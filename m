Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00C817F55
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 17:51:37 -0500 (CDT)
Date: Mon, 9 Sep 2013 17:51:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: check magic numbers in dir3 leaf verifier first
Message-ID: <20130909225137.GS1935@sgi.com>
References: <1378119020-31299-1-git-send-email-david@fromorbit.com>
	<20130903000658.GJ12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130903000658.GJ12779@dastard>
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

On Tue, Sep 03, 2013 at 10:06:58AM +1000, Dave Chinner wrote:
> xfs: check magic numbers in dir3 leaf verifier first
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Calling xfs_dir3_leaf_hdr_from_disk() in a verifier before
> validating the magic numbers in the buffer results in ASSERT
> failures due to mismatching magic numbers when a corruption occurs.
> Seeing as the verifier is supposed to catch the corruption and pass
> it back to the caller, having the verifier assert fail on error
> defeats the purpose of detecting the errors in the first place.
> 
> Check the magic numbers direct from the buffer before decoding the
> header.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Cleaned up the spurious newline and applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
