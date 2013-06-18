Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14FBF7CBF
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:38:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B12D9AC004
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 14:38:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4hgA8VMDDMUymXGg for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 14:38:12 -0700 (PDT)
Date: Wed, 19 Jun 2013 07:38:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs: fix the symbolic link assert in xfs_ifree
Message-ID: <20130618213810.GY29338@dastard>
References: <20130617203503.472644581@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130617203503.472644581@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 17, 2013 at 03:35:57PM -0500, Mark Tinguely wrote:
> a
> Content-Disposition: inline; filename=v4-xfs-fix-assert-in-xfs_ifree.patch
> 
> Adding an extended attribute to a symbolic link can force that
> link to an remote extent. xfs_inactive() incorrectly assumes
> that any symbolic link small enough to be in the inode core
> is incore, resulting in the remote extent to not be removed.
> xfs_ifree() will assert on presence of this leaked remote extent.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

One minor, minor thing:

> +	if (pathlen < 0 || pathlen > MAXPATHLEN) {
> +		xfs_alert(mp, "%s: inode (%llx) bad symlink length (%d)",

					(0x%llx)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
