Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37353 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdCQNI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 09:08:29 -0400
Received: by mail-it0-f52.google.com with SMTP id g138so24726372itb.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 06:06:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2030b8be-4fe0-c767-4c3a-0e5ff25c4362@sandeen.net>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170316233845.GY28800@wotan.suse.de>
 <2030b8be-4fe0-c767-4c3a-0e5ff25c4362@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 17 Mar 2017 13:57:10 +0100
Message-ID: <CACj3i72OB8Ywx-vomuT+jV5P7KFVZN-4g=NssTXX6W_G8MjQ1w@mail.gmail.com>
Subject: Re: [PATCH 00/22] mkfs.xfs: Make stronger conflict checks
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Fri, Mar 17, 2017 at 12:47 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/16/17 4:38 PM, Luis R. Rodriguez wrote:
>> On Wed, Mar 15, 2017 at 04:59:55PM +0100, Jan Tulak wrote:
>>> This set is a follow-up of some old discussions and further attempts to untangle
>>> the spaghetti in options parsing. In short, this patchset allows to define
>>> cross-option conflicts and makes the conflicts detection more robust.
>>
>> This series is pretty large. There are quite a bit of patches which just rename
>> something, or just shove code from one place to another. Can you group up
>> non-functional changes together first, and send a small series of simple stuff
>> with no functional changes first?
>
> I have to say I'm still struggling with it as well.  Apologies for the
> random detail nitpicking, I'm trying to look through it all to get a better
> big picture.

No issue. I guess that if I split the changes differently, it might be
easier to read.
I need to find a better way how to present/group the changes.

>
> And as far as "no-op changes" it's imperative to make them really no-op.
> Make sure that other random changes aren't stuck into the middle of anything...
>

Of course. :-)

> I'll probably keep flinging comments on various patches as I read them,
> some of it may be helpful in terms of just learning some best practice
> for patches, but TBH I'm still trying to wrap my head around the big change
> and purpose.
>

OK. We can talk about it next week personally if needed. And decide
whether it is worth to reorganise this set into no-op and op changes.

Cheers,
Jan



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
