Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 09:41:37 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1MHfWlE008989
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 09:41:33 -0800
Message-ID: <47BF0963.6020809@sandeen.net>
Date: Fri, 22 Feb 2008 11:41:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] User-space support for bad_features2 patch
References: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> The attached patch fixes mkfs.xfs writing the bad features2 in the first  
> place (the change to xfs_sb.h does this).
> 
> Next xfs_db support printing of this superblock field and xfs_check can  
> report the bad_features2 field is set.
> 
> xfs_repair can correct the error in the same fashion that David Chinner's  
> mount code does it.
> 
> This patch applies to the lazy-count xfs_repair conversion code that I  
> posted a short time before this patch.
> 
> Barry.
> 
+	 * Check bad_features2, if set and features2 is zero, copy
+	 * bad_features2 to features2 and zero bad_features2.
+	 */
+	if (sb->sb_bad_features2 != 0) {
+		if (sb->sb_features2 == 0)
+			sb->sb_features2 = sb->sb_bad_features2;
+		sb->sb_bad_features2 = 0;
+		primary_sb_modified = 1;
+		do_warn(_("superblock's features2 field is in the wrong "
+			"location, correcting\n"));
+	}

My only thought here is that if you repair it, then use an older kernel
w/o the fix, suddenly your fs behavior changes, whereas before you often
got lucky, and both userspace & kernelspace swapped the same way, and
you found the bits you were looking for out of luck :)  (same goes for
the recent kernel fix too, I guess)

Should we flag the bad_features2 as "already copied to features2" but
otherwise leave it?  Hmm I guess that would look like an unsupported
feature flag to old kernels, wouldn't it.  Urgh.

-Eric
