Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E1057CA3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 17:13:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33CE28F8039
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 15:13:54 -0700 (PDT)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com
	[209.85.213.47]) by cuda.sgi.com with ESMTP id RkoBw42Z2U9BalgW
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 15:13:52 -0700 (PDT)
Received: by mail-vk0-f47.google.com with SMTP id z68so80139952vkg.3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 15:13:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459348507-20406-1-git-send-email-mguzik@redhat.com>
References: <1459348507-20406-1-git-send-email-mguzik@redhat.com>
Date: Thu, 31 Mar 2016 00:13:51 +0200
Message-ID: <CAHc6FU4SOh_6C8DPjrug0jR31U5rAQWFg7a8e2dUbvv-Axg8KQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix a memory leak in xfs_get_acl on error
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, XFS Developers <xfs@oss.sgi.com>

On Wed, Mar 30, 2016 at 4:35 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
> Signed-off-by: Mateusz Guzik <mguzik@redhat.com>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

> ---
>  fs/xfs/xfs_acl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 2dad2b5..ce10c4c 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -162,10 +162,11 @@ xfs_get_acl(struct inode *inode, int type)
>                  */
>                 if (error != -ENOATTR)
>                         acl = ERR_PTR(error);
> -               return acl;
> +               goto out;
>         }
>
>         acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount));
> +out:
>         kmem_free(xfs_acl);
>         return acl;
>  }
> --
> 1.8.3.1
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
