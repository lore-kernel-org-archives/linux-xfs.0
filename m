Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:34873 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdDMJmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 05:42:13 -0400
Received: by mail-ua0-f170.google.com with SMTP id f10so9724197uaa.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 02:42:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i70PkWXYT9wxjBDrk=jn5sNOu0i+Z5CrxsxTGOJcA+WCYw@mail.gmail.com>
References: <20170406144139.20284-1-jtulak@redhat.com> <20170407014959.GT17542@dastard>
 <CACj3i71f3aDPYrMe1qN4YUxj2OmvcrC9OoNS3=u1tiHew9s0Fg@mail.gmail.com>
 <20170408235922.GG23007@dastard> <CACj3i70PkWXYT9wxjBDrk=jn5sNOu0i+Z5CrxsxTGOJcA+WCYw@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 13 Apr 2017 11:41:51 +0200
Message-ID: <CACj3i73cXhKYYD5XwjdV3VhiiabSjKPH3b9rtbNXPS9xy2GiWQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>

On Mon, Apr 10, 2017 at 10:42 AM, Jan Tulak <jtulak@redhat.com> wrote:
> On Sun, Apr 9, 2017 at 1:59 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Fri, Apr 07, 2017 at 03:17:20PM +0200, Jan Tulak wrote:
>>> On Fri, Apr 7, 2017 at 3:50 AM, Dave Chinner <david@fromorbit.com> wrote:
>>> > On Thu, Apr 06, 2017 at 04:41:38PM +0200, Jan Tulak wrote:
>>> >> Followup of my "[xfsprogs] Do we need so many data types for user input?" email.
>>> >>
>>> >> In the past, when mkfs was first written, it used atoi and
>>> >> similar calls, so the variables were ints. However, the situation moved
>>> >> since then and in course of the time, mkfs began to use other types too.
>>> >>
>>> >> Clean and unify it. We don't need negative values anywhere in the code and
>>> >> some numbers has to be 64bit. Thus, uint64 is the best candidate as the target
>>> >> type.
>>> >
>>> > I'm with Darrick and Eric on this - it's not the right conversion to
>>> > make for all the reasons they've pointed out. Further, I think it's
>>> > the wrong direction to be working in.
>>> >
>>> > What I originally intended the config option table to be used for
>>> > was to /replace all these config variables/ with config option table
>>> > lookups. We don't need tens of variables to say we certain options
>>> > set - once option parsing is complete we can just lookup the config
>>> > table and use the option value directly. i.e.  we need to work
>>> > towards removing all the variables, not try to make them pretty....
>>> >
>>>
>>> Removing them entirely is not as easy... Right now, there is this
>>> thing in "[PATCH 17/22] mkfs: use old variables as pointers to the new
>>> opts struct values" in the main:
>>>
>>> (Link to the patch: https://www.spinics.net/lists/linux-xfs/msg04977.html)
>>>
>>> -       __uint64_t              agcount;
>>> +       __uint64_t              *agcount;
>>> ...
>>>
>>> +       /*
>>> +        * Set up pointers, so we can use shorter names and to let gcc
>>> +        * check the correct type. We don't want to inadvertently use an int as
>>> +        * unsigned int and so on...
>>> +        */
>>> +       agcount = &opts[OPT_D].subopt_params[D_AGCOUNT].value.uint64;
>>
>> That's .... an interesting interpretation....
>>
>> What I intended was replacing all the uses of the agcount variable
>> with calls like:
>>
>>         get_config_val(OPT_D, D_AGCOUNT)
>>
>> [....]
>>
>>> transformed the variables into pointers in the patchset). But at least
>>> it could be possible to catch an incorrect type use easily, something
>>> we couldn't do in the macro:
>>>
>>> int get_opt_int(opt, sub)
>>> {
>>>   if (opts[opt].subopt_params[sub].type != INT)
>>>        print an error and exit();
>>>   return opts[opt].subopt_params[sub].value.int;
>>> }
>>
>> Yes, but why do we need to add type checking like this? It seems to
>> me that you're trying to over-engineer a simple thing that does not
>> need to be complex. For options with integer/flag values:
>>
>> /* return default value if nothing specified on the CLI */
>> static inline uint64_t
>> get_config_val(int opt, int subopt)
>> {
>>         if (!opts[opt].subopt_params[subopt].seen)
>>                 return opts[opt].subopt_params[subopt].defaultval;
>>         return opts[opt].subopt_params[subopt].value;
>> }
>>
>> And for options that are strings (e.g. device names):
>>
>> static inline char *
>> get_config_str(int opt, int subopt)
>> {
>>         if (!opts[opt].subopt_params[subopt].str_seen)
>>                 return NULL;
>>         return opts[opt].subopt_params[subopt].string;
>> }
>>
>> That's all that is necessary. The config table is guaranteed to
>> contain valid default values, and by the time we get to checking
>> options we've done all the conflict/validity checking so we can
>> trust the config settings to be valid and just use them directly
>> like this.
>>
>
> Yes, but to be able to do this, we have to remove the other numeric
> types. As long we have int, uint, various sizes... then there isn't an
> overarching data type that can be used, so we either lose part of the
> value range, or we need multiple functions. If we have only the
> uint64, then this works.
>
>>> >> +     __uint64_t      *dswidth,
>>> >> +     __uint64_t      *lsunit)
>>> >
>>> > My, what big raid stripes you have! ;)
>>>
>>> Well, yes, 64 bits is not necessary here, but I would say that having
>>> just one size of uint removes some (even if small) ambiguity, while
>>> performance-wise, it won't do anything noticeable.
>>
>> However, it makes me cringe when I read code written like this. You
>> say it removes ambiguity but to me, after more than 20 years of C
>> coding using appropriate types for variable contents, using uint64_t
>> for all variables (especially those that don't require 64 bit types)
>> introduces ambiguity and raises questions about the code quality.
>>
>> e.g.  declaring a flag as boolean means the author intended it to
>> only have two values (i.e. it's self documenting then intent of a
>> flag value!) whereas declaring them all as uint64_t makes me wonder
>> why the author of this code didn't know what the valid value range
>> for this variable is, why none of the reviewers cared either, what
>> happens if I put a really large value into the field instead of 0 or
>> 1, if that was tested, etc. Using the right type removes all this
>> potential ambiguity in the use/value of the variables.....
>
> The boolean flag is something I acknowledged in my previous email; it
> indeed makes sense to keep that as a boolean. With other types though,
> that goes against the idea of a single get_config_val().

Pinging this a bit. I changed all the flags to bool - these shouldn't
be an issue now. How about the other options like dswidth, though? Is
it ok if those are kept uint64?

And I'm not sure whether to use uint64_t or __uint64_t - as I wrote
before, I picked the __uint64_t because it was already used in this
file and is defined in xfs_linux.h, but I'm open to change it if it is
a legacy type and standard uint64_t is preferred...

Thanks.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
