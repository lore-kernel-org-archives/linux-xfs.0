Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AFA97CA3
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 15:41:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D15B8F8033
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 13:41:32 -0700 (PDT)
Received: from mail-vk0-f42.google.com (mail-vk0-f42.google.com
	[209.85.213.42]) by cuda.sgi.com with ESMTP id hVNqDoHjdBQUykvs
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Jul 2016 13:41:30 -0700 (PDT)
Received: by mail-vk0-f42.google.com with SMTP id c2so192258467vkg.1
	for <xfs@oss.sgi.com>; Sat, 02 Jul 2016 13:41:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57781AE6.10605@clear.net.nz>
References: <57781AE6.10605@clear.net.nz>
From: Nick Fisk <friskyfisk10@googlemail.com>
Date: Sat, 2 Jul 2016 21:41:28 +0100
Message-ID: <CAC5UwBhzdrJymG6doGbG7pDk5C+-xzvdaQH10aRsQSMRN+i1ew@mail.gmail.com>
Subject: Re: High Fragmentation with XFS and NFS Sync
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
To: Richard Scobie <r.scobie@clear.net.nz>
Cc: xfs@oss.sgi.com

On 2 July 2016 at 20:49, Richard Scobie <r.scobie@clear.net.nz> wrote:
>
>  Nick Fisk wrote:
>
> "So it looks like each parallel IO thread is being
> allocated next to each other rather than at spaced out regions of the disk."
>
> It's possible that the "filestreams" XFS mount option may help you out. See:
>
>
> http://www.xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s16.html

Thanks, I will see if this helps. Should I have any concern about
ongoing IO once the VM has been copied? That link seems to suggest
problems if the file is appended again at a later date. I believe the
holes shown below are due to it being a sparse file.

Would also using swalloc and a large swidth have any effect, or is
this like the allocsize, ignored once the file is closed?

I've been doing a bit more digging and I think the problem is a bit
more complex than I first thought. ESX seems to multithread the copy
with lots of parallel 64kb io's, I believe looking at xfs_bmap that
some these threads are also getting written out of order, which
properly isn't helping, although this is probably a minor problem in
comparison. This example file is 40GB and has nearly 50,000 extents.

        0: [0..127]: 5742779480..5742779607 128 blocks
        1: [128..2047]: hole 1920 blocks
        2: [2048..2175]: 5742779736..5742779863 128 blocks
        3: [2176..2303]: 5742779608..5742779735 128 blocks
        4: [2304..2431]: 5742779864..5742779991 128 blocks
        5: [2432..4351]: hole 1920 blocks
        6: [4352..4607]: 5742779992..5742780247 256 blocks
        7: [4608..12543]: hole 7936 blocks
        8: [12544..12671]: 5742780248..5742780375 128 blocks
        9: [12672..13695]: 5742798928..5742799951 1024 blocks
        10: [13696..13823]: 5742813392..5742813519 128 blocks
        11: [13824..13951]: 5742813648..5742813775 128 blocks
        12: [13952..14079]: 5742813264..5742813391 128 blocks
        13: [14080..14207]: 5742813520..5742813647 128 blocks <-- Next
to 10 on disk
        14: [14208..14719]: 5742813776..5742814287 512 blocks <-- Next
to 11 on disk
        15: [14720..15359]: 5742837840..5742838479 640 blocks
        16: [15360..15487]: 5743255760..5743255887 128 blocks
        17: [15488..15743]: 5742838608..5742838863 256 blocks
        18: [15744..15871]: 5743133904..5743134031 128 blocks
        19: [15872..15999]: 5743134288..5743134415 128 blocks
        20: [16000..16127]: 5743255632..5743255759 128 blocks
        21: [16128..16255]: 5743133776..5743133903 128 blocks
        22: [16256..16383]: 5743134032..5743134159 128 blocks
        23: [16384..16511]: 5742838480..5742838607 128 blocks
        24: [16512..16895]: 5743255888..5743256271 384 blocks
        25: [16896..17023]: 5743134416..5743134543 128 blocks
        26: [17024..17151]: 5743134160..5743134287 128 blocks

Thanks,
Nick

>
> Regards,
>
> Richard
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
