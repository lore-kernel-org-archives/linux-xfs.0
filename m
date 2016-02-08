Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 680F87CA3
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 00:15:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63BD8304048
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 22:15:22 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	M316dpSCxyNC0igT for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 22:15:20 -0800 (PST)
Date: Mon, 8 Feb 2016 17:15:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
Message-ID: <20160208061518.GB27429@dastard>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<20160205010519.GJ459@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160205010519.GJ459@dastard>
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

On Fri, Feb 05, 2016 at 12:05:19PM +1100, Dave Chinner wrote:
> On Thu, Feb 04, 2016 at 03:28:05PM +0100, Jan Kara wrote:
> > Add infrastructure for supporting get_nextdqblk() callback for VFS
> > quotas. Translate the operation into a callback to appropriate
> > filesystem and consequently to quota format callback.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I'm a little confused here. What patchset is this dependent on? i.e.
> what introduces the ->get_nextdqblk method?
> 
> The patches I currently have in my XFS working tree introduce this
> (quota: add new quotactl Q_XGETNEXTQUOTA) and everythign else is
> dependent on this. I looked a coupl eof days ago and I wasnt' able
> to find this in your tree.
> 
> I'd much prefer that one of us publish a stable branch with just the
> quotactl() infrastructure (i.e. commands and bits up to the
> ->get_nextdqblk() callback) that we can then both base the different
> subsystem implementations off, rather than one of us having to pull
> in a whole tree of changes just to get the one commit we need...

Jan, I've posted a stable branch with the quotactl() changes and
the XFS implementation here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-get-next-dquot-4.6

It's currently in the xfs for-next branch for wider testing - I've
done this because I want to get all the pending XFS code out into
for-next land early in this cycle so I can move on and concentrate
on rmap/reflink for the rest of the cycle.

If you want to do this through your tree instead of the XFS tree
then let me know when you publish a branch with quotactl changes in
it so I can rebuild the XFS for-next branch to use that.
Alternatively, i can pull the rest of the generic changes in this
patch set into the branch I already have, so it's all in one place
for ease of testing....

Cheeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
