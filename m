Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 933B67F51
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 01:34:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30BB5AC006
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:34:46 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 7Dzyip10HFAJaA4x for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:34:45 -0700 (PDT)
Message-ID: <51F8B058.1010308@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 14:36:08 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 1/7] xfs: create wrappers for converting kuid_t to/from
	uid_t
References: <20130729230640.5131f5cc@oracle.com>
In-Reply-To: <20130729230640.5131f5cc@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On 07/30/2013 11:06 AM, Dwight Engen wrote:
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_linux.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 

looks good to me, thanks!
Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>

> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 800f896..761e4c0 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -159,6 +159,32 @@
>  #define MAX(a,b)	(max(a,b))
>  #define howmany(x, y)	(((x)+((y)-1))/(y))
>  
> +/* Kernel uid/gid conversion. These are used to convert to/from the on disk
> + * uid_t/gid_t types to the kuid_t/kgid_t types that the kernel uses internally.
> + * The conversion here is type only, the value will remain the same since we
> + * are converting to the init_user_ns. The uid is later mapped to a particular
> + * user namespace value when crossing the kernel/user boundary.
> + */
> +static inline __uint32_t xfs_kuid_to_uid(kuid_t uid)
> +{
> +	return from_kuid(&init_user_ns, uid);
> +}
> +
> +static inline kuid_t xfs_uid_to_kuid(__uint32_t uid)
> +{
> +	return make_kuid(&init_user_ns, uid);
> +}
> +
> +static inline __uint32_t xfs_kgid_to_gid(kgid_t gid)
> +{
> +	return from_kgid(&init_user_ns, gid);
> +}
> +
> +static inline kgid_t xfs_gid_to_kgid(__uint32_t gid)
> +{
> +	return make_kgid(&init_user_ns, gid);
> +}
> +
>  /*
>   * Various platform dependent calls that don't fit anywhere else
>   */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
