Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60720 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbdKCDKp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 23:10:45 -0400
Subject: Re: [PATCH] build: define _DEFAULT_SOURCE if _BSD_SOURCE
References: <20171026172857.8683-1-mcgrof@kernel.org>
 <d1635f9c-dcc7-66fe-268d-2aece2d44ba8@sandeen.net>
 <CAB=NE6XMwuNsu3YB71cxeKTEyiqME1TwFimT1q3o2LnGZR8zMA@mail.gmail.com>
 <D31D5414-876E-4251-B029-CD90FE4EB70E@sandeen.net>
 <CAB=NE6XWiUEOhTn_XqDSifL2KK4a2+bdGaYzWBFVqqyAW2aMbQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <873fe2cb-15fa-9bc6-8262-e67a7394de80@sandeen.net>
Date: Thu, 2 Nov 2017 22:10:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XWiUEOhTn_XqDSifL2KK4a2+bdGaYzWBFVqqyAW2aMbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>



On 11/2/17 5:59 PM, Luis R. Rodriguez wrote:
> On Thu, Nov 2, 2017 at 3:51 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On Nov 2, 2017, at 3:22 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>>>
>>>> On Thu, Nov 2, 2017 at 1:04 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>>> On 10/26/17 12:28 PM, Luis R. Rodriguez wrote:
>>>>> ./configure will leave traces of a complaint on config.log when
>>>>> _BSD_SOURCE is defined but not _DEFAULT_SOURCE. _BSD_SOURCE is
>>>>> deprecated so if defining _BSD_SOURCE also define _DEFAULT_SOURCE.
>>>>>
>>>>> From config.log:
>>>>> /usr/include/features.h:183:3: warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-Wcpp]
>>>>
>>>> Ok.  Or perhaps a more clear rationale is the preadv(5) manpage
>>>> itself:
>>>>
>>>> preadv(), pwritev():
>>>>        since glibc 2.19:
>>>>                _DEFAULT_SOURCE
>>>>        Glibc 2.19 and earlier:
>>>>                _BSD_SOURCE
>>>>
>>>> But this is just a feature test macro in a configure script.
>>>>
>>>> What about the code itself, how do we handle this when we
>>>> actually use preadv() in the codebase?
>>>
>>> Its not clear to me what the issue would be by defining this extra
>>> _DEFAULT_SOURCE when _BSD_SOURCE is defined.
>>>
>> That's not the issue I was raising; I'm fine with defining both.  I pointed out the man page because it clearly describes the change.
>>
>> What I'm asking is this: one or the other of these defines is /required/ for preadv use, per the man page.  You are fixing one in the config test.  What about the actual use of preadv in the code itself?  Why does the issue exist only in the config test?
> 
> Beats me really, I ran into this pesky warning with modern compilers
> and on old releases, and on old releases the complaint is actually on
> most of the C files it compiles, with new code for some reason it only
> complains on the configuration.

I'm asking you to look into it, like this:

The config snippet is simply a tiny bit of C code, generated from the m4:

#define _BSD_SOURCE
#include <sys/uio.h>

int
main ()
{

         preadv(0, 0, 0, 0);

  ;
  return 0;
}

you're telling me that _BSD_SOURCE is deprecated and should now be
_DEFAULT_SOURCE - which is fine.  The preadv manpage says one or the other
is required, to get the definition.  Defining both is fine, for older glibcs.
In fact this is what the feature_test_macros(7) manpage says to do.

But the whole point of a config test for preadv is so that we can /use/
it in the code, right?  So surely if this were a problem in the
preadv /test/ it is likely to be a problem in the preadv /use/ within
the code as well, right?

In other words, don't just paper over a warning with a spot-fix; look
at what the warning is telling you, and fix things across the project
in a consistent manner.

preadv() is called in io/pread.c - if the config test passes.  Oddly, it
doesn't use either of the #defines before including <sys/uio.h>, despite
the manpage listing this as a requirement.  Apparently it's a happy
accident that it still works.

So now that the code in configure has highlighted this problem for you,  
look at everywhere preadv and/or _BSD_SOURCE is used, and add the proper
#defines per the manpage there as well. 

If you can send a V2 that also adds proper #defines for the preadv use in
io/pread.c, I'd appreciate it.

Thanks,
-Eric
