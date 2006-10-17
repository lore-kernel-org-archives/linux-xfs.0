Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 22:36:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9H5ZxaG001538
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 22:36:00 -0700
Received: from home.jason.bur.st (ppp77-57.lns1.mel3.internode.on.net [59.167.77.57])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C418B4AEBCC
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 22:35:16 -0700 (PDT)
Date: Tue, 17 Oct 2006 15:35:14 +1000
From: Jason White <jasonjgw@internode.on.net>
Subject: Re: FS corruption and repair problem
Message-ID: <20061017053514.GA5095@jdc>
References: <20061016082532.GA5574@jdc> <45338FEA.3060709@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45338FEA.3060709@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Oct 16, 2006 at 08:58:02AM -0500, Eric Sandeen wrote:
 
> The original reason for the shutdown would probably be interesting here, that's 
> missing information about the first problem you encountered.

Unfortunately, yes. The first I knew about it came in the form of i/o errors
and processes terminating with error 990.
> 
> But, from the repair output, it looks like corrupted directory data on disk, 
> hard to say when/why it occurred.  Newer repair is always a good idea, but if 
> the directory is badly corrupted then there's not a lot of magic to be done.

The newer repair ran to completion and corrected more errors. 

If the corruption recurs, the next step will be to reinstall everything.
Fortunately, I have multiple backups of important files, though one of them
was to an XFS file system created under kernel 2.6.17, which had minor
directory corruption that was fixed by xfs_repair. After mounting that drive
under 2.6.18, I created an entirely new backup and compared it with the old;
the only files which had changed were those which I knew to have been updated
since the previous backup.

After unmounting the backup fs I ran xfs_check, which reported no problems.
Thus I suspect that in the case of the backup drive, the FS corruption was due
to the 2.6.17 bug, since copying gigabytes of files to it failed to reproduce
the problem, and all seems fine under 2.6.18.

I am still pleased with XFS as I have been using it since 2001, and the only
problems have been due to bugs that were quickly fixed by the developers, and
most of these happened prior to the integration of XFS into the mainline.
