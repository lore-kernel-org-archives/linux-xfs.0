Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599D3C04A68
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 22:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiG1Wb1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiG1WbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 18:31:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E7A7AC17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jul 2022 15:29:56 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 17so3155431pfy.0
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jul 2022 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Fd8EMGhRWxQdk2h5DLoGPCXwieyEoZKvpwJmBXhT3LU=;
        b=c8MITXfarlSM0xDcTEyKhHXGX/bng1UAwz3toRJjOXl0jhb2wr5LAwXjGd/oNPaXT/
         6Z1Mjn3Cq8bWTHLaMA5CgRPHCswKUB8W5Bg+v+7vhVXKcpTtseafspWV0hW7N1MJOYnt
         wZzVoqiiRkG+dA/O9ePDjGzT6LDfGeRieMRKpD8W+m6NyCX0DLP2ve0arf7l4KuB+LIB
         tGmBE2uRqsTydw9ITLfAXy5Bq91aVYhrVJndPAM61RHRlRpZDDvkdAkJcYB/dWnrLyug
         x7Bese10CF295xpkPlYrRlbYFdmvkBJTFUU9mlR2deA4vXipsgmmHxYx5VTY/qoUe+io
         M0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Fd8EMGhRWxQdk2h5DLoGPCXwieyEoZKvpwJmBXhT3LU=;
        b=Q7TY4RSt68CP4LrOxhnH0DrqNGCTJ2HpoaoQ3XuVc+LTOHH986R7GoTcUsMv/MMuEr
         Odfd4bB/Pum3obt1kXlFeMlBLCXj5i9dhDOM7P99R6WtFwPxkP8BfXUCb/hMWHS/rucZ
         9CaMRiBHMdfnFGPDH0qEEFdGH6pV7IQhWv82kxEtpUXM4hC8Y76PkS9B7GxzHaYuYzts
         N5XYgNrIcFsYw0oes7GWRfts4Et4zG9J9H7ziFEAlan+3wLl7tvmiucVyQBG/3x7ue7+
         sZRSxi0GTlFl9Jbf0rF0mHe2RT7o/kYGfuJ9SReC2PiSWgIHTa6bM4xtKMtFvO2gCe7L
         GTnA==
X-Gm-Message-State: AJIora9mCouNnvyLgw81c+fNOpx8RTLuwqn7i70prENE0/QYYlEIHXs/
        DxtmUtfn1rcY6HYM1n1W3bRtGf4/Tnc=
X-Google-Smtp-Source: AGRyM1t7hKTbMk1sej2KFlID4wU1fhtOOWaZw3DJSUe/hP/PLaKnPLb9ncGGLbrCHhzTMg7JRM4ffg==
X-Received: by 2002:a65:46cc:0:b0:419:cb1b:d9c2 with SMTP id n12-20020a6546cc000000b00419cb1bd9c2mr656094pgr.311.1659047395518;
        Thu, 28 Jul 2022 15:29:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id rj1-20020a17090b3e8100b001f21646d1a4sm9902643pjb.1.2022.07.28.15.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 15:29:55 -0700 (PDT)
Message-ID: <e6ee2759-8b55-61a9-ff6c-6410d185d35e@gmail.com>
Date:   Thu, 28 Jul 2022 15:29:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH] libxfs: stop overriding MAP_SYNC in publicly exported
 header files
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Fabrice Fontaine <fontaine.fabrice@gmail.com>
References: <WVSe_1J22WBxe1bXs0u1-LcME14brH0fGDu5RCt5eBvqFJCSvxxAEPHIObGT4iqkEoCCZv4vpOzGZSrLjg8gcQ==@protonmail.internalid>
 <YtiPgDT3imEyU2aF@magnolia> <20220721121128.yyxnvkn4opjdgcln@orion>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220721121128.yyxnvkn4opjdgcln@orion>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/21/22 05:11, Carlos Maiolino wrote:
> On Wed, Jul 20, 2022 at 04:28:00PM -0700, Darrick J. Wong wrote:
>> Can one of you please apply this patch and see if it'll build in musl on
>> mips, please?  Sorry it's taken so long to address this. :/
>>
>> --D
>>
>> ---
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> Florian Fainelli most recently reported that xfsprogs doesn't build with
>> musl on mips:
>>
>> "MIPS platforms building with recent kernel headers and the musl-libc
>> toolchain will expose the following build failure:
>>
>> mmap.c: In function 'mmap_f':
>> mmap.c:196:12: error: 'MAP_SYNC' undeclared (first use in this function); did you mean 'MS_SYNC'?
>>   196 |    flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>>       |            ^~~~~~~~
>>       |            MS_SYNC
>> mmap.c:196:12: note: each undeclared identifier is reported only once for each function it appears in
>> make[4]: *** [../include/buildrules:81: mmap.o] Error 1"
>>
>> At first glance, the build failure here is caused by the fact that:
>>
>> 1. The configure script doesn't detect MAP_SYNC support
>> 2. The build system doesn't set HAVE_MAP_SYNC
>> 2. io/mmap.c includes input.h -> projects.h -> xfs.h and later sys/mman.h
>> 3. include/linux.h #define's MAP_SYNC to 0 if HAVE_MAP_SYNC is not set
>> 4. musl's sys/mman.h #undef MAP_SYNC on platforms that don't support it
>> 5. io/mmap.c tries to use MAP_SYNC, not realizing that libc undefined it
>>
>> Normally, xfs_io only exports functionality that is defined by the libc
>> and/or kernel headers on the build system.  We often make exceptions for
>> new functionality so that we have a way to test them before the header
>> file packages catch up, hence this '#ifndef HAVE_FOO #define FOO'
>> paradigm.
>>
>> MAP_SYNC is a gross and horribly broken example of this.  These support
>> crutches are supposed to be *private* to xfsprogs for benefit of early
>> testing, but they were instead added to include/linux.h, which we
>> provide to user programs in the xfslibs-dev package.  IOWs, we've been
>> #defining MAP_SYNC to zero for unsuspecting programs.
>>
>> Worst yet, gcc 11.3 doesn't even warn about overriding a #define to 0:
>>
>> #include <stdio.h>
>> #include <sys/mman.h>
>> #ifdef STUPID
>> # include <xfs/xfs.h>
>> #endif
>>
>> int main(int argc, char *argv[]) {
>> 	printf("MAP_SYNC 0x%x\n", MAP_SYNC);
>> }
>>
>> $ gcc -o a a.c -Wall
>> $ ./a
>> MAP_SYNC 0x80000
>> $ gcc -DSTUPID -o a a.c -Wall
>> $ ./a
>> MAP_SYNC 0x0
>>
>> Four years have gone by since the introduction of MAP_SYNC, so let's get
>> rid of the override code entirely -- any platform that supports MAP_SYNC
>> has had plenty of chances to ensure their header files have the right
>> bits.  While we're at it, fix AC_HAVE_MAP_SYNC to look for MAP_SYNC in
>> the same header file that the one user (io/mmap.c) uses -- sys/mman.h.
>>
>> Annoyingly, I had to test this by hand because the sole fstest that
>> exercises MAP_SYNC (generic/470) requires dm-logwrites and dm-thinp,
>> neither of which support fsdax on current kernels.
>>
>> Reported-by: info@mobile-stream.com
>> Reported-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
>> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>  include/linux.h       |    8 --------
>>  io/io.h               |    2 +-
>>  io/mmap.c             |   25 +++++++++++++------------
>>  m4/package_libcdev.m4 |    3 +--
>>  4 files changed, 15 insertions(+), 23 deletions(-)
>>
>> diff --git a/include/linux.h b/include/linux.h
>> index 3d9f4e3d..eddc4ad9 100644
>> --- a/include/linux.h
>> +++ b/include/linux.h
>> @@ -251,14 +251,6 @@ struct fsxattr {
>>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>>  #endif
>>
>> -#ifndef HAVE_MAP_SYNC
>> -#define MAP_SYNC 0
>> -#define MAP_SHARED_VALIDATE 0
>> -#else
>> -#include <asm-generic/mman.h>
>> -#include <asm-generic/mman-common.h>
>> -#endif /* HAVE_MAP_SYNC */
>> -
>>  /*
>>   * Reminder: anything added to this file will be compiled into downstream
>>   * userspace projects!
>> diff --git a/io/io.h b/io/io.h
>> index ada0a149..de4ef607 100644
>> --- a/io/io.h
>> +++ b/io/io.h
>> @@ -58,7 +58,7 @@ typedef struct mmap_region {
>>  	size_t		length;		/* length of mapping */
>>  	off64_t		offset;		/* start offset into backing file */
>>  	int		prot;		/* protection mode of the mapping */
>> -	bool		map_sync;	/* is this a MAP_SYNC mapping? */
>> +	int		flags;		/* MAP_* flags passed to mmap() */
>>  	char		*name;		/* name of backing file */
>>  } mmap_region_t;
>>
>> diff --git a/io/mmap.c b/io/mmap.c
>> index 8c048a0a..425957d4 100644
>> --- a/io/mmap.c
>> +++ b/io/mmap.c
>> @@ -46,8 +46,11 @@ print_mapping(
>>  	for (i = 0, p = pflags; p->prot != PROT_NONE; i++, p++)
>>  		buffer[i] = (map->prot & p->prot) ? p->mode : '-';
>>
>> -	if (map->map_sync)
>> +#ifdef HAVE_MAP_SYNC
>> +	if ((map->flags & (MAP_SYNC | MAP_SHARED_VALIDATE)) ==
>> +			  (MAP_SYNC | MAP_SHARED_VALIDATE))
>>  		sprintf(&buffer[i], " S");
>> +#endif
>>
>>  	printf("%c%03d%c 0x%lx - 0x%lx %s  %14s (%lld : %ld)\n",
>>  		braces? '[' : ' ', index, braces? ']' : ' ',
>> @@ -139,7 +142,9 @@ mmap_help(void)
>>  " -r -- map with PROT_READ protection\n"
>>  " -w -- map with PROT_WRITE protection\n"
>>  " -x -- map with PROT_EXEC protection\n"
>> +#ifdef HAVE_MAP_SYNC
>>  " -S -- map with MAP_SYNC and MAP_SHARED_VALIDATE flags\n"
>> +#endif
>>  " -s <size> -- first do mmap(size)/munmap(size), try to reserve some free space\n"
>>  " If no protection mode is specified, all are used by default.\n"
>>  "\n"));
>> @@ -193,18 +198,14 @@ mmap_f(
>>  			prot |= PROT_EXEC;
>>  			break;
>>  		case 'S':
>> +#ifdef HAVE_MAP_SYNC
>>  			flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>> -
>> -			/*
>> -			 * If MAP_SYNC and MAP_SHARED_VALIDATE aren't defined
>> -			 * in the system headers we will have defined them
>> -			 * both as 0.
>> -			 */
>> -			if (!flags) {
>> -				printf("MAP_SYNC not supported\n");
>> -				return 0;
>> -			}
>>  			break;
>> +#else
>> +			printf("MAP_SYNC not supported\n");
>> +			exitcode = 1;
>> +			return command_usage(&mmap_cmd);
>> +#endif
>>  		case 's':
>>  			length2 = cvtnum(blocksize, sectsize, optarg);
>>  			break;
>> @@ -281,7 +282,7 @@ mmap_f(
>>  	mapping->offset = offset;
>>  	mapping->name = filename;
>>  	mapping->prot = prot;
>> -	mapping->map_sync = (flags == (MAP_SYNC | MAP_SHARED_VALIDATE));
>> +	mapping->flags = flags;
>>  	return 0;
>>  }
>>
>> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
>> index df44174d..5293dd1a 100644
>> --- a/m4/package_libcdev.m4
>> +++ b/m4/package_libcdev.m4
>> @@ -387,8 +387,7 @@ AC_DEFUN([AC_HAVE_MAP_SYNC],
>>    [ AC_MSG_CHECKING([for MAP_SYNC])
>>      AC_COMPILE_IFELSE(
>>      [	AC_LANG_PROGRAM([[
>> -#include <asm-generic/mman.h>
>> -#include <asm-generic/mman-common.h>
>> +#include <sys/mman.h>
>>  	]], [[
>>  int flags = MAP_SYNC | MAP_SHARED_VALIDATE;
>>  	]])
> 
> Patch looks good, if you plan to make it into a non-RFC patch, feel free to
> include:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 

Darrick, do you need to re-post, or can the maintainers pick up the patch directly?
-- 
Florian
