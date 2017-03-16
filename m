Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38144 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdCPRs0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2017 13:48:26 -0400
Received: by mail-it0-f50.google.com with SMTP id m27so53594487iti.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2017 10:47:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <91e0d702-4b11-a42a-9ded-958fa09e2d41@sandeen.net>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-5-jtulak@redhat.com>
 <406aa194-3df0-d895-c0bf-db424343db99@sandeen.net> <CACj3i71NiJF-big5sAtBaVEPV9HC_wRGKEPHBjgNfUjDbu_1CA@mail.gmail.com>
 <91e0d702-4b11-a42a-9ded-958fa09e2d41@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 16 Mar 2017 18:47:25 +0100
Message-ID: <CACj3i72BzVsCQsUZtvU2NHemOzq-exQ-YAhZ0KK=h=tfYqKA8w@mail.gmail.com>
Subject: Re: [PATCH 04/22] mkfs: change conflicts array into a table capable
 of cross-option addressing
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2017 at 6:41 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 3/16/17 10:21 AM, Jan Tulak wrote:
>> On Thu, Mar 16, 2017 at 6:02 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 3/15/17 8:59 AM, Jan Tulak wrote:
>>>> Change subopt_param.conflicts from array of integers into array of structures.
>>>> This prepares the ground for more universal conflict detection in future
>>>> patches.
>>>>
>>>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>>> ---
>>>>  mkfs/xfs_mkfs.c | 243 ++++++++++++++++++++++++++++++--------------------------
>>>>  1 file changed, 129 insertions(+), 114 deletions(-)
>>>>
>>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>>> index 5e15fee2..c9861409 100644
>>>> --- a/mkfs/xfs_mkfs.c
>>>> +++ b/mkfs/xfs_mkfs.c
>>>> @@ -93,8 +93,16 @@ unsigned int               sectorsize;
>>>>   *
>>>>   *   conflicts MANDATORY
>>>>   *     If your subopt is in a conflict with some other option, specify it.
>>>> - *     Accepts the .index values of the conflicting subopts and the last
>>>> - *     member of this list has to be LAST_CONFLICT.
>>>> + *     Accepts the .index values of the conflicting subopt as .opt (e.g. OPT_D)
>>>> + *     and .subopt (e.g. D_FILE). If .test_values is true, then the conflict
>>>> + *     is raised only when the "remote" suboption .value is equal to
>>>> + *     .invalid_value field and the "current" suboption has .value equal to
>>>> + *     .at_value.
>>>> + *     If .test_values is false, a conflict is raised when the suboption appears
>>>> + *     on the CLI, no matter its value. The field .message contains an optional
>>>> + *     explanatory string for the user. This string can't be translated here,
>>>> + *     so it has to be enveloped with _() when printed.
>>>
>>> You also still need to mark each string initializer you added in the array
>>> in patch 08 with N_(" ... ") or gettext won't know about it.
>>> (I think that's the right way to go about it)
>>>
>>> -Eric
>>
>> See patch 06, the last chunk. It adds printing of the error with
>> "_(conflict->message)".
>
> yes, but nothing tags the actual conflict strings as needing translation.
>
> https://www.gnu.org/software/gettext/manual/html_node/Special-cases.html#Special-cases
>
> might help.
>
> note that we use macros - N_() is gettext_noop(), and _() is gettext()
>
>> So if C gettext is a function evaluated on the run and not a macro
>> evaluated on the compile time, then it should be ok. (And everywhere I
>> looked, I saw it mentioned as a function... Although I admit I didn't
>> tested it.)
>
> Well, give it a test.  If it works, fine, but I do not see these strings
> ending up in the .pot file so I'm skeptical.
>
> -Eric

Ah, it makes sense this way - the translation works, but the new
strings are not marked without the _() or N_().

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
