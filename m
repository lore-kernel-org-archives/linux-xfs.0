Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 903847F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 22:14:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 82721304048
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 20:14:04 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4dvpvvFKvxVyeMJz for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 20:14:02 -0800 (PST)
Date: Tue, 25 Feb 2014 15:13:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
	for fallocate
Message-ID: <20140225041346.GA29907@dastard>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
	<20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Tue, Feb 25, 2014 at 02:16:01PM +1100, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Mon, 24 Feb 2014 11:57:10 +1100 Dave Chinner <david@fromorbit.com> wrote:
> >
> > > Namjae Jeon (10):
> > >   fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
> > >   xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> > 
> > I've pushed these to the following branch:
> > 
> > 	git://oss.sgi.com/xfs/xfs.git xfs-collapse-range
> > 
> > And so they'll be in tomorrow's linux-next tree.
> > 
> > >   ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> > 
> > I've left this one alone for the ext4 guys to sort out.
> 
> So presumably that xfs tree branch is now completely stable and so Ted
> could just merge that branch into the ext4 tree as well and put the ext4
> part on top of that in his tree.

Well, for some definition of stable. Right now it's just a topic
branch that is merged into the for-next branch, so in theory it is
still just a set of pending changes in a branch in a repo that has
been pushed to linux-next for testing.

That said, I don't see that branch changing unless we find bugs in
the code or a problem with the API needs fixing, at which point I
would add more commits to it and rebase the for-next branch that you
are pulling into the linux-next tree.

Realistically, I'm waiting for Lukas to repost his other pending
fallocate changes (the zero range changes) so I can pull the VFS and
XFS bits of that into the XFS tree and I can test them together
before I'll call the xfs-collapse-range stable and ready to be
merged into some other tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
