Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8R482d2165213 for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 23:08:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0CAC518652FF
	for <xfs@oss.sgi.com>; Sun, 26 Sep 2010 21:08:58 -0700 (PDT)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id pYdty67fNiFPAZCK for
	<xfs@oss.sgi.com>; Sun, 26 Sep 2010 21:08:58 -0700 (PDT)
Message-ID: <4CA018D9.1030803@sandeen.net>
Date: Sun, 26 Sep 2010 23:08:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Contiguous file sequences
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>	<4C9A6298.106@sandeen.net>
	<AANLkTinz4rYCb8cHH69pYy-oPT-041y+DmVaWm3N_1hu@mail.gmail.com>
In-Reply-To: <AANLkTinz4rYCb8cHH69pYy-oPT-041y+DmVaWm3N_1hu@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Daire Byrne <daire.byrne@gmail.com>
Cc: xfs@oss.sgi.com

Daire Byrne wrote:
> Eric,
> 
> On Wed, Sep 22, 2010 at 9:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> Daire Byrne wrote:
>>> Hi,
>>>
>>> I have been trying to figure out how to lay down a file sequence (e.g.
>>> images) such that they are guaranteed to always be contiguous on disk
>>> (i.e. no block gaps between them).
>> There's no mechanism to guarantee that.
>>
>> Why is this the goal, what are you trying to achieve?
> 
> I am essentially trying to play back a large frame sequence and trying
> to minimise seeks as it can lead to sporadic slowdowns on a SATA based
> RAID.

Ok - and you've really seen allocation patterns that cause the playback
to slow down?  xfs_bmap information for a few sequential files that were
this far off would be interesting to see.

Are you certain that it's seekiness causing the problem?  A great way
to visualize it would be to use the seekwatcher application while you
run a problematic file sequence.

...

>> You can't specify a starting block for any given file I'm afraid.
> 
> Somebody pointed me at this which looks fairly promising:
> 
>   http://oss.sgi.com/archives/xfs/2006-07/msg01005.html

Yeah, that never got merged, but I think it still could be.

It's only half your battle though, you need to find that contiguous
space first, then specify the start block for it with the interface
above.

> I'm still trying to get my head around how I would actually write a
> userspace app/script to use it but I think it should allow me to do
> what I want. It would be good if I could script it through xfs_io. I'd
> really like a script where I could point it at a directory and it
> would do something like:
> 
>   1. count total space used by file sequence
>   2. find start block for that much contiguous space on disk (or as
> much of it as possible)
>   3. allocate the files using the start block one after another on disk
> 
>>> Another option might be to create a single contiguous large file,
>>> concatenate all the images into it and then split it up on disk using
>>> offsets but I don't think such a thing is even possible? I always know
>>> the image sequence size beforehand, all images are exactly the same
>>> size and I can control/freeze the filesystem access if needed.
>>>
>>> Anybody got any suggestions? It *seems* like something that should be
>>> possible and would be useful.
>> This would be pretty low-level control of the allocator by userspace.
>>
>> I'll just go back and ask what problem you're trying to solve?  There
>> may be a better (i.e. currently existing) solution.
> 
> The "realtime" option is sometimes suggested as a way to do sequence
> streaming but I'd really rather avoid that. It seems to me like the
> option to allocate a sequence of files end on end in a known chunk of
> contiguous space is something that would be useful in the normal
> operating mode.

It would be, but it's not there now.  Also, without some more complexity
it'd still probably end up being a best effort rather than a guarantee,
but some hints from userspace might be better than nothing.

-ERic

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
