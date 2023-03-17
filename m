Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EBBC7618A
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 19:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCQTGW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 15:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCQTGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 15:06:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACECF52F48;
        Fri, 17 Mar 2023 12:06:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HI0c4g015714;
        Fri, 17 Mar 2023 19:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yySPFBh5sTh5znvMNaLrQr+NCwFCByXMJVU+xMpgMEY=;
 b=aHsh70KZdHbCfrnHqIUPAxCqZt0tNusd4kK/XTQVFWUSNHkHz1Ox/skbLTyx4OY3dd6e
 EwAQKa3NBh9edp4Tczy+6I9Ug92t9QB8Jb8hNX0F6fQ7QaKbsXRS9J4B9iBfbDU6HNFs
 hjJA0lpCUs8Bu6oM7jV+gZbp4HIpt2HY6N7egj7Q7jtdiNXnLLZ49ICAmC7K0i58XQQo
 J6PzqQNj7Z17TkyPDpvh9cDoeoC/hAdiHCAu4LqaFIP8sx++RduOpkYqROYYewXvctlm
 bk989J/wOgk0TxTyFoJoTDul8n1wFDM2TdsMEOdRX0RlTxkjrFEW5m/D5w1Af6q465gn Og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pcthk0jmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 19:06:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32HHHU0o002407;
        Fri, 17 Mar 2023 19:06:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq48685q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 19:06:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SB0I20w5X6pO9pCyvtHDyiZwF8ofnroY51qZTQ1WwbdUjbKGuH0/OUYIG94A6ucYWPpwnq1yef3H73swxXO1H4m4ZbcECgYa72f8ktsoyT7geG7VBN+S70r2UY6nGpa8mDPjkThTe6jYw574Lu5Y+C7O1GvF/eANa2npHRu/mEoJ3SjezPrz6o50diES2XW/gKbyGjcou4hoB1wrbRUR5GzJiI2mhe3jrYhIvun0jYID8xPvVX7btEO2k+gd1ynG27C24f6yS77YGEaZJqLEeXRDWr6O9KE77sTRfRD1cxCGYiY+jV3wJBcbmaoyoJdfVx9HFCFNtUMDBmWVOtOcQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yySPFBh5sTh5znvMNaLrQr+NCwFCByXMJVU+xMpgMEY=;
 b=fmD8d+Sk5KhhHIKiT/oIfZX59gnGAoeV2WPrcItHImd/61UQxarD050eWciqS7VSUtSi6wE/GwOWXvzSTyLJMGxNMGHFDZvACAuwXmvrmEHBNXXsIIonU+QP1drbpe5s+LfE7YjSf3kIRDv8F/4g1Ops87BreMVXNwfViSBfbd9OBju4szTjqXmhdAI9nWVWuW16vECkUKdkiuUGnBF5+Qy87Nq8HkGAnbj4Z9dSged00MlaxGcpR7yV4VfLIaCt8lp8x2QDLz29ig4Y0P9Q2NCvFehAJdVGgiXhJks4gOEZRl6hZpRkf6uPp+sMr/UazgA6gjuh+GkLpkNP8S8Y3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yySPFBh5sTh5znvMNaLrQr+NCwFCByXMJVU+xMpgMEY=;
 b=hUQE0/T/Yi0y2TB2AYTo/i1uySGtzoOjpLPL80CbGvStKM3tyHz/IcUQ2NWIvuaHmoE4uMGuDbVRDdX/DeICCWRoypzZy6NRxpoLq6utdxH1ykUDnVnS30JrS+pvCIx36ovXLami+pER30e+tu6lsMbXztibmYI4t+o/6rZHUXE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA2PR10MB4475.namprd10.prod.outlook.com (2603:10b6:806:118::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 19:06:07 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%6]) with mapi id 15.20.6178.033; Fri, 17 Mar 2023
 19:06:07 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC DELUGE v10r1d2] xfs: Parent Pointers
Thread-Topic: [RFC DELUGE v10r1d2] xfs: Parent Pointers
Thread-Index: AQHZWDi40PleEnagskq+ctjQXWYsi67/VpsA
Date:   Fri, 17 Mar 2023 19:06:07 +0000
Message-ID: <776987d7caf645996bea6cdb43ac1530f76c91d1.camel@oracle.com>
References: <20230316185414.GH11394@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SA2PR10MB4475:EE_
x-ms-office365-filtering-correlation-id: ad292023-32d0-43a7-d9cb-08db271aa9a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1uDiaOYVO05xGkdALK/z8CpTkmjSiczocqP3z1Jf2G6+kqR/n9qUzsg4GYPfLpJLaNf9gELcL3HP9crdqLQEVMozrrmYaShk6jbbvcavinEw8a67HfZXNT2VO/CU6yEmTDlfpPpHRZzvrxTI3PuRX49RcBS/VrsLAXBT7CgvWk750x+cmFwg9R1a4Osi1DfP31ZG2IfDu36tyvB9cnFWW4w9FNypJPgkACxX934mo5POj/fjfWuwj+t5l1MWIGzwtbBirDj+UVV1pZXyxgFo05vVMVvZddwvoRtcEG4AiWLpRUTFu0lgDq+ENVixWH2a/1sWpGq3qd6ubti7D+PtEqp1bb4tcH6n8q0IdwlOs2yWULNTYCRMuh5w3463andoUEcX/bCXa7L6lvpbNI8oUW00LoObZHwpI4YlGAEvTlthwV8W//h9erHcE1QlrUHBU8vWTCOCrETCnJsVBMm2VlsxLNDLnHbTSWKJB+RJ3fmCHQU7XHl3fQPDRYvIqU99ltqeXKqJsnu0XFI9mfL9LMOelC9cgb+QkgBkbSa2ZC0pV/pTzzxylv1V8kDLEoAUwU/sHTZZfYkVQGyeLr2a3Yp0oEDkxnD6fR728nxAZrUGg3FTUqxespfujTQkzHOP3RydkRO9iDEB2eB/CiHoqB8R5y/FyD20l8oUC6iZNeYoEHAnKDQkkoQXrB2FqLH6IJO+t53xoLLHtfeAv7IqGOY4/i/zjxLy4+qIoBkI3G/vBASX8v2EyFDlOLx7OtlSSWVWk9TOKOd9FsidSMCxhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199018)(6506007)(186003)(6512007)(83380400001)(26005)(38070700005)(86362001)(122000001)(38100700002)(36756003)(2616005)(66946007)(66446008)(66476007)(64756008)(66556008)(8936002)(44832011)(478600001)(316002)(8676002)(54906003)(2906002)(76116006)(4326008)(6916009)(966005)(5660300002)(71200400001)(41300700001)(6486002)(66899018)(130860200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzJsd2hpM0RDaWhBOGJwdTlvdzZwMVdmbjlOWGtWeUNId2ZjejJGbWZ5NGRo?=
 =?utf-8?B?TVVPaTBZR21qR2NQYU5xZE51QUJ5bnY2UysvUE5HY0FnamlKUmJjZ1lzdEZK?=
 =?utf-8?B?YWF5NmVWM2NaLys3Tjdoc2YwN0VzR2o4azM2a1FnMHVWN2xjRzRETFdYU3Y2?=
 =?utf-8?B?WjBya2d4c28vMVlsVElRUWZjTGhYRnZxUU9SVExSZ3kxVXFyZWJjSjI2OTVM?=
 =?utf-8?B?cnoxaU02UGhaejBvK21LRjluZUtRZUsrTjVFUlZ3cmRKSkN1KzNIenZ1WWFO?=
 =?utf-8?B?R1I1SFVRZjFINEpuY28zUUlmSm15MnlTUzh6eVRPcm05Zk5EazRVVHhjZnZs?=
 =?utf-8?B?ZGg0eWlOTUhrQWFpT2NPZGoxazRzTzVBaVhoSXF6dWZ5elB4SEp2MDlKbW1t?=
 =?utf-8?B?QnZMU1Q4U3dIc0ZGc1U4dDBBUFNxejJEWFZhellCclYwSVF2bHJiWW9WajZV?=
 =?utf-8?B?U0FpVGtsRVRjVEhTWEFuSldCOG5LNEFXTnNvYXpzYUNjSFJGeUhJc3FnYmJB?=
 =?utf-8?B?eXZadFpRUnM3M0dPeEVaeXcxbjhPeUdZaDZxeWhKcEVrWjJNcnFiNERKU3dx?=
 =?utf-8?B?QTlRcEZzblpkZjRFNjV3aUFNdTFnWTdaRDhPc3pLdHVXbXQ0TTZzSnhNSDli?=
 =?utf-8?B?Mnc3WDBkRUlrbEF0STlHNERLazRkSGhJSldTSEZDaGJTd3JxRVpXNUNXL3RY?=
 =?utf-8?B?bHpGd3dPYU9ib0lwQy91K3AxRjNTSGtXWDlYQTZUTkN3V3ZVQnNKTis5anhC?=
 =?utf-8?B?bm5wYjFHL2ZVVC9ndzdRNkxKUHgxTklGUXhyNjdlN3pxSkJvcWh3Q0o5OGNx?=
 =?utf-8?B?R0MrUU02NVROS1Z0RXRMTkVhS3R3UnVLUlRaMFlhczJrYURna0NhblRmMVV0?=
 =?utf-8?B?dGpEc1REdVBxWjJpV1FwR1VqUkNEZnFYUFB3QjkwN1ZvNmw5dFBxVWt2TDhW?=
 =?utf-8?B?dTY2cm1ya1NqSS9VUFM5ZjNkVmI1WTJqZlRTOXVCTWViZzFDQkt1VjRGY2JO?=
 =?utf-8?B?Wm9zNlZhNmtERGV5SUNRVTdndFpJSHJtU3RIeUhWeFVHdS8wRkN4akhXQngy?=
 =?utf-8?B?NkpWc1lkSlAwZ2d1blArSE1KVHQ5bk5HcGRESnZ6V0tmczE3OHp5REtmckFa?=
 =?utf-8?B?azhpWnZzTnhRVkhrT1hjSFlidm9vd3ZOdE1KWUN4Mm01cEs3d1R1ek8wZFFp?=
 =?utf-8?B?VXNqSmFSQWkzZkd6MkZFTlBOOG1hQURZSnBZc1B5aU83U2hsdVFlOGVhU2RV?=
 =?utf-8?B?a2ZzYkt4QVc0Vzl5L0dtcTlJaGZleWg0ajZ1dEpGSlhNMTRiWXpOOTFtajIr?=
 =?utf-8?B?RUVHeitwOGJWMkRDUmdCOEU2WU0vVjJKMVpucWkvSWROMFZvTWxCSEVHbHFs?=
 =?utf-8?B?anR2ODJDWWd6SFg3L2hpaWpPOXVBdE13Y0dKL2dJSDczdXQramFvS3FCa0xw?=
 =?utf-8?B?Y3JFWk9mYU9PeTRvZ3JZM0dVdW1IaS93Y0hnUVFkS3VSYlE0TkdJNmFTWUJr?=
 =?utf-8?B?WFZwb1dWUXozbDgydnVHQklJUlpqR01XWHFMVDBtUXZPOTBnYmJNREVleFBu?=
 =?utf-8?B?NEVaWkJzY2Y5a0pKYU1Sa3FyZ3FtVVJzMGZnS1JOTVR1TlAyRWYwZk9MSHp5?=
 =?utf-8?B?bU85TkVwWFJMc1dtVWEzRG9BNTd2ckp5Um1xZmY1RHFQMXhkeWNqRjJrMWI1?=
 =?utf-8?B?TTFGb2VXWEs0ZzRBMS9mdTR3dE9OZjBBTEdIVU10VW95WGZ4VlB2RlN5Vlcz?=
 =?utf-8?B?QmU0YXJXVnI3N1F1WFRlS2ZLalZFQ3Fpd1JEdmh1eEtPY0hBWTdsa3lMUDgr?=
 =?utf-8?B?NWhZUC9KbWt6OEdQN05oT0JXM1lzdEtOam1hMmMvenY2MzNhSlFzb2grbS9M?=
 =?utf-8?B?ZE5yVTZPQlB6ZXNNK3VkL09IOHVaMk1ZK01xZkFsTjBBTW04NHNyckN0Ujcv?=
 =?utf-8?B?NkszYlJ2VVlhUEtBbzBTaUI5emlBaCtCZmNyakpCTm5icEk1blVDY2tKWTdL?=
 =?utf-8?B?V3ROYTM1ZDZweEpSTG9TTDEyRXh4b2w0ejdNcjdIOG4ySnYvQ2Z2WGp2alI0?=
 =?utf-8?B?ems5RjVZWkswaytsTnY4Zll4ZTVGWjhBbExTVXkvZVkvZ1V6K1A0NkdjdVh3?=
 =?utf-8?B?aXBwSG8zbVc1bkR5QTNFTGtzS251REVVcm1CaEhCSWxUSmxzK1N5dER4bzNz?=
 =?utf-8?Q?LVJOQP58CXECbCwAvQz+wso=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C86CC74EC73A4C4481013011394CA62F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ff5vnUx0u3CL+JuDIdlf4mUro9NcbnZnutIXep/UGAKvu8SFPSfXY6macL5lr0D0nMso7DNXErk4KBLPfGkRKM7QGSYEvjDHWNOf6RynFvcNsmtAG3bnHtVX7O3cn6lpgLR1FFqfhl+0oGJMvB8w/exp8bl1G2pS3fDOjVP4eI6PFXnEzwIhTMdZf6xyK67czCPvkz/+60CdqYlDxXW18u5UTAU6QlIJ0Ewcp2/L73nbfmaMDuHCI0qTceh83EEazYkMbuOwaFdmFoXuAJeNjOmJNKLQlBFqTxVr1Yyak83sHWjgV1zal9zqTCqQUn4NeQnTC/w2UBV9sVKo2r3NdYy4jS3KNdxgmesopPqUAovooJOn8FzpOMWTjzkdGa94uJaLO5fOjrhAVOqWzeTJDDc7Z9vTfNEqhB29N1Mm+IDAjTXLMRR4h7zY2u4oVBHC/N2HsnFFVxFYw+YuSz3VwrtgJfBJuPHUgpANh20LPZkM/pxQrRJ3tOXwfK1cYJK9mR3ouSkPj4y7i2XK/O2R8P1tz3IZ2eM/Xgt37qgozRwxcDa3XF2A29x8QZ4piPRas3w4+TjfkSXNtSEMiR8HeVKKmDS4N+ZPP9y2KPLxfYywU4K1LFzw+vUTq150AGf/IpQKby1aWiMsDuVq6uG/wG/JPMnotJyRDzvDP03xF7wt2M1qDvqODC8IGmYfcycqVtt+Wzgi00ByL9MSgd0PiKi4a5naMSFXnjwX7paZG/CdQvL+aqbB/tjubsnq4I38zC9iC9vJWyeuKgdLUWTGx29RHG38378MGM+5rQrS5OE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad292023-32d0-43a7-d9cb-08db271aa9a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 19:06:07.1218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Bp+EVHJ6bXYFux+xgCGf3Opr2cvojXb1PYSL2XPWhgPIKKosHkTPUrKldlEG6os9rFBdrPZ/jU/0zMJBL4Rp5NBZwcGTJAW9vRk4jRsQzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_17,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170132
X-Proofpoint-ORIG-GUID: vobwrqm3HgLUmNtifDHWsN3RYGjrkwlo
X-Proofpoint-GUID: vobwrqm3HgLUmNtifDHWsN3RYGjrkwlo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTE2IGF0IDExOjU0IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IEhpIGV2ZXJ5b25lLA0KPiANCj4gVGhpcyBkZWx1Z2UgY29udGFpbnMgYWxsIG9mIHRoZSBh
ZGRpdGlvbnMgdG8gdGhlIHBhcmVudCBwb2ludGVycw0KPiBwYXRjaHNldCB0aGF0IEkndmUgYmVl
biB3b3JraW5nIHNpbmNlIGxhc3QgbW9udGgncyBkZWx1Z2UuwqAgVGhlDQo+IGtlcm5lbA0KPiBh
bmQgeGZzcHJvZ3MgcGF0Y2hzZXRzIGFyZSBiYXNlZCBvbiBBbGxpc29uJ3MgdjEwIHRhZyBmcm9t
IGxhc3Qgd2VlazsNCj4gdGhlIGZzdGVzdHMgcGF0Y2hlcyBhcmUgbWVyZWx5IGEgcGFydCBvZiBt
eSBkZXZlbG9wbWVudCB0cmVlLsKgIFRvDQo+IHJlY2FwDQo+IEFsbGlzb24ncyBjb3ZlciBsZXR0
ZXI6DQo+IA0KPiAiVGhlIGdvYWwgb2YgdGhpcyBwYXRjaCBzZXQgaXMgdG8gYWRkIGEgcGFyZW50
IHBvaW50ZXIgYXR0cmlidXRlIHRvDQo+IGVhY2gNCj4gaW5vZGUuwqAgVGhlIGF0dHJpYnV0ZSBu
YW1lIGNvbnRhaW5pbmcgdGhlIHBhcmVudCBpbm9kZSwgZ2VuZXJhdGlvbiwNCj4gYW5kDQo+IGRp
cmVjdG9yeSBvZmZzZXQsIHdoaWxlIHRoZcKgIGF0dHJpYnV0ZSB2YWx1ZSBjb250YWlucyB0aGUg
ZmlsZSBuYW1lLg0KPiBUaGlzIGZlYXR1cmUgd2lsbCBlbmFibGUgZnV0dXJlIG9wdGltaXphdGlv
bnMgZm9yIG9ubGluZSBzY3J1YiwNCj4gc2hyaW5rLA0KPiBuZnMgaGFuZGxlcywgdmVyaXR5LCBv
ciBhbnkgb3RoZXIgZmVhdHVyZSB0aGF0IGNvdWxkIG1ha2UgdXNlIG9mDQo+IHF1aWNrbHkNCj4g
ZGVyaXZpbmcgYW4gaW5vZGVzIHBhdGggZnJvbSB0aGUgbW91bnQgcG9pbnQuIg0KPiANCj4gdjEw
cjFkMiByZWJhc2VzIGV2ZXJ5dGhpbmcgYWdhaW5zdCA2LjMtcmMyLsKgIEkgc3RpbGwgd2FudCB0
byByZW1vdmUNCj4gdGhlDQo+IGRpcm9mZnNldCBmcm9tIHRoZSBvbmRpc2sgcGFyZW50IHBvaW50
ZXIsIGJ1dCBmb3IgdjEwIEkndmUgcmVwbGFjZWQNCj4gdGhlDQo+IHNoYTUxMiBoYXNoaW5nIGNv
ZGUgd2l0aCBtb2RpZmljYXRpb25zIHRvIHRoZSB4YXR0ciBjb2RlIHRvIHN1cHBvcnQNCj4gbG9v
a3VwcyBiYXNlZCBvbiBuYW1lICphbmQqIHZhbHVlLsKgIFdpdGggdGhhdCB3b3JraW5nLCB3ZSBj
YW4gZW5jb2RlDQo+IHBhcmVudCBwb2ludGVycyBsaWtlIHRoaXM6DQo+IA0KPiDCoMKgwqDCoMKg
wqDCoMKgKHBhcmVudF9pbm8sIHBhcmVudF9nZW4sIG5hbWVbXSkNCj4gDQo+IHhhdHRyIGxvb2t1
cHMgc3RpbGwgd29yayBjb3JyZWN0bHksIGFuZCByZXBhaXIgZG9lc24ndCBoYXZlIHRvIGRlYWwN
Cj4gd2l0aA0KPiBrZWVwaW5nIHRoZSBkaXJvZmZzZXRzIGluIHN5bmMgaWYgdGhlIGRpcmVjdG9y
eSBnZXRzIHJlYnVpbHQuwqAgV2l0aA0KPiB0aGlzDQo+IGNoYW5nZSBhcHBsaWVkLCBJJ20gcmVh
ZHkgdG8gd2VhdmUgbXkgbmV3IGNoYW5nZXMgaW50byBBbGxpc29uJ3MgdjEwDQo+IGFuZA0KPiBj
YWxsIHBhcmVudCBwb2ludGVycyBkb25lLiA6KQ0KPiANCj4gVGhlIG9ubGluZSBkaXJlY3Rvcnkg
YW5kIHBhcmVudCBwb2ludGVyIGNvZGUgYXJlIGV4YWN0bHkgdGhlIHNhbWUgYXMNCj4gdGhlDQo+
IHY5cjJkMSByZWxlYXNlLCBzbyBJJ20gZWxpZGluZyB0aGF0IGFuZCBldmVyeXRoaW5nIHRoYXQg
d2FzIGluDQo+IEFsbGlzb24ncw0KPiByZWNlbnQgdjEwIHBhdGNoc2V0LsKgIElPV3MsIHRoaXMg
ZGVsdWdlIGluY2x1ZGVzIG9ubHkgdGhlIGJ1ZyBmaXhlcw0KPiBJJ3ZlDQo+IG1hZGUgdG8gcGFy
ZW50IHBvaW50ZXJzLCB0aGUgdXBkYXRlcyBJJ3ZlIG1hZGUgdG8gdGhlIG9uZGlzayBmb3JtYXQs
DQo+IGFuZA0KPiB0aGUgbmVjZXNzYXJ5IGNoYW5nZXMgdG8gZnN0ZXN0cyB0byBnZXQgZXZlcnl0
aGluZyB0byBwYXNzLg0KPiANCj4gSWYgeW91IHdhbnQgdG8gcHVsbCB0aGUgd2hvbGUgdGhpbmcs
IHVzZSB0aGVzZSBsaW5rczoNCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Rqd29uZy94ZnMtbGludXgu
Z2l0L2xvZy8/aD1wcHRycy1kcm9wLXVubmVjZXNzYXJ5X187ISFBQ1dWNU45TTJSVjk5aFEhTW5r
QmJ5REtFZGdRaVhMZm1YWjg3dVRfal9UQXRRSEhBMVVyYVBmMDFvcDZ3TnBSWmtrMnRnNUNYcnU0
ZUw2LXB6SnlVbC11SkFabFNyR1d3REZwJA0KPiDCoA0KPiBodHRwczovL3VybGRlZmVuc2UuY29t
L3YzL19faHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGp3
b25nL3hmc3Byb2dzLWRldi5naXQvbG9nLz9oPXBwdHJzLWRyb3AtdW5uZWNlc3NhcnlfXzshIUFD
V1Y1TjlNMlJWOTloUSFNbmtCYnlES0VkZ1FpWExmbVhaODd1VF9qX1RBdFFISEExVXJhUGYwMW9w
NndOcFJaa2sydGc1Q1hydTRlTDYtcHpKeVVsLXVKQVpsU21qT2g2WDckDQo+IMKgDQo+IGh0dHBz
Oi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9kandvbmcveGZzdGVzdHMtZGV2LmdpdC9sb2cvP2g9cHB0cnMtbmFtZS1p
bi1hdHRyLWtleV9fOyEhQUNXVjVOOU0yUlY5OWhRIU1ua0JieURLRWRnUWlYTGZtWFo4N3VUX2pf
VEF0UUhIQTFVcmFQZjAxb3A2d05wUlprazJ0ZzVDWHJ1NGVMNi1wekp5VWwtdUpBWmxTbHVsT2h1
SiQNCj4gwqANCj4gDQo+IEFsbGlzb246IENvdWxkIHlvdSBwbGVhc2UgcmVzeW5jIGxpYnhmcyBp
biB0aGUgZm9sbG93aW5nIHBhdGNoZXMNCj4gdW5kZXINCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNv
bS92My9fX2h0dHBzOi8vZ2l0aHViLmNvbS9hbGxpc29uaGVuZGVyc29uL3hmc3Byb2dzL2NvbW1p
dHMveGZzcHJvZ3NfbmV3X3BwdHJzX3YxMF9fOyEhQUNXVjVOOU0yUlY5OWhRIU1ua0JieURLRWRn
UWlYTGZtWFo4N3VUX2pfVEF0UUhIQTFVcmFQZjAxb3A2d05wUlprazJ0ZzVDWHJ1NGVMNi1wekp5
VWwtdUpBWmxTcWlYYTN4TiQNCj4gwqANCj4gcGxlYXNlPw0KPiANCj4geGZzcHJvZ3M6IGFkZCBw
YXJlbnQgcG9pbnRlciBzdXBwb3J0IHRvIGF0dHJpYnV0ZSBjb2RlDQo+IHhmc3Byb2dzOiBleHRl
bmQgdHJhbnNhY3Rpb24gcmVzZXJ2YXRpb25zIGZvciBwYXJlbnQgYXR0cmlidXRlcw0KPiB4ZnNw
cm9nczogcGFyZW50IHBvaW50ZXIgYXR0cmlidXRlIGNyZWF0aW9uDQo+IHhmc3Byb2dzOiByZW1v
dmUgcGFyZW50IHBvaW50ZXJzIGluIHVubGluaw0KPiB4ZnNwcm9nczogQWRkIHBhcmVudCBwb2lu
dGVycyB0byByZW5hbWUNCj4geGZzcHJvZ3M6IG1vdmUvYWRkIHBhcmVudCBwb2ludGVyIHZhbGlk
YXRvcnMgdG8geGZzX3BhcmVudA0KPiANCj4gVGhlcmUgYXJlIGRpc2NyZXBhbmNpZXMgYmV0d2Vl
biB0aGUgdHdvLCB3aGljaCBtYWtlcyAuL3Rvb2xzL2xpYnhmcy0NCj4gZGlmZg0KPiB1bmhhcHB5
LsKgIE9yLCBpZiB5b3Ugd2FudCBtZSB0byBtZXJnZSBteSBvbmRpc2sgZm9ybWF0IGNoYW5nZXMg
aW50bw0KPiBteQ0KPiBicmFuY2hlcywgSSdsbCBwdXQgb3V0IHYxMSB3aXRoIGV2ZXJ5dGhpbmcg
dGFrZW4gY2FyZSBvZi4NClN1cmUsIHdpbGwgcmVzeW5jLCBhcyBJIHJlY2FsbCBzb21lIG9mIHRo
ZW0gaGFkIHRvIGRldmlhdGUgYSBsaXR0bGUgYml0DQpiZWNhdXNlIHRoZSBjb3JyZXNwb25kaW5n
IGNvZGUgYXBwZWFycyBpbiBkaWZmZXJlbnQgcGxhY2VzLCBvciBuZWVkZWQNCnNwZWNpYWwgaGFu
ZGxpbmcuDQoNCk9yaWdpbmFsbHkgbXkgaW50ZW50IHdhcyBqdXN0IHRvIGdldCB0aGUga2VybmVs
IHNpZGUgb2YgdGhpbmdzIHNldHRsZWQNCmFuZCBsYW5kZWQgZmlyc3QsIGFuZCB0aGVuIGdyaW5k
IHRocm91Z2ggdGhlIG90aGVyIHNwYWNlcyBzaW5jZSB1c2VyDQpzcGFjZSBpcyBtb3N0bHkgYSBw
b3J0LiAgSSB3YXMgdHJ5aW5nIHRvIGF2b2lkIHNlbmRpbmcgb3V0IGdpYW50DQpkZWx1Z2VzIHNp
bmNlIHBlb3BsZSBzZWVtZWQgdG8gZ2V0IGh1bmcgdXAgZW5vdWdoIGluIGp1c3Qga2VybmVsIHNw
YWNlDQpyZXZpZXdzLg0KDQpUaGFua3MgZm9yIGFsbCB0aGUgaGVscCB0aG8uDQoNCkFsbGlzb24N
Cg0KPiANCj4gLS1EDQoNCg==
