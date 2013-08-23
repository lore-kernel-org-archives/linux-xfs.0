Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 533DC29DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 13:32:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 304038F8033
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 11:32:30 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id dUr7qa5JpFSd64rG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 11:32:29 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 813E89A0359
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 12:32:28 -0600 (MDT)
Date: Fri, 23 Aug 2013 14:32:26 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH V4] xfstests: don't remove the two first devices from
	SCRATCH_DEV_POOL
Message-ID: <20130823183226.GE29654@localhost.localdomain>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 23, 2013 at 03:07:10PM +0200, Stefan Behrens wrote:
> Since common/config is executed twice, if SCRATCH_DEV_POOL is configured
> via the environment, the current code removes the first device entry twice
> which means that you lose the second device for the test.
> 
> The fix is to not remove anything from SCRATCH_DEV_POOL anymore.
> That used to be done (I can only guess) to allow to pass the
> SCRATCH_DEV_POOL as an argument to _scratch_mkfs. Since _scratch_mkfs adds
> the SCRATCH_DEV, the pool mustn't contain that device anymore.
> 
> A new function _scratch_pool_mkfs is introduced that does the expected
> thing.
> 

This didn't break anything and makes sense

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
