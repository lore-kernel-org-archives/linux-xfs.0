Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22FROOY092971 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 09:27:25 -0600
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.160]) by
	cuda.sgi.com with ESMTP id gF0NvqIYIZdpD6LE (version=TLSv1
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 07:27:23 -0800 (PST)
Message-ID: <4F50E6D4.8060605@giantdisaster.de>
Date: Fri, 02 Mar 2012 16:27:16 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: before test execution, print test number to
	syslog
References: <1330691215-4796-1-git-send-email-sbehrens@giantdisaster.de>
	<4F50DFEF.60401@sandeen.net>
In-Reply-To: <4F50DFEF.60401@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 3/2/2012 3:57 PM, Eric Sandeen wrote:
> On 3/2/12 6:26 AM, Stefan Behrens wrote:
>> When the xfstests are executed in a batch (like "check 001-299")
>> and produce syslog output, it is helpful to know which test was
>> causing the output. Therefore each time a test is started, a
>> syslog message is generated that contains the number of the
>> xfstest.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> 
> I like this; I almost sent a similar patch once.
> 
> But would like to let others chime in as well to be sure.
> 
> Is "logger" universal and portable to other systems?  That'd be
> my only concern with the patch.

logger(1) is included in the POSIX specification.


> 
> -Eric
> 
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
