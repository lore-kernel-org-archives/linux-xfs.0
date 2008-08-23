Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 19:09:24 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7N29KJC002724
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 19:09:22 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8D281A35FD1
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 19:10:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id PGGm51jvNMzshD8s for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 19:10:40 -0700 (PDT)
Message-ID: <48AF719F.8010903@sandeen.net>
Date: Fri, 22 Aug 2008 21:10:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_quota free
References: <48AF4DD1.5080603@nerp.net>
In-Reply-To: <48AF4DD1.5080603@nerp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dan <dan@nerp.net>
Cc: xfs@oss.sgi.com

Dan wrote:
> Hi,
> 
> Some time ago I needed to determine the free space on a real time 
> device.  Nate indicated to use xfs_quota free.  I've read the man pages 
> and tried many iterations of this command but I cannot get any results.
> 
> One potential problem is I'm uncertain of the folder or device to point 
> the command at.  My filesystem is mounted to /mnt, the rtdev is /dev/md0 
> and meta data is on /dev/sdb.  Basically it boils down to xfs_quota -c 
> 'free -r -h'  /mnt I think but I get the following error:
> 
> XFS_IOC_FSGEOMETRY_V1: Invalid argument
> 
> How do you use this?
> 
> Thanks,
> 
> Dan
> 
> 

Do you happen to have 32-bit userspace on a 64-bit kernel?

Could be an ioctl translation problem if so.

Otherwise maybe a quota-savvy person knows ;)

-Eric
