Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50B1183CDB
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560533; cv=none; b=M0Jse0b5JZToNU46MMoU17cxeODTFle7UuDxqfVcRJy3dZthnTdq2usVVnBQ0MWI9Gdx3m86ZEhGH0oNdK0V20EoG4xAs/w+BgUYinm3boD+zGi0CBbCvIacGd5Nhb/iO8123L8wciOXPSQB4b1RdT4dBjg4ban3aZRpGFqBgX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560533; c=relaxed/simple;
	bh=NeOssh5ymZtU9jtpZMoN7p+YAqNkBque6S5t017xNpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/cRrNkFVoOL2/HNIEYCMbGMIn7tIFQ1umxyAwCnFhS+cSjJiFqhxcrU6YAqB379bqd9vWPsuQfvHAmnVhYCEeeSTrsd7X3cJXIXiWk7tYJmjXbjCN3hTFqp+Yk4uw0N2URrlUrFW/wlBLpjo4SCgo3p2ILm06RCAmVSj4qvUfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDk2Bo47; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDk2Bo47"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-201d5af11a4so10863005ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560531; x=1726165331; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRWzOc3+/EMvTO9f5DEXYWHVnsLlTM8gbmfkV3xHmBc=;
        b=MDk2Bo47tnheNSICC8Abq9mnSk0Hk/yWdloN6CG7F9oKwZqfaji6yCwOsmlG9F5hak
         mH9VMe480NAbQ+9jbsIh+MlciEXRlrvlhGtNoyi0OBsWTU4rcKy+Ham9v+gn23M1ebad
         fN+e5RqAmghI27wKoRQA5MDRgZ9oqsxxyXNg1MePXqje2AD/yUuK6ljTpUUdB82ix7S+
         dnq0UAgWzQv4IgJFzQbVhzkPO/TboGfJ/0Urg4sJ+NRVdFVxp2LvU8MhdPsPzkImuMfT
         2nTFfEOx0wAhU+Xc2JQytG8Jg7p6luPvaNK7aRhYI4y4Zsutc3d4DSWvp9CU6WLEKq+J
         IENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560531; x=1726165331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRWzOc3+/EMvTO9f5DEXYWHVnsLlTM8gbmfkV3xHmBc=;
        b=P36KOFzYbH2BHH6fGoTt0W//KCLTxAIShbhjC+vGfKC25+6wxMG1wCQSB6gq9RCpoo
         /p3OwIMbGf4N667gKuGPyR1j+6dDRzqCgm5T9wscKYdQIcGI15Y/sm1z4fWpWrAL6wa3
         K7mx3/6mbC6URhCjodgx6Q3HhH0XqAXbny7FWUcQN9oWlXl+Z6umm8jbw9cNAayE5SGa
         aCECVTdf7cYvpFMHZd5J+dFIeofdtxqrZiHW725F1mztgYU73yPpO+hF+KcFaYrKW6Ag
         TzMfwNNiZHE+HPtFVuSNlrHoW4i/VD982jnynRPR8gKOf3x7nu1w7IVAsIWAWqnjO2q0
         U7cw==
X-Gm-Message-State: AOJu0YzambJUy/26tuELynUJOKKdSReb+F3DMNYbKmbQrOl4KukOwSyT
	ANUtRtXCLDXcZIzUs/dQ/BBuMJ6GU9LTWfbVrNLwYJG5RDdf3uXjNTEtuBFe
X-Google-Smtp-Source: AGHT+IFlZXYwKKzfSVCvQAD/F7EYjBHt8mO4L4o/4IGfR/VxKkT251PJXIXN5RAsC86eMXDmLpAM5A==
X-Received: by 2002:a17:903:32cf:b0:205:753e:b46d with SMTP id d9443c01a7336-205753eb5aamr221051195ad.40.1725560531001;
        Thu, 05 Sep 2024 11:22:11 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:10 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 19/26] xfs: fix negative array access in xfs_getbmap
Date: Thu,  5 Sep 2024 11:21:36 -0700
Message-ID: <20240905182144.2691920-20-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 1bba82fe1afac69c85c1f5ea137c8e73de3c8032 ]

In commit 8ee81ed581ff, Ye Bin complained about an ASSERT in the bmapx
code that trips if we encounter a delalloc extent after flushing the
pagecache to disk.  The ioctl code does not hold MMAPLOCK so it's
entirely possible that a racing write page fault can create a delalloc
extent after the file has been flushed.  The proposed solution was to
replace the assertion with an early return that avoids filling out the
bmap recordset with a delalloc entry if the caller didn't ask for it.

At the time, I recall thinking that the forward logic sounded ok, but
felt hesitant because I suspected that changing this code would cause
something /else/ to burst loose due to some other subtlety.

syzbot of course found that subtlety.  If all the extent mappings found
after the flush are delalloc mappings, we'll reach the end of the data
fork without ever incrementing bmv->bmv_entries.  This is new, since
before we'd have emitted the delalloc mappings even though the caller
didn't ask for them.  Once we reach the end, we'll try to set
BMV_OF_LAST on the -1st entry (because bmv_entries is zero) and go
corrupt something else in memory.  Yay.

I really dislike all these stupid patches that fiddle around with debug
code and break things that otherwise worked well enough.  Nobody was
complaining that calling XFS_IOC_BMAPX without BMV_IF_DELALLOC would
return BMV_OF_DELALLOC records, and now we've gone from "weird behavior
that nobody cared about" to "bad behavior that must be addressed
immediately".

Maybe I'll just ignore anything from Huawei from now on for my own sake.

Reported-by: syzbot+c103d3808a0de5faaf80@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-xfs/20230412024907.GP360889@frogsfrogsfrogs/
Fixes: 8ee81ed581ff ("xfs: fix BUG_ON in xfs_getbmap()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_bmap_util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 351087cde27e..ce8e17ab5434 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -558,7 +558,9 @@ xfs_getbmap(
 		if (!xfs_iext_next_extent(ifp, &icur, &got)) {
 			xfs_fileoff_t	end = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
 
-			out[bmv->bmv_entries - 1].bmv_oflags |= BMV_OF_LAST;
+			if (bmv->bmv_entries > 0)
+				out[bmv->bmv_entries - 1].bmv_oflags |=
+								BMV_OF_LAST;
 
 			if (whichfork != XFS_ATTR_FORK && bno < end &&
 			    !xfs_getbmap_full(bmv)) {
-- 
2.46.0.598.g6f2099f65c-goog

