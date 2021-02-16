Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75CFC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C92C64D5D
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 12:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBPMvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 07:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhBPMvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Feb 2021 07:51:48 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E4FC061574
        for <linux-xfs@vger.kernel.org>; Tue, 16 Feb 2021 04:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=WB+8nAV2X3Ywa5a1IdZTYCbhkpUu23MpVCAxtRiGvso=; b=Kju9toPF8Rx1DmBuIms4qp5C1G
        LAqu15hcQjFMuqdPWU9N1BPrvbNVPUGckh697JNx7pXTLCX7Ua7mVifrcGNNrEFmAfEKr6NGHLJkY
        lHhs2HtXgxEjpy+RpCcD0i05S54v3wpczMxMupt/BL+feTE7QaMHE9h0siM9sQ/s0oHoKw+komem8
        ecTuBnDlJMyvwYqfzGo2cPCGlRtjRgusyKANEn6wpVyK9TIxdss4CC711Uevl00hWWzJ6yggK4hwW
        bCHHA2hZjvkU3F2rVJ4z0PrxCtnKTZBCGHDZpPV8UIMnrgO2ylov8/drekokqdbCPkCC45+IW1eza
        E8tmoJEg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1lBzom-0002dl-NP; Tue, 16 Feb 2021 12:51:04 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#981662: marked as done (xfsprogs-udeb depends on libinih1,
 not libinih1-udeb)
Message-ID: <handler.981662.D981662.16134797328803.ackdone@bugs.debian.org>
References: <E1lBzmc-000A5U-3j@fasolo.debian.org>
 <161228884604.31814.16098605757501286276.reportbug@tack.local>
X-Debian-PR-Message: closed 981662
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: d-i confirmed
X-Debian-PR-Source: xfsprogs
Reply-To: 981662@bugs.debian.org
Date:   Tue, 16 Feb 2021 12:51:04 +0000
Content-Type: multipart/mixed; boundary="----------=_1613479864-10107-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1613479864-10107-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 16 Feb 2021 12:48:50 +0000
with message-id <E1lBzmc-000A5U-3j@fasolo.debian.org>
and subject line Bug#981662: fixed in xfsprogs 5.10.0-4
has caused the Debian Bug report #981662,
regarding xfsprogs-udeb depends on libinih1, not libinih1-udeb
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
981662: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D981662
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1613479864-10107-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 2 Feb 2021 18:01:21 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FOURLA,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,TXREP,
	XMAILER_REPORTBUG,X_DEBBUGS_CC autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 13; hammy, 150; neutral, 83; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debbugs-Cc:sk:debian-,
	0.000-+--H*M:reportbug, 0.000-+--H*MI:reportbug, 0.000-+--H*UA:deb10u1,
	 0.000-+--sk:taint_o
Return-path: <steve@einval.com>
Received: from cheddar.halon.org.uk ([93.93.131.118]:51058)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <steve@einval.com>)
	id 1l6zzN-0005S9-3B
	for submit@bugs.debian.org; Tue, 02 Feb 2021 18:01:21 +0000
Received: from bsmtp by cheddar.halon.org.uk with local-bsmtp (Exim 4.92)
	(envelope-from <steve@einval.com>)
	id 1l6zzC-0002fA-C5; Tue, 02 Feb 2021 18:01:10 +0000
Received: from steve by tack.einval.org with local (Exim 4.92)
	(envelope-from <steve@einval.com>)
	id 1l6zyo-0000pY-1n; Tue, 02 Feb 2021 18:00:46 +0000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Steve McIntyre <steve@einval.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs-udeb depends on libinih1, not libinih1-udeb
Message-ID: <161228884604.31814.16098605757501286276.reportbug@tack.local>
X-Mailer: reportbug 7.5.3~deb10u1
Date: Tue, 02 Feb 2021 18:00:46 +0000
X-Debbugs-Cc: debian-boot@lists.debian.org
Delivered-To: submit@bugs.debian.org

Source: xfsprogs
Version: 5.10.0-2
Severity: serious
Tags: d-i

Hi folks,

It appears that the latest version of xfsprogs (5.10.0) has just grown
a dependency on libinih1, and there isn't a udeb version of libinih to
meet that dependency. This means that xfs support in d-i just
broke. When trying to create an XFS filesystem we now get:

Error msg: "The xfs file system creation in partition #4 of /dev/nvme0n1
failed".
When trying from 2nd console, there seems to be a lib missing:
mkfs.xfs /dev/nvme0n1p4
mkfs.xfs: error while loading shared libraries: libinih.so.1: cannot open
shared object file: No such file or directory

There currently is not a libinih1-udeb package; maybe that's the right
fix. I don't know xfsprogs well enough to know if there are other
options (e.g. maybe disabling the libinih1 dependency from the udeb
build).


-- System Information:
Debian Release: 10.7
  APT prefers stable-debug
  APT policy: (500, 'stable-debug'), (500, 'stable'), (500, 'oldstable')
Architecture: amd64 (x86_64)
Foreign Architectures: i386

Kernel: Linux 4.19.0-13-amd64 (SMP w/4 CPU cores)
Kernel taint flags: TAINT_OOT_MODULE, TAINT_UNSIGNED_MODULE
Locale: LANG=en_GB.UTF-8, LC_CTYPE=en_GB.UTF-8 (charmap=UTF-8), LANGUAGE=en_GB:en (charmap=UTF-8)
Shell: /bin/sh linked to /usr/bin/dash
Init: systemd (via /run/systemd/system)
LSM: AppArmor: enabled

-- no debconf information

------------=_1613479864-10107-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 981662-close) by bugs.debian.org; 16 Feb 2021 12:48:52 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,MD5_SHA1_SUM,PGPSIGNATURE,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 81; hammy, 150; neutral, 121; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from mailly.debian.org ([2001:41b8:202:deb:6564:a62:52c3:4b72]:35458)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=mailly.debian.org,EMAIL=hostmaster@mailly.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1lBzme-0002Fv-IM
	for 981662-close@bugs.debian.org; Tue, 16 Feb 2021 12:48:52 +0000
Received: from fasolo.debian.org ([138.16.160.17]:46420)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1lBzmd-0005Ou-2h; Tue, 16 Feb 2021 12:48:51 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1lBzmc-000A5U-3j; Tue, 16 Feb 2021 12:48:50 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Reply-To: Bastian Germann <bastiangermann@fishpost.de>
To: 981662-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#981662: fixed in xfsprogs 5.10.0-4
Message-Id: <E1lBzmc-000A5U-3j@fasolo.debian.org>
Date: Tue, 16 Feb 2021 12:48:50 +0000

Source: xfsprogs
Source-Version: 5.10.0-4
Done: Bastian Germann <bastiangermann@fishpost.de>

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 981662@bugs.debian.org,
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
Date: Tue, 16 Feb 2021 13:31:30 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-4
Distribution: unstable
Urgency: high
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 981662
Changes:
 xfsprogs (5.10.0-4) unstable; urgency=high
 .
   * Source-only reupload (Closes: #981662)
Checksums-Sha1:
 bdad02aac22258f7d03aaafc7de910309e861d62 2047 xfsprogs_5.10.0-4.dsc
 37b74a2bceb4d6eba1b2c7f3cfcb33a62bd31f41 13924 xfsprogs_5.10.0-4.debian.tar.xz
 32d0b8d03beaf56a1e74fca13f31466cf3fc6ec9 6545 xfsprogs_5.10.0-4_source.buildinfo
Checksums-Sha256:
 839e28e8d8fcb932013f50a371cf8a4ba29016a36238e4880c2a593b81ce9211 2047 xfsprogs_5.10.0-4.dsc
 616a7730b773c60e0877694e419374174027a8cb540029509093a40da178bdbc 13924 xfsprogs_5.10.0-4.debian.tar.xz
 c3a87d3e6d1b60eff9bb9989c471239fc7bbc373f02b525bf553cac8ad52dd09 6545 xfsprogs_5.10.0-4_source.buildinfo
Files:
 62e8be79f08484553689fcbd3153e015 2047 admin optional xfsprogs_5.10.0-4.dsc
 7fd577f89a73a18a91630b02cb42bc25 13924 admin optional xfsprogs_5.10.0-4.debian.tar.xz
 1d0b1ab28fa60d8ca7c44d68462a60f9 6545 admin optional xfsprogs_5.10.0-4_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAru/AbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMU2DMMAK4reAI4MtsyfII66TMQ
M5f91mFFkbWLB5AMLuYlf+gP58x7WHcxCRzby6IagBTSRxPHx5s8mNNiy4P1NSfE
QXufjFQ50/iJEafVm+wBJBoqvVZkupoNuqEo1LgYciI/s0YqWDQ/s94ybdwnE6Fd
eabskKy+ag54KBXzBbZUY5u5OpZ4UMqPI1uniFnBQ/4rmlQetXn+RYalMoir5u+8
QEVbxheLUy7virdVgvM676sbdJxvoTR2DFF/VfrReG3kfAyz08KS7B9fzxgrn9lr
QBrLtsZU9Deo8ueXZr3pSqpUG+kDMGrJKAAog6Ptgue+2FxPttoxc0pA79DDwaxR
K4TsInZUNwIy2M4UOuN+/R7gmChjzUcW/ecn0IxSxzDQkWiL5DK7fgV8TUBoBjml
g4Em8kU1F2x3ZjCePp0hTS5PlQ2Ra9DcvNHZNifTV21L/ffFzKpHFkC/pa/E6P7v
n5oERP2pwkG2jiZOkJqVFKjfpY/+569SpYVuCXBjZRfEvg==
=j5hW
-----END PGP SIGNATURE-----
------------=_1613479864-10107-0--
