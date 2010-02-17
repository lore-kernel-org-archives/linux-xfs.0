Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H2bp57199183 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 20:37:52 -0600
Date: Tue, 16 Feb 2010 21:39:48 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/2] commit_metadata export operation v5
Message-ID: <20100217023948.GB32315@fieldses.org>
References: <20100216210026.5694.14423.stgit@case>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100216210026.5694.14423.stgit@case>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 16, 2010 at 03:04:08PM -0600, Ben Myers wrote:
> Here is the latest version of the knfsd sync changes that I've been spamming
> you with.

Don't worry about spamming--it's good that people have lots of comments!

--b.

> I have addressed the latest suggestions provided by Christoph,
> Trond, Dave, and Alex.  This version of the commit_metadata export operation
> takes only one inode as suggested by Christoph and it turns out to be much
> cleaner this way.  Now we've gone back to committing all of the time in
> nfsd_create_setattr and don't bother with the added argument.  A couple extra
> comments to explain the commit ordering.
> 
> Thanks,
> Ben
> 
> ---
> 
> Ben Myers (2):
>       commit_metadata export operation replacing nfsd_sync_dir
>       xfs_export_operations.commit_metadata
> 
> 
>  fs/nfsd/nfs4recover.c         |    4 --
>  fs/nfsd/vfs.c                 |  109 ++++++++++++++++++++---------------------
>  fs/xfs/linux-2.6/xfs_export.c |   24 +++++++++
>  include/linux/exportfs.h      |    5 ++
>  4 files changed, 83 insertions(+), 59 deletions(-)
> 
> -- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
