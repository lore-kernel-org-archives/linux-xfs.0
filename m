Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934617AbdKBW7n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 18:59:43 -0400
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com [209.85.223.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73552193A
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2017 22:59:42 +0000 (UTC)
Received: by mail-io0-f173.google.com with SMTP id 189so2464234iow.10
        for <linux-xfs@vger.kernel.org>; Thu, 02 Nov 2017 15:59:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D31D5414-876E-4251-B029-CD90FE4EB70E@sandeen.net>
References: <20171026172857.8683-1-mcgrof@kernel.org> <d1635f9c-dcc7-66fe-268d-2aece2d44ba8@sandeen.net>
 <CAB=NE6XMwuNsu3YB71cxeKTEyiqME1TwFimT1q3o2LnGZR8zMA@mail.gmail.com> <D31D5414-876E-4251-B029-CD90FE4EB70E@sandeen.net>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Thu, 2 Nov 2017 15:59:21 -0700
Message-ID: <CAB=NE6XWiUEOhTn_XqDSifL2KK4a2+bdGaYzWBFVqqyAW2aMbQ@mail.gmail.com>
Subject: Re: [PATCH] build: define _DEFAULT_SOURCE if _BSD_SOURCE
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 2, 2017 at 3:51 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On Nov 2, 2017, at 3:22 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>>
>>> On Thu, Nov 2, 2017 at 1:04 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>> On 10/26/17 12:28 PM, Luis R. Rodriguez wrote:
>>>> ./configure will leave traces of a complaint on config.log when
>>>> _BSD_SOURCE is defined but not _DEFAULT_SOURCE. _BSD_SOURCE is
>>>> deprecated so if defining _BSD_SOURCE also define _DEFAULT_SOURCE.
>>>>
>>>> From config.log:
>>>> /usr/include/features.h:183:3: warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Wcpp]
>>>
>>> Ok.  Or perhaps a more clear rationale is the preadv(5) manpage
>>> itself:
>>>
>>> preadv(), pwritev():
>>>        since glibc 2.19:
>>>                _DEFAULT_SOURCE
>>>        Glibc 2.19 and earlier:
>>>                _BSD_SOURCE
>>>
>>> But this is just a feature test macro in a configure script.
>>>
>>> What about the code itself, how do we handle this when we
>>> actually use preadv() in the codebase?
>>
>> Its not clear to me what the issue would be by defining this extra
>> _DEFAULT_SOURCE when _BSD_SOURCE is defined.
>>
> That's not the issue I was raising; I'm fine with defining both.  I pointed out the man page because it clearly describes the change.
>
> What I'm asking is this: one or the other of these defines is /required/ for preadv use, per the man page.  You are fixing one in the config test.  What about the actual use of preadv in the code itself?  Why does the issue exist only in the config test?

Beats me really, I ran into this pesky warning with modern compilers
and on old releases, and on old releases the complaint is actually on
most of the C files it compiles, with new code for some reason it only
complains on the configuration.

 Luis
