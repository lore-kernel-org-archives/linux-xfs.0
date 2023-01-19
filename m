Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B87EC004D4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 19:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjASTLZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 14:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjASTLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 14:11:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A029E966D9
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 11:10:24 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JGwd9a029446;
        Thu, 19 Jan 2023 19:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yq5RUQRze7pbNdBmLBbuT+0vxP2Qps0lsZp6ZZsQxdQ=;
 b=X+8T2cyDWAkfscprnez2YRjzpuvr0Xt21vCvFiHgLiFEOaw7AO4ZV7Aim3Y/kSml0U0b
 5dEHkN0v6QjWhrQ2/1ZzMXxP4IJZkcw3EWDI5YTu1J99a6lbb9VqzRBuVqymw32ZmoaZ
 d/LOdHAZMB8REumIuiBxTsixl0fadJBgqOwW6gAmxIpw8opydEqm7GyCLt1wF2ely95f
 hDuOY3F1hUjwc5tKhRRld0MgmgjlAO6PxWgkQSGLq1QPSfrGhS8SEUWXyS9AYtcuyHFL
 AEFn/sSbbutiAmWuMN2wDjgElpew1RfrsfJnvP25PdebcdSlSIYNPLhbAkr0JfcXbbVC lA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3medk4m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 19:08:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30JHsfxC028206;
        Thu, 19 Jan 2023 19:08:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6quc35ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 19:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGZVi+XH2iJ72SoCVZNUalc2RqiVQnXrB4QahOe7ohAP1SAEnXP5CvAW8YZAPSTXkoxANM/Lpqe4d7CVU5FLA/ur2SaDqsSD/Us1ODxF9uXunnFOBFdWwfnSksxQx4SO5LxUcir1jRBpflCUFbjxFI0CyrkRzyYyjnd8innDK+jPE9kn2Ha/Yxd2L5r/sLFwDOms7m1zkzrwTbtd8Q65zTTmYzkuAHNGiXoQC6QQUS3czOwSQLpfoPpFsZk4uzVniTGPHXKUZloUlq0P1+Xa5/f/wsecarykzlSZaiM650k6eWN3zsbejksRdKc+2cdSkUjG1E5CrhQxjYu2OJK/ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yq5RUQRze7pbNdBmLBbuT+0vxP2Qps0lsZp6ZZsQxdQ=;
 b=nRTeHWFJSt2rsC/ac7gVmxvK+DfE3QEyJ6bJuZPrfFoZgMjCb2dGLkTiIW8pvSSJQVCplUXVlCV9hzHGS+NrQ48akrZJiY5o3dijh47Xpuo7eBur5m15YicgIcehuBf2oK4rgZb4XCxy+C5ryUXHmYjTGiggiBfvOgbfIACHmEk7OxY9BrBX71/kt7CW0HZIHFcKkEQOaHKYqQwf3ppaxZXRO23Ix4j4f8rmkL//R5eun4VkFGiuMTyqPBXCX8/iwxuaP0Z+lycXE9XaLoWeUYuDZfTS6GB7RG0Qs6wAcT0SHxxZmlxnncIXn11GqJH7nsVoKqN1JEqjb2rlKTJ+XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yq5RUQRze7pbNdBmLBbuT+0vxP2Qps0lsZp6ZZsQxdQ=;
 b=U1viupjB9sH5Hnk8pPDG0ors2X/lropMvojFycDXYffM54B/gZC4vJUPAMmJFO3LkE37PGN+DDGVzkeBtDDAVsx5NKx2Rrx1A4aXGcusVcqxDlM0TIUszTmXBFB5Dq8DCX+7F7JfLMCRImUYSsvWASRGaYWWLUcDjOWECvkjM5w=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ2PR10MB7039.namprd10.prod.outlook.com (2603:10b6:a03:4c5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Thu, 19 Jan
 2023 19:08:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6002.012; Thu, 19 Jan 2023
 19:08:50 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 02/42] xfs: prefer free inodes at ENOSPC over chunk
 allocation
Thread-Topic: [PATCH 02/42] xfs: prefer free inodes at ENOSPC over chunk
 allocation
Thread-Index: AQHZK46P4ryWu97XSE65bouFhvQ5Ta6mG9AA
Date:   Thu, 19 Jan 2023 19:08:50 +0000
Message-ID: <550481003d762ca55af1c0b0ef25a990c7e01ef7.camel@oracle.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
         <20230118224505.1964941-3-david@fromorbit.com>
In-Reply-To: <20230118224505.1964941-3-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SJ2PR10MB7039:EE_
x-ms-office365-filtering-correlation-id: bfd4e468-01db-4f71-feef-08dafa509993
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uXaCX27liXVYUawbmFV/N65/7VhY0nn8v6mihk5LXaTqnBQQOjPxUVdtE6Uy0Y+k/U2/7CGtKFxHxrDlkEONekKeNtShjvDVc1wjZG5enUuWBRNEtIIZjU/9Ro+OZWqACt5xcz0V/WeZs6R+jth8PU0EZJ8vkJZCMCUfrK2z66MKgX/d6bLLc74K+NHH0Ak+Mt/9VL2mFoTjrIbhXUgG81ytwar2ifjEtdSy1myFGhDtq298YUmkGnS39jyQauxHK529y28wXDuMGniI9MvBSjIqfwemlaqDIG1/Gu3HUIQhcBPlWo2PZSuNW3Fx+AU3CNRf6t7xpto9MROXl9XCigKL6D1ycUJyX+qi3zGdbcE7w4JrUOy6rG8k62Ap9T24bKjhH+bLX7uf1iTLpQSm9jmKooNEw6Mudc2+u8GylJturFTrMhMsh0wem26yqAASBEHsC7EYdlY2IHVU/9pj+v9vP0pYQWxUcSaKVBnIycuFL3VGrwCNcWqDy0Pl/CxYYIjZhB9u4qosekDbaDLDpVkx63wE9X1ZqUr2wvXJ2H4opHNExoKkLrj/wP0b9ogd76zwgxHO5CZTm8FNK0Z2Da3gsgjB0CicMoCpKGdHFV9BuqELyn9D5kuOl5a/96YUBpTa+/nYJyqNkzNnxoaE//IWWkg06mtY9O5luNSD4ul6iXupQwm+1hTQsm+BBeZganDrOT2+l0TeoWs+aT5sZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(478600001)(6486002)(71200400001)(2906002)(6506007)(5660300002)(2616005)(110136005)(66446008)(64756008)(41300700001)(36756003)(8936002)(83380400001)(86362001)(66946007)(76116006)(66556008)(38100700002)(316002)(66476007)(122000001)(44832011)(8676002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWhCeFNwV1YvNWFXRFlTejJOYXNHb0FSQndYVXZGeHNPK01OcVVvR0lWWjd0?=
 =?utf-8?B?NEIzUUFsN3h0SjFWS3d2QUVvcThUUFVJOHVMVjlJa3lNV1htL1Y1TkNYdmFM?=
 =?utf-8?B?VGRjL0hJdGhwWmU3NDdjZXU4MlZJYmx1dXBDaVA3R0hHTHJia1lnNHEzNDVx?=
 =?utf-8?B?Q1VieVFQcVFZOUVxN3d4L3FrMXlWN1hURGErMm1OS3Vob2xFanVoRUcyUVpa?=
 =?utf-8?B?ekFBci9SVHRCR1grRGVrdXFlUW8zYnMrcFFEcEU2WHVxeXoybm1zR1RpQjZn?=
 =?utf-8?B?bWZsR0JwMmZhbFhHTm5IM05iWldYczlSMFVIdmFmZFYyTFJHUmIvWmVXMFdB?=
 =?utf-8?B?R2laSk1hamlCNHE2WXh5amtPVHE0MGtIM2JpcTRuTGdlR1lmaGR3SEhvcWtL?=
 =?utf-8?B?Z21qeTlHTnBTblZDT1IvUk4xb1YwVnBxMUUzeUtBcFpaVVFyQSs4R0FBbVYr?=
 =?utf-8?B?SlhGOEt1ODFXN2ZSMiszK1FJeURkblFTSi8zYWFYQWo3eGw5YVJnT1lXK2tn?=
 =?utf-8?B?K0dQSGRzM3hTRGF0L2U3eWFjdmJIMlU5TldtbVJySmlYV1hhRkhKTGNveVpx?=
 =?utf-8?B?WW8wVTN1b2d6aEFDdlpOMURJTlNOL202Wit2UitnSlhFZDJ4OTBxb2JKRWpl?=
 =?utf-8?B?N2E4Znl5V3RmMjdvQk5Xam9pb094bUlsQnNjRjd5YVIvM3FmRnV3a0VHamdj?=
 =?utf-8?B?Q3N5U21Fd1IybFlodHRkeFNDaGpSeTc5Z3FEVE1zZjhTeUpXK1UwT21YdVh4?=
 =?utf-8?B?UmdzbThZTzlFUVJFbEduRUdacGlwdW5Yb2ZucDRvUTZLc2xrY0M2WWFPdnpK?=
 =?utf-8?B?UTZWcFZZOExkb3BsWkxmSE5rcTBwcUpzZTJLR1V1d0o0aElpdy9sL3p3aW9u?=
 =?utf-8?B?OEdnaHE3MFRjQVZIdnJ1UzVWajRZdyt1L210TERpbVZaei9ZcDJ4VmptSXZZ?=
 =?utf-8?B?Q0c0K3orVm9tSTFyVUFZU3lueG1BM05rVGoyejBGQzU2NTBuRDF5dHYwWms1?=
 =?utf-8?B?ditBa01CZXc2TFYvRUJrSnZFbEhQejhuUjlLdGRETlk5cXFDa1hGTmprZEhU?=
 =?utf-8?B?ZHBLSnY0ZmVoOURXQWdYTnd6UzhVbjcrc0ZwT093eGhrRHFETjFEbDB1cDY0?=
 =?utf-8?B?QlJ2K1BxYW0wTEhrQjlGdXp5dC9CSlFMdmVnb0lPYlJaR0tpV0tPMDlBUFdW?=
 =?utf-8?B?T3c5aDZEQUhQL0NrNjBOSDJ1S2lFR3kxRzgvNlVjVUkyVUg4MldXWFNhbWph?=
 =?utf-8?B?a0NFbGhLdzNaYTkvaFZyVUszYjRjSG5ZOHBjQUVHRnRVWUJHQzh0WURUNGZZ?=
 =?utf-8?B?M1pLa1RUTUVKUWJGaUpxMEpUSExnTzRhcnhjQlVZeGxzbmhmOEV5OG1hamlx?=
 =?utf-8?B?anRrcytIcytJeFVTazRxdkVWYXhKZUFUQnBUUkcxMjgzL3pWU09Ka2pFWTk5?=
 =?utf-8?B?SGYzR3Jsb0xUeVFWc0UwTURsZDlLd1hzUXk4U2RaRmF2L2F5ektFOUJnUzE4?=
 =?utf-8?B?NG54K0hFanJzY1ZLRWNJamFUVE9UNG5YL0xWN0J6czNrc3NsZFkycUZaTWdh?=
 =?utf-8?B?d2k1NlFZUDdEMkdCNDRQbFB1dFZLdllzbzd1amdlb0hucHdkQ2dsdk1UYU15?=
 =?utf-8?B?ZkhEanc3bURBODNQdlJ2REtlREdMWUZtK2ljZnJ4ZVZxSElVSk1YeUl3NkVM?=
 =?utf-8?B?c01DckN1Mm1RNWVsOVZvUzFrTzBwcjVwU0lmTHRNZXJkQ2xhKzhIZFdybXlP?=
 =?utf-8?B?Y2JiZmRnWUhrVGcyMEQ2L1NHYlNtQnhFZnhPcVoyQWIxSjNvcEx3Yk1SQm5j?=
 =?utf-8?B?LzhjRzJURlhqQkViRGFNbGl2dWF0ay9xNk9XMjlZeHB1dVdMYng4d1J0M2I3?=
 =?utf-8?B?UDZCa29hT1luR01rWHkxeVNqK2xCaE5jRURnanpiY0RMVlprTTFibk1EZkww?=
 =?utf-8?B?dGwwYWpwVlZndjFnTE5HWHNnSUxBYnhXYjlVb1FicFIwMWRsSnVjc2ZhM1FX?=
 =?utf-8?B?THY5TnFvaVdiVFh0akdLUjhEZ2lrNmFjTjJwdFlRREcwM2YwbjhyU1daa0FK?=
 =?utf-8?B?c3FDQ3VxQW42VWJDaFNrbEVxaXhMcXgwUG9XMDMzM25jeW9oNEhWd1pYYWFI?=
 =?utf-8?B?WmltK2NrZFFxdVBIQlIwSENHeFM2WFZlTlJCOGJjSnJqZVphNlcwMjI5QVNi?=
 =?utf-8?Q?7RY0R+aDGkzpm04vHl8S2kQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D51536D6DCC02142AC5F572526AD969E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hTLs9fm9x1M5E2JHgTApX4Gi4E2xVpEs96HHQ1YW66zoEnZNNal7LWfqUObjBvxQEA9K6SKuVuKbsgmYbbM65qbuZJ66oqLNeV3ZCq85SA5eQzIoV8bqB8C/1fD6ZltUDwO2keejHcKG7Jqksbga3ZVeCQeorPTqYG/ruOEeKlumvT4u0d7+a2wmmcnauMRu/hoVVQKuguE74UHhVqvd6m2L+aT4EEJ2OyZ6Uip6ohgxjn6magJHg/3bel3bYC5emK4IvW+x0BxOWNfHWrffZgXecR9Z/i/zL1cGE6dRfwPjPTiRfI4G4yrfT6Gb6PonVgLFNnWPvBW1G/p6vr3ht0z90KKbY6YA6Y+puIBF/rNlouimIiS9H80yPfNV+QAE9+lX9UQ3MhIC/1IXyvdrDNsO4kB8/T158kMWlPVHuWzwZIYE8ZFNhJNI69ZVWRk1giTxFtwXMbfh3FLhcvc9p4+RlXC1RJJCQrlmvIi7h9lJKajU3X4L3jFzZpCxYQ0vwwtwMprjMXEI4Rvmm7isn3HTPz4qe1GLAzMTP68saS/47+YusG8jnKvKmZ92p+f5F9GS8EQOtLw47lz6rU+XUBGJLXsJ9xOzRcZtDKQFhUztC1wiXrr/qvdgLR/EVBl8H6ID+F9S0KL0GG9LI6enE/YkeG8KtOcX9B78ZEDkhT2Q7ii0KABHPeWDbZsLjvE0R49zORWYcB5iY+LrzsPgL+lFpmxNGb6bfS8g7cY1ZTtZeYLj8WEFJidDlEC15/yXEvak21f0USt4HJS1u0OkPPSJTUS5St7oHL/vffTqf1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd4e468-01db-4f71-feef-08dafa509993
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 19:08:50.6974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68zw6PU6a9YLf8LicxqAUYIYSW75EVH+cDRpqKwpELefJZrypnSf/wMRQT/QgUgWLR7HCXx25+usGGclq5630lMaAde92xm4Wl2TqGqoVik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_13,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190160
X-Proofpoint-ORIG-GUID: GZ7ExtKFmHxkx1FeBgGPxDdolRxkA09e
X-Proofpoint-GUID: GZ7ExtKFmHxkx1FeBgGPxDdolRxkA09e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDA5OjQ0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IFdoZW4gYW4gWEZT
IGZpbGVzeXN0ZW0gaGFzIGZyZWUgaW5vZGVzIGluIGNodW5rcyBhbHJlYWR5IGFsbG9jYXRlZAo+
IG9uIGRpc2ssIGl0IHdpbGwgc3RpbGwgYWxsb2NhdGUgbmV3IGlub2RlIGNodW5rcyBpZiB0aGUg
dGFyZ2V0IEFHCj4gaGFzIG5vIGZyZWUgaW5vZGVzIGluIGl0LiBOb3JtYWxseSwgdGhpcyBpcyBh
IGdvb2QgaWRlYSBhcyBpdAo+IHByZXNlcnZlcyBsb2NhbGl0eSBvZiBhbGwgdGhlIGlub2RlcyBp
biBhIGdpdmVuIGRpcmVjdG9yeS4KPiAKPiBIb3dldmVyLCBhdCBFTk9TUEMgdGhpcyBjYW4gbGVh
ZCB0byB1c2luZyB0aGUgbGFzdCBmZXcgcmVtYWluaW5nCj4gZnJlZSBmaWxlc3lzdGVtIGJsb2Nr
cyB0byBhbGxvY2F0ZSBhIG5ldyBjaHVuayB3aGVuIHRoZXJlIGFyZSBtYW55LAo+IG1hbnkgZnJl
ZSBpbm9kZXMgdGhhdCBjb3VsZCBiZSBhbGxvY2F0ZWQgd2l0aG91dCBjb25zdW1pbmcgZnJlZQo+
IHNwYWNlLiBUaGlzIHJlc3VsdHMgaW4gc3BlZWRpbmcgdXAgdGhlIGNvbnN1bXB0aW9uIG9mIHRo
ZSBsYXN0IGZldwo+IGJsb2NrcyBhbmQgaW5vZGUgY3JlYXRlIG9wZXJhdGlvbnMgdGhlbiByZXR1
cm5pbmcgRU5PU1BDIHdoZW4gdGhlcmUKPiBmcmVlIGlub2RlcyBhdmFpbGFibGUgYmVjYXVzZSB3
ZSBkb24ndCBoYXZlIGVub3VnaCBibG9jayBsZWZ0IGluIHRoZQo+IGZpbGVzeXN0ZW0gZm9yIGRp
cmVjdG9yeSBjcmVhdGlvbiByZXNlcnZhdGlvbnMgdG8gcHJvY2VlZC4KPiAKPiBIZW5jZSB3aGVu
IHdlIGFyZSBuZWFyIEVOT1NQQywgd2Ugc2hvdWxkIGJlIGF0dGVtcHRpbmcgdG8gcHJlc2VydmUK
PiB0aGUgcmVtYWluaW5nIGJsb2NrcyBmb3IgZGlyZWN0b3J5IGJsb2NrIGFsbG9jYXRpb24gcmF0
aGVyIHRoYW4KPiB1c2luZyB0aGVtIGZvciB1bm5lY2Vzc2FyeSBpbm9kZSBjaHVuayBjcmVhdGlv
bi4KPiAKPiBUaGlzIHBhcnRpY3VsYXIgYmVoYXZpb3VyIGlzIGV4cG9zZWQgYnkgeGZzLzI5NCwg
d2hlbiBpdCBkcml2ZXMgdG8KPiBFTk9TUEMgb24gZW1wdHkgZmlsZSBjcmVhdGlvbiB3aGlsc3Qg
dGhlcmUgYXJlIHN0aWxsIHRob3VzYW5kcyBvZgo+IGZyZWUgaW5vZGVzIGF2YWlsYWJsZSBmb3Ig
YWxsb2NhdGlvbiBpbiBvdGhlciBBR3MgaW4gdGhlIGZpbGVzeXN0ZW0uCj4gCj4gSGVuY2UsIHdo
ZW4gd2UgYXJlIHdpdGhpbiAxJSBvZiBFTk9TUEMsIGNoYW5nZSB0aGUgaW5vZGUgYWxsb2NhdGlv
bgo+IGJlaGF2aW91ciB0byBwcmVmZXIgdG8gdXNlIGV4aXN0aW5nIGZyZWUgaW5vZGVzIG92ZXIg
YWxsb2NhdGluZyBuZXcKPiBpbm9kZSBjaHVua3MsIGV2ZW4gdGhvdWdoIGl0IHJlc3VsdHMgaXMg
cG9vcmVyIGxvY2FsaXR5IG9mIHRoZSBkYXRhCj4gc2V0LiBJdCBpcyBtb3JlIGltcG9ydGFudCBm
b3IgdGhlIGFsbG9jYXRpb25zIHRvIGJlIHNwYWNlIGVmZmljaWVudAo+IG5lYXIgRU5PU1BDIHRo
YW4gdG8gaGF2ZSBvcHRpbWFsIGxvY2FsaXR5IGZvciBwZXJmb3JtYW5jZSwgc28gbGV0cwo+IG1v
ZGlmeSB0aGUgaW5vZGUgQUcgc2VsZWN0aW9uIGNvZGUgdG8gcmVmbGVjdCB0aGF0IGZhY3QuCj4g
Cj4gVGhpcyBhbGxvd3MgZ2VuZXJpYy8yOTQgdG8gbm90IG9ubHkgcGFzcyB3aXRoIHRoaXMgYWxs
b2NhdG9yIHJld29yawo+IHBhdGNoc2V0LCBidXQgdG8gaW5jcmVhc2UgdGhlIG51bWJlciBvZiBw
b3N0LUVOT1NQQyBlbXB0eSBpbm9kZQo+IGFsbG9jYXRpb25zIHRvIGZyb20gfjYwMCB0byB+OTA4
MCBiZWZvcmUgd2UgaGl0IEVOT1NQQyBvbiB0aGUKPiBkaXJlY3RvcnkgY3JlYXRlIHRyYW5zYWN0
aW9uIHJlc2VydmF0aW9uLgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhdmUgQ2hpbm5lciA8ZGNoaW5u
ZXJAcmVkaGF0LmNvbT4KT2ssIG1ha2VzIHNlbnNlClJldmlld2VkLWJ5OiBBbGxpc29uIEhlbmRl
cnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4KIAo+IC0tLQo+IMKgZnMveGZzL2xp
Ynhmcy94ZnNfaWFsbG9jLmMgfCAxNyArKysrKysrKysrKysrKysrKwo+IMKgMSBmaWxlIGNoYW5n
ZWQsIDE3IGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNf
aWFsbG9jLmMgYi9mcy94ZnMvbGlieGZzL3hmc19pYWxsb2MuYwo+IGluZGV4IDUxMThkZWRmOTI2
Ny4uZTgwNjg0MjJhYTIxIDEwMDY0NAo+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2lhbGxvYy5j
Cj4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfaWFsbG9jLmMKPiBAQCAtMTczNyw2ICsxNzM3LDcg
QEAgeGZzX2RpYWxsb2MoCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfcGVyYWfCoMKgwqDC
oMKgwqDCoMKgKnBhZzsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9fZ2VvbWV0cnnC
oCppZ2VvID0gTV9JR0VPKG1wKTsKPiDCoMKgwqDCoMKgwqDCoMKgYm9vbMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBva19hbGxvYyA9IHRydWU7Cj4gK8KgwqDCoMKgwqDC
oMKgYm9vbMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsb3dfc3BhY2Ug
PSBmYWxzZTsKPiDCoMKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZmxhZ3M7Cj4gwqDCoMKgwqDCoMKgwqDCoHhmc19pbm9fdMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlubzsKPiDCoAo+IEBAIC0xNzY3LDYgKzE3NjgsMjAgQEAg
eGZzX2RpYWxsb2MoCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBva19hbGxvYyA9
IGZhbHNlOwo+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqAKPiArwqDCoMKgwqDCoMKgwqAvKgo+ICvC
oMKgwqDCoMKgwqDCoCAqIElmIHdlIGFyZSBuZWFyIHRvIEVOT1NQQywgd2Ugd2FudCB0byBwcmVm
ZXIgYWxsb2NhdGlvbgo+IGZyb20gQUdzIHRoYXQKPiArwqDCoMKgwqDCoMKgwqAgKiBoYXZlIGZy
ZWUgaW5vZGVzIGluIHRoZW0gcmF0aGVyIHRoYW4gdXNlIHVwIGZyZWUgc3BhY2UKPiBhbGxvY2F0
aW5nIG5ldwo+ICvCoMKgwqDCoMKgwqDCoCAqIGlub2RlIGNodW5rcy4gSGVuY2Ugd2UgdHVybiBv
ZmYgYWxsb2NhdGlvbiBmb3IgdGhlIGZpcnN0Cj4gbm9uLWJsb2NraW5nCj4gK8KgwqDCoMKgwqDC
oMKgICogcGFzcyB0aHJvdWdoIHRoZSBBR3MgaWYgd2UgYXJlIG5lYXIgRU5PU1BDIHRvIGNvbnN1
bWUgZnJlZQo+IGlub2Rlcwo+ICvCoMKgwqDCoMKgwqDCoCAqIHRoYXQgd2UgY2FuIGltbWVkaWF0
ZWx5IGFsbG9jYXRlLCBidXQgdGhlbiB3ZSBhbGxvdwo+IGFsbG9jYXRpb24gb24gdGhlCj4gK8Kg
wqDCoMKgwqDCoMKgICogc2Vjb25kIHBhc3MgaWYgd2UgZmFpbCB0byBmaW5kIGFuIEFHIHdpdGgg
ZnJlZSBpbm9kZXMgaW4KPiBpdC4KPiArwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKg
wqBpZiAocGVyY3B1X2NvdW50ZXJfcmVhZF9wb3NpdGl2ZSgmbXAtPm1fZmRibG9ja3MpIDwKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG1wLT5tX2xvd19z
cGFjZVtYRlNfTE9XU1BfMV9QQ05UXSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBva19hbGxvYyA9IGZhbHNlOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBsb3df
c3BhY2UgPSB0cnVlOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gwqDCoMKgwqDCoMKgwqDCoC8q
Cj4gwqDCoMKgwqDCoMKgwqDCoCAqIExvb3AgdW50aWwgd2UgZmluZCBhbiBhbGxvY2F0aW9uIGdy
b3VwIHRoYXQgZWl0aGVyIGhhcwo+IGZyZWUgaW5vZGVzCj4gwqDCoMKgwqDCoMKgwqDCoCAqIG9y
IGluIHdoaWNoIHdlIGNhbiBhbGxvY2F0ZSBzb21lIGlub2Rlcy7CoCBJdGVyYXRlIHRocm91Z2gK
PiB0aGUKPiBAQCAtMTc5NSw2ICsxODEwLDggQEAgeGZzX2RpYWxsb2MoCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFr
Owo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmbGFncyA9IDA7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAobG93
X3NwYWNlKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoG9rX2FsbG9jID0gdHJ1ZTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHhmc19wZXJhZ19w
dXQocGFnKTsKPiDCoMKgwqDCoMKgwqDCoMKgfQoK
