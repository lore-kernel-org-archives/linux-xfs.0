Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94FED7F59
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 08:06:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 837868F8040
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 06:06:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Je7RGxdJ12VfzOQO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2015 06:06:15 -0800 (PST)
Date: Fri, 23 Jan 2015 09:06:11 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Change sector size on existing partition
Message-ID: <20150123140611.GB2864@laptop.bfoster>
References: <54C246EC.90207@xtremenitro.org>
	<20150123133933.GA2864@laptop.bfoster>
	<54C250D3.9030706@xtremenitro.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54C250D3.9030706@xtremenitro.org>
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
To: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 23, 2015 at 08:46:59PM +0700, Dewangga Bachrul Alam wrote:
> Hi,
> 
> The device reported like this :
> 
> $ blockdev --getss --getpbsz --getiomin --getioopt /dev/dm-3
> 512
> 4096
> 4096
> 0
> 

What is dm-3? Is that a logical volume based on a volume group on top of
your physical array? It might be good to get the equivalent data for the
array device (md?) and at least one of the physical devices (sd?).

> Then, the sector size should be 512. Don't know why it can be 4096. :( I
> will try to backup them and reformat. Any suggestion for formating on
> raid-10 array? The device is 4 x 1TB drives.
> 

According to the above you have 4k physical sectors and 512b logical
sectors. IIUC, this means mkfs will use the physical size by default,
but you can specify and the device can handle down to 512 sectors.

>From skimming through the link posted earlier, it sounds like you have
an application that has a hardcoded dependency on 512b direct I/O
requirements (e.g., buffer alignment) rather than being configurable..?
Can you disable direct I/O and verify whether that works? Regardless, it
might be wise to test out this 512b sector configuration (perhaps with a
single or spare drive?) and verify this fixes the problem you're trying
to solve before reconfiguring everything.

Brian

> On 01/23/2015 08:39 PM, Brian Foster wrote:
> > On Fri, Jan 23, 2015 at 08:04:44PM +0700, Dewangga Bachrul Alam wrote:
> >> Hi,
> >>
> >> I'm new to XFS, I have RAID-10 array with 4 disk, when I check with
> >> xfs_info, the information print like this.
> >>
> >> $ xfs_info /var/lib/mysql
> >> meta-data=/dev/mapper/vg_catalystdb01-lv_database isize=256
> >> agcount=16, agsize=1600000 blks
> >>          =                       sectsz=4096  attr=2, projid32bit=0
> >> data     =                       bsize=4096   blocks=25600000, imaxpct=25
> >>          =                       sunit=0      swidth=0 blks
> >> naming   =version 2              bsize=4096   ascii-ci=0
> >> log      =internal               bsize=4096   blocks=12500, version=2
> >>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>
> >> Is it possible to change `sectsz` value to 512 without re-format it? Or
> >> any suggestion? I have issue with current sector size, my TokuDB
> >> engines[1] can't start because of this.
> >>
> > 
> > The only way to set things like sector size, block size, etc. is to
> > reformat. I believe the default sector size is dependent on the physical
> > device. You might want to report the following from your array device
> > and perhaps from some or all of the member devices:
> > 
> > blockdev --getss --getpbsz --getiomin --getioopt <device>
> > 
> > Brian
> > 
> >> [1] https://groups.google.com/forum/#!topic/tokudb-user/kvQFJLCmKwo
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
