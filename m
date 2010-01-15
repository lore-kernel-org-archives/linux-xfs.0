Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FMj6pd137167 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 16:45:16 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDBD116B873
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 14:45:29 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id ZQuq2Ypy4Tcpg9tV for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 14:45:29 -0800 (PST)
Message-ID: <4B50EFC6.6050804@sandeen.net>
Date: Fri, 15 Jan 2010 16:44:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] mkfs: fix mkfs.xfs -dfile,name=$NAME for new files
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A697D@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A697D@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

Alex Elder wrote:
> Eric Sandeen wrote:
>> # /sbin/mkfs.xfs -dfile,name=grrr,size=100g
>> mkfs.xfs: Use the -f option to force overwrite.
>>
>> check_overwrite is failing, because  blkid_new_probe_from_filename()
>> is failing, because the (new) image file is 0 length.
>>
>> It's easy to test for 0 length, and if found, there is
>> nothing to overwrite so return 0.
>>
>> Also, if testing itself failed for some reason, print
>> a message to that effect:
>>
>> # mkfs/mkfs.xfs -dfile,name=newfile,size=1g
>> mkfs.xfs: probe of newfile failed, cannot detect existing filesystem.
>> mkfs.xfs: Use the -f option to force overwrite.
> 
> This looks good.

except of course that st_size for devices is 0.

Oh, I suck lately :/

Ok, will send fixup patch later.  And then I'm gonna stop ;)

-Eric

>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index faaafed..b6801dd 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -283,27 +283,47 @@ calc_stripe_factors(
>>  }
>>
>>  #ifdef ENABLE_BLKID
>> +/*
>> + * Check for existing filesystem or partition table on device.
>> + * Returns:
>> + *	 1 for existing fs or partition
>> + *	 0 for nothing found
>> + *	-1 for internal error
>> + */
>>  static int
>>  check_overwrite(
>>  	char		*device)
>>  {
>>  	const char	*type;
>> -	blkid_probe	pr;
>> -	int		ret = 0;
>> +	blkid_probe	pr = NULL;
>> +	int		ret;
>> +	struct stat	statbuf;
>>
>>  	if (!device || !*device)
>>  		return 0;
>>
>> +	ret = -1; /* will reset on success of all setup calls */
>> +
>> +	if (stat(device, &statbuf) < 0)
>> +		goto out;
>> +
>> +	/* nothing to overwrite on a 0-length device */
>> +	if (statbuf.st_size == 0) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>> +
>>  	pr = blkid_new_probe_from_filename(device);
>>  	if (!pr)
>> -		return -1;
>> +		goto out;
>>
>>  	if (blkid_probe_enable_partitions(pr, 1))
>> -		goto out_free_probe;
>> +		goto out;
>>
>>  	if (blkid_do_fullprobe(pr))
>> -		goto out_free_probe;
>> +		goto out;
>>
>> +	ret = 0;
>>  	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
>>  		fprintf(stderr,
>>  			_("%s: %s appears to contain an existing "
>> @@ -316,8 +336,13 @@ check_overwrite(
>>  		ret = 1;
>>  	}
>>
>> -out_free_probe:
>> -	blkid_free_probe(pr);
>> +out:
>> +	if (pr)
>> +		blkid_free_probe(pr);
>> +	if (ret == -1)
>> +		fprintf(stderr,
>> +			_("%s: probe of %s failed, cannot detect "
>> +			  "existing filesystem.\n"), progname, device);
>>  	return ret;
>>  }
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
