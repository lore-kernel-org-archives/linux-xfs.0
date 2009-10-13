Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DEoMlL121142 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 09:50:22 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD3BD1D7DBC7
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 07:51:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NXCrX71QbhWVypaO for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 07:51:51 -0700 (PDT)
Message-ID: <4AD493FE.6000403@sandeen.net>
Date: Tue, 13 Oct 2009 09:51:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown
References: <CEBA5E865263FA4D8848D53D92E6A9AE0412EC23@DAKLAK.cybersoft-vn.com>
	<4AD32DED.4050402@sandeen.net>
	<CEBA5E865263FA4D8848D53D92E6A9AE0416AB0B@DAKLAK.cybersoft-vn.com>
In-Reply-To: <CEBA5E865263FA4D8848D53D92E6A9AE0416AB0B@DAKLAK.cybersoft-vn.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hieu Le Trung <hieult@Cybersoft-VN.com>
Cc: xfs@oss.sgi.com

Hieu Le Trung wrote:
> Eric Sandeen wrote:
>> Hieu Le Trung wrote:
>>> Hi,
>>>
>>> What may cause metadata becomes bad? I got xfs_force_shutdown with
> 0x2
>>> parameter.
>> Software bugs or hardware problems.  If you provide the actual kernel
>> message we can offer more info on what xfs saw and why it shut down.
> 
> I'm not sure which one is it but the issue is hard to reproduce. 
> I have following in the dmesg but I'm not sure it's the right one
>   <1>I/O error in filesystem ("sda2") meta-data dev sda2 block 0xf054f4
> ("xlog_iodone") error 5 buf count 32768

Were there IO errors from the storage before this?  i.e. did some lower
layer go bad.

>   <5>xfs_force_shutdown(sda2,0x2) called from line 956 of file
> fs/xfs/xfs_log.c.  Return address = 0x801288d8
> 
> Furthermore, the driver's write cache is
>   <5>SCSI device sda: drive cache: write back

That's fine...

> The xfs_logprint shows 'Bad log record header'
> xfs_logprint: /dev/sda2 contains a mounted and writable filesystem
>     data device: 0x802
>     log device: 0x802 daddr: 15735648 length: 20480
> 
> Header 0xa4 wanted 0xfeedbabe
> **********************************************************************
> * ERROR: header cycle=164         block=14634                        *
> **********************************************************************
> Bad log record header
> 
> So I wonder what may cause bad record header?

Probably the IO errors when attempting to write to the log ...

>>> How can I analyze the metadata dump file?
>> the metadump file is just the metadata skeleton of the filesystem; you
>> can mount it, repair it, point xfs_db at it to debug it, etc.
> 
> Is there any tutorials or guideline in using xfs_db to debug the issue?

xfs_db has a manpage, but I'm not sure the answer will be found by using
it.  It will only look at what data made it to the disk, and you had an
IO error.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
