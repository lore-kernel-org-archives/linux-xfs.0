Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD6B57FA6
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 06:48:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BCE8A304048
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 04:48:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IiQ5ei2ehe8gEJ5M (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 04:48:19 -0700 (PDT)
Date: Fri, 29 Aug 2014 07:48:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Run out of inodes?
Message-ID: <20140829114806.GA17610@bfoster.bfoster>
References: <54005108.1020203@inserm.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54005108.1020203@inserm.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Samuel Granjeaud <samuel.granjeaud@inserm.fr>
Cc: xfs@oss.sgi.com

On Fri, Aug 29, 2014 at 12:08:08PM +0200, Samuel Granjeaud wrote:
> Hi,
> 
> Sorry if the answer is obvious, but I didn't find any clear answer after
> googling.
> 
> I have a XFS system of 18T over LVM. Recently, I could not create new files
> or directories.
> 
> # mkdir tempo
> mkdir: cannot create directory `tempo': No space left on device
> 
> After deleting a few files, this command runs successfully.
> 
> So I think that the system runs out of something, inodes I guess.
> 
> But the df diagnosis does not enlight it: only 1% used.
> 
> # df -ht xfs
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/vg1_backup-backup
>                        18T   12T  6.6T  63% /mnt/vg1_backup/backup
> # df -it xfs
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/mapper/vg1_backup-backup
>                      18874040320  530042 18873510278    1%
> /mnt/vg1_backup/backup
> 
> So what is wrong? How should I solve the problem?
> 
> I read about xfs_grow -m, but I am not sure if it could help.
> Of course, I rebooted the system before my trials.
> 

You should probably include more information for context:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

That aside... is inode64 enabled? Is imaxpct set to a non-default value?
Also, how is this filesystem used? I notice it's named as some kind of
backup volume.

Brian

> Best regards,
> Samuel
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
