Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NH9IWK128485 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 12:09:18 -0500
Subject: Re: [PATCH v3] xfs: fix possible overflow in xfs_ioc_trim()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316598150-12447-1-git-send-email-lczerner@redhat.com>
References: <1316598150-12447-1-git-send-email-lczerner@redhat.com>
Date: Fri, 23 Sep 2011 12:08:55 -0500
Message-ID: <1316797735.2879.69.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, 2011-09-21 at 11:42 +0200, Lukas Czerner wrote:
> In xfs_ioc_trim it is possible that computing the last allocation group
> to discard might overflow for big start & len values, because the result
> might be bigger then xfs_agnumber_t which is 32 bit long. Fix this by not
> allowing the start and end block of the range to be beyond the end of the
> file system.
> 
> Note that if the start is beyond the end of the file system we have to
> return -EINVAL, but in the "end" case we have to truncate it to the fs
> size.
> 
> Also introduce "end" variable, rather than using start+len which which
> might be more confusing to get right as this bug shows.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

There are cases where we're (still) not trimming
blocks within the range specified when we could.
I have an idea about how to do that but I'll send
it out later and will commit this as-is.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
