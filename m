Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A289C2DCBF5;
	Tue, 10 Jun 2025 13:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749560441; cv=none; b=l25JI3uAbG5pguwaovLY/KYLHB1rLPGZOLQoR5AkSRxpybsMsV85dja7k5c5IVhx6bCbEEaUfB4/s+dRqMMa+wdXCIhiALRAnr4uIYrYwhvfhud7aXWU0NJYtPHLxJB0VedXn/3uWnIbyD+dGPZOdRgaE8cJMNKwqlGv3Q9VeA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749560441; c=relaxed/simple;
	bh=abYFe82pY9HAkSfp52BKK6TLTuB3UmZkzkMqJ80SsQU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nYhHipqiYZWZz5Puffu+5kzxf1ZKGZWRS7sZuc4UpOdPdiUmxQvZGgEg4cCO1nnigbrxugLDNv2kpIg1j4SnpDr/0AN9b+Rjt18lRaUva0dwCbiikkMZ84bYZM/LrYFm5fi9K8SfXjGGyTKSHZObW2XPCzzsW5UbK3Qd8nLQFbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=cUc/6d6z; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="cUc/6d6z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1749560429; x=1750165229; i=markus.elfring@web.de;
	bh=3ru8lF5jq4NEcL5YlhuLBKOrkMTglWNt7qSouMfx1O4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cUc/6d6zxX+sITgA8Rw4Fe3qMSSfM+UbMlWqlMsSVD+YudxexaYtAcSSwg6GnwMb
	 j2nckC5GtORZjDxBY10YxhLqmfORZcDXUIME79auMBZekN+HFHHs+RD6GV7gi8X7g
	 Rjwr1ULRlBYbg3NFUTUqHEcDxya8+hKXtMnS7vHZDBuzg8K48WwfUAhHeoIkTv7jX
	 mm9nUC5AujqAZhk3hsAKFZ79SlFMCHg9sYEScGa1S1Ir0VCBF5Z+xDdEdwgUdA5sW
	 QKw+jCuO1iWkPBAfMV4XvkWfAQUbvwcy505X18pnegwgTL2O6xdw+7wjFObPUxdsK
	 XGeJ0OiEsEHSZvyMKg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.183]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MMpCS-1u8XdJ0rA4-00RMxF; Tue, 10
 Jun 2025 15:00:29 +0200
Message-ID: <b182b740-e68d-4466-a10d-bcb8afb2453a@web.de>
Date: Tue, 10 Jun 2025 15:00:27 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] xfs: Improve error handling in xfs_mru_cache_create()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UJz2tF5PxhoKS9eiiR3sqRK5NaAEvx0TVp2RtKUpDQD7UrN2h3Q
 gV1y9GQinCPLstW2tqBY8vi1/JgfEN46C7pAgGhuSJ+mvcikvdmQ6HdBjaxKzCidLXzueFd
 2tYoSGeyZr4AV1uFwHDxckfKsfcvT7B+S71DZ9sjWpYkRXmG5bS0N6+YkHIbOnIP5xaXoa5
 J/CKTinVlObSf4aE9qfoA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:U1xje0ld8v8=;/Nx2tw+MUOcXiLOKS+QqzDNN/DV
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 10 Jun 2025 14:50:07 +0200

Simplify error handling in this function implementation.

* Delete unnecessary pointer checks and variable assignments.

* Omit a redundant function call.


This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/xfs/xfs_mru_cache.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 08443ceec329..2ed679a52e41 100644
=2D-- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -320,7 +320,7 @@ xfs_mru_cache_create(
 	xfs_mru_cache_free_func_t free_func)
 {
 	struct xfs_mru_cache	*mru =3D NULL;
-	int			err =3D 0, grp;
+	int			grp;
 	unsigned int		grp_time;
=20
 	if (mrup)
@@ -341,8 +341,8 @@ xfs_mru_cache_create(
 	mru->lists =3D kzalloc(mru->grp_count * sizeof(*mru->lists),
 				GFP_KERNEL | __GFP_NOFAIL);
 	if (!mru->lists) {
-		err =3D -ENOMEM;
-		goto exit;
+		kfree(mru);
+		return -ENOMEM;
 	}
=20
 	for (grp =3D 0; grp < mru->grp_count; grp++)
@@ -361,14 +361,7 @@ xfs_mru_cache_create(
 	mru->free_func =3D free_func;
 	mru->data =3D data;
 	*mrup =3D mru;
-
-exit:
-	if (err && mru && mru->lists)
-		kfree(mru->lists);
-	if (err && mru)
-		kfree(mru);
-
-	return err;
+	return 0;
 }
=20
 /*
=2D-=20
2.49.0

