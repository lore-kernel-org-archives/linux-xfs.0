Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 253967F4E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 07:16:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECBF88F8049
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 05:16:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6MkFDeBBgylZQoxz for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 05:16:50 -0700 (PDT)
Date: Tue, 20 May 2014 22:16:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/2] xfs: add basic per-mount sysfs attribute support
Message-ID: <20140520121647.GH8554@dastard>
References: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
	<1400263966-35541-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400263966-35541-2-git-send-email-bfoster@redhat.com>
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

On Fri, May 16, 2014 at 02:12:45PM -0400, Brian Foster wrote:
> Initialize/destroy a kset on module init/fini for XFS. The XFS attribute
> directory is represented as /sys/fs/xfs. Create a subdirectory per-mount
> based on the system device name.
> 
> Also add some basic macros to aid in the addition of sysfs attributes.
> This code is modeled after the equivalent mechanism for ext4.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_mount.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.h |  2 ++
>  fs/xfs/xfs_super.c | 12 ++++++++-
>  3 files changed, 92 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 944f3d9..9ed9dd0 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -60,6 +60,9 @@ static DEFINE_MUTEX(xfs_uuid_table_mutex);
>  static int xfs_uuid_table_size;
>  static uuid_t *xfs_uuid_table;
>  
> +extern struct kset *xfs_kset;
> +static struct kobj_type xfs_ktype;
> +
>  /*
>   * See if the UUID is unique among mounted XFS filesystems.
>   * Mount fails if UUID is nil or a FS with the same UUID is already mounted.
> @@ -955,6 +958,13 @@ xfs_mountfs(
>  	"Unable to allocate reserve blocks. Continuing without reserve pool.");
>  	}
>  
> +	mp->m_kobject.kset = xfs_kset;
> +	init_completion(&mp->m_kobject_complete);
> +	error = kobject_init_and_add(&mp->m_kobject, &xfs_ktype, NULL,
> +				     "%s", mp->m_fsname);
> +	if (error)
> +		goto out_rtunmount;
> +

I think this should be wrapped in a helper, same for the destruction
code. It shoul dalso be called earlier rather than later, because we
are going to want to add children to this object (e.g. per-ag sysfs
attribute directories), and we probably want to isolate information
from different subsystems to different subdirectories under this.
e.g;

	/sysfs/fs/xfs/vda/....
	             /vdb/log/...
		         /trans/...
		         /ag/0/sb/....
			      /agf/....
			      /agi/....
			      /agfl/....
			    /1/sb/...
			    ...
			    /n/agfl/....
			 /quota/....

Dumping everything in the root directory is probably not a good
idea, and hence we shoul dbe creating the heirarchy as we initialise
subsystems during mount, and freeing them as we tear them down from
unmount...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
