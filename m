Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7059AC05027
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Feb 2023 20:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBQUCp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Feb 2023 15:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBQUCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2023 15:02:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB97C5ECA0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 12:02:41 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31HGNpCk032039;
        Fri, 17 Feb 2023 20:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bjeN/DWsHeGgZY6uOK4Cg1X2BSjtuAOtjbEDXOybalY=;
 b=dhqFsvbo4wlfh/Bi/hp0z1bXbo4nGKAbYiPHzyHTkJBt0dhtZLdKXJy2EtK8ro6RPbqX
 GEH/L0s/DrR55kahDJ7AYqlIkEmoh1BZhDTCOfXgglo7hnwupX4ej0sqaimqrrNcd97x
 6GuqGXDtN86r0cfCURa89LGqoBfgQnGZzft8rD2pp2lKJLalYirBAbAx//ciy64S+qto
 aaa6VlIf8khgajl9bFXAy2RqJsuCIkdFA47PESSPwPh0Z7JfkZ7QXjm7mEqzCDUjYbm8
 MVMF3o9F696WRpEjgOphCH1WZn0rlannjj3TMw/kAbm3XQ5IsfHu1n09c+6ew4q7ct+G lQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2mtptyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 20:02:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31HIZWQ9019910;
        Fri, 17 Feb 2023 20:02:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1fb2ttm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 20:02:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9lJqyrjce/NLQBmGya0acGekuya1Qx5fTvL9yxMYZ9YheGWez/LL1QjqV1RNjLidEcO1NzFg/nh0ZGQd1NFQaUqAl/eMyg4+gSy9lXDgy4CsEBLlnJvXHixg5H9AjrBWQFVBSK4tVd1VGnJfYCjq+W4viT+nov0lox7A57PAPe4qafQElkcmtDR/uYMVMGnj6cAlMOjf8Rr8xamWgyvQmkX8eLJ5+dmfpGLrQZw6IHUKP2nD56HPIES/hcXx2dDVwlinBxp/kBpYho1OfOW+/23pBHdkJwTTb2mUGCBTxd8DTRROm7xd+PlsotjtwXxFQpcE/v3cS7xKuduVZT6ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjeN/DWsHeGgZY6uOK4Cg1X2BSjtuAOtjbEDXOybalY=;
 b=T8Td6q6se3PA6pQ4cya3GT8gA8tWgpLRF7BBFWvrJuu3/H47kEsVY7xUow+b0CjISfvvwozay36NmPw1necWhnzrf7v9WhgPm9DKX9p1q3fv8GTzcNTRGYOYzGdzjzR6nyC76yiSAz7k1UPy+dIIq8rjbLv36ZNBnFEUzwJB4e8bS46f4Drl0Xct8AhNOZMtXd77/wd6b3suXaPh7hsKHGR1OwONDdNW65Pc5W92Lp560HB6lKiXD2LaRwrHr9TdP0fw08kHuJC1/mCunKy6V18u66NsFiIkllL9byUGsnkANVO7M7ETkvjJaudqo26Jn8AhrgU9o1QYVtPTI7TJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjeN/DWsHeGgZY6uOK4Cg1X2BSjtuAOtjbEDXOybalY=;
 b=ZY2WKamclmPL0Mrbx337L5v6nu/sjhkvVNCwniWlewdsP1lJPm5/Tqaqz7NYIpcF+JcdXsoZ7B13blPocXOeP/SA2Q6ntSX9AIYs2IeBNAXvY3V/18JwrHRwhOMTKX6cq4PaAU4dCV9IlZmQ8H3yMfCI2R7WkViX0HJPuJmRhtY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5381.namprd10.prod.outlook.com (2603:10b6:408:128::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6; Fri, 17 Feb
 2023 20:02:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6134.006; Fri, 17 Feb 2023
 20:02:29 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC DELUGE v9r2d1] xfs: Parent Pointers
Thread-Topic: [RFC DELUGE v9r2d1] xfs: Parent Pointers
Thread-Index: AQHZQkItZlHBBP1ZGkWf8BFT+JAjD67TkQEA
Date:   Fri, 17 Feb 2023 20:02:29 +0000
Message-ID: <8a65fba38b8a8f9167f27f2a2d6151c8d84bfa61.camel@oracle.com>
References: <Y+6MxEgswrJMUNOI@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|BN0PR10MB5381:EE_
x-ms-office365-filtering-correlation-id: 2dbc5e96-f272-4a36-1b8c-08db1121e60d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRFGWnC0qj3L/Ys4gS78K4S9WhE687LZ4mV8CnbBbmppuufRzKfBjb6d/ykN9c+LOGkCNfUdz8cfXNP+OFrrAxDxFG2kcLUYcG8vuJ95DIuEfL1oVeYiPvzUQjHFqaQvMMiNzew5zRsL3LCKTFbA0X5XF59MohE+G76VGvNJbCdpy1ezrK8K2ZKIvqntG3EAChhKp71avo25OLi27ywi69U2Gi9IBKztB5OF7uI7+Eeyl/hz+BARFhP+9YmuAD7WdqmaEUvdCimEiqtuIqBIdJHB9dB8Ge7jCLUzdf9o5XMX4vjys8cWEluQUEvqHBp9q0HKEzElgmPQzgXXIc5+usfhDJl5AMDLlg7yf8rAFzQyL9GEa2Gqu4HJLRyynjW2DQL0JX3hN5E2D5GAutyvQ+wMgftHHM8tH2yIdaAQwBZCmrMz9QT4OZ9NCmPo78Gb3Xr+n/QvCidYbwrlBI+H/XgiVA7Clmn2ZQ0P4Wrrfjmhr0J1ZEQveil/rD09m7BeeudCcC1kGjOBMnQEPGVRBxVVxbY+tIWdP4WQAw/scShm5RMkHYEgYQOZCxce3WkiOF2vUCTipWv/9C+r+cs7smdzD+7MgS75scgR3gqDqTxQV8FU+foi2w9v1irORH1xT36nEOIBjQpbsiM7JHvny1DHOSfQXwvaWEYFCnVM4doXkNwi8kxaHjkZW1Li9aXsAhhgVDTyRM7WT9P2zprBPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199018)(2906002)(316002)(8936002)(44832011)(5660300002)(38070700005)(76116006)(66946007)(66446008)(64756008)(66556008)(66476007)(6916009)(8676002)(41300700001)(2616005)(4326008)(86362001)(38100700002)(36756003)(83380400001)(6486002)(122000001)(66899018)(478600001)(186003)(6506007)(71200400001)(6512007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVJIV0NyWkZmelE1eE4zb0s2aEJWMW56V093TklGQXN6bFFtYTdOZ0hTcy8v?=
 =?utf-8?B?RnpmWnFLY01kYTNFV1B4VTdxUHFHZ2pPaVhORGlUN2hpS1ZHT0pKNkRFQzVG?=
 =?utf-8?B?cjgxZFZuMXJhOGxwQUpkQzI3Njg2SlpHRDlBeHU2L0hFUEhxT1F3MEJPVitY?=
 =?utf-8?B?YWNrNG1TWlh5VDNmS3Z4eVV1bS9TSDFqMkVra2hXTVNzNHBCTlcyY2VHU3hp?=
 =?utf-8?B?SjRQRVhVOVVHS3lvcUFNdno2emhqTXN6bFpXeHBiNVdJdFhPY1QwcmpuM3Y1?=
 =?utf-8?B?MDZjenpsUXJRcDhualNBWUxhcUNNbHBOTUFnTVNKYVc2TGV6b2REZm1kQW84?=
 =?utf-8?B?RHVsTTFESnBTNE1EUWRiV0ZWcmwzd1psRnZ1Y2dGd0hoMVNmTGE1SjFZM1NU?=
 =?utf-8?B?UCsxN1ZCUVYxRk9QSjVjS214dlJkaG8rMUVUOFE1TXBtcEY5SWJDTlJvdkZH?=
 =?utf-8?B?dThuOTJTYWRpYUI3RUwrTCtKb0Y3R2RxTXRVK3lXeFpJeTJnOUl5enRoblFB?=
 =?utf-8?B?aDQ4SFhiQVBRb3ZVeUhQQUF0NzQvZ2h5dFZFY3FYY1kvQlpMMHE1NUIwREtr?=
 =?utf-8?B?Zy93SGdFVWQ3UytQeFVqdnJKY0NPczc2YUJ0UVBhcTVUUDhtYkVMQ2hZK3My?=
 =?utf-8?B?c3BZZUM1MGQxVGZiRTdyL2hrRWhIaitZZmYxVE5peUtkWGVNNlJ4R2xWb2FT?=
 =?utf-8?B?M2Jrb3JrcTBnbTNoVjE3aUxHUld2bnJGa0tNbDBpNnlPVGZUQ1ovZG5EalBm?=
 =?utf-8?B?aW95NEpqY212UVNRMGZlNEZFUnBXcWk5bWw0UitENUc5c0MyWG4yelpUMXVj?=
 =?utf-8?B?LzYrVnZ2TkNXa3BVRXgydGx5bkYxeXlGQVVZKzYyT0lnQnIrT0diMEhrUzU5?=
 =?utf-8?B?SHR0REpoc3A5cEowWE1CdTVodFVNNnVXWnNxSDBJM1JxbHdxVHAzdzhEMXlj?=
 =?utf-8?B?ckxHdEQyWUZlSTlBU2R5dXQ0OU52alhPcXFDRUtldnUwUmtza0ZaWjdRUms0?=
 =?utf-8?B?dnF1Y1Yya1JmYUk2WnVvT2grMW5ndldKS0RoQ0hzU1A1dW5HRnozcC81VHZx?=
 =?utf-8?B?M1BsdWwyWmxFZkV1UkNFM0FjM3BQQ01kTlNtSUZFMFhHYWFVMzJuZWZaSXFC?=
 =?utf-8?B?ZlRHUU9JelR3S3BPajU3aFpKMGo0VThxTjd3WmY3V0dhS3dSeEtEQzJiZ2Fq?=
 =?utf-8?B?eGgrVzl3ckhQNVZnNW9NSGpiaE5NZ2VsKzFRMVdNUEZ2SDdRUW14a1A2TGpm?=
 =?utf-8?B?UU4rZXRFdFVQTk5ibm8vZlhRd3A4S3ZvUzI5d3F3emFzS2hvd2VMdHJiZHpu?=
 =?utf-8?B?REJjdkczYkxBdDBXUEg3K3c0eXdZRUZBbSs0T01KUHA4cDhoUWVsQ0xWVW5O?=
 =?utf-8?B?SU80U0Fra2lFTGpsbUhiRHlHZGxJS3J4OVZPYnFqWU9zM3FJLzBxa3IyQTZi?=
 =?utf-8?B?a2x5aDRVNUxoQUQ5c2c5RGxibytSaGVzS1l1QnBWc1c4MjYxWUdXQTRkSTN5?=
 =?utf-8?B?bUZZN2J3RFRRSWwwNUR0a3FLNlFMMnBlNjlmWVkybjJGRDhBTmxhZTRiS0ZV?=
 =?utf-8?B?UlZQcjRPR2ZRU0h4RzBtRmFta0YyODBVUnRUaEVTVUNZMUtmK0dyQldTQ3Bi?=
 =?utf-8?B?MjJRUklJaERkS0tNQXpXaWR4ZWVUVXpoQnVMV0pwakR3dndlY2tmQUFMZXc5?=
 =?utf-8?B?LzFyaTQ5bEN3KzFMV1F1MXdNakprTTFlaVBoS042QVJPWmYvS2U0aUJJVyt1?=
 =?utf-8?B?OEV5bktFU2kxWDN0T3NmUTdiVFFteHluRWY0ZU1WNEN3U0VmbWo5cHQxb1hN?=
 =?utf-8?B?NDd1N0d6UG8vcjdXWTlvVTFiT2xKT3R6NmMvYjBudkQ1OWdUaER5dFZtYXN2?=
 =?utf-8?B?NGx3ck9DVWF0TGpocGcvVjJUQlNFOXhGdCttb0ptZ1BuQ2l5dU5CSlluaTkx?=
 =?utf-8?B?cjNNQWc5OTVkYVFBdGxkK29vM25hOEpldXVDRTlRUEtaaVJWWC8xZnFtc2xi?=
 =?utf-8?B?L1V0K2E3T1ZSVzVMbVROK0Q4UHNRT3cxNU94K21XbkU3by9INDNwL2w4Nko4?=
 =?utf-8?B?cmxGZlMvNHMxUnZHTGxLRjFnSXJHZWpOKzc5K3hMY2tkZ3dXczU0bTRGMG1w?=
 =?utf-8?B?UUQ0ZU9tcEErWS9vb2RkUHhydG5lOFRVVWx1dXlrRURTcThxdGVBdUdXYnRG?=
 =?utf-8?Q?V4indGlbt/3jF5YKF+a8c1o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9591E0DE78B695478444936E84A7E7A6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZyyBPHD+xhSTi5q3c+hSax0rlDiCZKar7bYETqi8u5s1hauzm9TGIHJYV7U90PIkoBHhgD5RyM7V9Pb30mRZoEUGfdOkmcmBrQ9RgyN4r3o/S2wGKl5x0zGrW2dfmgUoJTnz/tOkF+G16L/4+aEPNGnbVB+PNjXa7H4Y6pCwAuI4x/f0koPWUo6HXF9Z/boePmChAduUgWtvXuvGkZH3g5jiqFRH3TF+X26ajoSL31tMCMHW0dBpwVOy4JNN5cJXlkXsCnFTfcQCJjY4q+n96JYAHkNYYEmiDHJNbhcUSUkSnQM1dIPZqpGFxuNN5PaE7xvXo6janDi3Dk+LuuL0pPE7htovHzRygC0zv49IiShrvdcqiRZOsjhhY8/9E7ltiVMU39wtFQAA6oULlOUv+FBZYpbnolewP2EKtAo2jakqvPAb7skk3LTfPsjUV+F0bxLZA/q/7MAxyMsqYimwr9PnIU5qOLnSqAfx6uXwPnA+zWUMf/b6c53hsis2xqS0Oc209mYAUQog0tIewZmOB8xoKPe7siDSXYnDAETPH3I/Q1KfMUPIRS8i6fdAa4IYDIg5NEriD/+jemp7LSniOxb1uthZua6ORp/353KrgNmRKdCiVUmyTXpt/OW4lIx6Wh+zQZ8/2af6Bed/NaEvs3yaokoh4PbPyRzP53YGWvNHNpGJrU9i7Dj+mseGaoDeg3rAa4qLd4eX/jLcQoqqDZBiudSPMCuRl/LVdQIVMhUfIfeWjG6bjfoLpnsDbVa5M12Db3IQ6oM2WlJh6i2g2tlAJSKQua2cQVUD/+NlzTc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dbc5e96-f272-4a36-1b8c-08db1121e60d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 20:02:29.3956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C0dffEm2KzsmdvflUu8n4sUeCVFb/eyQd8m3Y/yS7JiQGcooN0TxE6whN4nxLj7uA5E2X670pD23qXtXok5BORiYvBqawLOnYwSkVgB9eAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_14,2023-02-17_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302170176
X-Proofpoint-GUID: VVKoDo1onkjX8vwmAeXn5vg2ZX83xqdR
X-Proofpoint-ORIG-GUID: VVKoDo1onkjX8vwmAeXn5vg2ZX83xqdR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAyLTE2IGF0IDEyOjA2IC0wODAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IEhpIGV2ZXJ5b25lLA0KPiANCj4gVGhpcyBkZWx1Z2UgY29udGFpbnMgYWxsIG9mIHRoZSBh
ZGRpdGlvbnMgdG8gdGhlIHBhcmVudCBwb2ludGVycw0KPiBwYXRjaHNldCB0aGF0IEkndmUgYmVl
biB3b3JraW5nIG9uIGZvciB0aGUgcGFzdCBtb250aC7CoCBUaGUga2VybmVsDQo+IGFuZA0KPiB4
ZnNwcm9ncyBwYXRjaHNldHMgYXJlIGJhc2VkIG9uIEFsbGlzb24ncyB2OXIyIHRhZyBmcm9tIGxh
c3Qgd2VlazsNCj4gdGhlIGZzdGVzdHMgcGF0Y2hlcyBhcmUgbWVyZWx5IGEgcGFydCBvZiBteSBk
ZXZlbG9wbWVudCB0cmVlLsKgIFRvDQo+IHJlY2FwDQo+IEFsbGlzb24ncyBjb3ZlciBsZXR0ZXI6
DQo+IA0KPiAiVGhlIGdvYWwgb2YgdGhpcyBwYXRjaCBzZXQgaXMgdG8gYWRkIGEgcGFyZW50IHBv
aW50ZXIgYXR0cmlidXRlIHRvDQo+IGVhY2gNCj4gaW5vZGUuwqAgVGhlIGF0dHJpYnV0ZSBuYW1l
IGNvbnRhaW5pbmcgdGhlIHBhcmVudCBpbm9kZSwgZ2VuZXJhdGlvbiwNCj4gYW5kDQo+IGRpcmVj
dG9yeSBvZmZzZXQsIHdoaWxlIHRoZcKgIGF0dHJpYnV0ZSB2YWx1ZSBjb250YWlucyB0aGUgZmls
ZSBuYW1lLg0KPiBUaGlzIGZlYXR1cmUgd2lsbCBlbmFibGUgZnV0dXJlIG9wdGltaXphdGlvbnMg
Zm9yIG9ubGluZSBzY3J1YiwNCj4gc2hyaW5rLA0KPiBuZnMgaGFuZGxlcywgdmVyaXR5LCBvciBh
bnkgb3RoZXIgZmVhdHVyZSB0aGF0IGNvdWxkIG1ha2UgdXNlIG9mDQo+IHF1aWNrbHkNCj4gZGVy
aXZpbmcgYW4gaW5vZGVzIHBhdGggZnJvbSB0aGUgbW91bnQgcG9pbnQuIg0KPiANCj4gVGhlIGtl
cm5lbCBicmFuY2hlcyBzdGFydCB3aXRoIGEgbnVtYmVyIG9mIGJ1ZiBmaXhlcyB0aGF0IEkgbmVl
ZCB0bw0KPiBnZXQNCj4gZnN0ZXN0cyB0byBwYXNzLsKgIEkgYWxzbyByZXN0cnVjdHVyZWQgdGhl
IGtlcm5lbCBpbXBsZW1lbnRhdGlvbiBvZg0KPiBHRVRQQVJFTlRTIHRvIGN1dCB0aGUgbWVtb3J5
IHVzYWdlIGNvbnNpZGVyYWJseS4NCj4gDQo+IEZvciB1c2Vyc3BhY2UsIEkgY2xlYW5lZCB1cCB0
aGUgeGZzcHJvZ3MgcGF0Y2hlcyBzbyB0aGF0IGxpYnhmcy1kaWZmDQo+IHNob3dzIG5vIGRpc2Ny
ZXBhbmNpZXMgd2l0aCB0aGUga2VybmVsIGFuZCBjbGVhbmVkIHVwIHRoZSBwYXJlbnQNCj4gcG9p
bnRlcg0KPiB1c2FnZSBjb2RlIHRoYXQgSSBwcm90b3R5cGVkIGluIDIwMTcgc28gdGhhdCBpdCdz
IGxlc3MgYnVnZ3kgYW5kDQo+IG1vbGR5Lg0KPiBJIGFsc28gcmV3aXJlZCB4ZnNfc2NydWIgdG8g
dXNlIEdFVFBBUkVOVFMgdG8gcmVwb3J0IGZpbGUgcGF0aHMgb2YNCj4gY29ycnVwdCBmaWxlcyBp
bnN0ZWFkIG9mIGlub2RlIG51bWJlcnMsIHNpbmNlIHRoYXQgcGFydCBoYWQgYml0cm90dGVkDQo+
IGJhZGx5Lg0KPiANCj4gV2l0aCB0aGF0IG91dCBvZiB0aGUgd2F5LCBJIGltcGxlbWVudGVkIGEg
cHJvdG90eXBlIG9mIG9ubGluZSByZXBhaXJzDQo+IGZvciBkaXJlY3RvcmllcyBhbmQgcGFyZW50
IHBvaW50ZXJzLsKgIFRoaXMgaXMgb25seSBhIHByb29mIG9mDQo+IGNvbmNlcHQsDQo+IGJlY2F1
c2UgSSBoYWQgYWxyZWFkeSBiYWNrcG9ydGVkIG1hbnkgbWFueSBwYXRjaGVzIGZyb20gcGFydCAx
IG9mDQo+IG9ubGluZQ0KPiByZXBhaXIsIGFuZCBkaWRuJ3QgZmVlbCBsaWtlIHBvcnRpbmcgdGhl
IHBhcnRzIG5lZWRlZCB0byBjb21taXQgbmV3DQo+IHN0cnVjdHVyZXMgYXRvbWljYWxseSBhbmQg
cmVhcCB0aGUgb2xkIGRpci94YXR0ciBibG9ja3MuwqAgSU9XcywgdGhlDQo+IHByb3RvdHlwZSBz
Y2FucyB0aGUgZmlsZXN5c3RlbSB0byBidWlsZCBhIHBhcmFsbGVsIGRpcmVjdG9yeSBvciB4YXR0
cg0KPiBzdHJ1Y3R1cmUsIGFuZCB0aGVuIHJlcG9ydHMgb24gYW55IGRpc2NyZXBhbmNpZXMgYmV0
d2VlbiB0aGUgdHdvDQo+IHZlcnNpb25zLsKgIE9idmlvdXNseSB0aGlzIHdvbid0IGZpeCBhIGNv
cnJ1cHQgZGlyZWN0b3J5IHRyZWUsIGJ1dCBpdA0KPiBlbmFibGVzIHVzIHRvIHRlc3QgdGhlIHJl
cGFpciBjb2RlIG9uIGEgY29uc2lzdGVudCBmaWxlc3lzdGVtIHRvDQo+IGRlbW9uc3RyYXRlIHRo
YXQgaXQgd29ya3MuDQo+IA0KPiBOZXh0LCBJIGltcGxlbWVudGVkIGZ1bGx5IGZ1bmN0aW9uYWwg
cGFyZW50IHBvaW50ZXIgY2hlY2tpbmcgYW5kDQo+IHJlcGFpcg0KPiBmb3IgeGZzX3JlcGFpci7C
oCBUaGlzIHdhcyBsZXNzIGhhcmQgdGhhbiBJIGd1ZXNzZWQgaXQgd291bGQgYmUNCj4gYmVjYXVz
ZQ0KPiB0aGUgY3VycmVudCBkZXNpZ24gb2YgcGhhc2UgNiBpbmNsdWRlcyBhIHdhbGsgb2YgYWxs
IGRpcmVjdG9yaWVzLsKgDQo+IEZyb20NCj4gdGhlIGRpcmVudCBkYXRhLCB3ZSBjYW4gYnVpbGQg
YSBwZXItQUcgaW5kZXggb2YgYWxsIHRoZSBwYXJlbnQNCj4gcG9pbnRlcnMNCj4gZm9yIGFsbCB0
aGUgaW5vZGVzIGluIHRoYXQgQUcsIHRoZW4gd2FsayBhbGwgdGhlIGlub2RlcyBpbiB0aGF0IEFH
IHRvDQo+IGNvbXBhcmUgdGhlIGxpc3RzLsKgIEFzIHlvdSBtaWdodCBndWVzcywgdGhpcyBlYXRz
IGEgZmFpciBhbW91bnQgb2YNCj4gbWVtb3J5LCBldmVuIHdpdGggYSBydWRpbWVudGFyeSBkaXJl
bnQgbmFtZSBkZWR1cGxpY2F0aW9uIHRhYmxlIHRvDQo+IGN1dA0KPiBkb3duIG9uIG1lbW9yeSB1
c2FnZS4NCj4gDQo+IEFmdGVyIHRoYXQsIEkgbW92ZWQgb24gdG8gc29sdmluZyB0aGUgbWFqb3Ig
cHJvYmxlbSB0aGF0IEkndmUgYmVlbg0KPiBoYXZpbmcgd2l0aCB0aGUgZGlyZWN0b3J5IHJlcGFp
ciBjb2RlLCBhbmQgdGhhdCBpcyB0aGUgcHJvYmxlbSBvZg0KPiByZWNvbnN0cnVjdGluZyBkaXJl
bnRzIGF0IHRoZSBvZmZzZXRzIHNwZWNpZmllZCBieSB0aGUgcGFyZW50DQo+IHBvaW50ZXJzLg0K
PiBUaGUgZGV0YWlscyBvZiB0aGUgcHJvYmxlbSBhbmQgaG93IEkgZGVhbHQgd2l0aCBpdCBhcmUg
Y2FwdHVyZWQgaW4NCj4gdGhlDQo+IGNvdmVyIGxldHRlciBmb3IgdGhvc2UgcGF0Y2hlcy7CoCBT
dWZmaWNlIHRvIHNheSwgd2Ugbm93IGVuY29kZSB0aGUNCj4gZGlyZW50IG5hbWUgaW4gdGhlIHBh
cmVudCBwb2ludGVyIGF0dHJuYW1lIChvciBhIGNvbGxpc2lvbiByZXNpc3RhbnQNCj4gaGFzaCBp
ZiBpdCBkb2Vzbid0IGZpdCksIHdoaWNoIG1ha2VzIGl0IHBvc3NpYmxlIHRvIGNvbW1pdCBuZXcN
Cj4gZGlyZWN0b3JpZXMgYXRvbWljYWxseS4NCj4gDQo+IFRoZSBsYXN0IHBhcnQgb2YgdGhpcyBw
YXRjaHNldCByZW9yZ2FuaXplcyB0aGUgWEZTX0lPQ19HRVRQQVJFTlRTDQo+IGlvY3RsDQo+IHRv
IGVuY29kZSB2YXJpYWJsZSBsZW5ndGggcGFyZW50IHBvaW50ZXIgcmVjb3JkcyBpbiB0aGUgY2Fs
bGVyJ3MNCj4gYnVmZmVyLg0KPiBUaGUgZGVuc2VyIGVuY29kaW5ncyBtZWFuIHRoYXQgd2UgY2Fu
IGV4dHJhY3QgdGhlIHBhcmVudCBsaXN0IHdpdGgNCj4gZmV3ZXINCj4ga2VybmVsIGNhbGxzLg0K
PiANCj4gLS1EDQoNCg0KRXJtZXJnZXJzaCwgdGhhdHMgYSBsb3QhICBUaGFua3MgZm9yIGFsbCB0
aGUgaGFyZCB3b3JrLiAgSSBmZWVsIGxpa2UgaWYNCndlIGRvbid0IGNvbWUgdXAgd2l0aCBhIHBs
YW4gZm9yIHJldmlldyB0aG91Z2gsIHBlb3BsZSBtYXkgbm90IGtub3cNCndoZXJlIHRvIHN0YXJ0
IGZvciB0aGVzZSBkZWx1Z2VzISAgTGV0cyBzZWUuLi4gaWYgd2UgaGFkIHRvIGJyZWFrIHRoaXMN
CmRvd24sIEkgdGhpbmsgd291bGQgZGl2aWRlIGl0IHVwIGJldHdlZW4gdGhlIGV4aXN0aW5nIHBh
cmVudCBwb2ludGVycw0KYW5kIHRoZSBuZXcgcHB0ciBwcm9wb3NpdGlvbnMgZm9yIG9mc2NrLiAg
VGhlbiBmdXJ0aGVyIGRpdmlkZSBpdCBhbW9uZw0Ka2VybmVsIHNwYWNlLCB1c2VyIHNwYWNlIGFu
ZCB0ZXN0IGNhc2UuICBJZiBJIGhhZCB0byBwaWNrIG9ubHkgb25lIG9mDQp0aGVzZSB0byBmb2N1
cyBhdHRlbnRpb24gb24sIHByb2JhYmx5IGl0IHNob3VsZCBiZSBuZXcgb2ZzY2sgY2hhbmdlcyBp
bg0KdGhlIGtlcm5lbCBzcGFjZSwgc2luY2UgdGhlIHJlc3Qgb2YgdGhlIGRlbHVnZSBpcyByZWFs
bHkgY29udGluZ2VudCBvbg0KaXQuIA0KDQpTbyBub3cgd2UndmUgbmFycm93ZWQgdGhpcyBkb3du
IHRvIGEgZmV3IHN1YnNldHM6DQoNCltQQVRDSFNFVCB2OXIyZDEgMC8zXSB4ZnM6IGJ1ZyBmaXhl
cyBmb3IgcGFyZW50IHBvaW50ZXJzDQpbUEFUQ0hTRVQgdjlyMmQxIDAvNF0geGZzOiByZXdvcmsg
dGhlIEdFVFBBUkVOVFMgaW9jdGwsDQpbUEFUQ0hTRVQgdjlyMmQxIDAwLzIzXSB4ZnM6IG9ubGlu
ZSBmc2NrIHN1cHBvcnQgcGF0Y2hlcw0KW1BBVENIU0VUIHY5cjJkMSAwLzddIHhmczogb25saW5l
IHJlcGFpciBvZiBkaXJlY3Rvcmllcw0KW1BBVENIU0VUIHY5cjJkMSAwLzJdIHhmczogb25saW5l
IGNoZWNraW5nIG9mIHBhcmVudCBwb2ludGVycw0KW1BBVENIU0VUIHY5cjJkMSAwLzNdIHhmczog
b25saW5lIGNoZWNraW5nIG9mIHBhcmVudCBwb2ludGVycw0KW1BBVENIU0VUIHY5cjJkMSAwLzJd
IHhmczogb25saW5lIGNoZWNraW5nIG9mIGRpcmVjdG9yaWVzDQpbUEFUQ0hTRVQgdjlyMmQxIDAv
NV0geGZzOiBlbmNvZGUgcGFyZW50IHBvaW50ZXIgbmFtZSBpbiB4YXR0ciBrZXkNCltQQVRDSFNF
VCB2OXIyZDEgMC8zXSB4ZnM6IHVzZSBmbGV4IGFycmF5cyBmb3IgWEZTX0lPQ19HRVRQQVJFTlRT
LA0KDQpPZiB0aG9zZSwgSSB0aGluayAieGZzOiBlbmNvZGUgcGFyZW50IHBvaW50ZXIgbmFtZSBp
biB4YXR0ciBrZXkiIGlzIHRoZQ0Kb25seSBvbmUgdGhhdCBtaWdodCBpbXBhY3Qgb3RoZXIgZmVh
dHVyZXMgc2luY2UgaXQncyBjaGFuZ2VpbmcgdGhlDQpvbmRpc2sgZm9ybWF0IGZyb20gd2hlbiB3
ZSBmaXJzdCBzdGFydGVkIHRoZSBlZmZvcnQgeWVhcnMgYWdvLiAgU28NCnByb2JhYmx5IHRoYXQg
bWlnaHQgYmUgdGhlIGJlc3QgcGxhY2UgZm9yIHBlb3BsZSB0byBzdGFydCBzaW5jZSBpZiB0aGlz
DQpuZWVkcyB0byBjaGFuZ2UgaXQgbWlnaHQgaW1wYWN0IHNvbWUgb2YgdGhlIG90aGVyIHN1YnNl
dHMgaW4gdGhlDQpkZWx1Z2UsIG9yIGV2ZW4gZmVhdHVyZXMgdGhleSBhcmUgd29ya2luZyBvbiBp
ZiB0aGV5J3ZlIGJhc2VkIGFueXRoaW5nDQpvbiB0aGUgZXhpc3RpbmcgcHB0ciBzZXQuDQoNCkkg
ZmVlbCBsaWtlIGEgNSBwYXRjaCBzdWJzZXQgaXMgYSB2ZXJ5IHJlYXNvbmFibGUgdGhpbmcgdG8g
YXNrIHBlb3BsZQ0KdG8gZ2l2ZSB0aGVpciBhdHRlbnRpb24gdG8uICBUaGF0IHdheSB0aGV5IGRv
bnQgZ2V0IGxvc3QgaW4gdGhpbmdzIGxpa2UNCm5pdHMgZm9yIG9wdGltaXphdGlvbnMgdGhhdCBt
aWdodCBub3QgZXZlbiBtYXR0ZXIgaWYgc29tZXRoaW5nIGl0DQpkZXBlbmRzIG9uIGNoYW5nZXMu
DQoNCkZvciB0aGUgbW9zdCBwYXJ0IEkgYW0gb2sgd2l0aCBjaGFuZ2VpbmcgdGhlIGZvcm1hdCBh
cyBsb25nIGFzIGV2ZXJ5b25lDQppcyBhd2FyZSBhbmQgaW4gYWdyZWVtZW50IHNvIHRoYXQgd2Ug
ZG9udCBnZXQgY2F1Z2h0IHVwIHJlLWNvZGluZw0KZWZmb3J0cyB0aGF0IHNlZW0gdG8gaGF2ZSBz
dHVnZ2xlZCB3aXRoIGRpc2FncmVlbWVudHMgbm93IG9uIHRoZSBzY2FsZQ0Kb2YgZGVjYWRlcy4g
IFNvbWUgb2YgdGhlc2UgcGF0Y2hlcyB3ZXJlIGFscmVhZHkgdmVyeSBvbGQgYnkgdGhlIHRpbWUg
SQ0KZ290IHRoZW0hDQoNCk9uIGEgc2lkZSBub3RlLCB0aGVyZSBhcmUgc29tZSBwcmVsaW1pbmFy
eSBwYXRjaGVzIG9mIGtlcm5lbCBzaWRlDQpwYXJlbnQgcG9pbnRlcnMgdGhhdCBhcmUgZWl0aGVy
IGxhcnAgZml4ZXMgb3IgcmVmYWN0b3Jpbmcgbm90IHNlbnNpdGl2ZQ0KdG8gdGhlIHByb3Bvc2Vk
IG9mc2NrIGNoYW5nZXMuICBUaGVzZSBwYXRjaGVzIGEgaGF2ZSBiZWVuIGZsb2F0aW5nDQphcm91
bmQgZm9yIGEgd2hpbGUgbm93LCBzbyBpZiBubyBvbmUgaGFzIGFueSBncmlwZXMsIEkgdGhpbmsg
anVzdA0KbWVyZ2luZyB0aG9zZSB3b3VsZCBoZWxwIGN1dCBkb3duIHRoZSBhbW91bnQgb2YgcmVi
YXNlaW5nLCB1c2VyIHNwYWNlDQpwb3J0aW5nIGFuZCBwYXRjaCByZXZpZXdpbmcgdGhhdCBnb2Vz
IG9uIGZvciBldmVyeSB2ZXJzaW9uLiAgKG1heWJlIHRoZQ0KZmlyc3QgMSB0aG91Z2ggNyBvZiB0
aGUgMjggcGF0Y2ggc2V0LCBpZiBmb2xrcyBhcmUgb2sgd2l0aCB0aGF0KQ0KDQpJIHRoaW5rIHRo
ZSBzaGVhciBzaXplIG9mIHNvbWUgb2YgdGhlc2Ugc2V0cyB0ZW5kIHRvIHdvcmsgYWdhaW5zdCB0
aGVtLA0KYXMgcGVvcGxlIGxpa2VseSBjYW5ub3QgYWZmb3JkIHRoZSB0aW1lIGJsb2NrIHRoZXkg
cHJlc2VudCBvbiB0aGUNCnN1cmZhY2UuICBTbyBJIHRoaW5rIHdlIHdvdWxkIGRvIHdlbGwgdG8g
ZmluZCBhIHdheSB0byBpbnRyb2R1Y2UgdGhlbQ0KYXQgYSByZWFzb25hYmxlIHBhY2UgYW5kIGtl
ZXAgYXR0ZW50aW9uIGZvY3VzZWQgb24gdGhlIHN1YnNlY3Rpb25zIHRoYXQNCnNob3VsZCByZXF1
aXJlIG1vcmUgdGhhbiBvdGhlcnMsIGFuZCBob3BlZnVsbHkga2VlcCB0aGluZyBtb3ZpbmcgaW4g
YQ0KcHJvZ3Jlc3NpdmUgZGlyZWN0aW9uLg0KDQpUaHghDQpBbGxpc29uDQoNCg==
