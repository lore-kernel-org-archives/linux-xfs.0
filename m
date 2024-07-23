Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE4815749C
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721755577; cv=none; b=ZI8N+uBpaXQGzJ/AXg2TMrhm15o7YN6oFunHQJ98f3o/m+iL+VXFN7EJMpIShBR2w8ywiw/uDAQ5vY004hKXU94lFcyG4mYMKSXYYYTdxWFc/xT3gv4Fq9C88lUJWbIq/meOLy7qM4Cfk66nWI5s572eLx0vRf8oFiH50+VXqGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721755577; c=relaxed/simple;
	bh=BMRBnPdSq8GOejJ2X4Uihui18BLSEVmZIv6u7MEWW1o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=owOxA5JiUXP42yoai0qAINWRfkRUjrVM2KCFkfEvEmrVMsYr4sqJw8TgkYmdxitSEyKegFSOQ3TD886p40v8DkzsOSvOak+RXTuqw5AgHZkIzRm6C7im20hmTQrKwOwnDTISJE900semFQM/h+GVxQGSRNll5/+ty8h4TpbDM7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVzGT82+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVzGT82+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721755574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjrussu1VgOd8VN9W732A16wO3zU8frgLAsVfkbyQXg=;
	b=IVzGT82+o6XtsmLuNP0R73z3klC7tjDyUYCN8CTSqOWTgmKaaPYoHJP6sy+yUTN/BMgT9K
	SGz0aHD6+f1KiK9iPFDwMye5XGto+DV78htoEyqqbuaXsVW4hQuhOtTFxgFwW3Ey/18vFz
	cJHZi+N1qUpGVnrxGaeKwMO34XT/pEg=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-FCuYquBkMCaflB46P2YPZw-1; Tue, 23 Jul 2024 13:26:12 -0400
X-MC-Unique: FCuYquBkMCaflB46P2YPZw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7fba8d323f9so961555839f.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 10:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721755572; x=1722360372;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kjrussu1VgOd8VN9W732A16wO3zU8frgLAsVfkbyQXg=;
        b=thi7Fe7UwLJ9WvXO9iDLRAl6q/Js+0nVcJMpnd+327rUcKg8s+GiCR8fpyFsHCeDYC
         TL5JITnddNVRx+RI9N1Q2EJYtBb/uXDBr93bT0O4f7wedHBjZKCP4EamM3bIGSk8zqX8
         2b/fMEbZF/SZ441IxBRSCsJ/Yy9Ky2RYSw3Rf87RDmz4zegaU/viTAsvKx5fZ5r1n0MD
         CJrWEk0oR5nTLsP9zCHB3FpvT5DTdi7MiP7tgBPEwlAJMbAUzafpYiM5lpZ6x/jItVAY
         gcfhXG1UfSAjoOLkE58o64k4q9F517MbWF6FnCt7LNyJb42scXLjnuJdPliFqHsdyoQc
         qNLg==
X-Gm-Message-State: AOJu0YwHrLnHHIGTf4Ye6i5oI4j9eHCDjOLpeEODEQ4+qaOD6eK3k3ET
	5lw9N6WvRuiiasVLei6Dah03BO5+F/uabvVEOD7XxVJgWfuWDVPwzj0EAb+Do7yDjdSghW6TFAb
	iD/7CYImh2Pc3DtjYzo1mCvoXVmWGxMF4GRYGcz9LC7Y9xTCaKrXBzQJ0oKPZyVO6ThjnEBxpTT
	Ut3ZSWrk0hzu1DG4PRNFYIfdrUFwzseQc7Sdotp0E5
X-Received: by 2002:a05:6602:6d16:b0:7fa:b6c1:c35a with SMTP id ca18e2360f4ac-81f6d2004admr39525639f.12.1721755571922;
        Tue, 23 Jul 2024 10:26:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/fr4RFl6ScBz7/SLhKOZOIvPCkl5OUqMfhy0H5CaJbr4kx729b15bnUAEZdUxY9bqJY402w==
X-Received: by 2002:a05:6602:6d16:b0:7fa:b6c1:c35a with SMTP id ca18e2360f4ac-81f6d2004admr39523239f.12.1721755571510;
        Tue, 23 Jul 2024 10:26:11 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c2342bf580sm2180089173.32.2024.07.23.10.26.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 10:26:11 -0700 (PDT)
Message-ID: <78735bed-d2d1-4976-be9a-f1d55f9bfe94@redhat.com>
Date: Tue, 23 Jul 2024 12:26:10 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH V4] xfs: allow SECURE namespace xattrs to use reserved block
 pool
From: Eric Sandeen <sandeen@redhat.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <7c666cfc-0478-42d0-b179-575ace474db0@redhat.com>
 <7ecf75c9-4727-4cde-ba5a-0736ea4128e9@redhat.com>
Content-Language: en-US
In-Reply-To: <7ecf75c9-4727-4cde-ba5a-0736ea4128e9@redhat.com>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---

V2: Remove local variable, add comment.
V3: Add Dave's preferred comment
V4: Spelling and comment beautification

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ab3d22f662f2..eaf849260bd6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -110,7 +110,24 @@ xfs_attr_change(
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
 
-	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
+	/*
+	 * Some xattrs must be resistant to allocation failure at ENOSPC, e.g.
+	 * creating an inode with ACLs or security attributes requires the
+	 * allocation of the xattr holding that information to succeed. Hence
+	 * we allow xattrs in the VFS TRUSTED, SYSTEM, POSIX_ACL and SECURITY
+	 * (LSM xattr) namespaces to dip into the reserve block pool to allow
+	 * manipulation of these xattrs when at ENOSPC. These VFS xattr
+	 * namespaces translate to the XFS_ATTR_ROOT and XFS_ATTR_SECURE on-disk
+	 * namespaces.
+	 *
+	 * For most of these cases, these special xattrs will fit in the inode
+	 * itself and so consume no extra space or only require temporary extra
+	 * space while an overwrite is being made. Hence the use of the reserved
+	 * pool is largely to avoid the worst case reservation from preventing
+	 * the xattr from being created at ENOSPC.
+	 */
+	return xfs_attr_set(args, op,
+			args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE));
 }
 
 


