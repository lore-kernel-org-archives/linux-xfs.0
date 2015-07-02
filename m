Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA9737FA3
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 19:20:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C93C08F8049
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 17:20:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	tI6DXb9XjuQw7qDh for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 17:20:18 -0700 (PDT)
Date: Thu, 2 Jul 2015 10:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Fine-tuning for checks before the function call
	"xfs_qm_dqrele"?
Message-ID: <20150702001951.GX22807@dastard>
References: <530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<5479F823.60900@users.sourceforge.net>
	<20141130230904.GF16151@dastard>
	<558D1833.3080009@users.sourceforge.net>
	<20150629214355.GE7943@dastard>
	<55939BA8.1090400@users.sourceforge.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55939BA8.1090400@users.sourceforge.net>
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

On Wed, Jul 01, 2015 at 09:50:00AM +0200, SF Markus Elfring wrote:
> > xfs_dqrele_inode() gets called on every inode in the inode cache,
> > and this change results in a cacheline in every inode being dirtied
> > even if they don't have dquots attached. Given the inode cache can
> > hold tens to hundreds of millions of inodes on large machines, we
> > don't want to dirty any cachelines we don't need to while walking
> > the inode cache and releasing dquots...
> 
> Would it make sense to annotate checks before such function calls
> as "LIKELY"?

No - it will be random as to whether the inodes have dquots attached
or not and so a static hint is always going to be wrong for
someone....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
