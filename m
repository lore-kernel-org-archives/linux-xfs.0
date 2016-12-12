Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56390 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752997AbcLLUlg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Dec 2016 15:41:36 -0500
Subject: Re: [PATCH 1/1] Fixed to codestyle
References: <987271481540010@web27o.yandex.ru>
 <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
 <1481566450.1764.23.camel@perches.com>
 <50420874-ffde-283f-f2e7-cb2ebbec1b84@sandeen.net>
 <737751481574841@web26j.yandex.ru>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cbf01379-fbcb-b42e-abc1-1b368b9d6633@sandeen.net>
Date: Mon, 12 Dec 2016 14:41:34 -0600
MIME-Version: 1.0
In-Reply-To: <737751481574841@web26j.yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ozgur Karatas <okaratas@member.fsf.org>, Joe Perches <joe@perches.com>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 12/12/16 2:34 PM, Ozgur Karatas wrote:
> 12.12.2016, 20:35, "Eric Sandeen" <sandeen@sandeen.net>:
>> On 12/12/16 12:14 PM, Joe Perches wrote:

...

>>>>>   {
>>>>>           xfs_uu_t *uup = (xfs_uu_t *)uuid;
>>>>>
>>>>>  @@ -51,8 +51,8 @@ uuid_is_nil(uuid_t *uuid)
>>>>>           if (uuid == NULL)
>>>>>                   return 0;
>>>>>           /* implied check of version number here... */
>>>>>  - for (i = 0; i < sizeof *uuid; i++)
>>>>>  - if (*cp++) return 0; /* not nil */
>>>>>  + for (i = 0; i < sizeof (*uuid); i++)
>>>>>  + if (*cp++) return 0; /* not nil */
>>>
>>>  There shouldn't be a space after sizeof.
>>
>> and the "if" /should/ be indented under the for loop, because
>> it is within the loop...
>>
>> I suppose simply:
>>
>> - for (i = 0; i < sizeof *uuid; i++)
>> + for (i = 0; i < sizeof(*uuid); i++)
>>
>> would be fine on its own, though, because that is a bit
>> unusual/inconsistent. I'll admit that I didn't spot
>> that change as I scanned over the unnecessary & incorrect parts
>> of the first patch. :)
>>
>> thanks,
>> -Eric
> 
> Dear Eric;
> 
> Can you tell me the true code style? should use to (* uuid)? 
> I'm learn to new and I'm newbies :)

Well, rule #1 for newbies is "code style patches aren't
very useful, and usually are not welcomed by the project."

Making style changes just because checkpatch told you to is
not particularly helpful.  If it were important, it would have
been done by now.  If it hasn't been done by now, odds are
it's not important.  :)

If you are writing /new/ code, then sure, conform to the kernel
style, /aided/ by checkpatch.pl, and using your discretion as
well.

If you are just now looking at xfs/* code, best not to start
with "style" cleanups.  You'll find this to be true in general
across the kernel, maintainers are usually not thrilled to have
this kind of patch.

If you want to start with a new project, learn about the code,
learn what it /does/, learn how to use it.  use it.  Find things
that don't work as expected, or could work better.  Look into
bug reports and if you understand them, and the code involved,
try to write and test a fix.  But don't go looking for whitespace
nitpicks.

> Sorry,

No need to be sorry, this is how we learn.  ;)  But really, making
purely cosmetic changes for their own sake is not helpful in
general.

-Eric

> Regards
> 
> Ozgur
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
