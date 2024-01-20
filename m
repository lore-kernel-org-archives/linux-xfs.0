Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6A3D2F1
	for <linux-xfs@vger.kernel.org>; Sat, 20 Jan 2024 08:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705740616; cv=none; b=nmCQRdHNlPF0RjEUGIKHm86i6UCg+lmy4s9242MLSy3kwgveDgJ005xJblc68rFN2VPIrEvjMzmax67LT8WeE9VV4woR2UAHOkN7edh1Q8dfyw8rpL2nqqqqohxoCmZhcc0LXamw5ooOari1VCRp9iNSHATOf1tamYZXZMnzTFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705740616; c=relaxed/simple;
	bh=MjCrcomybm4hurNoInZvaLKNIQQiyTnj+oIxjkynVTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aitLDXidkt7ulWMx+GxKNrpu34JM9SohbA3x8ssd4Cw84bijiOggpRNWG39IQHH5rwwC+Gnf4apDup74lfdn3c3p3aQIqQNnjjSixbztOc2+fcAaPrin7gkcn67W1tMKyTS7ywWbZ+kYJa7P09VAwoXk+B69cIt3Mp4+UYKlQY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z7dJ7bZs; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z7dJ7bZs"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-681397137afso11733786d6.1
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jan 2024 00:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705740614; x=1706345414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJUK17aflggocfkmehHfKXuoXVAzC+wWIf0Dw+WmzO0=;
        b=Z7dJ7bZsPexpEvfLQDTwXQw2xBcFNKdVCiLZEgD+McBoq93ARtbYAYS8/KdSnN4JUy
         UWsKc9yaCecT2AHMBv6zDAVKVo+jfwDDNqB5B1ZLDbHZo2aOYc9k4495maDa6rqEMxm2
         87HerrQZewk467xFhRnEeMUD1Gwo+Mh9twdscGouHZ69t/uiBzrvYmMxCMi5mDNgdS7h
         Rud+zxJw5Y9DTPORcgZvCg70hywn5s27YheEMRYPGguacmJAq96ZunhLnUzaq8ZEmNw1
         Zc+3wjuSvtJ1736uiTQYp03TccjAdagqgf10+GzhcFs5MvfkYqhdPTJonQYph2YtDJ0l
         JSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705740614; x=1706345414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJUK17aflggocfkmehHfKXuoXVAzC+wWIf0Dw+WmzO0=;
        b=Zap6mlVj1cbxYqntdcvIXBusU/6AQHcGsakEue5u6c1F6M7WDIkPK/ufD22JDLg+yG
         JgW3irdIW3uFBTFB4MZXjueri7AN1mHcaRU1xcgDm60ea5WDr1VlnFs7NuhqAJDKA3tK
         /Q9vPazNVqwL339Dym4cTeja3PW/qwoLoJSG2jYKPuwo7DxN2CQS4uoR2+36xIGintjT
         I6cJObNftRHagMlV969EoJ43RjUrmX1DVsvZIbDnYcA870KIRxfJ7JX2vG9zJSPvjEYX
         hkhyKncHz1b8d7zuBcYiL21F4IBCVAp2+AQtqwyEq++DXioY1Mx4+7bMle8sAp78w4qG
         6Sww==
X-Gm-Message-State: AOJu0YwYrENDtJpoHoZoGvz3jVfE+dJhG+aKsjBAGuIRkGKC/0jZzTSR
	7Z4OY8rhaWe+/b953JYrMtR0siWsKwETu7cjAk7gteq3bO0fokKTwF2cDZIyv5T/tUUuJDtmHCC
	tpHBJWGHz8MYhrgy9z1Xx4/gHrVw=
X-Google-Smtp-Source: AGHT+IGmRxCYb5WcVS4NEEL4PozUCLCztjHY/yuEujLTLw4UY/aKhyKTvnP/D+O8sJoyD4AJV9vUitGeg4XX9PeVRv8=
X-Received: by 2002:a05:6214:2122:b0:680:bcc:830f with SMTP id
 r2-20020a056214212200b006800bcc830fmr1740825qvc.85.1705740613669; Sat, 20 Jan
 2024 00:50:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240119193645.354214-1-bfoster@redhat.com>
In-Reply-To: <20240119193645.354214-1-bfoster@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 20 Jan 2024 10:50:02 +0200
Message-ID: <CAOQ4uxjWm82=KSQYMPo06kxfU90OBpMDmmQfyZAMS_2ZfJHnrw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 19, 2024 at 9:35=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
>
> We've had reports on distro (pre-deferred inactivation) kernels that
> inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> lock when invoked on a frozen XFS fs. This occurs because
> drop_caches acquires the lock and then blocks in xfs_inactive() on
> transaction alloc for an inode that requires an eofb trim. unfreeze
> then blocks on the same lock and the fs is deadlocked.
>
> With deferred inactivation, the deadlock problem is no longer
> present because ->destroy_inode() no longer blocks whether the fs is
> frozen or not. There is still unfortunate behavior in that lookups
> of a pending inactive inode spin loop waiting for the pending
> inactive state to clear, which won't happen until the fs is
> unfrozen. This was always possible to some degree, but is
> potentially amplified by the fact that reclaim no longer blocks on
> the first inode that requires inactivation work. Instead, we
> populate the inactivation queues indefinitely. The side effect can
> be observed easily by invoking drop_caches on a frozen fs previously
> populated with eofb and/or cowblocks inodes and then running
> anything that relies on inode lookup (i.e., ls).
>
> To mitigate this behavior, invoke a non-sync blockgc scan during the
> freeze sequence to minimize the chance that inode evictions require
> inactivation while the fs is frozen. A synchronous scan would
> provide more of a guarantee, but is potentially unsafe from
> partially frozen context. This is because a file read task may be
> blocked on a write fault while holding iolock (such as when reading
> into a mapped buffer) and a sync scan retries indefinitely on iolock
> failure. Therefore, this adds risk of potential livelock during the
> freeze sequence.
>
> Finally, since the deadlock issue was present for such a long time,
> also document the subtle ->destroy_inode() constraint to avoid
> unintentional reintroduction of the deadlock problem in the future.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Is there an appropriate Fixes: commit that could be mentioned here?
or at least a range of stable kernels to apply this suggested fix?

Thanks,
Amir.

> ---
>
> Hi all,
>
> There was a good amount of discussion on the first version of this patch
> [1] a couple or so years ago now. The main issue was that using a sync
> scan is unsafe in certain cases (best described here [2]), so this
> best-effort approach was considered as a fallback option to improve
> behavior.
>
> The reason I'm reposting this is that it is one of several options for
> dealing with the aforementioned deadlock on stable/distro kernels, so it
> seems to have mutual benefit. Looking back through the original
> discussion, I think there are several ways this could be improved to
> provide the benefit of a sync scan. For example, if the scan could be
> made to run before faults are locked out (re [3]), that may be
> sufficient to allow a sync scan. Or now that freeze_super() actually
> checks for ->sync_fs() errors, an async scan could be followed by a
> check for tagged blockgc entries that triggers an -EBUSY or some error
> return to fail the freeze, which would most likely be a rare and
> transient situation. Etc.
>
> These thoughts are mainly incremental improvements upon some form of
> freeze time scan and may not be of significant additional value given
> current upstream behavior, so this patch takes the simple, best effort
> approach. Thoughts?
>
> Brian
>
> [1] https://lore.kernel.org/linux-xfs/20220113133701.629593-1-bfoster@red=
hat.com/
> [2] https://lore.kernel.org/linux-xfs/20220115224030.GA59729@dread.disast=
er.area/
> [3] https://lore.kernel.org/linux-xfs/Yehvc4g+WakcG1mP@bfoster/
>
>  fs/xfs/xfs_super.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d0009430a627..43e72e266666 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -657,8 +657,13 @@ xfs_fs_alloc_inode(
>  }
>
>  /*
> - * Now that the generic code is guaranteed not to be accessing
> - * the linux inode, we can inactivate and reclaim the inode.
> + * Now that the generic code is guaranteed not to be accessing the inode=
, we can
> + * inactivate and reclaim it.
> + *
> + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while th=
e
> + * filesystem is frozen. Therefore it is generally unsafe to attempt tra=
nsaction
> + * allocation in this context. A transaction alloc that blocks on frozen=
 state
> + * from a context with ->s_umount held will deadlock with unfreeze.
>   */
>  STATIC void
>  xfs_fs_destroy_inode(
> @@ -811,15 +816,18 @@ xfs_fs_sync_fs(
>          * down inodegc because once SB_FREEZE_FS is set it's too late to
>          * prevent inactivation races with freeze. The fs doesn't get cal=
led
>          * again by the freezing process until after SB_FREEZE_FS has bee=
n set,
> -        * so it's now or never.  Same logic applies to speculative alloc=
ation
> -        * garbage collection.
> +        * so it's now or never.
>          *
> -        * We don't care if this is a normal syncfs call that does this o=
r
> -        * freeze that does this - we can run this multiple times without=
 issue
> -        * and we won't race with a restart because a restart can only oc=
cur
> -        * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> +        * The same logic applies to block garbage collection. Run a best=
-effort
> +        * blockgc scan to reduce the working set of inodes that the shri=
nker
> +        * would send to inactivation queue purgatory while frozen. We ca=
n't run
> +        * a sync scan with page faults blocked because that could potent=
ially
> +        * livelock against a read task blocked on a page fault (i.e. if =
reading
> +        * into a mapped buffer) while holding iolock.
>          */
>         if (sb->s_writers.frozen =3D=3D SB_FREEZE_PAGEFAULT) {
> +               xfs_blockgc_free_space(mp, NULL);
> +
>                 xfs_inodegc_stop(mp);
>                 xfs_blockgc_stop(mp);
>         }
> --
> 2.42.0
>
>
