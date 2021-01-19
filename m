Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD65DC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB83F22E01
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbhASW1z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728318AbhASW1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 17:27:49 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D16C061575
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 14:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=kKDpaxO0BSU0gtEIhUqpMGF8hl35agxqTFnwO22p330=; b=MyqmSUIJo6wVCLnWdk5mLDfzuS
        KfQHHmLh9jZc19Il/S/lCaXeBmMu1V/ltQ25RTjY7xbjlczaI9SEiIdGqzdke1uLhTi0wE9TxjMPn
        0vSlXCpWTnYw4g5/mTM52k1h8bjZnTJlKkCoYgaBGuuIJZVGEpO3fye4qNSqSLCOpv9tYIvOHzYGy
        EUr1dOvs+e9ISkO2JP3pRqhccrrkjo8IhXUxejfMshj20/S7xzFmWYm258/6MkrxAHyR5eqF+DdO0
        8S5nqJsJ4IcNEvIbeflRo2CpVd9zSJRutxYUQdnrLjYbi5E1ZKmOq2aLXX6GegDM2GYHN6wWAovee
        GRWe5fyg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l1zSu-0001fO-Fp; Tue, 19 Jan 2021 22:27:08 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#979653: marked as done (xfsprogs: Incomplete debian/copyright)
Message-ID: <handler.979653.D979653.16110950475319.ackdone@bugs.debian.org>
References: <E1l1zPx-0005hZ-D4@fasolo.debian.org>
 <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
X-Debian-PR-Message: closed 979653
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
Reply-To: 979653@bugs.debian.org
Date:   Tue, 19 Jan 2021 22:27:08 +0000
Content-Type: multipart/mixed; boundary="----------=_1611095228-6401-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1611095228-6401-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 19 Jan 2021 22:24:05 +0000
with message-id <E1l1zPx-0005hZ-D4@fasolo.debian.org>
and subject line Bug#979653: fixed in xfsprogs 5.10.0-2
has caused the Debian Bug report #979653,
regarding xfsprogs: Incomplete debian/copyright
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
979653: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D979653
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1611095228-6401-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 9 Jan 2021 18:31:56 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 17; hammy, 135; neutral, 27; spammy,
	3. spammytokens:0.939-+--LLC, 0.907-+--individuals, 0.858-+--llc
	hammytokens:0.000-+--H*r:TLS1_3, 0.000-+--H*u:78.0,
	0.000-+--UD:gappssmtp.com, 0.000-+--UD:20150623.gappssmtp.com,
	0.000-+--H*RU:2003
Return-path: <bastiangermann@fishpost.de>
Received: from mail-wm1-x335.google.com ([2a00:1450:4864:20::335]:37957)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1kyJ1o-0007Hy-I5
	for submit@bugs.debian.org; Sat, 09 Jan 2021 18:31:56 +0000
Received: by mail-wm1-x335.google.com with SMTP id g185so11215579wmf.3
        for <submit@bugs.debian.org>; Sat, 09 Jan 2021 10:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=0NUxVuxgIw8FauR2KUBGGh7FCGSIfYyIyshf9OniEIs=;
        b=VqdndagAJh2cB6aENO1K4t/CbriiMi4XCg7q0z2YYRThM8mXiugPg3OtOUzEZdF4ay
         +PFS/fGF4+9uqMvIp6XUyrOVL2T6oFuA6cR87kt4BCs4tJQjNrJrmNbx2EPo4FpO3B4a
         KIxuSfVVlhh2REvVaEHNhgkNafpSrJM8rKe4saEAlMsjsHnMJAtPvrlYO3zVMJNKTkrM
         12WwJSqqfQDnvVzl7PKxX6K9ey1eRGl0aHCJE1B0+43jakUsurbkt8DNsOGAM0gk7yD/
         1OGmlk1QSxRDB98hQ7M8hHDDegmfE/u6DQNEJYaHGaBY2GJWFNTqyiqnIkNhIjsH/kB9
         5sjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0NUxVuxgIw8FauR2KUBGGh7FCGSIfYyIyshf9OniEIs=;
        b=V086CYeFAwGQpYTj/EDHr/upfTs5qPuAfN7En2fPZtbvTLaehjQ8q1j0LN5+E261sV
         LuuXGdLji/iMG5TJFY38/+GM08UcGR4TDa36K4dQBarGQZtwAdWWiDNyqo5b5ZwYAqGW
         hOB9XbbBHd+mPIu6bflNMo71IgmA0Xgn/jlgMF4IolvQmQnKueqpNotLXDdK5VaOL+Z3
         QVjcotBOQ684KyQQBiy5NT2tMl+LlPsI+LjwZhPRggp0aSa2SSDK/6ag4Ajx20sacKWx
         hdGXyCSbXIYzTO51uBxEkFAEt4j6BGcUaM8ZnL9OjxAltbbhsn5H7hl2iCJOuM/KoalD
         CfSw==
X-Gm-Message-State: AOAM533G8fWFUUhtM8KwTG67BleKrJrFjkrGfl6kw1PLrz/OLMVZc9+a
	us3VsyTHlbzfWuyxfjv5/pwkQB/OysSKIW1Z
X-Google-Smtp-Source: ABdhPJwJWS+9RGcI+vHoGXSTrUu0nYMfcRz5yT8hXBQqkc4YFn0tQZiTptxvzKeWDAtOBWp57b49Vg==
X-Received: by 2002:a1c:356:: with SMTP id 83mr8349153wmd.31.1610217112547;
        Sat, 09 Jan 2021 10:31:52 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id t188sm15991436wmf.9.2021.01.09.10.31.51
        for <submit@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 10:31:52 -0800 (PST)
To: submit@bugs.debian.org
From: Bastian Germann <bastiangermann@fishpost.de>
Subject: xfsprogs: Incomplete debian/copyright
Message-ID: <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
Date: Sat, 9 Jan 2021 19:31:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Delivered-To: submit@bugs.debian.org

Source: xfsprogs
Version: xfsprogs/5.6.0-1
Severity: important

xfsprogs' debian/copyright only mentions Silicon Graphics, Inc.'s 
copyright. There are other copyright holders, e.g. Oracle, Red Hat, 
Google LLC, and several individuals. Please provide a complete copyright 
file and convert it to the machine-readable format.

------------=_1611095228-6401-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 979653-close) by bugs.debian.org; 19 Jan 2021 22:24:07 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FOURLA,FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,MD5_SHA1_SUM,PGPSIGNATURE,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 99; hammy, 150; neutral, 137; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from mailly.debian.org ([2001:41b8:202:deb:6564:a62:52c3:4b72]:57066)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=mailly.debian.org,EMAIL=hostmaster@mailly.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l1zPz-0001NN-Rj
	for 979653-close@bugs.debian.org; Tue, 19 Jan 2021 22:24:07 +0000
Received: from fasolo.debian.org ([138.16.160.17]:42982)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l1zPy-0002jp-CE; Tue, 19 Jan 2021 22:24:06 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l1zPx-0005hZ-D4; Tue, 19 Jan 2021 22:24:05 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Reply-To: Bastian Germann <bastiangermann@fishpost.de>
To: 979653-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#979653: fixed in xfsprogs 5.10.0-2
Message-Id: <E1l1zPx-0005hZ-D4@fasolo.debian.org>
Date: Tue, 19 Jan 2021 22:24:05 +0000
X-CrossAssassin-Score: 2

Source: xfsprogs
Source-Version: 5.10.0-2
Done: Bastian Germann <bastiangermann@fishpost.de>

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 979653@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Bastian Germann <bastiangermann@fishpost.de> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@ftp-master.debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Thu, 14 Jan 2021 18:59:14 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-2
Distribution: unstable
Urgency: low
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 979644 979653
Changes:
 xfsprogs (5.10.0-2) unstable; urgency=low
 .
   * Team upload
   * debian: cryptographically verify upstream tarball (Closes: #979644)
   * debian: remove dependency on essential util-linux
   * debian: remove "Priority: extra"
   * debian: use Package-Type over its predecessor
   * debian: add missing copyright info (Closes: #979653)
Checksums-Sha1:
 9c7923ea5735242a29b8481cbd38059c850433b9 2034 xfsprogs_5.10.0-2.dsc
 9e5cbf9b3a561c3b9b391f0b1330bcb4b3537d38 1273332 xfsprogs_5.10.0.orig.tar.xz
 7240aa6c2fb907b9f1aeec8ae6d19fb8c62c1585 13792 xfsprogs_5.10.0-2.debian.tar.xz
 87001ed58e1229bb8b9c7cc4348b5e07646675ef 6593 xfsprogs_5.10.0-2_source.buildinfo
Checksums-Sha256:
 d4b995161ecfc754895c3a91931db9787fffc924fbc2a5cd51abb11a28ac1522 2034 xfsprogs_5.10.0-2.dsc
 e04017e46d43e4d54b9a560fd7cea922520f8f6ef882404969d20cd4e5c790e9 1273332 xfsprogs_5.10.0.orig.tar.xz
 3f144a529ec274ffd720ad70c347b294c9a787868b2119ecacbf0c16bcb642f1 13792 xfsprogs_5.10.0-2.debian.tar.xz
 a022f266d04946b600fdb12815a4197d4dbb70ae8bfe92e5c682803bba9ac42d 6593 xfsprogs_5.10.0-2_source.buildinfo
Files:
 49fad22f902144635cd5a7c06de1fb1e 2034 admin optional xfsprogs_5.10.0-2.dsc
 f4156af67a0e247833be88efaa2869f9 1273332 admin optional xfsprogs_5.10.0.orig.tar.xz
 6bb054391ad11b6d23d883a907e099be 13792 admin optional xfsprogs_5.10.0-2.debian.tar.xz
 853ed7390e20376455676cf65ba4137d 6593 admin optional xfsprogs_5.10.0-2_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAHV+cbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMUZCIL+wXFyjxnBr2VGlTj+BVU
taQwxuvEZoFwxvNwZ4Z5s38FBi6DzPWLF2jxCv4M0UTOpDPstg5WXebhfOnOdp4D
0WW8G39jMIB2J+b0OQEGcMKdwuXKYKfDdBdOa+lesUoUU8AZEazS/whzMa7FD7wB
/av/28PvYdWFK/ddERfujPIa6BtoIE2QszggOCHqCbUt3egQLCTxA+2qPR+f5Nrs
VT/xgDrkkHC9ypkU8kypv4XhetHKwwxDyp+4PLja0OSnuH6/KzmiV8gI/Hq4Y4/l
lYzXiWWjz5ofEHc3haGxqsKxabyRT6h31INdxfKjFhnFVrEyh3l+KjJL4AXcn8wH
fB/DL2uquJkWBJ+N7xD/UYvDylwNaqnkyYOMCy+JyKE1lJZv5AfAGlsZ3VAnOeGT
Rn8e7XF+4lPWsckPZ+YZWqGDmLbRxAeg5xGQ2iFKFPfwq0grKjARF+33JWkHR3Jk
O/MWldWzIuogu77fsZbPlRPgG7dj8eA2pjscQJOXo/yb6g==
=IDLF
-----END PGP SIGNATURE-----
------------=_1611095228-6401-0--
