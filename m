Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Mar 2008 20:25:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2T3P2v6004933
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 20:25:05 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C7B88B71C7
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 20:25:36 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id f6SVoiPOYUwmZW9X for <xfs@oss.sgi.com>; Fri, 28 Mar 2008 20:25:36 -0700 (PDT)
Message-ID: <47EDB6AD.4070604@sandeen.net>
Date: Fri, 28 Mar 2008 22:25:33 -0500
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
> ...

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
>   
I think there's a minor problem here that while this will update the
superblock with the proper features2 values, features2 has already been
checked, so mp->m_flags won't have, for example, the attr2 flags...

So attr2 will show up next time, but not on this mount.

This probably wouldn't normally matter, except in a weird corner case
I think I've found:

x86_64 set attr2 in bad_features2
bad_features2 was found, kernel & userspace pad the same
filesystem created attr2 attributes
hch's sb endianness annotation actually made bad_features2 *not* found
mount after that thinks there is no attr2
another corner case bug corrupts the fs, would be avoided if attr2 were not lost.

-Eric
