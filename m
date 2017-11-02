Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42482 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbdKBWvF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 18:51:05 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] build: define _DEFAULT_SOURCE if _BSD_SOURCE
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAB=NE6XMwuNsu3YB71cxeKTEyiqME1TwFimT1q3o2LnGZR8zMA@mail.gmail.com>
Date: Thu, 2 Nov 2017 17:51:03 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <D31D5414-876E-4251-B029-CD90FE4EB70E@sandeen.net>
References: <20171026172857.8683-1-mcgrof@kernel.org> <d1635f9c-dcc7-66fe-268d-2aece2d44ba8@sandeen.net> <CAB=NE6XMwuNsu3YB71cxeKTEyiqME1TwFimT1q3o2LnGZR8zMA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Nov 2, 2017, at 3:22 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> 
>> On Thu, Nov 2, 2017 at 1:04 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 10/26/17 12:28 PM, Luis R. Rodriguez wrote:
>>> ./configure will leave traces of a complaint on config.log when
>>> _BSD_SOURCE is defined but not _DEFAULT_SOURCE. _BSD_SOURCE is
>>> deprecated so if defining _BSD_SOURCE also define _DEFAULT_SOURCE.
>>> 
>>> From config.log:
>>> /usr/include/features.h:183:3: warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Wcpp]
>> 
>> Ok.  Or perhaps a more clear rationale is the preadv(5) manpage
>> itself:
>> 
>> preadv(), pwritev():
>>        since glibc 2.19:
>>                _DEFAULT_SOURCE
>>        Glibc 2.19 and earlier:
>>                _BSD_SOURCE
>> 
>> But this is just a feature test macro in a configure script.
>> 
>> What about the code itself, how do we handle this when we
>> actually use preadv() in the codebase?
> 
> Its not clear to me what the issue would be by defining this extra
> _DEFAULT_SOURCE when _BSD_SOURCE is defined.
> 
That's not the issue I was raising; I'm fine with defining both.  I pointed out the man page because it clearly describes the change.

What I'm asking is this: one or the other of these defines is /required/ for preadv use, per the man page.  You are fixing one in the config test.  What about the actual use of preadv in the code itself?  Why does the issue exist only in the config test?

Eric

> Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

