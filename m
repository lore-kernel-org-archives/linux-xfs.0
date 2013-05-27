Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B60F729DF8
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 01:04:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77FC330404E
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 23:04:52 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id iSeyIlcJW4sR9Jtw for
	<xfs@oss.sgi.com>; Sun, 26 May 2013 23:04:51 -0700 (PDT)
Date: Mon, 27 May 2013 02:04:47 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1255895779.6805491.1369634687715.JavaMail.root@redhat.com>
In-Reply-To: <20130527053608.GS29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
Subject: Re: 3.9.3: Oops running xfstests
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

Hi,
> So automate the collection of all the static information.
Yes, that probably the best to do.
> > I will provide the information as far I knew for now.
> > - kernel version (uname -a): 3.9.3
> > - xfsprogs version (xfs_repair -V): Fedora-19 xfsprogs-3.1.10
> > - number of CPUs: 8
> 
> What type of CPUs? That's why we ask for /proc/cpuinfo....
Reproduced on both, Dual-Core AMD Opteron(tm) Processor 8218 and
Intel(R) Xeon(R) CPU E31220 @ 3.10GHz.
> 
> > - RAID layout (hardware and/or software):
> > Nothing special,
> 
> You say nothing special. I see:
> 
> > 06:21:51,812 INFO kernel:[   27.480775] mptsas: ioc0: attaching ssp device:
> > fw_channel 0, fw_id 0, phy 0, sas_addr 0x500000e0130ddbe2
> > 06:21:51,812 NOTICE kernel:[   27.539634] scsi 0:0:0:0: Direct-Access
> > IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5
> > 06:21:51,812 INFO kernel:[   27.592421] mptsas: ioc0: attaching ssp device:
> > fw_channel 0, fw_id 1, phy 1, sas_addr 0x500000e0130fa8f2
> > 06:21:51,812 NOTICE kernel:[   27.651334] scsi 0:0:1:0: Direct-Access
> > IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5
> 
> Hardware RAID of some kind. So, details, please. Indeed, googling
> for "IBM-ESXS MAY2073RC" turns up this lovely link:
> 
> http://webcache.googleusercontent.com/search?client=safari&rls=x86_64&q=cache:dD2J_ZuKGF4J:http://www.ibm.com/support/entry/portal/docdisplay%3Flndocid%3DMIGR-5078767%2BIBM-ESXS+MAY2073RC&oe=UTF-8&redir_esc=&hl=en&ct=clnk
> 
> 	"Corrects firmware defect that can cause data corruption"
> 
> http://www-947.ibm.com/support/entry/portal/docdisplay?lndocid=MIGR-5092677
> 
> 	"Additional Information
> 	A subset of optional IBM Options hard drive shipped between April
> 	2010 and January 2013 running firmware levels A3C2, A3C0, A3BE, or
> 	A3B8 may be exposed to a possible undetected data loss or data error
> 	during a proximal write."
> 
> 
> That might be relevant to a filesystem corruption problem, yes?
> Start to understand why we ask for basic information about your
> hardware now?
OK, and this was also reproduced on,
[    9.778658] hpsa 0000:04:00.0: hpsa0: <0x323a> at IRQ 43 using DAC 
[    9.796557] [TTM] Zone  kernel: Available graphics memory: 4066866 kiB 
[    9.796558] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB 
[    9.796558] [TTM] Initializing pool allocator 
[    9.796594] [TTM] Initializing DMA pool allocator 
[    9.930529] scsi0 : ata_piix 
[    9.934804] scsi1 : ata_piix 
[    9.937735]SATA max UDMA/133 cmd 0x1400 ctl 0x1408 bmdma 0x1420 irq 17 
[   10.143857] fbcon: mgadrmfb (fb0) is primary device 
[   10.143943] ata2: SATA max UDMA/133 cmd 0x1410 ctl 0x1418 bmdma 0x1428 irq 17 
[   10.146870] scsi2 : hpsa 
[   10.146900] ata_piix 0000:00:1f.5: MAP [ 
[   10.146901]  P0 -- P1 -- ] 
[   10.149376] scsi3 : ata_piix 
[   10.151329] scsi4 : ata_piix 
[   10.151702] ata3: SATA max UDMA/133 cmd 0x1440 ctl 0x1448 bmdma 0x1460 irq 17 
[   10.151705] ata4: SATA max UDMA/133 cmd 0x1450 ctl 0x1458 bmdma 0x1468 irq 17 
[   10.152789] hpsa 0000:04:00.0: RAID              device c2b3t0l0 added. 
[   10.152790] hpsa 0000:04:00.0: Direct-Access     device c2b0t0l0 added. 
[   10.153206] scsi 2:3:0:0: RAID              HP       P410             5.14 PQ: 0 ANSI: 5 
[   10.153563] scsi 2:0:0:0: Direct-Access     HP       LOGICAL VOLUME   5.14 PQ: 0 ANSI: 5 
[   10.213887] [drm] mga base 0 
[   10.285126] Console: switching to colour frame buffer device 128x48 
[   10.387399] mgag200 0000:01:00.1: fb0: mgadrmfb frame buffer device 
[   10.387399] mgag200 0000:01:00.1: registered panic notifier 
[   10.387441] [drm] Initialized mgag200 1.0.0 20110418 for 0000:01:00.1 on minor 0 
[   10.469431] ata3: SATA link down (SStatus 0 SControl 300) 
[   10.508564] ata4: SATA link down (SStatus 0 SControl 300) 
[   10.765662] ata2.00: SATA link down (SStatus 0 SControl 300) 
[   10.793575] ata2.01: SATA link down (SStatus 0 SControl 300) 
[   10.833455] ata1.00: SATA link down (SStatus 0 SControl 300) 
[   10.861780] ata1.01: SATA link down (SStatus 0 SControl 300) 
[   10.900174] sd 2:0:0:0: [sda] 143305920 512-byte logical blocks: (73.3 GB/68.3 GiB) 
[   10.940769] sd 2:0:0:0: [sda] Write Protect is off 
[   10.965161] sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA 
[   11.013492]  sda: sda1 sda2 
[   11.029787] sd 2:0:0:0: [sda] Attached SCSI disk 
[   11.288535] bio: create slab <bio-1> at 1 
> 
> > - LVM configuration: nothing special. Just Fedora-19 autopart. The below
> > information
> >   from the installation time. Later, everything been formatted to XFS.
> 
> Manually?
Partitioning and formatting during the installation time using kickstart files.
> So, can you reproduce this problem on a clean, *pristine* system
> that hasn't been used for destructive testing for 24 hours prior to
> running xfstests?
Yes, I can try that and let you know if I can.

Regards,
CAI Qian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
