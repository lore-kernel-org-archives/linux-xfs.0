Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBABB371EB6
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807674; cv=none; b=pvoLBH/ZSiZMRpwTm4RzayupNm2vkKqM5jon5x9EDMucRevMMZnWYMv4Ic9wyBLN4hL+xpfkyqwvfdbWE9g8I/f176mjZAcESzD2rOI11ovJUMKmB+qmqiuxLFtFF96PR9aMkBg0tD6egCoOHlgspdWKQGI9kyYxVIOlbYXOuUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807674; c=relaxed/simple;
	bh=1ynNzpiuwPqZZfc4RXGfh4iGaVDz+/1Rc+r/9GR0kTY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKFzwUNCSGHWsjvgUz4VzL9UMELRBayATgnaBSU5BM+Cy/EhXzh2jN03iVygr7aA+L9/0N9t9qJUHsl+DGnyH1UQ4POEEZNIW2cBKicqAYaN5yBDjOIZitX8k5ueecpXInWNH5FPTKAY/6GRDsPJ6ltH4bRcygb2jGhl1rSYXOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=RmE+irxL; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="RmE+irxL"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e94fc015d77so1481867276.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807671; x=1756412471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7o1UME4c5fAFN/Xhsfm0V4nndfddrm872UrCQizuLdI=;
        b=RmE+irxLbr8dhHU/ye60oarMKOW3m1gPME3Wd7Ldi9qcnoXpt8r1SkMJeMJglf15U+
         1oFrhsxsO+YI+fJ+yx2xrQuMdSFROZyPo4NPa4x7eDchqOYHDxh24YwT128ODXGG6Egc
         XRAju03vaOqChD6PCt54IdhnDx40gjjAw9sIUt4H3+NRKquL+s4PnZDh0GtvsdqfEEuN
         7B6DZzuXUO3ZIJVFRXqvcb/vVb9Blafmaz1/3LBXltazJjHdjeBmAZyxNCXdntbrab6O
         GOCkxeVE9NDzklw0TwczMPWdl05mYGBGP4DERw7sTBitUGJ8SyOco+jJCe4v6AgT+NKV
         L2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807671; x=1756412471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7o1UME4c5fAFN/Xhsfm0V4nndfddrm872UrCQizuLdI=;
        b=ZGgYZ7vhS15gf/yUWhOp/1EsR0BPuwXv7DrdzcaX8KWQSTsFXTKxw24BmMEtpvtEL6
         uCbav1QUGTwkm9g2YjYrtwevibtpWX2AvtezmyVDRw3PoP/96UxJlWvOGiiYhZDwHqEc
         Kxncdmg7tRjyd/KKyy+8wSfuyRwxYg440nbBzy1svhdhQpFfSa9Zg0SsT2LXB+UTdLXr
         UKRCPG8dJg5qnTvRXDNJ79erqBvyAd9DcI3CB7RaTSesm1mqfYP3qo+f0yV8nd4xNwvS
         c3kqDDseNCw6VBQ1qmsZB/HVFFBCnLVHsDid7y0nFP9SyBcaPp6hinNUtpxtPruTH0u/
         ch1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLb/6QtlMOYUYxcq9XjaiLWsDOmKd1F2c5MickDhoI7Uc8c1jIhZG6aoawJtu8nvZxFD0q6slSxBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX1MZ4zwKMBRWY+vdO220IEwJzr/RdvXjEf3lzFcL7yCbu/ils
	zADoMd00B1U1RLem0NIgWOyDrtIXoQaOo9Jw81NknwZIk7GsE3kUEX/DTwOgXhCPAvw8faILWNn
	KFpk8ZD0PABWF
X-Gm-Gg: ASbGncsq4+GQ0Q9p86AnwCFsGE8j6BMsY2Nhm0vmyXU2abI3kZU8FgbczX9H0O1qLXb
	2rKXaFILi4GTMHKLkNeEkDLPQT+cCvRbNiWPszbFmxt9eQ4qnDQ0IiqoTXNXt+4Ltq20LG1E9hr
	EqYoII9rdtX/rBBrniSHGRuEZAgNHkW1MQ0C/K/gaZ5kwEm+/iqZl5EwIHBLU0E2oNF4FDJSwsk
	ShZ+EwNFQdkNPawnxMAFT7wL9UEADbA3wtRoznAfO3S8OaTFkfLm4fH5iVUkn6PFyX55isFHYvx
	yDfDg90lYgEwP23zisL7LjL+WjsZS3o3EObA0W7gxiYiEeGi8YW4BQQRHJSwcvn9ReuJD191hn4
	m0XxuJD3nKdlCvx4563JInE6Aty2qwp5MKH1bFxZW/JILiRxc3Ng9H7OSkgw=
X-Google-Smtp-Source: AGHT+IEK9Y3HGsRw84lNwHY9ub4929O/sGVc990y8WeBLhD6pl7WYhs7lL5XHgi9vuczlX82x2XgRg==
X-Received: by 2002:a05:6902:33c5:b0:e93:4b5c:d50d with SMTP id 3f1490d57ef6-e951c2a6db5mr895451276.25.1755807670806;
        Thu, 21 Aug 2025 13:21:10 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94ee7b9ec3sm2508563276.17.2025.08.21.13.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:10 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 36/50] gfs2: remove I_WILL_FREE|I_FREEING usage
Date: Thu, 21 Aug 2025 16:18:47 -0400
Message-ID: <0551f9d37b57fecb82930a3465d42ee6a55ea11e.1755806649.git.josef@toxicpanda.com>
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

Now that we have the reference count to check if the inode is live, use
that instead of checking I_WILL_FREE|I_FREEING.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/gfs2/ops_fstype.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c770006f8889..2b481fdc903d 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1745,17 +1745,26 @@ static void gfs2_evict_inodes(struct super_block *sb)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
 	set_bit(SDF_EVICTING, &sdp->sd_flags);
-
+again:
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) &&
-		    !need_resched()) {
+		if ((inode->i_state & I_NEW) && !need_resched()) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		__iget(inode);
 		spin_unlock(&inode->i_lock);
+
+		if (!igrab(inode)) {
+			if (need_resched()) {
+				spin_unlock(&sb->s_inode_list_lock);
+				iput(toput_inode);
+				toput_inode = NULL;
+				cond_resched();
+				goto again;
+			}
+			continue;
+		}
 		spin_unlock(&sb->s_inode_list_lock);
 
 		iput(toput_inode);
-- 
2.49.0

