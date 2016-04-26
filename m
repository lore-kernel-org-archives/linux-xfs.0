Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E93B7CF8
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 17:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4DABB304039
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2016 15:59:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PxKEXjtYdtUYvHaV for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2016 15:59:37 -0700 (PDT)
Date: Wed, 27 Apr 2016 08:58:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mm, debug: report when GFP_NO{FS,IO} is used
	explicitly from memalloc_no{fs,io}_{save,restore} context
Message-ID: <20160426225845.GF26977@dastard>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
	<1461671772-1269-3-git-send-email-mhocko@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461671772-1269-3-git-send-email-mhocko@kernel.org>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

On Tue, Apr 26, 2016 at 01:56:12PM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> THIS PATCH IS FOR TESTING ONLY AND NOT MEANT TO HIT LINUS TREE
> 
> It is desirable to reduce the direct GFP_NO{FS,IO} usage at minimum and
> prefer scope usage defined by memalloc_no{fs,io}_{save,restore} API.
> 
> Let's help this process and add a debugging tool to catch when an
> explicit allocation request for GFP_NO{FS,IO} is done from the scope
> context. The printed stacktrace should help to identify the caller
> and evaluate whether it can be changed to use a wider context or whether
> it is called from another potentially dangerous context which needs
> a scope protection as well.

You're going to get a large number of these from XFS. There are call
paths in XFs that get called both inside and outside transaction
context, and many of them are marked with GFP_NOFS to prevent issues
that have cropped up in the past.

Often these are to silence lockdep warnings (e.g. commit b17cb36
("xfs: fix missing KM_NOFS tags to keep lockdep happy")) because
lockdep gets very unhappy about the same functions being called with
different reclaim contexts. e.g.  directory block mapping might
occur from readdir (no transaction context) or within transactions
(create/unlink). hence paths like this are tagged with GFP_NOFS to
stop lockdep emitting false positive warnings....

Removing the GFP_NOFS flags in situations like this is simply going
to restart the flood of false positive lockdep warnings we've
silenced over the years, so perhaps lockdep needs to be made smarter
as well...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
