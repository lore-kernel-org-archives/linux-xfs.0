Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34217 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdCQMLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 08:11:40 -0400
Received: by mail-it0-f47.google.com with SMTP id m27so11653431iti.1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 05:11:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170316232555.GX28800@wotan.suse.de>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-8-jtulak@redhat.com>
 <20170316232555.GX28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 17 Mar 2017 13:11:13 +0100
Message-ID: <CACj3i73O96z7vDR+P4JVt4VfJ0B7WfuZc_sRZMdHD9=+BR09Xw@mail.gmail.com>
Subject: Re: [PATCH 07/22] mkfs: Move opts related #define to one place
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 17, 2017 at 12:25 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Wed, Mar 15, 2017 at 05:00:02PM +0100, Jan Tulak wrote:
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 0877c196..4ba6df05 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -48,6 +48,80 @@ unsigned int               sectorsize;
>>  #define MAX_CONFLICTS        8
>>  #define LAST_CONFLICT        (-1)
>>
>> +#define OPT_B                0
>> +#define B_LOG                0
>> +#define B_SIZE               1
>
> How about instead using enums, this way if we use kdoc format (hey the new
> kernel doc format is producing nicer docs) we can then document what the
> hell each of these things are nicely. Also, when enums are used in switches
> the compiler will nag at you if you happened to have missed a case, unless you
> have a default.
>
> We could have an enum for the opts and then one for each subopt group.
>
>   Luis

Good point. I kept it as defines, but given how I'm shuffling it, I
might turn it into enum as well. This change should cause no issue
except separating option/suboption definition. I will think about it,
but now I'm more for the enums.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
