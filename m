Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06FEC32772
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 17:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiHPRPg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 13:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236163AbiHPRPg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 13:15:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBB57A758
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 10:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660670133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=76sG/KyxLmQ56bn83QhiqsNTUnCGsc1T0j3i3xg61zo=;
        b=I7BQx8VeqwUg3sKZup425xGd888e25/DSLxyL6RMRWj/7Xb0YMEhCZhh2cZeBCDn9Hm9od
        ja61qKU1BbMTSPyIVbDokgUNe6srxuS3tp9n97Y2CZp6lB2mkLtA9LpKQMyXrRq+8TG6br
        TBr6lzMw5ZlMnWbRU9Q1i0cRv7BRQO0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-341-v9yIii2_Ne2MLiRJmE2AhA-1; Tue, 16 Aug 2022 13:15:32 -0400
X-MC-Unique: v9yIii2_Ne2MLiRJmE2AhA-1
Received: by mail-ed1-f70.google.com with SMTP id m22-20020a056402431600b0043d6a88130aso7000127edc.18
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 10:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=76sG/KyxLmQ56bn83QhiqsNTUnCGsc1T0j3i3xg61zo=;
        b=JPYC8IFFUuJSe4eruftMcw8teluWSftMoY3IqtWOJXD7laEwmTiZcAbRfzm75poXZ3
         tZbP0A8HyqqTQGtIkicFrmDZIKIJbyTqMLwMConKjG2r9gVfCb0xhELUY9xq0xW79hje
         GUJvmyoVqZ68uyU6mpy1l3lUY3grjeiERZ5GOO34T2y9AD0p/cnej20YXcyL/ePEc0J/
         0YiSBPB1B0/p9lyOuKx9N+Izd286bLnGn4tRK4FbeHYQjMdHyo6Ost+LRtpZpOIM7msL
         YcmDBYS5QK0/yyyjgiYFJaprgbpzaC4F/OiQsKuaUBfsf/MiIMN+lsNpn98wkcHrpLFD
         Z77A==
X-Gm-Message-State: ACgBeo03LjO7YlXbPZRdgH+OApmsMAbPTZArJkIR5Wx6AwhkToOEAA4B
        HLh5jn4l3/AnTy7jvUkz5dRVh/9QsQ0Yl/nRwskFrxJdLunlBgHdyvSFjVGxeDKWKh827gya3Db
        5JFByDfWQV+YIE18SusUbAxbTOdwS7iUcnAkP
X-Received: by 2002:a17:907:3f24:b0:730:bcbd:395d with SMTP id hq36-20020a1709073f2400b00730bcbd395dmr14506546ejc.540.1660670131306;
        Tue, 16 Aug 2022 10:15:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR60DtWRTlTqBPmwvunUq9U89uGjFYeIC8yRzoieFTiLmWCy/xDCdkYkj0UP9n143AUUCtjhkk0S1H7gbQQiUsA=
X-Received: by 2002:a17:907:3f24:b0:730:bcbd:395d with SMTP id
 hq36-20020a1709073f2400b00730bcbd395dmr14506527ejc.540.1660670131073; Tue, 16
 Aug 2022 10:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220816131736.42615-1-jlayton@kernel.org>
In-Reply-To: <20220816131736.42615-1-jlayton@kernel.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 16 Aug 2022 13:14:55 -0400
Message-ID: <CALF+zO=OrT5tBvyL1ERD+YDSXkSAFvqQu-cQkSgWvQN8z+E_rA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix i_version handling in xfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 9:19 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> The i_version in xfs_trans_log_inode is bumped for any inode update,
> including atime-only updates due to reads. We don't want to record those
> in the i_version, as they don't represent "real" changes. Remove that
> callsite.
>
> In xfs_vn_update_time, if S_VERSION is flagged, then attempt to bump the
> i_version and turn on XFS_ILOG_CORE if it happens. In
> xfs_trans_ichgtime, update the i_version if the mtime or ctime are being
> updated.
>
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_trans_inode.c | 17 +++--------------
>  fs/xfs/xfs_iops.c               |  4 ++++
>  2 files changed, 7 insertions(+), 14 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 8b5547073379..78bf7f491462 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -71,6 +71,8 @@ xfs_trans_ichgtime(
>                 inode->i_ctime = tv;
>         if (flags & XFS_ICHGTIME_CREATE)
>                 ip->i_crtime = tv;
> +       if (flags & (XFS_ICHGTIME_MOD|XFS_ICHGTIME_CHG))
> +               inode_inc_iversion(inode);
>  }
>
>  /*
> @@ -116,20 +118,7 @@ xfs_trans_log_inode(
>                 spin_unlock(&inode->i_lock);
>         }
>
> -       /*
> -        * First time we log the inode in a transaction, bump the inode change
> -        * counter if it is configured for this to occur. While we have the
> -        * inode locked exclusively for metadata modification, we can usually
> -        * avoid setting XFS_ILOG_CORE if no one has queried the value since
> -        * the last time it was incremented. If we have XFS_ILOG_CORE already
> -        * set however, then go ahead and bump the i_version counter
> -        * unconditionally.
> -        */
> -       if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
> -               if (IS_I_VERSION(inode) &&
> -                   inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
> -                       iversion_flags = XFS_ILOG_CORE;
> -       }
> +       set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags);
>
>         /*
>          * If we're updating the inode core or the timestamps and it's possible
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 45518b8c613c..162e044c7f56 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -718,6 +718,7 @@ xfs_setattr_nonsize(
>         }
>
>         setattr_copy(mnt_userns, inode, iattr);
> +       inode_inc_iversion(inode);
>         xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>
>         XFS_STATS_INC(mp, xs_ig_attrchg);
> @@ -943,6 +944,7 @@ xfs_setattr_size(
>
>         ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
>         setattr_copy(mnt_userns, inode, iattr);
> +       inode_inc_iversion(inode);
>         xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>
>         XFS_STATS_INC(mp, xs_ig_attrchg);
> @@ -1047,6 +1049,8 @@ xfs_vn_update_time(
>                 inode->i_mtime = *now;
>         if (flags & S_ATIME)
>                 inode->i_atime = *now;
> +       if ((flags & S_VERSION) && inode_maybe_inc_iversion(inode, false))
> +               log_flags |= XFS_ILOG_CORE;
>
>         xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>         xfs_trans_log_inode(tp, ip, log_flags);
> --
> 2.37.2
>

I have a test (details below) that shows an open issue with NFSv4.x +
fscache where an xfs exported filesystem would trigger unnecessary
over the wire READs after a umount/mount cycle of the NFS mount.  I
previously tracked this down to atime updates, but never followed
through on any patch.  Now that Jeff worked it out and this patch is
under review, I built 5.19 vanilla, retested, then built 5.19 + this
patch and verified the problem is fixed.
You can add:
Tested-by: Dave Wysochanski <dwysocha@redhat.com>



# ./t0_bz1913591.sh 4.1 xfs relatime
Setting NFS vers=4.1 filesystem to xfs and mount options relatime,rw
 0. On NFS server, setup export with xfs filesystem on loop device
/dev/loop0 /export/dir1 xfs
rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
 1. On NFS client, install and enable cachefilesd
 2. On NFS client, mount -o vers=4.1,fsc 127.0.0.1:/export/dir1 /mnt
 3. On NFS client, dd if=/dev/zero of=/mnt/file1.bin bs=4096 count=1
 4. On NFS client, echo 3 > /proc/sys/vm/drop_caches
 5. On NFS client, dd if=/mnt/file1.bin of=/dev/null (read into fscache)
 6. On NFS client, umount /mnt
 7. On NFS client, mount -o vers=4.1,fsc 127.0.0.1:/export/dir1 /mnt
 8. On NFS client, repeat steps 4-5 (read from fscache)
 9. On NFS client, check for READ ops (1st number) > 0 in /proc/self/mountstats
Found 4200 NFS READ and READ_PLUS ops in /proc/self/mountstats > 0
                READ: 1 1 0 220 4200 0 0 1 0
           READ_PLUS: 0 0 0 0 0 0 0 0 0
FAILED TEST ./t0_bz1913591.sh on kernel 5.19.0 with NFS vers=4.1
exported filesystem xfs options relatime,rw


# ./t0_bz1913591.sh 4.1 xfs relatime
Setting NFS vers=4.1 filesystem to xfs and mount options relatime,rw
 0. On NFS server, setup export with xfs filesystem on loop device
/dev/loop0 /export/dir1 xfs
rw,seclabel,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota 0 0
 1. On NFS client, install and enable cachefilesd
 2. On NFS client, mount -o vers=4.1,fsc 127.0.0.1:/export/dir1 /mnt
 3. On NFS client, dd if=/dev/zero of=/mnt/file1.bin bs=4096 count=1
 4. On NFS client, echo 3 > /proc/sys/vm/drop_caches
 5. On NFS client, dd if=/mnt/file1.bin of=/dev/null (read into fscache)
 6. On NFS client, umount /mnt
 7. On NFS client, mount -o vers=4.1,fsc 127.0.0.1:/export/dir1 /mnt
 8. On NFS client, repeat steps 4-5 (read from fscache)
 9. On NFS client, check for READ ops (1st number) > 0 in /proc/self/mountstats
10. On NFS client, check /proc/fs/fscache/stats fscache reads incrementing
PASSED TEST ./t0_bz1913591.sh on kernel 5.19.0i_version+ with NFS
vers=4.1 exported filesystem xfs options relatime,rw

