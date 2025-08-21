Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D487E39218E
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807692; cv=none; b=ehdQSVj23I47QlX+rBuXGvNe+EIYSRAm2JrSW5AkpSclSpvF21/MpXydyq3RY2aBMXs7LHpgKf5ym0jq1ndaYhZCHlwJKJXHLdWo47R3xTiaKS2rGuo+4dKUTAyJIU7yOijQ2qDb6Z11hcZCCcXDCiJrgVH/7wRR01kjqNvRlcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807692; c=relaxed/simple;
	bh=K7JnBj/EGzyS1OdbBFrvkh4RZsBpYi+IyFwAgh+Lb+g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXP+jKVVzssXxnBtS2H8eFoxvGc9o4II/R280S1Vvs1IdOR7NG6c0Ce9WgSfTEHxZU3MQPLpW+HgmnQQQUM6EJAHPsOpDo9y5Ox3lD6oh29+r1BKssH5LYLy1Ukbd7z8d8pGHFZketcdR4791fxaXtcMLttGmZ391aOX/JsQfIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=l+PlcfAE; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="l+PlcfAE"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d6083cc69so12303317b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807690; x=1756412490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXIzcijPr4pONzroTEWGlRY1GomK1Uf0HH+VMUMLr6k=;
        b=l+PlcfAEmx5i2V8op88cnpZsuRkMTt7IYc41Sfy+HSvLebZfCwtTQZvCH8Bk6CsjJt
         K4jx60j64kmerkjnRTZbVcPgHZU736YIo+p+ZDF8yz/jjL9nIwB+u3m+OFY+rMpWwLAl
         7AH38QWbHlSX645VekRQcQVsAecCcb9p4J1Ml6vxH4WYtcAhaeCvGHNKmZjd8w8e611w
         KQ9KD5ssYCHEffbvY4RRx+FZBsp9k1jgMDuNc2cVHg7U5MhMZcTgIhIFOATLoc3Kciwh
         X/up8AhmF+Y5tChZcdZoK8E82UBhzCXt62EHRVx+lw9Ko0RyUcMS/yw0j5SMCS2XWAQi
         L/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807690; x=1756412490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXIzcijPr4pONzroTEWGlRY1GomK1Uf0HH+VMUMLr6k=;
        b=rurA8eQFRJsV6oOdZ8hQb3rHpxPNPifhokCEqvXpe436w1D/Hy+A4nChbZFMfT1LXM
         DmrFqE+cAucXslWgNNJv2XJ2nZ4Df901/3vmYkN9BZcaTf5PzRs6Wh/KDzpxeiSoq3O9
         dpftgVOdOOgUkgHBl0yeUcXAJUjt3JNIWfs2tTJoPBahyLZTTu6qUYfzJlkLaLH3jD59
         PqUD/xXIrF/yf3ipQygwitecAm/Z2a3O7xH02ZyBCHuhp5kFjYSU/8dJNgXAhiQ3ouOm
         4BxsPbnfQXa3rH9J/LQjN8e3HOmoEX7L/7nbaZ20+ceuixSTQHyN6WvQPXtdGvkWCSA3
         bVGw==
X-Forwarded-Encrypted: i=1; AJvYcCUB0jX8DmmOm0jvu/7xxyGbEahRmawrUCUn9SFrTbJzqjRZ4+Q3XbVExLO3NkvRmE3X4WAbaHChgIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/U1TB4NpjrMtbUWanNoC+bnqplr1GmyWxTj3Qcugm8IwsQ3My
	cAfpLydL46XIKmQwgT3IKpI6k9wVw4jg/f+23vNjuWAD9uggqc5NA18SrYU9cV6BLps=
X-Gm-Gg: ASbGncvRNbsTl0zXPuHznjJe1/4f/cbM6qeD3b8CE950Lh2tFc/U1ipXpNkzA1WgOJj
	cRh4HF+M6eBoFnzbUBzPL9OWqfqIORXiUpDU22X2sP1tOrW0TDM8V4Km/DT4ADWKTj1CnNDYe5L
	sGDJRtcC0y+wpGxmtUqCGYd/MvOuSVqLl9WCl+1vujcjpeERCEfV/JQ51GBST87mnrQVIltuuRE
	3QHLAnERmi1XHBIJLCysNToy7sZ3wDqKu11ekhe1TTIIZrzmOVN/ZFHVInk295xidyKjqByReBh
	KetQptJNE1NQFnrAADgSF7lPb2c5hQtHQ1ijR36MVKOWCz616r+02MG0+zBn/6XSWVKukk9f//i
	TFVs46mz9XhOV9FGvJ+jsIERqNtJwUhHXlCYxomUJhe6JEUO6ctwuYEm79Q+ddzFRtn3Riw==
X-Google-Smtp-Source: AGHT+IEO30NmlKq6gjexRRcDwC+IutcN4FswlbECizygJkS4EjREg3MgjupO6wxhwVTETYh4w1p4cA==
X-Received: by 2002:a05:690c:4d02:b0:71b:f755:bbc1 with SMTP id 00721157ae682-71fdc3e00bemr5400007b3.31.1755807689657;
        Thu, 21 Aug 2025 13:21:29 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71faf1e1459sm17292517b3.60.2025.08.21.13.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:28 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 48/50] ocfs2: do not set I_WILL_FREE
Date: Thu, 21 Aug 2025 16:18:59 -0400
Message-ID: <c00734df0a9773105cb274cf924f04ac73b3c4e4.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a subtle behavior change. Before this change ocfs2 would keep
this inode from being discovered and used while it was doing this
because of I_WILL_FREE being set. However now we call ->drop_inode()
before we drop the last i_count refcount, so we could potentially race
here with somebody else and grab a reference to this inode.

This isn't bad, the inode is still live and concurrent accesses will be
safe. But we could potentially end up writing this inode multiple times
if there are concurrent accesses while we're trying to drop the inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ocfs2/inode.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..d3c79d9a9635 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1306,13 +1306,9 @@ int ocfs2_drop_inode(struct inode *inode)
 	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink, oi->ip_flags);
 
-	assert_spin_locked(&inode->i_lock);
-	inode->i_state |= I_WILL_FREE;
 	spin_unlock(&inode->i_lock);
 	write_inode_now(inode, 1);
 	spin_lock(&inode->i_lock);
-	WARN_ON(inode->i_state & I_NEW);
-	inode->i_state &= ~I_WILL_FREE;
 
 	return 1;
 }
-- 
2.49.0

