Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 710D929E12
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 15:54:03 -0600 (CST)
Date: Wed, 4 Dec 2013 15:53:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch] xfs: underflow bug in xfs_attrlist_by_handle()
Message-ID: <20131204215359.GA1935@sgi.com>
References: <20131025144452.GA28451@ngolde.de>
	<20131031180010.GA24839@longonot.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031180010.GA24839@longonot.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Fabian Yamaguchi <fabs@goesec.de>, security@kernel.org, Alex Elder <elder@kernel.org>, Nico Golde <nico@ngolde.de>, xfs@oss.sgi.com

On Thu, Oct 31, 2013 at 09:00:10PM +0300, Dan Carpenter wrote:
> If we allocate less than sizeof(struct attrlist) then we end up
> corrupting memory or doing a ZERO_PTR_SIZE dereference.
> 
> This can only be triggered with CAP_SYS_ADMIN.
> 
> Reported-by: Nico Golde <nico@ngolde.de>
> Reported-by: Fabian Yamaguchi <fabs@goesec.de>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.  Thanks Dan.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
