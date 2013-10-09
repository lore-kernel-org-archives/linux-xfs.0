Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 433CC7FB3
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 19:25:37 -0500 (CDT)
Date: Tue, 8 Oct 2013 19:25:33 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3 0/4] xfs: rework xfs_inactive()
Message-ID: <20131009002533.GZ1935@sgi.com>
References: <1379689572-5543-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379689572-5543-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 20, 2013 at 11:06:08AM -0400, Brian Foster wrote:
> Hi all,
> 
> This set reworks the xfs_inactive() path with the intent to clean up the
> transaction management overall. This is preparation work for the free
> inode btree set and subsequent work in the area. The patches clean up
> the remote symlink work, truncate work and ifree work respectively.
> 
> This passes through a quick xfstests run (with debug and lockdep)
> without any major explosions. Thoughts appreciated.
> 
> Brian

Applied these four.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
