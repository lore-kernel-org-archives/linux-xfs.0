Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9382CC11D10
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A6B206F4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 16:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="B+oDtAX6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lAQ3qQQI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgBTQ0B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 11:26:01 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:43833 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728736AbgBTQ0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 11:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582215960; x=1613751960;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=X3vmfbS8IkxLGV65HqfBlufWF4tDzJf0fyqnOfVxEyE=;
  b=B+oDtAX6eHOjeZvUKk+AL/ZFk+KnGA4284hlRT5luenSjgYJ2OWmGBG+
   JKfuBcIvMeqXKquJB6JARYuoCskkG62Ud7F7FTdyDoViFseHGzSoOpImd
   yxpl44IzuDb79vHdpmW+KYfsVPW9RQXxAl0sS+oBd3tAevkrVA3OssuvU
   tdnYF43U+EHSe0aHrS3vzvHOxxzhlq6ybZTpQhqvwCTZCZxwktQ/g0h03
   bIbwc9+zappdIbliulU9U+QvviI0I1WFmUisNd179lcrHFbZx9Il3Id1/
   u1Dh5GxcrQftLQOV7PsdBKkqpxDAQyPtg7pvtvHdPx2tmCPaeUqOUm9xf
   A==;
IronPort-SDR: ixHFQPo9adCRGESjtk+eD0URWf3Ja4L+NbyOSKSpI7W2UoH3NNrbWbcT9C6UT2igs15D4XKQJv
 /j9tdX1lejS80fMeqciSbHvl7wi/tTZSGvLbXx9+zhyjvXlllyisg4OlgsbiunqFTMRGmqB8Ll
 nXkRhn2N6HRexSgAt0a60NZs44MkIXJqLk9BCMOtBDTZptMVNfv0DTpRV5WJo+R8NtmDnvUFnV
 WrvyKGvql2zaKtwn//AWY1TzSzXOFsvtn/GNN/Eb3XA8lNf7K5Cw8OtekeWMpX7zR5mPes6ScF
 Cms=
X-IronPort-AV: E=Sophos;i="5.70,465,1574092800"; 
   d="scan'208";a="238402064"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2020 00:25:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5mVaZFJBBKKn5DMjIU4tJnhG3hByRKvvM8nO+Js1f6zc3f38CpPijjOFzQ9N0Ow5F85IpSKJCbaeT54qmT6VHpvoLZ71wVl1AR8FZwVxoX9gzq5aAzteRTJPLltTVuj1VzU5YK1N3nFnhjjpUwtxugcNfzwPuGwBw93B9aZtaQgOwnOuUZtNKJlYc0WGx9xFy9NxOBtHyIJQBZBp568w4cWkRWwCKBnaS8bMBIfnjdvxVfqxW++l73OPxu+6ybFAWa9GAmO3jU4L8I9LnEoTRdMTaiiR6diFPHYOzXuVksmb68t58a3e/enuMxCODysG5R2kaRbf8TrQpEOtMdsfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtIZa/cm4OkSGPYfvBwHKkiwcy02xn8oQgqz4TpJTRc=;
 b=TV5srcuaMQZT5DuLtOrNoqG7ghd0Tj+PQ/fe2MdPu3PNRitHi4fh58IM1uHlWOngZJo+fbhXouRgudHYYfl7KJC8eWgAKPsguTMUuqpmY7lCdYrd2WFtYUlqdqMcxtf/Jbb04VCOxzvG9l24Kn5pQDCH7Gb7GQGkclYfcbC6Jn4m9DQBH9YzBG5HZfyq4Ge6qUCQoBeCvaV6I7P7YCWHjcL8lJ4ZHA2tLldTRPVMXSYKDOH2onuYqmPH87Zd94Y/Vxn8c8sn+LVMofJ9dKGFoDlIPz2XmFMSpWBCqVQigbKLHkzhnsiqIOGGFflT1TMpSaVIZ/lYdxtTspkWZz/2Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtIZa/cm4OkSGPYfvBwHKkiwcy02xn8oQgqz4TpJTRc=;
 b=lAQ3qQQImatuPtABw880+NXm5uJ14qwMNuxBgajSK2/XtsYcdwvBsEZntJkqssDfa1EseIwbypuLQEj79bZrZkcN65KirzTi8MnEtjWshPkBE2WYxqXLsTJ+ObfJltV1t/u9Dy1oIZRTTGRrDLJUulr0WmYPQzSTRtjLMABWuOg=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB5301.namprd04.prod.outlook.com (20.178.49.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.29; Thu, 20 Feb 2020 16:25:58 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fdf8:bd6f:b33d:c2df]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::fdf8:bd6f:b33d:c2df%3]) with mapi id 15.20.2750.016; Thu, 20 Feb 2020
 16:25:58 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Reichl <preichl@redhat.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Thread-Topic: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Thread-Index: AQHV42kEDs8e/WrrJU6iifDPQ+S/cQ==
Date:   Thu, 20 Feb 2020 16:25:58 +0000
Message-ID: <BYAPR04MB5749939FDB825A04AD40D9FF86130@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <DM6PR04MB57544CDC68D9DFAB48B61F1386140@DM6PR04MB5754.namprd04.prod.outlook.com>
 <CAJc7PzWrcXpcraAMEfMi6idTeYa9o009tZLOSzp3A6sC-km3DA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d569896-f9c4-4d82-0bd3-08d7b621918a
x-ms-traffictypediagnostic: BYAPR04MB5301:
x-microsoft-antispam-prvs: <BYAPR04MB530162EB47BFA4D0C24FCC8486130@BYAPR04MB5301.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(199004)(189003)(316002)(7696005)(66556008)(8676002)(64756008)(81166006)(81156014)(66946007)(66476007)(66446008)(33656002)(6916009)(8936002)(76116006)(5660300002)(2906002)(186003)(9686003)(4326008)(6506007)(55016002)(71200400001)(86362001)(26005)(52536014)(478600001)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5301;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K3S+HKwamRrBn0BOn5R3mooJFSpt/UjWrzrc+rErQdjtidk3DsokNr3xk1h1StMWSgjS4As4BrmLtBjTVlfhX252MtqAW9D2rcYDCiMHE3k9LUq7WYLk5rb/jrXsogov+fzKOpaCILlVymCjG8njSVNnQg0/gtk3HutJD2u3xYYO3BGxPz9dgrlQEHIk5QAfzQirdTPgRRpfF7c+D2vFIF/ZDvKJhxCsLWDKePi/xAluX3z0aZiYGR8EM6jYje+3SQUJPFjALztu3qwhc/QHYglUHp/6NUEQQREiS1rELc+nQF99Y1HMv9fhEqUiDTRnrgyogLVNbJJqXOgZWP0sGB4LzlzR5WKsIn2p1njkxO75MO/8MUIy2Kvccr8Z6g3HS50J/3BNlgvYNngyZDwocue37DdfynnGvjXLYG6/SxW/YO4IEukC64Qa7knjWy0Y
x-ms-exchange-antispam-messagedata: P06deLzc+X0LMPoL/aB2AnwvoDb50sBwhmbdna3HP1vBXHAEqf4bOIuiF0tZzgWk0e9QK5C3KyyRi2o8nyY3YXTKmxYu1FcF/mq6aQZ8D9Ozk5OaKgiZmpllQcgK6qrXiYlbEnb3NbcUa9ilxNTp1w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d569896-f9c4-4d82-0bd3-08d7b621918a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 16:25:58.7284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WHaesnBhpUTdLLdn6GdElWn+o2dk/CaCyzrMAvZUzIQCdk3EGr+uPXPV/wLDBuX9iS7jCKJZCGMUnC3lU1YHHtKkuPkYlchjzpYwtO+KOMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5301
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 02/17/2020 02:56 AM, Pavel Reichl wrote:=0A=
> On Sat, Feb 15, 2020 at 2:38 AM Chaitanya Kulkarni=0A=
> <Chaitanya.Kulkarni@wdc.com>  wrote:=0A=
>> >=0A=
>> >Since it has more than one patch and version 5,=0A=
>> >I couldn't find the cover-letter and a change log for this=0A=
>> >series, is there a particular reason why it is not present or I=0A=
>> >missed it?=0A=
>> >=0A=
>> >On 02/14/2020 11:00 AM, Pavel Reichl wrote:=0A=
>>> > >Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocke=
d().=0A=
>>> > >__xfs_rwsem_islocked() is a helper function which encapsulates check=
ing=0A=
>>> > >state of rw_semaphores hold by inode.=0A=
>>> > >=0A=
>>> > >=0A=
>> >=0A=
>> >=0A=
> Hi Chaitanya,=0A=
>=0A=
> sorry for the absence of the changelog I forgot to add it - that was=0A=
> not on purpose.=0A=
>=0A=
> To summarize the changes: I moved the asserts from the first patch to=0A=
> the third as suggested by Eric and changed the commit messages as=0A=
> suggested by Dave.=0A=
Thanks.=0A=
>=0A=
> Regarding the missing cover-letter it was same since version one and I=0A=
> was not sure I should resend it with every new version, should I?=0A=
It's okay, it just makes re-viewer's life easier to look for the change.=0A=
>=0A=
>   Thanks you for your comments.=0A=
>=0A=
> Best regards=0A=
>=0A=
> Pavel Reichl=0A=
>=0A=
>=0A=
=0A=
