Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF14CEB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 05:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjFVFYG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 01:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjFVFYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 01:24:04 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD9B135
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1687411441; x=1688016241; i=polynomial-c@gmx.de;
 bh=xyn2tfNxKM48kr1wvhKrV4MJFb+9z9iHMjIUkRpcfNQ=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
 b=peJWCeLOrj4pCWZkkFK1GkQ/hv3GRzxAwjYzSfkUyLwUvN9ukmEhUcFKCzx+X3l2Aqchc5n
 STjHKaQm1HyjJKC9x/UXEQY5yOsQupEon8rJVPJslFIsxvlV9vpo2itHK62jrEJPxsjXYGZfO
 VfcbvzwX3xderiBI6GlJmWKjGElx87rs4edSnmZMNfTMDDsvjN57wY2oZgNys9nA0R/xARGjR
 1qr1P3WFolg4TGJXx9BWwidBkgg4pJp4GiIqgvq3f82ce8iaG9DXkxNSML28zrUQbnKozGUSC
 n6uwV/tVbDcu0iDuoUcQyQ+36G1N8xZVODgPoL/wv9pfGTb7/3xQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost ([79.234.209.71]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MxUnp-1prtrE0gkD-00xvZl; Thu, 22
 Jun 2023 07:24:01 +0200
From:   Lars Wendler <polynomial-c@gmx.de>
To:     linux-xfs@vger.kernel.org
Cc:     Lars Wendler <polynomial-c@gmx.de>
Subject: [PATCH] xfsprogs: po/de.po: Fix possible typo which makes gettext-0.22 unhappy
Date:   Thu, 22 Jun 2023 07:23:54 +0200
Message-ID: <20230622052354.12849-1-polynomial-c@gmx.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <ZJNyn817MpCB3nbr@dread.disaster.area>
References: <ZJNyn817MpCB3nbr@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HLDkp7+ENcS7k9exewVJ1X9efMKftmiVQGYGP+rGtF8E/+lnLeW
 zhfIAST/KyBS3NtnadI9m1xdSbkqb7sKKhFA6HwfnnAgJPwtnvm0CfDl25CD+pj+6D60lnH
 eDY6yfbSKTJdFAi+jCxe4hHn26UlsFDZI1jvlmSDS1yLLusbger++WA1ES/U0SIkjWaQIWG
 X5TlPf+1iO93NBTIryr2w==
UI-OutboundReport: notjunk:1;M01:P0:Zie9pfchsyk=;u2EMMhVv9/tdlNBNWEccCUYoxCD
 ULZKYcxFZtaVNnEWUNb4zljI/WGSZ+3nAJFfGYqA6JU78nqyDwlmGPQWDCVT8c6Qpr0ISnwLZ
 C6wCRVn8dQwW3nHHYWaDQdXnF1zMvFf9OgfQp+NZfzwGvNezMaTQcr8czZYLeylhv4KfrZBhf
 X8DBeoX0EIKyB8YZGEyD59c9h78S5d/LpemI2AuiLeQKeTkjbMbfFquHvt5ZSpVwDxza3lh62
 030xrSfraVcAw9uqp3A7a8+/rG59ePidVPonz0+a4AaFNr3kOL2UtkRtwxKS/Ox6iULSKMF3q
 qUTgh/tb/N40+mS8UZLKwFEmR2knLiAztFcRK4U796jLSPrt3FghQdmNMCCMsCxZ/1G/eqMhc
 s8UwSq08uqXEV4pFPCHPL8+ojNJ6s1V1E/VOqs7GwpMyTjOz5tagZx4aucJLrMSMX6z9HAnFg
 trxOtqhVJptu5On14YJv2ayaHCPb1mr0TeVGaXSbDiAgqt/vgTAKa4nRts9DoEIWPiFGoQjU/
 h7wGy50hntNuEU1iDkfp7EQjNPxa7doEa12BrwiAxWAcjkSqTRmx1hOnOmJSHQ0vaV3V0KdhA
 50H1kOoA8US9LbJCxZUM4Cz5WjdoBm/8ddV4k0Y+yliH9tlb5WoHtq+W2GDv/qKpSgrIAMEFA
 H5xzwsEsc6hmzKGnhxFM2HvKdarAJyPJK7Ig+yyndXNi3Ld4V6vkZm4gP25SRmmotkR+tp97H
 beAybYyhXO+/1z09Tu4wZCp8loty8RSgPF3SwIPkztU6RprBtFRynPk/31bvU5Pvitu8t2hyE
 e/W0EyVPhQ2cJ1BC7NhXgqGG9vwmv+F6wxpgXmQdhV1CMKvGXcOjMRY6XzTbbE7WE27UkWj9T
 VojgUpvZrMiIo3TLN0DCscAmTg2BxVQiv4H6s3RXY0R2OXk8nVyas7oRmyiUdzN1zP8M8/cIN
 sbangQrBBTXjQOuqat6yEMNFjZI=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The removed line contains "%.lf" with a lowercase letter L.
The added line contains "%.1f" where the lowercase letter L was replaced
with the digit 1.

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

