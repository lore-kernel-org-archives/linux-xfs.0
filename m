Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NE72XK058424 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 09:07:02 -0500
Message-ID: <5086A4E0.7040008@sgi.com>
Date: Tue, 23 Oct 2012 09:08:32 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20121022213759.033667921@sgi.com>
	<20121022213804.616209844@sgi.com> <20121022232931.GD4291@dastard>
In-Reply-To: <20121022232931.GD4291@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 10/22/12 18:29, Dave Chinner wrote:
> On Mon, Oct 22, 2012 at 04:38:00PM -0500, Mark Tinguely wrote:

> Type		Offset
> HOLE		630784
>

> xfs_io>  lseek -r -d 0
> Type		Offset
> DATA		0
> DATA		65536
> DATA		524288
> xfs_io>  lseek -r -h 0
> Type		Offset
> HOLE		16384
> HOLE		131072
> HOLE		1049576
>

> xfs_io>  lseek -r -a 0
> DATA		0
> HOLE		16384
> DATA		65536
> HOLE		131072
> DATA		524288
> HOLE		1049576

Good idea.

>> +#define _LARGEFILE64_SOURCE     /* See feature_test_macros(7) */
>
> That's defined by _GNU_SOURCE, which is set in the makefiles, so not
> necessary here.

Okay, I think a couple of the header files are redundantly redundant too.

>
>> +static void
>> +lseek_help(void)
>> +{
>> +	printf(_(
>> +"\n"
>> +" returns the next hole or data offset at or after the specified offset\n"
>> +"\n"
>> +" Example:\n"
>> +" 'lseek -d 512'  - offset of data at or following offset 512\n"
>> +"\n"
>> +" Repositions and returns the offset of either the next data or hole.\n"
>> +" There is an implied hole at the end of file. If the specified offset is\n"
>> +" past end of file, or there is no data past the specied offset, the offset\n"
>> +" -1 is returned.\n"
>
> I'd prefer that "EOF" rather than "-1" is printed in this case.

sounds good.

<deleted mess of things to clean up>

>
> Given that we only support pread and pwrite operations, the
> repositioning of the file pointer is irrelevant so probably should
> not be mentioned. If it was relevant, then we'd also need to support
> the other seek modes to reposition the file pointer. So jsut
> mentioning that it returns the offset of the next ... is probably
> sufficient here.

agreed. I did not the other lseek() whence options for that very reason.

>
> Cheers,
>
> Dave.

Thanks for the feedback.

PS. To Christoph: Yes, a test will be added.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
