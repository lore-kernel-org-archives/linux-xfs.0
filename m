Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 19:20:41 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m163KVLw015292
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 19:20:36 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97433D9FF63
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 19:20:54 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id FyBhIjGBtah3Atfn for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 19:20:54 -0800 (PST)
Message-ID: <47A92793.8040006@sandeen.net>
Date: Tue, 05 Feb 2008 21:20:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: %inodes question
References: <47A90A38.3050206@tlinx.org>
In-Reply-To: <47A90A38.3050206@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Linda A. Walsh" <law@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> Does this really matter much anymore?  It defaults to 25%, but
> on a 1T disk, that's 250G "reserved"(?) for inodes?  Even 1%
> still gives you 10G of inodes.

Not any more.  xfsprogs 2.9.5 will put it at 5% for a 1T fs.

And it's not reserved per se; it's just the maximum.  Inodes are
allocated dynamically up to that point.

-Eric
