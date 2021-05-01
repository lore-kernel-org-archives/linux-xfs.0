Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71DFC433B4
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 16:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82534613F0
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 16:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhEAQbL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 May 2021 12:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhEAQbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 May 2021 12:31:09 -0400
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9875AC06174A
        for <linux-xfs@vger.kernel.org>; Sat,  1 May 2021 09:30:19 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id ABC663C032B;
        Sat,  1 May 2021 18:30:17 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id T8anpIMqUL6o; Sat,  1 May 2021 18:30:16 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 61BCD3C0334;
        Sat,  1 May 2021 18:30:16 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net 61BCD3C0334
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1619886616;
        bh=0PNGewK9YqvlkmUehO0fu73SqKgyfVgZMVKO2eMuz/Q=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=FjXMTGCvozihwKPSBavt03GwKYhcLvxEJ/4lTP2aJFWdBSK8aWmFyy5ibM+EBSFKR
         AGHVtSsMcPDIiSgkACTeA9eoed8Ek1fPKhBsDL46mxMiVh1x/vSPOne6YqOsMnoUxS
         vRISorLc1lppdCNh8waQloaBn4lyoEnIV/tEkf3hc/5NB08KY4hXJ2L0ZbJ83K8YPn
         l0Xt9+4Jo6GTzF4pXhOCme5lWwy8xsRs33m8sUiAJr4ZQ+3h/BcHUB1vTIHCe06QvQ
         fMkIF6351O44O7da7jALw6n3ZvpWnhaKBTXSmfh03h7rodd0qTX5bsYWpS5EzfDiZi
         vAvTOXeMgUvkQ==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 6rgawsQABx1r; Sat,  1 May 2021 18:30:16 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 379043C032B;
        Sat,  1 May 2021 18:30:16 +0200 (CEST)
Date:   Sat, 1 May 2021 18:30:16 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Message-ID: <42077743.2937447.1619886616032.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <20210501162319.GA1804@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210429160243.GD547183@magnolia> <65965754.2791270.1619869406755.JavaMail.zimbra@karlsbakk.net> <20210501162319.GA1804@hsiangkao-HP-ZHAN-66-Pro-G1>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to d4f74e162d23
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:700:700:403::a:1031]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF88 (Mac)/8.8.10_GA_3786)
Thread-Topic: xfs-linux: for-next updated to d4f74e162d23
Thread-Index: g5pgZacbzpLfV7w2aBDiGa0AwiHXOA==
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>> hm=E2=80=A6 xfs_ag_shrink_space
>>=20
>> does this mean xfs shrinking is getting closer to reality?
>>=20
>=20
> Currently it has supported shrinking empty space of the tail AG.
> For shrinking the entire empty AGs, the main discussion is still how to
> deactivate AGs gracefully.

Thanks for the update.

Best regards (and happy May 1th)

roy
--=20
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.

