Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q81NMnBS196693 for <xfs@oss.sgi.com>; Sat, 1 Sep 2012 18:22:49 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Fj9bQpFhYD7w50ff (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 01 Sep 2012 16:23:44 -0700 (PDT)
Date: Sat, 1 Sep 2012 19:23:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/13] xfs: sync work is now only periodic log work
Message-ID: <20120901232343.GA31634@infradead.org>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346328017-2795-6-git-send-email-david@fromorbit.com>
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

On Thu, Aug 30, 2012 at 10:00:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The only thing the periodic sync work does now is flush the AIL and
> idle the log. These are really functions of the log code, so move
> the work to xfs_log.c and rename it appropriately.
> 
> The only wart that this leaves behind is the xfssyncd_centisecs
> sysctl, otherwise the xfssyncd is dead. Clean up any comments that
> related to xfssyncd to reflect it's passing.

FYI: A while ago I looked into folding the work here into xfsaild.
While soing the periodic ail push there aka just waking up with a
timeout which we did more often anyway at that point was easy, getting
the log force / dummy log never really worked out.

I think at least the former probably should be dropped here as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
