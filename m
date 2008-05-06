Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 14:21:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m46LLGIr025063
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 14:21:22 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E832616513AF
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 14:22:00 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id Y48tkLKCedjasZ66 for <xfs@oss.sgi.com>; Tue, 06 May 2008 14:22:00 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m46LLYww008265
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 14:21:34 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m46LLYiA023790
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 14:21:34 -0700
Message-ID: <4820CBF5.8090206@agami.com>
Date: Tue, 06 May 2008 14:21:57 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: question about xfs_alloc_fix_freelist()
References: <20080504235048.GC155679365@sgi.com>
In-Reply-To: <20080504235048.GC155679365@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com



David Chinner wrote:
> On Fri, May 02, 2008 at 02:01:47PM -0700, Michael Nishimoto wrote:
>  >
>  > The following code can be found near the end of xfs_alloc_fix_freelist:
>  >
>  >                 if (targs.agbno == NULLAGBLOCK) {
>  >                         if (flags & XFS_ALLOC_FLAG_FREEING)
>  >                                 break;
>  >                         xfs_trans_brelse(tp, agflbp);
>  >                         args->agbp = NULL;
>  >                         return 0;
>  >                 }
>  >
>  > Don't we need to release agbp too by calling xfs_trans_brelse(tp, agbp)?
> 
> I don't think so. AFAICT, The agbp (agf block) is linked into the
> transaction and by this point we may have modified the AGF (think
> multiple iterations of the loop to fill the free list). Given that
> it may be modified, we shouldn't release it here but instead allow
> the transaction commit/abort to do that for us at the appropriate
> time.
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group

I understood that the transaction abort code will free resources/locks
when passing back an error.  However, by returning args->agbp = NULL,
aren't we telling the calling code that we have not satisfied the request
in the current AG?

I do see the part of about the AGF possibly getting modified.

It would help to have a clear comment description of possible inputs vs.
expected outputs for this function. :-)

    thanks,

        Michael
