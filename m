Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKBl3aN117306 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:47:03 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0253D20E0E1
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:49:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bIGFyKVd4iV18PGS for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:49:00 -0800 (PST)
Date: Mon, 20 Dec 2010 06:49:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/12] xfs: introduce new locks for the log grant ticket
	wait queues
Message-ID: <20101220114900.GF12806@infradead.org>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
	<1292215483-18224-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292215483-18224-11-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 13, 2010 at 03:44:41PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The log grant ticket wait queues are currently protected by the log
> grant lock.  However, the queues are functionally independent from
> each other, and operations on them only require serialisation
> against other queue operations now that all of the other log
> variables they use are atomic values.
> 
> Hence, we can make them independent of the grant lock by introducing
> new locks just to protect the lists operations. because the lists
> are independent, we can use a lock per list and ensure that reserve
> and write head queuing do not contend.
> 
> To ensure forced shutdowns work correctly in conjunction with the
> new fast paths, ensure that we check whether the log has been shut
> down in the grant functions once we hold the relevant spin locks but
> before we go to sleep. This is needed to co-ordinate correctly with
> the wakeups that are issued on the ticket queues so we don't leave
> any processes sleeping on the queues during a shutdown.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
