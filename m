Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B04B7F73
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 16:44:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE2C6AC001
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 14:44:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uaxCtdbzzU7MMW0b for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 14:43:58 -0700 (PDT)
Date: Tue, 30 Jun 2015 07:43:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Delete unnecessary checks before the function call
	"xfs_qm_dqrele"
Message-ID: <20150629214355.GE7943@dastard>
References: <530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5479F823.60900@users.sourceforge.net>
	<20141130230904.GF16151@dastard>
	<558D1833.3080009@users.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <558D1833.3080009@users.sourceforge.net>
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
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Jun 26, 2015 at 11:15:31AM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 26 Jun 2015 11:05:41 +0200
> 
> The xfs_qm_dqrele() function tests whether its argument is NULL and
> then returns immediately.

True.

> Thus the test around the call is not needed.

But wrong.

xfs_dqrele_inode() gets called on every inode in the inode cache,
and this change results in a cacheline in every inode being dirtied
even if they don't have dquots attached. Given the inode cache can
hold tens to hundreds of millions of inodes on large machines, we
don't want to dirty any cachelines we don't need to while walking
the inode cache and releasing dquots...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
