Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [PATCH] xfs: failure mapping nfs fh to inode should return ESTALE
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110714205036.GA19457@fieldses.org>
References: <20110714205036.GA19457@fieldses.org>
Date: Thu, 14 Jul 2011 17:25:50 -0500
Message-ID: <1310682350.2067.110.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: xfs-masters@oss.sgi.com, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2011-07-14 at 16:50 -0400, J. Bruce Fields wrote:
> From: J. Bruce Fields <bfields@redhat.com>
> 
> On xfs exports, nfsd is incorrectly returning ENOENT instead of ESTALE
> on attempts to use a filehandle of a deleted file (spotted with pynfs
> test PUTFH3).  The ENOENT was coming from xfs_iget.
> 
> (It's tempting to wonder whether we should just map all xfs_iget errors
> to ESTALE, but I don't believe so--xfs_iget can also return ENOMEM at
> least, which we wouldn't want mapped to ESTALE.)
> 
> While we're at it, the other return of ENOENT in xfs_nfs_get_inode()
> also looks wrong.
> 
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>

Looks reasonable to me.

I'll give others a chance to weigh in, but otherwise I'll
get this in for Linux 3.1.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
