Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EC834F479
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 09:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774429882; cv=pass; b=leGlALNVWmkX/RNOO6DMsd9Vc8czVodF/1rDZHAbZAf8lg5mAVZ+oJs+TMA7oO5YoGMMg7rZUBNSteb5RTr41csA7zRdkl0tDfwK/RGknzW+OfT7gUYTrKsubCAUpP8Y520tAYuVr/3Xt9cJ3BBlBTg3IHvibvPVXwY4bfxEFF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774429882; c=relaxed/simple;
	bh=fC/uan4rX3inFfsncSFitcekyi4kXWLCiPnm/SCAVVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zud8iKp/fcYpQU7BYaSCIsMIAHRd5dzPUXZqdx5TjN24GBOXomVWqveWbKBKOiMF+tr2I2Nzcc6IXqwCGrEgA+cZ2I7xN9Vnd8YR4pTadElWhu5iBhbDscFRInhr2d+X/8DBlnMLv/mrkIKlPbmw9Y6G/SMBwOsgKm1ce8uuLCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W4ec+noo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=L4G+yN5D; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4ec+noo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="L4G+yN5D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774429879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hmvsQXtzuSu9Q8Jr3K2x2Gsrg0C8mhjQT/B1CvBhxZY=;
	b=W4ec+nooFAl9B+Cuw6CzA7/INY84af8nvaBT+a6yrA+yHe1odHEmTCC4b6YXCA5VK5FpED
	Z1hW8lPWNMHWik+EIlQ8oF66zf5OqYzgpKKk8Vbk/AMC/2xKF1rNC/LOpLHWIzs5INBjIO
	8DlAwhoepeZgFqkipIWrpe4uJoDC7xg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-7mdLCpdvMB-1MQWS_BP93w-1; Wed, 25 Mar 2026 05:11:17 -0400
X-MC-Unique: 7mdLCpdvMB-1MQWS_BP93w-1
X-Mimecast-MFC-AGG-ID: 7mdLCpdvMB-1MQWS_BP93w_1774429877
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b97c2e6f6daso985208366b.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 02:11:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774429877; cv=none;
        d=google.com; s=arc-20240605;
        b=A6XlOcejUqogwTxK4A1M3OECwZ/9f6RTuCDnUc+EdMF2esi1kLZx8SXJcg+kNL+8Mu
         f6dD3NmJtHARkcWuOdNH+TMOM0N3NEWHQlXHOduxhV0aEKmMVP2lfaRo6yhnci6MKLFx
         hIHaraco2s1cI2h73KZk5i/vjvKa8xxl6nCSOoVJQ7h2hudkXUA/s4VkcpvsgojOcLit
         cGwdGMlN8kFxRabN484sb73ac2/f69l6xmAALPF255ONzd4YIpsZoDH2fI7PxVh5D4Ub
         +KnMZjZtA0dbhDMidc3yAwLJQ7vMZAd5vePIK/FNA4zz02lmHnZ0A2RfGrVJza+cINSP
         F/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hmvsQXtzuSu9Q8Jr3K2x2Gsrg0C8mhjQT/B1CvBhxZY=;
        fh=uv0HusliuflhTn+WEjIVDbn+kBApYy54IFq1+GLR5d0=;
        b=KWRZqmTQggHxs6d+KbN2a/i/LfAhIHegoCj8BNT+5R9JH0keSHsZB4Ws2Fp1PqInpb
         wb2fIO4lxVv1NLtqylWARdz1kuXsZ0BtSpsRvzmqW/eT8o1oHOda8Mm76AczIo8GqMhk
         gIYNSoDZYVIqtz6+hFKqSzDZJDwNnnVPWdfDnp9/ulCP7P3rbgsVMJqIaB2GEXtixR3c
         tD0NoLzQSpevlv1u6bNd/GB+tKc/GvqMv+Frt7pwkl3eK5n29bXNQkb0Y4d2ReuzqH6e
         bcrIPGarqXLN31R6XgTGsHo79GUYvMZXAQk7YyCHAXaloAjK8oQbLf/zayOsRPI1Al/P
         8iHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774429877; x=1775034677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hmvsQXtzuSu9Q8Jr3K2x2Gsrg0C8mhjQT/B1CvBhxZY=;
        b=L4G+yN5Dmfw2j4/6OKnYeZT6xAYWBOqaaTxBXEy210oTwMpfr9eJZG7dUHtY9bzIiZ
         mZfkYZ9hxRalJdMNYfegIQPcQvkXKq+Aq/Vpyizh12kHsVL9CDrPlq+aYwDJUvZJOmhm
         kSPXdcoY2I1LwWReAlhDe/m3J9Vtof0TIpuWs/CcCWVzARuIkidJEfxxXQJRmc8laIvd
         yY9EPcVT3i6aWi/gyGggh/0eZ1a41C6/ZZro8sFhzZcd817ZEd9hrqpeCQ3nlLBlk9BJ
         IwHe2Em1bd8VddylQpKwYdMxH2QVQDZNfGFcAvhHCIz0l8D+qgA0yhkFpte8zO0TdSnE
         lDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429877; x=1775034677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hmvsQXtzuSu9Q8Jr3K2x2Gsrg0C8mhjQT/B1CvBhxZY=;
        b=pwxAeT0UR0LWpIoo50R6ONPrkAew1Z6d3am7+tjRQ2BybLdWRG9r/DnWYKzlSiAx88
         6WIA7Bd7A8IXf1N0h+XLuWDWk2s22zaFV4OSReVe6o9S+TC8NdTd9jhowpRKAMa01Qcm
         lOMxMVAwI3f9WDaRQabdNa25UylPPSTYb6IB61mw0ABILq39M/hTVIpjb4xrIjMp2dDc
         s/HQg2OCfmzQaN1zjvvY609fADHovZwnoyf/LB+kaaNTfYYQ32WQ5pjGV1VcyzuH8wkl
         CX4juzeVcoGQnKvftu3K/prYweH41SaVCAW+qttFLddb/uJnmB0q5hc+8r+W6mp9BRGQ
         Uoyw==
X-Forwarded-Encrypted: i=1; AJvYcCVx2NyDRVbcN3IRZkENynfiMcGxbDGPYvWYNWg57x5gdMxN9uMTWp1mR3AxB0QEqScyxjkSEIaiiek=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ2KaaitlOwylHWbldfLK2Zoauoqi7h3ZErAJC1vlRCWdqX7Nh
	WAXBFrwbMgtQ9QU5wqLQexXGQOm1ADu5zMGqBqQMoj0p5zQ+UHvLDw1zfT41UtV7ouum82CjpKX
	m9KTEoWx6JHBk9GpOjjfH3mVy5leRWgIjJOy5hCbAJq9weNScPLeI22SuEpUyvkhCz6EA7EX1su
	aq3iGNuN46itk3dJinzqvrtfonSn8KkzhYcGDm
X-Gm-Gg: ATEYQzy3X13dyt8elYOTnBMu3eoNTLfH3lhvZz9b1hPzoahrKI/Xb3GzeSuDCV9vn2J
	Ds45gUkq2cYdMF1OQLzsXc0F166WFxwLC0OvhfzZ8z1hMKPjLqYGmFS5rKt9LunIy7GJH1wox8m
	Bf5Y7yIMCcaav7SvLSYIHN5qQqpvxpSnC3Xiz6H/Vy3HeXFbZYP3y8ju7QcC9ohNhxSmHtScd5T
	RP9fkIe
X-Received: by 2002:a17:906:9f8c:b0:b96:f9c9:9d2b with SMTP id a640c23a62f3a-b9a3f175fa8mr182596766b.8.1774429876537;
        Wed, 25 Mar 2026 02:11:16 -0700 (PDT)
X-Received: by 2002:a17:906:9f8c:b0:b96:f9c9:9d2b with SMTP id
 a640c23a62f3a-b9a3f175fa8mr182594866b.8.1774429875909; Wed, 25 Mar 2026
 02:11:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312090810.1145908-1-ravising@redhat.com> <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
 <20260317133159.GA53921@macsyma-wired.lan> <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>
 <20260318221810.GM1742010@frogsfrogsfrogs> <waksu55vh2fm74ltktchuckhezkjq4ggaooqrosixfzsuli5uo@i4q6ixu7r56x>
 <CAF-d4OvGmXWRinOB_qQYbCX9pckGLQbu1pghqDm-LhzHOaQY6Q@mail.gmail.com> <20260325001621.GD6202@frogsfrogsfrogs>
In-Reply-To: <20260325001621.GD6202@frogsfrogsfrogs>
From: Ravi Singh <ravising@redhat.com>
Date: Wed, 25 Mar 2026 14:41:04 +0530
X-Gm-Features: AQROBzC8tgx3qd4si6PDAOTlzXEzyAPXs8WmE2qMsH4v5rPfZkMUDH8EqM9CWmY
Message-ID: <CAF-d4Otft7-QYWJCRzgD3xKRqXdSMSTyuKebpLP_hNgJctsAkA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a dquot
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, adilger@dilger.ca, jack@suse.com, 
	cem@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 5:46=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Mon, Mar 23, 2026 at 04:55:31PM +0530, Ravi Singh wrote:
> > Hi all,
> >
> > Thanks for the feedback. Before posting a v3, I wanted to share some
> > additional findings. The v2 patch only covers one of three scenarios
> > where an unprivileged user cannot see the default limits applying to th=
em.
> >
> > Scenario 1: No dquot on disk (v2 fixes this):
> > xfs_qm_dqget() returns -ENOENT, and v2 catches it.
> >
> > mkfs.xfs /dev/vde -f
> > mount -o quota /dev/vde /mnt/test
> > xfs_quota -xc 'limit -u bsoft=3D10m bhard=3D20m 0' /mnt/test
> > # Do NOT chown anything to testuser8 - no dquot exists
> > su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
> >
> > Without fix: empty output
> > With fix:
> > Disk quotas for User testuser8 (1003)
> > Filesystem              Blocks      Quota      Limit  Warn/Time      Mo=
unted on
> >  /dev/vde                     0      10240      20480   00 [--------] /=
mnt/test
>
> Hmm, yes, that looks like a bug to me.

Thanks for confirming.

>
> > Scenario 2: dquot exists with non-zero counts but zero limits (v2 does =
NOT fix):
> >
> > A dquot is created for testuser8 before default limits are configured.
> > When the chown runs, xfs_qm_adjust_dqlimits() is called in
> > xfs_trans_apply_dquot_deltas(), but the defaults are all zero at that
> > point so nothing is pushed into the dquot. When the admin later sets
> > limits on ID 0, testuser8's existing dquot is not retroactively updated=
.
> > xfs_qm_dqget() succeeds and XFS_IS_DQUOT_UNINITIALIZED is
> > false (q_ino.count !=3D 0), so xfs_qm_scall_getquota_fill_qc() returns
> > the dquot's zero limits.
>
> I think this is a difference in opinion -- the last time I checked, the
> default limits are only supposed to be propagated to newly allocated
> ondisk dquots.

Understood: Scenario 2 is by design.

>
> It's true that it would make more sense if the ondisk dquot had a flag
> to say "I've had limits applied here" such that default limits would
> apply to a dquot that already existed on disk but hadn't had limits set.
> Plus then you could modify a dquot with explicit limits to revert back
> to the defaults.
>
> Unfortunately there's no such flag in the ondisk format so we'd have to
> rev the disk format to add that behavior.  As such ... I don't think
> this is easily fixable.  The only way you could revert to defaults is
> if...
>
> > mkfs.xfs /dev/vde -f
> > mount -o quota /dev/vde /mnt/test
> > mkdir /mnt/test/testuser8
> > chown testuser8:testuser8 /mnt/test/testuser8
> > xfs_quota -xc 'limit -u bsoft=3D10m bhard=3D20m 0' /mnt/test
> > su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
> > # empty output
> >
> > Scenario 3 : dquot all zeros / XFS_IS_DQUOT_UNINITIALIZED (v2 does NOT =
fix):
> >
> > A dquot record persists on disk with all zero fields after ownership
> > is transferred away. xfs_qm_dqget() succeeds, but XFS_IS_DQUOT_UNINITIA=
LIZED
> > returns true and the query returns -ENOENT. The v2 fallback does not
> > trigger because it only handles the xfs_qm_dqget() error path.
>
> ...you delete all usage for the dquot and set the limits to zero, right?
> Or does setting the limits to zero actually work even if there's quota
> usage?

Setting limits to zero alone isn't enough. XFS_IS_DQUOT_UNINITIALIZED
checks both limits and counts (q_blk.count, q_rtb.count, q_ino.count),
so all of them must be zero. In the reproduction, the chown back to
root moves the inode count back to 0, that's what makes all fields zero.
If the user still owns any files, q_ino.count would be non-zero
and the dquot would not be considered uninitialized.

>
> Either way if the ondisk dquot is totally uninitialized then I don't
> think we need to emit a record unless there's also a default limit.
>
> > mkfs.xfs /dev/vde -f
> > mount -o quota /dev/vde /mnt/test
> > mkdir /mnt/test/testuser8
> > chown testuser8:testuser8 /mnt/test/testuser8
> > chown root:root /mnt/test/testuser8
> > xfs_quota -xc 'limit -u bsoft=3D10m bhard=3D20m 0' /mnt/test
> > su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
> > # empty output
> >
> > I see two approaches for v3 and would appreciate guidance:
> >
> > 1. Fix all three in xfs_qm_scall_getquota() by merging default limits
> >     into the response for any zero-valued limit field, mirroring
> >     xfs_qm_adjust_dqlimits().
> > 2.  Expose default limits through Q_XGETQSTATV using the available
> >      padding space in fs_quota_statv, as Jan suggested, and let
> >      userspace tools merge them.
> >
> > Thoughts?
>
> I don't think we should create more userspace abi since nobody seems to
> think that anyone uses quota limit reporting aggressively.  But if
> anyone does, now would be a good time to say something.

Agreed. Thanks for the feedback!

>
> --D
>
> > Thanks,
> > Ravi
> >
> >
>

