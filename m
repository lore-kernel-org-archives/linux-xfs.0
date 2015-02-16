Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 61ECD7F4E
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 07:53:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4AE71304039
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 05:53:58 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iIavDgQxraDYXYk4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 05:53:56 -0800 (PST)
Message-ID: <54E1F6C2.4060105@oracle.com>
Date: Mon, 16 Feb 2015 16:55:14 +0300
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
MIME-Version: 1.0
Subject: Re: xfs_logprint segfault with external log
References: <54DB5E70.80607@oracle.com> <20150211205406.GT4251@dastard>
	<54DC940D.4030009@oracle.com> <20150212230940.GD12722@dastard>
In-Reply-To: <20150212230940.GD12722@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandee <sandeen@sandeen.net>, xfs@oss.sgi.com


On 02/13/2015 02:09 AM, Dave Chinner wrote:
> On Thu, Feb 12, 2015 at 02:52:45PM +0300, Alexander Tsvetkov wrote:
>> On 02/11/2015 11:54 PM, Dave Chinner wrote:
>>> On Wed, Feb 11, 2015 at 04:51:44PM +0300, Alexander Tsvetkov wrote:
>>>> Hello,
>>>>
>>>> I've obtained corrupted xfs log after some sanity xfs testing:
>>>>
>>>> "log=logfile
>>>> log_size=855
>>>>
>>>> dd if=/dev/zero "of=$log" bs=4096 count=$log_size
>>>> loopdev=$(losetup -f)
>>>> losetup $loopdev $log
>>>>
>>>> mkfs.xfs -f -m crc=1 -llogdev=$loopdev,size=${log_size}b $SCRATCH_DEV
>>>> mount -t xfs -ologdev=$loopdev $SCRATCH_DEV $SCRATCH_MNT
>>>> ./fdtree.sh  -l 4 -d 4 -C -o $SCRATCH_MNT
>>>> sync
>>>> umount $SCRATCH_MNT
>>>>
>>>> xfs_logprint -l $loopdev $SCRATCH_DEV"
>>>>
>>>> Test makes crc enabled xfs filesystem with the external log of
>>>> minimal allowed size and then creates on this fs the small directory
>>>> tree
>>>> with sub directories and files of fixed depth and size with help of
>>>> fdtree utility:
>>>> https://computing.llnl.gov/?set=code&page=sio_downloads
>>> Just take metadump image and put it somewhere we can down load it.
>>>
>>>> After that xfs_logprint stably reports bad data in log:
> Please try the patch below, it fixes the problem on the image you
> provided.

I've restored provided image to filesystem with the same log file, 
applied patch to latest xfsprogs and have stable pass runs
of xfs_logprint on that filesystem and running with xfsprogs without 
this patch results to xfs_logprint segfaults reported that means patch 
is working.
The problem that it is not working for repeated test runs where 
xfs_logprint still continue to report bad log data. It seems it is 
working for some
cases including this image, because sometimes test can be passed but 
most part of test runs have still this xfs_logprint log error. Here is 
another fs image
that is still failed for me with patch applied to xfsprogs: 
https://drive.google.com/file/d/0B1Cg0_B_ui2gM1Bzdkc3TWVqbGM/view?usp=sharing


> Cheers,
>
> Dave.
Thanks,
Alexander Tsvetkov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
