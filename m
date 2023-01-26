Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4926AC05027
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 18:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjAZSCb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Jan 2023 13:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjAZSCa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jan 2023 13:02:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81F759E4D
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 10:02:28 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30QGxMQB028093
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:02:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=JKUDd8dP4KOHY9YQIIcpNHmCk21kQHySHUkCPOF0fSU=;
 b=WBk994VUH49K5b91ZH3ZeSAm7c7IR+x9jSXCqyJcZX2RGJ0XtU32Rvw/To25lCoIgAp1
 acVoSieKsN6hTP0GWX8J5D4wlzZF8R8guxKKQb+UgcO9iSF72YSUlwxEV36hofY9DNGP
 xYQipstAUx/MjunBKjCLoKzCOZlkuG1wueSCbVsF2OeTp0ag3kFgxZoV/ku/1oRPOwUI
 BJnPSVryk0Yx+aLuW+tW2ym16fxw/EPanlfMBEjpApfZQZ9wAzm2uIqRy2L5nsyr5Um0
 LkN8fdcSyVh5M8BsfU8aEz2vs7wnfSuzygbMBF1bqBGPJh27jG5H+TCpfjOrczoEaoRO Pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ku2wu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:02:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30QHGTG8006629
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:02:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g860xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 18:02:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuPOcuvUoP7hDwldj546RyKTSCHSTq8TifGHLC+lyIR/qcnICy0Q6SJGFSNOIPvvBLDAo5M63DXMr8HDYW7SoKuvlniHM+gCMahqlndH7WQSYSb4ZYgoGpNy6qFZprzSIULeCEjOZlYzCnEmI7Z7NScCl4Y7ZFgnIfNqbxJUvaYl5OtcvtkFRt76yxEqc2UvWjF5FagfPwpaQFaccycPxfHwmrxZQWcUwZhjPWozAtVxmqZ9koJpSpV1TIKjpe0qgUjd5qKo+CbD0dBEwlUAxsyTsjxnqgfNAbhB1L5ntU9nT0ir2uUVrUuUDBje9cWlePnBfh9DDJ7E5ZEN06RbBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKUDd8dP4KOHY9YQIIcpNHmCk21kQHySHUkCPOF0fSU=;
 b=W4WQQHZ/4Ce2ucFnqKZ///JPhBuKdJe9wt0lpWgbaC94m9YatJc1EHtNjC1ozGkcS0IA5LkTXhA8AzU9EAOLkmkMa0sKK7+haTC0jOwFLDSs+LSDGRTlyuki7s19ltME9QqtJYNGfaTuGKF6ajNrXnQLBIyQa3H7zaJYtvf/Q000swty+xPi9GzsySgcp6Fw2Qj9ZQIP4Abs7T0aBwr5PO4f0lNqEdNnCg7fW/RUe2o1T+3MtDPIrsA0RGvPZyrvvJZd21508h/YahbAtgjKjWs/bmDgkjbIrUZOI9XYj0Rb0BHkLsKGnxJxUuTYw5RCeTcO2Y2xQ8CwQfg3SNsgIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKUDd8dP4KOHY9YQIIcpNHmCk21kQHySHUkCPOF0fSU=;
 b=KC8rat2jnhinDjUytJUNQqzcHwX+wwHWedmGhW7FPRRVc3CZrvvGWsqwiJ9GyG/EFPqIvTih4jBQQXeFfEihU8idPEbQiHC6Ba1n2avDpkFgIpGmOkBxZj2+8yj6zXQzeBp3VeyuEVZgM5B0sSplpXhvA3WfXNMPhNFNFFW9S6Q=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4755.namprd10.prod.outlook.com (2603:10b6:303:9f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 18:02:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 18:02:25 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] xfs_admin: correctly parse IO_OPTS parameters
Thread-Topic: [PATCH v2 1/2] xfs_admin: correctly parse IO_OPTS parameters
Thread-Index: AQHZMR3TxOkkDY222EKZiSaO/IS5O66w/nWA
Date:   Thu, 26 Jan 2023 18:02:25 +0000
Message-ID: <29ffd634da719aa10985f6bfd6506679ee464dbc.camel@oracle.com>
References: <20230126003311.7736-1-catherine.hoang@oracle.com>
         <20230126003311.7736-2-catherine.hoang@oracle.com>
In-Reply-To: <20230126003311.7736-2-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|CO1PR10MB4755:EE_
x-ms-office365-filtering-correlation-id: 54d93115-2f88-40df-40e7-08daffc77b38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qHh1kNsn6PN7mNf7y0iioGtpvOmloG3GCt8+q3rkbVbAoxqau36Mu2FoihcZyf0l+dhO5TXxliwWjy/Oj3reb8DO+cZtO0M8UStvZ5M/Q5c6vAEisgoEOmHs1vgj6XvCDcK0SGaBGjB4tTjK+jKQStEKvRW9anbYfsfVIx0uF6q6/HYXkM0pIhnTQJQvU9adsppH1nNvxW3c7RggBA6c9TMxYFyckpYmOrLF3GTsLOh4i6wn4QOBGMBLiNLnoxKxNvMK4pw2PnBZLUGe20ttc9Vx7cFGlOGTQ8tcsdgfvdUSzjG5WbhxyN1Cr8/8cdAvtdSWT7NYHS/PRjGydf7SaywR4Ew6O7V6e9HqaT9Fxzo5DRNXA8wSSlv5howDYnAAK5d3K/mTP0OuIQ63uvdbT3rBS7t3InT//GZh/L/AaYsqDNRAAbl5smQSjtZ9fq+DP5jh6AlT4HrQRFp7P6yNLEQc5ErDbiYJKYyV/lHnY3z/2WHAkHRY0wj+wG0830TnhuBFSP+b0MxOh4uiowBjAVfGMya6EMR9Qvo7+6FCYeX3WN/KIq5IwccIEF9KSKcNK4KBYfiJ9r9O3yN+17BKMvcPwYTtahCUhZzckmp/JFtRxGnlK+Jbd12OfC5IFZsYcDrJAfsgKBMX7CGnEpEmflgjyjmuBQ3K71FiZfDbFzlp/lM87fjAXtCP53E5p9tP0A9YfmuNkkoQWQmsrvvmFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(66476007)(66556008)(66946007)(64756008)(66446008)(8676002)(41300700001)(122000001)(2616005)(38100700002)(76116006)(6512007)(6506007)(38070700005)(8936002)(26005)(186003)(6486002)(478600001)(316002)(4744005)(44832011)(36756003)(5660300002)(2906002)(110136005)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ymh4WU9ZNVJucTB1QmMyOTBXNjBCaFFuekZmZmZLbnhTUlgwTWlmYm55NFpj?=
 =?utf-8?B?WjM2NXdmTDNjcWNqS0k0NlNjcFlucXZkSHl5NVlBbEVUZUhVNkw0QVZyM3Nx?=
 =?utf-8?B?S2NZNnRVVEo3Ym40ZU1kMXVaN1lBeWVKanpFZGlRZVNjNnZERktRRXd0WVdv?=
 =?utf-8?B?aWdOUHNCVW51cEI3N2F3K1Y5MEh5WEJJQjV2OHhkQnlMTE1GUTBFeGJoaHBM?=
 =?utf-8?B?c0JRalFtbG1sOG9QQ1dpeENobHRzYVovN2g1dy9ab1lScTVpOThQMzlxS3Na?=
 =?utf-8?B?b0E4UnJDK0FDbHVvZ2ZweXVSdHNRN0M2a1BHV004ZnlRcUdPOWhhMnduOVBX?=
 =?utf-8?B?ejdLVCs0cTlzS0orMmpaQ0JDL3hjWVI4T2VucjlKR3lSZUVybjdDcG9iRGcr?=
 =?utf-8?B?THhqeW9hNXQ1cXlFQjFJRUd2eUFtaVA0RG1oUTV1L2oxdVlCRldBaVVhSUM4?=
 =?utf-8?B?Ulp2cVdLOU9pZmIzN3orRHBBMEVZWTZJR3lvcUhvaUxrV092UnpCakc0SGJr?=
 =?utf-8?B?MVhueTFXTUwvbXFLWVBGbmxCdUZlMitrT3ZMV016Y1RpTllVTHZzb2ludUsv?=
 =?utf-8?B?SGNPWHl1MmJIWEN4ZVJhejQwMFdUc0ZpVkVBUURFcWh2VlNnUjNta3h6d2Vj?=
 =?utf-8?B?aUhyTDZDc0hDdUtlcnhFdzlMWEZORCtXM3dwY21HVmdGY20xcFRMNjcxWXNo?=
 =?utf-8?B?a0hYcml3Q3psMmYrckVTODJCRkkzR0pSRDhxTm13NWxQZXpoZUMyc05jL2Q4?=
 =?utf-8?B?THZXSXJEOWJhb05ld0dZZEZVVzd5Z0NyNGtXOW5Uc2k2RFowVTYvOWZvVlE1?=
 =?utf-8?B?T0g5L1lDT1pUOHcvMGsxM1ZvWXNCOHBheEJmb1lkVm1sWUxRSk1lUnNGNmk4?=
 =?utf-8?B?U1FCcDNLeU9NQlFkQUhpaTFpZVU5SlR3MGFZYlRXdmE0b1ZxeXV0Q1A0aWlD?=
 =?utf-8?B?SHdqNGpBeHRDMXJHT0hFRjRhSTNiUFJzc244Q3BYWVY2NGZvQ1RxQm9IZXhp?=
 =?utf-8?B?WGUrNzQ0UC9JUHpYakthUTA1akxNR24zRVg5Z2d0cElobWo1UVJtWk5McU91?=
 =?utf-8?B?UzdtbFlYYVpJemJFcDdrdjF5WkZqVWJsUFliVFBiemxscmFLOGg4aEQxYVlv?=
 =?utf-8?B?SlBLOFdzVDQwSFBTU3hLR1p6MGsyRlZDWEhzNlQxRDhaeS94WG5CdXFPemt1?=
 =?utf-8?B?RjA3Sk9FTE81bHZCV25sS2JoaStMNnYzZEJKeXNna251SlVEMm1YdzVQWVdF?=
 =?utf-8?B?QTJhdmxzRjBxdEtSMjdoWWthOFdiS1BwKzZtLzk3NFE4cVhsZ2dqQmY3R1Nx?=
 =?utf-8?B?OWVUU2JjMHMxRUphU1IrWlBTa3lnNlJSM09lTmJwblFJa1V3NlVXbUtMdXRm?=
 =?utf-8?B?T2VLM1lMWHpCYkRNYzQxYVFWWms5bW9wWXNMZmZnSStxUXMydjlUN3VnaVI4?=
 =?utf-8?B?S3B6RDg2d1AxM0pVNkJRYXlBcFlBS29pUHFpbjAyRlYyR1VyNndRcnlpKy92?=
 =?utf-8?B?M1JvQklUT1hDbTVMUWZhMEdUMCsrR05FVnlTQmZjWmE2LzRxekJibzMvU2ZP?=
 =?utf-8?B?RVFNM1phV0pYc1gyV0hGVTBMRjNJME01OS9pR2w3a2M4UUVmKzJvYi94ay9T?=
 =?utf-8?B?ZVZNNmRWVmQvaFRmWFNwamRLWUlPd2tNRzgzRElNK1h3RFp3QWtLNFkvdXRl?=
 =?utf-8?B?Ymh5OUtKQmlXVU1EYnJTTFUzUnFUK3R6TGN1Z1V6TEF1cU5FNTQ3anVMVXBL?=
 =?utf-8?B?M1BpbTAzVmdQZWhsWUpGTENLUUR0TEI5amYrY2JTOUs3VVd4WlBnUXI1T1FC?=
 =?utf-8?B?KzRRU3ZTSDVYUnNjcmZKQmNkbmF3VmhLNW5CWFV3dEIyVmJWTlYyTHdqcUt6?=
 =?utf-8?B?TnBnWUNEOUthWGorbWlyWTYrQTJCRXVTQUs5dXozRFIyeGNMOTNGQ3FVNTF6?=
 =?utf-8?B?WU1uUUZPL3ZDdmNmTjFUQ0U0d1V3RWYrMVpIeGhyZkFFb1phdTFDcEpmSEJl?=
 =?utf-8?B?WmlXeVFkMXVoRTQ3SHg5Yk9tVzRJYUF6Q2Y2WEtTM0RzSFJCZjcyc1UxcE1H?=
 =?utf-8?B?a3BqdWtIZkNHU0RITytXUDFlL2RzcHRESVJNWmIrNll0QldSZzA2QkVVaE8x?=
 =?utf-8?B?MTF6Z2NiQ2lXZ1pmeXlIU3VZT084UURqZXR6ZVg1alo4ZWw4ZlU1Z2RUZ3hS?=
 =?utf-8?Q?V212ujKGqgTDjc20f03Ct0k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB9DE6624DEE0F499853CB22999766F7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gqsinIh2Tbk3RzCptlAAOtqcuuP5Q4TSUeA7wDeU4gNHPUF5yT+I23ma2iZaFPqFAG5ZqLDhGy/fLyE2NhNbkxQ4czDKd8hitLBqKTsDm7bfP4pCPI78OptwY5PNrFh6NHFdTcEpDcbHUYdQA9Z0RBk6nkniAA4kFrH72pc8oPcBFowIpOlAUm/kKznhC8OfW2PRh7y2fR0GDtAYB2WbXiH/5mtMtB6TpFe8zlfFAd3tqI4d9ySaLUX3HItlXPG18ZjeXqvWTRNzG2lVA2W13ut9PsCm25fW2yNlCsTwyffg8U8qkdL/QsFIQlx0uCLmq+Tn9iylMqvCf2mhUVDEwvEk2LdasSHQo0jv78X4Gd6WPblTsECaIQModfVJ9KeJPV93U+H7B+7ORSx28FpDSkVx/FZOAqe2cJffgcBNWNNvOSAANwh+MDRVH64qYHDePgoWpqNm1fSu4d7kEaScxFGOJ7zXeG3DU0UFlAs7rr7+/o18sPQWenUmw3v8TVgj30qbYzWBtCu/RCKZuHed/NCgNycmXnErhn4VTx5iygXkrKNIR7JFtFTih+upIv3P580jNnPYI10dGtTrcyJLJvxlBI5ZtStZ+DvRxXM+pHCSJZqLuyX0gsY63xAg5rIMCFZTq4Z/QWDFbRpuQHFJMuxraEM47SHqJlxXM1p3gNwrxOhq+IbhL2vTZ2MhUIrG+yfg8gasLYUWQD4UdXvVpbIA6UBYhSg2Irp4Rf5ioDeKjQIKt3VV7LtdE/iPQXrWzZcLzatps9g4ERb4UHL67w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d93115-2f88-40df-40e7-08daffc77b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 18:02:25.6893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yAJECCZqmUU4Ip8l5HVmPrlx9cU4VgJUQZB6HUIWL271MlibxV9sTs9jfjSbFX8j4cIQU3WY8SZQi9GdiL137aWstG+SLMkO8U1Gd4Idx4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_08,2023-01-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260173
X-Proofpoint-GUID: lwdqPX-Anfjyc2e6rILy_Kf712IHgR5L
X-Proofpoint-ORIG-GUID: lwdqPX-Anfjyc2e6rILy_Kf712IHgR5L
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIzLTAxLTI1IGF0IDE2OjMzIC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gQ2hhbmdlIGV4ZWMgdG8gZXZhbCBzbyB0aGF0IHRoZSBJT19PUFRTIHBhcmFtZXRlcnMgYXJl
IHBhcnNlZAo+IGNvcnJlY3RseQo+IHdoZW4gdGhlIHBhcmFtZXRlcnMgY29udGFpbiBxdW90YXRp
b25zLgo+IAo+IEZpeGVzOiBlN2NkODliMmRhNzIgKCJ4ZnNfYWRtaW46IGdldCBVVUlEIG9mIG1v
dW50ZWQgZmlsZXN5c3RlbSIpCj4gU2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhvYW5nIDxjYXRo
ZXJpbmUuaG9hbmdAb3JhY2xlLmNvbT4KTG9va3MgZ29vZCB0byBtZQpSZXZpZXdlZC1ieTogQWxs
aXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+Cgo+IC0tLQo+IMKg
ZGIveGZzX2FkbWluLnNoIHwgMyArKy0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZGIveGZzX2FkbWluLnNoIGIvZGIv
eGZzX2FkbWluLnNoCj4gaW5kZXggYjczZmIzYWQuLjNhN2Y0NGVhIDEwMDc1NQo+IC0tLSBhL2Ri
L3hmc19hZG1pbi5zaAo+ICsrKyBiL2RiL3hmc19hZG1pbi5zaAo+IEBAIC02OSw3ICs2OSw4IEBA
IGNhc2UgJCMgaW4KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBmaQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaWYgWyAtbiAiJElPX09QVFMiIF07IHRoZW4KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBleGVjIHhmc19pbyAtcCB4
ZnNfYWRtaW4gJElPX09QVFMKPiAiJG1udHB0Igo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGV2YWwgeGZzX2lvIC1wIHhmc19h
ZG1pbiAkSU9fT1BUUwo+ICIkbW50cHQiCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXhpdCAkPwo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZpCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBmaQo+IMKgCgo=
