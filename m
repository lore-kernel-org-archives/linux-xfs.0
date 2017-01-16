Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38119 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdAPMpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2017 07:45:46 -0500
Received: by mail-it0-f54.google.com with SMTP id c7so20672175itd.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2017 04:45:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170113174331.GG23576@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-18-git-send-email-jtulak@redhat.com> <20170113174331.GG23576@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 16 Jan 2017 13:45:25 +0100
Message-ID: <CACj3i70vG_DgPXbUXv+Wg+fV_WTnyJiNTtvRLep2KcbWPsvgjQ@mail.gmail.com>
Subject: Re: [PATCH 17/22] mkfs: use old variables as pointers to the new opts
 struct values
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 6:43 PM, Bill O'Donnell <billodo@redhat.com> wrote:
> On Wed, Dec 07, 2016 at 02:27:24PM +0100, Jan Tulak wrote:
>> We need to have the values inside of the opts structure to validate it.
>> To avoid duplicity and to prevent issues with using a wrong type from
>> values union (e.g trating an int option as long long), keep the old
>> variables like agcount, dsunit, ... and just turn them into pointers
>> to the various opts fields.
>>
>> However, at this moment, do not touch fields in other structures.
>> If some option saves the value into the xi or fsx structure, then
>> simply copy the value at the end of option parsing.
>>
>> This might be changed in future if there is a nice way how to do it.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 771 ++++++++++++++++++++++++++++++--------------------------
>>  1 file changed, 418 insertions(+), 353 deletions(-)
>>
>> [snip]
>>
>> @@ -2003,6 +2004,10 @@ check_all_opts(struct opt_params *opts)
>>       }
>>  }
>>
>> +/* TODO we might loose some numbers here, if they are unsigned and bigger than
>> + * long long max value. So it might be worth to transform this... (think
>> + * __uint64_t)
>> + */
>
> OK, so is this "might" be recommended or should we go ahead and prevent it in this
> implementation? ;)
>

What we are hitting here is similar to the saving the values in the
opts struct. In one case, we can have UINT64_MAX value, in another, it
could be LLONG_MIN. I think that at this moment, it is a bit
theoretical issue as limits of XFS should kick in sooner, but still,
it would be nice to fix it. However, the only way I can see is to
change the return type from long long to something like the union
u_value introduced in this patchset.

I'm still a bit afraid that this thing with multiple types in union
will bite me later, so I kept it here as a TODO for now. Now as I
write this, I realised that maybe the getnum function can be turned
into multiple ones: getnum_int, getnum_uint... as only the last few
lines are really doing the conversion and would differ... Mm... I will
need to think his a bit. Any comments from you?


And thanks for you going through the patchset.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
