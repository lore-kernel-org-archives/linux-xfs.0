Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40264 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751665AbeCVWFB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 18:05:01 -0400
Subject: Re: [PATCH 1/2] workqueue: add missing pthreads header
References: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
 <20180316053016.GB1757@magnolia> <20180316060846.imxc42urbsb222sn@tarshish>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f0d6ee15-70d8-57c1-2b68-1d6b69f309ff@sandeen.net>
Date: Thu, 22 Mar 2018 17:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <20180316060846.imxc42urbsb222sn@tarshish>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Baruch Siach <baruch@tkos.co.il>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/16/18 1:08 AM, Baruch Siach wrote:
> Hi Darrick,
> 
> On Thu, Mar 15, 2018 at 10:30:16PM -0700, Darrick J. Wong wrote:
>> On Fri, Mar 16, 2018 at 07:21:35AM +0200, Baruch Siach wrote:
>>> Fix the following build failure with musl libc:
>>>
>>> In file included from read_verify.c:25:0:
>>> ../include/workqueue.h:39:2: error: unknown type name 'pthread_t'
>>>   pthread_t  *threads;
>>>   ^~~~~~~~~
>>> ../include/workqueue.h:42:2: error: unknown type name 'pthread_mutex_t'
>>>   pthread_mutex_t  lock;
>>>   ^~~~~~~~~~~~~~~
>>> ../include/workqueue.h:43:2: error: unknown type name 'pthread_cond_t'
>>>   pthread_cond_t  wakeup;
>>>   ^~~~~~~~~~~~~~
>>>
>>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>>> ---
>>>  include/workqueue.h | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/include/workqueue.h b/include/workqueue.h
>>> index b4b3541701df..edb2f8ac5991 100644
>>> --- a/include/workqueue.h
>>> +++ b/include/workqueue.h
>>> @@ -22,6 +22,8 @@
>>>  #ifndef	_WORKQUEUE_H_
>>>  #define	_WORKQUEUE_H_
>>>  
>>> +#include <pthread.h>
>>
>> Ooops, sorry about that.
>>
>> Our convention within xfsprogs sources (I think) is for most header
>> files to avoid having headers include other headers.  Would you mind
>> adding this include to read_verify.c instead?
> 
> I don't mind. But requiring every user of workqueue.h to remember to have 
> pthread.h before, is error prone IMO.
> 
>> (That said, you probably ought to wait for the maintainer (Eric) to
>> weigh in on this before you do any more work.)

Sorry for the late reply.

Eh, I think I'm inclined to just take this as-is, I don't see a downside to it.

Thanks,
-Eric
