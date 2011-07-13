Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DMgbEU103481 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 17:42:37 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 862816B02E
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 15:39:13 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id J0Wsou1efJxwEDiA for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2011 15:39:13 -0700 (PDT)
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6DMATxR011564
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 18:10:29 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6DMbtYJ1732810
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 18:37:55 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p6DMbtjP023580 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 19:37:55 -0300
Message-ID: <4E1E1E41.30106@linux.vnet.ibm.com>
Date: Wed, 13 Jul 2011 15:37:53 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4 v3] XFS TESTS: Fix 252 Failure: Add Generic FS Punch
	Hole Test 255
References: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309411441-2491-5-git-send-email-achender@linux.vnet.ibm.com>
	<1310574716.1998.25.camel@doink>
In-Reply-To: <1310574716.1998.25.camel@doink>
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
To: aelder@sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 07/13/2011 09:31 AM, Alex Elder wrote:
> On Wed, 2011-06-29 at 22:24 -0700, Allison Henderson wrote:
>> This patch adds a new test 255 that tests fallocate punch hole,
>> but is for use by generic filesystems.  It is similar to 252,
>> but uses a weaker fiemap filter that only displays the location
>> of the hole, and not the extent types.
>>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>
> I realize Christoph already committed this but I
> spotted something so I thought I might as well
> mention it.  I haven't tested any of this, so
> it may be OK after all, but if it's not then
> the filter_hole_fiemap() function ought to be
> updated.
>
> 					-Alex
>
> . . .
>
>> diff --git a/common.punch b/common.punch
>> index c18f88a..a48b7ae 100644
>> --- a/common.punch
>> +++ b/common.punch
>> @@ -218,6 +218,23 @@ _filter_fiemap()
>>   	_coalesce_extents
>>   }
>>
>> +# Filters fiemap output to only print the
>> +# file offset column and whether or not
>> +# it is an extent or a hole
>> +_filter_hole_fiemap()
>> +{
>> +	awk --posix '
>> +		$3 ~ /hole/ {
>> +			print $1, $2, $3;
>> +			next;
>> +		}
>> +		$5 ~ /0x[[:digit:]]+/ {
>
> I believe this should be:
>                   $5 ~ /0x[[:xdigit:]]+/ {
>
> (I.e., hex digits, not just decimals.)
>

Hi Alex,

I think you are right.  The extent flags are printed in hex, so it 
should be xdigit.  The existing _filter_fiemap routine that I modeled 
this code from is also only parsing decimal digits.  Even though the 
tests are not showing any problems right now, it should probably be 
fixed.  Should I submit a patch to correct it?

Allison Henderson

>> +			print $1, $2, "extent";
>> +		}' |
>> +	_coalesce_extents
>> +}
>> +
>> +
>>   # Prints the md5 checksum of a given file
>>   _md5_checksum()
>>   {
>
> . . .
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
