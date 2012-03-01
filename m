Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q214X4RS076450 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 22:33:05 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id VS7OpVvLgH3NRqwy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 20:33:03 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B.13305761474124@bugs.debian.org>
From: Goswin von Brederlow <goswin-v-b@web.de>
References: <20120228074914.31280.78231.reportbug@frosties.localnet>
	<20120228091151.GA24717@infradead.org> <4F4E82E6.3040505@sandeen.net>
Date: Thu, 01 Mar 2012 04:53:32 +0100
In-Reply-To: <4F4E82E6.3040505@sandeen.net> (Eric Sandeen's message of "Wed,
	29 Feb 2012 13:56:22 -0600")
Message-ID: <87399tkmdf.fsf@frosties.localnet>
MIME-Version: 1.0
Reply-To: Goswin von Brederlow <goswin-v-b@web.de>, 661580@bugs.debian.org
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
Cc: Christoph Hellwig <hch@infradead.org>, Debian Bug Tracking System <submit@bugs.debian.org>, Carlos Maiolino <cmaiolino@redhat.com>, 661580@bugs.debian.org, Goswin von Brederlow <goswin-v-b@web.de>

Eric Sandeen <sandeen@sandeen.net> writes:

> On 2/28/12 3:11 AM, Christoph Hellwig wrote:
>> Carlos, didn't you plan to look into this issue?
>> 
>> Goswin, how do you determin that mkfs is still doing unaligned I/O
>> when forcing the large sevtor size?  Once we set the sector size XFS
>> can't do I/O smaller than it.
>
> I did think this was supposed to be working already:
>
>         get_topology(&xi, &ft);
>
>         if (ft.sectoralign) {
>                 /*
>                  * Older Linux software RAID versions want the sector size
>                  * to match the block size to avoid switching I/O sizes.
>                  * For the legacy libdisk case we thus set the sector size to
>                  * match the block size.  For systems using libblkid we assume
>                  * that the kernel is recent enough to not require this and
>                  * ft.sectoralign will never be set.
>                  */
>                 sectorsize = blocksize;
>         } else if (!ssflag) {
>                 /*
>                  * Unless specified manually on the command line use the
>                  * advertised sector size of the device.
>                  */
>                 sectorsize = ft.sectorsize ? ft.sectorsize : XFS_MIN_SECTORSIZE;
>         }
>
> but it may depend on whether or not it is being built with libblkid support or not...?
>
> I'll try to test it when I have some time, unless Carlos beats me to it.
>
> -Eric

I'm asuming libblkid is used, otherwise a sectorsize of 512 would make
no sense.

It might be that NBD advertises the geometry wrong, as in ft.sectorsize
isn't set correctly. That would make that part at least a kernel bug.

MfG
        Goswin


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
