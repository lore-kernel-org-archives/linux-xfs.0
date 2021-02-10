Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09107C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 22:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB9BF60C41
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 22:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhBJW0S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 17:26:18 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2019 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhBJW0S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Feb 2021 17:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612995977; x=1644531977;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=TU5jSROIvbkMcX2RYmL0vxPJjdG8mahbecy2r6cfz7A=;
  b=LMP/AC1nfDih2WMv0m3RsQDSlxgjFl3/3JvgC3q6OYwCPv3YKRsXqyO5
   QhKOQ7lsUw1sfkNkCxdSNH/5/8/qxhy9sphd6yKxq1QZJzzc2C/mn5TCA
   TbDJSBSWz0fmprDwppp20qF3bTNd6rSrIy/abZciq6mO0Gd8RMhhkhcNa
   Nr4f6PX94X3yxiMcLHKM2oaIroMJupIW9kt3bFhJJlic7T2IyulkE7Rs7
   gYZeDbFpXBhm1PEGxA8gkbfenhkBc3eYYY+Wa3asOOq5bAOOBtjsZU0fO
   HZ0Rrvvr5le+pv7rEw3lgLSqfmpZ0RGoiW9r4bRyJLAidWxVxqXG3QbIn
   A==;
IronPort-SDR: S0W0ZhUgvK1uAK+GwMN/Jl0bpHCUaQWpXR6hsQ3jQ21yhVhmiPoiA52IDzMZR9qoCNYNF2R0aq
 ReuCYToIV602NxYzM8fhaDt3BXXAgLtx022yyYB5vFmS6zREsh4vVDTAVjMpDHl+4PA86T+Fk8
 EzK70E6Fif7PbQbx2BAJ2NgpGOqF+cqUtclN1KAv4D6LjvhsaZcptv1ZYX8aVWAvn/vgGRyRpU
 kL0WSiq7mfTmNoa+aKmEFW5KQ16nV584/d/zqQN9NAnmnZGrzgZ949RbkyZENZ4B3YJziU5Gx6
 37Q=
X-IronPort-AV: E=Sophos;i="5.81,169,1610380800"; 
   d="scan'208";a="160875736"
Received: from mail-co1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.54])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2021 06:25:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncR1x6nd+dIa3qb2hNw3lgdMWeSqmBGuqy73norA+yT0IA90HtKg7gUrAvcvMG0Vr86j8uIJ4as++dF00q7j33PiL63CFZ7jC/sU60FYtHiK96tmu0N9sT7fGxMXYrjwzfL/07bZRKY06cm7vqYVBDFJwFKwGQOkT3Ob2NCyG0wgHSWoCqGV96TZjvaTByDTgSmUa8F6L3jlPvEcxwSsSPlfEf+ilA9BfrjSlN8kh5tmi4yRz2ceCgkd2yOhbbHUW0PIppjPyumMDFq0F/poFxS7qtctkXHd4hSZ7yPIwMEJdqBb13/MxlONem0y358R4/YW94Ohqc8MzRVzCFkOyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ms85j7CCgIevU5LJS1Al7eH56ggTj+CxEKSZwDRPpI=;
 b=Sf5h4Q8/80GvvE+HC+dF7p0xgN9m98AP++3l88NQlI9HV7hdPVhe89Vi1GdrJAnjMfPhIjYi6ZmaM6WYTakjgKVT9KfAOPz8FPSwgawQT17bTvnh5yLc74dLoNwdc2BiDURF4L05uUHSH/Gs0FrpQnEXXGgolZTs2mgxtNxs/YuDFIcK2bEbeBcAwlM5rdSNwAHwKjmMVOvX/ia7cyWGS69MUeyStj/cvEketvc4TFFRdc4jvM4gjGmkzKjaIQr1ECc7LEPq6+m2cfyP2MR5I8iV8x/KcQhIhLPq3Xu/0nc8Z3KsU5lyU3ZrNI/8yGiKRrMaAHIBsaWzvjeYTAYv8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ms85j7CCgIevU5LJS1Al7eH56ggTj+CxEKSZwDRPpI=;
 b=IiiQiffJnnpmp3h/5Z0Pg1E3/ErkW9BTtdYowoCRP8cs4YiFPOw/O6GtoSoWScieuyAvHhy55OI3fzTHgxzOSF+Makk0TVuMjCZFYa1Ol/yxoe4n0vN0FtCNcUYjwD42Ac/OK4Y0BI6Wlys+QrdGW3UUI0kyclDci65kMsKkO9w=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7567.namprd04.prod.outlook.com (2603:10b6:a03:32d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 10 Feb
 2021 22:25:08 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3825.027; Wed, 10 Feb 2021
 22:25:08 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     kernel test robot <lkp@intel.com>,
        Brian Foster <bfoster@redhat.com>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix boolreturn.cocci warnings
Thread-Topic: [PATCH] xfs: fix boolreturn.cocci warnings
Thread-Index: AQHW/+jp4tDkLzyfjEeAfuLQ2dkAeQ==
Date:   Wed, 10 Feb 2021 22:25:08 +0000
Message-ID: <BYAPR04MB496561665A02FAADEC3D885D868D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <202102110412.GVAOIBVp-lkp@intel.com>
 <20210210200916.GA96657@7319c0dab462>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2607:fb90:482b:10d6:f4fe:f24b:7108:1811]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6bcde688-07fb-4d97-4a5c-08d8ce12b965
x-ms-traffictypediagnostic: SJ0PR04MB7567:
x-microsoft-antispam-prvs: <SJ0PR04MB75670F72E2E4B241ACBE618D868D9@SJ0PR04MB7567.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x0clep87Ryb8VeFjbyXC5WlDtB7uMW2Pt9uNmGAGqSa7px+1VPUU29FV2/OmuMWrp37/sj4331WKvXpiao1xDx1EG9jBpjAsKDw1qyULg1W90+Bzk44fH3DWDln0Chi/TPUUdAdLZN9cj2MhH6ghA+LHXXPYO1KarckOCxsy1nzsjVE9PVss+BXoQuPQZZhiyL2Mv81V/npRMD+cKGETX/FMX5vMT7In2hvgpXSRiHMO2Lr3BWIVfCJPKVhRZbXqX+kSqwCRnVweh7pJs97Zl/ulF/TcurSnMmHIYK89dfqEcaqeqb7cb9UH7ty5I7B66m8USxq7S3iLEwXtmS3M8HD7iy2Pan/J5+MspabUMZW6AZF6/vSotW8EWoP/4QjeriDt6MIyux8TFCUrw+/i7+p4fJVsFmL67OX9PTuiZTT46HsLXWO9mzmt2ySkcuJCOAVyJ2BqYeINh8Yp//4GsHayPVYSPJo5iORe+1Zss51Go2A5GOpGlcNjx5xvuvMUEh4aIzcjIzjLYkYrtIW2/C4mRNhxOKkT6uyckNXpQznIuhkquVVGPrRTEskXst16Gss9QcbUc8O7QDPEsA4QQ4z3Bb0xRtOHedLBsM0aNno=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(478600001)(5660300002)(8936002)(33656002)(4744005)(316002)(8676002)(4326008)(55016002)(966005)(76116006)(66476007)(66446008)(9686003)(64756008)(2906002)(66946007)(66556008)(71200400001)(52536014)(53546011)(6506007)(83380400001)(186003)(7696005)(110136005)(86362001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6HJByYUvxe++/MrRQPnJUFAsr4bmA4SpGiS/dL0AOXDtMd3435SMqJNbqrM+?=
 =?us-ascii?Q?YmeZ7bVRbJkdHdLqHiKIViOjtZwpH8m5I4YQFAZ+8PPctw3iE0KS05qdmHX0?=
 =?us-ascii?Q?ZzaVgVDOdlZW3bKmGbkMkpfWiNzxgtGgfJmkG9m44xGquJlQgmSb5T6n5w7q?=
 =?us-ascii?Q?TOGBkB7GG4aKXFoWoIV9AD6/ipF8+AvB/UNpwfz1AjREuFws9h4Oxf3VKqus?=
 =?us-ascii?Q?XnDq8USEzCAom8wKnrpK3hHvEgrt6LEN0dbSnRQTKJ6P1kHlv9AeU1crWYL7?=
 =?us-ascii?Q?TGCWviMEDIeeglLpRjWnVZWmIGMTV8wigQ+cwMIB+X+BfYYG6tqBxijiHzhd?=
 =?us-ascii?Q?bpltJEiO/UVG0avexWqVRBYFgffKMXJcuk1NReF+wUeoqw8Hx2zRwJcOilr6?=
 =?us-ascii?Q?YvipFyJul8cmQC+cCRWHYZfV99HQTu8lOTeSSASxnPd7OhXQZZs28O1+PhYj?=
 =?us-ascii?Q?QUDPfhetwxilJsxUveLmZoDzLhNPPLGnkFmHvitcHn1hIGzzm8QoZx8VAAsw?=
 =?us-ascii?Q?sUxDHWpgIijnSy1RWNIgp0WdEIB1EVHyz0OLufEv1zW7ADhcuy8g5pQ2i9Aa?=
 =?us-ascii?Q?bV3NzkMWE7s2Tng5FUM/6k6FEsVVzwQzng9inziSTEim8q37CwSJGLVSpCjX?=
 =?us-ascii?Q?5XwYa1hu4DNNRidPOAT6nu+sA4V4GwK3c5opcn/+/Cz7zuQCCf+dRC0aXf+g?=
 =?us-ascii?Q?18jEkmym1UKvI7pE2WD6f87ThjVQHKzootxA6canPTH5e97zLezQdpRMrH4A?=
 =?us-ascii?Q?v8nVwNc00ph457j2xRpOTyccd+JGziO758gOAlUfpFn0VVD3t57nH7qOdoP2?=
 =?us-ascii?Q?7j7xizzADFZX3G29EyokjF+yaLT6AQvLijncQtp44uLnMt9TLQAioJ6IJTsz?=
 =?us-ascii?Q?BaupIIVuUvOWqcUoKh1xBCJqBLmw1uEO0P2ljwwwXJh61a4zWnMyQAC73/1t?=
 =?us-ascii?Q?VlBj5WU4JBM3bi+6IX205zkxGHPsbkbky1MDlzzxvDXE7pnBp0quFs6uURXI?=
 =?us-ascii?Q?b5shHbguE7NgNNSfCxQ6R/utdrdsPur9OBnOjRIIsajemsCPzcrzZ+cuB/ac?=
 =?us-ascii?Q?YMjyHmlHblEochDZpY0uxeZvxFFks+Sxq5V/L4CpMAE8pjSM/G8HVb9YYAn4?=
 =?us-ascii?Q?vaN0k69bzCRtMR6VYHgzTTRo/BYRrHKwLE5oQNXmR8HG7kLWL3gNswWlR+/o?=
 =?us-ascii?Q?drAeltlmWXaXKm0L7aqW5zQMxy/ihHWm+KtvUQchMDSLOUFqYrDX1ZRqUTmx?=
 =?us-ascii?Q?W8A5etiAWfMUNY7fbF2lFw5TAVPPjaKwEbehIoM3u0kDzgXgKHXRV1GTwbYR?=
 =?us-ascii?Q?WBMunlbp9l8SqMKhf1nxej++kS7oVI/Dcj4YvlIA66VnAOOVPUJMmEqKI+QP?=
 =?us-ascii?Q?Wxll+ZaOmWP/V0yYSfFR6VTWHph1Ezjt3GbXyYt/tCRVoKkbvA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bcde688-07fb-4d97-4a5c-08d8ce12b965
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 22:25:08.7122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: byFkvauUqEQb0rIUbtXs94JlBKVMY3lhjB9HnKGSc4l9QyhWSeQaSbMPdoq1UtGAPTm4c2pjezTjrdoqBCGLIt1CmP7ZcyUqH4jwcdXHIbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7567
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/10/21 12:11 PM, kernel test robot wrote:=0A=
> From: kernel test robot <lkp@intel.com>=0A=
>=0A=
> fs/xfs/xfs_log.c:1062:9-10: WARNING: return of 0/1 in function 'xfs_log_n=
eed_covered' with return type bool=0A=
>=0A=
>  Return statements in functions returning bool should use=0A=
>  true/false instead of 1/0.=0A=
> Generated by: scripts/coccinelle/misc/boolreturn.cocci=0A=
>=0A=
> Fixes: 37444fc4cc39 ("xfs: lift writable fs check up into log worker task=
")=0A=
> CC: Brian Foster <bfoster@redhat.com>=0A=
> Reported-by: kernel test robot <lkp@intel.com>=0A=
> Signed-off-by: kernel test robot <lkp@intel.com>=0A=
> ---=0A=
>=0A=
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.=
git xfs-5.12-merge=0A=
> head:   560ab6c0d12ebccabb83638abe23a7875b946f9a=0A=
> commit: 37444fc4cc398266fe0f71a9c0925620d44fb76a [25/36] xfs: lift writab=
le fs check up into log worker task=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
