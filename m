Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF2E17F3F
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 19:56:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A974A8F807A
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 17:56:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wk0qiQWK8q4QFtAL for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 17:56:19 -0700 (PDT)
Date: Sat, 28 Jun 2014 10:56:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/6] xfs: add xfs_mount sysfs kobject
Message-ID: <20140628005617.GB9508@dastard>
References: <1403870821-20143-1-git-send-email-bfoster@redhat.com>
	<1403870821-20143-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1403870821-20143-4-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 27, 2014 at 08:06:58AM -0400, Brian Foster wrote:
> Embed a base kobject into xfs_mount. This creates a kobject associated
> with each XFS mount and a subdirectory in sysfs with the name of the
> filesystem. The subdirectory lifecycle matches that of the mount. Also
> add the new xfs_sysfs.[c,h] source files with some XFS sysfs
> infrastructure to facilitate attribute creation.
> 
> Note that there are currently no attributes exported as part of the
> xfs_mount kobject. It exists solely to serve as a per-mount container
> for child objects.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

One minor thing I can clean up directly:

> +static inline int
> +xfs_sysfs_init(
> +	struct xfs_kobj		*kobj,
> +	struct kobj_type	*ktype,
> +	struct xfs_kobj		*p_kobj,
                                 ^^^^^^

parent_kobj would be better - that looks too much like hungarian
notation... :)

Other than that,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
