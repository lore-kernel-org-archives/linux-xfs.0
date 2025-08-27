Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6FE27935C;
	Wed, 27 Aug 2025 22:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333125; cv=none; b=dpHrbCl/EYQ/It/fmx+8m2Vsy2+g2faYGiid+F/N26DB4deBU6YYfRtX/mG6C/T6oZmIeOAK5w+HjoF2oNwChL7o8oDsqVF/la3G1Nt43NNiFp1jBePKegPCRgRB8/WZ/0D6ID+CS5HGXbwog1dlU0DSdyWJCX6dJ1NMe0afOBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333125; c=relaxed/simple;
	bh=yKEOzvSZkzMKgqF/7rWC+AeAsHM5EazimO28ln893wg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lMejqmgPcs9oW6KK4k+B03bFR3BXC8cPJuxrZRkmfSmvjIZT0iXUu0+/Sb4YwV1nbNrcqtjZHC+T4gkzovSj89FgvhkaBW5jGjqfvykPbtWzHiYY64pDNXKdStpHlJe7JCbEzHZFPPoRdeBwOMOzE1Y5TJYCTUO1Xdt6Fg2rK48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjQYlzEd; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjQYlzEd"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2445806e03cso3670445ad.1;
        Wed, 27 Aug 2025 15:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756333123; x=1756937923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fnKCQ7KlE8GdkQRPdMNE8B421OcFBFXbPzdlUFE9jn4=;
        b=jjQYlzEd6Rpol6TGm3h4TTaNKsIWabi2Nz6qPJUjTJfWdMkv32ksLd43m94JWtOkAo
         0+BG5D1MUu0UnRj4NNIzPVVxDrHmcRQghAKYkk8W5WcIRJcRGjI1fecqOX2ibj9LIssK
         kAs5LnhLslIRzdeCS6pFYv56DBRe1DfmLF/rEmwwQfKKMWzIfmN+RyFqC1I5nz/GoSk3
         XNdCX0nMc5VkGDvPAQo6x/za1odqti7xMVfggDrNHcMvK3A739qzI+TV/FB6BymjoKL7
         +vCepdvkKmV6tUD3ICNPzSNlHKeNyvLkNsvnWAouvzON7KnU0DStSt3OTHCgi3HzIenm
         EMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756333123; x=1756937923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnKCQ7KlE8GdkQRPdMNE8B421OcFBFXbPzdlUFE9jn4=;
        b=uVQ7aEZt7xTB2KkgLPGvrZCC+p2wD+8BO7mImswxkXTOGDyBr3oL3hbpBavIe52g//
         zqkvgrB7old/EcJuLztGWxFcRoyuOOvZRaXqGNR1us5dt2ze98kuZlyqDlwReR9D9C5x
         P9yyTNfWnLniGBlEuqK5oitSMh88kP/CPTy2SB3q47V1vDJd3vN8sNqgIJeQd1W/XRYZ
         Hm+sY7v+R28PxvSKTlICX07ETnh423bwxf8w8yzP0ukf6fFKx2y441peAdWYbpSgd314
         bjUv4FcQI/2Z9fK1FP9M327xI9hceLYIeX1NoepU2LTmaR3mly0ofVRfMNEkq6VvPH3i
         jTCA==
X-Forwarded-Encrypted: i=1; AJvYcCUfVZ8YBsgpnVfI3R6mv+zZKIP/pt5jNxicOiF4wH1No6gmVfxE8uV5KC8ujUNJB9TzBmxOiSQ7apcS@vger.kernel.org, AJvYcCWzUkEKXJys6DEw1/11mERfDi47NeRE6q6hZSaX7FebbQ5do7c6LMS4O9Nf0VQtZRVNvcOZoPnKS/+tCXw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnWmawQq1fqvwClWuzIWttO2hL9rFywlqEtBGzj6WDTv4pUu7J
	b98LDUysEDq+SsKLroYt0/jUFa9zGnx4+D+MjMIdI4Xec4ApRhUmxZRa
X-Gm-Gg: ASbGncuGkuuJyao2qh68wEWoXXnHhE1YNHah3YsjXhnZB3GX55PbQ9Mh34RD13h0PsE
	y4vuiaCq2vNq2IzzOn7qb6wobjKH0JEP0dZiX4v2dyyDMgF+uarEd0ruMyX6IJeCBVsu7ixAFxz
	BwKg1uSZly/LK/3IxY4JBv8ViBj7Tps+anMnOyxFKq6EN3DgQQYPyZibhVbcE1vEQsPvHMnZIsm
	itLN9DtdKlmUNrhLJ19FYp9/g73SoTo6kZ8cqevM+Ngc99n+U/zoRRRIicNq4L0Ya95psXnV+WZ
	UjVdb+JifstoSVJ+kpbVM45uKIYXIzhDMQXT209Z3WPwlTgPej4Cll3Q85lrLddtxUoKEwkWeDw
	9J/mBYf9uMQxbXhRmGCM=
X-Google-Smtp-Source: AGHT+IHGV6KTJjO6YOxBOSnA3bu2gMF+DC1x7BOk7w/9r1S8JPMjnHhC+6uDDjwViwSp+DqWZK5QRg==
X-Received: by 2002:a17:903:288:b0:248:9677:5f33 with SMTP id d9443c01a7336-248967763b3mr56989255ad.3.1756333123181;
        Wed, 27 Aug 2025 15:18:43 -0700 (PDT)
Received: from fedora ([2804:14c:64:af90::1001])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466877b67bsm130771905ad.4.2025.08.27.15.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 15:18:42 -0700 (PDT)
From: Marcelo Moreira <marcelomoreira1905@gmail.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v3] xfs: Replace strncpy with memcpy
Date: Wed, 27 Aug 2025 19:17:07 -0300
Message-ID: <20250827221830.23032-1-marcelomoreira1905@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The changes modernizes the code by aligning it with current kernel best
practices. It improves code clarity and consistency, as strncpy is deprecated
as explained in Documentation/process/deprecated.rst. This change does
not alter the functionality or introduce any behavioral changes.

Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Marcelo Moreira <marcelomoreira1905@gmail.com>
---
Changes since v2:
- Fixing some errors in the commit message.
Link to v2: https://lore.kernel.org/linux-kernel-mentees/CAPZ3m_iNj2zwpAovv3BTz8gNp5XzdxSRHBFonM9sJvaSjYVBeg@mail.gmail.com/T/#t

 fs/xfs/scrub/symlink_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 953ce7be78dc..5902398185a8 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -185,7 +185,7 @@ xrep_symlink_salvage_inline(
 		return 0;
 
 	nr = min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
-	strncpy(target_buf, ifp->if_data, nr);
+	memcpy(target_buf, ifp->if_data, nr);
 	return nr;
 }
 
-- 
2.50.1

