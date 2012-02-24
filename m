Return-Path: <xfs-bounces@oss.sgi.com>
Date: Fri, 24 Feb 2012 10:01:47 -0600
From: Ben Myers <bpm@sgi.com>
Message-ID: <20120224160147.GD28391@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: elder@kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Dan Carpenter <dan.carpenter@oracle.com>

Bcc: 
Subject: Re: [PATCH] xfs: Use memset to initialize structure member.
Reply-To: 
In-Reply-To: <20120224075354.GA3649@mwanda>

On Fri, Feb 24, 2012 at 10:53:54AM +0300, Dan Carpenter wrote:
> On Fri, Feb 24, 2012 at 12:38:42PM +0530, santosh nayak wrote:
> > From: Santosh Nayak <santoshprasadnayak@gmail.com>
> > 
> > Sparse is giving following warning:
> > fs/xfs/xfs_bmap.c:4826:41: warning: Using plain integer as NULL pointer.
> > 
> 
> You could just do:
> 	struct xfs_bmalloca     bma = {};

Santosh, this aggregate initializer seems cleaner than memset.  Do you
mind resending the patch with Dan's suggestion?

Thanks for your contribution.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
