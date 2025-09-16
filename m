Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E479E223DF6
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 06:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758004690; cv=none; b=LVFV0FepuXjvmvOXFwu58I6eiBB8I0swdyjVlTIZv3ZjS30iWwhue/WMdIguuGHt0LqZ+nuDdxiDpslaINwUKBbPGkc60TG47D5tG6hvr9ktKBVj9ICG/Qul/iDaKbvBblBm26jEfwk6kZH2E8I/tlE2sTbZpZRSHNsqLz4xZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758004690; c=relaxed/simple;
	bh=UlB06k3fabYJVeuwagIuYZbusArRJV8PYAWb8HnCM7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RnHWWV6+tomzmAOdAziQwBpXiJAPulPUGxiYhSXbn6lGyETWbxRTOvbIxutKNm2A/F55U1xKRoYlP9+9OD0QtQD3z9rDHG86WylDIeu8TqGoOtjyOIOb8EYTRzkqDQnwbFdzjYiq2R2wg0QdJkIDVSnnQKSgmoDPjp30WJavXps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PsiUKty1; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsiUKty1"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-62ee43b5e5bso6698759a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 23:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758004687; x=1758609487; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cc7WNX8qWIF/5rBWrjguwjC9B2870jwiQMPwsz1WD7s=;
        b=PsiUKty1B98lWgRqrbCDHt0hkAHaIW4HuFmjEArGfYu69O5UrKAfY2wOpg8ZzGuZZ7
         6AJ9MLKwi+6RHa9l5FUVFY39k9VOsQrI0Dz7ok/4S/60De4v/dIB19HtDzfh5YnCnrVW
         Uz5iJJAexi11ZzSK8jtGxn8l8YcJPcE5IgnI99JZpYrDqGxUCOPkKCudO9DTItfz/dAt
         tyGyoFxWd9HJErEupzWMUR8BXwce2c5nYs/wvmz1bRVCmoRibFaF7+1dUIIhUISXJC9S
         vktHA547rxc8V4ujPrSQD9H+ojnctzfy+I3USpl07v/7+y/6SG70kQKRm/ESqyDUKoUJ
         ysNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758004687; x=1758609487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cc7WNX8qWIF/5rBWrjguwjC9B2870jwiQMPwsz1WD7s=;
        b=GU239nSNynnZ27Gt+rnK23pEA1SN9ZjHlkrXL7hUrapwGwLMdyhQ9uS604g+5uxGlJ
         8q++CBg6027nROitzMV+/VpaKZbGdbbkWRN9lkZehqFLhkT8A/6jx1FVtRzjjrUcWQfF
         T1bg3XvBwwhmb6asunDmeGleU1H86DUGK+P9m5sWFEMM77iIyCI+wYksFguMLvmEMMca
         Ui94HxOf2MW+0uYcqEyZH4l/PKq3/qZyUx2XLbRfgOJUfibdG8hHpaNsHc0z9p2E93bU
         G38r8qRUiOSrPu+k3rl56QQjxuzda4KfhbgllmlFbypfvMU+p8NlW/XQuo5sM6GDXsSw
         Nh4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXze2jalXKKSXFcnPY/UwfViV6MWRixVPjBuJro3htKkCq3PqQTvtpk7FFEMsu0M/jbR8phJd/jVMk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXuYPVHXHO0I42m4nCJN8rQ4ZCdskduVo18nKSbfmjVQeRuUH1
	2jKzWy6Zmjv+WdsosvwhSlDgFkJCauuQogvhK4DNAguzBb4xjc2s0ldwBGTCZ1xSl9ojnN912SN
	BEMvV0TCPOTNUn6QMoNg2KQLEDjHEr4U=
X-Gm-Gg: ASbGncugg5nSkIlqXX9mDN6HJQ2ASAO9HtIVMtSoe6eOCjUORxlwxz+dkxflQSQZbxl
	SwVVzj+0DvLosmEXYeB8r3UlbPXFoOIRx23WK7ob4sCCbgdi6iDDHzaJVO4lr/8uQGxphxP5cNe
	TStqtueT/eqYlFnq0qhH0WOZUEkdkPOwFYxjJBpjYZRef4eSm5sahbetwHDSen3EyrXKhpVTMLz
	zCFxBD4rpK9/8V+MCSbMWgbLF4ms5Pj6X7kcBUWXw==
X-Google-Smtp-Source: AGHT+IEappBHI1UrvMjtLUDln5FT0zMJjv0rXy1s/F3AnYYR3eWGfQGcNmj9FYjanF5LXOZTAGbS3nKFLn4NHTrsf7Y=
X-Received: by 2002:a05:6402:21c9:b0:628:e8e3:ada with SMTP id
 4fb4d7f45d1cf-62ed82f1777mr15910586a12.27.1758004687031; Mon, 15 Sep 2025
 23:38:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250913030503.433914-1-amir73il@gmail.com> <20250915182056.GO8096@frogsfrogsfrogs>
 <CAOQ4uxg4eBMS-FQADVYLGVh66QfMO+tHDAv3TUSpKqXn==XdKw@mail.gmail.com> <20250915234032.GB8096@frogsfrogsfrogs>
In-Reply-To: <20250915234032.GB8096@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 16 Sep 2025 08:37:54 +0200
X-Gm-Features: AS18NWCgfg5Hw8iQqX8b7xRdqkWHU35zVtNeheSZPySuvChBeuzUdAY9rTPwdtM
Message-ID: <CAOQ4uxh00vdYLs24aMTonCNJ0wnmudwysxaJQa95-iq7zziD4Q@mail.gmail.com>
Subject: Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
To: "Darrick J. Wong" <djwong@kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Catherine Hoang <catherine.hoang@oracle.com>, 
	Leah Rumancik <leah.rumancik@gmail.com>, Allison Henderson <allison.henderson@oracle.com>, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 1:40=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Mon, Sep 15, 2025 at 10:20:40PM +0200, Amir Goldstein wrote:
> > On Mon, Sep 15, 2025 at 8:20=E2=80=AFPM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > On Sat, Sep 13, 2025 at 05:05:02AM +0200, Amir Goldstein wrote:
> > > > From: Allison Henderson <allison.henderson@oracle.com>
> > > >
> > > > [ Upstream  commit f103df763563ad6849307ed5985d1513acc586dd ]
> > > >
> > > > With parent pointers enabled, a rename operation can update up to 5
> > > > inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
> > > > their dquots to a be attached to the transaction chain, so we need
> > > > to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
> > > > function xfs_dqlockn to lock an arbitrary number of dquots.
> > > >
> > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > >
> > > > [amir: backport to kernels prior to parent pointers to fix an old b=
ug]
> > > >
> > > > A rename operation of a directory (i.e. mv A/C/ B/) may end up chan=
ging
> > > > three different dquot accounts under the following conditions:
> > > > 1. user (or group) quotas are enabled
> > > > 2. A/ B/ and C/ have different owner uids (or gids)
> > > > 3. A/ blocks shrinks after remove of entry C/
> > > > 4. B/ blocks grows before adding of entry C/
> > > > 5. A/ ino <=3D XFS_DIR2_MAX_SHORT_INUM
> > > > 6. B/ ino > XFS_DIR2_MAX_SHORT_INUM
> > > > 7. C/ is converted from sf to block format, because its parent entr=
y
> > > >    needs to be stored as 8 bytes (see xfs_dir2_sf_replace_needblock=
)
> > > >
> > > > When all conditions are met (observed in the wild) we get this asse=
rtion:
> > > >
> > > > XFS: Assertion failed: qtrx, file: fs/xfs/xfs_trans_dquot.c, line: =
207
> > > >
> > > > The upstream commit fixed this bug as a side effect, so decided to =
apply
> > > > it as is rather than changing XFS_QM_TRANS_MAXDQS to 3 in stable ke=
rnels.
> > >
> > > Heh.  Indeed, you only need MAXDQS=3D=3D5 for filesystems that suppor=
t
> > > parent pointers, because only on those filesystems can you end up
> > > needing to allocate a xattr block either to the new whiteout file or
> > > free one from the file being unlinked.
> > >
> > > > The Fixes commit below is NOT the commit that introduced the bug, b=
ut
> > > > for some reason, which is not explained in the commit message, it f=
ixes
> > > > the comment to state that highest number of dquots of one type is 3=
 and
> > > > not 2 (which leads to the assertion), without actually fixing it.
> > >
> > > Agree.
> > >
> > > > The change of wording from "usr, grp OR prj" to "usr, grp and prj"
> > > > suggests that there may have been a confusion between "the number o=
f
> > > > dquote of one type" and "the number of dquot types" (which is also =
3),
> > > > so the comment change was only accidentally correct.
> > >
> > > I interpret the "OR" -> "and" change to reflect the V4 -> V5 transiti=
on
> > > where you actually can have all three dquot types because group/proje=
ct
> > > quota are no longer mutually exclusive.
> > >
> > > The "...involved in a transaction is 3" part I think is separate, and
> > > strange that XFS_QM_TRANS_MAXDQS wasn't updated.
> > >
> > > > Fixes: 10f73d27c8e9 ("xfs: fix the comment explaining xfs_trans_dql=
ockedjoin")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Christoph,
> > > >
> > > > This is a cognitive challenge. can you say what you where thinking =
in
> > > > 2013 when making the comment change in the Fixes commit?
> > > > Is my speculation above correct?
> > > >
> > > > Catherine and Leah,
> > > >
> > > > I decided that cherry-pick this upstream commit as is with a commit
> > > > message addendum was the best stable tree strategy.
> > > > The commit applies cleanly to 5.15.y, so I assume it does for 6.6 a=
nd
> > > > 6.1 as well. I ran my tests on 5.15.y and nothing fell out, but did=
 not
> > > > try to reproduce these complex assertion in a test.
> > > >
> > > > Could you take this candidate backport patch to a spin on your test
> > > > branch?
> > > >
> > > > What do you all think about this?
> > >
> > > I only think you need MAXDQS=3D=3D5 for 6.12 to handle parent pointer=
s.
> > >
> >
> > Yes, of course. I just preferred to keep the 5 to avoid deviating from
> > the upstream commit if there is no good reason to do so.
>
> <shrug> What do Greg and Sasha think about this?  If they don't mind
> this then I guess I don't either. ;)
>

Ok let's see.

Greg,

In kernels < 6.10 the size of the 'dqs' array per transaction was too small
(XFS_QM_TRANS_MAXDQS is 2 instead of 3) which can, as explained
in my commit, cause an assertion and crash the kernel.

This bug exists for a long time, it may have low probability for the entire
"world", but under specific conditions (e.g. a specific workload that is fu=
lly
controlled by unpriv user) it happens for us every other week on kernel 5.1=
5.y
and with more effort, an upriv user can trigger it much more frequently.

In kernel 6.10, XFS_QM_TRANS_MAXDQS was increased to 5 to
cover a use case for a new feature (parent pointer).
That means that upstream no longer has the bug.

I opted for applying this upstream commit to fix the stable kernel bug
although raising the max to 5 is an overkill.

This has a slight impact on memory footprint, but I think it is negligible
and in any case, same exact memory footprint as upstream code.

What do you prefer? Applying the commit as is with increase to 5
or apply a customized commit for kernels < 6.10 which raises the
max to 3 without mentioning the upstream commit?

If you agree with my choice, please advise regarding my choice of
formatting of the commit message - original commit message followed
by stable specific bug fix commit message which explains the above.


> > > The older kernels could have it set to 3 instead.  struct xfs_dqtrx o=
n a
> > > 6.17-rc6 kernel is 88 bytes.  Stuffing 9 of them into struct
> > > xfs_dquot_acct instead of 15 means that the _acct struct is only 792
> > > bytes instead of 1392, which means we can use the 1k slab instead of =
the
> > > 2k slab.
> >
> > Huh? there is only one xfs_dquot_acct per transaction.
>
> Yes, but there can be a lot of transactions in flight.
>
> > Does it really matter if it's 1k or 2k??
> >
> > Am I missing something?
>
> It seems silly to waste so much memory on a scenario that can't happen
> just so we can say that we hammered in a less appropriate solution.
>

Yeh, I do not like waste, but do not like to over complicate and micro
optimize either.

Talking about waste, in current upstream xfs_dquot_acct is bloated
as you described for the majority of users that enable quotas, who
do not enable parent pointers.

So if we consider this memory waste to be a bug, I prefer that stable
and upstream will be bug compatible.

If we fix that waste in upstream, we could add:
Fixes: f103df763563a ("xfs: Increase XFS_QM_TRANS_MAXDQS to 5")

Which would then be flagged for picking to stable kernels
that have this commit applied.

So? WDYT?

Thanks,
Amir.
