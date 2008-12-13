Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBDJ3shA016102 for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 13:03:55 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sat, 13 Dec 2008 12:01:38 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C0300383E@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: <200812131826.25280.Martin@lichtvoll.de>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<493A9BE7.3090001@sandeen.net>
	<alpine.DEB.1.10.0812130724340.18746@p34.internal.lan>
	(sfid-20081213_171213_704814_AA9856DD)
	<200812131826.25280.Martin@lichtvoll.de>
From: "David Lethe" <david@santools.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Martin Steigerwald <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, Eric Sandeen <sandeen@sandeen.net>



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Martin Steigerwald
> Sent: Saturday, December 13, 2008 11:26 AM
> To: linux-xfs@oss.sgi.com
> Cc: Justin Piszcz; Eric Sandeen; linux-raid@vger.kernel.org; Alan
> Piszcz; xfs@oss.sgi.com
> Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers
> [xfs]
> 
> Am Samstag 13 Dezember 2008 schrieb Justin Piszcz:
> > On Sat, 6 Dec 2008, Eric Sandeen wrote:
> > > Justin Piszcz wrote:
> > >> Someone should write a document with XFS and barrier support, if
I
> > >> recall, in the past, they never worked right on raid1 or raid5
> > >> devices, but it appears now they they work on RAID1, which slows
> > >> down performance ~12 times!!
> > >>
> > >> There is some mention of it here:
> > >> http://oss.sgi.com/projects/xfs/faq.html#wcache_persistent
> > >>
> > >> But basically I believe it should be noted in the kernel logs,
FAQ
> > >> or somewhere because just through the process of upgrading the
> > >> kernel, not changing fstab or any other part of the system,
> > >> performance can drop 12x just because the newer kernels implement
> > >> barriers.
> > >
> > > Perhaps:
> > >
> > > printk(KERN_ALERT "XFS is now looking after your metadata very
> > > carefully; if you prefer the old, fast, dangerous way, mount with
-
> o
> > > nobarrier\n");
> > >
> > > :)
> > >
> > > Really, this just gets xfs on md raid1 in line with how it behaves
> > > on most other devices.
> > >
> > > But I agree, some documentation/education is probably in order; if
> > > you choose to disable write caches or you have faith in the
battery
> > > backup of your write cache, turning off barriers would be a good
> > > idea.  Justin, it might be interesting to do some tests with:
> > >
> > > barrier,   write cache enabled
> > > nobarrier, write cache enabled
> > > nobarrier, write cache disabled
> > >
> > > a 12x hit does hurt though...  If you're really motivated, try the
> > > same scenarios on ext3 and ext4 to see what the barrier hit is on
> > > those as well.
> > >
> > > -Eric
> >
> > No, I have not forgotten about this I have just been quite busy, I
> > will test this now, as before, I did not use sync because I was in a
> > hurry and did not have the ability to test, I am using a different
> > machine/hw type but the setup is the same, md/raid1 etc.
> >
> > Since I will only be measuring barriers, per esandeen@ I have
changed
> > the mount options from what I typically use to the defaults.
> 
> [...]
> 
> > The benchmark:
> > # /usr/bin/time bash -c 'tar xf linux-2.6.27.8.tar; sync'
> > # echo 1 > /proc/sys/vm/drop_caches # (between tests)
> >
> > == The tests ==
> >
> >   KEY:
> >   barriers = "b"
> >   write_cache = "w"
> >
> >   SUMMARY:
> >    b=on,w=on: 1:19.53 elapsed @ 2% CPU [BENCH_1]
> >   b=on,w=off: 1:23.59 elapsed @ 2% CPU [BENCH_2]
> >   b=off,w=on: 0:21.35 elapsed @ 9% CPU [BENCH_3]
> > b=off,w=off: 0:42.90 elapsed @ 4% CPU [BENCH_4]
> 
> This is quite similar to what I got on my laptop without any RAID
> setup[1]. At least without barriers it was faster in all of my tar -xf
> linux-2.6.27.tar.bz2 and rm -rf linux-2.6.27 tests.
> 
> At the moment it appears to me that disabling write cache may often
> give more performance than using barriers. And this doesn't match my
> expectation of write barriers as a feature that enhances performance.
> Right now a "nowcache" option and having this as default appears to
> make more sense than defaulting to barriers. But I think this needs
> more testing than just those simple high meta data load tests. Anyway
I
> am happy cause I have a way to speed up XFS ;-).
> 
> [1] http://oss.sgi.com/archives/xfs/2008-12/msg00244.html
> 
> Ciao,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

Consider if write cache is enabled, and 128 blocks are in write cache
...
waiting to be flushed.

If those 128 blocks are not needed again before it is time to flush, 
then not only did you waste cycles copying those 128 blocks into cache,
but you prevented those same 128 block from being used by read cache,
buffers,
whatever..  You also have overhead of cache lookup, and no matter what,
you still
have to flush cache eventually.   If you are doing extended writes, then
the cache
will fill up quickly, so it hurts you.  Write cache is of greatest
benefit on a 
transactional environment, like database, and can hurt performance on
benchmarks,
rebuilds, etc .. depending on whether or not the extended operations can
actually 
save a disk I/O by getting information from the cache before it is time
to flush
cache to disk.

If you have SCSI, FC, or SAS disks, then you can query the drive's cache
log pages
(they are in vendor-specific fields for some drives), to see how the
cache is being
Utilized and determine relative efficiency.


David




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
