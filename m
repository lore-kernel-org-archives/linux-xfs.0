Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0B0C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Dec 2021 12:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbhLGMjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbhLGMjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 07:39:39 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A32C061574
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 04:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=TrNtTn/wkWl7Wgiex4GV4UCfTGYQThG0bFBIOytMFRY=; b=rU3QY3E7bk5CZZziRuappV4D4t
        Z64nRTA/3gd1CYTs+zzXmhqDNOuJ9nqqD5tmO3h0qxWBg3Fx+DXG5EESZEs2UdtRJgXRyEkHEA4Ho
        bp3veIO0KZm+5g5QVrpFGnt7MUypuMovIjWzfU67VQuV31HHrw26YEggzkqOHIJ/JAFX8G0iMz/Qf
        saF59JUZgN757gumf39pPxCVDQEex10fKW2B2SCw7oDIio719UTeamQqBNpNowBD4zP5+KkOxb/qT
        3fdT+haRzGnywycKP2R23Bb+rqq3V2Uvk6EthI2trjco7mb85Hq9JQuIDFbDgmd60WeWQfMX097YM
        WT8EpiHQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1muZhT-0002Mc-Dv; Tue, 07 Dec 2021 12:36:03 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bage@debian.org>
Subject: Bug#1000974: marked as done (xfs/linux.h defines common word
 "fallthrough" breaking unrelated headers)
Message-ID: <handler.1000974.D1000974.16388803767505.ackdone@bugs.debian.org>
References: <1ae1f860-e164-4e25-0c59-d4a3bb8587c2@debian.org>
 <163839370805.58768.6385074074873965943.reportbug@zbuz.infomaniak.ch>
X-Debian-PR-Message: closed 1000974
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Source: xfsprogs
Reply-To: 1000974@bugs.debian.org
Date:   Tue, 07 Dec 2021 12:36:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1638880563-9080-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1638880563-9080-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 7 Dec 2021 13:32:48 +0100
with message-id <1ae1f860-e164-4e25-0c59-d4a3bb8587c2@debian.org>
and subject line fixed upstream
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

------------=_1638880563-9080-0
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

------------=_1638880563-9080-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 1000974-done) by bugs.debian.org; 7 Dec 2021 12:32:56 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FROMDEVELOPER,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,TXREP,VERSION autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 32; hammy, 113; neutral, 20; spammy,
	0. spammytokens: hammytokens:0.000-+--HARC-Seal:zohoarc,
	0.000-+--HARC-Message-Signature:zohoarc, 0.000-+--H*u:91.0,
	0.000-+--H*UA:91.0, 0.000-+--HARC-Message-Signature:sk:Content
Return-path: <hostmaster@neglo.de>
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21822)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <hostmaster@neglo.de>)
	id 1muZeS-0001wf-7B
	for 1000974-done@bugs.debian.org; Tue, 07 Dec 2021 12:32:56 +0000
ARC-Seal: i=1; a=rsa-sha256; t=1638880371; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Z53okoikhO6Pe5ayy+scxW26TnaAK+Yl8OMEJbR/WdikTDLtr64FcNU4VvF3EhfX1YIWiveSicrAUaAWYwlXLkZ/rFIL9PuguSJ2U4ZNL2wCuML+90mHwc61w+GSS8UE7ZJCqqA539rJxPoR6vwK3/Wq3HHV3mnLRINPUbYX3xs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1638880371; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
	bh=gFPEvHSs7YOz8YO+cbkKUQrdwRoE+t7JEAn1IqcDcQE=; 
	b=K2jDN2in+JPPjykeYMpvv0Lk2OeU2qVl6rGiXa3V8F4GuF0L4uU2e+/6CDIlzDdiMUSmZ72mVR9ivi6QC4nuEuPpBQCm7Vj4oUP1O2nkyi1TEDme4i7S3E2WmN0CDYX1m0q2rhXiNtqVaxd6GF25U3IRva+deYxZYkNutNjE5yI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	spf=pass  smtp.mailfrom=hostmaster@neglo.de;
	dmarc=pass header.from=<bage@debian.org>
Received: from [192.168.178.28] (p5de0b257.dip0.t-ipconnect.de [93.224.178.87]) by mx.zoho.eu
	with SMTPS id 1638880369584127.70143103389523; Tue, 7 Dec 2021 13:32:49 +0100 (CET)
Message-ID: <1ae1f860-e164-4e25-0c59-d4a3bb8587c2@debian.org>
Date: Tue, 7 Dec 2021 13:32:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
To: 1000974-done@bugs.debian.org
Content-Language: en-US
From: Bastian Germann <bage@debian.org>
Subject: fixed upstream
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Version: 5.14.2-1

This was fixed by commit 135ce1ed0a99 (libxfs: hide the drainbamaged fallthrough macro from xfslibs)
------------=_1638880563-9080-0--
