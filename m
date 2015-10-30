Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF9A47F52
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 07:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E423AC002
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 05:37:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id W2BGXFK2yinHvVPZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 05:37:06 -0700 (PDT)
Date: Fri, 30 Oct 2015 08:37:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: DAX does not use IO completion callbacks
Message-ID: <20151030123704.GD54905@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-5-git-send-email-david@fromorbit.com>
	<20151029142957.GF11663@bfoster.bfoster>
	<20151029233911.GT19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151029233911.GT19199@dastard>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Fri, Oct 30, 2015 at 10:39:11AM +1100, Dave Chinner wrote:
> On Thu, Oct 29, 2015 at 10:29:57AM -0400, Brian Foster wrote:
> > On Mon, Oct 19, 2015 at 02:27:16PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > For DAX, we are now doing block zeroing and
> > > we are updating the file size during allocation. This means we no
> > > longer need an IO completion callback to do these things, so remove
> > > the completion callbacks from the __dax_fault and __dax_mkwrite
> > > calls.
> > > 
> > 
> > Where do we "update the file size during allocation?"
> 
> Stale comment. For page faults, we'll never update the file size
> (segv if fault is beyond EOF), and DIO still does IO completion
> based file size updates.
> 

Ok. With that fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
