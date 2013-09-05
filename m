Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 577927F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 15:03:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 362888F804B
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 13:03:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id huosSfTXjJhYNZ0D for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 13:03:22 -0700 (PDT)
Message-ID: <5228E388.3060901@sandeen.net>
Date: Thu, 05 Sep 2013 15:03:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: defrag support for v5 filesystems
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
	<20130903191201.GL1935@sgi.com> <20130903224542.GH23571@dastard>
	<20130905193428.GP1935@sgi.com> <5228E217.5080002@sandeen.net>
In-Reply-To: <5228E217.5080002@sandeen.net>
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

On 9/5/13 2:57 PM, Eric Sandeen wrote:
> On 9/5/13 2:34 PM, Ben Myers wrote:
>> Dave,
>>
>> On Wed, Sep 04, 2013 at 08:45:42AM +1000, Dave Chinner wrote:
> 
> ...
> 
>>> If people don't want CRCs, then we've still got a perfectly good v4
>>> filesystem format that they can use.
>>
>> People can still use v4 filesystem format, but the self describing metadata
>> includes checks that have value even without the crc.
> 
> Perhaps, but unless there is *value* in turning them off, there is no reason
> to do so.  See previous arguments about test matrix etc.
> 
> Right now you suggest a different mechanism, but it doesn't actually
> exist at this point - at least not for end-to-end metadata integrity.
> 
> crcs between hba & storage is a very different thing, and really not
> a substitute for xfs's object crcs.  More below
> 
> ...
> 
>>> Guess what we do right now with CRC support?
>>>
>>> That's right: the existing CRC infrastructure is ready to support
>>> integrated, end-to-end T10 CRCs for metadata in the filesystem. All
>>> that is missing is the block layer interfaces and a few changes to
>>> the CRC code to do iterative per-sector CRCs rather than
>>> per-filesystem object CRCs.
>>
>> Yes!  This is exactly what I would like to discuss.
> 
> ...
> 
> So if and when that is available, we could discuss whether or not
> there is any reason to disable crcs, right?  Until then we're
> handwaving with no good rationale.

In fact, I think we can distill this even further.  Even *with*
t10dif at the HBA level, the only reason I can see to turn off
per-object crcs is performance.

To make that argument, you should publish the performance numbers.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
