Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 693C87F56
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 05:51:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5572D8F804C
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 03:51:40 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id iy7Yg8ZZbc8erOYW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 03:51:33 -0800 (PST)
Message-ID: <54DC940D.4030009@oracle.com>
Date: Thu, 12 Feb 2015 14:52:45 +0300
From: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
MIME-Version: 1.0
Subject: Re: xfs_logprint segfault with external log
References: <54DB5E70.80607@oracle.com> <20150211205406.GT4251@dastard>
In-Reply-To: <20150211205406.GT4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandee <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


archive with necessary data is available by this reference:

https://drive.google.com/open?id=0B1Cg0_B_ui2gRTQ1Yk9kVUw1Snc&authuser=0

On 02/11/2015 11:54 PM, Dave Chinner wrote:
> On Wed, Feb 11, 2015 at 04:51:44PM +0300, Alexander Tsvetkov wrote:
>> Hello,
>>
>> I've obtained corrupted xfs log after some sanity xfs testing:
>>
>> "log=logfile
>> log_size=855
>>
>> dd if=/dev/zero "of=$log" bs=4096 count=$log_size
>> loopdev=$(losetup -f)
>> losetup $loopdev $log
>>
>> mkfs.xfs -f -m crc=1 -llogdev=$loopdev,size=${log_size}b $SCRATCH_DEV
>> mount -t xfs -ologdev=$loopdev $SCRATCH_DEV $SCRATCH_MNT
>> ./fdtree.sh  -l 4 -d 4 -C -o $SCRATCH_MNT
>> sync
>> umount $SCRATCH_MNT
>>
>> xfs_logprint -l $loopdev $SCRATCH_DEV"
>>
>> Test makes crc enabled xfs filesystem with the external log of
>> minimal allowed size and then creates on this fs the small directory
>> tree
>> with sub directories and files of fixed depth and size with help of
>> fdtree utility:
>> https://computing.llnl.gov/?set=code&page=sio_downloads
> Just take metadump image and put it somewhere we can down load it.
>
>> After that xfs_logprint stably reports bad data in log:
>>
>> "Oper (307): tid: eec9b0c7  len: 16  clientid: TRANS  flags: none
>> EXTENTS inode data
>> Oper (308): tid: 41000000  len: 805306368  clientid: ERROR  flags: none
>> LOCAL attr data
> Clearly that operation is wrong, so everything past it is suspect.
> This sort of error usually comes from an error parsing an earlier
> ophdr, so even that probably doesn't point directly at the cause.
>
>> ============================================================================
>> cycle: 1        version: 2              lsn: 1,3138     tail_lsn: 1,2
>> length of Log Record: 32256     prev offset: 3074               num ops: 375
>> uuid: 39a962b7-4c0d-4e0e-8bcd-39471f93bc1d   format: little endian linux
>> h_size: 32768
>> ----------------------------------------------------------------------------
>> Oper (0): tid: eec9b0c7  len: 48  clientid: TRANS  flags: none
>> **********************************************************************
>> * ERROR: data block=3138                                              *
>> **********************************************************************
>>
>> xfs_logprint: unknown log operation type (2e00)
>> Bad data in log"
> i.e. this is not the problem that needs to be chased.
>
>> Subsequent call to "xfs_repair -n -l $loopdev $SCRATCH_DEV" passes
>> and filesystem is mounted without errors.
> xfs_repair -n doesn't look at the log at all.
>
> Cheers,
>
> Dave.
Thanks,
Alexander Tsvetkov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
