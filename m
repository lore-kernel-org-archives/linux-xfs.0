Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36717 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755919AbdDGNRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 09:17:42 -0400
Received: by mail-vk0-f44.google.com with SMTP id s68so74385247vke.3
        for <linux-xfs@vger.kernel.org>; Fri, 07 Apr 2017 06:17:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170407014959.GT17542@dastard>
References: <20170406144139.20284-1-jtulak@redhat.com> <20170407014959.GT17542@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 7 Apr 2017 15:17:20 +0200
Message-ID: <CACj3i71f3aDPYrMe1qN4YUxj2OmvcrC9OoNS3=u1tiHew9s0Fg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>

On Fri, Apr 7, 2017 at 3:50 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Apr 06, 2017 at 04:41:38PM +0200, Jan Tulak wrote:
>> Followup of my "[xfsprogs] Do we need so many data types for user input?" email.
>>
>> In the past, when mkfs was first written, it used atoi and
>> similar calls, so the variables were ints. However, the situation moved
>> since then and in course of the time, mkfs began to use other types too.
>>
>> Clean and unify it. We don't need negative values anywhere in the code and
>> some numbers has to be 64bit. Thus, uint64 is the best candidate as the target
>> type.
>
> I'm with Darrick and Eric on this - it's not the right conversion to
> make for all the reasons they've pointed out. Further, I think it's
> the wrong direction to be working in.
>
> What I originally intended the config option table to be used for
> was to /replace all these config variables/ with config option table
> lookups. We don't need tens of variables to say we certain options
> set - once option parsing is complete we can just lookup the config
> table and use the option value directly. i.e.  we need to work
> towards removing all the variables, not try to make them pretty....
>

Removing them entirely is not as easy... Right now, there is this
thing in "[PATCH 17/22] mkfs: use old variables as pointers to the new
opts struct values" in the main:

(Link to the patch: https://www.spinics.net/lists/linux-xfs/msg04977.html)

-       __uint64_t              agcount;
+       __uint64_t              *agcount;
...

+       /*
+        * Set up pointers, so we can use shorter names and to let gcc
+        * check the correct type. We don't want to inadvertently use an int as
+        * unsigned int and so on...
+        */
+       agcount = &opts[OPT_D].subopt_params[D_AGCOUNT].value.uint64;
...

The comment states, why the variables are still here and with this
code, it still makes sense to make (at least for some variables) the
transformation. I tried to come up with another way how to make a
short and type-safe access to the options without the variables, but
so far, I didn't got anywhere.

Clearly, we can't use a macro, because we need to access the value of
a member of a struct to decide what type the option is. The only thing
I could come up that seems remotely working is to make a set of
functions like these for every type:

int get_opt_int(opt, sub)
int set_opt_int(opt, sub, number)


It would require us to always remember what suffix we have to use and
it is not possible to do direct assignments with "="(that is why I
transformed the variables into pointers in the patchset). But at least
it could be possible to catch an incorrect type use easily, something
we couldn't do in the macro:

int get_opt_int(opt, sub)
{
  if (opts[opt].subopt_params[sub].type != INT)
       print an error and exit();
  return opts[opt].subopt_params[sub].value.int;
}

If you find this better than the pointers, I can change it and then
this unifying patch is rather useless. But if not, then it makes sense
to do something with the types now, rather than in the linked patch.
Ultimately, if we decide to have only one numeric type, then the type
safety is not much of an issue. Because you can't get it wrong and one
macro for a number and one for a string would suffice then.


So to the other points from Eric and Darrick:

>> -     int             *dsunit,
>> -     int             *dswidth,
>> -     int             *lsunit)
>> +     __uint64_t      *dsunit,
>> +     __uint64_t      *dswidth,
>> +     __uint64_t      *lsunit)
>
> My, what big raid stripes you have! ;)

Well, yes, 64 bits is not necessary here, but I would say that having
just one size of uint removes some (even if small) ambiguity, while
performance-wise, it won't do anything noticeable.


> For example, you're taking simple flags like qflag - which sure does look
> like it should be a /bool/ - and making it 64 bits:

and

>> -     int                     bsflag;
>> -     int                     bsize;
>> +     __uint64_t              blflag;
>
> Why do we need 64 bits to store a boolean flag?  Shouldn't bool (or just
> leaving the flags as int) be enough?

The same as above. I admit it is wasting of space, though, and in case
of booleans it  make more sense to turn them into a proper bool.

>
>> +     __uint64_t              blocklog;
>> +     __uint64_t              bsflag;
>> +     __uint64_t              bsize;
>
> I'm wondering why __uint64_t instead of uint64_t?

Because __uint64_t was already used for some numbers (e.g. agcount),
while uint64_t not, and it is defined in xfs_linux.h. So I thought
that it is safer to use xfs's own type, if it exists for some reason.

>> -             fprintf(stderr, _("illegal block size %d\n"), blocksize);
>> +             fprintf(stderr, _("illegal block size %lu\n"), blocksize);
>
> "illegal block size %"PRIu64"\n", because uint64_t can be unsigned long
> long on 32bit.

Mmm, ok, I'm making a note to have a 32bit VM at hand and try to at
least compile things there too. Then I would get a warning that would
force me to find the PRIu64 alternative...


> This changelog doesn't really say why we'd want to make this change
> in all of the variables you've modified.

I thought this as also a way to simplify the types in the opts
structure, ideally to just one numeric type and a string. So this is
in part how I picked most of the variables. And I added the rest
thinking: "Well, I'm changing most of them, so why keep the last few
ints in there? Let's convert them too."
But I now, after reading your comments, I think that adding a boolean
into the mix makes sense. Using 64 bits even where we won't need so
big numbers is not an issue, I would still use the 64 bits there, but
the boolean can be bool instead.

I hope I didn't forget anything and that it is understandable...

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
