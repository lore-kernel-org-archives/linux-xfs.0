Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 08:39:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAMGd4aG020168
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 08:39:05 -0800
Message-ID: <45647CF8.8020104@sandeen.net>
Date: Wed, 22 Nov 2006 10:38:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>	 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net>	 <1164157336.19915.43.camel@xenon.msp.redhat.com>	 <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>	 <45647042.2040604@sandeen.net> <1164212695.19915.65.camel@xenon.msp.redhat.com>
In-Reply-To: <1164212695.19915.65.camel@xenon.msp.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Russell Cattelan wrote:
> On Wed, 2006-11-22 at 09:44 -0600, Eric Sandeen wrote:
>> Timothy Shimmin wrote:
>>> Thanks, Russell.
>>>
>>> I've been going thru the irc and just started looking at the patch.
>>> I'll get back to you about it tomorrow.
>>>
>>> I agree it would be good to have the fixed forkoff for data btree roots
>>> as the first fix. And look into redoing the btree root for a later change.
>> My only question is, how much does this defeat the purpose of attr2?
> Well from the standpoint that attr2 currently corrupts inodes anything
> to prevent that is good, since  currently attr2 can't be used at all.
> When the di_u is extent based the attr2 code works as expected, giving
> space to which ever segment gets there first.The attr2 code should still
> be a big win for most file/dir inodes since they are probably able to do
> their block mapping with local or extent mode.

yeah, that;s rpobqably true.

> The number of inodes that get pushed to btree mode should be a small %
> of the
> total number of inodes, especially on a root file system. So while attr2
> is
> not as efficient as it could be for that segment of the inodes the rest
> of inodes
> do benefit from attr2
> 
> By fixing the initial size calculation at least things like SElinux
> which is adding one attr won't cause the attr segment to flip to extents
> immediately.
> The second attr will cause the flip but not the first one.

I'd say this part (fixing up proper space for the initial attr fork 
setup) should probably go in soon if it gets good reviews (with the 
removal of the extra tests, as we discussed on irc last night).  I think 
this proper change stands on its own just fine.

the rest of the patch... I'd rather not confuse the functional changes 
with your rearrangement of return locations (the new gotos etc) but 
that's just me.

I think the bytesfit() fixup is probably good too, with your short-term 
addition of "if forkoff exists with btree data then it cannot move"

-Eric

> 
>> -Eric
>>
