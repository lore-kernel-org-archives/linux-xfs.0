Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A224336C082
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222907; cv=none; b=PzFsglEDMcDsSkJBTqXTSzecMbTlBJ+er5Px5uOx47+8H0FsReGXrwlqqxhkHl2OAS4JUewc0bimRCtxPJnYUzKebGwHjbOFRas1k2gtnuPX8/jG2epV2KPC/jSphGdgQoURcvZTNUYraOL+yVfqdaS74iXD+k2GcccDQQl5+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222907; c=relaxed/simple;
	bh=1ynNzpiuwPqZZfc4RXGfh4iGaVDz+/1Rc+r/9GR0kTY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh2h4FziGNprcY3vGUsnDh6CzyUxpY43BdD6j3rOn7LWpr429Gdr5kario7YXlA1a5MCmhCbNCPSnr6TvK5GmM7a9rYHJHariLQ7lpBtWO9xQpF1+yWFa9Xyqqc7LEk4Wy1MzQoUsf3epp8no2sPmB6bLQUBgMC0TpMPRJp7Lwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=uxi7ohXq; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="uxi7ohXq"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d71bcac45so45864497b3.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222905; x=1756827705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7o1UME4c5fAFN/Xhsfm0V4nndfddrm872UrCQizuLdI=;
        b=uxi7ohXqKUcBZO7Ua+hc/ajCXggSTI51qc1be8CHoDfUpzc91NJRWTj/ghdlaZYRf9
         UZg0KXNhymiGudejku1NoA3cYkQKamjzBVlLEFd6DdClC3w5WTOYjiwjrdo2npfRk5se
         rccY1P8OI+uIIFRIpkNDPGmZORCr2dsZ5FwzsD7zEg2OYIpROZqzcWcry128AHtFhHlp
         40XeOJZzb9CJ3Pw9dhXIg7BYAJHGtCSTnyJwArIl0VKn+2nxcrh0YTOXBwxok1KBlNTo
         i6+JRCs2Ohy6I6h+rp+4maxUIdO91tkyGK/4frTy/5B5MYdwS9dXV8z+ZV8yR/zK0Gls
         O3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222905; x=1756827705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7o1UME4c5fAFN/Xhsfm0V4nndfddrm872UrCQizuLdI=;
        b=UcVWz/FQAn4qsKJl0Qr31Fm89FWZMG1y97WQxvpY4Quw75PoikqKhgm0cKvJ7LspfZ
         +Geahsiq/DahuA5ieoOkYfsuYKm0fupzFYRQQAtpDueYe9FcVFg3XzwTuC4rrHgv8QJi
         mfbQaiYLxowU7oq1xJtZHk+arFTCUxhFi0jeYdxb+/6JTErk5SX7pANCqr0rjNzLB0YK
         s8ZRqxBXnMdGNcmq9Vxb2vkq1JHWb7EwE1YiJm+AFpiZNxMv2vWB79CkyxaSsB+CN0dp
         3lpkf3wZrAxP0xTDj3TanfAgEJI+bw1p8VwnqnpE562L0BfNtUYJkfgFV02TLU17BQp2
         ya+w==
X-Forwarded-Encrypted: i=1; AJvYcCUSdIoCI4+5Mpk0boZATLVdtR1I2H+yu4w0GYY8xNRK9lys22CYRrhMzJmQzjEHeXMMLwFfFxxa3JY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5wtt0AWy5Pfbsr1H6jodO0tuRjzbvxFcHIZpOIbxVD2ElxRtn
	6Hyid+KY006RFS0XDbU934vyiW5OJy4ildKJeid5RzmZuqMzIazfk7wSVtElI8JNuL8=
X-Gm-Gg: ASbGnct0A/ewRIqUvUA6qFZoiaINsNpLKMgowjqvtxJkN+M0LWLoWqBPCoHFtUD6rrD
	j5vY1d2oPLuuzV4JPUaoTZCldW58sYPc62cps5M+rpWoGvjX9cX66v2yp5uOe7n2+ZR0Ez2o6+f
	odgeh0qV5ti9X7w72ZVpTRQjNHn4ouJk18ZURipOcWlf0Vkry6LsGSk5gU9/Trqm6Z2Tj0UgY29
	5kSncD3hfEd+2rdJK1IidyWukDRtS2iOneOhEdqODMi03JzlSIVJqubSXdC4uhnLIoKrAdBFxXX
	0a7FKlQpp531D6TeE8PZSAAz293rqYXNIChhqbQ06to2xD6Iz7g9c9NdTmm0+2XVjOnwGTqQDiK
	K3Yc7pOLuhfO1TS8ngfoM4j5JEj6fer3HcprUOAcYP7mx61syNhw9DtHXHotbVhAqAyoJlTn7DE
	ND3qte
X-Google-Smtp-Source: AGHT+IGukatO5Mwgl+iFpY8aNAJGoZlPwkGqVoc2HLHPS4uUtL3IivdATW29hDRBnU0HqwHw9U1Bqg==
X-Received: by 2002:a05:690c:6e93:b0:71c:1de5:5da8 with SMTP id 00721157ae682-71fdc40d339mr188030487b3.36.1756222904483;
        Tue, 26 Aug 2025 08:41:44 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5fbb1a885absm418881d50.4.2025.08.26.08.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:43 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 38/54] gfs2: remove I_WILL_FREE|I_FREEING usage
Date: Tue, 26 Aug 2025 11:39:38 -0400
Message-ID: <45b3bd8bf31cdb07d0b7db55655f66ab49ecc94f.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
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

