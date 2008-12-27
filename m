Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBRE5O7O023377 for <xfs@oss.sgi.com>; Sat, 27 Dec 2008 08:05:24 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1B204A0ED
	for <xfs@oss.sgi.com>; Sat, 27 Dec 2008 06:05:23 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Svaps6S0d5K3pSIz for
	<xfs@oss.sgi.com>; Sat, 27 Dec 2008 06:05:23 -0800 (PST)
Date: Sat, 27 Dec 2008 09:05:23 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
In-Reply-To: <20081227135822.GI6284@josefsipek.net>
Message-ID: <alpine.DEB.1.10.0812270904370.15403@p34.internal.lan>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
	<495410F4.5010508@ziu.info>
	<alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
	<20081227133824.GH6284@josefsipek.net>
	<alpine.DEB.1.10.0812270850490.15403@p34.internal.lan>
	<20081227135822.GI6284@josefsipek.net>
MIME-Version: 1.0
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com



On Sat, 27 Dec 2008, Josef 'Jeff' Sipek wrote:

> On Sat, Dec 27, 2008 at 08:53:21AM -0500, Justin Piszcz wrote:
>> Why bother partitioning?  I also run a Linux SW RAID1 on the host, as you
>> know the drive letters can change when working on a server.
>>
>> Example: Before I created the array (RAID-6), my disks were /dev/sda,
>> /dev/sdb and /dev/sdc (spare), the RAID-6 was /dev/sdd.  After reboot,
>> /dev/sdd became /dev/sda and /dev/sd[a-c] became /dev/sd[b-d].
>>
>> In lilo.conf I had:
>> raid-extra-boot="/dev/sda,/dev/sdb"
>>
>> If I ran LILO and forgot to fix the lilo.conf to reflect the new drive
>> mappings:
>> raid-extra-boot="/dev/sdb,/dev/sdc"
>>
>> I could be at risk of ruining the partition?
>
> Hrm...interesting point. LILO could mess up the superblock in sector 0.
>
>> I try to avoid such situations when possible, to be safe.
>
> :)
>
> I don't know how LILO would handle it, but I would try to use
> /dev/disk/by-*/* instead of the rather unstable /dev/sd* names.
>
> Just my 0.02 cents.
>
> Jeff.

Excellent idea.

# lilo
Added 2.6.27.9-1
Added 2.6.27.10-1
Added 2.6.27.10-2 *
The boot record of  /dev/md1  has been updated.
The boot record of  /dev/disk/by-id/scsi-SATA_WDC_WD1500ADFS-_WD-SN#######  has been updated.
Warning: /dev/disk/by-id/scsi-SATA_WDC_WD1500ADFD-_WD-SN######## is not on the first disk
The boot record of  /dev/disk/by-id/scsi-SATA_WDC_WD1500ADFD-_WD-SN########  has been updated.

Thanks!

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
