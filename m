Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 21:35:34 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1T5ZKGq032748
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 21:35:23 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CB4062D57A
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 21:35:47 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id FBcfBLrDX7IzeB5X for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 21:35:47 -0800 (PST)
Subject: Re: [REVIEW #3] bad_features2 support in user-space
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <op.t69rt3bp3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.t69rt3bp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 16:33:58 +1100
Message-Id: <1204263238.13569.122.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, 2008-02-29 at 15:52 +1100, Barry Naujok wrote:
> Ok, xfs_repair will leave bad_features2 in place just in case it is
> being run with an older kernel that expects features2 in the bad
> location. But, it will make sure the correct and bad features2 are
> consistent if bad_features2 in non-zero.
> 
> If bad_features2 is zero, it is left alone (eg. new mkfs or new
> kernel with fixes it during mount time).
> 
> This seems to be the best solution to the problem.
> 

*nod* - looks good to me...

> +	if (sb->sb_bad_features2 != 0 &&
> +			sb->sb_bad_features2 != sb->sb_features2) {
> +		sb->sb_features2 |= sb->sb_bad_features2;
> +		sb->sb_bad_features2 = sb->sb_features2;
> +		primary_sb_modified = 1;

No endian issues here are there?  It looks OK, but you tested it right?
(looked at what a little endian system writes ondisk?)

cheers.

-- 
Nathan
