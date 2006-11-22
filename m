Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 00:58:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAM8w2aG005540
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 00:58:05 -0800
Date: Wed, 22 Nov 2006 19:59:22 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <1164157336.19915.43.camel@xenon.msp.redhat.com>
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>	
 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net>
 <1164157336.19915.43.camel@xenon.msp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Thanks, Russell.

I've been going thru the irc and just started looking at the patch.
I'll get back to you about it tomorrow.

I agree it would be good to have the fixed forkoff for data btree roots
as the first fix. And look into redoing the btree root for a later change.

Cheers,
Tim.

--On 21 November 2006 7:02:16 PM -0600 Russell Cattelan <cattelan@thebarn.com> wrote:

> On Mon, 2006-11-20 at 22:02 -0600, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>
>> > Eric Sandeen wrote:
>> >
>> >> ugh.  it's broken on x86 too, so it's not just the alignment/padding,
>> >>
>> >> although that should be fixed for cross-arch mounts.
>> >>
>> >> -Eric
>> >>
>> >>
>> > here's a testcase to corrupt it FWIW.
>> >
>> >
>> Ok, with expert collaboration from Russell, Barry, Tim,
>> Nathan, David, et al, how about this:
>>
>> For btree dirs, we need a different calculation for the space
>> used in di_u, to set the minimum threshold for the fork offset...
>>
>> This fixes my testcase, but as Tim points out -now- we need to compact
>> the btree ptrs, if we return (and use) an offset < current forkoff...
>>
>> whee....
>>
>> -Eric
>>
> It turns out this only fixes one of the problems it is still quite easy
> to corrupt indoes with attr2.
>
> The following patch is a short term fix that address the problem of
> forkoff
> moving without re-factoring the root inode btree root block.
>
> Once the inode has be flipped to BTREE for the data space the forkoff is
> fixed
> to the that size, currently due to the way attr1 worked (fixed size
> forkoff) the code is not handling the size to the root btree node due to
> size changes in the attr portion of the inode.
>
> The optimal solution is to adjust the data portion of the inode root
> btree block down if space exists.
>
> One easy fix that was resulting all attr add being pushed out of line is
> added
> the header size to the initial split of the inode, at least the first
> attr add
> should go inline now. Which should be a win the big attr user right now
> SElinux.
>
> Including the 2 test script that have been used.
>
>
>
> --
> Russell Cattelan <cattelan@thebarn.com>
