Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CEE57FA1
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:36:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCF79AC003
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 12:36:41 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8015V46BpSSLX618 for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 12:36:40 -0700 (PDT)
Date: Fri, 4 Apr 2014 06:36:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: extra semi-colon breaks a condition
Message-ID: <20140403193638.GO16336@dastard>
References: <20140328080313.GA25192@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140328080313.GA25192@mwanda>
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
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Fri, Mar 28, 2014 at 11:03:13AM +0300, Dan Carpenter wrote:
> There were some extra semi-colons here which mean that we return true
> unintentionally.
> 
> Fixes: a49935f200e2 ('xfs: xfs_check_page_type buffer checks need help')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Dan, $BEVVIE_OF_CHOICE is on me next time we are in the same place.
And bring a handful brown paper bags as well because there's a few
people here that need to wear them for a while. :/

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
