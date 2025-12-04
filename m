Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B82529AB15
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764876520; cv=none; b=WSna4wltly5eHle9XRAWU3/mTIUN7jtlRbIriEVq2h9z/PrVR+PnPqgPYQARvuFo91CCWruVFZ2xTpmpqNyz0lal+3pI9plzQOUgmHQoz0I9cWB5rf8wX56nfL56yQBl+xMpXXLj6T4iTV0Jbsq3d83pHN/JepFVP4HkmEOwAss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764876520; c=relaxed/simple;
	bh=R22YUcDFZoXPeD7EApi1QWj1tDN/AegsUCKViP9G1CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8/CG+3GZpKxdXCX1iGU2gtW1TdZSdXtBIPpRECK1PiGkXE6PF3soWgNMt6PV07vhhxH9Pa8vBo/dtTIFczg1BsnXBna45Sn943wJIDLeYtzt6qIuO9WtkxBQnp+HZxDmQR/Auz0QQhDevjNytSgzZmRGe244MY6gL714sGuu1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maven.pl; spf=pass smtp.mailfrom=maven.pl; dkim=pass (1024-bit key) header.d=maven.pl header.i=@maven.pl header.b=WwItR7a5; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maven.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maven.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=maven.pl header.i=@maven.pl header.b="WwItR7a5"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so2237321a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 11:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maven.pl; s=maven; t=1764876513; x=1765481313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bhiEW+cZ7ZgI2deyoJZQCbhPxyXEhbX9iN5VUkOFxT0=;
        b=WwItR7a5NHBWQh8y2pPI1b0l+wHtKLmeKXVoFSjQvX3lRdoZDiB3xaLKN55WLflbrO
         M6D1uCE6OufoCvgMT2uEMtQvNGgocuKlYHVikB/OH1YS2RJkge++Pd1VPDzQUU2t/pDS
         8fGn8tCSj+NNVJhQPpfcmviKVg3mDNeYHJuyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876513; x=1765481313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bhiEW+cZ7ZgI2deyoJZQCbhPxyXEhbX9iN5VUkOFxT0=;
        b=Z0aUKp6FXDGuVwCVKGLnW2sCfLH8vC41rxQRu73b52MEuDwbnEYa4XCxeXuULFw9BX
         OCLIpoyvWkW8ry7ATchq5B3vP31ANzRxVH/oLO16VVWpB8fLWcYwkU7GgQMP9iCRK8Aq
         QnW7RNtJXAgaFHk/Q93VsyOzVpdc+yUn35JZ9u1ra0oDtccQLiVBsvkQR9HGpFdlWtdM
         2DUCefBiag00ZDYDu3ZS5QObTbPj2SOwUisj+WCeQBkEXn+sBeKNuTIwbDGN0QRJz5G3
         k5PhxNclC3eixWYHkvKktCmWHlMQW5SEh/xBmh52yB/zxPK+S/yp58yqE2PC1W1NzhpG
         Yhwg==
X-Gm-Message-State: AOJu0YyXnnLdR1Bqo+XYQGjK/TCwMvRSD/4dD+5IWx8rynDLoInzhZVE
	wEawuyR/u4h+3Z4bEBRNdhconyYsnPytrLxoPxgj9Uh1KMbth1CGjf0xebsLrhvp87XZJYlIPGJ
	eVH+TsxY=
X-Gm-Gg: ASbGnctFn23bil4r8qY9Yo6s9q5XKSCkoLwq4ltk+jdZXpB2ETJetghbE0hCH5dteKa
	YeK+uzxwuOdZkDk9Nkjg5VpS23N0prwaO8CwhPZswow3bHRkPtUV3xofe0OrRro7lR0S8GhiUbJ
	mbLU1BzOSGUQnMCwO4nZ9gGu2fj1FHAlUhd0z0rQ+Et445gW3MCGjMfUP82Zdp6RzhVlj0uSqvI
	MUnWGaSv1JPclmdxWBL2Psr7JLMlLjzZ2mCp+IbVIhKjo3UHcwN9Yk+g1SA1CRuge98ySRWL/T+
	HOR63AQPaXkUMiQcMNf2A05XVf/g/QBXGqUqdUwSLVBjwiuGarRSn/eEAEDRVScMOYabWTRUObx
	eQLMaFVw8NSKZwi+v7mmT5+kM1Jjkv4GBOSYtfwAVGr8dY/nV6vxBTsfHz5LcuONO+NqgEu/G8U
	Srp7bG/ODXKF15lo1zUMWIBJ9hlkHpi4MK
X-Google-Smtp-Source: AGHT+IEkvXc2AFdA/XRSovCIc2pVWqLWl8ksCmvYwgaiaOaDITQvUVhSA4ydt+IztsVVKWloLPtaDw==
X-Received: by 2002:a05:6402:518b:b0:641:66cc:9d91 with SMTP id 4fb4d7f45d1cf-6479c519e8bmr6080956a12.27.1764876513382;
        Thu, 04 Dec 2025 11:28:33 -0800 (PST)
Received: from ixion.pld-linux.org (ixion.pld-linux.org. [193.239.45.161])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-647b412deddsm1943130a12.31.2025.12.04.11.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:28:32 -0800 (PST)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
To: linux-xfs@vger.kernel.org
Cc: arekm@maven.pl
Subject: [PATCH] libfrog: pass correct structure to FS_IOC_FSSETXATTR
Date: Thu,  4 Dec 2025 20:28:27 +0100
Message-ID: <20251204192827.2371839-1-arekm@maven.pl>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aS_XwUDcaQsNl6Iu@infradead.org>
References: <aS_XwUDcaQsNl6Iu@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 56af42ac ("libfrog: add wrappers for file_getattr/file_setattr syscalls")
introduced the xfrog_file_setattr() framework, which was then wired up for
xfs_quota in 961e42e0.

However, the wrong structure is passed to FS_IOC_FSSETXATTR, which breaks the
xfs_quota "project" subcommand:

    # LC_ALL=C /usr/sbin/xfs_quota -x -c 'project -s -p /home/xxx 389701' /home
    Setting up project 389701 (path /home/xxx)...
    xfs_quota: cannot set project on /home/xxx: Invalid argument
    Processed 1 (/etc/projects and cmdline) paths for project 389701 with recursion depth infinite (-1).

strace:
    ioctl(5, FS_IOC_FSSETXATTR,
          {fsx_xflags=FS_XFLAG_PROJINHERIT|FS_XFLAG_HASATTR,
           fsx_extsize=0, fsx_projid=0, fsx_cowextsize=389701}) = -1 EINVAL (Invalid argument)

Fix the call to pass the correct structure so that the project ID is set
properly.

Fixes: 56af42ac ("libfrog: add wrappers for file_getattr/file_setattr syscalls")
Signed-off-by: Arkadiusz Miśkiewicz <arekm@maven.pl>
---
 libfrog/file_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


Note: the tests need to be updated, as they didn’t catch this problem.

diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
index c2cbcb4e..6801c545 100644
--- a/libfrog/file_attr.c
+++ b/libfrog/file_attr.c
@@ -114,7 +114,7 @@ xfrog_file_setattr(
 
 	file_attr_to_fsxattr(fa, &fsxa);
 
-	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
+	error = ioctl(fd, FS_IOC_FSSETXATTR, &fsxa);
 	close(fd);
 
 	return error;
-- 
2.52.0

