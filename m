Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7932023C4FA;
	Sat, 25 Jul 2026 07:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965178; cv=none; b=cQI64PSdPICZA1JYFimksJMD0eY8ZbIFJEHRU6+lGbo8OEN41s1NbPz5KtkprgZzu/jcxMejmAbuPrfbQIjUjTzKnerw1K4xrFLZzt4Es3k1pzZ2O3Ly9ut24jE35vFtrCTMi0KNE9xTAS6dmG7s0ZEgBM5Q4yx6Z+1iPHZMIVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965178; c=relaxed/simple;
	bh=VJurfG4toGajb4n5Qqe6G4JDDM745tu9pj9m7voQBpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2RtW0erZs0ObgZTPsaHr1xXfZRU1v/f000QkG1HQ0IUi5Ee7YhZ8klteOS1P/yvdpkt8YIo5n75G9xXV+6yA6cofl+cwNFbYp7CEGyKKA+LawKh9UGbm0i3/k2LGP3gkbssIimI5acT87fofjyMK6xEsfz2Z6MWXl3Z6gXnYqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKU7fcel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKU7fcel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1F31F00A3A;
	Sat, 25 Jul 2026 07:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965177;
	bh=H/ifHRev1KZt7zJcATaDa76vriuxBeCWHVdvTL8hqTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKU7fcelYnCko5jUYOMQve4DorkA1qbXiJ+i7OXYVbcBLCt3EtDx7pFzbeAor+C0P
	 KH7sUzDNrZ1zBWT+HEY3Gu3eegC4BYGorI3eGSB7a3wLbgM04xn9CK6MCbshToiqzT
	 L9DFZos2OkjbmYObAjimO5pN/uT697pJH1+8s2K9+UIJhaMf+pfq1w9BbzYOjjB0AN
	 PkeSwcpRBqWutRvQjjwbvcMut6yZxtwTnvhP3F8iUNYm2eXvq0YJfs8orVtHi/rQOy
	 LrCFIIl4iZhIeqU7xmMVgBjq2D1e7VKm2R3vegb6EiRyoOrwtgIVzZTdylVNVh5BFB
	 9a2HJ0BlxV0Iw==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 03/13] fstests: add FSNOTIFYWAIT_PROG
Date: Sat, 25 Jul 2026 15:39:00 +0800
Message-ID: <09003af49b95d3b7fdf24b0d76e3ef389b44c3e1.1784949154.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784949154.git.asj@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define `FSNOTIFYWAIT_PROG` for an upcoming test case that uses `fsnotifywait`.

Signed-off-by: Anand Jain <asj@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

