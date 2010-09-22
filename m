Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MCAnU2063067 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 07:10:50 -0500
Received: from pirx.askja.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A086183B930
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 05:11:42 -0700 (PDT)
Received: from pirx.askja.de (pirx.askja.de [83.137.103.148]) by cuda.sgi.com
	with ESMTP id dY2VAPfdDHjQ9ELB for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 05:11:42 -0700 (PDT)
Date: Wed, 22 Sep 2010 14:11:23 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: XFS internal error xfs_da_do_buf(2)
Message-ID: <20100922121123.GB23326@pirx.askja.de>
References: <20100922083226.GF2614@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922083226.GF2614@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner schrieb:
> On Wed, Sep 22, 2010 at 09:26:53AM +0200, Ralf Gross wrote:
> > Hi,
> > 
> > we've a fileserver withe the following setup:
> > 
> > Debian Lenny AMD64, 2.6.32 bpo Kernel
> > 
> > Infortrend RAID with BBU -> DRBD -> LVM -> XFS
> > 
> > This system is running since beginning of August and replaced some
> > older hardware.
> > 
> > Last week xfs began to print some warnings to syslog. The day before a DRBD
> > verify ended without showing differences between the 2 cluster nodes.
> 
> That doesn't mean there is no corruption - it means the corruption
> got propagted to both nodes.


I just thought that the verify could have triggered the problem. But
given the 31 hours between the end of the verify and the first call
trace this may be unlikely.


> ....
> 
> > This seems not to happen all the time, the server was running 5 weeks without
> > these messages. And there were some full backups running during this
> > time which read every file on the fs.
> 
> Which implies that it is recent. Knowing when the directory was last
> modified and what was done to it would be useful, but I know you
> won't have that information....


yes

 
> > Any hints what to look for or what to do to notice this corruption as soon as possible?
> 
> You won't find an error on disk without scrubbing of some kind.
> In the case of filesystem metadata, you need to read all the
> metadata and validity check it to find random corruptions. The best
> you can do is traverse and stat every file regularly...


Disk scrubbing is activated on the infortrend RAIDs (2 week schedule).
With 'stat every file regularly' you mean check the md5sum?

 
> > Sep 13 12:30:30 VU0EM003 kernel: [2834063.439771] block drbd0: conn( Connected -> VerifyS ) 
> > Sep 13 12:30:30 VU0EM003 kernel: [2834063.439803] block drbd0: Starting Online Verify from sector 0
> > Sep 15 03:06:59 VU0EM003 kernel: [2972785.494729] block drbd0: Online verify  done (total 138989 sec; paused 0 sec; 33716 K/sec)
> > Sep 15 03:06:59 VU0EM003 kernel: [2972785.494794] block drbd0: conn( VerifyS -> Connected ) 
> > 
> > Sep 16 12:18:16 VU0EM003 kernel: [3092032.035881] ffff8803e65c8000: 49 4e 00 00 02 02 00 00 00 00 14 1b 00 00 04 26  IN.............&
> > Sep 16 12:18:16 VU0EM003 kernel: [3092032.035936] Filesystem "dm-2": XFS internal error xfs_da_do_buf(2) at line 2112 of file /tmp/buildd/linux-2.6-2.6.32/debian/build/source_amd64_none/fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa02b0a52
> 
> So it found an inode cluster rather than a directory block. Implies
> a bad block pointer. Without the repair output, there's no way of
> knowing what it might have been incorrect (either the directory
> btree block pointers or the block contents), so there's not much
> that can be guessed from this...


I'll post an update if it happens again...

Thanks, Ralf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
