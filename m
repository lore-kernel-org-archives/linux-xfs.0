Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BBF67F37
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 15:15:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4823B304039
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 13:15:55 -0700 (PDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
	[209.85.217.172]) by cuda.sgi.com with ESMTP id
	dsx1XdLP8vFC4s5G (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 26 Oct 2015 13:15:52 -0700 (PDT)
Received: by lbbwb3 with SMTP id wb3so48915230lbb.1
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 13:15:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445721369-25679-5-git-send-email-agruenba@redhat.com>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-5-git-send-email-agruenba@redhat.com>
Date: Mon, 26 Oct 2015 21:15:51 +0100
Message-ID: <CAHc6FU4_qNY+iXdc6+SOhZOWbVu-PRN=_S6JyjNg4ubL=5NN9w@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: SGI ACLs: Prepare for richacls
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

On Sat, Oct 24, 2015 at 11:16 PM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> In case an inode has trusted.SGI_ACL_* attributes but POSIX ACLs are not
> enabled, treat those attributes as normal trusted attributes and bypass the
> get_acl and set_acl inode operations to prevent corrupting inode->i_mode,
> inode->i_acl, or inode->i_default_acl.
>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/xfs/xfs_acl.c   |  5 +++++
>  fs/xfs/xfs_xattr.c |  5 +++--
>  fs/xfs/xfs_xattr.h | 28 ++++++++++++++++++++++++++++
>  3 files changed, 36 insertions(+), 2 deletions(-)
>  create mode 100644 fs/xfs/xfs_xattr.h
>
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 64ffb85..bee1493 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -21,6 +21,7 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
> +#include "xfs_xattr.h"
>  #include "xfs_acl.h"
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
> @@ -319,6 +320,8 @@ xfs_xattr_acl_get(struct dentry *dentry, const char *name,
>         struct posix_acl *acl;
>         int error;
>
> +       if (!IS_POSIXACL(inode))
> +               return xfs_xattr_get(dentry, name, value, size, type);

This doesn't give us UID/GID mapping. In-place rewriting as the VFS
does would help, but the value is a const * here so we cannot really
modify it.

>         if (S_ISLNK(inode->i_mode))
>                 return -EOPNOTSUPP;
>


Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
