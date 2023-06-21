Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AA3EB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Jun 2023 10:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjFUKzm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 06:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbjFUKzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 06:55:31 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC3CE6C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 03:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1687344927; x=1687949727; i=polynomial-c@gmx.de;
 bh=NN+hm0r49N6ZMzvFjfSk5sjCyNbRJuuzgUWO1fJZmw8=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
 b=jHtpjZ3H52WSlBX9F7TUq6VWVHnzLbUrg+Fh94s1fMYlYhVs7+rpv19J8QybxagMhMKN7qK
 bamh03pacSqEKAhNPK+0awrFnd8t4FiEcNzmAN1Ahlvg5nQyEfbRxYOgs6dkVjugHUt9nex1S
 mkRxyT1rTH0VdjVo4Emg6sYE+OMJ6sbzlI9PSv3G0BpsDM4c0pGU/Gz2I0heT5f8QlUGl6JPo
 fR6Bswb2X0pxlIifDEzsSK2czN0bb4KJBwzP7fALU7cijHARN6/q4nBiYlEYjWGCisBL774Kw
 OyAa2X0Ww6TMBZh8tEKXtw66wpeJhlk78gE/CG4p30QjtT7QGK2g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([79.234.209.71]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MoO2E-1pjDWA46mW-00oq02; Wed, 21
 Jun 2023 12:55:27 +0200
From:   Lars Wendler <polynomial-c@gmx.de>
To:     linux-xfs@vger.kernel.org
Cc:     Lars Wendler <polynomial-c@gmx.de>
Subject: [PATCH] po/de.po: Fix possible typo which makes gettext-0.22 unhappy
Date:   Wed, 21 Jun 2023 12:55:20 +0200
Message-ID: <20230621105520.17560-1-polynomial-c@gmx.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hGOMC8WryVmjV1LOrY2msxCw/Fh0X86bsPB+NxR6e7lJfmlkGww
 AEfPWYfQBUe07B7Wt8tMASPjRPbzqAVtKwjUDMkrVdxsxJqQsaIZaNYasRxn6jrE4KeEkt1
 IuPKWc+x9lxuHj/IpfXG1fPYXOc2OpqIUoFRwT/sONoLQmjsRa3XMI4b5thx2vwuoHas4xb
 z8gRdNYamSJHe7jTbIXEg==
UI-OutboundReport: notjunk:1;M01:P0:7DNnCPGcUIs=;B8Asoktrdfw+VANZ4Is2Lj9/ZY9
 KI2oGucgbFk+z0Qmp1GVxhPSmh7qxovoeZXmaMAUNfaorgxjaYlWo1IBbQrX9+AgemiiyTxcN
 PuhHkjxS+LN/n/srCHKPoo3THQMOtuSc3gi49rNF7uL/yuZjP9h2EEU/C4/aSXDHuuHfoCPS8
 m6vPQ2aDTI39EYQ2UrO3g415Cp1sLwPicUKkreAinGy4g6+fu2/4/Vn6ArY6rIAs1JSSEpYnL
 A1bC9IyZwZ9hAceULf286o20rZ6gtU400uDDZ+2mXQTWSaTPaH9Lr+YFjwjKye6vz+kF6HWG9
 KEf3x5vWtaFyGEJ0aHfNGC/gT3A5KTJqIj6narhzRYZ3vXxoztAnjX9Llj5L3U1pkqAa28pkr
 6jtAkxFoUd0yhaDQAAS+rMQKYE9vNxdahHOTB6VlVS7m4KrQdROPx2u6fQbMmY7XdNCdsU/WC
 SLpEJljJyt+BEaAeKOfFNkyWDKz7KSw20XjAJmeZWB7s5xH3itUNCDX2solm7etPPLNjzm0ah
 u9Fd8bZPhke4UQYp7PVlJ1R5FYwQu76fvCKM8R/PDbZUnJMztVbs71z+eUGGL+UTz8d8TdY4u
 0b92QsUD3C1WW2dfWa8g5QdYOgmQm0W8iQuFTfqShGV/sKQhaA2gvGjQRn/LkLbXVxz06dizU
 CdQf0tdyuyTqe8n3RGxGd3BdzA/B3QBRXgayB2R/S686r4grJ7b1ieITfly46hQI7cLNHjfXy
 BiX9hFzBDMn/JHL72VwCrfKZ4/2EC3d+hcwUV9gGjjUVWnJ8n5iFFnbJiZijt+AJHYxW5AW2w
 7fqbFD8MwKgm4eS7x7uHwuanIUyAjgKE8rkLcUK9+PIOFgJngdhNGzChiuLlehIyNpAOQDL1V
 6+ylgYSUZ5v9eoj9llijPOsycd87XSZIAWkejyp3JIqOtHY94fhHCsYv1WbgZ5fkyKyVurAWo
 /nvEH7ZtCwF/HSPnU3O2iZMXpwY=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

See downstream bug report: https://bugs.gentoo.org/908864

Signed-off-by: Lars Wendler <polynomial-c@gmx.de>
=2D--
 po/de.po | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/po/de.po b/po/de.po
index 944b0e91..a6f8fde1 100644
=2D-- a/po/de.po
+++ b/po/de.po
@@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
 #: .././estimate/xfs_estimate.c:191
 #, c-format
 msgid "%s will take about %.1f megabytes\n"
-msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
+msgstr "%s wird etwa %.1f Megabytes einnehmen\n"

 #: .././estimate/xfs_estimate.c:198
 #, c-format
=2D-
2.41.0

