Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A63113665A
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 12:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875818; cv=none; b=iaLawtpPr3Ej2SCa8F4toqfnfWzwzYaQxv3WB4Qrhh05fhPYBcMlHtGi1uwbG31xoHELIxjY/3WqyFl7IL/Fv91WQTydwZC2k/OPSqVSsam87jXyS/Q8qpMrqFIMUVPefdXWeTME3EkiVkBG5EUeDaVtNetkut6epJ24DwEmbP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875818; c=relaxed/simple;
	bh=9gS9lIQSFG27pOmupHpcGIadFMEEto0gV48SmKnlV/A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PydQKHoqo8N5bOu2zIpHLHsE9GQXUJTzpI+WVArxMTP6ZvF4OtTA5d1AGDAU8MdIcbEr5J/kbwT5xMa2TIQ6j+3zHfhGSATVWH6u5Qv0bRlelr3AWT5rxVj+7TF9pGBd2ZFHTPPt+vldQtPH5s/Br2vL38SRT8sOMyX8qdEzG80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Au/81XRW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Au/81XRW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713875816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/o2OHeusxSQYyxVWz1nebhnXWzM1ChZk/m24kEScxjY=;
	b=Au/81XRWSUBD62elAhYo58h1GwERpM6Lw1Irf2BsF6etoGHiaN9aLDXybrCrrgI4mPzCtj
	MBUTjtB2nEQZO41xUPRgvM0F4JHTJlewhjNFMsbcZN+38HTj8NqGORqAvUhwUkJ1XKToWT
	dEfZJLOMEGo5jgzc/+zqs0xwTJUsNVc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-30JHgQFdNCGItVYuAPkR5Q-1; Tue, 23 Apr 2024 08:36:55 -0400
X-MC-Unique: 30JHgQFdNCGItVYuAPkR5Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56e7187af0fso3463067a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 05:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713875813; x=1714480613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/o2OHeusxSQYyxVWz1nebhnXWzM1ChZk/m24kEScxjY=;
        b=BymbY2g+ZDBS8worL3Jw52YcBt8DGqKMGWMTgHZ+R+a2b5xEBPvnp/XccfCtD8liKW
         OksfGYYdIcTA9iJZ9FCShWdX5LKBqOg83QhtawHU9XVRaPR66YRCM0ODULkXk9gvXdN3
         f3IZZ4t5DADmNPrv8lNnDgGpHo3UbEi8VUs+Z0V5/Mzzl9qEJy/XFyes9TnlPVpbxFfq
         VwQzPar/J3ELXDzlzHKg3RE6aVb291LS6fKxzGOsDrWpocpJZ3eWR+KQjFkWm99eyVzp
         N7HOmrUK5b6c0m/5xlLdOmZopsSdIT+o5TEDzRbVVEtsrIo4qtaA6OsIJ+1eX2P/jZlO
         AKUA==
X-Forwarded-Encrypted: i=1; AJvYcCUlraIh9GQLOzXfmD8NjDSTM4isuravgoUUFA1uXRKuZLs3b1QW1jG3imNSmam3gjBO1VVzofaA7oQ+SQ416BuQzwWnNoYoc1ia
X-Gm-Message-State: AOJu0YwF4fXJ3Fg9CV2H2AAIw0piSlt/8JDPBjnhw02rfz/OChIL4jww
	SozKpp1lHpUtNtwK82xJ1ldus6i/Ojf2YbGkwQn7Kk0ZAMogGme77Eu/gYNgGvnvVZvri0CEO68
	EwBwqoJdWzsxtAtHMF6myjznry6hw2COiw/4PVV93pPG6giTA94ct6tI+92NRfMMf
X-Received: by 2002:a05:6402:485:b0:571:b9ac:ff3d with SMTP id k5-20020a056402048500b00571b9acff3dmr5817141edv.4.1713875813264;
        Tue, 23 Apr 2024 05:36:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFic4CWr65r6Uf83AH31uJUY+zseWEgljYzLjbVY9tx/w2cchK7YM+UipgCjT8SoIhb91fPHg==
X-Received: by 2002:a05:6402:485:b0:571:b9ac:ff3d with SMTP id k5-20020a056402048500b00571b9acff3dmr5817133edv.4.1713875812578;
        Tue, 23 Apr 2024 05:36:52 -0700 (PDT)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id et3-20020a056402378300b00571d8da8d09sm4783170edb.68.2024.04.23.05.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 05:36:52 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 0/4] xfsprogs random fixes found by Coverity scan
Date: Tue, 23 Apr 2024 14:36:13 +0200
Message-ID: <20240423123616.2629570-2-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is bunch of random fixes found by Coverity scan, there's memory
leak, truncation of time_t to int, access overflow, and freeing of
uninitialized struct.

v5:
- printf format for time_t in repair
v4:
- remove parentheses and conversion in another expression; add
  spaces for operators
v3:
- better error message
v2:
- remove parentheses
- drop count initialization patch as this code goes away with parent
  pointers
- rename unload: label
- howlong limit

--
Andrey

Andrey Albershteyn (4):
  xfs_db: fix leak in flist_find_ftyp()
  xfs_repair: make duration take time_t
  xfs_scrub: don't call phase_end if phase_rusage was not initialized
  xfs_fsr: convert fsrallfs to use time_t instead of int

 db/flist.c          |  4 +++-
 fsr/xfs_fsr.c       | 10 ++++++++--
 repair/globals.c    |  2 +-
 repair/globals.h    |  2 +-
 repair/progress.c   |  9 +++++----
 repair/progress.h   |  2 +-
 repair/xfs_repair.c |  2 +-
 scrub/xfs_scrub.c   |  3 ++-
 8 files changed, 22 insertions(+), 12 deletions(-)

-- 
2.42.0

