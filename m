Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 19:18:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m772II7p030212
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 19:18:18 -0700
Message-ID: <489A5BB0.9020900@thebarn.com>
Date: Wed, 06 Aug 2008 21:19:28 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: TAKE 981498 - Use KM_NOFS for debug trace buffers
References: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com> <cc7060690808061012x43511581m15c794e72129becc@mail.gmail.com> <20080806201957.GQ21635@disturbed> <20080806202746.GC6119@disturbed> <20080806210355.GS21635@disturbed>
In-Reply-To: <20080806210355.GS21635@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Aug 07, 2008 at 06:27:46AM +1000, Dave Chinner wrote:
>   
>> On Thu, Aug 07, 2008 at 06:19:57AM +1000, Dave Chinner wrote:
>>     
>>> On Wed, Aug 06, 2008 at 10:42:15PM +0530, Bhagi rathi wrote:
>>>       
>>>> I couldn't get a chance to read the diff's completely. If I click on
>>>> Lachlan's url for diff's, I couldn't access them. It looks to me that
>>>> the issue is not just with trace buffers. It can extend to xfs_iformat
>>>> as well. The same dead-lock can spring via
>>>>
>>>> xfs_iread -> xfs_iformat -> xfs_iformat_extents -> xfs_iext_add ->
>>>> xfs_iext_inline_to_direct -> which can do kmem_alloc with
>>>> KM_SLEEP flag.
>>>>         
>>> Fixed already:
>>>
>>>
>>>       
>> Hmmm. where did that url go? Try again:
>>     
>
> Ok, something is stripping URLs out of emails. I just sent that URL
> to myself and it wasn't stripped so it's not my mail infrastructure
> that is doing it.
>
> Did someone "upgrade" the spam filters on oss.sgi.com or the
> barracuda overnight?
>   
not oss
I'm seeing the correct url's BTW
> The link - minus the "http://" bit is:
>
> oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=8c6266658cb76e282c14cb92f8ba5a1c674f4928
>
> let's see if that gets stripped....
>
> Cheers,
>
> Dave.
>   
