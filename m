Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:34145 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1433863AbdDZIOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 04:14:35 -0400
Received: by mail-ua0-f178.google.com with SMTP id h2so146054784uaa.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 01:14:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f106f9ca-54c7-dcaa-08f4-75b3b086138c@sandeen.net>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-5-jtulak@redhat.com>
 <f106f9ca-54c7-dcaa-08f4-75b3b086138c@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 10:14:08 +0200
Message-ID: <CACj3i72KzjGuvq3fTW3LLcBHsKncfpHospfkS62MOLA_ynhjog@mail.gmail.com>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 11:45 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/23/17 1:54 PM, Jan Tulak wrote:
>> Merge separate instances of opt_params into one indexable table. Git
>> makes this patch looks a bit more complicated, but it does not change
>> values or structure of anything else. It only moves all the "struct
>> opt_params dopts = {...}", changes indentation for these substructures
>> and replaces their usage (dopts -> opts[OPT_D]).
>
> This looks correct.  Can you remind me why it helps?  :)
> (the commit log says what you did but not why you did it)
>

A groundwork to be able to address any option from any other one. So
we can have conflicts pointing from -m crc to -i align...

>
> One thing I wondered about to idiot-proof the code a bit (in some
> other patch, not this one, but while I'm looking at it):
>
> What about instead of:
>
>     switch (getsubopt(&p, subopts, &value)) {
>     case OPT1:
>             opt1 = getnum(value, &opts, OPT1);
>     case OPT2:
>             opt2 = getnum(value, &opts, OPT2);
>                                 ...
>
> and making sure there's never a mismatch between the case value and the
> value passed to getnum, you could do something like:
>
>     int so = getsubopt(&p, subopts, &value);
>
>     switch (so) {
>     case OPT1:
>             opt1 = getnum(value, &opts, so);
>     case OPT2:
>             opt2 = getnum(value, &opts, so);
>                                 ...
>
> so that you can never mismatch & pass in the wrong subopt for option
> checking; it will always be the subopt matched by the case statement.
>
> I just considered that as I reviewed it and found myself mentally
> checking that each case matched.
>

Well, I think that once we remove every bit of logic from the main
loop and put it into some helper functions, we can ditch these manual
switches entirely and construct it dynamically from what we have in
opts (and the helpers).

Cheers,
Jan

> Thanks,
> -Eric



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
