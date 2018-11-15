Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40214 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbeKPCUd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Nov 2018 21:20:33 -0500
Subject: Re: [PATCH 00/24] xfsdump: code style change
References: <20181109143004.24963-1-jtulak@redhat.com>
 <9a951869-5852-2689-a6ef-084c770f16fb@sandeen.net>
 <CACj3i70u6hS2RgSRwHMqLZtKexdEz6GnSH10tyYF6DiHXimnug@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c242400e-bd0b-404a-ec49-226fde9a23db@sandeen.net>
Date: Thu, 15 Nov 2018 10:12:06 -0600
MIME-Version: 1.0
In-Reply-To: <CACj3i70u6hS2RgSRwHMqLZtKexdEz6GnSH10tyYF6DiHXimnug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 11/15/18 6:40 AM, Jan Tulak wrote:
> On Wed, Nov 14, 2018 at 9:36 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 11/9/18 8:29 AM, Jan Tulak wrote:
>>> This set is dealing with whitespaces only, no functional change, code
>>> shuffling, etc. should be present (with one small exception in patch no. 2).
>>> From the previous set I split the changes into multiple patches, one type of
>>> change at a time, and tried to make the code fully compliant with xfs style,
>>> so the number of changes is way bigger than in the first set.
>>>
>>> The only patch with code shuffling (but no behavioral change) is: "xfsdump: do
>>> not split function call with ifdef." See the patch for details.
>>>
>>> For patch 21 - xfsdump: (style) format intercharacter spaces, I think whether
>>> it is still to much agregated and I should separate the changes. Some other
>>> patches I had to split to multiple files as they are too big to pass through
>>> to the mailing list - it is in their name. The largest one is 660K now, so I
>>> will check if that passed through, or it is still too big.
>>>
>>> The whole set is created mechanically from scratch. Scripts used for the
>>> specific change are part of the commit message and I can easily put it all
>>> together. So there is no need to worry about rebase conflicts, etc. when
>>> pointing out issues.
>>>
>>> The tools used to make these changes are sed and uncrustify.
>>> http://uncrustify.sourceforge.net/
>>>
>>> A git tree with these patches is also on Github:
>>> https://github.com/jtulak/xfsdump/tree/style-nov-9th
>>> or
>>> git clone --single-branch -b style-nov-9th https://github.com/jtulak/xfsdump.git
>>
>> Thanks for doing this.  I do think it's useful in the long run.
>>
>> NB: not all patches came through, apparently they were too big for the list.
> 
> Thanks for looking at it. And sorry for the missing mails, I checked
> it in my mailbox and there they arrived all. But apparently, Gmail and
> its deduplication made it look like it came through both mailing list
> and me in cc, even if I received CCed version only.
> 
>>
>> A few issues I notice:
>>
>> 1) we now get warnings like:
>>
>> In file included from content.c:44:0:
>> types.h:30:0: warning: "sizeofmember" redefined [enabled by default]
>>  #define sizeofmember(t, m)      sizeof(((t *)0)->m)
>>  ^
>> In file included from content.c:40:0:
>> /usr/include/xfs/jdm.h:65:0: note: this is the location of the previous definition
>>  #define sizeofmember( t, m ) sizeof( ( ( t * )0 )->m )
>>  ^
>>
>> because xfsprogs headers have the definitions w/ the spaces in them.  So
>> I'd just leave sizeofmember and offsetofmember defines alone for now to
>> avoid this.  Or, wrap them in #ifndef's.  Or if we require xfsprogs headers
>> to build anyway, perhaps just drop the defines altogether.
> 
> Ok, I will drop it out.
> 
>>
>> 2) I think we probably do not want to change any user-facing strings,
>> or at least they should be carefully examined.  This will break some
>> translations (fixable) but it's also more of a functional change, and
>> should be done with care if at all, and maybe left for a separate patch
>> if it's warranted.
>>
>> 3) This creates /many/ more > 80 char lines.  Per:
>>
>> # for F in */*.[ch]; do expand $F | grep '.\{81\}'; done
>>
>> the codebase goes from 794 such lines to 1806.  IOWs, some of the "missing"
>> whitespace may have been intentional, to stay under 80 cols.  New lines
>> vs. compressed lines is a judgement call, I guess.  Bleah.
>>
>> So... sorry about that, but if the goal is to format better, let's be
>> sure to keep observing other basic rules like "< 80 cols"
> 
> Yeah. I'm not sure there is an easy way to automate that...

Well, I think that's kind of the point here.  Do your automated replacement,
but then manually inspect the result - you can look for 80col problems with
the example above.  Then manually fix up as needed.  Then proceed to the next
patch.

Reviewers will need to look at the changes closely nyway, so you may as well
do it before submission.  ;)

...

>> I suppose we could try to limit whitespace changes to things that won't
>> change disassembly first (for example, no string or assert changes) and
>> then go back and do them, so that we could ge the bulk of the changes in
>> with no modifications to the binary code, but ... I'm not sure if it's
>> worth it.
> 
> I'll look at these issues and see what can be done/if that helps with
> disassembly.

I'm undecided about whether it's worth it.  While it would be nice to be
able to compare objdumps and see that there are no changes at all, if it
complicates the patchset it may not be worth it.  See what you think.

-Eric
