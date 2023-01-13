Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2A4C54EBD
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Jan 2023 00:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbjAMAUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Jan 2023 19:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240368AbjAMAUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2023 19:20:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E19E6DBB8
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2023 16:16:01 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CNuRiv013292
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 00:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KVfttDTAO4GeC/2zAQo0G6tW3x/L5rafg9gbmgIUrhY=;
 b=e4wxl/8JRXkbDMbZk4xTixREuQGdXkayjJkuUKZXYyDPJccs9lXusNcfT+yraWveyurn
 4aKN4qvNEmg14UsdOrsLrLJADBcLsJCIZdnIfXItT3+mstH40NbPRCMrzqhLxpx7epGt
 /2aUe2vQLbln/Wetc/kVrw96oD9g29I3QLwqbUUXBF7dqlV18DM70f5zPh58+9ZmuYi3
 MDvj2kVYArM0MoTIsnZv5q4vfbjFjjTshd/xvFCD+gxoUAm56K9tbwZ/A6f9Xn13Ug/s
 1xBiZ1Z4lYz09eBB6pMKH+QGnRAQuDYWucj+u6JPzd6cdNGNxJBjQtAKstvWHaFOC9Qn 0Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n2s9k0aqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 00:15:40 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30CMn7hG022699
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 00:15:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4g03yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jan 2023 00:15:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4smUo6lgb4N2EGJCFKjOCUu+LF2Opg7twCveOWmMkFJbzlYafrmmhJU2/KXGZ9pC9sBTb2LYaRqGM8ph87bj064gtjrMkq2kNWRH4q5mQvfPh34dd5jnmnCF2PzyKV3Y7xjad1exk7QgQuIve9dbaS8a9KX8WYHIv66VWV0wrH/fLAZXux41tDqejPj8QUGAd95mVEqqL5CSGUjcn0SC6a4fq7YnLiIVEfJV3YuTXh0tXGpqmKBPzjpKRxcLicr/kTpheDAIP15R4il5sWkt/0PhLBuyy+w38kf0cWjmiV8d9U8jS2z/CbLLhKvaoDbVatSLXZ9TqdHrgmaXA0fFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVfttDTAO4GeC/2zAQo0G6tW3x/L5rafg9gbmgIUrhY=;
 b=J+4TFFNEa4SFkmxy0mUksiM9z2DnxPPqEl5o79WY+iRrDcJZlo93HQIbt01z+0lj6YKKbrh53F2F22APz/L+KQxCwAxTs4UA6U2rfSakwznAw4yBdo9be4mMHwKIts2zIEyrg4XA5ofsklOI+xaRU3GAXL7HMz/utSUt4+SPCyvG/+1VMi/4WYerXSGvTwqqgaCW97Zfzp/xS/02kNZY9AWADVAb0gqCJxAKWoama1FuxoPUa1A4/jDoOwiC/q53XPdNeyjM/AMPGA0LDKNPygzQPTcYcgkAuzcIxfHrOkpgXos7Y2zjjQCD5/eSb9/j4TxqRH4LIKOZ6s8P+0n1Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVfttDTAO4GeC/2zAQo0G6tW3x/L5rafg9gbmgIUrhY=;
 b=IS5qv+4Gt95AYxaFimYJqEQkPdO5fWeXYcnFw8O42uHk+HMWTMVE4ssXJv7qPRD7Fdr010y1vdVdvv+ToWlBbLl3Bb4wKyfY6Z+g0ClVNdq0Psw6pn3DzgutEr8zPvE8MkrvMaln3QPbdkh6KazeLp1p3SxZe1pIe6aZkAJv468=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by IA1PR10MB6049.namprd10.prod.outlook.com (2603:10b6:208:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 13 Jan
 2023 00:15:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6002.012; Fri, 13 Jan 2023
 00:15:36 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] xfs_admin: get UUID of mounted filesystem
Thread-Topic: [PATCH v3 2/2] xfs_admin: get UUID of mounted filesystem
Thread-Index: AQHZIJ3o/ksFu1+lgkWqnM5lMS1pQK6bhxSA
Date:   Fri, 13 Jan 2023 00:15:36 +0000
Message-ID: <1189040b67b17df9138fc2cec98347c73b81ad44.camel@oracle.com>
References: <20230105003613.29394-1-catherine.hoang@oracle.com>
         <20230105003613.29394-3-catherine.hoang@oracle.com>
In-Reply-To: <20230105003613.29394-3-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|IA1PR10MB6049:EE_
x-ms-office365-filtering-correlation-id: 3d96f402-d098-4247-aa75-08daf4fb4b9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z0sNHjH8gzi8UBaxqmsRDEa2XXQhLDnDEFKpOh9JiqwT6zcbxNlDd5wQu2NvqCwP9Zxgh+ZDAIYf6pWdXV6kx90hPk7MrIr7kOSJoF0UxpejKVVdRPAA+0fvCI15rCK9TfSiV1OC7W1xHFkWxNhXtSHTcntqzLNZc1snjtZNJwj/JJOnk07Ctu9ZUxOp9ku1OVYAjDFePIcr6jbX9g8o9sAdjpTHB4XKLDFE0W1QI36wtXQRZuAEONSVkzBQWKIQrJzBgC/GJvfGIVZEpSGSIuTlLudbE8H+zdPC7QIenU9YNxIahDNoXIaMDicCYvLYPAegSWWzb9cRNFAyPaKG/Id85jQHHvTnwY0VX1Xu43nLtKryJ+AwxUs0UDiGz49nQeF/xfLWF76PzuzdxWS2Qkk0wD5V7vwqBAlLOVsS8S+07YajB5nP1o0qD5edRCBR5lXom2vQlddTE7S2qywbNVXfnh0dQGL4rlnES9rLl+tciy0zcp/Odml5HVlsdX6NNYWGK8Eaw2cmqgQGrx7FgsKjXaO1GIbGWNUe8/F8h92yo5Q0GxH5UaWFZWjdiOhHZW4V7gdGU+iRtpuVDJDW08VIB+pQvbfupJkX8rzobaNADp35SQc8brfRUS3qyJDLKedyg9mBdXVsvEmGXQACCn5qoNhyAsak7LVnZJZgIGmYnMkXxgLBTgGBxy+LiS4J9hQapYgnkq8sNP1Kg4PCKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199015)(478600001)(6486002)(36756003)(86362001)(83380400001)(186003)(38070700005)(71200400001)(26005)(6506007)(6512007)(122000001)(2616005)(38100700002)(66556008)(76116006)(66446008)(66476007)(8936002)(5660300002)(8676002)(66946007)(64756008)(44832011)(316002)(41300700001)(110136005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXlEM21YVUhHaTVmNVE3VnA0cjk4d05tNFBFei81R0hsUmM0QTI1Q0N1Z2lI?=
 =?utf-8?B?aGFDU1M0dFBvRUFFL1o0K21JRXg1S0JsbU5pRjEwNjFsbXAvbnZWdUhOZFVl?=
 =?utf-8?B?MzdnQXF2SzRVNzErYTNhZVZ0aFFJZm5rMmhaRWFMb2oyaXdoSUVjWC9WVHBX?=
 =?utf-8?B?RDJKNnVTWm8rOEFDam80dHNadHl3cU55ZnptaUltdUV1UmRWVnppNTQyUTB0?=
 =?utf-8?B?QURUNjlGemgrNGhqaTVRazBkdHJZc2REaUpoYnJmVHdkM215UmMrTHAxbjFl?=
 =?utf-8?B?NVhuZkpzL1kwdkphV1dibGRHZHlZWUUyeFNsbzB4eStSQTM1VUc4ZEY3Um0z?=
 =?utf-8?B?c3Baamh1UjU0R1paYXl1U0J0SmhlelJvRjZ2a0RHNGRHSUdEdTJTd0MwaXlS?=
 =?utf-8?B?RWMxM2Y1aTVkZ0w3Qkk2V0I5VGZ1U3VxUkRpdHVsQ0JlZVh1TlFDSitqK1FQ?=
 =?utf-8?B?K2RmcWJ5VFJMNFdCdnNjdCsrWWlrMjBYNE1oWEEwcDVkSVRwN056RmU1TStz?=
 =?utf-8?B?NVVOd213UG9tYU1nZ0tmNDIyYi85MWhWSzgxNUZCOGJGOFNrSmp0SjJydjhj?=
 =?utf-8?B?dTduMlgxcXZPazNjckpKZnRiWEtjZmVVeXVWT0hUcnduUUJwNWJoejNqU3Q3?=
 =?utf-8?B?Wk11dU1ZbDZLR3c4eVZIdmJScEJXK1BSd1NTbGE5ZVJLSVl2clJHQWZ6OXZz?=
 =?utf-8?B?bWZDZ3VuZGtiL1RFamRGSTRNMmh0d0daalFpYWhQQnNVY2lJblVla3kyYUZz?=
 =?utf-8?B?ekk0WE1qeGZlUnlCOG5ndThNeU5VcXIwK2JSbFg4cXdNeHl6TE5waC9rQ2Fr?=
 =?utf-8?B?WTB5WE1ib1k0MXJjSHMzMjJ3VWdWNFZMdVcvZzlVUEU3WEFSMjd4MGpOMW15?=
 =?utf-8?B?Z2dzUWtWN0FaN3Fzb2FPN3I0U29zRXAwdjhGdjhuS1MrZVM5KzJwVXhkZSth?=
 =?utf-8?B?Sm9Nc0FXbk5DWVgreVhqdTF5ZTQxZ1IyN2NHblBrZThENER4U01ISDlNditU?=
 =?utf-8?B?ZU4zSSs4SXcxbmR5ZkxheVkzRU9zMDRZR1N1STNmSUdudDFmSXJoNXJ5STZH?=
 =?utf-8?B?L3VqY0hTN0Z0aWFiTW4vN0sySkJqeEFVS1ptMytOSzVYUm1temYzYTdQVk1o?=
 =?utf-8?B?Y3grWUdZMVM2NEUvNWlPakVVRkFmUGlQd0tVQ1dBeDlzUmNCZ1ZQYTFqMHNS?=
 =?utf-8?B?WWl4Ri9Vblc5Y1p1QjRSNXgrNjdSYit0TVkrQmg5ajdibytPVi94Zk1hMk9o?=
 =?utf-8?B?VEl3ZVFQblBHaUk1QXo5NkoxNEJQVEgwZTZVU3F4d3g5Z0tBUVR6VkF5eWk2?=
 =?utf-8?B?cU10VmEzQlZyeEV2Vlh3Q3Qxenkzd2xaUDZvWGZZSGlMbm5QR2V4TExraWJ0?=
 =?utf-8?B?MU9pZjFoSzdaYVZCdXhYc0tmRW5ZT2lueEhXbGUxZFA4UnE0VXliN1Z6SGx1?=
 =?utf-8?B?TUcwbFA2emlSdWxJcDlNV3Bnc3VLTHhlRjBZRjY0RDBWeUV3VlRac25NMHlT?=
 =?utf-8?B?Y0NCMjI5bndmZ3UvOTdBd2lZdldkWExzQ0tGeE1mTDd3enJlcnBHWXVLMTFo?=
 =?utf-8?B?NVFWUkhQaE5CcFhDWE5hT0hOTHBxaUtFVEpaTWtiTjV4Z1hUSjNWWWRUNzdB?=
 =?utf-8?B?Ryt1b1J5OEJYZ3RrZWJoSUg4b2s1YlkyYWZFa1hka05nRGxDcnhJUU1TQi96?=
 =?utf-8?B?RVN2cGhROVdoUldUdVF1NG41QVlFS2ZSZmtqZG0wOGg0WEk0R1lSTmJWaWhP?=
 =?utf-8?B?QjNmK01QZnRYNEhNWmR0enBZUGtmOGpxV1I0ejU5dUZpeENDSnk2aXljc2hB?=
 =?utf-8?B?SHI4WG1YUE1pbHJOaG9jamcxamJXSHJUNFlPT1lnNncyR0UvclNOT2xqUUpC?=
 =?utf-8?B?SUt1QkxwRmVmci9LRmFwRTRFQVUvZWlSQ1NLanQwQVVybWRyRTlCalVESHl4?=
 =?utf-8?B?T3pENjFkRXd1WWRYaUx2UWVvbmprNmliRk5VWkdHTlRnNHl1ZjRhN1VMRWQ1?=
 =?utf-8?B?QzhPTVVVUkl1V0Z2bDYwN3R4bXpCNTlPMDQ5UXJ6aDB6QzZIWXVBN2hqMWtV?=
 =?utf-8?B?d05jVU41R01SekVLZ1htODdWdDRqcUtETlNVTy9NR1pCRVJoUkNrMmR5dVNk?=
 =?utf-8?B?a2R5Qm5MdkVGSVFpdEN5bCttSDV1L3gxY2VhR25RY29CbE94N2d6enlDbFV6?=
 =?utf-8?Q?27WtcGahdpxXb4u/QCJf0Bc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43D1F98BB1D08E4899743F608311CCEA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: m8Fn1xvsMlL/uD0lHwzD59R+2X02SQtFpjGFhJ1xOSKoZHn0ImyynTKyPTtiQIaDX4BnVd/k/N5M3STx7i9L1csBCDLuC4bZoYbyP7Rx+vF2LhbTmuxNZ93XeXCe9sffzK9MItGDffBCokNa6I4MPO3cZ74xkmPdOIwx5IMXcK76zoUahMvVW9lfBL/sopQ+3bn/sU22/hQb6u3+51Qex0EB1NiDOAKTF5TZ9FOBX2er8aY/Q5bprLCEzamWGIg9vkLcIBCbmUWg4oQYEGWutUfKbfOFtcwLfbmbrZztlOraufeEMl9AaaK9l2XRfV2ugDReM5Cw2bvBYR4rJTDqjEmYxg0cU7/Tf7tTakztWFXJkakyPv1wdcMMpWPIsNOr2vPEBuQ9TXfRDZkEmGEVoGYM81NThpjqRuI/pde6ofSC+a1yO0kdY+tsY7b2c27T+d/4ty28SG+xC7sBP0AVbJMNszoknsu0zysSU6DcVPUbSZ6K6VX1ivfU2U5/8lsQsgQ4MYZ5qtMSI9++yx4dQ4l6L5UfFhBRJ56qEwoH+AChVvqcxr9OEvJ5Q8cgRxpMrZJZyap3J5Hv7p2rdhIhslMj7A7bjz4exG1M9eWo+o3yY5aWswsSgTfaaTgoe3yiNbJ0etA0RykkOCRW00aP7tWFNRMHw1W7Q0u4NJ6tz5qVDLMhHHlxkthzmV2NCG9uVWMmFNOzjtBmUVcK4MO8JjmPtkQfLbSadM3AA/CcEJdinviIHkApQHJmQjD3MIrS4eYd5pEJ8m90aCb2wvoOGQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d96f402-d098-4247-aa75-08daf4fb4b9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2023 00:15:36.8470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JeyecOGwJcY0ud+ny01eOtzZfFlBvy1S6jNoHh7aRtdIzEZTW5podUAf95b7hbgvLebVxf57b6Rn+oJmOGxX1cF+hYvpO2ttbeXIxEjiqw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_13,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130000
X-Proofpoint-GUID: _R-b7U2KwL_tsOtw0q0x4j9Akis6nO_7
X-Proofpoint-ORIG-GUID: _R-b7U2KwL_tsOtw0q0x4j9Akis6nO_7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIzLTAxLTA0IGF0IDE2OjM2IC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gQWRhcHQgdGhpcyB0b29sIHRvIGNhbGwgeGZzX2lvIHRvIHJldHJpZXZlIHRoZSBVVUlEIG9m
IGEgbW91bnRlZAo+IGZpbGVzeXN0ZW0uCj4gVGhpcyBpcyBhIHByZWN1cnNvciB0byBlbmFibGlu
ZyB4ZnNfYWRtaW4gdG8gc2V0IHRoZSBVVUlEIG9mIGEKPiBtb3VudGVkCj4gZmlsZXN5c3RlbS4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9hbmcgPGNhdGhlcmluZS5ob2FuZ0BvcmFj
bGUuY29tPgpTb3JyeSBmb3IgdGhlIGRlbGF5IGhlcmUsIHRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0
byBtZSwgeW91IGNhbiBhZGQgbXkKcmV2aWV3OgpSZXZpZXdlZC1ieTogQWxsaXNvbiBIZW5kZXJz
b24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+Cgo+IC0tLQo+IMKgZGIveGZzX2FkbWlu
LnNoIHwgNjEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0K
PiAtLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygt
KQo+IAo+IGRpZmYgLS1naXQgYS9kYi94ZnNfYWRtaW4uc2ggYi9kYi94ZnNfYWRtaW4uc2gKPiBp
bmRleCA0MDk5NzViMi4uYjczZmIzYWQgMTAwNzU1Cj4gLS0tIGEvZGIveGZzX2FkbWluLnNoCj4g
KysrIGIvZGIveGZzX2FkbWluLnNoCj4gQEAgLTUsOCArNSwxMSBAQAo+IMKgIwo+IMKgCj4gwqBz
dGF0dXM9MAo+ICtyZXF1aXJlX29mZmxpbmU9IiIKPiArcmVxdWlyZV9vbmxpbmU9IiIKPiDCoERC
X09QVFM9IiIKPiDCoFJFUEFJUl9PUFRTPSIiCj4gK0lPX09QVFM9IiIKPiDCoFJFUEFJUl9ERVZf
T1BUUz0iIgo+IMKgTE9HX09QVFM9IiIKPiDCoFVTQUdFPSJVc2FnZTogeGZzX2FkbWluIFstZWZq
bHB1Vl0gWy1jIDB8MV0gWy1MIGxhYmVsXSBbLU8KPiB2NV9mZWF0dXJlXSBbLXIgcnRkZXZdIFst
VSB1dWlkXSBkZXZpY2UgW2xvZ2Rldl0iCj4gQEAgLTE0LDE3ICsxNywzNyBAQCBVU0FHRT0iVXNh
Z2U6IHhmc19hZG1pbiBbLWVmamxwdVZdIFstYyAwfDFdIFstTAo+IGxhYmVsXSBbLU8gdjVfZmVh
dHVyZV0gWy1yIHJ0ZGV2Cj4gwqB3aGlsZSBnZXRvcHRzICJjOmVmamxMOk86cHI6dVU6ViIgYwo+
IMKgZG8KPiDCoMKgwqDCoMKgwqDCoMKgY2FzZSAkYyBpbgo+IC3CoMKgwqDCoMKgwqDCoGMpwqDC
oMKgwqDCoMKgUkVQQUlSX09QVFM9JFJFUEFJUl9PUFRTIiAtYyBsYXp5Y291bnQ9IiRPUFRBUkc7
Owo+IC3CoMKgwqDCoMKgwqDCoGUpwqDCoMKgwqDCoMKgREJfT1BUUz0kREJfT1BUUyIgLWMgJ3Zl
cnNpb24gZXh0ZmxnJyI7Owo+IC3CoMKgwqDCoMKgwqDCoGYpwqDCoMKgwqDCoMKgREJfT1BUUz0k
REJfT1BUUyIgLWYiOzsKPiAtwqDCoMKgwqDCoMKgwqBqKcKgwqDCoMKgwqDCoERCX09QVFM9JERC
X09QVFMiIC1jICd2ZXJzaW9uIGxvZzInIjs7Cj4gK8KgwqDCoMKgwqDCoMKgYynCoMKgwqDCoMKg
wqBSRVBBSVJfT1BUUz0kUkVQQUlSX09QVFMiIC1jIGxhenljb3VudD0iJE9QVEFSRwo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXF1aXJlX29mZmxpbmU9MQo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqA7Owo+ICvCoMKgwqDCoMKgwqDCoGUpwqDCoMKgwqDCoMKgREJf
T1BUUz0kREJfT1BUUyIgLWMgJ3ZlcnNpb24gZXh0ZmxnJyIKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmVxdWlyZV9vZmZsaW5lPTEKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgOzsKPiArwqDCoMKgwqDCoMKgwqBmKcKgwqDCoMKgwqDCoERCX09QVFM9JERCX09QVFMi
IC1mIgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXF1aXJlX29mZmxpbmU9MQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA7Owo+ICvCoMKgwqDCoMKgwqDCoGopwqDC
oMKgwqDCoMKgREJfT1BUUz0kREJfT1BUUyIgLWMgJ3ZlcnNpb24gbG9nMiciCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlcXVpcmVfb2ZmbGluZT0xCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoDs7Cj4gwqDCoMKgwqDCoMKgwqDCoGwpwqDCoMKgwqDCoMKgREJfT1BU
Uz0kREJfT1BUUyIgLXIgLWMgbGFiZWwiOzsKPiAtwqDCoMKgwqDCoMKgwqBMKcKgwqDCoMKgwqDC
oERCX09QVFM9JERCX09QVFMiIC1jICdsYWJlbCAiJE9QVEFSRyInIjs7Cj4gLcKgwqDCoMKgwqDC
oMKgTynCoMKgwqDCoMKgwqBSRVBBSVJfT1BUUz0kUkVQQUlSX09QVFMiIC1jICRPUFRBUkciOzsK
PiAtwqDCoMKgwqDCoMKgwqBwKcKgwqDCoMKgwqDCoERCX09QVFM9JERCX09QVFMiIC1jICd2ZXJz
aW9uIHByb2ppZDMyYml0JyI7Owo+IC3CoMKgwqDCoMKgwqDCoHIpwqDCoMKgwqDCoMKgUkVQQUlS
X0RFVl9PUFRTPSIgLXIgJyRPUFRBUkcnIjs7Cj4gLcKgwqDCoMKgwqDCoMKgdSnCoMKgwqDCoMKg
wqBEQl9PUFRTPSREQl9PUFRTIiAtciAtYyB1dWlkIjs7Cj4gLcKgwqDCoMKgwqDCoMKgVSnCoMKg
wqDCoMKgwqBEQl9PUFRTPSREQl9PUFRTIiAtYyAndXVpZCAiJE9QVEFSRyInIjs7Cj4gK8KgwqDC
oMKgwqDCoMKgTCnCoMKgwqDCoMKgwqBEQl9PUFRTPSREQl9PUFRTIiAtYyAnbGFiZWwgIiRPUFRB
UkciJyIKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVxdWlyZV9vZmZsaW5lPTEK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgOzsKPiArwqDCoMKgwqDCoMKgwqBPKcKg
wqDCoMKgwqDCoFJFUEFJUl9PUFRTPSRSRVBBSVJfT1BUUyIgLWMgJE9QVEFSRyIKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVxdWlyZV9vZmZsaW5lPTEKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgOzsKPiArwqDCoMKgwqDCoMKgwqBwKcKgwqDCoMKgwqDCoERCX09Q
VFM9JERCX09QVFMiIC1jICd2ZXJzaW9uIHByb2ppZDMyYml0JyIKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmVxdWlyZV9vZmZsaW5lPTEKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgOzsKPiArwqDCoMKgwqDCoMKgwqByKcKgwqDCoMKgwqDCoFJFUEFJUl9ERVZfT1BU
Uz0iIC1yICckT1BUQVJHJyIKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVxdWly
ZV9vZmZsaW5lPTEKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgOzsKPiArwqDCoMKg
wqDCoMKgwqB1KcKgwqDCoMKgwqDCoERCX09QVFM9JERCX09QVFMiIC1yIC1jIHV1aWQiCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoElPX09QVFM9JElPX09QVFMiIC1yIC1jIGZzdXVp
ZCIKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgOzsKPiArwqDCoMKgwqDCoMKgwqBV
KcKgwqDCoMKgwqDCoERCX09QVFM9JERCX09QVFMiIC1jICd1dWlkICIkT1BUQVJHIiciCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlcXVpcmVfb2ZmbGluZT0xCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoDs7Cj4gwqDCoMKgwqDCoMKgwqDCoFYpwqDCoMKgwqDCoMKg
eGZzX2RiIC1wIHhmc19hZG1pbiAtVgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
c3RhdHVzPSQ/Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBleGl0ICRzdGF0dXMK
PiBAQCAtMzgsNiArNjEsMjQgQEAgc2V0IC0tIGV4dHJhICRACj4gwqBzaGlmdCAkT1BUSU5ECj4g
wqBjYXNlICQjIGluCj4gwqDCoMKgwqDCoMKgwqDCoDF8MikKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaWYgbW50cHQ9IiQoZmluZG1udCAtdCB4ZnMgLWYgLW4gLW8gVEFSR0VUICIk
MSIKPiAyPi9kZXYvbnVsbCkiOyB0aGVuCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAjIGZpbGVzeXN0ZW0gaXMgbW91bnRlZAo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgWyAtbiAiJHJlcXVpcmVfb2ZmbGlu
ZSIgXTsgdGhlbgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGVjaG8gIiQxOiBmaWxlc3lzdGVtIGlzIG1vdW50ZWQuIgo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGV4aXQgMgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZmkKPiArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpZiBbIC1uICIkSU9fT1BUUyIgXTsgdGhlbgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGV4ZWMgeGZzX2lvIC1wIHhmc19h
ZG1pbiAkSU9fT1BUUwo+ICIkbW50cHQiCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBmaQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmaQo+
ICsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIyBmaWxlc3lzdGVtIGlzIG5vdCBt
b3VudGVkCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIFsgLW4gIiRyZXF1aXJl
X29ubGluZSIgXTsgdGhlbgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgZWNobyAiJDE6IGZpbGVzeXN0ZW0gaXMgbm90IG1vdW50ZWQiCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBleGl0IDIKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgZmkKPiArCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAjIFBpY2sgdXAgdGhlIGxvZyBkZXZpY2UsIGlmIHByZXNlbnQKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGlmIFsgLW4gIiQyIiBdOyB0aGVuCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgTE9HX09QVFM9IiAtbCAnJDInIgoK
