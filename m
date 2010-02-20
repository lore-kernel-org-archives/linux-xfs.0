Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1KNZukf257487 for <xfs@oss.sgi.com>; Sat, 20 Feb 2010 17:35:56 -0600
Date: Sat, 20 Feb 2010 18:38:04 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/2] commit_metadata export operation v6
Message-ID: <20100220233804.GA15015@fieldses.org>
References: <20100217200426.13409.32688.stgit@case>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217200426.13409.32688.stgit@case>
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

On Wed, Feb 17, 2010 at 02:05:05PM -0600, Ben Myers wrote:
> Hey Bruce,
> 
> Here is the latest version of the knfsd sync changes.  I have addressed the
> suggestions provided by Christoph, Trond, Dave, and Alex.
> 
> In this latest version I have fixed up the few nits in the nfsd patch that
> Christoph pointed out yesterday.  I also have simplified the xfs patch as
> suggested by Dave.

Thanks, applying.

(Do you the second (xfs) patch to go in through the nfsd tree as well,
or should that go in through xfs maintainers after the nfsd merge?)

--b.

> 
> Thanks,
> 	Ben
> ---
> 
> Ben Myers (2):
>       commit_metadata export operation replacing nfsd_sync_dir
>       xfs_export_operations.commit_metadata
> 
> 
>  fs/nfsd/nfs4recover.c         |    4 --
>  fs/nfsd/vfs.c                 |  106 ++++++++++++++++++++---------------------
>  fs/xfs/linux-2.6/xfs_export.c |   20 ++++++++
>  include/linux/exportfs.h      |    5 ++
>  4 files changed, 78 insertions(+), 57 deletions(-)
> 
> -- 
> Signature

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
