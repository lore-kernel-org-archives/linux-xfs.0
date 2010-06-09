Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o596f7ES261617 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 01:41:07 -0500
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E336C3A93D8
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 23:43:38 -0700 (PDT)
Received: from isrv.corpit.ru (isrv.corpit.ru [81.13.33.159]) by cuda.sgi.com
	with ESMTP id bkZ8wf0DQGUIK3Qp for <xfs@oss.sgi.com>;
	Tue, 08 Jun 2010 23:43:38 -0700 (PDT)
Message-ID: <4C0F3819.4000409@msgid.tls.msk.ru>
Date: Wed, 09 Jun 2010 10:43:37 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs, aacraid
	2.6.27 => 2.6.32 results in 6 times slowdown]
References: <4C0E13A7.20402@msgid.tls.msk.ru> <20100608122919.GC7869@dastard>
	<4C0EA938.9000104@msgid.tls.msk.ru> <20100608231845.GG7869@dastard>
In-Reply-To: <20100608231845.GG7869@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

09.06.2010 03:18, Dave Chinner wrote:
> On Wed, Jun 09, 2010 at 12:34:00AM +0400, Michael Tokarev wrote:
[]
>> Simple test doing random reads or writes of 4k blocks in a 1Gb
>> file located on an xfs filesystem, Mb/sec:
>>
>>                       sync  direct
>>               read   write   write
>> 2.6.27 xfs   1.17    3.69    3.80
>> 2.6.32 xfs   1.26    0.52    5.10
>>                      ^^^^
>> 2.6.32 ext3  1.19    4.91    5.02
>>
>> Note the 10 times difference between O_SYNC and O_DIRECT writes
>> in 2.6.32.  This is, well, huge difference, and this is where
>> the original slowdown comes from, apparently.
>
> Are you running on the raw block device, or on top of LVM/DM/MD to
> split up the space on the RAID drive? DM+MD have grown barrier
> support since 2.6.27, so it may be that barriers are now being
> passed down to the raid hardware on 2.6.32 and they never were on
> 2.6.27. Can you paste the output of dmesg when the XFS filesystem in

That's why I asked how to tell if barriers are actually hitting the
device in question.

No, this is the only machine where DM/MD is _not_ used.  On all other
machines we use MD software raid, this machine comes with an onboard
raid controller that does not work in JBOD mode so I weren't able to
use linux software raid.  This is XFS on top of Adaptec RAID card,
nothing in-between.

Also, as I mentioned in the previous email, remounting with nobarrier
makes no difference whatsoever.

(Another side note here - I discovered that unknown options are
silently ignored in "remount mode" while correctly rejected in
"plain mount" mode, -- it looks like a kernel bug actually, but
it's entirely different issue).

> question is mounted on both 2.6.27 and 2.6.32 so we can see if
> there is a difference in the use of barriers?
>
> Also, remember that O_DIRECT does not imply O_SYNC. O_DIRECT writes
> only write data, while O_SYNC will also write metadata and/or the
> log.

I know this.  I also found osyncisosync and osyncisdsync mount
options, and when I try to use the latter, kernel tells it's the
default and hence deprecated.  I don't need metadata updates, but
it _looks_ like the system is doing such updates (with barriers
or flushes?) anyway even when mounted with -o osyncisdsync it behaves
the same: very slow.

I also experimented with both O_SYNC|O_DIRECT: it is as slow as
without O_DIRECT, i.e. O_SYNC makes whole thing slow regardless
of other options.

I looked at the dmesg outputs, and there's no relevant differences
related to block devices or usage of barriers.  For XFS it always
mounts like this:

  SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
  SGI XFS Quota Management subsystem
  XFS mounting filesystem sda6

and for the device in question, it is always like

  Adaptec aacraid driver 1.1-5[2456]-ms
  aacraid 0000:03:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
  AAC0: kernel 5.1-0[8832] Feb  1 2006
  AAC0: monitor 5.1-0[8832]
  AAC0: bios 5.1-0[8832]
  AAC0: serial 267BE0
  AAC0: Non-DASD support enabled.
  AAC0: 64bit support enabled.
  AAC0: 64 Bit DAC enabled
  scsi0 : aacraid
  scsi 0:0:0:0: Direct-Access     Adaptec  f0500            V1.0 PQ: 0 ANSI: 2
  sd 0:0:0:0: [sda] 286715904 512-byte hardware sectors (146799 MB)
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
   sda: sda1 sda2 sda3 < sda5 sda6 >

There are tons of other differences, but that is to be expected (like
format of CPU topology printing which is changed between .27 and .32).

Thanks!

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
