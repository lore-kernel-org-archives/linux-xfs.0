Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QLxNdN101286 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 16:59:23 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	x2e9CVEo0bFXvDIj for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 14:59:21 -0700 (PDT)
Date: Tue, 27 Mar 2012 08:59:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Building tilegx defconfig gets init/exit section errors in xfs.
Message-ID: <20120326215919.GN5091@dastard>
References: <4F6F61F3.40903@windriver.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F6F61F3.40903@windriver.com>
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
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, cmetcalf@tilera.com, xfs@oss.sgi.com

On Sun, Mar 25, 2012 at 02:20:35PM -0400, Paul Gortmaker wrote:
> Hi All,
> 
> Recently the tilegx defconfig was added to the linux-next build
> coverage, which exposed this.
>  
> LD      .tmp_vmlinux1
> `xfs_qm_exit' referenced in section `.init.text' of fs/built-in.o:
>  defined in discarded section `.exit.text' of fs/built-in.o
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/5941293/
> 
> It seemed odd to me, since I didn't think there was anything arch
> specific in the init/exit sectioning, so I thought I'd mention it
> here, just in case it hasn't been brought up before.

Already been reported, a patch has been provided, too. So the fix
is underway.

Thanks for reporting the problem anyway, Paul.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
