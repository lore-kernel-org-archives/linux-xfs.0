Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J3A6iM142885 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 22:10:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2A6B7CED2
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 20:10:05 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2Ez0wKZJy7y8qgtu for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 20:10:05 -0700 (PDT)
Date: Mon, 18 Jul 2011 23:10:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] splice: i_mutex vs splice write deadlock
Message-ID: <20110719031003.GA18166@infradead.org>
References: <1310961884-11634-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310961884-11634-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

I don't really like this very much.  Not taking the i_mutex at all
makes the splice_write method in XFS use different locking than
everyone else, and different from the normal XFS write path.

For example ocfs2 which has the same locking issues just has an
own implementation of the splice_write method, which isn't
too nice but at least marginally better.  I think the right
fix for both xfs and ocfs2 would be to have a generic_file_splice_write
variant that takes an "actor" function pointer, which defaults to
a smaller wrapper around file_remove_suid, file_update_time and
splice_from_pipe_feed, and then XFS and ocfs2 can provide their
own actors that add the additional locking.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
