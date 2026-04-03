Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7821248F62;
	Fri,  3 Apr 2026 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180631; cv=none; b=WBGIjLvkNGjfvmDS33mk/p5QM0tvz+TuBBrT/4FjyjiZ0JT2TDcyfVNGRuEW7VaghaxW8RY3w3ePZpqg2MSRKZx0MHxZWSJ8U9/UuEtpGRI9uGH/uzKzkq4MuXdofeRJG2ioQ6gi0iMZ1W3vlnxO3NxiIis8FCKkmDC/OCut+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180631; c=relaxed/simple;
	bh=pPAnbZXBvQPAwDcgrirebQ7qX7pU6qPa03X+SuB2zxw=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=SwYLnPwm08sQc7L/RysKZNYXTqkfdbQPU1xl3UUcHEHGoJmMmQo3SXGnrf8xvebU6VvKj2EPVlBq/O6k/SHepilLvpsJQkKQKDo6in3ekOcWFB6luilpc3Yd6WSLhXIgcOOO5P7kAzn38xkLNsZxPNCjibmOj3Rnez1TkAwPCx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ttN12VBE; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ttN12VBE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1775180623; bh=RbbCvnBBaG9Nr3laFCBN7NIigAl9sAI3ZzyDdUPOwew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttN12VBEXg42XO2mueN6FrzLwhdOzVcS9PFS7RoA/X/UMpGk8LNZuyP9FW2eh+tz4
	 diN8r9G1nZqnptIT9n2rLfQv7A1tinTJuEt/WZ2+3EZ5yTvwrsD1/BTyvf1TCBMpfr
	 XT+Lyq3P8jpeuECuP85w922ajEv8GQO48/y1ODdc=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id AE7A185F; Fri, 03 Apr 2026 09:43:39 +0800
X-QQ-mid: xmsmtpt1775180619tlu8b2pk3
Message-ID: <tencent_4D4CBF27D046DE52D3067D099C6EDDEECC06@qq.com>
X-QQ-XMAILINFO: MMwjR1C73eIsFXylMMCRwnZVLHHYhWfeGNAjCgvzclnCPjn+a/G9EXhf/o9FmI
	 vyXS4LXjMbkCdihrOL4sHNy+KCx3CpQJ4U5nkzLDJd4QW6dWjdeLTF/DOVebvpV+y/hPgfFRKpeU
	 3fM+MvrKaBFKp+whMU2ZsO2ldOVVrfGB98CyweGZFvvthYTM1EH9mB9AmxP8NHs2RrOZfK/6uCdU
	 v/1BhF3Ejmnn5acDvKNPcBEYe7hSVgbT+MhEuxWAg6l0qci2ytoYC0Vp0MMrwIFjq5W0qefceMlR
	 8edMlToTVgKrNGDlxpmoqszV9D3Mry0oOZQyM+VD/0x8EAu+UDo/Nw4SsSZkWGLgy7WlwdTZhzMX
	 Bm7TSm6U6UurpnOYD4sKYP3UG9jIBheX/PzizE1X2iE1md+wVzGlKgnDBlN4+3pB9487d2b1nPxE
	 xJm2Xw+KMbkSAlJe3/l7nhYYVIKOfkRDnLGMzC1J2KRkKmJeS3YX91i/rOFhH7uop7AfVr1b94ap
	 Cr3QlHJH5iSlN/5wTsPxVaBFWIWogEw1xXbAyboT2VoutEwedqsm+px5TQOqCtUr5GwgOE4utfvr
	 I240SXwe7GVyZY4ziKbxeBA7mqICAcff4XbI4cf3F2c2TeU1cLqQDpw4IYad2E0YlqiB0ORHrERn
	 3dD2cD3mETlOR8SmyYhTL63xA3T1A6E5w8h8RNH8uNZqLPTAPGsKCYUrfwFYcMGhokXVSZidN0wo
	 ZIiRmOSoQEmVpw2LZjdqWQXBCswUOKOeanNtgOuv34/FB7vErpIrfw4zNaV+bne9txnyyfUUDeZZ
	 XsdXysuuVyKjmImt0A7pP/niBvzaSSFNMqOP5POWytrL8kD4AzFX781bjyi61rEmj01sxjKNf7Cj
	 LITxNmaQPbalN46k/i5lDaVuPM/cd9tbJ3+2ahQnVPQFhaD+q9vwHbJVuXAdm9A4BpJ0lDek4XQb
	 1C/7FQCC0czmQ4yMInm0zE0ZkB9lNqej4kTXQOn4EdfTsCCl0z93CwpwmERE50rL/ImQiF2TU=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
Cc: cem@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] xfs: reject CRC validation when the log header cannot be retrieved
Date: Fri,  3 Apr 2026 09:43:39 +0800
X-OQ-MSGID: <20260403014338.789919-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <69cebb99.050a0220.2dbe29.0007.GAE@google.com>
References: <69cebb99.050a0220.2dbe29.0007.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the traditional algorithm fails to locate the log header, it triggers
the uninitialized-value issue regarding tmp_rhead_blk reported in [1],
continuing with the subsequent CRC verification traversal in such a
scenario is futile.

A check has been added to detect the absence of the log header and prevent
the execution of the subsequent CRC verification traversal.

[1]
BUG: KMSAN: uninit-value in xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
 xlog_verify_head+0x6c3/0x910 fs/xfs/xfs_log_recover.c:1058
 xlog_find_tail+0xc2e/0x1a50 fs/xfs/xfs_log_recover.c:1315
 xlog_recover+0x6d/0x800 fs/xfs/xfs_log_recover.c:3426
 xfs_log_mount+0x4da/0x880 fs/xfs/xfs_log.c:617

Local variable tmp_rhead_blk created at:
 xlog_verify_head+0x81/0x910 fs/xfs/xfs_log_recover.c:1032

Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/xfs/xfs_log_recover.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09e6678ca487..0d1b4bddd193 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1050,6 +1050,9 @@ xlog_verify_head(
 	if (error < 0)
 		return error;
 
+	if (!error)
+		return -EIO;
+
 	/*
 	 * Now run a CRC verification pass over the records starting at the
 	 * block found above to the current head. If a CRC failure occurs, the
-- 
2.43.0

