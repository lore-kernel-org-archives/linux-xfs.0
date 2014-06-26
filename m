Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4276C7F6B
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 23:29:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0942C304048
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 21:29:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hXDcKfFPwE5pVtn4 for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 21:29:39 -0700 (PDT)
Date: Thu, 26 Jun 2014 14:29:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: add xfs_mount sysfs kobject
Message-ID: <20140626042925.GW4453@dastard>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
	<1402060414-22075-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402060414-22075-4-git-send-email-bfoster@redhat.com>
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

On Fri, Jun 06, 2014 at 09:13:31AM -0400, Brian Foster wrote:
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
....
> +#include <linux/sysfs.h>
> +#include "xfs.h"
> +#include "xfs_types.h"
> +#include "xfs_sb.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_ag.h"
> +#include "xfs_mount.h"
> +
> +struct xfs_sysfs_attr {
> +	struct attribute attr;
> +	ssize_t (*show)(char *buf, void *data);
> +	ssize_t (*store)(const char *buf, size_t count, void *data);
> +};
> +
> +#define XFS_SYSFS_ATTR_RW(name) \
> +	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RW(name)
> +#define XFS_SYSFS_ATTR_RO(name) \
> +	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RO(name)
> +
> +#define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr

Not a fan of the sysfs attribute stuff, but it's a generic pattern
so at least the pain is shared by everyone...

Reviewed-by: Dave Chinner <dchinner@redhat.com>


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
