Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A31029E12
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 15:55:07 -0600 (CST)
Date: Wed, 4 Dec 2013 15:55:06 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: don't  perform discard if the given range length
	is less than block size
Message-ID: <20131204215506.GC1935@sgi.com>
References: <528C6E15.3030801@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528C6E15.3030801@oracle.com>
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

On Wed, Nov 20, 2013 at 04:08:53PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> For discard operation, we should return EINVAL if the given range length
> is less than a block size, otherwise it will go through the file system
> to discard data blocks as the end range might be evaluated to -1, e.g,
> # fstrim -v -o 0 -l 100 /xfs7
> /xfs7: 9811378176 bytes were trimmed
> 
> This issue can be triggered via xfstests/generic/288.
> 
> Also, it seems to get the request queue pointer via bdev_get_queue()
> instead of the hard code pointer dereference is not a bad thing.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>

Applied this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
