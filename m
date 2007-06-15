Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 11:13:57 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FIDrWt029502
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2007 11:13:54 -0700
Received: from localhost (dslb-084-056-065-071.pools.arcor-ip.net [84.56.65.71])
	by mail.lichtvoll.de (Postfix) with ESMTP id 5BF525AD56
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2007 20:13:54 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_fsr - problem with open files possible?
Date: Fri, 15 Jun 2007 20:13:52 +0200
References: <200706151804.43067.Martin@lichtvoll.de> <4672C531.9020802@sandeen.net> (sfid-20070615_201058_223491_4316861A)
In-Reply-To: <4672C531.9020802@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152013.52836.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Freitag 15 Juni 2007 schrieb Eric Sandeen:

> > I can try to reproduce the problem. Would be handy tough to have an
> > xfs_fsr that can be limited only to operate on a certain directory
> > and its files and sub directories. This way I could create a new
> > mailfolder, copy some mails in there, have it opened so that KMail
> > accesses the index file and let xfs_fsr only run on this mailfolder.
>
> From the man page:
>
>  Files marked as no-defrag will be skipped. The xfs_io(8) chattr
> command with the f attribute can be used to set or clear this flag. 
> Files  and directories created in a directory with the no-defrag flag
> will inherit the attribute.
>
> so you can flag your mail directory or index files as no-defrag if you
> like.  (I know this is the converse of what you wanted... but maybe
> helpful)

Hello Eric!

Well also from the man page as I just found out after sending my mail:

"xfs_fsr  can  be  called with one or more arguments naming filesystems 
(block device name), and files to reorganize.  In this mode xfs_fsr does 
not read or write /var/tmp/.fsrlast_xfs nor does it run for a fixed time 
interval.  It makes  one pass through each specified regular file and all 
regular files in each specified filesystem.  A command line name 
referring to a symbolic link (except to a file system device), FIFO, or 
UNIX domain socket generates a warning  message,  but is otherwise 
ignored.  While traversing the filesystem these types of files are 
silently skipped."

So maybe something along the lines of:

xfs_fsr ~/Mail/.trash.index

while it is open by KMail should be enough. I think I will give this a try 
soon.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
