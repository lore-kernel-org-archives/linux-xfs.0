Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FAB155742
	for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 22:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727217711; cv=none; b=Kp0nwT9OxOEbTN5TdZa6I3DCcl5HKCihJBPdNTQtVbXoL36hEf9DmdOAUH81SPqlusSSfk9UCV5Xvl3CrTI1EIgPWpmB4cO55CT3/gV20fryIgkZXrhOlFMyF7FjoH13pASolCjhpaNGKETJttNj1y1IYqX+s6QrblgTRQvO6WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727217711; c=relaxed/simple;
	bh=Myyp8NBhaLrbvyMytpCoFFH0i9Qb2P8Vdv0CCqOLW4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jp0U42AdGyxFxAkx6lhk0Qs3QIpEsDXZiIuHtJ6dpH2hgeZcnnTbzP7sSQGBbqqpg5/uOdz7a60PCgLtNNl8NfRJ0eJmVHrcEZBI+INiwDQ+EssUVB4xgCCMe9/1Kyacc2f4dmATz47l+xCRicE3dYK2JBNCgd46lOde0YQ2SLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gFnTGghM; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gFnTGghM"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7a9aec89347so384051385a.0
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2024 15:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1727217708; x=1727822508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kMkBt2ndnZsJ25ZrZgkjn9Q08hjBkXqiZSvNSy1oUMg=;
        b=gFnTGghMaKq/afSXO6GI1uDVFMxy5+5q/YAi1E4Yq14R77/hsRqnWaLnvo3G9zHF1K
         RlyzYBNpKz41mVWbjlCU3GEgT/BtPAUvg6hWXZu+9frwZX4qtqOZtq0y4Ou9yeZ/t38v
         sRsi+DEbFCJuDBsi+dtl7XcXhJW070IMtXXkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727217708; x=1727822508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kMkBt2ndnZsJ25ZrZgkjn9Q08hjBkXqiZSvNSy1oUMg=;
        b=JfhBzgaxQR6CZNR4EKVm7O16QS+sFHC0WrOx1PBDdrKSSU+3HSn/g41Jas6yYVwNbE
         yUDIWaB0sdIQcn6bZHgyss0Zm/nzGd9A38FgaB0A+pXUo1JwyUURBFRnyB/zVa/JZGDu
         5s3u32Hdb8ORz66rzCBNJWKg3hlI7/PNSX9DiIZNyIIo7Ma4ssePdoWFKYcXH7w3Ch5G
         z08LVQ/9npUfbMiHmJmMldeIQJCiBGtUPdW4S75T4kIPL4lTkEHq8wscUyk8j9WUm/mG
         h9zOlp8GmU1jGckQfB++jxPuvzENpP4gCc/R5zPFpKb2gCtLhmHFnat84sNN4Qw/VtDD
         VMMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRVSvuTd3fBpuVwBNkdRC6iMMMugZ0N6pThzBfOSZMeRVfp/u2j28RzXhu9yU42dWbOXdnANXQHFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzApn7ZEv2boI7faMS8zcQ4orECvHVBUpaN0LkU9KPunm9QPLav
	GD6w+awGZ7X/d4gIlkeviz4YWwyXoEPW6lu/mX285++fN0QI+ChGmfoMC69oPw==
X-Google-Smtp-Source: AGHT+IF7y2j5ElY99xoXAzTQLdIolfNsFnQAlor+9pe/omCt0w6+bj82DMuXvGASyjMB8LAXhWdU/w==
X-Received: by 2002:a05:620a:1786:b0:7a9:d0d2:a5fd with SMTP id af79cd13be357-7ace744d8femr137981085a.49.1727217708492;
        Tue, 24 Sep 2024 15:41:48 -0700 (PDT)
Received: from ubuntu-vm.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7acde53d6d3sm114843285a.42.2024.09.24.15.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 15:41:47 -0700 (PDT)
From: Kuntal Nayak <kuntal.nayak@broadcom.com>
To: leah.rumancik@gmail.com,
	jwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Kuntal Nayak <kuntal.nayak@broadcom.com>
Subject: [PATCH v5.10] xfs: No need for inode number error injection in __xfs_dir3_data_check
Date: Tue, 24 Sep 2024 15:39:57 -0700
Message-Id: <20240924223958.347475-2-kuntal.nayak@broadcom.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
References: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 39d3c0b5968b5421922e2fc939b6d6158df8ac1c ]

We call xfs_dir_ino_validate() for every dir entry in a directory
when doing validity checking of the directory. It calls
xfs_verify_dir_ino() then emits a corruption report if bad or does
error injection if good. It is extremely costly:

  43.27%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.28%  [kernel]  [k] __xfs_dir3_data_check
   6.61%  [kernel]  [k] xfs_verify_dir_ino
   4.16%  [kernel]  [k] xfs_errortag_test
   4.00%  [kernel]  [k] memcpy
   3.48%  [kernel]  [k] xfs_dir_ino_validate

7% of the cpu usage in this directory traversal workload is
xfs_dir_ino_validate() doing absolutely nothing.

We don't need error injection to simulate a bad inode numbers in the
directory structure because we can do that by fuzzing the structure
on disk.

And we don't need a corruption report, because the
__xfs_dir3_data_check() will emit one if the inode number is bad.

So just call xfs_verify_dir_ino() directly here, and get rid of all
this unnecessary overhead:

  40.30%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.98%  [kernel]  [k] __xfs_dir3_data_check
   8.10%  [kernel]  [k] xfs_verify_dir_ino
   4.42%  [kernel]  [k] memcpy
   2.22%  [kernel]  [k] xfs_dir2_data_get_ftype
   1.52%  [kernel]  [k] do_raw_spin_lock

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 375b3edb2..e67fa086f 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -218,7 +218,7 @@ __xfs_dir3_data_check(
 		 */
 		if (dep->namelen == 0)
 			return __this_address;
-		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
+		if (!xfs_verify_dir_ino(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
 		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
 			return __this_address;
-- 
2.39.3

