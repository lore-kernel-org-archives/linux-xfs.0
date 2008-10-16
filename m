Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 01:59:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G8wnjo004443
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 01:58:51 -0700
Date: Thu, 16 Oct 2008 05:00:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: crash with latest code drop.
Message-ID: <20081016090030.GA31558@infradead.org>
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed> <48F584B8.8060907@sgi.com> <20081015061917.GC25906@disturbed> <48F5A104.5060506@sgi.com> <48F6AA3E.8030902@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F6AA3E.8030902@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On Thu, Oct 16, 2008 at 12:43:10PM +1000, Peter Leckie wrote:
> Adding the following resolved the issue however you may wish to solve it  
> in another manner.
>
> @@ -102,7 +102,7 @@ xfs_sync_inodes_ag(
>                 * in reclaim. Leave it for the reclaim code to flush.
>                 */
>                inode = VFS_I(ip);
> -               if (!igrab(inode)) {
> +               if (!inode || !igrab(inode)) {
>                        read_unlock(&pag->pag_ici_lock);
>                        continue;
>                }
>

This would be the correct fix for the current code, but can you please
put in the Inode/XFS Inode unification patches?  At least I have only
QAed the whole patchkit, and from the issues here it seems like Dave did
the same.

And with that it would also be very good if there was any chance Dave
and me (and all others) could actually access the current tree.  The
ptools -> CVS export has been broken for mor than two days, and there
is no uptodate git tree eiter, so us external developers are completely
tapping in the dark vs the current tree.
