Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 442F429DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 16:53:54 -0500 (CDT)
Date: Mon, 17 Jun 2013 16:53:53 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: return FIEMAP_EXTENT_UNKNOWN for delayed
	allocation extent
Message-ID: <20130617215353.GF20932@sgi.com>
References: <51B08D71.7090404@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51B08D71.7090404@oracle.com>
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
Cc: xfs@oss.sgi.com

Hey Jeff,

On Thu, Jun 06, 2013 at 06:24:01AM -0700, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> For FIEMAP ioctl(2), if an extent is in delayed allocation
> state, we need to return the FIEMAP_EXTENT_UNKNOWN flag except
> the FIEMAP_EXTENT_DELALLOC because its data location is unknown.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Looks fine.  Is there an email thread I can reference?

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
