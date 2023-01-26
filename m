Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1630C05027
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 18:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjAZSDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Jan 2023 13:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjAZSDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jan 2023 13:03:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DFE2942B
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 10:03:08 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QGwbd9000947
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6S4ouzLKiMXmDYCDLWVnoJbCo7cZaGHlKzHcO19cqSQ=;
 b=2YyA5qhJ9Ntr9GwmBvGuwviw3v50ELpPjztZStB6X0Bo6K3zSjsZFxBjx3LeVWtI5Nae
 cVzDf01Bf36dK718YGwS6PLXroSv5C8k/I/1Frx8YTzND+v54+pjSxenrl1QADgztwtI
 P5ViHC9cGon1aqoCmzGXcgwSGkzadsGV9XVfEqrNeU8TG/z8kOocCZbaaNu0gLqBjtdQ
 OMbJNJ+BZ6ivloeUfTajlZ7kmRKFM/2OZxSA+SSPnTK93eA5MdY0f1xxkaRuxF0ohW8B
 pbAWuQfdoM/F7uhVDlnZiDuU+7sbBBU7xjTTR3mTLS2d4g5geuoJYUt5NKob7t58M6Ln XQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fck3hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:03:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30QHAOvk006738
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:03:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g861qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:03:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Coy9GGsSTopx8VJ3IEPlMW5L/ZODgj/X6sT4ZJvVprfvDiAesqBwHmdgsJ/L6LTIeTSJuhJ4eBiSsatb8Blv+4avyelT4Dok6VkXi3+Rc7f64R4x0gmr5sH4VU2LGYXSW6M/BwOuL9iyGtd93OtcRPG0MU1lFInzFFJrIkuO8cGyfuzGyEnmYfv/F270KFrUeKfQ8/+gvs17Q/wOQPgYEnGMUmKkhk8YkISl+rfaEcdoe4aJDAntqLvfDXXHocS8qiCrkeXsSWvNIy85OHfbBiYka/Funx/9MAqe3gfKI/lIqoQ8fbH2bjn/Ke3+ZTRuCq5aCq8LdqPbbJoyqDqbSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6S4ouzLKiMXmDYCDLWVnoJbCo7cZaGHlKzHcO19cqSQ=;
 b=TLeVBA46BANyNg5NTGCHfwH1Bjk0r+neQBsvD6aec9gxadO8MGfcBqfQiMJVzsLvh6/hxycSKuKFtgBqvFnJp7d+cGFXOmi03KZ4MyJyCO+9oY0f5JetTPCy9QRxklnViRW0iaWewDwPsbHiJSzLioyi3XDKIclYDL5l8OHKZGZ1WhG3SloJDMVv0NQf9hIvob5gYjBV33Rs94rfv1H985HN+htxyaypgx4B8WrCvfE++rRAp/MsK/bP+GjEXB56VO8hYhoJ6J7tqcXJ9Yq9sf1jcvSkKSMeXDXgwgXcgrfrAFSrE0l8TkCbqIUVXKK5J8T8HmxDWr2mxtsIOrqIQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6S4ouzLKiMXmDYCDLWVnoJbCo7cZaGHlKzHcO19cqSQ=;
 b=sTyeQdqnPuPoceyl28JRk8oBCk5yuOspy4jdT/FwEkWBr/e3mzY/n/v1bqfojTJwhRHyN591YhNLsOIFe9DHCVuw1rlEl7Vf/bo9dNSeZlux1A73q9Ltybp7+sZNxiM/K6Zkv7vGvctlozLP+v12yvFbRRG1jiC7HMitkCLreRU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4755.namprd10.prod.outlook.com (2603:10b6:303:9f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 18:03:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 18:03:04 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] xfs_admin: get/set label of mounted filesystem
Thread-Topic: [PATCH v2 2/2] xfs_admin: get/set label of mounted filesystem
Thread-Index: AQHZMR3P7fy5SaPd00C+E2G6zrjL566w/qMA
Date:   Thu, 26 Jan 2023 18:03:04 +0000
Message-ID: <5bfc1067a192376fe0e55fc9af1450e9d7761aaa.camel@oracle.com>
References: <20230126003311.7736-1-catherine.hoang@oracle.com>
         <20230126003311.7736-3-catherine.hoang@oracle.com>
In-Reply-To: <20230126003311.7736-3-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4755:EE_
x-ms-office365-filtering-correlation-id: 9d41d217-e0ea-4479-cbe9-08daffc79257
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FrajGPehUOD37eS5r46BD/Tkkp2wS34EHakXdrjhI520k/5kRReN/csZBnymaqH1nyGP5tH5l+jmjd3DQr+phrACfc7GAuIC8wAYaW2a97jr1AvQrmYiF5JRBSlstIeCa0LfaAJoNTBg72tBnaJ8OF+SlpsGDFpnOV5da01l3Bm5a34W0geRZu3DLXSOdtY64hh9Ap5/AW2zb5SyMdJGeMuA/ZNWxWd0VqM3RZ8bMD9c/kWsbcc24HOppXbYjvrt6F5sAPIvqe7LMsGkqAMcZ/AAfYLIK9aXMXbouCFn9lT7PXmKSOl9nfr5mpvDdDlhrD7FFcJRHM7iL4QmRlW0i7wIKcCRmeGlDO0lsd8K1SUx13g4ncNzqnm6t264EYzOJ+riuqTOaaO1q8ABeOCEE5WSVCDqnuB9zc4Ob5sl8FPM2I2EMZqJx9OMBPDwc4tvE1ciKDTYcytcavmCjwO/1ajzkHcAJMbKnyAhY041OCaVPzs3NXT7SX1DzxYgWvgbhI/CaNs0AjOccHLdY8eUCrAfNHpTy3MOJrWmupKffATSHwB8o/Nag6AVgX2S6xyd87W+3t1K4N/XmH7T0I0xc9UXJxNc9OoXY/Xf2+d4Hqgt+gQsmeD1gL66Y/43Iwtbb6bDYWl1Z8a981F1DTE6a7HFLWrrbM1ywOb1UYWo8ZfvWoLTSxamOv9ud3hdhf1zBkHnXbHuUT/NpqyaCi6FMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(66476007)(66556008)(66946007)(64756008)(66446008)(8676002)(41300700001)(122000001)(2616005)(38100700002)(76116006)(6512007)(6506007)(38070700005)(8936002)(26005)(186003)(6486002)(478600001)(316002)(4744005)(44832011)(36756003)(5660300002)(2906002)(110136005)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkxBb3pxMU9tWkRESm8ycDNtaG40NzV1WllyRHVabmxWcUFMRXpiVUlHUUNK?=
 =?utf-8?B?cjNUV2RqVVFSSTBkT1NBRDlENG84WHE1YlJabUVLNW5tWWdnb2szM0hmSkpm?=
 =?utf-8?B?MXlxa2tWUHBHZEFOazJUNlFMTkFQYTZTUjl4VTloVnljaGt4Z3FOUWF1Qldq?=
 =?utf-8?B?a29oWktZVHFoSndmai82ZHd2R3Iybmh5cGhlNmdjc3pDd0ExNEhRSkFMdng4?=
 =?utf-8?B?WlVaYVRzU0Z5SFNXRmNRNkw4TndGNGI1Nm1ZNHljSHp5YnNLam5ud1A5ZzlZ?=
 =?utf-8?B?Y3hoL3ZCbFZBbWsvREJkTzlDZk5FTzZwbDdCdGtrRHNpUnM5RmQrRE5WajZX?=
 =?utf-8?B?YjlBY3MvVEZ3RnZpT3pwUkxja29pSzdRRGxBRlJNRnZHYk1keHBiNVd1VnBE?=
 =?utf-8?B?QnJBUnNHM2ZmNnE4Qko3OGZrZVhGemRjRjNidE1ITnlDczNERTN4ZWxtTkZS?=
 =?utf-8?B?SFV3NVlQQmNwcUtadDdqU0ZDRDBSTzVXQTgvb2Y3aHVUZm12YUZDOVRnQzJp?=
 =?utf-8?B?WTBBVnA1TVp1L0pycG1WODAxYy8vZ3M0N214T21HdUR6ZzZPMTNKWDd2Rlhp?=
 =?utf-8?B?Z2R6TStoYklwSGpPb2V5d0xOelJibHF3SUJZQnhCTDdjK2FQbU54K0JrYnI0?=
 =?utf-8?B?RmJoRStoNjVaRFppOU5TMmdhR3haSmxmdkcxY3dHbDl1OE5uWnF1Qkp0bUN6?=
 =?utf-8?B?di9OdEp0WkFlVFNaR1p0bzVXalRuN0lOa3g1UlQyZTUvZzFVTFN1TVJtbitJ?=
 =?utf-8?B?cDhzcmdCS05YNnlReWMxYUhJbWY0VTNDNTNCVjlUWlhmM2EvOHZyRzFBTE5j?=
 =?utf-8?B?aUtGY1NyUWhGMGtLZ3ptVjJjd1JXRWFQeWJpVlF3MXR3alJLR3VqR1dqN1Np?=
 =?utf-8?B?TjdGOEJualU2N0grVHBRVXhqTTEzQmVXK3o1RG5PN0hWYW9zQk9VUngrcFIr?=
 =?utf-8?B?Q0xaaThneFgxd1VIMjhpL3hRWGFscEJveDA2anBhUTVnU2tlRXFoQ2w1TkE0?=
 =?utf-8?B?dVA3dHI4SG5TQW5weldWWlVQZHZXWXZVQ05pRnlOZGhvUUZiUnZPR0pybnBM?=
 =?utf-8?B?MHRFb0V3Z1RIS00yd0hHdG5BNmtJeVJxMnIrQU01Q2RiV3NlTC80NEZZUDNu?=
 =?utf-8?B?N09XSk5lTlo2a0dwb2VIMndwMHpHWjN2VmZvM3hobEovOVpQVGtFQm1MSzBi?=
 =?utf-8?B?MzhoTWJ0WjlEWjhsSk9kNUkrd2xhTDgwZmsxcm50NzZtTmJqL2RNVEcxcTJK?=
 =?utf-8?B?dG1VS3I2NWRDelN2UUZ6NTFhUHpTUGpEVDFNSEFieFVqZ3QxTUlOWjZ0WjA2?=
 =?utf-8?B?bmhsQVk5Q1ZFMndMY3dHVDlFd2ZnMUhFdS9nN2FLZHNQdGsxZ3ByT296K3pD?=
 =?utf-8?B?QzY0S0JpT044TWZyYWFtOHpkYUdRMmcxbHUwN0NBZ1pSS2JEVEZFY0NLLzNQ?=
 =?utf-8?B?a1h4Y1Z4dTlybFdHa3JqSk54MGNYNkdHeDVhcXRqVWNnM1g1SEdXcHJ0Z0FM?=
 =?utf-8?B?Z00wQmYzcmJQMjVXZ0tJaWNCT2JFSHpoSno5RHRKZWo3ODNmR3RzVHZjNGFH?=
 =?utf-8?B?MG9CNU94YjFLYUduTXJwZlZMQ1F1b1hGUlU5elU0Y2x4aWJwUVNLQjFqMklF?=
 =?utf-8?B?K3hYRTZYMHZNbzB5dEV5Uk5TZFYrd0tFY3ZGcTYyY3NyM3IxR0FKRFlrY1dr?=
 =?utf-8?B?WnRaaEc0enB0M2x5WkpFM1dPYitzLzZTc0w4elZYamVSYTMzdTBXdTdNMWYw?=
 =?utf-8?B?a0t2RlowdG9OcWNjUHBuVEg2Q0xVRSt5VDNscWpsWnN2VDlBaExlcmV3LzFF?=
 =?utf-8?B?SDUyWFIyR2NBeU5vMSt0em5WRG9YRFJMZXdlSlNTVm5qL3NWYWVtWCtVMGs5?=
 =?utf-8?B?WjJTNlpDNHA4V3ZoQWRydWxxVVRsS0k1L3RhV282U21wUUNyQzdRS1A5cHFO?=
 =?utf-8?B?R3YwM0J0VG9xYTNsbklhQThlZnpYc2VBd1B2cW1SZ2RHTnhSNS9Zek5VVS90?=
 =?utf-8?B?UmgrRW1IY1BkbWU3d2M2YXRwV1Zzb3RDWGpLaXJIQlVwM0hkMnRaM1hnZDlp?=
 =?utf-8?B?elN3Kzg4UytzRVJkVGpvK1QrcTA2djRySkNzUHhuTXd5Mnkwd3ZTRzFEcWZx?=
 =?utf-8?B?Y1FrN0hyU0xhOFJaZFhDaDZkOVRjU3hSZTRsMURHbmJPM3U3SEpRTnJQSWNL?=
 =?utf-8?Q?zAPazX6MmXgfwPkR6Il6fBY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE9859BF8C69CA4C8F5B3FCD689D7303@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: T01bmqgc2iTWCTm9aGWse5MJwodfXLARyNStLTJas8fmAF2DcEXOmZFupf8FzB6ETjcrNkgXr2dgw84ldbOTXqQwQyf8qmiVfc8Z2rcni2isIb/B3fWeLl20qMYPKcsiDG57ThMgHe2Igt8mSlvHnzfmiAfMAh00/sjBwT4cuEnFJSKTCzD/TmNfQRZLAOuikP/e6ogs+xMoiH4C+PN7WmV3B5OpOgPEXy7iXui0GONK5kF3Yu1Wd8jvjqrBGqlK6gUmvR4Nht7Gsk5d04FOhMfTCs0nzggdqHiUvfGyQFtMI6Fmb2VcxF1RfOmRmLD2BV1+7SSH7HR8vhpoV7cAYrMah8YWG1WN7+cALabzB4nWnrJF864FkTRiHji3WphwBTQ6kOMD/Hvr0v7fmpGU3ItyT18vEXa3xkHFnTG+HDOr0JTWp/CB933wQW2zxTG20aHYjZkZkYdyP5UQGSFopYIUMd6vinWi3rKSYVJlXSzxL+QRtmcvd8xRRVA7+xlVQOkeLGrbEliQ8k31KcNH8rv4pVMJtWaJlX9qpyejF2P0/LTcYO1pfjfR4jrSr/+d9Nwy+DSfUctiOz4HM/03UB4Thpr1ezaYMu+t9Y6qnDqeyTIwMvhpOhhQGzJbb+2NDz5ZLHOkY4rP0ZiZONBPEVQ9CYczpkLHfbdmQMyMYizTsV2lDjHaXo2o4N15mmvS1mdfW2wEMEVRmasDoyMWpbEskyRoDdxkI7oPlu7cmJ18XIxMPVPJRSddcVi6xWp5QavNWlVd/piLhZP3gCkaQg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d41d217-e0ea-4479-cbe9-08daffc79257
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 18:03:04.4523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEt7Lwo+kDlt0dwV6LPNvDtBcIfyoK6tfkma0LTNY9NdssaEGNCPB86R9b64o+CHXJwu75WPcbBFlm+/bgEegqC9vGpihh5O2matpMK8dCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_08,2023-01-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260173
X-Proofpoint-GUID: iBJs3VRvxuc-DW_bhNFEuHo5f-gUZRwf
X-Proofpoint-ORIG-GUID: iBJs3VRvxuc-DW_bhNFEuHo5f-gUZRwf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIzLTAxLTI1IGF0IDE2OjMzIC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gQWRhcHQgdGhpcyB0b29sIHRvIGNhbGwgeGZzX2lvIHRvIGdldC9zZXQgdGhlIGxhYmVsIG9m
IGEgbW91bnRlZAo+IGZpbGVzeXN0ZW0uCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhv
YW5nIDxjYXRoZXJpbmUuaG9hbmdAb3JhY2xlLmNvbT4KTG9va3MgZ29vZC4gIFRoYW5rcyBDYXRo
ZXJpbmUhClJldmlld2VkLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5kZXJzb25A
b3JhY2xlLmNvbT4KCj4gLS0tCj4gwqBkYi94ZnNfYWRtaW4uc2ggfCA2ICsrKystLQo+IMKgMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0t
Z2l0IGEvZGIveGZzX2FkbWluLnNoIGIvZGIveGZzX2FkbWluLnNoCj4gaW5kZXggM2E3ZjQ0ZWEu
LmNjNjUwYzQyIDEwMDc1NQo+IC0tLSBhL2RiL3hmc19hZG1pbi5zaAo+ICsrKyBiL2RiL3hmc19h
ZG1pbi5zaAo+IEBAIC0yOSw5ICsyOSwxMSBAQCBkbwo+IMKgwqDCoMKgwqDCoMKgwqBqKcKgwqDC
oMKgwqDCoERCX09QVFM9JERCX09QVFMiIC1jICd2ZXJzaW9uIGxvZzInIgo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVxdWlyZV9vZmZsaW5lPTEKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoDs7Cj4gLcKgwqDCoMKgwqDCoMKgbCnCoMKgwqDCoMKgwqBEQl9PUFRT
PSREQl9PUFRTIiAtciAtYyBsYWJlbCI7Owo+ICvCoMKgwqDCoMKgwqDCoGwpwqDCoMKgwqDCoMKg
REJfT1BUUz0kREJfT1BUUyIgLXIgLWMgbGFiZWwiCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoElPX09QVFM9JElPX09QVFMiIC1yIC1jIGxhYmVsIgo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqA7Owo+IMKgwqDCoMKgwqDCoMKgwqBMKcKgwqDCoMKgwqDCoERCX09QVFM9
JERCX09QVFMiIC1jICdsYWJlbCAiJE9QVEFSRyInIgo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXF1aXJlX29mZmxpbmU9MQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBJT19PUFRTPSRJT19PUFRTIiAtYyAnbGFiZWwgLXMgIiRPUFRBUkciJyIKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoDs7Cj4gwqDCoMKgwqDCoMKgwqDCoE8pwqDCoMKgwqDCoMKg
UkVQQUlSX09QVFM9JFJFUEFJUl9PUFRTIiAtYyAkT1BUQVJHIgo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmVxdWlyZV9vZmZsaW5lPTEKCg==
