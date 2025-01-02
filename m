Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1DE8F58
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jan 2025 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735856099; cv=none; b=V7a3PJ7IpF7BnoIx/O3mOqkdjVWcf4Xk3PudZnnv1XCD4TNFX6qAq6V6cOx4ER7V668SHsReEk0puxpaNRUXGu5RBEiMM6bsiIjKHfWfnn95BIdUZsNzz1IEJQHkhDAbK1s6Wfwgjdc3WLQNzyRr7tfqv2NzLQZQHboTnEyi7Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735856099; c=relaxed/simple;
	bh=yGFcOA8lKWc8iTuUBF396qxeMs/63/8bh4AvpKZkKbc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=kEwDQe5gyGXiY+3XYz8L+VFDrzrOnAt10e02gfpo5a+BXSJbFGJ3kTgV75AMo2JJUDIIChF5BAdxtmSdD0TqLYJkLDIUJaZ1MfcfN16LVf8CwWTpWasSAeoICr+ZE6ao6CDlnO5RnKvJ2vk6+r7HELfJxlrP1SAoshOItOsQAGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=netrise.io; spf=pass smtp.mailfrom=netrise.io; dkim=pass (2048-bit key) header.d=netrise-io.20230601.gappssmtp.com header.i=@netrise-io.20230601.gappssmtp.com header.b=L8+F1SRc; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=netrise.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrise.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netrise-io.20230601.gappssmtp.com header.i=@netrise-io.20230601.gappssmtp.com header.b="L8+F1SRc"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21619108a6bso149920495ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jan 2025 14:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netrise-io.20230601.gappssmtp.com; s=20230601; t=1735856096; x=1736460896; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yGFcOA8lKWc8iTuUBF396qxeMs/63/8bh4AvpKZkKbc=;
        b=L8+F1SRcEP3lOo2Iegu6+2HMC7FreZTFu4YrExw4vSteZjgJqX009A5jgtKlJf+rtb
         afMCb5Vlvd/RtJo0Iz49ndv99lEQ4EsHrupmfaF3K6+DbGaESinsGW9hoAYL3IAXuVWV
         i+3igeJjfQvNcS3K4aOnP6+O3vYdaxDZxdynXtrpGphCkxWDBh41JeCIQb6T4RcQk6n0
         g9kNTilExAQqExLelsYnYnbfTe4tq4mh2hkV2sSxeA2xp77EbDFHCDDM9+ylivdTW5Zf
         N8U6OPkwn9eKXPfgX3sxpbBBczTwdrwtid0aYULUyouekjQf/79pBVkPR+JpUAiFrdvN
         Kkpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735856096; x=1736460896;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGFcOA8lKWc8iTuUBF396qxeMs/63/8bh4AvpKZkKbc=;
        b=gRBMTdm5qs3upupgQH/MR4qEzt6U2debLJFV/JZf1UjmCN1FAdlOYoNOyE0m8CVHza
         X68yUah5qBb2e+9Xd7u7voUEMYtaIhcCWRI00WBDMbYRtS3npoMBe1apVP28nep9ne8l
         TEfji+/egfCjcXJEksr6LK4Z79KrVNvSzu3zjhftxVorAQ0y2xxm1B1/AhDubEdIx0t1
         nXrijs4MnFnqIgw0hBsaYPkDe40RLOp4x/cJHlj+PT4vYrQmQrUhZ5mbP/FKwwZV+/fM
         4VjHGSoPVq4pgo0g+cIT7DL97p/E9kPgk4u7+jbXfKhrrcJJXWJY7frOL0ILVZvrwWOc
         pctw==
X-Gm-Message-State: AOJu0YzqeWUYCGyreftmGm/w8MyRjPLtNjo35NBjeIDWz0xxiPTxCCUW
	3vzsljySCpxlied0BoXoH6gHY7V1XHLTaaAX4Zy+WG/qRaoG3XKR2uUoQW04VUssoWAEKrQ1c26
	zuty4L8cqUGBp+fHqFijnyhl3KXME7LvrmTDI8ArC83DfWD68A6Fagg==
X-Gm-Gg: ASbGncsjHsBZEPt1DWvaH/YWwAGxhWHXfDKQtmuhavuX01awODwdMiSMnN3tI2WXCE5
	16XLn23qxJOWlYhQBxeaynwkkwRjfg+HqjkU0TA==
X-Google-Smtp-Source: AGHT+IEkvS5NUmJXjkdkURgt1lJ9kcUKCVPurKvIBnTJl0CawPoRFacWffIoXnfvDYNPUVCm7bpLOQ5PqkpJ9uc0J1A=
X-Received: by 2002:a17:90b:3a05:b0:2ef:e0bb:1ef2 with SMTP id
 98e67ed59e1d1-2f452e3a8edmr71598283a91.19.1735856096231; Thu, 02 Jan 2025
 14:14:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Tom Samstag <tom.samstag@netrise.io>
Date: Thu, 2 Jan 2025 14:14:45 -0800
Message-ID: <CAE9Ui5nCVmeOGkOwJA4anU4oJ8evy7HqAXmPt+yhvwC_SJ5_uA@mail.gmail.com>
Subject: xfs_db bug
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi!

I'm encountering what I believe to be a bug in xfs_db with some code
that worked previously for me. I have some code that uses xfs_db to
copy some specific data out of an XFS disk image based on an inode
number. Basically, it does similar to:

inode [inodenum]
dblock 0
p
dblock 1
p
dblock 2
p
[etc]

This worked on older versions of xfs_db but is now resulting in
corrupted output. I believe I've traced the issue to the code
introduced in https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=b05a31722f5d4c5e071238cbedf491d5b109f278
to support realtime files.

Specifically, the use of a `dblock` command when the previous command
was not an `inode` command looks to lead to the data in
iocur_top->data to no longer contain inode data as expected in the
line
if (is_rtfile(iocur_top->data))

I don't know the code well enough to submit a fix, but some quick
experimentation suggested it may be sufficient to move the check for
an rtfile to inside the push/pop context above after the call to
set_cur_inode(iocur_top->ino).

Hopefully this describes the issue sufficiently but please let me know
if you need anything else from me.

-Tom Samstag
NetRise.io
