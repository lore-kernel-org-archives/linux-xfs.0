Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1370C29DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 17:55:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 004058F804B
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 15:55:19 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	KTMjfUVHN1ykug8F for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 15:55:18 -0700 (PDT)
Date: Wed, 22 May 2013 08:55:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/11] xfs: remote attribute tail zeroing does too much
Message-ID: <20130521225516.GT24543@dastard>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-5-git-send-email-david@fromorbit.com>
	<20130521223109.GN20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130521223109.GN20028@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, May 21, 2013 at 05:31:09PM -0500, Ben Myers wrote:
> On Tue, May 21, 2013 at 06:02:03PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When an attribute data does not fill then entire remote block, we
> > zero the remaining part of the buffer. This, however, needs to take
> > into account that the buffer has a header, and so the offset where
> > zeroing starts and the length of zeroing need to take this into
> > account. Otherwise we end up with zeros over the end of the
> > attribute value when CRCs are enabled.
> > 
> > While there, make sure we only ask to map an extent that covers the
> > remaining range of the attribute, rather than asking every time for
> > the full length of remote data. If the remote attribute blocks are
> > contiguous with other parts of the attribute tree, it will map those
> > blocks as well and we can potentially zero them incorrectly. We can
> > also get buffer size mistmatches when trying to read or remove the
> > remote attribute, and this can lead to not finding the correct
> > buffer when looking it up in cache.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> You fixed the bug I mentioned in the last review.  Beaten.
> 
> This looks ok.  From the looks of things we might consider cleanup of who is
> setting rmtblkcnt in the future.  It is getting to be confusing.

Yes, it is. This exact problem is one of the things my rework of the
attr CRC code later in the series fixes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
