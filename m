Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Jul 2007 11:10:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6BIA9bm029547
	for <xfs@oss.sgi.com>; Wed, 11 Jul 2007 11:10:11 -0700
Message-ID: <46951C0A.4080505@sandeen.net>
Date: Wed, 11 Jul 2007 13:06:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: zero existing secondary superblocks with mkfs.xfs -f
References: <op.tvamambx3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tvamambx3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> The attached patch zeros all the secondary superblocks if
> overwriting an existing XFS filesystem.
> 
> This allows xfs_repair to detect the correct secondary block
> if the primary is destroyed (like XFS QA test 030).

Seems good to me (after filtering out all of the quilt-induced
whitespace changes ;-) )

+	/*
+	 * perform same basic superblock validation to make sure we
+	 * actually zero secondary blocks
+	 */
+	if (sb.sb_magicnum != XFS_SB_MAGIC || sb.sb_blocksize == 0)
+		goto done;

Is there any chance we'd be here if the first test weren't already true?
 *shrug* harmless though I guess.

If something goes wrong and the old found SB is full of junk, this is
non-fatal, right.

Out of curiosity, why not just call verify_sb for the sanity checks
instead of recreating a subset of them in zero_old_xfs_structures?

Thanks,

-Eric
