Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9411F27E058
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 20:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757967655; cv=none; b=V35QUR1PvTDXE2OPZp4hqZkY+EZiYnXiKZL7EoplRm+XH3VYq3OS8GHy6jaResnvvafs0lQbEpwv83qh94hC3F5SngkiQdfEC0QNNfT0veQrZNgbMasP+VZc3ELLh1XfE7v8IugkQiv3IFRg4VteMNuobeX6zQt7bPaRWWN//oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757967655; c=relaxed/simple;
	bh=+SLUOZGs/qS2cXaKoug7x+JwelyJoUiOaA7pbJGRa9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NvHDa2FgaUToKviESTunteQsNEuyW5j+BYVVuPeLIHe9b1TB3lyMf2y4TWae30YCLqx8//U3MyFt4M+BSCHoZ58ARv9vda54uTgr5WjkdMv0TvYof5dfvbT9jY7r+Ikmta3praoxH2a5+4N+0VBCZbf281mMbqCkiqV4XR+Hy08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ba4SaV62; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ba4SaV62"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso7947911a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757967652; x=1758572452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jcV4wf+5WuOoeJKKBkai9T7otnt8wOzWs/vg6TVn+7A=;
        b=Ba4SaV62pTWNr6EEoguOsWNxRtcAxj66/6IkQPAaxblECwqwQIEzPqOBHreyIxYjRV
         8wkJQMzRvcwO6+qlGv/EzWRcnUpHL0ltzyXAEG7X3VkvGB5AzfR3isK4PfiKRBsTTPEJ
         LbXpPBRuUGddATX8pHy/x2hrNLgYs3vkXvPdHY2UkbnMHWWVxQMMF/2t6drCSVzlEiRe
         0NhRVopH2BbbZnrVQr1IfUOHwvU5Z3bPjJklHVxsFOwEcfMG5Rq9cSZpzvZRrMzQH724
         THHo3f+1/KroN8Mqkgy5ex8o+as22hjJHLAMYVM4gRLS7bnSEX0JXxQTPwuHXwpRWYl+
         GkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757967652; x=1758572452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jcV4wf+5WuOoeJKKBkai9T7otnt8wOzWs/vg6TVn+7A=;
        b=CPHqkIoSrK7BQuCh+SttNg+E29eXM7vSGdrckbfzSOLrOY8BscoUKLxo4er4zClg3G
         65FbZn7BT8KGrq98t+i3NnusFLEHMzGISLzcW8a33FI/+eln5wJFkYhOktA6Fk172FDy
         Kr9MOMsiNTnIAquKPyFcJ6czmiS1+CKM6ZhByDlNRnTn21IF158xmJM+yJXywyTFwi1N
         5TO05nCDiVCHQlrY5qmeDlRaud5z92MCLmedQo1yqDuCcsdaN087X2hN1BUdCDlskPZu
         G+RWnwXbgVIlhoa3H2myG31YAI9Vv80OSWan51wDUTVKjVOaA/dLQinkH850o552+pFJ
         5/2A==
X-Forwarded-Encrypted: i=1; AJvYcCWtjqJWbI07ijQL/Af9+XispFMZzdWE3JuHOyRCFCA55u1MqshNpgOlOMYf7MXAAnS2YG3eP4NnRQo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhPwGjR43zn0RgKz8NLiclHr8tkgjxiNWQn0yyZ5KbVB5DSWNL
	eOLnAKP3x03bB8TsdDdQTAxz7In/rNYumPm09ByJj8lQaYrmF7UI3mOIRQOiOqXrixm6FwXi5B3
	ws+WAFm1EGqVkxDO6QUkVsgkEoWTsag8=
X-Gm-Gg: ASbGnctrRcjLpTNW+ONIvWhcjmujB0YUgJr7iZyoJBtnl78X9yMTJbeEaigSaebmInR
	wdUXOEuhj/r01QS3yOpb4ebgGYo7jL+7wHNF0rmOY7lQ9G9Bpl3PfmFg3pPE0wIB7G1GVwPmjAc
	kW8m3krKT9ZE9hzQf0fxEcw/bFHkZUf9TZQAwJmA8nJWNnIMMMRMbzvMGwUjeLBT0Oye71nNsDd
	YNFdw24ppZShqlKrlB0lVyr0FTYJ/HD3u4O0SRpMXtnCdLOzu3i
X-Google-Smtp-Source: AGHT+IGYABGg7Uj58FeWOIrBs5TeeS8JiH8hNIJ+ma9m4krolqPGMWxATE1E0UGWN02bDuIslGoQuD0eAuM4rI8wTxU=
X-Received: by 2002:a05:6402:524e:b0:62f:4f1b:891d with SMTP id
 4fb4d7f45d1cf-62f4f1b9917mr2408740a12.2.1757967651735; Mon, 15 Sep 2025
 13:20:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250913030503.433914-1-amir73il@gmail.com> <20250915182056.GO8096@frogsfrogsfrogs>
In-Reply-To: <20250915182056.GO8096@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Sep 2025 22:20:40 +0200
X-Gm-Features: AS18NWAt3QLFx-SVagIXEf_zp-tZNYESWbPWrYnKJUdNAFCyHFTA7DKGZO2-Wjs
Message-ID: <CAOQ4uxg4eBMS-FQADVYLGVh66QfMO+tHDAv3TUSpKqXn==XdKw@mail.gmail.com>
Subject: Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Catherine Hoang <catherine.hoang@oracle.com>, 
	Leah Rumancik <leah.rumancik@gmail.com>, Allison Henderson <allison.henderson@oracle.com>, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 8:20=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Sat, Sep 13, 2025 at 05:05:02AM +0200, Amir Goldstein wrote:
> > From: Allison Henderson <allison.henderson@oracle.com>
> >
> > [ Upstream  commit f103df763563ad6849307ed5985d1513acc586dd ]
> >
> > With parent pointers enabled, a rename operation can update up to 5
> > inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
> > their dquots to a be attached to the transaction chain, so we need
> > to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
> > function xfs_dqlockn to lock an arbitrary number of dquots.
> >
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> >
> > [amir: backport to kernels prior to parent pointers to fix an old bug]
> >
> > A rename operation of a directory (i.e. mv A/C/ B/) may end up changing
> > three different dquot accounts under the following conditions:
> > 1. user (or group) quotas are enabled
> > 2. A/ B/ and C/ have different owner uids (or gids)
> > 3. A/ blocks shrinks after remove of entry C/
> > 4. B/ blocks grows before adding of entry C/
> > 5. A/ ino <=3D XFS_DIR2_MAX_SHORT_INUM
> > 6. B/ ino > XFS_DIR2_MAX_SHORT_INUM
> > 7. C/ is converted from sf to block format, because its parent entry
> >    needs to be stored as 8 bytes (see xfs_dir2_sf_replace_needblock)
> >
> > When all conditions are met (observed in the wild) we get this assertio=
n:
> >
> > XFS: Assertion failed: qtrx, file: fs/xfs/xfs_trans_dquot.c, line: 207
> >
> > The upstream commit fixed this bug as a side effect, so decided to appl=
y
> > it as is rather than changing XFS_QM_TRANS_MAXDQS to 3 in stable kernel=
s.
>
> Heh.  Indeed, you only need MAXDQS=3D=3D5 for filesystems that support
> parent pointers, because only on those filesystems can you end up
> needing to allocate a xattr block either to the new whiteout file or
> free one from the file being unlinked.
>
> > The Fixes commit below is NOT the commit that introduced the bug, but
> > for some reason, which is not explained in the commit message, it fixes
> > the comment to state that highest number of dquots of one type is 3 and
> > not 2 (which leads to the assertion), without actually fixing it.
>
> Agree.
>
> > The change of wording from "usr, grp OR prj" to "usr, grp and prj"
> > suggests that there may have been a confusion between "the number of
> > dquote of one type" and "the number of dquot types" (which is also 3),
> > so the comment change was only accidentally correct.
>
> I interpret the "OR" -> "and" change to reflect the V4 -> V5 transition
> where you actually can have all three dquot types because group/project
> quota are no longer mutually exclusive.
>
> The "...involved in a transaction is 3" part I think is separate, and
> strange that XFS_QM_TRANS_MAXDQS wasn't updated.
>
> > Fixes: 10f73d27c8e9 ("xfs: fix the comment explaining xfs_trans_dqlocke=
djoin")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Christoph,
> >
> > This is a cognitive challenge. can you say what you where thinking in
> > 2013 when making the comment change in the Fixes commit?
> > Is my speculation above correct?
> >
> > Catherine and Leah,
> >
> > I decided that cherry-pick this upstream commit as is with a commit
> > message addendum was the best stable tree strategy.
> > The commit applies cleanly to 5.15.y, so I assume it does for 6.6 and
> > 6.1 as well. I ran my tests on 5.15.y and nothing fell out, but did not
> > try to reproduce these complex assertion in a test.
> >
> > Could you take this candidate backport patch to a spin on your test
> > branch?
> >
> > What do you all think about this?
>
> I only think you need MAXDQS=3D=3D5 for 6.12 to handle parent pointers.
>

Yes, of course. I just preferred to keep the 5 to avoid deviating from
the upstream commit if there is no good reason to do so.

> The older kernels could have it set to 3 instead.  struct xfs_dqtrx on a
> 6.17-rc6 kernel is 88 bytes.  Stuffing 9 of them into struct
> xfs_dquot_acct instead of 15 means that the _acct struct is only 792
> bytes instead of 1392, which means we can use the 1k slab instead of the
> 2k slab.

Huh? there is only one xfs_dquot_acct per transaction.
Does it really matter if it's 1k or 2k??

Am I missing something?

Thanks,
Amir.
