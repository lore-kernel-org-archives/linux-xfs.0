Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC94A317148;
	Thu, 28 May 2026 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941178; cv=none; b=Vib+ifIGOplihWwshIV/GnPJfHiEIDYLNWJ83DO3opsDaW5woUU0SBlsMWk2333ufgY3TdUjW1ePzztUiTy1V/QaN8NSCN/qBtm3WEKyavy2tp/5cRZ91Gd4Jpbjh5z0Rps3MgXUWobA4HOeOUg9KSCDP2F/LoiY56cS8fvWB7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941178; c=relaxed/simple;
	bh=qkcDYd14HvLZT+hGAXHaXb4lm8XcroRoi4JMdfL5vF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPI4iLlC7x9bqDj+Ucr0AYpLfJFCSM+hNe6imW/J5UVzJZiLQjbXeW4K0Nr4ud9IaA5VQSDHcXE02d8SllzvZPW3gwKhmkRg1EBziK1/quYQ4QWBQnd5ZupDVNYpCVE02cZNTqdP5rT52Xt5BZH58lhh1ytiodIbEvBobigea2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJAsLqmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJAsLqmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66DD1F00A3A;
	Thu, 28 May 2026 04:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779941177;
	bh=7yTvj2+iPY9bgL3Stb79PLfhmJb2V6kYoeFhUhcOQBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJAsLqmVLMooIrhh/1vq1kc8PVAnOCsjVRIlmKT1UVoKB94KJ05Wu01IGMx21d9hx
	 i767/nPAzXBTQBwYUfDsFPhFE5qPDcejnRq70BEnWAcZZ42gZVkCrdajAGs8yKXbC8
	 M4FxIYjgIQGkktOFi3oX1RYMQia5zCYzrWGa2LmFSemih4PutaFvqklJhpYfuV73Vk
	 xvpKmiOfjK+8UJXSbq2iXOmn9Fo+j724iQ1gc9Gx177rQeUhuqD6/Rs3oSosYy8swn
	 2SVPXH+lJ5FxSsTUI59urvuQfzQlfhjS+4NOvwxvCHwRpA/fzlkjnxenDEZ5Y8Wpaz
	 MdwWH+jyg7wcw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v6 03/11] fstests: add FSNOTIFYWAIT_PROG
Date: Thu, 28 May 2026 12:05:34 +0800
Message-ID: <f4dc9d5af00133834acf97e1c72232d2a9b34ac6.1779939330.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779939330.git.asj@kernel.org>
References: <cover.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define `FSNOTIFYWAIT_PROG` for an upcoming test case that uses `fsnotifywait`.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/config b/common/config
index d5299d5b926f..5661fa0ec310 100644
--- a/common/config
+++ b/common/config
@@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
 export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
 export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
+export FSNOTIFYWAIT_PROG="$(type -P fsnotifywait)"
 
 # udev wait functions.
 #
-- 
2.43.0

