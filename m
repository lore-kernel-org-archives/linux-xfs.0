Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 20:45:29 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m254jBCp020692
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 20:45:13 -0800
Date: Tue, 4 Mar 2008 23:45:39 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [REVIEW #4] bad_features2 support in userspace
Message-ID: <20080305044539.GC19104@josefsipek.net>
References: <op.t7i0f5123jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t7i0f5123jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 05, 2008 at 03:37:07PM +1100, Barry Naujok wrote:
> Due to the issue of mounting filesystem with older kernels and
> potentially reading sb_features2 from the wrong location. It
> seems the best course of action is to always make sb_features2
> and sb_bad_features2 the same. This is pretty important as
> new bits in this are supposed to stop older kernels from
> mounting filesystems with unsupported features.
>
> If sb_bad_features2 is zero, and the old kernel tries to read
> sb_features2 from this location during mount, it will succeed
> as it will read zero.
>
> So, this patch changes mkfs.xfs to set sb_bad_features2 to
> the same as sb_features2, xfs_check and xfs_repair now also
> makes sure they are the same.

Idea: good
Implementation: I didn't see anything wrong.

Josef 'Jeff' Sipek.

P.S. Any reason why you inline the patch _and_ attach?

-- 
I think there is a world market for maybe five computers.
		- Thomas Watson, chairman of IBM, 1943.
