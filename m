Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C47C14B
	for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2023 11:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PKHXJYjs"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6dbc2bf4e8dso415372a34.1
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2023 03:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703329250; x=1703934050; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VILrGyAYT0i2NmKYaOjVLWXTyxkrTNbUAn+Codd2WJo=;
        b=PKHXJYjshcKPTDMNnpxtttw6S1DfJ0GSM07Ru1V0Avfy2Nw+LiLlph0Hb2XJ2Eplao
         p6ga3DwhIbS41QlkhO1LGbX738uhUcvTPPoG/VlUnubkFq0ms+e7+aU99QiKpMNoJeRW
         b8V7UrFOS3cSLSW12cLHehEevLD9LNm62wx4Y8M/lj7rj5BtuxpzSu+mhctRn9TDrXnf
         q1aF1Wn2s+S77vsynW1UoUl1q1XBMy7vwLgkgRSlUxyG40CRrRrdRTMQOzIDko36Y70Z
         iW+hK4I9UyA8BQ7ddtcYeQyhlxuujyZmHAsrVMRNgOcvKVpZSwYxLhGx1TOY3PuhK8R9
         VQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703329250; x=1703934050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VILrGyAYT0i2NmKYaOjVLWXTyxkrTNbUAn+Codd2WJo=;
        b=tYa+zPV2//CpIV3z00flB2lqyM8RXb778wFUqHiuQyvWFYHbpb3Kg2HHkds6TYEpVY
         KPmy7nS01cz8AE1frG/fK6578MBtw3SCwQhsQgKCIb7PeG/op6nT2Np0hqP6syLltbBC
         KKAgBpVz+mzuNHpwP4C0xh3xPn2Z9bUF3KggRT2lBcobpjNSuofWHS4QzjAJwQsqz+5Q
         6P8tnHmyw4xaPGjjy77SZAuzfXyZo2uRgIFrTFpNqCt3Uov2K4ILCKuCEKeNjFXE8YVr
         Zwn3H3G/uhHujLZ7AEa1OOY84u9tFua/yO3vu/5nayMSrpwH1Q/4a9NNIbq2u6aXU+ge
         8kgw==
X-Gm-Message-State: AOJu0Yy/mT5yDoCMBFWAM/Q1vVFbV/utOfA78pHnwwtLqUeGuywm+MVp
	VSo8ohH+NIXCzZ4HAD1vJFLs9vOdiWZ+FcPePZj8/PEeNls=
X-Google-Smtp-Source: AGHT+IERHipZlJMEQaO/0rtauAcoFETr9NbyA293rKtYEPdkV2KCKaRYgvJJqmXw7HN97563vd1ETKTCcCcK0ccXzSw=
X-Received: by 2002:a05:6820:1043:b0:594:36ea:b0ce with SMTP id
 x3-20020a056820104300b0059436eab0cemr4004707oot.0.1703329249704; Sat, 23 Dec
 2023 03:00:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214150708.77586-1-wenjianhn@gmail.com> <20231216153522.52767-1-wenjianhn@gmail.com>
 <ZYDBBmZWabnbd3zq@dread.disaster.area>
In-Reply-To: <ZYDBBmZWabnbd3zq@dread.disaster.area>
From: Jian Wen <wenjianhn@gmail.com>
Date: Sat, 23 Dec 2023 19:00:13 +0800
Message-ID: <CAMXzGW+ooGhvP1mHvEco5u97XUG+PO=bHD6Exx17oea7pjq3ew@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: improve handling of prjquot ENOSPC
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de, 
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 6:00=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
> So, with the assumption that project quotas return EDQUOT and not
> ENOSPC, we add this helper to fs/xfs/xfs_dquot.h:
>
> static inline bool
> xfs_dquot_is_enospc(
>         struct xfs_dquot        *dqp)
> {
>         if (!dqp)
>                 return false;
>         if (!xfs_dquot_is_enforced(dqp)
>                 return false;
>         if (dqp->q_blk.hardlimit - dqp->q_blk.reserved > 0)
I need some help on how to improve the above enospc check.
It seems that we need a value that is larger than 0.

4.0K space is available.
# df -h ./
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1       100M  100M  4.0K 100% /tmp/roothome/vda

ENOSPC is expected, but gets EDQUOT.
# touch t
touch: cannot touch 't': Disk quota exceeded

>
> The buffered write code ends up as:
>
>         .....
>         do {
>                 iolock =3D XFS_IOLOCK_EXCL;
>                 ret =3D xfs_ilock_iocb(iocb, iolock);
>                 if (ret)
>                         return ret;
>
>                 ret =3D xfs_file_write_checks(iocb, from, &iolock);
>                 if (ret)
>                         goto out;
>
>                 trace_xfs_file_buffered_write(iocb, from);
>                 ret =3D iomap_file_buffered_write(iocb, from,
>                                 &xfs_buffered_write_iomap_ops);
>                 if (!(ret =3D=3D -EDQUOT || ret =3D -ENOSPC))
>                         break;
>
>                 xfs_iunlock(ip, iolock);
xfs_iunlock() is called after the retry.
>                 xfs_blockgc_nospace_flush(ip, ret);
>         } while (retries++ =3D=3D 0);
>
>         if (ret =3D=3D -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquot))
>                 ret =3D -ENOSPC;
>         .....
out:
        if (iolock)
                xfs_iunlock(ip, iolock);
Double xfs_iunlock().

Please take a look at the v3 patch.
Thanks.
