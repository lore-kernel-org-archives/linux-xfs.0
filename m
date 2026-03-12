Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828C038B7BA
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 09:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773306503; cv=none; b=WcbAu7ldRz42qN5k1Dss/K1t2JoYtpzCNVQcDeC5LikyG1Brd23c4rqhxkKRc88ClB9HfeYk4u3xsN5KUdwBGWhaDSzsYRh7eiACAGjcYKrIV9h9SyIcxBHqMHv9LTirDVbNzBTv1hY+kYi5DIBcqMKnytZcR4an/prF3X9E11Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773306503; c=relaxed/simple;
	bh=684ISgQ8smHUyEZZTzGZngt64u/D6u1pEXkFQoQVAfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SfpyYFT9aovU/k3butchP8Q+DP6vcKWB+tYHG5PLWWT7jYtuFlFtbvq0W7QTCXniaCdVQVM99ZQYlgFTMN4pcXxJGR0KDrv1MUmpLoPmUzh4evkCFehbzrjzpd/a7576OnTP6n/tafhH1tQdFRgHkiC9+yzhNp9M/E3k/5r9JZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gM9oRoxE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iuIV5lZ6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gM9oRoxE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuIV5lZ6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773306501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eYKj8TYhZs/mWZdGVkKQ790hFLSyw65FsP7IykSGsaI=;
	b=gM9oRoxEuebKbTwId4c8gQjK9n0IBIVTyBeZEkZLEcnZPdy2bET6HskVOBiB4cauaz8Q2N
	x/KgObpRa+e5Z1CnGafa/EJIr+eOxDgOnnWMImjg8+aywY9434k74Auy9saj1UYj+RZBma
	5h8P4oL4gTXEL0CmW7wbGKELXT9hSAo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-7kwwYZpVNKu98XuGXE1OLg-1; Thu, 12 Mar 2026 05:08:19 -0400
X-MC-Unique: 7kwwYZpVNKu98XuGXE1OLg-1
X-Mimecast-MFC-AGG-ID: 7kwwYZpVNKu98XuGXE1OLg_1773306498
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-899edf01747so8899996d6.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 02:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773306498; x=1773911298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eYKj8TYhZs/mWZdGVkKQ790hFLSyw65FsP7IykSGsaI=;
        b=iuIV5lZ6ddw7IuVSOgb6x6rFNYZrf7nWtNk2eeG09YAEv2qbBDbITPyHMm6WU6D+FM
         Hr4RpbpIHf970d5IKFuChIIBqoFRmohkA01+7mUlEGhJuCNA4qLT8BAuFseWWM9DkRM2
         ixj+5Bs0z54NenkQFjKwBBHXErta1LtF+7wB7HZkUz6PpCLGiYJYZL26bY12unCQKbA6
         /F+m7mfWBvuJmQyeqgIouYV36m9irl8HAvj+7h2h8xLNfUeusdSGW4kq6J1VlbdV2Ut5
         06TVYt4G+KWVPFEcBzbtisS84GDnJtNUtSjoVbsK4EXjRoSv1HOkTdNmLvsWnVrEzRr6
         JfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773306498; x=1773911298;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYKj8TYhZs/mWZdGVkKQ790hFLSyw65FsP7IykSGsaI=;
        b=PaYi7l+Adfk2kRsWltJ1jt0SIdTg0Q84kOXLBMHsoY4CL5WNdPCDRl+tBNBxB68C21
         nEa4ev+nN0CFGMbqMYBhiMePObJBYUijLE4nv7dIzdXEIWFSWAMavy8YOewKpWIuVvyR
         pi6OVwlE3C3t1zNDmJrveEgzYSpvG8KOltOe3gX8DCjRYsvMvidQ6Tz2G9Rdr3EW/0UK
         tO+MdeHUpaVQUC5ACVsHtHMedu2XRgAJ0zlP9M5A/flY0ZG8NpxU28AxwYf0jTwRdniO
         u6mloWtOx5nq82ZqVrX+sguF3IMljR5dyjc/l2VnMTcdu3pLbtTOHPC3KcQTnjmM6Xs1
         vV/g==
X-Gm-Message-State: AOJu0YwGH5SsBF+mJ2jeglC18ycVKZWFc10wmRT3No8ZYR5Zsf50+Mnc
	Q+NiNYdp7Pf7jfBAwOVJAtw53kWBidiBQHmOc5WRj7rzcAWXKwHJVKnFjXyJJzb5kewGrcS6xwd
	UN/OcnRrAiREXJVnh53keaYgjRcMN/bMJW4FDi2UNBHumkZkpuitMtjteJinKDLFQKdT73CgU4e
	I/6DFTmbJCSJuLzX92hAYpZbCmxQr+8oIbD+qUOjCTVr2WaQER
X-Gm-Gg: ATEYQzz3nJErBnDQtF0ee5ZHmIakAFZDuKqqrG+RciHFpQJTbWqadTIuULTNjU8q5bb
	iRSSsmUXzQH2azXBD7AiJjXhlO4BeHxfam5j4EXzyKkCi/t81vn6FaWVBoq8saK/Dx7es1b5Vr2
	lrpbaIq2hXwbHOLX/ov7kSTgU8dgVD/lvmleiWcKdNYrDXyGKramszCbTktnNOXg6vmBOXmnvVS
	mKjVAuA5NyyXPV7ZdsXDpILp2CSq6GnQe+N07BlTIePmacJjTSw1K8g19XwaItUHDlECBL66ITP
	x//hULBNa3TO46vtzrCe73KZgpmOTeBvx8ftL8zOBwkxSOkrHZfVtbGi1hZeyGNpnpfw5yYfmAi
	Muca2cVIBvw6yhd6w
X-Received: by 2002:ad4:5ec6:0:b0:899:e8b8:8744 with SMTP id 6a1803df08f44-89a66adcc90mr72412236d6.57.1773306498085;
        Thu, 12 Mar 2026 02:08:18 -0700 (PDT)
X-Received: by 2002:ad4:5ec6:0:b0:899:e8b8:8744 with SMTP id 6a1803df08f44-89a66adcc90mr72411796d6.57.1773306497533;
        Thu, 12 Mar 2026 02:08:17 -0700 (PDT)
Received: from fedora.. ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cffbdesm30780086d6.41.2026.03.12.02.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 02:08:17 -0700 (PDT)
From: Ravi Singh <ravising@redhat.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: jack@suse.com,
	cem@kernel.org,
	dgc@kernel.org
Subject: [RFC PATCH] quota: allow unprivileged users to query ID 0 default limits
Date: Thu, 12 Mar 2026 17:08:10 +0800
Message-ID: <20260312090810.1145908-1-ravising@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Default quota limits are stored on the ID 0 dquot record and are
applied by the kernel to all users who have no explicit limits set.
However, check_quotactl_permission() only allows unprivileged users to
query their own user or group quota via Q_GETQUOTA/Q_XGETQUOTA.  This
means unprivileged users cannot discover what default limits apply to
them.

Allow any user to query ID 0's quota via Q_GETQUOTA/Q_XGETQUOTA.
Note that this does expose ID 0's usage counters and timers in
addition to the default limits. This enables userspace tools like
xfs_quota to fetch default limits and display them to unprivileged
users.

This change does not affect Q_XGETNEXTQUOTA, Q_SETQLIM, or any other
quota command -- those still require CAP_SYS_ADMIN.

Signed-off-by: Ravi Singh <ravising@redhat.com>
---
 fs/quota/quota.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 33bacd707..8b21f3c1b 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -42,6 +42,9 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
 		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))))
 			break;
+		 /* Allow unprivileged read of ID 0 (default quota limits) */
+		if (id == 0)
+			break;
 		fallthrough;
 	default:
 		if (!capable(CAP_SYS_ADMIN))
-- 
2.49.0

