Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 22:02:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6851vnr029780
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 22:02:01 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 963E32C6A39
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 22:03:01 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id V7TKKGdoH1on58ym for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 22:03:01 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Mon, 7 Jul 2008 22:03:38 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266701323C3C@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <4872E33E.3090107@sandeen.net>
References: <4872E0BC.6070400@pmc-sierra.com> <4872E33E.3090107@sandeen.net>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Raj Palani <Raj_Palani@pmc-sierra.com>, xfs@oss.sgi.com

Sure Eric, I'll keep you posted with the results w/o loop back file.
When you say that the deadlock could be due to vm, is it due to lack of
memory? I checked meminfo and I found that sufficient buffers and
committed_as were persent when xfs is stalled. 

Thanks
Sagar


Sagar Borikar wrote:
> That's right Eric but I am still surprised that why should we get a 
> dead lock in this scenario as it is a plain copy of file in multiple 
> directories.  Our customer is reporting similar kind of lockup in our 
> platform.

ok, I guess I had missed that, sorry.

> I do understand that we are chasing the access to block zero exception

> and XFS forced shutdown which I mentioned earlier.  But we also see 
> quite a few smbd processes which are writing data to XFS are in 
> uninterruptible sleep state and the system locks up too.

Ok; then the next step is probably to do sysrq-t and see where things
are stuck.  It might be better to see if you can reproduce w/o the
loopback file, too, since that's just another layer to go through that
might be changing things.

> So I thought
> the test which I am running could be pointing to similar issue which 
> we are observing on our platform. But does this indicate that the 
> problem lies with x86 XFS too ?

or maybe the vm ...

> Also I presume in enterprise market such kind of simultaneous write 
> situation may happen.  Has anybody reported similar issues to you? As 
> you observed it over x86 and 2.6.24 kernel, could you say what would 
> be root cause of this?

Haven't really seen it before that I recall, and at this point can't say
for sure what it might be.

-Eric

>     Sorry for lots of questions at same time :) But I am happy that 
> you were able to see the deadlock in x86 on your setup with 2.6.24
> 
> Thanks
> Sagar
> 
> 
> Eric Sandeen wrote:
>> Sagar Borikar wrote:
>>   
>>> Hi Eric,
>>>
>>> Did you see any issues in your test? 
>>>     
>> I got a deadlock but that's it; I don't think that's the bug you want

>> to chase...
>>
>>
>> -Eric
>>
>>   
>>> Thanks
>>> Sagar
>>>
>>>
>>> Sagar Borikar wrote:
>>>     
>>>> Eric Sandeen wrote:
>>>>       
>>>>> Sagar Borikar wrote:
>>>>>
>>>>>
>>>>>  
>>>>>         
>>>>>> Could you kindly try with my test? I presume you should see 
>>>>>> failure soon. I tried this on
>>>>>> 2 different x86 systems 2 times ( after rebooting the system ) 
>>>>>> and I saw it every time.
>>>>>>     
>>>>>>           
>>>>> Sure.  Is there a reason you're doing this on a loopback file?  
>>>>> That probably stresses the vm a bit more, and might get even 
>>>>> trickier if the loopback file is sparse...
>>>>>   
>>>>>         
>>>> Initially I thought to do that since I didn't want to have a strict

>>>> allocation limit but allowing allocations to  grow as needed until 
>>>> the backing filesystem runs out of free space due to type of the 
>>>> test case I had. But then I dropped the plan and created a 
>>>> non-sparse loopback device. There was no specific reason to create 
>>>> loopback but as it was simplest option to do it.
>>>>       
>>>>> But anyway, on an x86_64 machine with 2G of memory and a 
>>>>> non-sparse 10G loopback file on 2.6.24.7-92.fc8, your test runs 
>>>>> w/o problems for me, though the system does get sluggish.  I let 
>>>>> it run a bit then ran repair and it found no problems, I'll run it

>>>>> overnight to see if anything else turns up.
>>>>>   
>>>>>         
>>>> That will be great.  Thanks indeed.
>>>> Sagar
>>>>
>>>>       
>>>>> -Eric
>>>>>   
>>>>>         
>>   
> 
