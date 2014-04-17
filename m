Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58B0C7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 20:43:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D474BAC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 18:43:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JrD4gGbxTOe3eiCB for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 18:43:21 -0700 (PDT)
Message-ID: <534F31BD.7010402@sandeen.net>
Date: Wed, 16 Apr 2014 20:43:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: log running test to dmesg
References: <534EF81D.20205@redhat.com> <20140416234027.GR15995@dastard>
In-Reply-To: <20140416234027.GR15995@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/16/14, 6:40 PM, Dave Chinner wrote:
> On Wed, Apr 16, 2014 at 04:37:33PM -0500, Eric Sandeen wrote:
>> We already log the running test to system logs via "logger"
>> but viro pointed out that we can use /dev/kmsg to insert it
>> into dmesg as well.  When looking at the serial console that
>> could be pretty useful.
>>
>> Thanks to viro for the test -w suggestion too.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/check b/check
>> index 268417c..09b2320 100755
>> --- a/check
>> +++ b/check
>> @@ -457,6 +457,7 @@ do
>>  	$timestamp && echo -n "	["`date "+%T"`"]"
>>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
>>  	$LOGGER_PROG "run xfstest $seqnum"
>> +	test -w /dev/kmsg && echo "run xfstest $seqnum" > /dev/kmsg
>>  	./$seq >$tmp.rawout 2>&1
>>  	sts=$?
>>  	$timestamp && _timestamp
> 
> Might it be worthwhile adding a "_log" function that can take an
> arbitrary string so in future it is easy to add new log messages?

*shrug* I guess... nobody logs anything but here, today...

-Eric
 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
