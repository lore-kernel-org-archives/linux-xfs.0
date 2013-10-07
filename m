Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C8117F37
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 15:38:39 -0500 (CDT)
Date: Mon, 7 Oct 2013 15:38:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: RESEND: xattr issue with 3.11 kernel
Message-ID: <20131007203835.GY1935@sgi.com>
References: <ED5C1C84-614E-4EBB-A966-BBCD9CE89373@inktank.com>
	<20131004210411.GJ4446@dastard>
	<6ECC8063-935A-4DD6-A460-4B7D8AE24271@inktank.com>
	<20131005032112.GM4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131005032112.GM4446@dastard>
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
Cc: David Zafman <david.zafman@inktank.com>, ceph-devel@vger.kernel.org, xfs@oss.sgi.com

Hi Dave & Dave,

On Sat, Oct 05, 2013 at 01:21:12PM +1000, Dave Chinner wrote:
> On Fri, Oct 04, 2013 at 03:16:05PM -0700, David Zafman wrote:
> > 
> > Dave,
> > 
> > The 3.12-rc3 kernel passed my test.  Thanks for the quick response.
> 
> Good to hear.
> 
> ....
> 
> > > You are probably hitting the problem fixed in commit 997def2 ("xfs:
> > > fix node forward in xfs_node_toosmall") which went into 3.12-rc3.
> > > Can you test that this fixes your problem, ad if so, we'll need to
> > > push it back to -stable kernels..
> 
> Ben, can you push this fix back to the -stable kernels
> that require it?

Sure.  IIRC it needs to go back to 3.10, but I'll double check...

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
