Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794617988;
	b=FDpg9dr1St8CWGWYyh4O8lMsgVl43ZXu8QTf8v6qmjJi/O88VNGm4f8EX6CtjuS6Kx/J
	 HLdwPUz2ZS+37Ow6Ysc4FnVsXEERXu327A2109NRmxnuV5Tw2mcGe0ZCaBdSn0x/l9fl/
	 kD7BSgI7rJFpTA1NOBhVHkv3C04fmG9D4mAXFuVXDREtKdi92ER63tE7mCd2om3AOS/y6
	 qBG159X59QJlWDAchl7fE6ELEn7dZjmm5e1w4MQNK/TRZKcNCwlPAg7+Q6ezWIO0bDv8v
	 iQCN5pF5LGlwPPmI02zM1L+Ve7HE8LwI2jhzUaVgtUA9N60GF59Ha4op/Aqxmt0g73g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794617988;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K1yWxOrs7aLv3Az/EKcMIDPICU4PM/uIVfZVDOb46Ds=;
	b=QcHmeymfpnTn89D1om84CF4M7Cgb7EG2GDyp1zVU7Wg640QwQ3CftL8E/1dDRtEij96/
	 qPd3JT47bhKJvilvshGwckgJH+mpJgKEj+LA+N/hYyqZXGOw98F8gjTNgsJBVNZmz9lwV
	 8QdACCia4PlYnl0u7tFG7qHUfJVPvYMUr5por9ZPfutU9MWuHOmh4O8N6JYnJgRkdhB5g
	 j6s+pkBePMgKprAyTNoVlUVSQK/5EKxdUdKy+MvuciyJQF6jNATtH6pol2rkaxo804uA3
	 UDyzxWi+hHcvOnVS66SNhWlDPbZlS4Z9kBXxiaEBRzNZqIWWlK6P5UEmIhHgMax4ong==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="frtjc3L/";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=c1miEiFN;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD304606A327
	for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2026 00:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD304606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=frtjc3L/;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=c1miEiFN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794617986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K1yWxOrs7aLv3Az/EKcMIDPICU4PM/uIVfZVDOb46Ds=;
	b=frtjc3L/ARYWj10SQJD5PUEeNX0eg8ZLy5esEWoP1hnDo4zFzdQD8hyaVA0qrwG1MymOhy
	jnY3rbe1aXS9yEy48zwrd87pfPEhauWUg9A54zk06n59azlVYPG7Tgrwy2X69zRAjmvAaO
	TFt6IS2IFfGKanh+CFZnKHrz7s0830I=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-lAa55I3MNL-3g1mqKGYNJA-1; Fri, 13 Nov 2026 19:59:45 -0500
X-MC-Unique: lAa55I3MNL-3g1mqKGYNJA-1
X-Mimecast-MFC-AGG-ID: lAa55I3MNL-3g1mqKGYNJA_1794617985
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-716e232332aso2229589eaf.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 16:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794617984; x=1795222784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K1yWxOrs7aLv3Az/EKcMIDPICU4PM/uIVfZVDOb46Ds=;
        b=c1miEiFNAktKjqA7ihuXvo8xJnB1uarOhbC/Cngu9RTiJir1ZREiU42o+1tEZ/Xofr
         P4LhmqnTgIsFtwLQCcGowXP2+/yP6boiZmqktJqfzTFIUkht75zwCM8pFZnQcFH7mM2c
         cjoFYPD5UC/88+bI0wh6baSehDDTFaGCQ2z1vPuL9zVVgq76RoKPVuDrS5ZHGHmH4QLw
         4bkcCN6tutNkTeggDblyUwK1VtitgSsq89vavZNrM2bG5uqYyKF1x96hOKTK6u+da8Wo
         QFKdpUDm276nSeynTRW0DvwSXUWTHkTa2OJNsLv8e959tTP5c2rst4+3Bs5qkQy8XH25
         RSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794617984; x=1795222784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K1yWxOrs7aLv3Az/EKcMIDPICU4PM/uIVfZVDOb46Ds=;
        b=xFxJjQT2i7hf0rkA2Z7E/cVWoXJt5BW1tofqgX+QMQ5Cd5Ij39+I72LNt1RumvjByr
         jCiZYuUeDXYHkh9qAoFjDlIZvtCOF37+W7Roq0iSM6RRYhoHbx/iIpakdNE2gW1Q1erX
         RvrWZmVO057ceE+X83tv1IHwZGad2eEODcnnz7T6jz7ib6gwgD0UbYpNzeMiR9oveZon
         O/PhBRzVyKKWkFIDMiCzkxmxNyJaCbDxFCACPqVjbNSTN2apD9Pe+whOJ/pK7y9+gzOH
         3NB5Wx9K17pNLVJ3t6yuinXtgnNBKPWpCOPEJ8QmuB3Ax6d7ZCb12d2E+3UztqfuXJMx
         fLlw==
X-Gm-Message-State: APuU4Z/JKDaMD1u+PAaGKtqQjj4txLPxaavxYv0rBT3gNsu9tuOEZmlQ
	uUBopIs3wV6ylOjFFqJTuqzZ1UAM/+6fyC7aVK36qWPBN+0qz7OtXT4Bkx7htgGdHtJQsfznT1U
	vl8fCeCeocCsQ9WXqB6wvRDFiD6ih/QRqN2BruEy9atLD4+okMtfPk2Ql5HrxB/tk11mx/cMUjK
	T+mhTg08t+otmi5/YBcagHP6SPPh/pRkW9zHS4XhbOZD98
X-Gm-Gg: AYBFou2H52GwsfawrLqYr9Emtzkaso197bWN0d9wQBTCZTy97KS9gVQNhTJ/0MG3An+
	oessnBjcRBV2rg0D4Fp7T/JS2sKYlM9w+6YxAizUWb2llCyjEJ4nYiKLQWGks9dLxpQHfXNTMmp
	iqn5k5enNxSoZEA34bGnW/D5c7uU141TX4UTYSecbY9xOHPM1rcIRYgfiamnpioRqT1E3EcCTbK
	DRhcgbXO9ZvE+g10vVrF1WvYvdXz3OGxxfrgCJQVPVi13o7d9tgi06Tby9I6+9yfAak9ovuA39Z
	j7hOe8BkOwpPaf/Ln9mhIcS+CZCW02AEXst01gRXRKfpAc3DqdQA8i8KRpYxTsXtqk2T4dm8rnu
	eWdX3RUX9cVAq9mKLnHci4sksRgJOKuIvm1benOdgEv3JZeeAORAx1BrGYgbCWwMWDldvFkPqxj
	dqeolgGNNLRhwobA==
X-Received: by 2002:a05:6820:1518:b0:719:1627:6bfe with SMTP id 006d021491bc7-71ab4abb6c2mr2773790eaf.0.1794617984447;
        Fri, 13 Nov 2026 16:59:44 -0800 (PST)
X-Received: by 2002:a05:6820:1518:b0:719:1627:6bfe with SMTP id 006d021491bc7-71ab4abb6c2mr2773780eaf.0.1794617983811;
        Fri, 13 Nov 2026 16:59:43 -0800 (PST)
Received: from big24.xxmyappdomainxx.com (174-20-5-40.mpls.qwest.net. [174.20.5.40])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71ab411e269sm3402752eaf.2.2026.11.13.16.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:59:43 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	xuhx@hust.edu.cn,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: properly order xfsstats proc/sysfs init and teardown
Date: Fri, 13 Nov 2026 18:59:24 -0600
Message-ID: <20261114005925.103130-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xfs statistics are accessible both through procfs and through
sysctls, so they need to be fully set up before exposure via those
interfaces, and those interfaces both need to be torn down before
the underlying percpu structures are freed. Today we get that wrong
on both ends - we expose them through xfs_init_procfs before allocating
the percpu structures, and we free those percpu structures before
tearing down sysctls and procfs.

Fix init_xfs_fs by calling alloc_percpu(xfsstats) prior to
xfs_init_procfs(), and fix the error unwind path to reflect this, then
also move free_percpu() to after tearing down both procfs and sysctls
in exit_xfs_fs.

Reported-by: Hanxiang Xu <xuhx@hust.edu.cn>
Fixes: 80529c45ab66 ("xfs: pass xfsstats structures to handlers and macros")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..769c622cff54 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2668,9 +2668,15 @@ init_xfs_fs(void)
 	if (error)
 		goto out_destroy_wq;
 
+	xfsstats.xs_stats = alloc_percpu(struct xfsstats);
+	if (!xfsstats.xs_stats) {
+		error = -ENOMEM;
+		goto out_mru_cache_uninit;
+	}
+
 	error = xfs_init_procfs();
 	if (error)
-		goto out_mru_cache_uninit;
+		goto out_free_stats;
 
 	error = xfs_sysctl_register();
 	if (error)
@@ -2686,16 +2692,10 @@ init_xfs_fs(void)
 
 	xfsstats.xs_kobj.kobject.kset = xfs_kset;
 
-	xfsstats.xs_stats = alloc_percpu(struct xfsstats);
-	if (!xfsstats.xs_stats) {
-		error = -ENOMEM;
-		goto out_kset_unregister;
-	}
-
 	error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype, NULL,
 			       "stats");
 	if (error)
-		goto out_free_stats;
+		goto out_kset_unregister;
 
 	error = xchk_global_stats_setup(xfs_debugfs);
 	if (error)
@@ -2727,8 +2727,6 @@ init_xfs_fs(void)
 	xchk_global_stats_teardown();
  out_remove_stats_kobj:
 	xfs_sysfs_del(&xfsstats.xs_kobj);
- out_free_stats:
-	free_percpu(xfsstats.xs_stats);
  out_kset_unregister:
 	kset_unregister(xfs_kset);
  out_debugfs_unregister:
@@ -2736,6 +2734,8 @@ init_xfs_fs(void)
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
 	xfs_cleanup_procfs();
+ out_free_stats:
+	free_percpu(xfsstats.xs_stats);
  out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
  out_destroy_wq:
@@ -2756,11 +2756,11 @@ exit_xfs_fs(void)
 #endif
 	xchk_global_stats_teardown();
 	xfs_sysfs_del(&xfsstats.xs_kobj);
-	free_percpu(xfsstats.xs_stats);
 	kset_unregister(xfs_kset);
 	debugfs_remove(xfs_debugfs);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
+	free_percpu(xfsstats.xs_stats);
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
 	xfs_destroy_caches();
-- 
2.56.0

