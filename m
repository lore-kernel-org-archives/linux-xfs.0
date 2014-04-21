Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 470E27F51
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 02:11:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1425AC001
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 00:11:07 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id NRT2rX0FWiDDOAuV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 00:11:06 -0700 (PDT)
Date: Mon, 21 Apr 2014 00:11:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140421071106.GF20384@infradead.org>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-6-git-send-email-david@fromorbit.com>
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

On Tue, Apr 15, 2014 at 06:24:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> repair doesn't currently detect verifier errors in AG header
> blocks - apart from the primary superblock they are not detected.
> They are, fortunately, corrected in the important cases (AGF, AGI
> and AGFL) because these structures are rebuilt in phase 5, but if
> you run xfs_repair in checking mode it won't report them as bad.

Shouldn't we apply the same scheme as for directories here, that is if
it fails with a verifier error re-read without the verifier and then
still do the full check as well?

Btw, it might make sense to have special read_buf variants in libxfs
that always return a valid buffer even if the verifier fails, just
telling us about it without having to re-read.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
