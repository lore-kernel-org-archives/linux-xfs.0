Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3161F2C56
	for <linux-xfs@vger.kernel.org>; Fri, 21 Feb 2025 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740164285; cv=none; b=TIbDsZmAJjK9upSwNX7ca95CX07tfYp01uf4SVy2Y64dhNt0YLgUs2rzYSjAdhLk17O/PS/tePiWM9Jr7UIKk6Mnx8PEoHGhx3qSAMOF10/xcRbrMuz8txfYwN7LEK5XQDnv2TdZcyXVg7rZ/gx4ndR4KnUe2jgbp5MM5COif6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740164285; c=relaxed/simple;
	bh=yYzCqPEKhFINlmo8nU0sJmJc/vBIczX0mMdzVzQgUME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/m9G64DhVy1D3ISeK52704ZLY/UePKfmJgcgBynFQXeX9H+7StCo5vaFz4jTm+XeuUeCS45ZnpxDS7jaiuUuomxNxMZT4WLM9YPDk4Y4gZ9GvODa3IHGb+Inc/8+5WI+1ZhwXN+3W0ofyMDw33Bds4VJ11+ZJbqFCgW3Onnip0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DVLZDs1F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVLZDs1F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740164282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b4aHMhlwwKHCFybQ84J/KnuKFoecjLX8Zzz3gshrv1k=;
	b=DVLZDs1F/+ttlf7vwqEq8RRJnb3KfiYJYOduImKdVSPtgQArumwJUVtlbyTm77l9fL11jk
	oscNMYPAQ4HeMERpQPXc5bNkXmevzC/N281KdeP0E57vPqJJ31rIWTEjrLEYzIh8mSW1Ac
	f06yUpHL7hmUsT5jzaRIdHWojtnszKs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-ZyF3VnGCO-y_UqOW45ZCuA-1; Fri, 21 Feb 2025 13:58:01 -0500
X-MC-Unique: ZyF3VnGCO-y_UqOW45ZCuA-1
X-Mimecast-MFC-AGG-ID: ZyF3VnGCO-y_UqOW45ZCuA_1740164280
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-abb9b2831b7so339327666b.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Feb 2025 10:58:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740164279; x=1740769079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b4aHMhlwwKHCFybQ84J/KnuKFoecjLX8Zzz3gshrv1k=;
        b=l/2FN6B+5roBs90if4sXgDlzZI3uHlvd4hfcHYg0GPfj6w/PyCKmRAyEwcD5bqsTzD
         OMEOcquIw9OU6wUxT/QS2QYykNqLGhJku9s17ciID+lS3EheijQqlgVI41X+sicjx6HZ
         IYRy2GGqnZycj64+ryGfQvq1DdynEVrNA+e9NT6gPqYPIyXWRvWvFp5eOijjkxj1+SN3
         aCXri99tPonDAvRZyfPfH4iKLXPBnLQ55X8u3JuyRy7bcFu0aJfzve2WDTh4dHIGp5cx
         2JV/aCIflmpr8nVVjbplDptzMegwGMqkyfOHeJnfz+cdcpUqLeFe3jZ2QTjk7G+jPns5
         kZ9A==
X-Gm-Message-State: AOJu0Yygx7cnAmcLK3vfYa7A7fSb4tHAu5J6+mP7q0dYWYm/ix7PIkdL
	NJ7EgpaUpcNLqHHQVlWT2cl1/JNa19FXog5dpB3fllIsow2oBc3wMb4AzlvnOD5EV9WC/QKJFYS
	HKAg9c9ulxn/PCnoZL0LKFY1volFqeyMtQCHWzoUFseP+IR7OIdLv9j1XK5LKCsVxtQ==
X-Gm-Gg: ASbGncuXoS+hc1CFr0aRr+VYmpTc2Q7/vIP0GOrFuvG4tofuXd/mHWhAFl1/N09AyJ+
	k7MUJUeQL4qsh9VQssH+d8LEbUisTD2RSKlgI44NWaw2ihGwqc0MXzW5XHAzBbAAJXHcnnlyQpD
	lYxlvsgdKlG85VoQ/yMt0fvgwjPtcaLgyYJNgCdqGKll+ZNt0CLLYP0+PTs1xaZ2bZ290KVT7wB
	uFXpfse9/0fSaUa4ZwxZn8vbzBhwhw5ngMnTHr9e4PAS8L+kDcS0piNu3Pxr3gh6DKmOfGq5B+/
	UHySnwwar+VlzqhlS9WHifor1DANY0i++r4DdFq4
X-Received: by 2002:a17:907:9989:b0:abb:daa7:f769 with SMTP id a640c23a62f3a-abbed5b21b4mr851871266b.0.1740164278957;
        Fri, 21 Feb 2025 10:57:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWgwK3cDIX60u/IwdA5ztWP6BV6Ntgte4oxUc5MjSalj4ldikTIYDLwxEulrml7uMhjxVpMw==
X-Received: by 2002:a17:907:9989:b0:abb:daa7:f769 with SMTP id a640c23a62f3a-abbed5b21b4mr851869566b.0.1740164278533;
        Fri, 21 Feb 2025 10:57:58 -0800 (PST)
Received: from fedora.. (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abba6f884f2sm905621666b.155.2025.02.21.10.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 10:57:58 -0800 (PST)
From: Pavel Reichl <preichl@redhat.com>
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfsprogs: Fix mismatched return type of filesize()
Date: Fri, 21 Feb 2025 19:57:57 +0100
Message-ID: <20250221185757.79333-1-preichl@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250217155043.78452-1-preichl@redhat.com>
References: <20250217155043.78452-1-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function filesize() was declared with a return type of 'long' but
defined with 'off_t'. This mismatch caused build issues due to type
incompatibility.

This commit updates the declaration to match the definition, ensuring
consistency and preventing potential compilation errors.

Fixes: 73fb78e5ee8 ("mkfs: support copying in large or sparse files")

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cem@kernel.org>
---
 mkfs/proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 6dd3a200..981f5b11 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -20,7 +20,7 @@ static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
 static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
 static int newregfile(char **pp, char **fname);
 static void rtinit(xfs_mount_t *mp);
-static long filesize(int fd);
+static off_t filesize(int fd);
 static int slashes_are_spaces;
 
 /*
-- 
2.48.1

