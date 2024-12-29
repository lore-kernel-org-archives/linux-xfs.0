Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479A41531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479549; cv=none; b=bWmhlA8UY2E63PGNC9JEQUUHFcPGiT1by8sa4KarQg69DKTr/ufe9njzEgSWv+rOjnjQExAbOLjxFOmF6JiwZ5KXkdtrzHaRozNC3cY2FeLPQAIkKOd6cuWB4Q1Gg6EtQN8vXaWF5l0TKSqkGXg/sVrR0yYmaYVUB69i5/oeRlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479549; c=relaxed/simple;
	bh=ZhcZFHd5JVEpVLlW9VMPmicx5F+tcNphNkg/aZjNQRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNbSQ3IqEOFMLjo5XdlQldv+SNHT9IgPycFOq3F5b4S2bB637SpDVjxMBx+NSxKGYU3eMRbfGsSHtyJ5XSd5VgsjxyE7JTH+4EmVVuZF6lmDI46MPlpAKbtv9p09nhv1WYsBDCw9rHvE/HRLeia0yPPyglM2cUv7l/7ieYc7ATA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LdYVTDgT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LdYVTDgT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nur/MaXbNbep0nGfnpuQnIYAkWa+dhGBZo7ukzuAicY=;
	b=LdYVTDgTKAYdiO2hmTyZhgC/dvcJVryKl0CHnq9vKgYzFZwksavdXv7EsXE/iQwpmrd6V5
	PiIV/IGaqlgwjc3p69F844mLntWS20NqgShJ+wuzWzAzlhaelZ2OcsiJhh71IEuulL1pdW
	jcIbYg66bf96GKJpr1FtyJJwAu4J7IY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-OgvfQQnbPpe4j-6uKxBuhw-1; Sun, 29 Dec 2024 08:39:06 -0500
X-MC-Unique: OgvfQQnbPpe4j-6uKxBuhw-1
X-Mimecast-MFC-AGG-ID: OgvfQQnbPpe4j-6uKxBuhw
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38a2140a400so5204000f8f.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479544; x=1736084344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nur/MaXbNbep0nGfnpuQnIYAkWa+dhGBZo7ukzuAicY=;
        b=Xxk5q6VRG1JQbXo/RKyvYDfoQJBzTGqDjHycBMxp6JS/OG+gdyXxjVaBLwppN7UatX
         ENVGAtTTFuPVem9gN7YQ/t9NQG3+GQ3VBkSl6tuITeTfQWGKo2dkNFMIv7cECyZKjBXJ
         eV6bfZqjsj7zohtFDSyCrS2bt090f4DIpgGQyfBlUalnsocv+grIwIgxsQ5PEaS8zFUK
         QfbhEo1+fqwX52+Hrojdsb6tEftWOhk1Tl88bc0Vtgg2dmUMBIk3lDxzXybklWUS88uP
         8hjdm/z4K322ggiedH1741Kbh60M93sSPmgIK+BO5rmjVSCymeb2TW57maXp82OVNjqU
         pOrg==
X-Gm-Message-State: AOJu0Ywe6htLwqUjcx6l6AlNr01lpbg40OVn4b66Xr+FY6h98wpiv+Ve
	EE/LQv5ozhhX794uhD5FC4NmG+wE4chw1xYEeH7WOmyY9QvnDWLPT5HuXdehZBU3/5peGtJc2BK
	GC9NwebQuc4TfgE/QIEXAqhVvfn8+/3H98cEuigYOW39GP5NFJkx/6vo7iZ+m5nO5RCZhW/fpgx
	Pa0s7cRUoN57cgNDv5yiJpDlIkLlWQxkBC8wwnnkJd
X-Gm-Gg: ASbGncsB+79Mw+iQ77sch2T2vrPKp/6k1C+ydCf8SQZ6gxnrWaV5xoh6PO12n2sHLWt
	xXxO7ysBYUtn25SxyyjUVUhiv4SB+RkEuSkYYNrqzKs5MD4chAisZdZQSKUy9FKtSVuMfEV/09k
	wJdZZjrg6hLtPe/lv/3cusqPkVP56bftL9ugcLLiUK188NyCIeSN3ESoQ9aO/59u5rpPUTPXqV5
	7j7UQJkWdsB1JnjQyC6kwfmgGxa6hVCA8pZeeu9pQFMmSPUxrRLznKBu1milTgjLEd+0ulFqJX4
	HJztX9asBFFmQ+A=
X-Received: by 2002:a5d:5e09:0:b0:385:f72a:a3b0 with SMTP id ffacd0b85a97d-38a223fd417mr34649027f8f.55.1735479544330;
        Sun, 29 Dec 2024 05:39:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGt2JiTI+52hRdXTVo5j6kOA5o+ypnN61iCqRRoxRIF0zz5icEqvzhm8ZXrPqoWhScTWqZrKw==
X-Received: by 2002:a5d:5e09:0:b0:385:f72a:a3b0 with SMTP id ffacd0b85a97d-38a223fd417mr34649013f8f.55.1735479543968;
        Sun, 29 Dec 2024 05:39:03 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8474c2sm27093127f8f.55.2024.12.29.05.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:03 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 10/14] xfs: introduce XFS_ATTRUPDATE_FLAGS operation
Date: Sun, 29 Dec 2024 14:38:32 +0100
Message-ID: <20241229133836.1194272-11-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133836.1194272-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133836.1194272-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The extended attributes mapped through page cache need a way to
reset XFS_ATTR_INCOMPLETE flag and set data CRC when data IO is
complete. Introduce this new operation which now applies only to
leaf attributes.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       | 19 ++++++++++++++++++-
 fs/xfs/libxfs/xfs_attr.h       |  3 +++
 fs/xfs/libxfs/xfs_log_format.h |  1 +
 fs/xfs/xfs_attr_item.c         |  6 ++++++
 fs/xfs/xfs_attr_item.h         |  1 +
 fs/xfs/xfs_stats.h             |  1 +
 6 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 5060c266f776..55b18ec8bc10 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -855,6 +855,13 @@ xfs_attr_set_iter(
 			attr->xattri_dela_state++;
 		break;
 
+	case XFS_DAS_LEAF_FLAGS_UPDATE:
+		error = xfs_attr3_leaf_setcrc(args);
+		if (error)
+			return error;
+		attr->xattri_dela_state = XFS_DAS_DONE;
+		break;
+
 	case XFS_DAS_LEAF_SET_RMT:
 	case XFS_DAS_NODE_SET_RMT:
 		error = xfs_attr_rmtval_find_space(attr);
@@ -1093,6 +1100,11 @@ xfs_attr_set(
 		tres = M_RES(mp)->tr_attrrm;
 		total = XFS_ATTRRM_SPACE_RES(mp);
 		break;
+	case XFS_ATTRUPDATE_FLAGS:
+		XFS_STATS_INC(mp, xs_attr_flags);
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+		break;
 	}
 
 	/*
@@ -1119,6 +1131,11 @@ xfs_attr_set(
 			break;
 		}
 
+		if (op == XFS_ATTRUPDATE_FLAGS) {
+			xfs_attr_defer_add(args, XFS_ATTR_DEFER_FLAGS);
+			break;
+		}
+
 		/* Pure create fails if the attr already exists */
 		if (op == XFS_ATTRUPDATE_CREATE)
 			goto out_trans_cancel;
@@ -1126,7 +1143,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (op == XFS_ATTRUPDATE_REMOVE)
+		if (op == XFS_ATTRUPDATE_REMOVE || op == XFS_ATTRUPDATE_FLAGS)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0e51d0723f9a..b851e2e4b63c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -448,6 +448,7 @@ enum xfs_delattr_state {
 
 	XFS_DAS_LEAF_ADD,		/* Initial leaf add state */
 	XFS_DAS_LEAF_REMOVE,		/* Initial leaf replace/remove state */
+	XFS_DAS_LEAF_FLAGS_UPDATE,	/* Update leaf XFS_ATTR_* flags and CRC */
 
 	XFS_DAS_NODE_ADD,		/* Initial node add state */
 	XFS_DAS_NODE_REMOVE,		/* Initial node replace/remove state */
@@ -477,6 +478,7 @@ enum xfs_delattr_state {
 	{ XFS_DAS_SF_REMOVE,		"XFS_DAS_SF_REMOVE" }, \
 	{ XFS_DAS_LEAF_ADD,		"XFS_DAS_LEAF_ADD" }, \
 	{ XFS_DAS_LEAF_REMOVE,		"XFS_DAS_LEAF_REMOVE" }, \
+	{ XFS_DAS_LEAF_FLAGS_UPDATE,	"XFS_DAS_LEAF_FLAGS_UPDATE" }, \
 	{ XFS_DAS_NODE_ADD,		"XFS_DAS_NODE_ADD" }, \
 	{ XFS_DAS_NODE_REMOVE,		"XFS_DAS_NODE_REMOVE" }, \
 	{ XFS_DAS_LEAF_SET_RMT,		"XFS_DAS_LEAF_SET_RMT" }, \
@@ -556,6 +558,7 @@ enum xfs_attr_update {
 	XFS_ATTRUPDATE_UPSERT,	/* set value, replace any existing attr */
 	XFS_ATTRUPDATE_CREATE,	/* set value, fail if attr already exists */
 	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
+	XFS_ATTRUPDATE_FLAGS,	/* update attribute flags and metadata */
 };
 
 int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op, bool rsvd);
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 15dec19b6c32..9f1b02a599d2 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1035,6 +1035,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_PPTR_SET	4	/* Set parent pointer */
 #define XFS_ATTRI_OP_FLAGS_PPTR_REMOVE	5	/* Remove parent pointer */
 #define XFS_ATTRI_OP_FLAGS_PPTR_REPLACE	6	/* Replace parent pointer */
+#define XFS_ATTRI_OP_FLAGS_FLAGS_UPDATE	7	/* Update attribute flags */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index f683b7a9323f..f392c95905b5 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -908,6 +908,9 @@ xfs_attr_defer_add(
 		else
 			log_op = XFS_ATTRI_OP_FLAGS_REMOVE;
 		break;
+	case XFS_ATTR_DEFER_FLAGS:
+		log_op = XFS_ATTRI_OP_FLAGS_FLAGS_UPDATE;
+		break;
 	default:
 		ASSERT(0);
 		break;
@@ -931,6 +934,9 @@ xfs_attr_defer_add(
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		new->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
+	case XFS_ATTRI_OP_FLAGS_FLAGS_UPDATE:
+		new->xattri_dela_state = XFS_DAS_LEAF_FLAGS_UPDATE;
+		break;
 	}
 
 	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index e74128cbb722..f6f169631eb7 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -57,6 +57,7 @@ enum xfs_attr_defer_op {
 	XFS_ATTR_DEFER_SET,
 	XFS_ATTR_DEFER_REMOVE,
 	XFS_ATTR_DEFER_REPLACE,
+	XFS_ATTR_DEFER_FLAGS,
 };
 
 void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index a61fb56ed2e6..007c22e2cad2 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -96,6 +96,7 @@ struct __xfsstats {
 	uint32_t		xs_attr_get;
 	uint32_t		xs_attr_set;
 	uint32_t		xs_attr_remove;
+	uint32_t		xs_attr_flags;
 	uint32_t		xs_attr_list;
 	uint32_t		xs_iflush_count;
 	uint32_t		xs_icluster_flushcnt;
-- 
2.47.0

