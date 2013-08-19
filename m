Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55E127F67
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 06:01:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42B06304059
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 04:01:20 -0700 (PDT)
Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	by cuda.sgi.com with ESMTP id oAkx0fYNmL7aNqYe (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 04:01:19 -0700 (PDT)
From: "Semion Zak (sezak)" <sezak@cisco.com>
Subject: RE: xfs_repair deletes files after power cut
Date: Mon, 19 Aug 2013 11:00:51 +0000
Message-ID: <345BE8CDF5F1514CB9B5CB3FFFA9B6590145CD39@xmb-aln-x14.cisco.com>
References: <345BE8CDF5F1514CB9B5CB3FFFA9B65920197D@xmb-aln-x14.cisco.com>
	<20130815000225.GH6023@dastard>
In-Reply-To: <20130815000225.GH6023@dastard>
Content-Language: en-US
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
Cc: "xtv-fs-group-nds-dg(mailer list)" <xtv-fs-group-nds-dg@cisco.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello Dave,

Thank you for fast and helpful answer.

I applied the patch and it really helped.
The only problem was that read and append to the file of 512 bytes, properly aligned failed.

4K append succeeded, which for my purposes is OK.

Once more, thank you very much.

Semion. 

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Thursday, August 15, 2013 3:02 AM
To: Semion Zak (sezak)
Cc: xfs@oss.sgi.com; xtv-fs-group-nds-dg(mailer list)
Subject: Re: xfs_repair deletes files after power cut

On Wed, Aug 14, 2013 at 01:06:08PM +0000, Semion Zak (sezak) wrote:
> Hello,
> 
> 
> 
> There is a problem in XFS: xfs_repair deletes files after power cut 
> because of "data fork in rt inode x claims used rt block y"

What's it supposed to do with it if it is corrupt?

> Scenario:
> 
> Empty XFS partition and real-time partition with extent size 3008 
> sectors.

Umm, 3008 sectors for the rt extent size? that's extremely weird even for a RT device....
> 
> 1. In a loop simultaneously:
> 
> a. 2 threads simultaneously write 1 stream file in real time partition
> 
> b. 1 thread writes 3 files into data partition.
> 
> c. 1 thread makes holes in the stream files
> 
> d. In the middle of the loop switch off the disk power.

So you're power failing a drive which has write caches turned on,


> 
> 2. Drop caches ("echo 3>/proc/sys/vm/drop_caches")
> 
> 3. Unmount XFS
> 
> 4. Switch the disk power on
> 
> 5. Mount XFS (to replay log)
> 
> 6. Unmount XFS
> 
> 7. Repair XFS
> 
> 8. Mount XFS
> 
> 
> 
> After the first mount (step 5) stream file exist in real time 
> partition.

No, the inode and it's metadata exist in the data partition. Only the file data is in the realtime partition. The corruption is in the metadata, not the realtime device.

> The only file in RT partition 0.STR:
> 
> /rt/000000R0.DIR/0.STR:
> 
>                0: [0..144383]: hole
>                1: [144384..147391]: 607625024..607628031
>                2: [147392..291775]: hole
>                3: [291776..294783]: 607772416..607775423
>                4: [294784..436159]: hole
>                5: [436160..439167]: 607916800..607919807
>                6: [439168..583551]: hole
>                7: [583552..586559]: 608064192..608067199
>                8: [586560..727935]: hole
>                9: [727936..730943]: 608208576..608211583
>                10: [730944..875327]: hole
>                11: [875328..878335]: 608355968..608358975
>                12: [878336..1019711]: hole
>                13: [1019712..1022719]: 608500352..608503359
>                14: [1022720..1167103]: hole
>                15: [1167104..1170111]: 608647744..608650751
>                16: [1170112..1311487]: hole
>                17: [1311488..1314495]: 608792128..608795135
>                18: [1314496..1458879]: hole
>                19: [1458880..1461887]: 608939520..608942527
>                20: [1461888..1603263]: hole
>                21: [1603264..1606271]: 609083904..609086911
>                22: [1606272..1750655]: hole
>                23: [1750656..1753663]: 609231296..609234303
>                24: [1753664..1895039]: hole
>                25: [1895040..1898047]: 609375680..609378687
>                26: [1898048..2042431]: hole
>                27: [2042432..2045439]: 609523072..609526079
>                28: [2045440..2186815]: hole
>                29: [2186816..2189823]: 609667456..609670463
>                30: [2189824..2334207]: hole
>                31: [2334208..2334719]: 609814848..609815359
>                32: [2334720..3853247]: 609815360..611333887
> 
> The only strange thing is that 2 the last extents are contiguous and 
> could be united into 1 extent.

And that will, most likely, be what xfs_repair is barfing on. The end of extent 31 is not aligned to the rt extent size, and so the block starting extent 32 overlaps a rt extent already claimed by extent 31.

So, there is an inconsistency in the extent map, and so xfs_repair is correct in saying it's broken and trashing the file.

This all sounds very familiar. I'm pretty sure this has been hit before, and I thought we fixed it. Oh:

http://oss.sgi.com/archives/xfs/2012-09/msg00287.html

Can you see if this patch:

http://oss.sgi.com/archives/xfs/2012-09/msg00481.html

stops repair from removing the file?

It would appear that followup patches that fixed the kernel code were never posted, and so the problem still exists in the kernel code.

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
