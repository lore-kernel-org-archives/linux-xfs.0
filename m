Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:42937 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754408AbeEHKY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 06:24:26 -0400
Received: by mail-yw0-f195.google.com with SMTP id q7-v6so1162555ywd.9
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 03:24:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180507213620.GB11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-21-git-send-email-allison.henderson@oracle.com> <20180507213620.GB11261@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 13:24:24 +0300
Message-ID: <CAOQ4uxh78+xGL24hTCxK-0-tG7Shv83DC7SpDTK3jWmfDusDwA@mail.gmail.com>
Subject: Re: [PATCH 20/21] xfs: Add parent pointer ioctl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 8, 2018 at 12:36 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Sun, May 06, 2018 at 10:24:53AM -0700, Allison Henderson wrote:
>> This patch adds a new file ioctl to retrieve the parent
>> pointer of a given inode
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
[...]
>> +
>> +     /*
>> +      * Now that we know how big the trailing buffer is, expand
>> +      * our kernel xfs_pptr_info to be the same size
>> +      */
>> +     ppi = kmem_realloc(ppi, XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size),
>
> Hmm, pi_ptrs_size probably needs some kind of check so that userspace
> can't ask for insane large allocations.  64k, perhaps?  ~230 records per
> call ought to be enough for anyone... :P
>
> if (XFS_PPTR_INFO_SIZEOFI(...) > XFS_XATTR_LIST_MAX)
>         return -ENOMEM;

ERANGE feels more appropriate.

> ppi = kmem_realloc(...);
>
>> +                          KM_SLEEP);
>> +     if (!ppi)
>> +             return -ENOMEM;
>> +
>> +     if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
>> +             dentry = xfs_handle_to_dentry(filp, &ppi->pi_handle,
>> +                                           sizeof(struct xfs_handle));
>> +             if (IS_ERR(dentry))
>> +                     return PTR_ERR(dentry);
>> +             ip = XFS_I(d_inode(dentry));
>
> I would've thought that between the dentry and the ip that at least one
> of those would require a dput/iput, and that we'd need to do something
> to prevent the dentry or the inode from disappearing from underneath us...
>
> ...but you could also extract the inode and generation numbers from the
> handle information and call xfs_iget directly.  The exportfs code tries
> to reconnect dentry parent information up to the root, which will turn
> out badly if some mid-level directory is corrupt and scrub is trying to
> reconstruct the former path of a now inaccessible file.
>

Here is an easy code reuse solution for you.
It's a way to suppress reconnect and reuse of the conversions
done in xfs_handle_to_dentry().

Thanks,
Amir.

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 89fb1eb80aae..2312862dc34a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -159,7 +159,8 @@ struct dentry *
 xfs_handle_to_dentry(
        struct file             *parfilp,
        void __user             *uhandle,
-       u32                     hlen)
+       u32                     hlen,
+       bool                    reconnect)
 {
        xfs_handle_t            handle;
        struct xfs_fid64        fid;
@@ -184,7 +185,7 @@ xfs_handle_to_dentry(

        return exportfs_decode_fh(parfilp->f_path.mnt, (struct fid *)&fid, 3,
                        FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
-                       xfs_handle_acceptable, NULL);
+                       reconnect ? xfs_handle_acceptable : NULL, NULL);
 }

 STATIC struct dentry *
@@ -192,7 +193,8 @@ xfs_handlereq_to_dentry(
        struct file             *parfilp,
        xfs_fsop_handlereq_t    *hreq)
 {
-       return xfs_handle_to_dentry(parfilp, hreq->ihandle, hreq->ihandlen);
+       return xfs_handle_to_dentry(parfilp, hreq->ihandle, hreq->ihandlen,
+                                   false);
 }
