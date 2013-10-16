Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 74D287F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 16:49:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB5748F8040
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 14:49:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Barf6VckR150RsSe for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 14:49:41 -0700 (PDT)
Date: Thu, 17 Oct 2013 08:49:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests names/numbers
Message-ID: <20131016214938.GJ4446@dastard>
References: <525EBDD1.7070107@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525EBDD1.7070107@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Zach Brown <zab@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 16, 2013 at 11:24:49AM -0500, Eric Sandeen wrote:
> Hey all (probably specifically Dave) - 
> 
> Is there any patch in the works to allow non-numeric test names?
> It'd be nice to get away from the nondescript numbers clashing.

Well, I was kind of waiting for the rest of Lukas' patch that
introduced config sections to be finished and committed before
touching that same code...

> The numeric names "in service of nothing" is making Zach unhappy.
>
> And if Zach ain't happy, ain't nobody happy.  ;)

On the count of 3. 1... 2... 3...

Awwwwww, poor Zach.

:)

> But seriously, I think that was in the works, or in the plan,
> once.  Is there a patch out there somewhere?

There's a bit of infrastructure work to make it a reality - all of
the CLI parsing/validity checks assumes tests are numbered and match
a sepcific regex, as do some of the test list building functions.
That all needs to be reworked, and up until now it hasn't been a
huge priority for me so I haven't started that work yet.

You're more than welcome to hack on it if you want....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
