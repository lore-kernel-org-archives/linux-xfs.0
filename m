Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:33201 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbdC2O6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2017 10:58:22 -0400
Received: by mail-vk0-f43.google.com with SMTP id d188so20658600vka.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Mar 2017 07:58:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7e15965f-1f31-9d3d-701f-cca982a871a8@sandeen.net>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-7-jtulak@redhat.com>
 <7e15965f-1f31-9d3d-701f-cca982a871a8@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 29 Mar 2017 16:57:59 +0200
Message-ID: <CACj3i736jkFi-2G7jFVW4Q8iCOuPuuP-=s0rWCSL5egOWvS3qA@mail.gmail.com>
Subject: Re: [PATCH 06/22] mkfs: add cross-section conflict checks
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sat, Mar 25, 2017 at 1:31 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/15/17 11:00 AM, Jan Tulak wrote:
>> Checks are modified to work with cross-section conflicts (data, metada, log, ...).
>
> More information in the changelog please; this doesn't
> tell us a whole lot about what this is actually doing.

Like this?

Checks are modified to work with cross-section conflicts (data,
metada, log, ...).
So, it is now possible to detect a conflict between -m foo and -d bar
options.

This patch only extends checks to test for conflicts across all
options instead of only the current one, the opts struct already can
declare it.

>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 43 ++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 34 insertions(+), 9 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 7e0a4159..0877c196 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -744,6 +744,9 @@ struct opt_params {
>>       },
>>  };
>>
>> +static void conflict_struct(struct opt_params        *opt, struct subopt_param *subopt,
>
> weird tabs there
>
>> +                     struct subopt_conflict  *conflict);
>
> "conflict_struct" seems like a variable name, not a function name.  :)
>
> What does this function actually do?

See bellow at the definition of this function (your other comment).

>
>> +
>>  #define TERABYTES(count, blog)       ((__uint64_t)(count) << (40 - (blog)))
>>  #define GIGABYTES(count, blog)       ((__uint64_t)(count) << (30 - (blog)))
>>  #define MEGABYTES(count, blog)       ((__uint64_t)(count) << (20 - (blog)))
>> @@ -1351,10 +1354,9 @@ check_opt(
>>                       break;
>>               if (conflict_opt.test_values)
>>                       break;
>> -             if (opt->subopt_params[conflict_opt.subopt].seen ||
>> -                 opt->subopt_params[conflict_opt.subopt].str_seen) {
>> -                     conflict(opt->name, (char **)opt->subopts,
>> -                              conflict_opt.subopt, index);
>> +             if (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
>> +                 opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) {
>> +                     conflict_struct(opt, sp, &conflict_opt);
>>               }
>>       }
>>  }
>> @@ -1379,13 +1381,12 @@ check_opt_value(
>>                       break;
>>               if (!conflict_opt.test_values)
>>                       break;
>> -             if ((opt->subopt_params[conflict_opt.subopt].seen ||
>> -                                 opt->subopt_params[conflict_opt.subopt].str_seen) &&
>> -                 opt->subopt_params[conflict_opt.subopt].value
>> +             if ((opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
>> +                  opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) &&
>> +                 opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].value
>>                               == conflict_opt.invalid_value &&
>>                   value == conflict_opt.at_value) {
>> -                     conflict(opt->name, (char **)opt->subopts,
>> -                              conflict_opt.subopt, index);
>> +                     conflict_struct(opt, sp, &conflict_opt);
>>               }
>>       }
>>  }
>> @@ -3586,12 +3587,36 @@ conflict(
>>       char            *tab[],
>>       int             oldidx,
>>       int             newidx)
>> +
>
> that newline should not be here ...
>
>>  {
>>       fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
>>               opt, tab[oldidx], opt, tab[newidx]);
>>       usage();
>>  }
>
> A comment about what this function actually /does/ would be good.
>
> All it really does is printf, I guess - so a function name more
> like show_conflict() might make more sense?  conflict_struct just
> isn't a good descriptive name.

Agreed, renamed to print_conflict_struct. The _struct is to
differentiate it from the conflict() function that has a different set
of arguments and can't print out the optional message conflicts
definitions can have.

>
>> +static void
>> +conflict_struct(
>> +     struct opt_params       *opt,
>> +     struct subopt_param     *subopt,
>> +     struct subopt_conflict  *conflict)
>> +{
>> +     if(conflict->message) {
>> +             fprintf(stderr, _("Cannot specify both -%c %s and -%c %s: %s\n"),
>> +                     opt->name,
>> +                     opt->subopts[subopt->index],
>> +                     opts[conflict->opt].name,
>> +                     opts[conflict->opt].subopts[conflict->subopt],
>> +                     _(conflict->message));
>> +     } else {
>> +             fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
>> +                     opt->name,
>> +                     opt->subopts[subopt->index],
>> +                     opts[conflict->opt].name,
>> +                     opts[conflict->opt].subopts[conflict->subopt]);
>> +     }
>
> I wonder if this can be done w/o the cut and paste?

Yes. After few minutes of thinking how to nicely concatenate strings
while avoiding allocs, I realised I can just print out the basic
error, conditionally print the conflict->message and then always print
"\n". I guess I overcomplicate things sometimes... :-/ Anyway, changed
for the next version of this patch.

>
>> +     usage();
>> +}
>> +
>>
>>  static void
>>  illegal(
>>



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
