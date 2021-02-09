Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F71C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8B064EAA
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhBIEGe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:06:34 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11282 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhBIEFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Feb 2021 23:05:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612843533; x=1644379533;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=jbiJ/tMYoacV1OWimltfMA/aSqUCHPK4fmRx/X0t1Zg=;
  b=JresYT7nE2gomFMQ4/ZxEmPB/HoecbDWgvo6CYRji5WzWnKDd55qWIrU
   UpwmGSXpO1oQlmpgYbjT7THa9vmUQfsxVxuVIvqLhZcEaJnWTb1S+rbtr
   NidBw2WeqkWHLDSIX4rxirjsv0yNXOP8YzJmVXHpyP+s0htB4rnYttKRw
   7p3M2No0y9CGvIsn6nN5+xQyOm8sfZVpBanx6JQeKpWCD3ACkT3ojgn+S
   0KulrF45AnPGnHiLNpcXmIbxYLyWZxd/ajYq+KwOX3phqsEssbSEe5TB2
   gBnUxorJpFOgqHuM8TSVQuZjvI78rqMBLaqKSmORpDUKUQSfwWUpLbAVx
   w==;
IronPort-SDR: thmNbnDaQiCyRGQdCUXzUaQBX+TKVz25MV2zcUzUYkz9A//rYQ1qXbITiStBSP3rCPbN/PeJJY
 y+zkrgEnYJj/rCoQawLdwWH4ZkM8tMj5FkY0ViK4uwFOmUBjbj8snWUia4NkyTdY7b7ebaJJMg
 FRqvsBsBWxZtu/fbqIM5Bms42LrEprz+jiESOgsu/FubuhdQ7wTEoLCUF7dDjnL08IZRf671Zl
 hH4HB/70cRXs+uozOuuH4+NFmjtz6lRSCkvc01sMH+4BOrq2XusbXW5TQ+OGrLMG+MdeM2rqrQ
 3zw=
X-IronPort-AV: E=Sophos;i="5.81,164,1610380800"; 
   d="scan'208";a="163963147"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2021 12:04:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6M6CPN5bu/lpeU90VswjFtiEpsmdO6TqHkRHwCzvR9r8/61atLSotIxBI0RR9aHuH1ZnfK6RlVeGvTC8a1iLvbfRVdI21zQWms/B7vI7x8Q1G5RoMxPzEGROy4942AE92Qneo8vzAFeeY2auNBc0yWwzbev83a1QI7+77n3MkdPKIuoSjkHH1vGjySr+FCnFa7TlWpOxVeeXdBctyn2RR8Z0z1Sac80FvWLXA46dvO7gGr8ogk5cxDsYAAeF8b6IrI986IqPOGOu3mUP5jMSX9QztoUcYxjZFeitam+XRa+Es6fOLVouC+21XUtcB7spWE7BXQQFh/EI8GuKxLM/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsZRQJxTe/68c2f2KeOCoFqpt9jLHErQzOJ1ZxVkeoQ=;
 b=MwD3Ve700BbnMCg+Q8ckXwtHQMIwOuM668G8DgdGVfHE3qe+43n5tw7ZTteaInCTTLNHCw/cPNVQZp0GiB6fUz7dGvyMESrJ+Tz7E4/ZSF+AnENOU1AiDjmYB44E4t/beWfhxsm5cXRNUqiEU8r36z16869DnJhCHSTAR66waxWpHn6hLTJpG1nADZ6mSgb7aXb06SlvHcE/rLLN+mRk7+vfq2Q291ocXVzw7QjBcjcAC+L9deriQANzDv/6iC7CW9c/o97bhpgjRe9KXZc8nqau0A/Uv0XO+hdTXdS4wGYWagJM0YHqLNwfeOSaQwX5QLFhgzy1rhtJIgDGJgryZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsZRQJxTe/68c2f2KeOCoFqpt9jLHErQzOJ1ZxVkeoQ=;
 b=XXMT3RX/IMZSJ60Wdri4uIckNzOBt0RiwR5FLPpGB7Sa1qzeT9dTIsrjcOB3pbNVQ0z7llMirfzERZkaKGXrNceytqTDGQVZGw+7w7zpWGyaCoZr4WAi23OSk3nqzlgzKbqED73t4VxVCJewNU6K9GwnSFtWrDYbbPsP4gR6bm8=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4328.namprd04.prod.outlook.com (2603:10b6:a02:ef::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 04:04:03 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Tue, 9 Feb 2021
 04:04:03 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix rst syntax error in admin guide
Thread-Topic: [PATCH] xfs: fix rst syntax error in admin guide
Thread-Index: AQHW/oojgst2JYYYbkiy1ho1ObXEBQ==
Date:   Tue, 9 Feb 2021 04:04:02 +0000
Message-ID: <BYAPR04MB49659152BB28D63D99AB7C27868E9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210209021843.GP7193@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e50bd71b-3faa-4a0c-e6ca-08d8ccafbcb4
x-ms-traffictypediagnostic: BYAPR04MB4328:
x-microsoft-antispam-prvs: <BYAPR04MB432895078026AF58D3D90657868E9@BYAPR04MB4328.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YwV+D0xIE+I+J6zzEVwAFqpt8K+XU9jxeSTv3fiOELT6MJ4KE1dLqUrK476r7WKwq5UEthgVXorpWm3P+hg0vPw+i0IrgBxlxB24Nu48y0LjaaOgwHJmFF36AfBi5D+4pOQfPRTUClAFXBVquUDifR5LQacxzfq+AtuASO95i0WAJO/zBoR3w32EwOLp2XUpZqlGZD4cpMfkJqr3M3Ku8J/Txp0FW6Fufa4idCXCiXS2ab7vEYAth4fhSC5dyMac81CjONUnnEiteh4nqOagWR6Dt90WNJefFPf+oMt2bdunrTteeq7eAx/GnyB+eca+qsyzEPV/JyjegS93JChZc/ohm9+fhVjpA8G0n9WSw+N2n2dMDPbBBaCHJTkwPcrMxhNDJN1rLYzhrD1UkGWYpWVmZnVK9xWIZH0nLaKcZKrOfHFbArSxDhz3joZK0xlwxZIRZLHH8iLK4bbqCBjIKUsTvCnXonG92CBbqmkfzcnwkKxdSHbnmfzUGkYE6Da7K04OWK7rFiaGcZ5YKH57ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(52536014)(76116006)(478600001)(5660300002)(9686003)(6506007)(316002)(64756008)(66946007)(66556008)(66476007)(66446008)(110136005)(55016002)(86362001)(53546011)(7696005)(186003)(8676002)(26005)(71200400001)(83380400001)(33656002)(8936002)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?E7+dhR7lCPv2mlWGl7skYR1a2+WP/LFJxA/fQSWc1tnrk21g1nfOKb3GCrMh?=
 =?us-ascii?Q?cfnEr+iCi9yerNodsemYG5Y9xzHgER281FLC4ShFJ1ErcnClogj5sUl0+DPk?=
 =?us-ascii?Q?If/FSKE6XSIFXd67N1HWsn1n8WZQEpqp0I4DbDHjp5LLwuO0Q1Ca2PJgYtbW?=
 =?us-ascii?Q?1PbGaeXalWxIAimN0sgdAnYJn9h1Q9gxmJLnTPamVQ+qusiWK83OhALNajzj?=
 =?us-ascii?Q?H0CSztelWNRetTi20gqS2m52x4KSiOzaae1hcfgO8m/73tOkFNw/NQbqdpf2?=
 =?us-ascii?Q?U+/MI/CbFO3fraHGK6GmZgnacuzp6wGNp2dJLcpPGjbIOOF0i+VzYI8+NUUV?=
 =?us-ascii?Q?cVPKhheFAlTzvgssOBnN1KDr2SdjRmXENZa+9ZC5Wx0ZcnJQLgUFBtIa88or?=
 =?us-ascii?Q?dAqoLfJALcECBovUFYerbZjBrSQxxb2ZBxjgAF0pPcmofOHbm9YoFtQ2Kxl5?=
 =?us-ascii?Q?lTDs+EMLOftiOCtTX6E37lneFoPmktm5gVCIjz3ZJPEBYAD4g1ErhIlo/Y+C?=
 =?us-ascii?Q?6t9vuBBRnTq+FX0WYl5+Xml+59iNCSxKL9SidVpyBH9MIBXh7Xln6nv6HJte?=
 =?us-ascii?Q?hkAQpzWC+qrbfJPlVTwLZnc7/IM4RcJ+Zd4mifmsC8Fw0dnjhk6h/L9Fm2W7?=
 =?us-ascii?Q?L9HINVJPjbSejlSyX7BYxgBnoJOiVCZfzgKbxdhNKX3UjwrDKPKNhWElUTyw?=
 =?us-ascii?Q?ypNIWSW1t+u2qoxcvibXQey7S/EqqWHvamFxNRMOm7B8971iEkWCtXxoheBC?=
 =?us-ascii?Q?7BLe7SVvjzVfrXXGYgdeHdgtkXNeTMLdwB5/TxiQMsykAxm94kJc1CpDBeA/?=
 =?us-ascii?Q?WS2sYxqQuFtmi0lwiXXAB14AkFYO6uL+Aw8GFRi8cWAE6e1U/gNhh5IF++6p?=
 =?us-ascii?Q?A2z4oVPZG0uQ80QmFEwFzMHkTy1XASIs0m0QbJgUBEZk5GgTwoaLG0MBEU8S?=
 =?us-ascii?Q?3Iqq4WOnC7xXJR3/0o8uq1ft1KjkUIzFDmNR/1ZJIQVtTcW7xFVvptKW4ZTr?=
 =?us-ascii?Q?ENug8e7+KF9YPHGrlnRtweKVTegHrH5tAHtvKHZv2Hbf/PUQS0zMLJ/TyuNr?=
 =?us-ascii?Q?VsqSkApJN4NO37V+DCJ1qn2IwvR6E8hFNrZfHSnw7OAHwk79ZQncu7GWGqpF?=
 =?us-ascii?Q?GjNe8o7dHJjUqiEYxLKoYYenfPta+p+Ju1gNsFGMgz1NSAHI9SgBAyx9YHeQ?=
 =?us-ascii?Q?vWH0/LZXnGYbA12c5YlCWi0c5Y8j48X2aBA007mno9fCbg/ARW7YsFDJYvA0?=
 =?us-ascii?Q?BO9tUoICz+bCPFvpUMdur+pbzkWvX9I2p2fy+jEuxAiL2jfuJqCBXCdKiiwq?=
 =?us-ascii?Q?tqKhUS3sUpuzs2urDdTraosL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50bd71b-3faa-4a0c-e6ca-08d8ccafbcb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 04:04:02.9660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5YktK8Qg1BPHgvobj8bM0dUTS0P8VVueJvqaBiIyVaJ+SSRrDZ0LOZ8jeYgxdMQwmvbpSTUY5eHJYZrMRmwQzeanamNARsgGECoi1ZeR+Eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4328
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/8/21 18:20, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong <djwong@kernel.org>=0A=
>=0A=
> Tables are supposed to have a matching line of "=3D=3D=3D" to signal the =
end=0A=
> of a table.  The rst compiler gets grouchy if it encounters EOF instead,=
=0A=
> so fix this warning.=0A=
>=0A=
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>=0A=
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>=0A=
Indeed the last line "=3D=3D=3D" is missing from xfs/for-next branch.=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
