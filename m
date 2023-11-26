Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xse5UYJQ"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0A8DD
	for <linux-xfs@vger.kernel.org>; Sun, 26 Nov 2023 05:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1QM3z+SJ7JgGkHSAOCSwpKA5FACiukRZ6iqb1XGbg4s=; b=Xse5UYJQMdjed52uqd1yHlPUNJ
	lRa+bjNguG6hU5bM/8gIx9PWCnLRzY8VQuKLrh03PhCoXno1HS1aRsN23no6EN+CyUCcfeTSJLnNU
	uIvcrLHRlw0oLI012TPn/lNrIk4Scji9cim8uP5tWVRgMp1wJL1Y18yY4GYt8qJ+UK023m5EUUC8+
	kDdE86u0iEbM7AGAL3JfzCl9GSViWA2hs07TZCXnn7mxPI3a1Uo7AFoDQFflYqTsbJrq4aFdRMdZC
	EWZqXqEqCho5wPWaJT/gQRcSXx1t4OOCl2/H2DObK+afdZ9nyTR7ahWyRtGHd+HOV3Hc+gy9oZfPI
	Kf7+8Wcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7EyL-00BKiA-2W;
	Sun, 26 Nov 2023 13:14:53 +0000
Date: Sun, 26 Nov 2023 05:14:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <ZWNEzd9aCQpKzpf9@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926207.2768790.3907390620269991796.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926207.2768790.3907390620269991796.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The data structure and support code looks fine to me, but I do have
some nitpicky comments and questions:

> -	/* Fork format. */
> -	unsigned int		if_format;
> -
> -	/* Number of records. */
> -	unsigned int		if_extents;
> +	/* Which fork is this btree being built for? */
> +	int			if_whichfork;

The two removed fields seems to be unused even before this patch.
Should they have been in a separate removal patch?

> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 876a2f41b0637..36c511f96b004 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -10,6 +10,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> +#include "xfs_btree_staging.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"

I also don't think all the #include churn belongs into this patch,
as the only existing header touched by it is xfs_btree_staging.h,
which means that anything that didn't need it before still won't
need it with the changes.

> +/*
> + * Estimate proper slack values for a btree that's being reloaded.
> + *
> + * Under most circumstances, we'll take whatever default loading value the
> + * btree bulk loading code calculates for us.  However, there are some
> + * exceptions to this rule:
> + *
> + * (1) If someone turned one of the debug knobs.
> + * (2) If this is a per-AG btree and the AG has less than ~9% space free.
> + * (3) If this is an inode btree and the FS has less than ~9% space free.

Where does this ~9% number come from?  Obviously it is a low-space
condition of some sort, but I wonder what are the criteria.  It would
be nice to document that here, even if the answer is
answer is "out of thin air".

> + * Note that we actually use 3/32 for the comparison to avoid division.
> + */
> +static void

> +	/* No further changes if there's more than 3/32ths space left. */
> +	if (free >= ((sz * 3) >> 5))
> +		return;

Is this code really in the critical path that a division (or relying
on the compiler to do the right thing) is out of question?  Because
these shits by magic numbers are really annyoing to read (unlike
say normal SECTOR_SHIFT or PAGE_SHIFT ones that are fairly easy to
read).
