Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3847C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 12:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhLGM5i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbhLGM5h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 07:57:37 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958CAC061574
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 04:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=QatYt7TU5hKIIL3y7chz+u4LOrqmrc+Fdhs5pmBUS6U=; b=gsc5OdnyOc/E5+Gqp5kVf7URNj
        r1ECk4sI2lw3/iksqrfpzjtl8wO7Vza1buPV4FHZ31+F4if//Sqyyi+MzJ2X1eHvGLOyxdBzr08fO
        GefAxq4qil1QJZSeqY4lHcOQA8E5ZaUrnrK5JKD51AHciHy5J5SXI4H9A/ap0LZv7GZycOVx7oav+
        1WWlPGyACRFxHrWLoNxIUsWi6pUioGCxPA8MAPFr3eLVRj5wdL0b+QMCtCwZmSNB7VjWbPeDLgfhI
        h382957BQTC2+kFW023hZzHUzTMaTjOZqoFGadBheTt1wlK1V2uyvAWUSDXyPODHIL+ohjk1Ak3np
        WWmZ8tGA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1muZyt-0004PA-AU; Tue, 07 Dec 2021 12:54:03 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Nathan Scott <nathans@debian.org>
Subject: Bug#1000974: marked as done (xfs/linux.h defines common word
 "fallthrough" breaking unrelated headers)
Message-ID: <handler.1000974.D1000974.163888145515091.ackdone@bugs.debian.org>
References: <E1muZvp-000DCs-Vb@fasolo.debian.org>
 <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Debian-PR-Message: closed 1000974
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Source: xfsprogs
Reply-To: 1000974@bugs.debian.org
Date:   Tue, 07 Dec 2021 12:54:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1638881643-16918-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1638881643-16918-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 07 Dec 2021 12:50:53 +0000
with message-id <E1muZvp-000DCs-Vb@fasolo.debian.org>
and subject line Bug#1000974: fixed in xfsprogs 5.14.2-1
has caused the Debian Bug report #1000974,
regarding xfs/linux.h defines common word "fallthrough" breaking unrelated =
headers
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
1000974: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1000974
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1638881643-16918-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 1 Dec 2021 21:22:01 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	HAS_PACKAGE,RDNS_NONE,SPF_HELO_NONE,SPF_NONE,TXREP,XMAILER_REPORTBUG
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 30; hammy, 142; neutral, 60; spammy,
	2. spammytokens:0.975-+--recieve, 0.947-+--H*r:bugs.debian.org
	hammytokens:0.000-+--goirand, 0.000-+--Goirand, 0.000-+--H*M:reportbug,
	 0.000-+--H*MI:reportbug, 0.000-+--H*F:U*zigo
Return-path: <zigo@debian.org>
Received: from [2001:1600:0:cccc:f000::1849] (port=52186 helo=zbuz.infomaniak.ch)
	by buxtehude.debian.org with esmtp (Exim 4.92)
	(envelope-from <zigo@debian.org>)
	id 1msX3B-0003G7-0w
	for submit@bugs.debian.org; Wed, 01 Dec 2021 21:22:01 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Thomas Goirand <zigo@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: =?utf-8?b?Y29weV9tb3ZlX2FsZ28uaHBwOjEwODM6MTA6IGVycm9yOiDigJhfX2ZhbGx0aHJvdWdoX1/igJkgd2FzIG5vdCBkZWNsYXJlZCBpbiB0aGlzIHNjb3BlOyBkaWQgeW91IG1lYW4g4oCYZmFsbHRocm91Z2jigJk/?=
Message-ID: <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Mailer: reportbug 7.10.3
Date: Wed, 01 Dec 2021 22:21:48 +0100
Delivered-To: submit@bugs.debian.org

UGFja2FnZTogbGliYm9vc3QxLjc0LWRldgpWZXJzaW9uOiAxLjc0LjAtMTMKU2V2ZXJpdHk6IGlt
cG9ydGFudAoKSGkgdGhlcmUhCgpXaGVuIGJ1aWxkaW5nIENlcGggKGN1cnJlbnQgdmVyc2lvbiBp
biBFeHBlcmltZW50YWwpLCBzaW5jZSBhIGZldyBkYXlzL3dlZWtzLApJIGdldCB0aGlzOgoKSW4g
ZmlsZSBpbmNsdWRlZCBmcm9tIC9yb290L2NlcGgvY2VwaC9zcmMvc2Vhc3Rhci9zcmMvY29yZS9m
aWxlLmNjOjI4OgovdXNyL2luY2x1ZGUvYm9vc3QvY29udGFpbmVyL2RldGFpbC9jb3B5X21vdmVf
YWxnby5ocHA6IEluIGZ1bmN0aW9uIOKAmHR5cGVuYW1lIGJvb3N0Ojptb3ZlX2RldGFpbDo6ZW5h
YmxlX2lmX2M8KGJvb3N0Ojpjb250YWluZXI6OmR0bDo6aXNfbWVtdHJhbnNmZXJfY29weV9hc3Np
Z25hYmxlPEYsIEc+Ojp2YWx1ZSAmJiB0cnVlKSwgdm9pZD46OnR5cGUgYm9vc3Q6OmNvbnRhaW5l
cjo6ZGVlcF9zd2FwX2FsbG9jX24oQQpsbG9jYXRvciYsIEYsIHR5cGVuYW1lIGJvb3N0Ojpjb250
YWluZXI6OmFsbG9jYXRvcl90cmFpdHM8QWxsb2NhdG9yPjo6c2l6ZV90eXBlLCBHLCB0eXBlbmFt
ZSBib29zdDo6Y29udGFpbmVyOjphbGxvY2F0b3JfdHJhaXRzPEFsbG9jYXRvcj46OnNpemVfdHlw
ZSnigJk6Ci91c3IvaW5jbHVkZS9ib29zdC9jb250YWluZXIvZGV0YWlsL2NvcHlfbW92ZV9hbGdv
LmhwcDoxMDgzOjEwOiBlcnJvcjog4oCYX19mYWxsdGhyb3VnaF9f4oCZIHdhcyBub3QgZGVjbGFy
ZWQgaW4gdGhpcyBzY29wZTsgZGlkIHlvdSBtZWFuIOKAmGZhbGx0aHJvdWdo4oCZPwogMTA4MyB8
ICAgICAgICAgIEJPT1NUX0ZBTExUSFJPVUdIOwogICAgICB8ICAgICAgICAgIF5+fn5+fn5+fn5+
fn5+fn5+CgpUbyBtZSwgaXQgbG9va3MgbGlrZSBhIGJ1ZyBpbiBCb29zdCBpdHNlbGYsIGFzIHRo
aXMgaXMgd2hlcmUgdGhlCkJPT1NUX0ZBTExUSFJPVUdIIG1hY3JvIGlzIGRlZmluZWQuCgpOb3Rl
IHRoYXQgaW4gQ2VwaCwgSSBoYWQgdGhlIHNhbWUgaXNzdWUsIHVudGlsIEkgcmVkZWZpbmVkIHRo
ZQptYWNybyBsaWtlIHRoaXMgZGlyZWN0bHk6CiNkZWZpbmUgRk1UX0ZBTExUSFJPVUdIIFtbZ251
OjpmYWxsdGhyb3VnaF1dCgpyZW1vdmluZyB0aGUgY29uZGl0aW9uYWw6CiNpZiBfX2NwbHVzcGx1
cyA9PSAyMDExMDNMIHx8IF9fY3BsdXNwbHVzID09IDIwMTQwMkwKCndoaWNoIGRvZXNuJ3Qgc2Vl
bSB0byBnZXQgc29tZSBtYXRjaGluZywgYW5kIHRoZW4gdGhlIGVycm9yIGluCnRoZSBzdWJqZWN0
IG9mIHRoaXMgYnVnIHJlcG9ydCB3ZW50IGF3YXksIGF0IGxlYXN0IGZvciB0aGUgQ2VwaApwYXJ0
ICh3ZWxsLCBmbXQgd2hpY2ggQ2VwaCBlbWJlZGRzLi4uKS4KCklzIHRoaXMgc3RpbGwgYSBwcm9i
bGVtIGluIENlcGgsIG9yIGFtIEkgcmlnaHQgdGhhdCBpdCBwcm9iYWJseQppcyBhbiBpc3N1ZSBp
biBCb29zdD8KCkkgY2FuJ3QgZ2V0IG15IGhlYWQgYXJvdW5kIHRoaXMgaXNzdWUgd2hpY2ggaGFz
IGJlZW4gYmxvY2tpbmcgbWUKZm9yIHdlZWtzLiBXaGF0J3MgYW5ub3lpbmcgaXMgdGhhdCBpdCB1
c2VkIHRvIGJ1aWxkIGZpbmUsIGFuZApJIGRvbid0IGtub3cgd2hhdCBjaGFuZ2VkIGluIHVuc3Rh
YmxlIHRvIG1ha2UgaXQgZmFpbCB0byB3YXkuCklmIHRoZSBpc3N1ZSBpcyBpbiBDZXBoJ3MgY29k
ZSwgdGhlbiBJIHdvdWxkIGhhcHBpbHkgcmVjaWV2ZQphZHZpY2VzLgoKWW91ciB0aG91Z2h0cz8K
CkNoZWVycywKClRob21hcyBHb2lyYW5kICh6aWdvKQo=

------------=_1638881643-16918-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 1000974-close) by bugs.debian.org; 7 Dec 2021 12:50:55 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.8 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,MD5_SHA1_SUM,PGPSIGNATURE,
	RCVD_IN_DNSWL_HI,SHIP_ID_INT,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 70; hammy, 150; neutral, 134; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from muffat.debian.org ([2607:f8f0:614:1::1274:33]:55860)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=muffat.debian.org,EMAIL=hostmaster@muffat.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1muZvr-0003vE-TF
	for 1000974-close@bugs.debian.org; Tue, 07 Dec 2021 12:50:55 +0000
Received: from fasolo.debian.org ([138.16.160.17]:57016)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1muZvr-00063N-1r; Tue, 07 Dec 2021 12:50:55 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1muZvp-000DCs-Vb; Tue, 07 Dec 2021 12:50:53 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Reply-To: Nathan Scott <nathans@debian.org>
To: 1000974-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#1000974: fixed in xfsprogs 5.14.2-1
Message-Id: <E1muZvp-000DCs-Vb@fasolo.debian.org>
Date: Tue, 07 Dec 2021 12:50:53 +0000

Source: xfsprogs
Source-Version: 5.14.2-1
Done: Nathan Scott <nathans@debian.org>

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 1000974@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Nathan Scott <nathans@debian.org> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@ftp-master.debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Mon, 06 Dec 2021 14:26:57 -0500
Source: xfsprogs
Architecture: source
Version: 5.14.2-1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Nathan Scott <nathans@debian.org>
Closes: 1000974
Changes:
 xfsprogs (5.14.2-1) unstable; urgency=medium
 .
   * New upstream release
     - Move rogue fallthrough macro out of linux.h (Closes: #1000974)
Checksums-Sha1:
 7d58d8887618f090bfc2b5c0d9c309da788ba960 2017 xfsprogs_5.14.2-1.dsc
 035e552cf4a08d5dbe1330ec1e3e6ceeb21b6bc9 1308912 xfsprogs_5.14.2.orig.tar.xz
 ef951cda194275eee5c3975cfd46544cf0f70a67 14316 xfsprogs_5.14.2-1.debian.tar.xz
 2d71d75e23c654180f1c794e4d5c8c569f62873f 6141 xfsprogs_5.14.2-1_source.buildinfo
Checksums-Sha256:
 6fcd3408e1c1edc0d776f54323424dd36eeaffc148191911c464d5a02b2bad6b 2017 xfsprogs_5.14.2-1.dsc
 01ccd3ef9df2837753a5d876b8da84ea957d13d7a461b8c46e8afa4eb09aabc8 1308912 xfsprogs_5.14.2.orig.tar.xz
 9581848bd59128cdd38ccaa4c92d82d5ddd66c74baa9dc2fc76fb5146497af4a 14316 xfsprogs_5.14.2-1.debian.tar.xz
 4d20924cfc79905a769dbff0aca10eab696536aab5f591e36e9e35001f63a5f6 6141 xfsprogs_5.14.2-1_source.buildinfo
Files:
 14d5f362b8d4ea4bee80edb78a36ad9e 2017 admin optional xfsprogs_5.14.2-1.dsc
 597e7067b8aa24d440bc87c29e987377 1308912 admin optional xfsprogs_5.14.2.orig.tar.xz
 89ea7c8a994352dcecd267a0ec13136c 14316 admin optional xfsprogs_5.14.2-1.debian.tar.xz
 4e41a97053eeb8ec0c6547e293683776 6141 admin optional xfsprogs_5.14.2-1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmGvU4sACgkQH1x6i0VW
QxS0egv9HwfcbxyRn43bj+CxNKMCdKtgIPfV0SZxejKwarbdDg3d8f4/1i7gNVpJ
+isPdnKvVULyxEhQxdoYfsjWaTCCX3YMlyrd6i5+2nrn6J9cwXrrJJdjPWvMgXR2
o2u+brvm9cPYllAbbEVUYe6dtHY+/cH1c16W1SYK3yln7MWWWCTvAT0a7YrnrZQj
7FVdd0qcbM+PU/m2qwpUxz2KmtVjJ8RfiF+a/X7P1zeAxAoODFx3GRRY9cTyvgnV
tDwAdlSu4W6UgiKwgTpDFUT6EPRigEEqjTk3k0BgvYeFEidX57TsknQXwWKn3dI/
Dxfo5wxGVlDIywj4iN9EugsYCBwW8ggm60St/BiJhuNpgup339yUBGtszm/x97RM
XLKTOgb642bqTVu1Otee+Bdd5VSMwlmkyUnDDvuh52EPF3uFNf55sgiYsv02ATrB
jb8rcN1zeqUZ9r+9m6w65pp2wQX6HAWqZSUEl2HToPITse3OPwwCPUKZja+BYpT5
bGdytpiC
=ORx6
-----END PGP SIGNATURE-----
------------=_1638881643-16918-0--
