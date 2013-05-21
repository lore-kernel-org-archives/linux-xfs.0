Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED5D929DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:31:12 -0500 (CDT)
Date: Tue, 21 May 2013 17:31:09 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 04/11] xfs: remote attribute tail zeroing does too much
Message-ID: <20130521223109.GN20028@sgi.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369123330-9579-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 06:02:03PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When an attribute data does not fill then entire remote block, we
> zero the remaining part of the buffer. This, however, needs to take
> into account that the buffer has a header, and so the offset where
> zeroing starts and the length of zeroing need to take this into
> account. Otherwise we end up with zeros over the end of the
> attribute value when CRCs are enabled.
> 
> While there, make sure we only ask to map an extent that covers the
> remaining range of the attribute, rather than asking every time for
> the full length of remote data. If the remote attribute blocks are
> contiguous with other parts of the attribute tree, it will map those
> blocks as well and we can potentially zero them incorrectly. We can
> also get buffer size mistmatches when trying to read or remove the
> remote attribute, and this can lead to not finding the correct
> buffer when looking it up in cache.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

You fixed the bug I mentioned in the last review.  Beaten.

This looks ok.  From the looks of things we might consider cleanup of who is
setting rmtblkcnt in the future.  It is getting to be confusing.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
