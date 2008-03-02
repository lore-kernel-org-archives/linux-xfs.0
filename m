Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Mar 2008 17:34:48 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m221YS1q006273
	for <xfs@oss.sgi.com>; Sat, 1 Mar 2008 17:34:29 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B216563A621
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2008 17:34:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 9tQsP0WqoHlYyBSr for <xfs@oss.sgi.com>; Sat, 01 Mar 2008 17:34:57 -0800 (PST)
Message-ID: <47CA043F.5070202@sandeen.net>
Date: Sat, 01 Mar 2008 19:34:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Kernel oops / XFS filesystem corruption
References: <47C93C32.40006@mathtm.de> <47C9C44D.8080400@sandeen.net> <47C9F5E9.70703@mathtm.de>
In-Reply-To: <47C9F5E9.70703@mathtm.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Thomas Müller wrote:
> Eric Sandeen wrote:
>> Did you also happen to save the xfs_repair output?
> No, but I made a complete copy of the file system before
> repairing it, so I can easily recreate it... :)

oh, like a dd image?  great.  You can use xfs_metadump to make a more
transportable image... xfs folks might even be able to use that to
recreate the oops.

-Eric
