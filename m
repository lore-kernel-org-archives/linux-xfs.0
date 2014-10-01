Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D06F77F6B
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 18:21:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7EBC8AC003
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 16:21:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EcUYBRECH6iwusBU for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 16:21:40 -0700 (PDT)
Date: Thu, 2 Oct 2014 09:21:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: only set extent size hint when asked
Message-ID: <20141001232126.GE10298@dastard>
References: <1412041565-18873-1-git-send-email-david@fromorbit.com>
	<1412041565-18873-3-git-send-email-david@fromorbit.com>
	<20141001115959.GB53779@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141001115959.GB53779@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: iusty@k1024.org, xfs@oss.sgi.com

On Wed, Oct 01, 2014 at 07:59:59AM -0400, Brian Foster wrote:
> On Tue, Sep 30, 2014 at 11:46:05AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently the extent size hint is set unconditionally in
> > xfs_ioctl_setattr(), even when the FSX_EXTSIZE flag is not set. This
> > means we can set values from uninitialised stack variables. Hence
> > only set the extent size hint from userspace when both the mask
> > falg is set and the inode has the XFS_DIFLAG_EXTSIZE flag set to
> > indicate that we should have an extent size hint set on the inode.
> > 
> 
> I'm not sure what you mean here by FSX_EXTSIZE not being checked. It
> looks like FSX_EXTSIZE is checked before and after the patch.

Yup, I wrote the commit message, then did the fix and forgot to
update the message after I realised it was wrong. I've fixed the
commit message.

> Regardless, the fix looks Ok to me...
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
