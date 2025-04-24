Received: from plesk.hostmyservers.fr (plesk.hostmyservers.fr [45.145.164.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5F820102D;
	Thu, 24 Apr 2025 08:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.164.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745485165; cv=none; b=uvcbVeWPTel5yCoYdVKtHU7WvgMvRjGiPXO+/Xs0RxyVOceJdj9059v73YEK8veGn/eSnXq8epFNAYP/XQ6LxU4O12tKcz/a6Ab3g3bqWi9BC5bQmzsDtAFBdx9KVyvHidxgcFVMxS53SlkT+HVib0gw0QTLFRLgYCN5ysA370E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745485165; c=relaxed/simple;
	bh=s/PZCC6C7dNYSldko1q2R7adkA0Tj3BmAKQ+Z44kYxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOeYRe0osl2Ah4q5iWE+tiGpoUQndGckfbumh1x6JEOHYyOPYLU1ZsTgmUYqm5Yy08AKS9ZAmlbaeB2mSEGpvH3uvu7O5ahJ/KqcvbIvDEx5j34u5HUB207sNgePJl3z9FkwIngM84s/5E422BHNsnu3KgQMvUIjXifUIccYnW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arnaud-lcm.com; spf=pass smtp.mailfrom=arnaud-lcm.com; arc=none smtp.client-ip=45.145.164.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arnaud-lcm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arnaud-lcm.com
Received: from arnaudlcm-X570-UD.. (unknown [IPv6:2a01:e0a:3e8:c0d0:eeac:f145:aff3:8659])
	by plesk.hostmyservers.fr (Postfix) with ESMTPSA id 7DF4A52B4A;
	Thu, 24 Apr 2025 08:59:19 +0000 (UTC)
Authentication-Results: Plesk;
	spf=pass (sender IP is 2a01:e0a:3e8:c0d0:eeac:f145:aff3:8659) smtp.mailfrom=contact@arnaud-lcm.com smtp.helo=arnaudlcm-X570-UD..
Received-SPF: pass (Plesk: connection is authenticated)
From: Arnaud Lecomte <contact@arnaud-lcm.com>
To: syzbot+b4a84825ea149bb99bfc@syzkaller.appspotmail.com
Cc: cem@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: syztest
Date: Thu, 24 Apr 2025 10:59:13 +0200
Message-ID: <20250424085914.82201-1-contact@arnaud-lcm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <68099bb2.050a0220.10d98e.0005.GAE@google.com>
References: <68099bb2.050a0220.10d98e.0005.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <174548515989.17600.12464261522932033389@Plesk>
X-PPP-Vhost: arnaud-lcm.com

#syz test

--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1182,6 +1182,8 @@ xfs_dialloc_ag_inobt(
                        if (error)
                                goto error1;
                } else {
+                       pag->pagl_leftrec = NULLAGINO;
+                       pag->pagl_rightrec = NULLAGINO;
                        /* search left with tcur, back up 1 record */
                        error = xfs_ialloc_next_rec(tcur, &trec, &doneleft, 1);
                        if (error)

