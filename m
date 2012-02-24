Return-Path: <xfs-bounces@oss.sgi.com>
Date: Fri, 24 Feb 2012 10:05:05 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Use memset to initialize structure member.
Message-ID: <20120224160505.GF7762@sgi.com>
References: <1330067322-17011-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120224075354.GA3649@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120224075354.GA3649@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>, santosh nayak <santoshprasadnayak@gmail.com>
Cc: xfs-masters@oss.sgi.com, elder@kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Santosh,

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

This aggregate initializer seems cleaner than memset.  Do you
mind resending the patch with Dan's suggestion?                                 
                                                                                
Thanks for your contribution.  ;)    

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
