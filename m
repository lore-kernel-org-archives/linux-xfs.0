Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B1217F51
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 18:05:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2DFF8F8033
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 16:05:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WiEEeAs3DgIPE69x for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 16:05:47 -0700 (PDT)
Date: Mon, 22 Jun 2015 09:05:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: validate transaction header length on log
	recovery
Message-ID: <20150621230532.GB22807@dastard>
References: <1434631741-50856-1-git-send-email-bfoster@redhat.com>
	<1434631741-50856-3-git-send-email-bfoster@redhat.com>
	<20150621092722.GA7914@infradead.org>
	<20150621202526.GA3955@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150621202526.GA3955@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Jun 21, 2015 at 04:25:29PM -0400, Brian Foster wrote:
> On Sun, Jun 21, 2015 at 02:27:22AM -0700, Christoph Hellwig wrote:
> > This looks sensible to me, but I still can't make sense of the old
> > code which just conditionally copied it even after taking a brief
> > look at the pre-git history of this code.  Does anyone understand why
> > the code was like this?   Fixing code that seems to have had an
> > intention I can't make sense of always feel dangerous.
> > 
> 
> Yeah, I couldn't really make much sense of the original code either. My
> reasoning at the time was that the memcpy() seemed superfluous in this
> case, as we wouldn't add anything to trans->r_itemq and end up doing the
> memcpy() again the next time around.
> 
> Taking another look at other xlog_recover_add_item() callsites, there is
> this in the xlog_recover_add_to_cont_trans() case:
> 
>         if (list_empty(&trans->r_itemq)) {
>                 /* finish copying rest of trans header */
>                 xlog_recover_add_item(&trans->r_itemq);
>                 ptr = (xfs_caddr_t) &trans->r_theader +
>                                 sizeof(xfs_trans_header_t) - len;
>                 memcpy(ptr, dp, len);
>                 return 0;
>         }
> 
> ... which according to the code/comment, seems to imply that the
> transaction header could be split across op records..? I'm not terribly
> familiar with the log on-disk format. Does this sound sane?

Yes. Look at xfs_cil_push, where it formats the transaction header.
It is just another 16 byte vector that is passed to xlog_write so it
gets encapsulated in log opheaders. That means it can be split
across multiple iclogs and log opheaders (i.e. can trigger the
last_was_partial_copy case in xlog_write_setup_copy()).

> If so, perhaps the patch is wrong and we should only bail if the length
> in either of these two cases is obviously invalid (e.g., it exceeds the
> size of the full in-core structure).

The code currently assumes that if the magic number matches, then
the length of the opheader will be in range. It's probably a fair
assumption, as only a software bug in setting the opheader size in
the log write code will cause problems. Other on-disk corruption
(e.g.  bit flips) will be caught by the log buffer CRCs....

However, we should really trigger a corruption if it does exceed
the size of the transaction header. Similarly, we should do the same
check on the other side of the partial trans header copy...

> Perhaps there's also more
> validation that can occur here: can we assert that this should mean
> we're at the end of the operation record in the first short copy
> instance?

Not sure what you mean here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
