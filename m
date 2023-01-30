Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0A3C54EAA
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Jan 2023 10:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbjA3K5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Jan 2023 05:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbjA3K5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2023 05:57:12 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2131.outbound.protection.outlook.com [40.107.8.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C5E3251B
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jan 2023 02:57:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rk6GjLG+V+PrZsvloO6okkejdpKeN/Qu6a0XOMkpZXfK53PB0oyfIjtpnDJ0W+NzdfFkGysLePUkYZK1r8EgH/kF+U6QlBPIk8scbKL/SUdvLzFrbzuM5fZXYjCBrmfz8vwEfeXWtdOpLV1VjLP84h8V90lZo97bkdGCD5JQaaLbXIX16VqfPvDYNylXnYBk5NnYAY5+yA/Xbc8y2rgRiT/dCV3istPTGjIfKnTscXmiyJsjxg18sZVDzdzDBlhFUZb67f5mwkEIviQ5xk1VATn2kd95nYmfCvym7wT6HYdCCDDvFBVz/tqoKiIOc1t42YTmDTgg+LI21Z9Qf1AsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMtWkx9839RwhEMDN6itkBfJ7XziIXFNuXZMZdDVp74=;
 b=SR69NF9rx1ce7m42o/kbVWJeAeZcMEUCqJ0xr3gsOJpL9K/UAMy2ikH8xk20xZV1DrNM5GmcdwT9d6Ws+3uQNUpFFvkBJD11OUuDKd7RuBfDj1qVnO5Fd0jtatcx+37J2Dnm2fmEKZzw9UCI4i+st1gczkGSw7IN79spI5NUIsoecSUdtZn/PfoeH7Wx49/NqE4jGEDTbCGzd5HNuba08ZiF/lAVQjaWnSMoowT7cDG5h/74GP3Wt9p0TXwAMdHXLBUkskrEQh2Ty4IUxpVNWFGOl6wT9qPLEnsv2MZd+qptAdj9apFB4S0RwYiIqMLQFMUbJqGokQqf/JJwwDoDKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bcom.cz; dmarc=pass action=none header.from=bcom.cz; dkim=pass
 header.d=bcom.cz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bcom.cz; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMtWkx9839RwhEMDN6itkBfJ7XziIXFNuXZMZdDVp74=;
 b=h4tvTdU7ocE/Ru88FWPEQrWBygsp/yoFXpoLVVLxigmouHHNXvbtKlmD+YQfmbTT9UG0/vMPKXJogPpHVX+Y2hcoqfaG//ZNMZjANKV1XhQqMx2L95yY0r2cWvWASj79imHoAWXUPpYhfPk4ODFTJw7oVbSOy3RoPR1p50IITj0=
Received: from PAXPR03MB7856.eurprd03.prod.outlook.com (2603:10a6:102:213::23)
 by AS8PR03MB8665.eurprd03.prod.outlook.com (2603:10a6:20b:54b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 10:57:03 +0000
Received: from PAXPR03MB7856.eurprd03.prod.outlook.com
 ([fe80::c18b:6bb0:4121:6758]) by PAXPR03MB7856.eurprd03.prod.outlook.com
 ([fe80::c18b:6bb0:4121:6758%8]) with mapi id 15.20.6043.022; Mon, 30 Jan 2023
 10:57:02 +0000
From:   =?iso-8859-2?Q?Libor_Klep=E1=E8?= <libor.klepac@bcom.cz>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_repair on filesystem stuck in "rebuild AG headers and trees"?
Thread-Topic: xfs_repair on filesystem stuck in "rebuild AG headers and
 trees"?
Thread-Index: AQHZMXJ4TCclsvSXT0mdskAJxnfhqa62z5DT
Date:   Mon, 30 Jan 2023 10:57:02 +0000
Message-ID: <PAXPR03MB7856BFBFC10B60C0C92372878AD39@PAXPR03MB7856.eurprd03.prod.outlook.com>
References: <PAXPR03MB7856BE8E2D589B6A5FA2B84A8ACF9@PAXPR03MB7856.eurprd03.prod.outlook.com>
In-Reply-To: <PAXPR03MB7856BE8E2D589B6A5FA2B84A8ACF9@PAXPR03MB7856.eurprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bcom.cz;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR03MB7856:EE_|AS8PR03MB8665:EE_
x-ms-office365-filtering-correlation-id: fc818c03-12c5-45c5-0f0e-08db02b0b818
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7gg1/5yO1EPsfsTnJpW0j9LH2BINOwooacNjhVCXJBZJpYnp/ZjFDFUeMKJ+CXC3I8iBK6m7j/B69KKTCxjuIZ5AoHog7CDBRTnnGm5mlkU3uIKNcCSIXtH//otSjijss8qgBwt4RsjH35U8bJ64IrAVnTM6WlWbgCrSPs6fCl+czuxfYpA9lkN53q9A98NfMFbioW8X+wcFrkIChZB0SX1M0UsCtYEEbzoNs8lVNCWxNlaJKbqZDsBPjoN6kDGXmdmC4m5OVzzxhfJPuyQY17za7mtIE1PwuOOZ2hE9DF/7hxUl0/Qf+KunXvTCaPpO6WG+oehFnKaPBg1edAzgFwE6HaxljaJwO3Va4y1A1mZPPcXm+nYOhj4SCFYENEa8oN4YBoqDNb7LT4XGZ2gUNuIIGOXQGLXAWhHD0i8aYlvhKkFEWWJpEl0O3547OFHJLTLprMXMHqx5sqbIqQX6kdhZIPQ5t1PPbo8mUgM7LV61TvpP8oehpHXs0jHrQN64GtOlGZfZj6c2KWQ5Vstvx2KUljGfwNnETXh4DUY8CFCkKiPv9It1+GDXh0FalCDh6EBtZZ4818eNdCFuDhfkmaJK/TvCDq25zECp4fkP20SOmXgScIRu7zJMPcFIXYe7/HXiy1AdOJwq0t+fqbN1HXHmONPKRGNhbi6KykkaSFEC177cm0Jj0C1bez+oOK2Iy68eNgX/Y2PMACuUnYzT96BPhtZtyt7zkUlwZPLUHR4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR03MB7856.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39850400004)(366004)(136003)(376002)(346002)(451199018)(41300700001)(2906002)(122000001)(478600001)(966005)(71200400001)(7696005)(86362001)(38100700002)(38070700005)(33656002)(53546011)(66574015)(6506007)(66476007)(76116006)(6916009)(66946007)(316002)(8676002)(91956017)(8936002)(55016003)(5660300002)(66446008)(64756008)(52536014)(66556008)(186003)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?y/8xAj4E5/x3UG0NHAMXh0KPYX6cnMCwc0DU2gYQ+C6cX9HEbxsqhFSakT?=
 =?iso-8859-2?Q?F5aY4rB0ELsNIn/bq+mN1sNOn9qp6CRpmM7Y/3cDVz4DAOwM0CdCb/rRJx?=
 =?iso-8859-2?Q?iIYU79OKoJ8XuULFmPkRkliSPKMpEWBGuu5eJL4Vun0N/lBU/SCaJWVtQS?=
 =?iso-8859-2?Q?wFnmo0WlaAITDqv4dPtV5XWa/CLEveI4macDvVrWiryPr093Xy7PqkfYVy?=
 =?iso-8859-2?Q?/LzQbSCtBEJquMdBQM2kjQ8g0aTLTOnmDHqAFRat7PWXl8cbYdLVng1P9E?=
 =?iso-8859-2?Q?K1EEKGiAXdcjKF60Llp96Pt7QEgoCmwDLNvjcL4QOlbKFIw1SMjkRglYrt?=
 =?iso-8859-2?Q?U85jWiqUIrZ3uwqauatZUitTylxOab3imWWLBTa8syknVdq1e8EwO1z1Jz?=
 =?iso-8859-2?Q?ZeMek9uX2jfouS9dNcyGLyHFYv8wiPP8eo8uVZhtZbAZfvK/6ocLcmu4y+?=
 =?iso-8859-2?Q?+R1nznpc51pE+y0aaFMNpP252oKm3Iz7Ps3xPhXCcgH09M9rBLmYcSZpGW?=
 =?iso-8859-2?Q?rgxAtG4uRe0dtFam42KGydYft9hti4Gj/mUe1EnjT5DB+0n7yX1VZKCpXV?=
 =?iso-8859-2?Q?VgPwT3nxS0W1BFlO5mbX7O/jOaHLPS9QNGwzIM3WFFmirXo5gtSBJg+jHH?=
 =?iso-8859-2?Q?P38OMUtLDdpblVWIvSYVk3LpLh8KYCO2ICbT3+QDC/4RRQCyGjTQMmXf9X?=
 =?iso-8859-2?Q?L+g9zADxiZGeJJdCk5nzkcOXpa4sVjy5YKQF2B3CWPR3H0LM9BgOdD9+Cy?=
 =?iso-8859-2?Q?+hjC1vDGjV0XMKsxWpOmD7j9Hn3RqMRcGfWpKw48S+VlBlYhLBomswELEK?=
 =?iso-8859-2?Q?jISlFxtBAcuwpP55Ml2B/QrnfnvQPKldvwjPVTLhaDAus6ZBIPfmv0gLdx?=
 =?iso-8859-2?Q?29mCIP1oDWl6aWcC41zzhWjc0WjroJQsa5ByXLKLpxt9GylHqtIOPFZugV?=
 =?iso-8859-2?Q?AK8jAqVjWtOp5jl4a6aR6v8+fJdQj/iqz3dpRfSvU5MSjhNVF1EtrXs1Gi?=
 =?iso-8859-2?Q?1GoqaS2QBzIKvleH5HYr7/MDxJ8aVUTIMOCAQc5voOtGIKUFD0LoCLBN8+?=
 =?iso-8859-2?Q?DjETZPRlaUI8IRbjSfKjA723lfKHT+9zjbNKLxz9nlPje94THhh20EHMHu?=
 =?iso-8859-2?Q?ZuonIMBBcceY9nvCJNORAj9HmnyUKcoBYehUrjb64jGrPBXdyzqzlgioyu?=
 =?iso-8859-2?Q?oMtMSvBNgz7HP4g45898DK+q0jV8RLXV+4Vryf+cDnmCEO/x7mp/E/3od8?=
 =?iso-8859-2?Q?CV2lwaGu+xTqwr3rjMRZXCvynZuaJobJvoXPT9p71uBQDPG2T3SqugfC/s?=
 =?iso-8859-2?Q?HEGxadqzSR1Ki/K0Cv4jOcqCSWScZ3wd6iTZ3UjguSweVHaiNPuENEmwcB?=
 =?iso-8859-2?Q?l1I3hVjBCVI/TMRXDupa1q/M2XWQ7qLyQNhO0D9NO9jJ9QTo4Lg5giWMBN?=
 =?iso-8859-2?Q?h8PWGuwYfZt6uVbSwAbdqQ7cTcZZgWWLVsCKyeY9ecIOZSNzQF6wROokEa?=
 =?iso-8859-2?Q?Tuh7m3k4WubzWaQ/9BmaCYTB02YwsnznGUJrnM/wNdQLhp6Cf//D6jDN7Z?=
 =?iso-8859-2?Q?pGIN5Pup7+W3F+rD7zXQ6bUuhWwXVah67lrNRbtt9FOVuC+IeMExGATQcu?=
 =?iso-8859-2?Q?mxE2IXVpxnNWVYmHqXZHBBvvIxj4R/WFPT9fdon7BXyJV9OX19JEi13bzJ?=
 =?iso-8859-2?Q?ZO+193H7uQUgf2zdhgs=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bcom.cz
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR03MB7856.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc818c03-12c5-45c5-0f0e-08db02b0b818
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 10:57:02.8516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 86024d20-efe6-4f7c-a3f3-90e802ed8ce7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cl9b0tYLexllg4QbZ7rPzY7aZ+hNPy+FmpXkNmy83Py4e4evztuk81Prjvdl7aoJgaddStHjo/9/R/wuxqzAuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB8665
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,=0A=
i breaked xfs_repair and lauched it again.=0A=
On beginning of phase 6 i have=0A=
failed to create prefetch thread: Resource temporarily unavailable=0A=
https://download.bcom.cz/xfs/Screenshot_20230130_114707.jpeg=0A=
=0A=
Also, there is dmesg, when it was trying to mount it and it was stuck=0A=
https://download.bcom.cz/xfs/dmesg.txt=0A=
=0A=
Libor=0A=
=0A=
=0A=
From: Libor Klep=E1=E8 <libor.klepac@bcom.cz>=0A=
Sent: Thursday, January 26, 2023 11:46=0A=
To: linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>=0A=
Subject: xfs_repair on filesystem stuck in "rebuild AG headers and trees"? =
=0A=
=A0=0A=
Hi,=0A=
we have virtual machine with 8TB data disk with around 5TB of data in few l=
arge files (backup repository of nakivo backup solution - it contains snaps=
hots of vmware machines - one file per snapshot).=0A=
=0A=
We have recently upgraded VM from ubuntu 20.04 to ubuntu 22.04 and after re=
boot, mount of this filesystem took ages.=0A=
=0A=
I started xfs_repair on it and now it spits line=0A=
rebuild AG headers and trees - 16417 of 16417 allocation groups done=0A=
=0A=
in 15 minutes interval for last two days.=0A=
Is it in loop?=0A=
Can i break it? =0A=
Data on disk is just remote copy of backup, so it can be lost, it will just=
 take some time to transfer it again.=0A=
=0A=
Kernel is probably from package 5.15.0-58.64=A0 - sorry i don't know real v=
ersion, cannot get it from ubuntu package.=0A=
xfsprogs should be 5.13.0-1ubuntu2=0A=
=0A=
Thanks for any info,=0A=
=0A=
with regards,=0A=
Libor=
