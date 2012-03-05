Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25HWMBI233637 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 11:32:23 -0600
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.161]) by
	cuda.sgi.com with ESMTP id CCasSl6JVyj5RYNi (version=TLSv1
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 09:32:21 -0800 (PST)
Message-ID: <4F54F8A1.7020603@giantdisaster.de>
Date: Mon, 05 Mar 2012 18:32:17 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: before test execution, print test number to
	syslog
References: <1330691215-4796-1-git-send-email-sbehrens@giantdisaster.de>
	<20120305012301.GM5091@dastard>
In-Reply-To: <20120305012301.GM5091@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 3/5/2012 2:23 AM, Dave Chinner wrote:
> On Fri, Mar 02, 2012 at 01:26:55PM +0100, Stefan Behrens wrote:
>> When the xfstests are executed in a batch (like "check 001-299")
>> and produce syslog output, it is helpful to know which test was
>> causing the output. Therefore each time a test is started, a
>> syslog message is generated that contains the number of the
>> xfstest.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>  check |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/check b/check
>> index f792009..883edcc 100755
>> --- a/check
>> +++ b/check
>> @@ -241,6 +241,7 @@ do
>>  	start=`_wallclock`
>>  	$timestamp && echo -n "	["`date "+%T"`"]"
>>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
>> +	logger "run xfstest $seq"
>>  	./$seq >$tmp.rawout 2>&1
>>  	sts=$?
>>  	$timestamp && _timestamp
> 
> Only thing I'd suggest here is that errors (e.g. logger is not
> installed) are redirected to /dev/null so there isn't additional
> noise if we fail to log to syslog.

Patch v2 is sent which checks that logger can be executed. Additional
output cannot happen according to the sources. Thanks!


> 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
