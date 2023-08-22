Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89697EE49A3
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 02:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjHWCyE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 22:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjHWCyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2023 22:54:02 -0400
X-Greylist: delayed 903 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 19:53:57 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D601A5
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 19:53:56 -0700 (PDT)
X-AuditID: cb7c291e-055ff70000002aeb-fc-64e55c5587c2
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 3F.D7.10987.55C55E46; Wed, 23 Aug 2023 06:09:42 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=URMXjhjlr4K2A5DWfefBJ/vgnSJbdAD2QAzBPhPIKCTqStwfqPsur2DHR78N/ObY/
          hfeollRwh2F6CtEWMMNYK5ju6KDuukD0NCuePcczBETvvI3AEGgn4DCIH1xkxKb3D
          0CcL2RFdhFbXYir5Haz3MP6t+Cral+o4gryxkqbFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=Q3r3WU9LX7Ydee8XJll4V9HE0gOCtKKYJC1+Bjiv1ZRpQXFDs2BuFEmLTQkPFaKhL
          cdHBceR6tGMQlSolirvWRsa+YPj8i/n8SnhXeegAml64AW4PMUbbbFANg9uk3U/Y+
          Fl4GACwHE8nIvz83vSmn5POw1eV+uRXlx+89aNu8o=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:31:09 +0500
Message-ID: <3F.D7.10987.55C55E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-xfs@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:23 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVyyUKGWzcs5mmKQeNGJotdf3awOzB6fN4k
        F8AYxWWTkpqTWZZapG+XwJWxZN0FloLdzBVt/YtYGhgfM3UxcnBICJhINLyK6GLk4hAS2MMk
        caF5GjuIwyKwmlli5oZ5LBDOQ2aJOW/fMHYxcgKVNTNKnD9qBmLzClhLbJ65nRnEZhbQk7gx
        dQobRFxQ4uTMJywQcW2JZQtfM4NsYxZQk/jaVQISFhYQk/g0bRk7iC0iICsxaeUpsPFsAvoS
        K742g9ksAqoSjw/uZoFYKyWx8cp6tgmM/LOQbJuFZNssJNtmIWxbwMiyilGiuDI3ERhoySZ6
        yfm5xYklxXp5qSV6BdmbGIFBeLpGU24H49JLiYcYBTgYlXh4f657kiLEmlgG1HWIUYKDWUmE
        V/r7wxQh3pTEyqrUovz4otKc1OJDjNIcLErivLZCz5KFBNITS1KzU1MLUotgskwcnFINjKYP
        n87WDTvg/rjuumYP71qWDmuB7ws2/E3f9sU7V7imNO2hn6+FzOI1gRvUD9f9bt97N+zdK4n7
        98omBVvdUS53nde6q4b5U/iXAoZXK+bvbJ5prFzruOjzgk85HEcZ1rj2rvi5dc9LE9dfF185
        T7tYt/7jVN4ylaQJtWH+gluWtPa2Fdi8+qbEUpyRaKjFXFScCAAr4yATPgIAAA==
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China

