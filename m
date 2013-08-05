Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D01E87CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 16:59:44 -0500 (CDT)
Date: Mon, 5 Aug 2013 16:59:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 07/12] xfs: remote attribute tail zeroing does too much
Message-ID: <20130805215943.GD3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-8-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:24:56PM +1000, Dave Chinner wrote:
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

Goes with commit 4af3644c9a53eb2f1ecf69cc53576561b64be4c6

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
