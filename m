Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NHHJoi129218 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 12:17:20 -0500
Date: Fri, 23 Sep 2011 19:17:07 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3] xfs: fix possible overflow in xfs_ioc_trim()
In-Reply-To: <1316797735.2879.69.camel@doink>
Message-ID: <alpine.LFD.2.00.1109231913400.3806@dhcp-27-109.brq.redhat.com>
References: <1316598150-12447-1-git-send-email-lczerner@redhat.com>
	<1316797735.2879.69.camel@doink>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: hch@infradead.org, Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Fri, 23 Sep 2011, Alex Elder wrote:

> On Wed, 2011-09-21 at 11:42 +0200, Lukas Czerner wrote:
> > In xfs_ioc_trim it is possible that computing the last allocation group
> > to discard might overflow for big start & len values, because the result
> > might be bigger then xfs_agnumber_t which is 32 bit long. Fix this by not
> > allowing the start and end block of the range to be beyond the end of the
> > file system.
> > 
> > Note that if the start is beyond the end of the file system we have to
> > return -EINVAL, but in the "end" case we have to truncate it to the fs
> > size.
> > 
> > Also introduce "end" variable, rather than using start+len which which
> > might be more confusing to get right as this bug shows.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> There are cases where we're (still) not trimming
> blocks within the range specified when we could.
> I have an idea about how to do that but I'll send
> it out later and will commit this as-is.

What cases do you have in mind ? I have actually noticed that you are
discarding even more than user asked for in case that the free extent
and the range to trim overlaps, but that perfectly fine since the
duration of the discard command does not usually depends on the extent
size, so it is good thing to do.

> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
