Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jun 2008 10:13:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5GHD8nd020313
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:13:08 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A10BCC72AE
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:14:05 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id sO79sz6ONKwvwmPh for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:14:05 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m5GHDg8Z018049
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:13:42 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m5GHDgrb015226
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2008 10:13:42 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: [PATCH] Always reset btree cursor after an insert
Date: Mon, 16 Jun 2008 10:14:04 -0700
References: <4855CE2D.70505@sgi.com> <20080616050150.GK3700@disturbed> <48560B0B.3060204@sgi.com>
In-Reply-To: <48560B0B.3060204@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161014.04407.dchinner@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sunday 15 June 2008 11:41 pm, Lachlan McIlroy wrote:
> Dave Chinner wrote:
> > On Mon, Jun 16, 2008 at 12:21:33PM +1000, Lachlan McIlroy wrote:
> >> After a btree insert operation a cursor can be invalid due to block
> >> splits and a maybe a new root block.  We reset the cursor in
> >> xfs_bmbt_insert() in the cases where we think we need to but it
> >> isn't enough as we still see assertions.  Just do what we do elsewhere
> >> and reset the cursor unconditionally.
> > 
> > Ok, so you should also kill the new code in the btree insert that
> > revalidates the btree cursor. IIRC, this was the only place it was
> > needed for....
> 
> That was the plan.

Cool. Please include it in the next version of the patch.

> >> +			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> >> +					new->br_startblock, new->br_blockcount,
> >> +					&i)))
> >> 				goto done;
> > 
> > 
> > 			error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> > 					br_startblock, new->br_blockcount, &i);
> > 			if (error)
> > 				goto done;
> > 
> >> -			ASSERT(i == 1);
> >> +			ASSERT(i == 0);
> > 
> > ASSERT? How about a WANT_CORRUPTED_GOTO()?
> 
> I was just being consistent with the rest of the code.  If you think this
> ASSERT should be changed then what about all of them?

Well, the ASSERT means silent failure on a production system.
Given that failure here indicates a corrupt btree, then we really
should be treating it as such. i.e. shut down the filesystem. This
might have saved us a whole heap of trouble tracking down these
problems as a shutdown here would have pointed us right at the
source of the problem...

Cheers,

Dave.
