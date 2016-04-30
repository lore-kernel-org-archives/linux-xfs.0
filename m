Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9D5C7D24
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 19:24:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8473F8F8033
	for <xfs@oss.sgi.com>; Fri, 29 Apr 2016 17:24:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XCHDInGD6ekoBrzl for <xfs@oss.sgi.com>;
	Fri, 29 Apr 2016 17:24:27 -0700 (PDT)
Date: Sat, 30 Apr 2016 10:24:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] scop GFP_NOFS api
Message-ID: <20160430002418.GP26977@dastard>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
	<8737q5ugcx.fsf@notabene.neil.brown.name>
	<20160429120418.GK21977@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160429120418.GK21977@dhcp22.suse.cz>
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
Cc: NeilBrown <mr@neil.brown.name>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, reiserfs-devel@vger.kernel.org, Chris Mason <clm@fb.com>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

On Fri, Apr 29, 2016 at 02:04:18PM +0200, Michal Hocko wrote:
> I would also like to revisit generic inode/dentry shrinker and see
> whether it could be more __GFP_FS friendly. As you say many FS might
> even not depend on some FS internal locks so pushing GFP_FS check down
> the layers might make a lot of sense and allow to clean some [id]cache
> even for __GFP_FS context.

That's precisely my point about passing a context to the shrinker.
It's recursion within a single superblock context that makes up the
majority of cases GFP_NOFS is used for, so passing the superblock
immediately allows for reclaim to run the superblock shrinker on
every other superblock.

We can refine it further from there, but I strongly suspect that
further refinement is going to require filesystems to specifically
configure the superblock shrinker.

e.g. in XFS, we can't allow evict() even on clean VFS inodes in a
PF_FSTRANS context, because we may run a transaction on a clean
VFS inode to prepare it for reclaim.  We can, however,
allow the fs-specific shrinker callouts to run (i.e. call into
.free_cached_objects) so that it can reclaim clean XFS inodes
because that doesn't require transactions....

i.e. the infrastructure I suggested we use is aimed directly at
providing the mechanism required for finer-grained inode/dentry
cache reclaim in contexts that it is currently disallowed
completely. I was also implying that once the infrastructure to pass
contexts is in place, I'd then make the changes to the generic
superblock shrinker code to enable finer grained reclaim and
optimise the XFS shrinkers to make use of it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
