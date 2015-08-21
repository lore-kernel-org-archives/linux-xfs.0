Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC65C7F62
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 06:09:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 922ED8F8073
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 04:09:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WTDXylFB2YK4xcGC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 04:09:08 -0700 (PDT)
Date: Fri, 21 Aug 2015 07:09:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: inode lockdep annotations broke non-lockdep build
Message-ID: <20150821110906.GA46372@bfoster.bfoster>
References: <1439979814-18934-1-git-send-email-david@fromorbit.com>
	<20150820113200.GA13033@bfoster.bfoster>
	<20150821004254.GV714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150821004254.GV714@dastard>
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

On Fri, Aug 21, 2015 at 10:42:54AM +1000, Dave Chinner wrote:
> On Thu, Aug 20, 2015 at 07:32:00AM -0400, Brian Foster wrote:
> > On Wed, Aug 19, 2015 at 08:23:34PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
...
> 
> > Perhaps it's best to just use the #define in both cases?
> 
> -#ifdef CONFIG_LOCKDEP
> +#if (defined(DEBUG) || defined(XFS_WARN)) && CONFIG_LOCKDEP
> 
> is how I fixed it.
> 

Sounds good to me.

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
