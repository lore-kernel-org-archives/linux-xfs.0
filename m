Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E5918732B;
	Mon,  4 Nov 2024 01:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684715; cv=none; b=Nup6PKD5Ko1IIqajs82cM5sLCf8bSu9vnXjoxLDbYt6RYCWhKJjjU0QxV+EzALfU51UNB9JdCsujYYRYoYcePqXCNz4gZeYEnRYE1BN9ImX4wL8ojxmcPrzEFhD99oPUTz3RjT2pxmCRpzBNoW9T3aWi0FM7SfhKR/2dJ/TGQJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684715; c=relaxed/simple;
	bh=4HN9YTUUVd5m+kQvD8mswBgKP6nmdptFwI0vtuu5NSg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XEHIwjCUlwUqIfaKeEcvyPkfHw+dOcf5BpWCkB3V+KuLmqwgpdhLUDYNLiKh4VzHZIyg5DwXWYGTCl+rmKFV/yjJUcFjVbydFePdtNZCCxJGMz7HLYE4g/zOBWFJYG8FqMOn9b/E7l9Jy74GS58aMFa6RkMcvQztSK7zLUf023k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Azr0JTsj; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Azr0JTsj"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-720be27db74so2283338b3a.1;
        Sun, 03 Nov 2024 17:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730684713; x=1731289513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rDXLhuXjk2jLJN5NRJ96tHaE2wkNSlsldVHym5Q/eo=;
        b=Azr0JTsjTx1RXwOD4c+xhOKq/nc+osCNN2r0OUgIlTsnosdAtCvrR810MMU+wFzk4q
         DGtF/sgN13wFL+IXYpTEU9JoI7tbdf0rVnP+0H8iHUr8GqjSBNj78lUXo9SSYvTFXTwZ
         fkmzkegxw0KepAAjcCRMgur521IdjjUgtBK8o72Fep8AxRWGX8mDFKsrsfzBeAEFEC5J
         A2EzErUGm9F+JHKN4zICP0YaoJsqYTIFHEAvZ9Te2ThCC6olxCqDUjCtXHA+pgFiiloo
         o3CPeVH3HiEyPFEDAGvd5AmF73uFp5QOP/E0O9o3kTpP1jHi2zcMQOjoDsuuC4sa9Chg
         D6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730684713; x=1731289513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1rDXLhuXjk2jLJN5NRJ96tHaE2wkNSlsldVHym5Q/eo=;
        b=snK9DVhSfw8o9knygvPwXcU0LowXjkQYNamxJuN+ZYjvV95mz+un6muL+ghzmh0yP2
         BEQnv+aSNq+BVMTO+48ihA0rMSRvylSJzHtXPK1mt5XdBLiPMn+JPBAqFjMzqH/kHE8X
         069bWxy9a2g1C5Ue4OICA9fNX77G43f7jSraQUz/2jI65vXmvCdRDu9JeieTOObpf3Vb
         JPI2Syd6x1S6Tk4YHkZMIljYgmFHsvzCcjKzHkIKEXjDCJEnqL8Q9cxRgRBasB7x0gGn
         rERUDEc+FDCmHQzQJoPMl2XPNkyT8iK6dFxA9azIV1/RQQ7EUOAix73NKHssTYeoaRRx
         Z/7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVm8ue0EI0/DcCIPWCbLKjMYZMOIcbw1CWQD4HKY7C94CMi6gPt9kKUxcTj7IYxU8lZWBA/aSkdNf0mA80=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGbA3Tq5Eej1yWLGID0+NfvHkhQKirYNBd4IsnH965OgIabJ/N
	vgdFrIMCdTxUXX2gTQDBaO+V2CJRPbI0b62zEDNIDoy9qGHDUe3XUX2cgowvgaE=
X-Google-Smtp-Source: AGHT+IFposWJFsNCfOvvnQK72vOWX6qOEnNRu3Qw1p2EcyFypfIgeTWSrCxQDtjQGZoLJrAj3J6H6Q==
X-Received: by 2002:a05:6a00:4615:b0:71e:5573:8dcd with SMTP id d2e1a72fcca58-720bcaf1e8emr19062503b3a.2.1730684712999;
        Sun, 03 Nov 2024 17:45:12 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1eb3a7sm6360030b3a.81.2024.11.03.17.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:45:12 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: djwong@kernel.org,
	dchinner@redhat.com,
	leo.lilong@huawei.com,
	wozizhi@huawei.com,
	osandov@fb.com,
	xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 3/5] xfs: add mount options as a way to change the AF layout
Date: Mon,  4 Nov 2024 09:44:37 +0800
Message-Id: <20241104014439.3786609-4-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104014439.3786609-1-zhangshida@kylinos.cn>
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Except for mount options, maybe there are other ways like ioctl()
to pass the layout from user to the filesystem.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/xfs_super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0975ad55557e..09dc44480d16 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -105,7 +105,7 @@ enum {
 	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_af1, Opt_af2,
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -150,6 +150,8 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+	fsparam_u32("af1",		Opt_af1),
+	fsparam_u32("af2",		Opt_af2),
 	{}
 };
 
@@ -1396,6 +1398,12 @@ xfs_fs_parse_param(
 		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
 		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
 		return 0;
+	case Opt_af1:
+		parsing_mp->m_af[0] = result.uint_32;
+		return 0;
+	case Opt_af2:
+		parsing_mp->m_af[1] = result.uint_32;
+		return 0;
 	default:
 		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
-- 
2.33.0

