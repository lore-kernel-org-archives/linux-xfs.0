Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B10DE7D0B4
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 23:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjIUXLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 19:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjIUXLv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 19:11:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DCF122
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 16:11:45 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsUUf009841;
        Thu, 21 Sep 2023 23:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wlrM2kv9FJ5U6BcpC7hP1KzPhJL/tu+pFRtuWZSWYYM=;
 b=JKfeoOrRmZ4yacyw5NryCqqqHbB2dF5b1Xu+/v4o7Pk4h1ljrF7mW4bWS1YgN+0f1RNU
 TKDos4wIoTalECzi0moVD7ScKzvd9NFTfBJZkS71/cTQkrQ9cBFK1wSLqW08/cw8H1MF
 /pff8sG+eojL7aS5UaGDZBwgkdaX2wKG8FeYES/3xtBWiLW3sNnIRO8CsyZQV/ed8K8B
 EKcX/xDUuCg3SeqdaAwwSmNj5Ba3tMGEA0LrOQTPa/Z67kx3X9+7kLyKhtji9WlsHPsm
 7TZTRWoALyiYiJPemd1TtZ9Y0l9/ub51f/u1Blhp0VmIJnwbQpGdsIN0VjQ7KLSbV0Vk Jw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tswgg2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 23:11:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMXglX039463;
        Thu, 21 Sep 2023 23:11:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8ty1sa89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Sep 2023 23:11:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuvxkJ62P8L7xnHorMBe5FVf7JVBjp3l7Waohg1mARD0oUf8vbke2XksTCTy/FzcI/B4EA/OGsT2dJqUFGLJhNgVoXlwveNNeHj+JfYjOkhQaSBLKM/1z9WvLZgKeVVgXxFYArNPCx0Syli9yku4sA7X4JkNQJyPdqDkhBWH0fmqUyL5Rv4248gHAxqxqIJ8xkGcCegkQLC/1SOBvPvSYViaqH1vhIZlK7ErDfNOyKksem/wO+WvV0KnH9B/KYYR9sh3v/m3uNIAdVvKK2Ex4J39aWLxPCxrNXepEF7zLpQxie1zzbb4OCE9RlBOX3nnOta1t/hGtJYmZAZHtcZDRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlrM2kv9FJ5U6BcpC7hP1KzPhJL/tu+pFRtuWZSWYYM=;
 b=XKV/XVZQENobdJdEWf5f4w/QfYMnhPpwwUEUEz+/V45i6WPv+5dc4SW7YmDMMrbZ9Pbfp2O3sZVsBUdog2SUCzjtQtCqaDapS++Q4a6MMJDl5DdNn/pIu5KXg6nYLMIRYeSBcslFeMaLNTyeZ6wqpJWMW++IXdSlKoAxDYfu0GnoFSqB2ueAexG+4GjTiNxaoBr0/2Dpj38vMbgrNbiBXtPFfuO3rYi2nsOTqj0WJXQCNP/M/gyGlWpsqnulBXQrRIajHcQ85JRGPbrqGcJ0A3gM/gWWhTZN920Hfm2KsMWqh1FW/TLck95RqwTN1qf5qujphp2kA6LSWUIqzUMg2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlrM2kv9FJ5U6BcpC7hP1KzPhJL/tu+pFRtuWZSWYYM=;
 b=0MJ8XahacXsNVhT0xj4s/i2wZoEaZ+b3+JLiOJGSTSJlPHgbQTZ6uGjw23m8h+Dr1ipGx5bwt8QsA1k6QoK8gAR+zvRbVOX2RpYS2lMKFhFXO7ORtDMix/rkhAk/3Aiucx4kslCtSq7vCmRnp7A5eGhc0su0f/GmBkkTlw46exQ=
Received: from CO1PR10MB4499.namprd10.prod.outlook.com (2603:10b6:303:6d::12)
 by CH3PR10MB7530.namprd10.prod.outlook.com (2603:10b6:610:155::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 21 Sep
 2023 23:11:40 +0000
Received: from CO1PR10MB4499.namprd10.prod.outlook.com
 ([fe80::aee4:c548:7d92:1652]) by CO1PR10MB4499.namprd10.prod.outlook.com
 ([fe80::aee4:c548:7d92:1652%7]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 23:11:40 +0000
From:   Darrick Wong <darrick.wong@oracle.com>
To:     Shuangpeng Bai <bb993561614@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: BUG: KASAN: slab-out-of-bounds in xfs_iext_get_extent
Thread-Topic: BUG: KASAN: slab-out-of-bounds in xfs_iext_get_extent
Thread-Index: AQHZ7MEjIMafvKv7M06iri70UvwZj7Al6CGI
Date:   Thu, 21 Sep 2023 23:11:40 +0000
Message-ID: <CO1PR10MB449999973B3699FFF7061652F8F8A@CO1PR10MB4499.namprd10.prod.outlook.com>
References: <CAH1hT1JGYtidLN9qe-7XnTgsdKo_bdbHQyQZpG6==iwAkCPu0w@mail.gmail.com>
In-Reply-To: <CAH1hT1JGYtidLN9qe-7XnTgsdKo_bdbHQyQZpG6==iwAkCPu0w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR10MB4499:EE_|CH3PR10MB7530:EE_
x-ms-office365-filtering-correlation-id: 978f210d-67ff-4ce1-0f25-08dbbaf81cdd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51bQE8krLvgWAiursqvh117N/XPQDhe2Osy0eIa7hRRDNctNSQwmClh3aYtFIn3xr5i9BYRQR6Af/+zt0OBUayXS5jDe7AaGsI/20wB5yEIlNuJMUhLb9P/6GibihSvnI/oq5xacsi+jwx7b6GBPOwbptRScrdy2MwqkfwcH/kPMsl37iXXos/dOU01mowjXkzlfTRHEgYUSrE2JM8ejJX7nUEvZrG+q/CYvj02LQtXnVY+95oxUk9jsVc4sLIfF718ThHzJToXCG0fM4aJAquhcXHiHtQbmhUW6Br6Oorqfxh4i7dHZjB44R2AHG/hHBAjuVRKva2rRbBhRl/7nlSWQJ91TfnkvBdkQ2Z2nUIMvVaOoZy7Uft74J7UtjDQ/4iWX9xrMHKj2DMJOgf1GhRbrs6CthEK8Ddr+h1AC9eDfAV69fyUwp5LOEgUijHSSL8cRKXHy6ECbWiK/9ADChbKecaSalq6jduk4nmFiFhxFAhZG8joz/A86bsxkmQRL2pWChNEjGHykN2EPggx3DWody9F0hEhP6NX5nDZ1XyZCkCWRn8oaGxJ+HL+gbHD3NVPfijY3ro64L1mmU9mOM627NCZQ0pFOm9vBst36NnKyRR6jrAWIL0C1xVx5dnkYjsaTHfp/iChSc42EPuWlvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4499.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(136003)(376002)(186009)(451199024)(1800799009)(41300700001)(84970400001)(66899024)(9686003)(7696005)(71200400001)(53546011)(38100700002)(33656002)(55016003)(122000001)(38070700005)(86362001)(2906002)(26005)(83380400001)(6506007)(478600001)(44832011)(76116006)(110136005)(52536014)(8936002)(316002)(5660300002)(66946007)(91956017)(66476007)(64756008)(66556008)(66446008)(8676002)(505234007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VE7EZfDwpbgQvojeSfzsY3sXL1tKzAJiGT/zB+EvLyGY2SqSCcimmk9eBRYa?=
 =?us-ascii?Q?/VLiwN2pKEqOCfWhfZgAK9L+zQL4IZUj9ksDr0hoSaIiOoemYm/2Zj+0aGLt?=
 =?us-ascii?Q?kojctSNDssuDp74sAmxpa5VqSdL92zgDEZapx0u0LOKOtt+UneVe7EE7Bq1X?=
 =?us-ascii?Q?ZlVSfn+IDVxFilWr+Kn1zxC2Hf5E0Bw0nMkbTQn0AauIC0VA00pLks/eHdmy?=
 =?us-ascii?Q?FE4EpeEIqJg389CZ02ckwiRzQOCdyjEAhpvFsM9AiYIRr2+IxKHIgToKfp62?=
 =?us-ascii?Q?KoQFW1B7nR0YLtpozBgxRdolzkMSFXUWXQRfhGzKVtacR/Uh+1RH/L4m7Afi?=
 =?us-ascii?Q?JPybeaM/G7Iw07iMgyiWV4JCvmrX/WSEX6i5ultmSPoIFsHBtyw2nkv6PjS4?=
 =?us-ascii?Q?kTJ9zPWsAoDl+FnMkUB6Bg7Qf5WrV3chbSgRsThMFVnopw8lp0M1qWfcS23p?=
 =?us-ascii?Q?LImN2ngiMK9M//0lN0cvsLvgEC0hcELAerLVMtoeFLlbV+8SvLYlmxR9VNyQ?=
 =?us-ascii?Q?GLjA6GDfLY8D8Yd3Lez+xFjxyoMhMCiXkkkmEU3nmGkqaERl0PEIz3B0M12Z?=
 =?us-ascii?Q?B01lVvni3YSjZNtP90eOaSF/5FkbD1+nuWpsZ6SqlNHrDPQXPuwL7tP/sQuo?=
 =?us-ascii?Q?+IGO7AyWNnOuuOgLVXML9ToZD8TYMSnaAQG09UWS9EMq0AhJOaBHJHx4czrl?=
 =?us-ascii?Q?QUhM3e1hmriAdRkMzthF7bHce7CmqJFiAslVEZJcfGckWh8G+hqIWggIt13H?=
 =?us-ascii?Q?JcZa1ZtNRReugK6IpS+GJHi3TurSrXUW2vicXvnPr+Mz/XwJj/jHdE3Iv2HN?=
 =?us-ascii?Q?U+Vt88we7Vy6ayUUQkhrRtX0S/gxCWE24vye59muyB/CdLpuB+5LJSBhj/D2?=
 =?us-ascii?Q?h4Sr/WrUo383p5P3u7vSsop5VVk12L4s6XnSqMApiYmuwVEPhOmkC7GkP6+1?=
 =?us-ascii?Q?GAlsJiIPp2sWBOh+5Qpp0MlzWKKI+YNjL6VDPUt2/wKCZ9Spsbak7tiubmY5?=
 =?us-ascii?Q?OQd8C1WXEGxpLbERi7/KOMXy1d330nDqWKnAOy2CFmkJ12HpTk5NwCkSnCjy?=
 =?us-ascii?Q?FtWUIN8Ww26mkJBHbPJKUwmjeWy2XraWgpqeHnRI/Y0AZXGDBakxhiPqlQ9E?=
 =?us-ascii?Q?q++QqutyPHOB4uVfJJEN/MwLETdiGhf8cqcWVE6Ih667F61xpe6SmJiv12Yr?=
 =?us-ascii?Q?sEAbHOu5+oBMWyRdpHcbR53HHJEZjjiJb5Rhw9TvbAmYVK5eYFh++in8Pz1F?=
 =?us-ascii?Q?uqwcuFlC2Px5B12MxblFlqi+i1QvDeQGFsHkdNgjV+Bpr0N6kWjyeljvXEAn?=
 =?us-ascii?Q?euR1f1c5cflpYPE3N7iWuTU8HdwtWSM2wMLy52GRkTEaQdtVHoAy0ZVYNNZW?=
 =?us-ascii?Q?SlFVBT+HDErmOIreQJ+EEmK/+BGAkKkke7ID/nPOl45TaBmGdqD1LdsYsdq1?=
 =?us-ascii?Q?eZiE37nTd1/OaKxftwB649OlvIYhfKMNX1tc5E9BDDK0PS1ObyxtcVKOVraY?=
 =?us-ascii?Q?utOSO6YejV2mDhXQ6zfBDad+aYprabSXxhOT+ntmOSwhcpDJtzpMrNjBI+Kl?=
 =?us-ascii?Q?WKlW/oNOsXClf8E+cNp/4BggnZ+8x2GQIA8jq/SN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ppNPKkC9kPlltag5i8scAQxkI5YLfI8+qSLTB8AlAnu28jmkcSyVTzJx2MfVwlOm8VufeYoYXQUDrHJeSbhBJTcRm7KIo+OPB4qyRE0Kt6pHHsmTzGszTq8PopuPtrUwZCgMMR76CP7pBHLHyeFhWc1XYPBBYJiosjBA1fJjCsLkHB3la7sp5jxMq9PhRY2X7hjqHuV1VgNEg90MwhvPNiebRJO5zTVKa/7viJ8zLYFOqa0c+Vq9HB6ph1h1/kcI16Y3p7oEZL0QTs7rHcSGX7sFkiBYCtCBrvMfq9dbYJYgnywEQ0A36sTMv9Tcz3KobFGAe56XsVH4Dm0BWh26q3VF+Qih4Z2rM9c2OnXSB78HI02D5PZ4J/QcHb5N6sz5lJUwsOf6pTCTd7F/cN8cnldbGmszApOSS6Nv7qTddSK0bWVVxplf4HJLQwg1XIk42nrgn1oRkw3QkJXB1PYcyo0amVCYmxcSccQUuDOWr2lZwXbQ9A4Pe2DpRVAsziAmw7vC58VTKtah/SKG1apoby3j9Mm86BHOOklNr0pUuTC1hy6dfVV1qFxdQ5UqOYKgQm5F2M74SoqpG0tUgfJvRZrT9VCH2tMb4AgJy2InS2XegexjPszoNsqJaLQuZNCAxFlfzaacPr1fivvgQyOV1f+RmyDbecWcMPPPB92NO2d9LtqblR7p3Mx+81Giyq1UFIwPP8/R7gMcVXsr2kV2rg03ygszMPfJDCj4jRvD5xBgpyNFDo6d/bf6w0XUNmneP76MMWDim2bZaDIdknXY30knkk7L0nBYGbAwMvN0rAWtKPaWnqZu51Owzox4zkF8fK3KakdK75IfGKn/fl8k9A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4499.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978f210d-67ff-4ce1-0f25-08dbbaf81cdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2023 23:11:40.1626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rOaxzi9ZSX8ivFyk/HYC/6h+zJR7pj+ndx2OXA6+DIvYfLxIAqXdiedDgsUUa/X0WIgnc7qF2NhK5/GRjqOxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-21_19,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309210201
X-Proofpoint-GUID: TuoK7zSzNisegA83RUPeSoXRezPYrgQ6
X-Proofpoint-ORIG-GUID: TuoK7zSzNisegA83RUPeSoXRezPYrgQ6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

4.19 is not supported or maintained by the upstream XFS community.  You're =
welcome to contribute to that effort.

--D

________________________________________
From: Shuangpeng Bai <bb993561614@gmail.com>
Sent: Thursday, September 21, 2023 12:23
To: syzkaller; Darrick Wong; linux-xfs@vger.kernel.org
Subject: BUG: KASAN: slab-out-of-bounds in xfs_iext_get_extent

Hi Kernel Maintainers,

Our tool found a new kernel bug KASAN: slab-out-of-bounds in xfs_iext_get_e=
xtent. Please see the details below.

Kenrel commit: v4.19.294 (longterm)
Kernel config: see attachment
C/Syz reproducer: see attachment

[   75.486892] BUG: KASAN: slab-out-of-bounds in xfs_iext_get_extent (fs/xf=
s/libxfs/xfs_iext_tree.c:47 fs/xfs/libxfs/xfs_iext_tree.c:156 fs/xfs/libxfs=
/xfs_iext_tree.c:1018)
[   75.487761] 000000001c8ced51: 00 00 00 04 00 00 00 05 00 00 00 00 00 00 =
00 01  ................
[   75.487862] Read of size 8 at addr ffff8882350b4d58 by task a.out/8319
[   75.489112] 00000000fec1508e: 00 00 00 01 00 00 00 00 00 00 07 00 00 00 =
00 04  ................
[   75.489991]
[   75.490001] CPU: 1 PID: 8319 Comm: a.out Not tainted 4.19.294 #2
[   75.491203] 000000001e2fb696: 00 00 00 04 00 00 7f be 00 00 7f be 00 00 =
00 00  ................
[   75.491423] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.15.0-1 04/01/2014
[   75.492261] 000000005b2b9690: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[   75.493434] Call Trace:
[   75.493445] dump_stack (lib/dump_stack.c:120)
[   75.494595] 000000008bfa4abe: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[   75.495768] print_address_description.cold (mm/kasan/report.c:256)
[   75.495778] kasan_report_error.cold (mm/kasan/report.c:354)
[   75.495786] ? xfs_iext_get_extent (fs/xfs/libxfs/xfs_iext_tree.c:47 fs/x=
fs/libxfs/xfs_iext_tree.c:156 fs/xfs/libxfs/xfs_iext_tree.c:1018)
[   75.495793] __asan_report_load8_noabort (mm/kasan/report.c:432)
[   75.495801] ? xfs_iext_get_extent (fs/xfs/libxfs/xfs_iext_tree.c:47 fs/x=
fs/libxfs/xfs_iext_tree.c:156 fs/xfs/libxfs/xfs_iext_tree.c:1018)
[   75.495808] xfs_iext_get_extent (fs/xfs/libxfs/xfs_iext_tree.c:47 fs/xfs=
/libxfs/xfs_iext_tree.c:156 fs/xfs/libxfs/xfs_iext_tree.c:1018)
[   75.495816] xfs_iextents_copy (fs/xfs/libxfs/xfs_inode_fork.c:562 (discr=
iminator 1))
[   75.495826] ? xfs_iformat_fork (fs/xfs/libxfs/xfs_inode_fork.c:552)
[   75.495837] ? mark_held_locks (kernel/locking/lockdep.c:3275)
[   75.495848] xfs_inode_item_format_attr_fork (fs/xfs/xfs_inode_item.c:244=
)
[   75.495860] xfs_inode_item_format (fs/xfs/xfs_inode_item.c:429)
[   75.500673] 000000007e4099b5: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[   75.501050] ? xfs_inode_item_format_attr_fork (fs/xfs/xfs_inode_item.c:3=
91)
[   75.501661] 00000000a3693a78: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00  ................
[   75.502222] ? xfs_log_commit_cil (fs/xfs/xfs_log_cil.c:393 fs/xfs/xfs_lo=
g_cil.c:994)
[   75.502234] xfs_log_commit_cil (fs/xfs/xfs_log_cil.c:377 fs/xfs/xfs_log_=
cil.c:407 fs/xfs/xfs_log_cil.c:994)
[   75.502824] XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" =
at daddr 0x1 len 1 error 117
[   75.503362] ? xfs_buf_item_log (fs/xfs/xfs_buf_item.c:890 (discriminator=
 2))
[   75.504108] XFS (loop0): xfs_do_force_shutdown(0x1) called from line 300=
 of file fs/xfs/xfs_trans_buf.c.  Return address =3D 00000002
[   75.504731] ? xlog_cil_empty (fs/xfs/xfs_log_cil.c:979)
[   75.504739] ? xfs_trans_apply_dquot_deltas (fs/xfs/xfs_trans_dquot.c:326=
)
[   75.504753] ? xfs_defer_trans_roll (fs/xfs/libxfs/xfs_defer.c:277)
[   75.504759] __xfs_trans_commit (fs/xfs/xfs_trans.c:969)
[   75.504767] ? xfs_trans_free_items (fs/xfs/xfs_trans.c:923)
[   75.504775] ? kmem_zone_alloc (fs/xfs/kmem.c:96)
[   75.504786] ? xfs_defer_finish (fs/xfs/libxfs/xfs_defer.c:465)
[   75.509734] XFS (loop0): I/O Error Detected. Shutting down filesystem
[   75.510318] ? xfs_defer_trans_roll (fs/xfs/libxfs/xfs_defer.c:277)
[   75.510929] XFS (loop0): Please umount the filesystem and rectify the pr=
oblem(s)
[   75.512597] xfs_trans_roll (fs/xfs/xfs_trans.c:1100)
[   75.512606] ? xfs_trans_alloc_empty (fs/xfs/xfs_trans.c:1077)
[   75.520389] ? xfs_defer_finish (fs/xfs/libxfs/xfs_defer.c:461)
[   75.520969] ? check_preemption_disabled (lib/smp_processor_id.c:52 (disc=
riminator 1))
[   75.521640] ? xfs_defer_finish (fs/xfs/libxfs/xfs_defer.c:465)
[   75.522208] xfs_defer_trans_roll (fs/xfs/libxfs/xfs_defer.c:277)
[   75.522811] ? xfs_defer_create_intents (fs/xfs/libxfs/xfs_defer.c:224)
[   75.523483] ? check_preemption_disabled (lib/smp_processor_id.c:52 (disc=
riminator 1))
[   75.524154] xfs_defer_finish (fs/xfs/libxfs/xfs_defer.c:465)
[   75.524700] xfs_attr_set_args (fs/xfs/libxfs/xfs_attr.c:271)
[   75.525274] ? xfs_attr_get (fs/xfs/libxfs/xfs_attr.c:228)
[   75.525809] ? rcu_is_watching (./include/linux/compiler.h:263 ./arch/x86=
/include/asm/atomic.h:31 ./include/asm-generic/atomic-instrumented.h:22 ker=
nel/rcu/tree.c:350 kernel/rcu/tree.c:1025)
[   75.526353] ? xfs_trans_reserve_quota_nblks (fs/xfs/xfs_trans_dquot.c:83=
3)
[   75.527080] ? xfs_trans_add_item (fs/xfs/xfs_trace.h:3345 fs/xfs/xfs_tra=
ns.c:753)
[   75.527683] xfs_attr_set (fs/xfs/libxfs/xfs_attr.c:377)
[   75.528193] ? xfs_attr_remove_args (fs/xfs/libxfs/xfs_attr.c:316)
[   75.528818] ? kernel_text_address (kernel/extable.c:161)
[   75.529425] xfs_xattr_set (fs/xfs/xfs_xattr.c:83)
[   75.529936] ? xfs_forget_acl (fs/xfs/xfs_xattr.c:68)
[   75.530469] __vfs_setxattr (fs/xattr.c:149)
[   75.531001] ? xattr_resolve_name (fs/xattr.c:139)
[   75.531618] ? evm_protect_xattr.constprop.0 (security/integrity/evm/evm_=
main.c:365)
[   75.532337] __vfs_setxattr_noperm (fs/xattr.c:181)
[   75.532957] __vfs_setxattr_locked (fs/xattr.c:238)
[   75.533571] vfs_setxattr (./include/linux/fs.h:753 fs/xattr.c:257)
[   75.534072] ? __vfs_setxattr_locked (fs/xattr.c:248)
[   75.534709] ? __might_fault (mm/memory.c:4811)
[   75.535256] setxattr (fs/xattr.c:524)
[   75.535721] ? vfs_setxattr (fs/xattr.c:485)
[   75.536260] ? __phys_addr (arch/x86/mm/physaddr.c:31 (discriminator 4))
[   75.536769] ? __phys_addr_symbol (arch/x86/mm/physaddr.c:41 (discriminat=
or 2))
[   75.537355] ? check_preemption_disabled (lib/smp_processor_id.c:52 (disc=
riminator 1))
[   75.538024] ? check_preemption_disabled (lib/smp_processor_id.c:52 (disc=
riminator 1))
[   75.538698] ? preempt_count_add (./include/linux/ftrace.h:696 kernel/sch=
ed/core.c:3222 kernel/sched/core.c:3247)
[   75.539277] ? __mnt_want_write (fs/namespace.c:345 (discriminator 3))
[   75.539857] path_setxattr (fs/xattr.c:540)
[   75.540379] ? __se_sys_fsetxattr (fs/xattr.c:530)
[   75.540986] ? task_work_run (kernel/task_work.c:108)
[   75.541533] __x64_sys_setxattr (fs/xattr.c:550)
[   75.542101] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:2839 kernel/=
locking/lockdep.c:2884)
[   75.542714] do_syscall_64 (arch/x86/entry/common.c:293)
[   75.543227] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:24=
4)
[   75.543919] RIP: 0033:0x7f026bfc773d
[ 75.544417] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89=
 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 48

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0: 00 c3                 add    %al,%bl
   2: 66 2e 0f 1f 84 00 00 cs nopw 0x0(%rax,%rax,1)
   9: 00 00 00
   c: 90                   nop
   d: f3 0f 1e fa           endbr64
  11: 48 89 f8             mov    %rdi,%rax
  14: 48 89 f7             mov    %rsi,%rdi
  17: 48 89 d6             mov    %rdx,%rsi
  1a: 48 89 ca             mov    %rcx,%rdx
  1d: 4d 89 c2             mov    %r8,%r10
  20: 4d 89 c8             mov    %r9,%r8
  23: 4c                   rex.WR
  24: 8b                   .byte 0x8b
  25: 48                   rex.W
[   75.546915] RSP: 002b:00007f026b6a9da8 EFLAGS: 00000297 ORIG_RAX: 000000=
00000000bc
[   75.547938] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f026bf=
c773d
[   75.548905] RDX: 0000000020000100 RSI: 00000000200000c0 RDI: 00000000200=
00080
[   75.549867] RBP: 00007f026b6a9e00 R08: 0000000000000001 R09: 00000000000=
00000
[   75.550831] R10: 0000000000000016 R11: 0000000000000297 R12: 00007fff53e=
328de
[   75.551794] R13: 00007fff53e328df R14: 00007fff53e32980 R15: 00007f026b6=
a9f00


Best,
Shuangpeng
