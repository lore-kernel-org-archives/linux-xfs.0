Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23951281531
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734708; cv=none; b=pTH9zZ2HgSBp4NBurJBp8pnZ+4IGqntI4EyIQLKqTDplmPncVWQUbqgWqpi22cuRIoKL8YLmzlx3tipIPYgKQyethMe5oX8K3tZTj2pXG7oCcRlh0aSaaTpYtZN5KXzaJLL6DE13kAlOuNlz9SF2eDW7vImLnNewdpH6GUEU98s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734708; c=relaxed/simple;
	bh=9p3je7ovaq0B8RD2/pr9rtueolxe1jVdbp+fSNss1tA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ewQXv5jQWZc1UdYRk0BYmBEwsBreY4o6lZLjISzjsar6sHs0mBv8jwPeeMDAPv97Rv1Wrd8S+wSF41YiLChHvG/LoFAUycQg0MsoraI1XC2HvPjt8766osBjIkqRwWbgzKZAAOSL4vFcMrc33WgnewRM/tONWdraOAuRfmShDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y5SjRPMx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y5SjRPMx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtQJvCPxeTpstVyjgZAbXZc0G2YxyuH7YAlXrLlQnu0=;
	b=Y5SjRPMxtVzWQqCK3JtTY5vYqTNKzrVx9By0yUscgxGlxps5S0SxRX1zWtGgNhKiRzPHa/
	N2saJ1q9juUJA5/VVloUlfK6nTe1VkMUbH/CzKjeZ+oyrkbzBYiT1BkWqM5O2gw9Zk5Tme
	G4WkQpIFduKXqwJYUJnKGes4E09lOkk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-ekTE89nLNHWsOKtn7N0RnA-1; Mon, 28 Jul 2025 16:31:41 -0400
X-MC-Unique: ekTE89nLNHWsOKtn7N0RnA-1
X-Mimecast-MFC-AGG-ID: ekTE89nLNHWsOKtn7N0RnA_1753734701
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-61563bdc8daso318969a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734700; x=1754339500;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtQJvCPxeTpstVyjgZAbXZc0G2YxyuH7YAlXrLlQnu0=;
        b=IU2h53DoM5Unk4hQCy+deUEte9H3ozYBDLdCDRDIZ6aH/1lGsjxAu0yDmRd6NYz79E
         T/m4iKNb1gzypny15MpJK7HayPfBRO0vySgx+lsUBox2GkixfjhLPzfxahWTuPtzJZDI
         ZaFMHb0s9jjbxehPvSFJPkp1HFAidSnZLoBXY1Bwsfa3oUirt+EvZy2wEfYoOWHO3EjT
         nR/5hlTlPhhod/yjFo/3NbL5AEkQC1TTdME6v/pc5lV2ikc3yeDU39+wRV/9DXCYp1eM
         IEcC+5iYC6+yPjJuveIZODwIWoDc5ys9pFe3dK4DFN5Vay9OjyrimNZHpver8kqJo763
         gvSA==
X-Forwarded-Encrypted: i=1; AJvYcCV0A6kZS3a23zV5Wc/Sm74UTx+uhmoYJMNbg+rkHCvV2ajF/1e1beL362fRj3faVqexejxVbtGhpgI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7ERSGXw76cciciq9xGDSrRU65jbWm7ht6/ZGTNJJzJVxJm2Gh
	EQglUL+CZD6Ngb2wYcTsNJdBULdR+MqBoXgtnFQ8TnBJQKRd1p2vwxJIV8/94cyChPIHvNqzc/o
	TEAp9kYt7tGeEJH5i7Vf6UR09Axd20wcKsNvjW74meR8IENfKtEiRfMNNRioY
X-Gm-Gg: ASbGncuYnYQJ3k8wytK+Li2Qnb75hgesRHfsUNKvzhiC/WVNfKac6ythjs/qndogtNQ
	tjcToK/NiS8V7w2tZiPwrgsLk8fQwZ5x/DVdBnH2aT1Q+FNRSnLA/Lv8+dPuK4zeBA1dbEolL4X
	7cJHFZAf2RAdX2m8QMZ9gJOG5NrXnLxs16qNP+g5exuErk3ceQNhKVE9f/7WD76YTzxvMpb8lpO
	C9Pj9Y8ZfBG/eYamFzncPNfmGnPdlJrds+cgjMUMLyOZdo4BK3Q/kUD/uj1uz1zD01Q1UNhfXCC
	UaTI+jZ+8M6zSKEW3zOhJYeC/S3UgLm4jpqv5RTRhxxrYA==
X-Received: by 2002:a05:6402:84e:b0:607:f082:5fbf with SMTP id 4fb4d7f45d1cf-614f1bc4e08mr12085049a12.12.1753734700501;
        Mon, 28 Jul 2025 13:31:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEm3mB3ElwGqIqkRyBhO2Z5hZvB74PuXLKq9UDjvFTGDUQy/f5zCpnhAQLNFtZgZRIeyuyWA==
X-Received: by 2002:a05:6402:84e:b0:607:f082:5fbf with SMTP id 4fb4d7f45d1cf-614f1bc4e08mr12085030a12.12.1753734700033;
        Mon, 28 Jul 2025 13:31:40 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:39 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:23 +0200
Subject: [PATCH RFC 19/29] xfs: disable direct read path for fs-verity
 files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-19-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1542; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=pMZQbXtMrVBz6SrzAXMqrLN3V7mq4bHJ3sncK2j8+2g=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSXxXVRT749GyXdn3V8Wy/1NWLajpunhedsr8p
 PdVBb+qMxk7SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATOTfKYZ/JpG5x6ae+WG9
 UHzu0bbHp/l1zJR3r2a6/kn4xPYVObVntBj+GeYfWnr/wBwvvidTpB3bFZ1ZZxxvVNr0zeXOi8w
 JTWfd2ACym0xK
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

The direct path is not supported on verity files. Attempts to use direct
I/O path on such files should fall back to buffered I/O path.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix braces]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index da13162925d9..9680c97ee40f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -259,7 +259,8 @@ xfs_file_dax_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(iocb, to);
@@ -312,10 +313,18 @@ xfs_file_read_iter(
 
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
-	else if (iocb->ki_flags & IOCB_DIRECT)
+	else if ((iocb->ki_flags & IOCB_DIRECT) && !fsverity_active(inode))
 		ret = xfs_file_dio_read(iocb, to);
-	else
+	else {
+		/*
+		 * In case fs-verity is enabled, we also fallback to the
+		 * buffered read from the direct read path. Therefore,
+		 * IOCB_DIRECT is set and need to be cleared (see
+		 * generic_file_read_iter())
+		 */
+		iocb->ki_flags &= ~IOCB_DIRECT;
 		ret = xfs_file_buffered_read(iocb, to);
+	}
 
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);

-- 
2.50.0

