Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C462C63706
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 23:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiLFXhW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 18:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiLFXhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 18:37:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8099C43ADA;
        Tue,  6 Dec 2022 15:37:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LKrLk027044;
        Tue, 6 Dec 2022 23:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=emf+8KC0xVW+JayHoWsnht2mRtjY7FiFZmeWcCNPDMs=;
 b=VQve0R+3DgVZHQH1RD/8/NCJ5au0ograA56RvE2VdKG2HtKqQem6zxPto6fkKaUf8c0z
 5pz/DEhKTaLtb7PtpAIgKCpe0IaffDqS87izxfgzJUUoDHX+7S+LdOoCAZT5GafDJzlr
 NhBAXD1YiCnI571PxUNMoF1m1KmHVD8qRoATUqVOx+S5gT3BO+WXL6slRd1Dmzk6T5EN
 o0dLT9othBPNGqOHvXNz+KJGstQJIEm/pHQAwVFjys02LMGaIaxZAqIMeT8IB/XdG43A
 SfyoDiiWiYIJE487b3uZ9ulh4E6o5p7v61dXQvQansj91yb4StxhJ7cm+N+Ibar4J2Dp RA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ycf97p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 23:37:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LI0jw031927;
        Tue, 6 Dec 2022 23:37:05 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7veaec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 23:37:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUvXlrqcNHJ/nX2gRVJDlbjLQawhaiL+UzeGPjCzMN3uAP+QH43fczNQ+wbv88IqbjHHR0gcLiZ6g2+pXOs+YaGn3EKA4QwMqY4OJEkvHKTPe7huLsZduGQXc22xg26U/yaFBx13r/rREgY28NvM/I8d9wi/giAGOdrnReeQb5ILVQeWrwwM9qf6J2+jqBygCUvrOyyPoqxNzZAtjaEWCUr7waK9QdTMRRJ8uC2rmXSfA6Bs9nb/i/pncEfgJbXnFWGfJHjwOx2uDizSQMrLcHMhkz5qAOf74RFErWerG7jnj6Zs4QWMTl/ODJ098ijbKfZ/ZdyUG8491wF+BCo7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emf+8KC0xVW+JayHoWsnht2mRtjY7FiFZmeWcCNPDMs=;
 b=iObnumLSCdIthHA48CtYlwn8dZ55Ux78iOY3xI/ydpoEohXGE/azjSWqllf4tV1Hz36ooRMOMDvzgj4gdQv1xKp9o79uNtZLj9yasmSUti9RmL0MB2pO9XGZMdDrwLePwcIP00BqLu0A/GjNQKMhOGtmVX2miwoNvCwyEW97GWl5YSvCjj2w5Eu1fOXsPfLu+5in/OT7prnLNSsFYA+d3FDwaSMDF1x9q3+l424l9X60Q/I6IgvPhFWWKKVIJZld4oc9kTkbVo3qmefg9qIHPfqdaToVwet17ac6o/4RiF/i9Rm7NJ6kj67NqbipUAR8Salzf/UOiXdR2+WdgkocmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emf+8KC0xVW+JayHoWsnht2mRtjY7FiFZmeWcCNPDMs=;
 b=pncsBI0Rxj+Q7Cx3wbYCfiNelNYs6UPkMXGdqsV+cA+Gm7x/sFfLUaO7IPog9rKlOBSL+F1htZEG3/B/g/OlNBHw+6Ym7bCMOcsaTubhzEpU+6yP416kwCbU1YKfgGTqKJD6ulmJI54OZqXQbzWIFp6MDec81Yz80osiKm9uB60=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5053.namprd10.prod.outlook.com (2603:10b6:5:3a4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 23:37:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3cab:6ff7:cb4d:b57c%4]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 23:37:04 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ZiyangZhang@linux.alibaba.com" <ZiyangZhang@linux.alibaba.com>
CC:     "djwong@kernel.org" <djwong@kernel.org>,
        "hsiangkao@linux.alibaba.com" <hsiangkao@linux.alibaba.com>
Subject: Re: [PATCH V3 1/2] common/xfs: Add a helper to export inode core size
Thread-Topic: [PATCH V3 1/2] common/xfs: Add a helper to export inode core
 size
Thread-Index: AQHZCVpXkEtEYEkVAUS4Ilp6+VqiOK5hhJMA
Date:   Tue, 6 Dec 2022 23:37:03 +0000
Message-ID: <b5374108cf81bc325d27af16bc3d4754385566dc.camel@oracle.com>
References: <20221206100517.1369625-1-ZiyangZhang@linux.alibaba.com>
         <20221206100517.1369625-2-ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20221206100517.1369625-2-ZiyangZhang@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DS7PR10MB5053:EE_
x-ms-office365-filtering-correlation-id: 5e618051-a942-4f7a-9d76-08dad7e2c7ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: raTVD9SWdSZw8zKpp01NRWclNGtQKQCC+4fi1diEQh3/tjHn2LTvJoSEpCNqbOy5AX77IPujm2AOzcaxho6XtnNU7H/4SzfpxruSuMPspisKo1fTaJcUzxH0L+AQu//AX+3S1xxcT4a3nCM0KoXHmRAuprInmQTceRIpoR1C9hX2QYt7TCDaTuQkqTtHOo90arBUkhKb+AbBzP+QoDVZAo6Yc8tZ0j9GyXI6NMIguDyoLKJAprM/dlN7iBtE5orylvMM3aNw04acHKJ6xSWdTLYegRmIEXsGT0XWDLKV6jbgbdiLw2Q3DoTSWf4Wb7rBX7BX5b0PXChNuMe2RrwjvRuuEpVRyBkjrENv43V0ifBk/nkQNqVoGMnkSLzSZF3gU8Yl2T8nzWQ4mTbps4XX5fU0iTX7qdxfPjNKWUvyjIV0mcnRXjlIpYL6ngA5/VWjc7bnrXlx7NmACC1TWysllQYlMpf5rYJ4s9Z8jQbdbAxLe5YKgW0H/78oXOf438hYP0t8N18N7JyFSLwfHbWR6J17ildD8nEXgqd4EFPTTXteRfxMqbexhTU3pDOcnvD9LMjdXtaC85BHp846PJAt0rsEEuhuuu+IB9rxmIR4mmNdUvF89Z31oYnqh3f2mkyTAugHFDT18n+Fvn2FhGN8DXGnwZVYfzpWG1E0Y4fy9ctKhTGoyRQeSTSBBg/oaKqb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(83380400001)(122000001)(86362001)(8936002)(44832011)(5660300002)(2906002)(38070700005)(41300700001)(4326008)(8676002)(478600001)(26005)(186003)(64756008)(6506007)(6512007)(110136005)(2616005)(66556008)(66946007)(54906003)(66446008)(316002)(66476007)(76116006)(6486002)(38100700002)(71200400001)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWp6RENVSVMzTWszbEs1bnFJVjM5K2tJRzNYcWlKdUc0ZDZ4TWRJSGUxUS90?=
 =?utf-8?B?VWJDcVZyOE9RYjVjR3luTU5GMjd2aldxZ2dmSzZqR2wxaWNrMzRzeHVGTXZF?=
 =?utf-8?B?ZlhVUUVtMGtSQURyTmpVaUNmUzcvbUl0ZklCK01kaC8zQ3RMUVB0MDRvbUp2?=
 =?utf-8?B?S1ZtbC8zNjNROERubHNjTmpRcmsxVnJaeW5wazNObzhYMU5pUTdMdmRjQ3lE?=
 =?utf-8?B?ZWJJV3o0cWthaG9GTk1XcTc3VFVxNjQvL0Q4ekFVOVZVbFNkYW90ZTFIdVcv?=
 =?utf-8?B?WWZxQjRiV0tabFhBYTFEY0EvSVRSc3VsV1prTnlWS2FxMWFjSjB6eEdmb05a?=
 =?utf-8?B?eTk5bjBRU3FnUjdkZ05jL2NjZ3FPcXB5c1VlZkF3ejVPaUVpN2E2SlNOdERU?=
 =?utf-8?B?VFpDMFVXQkRIbmVSK3JqRXRlcDdTenlSQUVtUXNrVGFsQTBvbXNlVERXQ3ZI?=
 =?utf-8?B?SjdCS0IzUWFnZndGMy8rZjl3REU1TWVYc0tpamlkYWVHbmUwQUJ6TjdEc0pl?=
 =?utf-8?B?RmdjblhHZkhlRHRWSnh3SFNXbnZ1Q2ZPb255UVplMWtuQ2E2UGdNNXVXZ2ZB?=
 =?utf-8?B?a3MzU091cjlFZG5DUXkwNWQ4YytKQkM3ZWVPVFlrWTgvWVhmNVRIUHFmd1Rn?=
 =?utf-8?B?VUVKZi9INHVyQk9hV2EwQm15WENGTllJYU8raFp0cWdoRjVacE51dENCSGcv?=
 =?utf-8?B?Z01KYUhYWWdpNFBDWUQxWDErU2NhKzM4blRYNE92ZllzVi9JSFpPTVluVDRE?=
 =?utf-8?B?alM0dTJ2WGpYWU9tQ3d6Ny9sdFFTWHczekpFdDZyang2RCtSWlB5a0Z6MWdp?=
 =?utf-8?B?Ui84Z2xFN2JhRjhNY25NOUg5a21lL2ZaS2ViTVFiK0JXMUNMQkgyOEpGa2VX?=
 =?utf-8?B?Ym9DZXhQVGFKM2h3NEN5ZzVaNjZVUHc2S0N3SzNzay94TU52RDk2T0JzVnVQ?=
 =?utf-8?B?ZTFwSi9qKy84V0tyZzNzc1F6cFNaUkZWSUVIbDFjY1ZZYWpMWmVqZEVwQVQy?=
 =?utf-8?B?bnBGbm1MQ29zQ0JhbXl4ZnlyUmJTc1BScE9nNU1YeUJBd3d6eWZDczNGU2VC?=
 =?utf-8?B?dnZiWDdhQTQxTFBJWHg2M2pETkQ4S2tPMHhFNzdUUkJJVmJQQnU0U3dhUnZi?=
 =?utf-8?B?SFhyK3ZkdWZKM3FYZXkvZ3N1d0FtL0tkN09xSUpDc1dEbXZMVi9MN1Fod05W?=
 =?utf-8?B?OVRSRlpwR0RWbEM4TUoyMUErbWZhODRxQjJqOHAxa3FaWW44WGhxSFFWNWpH?=
 =?utf-8?B?cWgvZzZoeGU4NTRtL2xCSkxHUmNrdDBEUjBpdlFoYXg0TkJQbUNiNnFPWDdP?=
 =?utf-8?B?dTJwK0hhU2ZwU0FYaWF5WTIrQ0ZQSE5GaFVPVzBaejA0cml1RU9FTStHM24v?=
 =?utf-8?B?NGRUcENLeGMzOVZHaWpub0IrM0RUamg3cHRuaVNmVEtwUWZZQ0VjYmF6cFgr?=
 =?utf-8?B?MU9NYUtLR2JRSit1blJYUS8xS0pIQklsUUM5UEN4U0kwQWo5amQzejlVNlZr?=
 =?utf-8?B?WHZwNzkwNnVJakhpVFIvRjZCcEJHOGF1eDQxY2JvTExzQVhqaitBcEhrY2Rx?=
 =?utf-8?B?Nlg2WHBHQWozRUtmU00wNExrTlFLV0UzbUJzSzVuaXdSb3JKUmhwTVNxV1NU?=
 =?utf-8?B?aUU0b2E1ZHVkeWI5SlZ4N0tNQTlCS2xEZjhCOFJmcFdrNDNtYUErK2p3Yk9I?=
 =?utf-8?B?UmFoMi83TTB6ZFkyS09VN2xQcHh2ampxOHVTZFJzWGV1QTdsTHJJYzVMejFj?=
 =?utf-8?B?T2hFOGdKNzlzK1hGb2J2NWFrd1lTaElYWEFoWTczWXhITG9HbXlpNG9UcXpF?=
 =?utf-8?B?S0dMUmdYQlNlSGdQRjRndzFrV2xVS3FBL1lZOU9tM0dMaUhsVFp2YkYrNVlM?=
 =?utf-8?B?blUzVDE3eUF5Q21tcldYRmJYSklHaUZrdGFqM3FncUxXdzhvWURBNVZQUTI4?=
 =?utf-8?B?NUhiTktOdnZhN0dJcDVoblZHcGRlMzdxMDhvSkFJb2VLdllpOHdBd2JUbFor?=
 =?utf-8?B?eDUvaFhaTUFQZlprRjAwTWJ0VVFZWXM3d3J1QTNXZDBrQ0dEaHpEaStUSkFM?=
 =?utf-8?B?U2NXbXNLS2N3Tzl1U1QwazZQTlJhdFRBR1FUL0w1cTZ5c09KaWlwdmZLWGdX?=
 =?utf-8?B?Y2hhdGE0citSOTN6ajYrdXhZSUR5dVZzTU4vU0htK3psdnBSSlpVM2Z6R1Bp?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A326ADF88360D644B2279E528D68031A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QWF3djcySUwrb2tvSEJLTmxQdlREbkEzU0VwZE9XTUFnUHZlOWNGOE9CRDJn?=
 =?utf-8?B?RkRFVXVrTFlLUnpjWGhQb3V5aEQ1ZXpjZEhCM0N4K01KWTlGUW1RVkszMjFw?=
 =?utf-8?B?dWpSUW5TaGFHMjZ6QkVZeEFZSEtGK0RKZWR0TkYycURXa2dtcmZYV0hCRmxU?=
 =?utf-8?B?cHJML25KV1BzR0lBa1lVTkVyUGZXa2lqWlNEZHlXd0trSGdITC9sb2thdFFr?=
 =?utf-8?B?Zm1wZjF4WVpSUXg2MHowREtoMS9WY0J1RlY0MkR6d0lpdDdaUXNaVktITW52?=
 =?utf-8?B?YVF6MTJKV3BmektSckkwdi85RVkrUWNFNUt3K3hoOHBWN2I1N2Z5OVNTT08y?=
 =?utf-8?B?MzZFZ3U4UG5qdDhLaWVGQlQ4TWtqcUJlcWtUTEZocU1SODh3OFdZOEtlS1Y1?=
 =?utf-8?B?b2VOL1dtK21wSmo1SmkxdzhiZVZ0UksxeGY2REZ2OTVLdmo4VEZ5MzQwMTd3?=
 =?utf-8?B?U3cwWTBFRXJjaU53MVE5dlZTNHZ1czhLbU10V21jbzM5MVNuVVA2dTJ2dUJS?=
 =?utf-8?B?SzVZOWwxVnNGQmdDOTNYRUtveDN5SkRTalFxRU5YMWYyK1luTHFRMmFIenZu?=
 =?utf-8?B?RzAwbWRpT0tlWUEzL2JPbjZYTVFaay9oVXZ6RWVERkpGSUgxYWpWS2w5MDJT?=
 =?utf-8?B?QkJ4RDcrWlBscHJJRW5idVBuNnMrMUhWVjA4VlFwV290b2RYN3pac3plMkFz?=
 =?utf-8?B?Q0xWTjNtUDVjemxzbmRKL3ZiN1NNNE1aM040L2w3VlVYU1JzRmhhT2REdWRU?=
 =?utf-8?B?MHhXV0FZblpTVVFEcmE0eHFPVkVpOGRIM0YzRndxazVNT1BUc2dubm1VUGFp?=
 =?utf-8?B?SGx1ejFVS1dLNVgyMkc3OExVT1M4YWljUU9yMGU4RXZGTkZPMnR2MDNwYmdH?=
 =?utf-8?B?Z21jRHduR0MxTEFnRW9lVWdGc3FSdmhnOGdRMEFzWEgzMlBoYS84UzVRS0RQ?=
 =?utf-8?B?a2xQNDVaQzMzQVF3K2FSejJucTRvQkJXWkxwczZ4aUhnbVAvU0dHNGc2bmt3?=
 =?utf-8?B?NEx0MVB1djFad282VnVsajE4L3hmOG53NWRzVElqSXpiTjY4Mm5HR0ZVZEpC?=
 =?utf-8?B?RE50MGtHaFhrSVErT0lmR0NzVGxkUjdhbXRzYjU0clcyYUNvSFlBTWZLTWRT?=
 =?utf-8?B?dDJ0aFN1Ty8xTGcvdC8xbkJpTWY2VkZaVmFqUkFpUjZkUnI3VXFNczd4UndJ?=
 =?utf-8?B?NHRHYk1oWXU5blN0VHZ5TW45Qkw2WEhGQ2FMeDN1MFl1dnpxOFFUOUZaVDhL?=
 =?utf-8?Q?BgVHS0KgOT2b31k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e618051-a942-4f7a-9d76-08dad7e2c7ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 23:37:03.9510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BfJb07yDQS8Xrg9WKi1kRblMiVvVOUFw1vZLAIubSc6jRAeYQvYixyl//IG7n6MOgbwD4WtGDDDS8NKX9bPRVT7YhiBntkwYG9t4mNsc+xY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5053
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212060199
X-Proofpoint-ORIG-GUID: wYQo7ic2RRdhQ8bOx5km6fWFmMog40Un
X-Proofpoint-GUID: wYQo7ic2RRdhQ8bOx5km6fWFmMog40Un
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDIyLTEyLTA2IGF0IDE4OjA1ICswODAwLCBaaXlhbmcgWmhhbmcgd3JvdGU6DQo+
IFNvbWUgeGZzIHRlc3QgY2FzZXMgbmVlZCB0aGUgbnVtYmVyIG9mIGJ5dGVzIHJlc2VydmVkIGZv
ciBvbmx5IHRoZQ0KPiBpbm9kZQ0KPiByZWNvcmQsIGV4Y2x1ZGluZyB0aGUgaW1tZWRpYXRlIGZv
cmsgYXJlYXMuIE5vdyB0aGUgdmFsdWUgaXMgaGFyZC0NCj4gY29kZWQNCj4gYW5kIGl0IGlzIG5v
dCBhIGdvb2QgY2hpb2NlLiBBZGQgYSBoZWxwZXIgaW4gY29tbW9uL3hmcyB0byBleHBvcnQgdGhl
DQo+IGlub2RlIGNvcmUgc2l6ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFppeWFuZyBaaGFuZyA8
Wml5YW5nWmhhbmdAbGludXguYWxpYmFiYS5jb20+DQpMb29rcyBjbGVhbiB0byBtZQ0KUmV2aWV3
ZWQtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPg0K
PiAtLS0NCj4gwqBjb21tb24veGZzwqDCoMKgIHwgNyArKysrKysrDQo+IMKgdGVzdHMveGZzLzMz
NSB8IDMgKystDQo+IMKgdGVzdHMveGZzLzMzNiB8IDMgKystDQo+IMKgdGVzdHMveGZzLzMzNyB8
IDMgKystDQo+IMKgdGVzdHMveGZzLzM0MSB8IDMgKystDQo+IMKgdGVzdHMveGZzLzM0MiB8IDMg
KystDQo+IMKgNiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2NvbW1vbi94ZnMgYi9jb21tb24veGZzDQo+IGluZGV4IDhh
YzE5NjRlLi41MTgwYjlkMyAxMDA2NDQNCj4gLS0tIGEvY29tbW9uL3hmcw0KPiArKysgYi9jb21t
b24veGZzDQo+IEBAIC0xNDg2LDMgKzE0ODYsMTAgQEAgX3JlcXVpcmVfeGZzcmVzdG9yZV94Zmxh
ZygpDQo+IMKgwqDCoMKgwqDCoMKgwqAkWEZTUkVTVE9SRV9QUk9HIC1oIDI+JjEgfCBncmVwIC1x
IC1lICcteCcgfHwgXA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBfbm90cnVuICd4ZnNyZXN0b3JlIGRvZXMgbm90IHN1cHBvcnQgLXgNCj4gZmxhZy4n
DQo+IMKgfQ0KPiArDQo+ICsjIE51bWJlciBvZiBieXRlcyByZXNlcnZlZCBmb3Igb25seSB0aGUg
aW5vZGUgcmVjb3JkLCBleGNsdWRpbmcgdGhlDQo+ICsjIGltbWVkaWF0ZSBmb3JrIGFyZWFzLg0K
PiArX3hmc19pbm9kZV9jb3JlX2J5dGVzKCkNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoMKgZWNobyAx
NzYNCj4gK30NCj4gZGlmZiAtLWdpdCBhL3Rlc3RzL3hmcy8zMzUgYi90ZXN0cy94ZnMvMzM1DQo+
IGluZGV4IGNjYzUwOGU3Li42MjRhOGZkMSAxMDA3NTUNCj4gLS0tIGEvdGVzdHMveGZzLzMzNQ0K
PiArKysgYi90ZXN0cy94ZnMvMzM1DQo+IEBAIC0zMSw3ICszMSw4IEBAIGJsa3N6PSIkKF9nZXRf
YmxvY2tfc2l6ZSAkU0NSQVRDSF9NTlQpIg0KPiDCoGVjaG8gIkNyZWF0ZSBhIHRocmVlLWxldmVs
IHJ0cm1hcGJ0Ig0KPiDCoCMgaW5vZGUgY29yZSBzaXplIGlzIGF0IGxlYXN0IDE3NiBieXRlczsg
YnRyZWUgaGVhZGVyIGlzIDU2IGJ5dGVzOw0KPiDCoCMgcnRybWFwIHJlY29yZCBpcyAzMiBieXRl
czsgYW5kIHJ0cm1hcCBrZXkvcG9pbnRlciBhcmUgNTYgYnl0ZXMuDQo+IC1pX3B0cnM9JCgoIChp
c2l6ZSAtIDE3NikgLyA1NiApKQ0KPiAraV9jb3JlX3NpemU9IiQoX3hmc19pbm9kZV9jb3JlX2J5
dGVzKSINCj4gK2lfcHRycz0kKCggKGlzaXplIC0gaV9jb3JlX3NpemUpIC8gNTYgKSkNCj4gwqBi
dF9wdHJzPSQoKCAoYmxrc3ogLSA1NikgLyA1NiApKQ0KPiDCoGJ0X3JlY3M9JCgoIChibGtzeiAt
IDU2KSAvIDMyICkpDQo+IMKgDQo+IGRpZmYgLS1naXQgYS90ZXN0cy94ZnMvMzM2IGIvdGVzdHMv
eGZzLzMzNg0KPiBpbmRleCBiMWRlOGU1Zi4uZTYwMTYzMmQgMTAwNzU1DQo+IC0tLSBhL3Rlc3Rz
L3hmcy8zMzYNCj4gKysrIGIvdGVzdHMveGZzLzMzNg0KPiBAQCAtNDIsNyArNDIsOCBAQCBybSAt
cmYgJG1ldGFkdW1wX2ZpbGUNCj4gwqBlY2hvICJDcmVhdGUgYSB0aHJlZS1sZXZlbCBydHJtYXBi
dCINCj4gwqAjIGlub2RlIGNvcmUgc2l6ZSBpcyBhdCBsZWFzdCAxNzYgYnl0ZXM7IGJ0cmVlIGhl
YWRlciBpcyA1NiBieXRlczsNCj4gwqAjIHJ0cm1hcCByZWNvcmQgaXMgMzIgYnl0ZXM7IGFuZCBy
dHJtYXAga2V5L3BvaW50ZXIgYXJlIDU2IGJ5dGVzLg0KPiAtaV9wdHJzPSQoKCAoaXNpemUgLSAx
NzYpIC8gNTYgKSkNCj4gK2lfY29yZV9zaXplPSIkKF94ZnNfaW5vZGVfY29yZV9ieXRlcykiDQo+
ICtpX3B0cnM9JCgoIChpc2l6ZSAtIGlfY29yZV9zaXplKSAvIDU2ICkpDQo+IMKgYnRfcHRycz0k
KCggKGJsa3N6IC0gNTYpIC8gNTYgKSkNCj4gwqBidF9yZWNzPSQoKCAoYmxrc3ogLSA1NikgLyAz
MiApKQ0KPiDCoA0KPiBkaWZmIC0tZ2l0IGEvdGVzdHMveGZzLzMzNyBiL3Rlc3RzL3hmcy8zMzcN
Cj4gaW5kZXggYTI1MTVlMzYuLjVkNWVjOGRjIDEwMDc1NQ0KPiAtLS0gYS90ZXN0cy94ZnMvMzM3
DQo+ICsrKyBiL3Rlc3RzL3hmcy8zMzcNCj4gQEAgLTMzLDcgKzMzLDggQEAgYmxrc3o9IiQoX2dl
dF9ibG9ja19zaXplICRTQ1JBVENIX01OVCkiDQo+IMKgDQo+IMKgIyBpbm9kZSBjb3JlIHNpemUg
aXMgYXQgbGVhc3QgMTc2IGJ5dGVzOyBidHJlZSBoZWFkZXIgaXMgNTYgYnl0ZXM7DQo+IMKgIyBy
dHJtYXAgcmVjb3JkIGlzIDMyIGJ5dGVzOyBhbmQgcnRybWFwIGtleS9wb2ludGVyIGFyZSA1NiBi
eXRlcy4NCj4gLWlfcHRycz0kKCggKGlzaXplIC0gMTc2KSAvIDU2ICkpDQo+ICtpX2NvcmVfc2l6
ZT0iJChfeGZzX2lub2RlX2NvcmVfYnl0ZXMpIg0KPiAraV9wdHJzPSQoKCAoaXNpemUgLSBpX2Nv
cmVfc2l6ZSkgLyA1NiApKQ0KPiDCoGJ0X3B0cnM9JCgoIChibGtzeiAtIDU2KSAvIDU2ICkpDQo+
IMKgYnRfcmVjcz0kKCggKGJsa3N6IC0gNTYpIC8gMzIgKSkNCj4gwqANCj4gZGlmZiAtLWdpdCBh
L3Rlc3RzL3hmcy8zNDEgYi90ZXN0cy94ZnMvMzQxDQo+IGluZGV4IGYwMjZhYTM3Li40NWFmZDQw
NyAxMDA3NTUNCj4gLS0tIGEvdGVzdHMveGZzLzM0MQ0KPiArKysgYi90ZXN0cy94ZnMvMzQxDQo+
IEBAIC0zMyw3ICszMyw4IEBAIHJ0ZXh0c3pfYmxrcz0kKChydGV4dHN6IC8gYmxrc3opKQ0KPiDC
oA0KPiDCoCMgaW5vZGUgY29yZSBzaXplIGlzIGF0IGxlYXN0IDE3NiBieXRlczsgYnRyZWUgaGVh
ZGVyIGlzIDU2IGJ5dGVzOw0KPiDCoCMgcnRybWFwIHJlY29yZCBpcyAzMiBieXRlczsgYW5kIHJ0
cm1hcCBrZXkvcG9pbnRlciBhcmUgNTYgYnl0ZXMuDQo+IC1pX3B0cnM9JCgoIChpc2l6ZSAtIDE3
NikgLyA1NiApKQ0KPiAraV9jb3JlX3NpemU9IiQoX3hmc19pbm9kZV9jb3JlX2J5dGVzKSINCj4g
K2lfcHRycz0kKCggKGlzaXplIC0gaV9jb3JlX3NpemUpIC8gNTYgKSkNCj4gwqBidF9yZWNzPSQo
KCAoYmxrc3ogLSA1NikgLyAzMiApKQ0KPiDCoA0KPiDCoGJsb2Nrcz0kKChpX3B0cnMgKiBidF9y
ZWNzICsgMSkpDQo+IGRpZmYgLS1naXQgYS90ZXN0cy94ZnMvMzQyIGIvdGVzdHMveGZzLzM0Mg0K
PiBpbmRleCAxYWU0MTRlYi4uZDRmNTQxNjggMTAwNzU1DQo+IC0tLSBhL3Rlc3RzL3hmcy8zNDIN
Cj4gKysrIGIvdGVzdHMveGZzLzM0Mg0KPiBAQCAtMzAsNyArMzAsOCBAQCBibGtzej0iJChfZ2V0
X2Jsb2NrX3NpemUgJFNDUkFUQ0hfTU5UKSINCj4gwqANCj4gwqAjIGlub2RlIGNvcmUgc2l6ZSBp
cyBhdCBsZWFzdCAxNzYgYnl0ZXM7IGJ0cmVlIGhlYWRlciBpcyA1NiBieXRlczsNCj4gwqAjIHJ0
cm1hcCByZWNvcmQgaXMgMzIgYnl0ZXM7IGFuZCBydHJtYXAga2V5L3BvaW50ZXIgYXJlIDU2IGJ5
dGVzLg0KPiAtaV9wdHJzPSQoKCAoaXNpemUgLSAxNzYpIC8gNTYgKSkNCj4gK2lfY29yZV9zaXpl
PSIkKF94ZnNfaW5vZGVfY29yZV9ieXRlcykiDQo+ICtpX3B0cnM9JCgoIChpc2l6ZSAtIGlfY29y
ZV9zaXplKSAvIDU2ICkpDQo+IMKgYnRfcmVjcz0kKCggKGJsa3N6IC0gNTYpIC8gMzIgKSkNCj4g
wqANCj4gwqBibG9ja3M9JCgoaV9wdHJzICogYnRfcmVjcyArIDEpKQ0KDQo=
