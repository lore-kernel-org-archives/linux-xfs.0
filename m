Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43382 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750842AbeBVUt2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Feb 2018 15:49:28 -0500
Subject: Re: [ANNOUNCE] xfsprogs v4.15.0-rc1 released
References: <7025bd78-65f9-ad25-e884-cada818a685b@sandeen.net>
 <20180220003635.GA8479@infradead.org>
 <8675595f-abe1-739c-c131-e12737045365@sandeen.net>
 <20180220163347.GB27629@magnolia> <20180220210237.GB7000@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b5f653da-d56d-550f-645c-36da93ba7441@sandeen.net>
Date: Thu, 22 Feb 2018 14:49:27 -0600
MIME-Version: 1.0
In-Reply-To: <20180220210237.GB7000@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>



On 2/20/18 3:02 PM, Dave Chinner wrote:
> On Tue, Feb 20, 2018 at 08:33:47AM -0800, Darrick J. Wong wrote:
>> On Tue, Feb 20, 2018 at 09:09:22AM -0600, Eric Sandeen wrote:
>>> (resend, somehow I keep missing reply-all)
>>>
>>> That would be much faster than at least our historical progression
>>> for new features:
>>>
>>> * Experimental for $LONG_TIME
>>> * Drop experimental for $SIGNIFICANT_TIME
>>> * Make default after that
>>
>> ISTR Dave once telling me that he usually waited ~4 kernel releases to
>> drop the experimental tag and then another year to turn it on by
>> default in mkfs.  I'll grant you that seven kernels went by before
>> EXPERIMENTAL went away, so I don't think we need to wait a whole other
>> year.  How about turning it on by default in July or so?
> 
> The wait time for "supported -> default" is so that distro's have
> time to move to a feature supported kernel before they pick up a new
> xfsprogs release that turns on that feature by default. this mostly
> avoids the problem of distros accidentally turning on a feature that
> is still experimental in their kernel....

Speaking for Fedora, it brings userspace & kernelspace into a distro
together, so that's not a problem.  Speaking for RHEL, it's a long term
distro that knows darned well that mixing and matching new & old requires
care, if it's done at all.

> It also gives us "early adopter" feedback before large numbers of
> unsuspecting users have it enabled for them....

*nod*

>> Speaking of which, hasn't enough time passed to enable spinodes by
>> default in mkfs?  Given the likelihood of worse fragmentation once we
>> add cow into the mix, we probably want that turned on before reflink.
>>
>> Hm.... EXPERIMENTAL was removed for spinodes in July 2016, so that
>> probably could be turned on "now".
> 
> Yup, enough time has passed there.

Uh, ok, 4.16 then?  Maybe not something to do at the very last minute
of 4.15.

>>> My sense is that it's a bit premature, having /just/ dropped the
>>> EXPERIMENTAL tag, which will (in theory) get more people using
>>> it in earnest and maybe shaking out more bugs.
>>>
>>> But I'd like to hear what others think as well.
>>
>> There's already too much new stuff in mkfs 4.15; let's wait for .17
>> because that'll give the more cautious testers more time to find
>> whatever other bugs still lurk. :)
> 
> I think even that is too fast. If distro's want it as the default
> before we set it, then they can patch mkfs themselves.

Again speaking with my own distro maintainer hat on, I hate backporting
fundamental changes in behavior like that.  It's easier on everyone
if xfsprogs version $FOO has a well known, consistent set of features, but -

> If this is really a huge problem for distros, then wasn't this what
> someone wanted mkfs config files for?

Suse folk seem to like that approach, yes.  But while the config
file facilitates that sort of distro approach, it isn't really
a hard requirement, I'd think - patching is always an option
in the end.

-Eric
