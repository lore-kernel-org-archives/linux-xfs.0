Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71A0F7F52
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 10:30:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40FBD304053
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 08:30:21 -0800 (PST)
Received: from mail-ob0-f182.google.com (mail-ob0-f182.google.com
	[209.85.214.182]) by cuda.sgi.com with ESMTP id
	7dEvidaimXAyDl94 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 08:30:19 -0800 (PST)
Received: by obbza9 with SMTP id za9so16461064obb.1
	for <xfs@oss.sgi.com>; Tue, 03 Nov 2015 08:30:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446563847-14005-48-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-48-git-send-email-agruenba@redhat.com>
Date: Tue, 3 Nov 2015 11:30:19 -0500
Message-ID: <CAHQdGtTiOEzNMCjgLna5VDtq4mKz83UdA4xAO8vtvRQGHMN0VQ@mail.gmail.com>
Subject: Re: [PATCH v13 47/51] nfs: Fix GETATTR bitmap verification
From: Trond Myklebust <trond.myklebust@primarydata.com>
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
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API Mailing List <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Nov 3, 2015 at 10:17 AM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> When decoding GETATTR replies, the client checks the attribute bitmap
> for which attributes the server has sent.  It misses bits at the word
> boundaries, though; fix that.
>
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/nfs/nfs4xdr.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
> index 788adf3..6f6d921 100644
> --- a/fs/nfs/nfs4xdr.c
> +++ b/fs/nfs/nfs4xdr.c
> @@ -4375,6 +4375,11 @@ static int decode_statfs(struct xdr_stream *xdr, struct nfs_fsstat *fsstat)
>                 goto xdr_error;
>         if ((status = decode_attr_files_total(xdr, bitmap, &fsstat->tfiles)) != 0)
>                 goto xdr_error;
> +
> +       status = -EIO;
> +       if (unlikely(bitmap[0]))
> +               goto xdr_error;
> +
>         if ((status = decode_attr_space_avail(xdr, bitmap, &fsstat->abytes)) != 0)
>                 goto xdr_error;
>         if ((status = decode_attr_space_free(xdr, bitmap, &fsstat->fbytes)) != 0)
> @@ -4574,6 +4579,10 @@ static int decode_getfattr_attrs(struct xdr_stream *xdr, uint32_t *bitmap,
>                 goto xdr_error;
>         fattr->valid |= status;
>
> +       status = -EIO;
> +       if (unlikely(bitmap[0]))
> +               goto xdr_error;
> +
>         status = decode_attr_mode(xdr, bitmap, &fmode);
>         if (status < 0)
>                 goto xdr_error;
> @@ -4627,6 +4636,10 @@ static int decode_getfattr_attrs(struct xdr_stream *xdr, uint32_t *bitmap,
>                 goto xdr_error;
>         fattr->valid |= status;
>
> +       status = -EIO;
> +       if (unlikely(bitmap[1]))
> +               goto xdr_error;
> +
>         status = decode_attr_mdsthreshold(xdr, bitmap, fattr->mdsthreshold);
>         if (status < 0)
>                 goto xdr_error;
> @@ -4789,12 +4802,22 @@ static int decode_fsinfo(struct xdr_stream *xdr, struct nfs_fsinfo *fsinfo)
>         if ((status = decode_attr_maxwrite(xdr, bitmap, &fsinfo->wtmax)) != 0)
>                 goto xdr_error;
>         fsinfo->wtpref = fsinfo->wtmax;
> +
> +       status = -EIO;
> +       if (unlikely(bitmap[0]))
> +               goto xdr_error;
> +
>         status = decode_attr_time_delta(xdr, bitmap, &fsinfo->time_delta);
>         if (status != 0)
>                 goto xdr_error;
>         status = decode_attr_pnfstype(xdr, bitmap, &fsinfo->layouttype);
>         if (status != 0)
>                 goto xdr_error;
> +
> +       status = -EIO;
> +       if (unlikely(bitmap[1]))
> +               goto xdr_error;
> +
>         status = decode_attr_layout_blksize(xdr, bitmap, &fsinfo->blksize);
>         if (status)
>                 goto xdr_error;
> --
> 2.5.0

This patch can and should be merged separately from this patchset.
Please submit it through the usual channels.

Trond

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
