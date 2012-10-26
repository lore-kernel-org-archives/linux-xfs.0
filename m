Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QDTTNc229011 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 08:29:29 -0500
Message-ID: <508A909F.10305@sgi.com>
Date: Fri, 26 Oct 2012 08:31:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs_io: [v3] add the lseek() SEEK_DATA/SEEK_HOLE
	support
References: <20121022213759.033667921@sgi.com>
	<20121022213804.616209844@sgi.com> <20121022232931.GD4291@dastard>
	<20121023200144.515107339@sgi.com>
	<20121025141450.995788000@sgi.com> <20121025222914.GE29378@dastard>
In-Reply-To: <20121025222914.GE29378@dastard>
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
Cc: xfs@oss.sgi.com

On 10/25/12 17:29, Dave Chinner wrote:
> On Thu, Oct 25, 2012 at 09:14:44AM -0500, Mark Tinguely wrote:
>> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
>> The result from the lseek() call will be printed to the output.
>> For example:
>>
>> xfs_io>  lseek -h 609k
>> Type	Offset
>> hole	630784
>>
>> v1 ->  v2 Add "-a" and "-r" options.
>> 	 Simplify the output.
>> v2 ->  v3 Refactor for configure.in ->  configure.ac change.
>> 	 SEEK_DATA with -1 offset behaves badly on older Linux.
>> 	 Display error message as "ERR<errno>".
> ....
>> +
>> +#include<linux/fs.h>
>
> I missed this first time around - why is this include necessary?

Take it out and you will find that it contains the
defines for SEEK_DATA/SEEK_HOLE.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
