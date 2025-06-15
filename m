Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA51D516C
	for <linux-xfs@vger.kernel.org>; Sun, 15 Jun 2025 11:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749985463; cv=none; b=QxSlHeAD0gWtnLzXg7u57qLF4gMbUv6OLy9gKmfqVaqEQoRvS1ukUgElKS7BYw9UumrYeAQc3lI/UdN2BpSIXSzWcJAh8lm1xqbijASRX2XR4i/ETvQhAENxiLazbZGnGFB/3z2NOJOEcnOY9XmZ8Nt4RITCYggGBW22+P7f9mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749985463; c=relaxed/simple;
	bh=vFoEtLX66wQ+FVqOlfFdScL7Cs0s/iLM3vJKnosHYUU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=D8A8m3xoAjzATl3j9DB1ta6GiXnMhOC2Kk9Hld/i+tOP+eW+MeQ/MdPgz1faXBUMzIwAnyUEwdnIGZXnv5zSLoJsSuBMFMp3QKtYXFVvprhCOJRX7xn8Yl3l30JSfOg05VOPk5jVhJPZ4EWA0obSB6qvJLThrk5B0MKKVx6LlzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zadara.com; spf=pass smtp.mailfrom=zadarastorage.com; dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b=b3Xyt3jk; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zadara.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zadarastorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara.com header.i=@zadara.com header.b="b3Xyt3jk"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-742c7a52e97so2986911b3a.3
        for <linux-xfs@vger.kernel.org>; Sun, 15 Jun 2025 04:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google; t=1749985461; x=1750590261; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ke3jQjLijB81dhMTUF0jg2KeGrrqRQao1m1XCmRHha4=;
        b=b3Xyt3jkvqcPfkLeANbcLhfJz3Q/JpYxvQAlF8Ja/26K+sOyjamJztmfm2GgywyLzK
         agK0FimK9Zp2EE/VzfZZJ8ctj63/kBnzK65PGIVbl3vTxHgwNTZNBC5V/kLG89EhHHPi
         Nr7lO/yfzPKIHJlJabN1yk14Lc809MDCvDojI9j/wH+NjyTPccL6ggX6imk/JB1ddtEP
         kdOW2cwxbO1cNz7GtWaXVviElMW3A3/pkvK7/QVk2jRXxRMV9hcq5MbQLazyCEsimCvf
         LLNPnu7lB4raWfZ2+NVIAdcg2eRmK0Yeul+7tV320yJrXgwwISVa4ZCYvGCjfJeCLpmF
         ouVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749985461; x=1750590261;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ke3jQjLijB81dhMTUF0jg2KeGrrqRQao1m1XCmRHha4=;
        b=pvb56ACQGbqWMOvJQdbJ/o7LPrdGhdBGgPOFAg4+Ev9I5SRKyEiAzG+BcwLLsvTvTc
         KUoOUXOMK2KS7yjrfrguZTDI+uTx6wcKDWncAF8NgOfV47YxkjHhlsPgK/TiC9tsLId3
         /9vB6OsP1jiEyG42UeOzJq3dIK7bnK6iBhOdSj/0yTARz0axA6685FUoRbd2pE9a7UV3
         TnHRnpZfbZtzOyjleMRbv02jjzeZUYhivqQtTlfipdA8eE9odSPHfEoYhqGt0A0SELb6
         ESXfgeI2jI6GSfBtlY7QMgN/nZK5PjPjiBwx9nVHw7guCN+Njb/1CYvmIjynS2ZVyi/a
         sPvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWzIVawCe1aFDlsDQsZTFoBNly0q2igExrL2WiRFA88jyRcf0W0q+FCzVfbEmQucflUNiT3CF1Cm4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOXodh7L8O9YSqSG3eCXk27aAe0HkgH5v8Zfb6DTQXMCo/G5o0
	7NR4ougm31ndRzurl0oJJlDaY0JNAZD+n7Dz81h+tZ9ETezY5Fl/mTn2Ds9dxDRs9eSk2YATct6
	Wqd3TL8HlDP5WO9ShXh2t3rJFW3Kuig8C3yRb5vyOv91psh3qQepWNLM06A==
X-Gm-Gg: ASbGncuNxw8FZGPK0Y/v3myXIdPy5aL6NNkwK1Oy4fPnENxvvsA8qjPVNCV2MGPNDcO
	5V8cang/3+tmNuiO2acaMiKZeyYk5MZ7LQCQ8GB4eezfsoxMl5nLkmC6HlgRj9XzjePC4Kj819h
	4pRrp9JJVgFoUXPYWovid88wuixn2tKIQz0CeBCWulPYv7TO2MnA9qWw==
X-Google-Smtp-Source: AGHT+IEqE2sK/ENLhB+akYqHNIS91IfyoCnD/Vt2FrImQ+nlarNhUo5NI6CfUY5syFStSCua4j8p+uTTZ2twLkSNpyM=
X-Received: by 2002:a05:6a21:3399:b0:21a:e091:ac25 with SMTP id
 adf61e73a8af0-21fbd505f24mr9541678637.6.1749985460943; Sun, 15 Jun 2025
 04:04:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alex Lyakas <alex.lyakas@zadara.com>
Date: Sun, 15 Jun 2025 14:04:10 +0300
X-Gm-Features: AX0GCFvzOE8tPWUGnUsLLwnTDVSz0GB7z84R2yk2RPJ33ZTSG_H9DmNM3wpGqhU
Message-ID: <CAOcd+r11dBE2O8+bOyNdGYHCnxaEbKd5jaZttQ-+pJSgz9uPVQ@mail.gmail.com>
Subject: question about patch "xfs: swapext replay fixes"
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

I found the following patch series of yours:

[PATCH 0/2] xfs: swapext replay fixes
[PATCH 1/2] xfs: handle bad flags in xfs_recover_inode_owner_change
[PATCH 2/2] xfs: clear XFS_ILOG_[AD]OWNER for non-btree formats
at
https://lore.kernel.org/linux-xfs/81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com/

which is fixing a kernel panic during log replay. We have this exact
kernel panic in kernel 4.14.99 LTS. However, I do not see that these
patches made it into Linux.

I do see a different patch of yours[1] that made it into Linux 4.17.
It fixes a failure of log replay (which doesn't cause a kernel
panic),which we see as well. We see exactly the same assert in
xfs_iformat_fork(), we also run fsr.

Can you please clarify what's the status of the first patch series?

Thanks,
Alex.


[1]
commit dc1baa715bbfbb1902da942d06497e79b40e7bc7
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Wed Mar 28 17:48:08 2018 -0700

    xfs: do not log/recover swapext extent owner changes for deleted inodes

    Today if we run xfs_fsr and crash[1], log replay can fail because
    the recovery code tries to instantiate the donor inode from
    disk to replay the swapext, but it's been deleted and we get
    verifier failures when we try to read the inode off disk with
    i_mode == 0.

    This fixes both sides: We don't log the swapext change if the
    inode has been deleted, and we don't try to recover it either.

    [1] or if systemd doesn't cleanly unmount root, as it is wont
        to do ...

    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
