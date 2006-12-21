Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 23:42:18 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBL7gBqw001825
	for <linux-xfs@oss.sgi.com>; Wed, 20 Dec 2006 23:42:13 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1GxIYJ-0004e7-0r
	for linux-xfs@oss.sgi.com; Thu, 21 Dec 2006 08:41:19 +0100
Received: from finn.gmane.org ([80.91.229.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Thu, 21 Dec 2006 08:41:19 +0100
Received: from mszpak by finn.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Thu, 21 Dec 2006 08:41:19 +0100
From: =?ISO-8859-2?Q?Marcin_Zaj=B1czkowski?= <mszpak@wp.pl>
Subject: Re: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
Date: Thu, 21 Dec 2006 08:42:05 +0100
Message-ID: <emddqo$bq7$1@sea.gmane.org>
References: <em84t3$b27$1@sea.gmane.org> <200612200059.LAA04335@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200612200059.LAA04335@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Barry Naujok wrote:
(...)
>> Btw, is it possible to mount XFS filesystem from the file created by 
>> xfs_copy?
>> If not, is it possible to restore file system "backuped" to file (by 
>> xfs_copy)? I read in the manual that the first parameter 
>> xfs_copy has to 
>> be device (not file). xfs_restore will work with that "dump"?
>  
> Yes, you can mount an XFS filesystem file using the "-o loop" mount
> option and specifying the file for the device.
> 
> Yes, you can xfs_copy from a file back to a device. From the man page:
> "The first (source) argument must be the pathname of the device or file
> containing the XFS filesystem.". 

In fact. I don't know why I missed it earlier.


Thanks
Marcin
