Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37BCA7F7E
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 18:43:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21D268F8035
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 16:43:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id G4dKxzLzZA9eiE4B for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 16:43:31 -0700 (PDT)
Message-ID: <53433821.1080506@sandeen.net>
Date: Mon, 07 Apr 2014 18:43:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 00/19] xfs: remove a bunch of unused function args
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
	<20140407232846.GE27017@dastard>
In-Reply-To: <20140407232846.GE27017@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 4/7/14, 6:28 PM, Dave Chinner wrote:
> On Mon, Apr 07, 2014 at 02:58:47PM -0500, Eric Sandeen wrote:
>> I did some mindless work during a plane ride.  ;)
>>
>> If the granularity of these patches is just too much, I could certainly
>> collapse them into fewer, bigger patches, but I figured that this would
>> make them super-trivial to review.
>>
>> Most have no interesting commit messages aside from the subject, because
>> the subject says it all.
>>
>> Compile-tested only, TBH.
> 
> Looks good, except for the patch I specifically commented on.
> 
> FWIW, this sort of cleanup will help reduce some of the register
> pressure these code paths have, and that in turn will help reduce
> stack usage, so if you can find more...

yep I was thinking along those lines.  I think this is all of them;
more show up w/ GCC warnings but some are for ops that need the superset
of args.  I'll do one more pass to be sure there aren't any knock-on
effects w/ these changes.

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
