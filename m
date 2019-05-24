Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42190 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390021AbfEXQax (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 May 2019 12:30:53 -0400
Subject: Re: [RFC][PATCH] kernel.h: Add generic roundup_64() macro
References: <20190523100013.52a8d2a6@gandalf.local.home>
 <CAHk-=wg5HqJ2Kfgpub+tCWQ2_FiFwEW9H1Rm+an-BLGaGvDDXw@mail.gmail.com>
 <20190523112740.7167aba4@gandalf.local.home>
 <e4e875f0-2aa5-89f4-f462-78bedb9c5cde@filmlight.ltd.uk>
 <20190524112656.5ef67c6c@gandalf.local.home>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bd4a85fc-dc56-aae0-4986-003ad4a11ef4@suse.com>
Date: Fri, 24 May 2019 19:30:45 +0300
MIME-Version: 1.0
In-Reply-To: <20190524112656.5ef67c6c@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steven Rostedt <rostedt@goodmis.org>, Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, nouveau@lists.freedesktop.org, linux-rdma <linux-rdma@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>



On 24.05.19 г. 18:26 ч., Steven Rostedt wrote:
> On Fri, 24 May 2019 16:11:14 +0100
> Roger Willcocks <roger@filmlight.ltd.uk> wrote:
> 
>> On 23/05/2019 16:27, Steven Rostedt wrote:
>>>
>>> I haven't yet tested this, but what about something like the following:
>>>
>>> ...perhaps forget about the constant check, and just force
>>> the power of two check:
>>>
>>> 							\
>>> 	if (!(__y & (__y >> 1))) {			\
>>> 		__x = round_up(x, y);			\
>>> 	} else {					\  
>>
>> You probably want
>>
>>             if (!(__y & (__y - 1))
>>
>> --
> 
> Yes I do. I corrected it in my next email.
> 
>  http://lkml.kernel.org/r/20190523133648.591f9e78@gandalf.local.home

Or perhaps just using is_power_of_2 from include/linux/log2.h ?
> 
>> #define roundup(x, y) (					\
>> {							\
>> 	typeof(y) __y = y;				\
>> 	typeof(x) __x;					\
>> 							\
>> 	if (__y & (__y - 1))				\
>> 		__x = round_up(x, __y);			\
>> 	else						\
>> 		__x = (((x) + (__y - 1)) / __y) * __y;	\
>> 	__x;						\
>> })
> 
> 
> -- Steve
> 
