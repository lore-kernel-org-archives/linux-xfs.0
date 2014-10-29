Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95D867F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 08:03:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42192AC007
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 06:03:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uWHHs1Uc83JAjPQs for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 06:03:09 -0700 (PDT)
Message-ID: <5450E58B.10106@sandeen.net>
Date: Wed, 29 Oct 2014 08:03:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS shrinking planned?
References: <544FC202.1000200@shiftmail.org> <544FD4C1.4020004@sandeen.net>
	<5450B560.6000208@shiftmail.org>
In-Reply-To: <5450B560.6000208@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>, xfs@oss.sgi.com

On 10/29/14 4:37 AM, Spelic wrote:
> On 28/10/2014 18:39, Eric Sandeen wrote:
>> Not formally planned, there are bits and pieces out there (i.e. the inode
>> mover) which are part of what it might take to achieve a shrinker.
>>
>> Another option, rather than fs shrinking, is to use the dm-thinp target, which
>> would allow you to allocate a large-but-sparse block device, create a very
>> large filesystem on that, and add or remove storage as needed.
>> (At least I think you can remove it...!)
>>
>> -Eric
> 
> Thanks for your reply Eric
> 
> Interesting technique, but for enforcing a maximum size (smaller than
> the very large allocated thin device) I would have to rely on quotas,
> which probably decreases performance.

"probably"

> Then using thinp would mess up
> all the disk layout, basically replacing the XFS allocator, which
> most likely would decrease performances significantly.

"most likely"

> And then the
> thinp code itself is a medium performance thing and I don't think it
> can keep up with XFS performances, so that would presumably be a hard
> bottleneck.

"presumably"

> All this would result in a performance almost certainly
> lower than ext4.

"almost certainly..."
 
All possibilities, but possibly also worth testing to find out.  ;)
It's true that today the thinp allocator will impact XFS allocation
patterns to some degree.

Anyway, shrink has been on the radar for years, it's just never really
been a priority.  It might happen some day...

-Eric

> Thanks
> S.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
