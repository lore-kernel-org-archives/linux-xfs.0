Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Mar 2008 18:30:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2U1TvW2018902
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 18:29:58 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 894BB8BE0C2
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 18:30:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id tGF1fsaADfsEYM3T for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 18:30:33 -0700 (PDT)
Message-ID: <47EEED18.9090206@sandeen.net>
Date: Sat, 29 Mar 2008 20:30:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] detect and correct bad features2 superblock field
References: <20080220054041.GM155407@sgi.com>
In-Reply-To: <20080220054041.GM155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> There is a bug in mkfs.xfs that can result in writing the features2
> field in the superblock to the wrong location. This only occurs
> on some architectures, typically those with 32 bit userspace and
> 64 bit kernels.
> 
> This patch detects the defect at mount time, logs a warning
> such as:
> 
> XFS: correcting sb_features alignment problem
> 
> in dmesg and corrects the problem so that everything is OK.
> it also blacklists the bad field in the superblock so it does
> not get used for something else later on.

...

>  	/*
> +	 * Check for a bad features2 field alignment. This happened on
> +	 * some platforms due to xfs_sb_t not being 64bit size aligned
> +	 * when sb_features was added and hence the compiler put it in
> +	 * the wrong place.
> +	 *
> +	 * If we detect a bad field, we or the set bits into the existing
> +	 * features2 field in case it has already been modified and we
> +	 * don't want to lose any features. Zero the bad one and mark
> +	 * the two fields as needing updates once the transaction subsystem
> +	 * is online.
> +	 */
> +	if (xfs_sb_has_bad_features2(sbp)) {
> +		cmn_err(CE_WARN,
> +			"XFS: correcting sb_features alignment problem");
> +		sbp->sb_features2 |= sbp->sb_bad_features2;
> +		sbp->sb_bad_features2 = 0;
> +		update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
> +	}

Hm, the other problem here may be that if we zero bad_features2, then
any older kernel will mount up as attr2... and run into the corruption
problem I found on F8...

Should we make features2 and bad_features2 match rather than zeroing
bad_features2?

-Eric
