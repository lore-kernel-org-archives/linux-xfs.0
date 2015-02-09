Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 725D17F8D
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 07:09:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6137F304032
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 05:09:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2ogLSl4RkCE075xy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 05:09:31 -0800 (PST)
Date: Mon, 9 Feb 2015 08:09:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/2] xfs: pass mp to XFS_WANT_CORRUPTED_*
Message-ID: <20150209130926.GA18336@laptop.bfoster>
References: <54D53E8C.8070207@redhat.com>
 <20150208213502.GA4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150208213502.GA4251@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 09, 2015 at 08:35:02AM +1100, Dave Chinner wrote:
> On Fri, Feb 06, 2015 at 04:22:04PM -0600, Eric Sandeen wrote:
> > These 2 patches provide information about which filesystem
> > hit the error...
> 
> If we are going to touch every one of these macros, then can we
> rename them to something a little shorter like XFS_CORRUPT_GOTO()
> and XFS_CORRUPT_RETURN() at the same time? That will make the code a
> little less eye-bleedy where there are lots of these statements,
> and make formatting of complex checks a bit easier, too...
> 

XFS_CORRUPT_DOSOMETHING() jumps out to me as indicate corruption if the
logic statement evaluates as true rather than false. The latter (e.g.,
assert-like logic) is how they work today, so that could be a bit
confusing to somebody who isn't already familiar with how these macros
work.

Unfortunately, nothing shorter than the current naming immediately comes
to mind... :/ We could kill the XFS_ prefix I suppose or even invert the
logic of the calls, but that's certainly a more significant change.
Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
