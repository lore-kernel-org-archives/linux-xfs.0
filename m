Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95IFJ2I085476 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 13:15:19 -0500
Date: Fri, 5 Oct 2012 14:16:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch v4 04/13] [PATCH 04/13] xfs: sync work is now only
	periodic log work
Message-ID: <20121005181645.GB1056@infradead.org>
References: <20121005171853.985930109@sgi.com>
	<20121005171945.888412779@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121005171945.888412779@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Fri, Oct 05, 2012 at 12:18:57PM -0500, Ben Myers wrote:
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>  	}
>  
> +	xfs_log_work_queue(mp);
> +
>  	return error;

I still think queueing the work item here if we return a failure is
the wrong thing to do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
