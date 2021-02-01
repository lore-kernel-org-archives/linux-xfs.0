Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C923C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F3F64E27
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhBAC3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:29:15 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:6818 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBAC3K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jan 2021 21:29:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612146562; x=1643682562;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MkwiAKnVn4Kq3+/DrLWZ2HV+yZ/16KfSQCb3YpwW4fE=;
  b=o5Ms39Y1wwkFC0cPwHabS4RFGPvNfP7hAWzi5ZheVq+gAAVLJF2uElvp
   58oAcKmlnumbFk1x7prPYopkF34iAKVYrv/TS3Eacg8mCykFtuW8rWqZd
   0rKpOp7thxWqQHQXjCbj+PR0zCuTwmbupdJUrUoWW2P5Z5v8Eqlk0c4uV
   AfQENexxRy5HcQ4quhKdT1N4iiVSz1zcNp+2SyHGuGaFfkhNLke8Hq4pw
   k7cO0ZcpytjYzLkXujhXuh2diZw+D+e7LL+dRoCo9oQI4fl6giG8cjAtC
   TZoBM5kp0fiTINPSqEgpuOczzDwr4Bc50y4pUezf5+A83jcwc3yZ8F/t6
   Q==;
IronPort-SDR: ChDD9EX+WPJN/vGX6GcwNG8oSidqBPLy13Puz5udvZNahN6LdGex/0ixz0j5zB7t3wHB+Xz8q0
 m+LywSZsqZ0WPDn0Sl/rqV4GXN+J3aDMBaVbqFc56tQdpuJPk56UGWfxZhafT9FFnFWn6GcnLJ
 i4gh1JgUHV3qp0matY7cf3wu4L5RpgSxXz4eodva/wsWGdbhQg0HzINOCyID8KgwrdlgHwjeFQ
 dpt+aaKxYyjY5tU58SBeuX36gxvjXtK9YKBZQ5jCcRhCLn/dxnf9jYqvovwJ7b9fIuMrElnMSn
 NXo=
X-IronPort-AV: E=Sophos;i="5.79,391,1602518400"; 
   d="scan'208";a="262838876"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 10:47:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ja1XsQjQbjIwPvgFZJRP7wHgVFC3WNrFscPBv+OQ+vnnu/nVzWT+QheESpb4ke+RZ8cD/TxWUxsv2nu4/DU4kbKgrvI8IVw+mzDH/fAM56BFozMG/AxllYn0AuqDdLvZE6UWiCFTiqrPApBXnjpOnjlKM6U90C3EgF/6LSL06r1+dtqaE9jopK5xJs8PhaAZl3CXPwMVQJ2DjTRW2zxzYSUok3XRZNygheKlQLmsX8gkpwTCiiJGZklMTf2keXIBJLVwWkS1nSRcmPunIwrC5GACEGwn5QYYpD89DhNRj/WcXFUcN/nV2nTfHmnxREDStw+5N06BW+c9YiZK0I4cBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkwiAKnVn4Kq3+/DrLWZ2HV+yZ/16KfSQCb3YpwW4fE=;
 b=ALXjmHy0adehQ5T+pkWkV603YqBqc/Atns/exBJNyQSTHPU1rHtu9Rdbie1yrVJaQRO2Q/1znPA2HvQILx0Er6T2pyW+kuOkT0cA5EcRjtzc7MNpXaRTtm1D5Bdi6TwGBiUMLdRxEsmpxDLZqRN1Ju7vZL19EWbrmNCG5rvjg/JWPb/7NUXLwsDka+5GkMFBkQRpf/av1oqOc54LaqtbvWscazrdeh7O98RWXIIVr8GyzZbo8bgw444VmwRnvTst5Mfm1fGoHFC972U1tzvyEIwCkw7F5gD8+QhuZov8n7XhRULl/iLa86nsQ4//8Io8wuIRhDMweal47UlzpKdzSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkwiAKnVn4Kq3+/DrLWZ2HV+yZ/16KfSQCb3YpwW4fE=;
 b=OFU1RN8UCDqImIugoQ5w19NtUAPlIDxieZbFaEwm3asbXZ7C9NgP44+9nH2Q9UpgngZZ9wxa3XyPY982WFuyENmUm9YRynNrB9bPq38JlgWQYA8EffcmeHi7SyismKhRahg51L+Ei/SOkrXMzQufd6pG4O3HjCWWQA8pJ/RMMto=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB3958.namprd04.prod.outlook.com (2603:10b6:a02:ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 02:28:01 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Mon, 1 Feb 2021
 02:28:01 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [PATCH 05/17] xfs: clean up icreate quota reservation calls
Thread-Topic: [PATCH 05/17] xfs: clean up icreate quota reservation calls
Thread-Index: AQHW+D7IaxeBEba61EujctZHsFjOtw==
Date:   Mon, 1 Feb 2021 02:28:01 +0000
Message-ID: <BYAPR04MB496566C989CFEED17446442086B69@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214505716.139387.5943630704810313558.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 31cd3e20-f652-4adf-ab75-08d8c658ff3c
x-ms-traffictypediagnostic: BYAPR04MB3958:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <BYAPR04MB3958E73093248D7FC6DE016A86B69@BYAPR04MB3958.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:357;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ag4aYVAbrV7ANIN1PvytY33SyKHZmiDKkr9U4Xz3/feTPk2h6g2iP46T9UOOBpe9KxxEj3vcoRpoHCRZhIi9EbU+b6qFcd2pc6ZXVM7rcvjKMUs+IQhufku/lcUXJNNprBdtezfKtn0k5HIC7egyqJA6/hi+YGzT+36u9eDtsdz9vaH9z2WMweZ49x0O4hXSO4yUnQA8veH5Qc0+tf5sDxq7h1mulV5ugnuvtIsYPteDNJpd5h35UdMl2EaQgI3+X29zLQDh3sTz4Vmg3kPLT17Wy6Ll+DB8hQu2OuNjrf8xIgyxsnqWdYhd1zvzIoSLW6AcPPAi6QHyvamr2e3wgzDYqUPzry/G+i4UdbpSuNvAQLIq8l+wfRq4MQyl7vuh+b7sKmF0OGNvWwtCI5QGSr/eCQP7pEiCebuqy2H4hMTWjhadBZNxG1wcj3H3/kBF+tAaNFDuB3xQbqKvbtXzOzxjyItUuXT0tNhjuO5q2EKQeFAF1+xZSeHrD0cWM3+zYlaYNB3PzSPVg1dy71ICGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(316002)(71200400001)(15650500001)(55016002)(83380400001)(9686003)(54906003)(33656002)(7696005)(5660300002)(6506007)(8936002)(26005)(4744005)(8676002)(478600001)(6916009)(86362001)(2906002)(4326008)(186003)(52536014)(53546011)(64756008)(66476007)(76116006)(66446008)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gafwG37xyY3wqEU4nEi6l7/es9PkcPdkIBCsX8WuDtnOKJ/Os/zwW19/KRz4?=
 =?us-ascii?Q?EeshPQxw/ftaoxE5NpDM+LO61XcSrkVo9yYlIjlyOonw6ckuB+TMv4tfjHYF?=
 =?us-ascii?Q?gxlXKf1ra4kQWopDomEZ+sIZEr3LFhrksGShact62q7guRCE6xXVo2Z2rc3W?=
 =?us-ascii?Q?pEBjLYcPkyN+Oj6PY7xinrLigUKIOhr+Vl7weFsRmLcloGC9RAa/vnk+jJqw?=
 =?us-ascii?Q?W9ifWiaZpN1EIrbJcouHSw6lp064z4PnRj/vWf1eSF9Uh1hqsWEUB/ryM/Da?=
 =?us-ascii?Q?0J+Zz0eBkcui5rHIy+llhK8JN+eNrEz3T3xuqfhzcdybUVxRHFlJRixIwef2?=
 =?us-ascii?Q?E2Zxu0T5wJ0h8OQCLjgln/ST/bNoflNhie77WY/nsVQM/NyMW6U/VAEStox5?=
 =?us-ascii?Q?2ZtqFEO29Tr3GoIS0OLOgVMxmOK/wZEX3MbrYQ2sa2d43C2LLgHIzXT0FAtc?=
 =?us-ascii?Q?hSAi4RHCHYvZajJB3/AyWPSxl4rWOjSjbBKVEAe5domrOOtjm8GIx//jEhQF?=
 =?us-ascii?Q?+xa9Ih+J43OtZns3Xj7GCAM80TjMMjf1Zee0hH4N0NiZjuED1HzFwQ8I+jU5?=
 =?us-ascii?Q?rXfCmNljZA7mS0q4oIke9c2wE937cgz/IskiuZiIb+j6l3zo23InpioDklHk?=
 =?us-ascii?Q?xgWr66gEcuQfcvNrPBKIZIGZ2tsH3T8YBSPTF672CIPLMwOcaNwt7nyZewNO?=
 =?us-ascii?Q?X3Sd+nk3Un5M4bHPz6BO+dKfjfepXYi4e1u+V6tl3RaexGM/zqhcH4I+4DPv?=
 =?us-ascii?Q?drrKPFFaM9x5Onp8T6z94gcsLzbTeQ4CmsGQewOy7ha5PCtPp3jOfJ4KP4OO?=
 =?us-ascii?Q?RjipGPiWHqEyR65sSBIc+NJ2erajGthKO1lGhgz34bcql7z6Q5JO1tLXepfz?=
 =?us-ascii?Q?8sayo09hIT3Ah/7RcBisMZyCpp5/tCfddo+pRxtThX45kS4ypnv2ZvWq0EXO?=
 =?us-ascii?Q?II3vAbaJCqPufdSNSJN3wm/JxtFf7hJ573o48eixfWLWSadc5OH+KfOFI46S?=
 =?us-ascii?Q?XZxEuPD1JwvqagA83k30EpIQH/Ut2p6u15DsutGITAgt68UiZpT2minbgdCJ?=
 =?us-ascii?Q?Q9Q9mNG6U/mtoVWwWVlLSF0QTELjUg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cd3e20-f652-4adf-ab75-08d8c658ff3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 02:28:01.2804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVCsFBZDTpH3GzVl4jKKF12hVJ/TTWy/oYbgjFaudtE9R3PLPq3KJoReRePTmr1wf2it1Fihrp/puN4S7rg3K7HVwstGcyjcPsvalKPW70A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3958
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/31/21 18:05, Darrick J. Wong wrote:=0A=
> From: Darrick J. Wong <djwong@kernel.org>=0A=
>=0A=
> Create a proper helper so that inode creation calls can reserve quota=0A=
> with a dedicated function.=0A=
>=0A=
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>=0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Brian Foster <bfoster@redhat.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
