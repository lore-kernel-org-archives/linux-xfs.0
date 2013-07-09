Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C42977F66
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 15:37:24 -0500 (CDT)
Date: Tue, 9 Jul 2013 15:37:20 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: clean up unused codes at xfs_bulkstat()
Message-ID: <20130709203720.GU20932@sgi.com>
References: <51D18964.2030708@oracle.com>
 <20130702103046.GD14996@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130702103046.GD14996@dastard>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 02, 2013 at 08:30:46PM +1000, Dave Chinner wrote:
> On Mon, Jul 01, 2013 at 09:51:32PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > There are some unused codes at xfs_bulkstat():
> > 
> > - Variable bp is defined to point to the on-disk inode cluster
> >   buffer, but it proved to be of no practical help.
> > 
> > - We process the chunks of good inodes which were fetched by iterating
> >   btree records from an AG.  When processing inodes from each chunk,
> >   the code recomputing agbno if run into the first inode of a cluster,
> >   however, the agbno is not being used thereafter.
> > 
> > This patch tries to clean up those things.
> > 
> > Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
