Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4GJm9Iq146011 for <xfs@oss.sgi.com>; Mon, 16 May 2011 14:48:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A694814D3AB1
	for <xfs@oss.sgi.com>; Mon, 16 May 2011 12:48:08 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id GYwIALduSTCpiJZV for <xfs@oss.sgi.com>;
	Mon, 16 May 2011 12:48:08 -0700 (PDT)
Message-ID: <4DD17F77.1010807@sandeen.net>
Date: Mon, 16 May 2011 14:48:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 251: fix fitrim support test
References: <4DCDA43A.30502@redhat.com>
	<alpine.LFD.2.00.1105161112290.3670@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1105161112290.3670@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 5/16/11 4:19 AM, Lukas Czerner wrote:
> On Fri, 13 May 2011, Eric Sandeen wrote:
> 
>> On my ext4 filesystem, the simple "did fstrim work" test passes,
>> because it asks to free all blocks in the first 10m of the fs,
>> and those 10m are full of filesystem metadata.  Because no blocks
>> are free, no blocks are trimmed, and we get success returned.
>>
>> But then when the test runs I'm flooded with error messages, because
>> it's a hard drive not an ssd...
>>
>> So we need to step through the fs until we either free a block,
>> or encounter an error.
>>
>> I think this is ugly bash, if anyone has a better plan I'm all ears.
>>
>> (also change FSTRIM to FITRIM in the failure message, it seems
>> to be intended to print the ioctl name ...)
> 
> Hi Eric,
> 
> this is actually a filesystem bug found unintentionally by this test :)
> and it is already fixed upstream 4143179218960a70d821a425e3c23ce44aa93dee
> for ext4.. So I think we better leave it as it is, since this is
> unwanted behaviour and should be detected.

Oh, of course.  Makes much more sense, thanks!



> What we should fix however, is when fstrim fails after successful fist
> test, so the test exits and report failure, rather than printing tons of
> error messages.

That'd be easy enough ...

-Eric
 
> Thanks!
> -Lukas
> 
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/251 b/251
>> index fa3d74a..5ab0a87 100755
>> --- a/251
>> +++ b/251
>> @@ -73,7 +73,19 @@ _fail()
>>  
>>  _check_fstrim_support()
>>  {
>> -	$here/src/fstrim -l 10M $SCRATCH_MNT &> /dev/null
>> +	# Go until error or until something gets trimmed
>> +	step=1048576
>> +	start=0
>> +	retval=0
>> +	nonetrimmed=1
>> +
>> +	while [ $retval -eq 0 ] && [ $nonetrimmed -ne 0 ]; do
>> +		result=`$here/src/fstrim -v -s $start -l $step $SCRATCH_MNT 2>&1`
>> +		retval=$?
>> +		[ "${result:0:1}" -eq "0" ] && nonetrimmed=1
>> +		start=$(( $start + $step ))
>> +	done
>> +	return $retval
>>  }
>>  
>>  ##
>> diff --git a/src/fstrim.c b/src/fstrim.c
>> index f1f37ec..ad7fd6a 100644
>> --- a/src/fstrim.c
>> +++ b/src/fstrim.c
>> @@ -236,7 +236,7 @@ int main(int argc, char **argv)
>>  	}
>>  
>>  	if (ioctl(fd, FITRIM, opts->range)) {
>> -		fprintf(stderr, "%s: FSTRIM: %s\n", program_name,
>> +		fprintf(stderr, "%s: FITRIM %s\n", program_name,
>>  			strerror(errno));
>>  		goto free_opts;
>>  	}
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
