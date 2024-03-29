Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B881224D1
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 02:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711680967; cv=none; b=pGwyB1efIGmaPjueDrlXByTPaRixBFqCDrDs4mvAv/gvDOreLHCR/BvlI68WMCsdeHpN8KpICR9jOxBaw4i0Y3QjQ6hEmptC5oo66VESqUNQ1xvVYpdUrnIgr5l9ekAlJ6AUGipelQRiQCC4XRO/IRECC6C7wbGfU9Urtmy21Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711680967; c=relaxed/simple;
	bh=NiI3YFM0jM5FCH4nZsKTZlHlqzvvgBKSaH8DMM42B2A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=gQRPgy1NKixCaMz+sCxaJOKsPZED4Klt5MPK1LhHR59/gZXpr+ZB6ZjELnXVXAVPKkBJrbelcHII6I78xXXJIzWbDARkOcvMudhevCNco3r1f4ajFyGtruNB314NFMePBLZ2yDb4v0H8WH3p6cid9qOpMXPpemBppgEGRuZ1EAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUpiTXzw; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUpiTXzw"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-42f2d02fbdeso6514331cf.1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 19:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711680965; x=1712285765; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NiI3YFM0jM5FCH4nZsKTZlHlqzvvgBKSaH8DMM42B2A=;
        b=MUpiTXzwNHxcQBnj8G9p5+3NxGIx/vNNMbHe/BeHhkGMhB35vubm1qbl7H8u7zpXW6
         8rFUsY4pXIjGOO9U1iXHyorkGJbW1t7Yft2YxDMtFdVZ1ee9igE1qSQa65urzVjmpNkR
         F5tM9nFRwVKJtGB3WoJ6WzpcngrQkWrJmxMBbUq5eRj4LYeB6SMmQupVT8LZH+L0ikKI
         6z9i/TlKBPNeGb3sXq27prSybVCdwM3m5NEHw1J/LYC0n5k0K13eKVW3M5xEJYVgz7yZ
         ERf0YhBdoJITwEmXGQdict5BQo+1SNXnOz22opdWi4ehVo9VJONfmSVuGax44L3gYOT0
         tp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711680965; x=1712285765;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NiI3YFM0jM5FCH4nZsKTZlHlqzvvgBKSaH8DMM42B2A=;
        b=ibApJhl+EBt1wtGA01yna8QBlsPSiSX8SqIxXYx8uZ0qebFkWvdSUqBGFICif0GRMd
         aYLUGEE1g3OLvh/2CTEkO6oJmQLlneJE8S+PACeoXaQ3+fzg+D2deJeJ3um5DXcLw12N
         kusanOIbk5hbeX/mBlUM7K2N11VKZ0rB/OLtFrvYwbtCmLnvZcLlRKJYzZNaEfOJgVf0
         Nx6lTZJOU9t+q0DEf+ySWVu7S4Uj8MclIYSzrBqd6QbFpcHdK/+NL6LSwxlz16mBM9u1
         jm44L76l0anGhjNJ3lOvOH61tdHfEGywJKJUcBz1q3IDlUK4W6dT7XICHYBgK4SD3xal
         AEwA==
X-Gm-Message-State: AOJu0YyvGCn8OmT/EEoWmYwJ9eRGdF+KNuo9QCg4/xz+vbYhninOA1TM
	uxMPcoTJDo24v+16L8qiwN6nPlcT0o2rKG/xT0KIGnBfiNLXfzEw/ffTNTb66QVkUrweq1Atm7o
	6GWJSaNyfyzw8tFRoaPBGgdSufirKZKpqOSD0IgG4
X-Google-Smtp-Source: AGHT+IHFa1yhv6Mzf6xnIvVDk37u4bzzmUPzOWSiha/z2W40Oo41nRVDIXlLRH/4iXCQiAPOPqJJM+3FqWA5DgNcisc=
X-Received: by 2002:ac8:7d82:0:b0:431:8290:716 with SMTP id
 c2-20020ac87d82000000b0043182900716mr1582205qtd.5.1711680964811; Thu, 28 Mar
 2024 19:56:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 29 Mar 2024 10:55:29 +0800
Message-ID: <CANubcdXY-otymMxDpzbdy1q5osnruNeU7L-b_+eeNo682U4p+Q@mail.gmail.com>
Subject: Potential issue with a directory block
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

It's all about the commit 09654ed8a18c ("xfs: check sb_meta_uuid for
dabuf buffer recovery").

IIUC, any XFS buffer will be in an internally consistent state
regardless of whether any other buffer is replaying to it.

Specifically, for a buffer like:

...
bleaf[0].hashval = 0x2e
bleaf[0].address = 0x8
bleaf[1].hashval = 0x172e
bleaf[1].address = 0xa
bleaf[2].hashval = 0x4eccc517
bleaf[2].address = 0x36
bleaf[3].hashval = 0x4eccc519
bleaf[3].address = 0x2a
bleaf[4].hashval = 0x4eccc51a
bleaf[4].address = 0x24
bleaf[5].hashval = 0x4eccc51b
bleaf[5].address = 0x1e
bleaf[6].hashval = 0x4eccc51e
bleaf[6].address = 0xc
bleaf[7].hashval = 0x9133c702
bleaf[7].address = 0x68
bleaf[8].hashval = 0x9133c704
bleaf[8].address = 0x52
bleaf[9].hashval = 0x9133c705
bleaf[9].address = 0
bleaf[10].hashval = 0x9133c706
bleaf[10].address = 0x3c
bleaf[11].hashval = 0x9133c707
bleaf[11].address = 0
btail.count = 12
btail.stale = 2

and then If we skip a buffer replay during log recovery, the buffer
will still be in an internally consistent state. This implies that the
'stale' or 'count' will be consistent with the real count in the
block, meaning it won't trigger the check in xfs_dir3_leaf_check_int.

but the commit 09654ed8a18c ("xfs: check sb_meta_uuid for dabuf buffer
recovery") states that in some scenarios, IIUC, if we skip a buffer
replay during log recovery, the buffer will not be in an internally
consistent state.

What could cause this inconsistency? Are there any potential issues
with the directory block?

Hope my naive question doesn't contaminate your timeline.

Thanks,
Stephen.
