Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D25F97F55
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 02:51:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE7058F8050
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 00:51:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ARIrfv1eGDKDFgfJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 00:51:14 -0700 (PDT)
Message-ID: <5209E589.7080304@oracle.com>
Date: Tue, 13 Aug 2013 15:51:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: call roundup_64() to calculate the min_logblks
References: <5209C4D0.5050203@oracle.com> <20130813065355.GB6023@dastard>
In-Reply-To: <20130813065355.GB6023@dastard>
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
Cc: kbuild test robot <fengguang.wu@intel.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 08/13/2013 02:53 PM, Dave Chinner wrote:

> On Tue, Aug 13, 2013 at 01:32:00PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Replace roundup() with roundup_64() as we calculate min_logblks
>> with 64-bit divisions.  Hence, call roundup() will cause the
>> following error while compiling a 32-bit kernel:
>>
>> fs/built-in.o: In function `xfs_log_calc_minimum_size':
>> fs/xfs/xfs_log_rlimit.c:140: undefined reference to `__udivdi3'
>>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Cc: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> You beat me to it, Jeff. I got an email from Fengguang's build farm,
> too. :)

Hi Dave,

I'm on a longer vacations these days(until next week).  I have asked
my friend for help checking our mailing list to watch if there's any
email for me before the leaving, so I got his phone call this morning
for this bug. :)

> 
> Your fix looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for your quick review!

-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
