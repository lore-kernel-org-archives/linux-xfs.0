Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB7858222
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534131; cv=none; b=sqOfb5fkFoSeBNbejx2QHuYWfg3WJrc1PuZktqEF5dZ9gM9IeYK+HkV09rErzspEyvdHwG3E1GVCFFXrUuAW8ZYPzR0lg+gxORK5TD7+I/yNOTlZy//kWla4nE+QGgY2nc/nZvDg6o22cDNCmXn4hmPka0chw4ediCbEX6ZBAE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534131; c=relaxed/simple;
	bh=K7ZOS9zIfdbAXIqQsXDnKDrsJzCL+9Sme1mH9nrUgto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tqbY6YcmXi6SZLr+xDEBhAy04Wx/Ui/0Wf3owISBPrJE9ewqs3Kw1v16okSWQy2y9ki6MrQWIQTT74THeHsuCBrH0wKr8hOVDhydaFNMguWswazg/sxSjG4u/CZm62BRgypaDbjvYp4DJxvbC4efZFlI/B+HhzST+PnW9AX29lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=lh08j+Ur; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="lh08j+Ur"
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B2AC73F1EE
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1723534120;
	bh=gmx9WjIOlCIoagptFLTM0T9Kfm1ZmccgBN/2GTR0w7M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=lh08j+Urcb5wSKhDV0Pg/OKg2mwkvw+9IN8p+vA2xbE/K+i2ccD/bIO00siYBfMes
	 +EauNaA5YphdA8ff0ryxC2DnFwBnbQxYknoYdmqKg+byahwom9M5dv8FH6vuT/SMEw
	 ws46fr7VoafYXcozG6TXKHPQT2bK2CEaYYXy5j+tgp1Tg/MOMrmon10rafTTcpxeIG
	 I8MrFfC6aFRy2uNGrdYtv7blkhFCURQtXFlmlO9odJBBOhfLR2yqa/gm6gG0QkuVhV
	 1AOaw9JQeyBgdetDjuCf6CONYCt/H1gC/KLr57Z2+7wzmF5BIptWMJ0H/Lzkb+P5Nc
	 ZJzyALLMEzMvQ==
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-70d1d51f3e9so6286052b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 00:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723534119; x=1724138919;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gmx9WjIOlCIoagptFLTM0T9Kfm1ZmccgBN/2GTR0w7M=;
        b=VmgkKqF4gdzFULKGuj4i1Nvs4vsGLbyZu4gTJAK8FFo9O6jZKCwa6COvybqLJoS/m6
         ljfqTvtLIIkpLmZFNnbkfFeyHyWFKX9VA8qXqgMQ567OwrtW2nXGlwdfG1Fy9fCPV3eU
         BvKoq2MD2U6XCWzWdqPe/qtdR+v/eLj48MwQAark7pxDFtfExsnSxW00i5G0uJZMsZ0B
         VXJtzGJ0UeSnfLi7qvHU+nr/HC5FOpJedCrGNxCCTeVo6I/btiQhMN16AU8s8GHtEPT3
         SVskfNXaPkfrGKBV+BzY1DSQkhjfffAAxyg5Z4IUSZAZthhTTHnOMeYZEhwPCOkSLntB
         FfWg==
X-Gm-Message-State: AOJu0YyaSjpeMEn3Of/1Pld9BwD0ZEGt0i3crAb7QqpbxFIxeZnz4Alk
	XtxOk+SpORUuT1IXyLWT8aZJdw+f2itD9r+5WQd9bOaq+lTfgB/X1XphVvPthPK83FAnnGeVVdY
	pgTfDvqSohJOnhda0E6bzqVhD8ZhSfmKYu00M7MwyW2Vc/fq0+kEuyGluvZngmL9vtyHeUj/HHC
	+9cEwf6w==
X-Received: by 2002:a05:6a00:b41:b0:70d:3354:a19b with SMTP id d2e1a72fcca58-7125521cd08mr3552256b3a.22.1723534119018;
        Tue, 13 Aug 2024 00:28:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNTcENvcpBWTI3oD/2Nce8nXVovdBrvcr2rmisvjjFRBKBFJhrJZNOzERCgE7KNER9W016dQ==
X-Received: by 2002:a05:6a00:b41:b0:70d:3354:a19b with SMTP id d2e1a72fcca58-7125521cd08mr3552235b3a.22.1723534118627;
        Tue, 13 Aug 2024 00:28:38 -0700 (PDT)
Received: from localhost.localdomain (220-135-31-21.hinet-ip.hinet.net. [220.135.31.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5ac6e4csm5101488b3a.196.2024.08.13.00.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 00:28:38 -0700 (PDT)
From: Gerald Yang <gerald.yang@canonical.com>
To: djwong@kernel.org,
	sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] fsck.xfs: fix fsck.xfs run by different shells when fsck.mode=force is set
Date: Tue, 13 Aug 2024 15:25:51 +0800
Message-ID: <20240813072815.1655916-1-gerald.yang@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fsck.mode=force is specified in the kernel command line, fsck.xfs
is executed during the boot process. However, when the default shell is
not bash, $PS1 should be a different value, consider the following script:
cat ps1.sh
echo "$PS1"

run ps1.sh with different shells:
ash ./ps1.sh
$
bash ./ps1.sh

dash ./ps1.sh
$
ksh ./ps1.sh

zsh ./ps1.sh

On systems like Ubuntu, where dash is the default shell during the boot
process to improve startup speed. This results in FORCE being incorrectly
set to false and then xfs_repair is not invoked:
if [ -n "$PS1" -o -t 0 ]; then
        FORCE=false
fi

Other distros may encounter this issue too if the default shell is set
to anoother shell.

Check "-t 0" is enough to determine if we are in interactive mode, and
xfs_repair is invoked as expected regardless of the shell used.

Fixes: 04a2d5dc ("fsck.xfs: allow forced repairs using xfs_repair")
Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
---
 fsck/xfs_fsck.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index 62a1e0b3..19ada9a7 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -55,12 +55,12 @@ fi
 # directly.
 #
 # Use multiple methods to capture most of the cases:
-# The case for *i* and -n "$PS1" are commonly suggested in bash manual
+# The case for *i* is commonly suggested in bash manual
 # and the -t 0 test checks stdin
 case $- in
 	*i*) FORCE=false ;;
 esac
-if [ -n "$PS1" -o -t 0 ]; then
+if [ -t 0 ]; then
 	FORCE=false
 fi
 
-- 
2.43.0

