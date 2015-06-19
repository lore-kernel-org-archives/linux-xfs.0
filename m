Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FA267F5D
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 10:19:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D9AE8F8035
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 08:19:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PxhRi13IDQVWZc10 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 08:19:51 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id EC32D4334A0
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 15:19:50 +0000 (UTC)
Message-ID: <55843315.1050800@redhat.com>
Date: Fri, 19 Jun 2015 10:19:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: automatically enable -f (file) mode when
	needed
References: <5583383D.4070906@redhat.com>
	<20150619132004.GD12833@bfoster.bfoster>
In-Reply-To: <20150619132004.GD12833@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/19/15 8:20 AM, Brian Foster wrote:
> On Thu, Jun 18, 2015 at 04:29:33PM -0500, Eric Sandeen wrote:
>> If we specify "-f" to xfs_repair, it recognizes that it's working
>> on a file, and if the underlying filesystem sector size differs
>> such that direct IO won't work, it disables direct IO.
>>
>> It's odd, though, that we'd need to specify this, and the failure
>> is non-obvious:
>>
>> # xfs_repair /mnt/test/foo.img
>> Phase 1 - find and verify superblock...
>> xfs_repair: read failed: Invalid argument
>>
>> I see no advantage to requirin the administrator to jump through
>> this hoop; why not just detect that it's a file, and move on?
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
>> index 834697a..2d376be 100644
>> --- a/repair/xfs_repair.c
>> +++ b/repair/xfs_repair.c
>> @@ -573,6 +573,18 @@ main(int argc, char **argv)
>>  		exit(1);
>>  	}
>>  
>> +	/* -f forces this, but let's be nice and autodetect it, as well. */
>> +	if (!isa_file) {
>> +		int		fd = libxfs_device_to_fd(x.ddev);
>> +		struct stat64	statbuf;
>> +
>> +		if (fstat64(fd, &statbuf) < 0)
>> +			do_warn(_("%s:  couldn't stat \"%s\"\n"),
>> +				progname, fs_name);
>> +		if (S_ISREG(statbuf.st_mode))
>> +			isa_file = 1;
> 
> We probably shouldn't query the statbuf if the stat call failed (who
> knows what's in there). Otherwise this seems like a good change to me.

yeargh, right, last-minute decision to not fail on the failed stat.

Sigh.  V2 coming.

(I think Jan is working on a more wholesale cleanup of this crap, but in the
meantime I think maybe a couple targeted fixes to get things going are probably
ok).

-Eric

> Brian
> 
>> +	}
>> +
>>  	/*
>>  	 * if the sector size of the filesystem we are trying to repair is
>>  	 * smaller than that of the underlying filesystem (i.e. we are repairing
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
