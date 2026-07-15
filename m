Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE42C4963A9
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784136682; cv=none; b=h0MDU8Kmo2n5juiL0I+WEXsAp1ha2hxhvy/btpqawm80tXXm8kxbrSx1eZ8gks0a7LBizN26//p40D0NSfKTg8Ws0Js9KOYaFnt84kBMzsjgUoebWuFnr5zt8cJV1YKPfJhbu6kNPhtbkXQ2Dti0SMB8YjHmKN/l9HcqoPAybRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784136682; c=relaxed/simple;
	bh=62jbLUTe+p3E4Vqkm8wCenHEgLSnFxeO+ZJEp07XjJk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Emadt7to7lnY9yFkUgjImc9uy6AL0L6idxUvM/6B7LeYAJAdRlrEvqfjq7YvnJWEgS9gmCh72GB0lmqJYEW3hXpe9ubbHoM0ytnTX1ZTo6DbZSF7Wo3nY0fyNnqlMjDDnKNnNO0brDC13Dv1hbXpxiGP6QhlGVKtOxbiEHMl2Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hvp7oSnw; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hvp7oSnw"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493c733f15aso51489305e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 10:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784136676; x=1784741476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hU+tPiCp1O2jInOUlead5H5dFUyJInCLz9NCVFOaNBU=;
        b=Hvp7oSnw0DgOgUeFOpU/E7LdlQSKPTGFpo5+lCTp9NPQnDd4V7E78kaLKPI8zon+rL
         qhz9DHhpDzMmQXI/NWTEjyMNjOszsOokvAyDPKyzK9hOEL/g8ItUIKVXpxnzWbjZM0pJ
         lCDijvZTjZCGTWNXLva5905BcglKj4yDVKWgCBgiKeKw7qeMqn6RMx+2TM9tn2H76+gZ
         uhLh9e5zXoDeZuoTLrEUtLb6xgjc/umChWfm4AhWUQduf8YTVqVmjw8EOppYDzQlLdLy
         ar/TRkOnT3VcrYajtOQQgbVc0S4j+jzduX5agmMo3xokgRWzBgvk8524m0yLD8bqDVdG
         jRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784136676; x=1784741476;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hU+tPiCp1O2jInOUlead5H5dFUyJInCLz9NCVFOaNBU=;
        b=dHp0W2cgbUHkZsh4PBhzddGYlZbodlpkL2NFQy/9v16w9HSkV2Yxr8Pp06hbhlcwrd
         CUS91kkx+PhnloU1Wu2tKSX77pADf1LjQtADd+B8aMsgxy+Z2oLE/MzsgOnfFHOW8G8x
         qP77SAeV6wmAiytKyUtKCjQ/KEhBfDsGwkzGmqbl63jhZ99s3v3oIj0ubKxIsieCSmdQ
         d++eRJv1PCygM0HyFSwx+ePnHItm3pKshKcPz4o+p4GOEoy3HzZp8BLuoK9KcngahfZm
         ZIPdkBMJPYyO8b34fuA965YF2i3QQ+yGw/qKdQ7iAXyVYgyS13SK97O4Jdfmc68h0ZdV
         TOQA==
X-Gm-Message-State: AOJu0Yz9qP3VcCToQ2vAIWnVw7rPe6EJqvNBadYgTJVSh0jY7wFTd86z
	3JUQ35BvYWRwFCy7p33dx0IGetyVzyueXo05feJQnAPi3KYkqUCdkbRjEB9m4xNe62cMo40vnTs
	qKRYl11oy4w==
X-Gm-Gg: AfdE7cnENrFJZTgrwM5nFwXsHAUn6kO9rW40pe8e7+CNnsT6e5dLmRZMelxDcN7a4Uk
	VJ2R/QU4EtNLenf+jPoAIgb2APpMKjaUZak4gjsipa90B7MNT2qPYvOjXMgOqDnSDIMhul8kaQM
	7dj7QugW8qfG0yma3pmu7uTkYCHxkxgrNWXPvvi8AyiLl85Tc9XBs/2GvtC3fDsRT6dZKzJaGEa
	rfj4BRzxywm9hihrB8QXNsTp3hymyGGbVCgII+C913plxSzO2ykW5EgdQ2quiuv/S8cBxz5WTAx
	PtdSFCYp4z/MG4M3IBzvfcBL/vvBpkQGVsKIUvFaSAlbfprS71rekQlhM2TdJ6N+fpmSMlnttPQ
	2XLHh/CC07WwxOdZrj/oqm2Eiu/XKOC4B4vG93rErvXoRfqxXQY+zepxJxRHKbaUwlfPkS5ewo9
	A=
X-Received: by 2002:a05:600c:1f94:b0:493:c8c6:4989 with SMTP id 5b1f17b1804b1-4953909f29cmr74350405e9.6.1784136676235;
        Wed, 15 Jul 2026 10:31:16 -0700 (PDT)
Received: from localhost ([2a07:b241:1004:8300::1000])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2f9402sm163747935e9.13.2026.07.15.10.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 10:31:15 -0700 (PDT)
From: Avinesh Kumar <avinesh.kumar@suse.com>
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org,
	djwong@kernel.org,
	cem@kernel.org
Subject: [RFC PATCH] libfrog: make cmn_err() emit each message atomically to avoid torn output
Date: Wed, 15 Jul 2026 19:28:21 +0200
Message-ID: <20260715173114.359368-1-avinesh.kumar@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Avinesh Kumar <avinesh.kumar@suse.com>

fstests xfs/033 fails sporadically with a spurious blank line in the
xfs_repair output:

- output mismatch (see /opt/xfstests/results//xfs/033.out.bad)
    --- tests/xfs/033.out	2026-06-24 15:52:51.000000000 -0400
    +++ /opt/xfstests/results//xfs/033.out.bad	2026-07-14 18:54:46.582495041 -0400
    @@ -103,6 +103,7 @@
     Phase 3 - for each AG...
             - scan and clear agi unlinked lists...
             - process known inodes and perform inode discovery...
    +
     bad magic number 0xffff on inode INO
     bad version number 0xffffffff on inode INO
     inode identifier 18446744073709551615 mismatch on inode INO

Root cause is in cmn_err() (libfrog/util.c), which emits a message
and its newline as two separate writes to unbuffered stderr.
xfs_repair's threads all share stderr. If one is preempted between the
two writes, another thread's line lands in between:

(snips from `cat -A 033.raw`) -
Phase 3 - for each AG...$
        - scan and clear agi unlinked lists...$
        - process known inodes and perform inode discovery...$
Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000        - agno = 0$
$
bad CRC for inode 128$
bad magic number 0x0 on inode 128$

which should be like -

Phase 3 - for each AG...$
        - scan and clear agi unlinked lists...$
        - process known inodes and perform inode discovery...$
Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000$
        - agno = 0$
bad CRC for inode 130$
bad magic number 0x0 on inode 130$

_filter_repair() strips the noise line it glued onto but not the lone
newline, which then fails the golden diff.

Make the two writes atomic.

Signed-off-by: Avinesh Kumar <avinesh.kumar@suse.com>
---

Hi, please give feedback if this should be fixed in a different way.
Thanks!

 libfrog/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libfrog/util.c b/libfrog/util.c
index 5bae5bab..3b6df917 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -116,8 +116,10 @@ cmn_err(int level, char *fmt, ...)
 	va_list	ap;
 
 	va_start(ap, fmt);
+	flockfile(stderr);
 	vfprintf(stderr, fmt, ap);
 	fputs("\n", stderr);
+	funlockfile(stderr);
 	va_end(ap);
 }
 
-- 
2.55.0

