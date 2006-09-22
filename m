Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Sep 2006 19:24:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8M2OnaG011981
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 19:24:49 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F023FD10E75E
	for <xfs@oss.sgi.com>; Thu, 21 Sep 2006 19:24:10 -0700 (PDT)
Message-ID: <4513493F.8090005@sandeen.net>
Date: Thu, 21 Sep 2006 21:23:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH -mm] rescue large xfs preferred iosize from the inode
 diet patch
References: <45131334.6050803@sandeen.net> <45134472.7080002@sgi.com>
In-Reply-To: <45134472.7080002@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Timothy Shimmin wrote:

> Looked at your patch and then at our xfs code in the tree and
> the existing code is different than what yours is based on.
> I then noticed in the logs Nathan has actually made changes for this:
> 
> ----------------------------
> revision 1.254
> date: 2006/07/17 10:46:05;  author: nathans;  state: Exp;  lines: +20 -5
> modid: xfs-linux-melb:xfs-kern:26565a
> Update XFS for i_blksize removal from generic inode structure
> ----------------------------
> I even reviewed the change (and I don't remember it - getting old).
> 
> I looked at the mods scheduled for 2.6.19 and this is one of them.
> 
> So the fix for this is coming soon (and the fix is different from the
> one above).


Ah, ok, thanks guys.  Should have checked CVS I guess.

-Eric
