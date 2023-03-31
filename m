Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E29C761A6
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Mar 2023 22:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjCaWmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCaWms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2023 18:42:48 -0400
X-Greylist: delayed 461 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 31 Mar 2023 15:42:47 PDT
Received: from mta.karlsbakk.net (mta.karlsbakk.net [5.183.95.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8609320C32
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2023 15:42:47 -0700 (PDT)
Received: from mta.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by mta.karlsbakk.net (Proxmox) with ESMTP id 53D9F211F5
        for <linux-xfs@vger.kernel.org>; Sat,  1 Apr 2023 00:35:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
         h=cc:content-transfer-encoding:content-type:content-type:date
        :from:from:message-id:mime-version:reply-to:subject:subject:to
        :to; s=sausages; bh=y+5DKlJ+XcHpwKq6ZucXYnQVVpngzqLZ6MMOlGfPyW0=; b=
        D/DMgipjwtrU8L809s/AE0y90gQv2CeOgbgDvPMtX7Wp6PkEzv0CAr6Wgtaay9X+
        ELEQRyn31L57kxjonkjcBqWPVnlNcGFl2n0S8g2DJNfIK4+ukBNmfsv0lUDi1iTV
        EXDWNKFjLUkOhYvc+kQhaYK0DsrQiobo8LwrZZsvgZkI2zQ472PzI8j6hFNvAGnd
        LL8T/i+zDXbwBVdx8fB/moP7gcqqvMc/+US/A/WYv5Iv3yeSlxqFMsPUjvVzoPxq
        zMP4cjXrGE0LBELtWSVAorpN6aedWQmh/zZmR0b+kN4yC29cL0JzaHc6EB7G0MAf
        e7stNZscom7L3njgwAiu4tbe1LynDTkfPD5ads9ILW+LhLqmtDYJOoNE/IVkM0SW
        myOYA2ODyqqyjn8GyW8o5AK7UVdymKTAbFHWB29deVHwDJ1uESLkFD3D7vW7pxbu
        b22vSBIp2sXw8HE84xqOqksNPf4pzrpIQkKnub/bpLW/rj7ic5XDBw+OapGZJLLf
        l8NVCgyShIXPK3h0mNAVQJLlqU8fHHttMCdDs3bkXtbkYZEDY7UJkkQWvcTOX9UU
        l6rJJAzc4lY5Wx3Atq1GSTglKzuPz8YEMGMDyxOvw58qWgZ9AGlJd8Z7qDSMLBDg
        zXkPUBTa27k45Do/weZ6RczXhYUVV/GN1ZO8MR8Rup+nX2j9v0KVapN0S7wsxH21
        ihvWpUEzh+wdrs0KGV+Ux25kVv6iXOKMwlSjvTq676xPrSQQReGIikg1yw1KAXKe
        PkiSSBteg81f6nNG1PECOKCHJHSXFI2XQHyFoVRr6cKE2kEBbj9ghhHGNWMKyiUb
        TG5wHuXE6hZpxJNl5JoWM7yHvLUj42RMLj/Mf9ttvLljxMSLb4B4Hi6P+eqKy/VV
        Ayn/qpNX4dmuWKuiZPda5yiTddKagYZmW7oSVdRqegLmWKHnaOXS3NZMlTZ2k+eP
        uou0P94gGZ+r9NlAG/k07Qpq0QzCdkCSsYKqsmDHZbCElrQQdoICGRidLanyInso
        Rmt0IuiWcjZUBJxW44vE2rx6S82n/pgWdxq9KhI5Yf53/RFac1d+ej8PJN5+bNQV
        SfyAzGXhKZ9DhuDQhxbXZPwr1e9vueJ2Nn05vofLv2zyAmnnTQVAHyCFeZRAXAhX
        sQLsYkdIl4FoYJFBlcGJE47q2m0zpeu3CcKZQzbOsYzyqQJdv68C6RdrBAapZ+eC
        H53lHbMIz8Ms9K/pNtzglpp/ru9i7Q/uaexWsGMp+MHBkLSiXBWCwip7O0yyKiGr
        /d3Aj0IiddaFvA2YMXOCnT+5WDLKa5jlPx0BN06dt+OxWU1MXODn2pC2hOwQVWJR
        0i/ECr5d4Tj+XLBWPiJVRQ==
Received: from mail.karlsbakk.net (mail.karlsbakk.net [IPv6:2001:1608:1b:ac::2])
        by mta.karlsbakk.net (Proxmox) with ESMTP id C89C9207AD
        for <linux-xfs@vger.kernel.org>; Sat,  1 Apr 2023 00:35:01 +0200 (CEST)
Received: from mail.karlsbakk.net ([::1])
        by mail.karlsbakk.net with ESMTPA
        id NborMBVgJ2TX6AIAVNCnFw
        (envelope-from <roy@karlsbakk.net>)
        for <linux-xfs@vger.kernel.org>; Sat, 01 Apr 2023 00:35:01 +0200
MIME-Version: 1.0
Date:   Sat, 01 Apr 2023 00:35:01 +0200
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     linux-xfs@vger.kernel.org
Subject: Shrink support?
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <e19e642a3b5faeccf51db4e04bc845d6@karlsbakk.net>
X-Sender: roy@karlsbakk.net
Organization: Roys rare rot
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all

Was it something I was dreaming or was there shrink support coming to 
XFS?

roy

