Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:32823 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031840AbdDTN56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 09:57:58 -0400
Received: by mail-ua0-f177.google.com with SMTP id j59so7514993uad.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2017 06:57:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170420132859.GU28800@wotan.suse.de>
References: <20170419153025.10368-1-jtulak@redhat.com> <20170420083323.12524-1-jtulak@redhat.com>
 <20170420132859.GU28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 20 Apr 2017 15:57:37 +0200
Message-ID: <CACj3i73gDo2ozGP+75kutnttnRxAaeU=20FJAU5rk9BMryGs9g@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2017 at 3:28 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Thu, Apr 20, 2017 at 10:33:23AM +0200, Jan Tulak wrote:
>> Thus, uint64_t is the best candidate as the target
>> type for numeric values. The existing uses of __uint64_t in mkfs change to the
>> standard uint64_t type.
>
> <-- snip -->
>
>> CHANGES:
>> * __uint64_t -> uint64_t
>
> <-- snip -->
>
>> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
>> index ce9bbce..ab74536 100644
>> --- a/include/xfs_multidisk.h
>> +++ b/include/xfs_multidisk.h
>> @@ -57,7 +57,7 @@
>>  #define XFS_NOMULTIDISK_AGLOG                2       /* 4 AGs */
>>  #define XFS_MULTIDISK_AGCOUNT                (1 << XFS_MULTIDISK_AGLOG)
>>
>> -extern long long cvtnum(unsigned int blksize, unsigned int sectsize,
>> +extern __uint64_t cvtnum(unsigned int blksize, unsigned int sectsize,
>
> I thought uint64_t was desired ?
>
>> -long long
>> +uint64_t
>>  cvtnum(
>>       unsigned int    blksize,
>>       unsigned int    sectsize,
>>       const char      *s)
>>  {
>
>
> Indeed. Probably just a missed case?
>

Yes, sorry for missing that.

Thanks,
Jan

>   Luis



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
