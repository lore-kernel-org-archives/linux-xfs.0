Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35885 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1437778AbdDZPRW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 11:17:22 -0400
Received: by mail-ua0-f169.google.com with SMTP id 110so2419482uas.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 08:17:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170426151059.GN5205@birch.djwong.org>
References: <0f7c888b-5c62-e874-53d1-9159f1a3beba@redhat.com> <20170426151059.GN5205@birch.djwong.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 17:16:58 +0200
Message-ID: <CACj3i73KZozSgQ55i++J9k9ubcHyGnwmYXMa-+3gM=Cbu3FE7g@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: Assign proper defaults to rmapbt and reflink flags
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 26, 2017 at 5:10 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Apr 26, 2017 at 09:02:44AM -0500, Eric Sandeen wrote:
>> The "defaultval" field in the options structure was a bit confusing,
>> so when the rmapbt & reflink options got added, the desire was
>> to keep them off by default, and "defaultval = 0" got set.
>>
>> However, the purpose of this field is to define the default value
>> when the flag is specified with no associated value, i.e.
>>
>> -m rmapbt vs. -m rmapbt=0 or -m rmapbt=1
>>
>> Today, the resulting behavior is unexpected, and different from any
>> other mkfs flags; specifying "-m rmapbt,reflink" results in a
>> filesystem /without/ those features.
>>
>> Fix these to be consistent with every other boolean flag in the
>> mkfs options, so that specifying the flag with no value will
>> enable the feature.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>
> Someone should document that 'defaultval' is not the way to say
> 'disabled by default' in whatever the mkfs option processing code
> turns into.
>
> (Granted maybe it does and I just can't read :P)

The current documentation is confusing about this too, which is my
fault. I already have a patch in my current set that renames it to
flagval and makes it clear what it does. And maybe I will remove it
altogether in exchange for some way how to explicitly say "This is a
flag, it has only 0 and 1. Thus, no value means 'enable it.'" in
another patchset.

Cheers,
Jan

>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> --D
>
>> ---
>>
>> I want to get this fixed up for 4.11, so just sending it separately
>> ahead of any other change Jan may make in this area.
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index affa405..10858e4 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -697,13 +697,13 @@ struct opt_params mopts = {
>>                 .conflicts = { LAST_CONFLICT },
>>                 .minval = 0,
>>                 .maxval = 1,
>> -               .defaultval = 0,
>> +               .defaultval = 1,
>>               },
>>               { .index = M_REFLINK,
>>                 .conflicts = { LAST_CONFLICT },
>>                 .minval = 0,
>>                 .maxval = 1,
>> -               .defaultval = 0,
>> +               .defaultval = 1,
>>               },
>>       },
>>  };
>>



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
