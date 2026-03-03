Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1F7199FBA;
	Tue,  3 Mar 2026 03:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772508976; cv=none; b=Rp13O/nWbDspaEBKL7fPL8zOAaX8O53cCdx3EtyAQX800+6bWtZ35Og0YEM1FjTqtZrtrH2oL9FfDUaXvdEpXcMkP/6lkqBbCv6wx+PmAIMXmloGqd0iRd1n2gHjToc+VV7BUyTvHk/dEV2a2AkGaM8vszd6vnB8HAnLhw8wj0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772508976; c=relaxed/simple;
	bh=l5h6UNrPcr6W7czBoldLPIimYxHYiWtbsUgOgh0gvME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aTX+Wm99aC1fM3JB+CUhmai79klK2vlOaukfBYj1tcU23ya1wpWy+TWhsP3+qNq8jmMIub7AUt7sY7xBrQJaRUG/+DmB5KIzo1HjO6THcBv2wZr74zJBLif+783yVOSM8YgrL8PRC2Mjj/wARLuzCT2yFJw0FCHBv6v8zC/+QcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=QW1kVL8u; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="QW1kVL8u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1772508862;
	bh=iB6d320ee3DB3SNqxVUCnYqCzjRZ3Ean/1HV6ERLhA4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=QW1kVL8uNWn+f5DaihOhRXZk9qwA+Q57bVFJ4/j0WOAzL0UcTw3SE9hD5fwPMIgMp
	 GhcIKGRFICn5oHZqanFlxuV12mq5x/XVS/WwBVgYfNK6XKtMBFpRKKMIcrmsONZcXY
	 5x6KQieIA7Y3vleSsXMO7wIYVkrQr356xgBCD9Z4=
X-QQ-mid: zesmtpip2t1772508858tb8fcd0e0
X-QQ-Originating-IP: krzoJFRI4TgcNLoXhliORuHGtrCtUE4i5Ykz9a15s2E=
Received: from hongao-PC ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 03 Mar 2026 11:34:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16761856596894031061
EX-QQ-RecipientCnt: 6
From: hongao <hongao@uniontech.com>
To: cem@kernel.org,
	djwong@kernel.org,
	sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongao <hongao@uniontech.com>
Subject: [PATCH] xfs: Remove redundant NULL check after __GFP_NOFAIL
Date: Tue,  3 Mar 2026 11:33:32 +0800
Message-ID: <B6935AE39B8FFBF2+20260303033332.277641-1-hongao@uniontech.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: MPEeF6PUOsC8KaraAnOsaCfTfY6Tr0cjmwqo6Y53Gvvys1I/4VeJmY6d
	A73zbgHdVURs2XMMlCTcSYO9ZYturvhjQqHeW4bnqBG93sQ0+wgMBQfMVP1va5C7APGnETT
	DMXdgdGDtrcO88/wB6RzwTIUI7tazXf2pzTxabFHzZoOq/PzjXwzveG1gPWgiHD9+h3dS7Z
	N0jC/sV5i52crXt38Q2WHzYq8JheZyFtF0pWTqeC52Xtr+AN0zHnSqoTHJb3GrmzOp4gdRk
	osF+QLm4rbpbeaMz5oKzVjRHQ7aX/LZZ0Juf3y5yFDrZNdivh0ZLAgc6gKaygsv5KZJds7H
	kATjHxvF58wKi4/9bNT8LTfiigjl1dcTUG4ETVtnFXX1Il7qtpJB/yhQyFZo/SgJH5MlIIw
	+fvDdFbwe0vze5/bhBvNaSJp/NiUTnJbdpwspHAIRQvyjE6DqyX25EjTOHlsMLlIos4azHl
	ZaBVStLupdXrAIOhN+NEsQHuHuWteeip1bCv8A638Dg40FexJ4SgUaUkcZh2yU/a2QTzh+D
	OvYwzHdPnl810GiQjiXsCW5rYTNvXwpO/0wNxrw+SKu4XdSnb8vH0v21TAzmNwezYOck3vL
	2SeJe8BME9FygMwZzTT59wKITv668YiDbKncMRmcggNLNMkatp2TT1Uro1v5osxOxTup1RI
	Xs5uglz9wF/DZfVeM8pDo3usvUEWs+vPlWUeQLABiivuKLmJvAdpqMnYLIejCx1EVdGAj6Q
	aJi0W6DDl4v6QcwzGKk6n+0HCB+EtnJtTzdsvhUG+kds+XQlg3fhOrNDlvLhU2INYr6c6wa
	3TRjT5tkia4dIwgShirJ3kS2mSVsNoxFptjsQPaLzt1qXIetOZtFymU+18oAfd6pMzz/Kdr
	QQXJilOd8extktQXJy9Ijttpvy7zlFuKLF5TB0Yl3kmyi7H+fbRe3GOfmJjlNdnpnEsV8VX
	OxNsqVxfoung7fB+0KAcROdcfMly2Zr/Xqtu4XLwAiXLs7VkfSgI+fFWo/EmR97RoBsZi6H
	J+hkOUh2gsB4GCNRfqeh6S3EbgaNIoT59pbrmaN7K04J4LkDGtzm6NgszCZHHXx+Gn6A4i4
	cq4SxvZ2mbB
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

Remove redundant NULL check after kzalloc() with GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL.

Signed-off-by: hongao <hongao@uniontech.com>

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 766631f0562e..f76dfc8f4e1a 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2718,10 +2718,6 @@ xfs_dabuf_map(
 	if (nirecs > 1) {
 		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
 				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
-		if (!map) {
-			error = -ENOMEM;
-			goto out_free_irecs;
-		}
 		*mapp = map;
 	}
 
-- 
2.51.0

