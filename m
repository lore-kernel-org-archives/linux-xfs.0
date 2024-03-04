Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391917D3E4
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579553; cv=none; b=higTnSs4S5Iag3MG24uaH6Co99MOHdr/4kMbT+8k2SPlXaeYAP/5oD3yJ1SCWJJkX+tSzf/5HmLbJToSgrO+9Q3og8Gu9oT4Ep3UmX0pp5rflrq8yvdztGPiL1XVoclVlkuke99YVvlSNC6F10ZaRed+xgqpDm+gA5JqPquP2Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579553; c=relaxed/simple;
	bh=q0TWMGdcx6UYw2sFq8ZSAnpd1rQAgwPeqQNrYl42ZRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttvAShv8qZsMMMHOkpnqgfMlgfTbKiJwHgeZZXVSPNu/Vg2fbRttxPzcwSHjQv1e2muD3whnpb7giLcqIq0CpTTIES9LC+KLwLp5i2TZ9xzqOacpDeq4oNuP/ZLjGG+occk8fOL6IQwHjfZOXQGM6j3qf/QtKDtm5LQuLJQLYqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bGrd0F2i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bGrd0F2i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tZJgKDbZKO9AEPv9hol4NRfnrrJXjSrBKcTnHhFLOjw=;
	b=bGrd0F2iVVjipJ3h5d9JR4dJ9CYkWruxbxWCvCeQFl5657U6bmHl3zMx9LBs+8xawLG168
	jK+MFFU1l6qYxFMxggW9pwKzo9AtuvS8UXAEqg9pl+ICf6Qtl0DH5Lytdt+r+goDT8ZUwR
	GA4Mmfn0REyvMWoeDtA+cSPSc70kKtQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-AkJDs_3ON4KQMcisLFp3bw-1; Mon, 04 Mar 2024 14:12:29 -0500
X-MC-Unique: AkJDs_3ON4KQMcisLFp3bw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a45095f33fdso185620866b.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579549; x=1710184349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tZJgKDbZKO9AEPv9hol4NRfnrrJXjSrBKcTnHhFLOjw=;
        b=VXvjB9UFMN5n5CwxqDK63/mBS5GICzbyWplhR48UmfeZG/t6ExZiFklOsnM8G6wI21
         e16D6aba7JvbfEGATQOOHm9Q7XvP7WR9riWP/oNqHUX6Kp5nJ9FfWmxz4qGUC2AJmLuR
         M9Lf1chjkNiRNQ7HUX3IaFNNPRXcdKmze2IngXndgB8VRYqnuVNWruGnCHO8X6B5Lzpz
         Sdt1+Z6Fom6GHmIlq8abWyRYxfqZvIJzlJ/DsG84bPVqA1krNQe47rmMRV4vUiDSGDDg
         dbKiA/h9ucG0L55P8ScdTj8hFtO8iklx5ZXW5kPw7syNHJvMVm0C60/QLMe8IcIXMeIr
         m83g==
X-Forwarded-Encrypted: i=1; AJvYcCX9nGm8nq28bFKV92/rO8300OwiHyOTR4nlv5jTxunR/lHIDDHRBfuXudlIiz+kFS8IEOJ3i14b97b1eibouquKJ7d3ZWh3ZbmQ
X-Gm-Message-State: AOJu0YzLFwknkCLJN92CAbouCK0cSCOv2B20gSodMkbydGKETs7RVbjQ
	+zb3WsRGzVVH72f21yBbS69JbjJar0v4D9tO1cqanPs4+ymdf4xbmf8/yqk4nPDZrFxxcqnYnmE
	jaWyLNyXPpw0kEhOYwYO+CTaYDNHVojE1tdK2O5il1hobHI/eenr2FIVD
X-Received: by 2002:a17:906:3950:b0:a45:73b0:bcc3 with SMTP id g16-20020a170906395000b00a4573b0bcc3mr412638eje.34.1709579548805;
        Mon, 04 Mar 2024 11:12:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcXQkCy+qbM5MpjP28mYSzksscG7NinAKQc6R+cEtFLFSGXNxJn80ppRV0QWT9HBUWJwZUQg==
X-Received: by 2002:a17:906:3950:b0:a45:73b0:bcc3 with SMTP id g16-20020a170906395000b00a4573b0bcc3mr412595eje.34.1709579548091;
        Mon, 04 Mar 2024 11:12:28 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:27 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 19/24] xfs: don't allow to enable DAX on fs-verity sealsed inode
Date: Mon,  4 Mar 2024 20:10:42 +0100
Message-ID: <20240304191046.157464-21-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity doesn't support DAX. Forbid filesystem to enable DAX on
inodes which already have fs-verity enabled. The opposite is checked
when fs-verity is enabled, it won't be enabled if DAX is.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_iops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 0e5cdb82b231..6f97d777f702 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1213,6 +1213,8 @@ xfs_inode_should_enable_dax(
 		return false;
 	if (!xfs_inode_supports_dax(ip))
 		return false;
+	if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
 	if (xfs_has_dax_always(ip->i_mount))
 		return true;
 	if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
-- 
2.42.0

