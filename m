Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABA4C54EE9
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Sep 2022 16:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiIVQ4L (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 12:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiIVQ4G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 12:56:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59849F274B
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 09:56:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGlfjs030830
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 16:56:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Y2vPG01sG0QTJ/RgKDArw+u5kn36v4hVtX8CLDRda/M=;
 b=FTTUnGX02HdpU1ds5nqLcfgqt0ZEvCdHe/dMNmLq5z0J3WIosbdHOTMSVmG6i30jv27F
 r9rmYLddHazq437c7lA+p6JKk96OGHtQTJ6ypqrMRE5SXvKH2cc3ii8pJy0068Lcs6rz
 gDm9QObhiG3V56nJImCQGouXN/3Q40/fDk5ElAWE00MIU5msdg2xfLq7rqCIpNTlaoks
 A81khpGPk0iVtYRo8pJSxy3K0vjeyRLMjRkGysl2hA/HYDDc5l1d6v81nni0it7qALAT
 1++oujfZuAFzQw9/FDrdZJmmZx+I/nkZSvOybPZezk4gSdRthiAWMgjyH03U4iKnLXJ/ Pg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kx627-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 16:56:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGDoRa031344
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 16:55:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39nuc8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Sep 2022 16:55:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ip5+rTJcNJPZbUja+jEvp6joAsKfcTMEzgVCATI6QAtMt4Upk0ZMc80OgcxNBQbNnWuB0P21YxFv1YWGCsdzcyOiTXOizCbKY2RFWYDk5SgzZ+L/zvDjK3MTxiJvQ8/78fLuQJH41lkJCeitraIo4BGHfGU7atDB8cxKpPy4/SyTvGTu3yhd9dBn43xY+sp1WMdWEgTrjF5c7jajBby6sL6YAnuBItoUW2frhRQ5auAkXlg317xT5FRuyPD1X+VfI3lLSv+WCiQ7pXAY5PAgzPs3YQliksmse5Gvkx7FPKssVsKrcJB+jT9m8AWmt2p4WJAs6f9z/0Ga2KLOHtcv4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2vPG01sG0QTJ/RgKDArw+u5kn36v4hVtX8CLDRda/M=;
 b=blkCRnGfdAYvUe9GpZ3TPf1D1cp/KTA2pvAoC3lxkUyC8AmrLEfTzMX4cSSoyD91oyiJ2oe9bqSOFwf8g22fgmXj/IJRHZ+gtx1hiB87ExDZdMYu1aVm/PZ6Kt0Td2vjECoZnmiK8HGBssnfE5ngZ6/32KnZ1h51uVCH4LXUe/qXTp4hsgzLH9gzL96RvCvCfvzqqizTYsSJlP4JGlkMZtt+4KwDPPKZIP5yNQkynHeaJ7D/0sPY5XfhwaXmS/GcShQl+jTVG6/bUMXsDyFNgO0uBWvn/au36OyqkpPeRXjQjCpSemPPwgpDS3p4ATJqBH/tV6rxWoo6cIk9/FZTNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2vPG01sG0QTJ/RgKDArw+u5kn36v4hVtX8CLDRda/M=;
 b=h5eNz7Q6YgONWI3mD3OgMbpq8BzVMVQA82vkZ3L/X11I9ZKILA7DqaqgRp+e+x3BBACYwjJtUuUEaLZjuQB7IifYrI+oi4XxV69q2RfB2mzI7pVq+t4dQg3p62fwYH0IjcLMW6pb3IKKvGf6a/4IH2Fo7scPs9BMMTy5hlQm2L0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5119.namprd10.prod.outlook.com (2603:10b6:5:297::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 16:55:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::1c59:e718:73e3:f1f9%3]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 16:55:58 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 23/26] xfs: Filter XFS_ATTR_PARENT for getfattr
Thread-Topic: [PATCH v3 23/26] xfs: Filter XFS_ATTR_PARENT for getfattr
Thread-Index: AQHYzkaIcN085NWnhUuqrW29UEbRcK3rq9AA
Date:   Thu, 22 Sep 2022 16:55:57 +0000
Message-ID: <0f57509fac3bdbf06d109384421d6c47467fd716.camel@oracle.com>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
         <20220922054458.40826-24-allison.henderson@oracle.com>
In-Reply-To: <20220922054458.40826-24-allison.henderson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DS7PR10MB5119:EE_
x-ms-office365-filtering-correlation-id: 63a48b06-f48e-4caa-f017-08da9cbb524f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 55KYpDaLAYa8pcRTtMBLSmUODLYvDU52ce35XVM5nIIAZ5OZZYD6G7TwiR7jfKCw9AT97MkRCKjXc9CQTHi9GV4CjlrU7X756OMhx34+Y9/Xg88ImHjQWYya2YjM0DfXxWzScfCikagUx87ntCd+jmTUC0OUaeaeVBpIegWCimv3uMKZR9snvKsamH3HawmjRo7kobLmL2ZC11IDEok8aFCJgMezOaTFVsZ/feQUmW0edYQaVlczQTmMYqDEL2A/WRqpUIkwDg2F7EqXPbIk6A6aNeK2eXgVcE+yBV6HcDnZ8qSdM/OHMxnkCny7T9RfbHkWPe9jUG2Mspx0/PakpXPxP9y32exCTGO/QOf2QX2hfrxzXsgpvRSxFkfYth2SS/pj0zaNKkc/wmznfaouHgcbTKhn4gEYga7GgazIrb7AOMPLx0M/EJe6HnMKZWdgZuRcevzzQm3EhQtNVs3mFLQ5da7tLXoKZUq4Ogw2qZX4YMneJl0lUkceF1X79HBoOMPZCO1qhxUn8IUGT4vwPkVRWc3S8MV2prAI08Sc6sEV90X+3uU/+rgSG4rydeOEbXOZMvXkUwMcpl2ET+p7R5qChE2YvYvem4FANyRckrIo7hXheN9Fwta6shfc/WlMeDEamIt+Wz6EomebXYimOuRz/ESCyp/vpWpvvX2FVrX9DHlUEuV0OCWlNV4DdxQaBl2USZuYMSFK/5uxxzboRBWoKybyTNxdYWTOVyfQZ2sYlhDzOBAGUiFyvZgqEodf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199015)(2906002)(5660300002)(44832011)(64756008)(66446008)(41300700001)(6916009)(66476007)(316002)(478600001)(71200400001)(66946007)(8936002)(76116006)(36756003)(66556008)(8676002)(6486002)(26005)(6512007)(6506007)(83380400001)(38070700005)(86362001)(186003)(38100700002)(2616005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEVwUkVWOWhNSDJ1ajJlUERGNnRxdUdwUXViWm1TVm96bVZWK1lUa3RYSi9a?=
 =?utf-8?B?Vk1KTkxmWTBZUkNTWUdSZmRxaStjSUk0OVk3YWdvRGpuWGhRWFhxYmhYdzVu?=
 =?utf-8?B?TmtkM3YxSUl1bDlZSEUreDVKcTZFMEFiZUMya0F6THJCMm8zZUUvZTZKMVJ6?=
 =?utf-8?B?NTVWZTFPOWwyNDNMaGxiUkQ1M2trM1pRakZrTnpZSTBVQ2piaW1DYUpkQ3NB?=
 =?utf-8?B?OE5XZ2Vwai9iclB1S2w3MmFNOHY3d0ZXdGJvSEJob3YrUnc4T1VyZXBjM3k5?=
 =?utf-8?B?VjhyOWhtUlZ6ZlFid2h1RzM1WWpWWFVzbWhMR1c4SnRrOXVPRkpTVFZzR1I0?=
 =?utf-8?B?VU13bnBhbzJpSWlhYkE0anhoeUhJczN6QklLZmQ0TGYxUHZ1Vm1ZclExZGcw?=
 =?utf-8?B?c2xzajBhMHArcW9iUGZMV01sYUUyQWVZU0N3VkdsOS9sYzhJUFhxY2NQb1NR?=
 =?utf-8?B?OGJsVWVUc3FxNGFodW41T3pqL3MxYlFORk1GSjZtaTRZVkpaMGNSdERFYmlF?=
 =?utf-8?B?QWVIcEs1L2ZxQ01QSUpFZTNGQWxHMGRaNEhVYmpicDF6MjEyWjNVTEsxYmhJ?=
 =?utf-8?B?Wk4zN3piMFdxZXppYXp0Y3Fwbm5oVHNrRDFxOWE1UTlpY0Z0WnFQaEJOekN1?=
 =?utf-8?B?eHlUa1gxakJsbDRwcjNGckozTnVQRVlWMUp4T053dnFkcURnYlNhM2paNkhj?=
 =?utf-8?B?TmhqRDZ4YjJyTmEvZlpzSHYzMHoycm45aEp2ckF3ODUxSnhEWm1BOHlPMHNy?=
 =?utf-8?B?K2VBT2pEMko3cm5OZ3grdkJRVUhaMUlHRGZ6cDlyTWlOZWRsd2FzRHFoVmMv?=
 =?utf-8?B?U0laUTAvaG9yelc0S1RHaFFWVzUvTFFHZkZCcWl5enZCc25tK3dFSVltSTJ3?=
 =?utf-8?B?Q3l6WGQ2dnA1TnUxN2JiYlU2RkdFeCtpcS90V2pHbndhQUtrcXAxS29jSnpK?=
 =?utf-8?B?TW4vbDdTNGVzT3NJMG9XVFVsTU5tN25zcVNaUC9PcWl2TVZxcFFXbGNLcW1j?=
 =?utf-8?B?TzkxWWZ1U0lIdU5lV0tTcFZtV3dHZVdCSENaSkkyZ0dWMHg2c1puRCtvRjNR?=
 =?utf-8?B?SllBY2VIUzdxVkRIdGFnendZTkNMYmVIaEhmYmRnNG5vL2NyZFlNVlJmR0tX?=
 =?utf-8?B?Z05GdUwzVFhYOWFTU3RhNFdjZ3IwWkg1S01DODlaTS8yVi9MaTdoMklFd0ty?=
 =?utf-8?B?SWE2OFcwcVVDeVlQdzJUakhSYXVyTC9vSHJLd2lyMnJvZkdJUll5d05CZURG?=
 =?utf-8?B?MkpYSnhvdEI3azJTYlUxbGM3akxwN2tKRHA1UFZZdFoyUEovdXc5TVNBS1lR?=
 =?utf-8?B?dVp4TWczSVYxVm1lUURHK0RzMmdjeWp3YlhybmQwRzB0WWlmYy9ScFNaTlda?=
 =?utf-8?B?cmNFbUxiRjJyOXF1dUJvb3UyOE9ZK1VheHpFSU5KQnU1Vms0QXlOMlFFT3FW?=
 =?utf-8?B?MjVnN3hlSFl4d3lTVHJkcmU0aC9BTHZhdWN1aTlkUnhpSXkwOHd2aGdPOU5x?=
 =?utf-8?B?SHU5V1BLRHB5bFBWaVY0TlFNb2Z2cUw3RzV0TE1NektvR1RmZVpFVDZZTkph?=
 =?utf-8?B?Nkt0VW80NW9ELzFBd3U0ejIxMmRCdlBCMEgrVXdaRmZwU2JlaGpFaDNkY0th?=
 =?utf-8?B?Q2FIMGJROEgyY2Ixd1pLOG1ZN0NURFRxVmczNDJjbUgxYmlZOVl6blVlLzZh?=
 =?utf-8?B?MFliLzRSOWl1elhwSWVUYXV3UmprZWtQOGk5ZnVWYS9kVkhjRkpHNnZ1NXdw?=
 =?utf-8?B?YTE4ZVE1ZjBSL0JkM0NuWk9IQi9TWmRXTUFEaUduK0N4L3NjbEcvWEFGWFRx?=
 =?utf-8?B?VExMcUp4UWZWQkpGeGtob3NQdTV5b1YzSk9rS2N4NGo5aEQ2YW9iMjBydU9z?=
 =?utf-8?B?dW9HZkVZNHNHNmpJU3dyUU55T1AwV0lZdXhYU3NJRnArY2c4NFBMYUF6SlBk?=
 =?utf-8?B?aVdwVkhWamhZZi9XY2ZMbm51MGZKQzF1OEpxaXptRXBtUGdkS0RTV0tRN3RK?=
 =?utf-8?B?VzhHd3pxcHYrcE40aThLdmk3dXdMV2JXeHllMWJKM3pRajZSU2pVTVBiQ05M?=
 =?utf-8?B?bjF3RFBkYTVDYW9CNlQ0NGYvRXdONWZLbEZSVGszdVVpWFJCODkrRngzRW9D?=
 =?utf-8?B?R3VyZmZRMEV6YzZNTHNpVG5IenMydFhqeE9aNkl4Ty9uM3dkVGpqY1hURGp0?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F46AF8C45482BB4DA7991CEF24488A72@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a48b06-f48e-4caa-f017-08da9cbb524f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 16:55:57.9978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bPjTxN6X+hx3l5NJEAJcO69cs5Jvlwl82x0KuHNoKH++GFdpPXcgFJ+6E/7JlJYHo9IogO9UZDo0fICBDJ6RdXdoKFhe5E0tG6YBhT7WTUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_12,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220112
X-Proofpoint-ORIG-GUID: BcHPDcBYgJM0vrAQw69h_UWLBvRAfZ7y
X-Proofpoint-GUID: BcHPDcBYgJM0vrAQw69h_UWLBvRAfZ7y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

U29tZSBhZGRpdGlvbmFsIGNvbW1lbnRzIG9uIHRoaXMgbmV3IG9uZS4gIEkgdGhpbmsgbWF5YmUg
dGhpcyBzaG91bGQKaGF2ZSBiZWVuIGFuIHJmYyBzaW5jZSB4ZnNfYXR0cl9saXN0IGRvZXNudCBo
YXZlIGFueSBleGlzdGluZwpmaWx0cmF0aW9uIGxvZ2ljLiAgU28gd2l0aCBvdXQgYXNzdW1pbmcg
d2hhdCBiZWhhdmlvciBwZW9wbGUgd291bGQKcHJlZmVyIGl0IHRvIGhhdmUsIEkndmUgYXBwbGll
ZCB0aGUgbWluaW1hbCBhbW91bnQgb2YgY2hhbmdlIHRoYXQKc29sdmVzIHRoZSBwcm9ibGVtIGZv
ciBub3cuICBTdWdnZXN0aW9ucyB3ZWxjb21lIHRob3VnaCwgSSBhc3N1bWVkCnByb2JhYmx5IHBl
b3BsZSB3aWxsIHdhbnQgdG8gZGlzY3VzcyBvdGhlciBzb2x1dGlvbnMgZHVyaW5nIHRoZSByZXZp
ZXcuClRoYW5rcyEKCkFsbGlzb24KCk9uIFdlZCwgMjAyMi0wOS0yMSBhdCAyMjo0NCAtMDcwMCwg
YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbSB3cm90ZToKPiBGcm9tOiBBbGxpc29uIEhlbmRl
cnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4KPiAKPiBQYXJlbnQgcG9pbnRlcnMg
cmV0dXJuZWQgdG8gdGhlIGdldF9mYXR0ciB0b29sIGNhdXNlIGVycm9ycyBzaW5jZQo+IHRoZSB0
b29sIGNhbm5vdCBwYXJzZSBwYXJlbnQgcG9pbnRlcnMuwqAgRml4IHRoaXMgYnkgZmlsdGVyaW5n
IHBhcmVudAo+IHBhcmVudCBwb2ludGVycyBmcm9tIHhmc19hdHRyX2xpc3QuCj4gCj4gU2lnbmVk
LW9mZi1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+
Cj4gLS0tCj4gwqBmcy94ZnMvbGlieGZzL3hmc19kYV9mb3JtYXQuaCB8wqAgMyArKysKPiDCoGZz
L3hmcy94ZnNfYXR0cl9saXN0LmPCoMKgwqDCoMKgwqDCoCB8IDQ3ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLQo+IC0tCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDM5IGluc2VydGlvbnMo
KyksIDExIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19k
YV9mb3JtYXQuaAo+IGIvZnMveGZzL2xpYnhmcy94ZnNfZGFfZm9ybWF0LmgKPiBpbmRleCBiMDJi
NjdmMTk5OWUuLmU5YzMyM2ZhYjZmMyAxMDA2NDQKPiAtLS0gYS9mcy94ZnMvbGlieGZzL3hmc19k
YV9mb3JtYXQuaAo+ICsrKyBiL2ZzL3hmcy9saWJ4ZnMveGZzX2RhX2Zvcm1hdC5oCj4gQEAgLTY5
Nyw2ICs2OTcsOSBAQCBzdHJ1Y3QgeGZzX2F0dHIzX2xlYWZibG9jayB7Cj4gwqAjZGVmaW5lIFhG
U19BVFRSX0lOQ09NUExFVEXCoMKgwqDCoCgxdSA8PCBYRlNfQVRUUl9JTkNPTVBMRVRFX0JJVCkK
PiDCoCNkZWZpbmUgWEZTX0FUVFJfTlNQX09ORElTS19NQVNLIFwKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAoWEZTX0FUVFJfUk9PVCB8IFhGU19BVFRS
X1NFQ1VSRSB8Cj4gWEZTX0FUVFJfUEFSRU5UKQo+ICsjZGVmaW5lIFhGU19BVFRSX0FMTCBcCj4g
K8KgwqDCoMKgwqDCoMKgKFhGU19BVFRSX0xPQ0FMX0JJVCB8IFhGU19BVFRSX1JPT1QgfCBYRlNf
QVRUUl9TRUNVUkUgfCBcCj4gK8KgwqDCoMKgwqDCoMKgIFhGU19BVFRSX1BBUkVOVCB8IFhGU19B
VFRSX0lOQ09NUExFVEVfQklUKQo+IMKgCj4gwqAvKgo+IMKgICogQWxpZ25tZW50IGZvciBuYW1l
bGlzdCBhbmQgdmFsdWVsaXN0IGVudHJpZXMgKHNpbmNlIHRoZXkgYXJlCj4gbWl4ZWQKPiBkaWZm
IC0tZ2l0IGEvZnMveGZzL3hmc19hdHRyX2xpc3QuYyBiL2ZzL3hmcy94ZnNfYXR0cl9saXN0LmMK
PiBpbmRleCBhNTFmN2YxM2EzNTIuLjEzZGU1OTdjNDk5NiAxMDA2NDQKPiAtLS0gYS9mcy94ZnMv
eGZzX2F0dHJfbGlzdC5jCj4gKysrIGIvZnMveGZzL3hmc19hdHRyX2xpc3QuYwo+IEBAIC0zOSw2
ICszOSwyMyBAQCB4ZnNfYXR0cl9zaG9ydGZvcm1fY29tcGFyZShjb25zdCB2b2lkICphLCBjb25z
dAo+IHZvaWQgKmIpCj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoH0KPiDCoAo+ICsvKgo+ICsgKiBS
ZXR1cm5zIHRydWUgb3IgZmFsc2UgaWYgdGhlIHBhcmVudCBhdHRyaWJ1dGUgc2hvdWxkIGJlIGxp
c3RlZAo+ICsgKi8KPiArc3RhdGljIGJvb2wKPiAreGZzX2F0dHJfZmlsdGVyX3BhcmVudCgKPiAr
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2F0dHJfbGlzdF9jb250ZXh0wqDCoMKgwqAqY29udGV4
dCwKPiArwqDCoMKgwqDCoMKgwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZmxhZ3MpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBpZiAo
IShmbGFncyAmIFhGU19BVFRSX1BBUkVOVCkpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiB0cnVlOwo+ICsKPiArwqDCoMKgwqDCoMKgwqBpZiAoY29udGV4dC0+YXR0cl9m
aWx0ZXIgJiBYRlNfQVRUUl9QQVJFTlQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJldHVybiB0cnVlOwo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gZmFsc2U7Cj4gK30KPiAr
Cj4gwqAjZGVmaW5lIFhGU19JU1JFU0VUX0NVUlNPUihjdXJzb3IpIFwKPiDCoMKgwqDCoMKgwqDC
oMKgKCEoKGN1cnNvciktPmluaXR0ZWQpICYmICEoKGN1cnNvciktPmhhc2h2YWwpICYmIFwKPiDC
oMKgwqDCoMKgwqDCoMKgICEoKGN1cnNvciktPmJsa25vKSAmJiAhKChjdXJzb3IpLT5vZmZzZXQp
KQo+IEBAIC05MCwxMSArMTA3LDEyIEBAIHhmc19hdHRyX3Nob3J0Zm9ybV9saXN0KAo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgc2ZlLQo+ID5uYW1lbGVuLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2ZlLQo+ID5mbGFncykpKQo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gLUVGU0NPUlJVUFRFRDsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGNvbnRleHQtPnB1dF9saXN0ZW50KGNvbnRleHQsCj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNmZS0+ZmxhZ3MsCj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNmZS0+bmFtZXZhbCwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKGludClzZmUtPm5hbWVsZW4sCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIChp
bnQpc2ZlLT52YWx1ZWxlbik7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBpZiAoeGZzX2F0dHJfZmlsdGVyX3BhcmVudChjb250ZXh0LCBzZmUtCj4gPmZs
YWdzKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBjb250ZXh0LT5wdXRfbGlzdGVudChjb250ZXh0LAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2ZlLT5mbGFncywKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNmZS0+bmFtZXZhbCwKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIChpbnQpc2ZlLQo+
ID5uYW1lbGVuLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKGludClzZmUtCj4gPnZhbHVlbGVuKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAqIEVpdGhlciBzZWFyY2ggY2FsbGJhY2sgZmluaXNoZWQgZWFybHkg
b3IKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBk
aWRuJ3QgZml0IGl0IGFsbCBpbiB0aGUgYnVmZmVyIGFmdGVyIGFsbC4KPiBAQCAtMTg1LDExICsy
MDMsMTIgQEAgeGZzX2F0dHJfc2hvcnRmb3JtX2xpc3QoCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSAtRUZTQ09SUlVQVEVEOwo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBjb250ZXh0LT5wdXRfbGlzdGVudChjb250ZXh0LAo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNi
cC0+ZmxhZ3MsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2JwLT5uYW1lLAo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNi
cC0+bmFtZWxlbiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzYnAtPnZhbHVlbGVuKTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHhmc19hdHRyX2ZpbHRlcl9wYXJlbnQoY29udGV4dCwg
c2JwLT5mbGFncykpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBjb250ZXh0LT5wdXRfbGlzdGVudChjb250ZXh0LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBzYnAtPmZsYWdzLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBz
YnAtPm5hbWUsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNicC0+bmFtZWxlbiwK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2JwLT52YWx1ZWxlbik7Cj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoY29udGV4dC0+c2Vlbl9lbm91Z2gpCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYnJlYWs7Cj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjdXJzb3ItPm9mZnNldCsrOwo+IEBAIC00NzQs
OCArNDkzLDEwIEBAIHhmc19hdHRyM19sZWFmX2xpc3RfaW50KAo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICF4ZnNf
YXR0cl9uYW1lY2hlY2sobXAsIG5hbWUsCj4gbmFtZWxlbiwKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZW50cnktCj4gPmZsYWdzKSkpCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FRlND
T1JSVVBURUQ7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnRleHQtPnB1dF9s
aXN0ZW50KGNvbnRleHQsIGVudHJ5LT5mbGFncywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaWYgKHhmc19hdHRyX2ZpbHRlcl9wYXJlbnQoY29udGV4dCwgZW50cnktPmZsYWdzKSkK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnRleHQt
PnB1dF9saXN0ZW50KGNvbnRleHQsIGVudHJ5LT5mbGFncywKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgbmFtZSwgbmFtZWxlbiwKPiB2YWx1ZWxlbik7Cj4gKwo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGNvbnRleHQtPnNlZW5fZW5vdWdoKQo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFrOwo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3Vyc29yLT5vZmZzZXQrKzsKPiBAQCAtNTM5LDYg
KzU2MCwxMCBAQCB4ZnNfYXR0cl9saXN0KAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoeGZzX2lzX3No
dXRkb3duKGRwLT5pX21vdW50KSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAtRUlPOwo+IMKgCj4gK8KgwqDCoMKgwqDCoMKgaWYgKGNvbnRleHQtPmF0dHJfZmlsdGVy
ID09IDApCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnRleHQtPmF0dHJfZmls
dGVyID0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFhG
U19BVFRSX0FMTCAmIH5YRlNfQVRUUl9QQVJFTlQ7Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBsb2Nr
X21vZGUgPSB4ZnNfaWxvY2tfYXR0cl9tYXBfc2hhcmVkKGRwKTsKPiDCoMKgwqDCoMKgwqDCoMKg
ZXJyb3IgPSB4ZnNfYXR0cl9saXN0X2lsb2NrZWQoY29udGV4dCk7Cj4gwqDCoMKgwqDCoMKgwqDC
oHhmc19pdW5sb2NrKGRwLCBsb2NrX21vZGUpOwoK
