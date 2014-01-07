Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E69C17F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 13:34:03 -0600 (CST)
Date: Tue, 7 Jan 2014 13:34:00 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
	INIT_WORK_ONSTACK()
Message-ID: <20140107193400.GC1935@sgi.com>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
	<1389084814.3650.70.camel@cliu38-desktop-build>
	<52CBE321.4050906@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52CBE321.4050906@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, Chuansheng Liu <chuansheng.liu@intel.com>
Cc: dchinner@fromorbit.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jan 07, 2014 at 07:21:05PM +0800, Jeff Liu wrote:
> Hi Chuansheng,
> 
> On 01/07 2014 16:53 PM, Chuansheng Liu wrote:
> > 
> > In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> > call destroy_work_on_stack() which frees the debug object to pair
> > with INIT_WORK_ONSTACK().
> > 
> > Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> > ---
> >  fs/xfs/xfs_bmap_util.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 1394106..82e0dab 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -287,6 +287,7 @@ xfs_bmapi_allocate(
> >  	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
> >  	queue_work(xfs_alloc_wq, &args->work);
> >  	wait_for_completion(&done);
> > +	destroy_work_on_stack(&args->work);
> >  	return args->result;
> >  }
> 
> Thanks for your patch and it work fine for my testing.  I missed this in an
> old commit: [ 3b876c8f2a xfs: fix debug_object WARN at xfs_alloc_vextent() ] 

Looks good to me too.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
