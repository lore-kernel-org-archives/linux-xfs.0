Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139E846423
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 22:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXBuk8Fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F7BC433C8;
	Mon, 27 Nov 2023 22:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701124492;
	bh=mC+/eW2OQP1sTi2UklGNAHhcRwa79MPDN/JxSOMNtZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aXBuk8Fc66MaSAcYLgVvMIcH9Y5lvnpG/js5ALw6i8fb9funWpxC+7fVDk0RejC46
	 LQRQD6L/38UNEDQ0D8Cs4Gyh3LB92+CIdIs1j60UxbCMzZo3VJ6fE9jPQk54OByOz2
	 BMHtyQHx45kfPSS81fwYP8vjfg/WsrU8h1OdDIzGP+C8UsRfY7jNzCcWArV12FVVK1
	 wd78RATfuvg0wftiGrAXlegt9k2SrYLfcY+yC6ujysu51P2eKgYiXmPsFcM+0sHK3a
	 061CAekN7HRw5kvB3cr5OtvVawxTLCqtPBbmW3WfXS1aZA7yk5ZxNEfh4rH89w5mUk
	 3PW/VIh5Vi8AQ==
Date: Mon, 27 Nov 2023 14:34:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <20231127223451.GG2766956@frogsfrogsfrogs>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926207.2768790.3907390620269991796.stgit@frogsfrogsfrogs>
 <ZWNEzd9aCQpKzpf9@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWNEzd9aCQpKzpf9@infradead.org>

On Sun, Nov 26, 2023 at 05:14:53AM -0800, Christoph Hellwig wrote:
> The data structure and support code looks fine to me, but I do have
> some nitpicky comments and questions:
> 
> > -	/* Fork format. */
> > -	unsigned int		if_format;
> > -
> > -	/* Number of records. */
> > -	unsigned int		if_extents;
> > +	/* Which fork is this btree being built for? */
> > +	int			if_whichfork;
> 
> The two removed fields seems to be unused even before this patch.
> Should they have been in a separate removal patch?

They should have been in the patch that moved if_{format,extents} into
xfs_inode_fork:

daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")

but I think it just got lost in the review of all that back in May 2020.
Since then the design has changed enough that I don't even think the
if_whichfork field is in use anywhere:

$ git grep if_whichfork
fs/xfs/libxfs/xfs_bmap_btree.c:664:     cur = xfs_bmbt_init_common(mp, NULL, ip, ifake->if_whichfork);
fs/xfs/libxfs/xfs_btree_staging.h:42:   int                     if_whichfork;
fs/xfs/scrub/newbt.c:117:       xnr->ifake.if_whichfork = whichfork;
fs/xfs/scrub/newbt.c:156:       xnr->ifake.if_whichfork = XFS_DATA_FORK;

$ cd ../xfsprogs/
$ git grep if_whichfork
db/bmap_inflate.c:367:  ifake.if_whichfork = XFS_DATA_FORK;
db/bmap_inflate.c:421:  ifake.if_whichfork = XFS_DATA_FORK;
libxfs/xfs_bmap_btree.c:662:    cur = xfs_bmbt_init_common(mp, NULL, ip, ifake->if_whichfork);
libxfs/xfs_btree_staging.h:42:  int                     if_whichfork;
repair/bulkload.c:38:   bkl->ifake.if_whichfork = whichfork;

So that can all go away.

> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index 876a2f41b0637..36c511f96b004 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -10,6 +10,7 @@
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> >  #include "xfs_btree.h"
> > +#include "xfs_btree_staging.h"
> >  #include "xfs_log_format.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_sb.h"
> 
> I also don't think all the #include churn belongs into this patch,
> as the only existing header touched by it is xfs_btree_staging.h,
> which means that anything that didn't need it before still won't
> need it with the changes.

Hmm yeah.  Not sure when this detritus started accumulating here. :(

> > +/*
> > + * Estimate proper slack values for a btree that's being reloaded.
> > + *
> > + * Under most circumstances, we'll take whatever default loading value the
> > + * btree bulk loading code calculates for us.  However, there are some
> > + * exceptions to this rule:
> > + *
> > + * (1) If someone turned one of the debug knobs.
> > + * (2) If this is a per-AG btree and the AG has less than ~9% space free.
> > + * (3) If this is an inode btree and the FS has less than ~9% space free.
> 
> Where does this ~9% number come from?  Obviously it is a low-space
> condition of some sort, but I wonder what are the criteria.  It would
> be nice to document that here, even if the answer is
> answer is "out of thin air".

It comes from xfs_repair:
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/repair/bulkload.c?h=for-next#n114

Before xfs_btree_staging.[ch] came along, it was open coded in
repair/phase5.c in a most unglorious fashion:
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/repair/phase5.c?h=v4.19.0#n1349

At that point the slack factors were arbitrary quantities per btree.
The rmapbt automatically left 10 slots free; everything else left zero.

That had a noticeable effect on performance straight after mounting
because touching /any/ btree would result in splits.  IIRC Dave and I
decided that repair should generate btree blocks that were 75% full
unless space was tight.  We defined tight as ~10% free to avoid repair
failures and settled on 3/32 to avoid div64.

IOWs, we mostly pulled it out of thin air. ;)

OFC the other weird thing is that originally I thought that online
repair would land sooner than would the retroport of xfs_repair to the
new btree bulk loading code.

> > + * Note that we actually use 3/32 for the comparison to avoid division.
> > + */
> > +static void
> 
> > +	/* No further changes if there's more than 3/32ths space left. */
> > +	if (free >= ((sz * 3) >> 5))
> > +		return;
> 
> Is this code really in the critical path that a division (or relying
> on the compiler to do the right thing) is out of question?  Because
> these shits by magic numbers are really annyoing to read (unlike
> say normal SECTOR_SHIFT or PAGE_SHIFT ones that are fairly easy to
> read).

Nah, it's not performance critical.  Collecting records and formatting
blocks is a much bigger strain on the system than a few divisions.  I'll
change it to div_u64(sz, 10).

Hmm now that I look at it, I've also noticed that even the lowspace
btree rebuild in userspace will leave two open slots per block.

--D
