Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04E697F4E
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 02:08:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEECE8F8049
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 00:08:25 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HaVvdL0GKbdePLAz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 00:08:25 -0700 (PDT)
Date: Mon, 21 Apr 2014 00:08:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] repair: detect and correct CRC errors in directory
	blocks
Message-ID: <20140421070824.GE20384@infradead.org>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-5-git-send-email-david@fromorbit.com>
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

On Tue, Apr 15, 2014 at 06:24:56PM +1000, Dave Chinner wrote:
> + * Need to handle CRC and validation errors specially here. If
> + * there is a validator error, re-read without the verifier so
> + * that we get a buffer we can check and repair. Re-attach the
> + * ops to the buffer after the read so that when it is rewritten
> + * the CRC is recalculated.
> + *
> + * Returns a positive error on failure, 0 for success, and negative
> + * error if a verifier error occurred and we reread the block without
> + * the verifier successfully.

This comment doesn't come clear to using up the 80 character allowance
:)

I have to say the positive and negative errno convention is a bit
confusing to me.  I'd rather always return 0 if we could read it, and
pass a bool *crc_error instead that indicates if it needs fixing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
