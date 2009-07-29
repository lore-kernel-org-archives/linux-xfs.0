Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6T1V2iM214632 for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 20:31:06 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F14E5141767D
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 18:31:43 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id G1m9gfdl55xeu5pF for
	<xfs@oss.sgi.com>; Tue, 28 Jul 2009 18:31:43 -0700 (PDT)
Message-ID: <4A6FA67D.7080800@tlinx.org>
Date: Tue, 28 Jul 2009 18:31:41 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: does XFS support block sizes other than 512 bytes?
References: <4A6119B5.6000706@tlinx.org> <4A671E44.4040305@xfs.org>
In-Reply-To: <4A671E44.4040305@xfs.org>
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
To: Russell Cattelan <cattelan@thebarn.com>, xfs-oss <xfs@oss.sgi.com>



Russell Cattelan wrote:
>> But at least 1K might be a reasonable tradeoff?  Been quite a while since
>> I tried it and don't even know if the SAS drives allow it (if they do,
>> I wonder if the newer SATA drives do?)
> Yes
> XFS can support any power of 2 sector size up to the page size of your
> system.
> And it is recommend that on things like raid5 devices that the sector
> size be
> set to the same size as the filesystem block size.
> 
>> thanks more... :-)
>> -linda
---
	Just tried a 146GB-15K Seagate Cheetah SAS.  It didn't like anything other than 512bytes.  Any larger size ended up with a 528 byte sector size which really miffed the linux kernel so bad, it wouldn't expose it as a device
in /dev.  If you don't know mknod and the correct dev num, it would
make for a very interesting time formatting it back down.  ;-)

Do you know what brands might allow resizing?  You say SATA might
allow...just a WAG...but maybe a Seagate SATA might not? ;^)

Also, I wonder what might happen with a HW RAID card -- if it would
deal with 4K block sizes.  It deals with up to 1MB stripe sizes...so
you'd think it'd handle 4K block sizes...???  

Thanks for the fun times so far...;^)



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
