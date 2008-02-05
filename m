Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 06:56:17 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m15EuCqB001392
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 06:56:15 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D1905A0487
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 06:56:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id zdsWFWoL3N6y2KJx for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 06:56:34 -0800 (PST)
Message-ID: <47A87901.7010508@sandeen.net>
Date: Tue, 05 Feb 2008 08:56:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Linux mkfs.xfs parameters for large files
References: <b0a4f3350802050342i48525c02we95a2a4e89327688@mail.gmail.com>
In-Reply-To: <b0a4f3350802050342i48525c02we95a2a4e89327688@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jamie Tufnell <diesql@googlemail.com>
Cc: xfs@oss.sgi.com

Jamie Tufnell wrote:
> Hi,
> 
> I've done some research into how to best-prepare our Linux (2.6.18)
> XFS filesystem for a read-heavy workload of mostly large files (files
> between 50MB and 500MB) and I have some questions on block-sizes /
> extents.
> 
> My experience with other filesystems leads me to believe I should
> experiment with large block-sizes for this application.  In trying to
> do so, I found that the Linux XFS implementation forces the block size
> to not exceed the page size -- 4kB -- which seems a bit small in this
> case.  At first, I thought this was *really* bad news for me but I've
> since read some posts and the impression I'm getting is it's not that
> big of a deal?

In your careful benchmarking & testing, which aspects of the performance
you've found does not meet your needs or expectations?  That's always a
good place to start.

-Eric
