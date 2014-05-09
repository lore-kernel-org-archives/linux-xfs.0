Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBC477F3F
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 15:54:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC2E38F804B
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 13:54:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ifT2a2RO0krYzUuO for <xfs@oss.sgi.com>;
	Fri, 09 May 2014 13:54:26 -0700 (PDT)
Message-ID: <536D4082.2090707@sandeen.net>
Date: Fri, 09 May 2014 15:54:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix selinux context handling
References: <1399668027-12912-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1399668027-12912-1-git-send-email-jbacik@fb.com>
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
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sandeen@redhat.com

On 5/9/14, 3:40 PM, Josef Bacik wrote:
> With the new config stuff we lost the selinux options being set for systems with
> selinux turned on.  We want the selinux context set all the time, wether we
> provide a MOUNT_OPTIONS value or not, so take this logic out of _mount_opts()
> and just put it in the body of common/config
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

This makes sense to me... untested, TBH, but I assume you did, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

At some point it'd probably make sense to figure out which tests actually
need this, and put it in a _use_selinux_context() or something, so that
other tests still exercise under a normal selinux environment...

-Eric

> ---
>  common/config | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/common/config b/common/config
> index e8bcf48..a2f55cf 100644
> --- a/common/config
> +++ b/common/config
> @@ -217,16 +217,16 @@ case "$HOSTOS" in
>          ;;
>  esac
>  
> +# SELinux adds extra xattrs which can mess up our expected output.
> +# So, mount with a context, and they won't be created
> +# # nfs_t is a "liberal" context so we can use it.
> +if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
> +	SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
> +	export SELINUX_MOUNT_OPTIONS
> +fi
> +
>  _mount_opts()
>  {
> -	# SELinux adds extra xattrs which can mess up our expected output.
> -	# So, mount with a context, and they won't be created
> -	# # nfs_t is a "liberal" context so we can use it.
> -	if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
> -		SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
> -		export SELINUX_MOUNT_OPTIONS
> -	fi
> -
>  	case $FSTYP in
>  	xfs)
>  		export MOUNT_OPTIONS=$XFS_MOUNT_OPTIONS
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
