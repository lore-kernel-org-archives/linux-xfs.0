Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C462638F1CC
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807663; cv=none; b=ulbh+LWGwlruQ/F5DdBPlTNhSBKl02UtYvSxyLTx4aQjn9MAs3GE0D2MClX90XOPzaG9fIIiVJ6ti5mcAkkkpFwf323lFy32gzfUd2DS8svhtQL8u8RUqOUDI7gHnEaqxPEB7ViDw0oyo1AV4BScSxhW8zcSCgV2Wxvi/VmblSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807663; c=relaxed/simple;
	bh=IkafURwKBFSZguifSMeANEs1nfLj+d2hP631K3/rVjk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6dS62GO/oGX5cTeSAjUNBrAbQDKV1a1NX5yMtjjlk/2Xu2gbS6VGLWvdo3gKiN+Gn9akr4wfnBGGmpRyYFyxMbOH+UnKHSvA1FOMjwNLcoZVUpUs28jmkKqL9XfAo9qQ3z1AaYWCNcfH0bU4BmADTC5u5NttIptiA9bR9CDtWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=w48BCG8c; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="w48BCG8c"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d60504bf8so12600227b3.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807661; x=1756412461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7FM4ZS/CCiHT1N83b4qCfaeSJikQ1oCz+lcijf4XNlE=;
        b=w48BCG8ccJgkma1AlOapUFCgp/21WNdaAASUnZYXvMybLQjatToJnP/1FPIRtitPM+
         5dn/K5SUYt/xVbtQ+6saR1qD0iw+EloCHTxkQh2j9cRlTOrNsjTsIcREkd+uWN7/Ql0N
         E3wqvLsQ9MTR4NuhfjdubroLi8Sm/WWKT4B6L6V0NwyTAikwXP0mVqmXB+z4HNYASN3Z
         o2fabiTx37jJOCQzZ3Ajqn9ocA/CR290z0ffEPURt2WZDl2IpkO/kiKdM4HhWdDPXx2p
         6OFNly/nhJA7MuaE27fSKUbvi/3PFY0RCQLKoClpG2Ku+OYkFGwhxLR70S6bIqpAgsQU
         gDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807661; x=1756412461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7FM4ZS/CCiHT1N83b4qCfaeSJikQ1oCz+lcijf4XNlE=;
        b=Ure4p4S8q/QJ9zV/bv91y7V2St7frhnOdnN6sq2AYsds5khFo6VrqCI+uJP84KwEq+
         BXyLVIV2ogPVw6X+kSmWCSwgNbZ1DbUtYqnQUhcHtHfu9PerxOHj+fPLiAlqj/y2pin6
         Wi4QorgMfA5yyNy5xm226Av3y+jsm84NjJPcadNH3djbCac5OeIceWoBOuKOw5pyFQTr
         KpgCOju5N1Cn23OMTUVzv2MEemGVLHeVAmGOSbnhQEmHQA2/AVi7eBG+plk6VOeK26w4
         d9mwig5oGQlTNaI88apIay5KqEYvZ9KWNdQhKcwqJsdeuh0darzSpyxZWrTVLWEVy8z/
         IamA==
X-Forwarded-Encrypted: i=1; AJvYcCWZmjwP4MX866imPnCbeyFAxRwvuuQ6OGo3pXhO6jv3aL8/D7R6tt2ov8vIQ/FwOcD0w183wtye1ek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa5Rkbr0+UTDZ/peD7IAAsUs6jLUCEOquJcCD/3Z7cU4GvLXx7
	QDQo3cDjf/CRPH7nxvAeHfu+1xJy56KVTXl61CXuD9LUx92yh3U2WBRErQfsXgMhTmf6e2LiwN/
	MPVsDUu0ZYQ==
X-Gm-Gg: ASbGncsjBskLAMr3eE31yYt5ozE6ddtiS8Yv0vBc0SiVrlpcitvxIh6gPTDLgRjF8T5
	g9R8LFKbRqyop2s2+iTNz/EYpBzvO3yn7UuLdj/d69oOxTkajqm69yHZkr6J1uSwOVAhHgYLmZN
	yILSfF4VZcLhCiBe4RKY4Y8P8jL2bgLb/ZLs+SofX9Kr6NUiIe1od5EEoeCBdYHgESle3vWYcE1
	4h8vNQ6/LaVuLCXSzgqzLkgUNGfizmFj+3IaTfY+hPTQ5MBPINdEKQnrPnY47/q3TT2zeHvY07T
	Yn1tLEuseSngfF50gPwYmMI4qv/skGByNVZFqLm0uw9NwazH68Bu+c8xHn/DmMmLe/o9dCh5wB8
	OzWzR++PWbej3dXVB4YuiYp/L9UuFtZXv2npkwqYDpSjSPQlBg/LW+4/4yLw=
X-Google-Smtp-Source: AGHT+IHXyW830DnvyKqzvZNJ3jCSg9ln5Zh9ENecXokTzlVqOL6TqrPnRD3Q10rxAbC3n1YAglqgtg==
X-Received: by 2002:a05:690c:30c:b0:71f:ab32:1e1 with SMTP id 00721157ae682-71fdc2b275cmr7719697b3.10.1755807660634;
        Thu, 21 Aug 2025 13:21:00 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f52c1dda5fsm59031d50.4.2025.08.21.13.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:59 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 30/50] bcachefs: use the refcount instead of I_WILL_FREE|I_FREEING
Date: Thu, 21 Aug 2025 16:18:41 -0400
Message-ID: <008961b8237f87429bcc1f8573d764dab2b1a22d.1755806649.git.josef@toxicpanda.com>
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

We can use the refcount to decide if the inode is alive instead of these
flags.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/bcachefs/fs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 687af0eea0c2..de1c3c740a9d 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -347,7 +347,7 @@ static struct bch_inode_info *bch2_inode_hash_find(struct bch_fs *c, struct btre
 			spin_unlock(&inode->v.i_lock);
 			return NULL;
 		}
-		if ((inode->v.i_state & (I_FREEING|I_WILL_FREE))) {
+		if (!refcount_read(&inode->v.i_count)) {
 			if (!trans) {
 				__wait_on_freeing_inode(c, inode, inum);
 			} else {
@@ -2225,7 +2225,6 @@ void bch2_evict_subvolume_inodes(struct bch_fs *c, snapshot_id_list *s)
 			continue;
 
 		if (!(inode->v.i_state & I_DONTCACHE) &&
-		    !(inode->v.i_state & I_FREEING) &&
 		    igrab(&inode->v)) {
 			this_pass_clean = false;
 
-- 
2.49.0

