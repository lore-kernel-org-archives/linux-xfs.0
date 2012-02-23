Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1NMFRUL158634 for <xfs@oss.sgi.com>; Thu, 23 Feb 2012 16:15:28 -0600
Received: from millhouse.houseofnate.net
	(dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by
	cuda.sgi.com with ESMTP id zWgvI24VKOsdfwHm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Feb 2012 14:15:25 -0800 (PST)
Message-ID: <4F46BA7B.70600@houseofnate.net>
Date: Thu, 23 Feb 2012 17:15:23 -0500
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: Re: XFS, empty files after a crash
References: <4F4387A7.2070009@gmail.com>
	<20291.50554.414722.399249@tree.ty.sabi.co.UK>
	<4F445E9F.5030003@sandeen.net>
	<4F4695B1.4060202@houseofnate.net> <4F469C7F.9020208@gmail.com>
In-Reply-To: <4F469C7F.9020208@gmail.com>
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
To: xfs@oss.sgi.com

On 02/23/2012 03:07 PM, kadafax@gmail.com wrote:
>
>> kfx, try getting the inode number of the file (via stat or ls -i) and then 
>> doing something like this:
>>
>> xfs_db -r $DEV -c "inode $INO" -c "bmap" 
>
>
> # xfs_db -r /dev/sdc1 -c "inode 114748" -c "bmap"
> data offset 0 startblock 1881705728 (7/2657536) count 6460 flag 0
>
> # xfs_db -r /dev/sdc1 -c "inode 114754" -c "bmap"
> data offset 0 startblock 1077794560 (4/4052736) count 6582 flag 0

If you want to see what's behind those data extents (which are probably 
partially written), you could do something along these lines:

# Determine the AG size
agblocks=$(xfs_db -r /dev/sdc1 -c sb -c p | grep ^agblocks | sed 's/.* = //')

# Copy the extent in the first file, which consists of 6460 blocks (~26MB)
# in AG 7 starting at AG-relative block 2657536:
dd if=/dev/sdc1 bs=4096 skip=$(($agblocks * 7 + 2657536)) count=6460 of=./blob
# examine ./blob
...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
