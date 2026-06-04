Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D2B299931;
	Thu,  4 Jun 2026 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780564865; cv=none; b=dM5J0N9pwafxPtBkusdyEEK/PopwjBCurkjZrYqV/yHuATI6zjGjixDNW3AJUxug+tyisIltQ8BekhLBg4ejiKuhCdhXBB2RYe8aKzuWj8kPpnZtmB82ocl0XfYz7DXxpRUzq5WKO74wfrFKav+ks56QkAJQ4B3/ISjJgWvosKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780564865; c=relaxed/simple;
	bh=GdOew+tYHtQ5Hcu2NWMfqH5/ep5H9fCijwne8QJ2pPI=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=kk6F+fI5aQ0We8rzgb+70kH/lasPIiAuX7UNg09OCGMIx1u+167vMIg8Z+iJ/3wPuEHyrnb5HwdQtMpPNG9evrJLxD1gJi5/8lfrozAog+YXqc28B5MG29J2UuqQ1PJTr+VXmn77hyzbwwN0UJiCtOsTahYFB2QNH+wActHpI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=X8EmY728; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="X8EmY728"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1780564857; x=1781169657; i=markus.elfring@web.de;
	bh=50b+ig6q8ovEDpNTzNYDDc5vKohbSlPP3u/KUTRnGyA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=X8EmY728WcdfNdZkak24FwU9Y15maiDkpdRkKLphIqwfY8TElFNZKhKd0/9Cagyu
	 5FZSx+OE0rQm2ZrtPFiVB8CXM47Sm08G01c57k6BcM8njGeH0OnQRLVFEnNl2NN79
	 wymhgg6aOrK6cY5XvTbtTaC+gpoE6n2637K1SJWjSCoSskj4vp8REhkVDT3pThluD
	 PzqMSXCuXdfIOo4ytdQEe6YXqytOFT2m4SKnfa4laIw+DCus5/CXPY4NeoTDm6ii1
	 xMVnQk+vE7PZ04OFjuG9JrLuCF6PyRlqIhjx/mz7hdBYhihSwmH95TgNDVWDS6xlH
	 syFWZ+KP6LEcAfqOAg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MALiL-1wOmaQ3JrX-002jJv; Thu, 04
 Jun 2026 11:20:57 +0200
Message-ID: <995bacb6-881a-4fa0-b2c8-190882522f54@web.de>
Date: Thu, 4 Jun 2026 11:20:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] xfs: Simplify data output in xfs_zoned_show_stats()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jwklWPRX7/G79tC9BhhrEYITkJBJ0Q12XL2Llf6msvrdEy/lsIm
 NfBT2RuWrpMaZl2HLvhclEE38U0ph0oxantm5gvu2E/6KVLF+LSY/2uyvxfJX4B0Nz+Sn/7
 xGo7lipJPMs06CSvKcNKLSPiUPzZmR1qfg2ZVr1WAToUK597cIg3EBbyPaFkx9Sd7hL0rcd
 b9mbl5PCS9IqICWP5wHxw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bR9v9waIJ8M=;pl7IIer917m3ogrvCDNMZUPFmcF
 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
 zHUpiuUCpOQcIAAWcg=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 4 Jun 2026 11:16:01 +0200

Move the specification for a line break from a seq_puts() call
to a seq_printf() call.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/xfs/xfs_zone_info.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 47b475e21af8..57e3acabeee4 100644
=2D-- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -75,10 +75,8 @@ xfs_zoned_show_stats(
 	struct xfs_zone_info	*zi =3D mp->m_zone_info;
 	struct xfs_open_zone	*oz;
=20
-	seq_puts(m, "\n");
-
-	seq_printf(m, "\tuser free RT blocks: %lld\n",
-		xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
+	seq_printf(m, "\n\tuser free RT blocks: %lld\n",
+		   xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
 	seq_printf(m, "\treserved free RT blocks: %lld\n",
 		mp->m_free[XC_FREE_RTEXTENTS].res_avail);
 	seq_printf(m, "\tuser available RT blocks: %lld\n",
=2D-=20
2.54.0

