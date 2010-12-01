Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1CXBuw206973 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 06:33:11 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4CE01BA235
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 04:34:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id h6qe7ggXkOvHDQtY for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 04:34:54 -0800 (PST)
Date: Wed, 1 Dec 2010 07:34:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/14] xfs: use wait queues directly for log grant queues
Message-ID: <20101201123454.GA612@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-5-git-send-email-david@fromorbit.com>
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

On Mon, Nov 29, 2010 at 12:38:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The log grant queues are one of the few places left using sv_t
> constructs for waiting. Convert them to use wait queues directly
> while we are cleaning up the code to move one step closer to remove
> the sv_t type from the XFS codebase.

Doing this one separately from the other sv_t removal seems a bit
pointless.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
