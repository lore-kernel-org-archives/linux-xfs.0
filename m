Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:33489 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1435525AbdDZJKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 05:10:04 -0400
Received: by mail-ua0-f169.google.com with SMTP id j59so102201772uad.0
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 02:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170426004528.GP28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-9-jtulak@redhat.com>
 <20170425052721.GL28800@wotan.suse.de> <CACj3i73PnrUGRL+1zQtj=vgdih5ne3AZ8rnmNCn-zTmmnrV8EA@mail.gmail.com>
 <20170426004528.GP28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 11:09:42 +0200
Message-ID: <CACj3i716-7k41tiFmXmY6nA1JseeETiqmsQxhWY=1ZgaPZGa6Q@mail.gmail.com>
Subject: Re: [PATCH 08/12] mkfs: replace variables with opts table: -b,d,s options
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 2:45 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, Apr 25, 2017 at 10:37:57AM +0200, Jan Tulak wrote:
>> On Tue, Apr 25, 2017 at 7:27 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> > On Sun, Apr 23, 2017 at 08:54:59PM +0200, Jan Tulak wrote:
>> >> Remove variables that can be replaced with a direct access to the opts table,
>> >> so we have it all in a single place, acessible from anywhere.
>> >>
>> >> In future, we can remove some passing of values forth and back, but now limit
>> >> the changes to simple replacement without a change in the logic.
>> >
>> > What do you mean passing of values here, as an example with bopts ?
>>
>> Passing it to a function and then retrieving with pointers, e.g. change this
>>
>> static void
>> calc_stripe_factors(
>>         int             dsu,
>>         int             dsw,
>>         int             dsectsz,
>>         int             lsu,
>>         int             lsectsz,
>>         uint64_t        *dsunit,
>>         uint64_t        *dswidth,
>>         uint64_t        *lsunit)
>>
>>
>> to this
>>
>> static void
>> calc_stripe_factors(struct opt_params * opts) // or no argument at all...
>
> Ah, great, but note that not all options have a respective struct subopt_param,
> that is -- we don't allow for them to be specified in the command line, but they
> are rather collateral values, which depend on other struct subopt_param's. The
> lsunit is one example. Its why I ended up just stuffing all of the needed parameters
> into one data struct: struct mkfs_xfs_opts. Your patches round up direct
> parameters associated with struct subopt_param on the struct opt_params.
>
> Where would things like lsunit be stuffed into ?

I  thought about making a "special option", like OPT_INTERNAL, that
would group these variables.

And as I mentioned in the post scriptum in the cover letter, I think
about how to make sure we have valid values 100% of the time, that is,
how to validate every time we use set_conf_val(). Together, these two
things would mean that we could specify validity ranges and conditions
for any variable where we know them and ensure that they cannot
deviate. It might be an overkill, but it seems like something useful
we could get pretty cheap....

At this moment, this all is just an abstract idea, though.

>
> OK, understood, just so its clear, only once all the direct subopts and collateral
> values for subopts for the following main opts are stuffed into a data structure
> somehow (and perhaps the logic of processing them are stuffed into a routine) can
> the mkfs.xfs.conf blend in well, given the same logic would be used:
>
>                 case 'b':
>                 case 'd':
>                 case 'i':
>                 case 'l':
>                 case 'm':
>                 case 'n':
>                 case 'r':
>                 case 's':
>                         p = optarg;
>                         parse_subopts(c, p, &params);
>
> So I'll have to hold off my patches until something like this is available, but
> knowing its an end goal helps in the review process.
>
>   Luis

Yes, I want to end up with something like this.

Cheers,
Jan


-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
