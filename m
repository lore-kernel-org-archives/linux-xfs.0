Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EDE167F54
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 11:22:21 -0500 (CDT)
Message-ID: <514C853A.20803@sgi.com>
Date: Fri, 22 Mar 2013 11:22:18 -0500
From: Troy McCorkell <tdm@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/25] xfstests: remove bench infrastructure
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>	<1363350489-22257-3-git-send-email-david@fromorbit.com>	<20130315193635.GA2025@caliban.engr.sgi.com>	<20130319223149.GA17758@dastard>	<20130321235207.GK2025@caliban.engr.sgi.com>
	<20130322073743.GS17758@dastard>
In-Reply-To: <20130322073743.GS17758@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: Phil White <pwhite@sgi.com>

On 03/22/2013 02:37 AM, Dave Chinner wrote:
> On Thu, Mar 21, 2013 at 04:52:07PM -0700, Phil White wrote:
>    
>> On Wed, Mar 20, 2013 at 09:31:49AM +1100, Dave Chinner wrote:
>>      
>>> I understand why you see value in a benchmark infrastructure, but
>>> that's not the issue here. The issue at hand is whether we should be
>>> trying to maintain arbitrary abstractions that are made redundant by
>>> the cleanup patch in the hope they are useful in the future.
>>>
>>> There are solid technical reasons for what I've done, but you
>>> haven't provided any to advocate why we should accept your version
>>> as a better solution. "personal interest" is a good thing to have,
>>> but it's not a convincing technical argument....
>>>        
>> Let me be clear:
>>
>> Personal interest is why I took it upon myself to move this along,
>> rather than letting it moulder away even further than it has while
>> we wait for you to respond to our feedback.
>>      
> /me does a double take
>
> Please don't try to rewrite history.  This patchset has been held up
> by SGI steadfastly refusing to remove the bench infrastructure
> regardless of the technical merits of doing so, not by me failing to
> respond to SGI's feedback.
>
>    
>> It makes me wonder what your motives are.  Did you swear some sort of
>> vendetta against bench and remake?  Is there a blood oath between the
>> houses of Chinner and common?
>>      
> [...]
>
>    
>> It's unnecessary code churn.
>>      
> You're calling this code churn and implying it's driven by zealotry.
> I'd guess this is the first major cleanup you would have seen in the
> XFS code base. We've done many and as a matter of principle they do
> not leave unnecessary cruft behind.  This is the way we improve the
> quality of the code base.
>
> It's not possible to clean up code properly if you don't remove all
> the problematic code and interfces when the opportunity arises.  If
> it turns out we need it in future, then we pull it back out of the
> revision history and use just the bits we need.  We've been through
> this cycle several times before as needs have changed. e.g.  have a
> look at the history of the XFS_ISIZE macro in the kernel code.
>
>    
>> As for my work, there's an advertising slogan which I'm adapting for you
>> here: "One oughtn't post a whine before its time".  I have not posted
>> that work yet.
>>      
> OSS development motto:
>
> "Release early. Release often."
>
>    
>> What I do know is that you're making extra work for us.
>>      
> Other people do development, and they are not going to stop making
> changes just because it "makes extra work for you".  I have to keep
> tens of thousands of lines of patches current at the moment with all
> the CRC changes, but I'm not using that as an excuse to stop other
> people making changes...
>
>    
>> So my choices are simple here:
>> 1) I could give up -- as everyone else has -- and let this linger forever,
>>      
> It won't linger forever - I'm really not that far away from sticking
> a fork in xfstests...
>
>    
>> 2) You could accept that this is a change which you have no real reason to
>>     make, or
>> 3) I can do what I set out to do:  Get this patch series into xfstests and
>>     write extra code to bring my stuff in.
>>
>> The timeframe in which xfstests can move forward in cases 1 or 2 are
>> unacceptable to me.  So I'm going to do 3, review your March 15th series,
>> and move this forward.
>>      
> OK, well lets see how that goes :)
>
> Cheers,
>
> Dave.
>    

As I understood the history, this reorganization has been talked about 
for a long time, and agreed upon at the Linux Filesystem meeting.

Dave did the work to reorganized the tests and posted as a RFC. A couple 
people sent
back rough feedback like "the output from this test ends up in the main 
directory".

SGI wanted to make sure benchmarks are available and easy to use.
Dave said many or all of the benchmarks in xfstests are out of date, he 
even provided examples of better benchmarks.

We all got sucked into other projects until recently Eric pinged  on 
this series because it
will benefit the whole Linux filesystem community.

Phil took over reporting the series, and reposted it to the list. Dave 
reposted the series that
he had with updates.

I thought we all reached a common agreement on the reorganization. We 
all want it. SGI
would like to add benchmarking as a follow-up patch.  Dave wanted to 
make sure that if
done, benchmarking is done correctly. Dave's latest series is more up to 
date. I thought
we were going to do a quick re-review, and get it committed ASAP.

We will complete the review of Dave's second patch set and get it 
committed ASAP.
I expect it will be committed the beginning of next week.

Thank you,
Troy McCorkell
SGI XFS Manager

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
