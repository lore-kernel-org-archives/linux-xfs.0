Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 10:17:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1PIHINk007826
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 10:17:19 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADD6EEB9860
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 10:17:12 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ll5WOYKWBgQRJOfM for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 10:17:12 -0800 (PST)
Message-ID: <47C305BD.1060408@sandeen.net>
Date: Mon, 25 Feb 2008 12:15:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] filesystem corruption on xfs after 2.6.25-rc1 (bisected,
 powerpc related?)
References: <20080225112310.GA5516@soziologie.ch>
In-Reply-To: <20080225112310.GA5516@soziologie.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com, johannes@sipsolutions.net, linux-kernel Mailing List <linux-kernel@vger.kernel.org>

Gaudenz Steinlin wrote:
> Hi
> 
> Since upgrading to 2.6.25-rc1 I see filesystem corruption on my XFS
> filesystem. I can reproduce this by doing "git reset --hard v2.6.25-rc1"
> on a git checkout which is on some other revision. Git outputs strange
> error messages (like file xxx is a directory when xxx really is a file)
> and sometimes the filesystem "hangs" (I can no longer do any operations
> on it even from another shell). If I reboot with a working kernel and
> check the filesystem xfs_check reports many errors. I also see the
> problem when doing other (not related to git) operations on the
> filesystem. Git reset is just the easiest way to reproduce it.
> 
> I was able to track this corruption down to commit
> a69b176df246d59626e6a9c640b44c0921fa4566 ([XFS] Use the generic bitops
> rather than implementing them ourselves.) using git bisect.
> 
> Reverting edd319dc527733e61eec5bdc9ce20c94634b6482 ([XFS] Fix
> xfs_lowbit64) to avoid merge conflicts and the faulty commit on top of
> 2.6.25-rc3 fixes the problem.

If you're feeling motivated, maybe you can narrow it down to which of
the changes - xfs_highbit32, xfs_highbit64, xfs_lowbit32, or
xfs_lowbit64 - is causing the problem?  (or maybe they all are ...)

Or maybe someone looking at the commit can immediately see the
problem... but I can't :)

-Eric
