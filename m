Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D98BE7CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:06:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68F38AC001
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:06:44 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AWocz4Pw8XWuCWOi for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:06:41 -0800 (PST)
Date: Fri, 5 Feb 2016 12:05:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
Message-ID: <20160205010519.GJ459@dastard>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454596087-6814-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Thu, Feb 04, 2016 at 03:28:05PM +0100, Jan Kara wrote:
> Add infrastructure for supporting get_nextdqblk() callback for VFS
> quotas. Translate the operation into a callback to appropriate
> filesystem and consequently to quota format callback.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I'm a little confused here. What patchset is this dependent on? i.e.
what introduces the ->get_nextdqblk method?

The patches I currently have in my XFS working tree introduce this
(quota: add new quotactl Q_XGETNEXTQUOTA) and everythign else is
dependent on this. I looked a coupl eof days ago and I wasnt' able
to find this in your tree.

I'd much prefer that one of us publish a stable branch with just the
quotactl() infrastructure (i.e. commands and bits up to the
->get_nextdqblk() callback) that we can then both base the different
subsystem implementations off, rather than one of us having to pull
in a whole tree of changes just to get the one commit we need...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
