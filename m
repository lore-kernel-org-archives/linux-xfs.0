Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5852310623
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 15:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758728707; cv=none; b=qoXFreoQVhMFveLHTfpjfFq/upH1YtvgesLwycwzeptiaBgJjX72ul//7dWFKKNasa+1F4QVLzQxY9eAsN+PWpX3hw/2XnKJIejtBBHaMF+olHukNjpiPBliKjgCOOx5l3D5jcO0zbdDAuW/HqkkMtDYRoCI9LvHCZQijjH8Sv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758728707; c=relaxed/simple;
	bh=Y1oFn3WW4TEWHZJdgwQGsOOxoEQwZzbCWninz46dRyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eKiPBM+o25BOYi6xOAM+NHJ6cakQtll9DpVzRmZ/OKP35oaPgtrYql6QADaEXM4qhXFaKkpFQtFTtetyyfXNOY+QgtDxeoN9AoXvIACitqyy8pR5RlY6kUotqclHVD9/hJ5GSgQZrKZxQUK+WQG4rJ0PIC6A+VLBEMh22RI+elY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C80XrC1G; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C80XrC1G"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62fc2d92d34so10442886a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 08:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758728704; x=1759333504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ff78OoL5Hm8kgn0aGyB3+0EyFcIr1uulY772U1X+1fM=;
        b=C80XrC1GZoRDTGy9VTQcAaF1qiNV7nYT2JlPIxcAlvjeF4Lu4Vw8y+cuH2aKbcu5vG
         C3WRECs4fotSVmi0z63aTt1PuiHLCEcAIZyeOup8JfVC8+REVHdpaIGqIO8FLoSgnToA
         B4JBOj70J5SQWbIrYQqdM7oyYfPGxJvgnNgU4zgpRd3RwzrieUviABBbeWjtmTbpxzCy
         jLSal8X/AjvZYF23HIgrByl1Fw0MzcffMwl8Y/iQaa5YXwtXsdx1TeJLJ5jnacO5F8Bz
         PXNw9a9haI1rcUZurHues+qqwCr4EKmWVx0MOaFoknCsXP9q7gb/NuXAZc+RIlTwKkAN
         SGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758728704; x=1759333504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ff78OoL5Hm8kgn0aGyB3+0EyFcIr1uulY772U1X+1fM=;
        b=fuqwtgulvsWVgurcbbb85Lx6kH5bV/F+q42KPT6eHl2+AHSTbXM6MAmo/q8apXeLQs
         fY5081H1rGuYCvz8N+gP9dgc7Jt3evw/1iBdXFGIjw9AmhvMuiQNdAS5JTAwGk/JzU7r
         rKHVHHRGbUzQvWTm+PpKRnQrfxGgKk5n5unxpBzmVT9ziWcK6I13DRFMebkFlukG4g73
         +TLGoCLU66yM7jiCnr+uwrvqs9LqrpdU/I964pNicjWsDxd2o4Qmrvmwofy+ez1S6X93
         x99uQhExv/3Dnu8N7P6aUpcVzOOjthdps9KBgQAyo7krNzUaq9uCJ4t/kEJaXtSWYaQx
         UKLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTzoNlZtVzKLwEQFUaM2q3FzJG+N2F/XFSDtONB4wXgQ82KRNyRRSP4lyaiJv6/4aU1YOMLZ61+ns=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/8YMGyaejPPgATGTNAFs9sFtHGY/BvFWxazkLBSfGo46Dr15M
	44wIz9wcwtETW/hUpCbp/B9bsQWt+7wGWhXW2QBtduveqexXCUsuj5mS9EbFZfLEdTs6Hgcghsa
	JdS/Ro4Bo3m+IxWHS6qnlrzC0tiLWMhI=
X-Gm-Gg: ASbGncvYswpQLN32+ndajGwPUAQFkZ9y4mJ4mI+YZcuJoPs3zPZRIYqB28g1B6MOvNx
	wbWa9RTaKmDYHt3iTZtgjnGopCqi6uTduioOgqd+WrlkFd1YYoVtqKEbMQxr/nKQ1WaC1yRAGjc
	UAo/zZGkmJIVcw2x8J/X6hyPFhG3pFD4JChpo5hGUOrgztoE6uW95UMY4bnQedQU6EDX9RkBFpZ
	jGQVPx3OFji7Jn1sRYG/lVDRnPzq33QOVuunnhU
X-Google-Smtp-Source: AGHT+IGaoAO6JWJIY6kSzxUWUvCYhTVMywZ6Lec0hIKntpQyrJD3veSbZG/6/rZscpbXyIDVnF+QvUKA0YyFEzT/Wns=
X-Received: by 2002:a17:907:86aa:b0:b04:967:307c with SMTP id
 a640c23a62f3a-b34bde1308dmr24820366b.34.1758728704012; Wed, 24 Sep 2025
 08:45:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250913030503.433914-1-amir73il@gmail.com>
In-Reply-To: <20250913030503.433914-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Sep 2025 17:44:52 +0200
X-Gm-Features: AS18NWAtUjdzCucBmveMzawNbJaqJAVoamQGDu4rqg6nKIZon942x_9ZsvyfQ24
Message-ID: <CAOQ4uxjTRC_xYriSrSq6aF4sCjX_5xPzX5Lw_opW8RHJiHsrCA@mail.gmail.com>
Subject: Re: [PATCH CANDIDATE 5.15, 6.1, 6.6] xfs: Increase
 XFS_QM_TRANS_MAXDQS to 5
To: Catherine Hoang <catherine.hoang@oracle.com>, Leah Rumancik <leah.rumancik@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Allison Henderson <allison.henderson@oracle.com>, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, stable@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 13, 2025 at 5:05=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> From: Allison Henderson <allison.henderson@oracle.com>
>
> [ Upstream  commit f103df763563ad6849307ed5985d1513acc586dd ]
>
> With parent pointers enabled, a rename operation can update up to 5
> inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
> their dquots to a be attached to the transaction chain, so we need
> to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
> function xfs_dqlockn to lock an arbitrary number of dquots.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> [amir: backport to kernels prior to parent pointers to fix an old bug]
>
> A rename operation of a directory (i.e. mv A/C/ B/) may end up changing
> three different dquot accounts under the following conditions:
> 1. user (or group) quotas are enabled
> 2. A/ B/ and C/ have different owner uids (or gids)
> 3. A/ blocks shrinks after remove of entry C/
> 4. B/ blocks grows before adding of entry C/
> 5. A/ ino <=3D XFS_DIR2_MAX_SHORT_INUM
> 6. B/ ino > XFS_DIR2_MAX_SHORT_INUM
> 7. C/ is converted from sf to block format, because its parent entry
>    needs to be stored as 8 bytes (see xfs_dir2_sf_replace_needblock)
>
> When all conditions are met (observed in the wild) we get this assertion:
>
> XFS: Assertion failed: qtrx, file: fs/xfs/xfs_trans_dquot.c, line: 207
>
> The upstream commit fixed this bug as a side effect, so decided to apply
> it as is rather than changing XFS_QM_TRANS_MAXDQS to 3 in stable kernels.
>
> The Fixes commit below is NOT the commit that introduced the bug, but
> for some reason, which is not explained in the commit message, it fixes
> the comment to state that highest number of dquots of one type is 3 and
> not 2 (which leads to the assertion), without actually fixing it.
>
> The change of wording from "usr, grp OR prj" to "usr, grp and prj"
> suggests that there may have been a confusion between "the number of
> dquote of one type" and "the number of dquot types" (which is also 3),
> so the comment change was only accidentally correct.
>
> Fixes: 10f73d27c8e9 ("xfs: fix the comment explaining xfs_trans_dqlockedj=
oin")
> Cc: stable@vger.kernel.org
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>

> Catherine and Leah,
>
> I decided that cherry-pick this upstream commit as is with a commit
> message addendum was the best stable tree strategy.
> The commit applies cleanly to 5.15.y, so I assume it does for 6.6 and
> 6.1 as well. I ran my tests on 5.15.y and nothing fell out, but did not
> try to reproduce these complex assertion in a test.
>
> Could you take this candidate backport patch to a spin on your test
> branch?
>

Hi Catherine/Leah,

Do you plan to do a batch of backports to 6.6.y/6.1.y anytime soon.
Would you mind adding this patch to your candidates
for whenever you plan to test a batch?

Thanks!
Amir.
