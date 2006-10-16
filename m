Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 07:16:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GEGJaG021076
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 07:16:20 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D529DD134415
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 07:15:36 -0700 (PDT)
Message-ID: <45338FEA.3060709@sandeen.net>
Date: Mon, 16 Oct 2006 08:58:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: FS corruption and repair problem
References: <20061016082532.GA5574@jdc>
In-Reply-To: <20061016082532.GA5574@jdc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jason White <jasonjgw@internode.on.net>
Cc: xfs@oss.sgi.com

Jason White wrote:
> This is my desktop system, running kernel 2.6.17.11. Kernel 2.6.17 was
> previously installed, but I upgraded several weeks ago after I found out about
> the corruption bug in 2.6.17, which may or may not be related to the
> following.
> 
> The file system was shut down during a Debian package upgrade while trying to
> access apt-related files. I booted into an old 2.4 kernel on a separate
> partition and ran an old version of xfs_repair. The output is attached.
> Xfs_repair terminated abnormally (see the end of the output).

The original reason for the shutdown would probably be interesting here, that's 
missing information about the first problem you encountered.

But, from the repair output, it looks like corrupted directory data on disk, 
hard to say when/why it occurred.  Newer repair is always a good idea, but if 
the directory is badly corrupted then there's not a lot of magic to be done.

-Eric
