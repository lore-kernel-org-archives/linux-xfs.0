Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52868 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1953557AbdDZCu7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 22:50:59 -0400
Subject: Re: [PATCH 05/12] mkfs: extend opt_params with a value field
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-6-jtulak@redhat.com>
 <20170425031326.GI28800@wotan.suse.de>
 <CACj3i70LFrv9HbMRYg7M8qutCfmhFHC8oCUtrkf3vP8kvKUw4Q@mail.gmail.com>
 <20170426011038.GR28800@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dbdfd755-93df-5d61-ab6b-534a00b365d8@sandeen.net>
Date: Tue, 25 Apr 2017 21:50:58 -0500
MIME-Version: 1.0
In-Reply-To: <20170426011038.GR28800@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/25/17 8:10 PM, Luis R. Rodriguez wrote:
> On Tue, Apr 25, 2017 at 10:04:39AM +0200, Jan Tulak wrote:
>> On Tue, Apr 25, 2017 at 5:13 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>>> On Sun, Apr 23, 2017 at 08:54:56PM +0200, Jan Tulak wrote:
>>>
>>>> and anything you write here now is
>>>> + *     overwritten if user specifies the subopt. (If the user input is a string
>>>> + *     and not a number, this value is set to a positive non-zero number.)
>>>> + *
>>>>   * !!! NOTE ==================================================================
>>>>   *
>>>>   * If you are adding a new option, or changing an existing one,
>>>> @@ -152,6 +158,7 @@ struct opt_params {
>>>>               uint64_t        maxval;
>>>>               uint64_t        flagval;
>>>>               const char      *raw_input;
>>>> +             uint64_t        value;
>>>>       }               subopt_params[MAX_SUBOPTS];
>>>>  } opts[MAX_OPTS] = {
>>>>  #define OPT_B        0
>>>
>>> It would seem rather unfair to define this this but not use it in the patch ?
>>
>> I'm still trying to find out when exactly should I make something two
>> patches and when one, and it seems to shift case by case... I tried to
>> separate the adding of new things and rewriting of the existing code,
>> but do you think, in this case, the new thing is too trivial to have a
>> standalone patch?
> 
> Ah, I see, this was split out to be separate given a slew of subopts in turn
> later use it. The nasty alternative for review would be to have all subopts
> converted in one shot. I suppose a middle ground would be to have this patch
> squashed with just one of the subopt users, and then each other subopt ported
> atomically. That would make the addition of the value and definition in effect
> as soon as its added.
> 
> Just my 0.02 CRC but its up to Eric as this is rather subjective and tree dependent.

I think the way Jan did this is fine.  Ideally the commit would explain a bit more,
i.e. "This patch simply adds the value field.  Subsequent patches will utilize
this new field."

Then the reviewers know what to expect from the start, and we avoid the back and
forth of figuring out why it was done as it was done.  ;)

However, I think 5 & 6 could easily be combined - add the field and the routines
to manipulate it, /then/ start adding users of that new infrastructure.

I haven't really reviewed from here on out yet, but from a "how should I break
up patches" point of view, that's my ... $0.02.  :)

-Eric

> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
