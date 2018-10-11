Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51063 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727735AbeJKVgk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Oct 2018 17:36:40 -0400
Subject: Re: [PATCH 01/18 V2] xfsprogs: enable sparse checking with "make
 C=[12]"
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-2-git-send-email-sandeen@redhat.com>
 <3048f94d-191c-0e62-1a3b-a0ec0e4b8374@sandeen.net>
 <20181011055747.GA20811@infradead.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <bdaaeb58-6fc1-7114-7137-2b7e6f08922b@redhat.com>
Date: Thu, 11 Oct 2018 09:09:18 -0500
MIME-Version: 1.0
In-Reply-To: <20181011055747.GA20811@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On 10/11/18 12:57 AM, Christoph Hellwig wrote:
>> -sparse and gcc using:
>> +The xfsprogs Makefile has a convenient shortcut to running sparse, by setting
>> +the C ("check") variable on the make commandline.  To perform generic checks,
>> +
>> +	make C=1
>> +
>> +which checks with -Wsparse-all -Wno-transparent-union -Wno-return-void
>> +-Wno-undef -Wno-non-pointer-null, or to perform the bitwise checks, use
>> +
>> +	make C=2
>> +
>> +which checks with -Wbitwise -D__CHECK_ENDIAN__
> 
> Out of all the sparce checks applicable to xfsprogs endianess is by
> far the most impotant one.  I don't think it makes any sense to ever
> turn it off..

Oh... whoops, I thought I was emulating kernel behavior (by following e2fsprogs
behavior), but sadly no:

> Do a kernel make with "make C=1" to run sparse on all the C files that get
> recompiled, or use "make C=2" to run sparse on the files whether they need to
> be recompiled or not.  The latter is a fast way to check the whole tree if you
> have already built it.

Let me see if I can properly mimic that behavior, with endian checking baked
in for both.

Thanks for bringing it up,
-Eric
