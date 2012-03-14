Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2ENVtod006744 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 18:31:55 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	L4lAoEJLJCEDwJty for <xfs@oss.sgi.com>;
	Wed, 14 Mar 2012 16:31:53 -0700 (PDT)
Date: Thu, 15 Mar 2012 10:31:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: display project quota as user
Message-ID: <20120314233127.GL5091@dastard>
References: <20120314130902.GA26508@systemlinux.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120314130902.GA26508@systemlinux.org>
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
To: Andre Noll <maan@systemlinux.org>
Cc: =?iso-8859-1?Q?Andr=E9_C=2E?= Stiel <andre.stiel@tuebingen.mpg.de>, xfs@oss.sgi.com

On Wed, Mar 14, 2012 at 02:09:02PM +0100, Andre Noll wrote:
> Simple question: Can non-privileged users display XFS project quotas?
> 
> Currently the command
> 
> 	xfs_quota -c 'quota -p 42'
> 
> fails when executed as a non-root user due to quotactl(Q_XGETQUOTA,...)
> returning EPERM. The problem seems to be that fs/quota/quota.c has no
> knowledge of project quotas at all.

Right - only XFS supports project quotas.

> The proof-of-concept patch below makes quotactl(Q_XGETQUOTA,...)
> succeed for any user when called with type == XQM_PRJQUOTA. However,
> relaxing the permission checks like this might not please everybody,
> changes semantics of an existing API and adds the XFS specific constant
> XQM_PRJQUOTA to fs/quota.c. So I'm not even asking to apply something
> like that.
> 
> Is there a better way to allow users to display project quotas?

There is no user <=> projid mapping that exists, so either the
information is available to everyone, or it is available only to
root. In this case, system wide quota reports are limited to root,
and I don't see that changing.

If you really must allow users to see project quota limits, then
write a simple wrapper program and allow only the users that need
the infomration to execute it via sudo....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
