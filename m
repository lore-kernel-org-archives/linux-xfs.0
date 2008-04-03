Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 17:40:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m330dpHt029476
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 17:39:53 -0700
Date: Wed, 2 Apr 2008 20:35:39 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 2/7] XFS: ASCII case-insensitive support
Message-ID: <20080403003539.GC5211@josefsipek.net>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062708.071715758@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402062708.071715758@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Wed, Apr 02, 2008 at 04:25:10PM +1000, Barry Naujok wrote:
> Implement ASCII case-insensitive support. It's primary purpose 
> is for supporting existing filesystems that already use this
> case-insensitive mode migrated from IRIX. But, if you only need
> ASCII-only case-insensitive support (ie. English only) and will
> never use another language, then this mode is perfectly adequate.
> 
> ASCII-CI is implemented by generating hashes based on lower-case
> letters and doing lower-case compares. It implements a new
> xfs_nameops vector for doing the hashes and comparisons for
> all filename operations.
> 
> It also overrides the Linux dentry cache operations with its
> own hash and compare functions (the same as used in the xfs_nameops
> vector).
> 
> To create a filesystem with this CI mode, use:
> # mkfs.xfs -n version=ci <device>
 
Since you have to mkfs anyway, why not just use the unicode mkfs option, and
the ci mount option. Then, you can just drop this patch :)

Josef 'Jeff' Sipek.

-- 
Ready; T=0.01/0.01 20:32:39
