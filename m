Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A99B7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 01:47:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16B128F8049
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 23:47:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id c9tRJ0ohGpazfoZZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 23:47:37 -0700 (PDT)
Date: Mon, 21 Apr 2014 23:47:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140422064737.GA32026@infradead.org>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-6-git-send-email-david@fromorbit.com>
	<20140421071106.GF20384@infradead.org>
	<20140421233512.GE18672@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140421233512.GE18672@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 09:35:12AM +1000, Dave Chinner wrote:
> > Shouldn't we apply the same scheme as for directories here, that is if
> > it fails with a verifier error re-read without the verifier and then
> > still do the full check as well?
> 
> The directory code is the special case - it uses xfs_trans_read_buf*
> interfaces, which return either a good buffer with no error or an
> error with no buffer. Hence for the directory code, we have to
> re-read the buffer without the verifier to grab the unchecked buffer
> from the cache when the verifier detects an error.

How about just having a variant of xfs_da_read_buf that doesn't use
xfs_trans_read_buf *?  xfs_da_read_buf is pretty simple, especially
when removing the magic test that has been superceeded by the verifiers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
