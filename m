Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B8607F3F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 16:47:49 -0600 (CST)
Date: Thu, 5 Dec 2013 16:47:48 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v3] xfs: fix memory leak in xfs_dir2_node_removename
Message-ID: <20131205224748.GP1935@sgi.com>
References: <20131006024850.071924201@sgi.com> <20131204210014.GW1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131204210014.GW1935@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>, Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 04, 2013 at 03:00:14PM -0600, Ben Myers wrote:
> On Sat, Oct 05, 2013 at 09:48:25PM -0500, Mark Tinguely wrote:
> > Fix the leak of kernel memory in xfs_dir2_node_removename()
> > when xfs_dir2_leafn_remove() returns an error code.
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> 
> Looks good.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied this one.  Rich, I think there are xfsprogs bits to go with.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
