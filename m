Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58EB23F39D;
	Sat,  1 Mar 2025 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740825067; cv=none; b=VkWAII8fC04mjq8I6AJQZiODkikU79y7On+zecsJuQV0oGEOshEvRCtZ81NY5+jLK66MO8WwNIEL5CKIQ9oujjzmysoF4fumVL9IwawA5UQFXwk/r5NyB7GhyEoc6sdWkfz0hIzL+0QqQdmWHU/oBHhe6Wv55bvm+KWkIQLfZPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740825067; c=relaxed/simple;
	bh=VHktwuBA++pwcSNLwBq2O+4R7yu0UuumXB+RZgWa7j8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=OCbtY32Y462Lka2FZbtMMb0w23rc4no9HVF5xO7HbVV+khNB2chezC2aqKu5sgjk8vmeMhKe+D0wN5gvErnVTOqNf9vG2C2klrixlxeUIMLHHTxj0QohHfJF6wiPgKFeCkpszVSFZl5F5nkUzZlsXSlPQTpopcoN4Z8y0FXec0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=v/OQ8Ejq; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="v/OQ8Ejq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1740825054; x=1741429854; i=markus.elfring@web.de;
	bh=CAz6gCbtU7uFvGCm74xUODE01eBeWF9wvK2nZ3gFNuw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=v/OQ8EjqpAC+fpc2bPxegcZJQyxu0f1sxiwnHzaa4MRGgrSjKR5AYczeD2oWk1j0
	 fDpH710NRlirtXrxj8/fhxTI+CKF2tufdt0e5xpl/zBkJoQ3mP/09MIaX4XgQOhfN
	 fruZFmZa122DEUX1gn/RkTDPj6VrTaO+r7EwNLPmD2p25xyP90v9TAw7tDYJmp0rV
	 2rTKV+jEpwC1rwlN+0VQq1oen7EDeHtMgSXLY0rxfpvn4qcOBc6C1wT1QX0LfV1a7
	 oooh6bu3qNqww7gvigyRyo8KYrjwhcn7j+v2glEsqtH5bvTpoFxkBq3T+589RNxlH
	 3WYZmNH182wVF272eg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.42]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MqqPN-1tSRZP0ew5-00hX7u; Sat, 01
 Mar 2025 11:30:54 +0100
Message-ID: <2b6b0608-136b-4328-a42f-eb5ca77688a0@web.de>
Date: Sat, 1 Mar 2025 11:30:52 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 Chandan Babu R <chandanbabu@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Qasim Ijaz <qasdev00@gmail.com>, Natalie Vock <natalie.vock@gmx.de>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] xfs: Simplify maximum determination in xrep_calc_ag_resblks()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+uXaeMbeeE6tg5gjSaNZQEIIlZxoeGmI5TYUpyTw3Zs06EC7Rif
 hHaAq88tnokWoUVYdTb2/zu6O9JTGEktmpd+RorkxZ8S7Zs6vGEUnV4WruGi/AMewFvoQaD
 qmJnCjWB6vAGoPWPADj+Jr3BAtZkXUTUpGEcLMqqfhPWfrwx5S5lp+jxugvh3mByS+rePIc
 PaeieieZrJEQLQqRslvqQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kYXFuJDlFLY=;43Hm3a7/Zzg2fw/uTjqH/VN/YJd
 vk5kvNmvHjq+muvIRuShn/lytb6qGNihPYbExLlD33BQAfuFI9/MGXzbtmn7yMyyjdT8/hxMD
 gqzmGXH32GKLTFAzEnRS1C2Om6ELjSEoyRQslglMn7bKGpG/eTptkksBT4GTBq0qOVx/e57jv
 /l1fKSVBCBTmWI2OSdNHQEklxRxnO8xP1WNoySr7gKySkk3fJqsUZDHKXiYzIDpjivvSb4vPp
 OXE8oU1mSw1i3OkqFgvuvoU3oHc9Ir27xrzMHxB+TAiIw5nJXdSVzJRO/Kq2H6hh1J5q8MpLH
 heV/fnPFlv+PEICG2XpUZzzyveW8XR3OBjCvoPVu9/J2/jT/WMtIsxm08qSS1A9h6Of8qFRir
 Bmrka0kj2HETm5NZrrQHoRU9eKPnmS06yjwTgaByXq6qz7Tg0fEpiZ9J/rNN+YrpvAimLOHlf
 4/kLoRvDqdUIJ2NDEuap+Cv1AESiLRVfMAGu9kBG5+zGU1KnWjX+VDJc23QWwV7vDfOsMrzt+
 aou+o5+x+pEgPKn9xYDZ36cigkz2TPREDa+3fnKMiRKkejRQSAELxRihpNFPjLHoJCA3j9/Y7
 kqHNOdaPld1KzN8iphSuXSQatscaXxNmVnENn1jNQqcGu8Gr/VEdGtGnnLhms6LEGNCgmi8cN
 04AOqnlfkXs1/kfErl8FLd/UMAZA1QSn/kEHGV4p0IWQTalAUlTXCysIsAc+/cRK9ul+lVBuc
 3rX48Z2oJWwL8SZu34dPLl00vKL9LB572DPfsC435XGJweEk3bHFZFcbBGd/6eHKXYJqMvNO3
 s7jbreh/b2ZbnbLC61DRPrBRHVH1G8PekUeJ2RXviKSIwvPgg/UzOvLNNAXpViIyelgyFUg+K
 cZQWC6CN3eigW4uDLx/N32jLORVlOhkjs4CUywXkW+w3hjUhq1h5EGs7BMIV4C3rcPsGLQgVv
 pfCXBXAaAm6DEzse2hDnGAXt3+24lAEH3PtoMf05v9D7bt6x4/5auAueaWAxHr2Y37/gQp2+G
 KGoXVFVlYJoq81KpA4J7IiM0SjHVem6kqa1fX1ywDFGbAp2bcCgCKVW+rIbh5NLs3Urw2v3E/
 WROhUynDxpn60ygWw0oukAJDz8c7vRvUG+2R3SOzHARQN3vIXqumzLmQ6FyO2wDLKdw30dq6M
 dtMq1IAiupOUQhjxEFXTGtE/H08qkQ8fioUkgiGEWr1SBXp5R81z1FUU7q/7759S/opsgat93
 bNiPNzlD8HYyaFiHLocKpFJQ0JGsiTEgEW3TfIS4jpKJxJOPy8WI+5YsRLxavk3ssEV9T34ko
 shbCfvohkjmNm4AC3N6hNHliH8Ygvl5viphKWMwdHYYomPGejjuWRZ75UcY5x2ylvNmEQOdjd
 Qm0GaiqJfu+AFaxtrBsgi4hxYOtKDkZk0jW7Pemx+qSgNf+QAGSHVwUirUbfYTwJ2KE0/cycD
 qtsNK9A==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Mar 2025 11:24:52 +0100

Reduce nested max() calls by a single max3() call in this
function implementation.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/xfs/scrub/repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3b5288d3ef4e..6b23a3943907 100644
=2D-- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -382,7 +382,7 @@ xrep_calc_ag_resblks(
 			refcbt_sz);
 	xfs_perag_put(pag);

-	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
+	return max3(bnobt_sz, inobt_sz, max(rmapbt_sz, refcbt_sz));
 }

 #ifdef CONFIG_XFS_RT
=2D-
2.48.1

