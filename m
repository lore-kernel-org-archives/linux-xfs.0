Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76B817F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 02:23:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 466828F8035
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 00:23:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nDGsjJDnPS7Ia18H for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 00:23:13 -0700 (PDT)
Date: Mon, 23 Mar 2015 18:23:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use GFP_NOFS argument in radix_tree_preload
Message-ID: <20150323072309.GP28621@dastard>
References: <1427087183-20391-1-git-send-email-sanidhya.gatech@gmail.com>
	<20150323052449.GO28621@dastard> <20150323053715.GK5170@taesoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150323053715.GK5170@taesoo.org>
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
To: Taesoo Kim <taesoo@gatech.edu>
Cc: sanidhya@gatech.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, blee@gatech.edu, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, csong84@gatech.edu, changwoo@gatech.edu

On Mon, Mar 23, 2015 at 01:37:15AM -0400, Taesoo Kim wrote:
> Hi Dave,
> 
> Thank you for letting us know. Since we are not an expert of XFS (nor
> want to be), we really want to let you guys know it's potential bug
> that you might miss (we are helping you!). And that's why Sanidhya
> asked (rather than sending a patch) at the first place.

The point of sending patches is that it's the best way to ask
questions about the code because it first requires the patch
submitter to think about the change and to document the reasons for
making it. Many, many questions are answered in the process of
making a change and writing a decent commit message.

And, with it in patch format, if the change and reasoning is good, I
can just commit it and move on.

> I agree that the comment is misleading and not correct, but probably
> encouraging a student who spend times to clean up your mistake
> might be better way to influence him rather than shouting :)

I think you've taken what I said the wrong way - I'm not sure
how much more constructive I can be:

> > So while the change probably needs to be made, it needs to be made
> > for the right reasons. I haven't looked at the code, but I have
> > a pretty good idea of the context the allocation is being made
> > under. I'd suggest documenting the call path down to
> > xfs_mru_cache_insert(), because that will tell you exactly what
> > context the allocaiton is being made in and hence tell everyone else
> > the real reason we need to make this change...

What I've described is exactly how one goes about finding out
whether the allocation context is correct or not, for any allocation
in the kernel.  Following the rules and techniques I outlined, it
takes me less than 15s with cscope to work out whether the code in
the patch is correct or not.

However, fixing the commit message myself doesn't result in the
patch submitter learning what they've done wrong or how to improve
the work they've submitted.  Fixing it myself is the easy option -
it takes me far longer to write an email explaining how to validate
the change the right way and document it.

However, even though it costs me more time in the short term, I'd
much prefer that people learn how to do things the right way because
it means I don't end up having to answer the same question for every
suspect allocation or fix up the same mistakes in patches over and
over again.

To further demonstrate I am trying to help, here's exactly what I'd
be putting in a commit message explaining the change using methods
regularly used by kernel developers to demonstrate context and
errors. This is off the top of my head, so the call chain may not be
100% correct, but a commit message I would write for such change is
along these lines:

----
xfs: xfs_mru_cache_insert() should use GFP_NOFS

xfs_mru_cache_insert() can be called from within transaction context
during block allocation like so:

write(2)
  ....
    xfs_get_blocks
      xfs_iomap_write_direct
	start transaction
	xfs_bmapi_write
	  xfs_bmapi_allocate
	    xfs_bmap_btalloc
	      xfs_bmap_btalloc_filestreams
		xfs_filestream_new_ag
		  xfs_filestream_pick_ag
		    xfs_mru_cache_insert
		      radix_tree_preload(GFP_KERNEL)

In this case, GFP_KERNEL is incorrect and can potentially lead to
deadlocks in memory reclaim. It should use GFP_NOFS allocations to
avoid lock recursion problems.

Signed-off-by....
-----

i.e. explain the bug being fixed, not the convention used to find
it.  That's what I meant when I said "make the change for the right
reasons".

This is whay commit messages are important - they explain *why* the
code was changed. Hence the code review process is not just about
the code - the reviewers need to understand why the code
is being changed and the process that lead to the
change being proposed. The commit history is going to be the only
record of why this code exists in 10 years time, so the explanation
needs to be correct....

FWIW, if you want more background on what I'm trying to explain, I
highly recommend watching my recent LCA 2015 talk:

https://www.youtube.com/watch?v=VpuVDfSXs-g

i.e. code review is a key knowledge transfer mechanism in software
engineering....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
