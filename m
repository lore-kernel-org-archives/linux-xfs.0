Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35850 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbdC2O6n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 10:58:43 -0400
Received: by mail-vk0-f44.google.com with SMTP id s68so20733523vke.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Mar 2017 07:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c724fc7e-c8f8-b9d8-65c3-bbac48a2438b@sandeen.net>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-6-jtulak@redhat.com>
 <c724fc7e-c8f8-b9d8-65c3-bbac48a2438b@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 29 Mar 2017 16:58:16 +0200
Message-ID: <CACj3i70+Etdhsxhc9rZUnC21fqkOb=s3G23NR7Vny=kRFJ2kJw@mail.gmail.com>
Subject: Re: [PATCH 05/22] mkfs: add a check for conflicting values
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sat, Mar 25, 2017 at 1:36 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/15/17 11:00 AM, Jan Tulak wrote:
>> Add a check that reports a conflict only when subopts are mixed with specific values.
>
> Can you explain more about what changes here, maybe with an example?
>

For example, this should fail: -i attr=1 -m crc=1
But these should pass: -i attr=1 -m crc=0 or -i attr=2 -m crc=1
So we need a way how to raise conflict on these occassions. This does
not set the conflicting attributes in the options, but it prepares the
ground for it.

I will add something like this directly to the commit message.

> ...
>
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 52 ++++++++++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 44 insertions(+), 8 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index c9861409..7e0a4159 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -1311,18 +1311,18 @@ illegal_option(
>>   */
>>  static void
>>  check_opt(
>> -     struct opt_params       *opts,
>> +     struct opt_params       *opt,
>>       int                     index,
>>       bool                    str_seen)
>>  {
>> -     struct subopt_param     *sp = &opts->subopt_params[index];
>> +     struct subopt_param     *sp = &opt->subopt_params[index];
>>       int                     i;
>>
>>       if (sp->index != index) {
>>               fprintf(stderr,
>>       ("Developer screwed up option parsing (%d/%d)! Please report!\n"),
>>                       sp->index, index);
>> -             reqval(opts->name, (char **)opts->subopts, index);
>> +             reqval(opt->name, (char **)opt->subopts, index);
>>       }
>>
>>       /*
>> @@ -1335,11 +1335,11 @@ check_opt(
>>        */
>>       if (!str_seen) {
>>               if (sp->seen)
>> -                     respec(opts->name, (char **)opts->subopts, index);
>> +                     respec(opt->name, (char **)opt->subopts, index);
>>               sp->seen = true;
>>       } else {
>>               if (sp->str_seen)
>> -                     respec(opts->name, (char **)opts->subopts, index);
>> +                     respec(opt->name, (char **)opt->subopts, index);
>>               sp->str_seen = true;
>>       }
>
> Up to here you have only changed a variable name; I'm not sure why?

Mmm, honestly, I don't know now. It seems unnecessary to me too.

>
>> @@ -1349,10 +1349,44 @@ check_opt(
>>
>>               if (conflict_opt.opt == LAST_CONFLICT)
>>                       break;
>> -             if (opts->subopt_params[conflict_opt.subopt].seen ||
>> -                 opts->subopt_params[conflict_opt.subopt].str_seen)
>> -                     conflict(opts->name, (char **)opts->subopts,
>> +             if (conflict_opt.test_values)
>> +                     break;
>> +             if (opt->subopt_params[conflict_opt.subopt].seen ||
>> +                 opt->subopt_params[conflict_opt.subopt].str_seen) {
>> +                     conflict(opt->name, (char **)opt->subopts,
>>                                conflict_opt.subopt, index);
>
> now the name change is mixed with a functional change in the middle,
> so it's harder to see... a non-functional patch for the name change
> would be better, if it's necessary.

Yeah, I will split the patches.

>
>> +             }
>> +     }
>> +}
>> +
>> +/*
>> + * Check for conflict values between options.
>> + */
>> +static void
>> +check_opt_value(
>> +     struct opt_params       *opt,
>> +     int                     index,
>> +     long long               value)
>> +{
>> +     struct subopt_param     *sp = &opt->subopt_params[index];
>> +     int                     i;
>> +
>> +     /* check for conflicts with the option */
>> +     for (i = 0; i < MAX_CONFLICTS; i++) {
>> +             struct subopt_conflict conflict_opt = sp->conflicts[i];
>> +
>> +             if (conflict_opt.opt == LAST_CONFLICT)
>> +                     break;
>> +             if (!conflict_opt.test_values)
>> +                     break;
>> +             if ((opt->subopt_params[conflict_opt.subopt].seen ||
>> +                                 opt->subopt_params[conflict_opt.subopt].str_seen) &&
>> +                 opt->subopt_params[conflict_opt.subopt].value
>> +                             == conflict_opt.invalid_value &&
>> +                 value == conflict_opt.at_value) {
>> +                     conflict(opt->name, (char **)opt->subopts,
>> +                              conflict_opt.subopt, index);
>> +             }
>>       }
>>  }
>>
>> @@ -1399,6 +1433,8 @@ getnum(
>>                       illegal_option(str, opts, index, NULL);
>>       }
>>
>> +     check_opt_value(opts, index, c);
>> +
>>       /* Validity check the result. */
>>       if (c < sp->minval)
>>               illegal_option(str, opts, index, _("value is too small"));
>>



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
