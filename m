Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4B02F0C48
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764945214; cv=none; b=bivf5D6HkoYMoCXfxIitGrgj/w1bX+RdZxjxsLTY555blo4M2xJepjxYq94504pC3CwHVx5VDxqaiLWiRdpOgW+Eak+rHFw7DkhUS+nqVGXgioM0/dVaTYRMRLdxVIWyRTU7xVWr+6fHbVeya9GKa1D9vAY4/6Qir6pP08O8rXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764945214; c=relaxed/simple;
	bh=cBX2Dfe8+w0KhWNzJXHFLGerpFC0sx5Ws8pQaHRsu7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dn0HvuYp7Qcihhz/2iL9ZAEErAjlP7UCCsNSEAl7NEpsHRM4JGIj1yIcqEZ5jUx8dNjEMxwlHv4HbYxD3Mld57OFPbf63/Dc9ETZZxmH6QV+HLAM6H8FN0wQFGP/gJQqN57aK09Jbue0YjTg41yi4uY9mWrmhCPb83HvwCqTp+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GidbRiyW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oyCEAtvs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GidbRiyW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oyCEAtvs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764945207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=46sfcgBm/v2MHE7c+9yQUdlqktAkzr+1+1VVFVNVbyM=;
	b=GidbRiyWcz5Rc58H12Qevn7HVSiJRtxGzIl02qpYWSf4OqliIxHtXNzTcbDcj5f84q2icu
	v52GXcew1ih7BBTYYjzS6azeLHbqZoyzi7wMYYvAocgiwtg2ndCuEOnY4TVpQuN/ok9P/L
	hqBBkUoIQy4nGIP9xliWBUbpaievtvk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-BKWRaiQqMLy0xvzM1OC_ng-1; Fri, 05 Dec 2025 09:33:26 -0500
X-MC-Unique: BKWRaiQqMLy0xvzM1OC_ng-1
X-Mimecast-MFC-AGG-ID: BKWRaiQqMLy0xvzM1OC_ng_1764945205
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42e2e2389aeso1183348f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 06:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764945205; x=1765550005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=46sfcgBm/v2MHE7c+9yQUdlqktAkzr+1+1VVFVNVbyM=;
        b=oyCEAtvsJayw+SPI87wm0qXsQ+vzxoVO1UN1fyv+pOAvWJUUH/LHTOHHvrcN0XG+AU
         GHrY0LqteB/WWhTWOL1ar9O0H5g96AbfHbXAzzvNrTzMoPUMV1QkR392Z6MQLAEDUXmx
         iYTz6gmM4If2+x/Jms6XjywlOqBw7rfNins/bpBWHB9PlNIt8YB6hh0a1V83BMe93DSC
         XALLgnpcyLJuNmClwBz5zNGWznS5LLFVDu+O34xInBoe7gY6ad8NU/m472xxsM+bHqi7
         v+H6C/PL0BCrbvYM0CQjxxWd+0tuvLAyj6kKiC7AqG91rRKfBJ+9kMw1B2EJZ2n/D1BT
         o7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764945205; x=1765550005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46sfcgBm/v2MHE7c+9yQUdlqktAkzr+1+1VVFVNVbyM=;
        b=daTjxQPLG8Pq5bvpdNu3I/DKnuA+gd9xXD7ucMXl5js3Mv9MKMf5EWIkbz//9k0JwD
         ZsW00PeuC0I4ajt6+T7IbbzB2hA0N1x8R2/O1lnf+GKwA0ra5W1R/Qx4Lz8RAcSQOSUu
         TlZ4EvlFt4sZSB5K4eNZP3tSz5qG9P2eIhqtTJU8LtxePh6APAB6EMvVhGuVxrGR7Luh
         lC/yxXDKFIRXoVZyh9Z+9TcApk8BnKgXWAUjPyoKRDIvxlJtbKxB/rEgsir36L70Zj0I
         5MTtCdAsdrGTAAKrdOcVcpJFLT1aM4X1pPKjmJXwFMHSBYhG+4ANbxatuOXI/FpXkocR
         uXWQ==
X-Gm-Message-State: AOJu0YwGN6DDp8Q84qWo/skia7PNSTTB/YurSo1MeBFK9j8BTN727L0k
	QOeA6ANU5VOTZEqd1DkCcwz27tAWozHqR+Q3QKFO+er+FD43qFDKGWmwcFbZ6fPEilwsis3fxKd
	wlqcGJ/SvEdFIVJgQj0tVbE8hUbZ9DOyafRr6EHiXM3T8ypRiwSRiWMv/qPHB/b/IW83J6Hkczo
	7C9yxQl7br/L3gFxQrOsq9viqTiPlF0m1yMZGFkXevWJLf
X-Gm-Gg: ASbGncug4YPL8tyqFll5M4l80G3YWCqOo/nnUYU8JfC7GtqBGnT18/hGo+aOOx3+MhZ
	ilLNVWsZUmRR8CsUhinZRoXnbjUg5KJzsBI2tBUql3NoiNsxGDAMDIHEr50KRGqgMa8nC8qpDhV
	rAOqVd0tetYVrW1xV7hBBbbuRSD5Kjetspbf1seIqkV5EBXVRiRFElz3MmtEmkKF90FmKWd+u7k
	hAcvGwXxox0HPybmz55WEXDnzNWmwXvtweDRFxY/rF1Jvaz5cakqbNcrx36qrHKDnPohsEiOwOt
	O+yqpobsp5EdQYIyIRGDYdX+eWpgTNnix98QDffGFpT66pczYNVWjbZKIIOwqISuTeml/gXOVM5
	nTbmmcFpotpCCjT5Cx9VkMcs=
X-Received: by 2002:a5d:5d87:0:b0:42b:2b07:8630 with SMTP id ffacd0b85a97d-42f731a5541mr10913559f8f.31.1764945204657;
        Fri, 05 Dec 2025 06:33:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1m+Wfi1YCJ7yMF6ZTRvIaIHLzPZjg1tnU5ADHU5sDDUm11aiEGIn/N/QBPZ4yIrR2AdDUng==
X-Received: by 2002:a5d:5d87:0:b0:42b:2b07:8630 with SMTP id ffacd0b85a97d-42f731a5541mr10913509f8f.31.1764945203901;
        Fri, 05 Dec 2025 06:33:23 -0800 (PST)
Received: from thinky.door.alberand.com ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe8a7bsm9078733f8f.4.2025.12.05.06.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 06:33:23 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] libfrog: fix incorrect FS_IOC_FSSETXATTR argument to ioctl()
Date: Fri,  5 Dec 2025 15:31:48 +0100
Message-ID: <20251205143154.366055-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arkadiusz Miśkiewicz <arekm@maven.pl>

xfsprogs 6.17.0 has broken project quota due to incorrect argument
passed to FS_IOC_FSSETXATTR ioctl(). Instead of passing struct fsxattr,
struct file_attr was passed.

# LC_ALL=C /usr/sbin/xfs_quota -x -c "project -s -p /home/xxx 389701" /home
Setting up project 389701 (path /home/xxx)...
xfs_quota: cannot set project on /home/xxx: Invalid argument
Processed 1 (/etc/projects and cmdline) paths for project 389701 with
recursion depth infinite (-1).

ioctl(5, FS_IOC_FSSETXATTR, {fsx_xflags=FS_XFLAG_PROJINHERIT|FS_XFLAG_HASATTR, fsx_extsize=0, fsx_projid=0, fsx_cowextsize=389701}) = -1 EINVAL (Invalid argument)

There seems to be a double mistake which hides the original ioctl()
argument bug on old kernel with xfsprogs built against it. The size of
fa_xflags was also wrong in xfsprogs's linux.h header. This way when
xfsprogs is compiled on newer kernel but used with older kernel this bug
uncovers.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 include/linux.h     | 2 +-
 libfrog/file_attr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index cea468d2b9..3ea9016272 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -214,7 +214,7 @@
  * fsxattr
  */
 struct file_attr {
-	__u32	fa_xflags;
+	__u64	fa_xflags;
 	__u32	fa_extsize;
 	__u32	fa_nextents;
 	__u32	fa_projid;
diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
index c2cbcb4e14..6801c54588 100644
--- a/libfrog/file_attr.c
+++ b/libfrog/file_attr.c
@@ -114,7 +114,7 @@
 
 	file_attr_to_fsxattr(fa, &fsxa);
 
-	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
+	error = ioctl(fd, FS_IOC_FSSETXATTR, &fsxa);
 	close(fd);
 
 	return error;

