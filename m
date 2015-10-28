Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7157E7F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 20:00:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4FABA8F8040
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 18:00:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	C8AXLg8gWYh8J6io for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 18:00:23 -0700 (PDT)
Date: Wed, 28 Oct 2015 11:59:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: implement 'inode' command V3
Message-ID: <20151028005924.GP19199@dastard>
References: <1445257880-30797-1-git-send-email-cmaiolino@redhat.com>
	<20151022144255.GB13661@bfoster.bfoster>
	<20151023092946.GA752@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151023092946.GA752@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Oct 23, 2015 at 11:29:46AM +0200, Carlos Maiolino wrote:
> Thanks for the review Brian, I'll walk over it and fix the points you mentioned.
> > 
> > 
> > I still don't really get why we have separate -l and -s options here. It
> > seems to me that the behavior of -l already gives us the information
> > that -s does. Even if that's not obvious enough, the -l command could
> > just print out both. For example:
> > 
> >       "Largest inode: 1234 (32-bit)"
> 
> I agree with you here, but, I'll let Dave answer this question, maybe he had 
> some another idea for it that I'm not aware of. 

No preference here; all that I was suggesting was that if you want
to know whether inodes are 32/64 bit it doesn't matter what the
largest inode number is.

i.e. "Can I mount this with inode32 and have no problems (yes/no)?"

And it's a lot easier to just query for *any* 64 bit inode than it
is to find the largest inode number...

If you want to combine the two, then that's fine by me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
