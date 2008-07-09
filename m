Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 09:56:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69Gu7hf006502
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 09:56:08 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D360DDABEC
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 09:57:12 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id 4EdQua2VeC5VQRXX for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 09:57:12 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Wed, 9 Jul 2008 09:57:48 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266702A08F91@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <4872E33E.3090107@sandeen.net>
References: <4872E0BC.6070400@pmc-sierra.com> <4872E33E.3090107@sandeen.net>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Sagar Borikar wrote:
> That's right Eric but I am still surprised that why should we get a
dead 
> lock in this scenario as it is a plain copy of file in multiple 
> directories.  Our customer is reporting similar kind of lockup in our 
> platform. 

ok, I guess I had missed that, sorry.

> I do understand that we are chasing the access to block zero 
> exception and XFS forced shutdown which I mentioned earlier.  But we 
> also see quite a few smbd processes which are writing data to XFS are
in 
> uninterruptible sleep state and the system locks up too. 

Ok; then the next step is probably to do sysrq-t and see where things
are stuck.  It might be better to see if you can reproduce w/o the
loopback file, too, since that's just another layer to go through that
might be changing things.

<Sagar> I ran it on actual device w/o loopback file and even there
observed that XFS transactions going into uninterruptible sleep state
and the copies were stalled. I had to hard reboot the system to bring
XFS out of that state since soft reboot didn't work, it was waiting for
file system to get unmounted. I shall provide the sysrq-t update later.

> So I thought 
> the test which I am running could be pointing to similar issue which
we 
> are observing on our platform. But does this indicate that the problem

> lies with x86 XFS too ?  

or maybe the vm ...

> Also I presume in enterprise market such kind 
> of simultaneous write situation may happen.  Has anybody reported 
> similar issues to you? As you observed it over x86 and 2.6.24 kernel, 
> could you say what would be root cause of this?

Haven't really seen it before that I recall, and at this point can't say
for sure what it might be.

-Eric

>     Sorry for lots of questions at same time :) But I am happy that
you 
> were able to see the deadlock in x86 on your setup with 2.6.24
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
to
>> chase...
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
failure 
>>>>>> soon. I tried this on
>>>>>> 2 different x86 systems 2 times ( after rebooting the system )
and I 
>>>>>> saw it every time.
>>>>>>     
>>>>>>           
>>>>> Sure.  Is there a reason you're doing this on a loopback file?
That
>>>>> probably stresses the vm a bit more, and might get even trickier
if the
>>>>> loopback file is sparse...
>>>>>   
>>>>>         
>>>> Initially I thought to do that since I didn't want to have a strict

>>>> allocation limit but
>>>> allowing allocations to  grow as needed until the backing
filesystem 
>>>> runs out of free space
>>>> due to type of the test case I had. But then I dropped the plan and

>>>> created a non-sparse
>>>> loopback device. There was no specific reason to create loopback
but 
>>>> as it was
>>>> simplest option to do it.
>>>>       
>>>>> But anyway, on an x86_64 machine with 2G of memory and a
non-sparse 10G
>>>>> loopback file on 2.6.24.7-92.fc8, your test runs w/o problems for
me,
>>>>> though the system does get sluggish.  I let it run a bit then ran
repair
>>>>> and it found no problems, I'll run it overnight to see if anything
else
>>>>> turns up.
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
