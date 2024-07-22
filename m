Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F2E1BF54
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 19:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721676342; cv=none; b=tfCMQfEvU0r0XY/dWnnPfZtEeujvi7KzFrULG+SNTwlO7nLYijIKybBDqzC4ksXxNeO+rRhWmJDbNQXBoLZid8yCVKEquW1ClamcPyWd6Pukp/huiRKuX1t+K2IGldBrPW3QIXegQMw+OOMKv0CNHomDJdud/6dN1IoJGgPLPCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721676342; c=relaxed/simple;
	bh=/uU4tELWwrAP28+JXAqg4UC+8xY8di4PvpA/xOUDa6o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=mYtZ43L2wP/dXWorsRiB06Uh7lwHknY5Km4J9YhwjCUf+eP+I43ir8dmRll9Xx3YHoMerekrO2UgCAXbJHKDT5JYFKCy75XM0IWwg01xjW+afRFxPy8Dt0kmjLBQ6IVsF1SjvK7QpNBd7c8gRK/2ViBhY07XJ++gXoQPdgXC9NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TShoOchd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TShoOchd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721676339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBD0gDOLMP1Gxh7jm2U3Yx3HXEG+s6EhX5D8cY81Y9s=;
	b=TShoOchde7ZpBxd2HSAkzzj4HLQcCC0pQfD5udyTYUZ4HFgaKopScQk9aODH8lFguXGejA
	8ZP6MVvodMzqn34pY1LhsaUO8c26XdLr+G+HAvS53fH04uj90Exf+VCyBQ6JEYvehjUcXt
	Yx403Cr6PYcsTlA1aMQXrExUuzgxwEU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-iQntwr-_NI2Ui5UfWiYe1A-1; Mon, 22 Jul 2024 15:25:35 -0400
X-MC-Unique: iQntwr-_NI2Ui5UfWiYe1A-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-802d5953345so738040639f.3
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 12:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721676335; x=1722281135;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBD0gDOLMP1Gxh7jm2U3Yx3HXEG+s6EhX5D8cY81Y9s=;
        b=CAbfbEEyMCEsUaQBk/1myW8RGPPSOG+WlPbNg9c7Y9iXX0su61fYWmjcL/cDx+trDb
         +SGgheagd/m1tBWCigx3jq5vMq2UVGoHXwr48wungPAYcSyqjoJ0OGrsqlGaYdRDYZW8
         Zs6QYyDBQi4xPoNGggu1fQmToWsDye5/rSYZGWkvV4xbsH1DwHeuBXBGrZt8/5UmPeEC
         A8/Guo+WYEfL4Ub0NALjDbp7PWldZVqZCUJJRU1GMwsaQ+05BIKwFAO/np1+thPYpQ35
         IJGK6WgYnNzpTtALmFyVJNpGO9JcUUP29vwQtptz/rUSqqvdEjK4b6vfbnqXKkQnx0o+
         pv1Q==
X-Gm-Message-State: AOJu0Yy4Zj1M4yIQIx+gUZqee0K7vhVaiprDeUTTXzu1EaJfSLhgyIwt
	TDEuD896yGXVKCpBtD9kPTZ/OXChK1ZK+dce0WkUrvfAOLwoKfgHn/i8Wlvij4PPGcU5VIfLRuq
	MoKR8EsFWNe2TUda9rHegyWdyGlt+HIwOl7ZGt+3hAN+C+1kJgWmnP2ceTBasirQyNqYuh7Ikvy
	9XHOsKI4v40LGTr+BWjkMw4Dl45QMozYY6vpQw9fQ0
X-Received: by 2002:a05:6602:154c:b0:805:2e94:f21f with SMTP id ca18e2360f4ac-81aa9510c71mr982564439f.2.1721676334937;
        Mon, 22 Jul 2024 12:25:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7xjoUcP5UwotwRNstbzHF9cIMHQ5ZDJ3vr+ONIj6AqMuVfreJqAxDISBF7fx7lecTTtxIZg==
X-Received: by 2002:a05:6602:154c:b0:805:2e94:f21f with SMTP id ca18e2360f4ac-81aa9510c71mr982562639f.2.1721676334467;
        Mon, 22 Jul 2024 12:25:34 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c2343ab5dasm1759235173.87.2024.07.22.12.25.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 12:25:34 -0700 (PDT)
Message-ID: <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>
Date: Mon, 22 Jul 2024 14:25:33 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH V2] xfs: allow SECURE namespace xattrs to use reserved block
 pool
From: Eric Sandeen <sandeen@redhat.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
Content-Language: en-US
In-Reply-To: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We got a report from the podman folks that selinux relabels that happen
as part of their process were returning ENOSPC when the filesystem is
completely full. This is because xattr changes reserve about 15 blocks
for the worst case, but the common case is for selinux contexts to be
the sole, in-inode xattr and consume no blocks.

We already allow reserved space consumption for XFS_ATTR_ROOT for things
such as ACLs, and selinux / SECURE attributes are not so very different,
so allow them to use the reserved space as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Remove local variable, add comment.

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ab3d22f662f2..09f004af7672 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -110,7 +110,16 @@ xfs_attr_change(
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
 
-	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
+	/*
+	 * Allow xattrs for ACLs (ROOT namespace) and SELinux contexts
+	 * (SECURE namespace) to use the reserved block pool for these
+	 * security-related operations. xattrs typically reside in the inode,
+	 * so in many cases the reserved pool won't actually get consumed,
+	 * but this will help the worst-case transaction reservations to
+	 * succeed.
+	 */
+	return xfs_attr_set(args, op,
+		    args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE));
 }
 
 


