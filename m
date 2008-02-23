Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 21:00:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1N4xpaF022900
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 20:59:56 -0800
Date: Sat, 23 Feb 2008 16:00:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW] User-space support for bad_features2 patch
Message-ID: <20080223050011.GG155259@sgi.com>
References: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t6w1h5f53jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

[ please inline patches so they are easy to quote for review. ]

On Fri, Feb 22, 2008 at 06:52:43PM +1100, Barry Naujok wrote:
> The attached patch fixes mkfs.xfs writing the bad features2 in the first  
> place (the change to xfs_sb.h does this).
> 
> Next xfs_db support printing of this superblock field and xfs_check can  
> report the bad_features2 field is set.
> 
> xfs_repair can correct the error in the same fashion that David Chinner's  
> mount code does it.

Actually, it doesn't:

        /*
+        * Check bad_features2, if set and features2 is zero, copy
+        * bad_features2 to features2 and zero bad_features2.
+        */
+       if (sb->sb_bad_features2 != 0) {
+               if (sb->sb_features2 == 0)
+                       sb->sb_features2 = sb->sb_bad_features2;

This simply copies the bad features over the features field if
the sb_features2 field is zero. This ignores the fact that we may
have set something into the sb_features2 field before detecting the
problem (e.g. attr2 can be turned on dynamically).  The patch I posted
OR'd the two fields together to ensure no feature bits were lost.
This needs to be done here as well.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
