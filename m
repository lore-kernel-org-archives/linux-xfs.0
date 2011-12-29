Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBTFfckp015610 for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 09:41:38 -0600
Date: Thu, 29 Dec 2011 09:42:07 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2 v2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111229154207.GK21646@sgi.com>
References: <20111218154936.GA17626@infradead.org>
	<20111218155015.GC17626@infradead.org>
	<20111220200841.GA2788@infradead.org>
	<20111223214703.GW29840@sgi.com> <20111226121302.GE12731@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111226121302.GE12731@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hi Dave,

On Mon, Dec 26, 2011 at 11:13:02PM +1100, Dave Chinner wrote:
> On Fri, Dec 23, 2011 at 03:47:03PM -0600, Ben Myers wrote:
> > 
> > Reviewed-by: Ben Myers <bpm@sgi.com>
> > 
> > Mark also reviewed this.
> > 
> > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> 
> Just a process note here: if Mark reviewed the code and is happy
> with it, then he needs to send his reviewed-by tag himself. If he's
> got concerns, then he needs to discuss them on the list with the
> patch author, not just in private with you. If a person's questions
> are not posted to the mailing list or posted by proxy and they
> didn't aprticipate in discussions on the list, then there is no
> evidence that the person ever reviewed the patch. Hence the tag has
> no value because it is not verifiable.

I tend to agree that it is important to discuss things openly on the
list.  Will make an effort to do more of this.

> More importantly, tags are a semi-formal statement that a set of
> actions has been taken by that person - see
> Documentation/SubmittingPatches for the actions different tags
> imply. Hence it is important the actions they imply are verifiable,
> and it also reinforces the fact that they only have value when they
> are issued by the email address (or a known alias) in the tag....

I don't see anything in SubmittingPatches that says the address on the
>From line not matching a tag is a dealbreaker, and I think that we
should give credit where it is due.  Mark did some work to review and
understand this code in addition to his testing.  I have him a call and
asked him if I could add a 'Reviewed-by' to his 'Tested-by' because I
was suprised he didn't... Next time I'll ask him to send it himself.

I'd like to point out that plenty of the conversation surrounding this
pair of patches seems not to have made it to the list either.   

Anyway... SGI folk will try to keep discussion on the list or on irc
next time.

Folks from umich:  if you offer a 'Tested-by' we'll add that too.

Thanks,
	Ben

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
