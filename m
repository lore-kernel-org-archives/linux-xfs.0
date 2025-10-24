Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C62C026F
	for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761334689; cv=none; b=pHPI/HJ+kDE7YHDOw5L3oatuZ3Hk1ayI51meQzrY6GLq4cNtKqKHylACMl/DNBEvkKLY0bg4h4btk9+muyuceaIiSy3bmiNjTuOOA4opNo8664xhWmq7P630w2ukTn6J5Y9u7+aGZSGX8uuJ0rjszBv1PND6hiQBz0rRJcl1npA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761334689; c=relaxed/simple;
	bh=hnIBfkJedIaTuYw4+J2vwi6I3kHnSnRp5BhkxTZSCtY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E08QQ0VBnDSpPTOviBDuO00xvw+Bt9Ca6FgPJWyzyS0/IwRpCReNZeBAc8yyLCtvd1uPhU260XdkVKCNrXQAiKI/MQkCW/FTpWfbo2ddPN+k9fJYL2xcQehurH5wj3EgUlZPkELmA7N3zF3It0k9fnoR8GtPX3vGXxWcQ8voB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fvgSVcUj; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fvgSVcUj"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4270a0127e1so1807837f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 24 Oct 2025 12:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761334683; x=1761939483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tErkCkurvvEvRmrrCuEfmIwe8cZhw5krvFH49Q3590Q=;
        b=fvgSVcUjuqQwIa5hYMI7T735aBAAi1TTYyWgIJOqV5t3GyZ6naj2WK5vIWeQvlQBz4
         XCxYYlJGcgW8YvMG0I/kedpRZFYhOPPlxXdTg5h60zf/oR7kLrLX9p8W7Aq4lxfp7+Pr
         X0xxvOxwY2zal+6gEDlSlM96CRERnLdQtqE4SNJ60pLPBVX2r1VruKB874EwNCo+BM9H
         2cslL4ZCY4y/dlQM/BdHfTBT6/SIsIJeUvXhL8EKf5M+zVNwCSZsCLf2J6XZeo8+W8Vy
         zaaVnGX8haC9qoThU/4dCr3ZZSR9ICEPAsi+5ypQqehBSAzDWs+ybY8a4upvUTOqaX+v
         69Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761334683; x=1761939483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tErkCkurvvEvRmrrCuEfmIwe8cZhw5krvFH49Q3590Q=;
        b=fpCpm7zsSQ/iwwcES6E6jmoQd+ascEGkLgJqtSKFz9dSSlSj2i+eZ9nGz6yRl67ttw
         FNjYRPPTrVHkRcEql/anSWft0P4X4Ayz+gJX8hxhMCAEMglLXsLUk01jq0vwgot5FU0K
         SEcDjOS3ehv1Q7BkgE28eKV9znQ7EBOowEbSbPgh3xWHDnZ2ZNg33zpJlmyVmxIcVo0o
         VM0dqYHpVzSyfiDTYbJhFVGmkeT10vNP8L1/uZ3uxuJoDB0jAY6iiHNtcHMvoxNCtGA8
         r09LvJuEu/PX3Wk/6ABSVJ2N7GRbCohqeT0CJJUb3D5NJ/RyJO9P/SKYQgJtuCHTMxtB
         4Dgg==
X-Gm-Message-State: AOJu0Yxu50zlJg6yGDc8YP6LPA9zl5LnFTVSZXK8BgA3QJFx6jBi5GZF
	Mn+im/0OmBkBEhlEwuDTEyK+xMKrA+iZLDPY4pMqqBtHTpzo3Fyfi4IK4ArvOg==
X-Gm-Gg: ASbGncskLe5OHF+shmRHVbF3AQ8wbisEOy+zwJJwXgx5duk8lUF6H774tHyJfOejaS8
	ayvfpvd/NpLWIvbD5JiFJKSpNCmItgr8SVAMDuiPNE273ADq/9a6/8mQU3viwyJMufovPp4Qav+
	rV3R/6COdJOl+IRwP1Ol/sv/7UqROfSa2JiXtQHQy/WqNvAhEMuTDpOufiAshP8uIfvJQSUekz7
	lIVFuqWZn0QZCz0DV2mpX9W9NqwkJmwatGQYVthT5pIA5+xW2H+UaWNNuaUfdsSHhYYaX4QB6Ki
	+EA1vEA3pg99h9PMI/SdSmAAhVtP8AMueW6i82polv52cZveGtTKuAWssCtfqfs24g8+IzcBVLd
	Eis/Y/OMvCVy9lmyXQsbdvYVUjwTPCph2Vj0wMf292qdj5A6a3DOIL15epf1sRg+7pFb+ToJPZt
	gZGm+N7LbJGSF7QH0sNHVMtToyGjBiAcIkmeKmrxCFUW9iIpYt7X9esdSOMAIwsqDOUg+2VceR0
	2Bdokx/sfdH3ZShXPMq
X-Google-Smtp-Source: AGHT+IEEmDi69mStumJC+mbLFf0LX3jVbSEEcIH+JGgXUeoKdWcFXDMkaJsVJYuwrzxKZhaF4tKsQQ==
X-Received: by 2002:a05:6000:4285:b0:426:ee08:8ea9 with SMTP id ffacd0b85a97d-42704d9b240mr21805777f8f.44.1761334682838;
        Fri, 24 Oct 2025 12:38:02 -0700 (PDT)
Received: from f13.tail696c1.ts.net ([2a01:e11:3:1ff0:9dcd:df29:3054:53fe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cb7d1sm28073f8f.16.2025.10.24.12.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:38:02 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v1] proto: fix file descriptor leak
Date: Fri, 24 Oct 2025 21:36:48 +0200
Message-ID: <20251024193649.302984-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fix leak of pathfd introduced in commit 8a4ea72724930cfe262ccda03028264e1a81b145

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/proto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 2b29240d..1a7b3586 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1772,6 +1772,7 @@ handle_direntry(
 	create_nondir_inode(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
 			    rdev, fd, fname);
 out:
+	close(pathfd);
 	/* Reset path_buf to original */
 	path_buf[path_len] = '\0';
 }
--
2.51.0
