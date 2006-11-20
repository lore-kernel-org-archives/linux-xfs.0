Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Nov 2006 17:40:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAK1edaG017515
	for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 17:40:41 -0800
Message-ID: <45610761.50009@sandeen.net>
Date: Sun, 19 Nov 2006 19:39:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net>	 <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>	 <20061117023946.GN11034@melbourne.sgi.com>	 <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>	 <20061117055521.GS11034@melbourne.sgi.com>	 <52841.10.0.0.2.1163745285.squirrel@sandeen.net>	 <1163746343.4695.152.camel@edge>	 <48064.10.0.0.2.1163776850.squirrel@sandeen.net> <1163977907.4695.157.camel@edge>
In-Reply-To: <1163977907.4695.157.camel@edge>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Nathan Scott wrote:
> On Fri, 2006-11-17 at 09:20 -0600, sandeen@sandeen.net wrote:
>>> On Fri, 2006-11-17 at 00:34 -0600, sandeen@sandeen.net wrote:
>>>> and really, now that this is out in the wild, maybe sb_features3
>>>> instead of padding is appropriate, and check both for the attr2
>>>> bit...? :(
>>> Thats not going to work, theres three or four other feature2 bits
>>> preceding attr2 as well.
>>>
>>> The "take a 32 bit systems fs to a 64 bit system" is relatively
>>> uncommon, so I suppose its just something we live with (as we did
>>> with the log recovery issues in that situation for several years).
>> So you think this should not be fixed, then?  Because if it -is- fixed
> 
> I didn't say that.  It should be fixed.  Noone will notice though,
> as its not actually biting anyone... (the attr2 problem will not
> be related to this, its gonna be something else).

but it can't just be properly padded in the kernel and leave it at that, 
can it?  If so won't attr2 filesystems on x86_64 suddenly start 
appearing to be attr2?

-Eric
