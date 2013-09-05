Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 966287F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 14:57:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7DD488F804B
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 12:57:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Mpku6PTGFjVlufNc for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 12:57:13 -0700 (PDT)
Message-ID: <5228E217.5080002@sandeen.net>
Date: Thu, 05 Sep 2013 14:57:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: defrag support for v5 filesystems
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
	<20130903191201.GL1935@sgi.com> <20130903224542.GH23571@dastard>
	<20130905193428.GP1935@sgi.com>
In-Reply-To: <20130905193428.GP1935@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 9/5/13 2:34 PM, Ben Myers wrote:
> Dave,
> 
> On Wed, Sep 04, 2013 at 08:45:42AM +1000, Dave Chinner wrote:

...

>> If people don't want CRCs, then we've still got a perfectly good v4
>> filesystem format that they can use.
> 
> People can still use v4 filesystem format, but the self describing metadata
> includes checks that have value even without the crc.

Perhaps, but unless there is *value* in turning them off, there is no reason
to do so.  See previous arguments about test matrix etc.

Right now you suggest a different mechanism, but it doesn't actually
exist at this point - at least not for end-to-end metadata integrity.

crcs between hba & storage is a very different thing, and really not
a substitute for xfs's object crcs.  More below

...

>> Guess what we do right now with CRC support?
>>
>> That's right: the existing CRC infrastructure is ready to support
>> integrated, end-to-end T10 CRCs for metadata in the filesystem. All
>> that is missing is the block layer interfaces and a few changes to
>> the CRC code to do iterative per-sector CRCs rather than
>> per-filesystem object CRCs.
> 
> Yes!  This is exactly what I would like to discuss.

...

So if and when that is available, we could discuss whether or not
there is any reason to disable crcs, right?  Until then we're
handwaving with no good rationale.

> 'Fundamentally requires' is not the bar to pass for starting a discussion on
> this list.  Customers will likely want to be able to disable crc32c in metadata
> when they are using an alternate form of data protection.

Which does not exist, not in any similar form.

>  That is enough to go
> on for starting a discussion.  Insofar as supporting such a feature might
> require interface changes to the existing work, I think we should discuss what
> they might look like before finalizing the mkfs.xfs interfaces in a way that we
> might find to be incompatible later.  If after some discussion we find that
> this can be done without interface changes that will gate removal of the
> experimental tag... then it won't gate.

It is incumbent on SGI to explain why they want to make it optional.  
There is no alternative design; if and when there is one, that's the time
to make another configuration knob.

I see 2 possible reasons you would want it to be configurable.  The first
seems least stated but most likely:

1) You have performance concerns.

  - you need to show us the numbers if that's the case so we can discuss facts

2) You think T10dif will make it unnecessary

  - t10dif in hardware gives you EIO, not corruption detection & recovery
  - end-to-end t10dif with xfs at the "app" layer might be an option, but
    - nobody has written that, and
    - the only reason to turn off the object crcs at that point is perf, and
       - again, we'd need to start with performance numbers.

There's been no compelling argument about the need to configure it off
at this stage, so discussion of "gating" is really getting off on the wrong
foot here, IMHO.

If you spot a design decision which would make configurability impossible
later, by all means point it out, but I cannot see what purpose it would
serve to switch it off today, when there is no replacement.  The only good
reason I could see is if it affects performance; if you find that it does,
publish the numbers...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
