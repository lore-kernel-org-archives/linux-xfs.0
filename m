Return-Path: <SRS0=iJk4=43=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E93C18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 08:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9F9E24682
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Mar 2020 08:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="T+d5OGxT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgCJIqD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 04:46:03 -0400
Received: from mail-eopbgr70139.outbound.protection.outlook.com ([40.107.7.139]:9510
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbgCJIqD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Mar 2020 04:46:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXEuYowL3W294zit2UjXTiHOLvWJbIVJfvPqqIEpFDRFdtIl5RNPHjFzKml3+6T+GhyagUO3del5sibo+eVav/cP1qRO+KV38sZiRAo1YDe3uPWxS05SGjnLzwr99KsPire5t+BDeQ2aKqzmX8PTP3OYJJRcgMewHtEn+MOuqbZ/3znlUTkgUhE64aSUH1OON8flZTPIN8PfMNs98gBRqgljW5aTvTERgGnXjZ+Qiq5FjeNfuXYR1JTKmd3m10L1pZqCql0nGTGOmlM1nDDwYu3ny4ifM8B0NflpBVkqAhd3OQfyptNgzJYDZMN9nBKzhgc2aZXUWMN5tOxrKiwTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IkS7XUdgiKnoSkgf/9Web2TVnQ0qLAiLcADE6Skdys=;
 b=ZwbJ6znNB02eBe5dXTTimLGIjDX5CReTQjfI36aaVzQ0BKIu+GG+T8wj5jogPtDV8Re45AhTCoGB1gqtJnCj98eBwvrU8VRZCtzXkDH2msrcDs7flZb266/IdIHDOkk7mcoqC3hMI4UFUa6nxecyx9WvV0EOPjzAhe9QB2NwzgwHGZo53sZxAqIH1Ai3hCFBvnRNXUiWU/pGZB9f2eqffmHfSC7vfFH/LKZUqimZO/7C6VOpPLKyAe2cPr1STQi5byTvWGNL2KJ3rG1+p86cGXyxZGJSZMLx4JVDd64dKZvXVszq9vSjPtNIeAti6SJ6KWGm3r5im01EAsWtULjLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IkS7XUdgiKnoSkgf/9Web2TVnQ0qLAiLcADE6Skdys=;
 b=T+d5OGxTAluCAjU9uW5IuzN5xWoc5mVgsGN/f4KHofQ+vQk/ov6Xo7mLHI8CCs6zThbW3Mh7qWBwf59511Zd0eEwwoR1BUbSp2nIGjB4f1hwaOV7OHak+vvoJSdtIJpMaBJDcRVT2TO52AYSci408jfjSAQAqiogV/RQWQbqq+w=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3788.eurprd07.prod.outlook.com (52.133.5.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.9; Tue, 10 Mar 2020 08:45:58 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2814.007; Tue, 10 Mar 2020
 08:45:58 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "hch@lst.de" <hch@lst.de>
Subject: 5.5 XFS getdents regression?
Thread-Topic: 5.5 XFS getdents regression?
Thread-Index: AQHV9rhRbXPUS+vCVkG2reFy3jRV2w==
Date:   Tue, 10 Mar 2020 08:45:58 +0000
Message-ID: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56673539-5c1c-4319-61c4-08d7c4cf7466
x-ms-traffictypediagnostic: HE1PR0702MB3788:
x-microsoft-antispam-prvs: <HE1PR0702MB3788DFD1F37347BED7250420B4FF0@HE1PR0702MB3788.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(199004)(189003)(76116006)(110136005)(26005)(2616005)(36756003)(186003)(316002)(8936002)(6486002)(66946007)(64756008)(66556008)(66446008)(81156014)(66476007)(81166006)(7116003)(6512007)(478600001)(2906002)(71200400001)(86362001)(966005)(8676002)(6506007)(5660300002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3788;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2KedPC2wzCuOpXwa3951n1iu9vc/pa+qnm8itcZnxx/Rn5u8Mx2MSj1HwgMR4QGYvHxDCtC94bxatZLMQa77OR9Enaq8xWDwPwQbhQ8a7eWtcDz7M+45CHXS9NV5p1tCDaupY1KtfB/t/qicukL/fJVjOHfc1i0pvBD3YMfn3MUUNwLhQZ9sOY8vlR86C3U+XbQ8EDoerKaKLMPKR8r1tT/SmMmeaYoIq1dK3kRZnrkp9w5bq0Y4p3avjxjemJDRKKjoxSEFNiiTqgG4bMxXY7f8ysGnshqNsFhfGVWMHcG/p97Ls/1T/xcBXRlcEaSyRH/eO7GmqLrv8rMyTAL5QQjCHTSop2PB4cINBw4mj79QD0Nb/z9Y3rZhxS+4G2IEEqTP8hAKScS6mXjTrQe1HKoX1XkvCGoEPVITIqxlOdzq9+2cQKB6fLbWWLTyXKERrYch+hV4JoKb4x3onFhI2iECh99ZFU/1r70osR79oGlWsU24zBW92vhiI+5h+Bj/XIzjltsvJKFtocOv/eRN0A==
x-ms-exchange-antispam-messagedata: /Mr9wwvKTzRqYxYjaMKek+VSu/RFYe8ILRPaY2ZEbAi+SMg8BtxTZUE2/82RbX9sz8bASH5NnsjqE7bl313rHdB3rCbF9IGrn8k4NGGqUXVa/Pv1MhpMptVVHkKIqoeTwlLdkMDejN2N9clhDHSp+A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D76916B7F7D1BC40B415BD6D729B8BFD@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56673539-5c1c-4319-61c4-08d7c4cf7466
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 08:45:58.5286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JPPKi6wzrWtjDjsK2FQx7Ij9Tul4UOF1rn/Cpy8F/2YGPKIZIWPeXY91KVS32K9w4ZP1oUgKQQzYgOFR38J/k5DCHOrh5JxnbplCSslz+hQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3788
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

SGVsbG8sDQoNCk9uZSBvZiBteSBHaXRMYWIgQ0kgam9icyBzdG9wcGVkIHdvcmtpbmcgYWZ0ZXIg
dXBncmFkaW5nIHNlcnZlciA1LjQuMTgtDQoxMDAuZmMzMC54ODZfNjQgLT4gNS41LjctMTAwLmZj
MzAueDg2XzY0Lg0KKHRlc3RlZCA1LjUuOC0xMDAuZmMzMC54ODZfNjQgdG9vLCBubyBjaGFuZ2Up
DQpUaGUgc2VydmVyIGlzIGZlZG9yYTMwIHdpdGggWEZTIHJvb3Rmcy4NClRoZSBwcm9ibGVtIHJl
cHJvZHVjZXMgYWx3YXlzLCBhbmQgdGFrZXMgb25seSBjb3VwbGUgbWludXRlcyB0byBydW4uDQoN
ClRoZSBDSSBqb2IgZmFpbHMgaW4gdGhlIGJlZ2lubmluZyB3aGVuIGRvaW5nICJnaXQgY2xlYW4i
IGluIGRvY2tlcg0KY29udGFpbmVyLCBhbmQgZmFpbGluZyB0byBybWRpciBzb21lIGRpcmVjdG9y
eToNCiJ3YXJuaW5nOiBmYWlsZWQgdG8gcmVtb3ZlIA0KLnZlbmRvci9wa2cvbW9kL2dvbGFuZy5v
cmcveC9uZXRAdjAuMC4wLTIwMjAwMTE0MTU1NDEzLTZhZmI1MTk1ZTVhYS9pbnRlcm4NCmFsL3Nv
Y2tldDogRGlyZWN0b3J5IG5vdCBlbXB0eSINCg0KUXVpY2sgZ29vZ2xlIHNlYXJjaCBmaW5kcyBz
b21lIG90aGVyIHBlb3BsZSByZXBvcnRpbmcgc2ltaWxhciBwcm9ibGVtcw0Kd2l0aCA1LjUuMDoN
Cmh0dHBzOi8vZ2l0bGFiLmNvbS9naXRsYWItb3JnL2dpdGxhYi1ydW5uZXIvaXNzdWVzLzMxODUN
Cg0KDQpDb2xsZWN0ZWQgc29tZSBkYXRhIHdpdGggc3RyYWNlLCBhbmQgaXQgc2VlbXMgdGhhdCBn
ZXRkZW50cyBpcyBub3QNCnJldHVybmluZyBhbGwgZW50cmllczoNCg0KNS40IGdldGRlbnRzNjQo
KSByZXR1cm5zIDUyKzUwKzErMCBlbnRyaWVzIA0KPT4gYWxsIGZpbGVzIGluIGRpcmVjdG9yeSBh
cmUgZGVsZXRlZCBhbmQgcm1kaXIoKSBpcyBPSw0KDQo1LjUgZ2V0ZGVudHM2NCgpIHJldHVybnMg
NTIrNTArMCswIGVudHJpZXMNCj0+IHJtZGlyKCkgZmFpbHMgd2l0aCBFTk9URU1QVFkNCg0KDQpX
b3JraW5nIDUuNCBzdHJhY2U6DQoxMDowMDoxMiBnZXRkZW50czY0KDEwPA0KL2J1aWxkcy94eXov
LnZlbmRvci9wa2cvbW9kL2dvbGFuZy5vcmcveC9uZXRAdjAuMC4wLTIwMjAwMzAxMDIyMTMwLTI0
NDQ5MmRmYTM3YQ0KL2ludGVybmFsL3NvY2tldD4sIC8qIDUyIGVudHJpZXMgKi8sIDIwNDgpID0g
MjAyNCA8MC4wMDAwMjA+DQoxMDowMDoxMiB1bmxpbmsoIg0KLnZlbmRvci9wa2cvbW9kL2dvbGFu
Zy5vcmcveC9uZXRAdjAuMC4wLTIwMjAwMzAxMDIyMTMwLTI0NDQ5MmRmYTM3YS9pbnRlcm4NCmFs
L3NvY2tldC9jbXNnaGRyLmdvIikgPSAwIDwwLjAwMDA2OD4NCjEwOjAwOjEyIHVubGluaygiDQou
dmVuZG9yL3BrZy9tb2QvZ29sYW5nLm9yZy94L25ldEB2MC4wLjAtMjAyMDAzMDEwMjIxMzAtMjQ0
NDkyZGZhMzdhL2ludGVybg0KYWwvc29ja2V0L2Ntc2doZHJfYnNkLmdvIikgPSAwIDwwLjAwMDA0
OD4NClsuLi5dDQoxMDowMDoxMiBnZXRkZW50czY0KDEwPA0KL2J1aWxkcy94eXovLnZlbmRvci9w
a2cvbW9kL2dvbGFuZy5vcmcveC9uZXRAdjAuMC4wLTIwMjAwMzAxMDIyMTMwLTI0NDQ5MmRmYTM3
YQ0KL2ludGVybmFsL3NvY2tldD4sIC8qIDUwIGVudHJpZXMgKi8sIDIwNDgpID0gMjA0OCA8MC4w
MDAwMjM+DQoxMDowMDoxMiB1bmxpbmsoIg0KLnZlbmRvci9wa2cvbW9kL2dvbGFuZy5vcmcveC9u
ZXRAdjAuMC4wLTIwMjAwMzAxMDIyMTMwLTI0NDQ5MmRmYTM3YS9pbnRlcm4NCmFsL3NvY2tldC9z
eXNfbGludXhfMzg2LnMiKSA9IDAgPDAuMDAwMDYyPg0KWy4uLl0NCjEwOjAwOjEyIGdldGRlbnRz
NjQoMTA8DQovYnVpbGRzL3h5ei8udmVuZG9yL3BrZy9tb2QvZ29sYW5nLm9yZy94L25ldEB2MC4w
LjAtMjAyMDAzMDEwMjIxMzAtMjQ0NDkyZGZhMzdhDQovaW50ZXJuYWwvc29ja2V0PiwgLyogMSBl
bnRyaWVzICovLCAyMDQ4KSA9IDQ4IDwwLjAwMDAxNz4NCjEwOjAwOjEyIHVubGluaygiDQoudmVu
ZG9yL3BrZy9tb2QvZ29sYW5nLm9yZy94L25ldEB2MC4wLjAtMjAyMDAzMDEwMjIxMzAtMjQ0NDky
ZGZhMzdhL2ludGVybg0KYWwvc29ja2V0L3pzeXNfc29sYXJpc19hbWQ2NC5nbyIpID0gMCA8MC4w
MDAwMzk+DQoxMDowMDoxMiBnZXRkZW50czY0KDEwPA0KL2J1aWxkcy94eXovLnZlbmRvci9wa2cv
bW9kL2dvbGFuZy5vcmcveC9uZXRAdjAuMC4wLTIwMjAwMzAxMDIyMTMwLTI0NDQ5MmRmYTM3YQ0K
L2ludGVybmFsL3NvY2tldD4sIC8qIDAgZW50cmllcyAqLywgMjA0OCkgPSAwIDwwLjAwMDAxNT4N
CjEwOjAwOjEyIHJtZGlyKCINCi52ZW5kb3IvcGtnL21vZC9nb2xhbmcub3JnL3gvbmV0QHYwLjAu
MC0yMDIwMDMwMTAyMjEzMC0yNDQ0OTJkZmEzN2EvaW50ZXJuDQphbC9zb2NrZXQiKSA9IDAgPDAu
MDAwMDU1Pg0KDQoNCkZhaWxpbmcgNS41IHN0cmFjZToNCjEwOjA5OjE1IGdldGRlbnRzNjQoMTA8
DQovYnVpbGRzL3h5ei8udmVuZG9yL3BrZy9tb2QvZ29sYW5nLm9yZy94L25ldEB2MC4wLjAtMjAy
MDAzMDEwMjIxMzAtMjQ0NDkyZGZhMzdhDQovaW50ZXJuYWwvc29ja2V0PiwgLyogNTIgZW50cmll
cyAqLywgMjA0OCkgPSAyMDI0IDwwLjAwMDAzMT4NCjEwOjA5OjE1IHVubGluaygiDQoudmVuZG9y
L3BrZy9tb2QvZ29sYW5nLm9yZy94L25ldEB2MC4wLjAtMjAyMDAzMDEwMjIxMzAtMjQ0NDkyZGZh
MzdhL2ludGVybg0KYWwvc29ja2V0L2Ntc2doZHIuZ28iKSA9IDAgPDAuMDA2MTc0Pg0KWy4uLl0N
CjEwOjA5OjE1IGdldGRlbnRzNjQoMTA8DQovYnVpbGRzL3h5ei8udmVuZG9yL3BrZy9tb2QvZ29s
YW5nLm9yZy94L25ldEB2MC4wLjAtMjAyMDAzMDEwMjIxMzAtMjQ0NDkyZGZhMzdhDQovaW50ZXJu
YWwvc29ja2V0PiwgLyogNTAgZW50cmllcyAqLywgMjA0OCkgPSAyMDQ4IDwwLjAwMDAzND4NCjEw
OjA5OjE1IHVubGluaygiDQoudmVuZG9yL3BrZy9tb2QvZ29sYW5nLm9yZy94L25ldEB2MC4wLjAt
MjAyMDAzMDEwMjIxMzAtMjQ0NDkyZGZhMzdhL2ludGVybg0KYWwvc29ja2V0L3N5c19saW51eF8z
ODYucyIpID0gMCA8MC4wMDAwNTQ+DQpbLi4uXQ0KMTA6MDk6MTYgZ2V0ZGVudHM2NCgxMDwNCi9i
dWlsZHMveHl6Ly52ZW5kb3IvcGtnL21vZC9nb2xhbmcub3JnL3gvbmV0QHYwLjAuMC0yMDIwMDMw
MTAyMjEzMC0yNDQ0OTJkZmEzN2ENCi9pbnRlcm5hbC9zb2NrZXQ+LCAvKiAwIGVudHJpZXMgKi8s
IDIwNDgpID0gMCA8MC4wMDAwMjA+DQoxMDowOToxNiBybWRpcigiDQoudmVuZG9yL3BrZy9tb2Qv
Z29sYW5nLm9yZy94L25ldEB2MC4wLjAtMjAyMDAzMDEwMjIxMzAtMjQ0NDkyZGZhMzdhL2ludGVy
bg0KYWwvc29ja2V0IikgPSAtMSBFTk9URU1QVFkgKERpcmVjdG9yeSBub3QgZW1wdHkpIDwwLjAw
MDAyOT4NCg0KDQpBbnkgaWRlYXMgd2hhdCdzIGdvaW5nIHdyb25nIGhlcmU/DQoNCi1Ub21taQ0K
DQo=
