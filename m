Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A035C1553B1
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721746789; cv=none; b=Rai2k7TrMuF5vzeKPrjJORpHQ3jH/ya0OFQuj+VaI9dW+k7WMgWlHPKwSXkQKI1AsJAY4tg9SirVfYPR2rWGVUe1VgGUqXbqREhOtU/CsoGxiqNqLzMKBaXvX8gl6g7/ezOqqYIW6npo14tSAqwj7zniC2Xzv4yA3ZTFmztMQJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721746789; c=relaxed/simple;
	bh=eZa2Le/w1qo3SAWxEjd42sA7+Wm+uTC1QNJjJ81vDBE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ua7bJqmNMOk6TZ1MobbzVEwYUyAjmySrKdOkS0hiK9Pj0l9xGxs3kb/TlpiRXkXaxn8A9lQF+mzN5CwuWQ+aCMNL8O4YDlfw3Imi7lAIEI/YQ3SMRpjgb/lyXfODbAaV9Px0pUwphYvPjxj3y/lwchNAAlRtq9DzxGMGKda7D9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S4TRFo6u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S4TRFo6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721746785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrDzAcgJTQnKr2jMM834bfCktRQZL46T+ocLVaIu260=;
	b=S4TRFo6u/JyE2DyJQcsmk8qFwSTvUhlmdq64biBwxvwUod8C10vy+ajyUTFXwiOUkLCkXY
	tP/4tVsgs6RC5Kr/jdeQmodHKcONpsI5MBV5/FU5p9vyu2E2y5HA5noU6k54z/awGPlsYq
	cMGS7c6C5oX8oyhRkQLRW6db+iuHvoc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-DZUe48maPH6IuRAgvgw9Pg-1; Tue, 23 Jul 2024 10:59:43 -0400
X-MC-Unique: DZUe48maPH6IuRAgvgw9Pg-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81257dec573so907338739f.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 07:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721746783; x=1722351583;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XrDzAcgJTQnKr2jMM834bfCktRQZL46T+ocLVaIu260=;
        b=Al7F70365m/456R6t4+yPzVAvkY4M0v/PcuXqeUxOL3+X1W6sTYlVpF2Nl4d6pg4Lw
         g+F4RIXx0H1mWhF5B8AYeEfCtJULoAVHxqRRXaHNuc7gPasf2h5urZjCCA2f/do0/u/Q
         QecPAWaXh6AIsYbWg8119bfTctxEiicj2URLDUCPqVcabpPl5vpLXy6y9S7DLMYVujph
         NIy+CJNtXY3VP6Gu6rdyNscBHksTQkSm0+duytKISM/ip3LmwJ84hrNicD5tyBVRqeM6
         37Ds99ZF1jatt8UecaZirtsth5yb3eH+kNRF8SXBIAB0RBx4dpqzHlWDWosaOId/uyfD
         o76A==
X-Gm-Message-State: AOJu0YwK9p9w1eO9WlCLGTM9TRDnjXUGVGNJ/smn1D1mW0oMs++ATywH
	YFTu27ZUMQrJmEkwJByHHg4D9anzhlJG41LJsXNQs8gHOenUvYkdt77tKQdd0JMCRNBTGiL6KNZ
	3Xu0ji8J0q1ih98DypsbbuLs1BjEC3aAz9VoBLI/OBO1P+cgSP7yLDqX1JeiatC7UrYpo/JYRVe
	OY/rBK88g0vegpMyA1P74bD89d1s/hWERUh8rMK5GF
X-Received: by 2002:a05:6602:1589:b0:7f9:c953:c754 with SMTP id ca18e2360f4ac-81b33917e16mr1409757239f.3.1721746782842;
        Tue, 23 Jul 2024 07:59:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRKZuugr+KEjufqtRUo+S18Z/JMwOOPZtFiOge9l3CJXsb9dhNi0CA7duBtxzwRhQVw4xOvA==
X-Received: by 2002:a05:6602:1589:b0:7f9:c953:c754 with SMTP id ca18e2360f4ac-81b33917e16mr1409753239f.3.1721746782410;
        Tue, 23 Jul 2024 07:59:42 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c239105e04sm2004953173.40.2024.07.23.07.59.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 07:59:42 -0700 (PDT)
Message-ID: <7ecf75c9-4727-4cde-ba5a-0736ea4128e9@redhat.com>
Date: Tue, 23 Jul 2024 09:59:41 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH V3] xfs: allow SECURE namespace xattrs to use reserved block
 pool
From: Eric Sandeen <sandeen@redhat.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>
Content-Language: en-US
In-Reply-To: <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We got a report from the podman folks that selinux relabels that happen
as part of their process were returning ENOSPC when the filesystem is
completely full. This is because xattr changes reserve about 15 blocks
for the worst case, but the common case is for selinux contexts to be
the sole, in-inode xattr and consume no blocks.

We already allow reserved space consumption for XFS_ATTR_ROOT for things
such as ACLs, and SECURE namespace attributes are not so very different,
so allow them to use the reserved space as well.

Code-comment-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Remove local variable, add comment.
V3: Add Dave's preferred comment

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ab3d22f662f2..85e7be094943 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -110,7 +110,26 @@ xfs_attr_change(
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
 
-	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
+	/*
+	 * Some xattrs must be resistent to allocation failure at
+	 * ENOSPC. e.g. creating an inode with ACLs or security
+	 * attributes requires the allocation of the xattr holding
+	 * that information to succeed. Hence we allow xattrs in the
+	 * VFS TRUSTED, SYSTEM, POSIX_ACL and SECURITY (LSM xattr)
+	 * namespaces to dip into the reserve block pool to allow
+	 * manipulation of these xattrs when at ENOSPC. These VFS
+	 * xattr namespaces translate to the XFS_ATTR_ROOT and
+	 * XFS_ATTR_SECURE on-disk namespaces.
+	 *
+	 * For most of these cases, these special xattrs will fit in
+	 * the inode itself and so consume no extra space or only
+	 * require temporary extra space while an overwrite is being
+	 * made. Hence the use of the reserved pool is largely to
+	 * avoid the worst case reservation from preventing the
+	 * xattr from being created at ENOSPC.
+	 */
+	return xfs_attr_set(args, op,
+			args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE));
 }
 
 


