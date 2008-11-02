Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 14:51:48 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA2MpYgB029638
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 14:51:34 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD7437B04F6
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 14:51:35 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id gLuGdjLB6z3MBckq for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 14:51:35 -0800 (PST)
Date: Mon, 3 Nov 2008 09:51:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] XFS: fix error inversion problems with data
	flushing
Message-ID: <20081102225133.GI19509@disturbed>
References: <1225415729-26514-1-git-send-email-david@fromorbit.com> <1225415729-26514-2-git-send-email-david@fromorbit.com> <20081031201830.GA20309@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031201830.GA20309@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Oct 31, 2008 at 04:18:30PM -0400, Christoph Hellwig wrote:
> On Fri, Oct 31, 2008 at 12:15:25PM +1100, Dave Chinner wrote:
> > XFS gets the sign of the error wrong in several places when
> > gathering the error from generic linux functions. These functions
> > return negative error values, while the core XFS code returns
> > positive error values. Hence when XFS inverts the error to be
> > returned to the VFS, it can incorrectly invert a negative
> > error and this error will be ignored by the syscall return.
> > 
> > Fix all the problems related to calling filemap_* functions.
> > 
> > Problem initially identified by Nick Piggin in xfs_fsync().
> 
> But this patch is a little more than just the error code inversions..

Yes, that's the point of the patch - we get it wrong in many
places and this fixes them so that correctly signed error values
are returned to the higher layers....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
