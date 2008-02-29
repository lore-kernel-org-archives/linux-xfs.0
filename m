Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 21:44:05 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1T5hvnh001338
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 21:43:58 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F131BEEE504
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 21:44:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id JkS1oCt3ZI2dBIDU for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 21:44:25 -0800 (PST)
Message-ID: <47C79BB8.4010005@sandeen.net>
Date: Thu, 28 Feb 2008 23:44:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW #3] bad_features2 support in user-space
References: <op.t69rt3bp3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t69rt3bp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> Ok, xfs_repair will leave bad_features2 in place just in case it is
> being run with an older kernel that expects features2 in the bad
> location. But, it will make sure the correct and bad features2 are
> consistent if bad_features2 in non-zero.
> 
> If bad_features2 is zero, it is left alone (eg. new mkfs or new
> kernel with fixes it during mount time).
> 
> This seems to be the best solution to the problem.

Will look at details later, but I agree w/ the general direction... I
think maybe the kernel should go this way too?  (i.e. kernel maybe
shouldn't be zeroing features2 either... but this is probably more
important for userspace than kernelspace; how often do you revert to an
older kernel...)

-Eric
