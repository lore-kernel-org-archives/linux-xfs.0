Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D8C127CA0
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 06:58:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB18F8F8037
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 04:58:40 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fSg2BrqIlAM1uH1z for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2016 04:58:37 -0700 (PDT)
Date: Fri, 22 Jul 2016 21:58:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: next-20160722 build: 1 failures 5 warnings (next-20160722)
Message-ID: <20160722115834.GR16044@dastard>
References: <E1bQXSf-0008Uu-Ej@optimist> <20160722103829.GY6509@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160722103829.GY6509@sirena.org.uk>
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
To: Mark Brown <broonie@kernel.org>
Cc: linaro-kernel@lists.linaro.org, kernel-build-reports@lists.linaro.org, xfs@oss.sgi.com, linux-next@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-arm-kernel@lists.infradead.org

On Fri, Jul 22, 2016 at 11:38:29AM +0100, Mark Brown wrote:
> On Fri, Jul 22, 2016 at 11:13:41AM +0100, Build bot for Mark Brown wrote:
> 
> Today's -next fails to build an ARM allmodconfig due to:
> 
> > 	arm-allmodconfig
> > ERROR: "dax_do_io" [fs/xfs/xfs.ko] undefined!

Already fixed.

https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/commit/?h=for-next&id=f021bd071f06b545926b1031348873b05442139f

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
