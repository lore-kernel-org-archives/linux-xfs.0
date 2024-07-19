Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FD982D69
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 22:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721429340; cv=none; b=B2aX84RLghEm5Ux2AdCdMA0vp8zisqpXv2fuNf81wknW7lby1sr+Ikf9DgG2kPI0pcM7ZCTjpjFuFfMeyVvt/t1upLIoDjPuQvRQS6LPrFv8Fgf/RkESHDsrWUFjuBpsO4nboIEA2/bjp2TUtLOxMsDcMVUdX5s7SxuRbiyHmQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721429340; c=relaxed/simple;
	bh=EIUir4wQ1jDSm8IPIB4LF8aAnoqcHityx5kbX2idjjE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=bH24m8Nu6LR9sAqksA/95rr/ELWbaMshyyrIEffJFCuzkTqI8hA4PlTsEQ9ByzpM7z9XuPXdibasLFAXhVR3eRd2x4VqjnpXpwj/kmnF50XdU2gJYxh033GEbrHjZ5bysYkPyoTfn0xOFoiM7bO719IikGZFAfQScvExOtzCSYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gVY0YZZa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gVY0YZZa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721429337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w0S5e4sGInP7z6MpD0Yn2mZL23eIBOSAJlPdbBQ+hKQ=;
	b=gVY0YZZakZVZcMh/BPVTL96lvS4flRyDjcC7FifrTCgIen/TGsKSYDpMuQEAHSjrmkEgok
	QR0nOREORaJBCnhr/BBMwKt2+wmYDn7yOlw98bMhXCALSpN8PWkPb138C8ge/zmUyBsTq+
	l8qM2WZvz/zCV+/Y6eej+30fMEehNGU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-ZJiGmBqVOZOpD_lzA_zZMQ-1; Fri, 19 Jul 2024 18:48:55 -0400
X-MC-Unique: ZJiGmBqVOZOpD_lzA_zZMQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81ad0e64ff4so43261439f.2
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jul 2024 15:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721429334; x=1722034134;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w0S5e4sGInP7z6MpD0Yn2mZL23eIBOSAJlPdbBQ+hKQ=;
        b=O+lUWCaRHSF4h27PfJCFOwdgnIkJ933FWrqKwH7ESmI+Jbicpd6s7ijdI6A7oaGcr6
         AoGYL161m6aGmRxnw4AzQDEXfpdQxPY15MSQM0ES1QuZHO/SkJVNxktIwVhU1L4hQx4c
         o+gIT3pNmoDPpR8LuD5+PnTI+lQ+amYYEjHsrLGfbEkCmVP07eeN8EPQsO8cCTdwFUjr
         cvhGWE+zYcykU7/gT8JiSUGh/P7b9JH9PUku75eyvgty32e0wWd6ZJ7C0HHJjWiW7P1J
         Ou0rH2t/MbqqU3SLEB63+vrH5bmTd0o32FTp3RGuVNvrUODMsbYYrY9IMIg8ABdGekyv
         AFtg==
X-Gm-Message-State: AOJu0YxlChW/HJIWvd6HCcN38jgpa3tXKOCtKgZ3ZXUge/c9dPaL6YdN
	gF7ec3t6kpIoenBO+mq4pjVc/16wQAGlcH+9B3TrwoXbnRbvAzrIcjyMEL9tuM8YOdCVwegp6d3
	oK+r1L5UJavWAOjuh+MNX/IjqDHaO1LV3TkV79ded764HuTg3SrX5ATxxPb6EMJIVNjjAM+j61z
	wJY6nWB+WI1NvPcEkvoLNWR5yozm9MYcYSPQhD2SKX
X-Received: by 2002:a05:6602:154c:b0:804:c529:8601 with SMTP id ca18e2360f4ac-81aa5483347mr178664939f.3.1721429334495;
        Fri, 19 Jul 2024 15:48:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZLkqNlf9kvU+HzGjGj1r168WoV+R6bj9fETzba+qHxXikazPCmNNw6ANH7DRPO25nkfH2wA==
X-Received: by 2002:a05:6602:154c:b0:804:c529:8601 with SMTP id ca18e2360f4ac-81aa5483347mr178662539f.3.1721429334057;
        Fri, 19 Jul 2024 15:48:54 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c234405c70sm510808173.167.2024.07.19.15.48.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 15:48:53 -0700 (PDT)
Message-ID: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
Date: Fri, 19 Jul 2024 17:48:53 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: allow SECURE namespace xattrs to use reserved pool
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

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ab3d22f662f2..e59193609003 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -82,6 +82,7 @@ xfs_attr_change(
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	int			error;
+	bool			rsvd;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -110,7 +111,8 @@ xfs_attr_change(
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
 
-	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
+	rsvd = args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE);
+	return xfs_attr_set(args, op, rsvd);
 }
 
 

