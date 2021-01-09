Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DF0C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 21:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 473F423AC4
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 21:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbhAIVDr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 16:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbhAIVDq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 16:03:46 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80241C061786
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 13:03:06 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kyLO5-0000i3-6D; Sat, 09 Jan 2021 21:03:05 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#976683: RFS: xfsprogs/5.10.0-0.1 [NMU] -- Utilities for managing the XFS filesystem
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          976683@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 976683
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 976683-submit@bugs.debian.org id=B976683.16102261242334
          (code B ref 976683); Sat, 09 Jan 2021 21:03:03 +0000
Received: (at 976683) by bugs.debian.org; 9 Jan 2021 21:02:04 +0000
Received: from mail-ej1-x631.google.com ([2a00:1450:4864:20::631]:32861)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1kyLN6-0000ah-HS
        for 976683@bugs.debian.org; Sat, 09 Jan 2021 21:02:04 +0000
Received: by mail-ej1-x631.google.com with SMTP id b9so19385994ejy.0
        for <976683@bugs.debian.org>; Sat, 09 Jan 2021 13:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:subject:from:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=q9qg1UTc90GXClfkl6BD+4416sM00brFEnYEZ2SxuDw=;
        b=xKl+x24MOJKdN8df8CsFmwdWJzhu5mExA2WKZs4sRtgvUKzCVVuNkQggK55UJ4vWAs
         GCcr7fwex29WIXzrOSf50PdH+U0N/3p8sxP0Elx6ed268QdwyU9hG3sDnTDsE5M4GDU9
         T0Q0iQPgJT7KGSe0aoNcnlBfrBEgdw/IyM86TXiVbd/n7kVcvw0gHhz2LSQGFGjZkHlY
         4HZaGwdz4YEkwHIPxrJGGHcYG2CyUljigVdIuqhN26rQ6OI9R8Vwgtgfbf8FiaN4UYj8
         zgiDqEb/9IuRhsBDOPRDNUken59DF0N9BCgtEh1Q8sodkLNbvjjKxU5/z3VxXj2g8RGs
         IXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:subject:from:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=q9qg1UTc90GXClfkl6BD+4416sM00brFEnYEZ2SxuDw=;
        b=aBPCpOmBIllVrTlPj+2myR5TUM9ppufqb2eYv2ZIyMq0zcPBUt6Ixj9ty/J7YA2X76
         o38ft2rtvU2xTEPWtfIWHTPSv6ptLaedO86Bf+2LXBtIljOon9zsnuSqkUJOmKVE2icU
         JLHZG8EcDJhKBeERjcHXYFWV2JwgdqbtGyWQyQrBx31aDQ6eL5KU8vNISbzBpTez7pjC
         v8/g9D43ncYJzyxi4OXiFdimuBhj/wyYoX70gc7ThexUNcqjv2fqmCGDy6/USqgameiJ
         MnwlPG1MRuWuhmruDoIKH7ntAUHRTUQ7vOJXzPkcL8307piS4hvBnoXFdGAFRXbVpWjX
         4u8w==
X-Gm-Message-State: AOAM5308ZF0iYkDqK1t0ErCVt7FtE1ryY//wsg8KKhPkEj5yQITqTe2W
        R76px0CKJpmWmcx2tzJc8iRte5ZquslZ+uZw
X-Google-Smtp-Source: ABdhPJyRhgTflq79aIdx073p650Pn7XXWjAs4Ti2+5oTALBamm1xocZRBPdWfQ8mHYzQitmyCTOSpg==
X-Received: by 2002:a17:906:fa12:: with SMTP id lo18mr6705029ejb.354.1610226120110;
        Sat, 09 Jan 2021 13:02:00 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id i24sm5004788ejx.31.2021.01.09.13.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 13:01:59 -0800 (PST)
To:     submit@bugs.debian.org, 976683@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <fff77770-2496-0c1e-3849-bc1acc492725@fishpost.de>
Date:   Sat, 9 Jan 2021 22:01:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Package: sponsorship-requests
Severity: normal

Dear mentors,

I am looking for a sponsor for the package "xfsprogs" which was not 
updated for several major releases:

  * Package name    : xfsprogs
    Version         : 5.10.0-0.1
  * URL             : https://xfs.wiki.kernel.org/
  * License         : GPL-2, LGPL-2.1
    Section         : admin

It builds those binary packages:

   xfsprogs-udeb - A stripped-down version of xfsprogs
   xfslibs-dev - XFS filesystem-specific static libraries and headers
   xfsprogs - Utilities for managing the XFS filesystem

To access further information about this package, please visit the 
following URL:

   https://mentors.debian.net/package/xfsprogs/

Alternatively, one can download the package with dget using this command:

   dget -x 
https://mentors.debian.net/debian/pool/main/x/xfsprogs/xfsprogs_5.10.0-0.1.dsc

Changes since the last upload:

  xfsprogs (5.10.0-0.1) unstable; urgency=medium
  .
    [ Bastian Germann ]
    * Non-maintainer upload.
    * Cryptographically verify upstream tarball (Closes: #979644)
    * New upstream version 5.10.0 (Closes: #976683)
    * Remove dependency on essential util-linux
    * d/copyright: Add missing info to machine-readable format (Closes: 
#979653)
  .
    [ Darrick J. Wong ]
    * Replace libreadline with libedit (Closes: #695875)
    * Add build dependency on libinih-dev

Regards,
Bastian
