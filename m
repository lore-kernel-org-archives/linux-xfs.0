Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55800 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751089AbdHPOm7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Aug 2017 10:42:59 -0400
Subject: Re: [PATCH 1/6 v2] mkfs: Save raw user input field to the opts struct
References: <20170811123037.15962-1-jtulak@redhat.com>
 <20170815150812.32237-1-jtulak@redhat.com>
 <806d4e0b-587c-4c12-db45-3942b4ab0753@sandeen.net>
 <CACj3i72UC1vc9LD_JymfovkgnUkEdDt98=S5u9JSPUS=goiO=w@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b1e77067-8b6a-c64a-a4bd-80ccccefff59@sandeen.net>
Date: Wed, 16 Aug 2017 09:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i72UC1vc9LD_JymfovkgnUkEdDt98=S5u9JSPUS=goiO=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 8/16/17 4:11 AM, Jan Tulak wrote:
> On Wed, Aug 16, 2017 at 1:07 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 8/15/17 10:08 AM, Jan Tulak wrote:
>>> Save exactly what the user gave us for every option.  This way, we will
>>> never lose the information if we need it to print back an issue.
>>> (Just add the infrastructure now, used in the next patches.)
>>>
>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>
>> Sorry for not getting to the V1 review, catching up from a week off.
> 
> I hope you enjoyed your holiday. :-)

...


>>> +static char *
>>> +get_conf_raw_safe(const struct opt_params *opt, const int subopt)
>>> +{
>>> +     char *str;
>>> +
>>> +     str = NULL;
>>> +
>>> +     if (get_conf_raw(opt, subopt, &str) == -ENOMEM) {
>>> +             fprintf(stderr, "Out of memory!");
>>
>> Seems like using strerror() would be better than a hand-rolled, un-
>> translatable string?
> 
> Every day there is something new. :-)

Yeah, sorry.  But in general, strings need to be translatable; (that was
pointed out before) and strerror() would do that for your for free.

>>
>>> +             return NULL;
>>> +     }
>>
>> Again, I don't see that any subsequent patches ever call get_conf_raw();
>> is there any reason to even have this wrapper now?
> 
> Luis had a pretty strong opinion about having them there when he will
> need them in his own patches later on and I saw no reason why not to
> add them right now when the functions are created. After all, they
> will be useful later on also for me, when I want to limit the amount
> of asserts and be more return-oriented. It's just not in this
> patchset.

Hm, ok.  Let me reread that, thread - I'm just looking at this patchset
as sent.

In general, I'm not clear on what your "_safe" and "_unsafe" variants
are about but maybe it was discussed in the prior thread I skipped.

Thanks,
-Eric
