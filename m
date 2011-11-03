Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA37AvZp244154 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 02:10:57 -0500
Date: Thu, 3 Nov 2011 03:10:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfsdump: implement lock abstraction with pthreads
Message-ID: <20111103071054.GB10579@infradead.org>
References: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
	<1320268254-20583-4-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320268254-20583-4-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

> +struct qsem {
> +	ix_t qs_count;
> +		/* current count of this semaphore
> +		 */
> +	ix_t qs_waiters;
> +		/* number of threads waiting on semaphore
> +		 */
> +	pthread_mutex_t qs_mutex;
> +	pthread_cond_t qs_cond;
> +};
> +typedef struct  qsem qsem_t;

Can't you use Posix Semaphores directly?

See http://www.csc.villanova.edu/~mdamian/threads/posixsem.html for
a quick introduction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
