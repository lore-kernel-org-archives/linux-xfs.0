Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Oct 2006 18:05:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9915PaG028017
	for <xfs@oss.sgi.com>; Sun, 8 Oct 2006 18:05:27 -0700
Date: Mon, 09 Oct 2006 11:06:36 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: review: set blocksize patch - libxfs & mkfs
Message-ID: <2BDC88DD553790D1C3134DEF@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <1160150291.11159.29.camel@xenon.msp.redhat.com>
References: <778901771D2CDD34FDDE6CFA@timothy-shimmins-power-mac-g5.local>
 <1160150291.11159.29.camel@xenon.msp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Hi Russell,

--On 6 October 2006 10:58:10 AM -0500 Russell Cattelan 
<cattelan@thebarn.com> wrote:

> On Fri, 2006-10-06 at 16:34 +1000, Timothy Shimmin wrote:
>
>>  }
>> Index: xfsprogs/libxfs/init.c
>> ===================================================================
>> --- xfsprogs/libxfs/init.c.orig	2006-10-06 14:12:27.000000000 +1000
>> +++ xfsprogs/libxfs/init.c	2006-10-06 14:14:03.000000000 +1000
>> @@ -116,8 +116,16 @@
>>  		exit(1);
>>  	}
>>
>> -	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK)
>> -		platform_set_blocksize(fd, path, statb.st_rdev, 512);
>> +	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
>> +		if (setblksize == 1)
>> +			/* use the default blocksize */
>> +			(void)platform_set_blocksize(fd, path, statb.st_rdev,
>> XFS_MIN_SECTORSIZE, 0);
>> +		else {
>> +			/* given an explicit blocksize to use */
>> +			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
>> +			    exit(1);
>> +		}

> should the return code always be checked for failure?
> mybe something like
> if (platform_set_blocksize(fd, path, statb.st_rdev,
> 		((setblksize == 1)?XFS_MIN_SECTORSIZE:setblksize) 1))
>
> would be bit cleaner
>
Yeah.
I was just a bit cautious about keeping the previous default behaviour.
Previously if we failed the ioctl we just gave a warning message and did 
not exit.
I thought that may be this was done for a reason and that sometimes perhaps 
the ioctl
could fail even though we could still write in 512 bytes sectors and so it 
just
gave a warning msg and continued on.
I don't want to cause people grief by getting strict all of a sudden,
but if you can assure me that the old behaviour was too conservative and 
that
if the ioctl on default 512 fails then there is no point continuing,
then I'll change it.

Cheers,
Tim.
