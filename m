Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9625138DD8
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 06:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725259320; cv=none; b=UJc2IDrW8TLsmF/m+ReJ0s6DPIrwiSFHx1dOiNGvxWM+LjgGzzClA72EqpA6+tRW91vW6MMqSZhkwxdMJEEc+64u/ubAuyP+/ToVgwDvkiw3Lt/dJ8cV3+8AGay2o8fHDTfmiLY/AfympvN5xpaCZLbGqeEk/Zop+IXcvB8zmRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725259320; c=relaxed/simple;
	bh=4kMjB6Z7IY6fCPRikEhYBZnaPhnRsW11u4ULtlgnhck=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=sx794pZ+BmIAWrBvQlFCZOy2XRI+5oRQLFCavvMCido975hq9GQ3S3AlW1/mc6GIb4uVdR8DeJImgHp/uHj2tjnln27XNKVtMeJfVRJ6hSHoyo8MiR368qWh7pLX9dEYusdLaI7cDKwVW+dNiTTgjM/n3+6Y044dJdBnuAM+CMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhqN9ewB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhqN9ewB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5657C4CEC2;
	Mon,  2 Sep 2024 06:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725259320;
	bh=4kMjB6Z7IY6fCPRikEhYBZnaPhnRsW11u4ULtlgnhck=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=VhqN9ewBnj0izCqf4w2gryPb8L75CyVKOOszXRR5zuiJmVr5rZjjAMMXlcw95q4mx
	 CR3o2xjbaNSy5iRB/q7ewJ/CyAsHMcm3GGAd2K9G4NFi31F1i2N+8rfqh20qH497EM
	 tlLm8czzESSIRPDtohnWXGNU9wr2ndpvvu1fGrZeC/lOKHJCOuLD9rBMJ+lMdwlFFy
	 8TgvMikYmKbCUfG69b3w5VESv59IgCSw0M/XVDbkC1kUhdpCbVo6PSec8MDkVOwl3Y
	 QdZLgab0+Ok32mPWlaXW5jtM7GL1Ds+TSAJyEV0ZphEdjTRTdO3zktD9cga4ubGK0c
	 rNB9xG37Dw8lQ==
References: <20240824034100.1163020-1-hch@lst.de>
 <20240824034100.1163020-2-hch@lst.de>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: merge xfs_attr_leaf_try_add into
 xfs_attr_leaf_addname
Date: Mon, 02 Sep 2024 12:08:41 +0530
In-reply-to: <20240824034100.1163020-2-hch@lst.de>
Message-ID: <87v7zemua2.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Aug 24, 2024 at 05:40:07 AM +0200, Christoph Hellwig wrote:
> xfs_attr_leaf_try_add is only called by xfs_attr_leaf_addname, and
> merging the two will simplify a following error handling fix.
>
> To facilitate this move the remote block state save/restore helpers up in
> the file so that they don't need forward declarations now.
>

Hi,

This patch causes generic/449 to execute indefinitely when using the following
fstest configuration,

TEST_DEV=/dev/loop16
SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12"
MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024,'
MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'
TEST_FS_MOUNT_OPTS="$TEST_FS_MOUNT_OPTS -o usrquota,grpquota,prjquota"
USE_EXTERNAL=no
LOGWRITES_DEV=/dev/loop15

Can you please check this?

-- 
Chandan
