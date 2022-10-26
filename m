Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6312BC38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 07:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiJZHkv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiJZHkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 03:40:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A88D39111
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 00:40:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q5jTl3002596;
        Wed, 26 Oct 2022 07:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7WbE+1i6fUFGCTbQUEnMQwifqdS8+sJJRWA6zKICuak=;
 b=YFh3FCbqBgixfGvso+WcpVBHSetpT/jpY+SByZ/oiC3kx/f05vkdHa0Op9iRzkjrKiPC
 y7TVUwKveKu9YKI56O/UPm/3tHXWkJxEXBASVzPiIKdFaQemt3kJ30S7o4LhecSv7QQx
 7HLg7YYHBn9DWKgx4NVyb47gcyKqK1Qlgrl0QwZzFWEhd9Gzjb6Rdrl69e0pVASTH/bq
 lsMg3+eUNLF6EYGFssUbxUtt1lgatqyFCIUDrxOhZzYKlNI8YV0Krzpx0RNkeuNy/9Oj
 o0PHIW6nO62ywj3toRl8tkXOAG1AsnJaN2VRoKoxGA7Kb02lLV8N07XEEQ95wD72Q0U8 mA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbnfq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q70xwf010943;
        Wed, 26 Oct 2022 07:40:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5f7qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 07:40:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzMbyvNVF5bjPGuoRpHH9bml1FgdV0yBV36fDtnmwy38zGtn5C0x5FHURLsyZp0r0FILtEWNKpIY1KurkOlABhQo0gC9weTDl1nR2H/VD4tD5yRJBBW8pJUvvkHJA8YIhRvAAZFRx4SFzMwy4f4VJOYy+wpSTMhFbiH8/uLnWDpirZAQGGbI/RFSJ+AY2Y3st0RTL0D1v/+Mo8IG2yQX2iImFBrauDBreyp8vF8tYPMlnkCb4PayWfmhPkkmHOnveTmQLZMdrbsbKbsFEOQ+SuwnQibjpBpSj7LM0ceJQBFIQTc8Z0qwZqwOjP1uDGXo9S5fjq2wwg5ZP+F97EEWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WbE+1i6fUFGCTbQUEnMQwifqdS8+sJJRWA6zKICuak=;
 b=Ykw1pgVYKyTxBmevGrTv0bPqdwfq+4II55vG+Ef7yGOSmkNARlmiN/N78UtjvUNbyeVPVPmwZo+a3jtrXwr8gmLLD8GlnQfR7nILmgByPxMOGQAXxaJ2gu/v+1oFpJNwoOlLaM5mTJ7o6iCiojzSWr4bg9/hKK6qyE/U1d//KsRbg+8IQD9Y+1yf08En4TuRxSfsl5zSR4FSyJFCVVpMJw/N0MiQ+HrckRADvQoHDHhOo4w0v49mDNCNMLREouQW+39pIQRniX/xxAIxp3nHmBVu4fw2rPGXu0z37GVIMNW63lg5XpCx+9BU0qvvfEi8npHpv56VVoizHIvOs4OYHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WbE+1i6fUFGCTbQUEnMQwifqdS8+sJJRWA6zKICuak=;
 b=uBf4Yzumcl/UpSvJWRSiPCqIzQy6mWS5RZLwYjRB1pLIbCnsiJLfiQ8BeWeIafkCpn1JQqGwjob/TwH0hURcIDshMtRdVeGoYvit5T2Dhi0QY3v441twhuGm4tVt9O7lVjP/6othQ6UcZLwiBcvqizBB+yLyovoY99lRgDGn+7c=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB5991.namprd10.prod.outlook.com (2603:10b6:8:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 26 Oct
 2022 07:40:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 07:40:15 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 06/27] xfs: Expose init_xattrs in xfs_create_tmpfile
Thread-Topic: [PATCH v4 06/27] xfs: Expose init_xattrs in xfs_create_tmpfile
Thread-Index: AQHY5Zyf8upMPx9cAE+J1ubcziOOsa4fgJeAgAAm5oCAAKmoAA==
Date:   Wed, 26 Oct 2022 07:40:15 +0000
Message-ID: <884e29a17055a295bc0f9bea569c86f4b68b1a0e.camel@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
         <20221021222936.934426-7-allison.henderson@oracle.com>
         <Y1g1a+D6uMz6wSjs@magnolia> <Y1hWDYgOzW5W6EHu@magnolia>
In-Reply-To: <Y1hWDYgOzW5W6EHu@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DM4PR10MB5991:EE_
x-ms-office365-filtering-correlation-id: dfc392fe-1757-4fb2-f327-08dab7255282
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dLn/eWFbkywS0VhNx90Zwk1lafvZioO93Rwhmuh2wcMXpJ3vxrNseJBaZb8THfl+P7T0+dKV3x7CaPUXy3GaGgvpG2OpnUL8V71Qzprr+TOnob0Tk478Xx7sB0ElAoVh3Jk33RxwEQXM3TFsKxuXBVWGAs1Vi0L171lgcAufKChcqXM32N3ix02mxH3v5PQm06oXTiqfESm/FCHzzzQDLiLWt9HCeV+dQfxlgotFoerql7cF24Qylb92SOLRzQvGtISTLS3c/tBK/zTMVeMuKBOVVz/H/U4GLHjqraXV+3rfil2R9NEIRzTm5cqQZce/t3h7WwCvbscp/oaxLMrXjfYjekYi6uBiDDOJT7A2HuYFX2JKCpemQMpBd/BxNbCOMQZnk2iAv+RBp7+EHzEEWP3tvBerBU7XmImD1t/hAw8QdL0r2rFZZ2wjyO75MF6Ik2/mpysXe6SBkF2a8/8wXd83sJnHI0/9C09YBldyCpn5jfYkzDP5CwZRUuydMCaPfMz26v7jJnS1EQK0oYjkJTb9JqneqKgiIgBCiEglAq92ZSVXv0gmIFweNWqn4NK61+Yyd2s0yq/cYUEGJDbFD7X/ACJm+uuzq2N/B+uLX430RmUdivJtoI32ZKyQFkT6UAnFBUVuUMURiWDqkh6/DquF8uaB/YfkC3l8CVCOjgzK3QXJBEATTkvJjvGjKEXVM3F7lOtjo5lyzs7gyv4tqGUeF6smUZym7uvD7LHtrRV5urdR9rVtgZES1PYzNwpPzuOnkuPI2PJ6ujkNFfUHiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(316002)(66556008)(44832011)(86362001)(66476007)(66446008)(4326008)(6916009)(76116006)(83380400001)(66946007)(2906002)(2616005)(186003)(64756008)(41300700001)(8676002)(8936002)(6512007)(478600001)(26005)(71200400001)(38070700005)(4001150100001)(38100700002)(6506007)(122000001)(36756003)(5660300002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDlIeVNCaXpFeVJmdm9uN0JjQ0pEbENMU25IZ3R5V3JpZ1hPN0t6SWhyTEdz?=
 =?utf-8?B?TG5tME1xTXFLZGJNSC80OVBrVXZEL0hCKy85V1VFUG8vYjY0OURHWTBnM0l6?=
 =?utf-8?B?NFZUU2RyeWJyOEJuck5NdFN3MzlFQllQYTBwUzd5TXZPT3RRU1pNYlhtaWJv?=
 =?utf-8?B?SUQwZTU2MGNVRDEvaWg5bVdSekFZc3BZQmwwNzY1Wm9yaUsyYURaNWV2UTcv?=
 =?utf-8?B?VzRwQkFkVVpYbGlhL3I4b1ZqcFp0a3Q1djNuUVlmZjI3WU5CNjhEZk9hOGtx?=
 =?utf-8?B?Mnoycm1PZWUrd2lMTjdwa1YxNG1UNHVIcnZTS2FrZU9jeHZ0SlZLMm1TUnli?=
 =?utf-8?B?bmtzdDFwTHM0QjkyNTRBM2N5djBST1ZIbUhZTXc5ZFd5SHZGcitsQXhhWlh1?=
 =?utf-8?B?RzUyT0h6YTZOWE8ybjBFZkNFd2VlSVdWSGtiQ280a0thenhySG5ZemlYcWNR?=
 =?utf-8?B?YytwNjBRUTgxamwxK09Dbm12TUhCVWp1NlFyWEhSOEtvdzlSR2ZSb0RBQXRQ?=
 =?utf-8?B?VFAzK0k4cnBDKzBXWDVnUVVJa0RCOGVmcUs1MERhZFR2ZFRTQmFzSUpDNFZi?=
 =?utf-8?B?Tm5PVmtNQXAyTHlNMTlqRVBZSmNtSlZreVZoOXRVVnpXNkc1bWlzQWMyZHdU?=
 =?utf-8?B?bUdOR0tPQVFhU3dobVRVbWxyNENrcjZRMFRucXBYNDhHNnBvWXhYOU5tTm93?=
 =?utf-8?B?RDFUNWdoQVpoVFJ0QllJeSsxbW04dFF1QVl3amNBMk04N3NtdFkvMlhNbGpN?=
 =?utf-8?B?cnhXdWJBaHQrYUg3S0V4NytKT3pMYzJRRWErSVI3SDhLbDQ0K00xNkppRXYy?=
 =?utf-8?B?NWVQaU5DT3ZYcHRRbG9uQ3hWSyt6QVJlMHFxbnJ3Tzc3cWFkZWUyRFV4Y0Rz?=
 =?utf-8?B?eTZvYXlqblR5L0J1bVd5cWpkSTdNNjhNZDNMNmRXUVhXb1RjOER4TnJCTUpt?=
 =?utf-8?B?dU5vSnViSFo2SFczdkJ5Q2tNRWRmeitEampyTVAwT1p5UTk3S2JNSk5KTzY2?=
 =?utf-8?B?TEgxZ21ZMmtZdkJVdkFkRUFKb0VmcFcxdVE4NjgxdjltTXNGbGUxb1p5YjZG?=
 =?utf-8?B?aUo3NDUrYUMySEVEbWFoVW9NVGx3Uy93TUFISHRCeURua21CaVNQdEx4dDlV?=
 =?utf-8?B?RE01YmR3SjVYWGlHYThEaGovZlRKTkhuU3YyWUZUWjU2TDBsSTdIWjJ5eXJ4?=
 =?utf-8?B?czhsT2N6b2NNV3R0N0NhWEJ6L1ZDbTNzc2U0TVIyTXJqbjFHOElvUkkxRUc2?=
 =?utf-8?B?Rmo0UkZoV1ZadkgyQjBwRjlvZVNhb3pGL0lJdHBOOG9CQUZwcjJvN0tlT0VU?=
 =?utf-8?B?Wlp3UWFXZ3VKdlBKVXhMZS9EWjNkT1A4dWhkeGxzZU5ZbFJLZEIyYlJIbWhy?=
 =?utf-8?B?QmoycHBCTy9ZcllBTXd5cGVxbGZuY2RtaThKMTNvaStsemIzQ3pXSHU2TUpC?=
 =?utf-8?B?aHpyd3ozWGg5SE9xcFI4NnBxSnpKcy95MlI0SGhtUWpVZWlpejljeEx4d29z?=
 =?utf-8?B?aDBndWxTV2Q5MkEveEJGOXNlVHhuUnJleGVmb3VhQjFHQ1BMdzkxd2ttSldx?=
 =?utf-8?B?VGQzck1BdGw3cDBwL3pwWHcrUjBWR05OOGRETTdmZjNJbFdFMUhkWTRIT2dP?=
 =?utf-8?B?ZElzckxFdCtMK2hxak5aT3ZocmZYQnFGcitPWHFWYzNsa1BER2FDYU14eUVv?=
 =?utf-8?B?RHRsQnlscmxlTTZhZUFvUUJsdTNldFlFeUVzYitHcWhiNVJ0OERKOFB0M0d4?=
 =?utf-8?B?R043clBsMG5DRU1XRTVOUUN3MVhmcmVyUG5OOE56b0tQbW9CWnZhd2I4aUhj?=
 =?utf-8?B?V2pVbE5ES3J1cjdDdlVQRVRFNGRRbXFQZEhUUFMva3FVeUlZbUo2eEd4R2x1?=
 =?utf-8?B?TXl6SHI5SVloVjZ3bHBTdTlTczhpWG8xQVI0NjU0bmJnbHN4ZGJEN3dZQTBT?=
 =?utf-8?B?WFRZL0pQbE9zR2QxWEExcVRYeFRuRVd5V0F3RzRaWWVaQ2ZjNEZlWnZ1OUJN?=
 =?utf-8?B?NHBOSFg4Z3pmQWFBbWU1cXViN1VWL044NUQyQUJZbnFNL1NWK1hYTTVBSDUz?=
 =?utf-8?B?elduYnhkNGR1MjdqS1NFU3BJNmYyTWNiaHIvd0UwcWVVQStEWWxKcS8wVWcy?=
 =?utf-8?B?RlE1YlgzZXBqTys1NHZ4MWZjaGQrWlNYb1Y4K2NhNHV2Vlg3WElXN1J5U0Ir?=
 =?utf-8?B?bmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7061E2F947107647B7D54E1A78B5A89B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc392fe-1757-4fb2-f327-08dab7255282
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 07:40:15.2020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6LB+nPdN+kpKZqSSHAk5I2ZcRkAFgBfggAD6px5dK489BiDYb8/qbC5XVZV0RtATERGSjriXn+YBJWKAhwVc1P50BtVnR/vJoSmP86KojAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_04,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260042
X-Proofpoint-ORIG-GUID: wWtt6KFcQDWbmYCNyOGIWbSQBkFvMOy_
X-Proofpoint-GUID: wWtt6KFcQDWbmYCNyOGIWbSQBkFvMOy_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVHVlLCAyMDIyLTEwLTI1IGF0IDE0OjMzIC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
Cj4gT24gVHVlLCBPY3QgMjUsIDIwMjIgYXQgMTI6MTM6NDdQTSAtMDcwMCwgRGFycmljayBKLiBX
b25nIHdyb3RlOgo+ID4gT24gRnJpLCBPY3QgMjEsIDIwMjIgYXQgMDM6Mjk6MTVQTSAtMDcwMCwK
PiA+IGFsbGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb23CoHdyb3RlOgo+ID4gPiBGcm9tOiBBbGxp
c29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xlLmNvbT4KPiA+ID4gCj4gPiA+
IFRtcCBmaWxlcyBhcmUgdXNlZCBhcyBwYXJ0IG9mIHJlbmFtZSBvcGVyYXRpb25zIGFuZCB3aWxs
IG5lZWQKPiA+ID4gYXR0ciBmb3Jrcwo+ID4gPiBpbml0aWFsaXplZCBmb3IgcGFyZW50IHBvaW50
ZXJzLsKgIEV4cG9zZSB0aGUgaW5pdF94YXR0cnMKPiA+ID4gcGFyYW1ldGVyIHRvCj4gPiA+IHRo
ZSBjYWxsaW5nIGZ1bmN0aW9uIHRvIGluaXRpYWxpemUgdGhlIGZvcmsuCj4gPiA+IAo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBBbGxpc29uIEhlbmRlcnNvbiA8YWxsaXNvbi5oZW5kZXJzb25Ab3JhY2xl
LmNvbT4KPiA+ID4gLS0tCj4gPiA+IMKgZnMveGZzL3hmc19pbm9kZS5jIHwgNSArKystLQo+ID4g
PiDCoGZzL3hmcy94ZnNfaW5vZGUuaCB8IDIgKy0KPiA+ID4gwqBmcy94ZnMveGZzX2lvcHMuY8Kg
IHwgMyArKy0KPiA+ID4gwqAzIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkKPiA+ID4gCj4gPiA+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lub2RlLmMgYi9m
cy94ZnMveGZzX2lub2RlLmMKPiA+ID4gaW5kZXggNDRiNjhmYTUzYTcyLi44YjNhZWZkMTQ2YTIg
MTAwNjQ0Cj4gPiA+IC0tLSBhL2ZzL3hmcy94ZnNfaW5vZGUuYwo+ID4gPiArKysgYi9mcy94ZnMv
eGZzX2lub2RlLmMKPiA+ID4gQEAgLTExMDgsNiArMTEwOCw3IEBAIHhmc19jcmVhdGVfdG1wZmls
ZSgKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB1c2VyX25hbWVzcGFjZcKgwqDCoCptbnRf
dXNlcm5zLAo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKgwqDC
oMKgwqAqZHAsCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqB1bW9kZV90wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoG1vZGUsCj4gPiA+ICvCoMKgwqDCoMKgwqDCoGJvb2zCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW5pdF94YXR0cnMsCj4gPiA+IMKgwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlwqDCoMKgwqDCoMKgwqDCoCoqaXBwKQo+ID4gPiDCoHsK
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfbW91bnTCoMKgwqDCoMKgwqDCoMKgKm1w
ID0gZHAtPmlfbW91bnQ7Cj4gPiA+IEBAIC0xMTQ4LDcgKzExNDksNyBAQCB4ZnNfY3JlYXRlX3Rt
cGZpbGUoCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19kaWFsbG9jKCZ0cCwgZHAt
PmlfaW5vLCBtb2RlLCAmaW5vKTsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlmICghZXJyb3IpCj4g
PiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyb3IgPSB4ZnNfaW5pdF9uZXdf
aW5vZGUobW50X3VzZXJucywgdHAsIGRwLAo+ID4gPiBpbm8sIG1vZGUsCj4gPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoDAs
IDAsIHByaWQsIGZhbHNlLCAmaXApOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAwLCAwLCBwcmlkLCBpbml0X3hhdHRy
cywgJmlwKTsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGlmIChlcnJvcikKPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF90cmFuc19jYW5jZWw7Cj4gPiA+IMKgCj4g
PiA+IEBAIC0yNzQ4LDcgKzI3NDksNyBAQCB4ZnNfcmVuYW1lX2FsbG9jX3doaXRlb3V0KAo+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZXJyb3I7Cj4gPiA+IMKgCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19j
cmVhdGVfdG1wZmlsZShtbnRfdXNlcm5zLCBkcCwgU19JRkNIUiB8Cj4gPiA+IFdISVRFT1VUX01P
REUsCj4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgJnRtcGZpbGUpOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZhbHNlLCAm
dG1wZmlsZSk7Cj4gPiAKPiA+IFNpbWlsYXIgcXVlc3Rpb24gdG8gbGFzdCB0aW1lIC0tIHNob3Vs
ZG4ndCB3ZSBpbml0aWFsaXplIHRoZSBhdHRyCj4gPiBmb3JrCj4gPiBhdCB3aGl0ZW91dCBjcmVh
dGlvbiB0aW1lIGlmIHdlIGtub3cgdGhhdCB3ZSdyZSBhYm91dCB0byBhZGQgdGhlCj4gPiBuZXcK
PiA+IGZpbGUgdG8gYSBkaXJlY3Rvcnk/wqAgSU9Xcywgcy9mYWxzZS94ZnNfaGFzX3BhcmVudCht
cCkvIGhlcmU/Cj4gCj4gQWhhLCB5b3UgKmRvKiBkbyB0aGF0IGxhdGVyLgo+IAo+IFJldmlld2Vk
LWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3JnPgpHcmVhdCEgIFRoYW5rcyEK
QWxsaXNvbgo+IAo+IC0tRAo+IAo+IAo+ID4gLS1ECj4gPiAKPiA+ID4gwqDCoMKgwqDCoMKgwqDC
oGlmIChlcnJvcikKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
ZXJyb3I7Cj4gPiA+IMKgCj4gPiA+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lub2RlLmggYi9m
cy94ZnMveGZzX2lub2RlLmgKPiA+ID4gaW5kZXggMmVhZWQ5OGFmODE0Li41NzM1ZGUzMmJlZWIg
MTAwNjQ0Cj4gPiA+IC0tLSBhL2ZzL3hmcy94ZnNfaW5vZGUuaAo+ID4gPiArKysgYi9mcy94ZnMv
eGZzX2lub2RlLmgKPiA+ID4gQEAgLTQ3OCw3ICs0NzgsNyBAQCBpbnTCoMKgwqDCoMKgwqDCoMKg
wqB4ZnNfY3JlYXRlKHN0cnVjdCB1c2VyX25hbWVzcGFjZQo+ID4gPiAqbW50X3VzZXJucywKPiA+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1
bW9kZV90IG1vZGUsIGRldl90IHJkZXYsIGJvb2wKPiA+ID4gbmVlZF94YXR0ciwKPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qg
eGZzX2lub2RlICoqaXBwKTsKPiA+ID4gwqBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB4ZnNf
Y3JlYXRlX3RtcGZpbGUoc3RydWN0IHVzZXJfbmFtZXNwYWNlCj4gPiA+ICptbnRfdXNlcm5zLAo+
ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
c3RydWN0IHhmc19pbm9kZSAqZHAsIHVtb2RlX3QgbW9kZSwKPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB4ZnNfaW5vZGUgKmRw
LCB1bW9kZV90IG1vZGUsCj4gPiA+IGJvb2wgaW5pdF94YXR0cnMsCj4gPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHhmc19pbm9k
ZSAqKmlwcCk7Cj4gPiA+IMKgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgeGZzX3JlbW92ZShz
dHJ1Y3QgeGZzX2lub2RlICpkcCwgc3RydWN0IHhmc19uYW1lCj4gPiA+ICpuYW1lLAo+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCB4ZnNfaW5vZGUgKmlwKTsKPiA+ID4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfaW9wcy5jIGIv
ZnMveGZzL3hmc19pb3BzLmMKPiA+ID4gaW5kZXggMmUxMGUxYzY2YWQ2Li4xMGE1ZTg1ZjJhNzAg
MTAwNjQ0Cj4gPiA+IC0tLSBhL2ZzL3hmcy94ZnNfaW9wcy5jCj4gPiA+ICsrKyBiL2ZzL3hmcy94
ZnNfaW9wcy5jCj4gPiA+IEBAIC0yMDAsNyArMjAwLDggQEAgeGZzX2dlbmVyaWNfY3JlYXRlKAo+
ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgeGZzX2NyZWF0ZV9uZWVkX3hhdHRyKGRpciwKPiA+ID4gZGVmYXVsdF9hY2ws
IGFjbCksCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAmaXApOwo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlIHsK
PiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycm9yID0geGZzX2NyZWF0ZV90
bXBmaWxlKG1udF91c2VybnMsCj4gPiA+IFhGU19JKGRpciksIG1vZGUsICZpcCk7Cj4gPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvciA9IHhmc19jcmVhdGVfdG1wZmlsZSht
bnRfdXNlcm5zLAo+ID4gPiBYRlNfSShkaXIpLCBtb2RlLCBmYWxzZSwKPiA+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgJmlwKTsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoH0KPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoGlmICh1bmxpa2VseShlcnJvcikpCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgZ290byBvdXRfZnJlZV9hY2w7Cj4gPiA+IC0tIAo+ID4gPiAyLjI1LjEK
PiA+ID4gCgo=
