Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9B45A798
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802455; cv=none; b=SY0J5PLciwGG248eVSOmq43PLgM8OsTCxLLohwGj1T/DvsNfz70sP0RyyQ+vJlzmGgB+8WFk8d4s6g4aRuwLOTY/zFiu6Qyh235mELeVJ0Z1lSBGH8d6J856IeXbSL1y/KhyY4Ya3a3Xt9PP93MxdB0H65AgOUACh5EMLF2yI7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802455; c=relaxed/simple;
	bh=tqHXEw68+/aCd4gOGHmlBC51hR4wxiEEKoc/WEeLMhU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZEHUQULxjDuYtAz9GQ0Ek8ly7Fy9H1XKlAKRaiX2P75/X4JfUPfSnhOeG/A5NTSxySagrK4uJwNZIa1z37SeNUp+LkRSJbSP3tS9vZ16qBPdLrrNpHdCno0kTOJpsXquKQtGDKchWqiaqPPrfh6c8SwWh3bSFu6eVVn34kbYba0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=PMyu/1cZ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="PMyu/1cZ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e740fff1d8so232578b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802453; x=1711407253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tqHXEw68+/aCd4gOGHmlBC51hR4wxiEEKoc/WEeLMhU=;
        b=PMyu/1cZuXOIqOAYKr42rrpZZfGf66GMa+XO+qN1wrPKgwxAaTSK2HCIsS8zsiluPm
         zcQoTusXgOEUh3LkwrLhahC8tGqGIy5YLQG5wwr4FYB8WbGXUB1dqgeITjXspZIB53QQ
         3GbVajBCzLz3YDgi5Qvemx1q/LLEqtz5wEuyo/2vWyfQ7gCkgqKxJn/aVDKelO9yb+eF
         lcIhnaA5PFx6z+/1mZVthhS8LJp6cXjWY35p5/i0+tSye0C67uz896fJ3Vn7NQ9XSZwF
         7qp3y93cxSsO1TRaOjXWtJ6ccandyQoT0+F4IxMxt2AT9RxdE+aIkQSPmL7zjLHYxhJX
         4jRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802453; x=1711407253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tqHXEw68+/aCd4gOGHmlBC51hR4wxiEEKoc/WEeLMhU=;
        b=k8eaFlaIhF4gtlR18KSoWfeXuLtJNzrFBzj9n9rvszDp68lMMenM2os5Ra1HmJbiQM
         lqYt+HcRUEGPoFAAjCAbxsmUC5cONSZxhkJ9ExFpM7XO2ajrUvBSsZW757iTAVDn4GyX
         YNaQB/5GI4tDScSro5LZQmZYDdoWvM1hJojeN0CaHZVzV4+XVm9PepDHrXyWTODVhQWH
         jH/XNpIHGzOQxMVMvJb26F1Dla3vN6+GHlnh+jpsMyRwpR89dctS/Z0PL8pkYisiDMv8
         bfPGrj7ofLd/AH8hd+c9SqwaTx09ZHBe/5HgZcFoUX92wuNZa24UHz3rX1qS1XPmm7QE
         ZqOw==
X-Gm-Message-State: AOJu0YxEGHqcdBaX4HND7dD0tEsvs1rzu+9jTUY5zBvgp/DJLMfN7m6O
	IdQMyj0cIxL/ZipjwJ2kZs624n5QAOpckRA4YvEzvEaMHhVgpomtQiV6M/IYPkbu+sCyb6CFkfc
	2
X-Google-Smtp-Source: AGHT+IGqnWqy9TmAYINxOU+lsQiVMU5ITxTBibR+mJfaYzqxteGSDmm3QvErW4toapH1IBLkCSRm6g==
X-Received: by 2002:a05:6a20:9150:b0:1a3:64e8:eb8f with SMTP id x16-20020a056a20915000b001a364e8eb8fmr4866533pzc.11.1710802453151;
        Mon, 18 Mar 2024 15:54:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id n29-20020a634d5d000000b005d6a0b2efb3sm7703783pgl.21.2024.03.18.15.54.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:54:12 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLrt-003o5t-2p
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:54:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLrt-0000000EB3p-1Uly
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:54:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs: drop SB_I_VERSION support
Date: Tue, 19 Mar 2024 09:50:59 +1100
Message-ID: <20240318225406.3378998-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is a followup to my original patch to drop SB_I_VERSION support
that adds a second patch to clean up all the remaining usage of
inode->i_version and completely internalise the inode change counter
as Darrick requested. I haven't seen any issues or failures as a
result of this change, and NFS doesn't appear to complain or
misbehave over the reversion to ctime based change attributes,
either.

-Dave.
