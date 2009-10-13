Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DFEWGo123017 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 10:14:33 -0500
Received: from cybersoft-vn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B9F9132DCE4
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 08:16:00 -0700 (PDT)
Received: from cybersoft-vn.com (mail.cybersoft-vn.com [202.78.231.195]) by
	cuda.sgi.com with ESMTP id KAunK83XK2tI6jbs for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2009 08:16:00 -0700 (PDT)
Received: from DAKLAK.cybersoft.vn ([172.17.1.7])
	by temp.cybersoft-vn.com (cybersoft-vn.com) (MDaemon PRO v9.5.5)
	with ESMTP id md50000007603.msg
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 22:15:22 +0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: xfs_force_shutdown
Date: Tue, 13 Oct 2009 22:15:14 +0700
Message-ID: <CEBA5E865263FA4D8848D53D92E6A9AE0416AC5C@DAKLAK.cybersoft-vn.com>
In-Reply-To: <4AD493FE.6000403@sandeen.net>
References: <CEBA5E865263FA4D8848D53D92E6A9AE0412EC23@DAKLAK.cybersoft-vn.com>
	<4AD32DED.4050402@sandeen.net>
	<CEBA5E865263FA4D8848D53D92E6A9AE0416AB0B@DAKLAK.cybersoft-vn.com>
	<4AD493FE.6000403@sandeen.net>
From: "Hieu Le Trung" <hieult@Cybersoft-VN.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Hieu Le Trung wrote:
> > Eric Sandeen wrote:
> >> Hieu Le Trung wrote:
> >>> Hi,
> >>>
> >>> What may cause metadata becomes bad? I got xfs_force_shutdown with
> > 0x2
> >>> parameter.
> >> Software bugs or hardware problems.  If you provide the actual
kernel
> >> message we can offer more info on what xfs saw and why it shut
down.
> >
> > I'm not sure which one is it but the issue is hard to reproduce.
> > I have following in the dmesg but I'm not sure it's the right one
> >   <1>I/O error in filesystem ("sda2") meta-data dev sda2 block
> 0xf054f4
> > ("xlog_iodone") error 5 buf count 32768
> 
> Were there IO errors from the storage before this?  i.e. did some
lower
> layer go bad.

Before that is bunch of speed down request, maybe the real error has
been truncated
  <3>ata1.00: speed down requested but no transfer mode left
  <3>ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x10c00000 action 0x2
  <3>ata1.00: tag 0 cmd 0x30 Emask 0x10 stat 0x51 err 0x84 (ATA bus
error)


> >   <5>xfs_force_shutdown(sda2,0x2) called from line 956 of file
> > fs/xfs/xfs_log.c.  Return address = 0x801288d8
> >
> > Furthermore, the driver's write cache is
> >   <5>SCSI device sda: drive cache: write back
> 
> That's fine...

But in the XFS FAQ, they require to turn off the driver write cache
http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_problem_with_the_write_c
ache_on_journaled_filesystems.3F

> > The xfs_logprint shows 'Bad log record header'
> > xfs_logprint: /dev/sda2 contains a mounted and writable filesystem
> >     data device: 0x802
> >     log device: 0x802 daddr: 15735648 length: 20480
> >
> > Header 0xa4 wanted 0xfeedbabe
> >
**********************************************************************
> > * ERROR: header cycle=164         block=14634
*
> >
**********************************************************************
> > Bad log record header
> >
> > So I wonder what may cause bad record header?
> 
> Probably the IO errors when attempting to write to the log ...

What can I do with the log? Can I debug the issue using the log?

> >>> How can I analyze the metadata dump file?
> >> the metadump file is just the metadata skeleton of the filesystem;
> you
> >> can mount it, repair it, point xfs_db at it to debug it, etc.
> >
> > Is there any tutorials or guideline in using xfs_db to debug the
> issue?
> 
> xfs_db has a manpage, but I'm not sure the answer will be found by
using
> it.  It will only look at what data made it to the disk, and you had
an
> IO error.

Maybe I can use the log to find out what operation is failed and make
the log becomes bad then using xfs_db to analyze on the inode or block
to find out the filename. After that I may know what's going with my
code.
Is it possible? How to do that? How to find out the inode or block from
the log, and how to map the inode into filename using xfs_db?

-Hieu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
