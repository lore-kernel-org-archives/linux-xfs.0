Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Sep 2008 19:59:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C2xA6H011079
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 19:59:10 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 785148D3A0B
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 20:00:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id gmh5aDLsy2SRINRy for <xfs@oss.sgi.com>; Thu, 11 Sep 2008 20:00:39 -0700 (PDT)
Message-ID: <48C9DB57.10909@sandeen.net>
Date: Thu, 11 Sep 2008 22:00:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs, ubuntu, & xen
References: <BLU141-W21A745812EB94C128504C680510@phx.gbl>
In-Reply-To: <BLU141-W21A745812EB94C128504C680510@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Lawry <a_lawry@hotmail.com>
Cc: xfs@oss.sgi.com

Andrew Lawry wrote:
> 
> Hi,
> 
> I am setting up a new Xen installation using XFS as the file system. On our test
> machine we have been having some problems with a domU crashing and some
> data loss on the domU (on recovery of the file system at the next boot
> some files have become truncated.

Why is the domU crashing; does it look at all related to these problems,
or is it something different?

Does the filesystem image check out ok with xfs_repair when this
happens?  If not, what does it find?

Which files are truncated, system files or files that were being written
at the time of the crash?  And just to be clear, what exactly do you
mean by truncated; that the data is correct up to EOF, but the file is
smaller than you expect?  Is this more than simply buffered writes
getting lost, which is to be expected?

-Eric

> Our setup:
> 
> Dom0 and
> domUs are Ubuntu 8.04 64 bit  Server edition. The domUs use tap file
> based backends. The file system holding the image files is XFS and the
> filesystem in each domU is also XFS.
> 
> We are using xen 3.2 packaged with ubuntu.
> 
> I
> have read on this mailing list and on google that xen and XFS do not
> work well together and some patches have been produced. Has this issue been addressed? Would those patches be in the stable release and have found their way into Ubuntu packages?
> 
> Thanks for your help.
> 
> Andrew
