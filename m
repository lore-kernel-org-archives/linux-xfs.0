Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:34716 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1956638AbdDZH6V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 03:58:21 -0400
Received: by mail-vk0-f46.google.com with SMTP id k4so64972386vki.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 00:58:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <62f04d88-9475-b1a4-dd91-871fd091b0e1@sandeen.net>
References: <20170419153025.10368-1-jtulak@redhat.com> <20170420083323.12524-1-jtulak@redhat.com>
 <62f04d88-9475-b1a4-dd91-871fd091b0e1@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 09:58:00 +0200
Message-ID: <CACj3i72zQBEd18rXi3718xodVfUrRX54Fc9Z0VaJNx8Rn_Eiyw@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 5:58 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/20/17 3:33 AM, Jan Tulak wrote:
>> In the past, when mkfs was first written, it used atoi and
>> similar calls, so the variables were ints. However, the situation moved
>> since then and in course of the time, mkfs began to use other types too.
>>
>> Clean and unify it. We don't need negative values anywhere in the code and
>> some numbers has to be 64bit. Thus, uint64_t is the best candidate as the target
>> type for numeric values. The existing uses of __uint64_t in mkfs change to the
>> standard uint64_t type. For flag values let's use boolean.
>>
>> This patch changes variables declared at the beginning of main() +
>> block/sectorsize, making only minimal changes. The following patch
>> cleans some now-unnecessary type casts.
>>
>> It would be nice to change types in some of the structures too, but
>> this might lead to changes outside of mkfs, so I'm skipping them for
>> this moment to keep it simple.
>
> This introduces quite a few new warnings on i386, first of all.
> (they persist with patch 2/2), so please sort that out.

ok

>
> Also, almost all of the existing use of PRIu64 in the codebase
> puts spaces around it, i.e.
>         ("The value is %" PRIu64 "\n")
> not
>         ("The value is %"PRIu64"\n")
>
> so I'd prefer that you follow that convention whenever you
> need to use it.
>
> On a respin, it would be nice to separate the boolean changes
> into a separate patch from the 64-bit changes, to produce
> shorter individual patches to aid review.  In fact, splitting out
> another patch to first convert existing __uint64_t to uint64_t would
> make it even nicer.  Small, self-contained, functional patches.
> Change one thing at a time, especially for long patches.
>
> (Splitting out the bools would make it more obvious that "discard" and
> "lalign" really should be converted to bools below, not uint64_t
> as they are now; there might be others.)
>

Good idea.

> However, as Dave said earlier:
>
>> we need to work
>> towards removing all the variables, not try to make them pretty....
>
> and indeed, your later patches do remove a lot of the variables that
> you're converting here, i.e.:
>
> [PATCH 08/12] mkfs: replace variables with opts table: -b,d,s options
>
> does:
>
> -uint64_t               blocksize;
> -uint64_t               sectorsize;
> ...
> -       uint64_t                agcount;
> -       uint64_t                agsize;
> -       uint64_t                blocklog;
> ...
> -       uint64_t                dbytes;
> -       uint64_t                dsu;
> -       uint64_t                dsw;
> -       uint64_t                dsunit;
> -       uint64_t                dswidth;
> ...
> -       uint64_t                sectorlog;
>
> and [PATCH 09/12] mkfs: replace variables with opts table: -i options
> does:
>
> -       uint64_t                imaxpct;
> -       uint64_t                inodelog;
> -       uint64_t                inopblock;
> -       uint64_t                isize;
>
> etc ...
>
> so is there any real advantage to converting all of these, only to remove
> most of them a few patches later?  (If there is, just help me understand
> why...)
>

I wanted to avoid type changes in patches that replace variables in main
with opts use. Without this, I need to have the opts members in long
long, but I still get some changes int -> long long and even one or two
uint -> long long. So I wanted to have all the replaced variables already in a
single type, without the need to change format strings and knowing
that the type change is not causing any side effect.

But I think this shouldn't be a big issue (it doesn't seem that type
changes broke anything), so I'm rebasing the set without these uint
changes and the type transition can happen later on.

Cheers,
Jan

> Thanks,
> -Eric
>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
