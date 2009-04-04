Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n342veXL246209 for <xfs@oss.sgi.com>; Fri, 3 Apr 2009 21:57:50 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0A8C3040C8
	for <xfs@oss.sgi.com>; Fri,  3 Apr 2009 19:57:18 -0700 (PDT)
Message-Id: <60503DAA-7DA4-467C-A21E-B02D61FA9390@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <alpine.DEB.1.10.0904031818270.28893@asgard.lang.hm>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [GIT PULL] XFS update for 2.6.30
Date: Fri, 3 Apr 2009 20:54:55 -0500
References: <20090331053013.7642414167108@attica.americas.sgi.com>
	<BD6F95C9-2F2D-49A3-979C-25018E62E416@sgi.com>
	<alpine.LFD.2.00.0904030952220.4130@localhost.localdomain>
	<alpine.LFD.2.00.0904030954030.4130@localhost.localdomain>
	<8A177E56-84E9-487E-930E-9C6805E17184@sgi.com>
	<alpine.DEB.1.10.0904031818270.28893@asgard.lang.hm>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@lang.hm
Cc: Lachlan McIlroy <lachlan@sgi.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Apr 3, 2009, at 8:19 PM, david@lang.hm wrote:

> On Fri, 3 Apr 2009, Felix Blyakher wrote:
>
>> On Apr 3, 2009, at 12:02 PM, Linus Torvalds wrote:
>>
>>> On Fri, 3 Apr 2009, Linus Torvalds wrote:
>>>> On Thu, 2 Apr 2009, Felix Blyakher wrote:
>>>>> Were there any problems pulling from the xfs repository?
>>>> Sorry, no - just too much email, too many trees to look at, too  
>>>> many
>>>> people to argue with.
>>>> Pulled.
>>> Side note - I almost unpulled afterwards.
>>
>> That was my concern, i.e. it's not pulled without explicit
>> NAK. I knew about your possible concerns.
>>
>>> You've done several apparently totally useless pulls from my tree at
>>> random points.
>>
>> Yes, I noticed that, and agree with all your points even
>> before you brought them up.
>> I already started talking to people to improve my process.
>> The reason the intermediate pulls from your tree were done
>> is to make sure that new xfs patches would not conflict
>> with some other changes already in the mainline. That was
>> part of the maintainer cheat sheet given to me, and I
>> didn't realize the side effects of it.
>> I probably can verify the possible conflicts without pushing
>> the merges into the repository and reset the working tree to
>> pre pull state.
>
> create a temporary branch and do the merge in that. then throw away  
> the test branch and there is no harm to the main tree.

That was suggested among other things by Ingo Molnar as well.
I'm planing to follow this approach.

Thanks,
Felix

>
>
> David Lang
>
>> At any rate, I'll find some way to manage that without
>> cluttering the history with the merges.
>> Any suggestions are welcome.
>>
>> Thanks,
>> Felix
>>
>>> Daily "keep up-to-date with Linus' tree" pulls are _strongly_  
>>> discouraged
>>> (read: if this continues, I'll just stop pulling from you),  
>>> because it
>>> makes the history totally unreadable after-the-fact. It has some  
>>> direct
>>> technical downsides (it makes it much harder to run "git bisect"  
>>> and see
>>> what is going on), but apart from those direct downsides it just  
>>> makes it
>>> much harder for me - or anybody else who wants to get an overview  
>>> of what
>>> happened - to visualize things when history is messy.
>>> Instead of having a clear nice line of development that says "this  
>>> is what
>>> happened to XFS", those merges have basically mixed up all your  
>>> changes
>>> with all the random _other_ changes in the tree.
>>> In other words, having those extra merges makes the graphical  
>>> tools almost
>>> useless for getting some kind of "what happened" overview.
>>> I realize that an occasional back-merge may be required to resolve  
>>> big
>>> conflicts early, but they really have to be pretty big and  
>>> immediate for
>>> it to be a win.
>>>
>>> 			Linus
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
