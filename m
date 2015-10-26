Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 084C17F50
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 16:47:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA93E304032
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 14:47:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LvSAG4fgC8YpXjhx for <xfs@oss.sgi.com>;
	Mon, 26 Oct 2015 14:47:23 -0700 (PDT)
Date: Tue, 27 Oct 2015 08:46:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: SGI ACLs: Map uid/gid namespaces
Message-ID: <20151026214651.GJ8773@dastard>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-4-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445721369-25679-4-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Sat, Oct 24, 2015 at 11:16:08PM +0200, Andreas Gruenbacher wrote:
> Map uids and gids in the trusted.SGI_ACL_{FILE,DEFAULT} attributes between
> the kernel and user-space namespaces.  This needs to be done in the
> filesystem because the VFS is unaware of those attributes; for the standard
> POSIX ACL attributes, the VFS takes care of that for us.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/xfs/xfs_acl.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 0eea7ee..64ffb85 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -39,7 +39,8 @@ STATIC struct posix_acl *
>  xfs_acl_from_disk(
>  	const struct xfs_acl	*aclp,
>  	int			len,
> -	int			max_entries)
> +	int			max_entries,
> +	struct user_namespace	*ns)
>  {
>  	struct posix_acl_entry *acl_e;
>  	struct posix_acl *acl;
> @@ -71,10 +72,10 @@ xfs_acl_from_disk(
>  
>  		switch (acl_e->e_tag) {
>  		case ACL_USER:
> -			acl_e->e_uid = xfs_uid_to_kuid(be32_to_cpu(ace->ae_id));
> +			acl_e->e_uid = make_kuid(ns, be32_to_cpu(ace->ae_id));

Please don't replace the xfs wrappers with the horribly named
generic functions. Pass the namespace to xfs_uid_to_kuid(), and
modify them, please. That way people who don't deal with namespaces
every day can tell exactly what format conversion is taking place
just by reading the code...

This namespace stuff is awful twisty. The posix layer does a user-ns
to init-ns conversion and here we do a no-op init-ns to init-ns
conversion. That needs comments in the code to explain exactly why
one path needs user-ns conversion and the other doesn't, because I'm
sure as hell not going to remember why these code paths are
different in 6 months time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
