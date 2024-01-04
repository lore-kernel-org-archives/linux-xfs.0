Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AEC18EA8
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kc+mcHtM"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6dbd87b706aso30370a34.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Jan 2024 19:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704339445; x=1704944245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufEpKC6OIZPWtjvMw/jE8XpkmAJH6aRuBbFm+u+6iXM=;
        b=Kc+mcHtM08A28hBEvXhym6O0Fv6XIDZwUu4Zx151RCKtkT1YbAvN6G3+JIAOTGPsmK
         +RUvBvtIT1n752tUhMjWPLCuex9mUagl+nYebnHDshrmknJ+UPPO5bYA24ItgQXWVgee
         MPlgk07GZqDWfhDbZUrLn2EUYgwPJ2vWpdxQaoYQlzvi5RvCq6oR9bR4Aw+OdTrg0OjZ
         v+H7t5iEut4Tar1xwd12irZfi3e77x2/c79Or96dfOeIcRoIJplcZP1mUCs1NTq+5VPy
         5lGhGwwKhJzH4AwSsSxVL8lo2MQbzr+MUs+pCiTl7d55AFKSbVxKUGExYCL4gGdl572q
         q2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704339445; x=1704944245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ufEpKC6OIZPWtjvMw/jE8XpkmAJH6aRuBbFm+u+6iXM=;
        b=GMYFDJxm4ANRQTJdw2dLi6nVNAH33un41Zlpk0oDjyulnnulxhXChZK5vIvitzgAKQ
         tLcsEFFbTiojleC4vEjSYRxXynjWVNEDOniPZc35mdqlEXT1Ui/Fhy9ZKAbph5OnaIZb
         4+96juU2W1KbV18uTOIuSsGb5Sq8fEe20RloLBDdITJeiwiEK4makX9tzOJ2UYAF/3SI
         K54WMPPXt+M1RLGPR0VJ+ZQrJzOK0qNCbs/wcku2kYGdSNumY4LuNVMI+ghYU78/dL2Z
         t7DOsQgxJoU8btJfoDnSSxYPmf+kGXqsL8r3IJpGAndohVnxFSeayw5JPLbLfJKkvPZ8
         FYHw==
X-Gm-Message-State: AOJu0YyloMRwlmt+LKFlpubO9t5QlNzYWg+Uf81lB1T6wWyEB+VV6otf
	f9QUQmC9LMqT6ssTQ4JoxoBKwgoOtC63ARWrJ+E=
X-Google-Smtp-Source: AGHT+IE4z9aT15EilKJh2LwqwI1MW6KGa89MI5ZcPaLsiX1omq6pCw55v9ets+Ky7jiO1+bJm2NKHvEjvr4zQx1Pkk4=
X-Received: by 2002:a4a:d6da:0:b0:596:249c:936b with SMTP id
 j26-20020a4ad6da000000b00596249c936bmr71067oot.1.1704339445051; Wed, 03 Jan
 2024 19:37:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214150708.77586-1-wenjianhn@gmail.com> <20231223105632.85286-1-wenjianhn@gmail.com>
 <20240103014209.GH361584@frogsfrogsfrogs> <CAMXzGWJZHpatRBBJsH04B9GWNEVntGjU3WHQS-nDiC4wN2_HjQ@mail.gmail.com>
 <20240104014618.GR361584@frogsfrogsfrogs>
In-Reply-To: <20240104014618.GR361584@frogsfrogsfrogs>
From: Jian Wen <wenjianhn@gmail.com>
Date: Thu, 4 Jan 2024 11:36:48 +0800
Message-ID: <CAMXzGWLpYazOAyW0v4M1=JGZicmV-jskGE-u19nS7z83oovBSQ@mail.gmail.com>
Subject: Re: [PATCH v3] xfs: improve handling of prjquot ENOSPC
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com, 
	Dave Chinner <david@fromorbit.com>, Jian Wen <wenjian1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 4, 2024 at 9:46=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:

> > > > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > > > index 80c8f851a2f3..c5f4a170eef1 100644
> > > > --- a/fs/xfs/xfs_dquot.h
> > > > +++ b/fs/xfs/xfs_dquot.h
> > > > @@ -183,6 +183,19 @@ xfs_dquot_is_enforced(
> > > >       return false;
> > > >  }
> > > >
> > > > +static inline bool
> > > > +xfs_dquot_is_enospc(
> > >
> > > I don't like encoding error codes in a function name, especially sinc=
e
> > > EDQUOT is used for more dquot types than ENOSPC.
> > >
> > > "xfs_dquot_hardlimit_exceeded" ?
> > >
> > > > +     struct xfs_dquot        *dqp)
> > > > +{
> > > > +     if (!dqp)
> > > > +             return false;
> > > > +     if (!xfs_dquot_is_enforced(dqp))
> > > > +             return false;
> > > > +     if (dqp->q_blk.hardlimit - dqp->q_blk.reserved > 0)
> > > > +             return false;
> > >
> > >         return q_blk.reserved > dqp->q_blk.hardlimit; ?
> > >
> > > hardlimit =3D=3D reserved shouldn't be considered an edquot condition=
.
> > >
> > > Also, locking is needed here.
>
> Any response to this?
I will address it in v4.

> > >
> > > Also, a question for Dave: What happens if xfs_trans_dqresv detects a
> > > fatal overage in the project dquot, but the overage condition clears =
by
> > > the time this caller rechecks the dquot?  Is it ok that we then retur=
n
> > > EDQUOT whereas the current code would return ENOSPC?
The v3 patch will return EDQUOT if the condition clears. e.g.

STATIC ssize_t
xfs_file_buffered_write(
...
if (ret =3D=3D -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquot))
       ret =3D -ENOSPC;

ret will not be translated from EDQUOT to ENOSPC.
>
> I think this question is still relevant, though.  Or perhaps we should
> define our own code for project quota exceeded, and translate that to
> ENOSPC in the callers?
>
> I wonder, what about the xfs_trans_reserve_quota_nblks in
> xfs_reflink_remap_extent?  Does it need to filter EDQUOT?
Yes, it does.  I will address it in v4.
>
> Just looking through the list, I think xfs_ioctl_setattr_get_trans and
> xfs_setattr_nonsize also need to check for EDQUOT and project dquots
> being over, don't they?
Yes, xfs_trans_alloc_ichange has got them covered.
