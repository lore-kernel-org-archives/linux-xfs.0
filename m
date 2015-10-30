Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 62B587F3F
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 06:39:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CC9030404E
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2015 04:39:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Qcnj97NNo1prDJFE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2015 04:39:53 -0700 (PDT)
Date: Fri, 30 Oct 2015 07:39:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/8] cleanup: get rid of ASSERT
Message-ID: <20151030113950.GA54905@bfoster.bfoster>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
	<1444959901-31319-2-git-send-email-david@fromorbit.com>
	<20151028115121.GA50552@bfoster.bfoster>
	<20151028223234.GQ8773@dastard>
	<20151029121333.GA11663@bfoster.bfoster>
	<20151029222609.GC10656@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151029222609.GC10656@dastard>
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

On Fri, Oct 30, 2015 at 09:26:09AM +1100, Dave Chinner wrote:
> On Thu, Oct 29, 2015 at 08:13:34AM -0400, Brian Foster wrote:
...
> > Then why not try to undef/redef in xfsdump or just rename the #define
> > that's used? I don't care too much either way, I just don't follow why
> > there's a need to change behavior at all to fix a naming conflict.
> > 
> > Are we saying that ASSERT() probably shouldn't exist in userspace (incl.
> > xfsprogs) and we should always use the generic assert() mechanism? Or
> > are we saying ASSERT() can exist in userspace, but it's purely a libxfs
> > thing and should not be exported beyond that (e.g., libxfs can use
> > ASSERT(), actual userspace tools like repair, etc. should eventually use
> > assert())..?
> 
> Precisely this. ASSERT is used in the kernel side libxfs code, and
> so only exists in userspace to support the libxfs code in userspace.
> We don't want the libxfs code in userspace aborting on corrupt
> structures or invalid situations, because we need to
> handle/parse/repair such brokenness. IOWS, the ASSERTs in libxfs/ in
> userspace need to be turned off for userspace to work correctly.
> That's what the DEBUG define in libxfs does.
> 

Indeed.

> That leads to the xfsprogs userspace still needing an assert
> facility - that comes from using assert() and NDEBUG to turn it off
> and on.
> 
> Essentially, ASSERT is internal to libxfs and should not be exported
> anywhere. assert() should used outside libxfs in xfsprogs and other
> XFS code bases.
> 

Makes sense to me. Thanks for the explanation. It would be good if the
commit log description included some of this info. Otherwise, for the
series:

Acked-by: Brian Foster <bfoster@redhat.com>

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
