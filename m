Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D3EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 21:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiKKVsn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 16:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiKKVsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 16:48:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E316C777
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 13:48:40 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLkxvw007732
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 21:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=g8gqCeRiZv85mWA7Nbq/BuRJqCddpzwh3SiwX2HBFrw=;
 b=R2Mp7avd34caFF6q0/Rhl15VdlGtiDvOeWcKA3v9gY2Pp2SAThTMuaSVtKSZBnZuEuHR
 G4se84TzJ6iFGg1whgmFzcCK7P4dxKK2NlxQedl61KifjmvxqbLFRJmnzfS9C85KVJ4h
 5Ic8Sce5A5BrMBMN5X006cS6+IoCRVaPW/ecbkaOVKrdyYs08vGYSRK8Ek93lH7YQd2C
 M/3UItdWb/2OMvOLB2kVMEbRg06iqlSPBh9co9cJ7kwLqbs6CyhN5v9Tea8R5nJxG63k
 3UwdTej/r/HQYZu7v+sFkwFJOfqSSlA00AMV+SK4aB1ulnauiGEeyOnve8lnGTYW7BBz ZQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksxkx002k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 21:48:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLQlA0021352
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 21:31:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsjf24s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 21:31:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sb4xYggWSZdr8cqCjIu7YVQwL6eWPTjdayXHQZBz7Zf4WoG+cTQEmBEbcZ/dgtZaRV/+MfbQlrAP/2+dKblkDghxyTUEpnLTLPgQl0/oFc2f/p4YTbEnB4CZ5jFgxxz7QIY6RJnzkQWgy8IKvTj16IERLBONnOLK5df73Gi6Gq1BthjpImWCrXpQA0YcTXrWbfuopf1oN8inC416eH6vZvC243CpSPXooe2oznc6t+WLvfCLgvthpLzZEZ0oi1VjJSlHmNXGCiGpNyZaDawP7VHGSO2Q1CFAoXeSetTRMKcl6DXJ5LKSVZW+0gJ0pLXNRYBCsK90Emz0hT7Mht5PpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8gqCeRiZv85mWA7Nbq/BuRJqCddpzwh3SiwX2HBFrw=;
 b=ALZ3LzWnO2b/NHqQbrNChV1XtmNwrvuQzo5KWAZLP6zanNcoO96o0rpZyBp5fPFrpiVqL1t+TnPa6jodfi0px1IFxjkQ2ewED1Y7E3Ev7C+fIHTNZaxQjiZ8W700AOMNN8AX90/hlHkq3Jb4MAXUA0PuBnh/zc6NGba7ZmJH2bvFj877gLfikQUffaCFq92Ps0IeVM7uXQcdidNke2YsIEB7BJQdEL9y8qfB6WfDR0ZWx5tYNdHwRT7oh+UDTi+ei56G1OxkMlmX+hSdOz8l2n/NredkLaqvyADaRn5LzNJOFaPOLvEjfYHOkd3UadPVtaTZRgjglSjNQiZUSYdzOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8gqCeRiZv85mWA7Nbq/BuRJqCddpzwh3SiwX2HBFrw=;
 b=v4O84zDRqECT3eKHoVv3hHatyOFLkSvZ33BFfbdrjIBpIe+pWEa/M4tu8VYG8lJN42OyJlYT+U/rIRVRzYid0dfK8MMSvoBF/VtvYt6AOFCs174r+zMVqY5wRBRYB8D9EAQpmMmTLM99D5/DXNDXPac17DgXc7t2gqTN/xazNTM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6652.namprd10.prod.outlook.com (2603:10b6:510:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Fri, 11 Nov
 2022 21:31:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.014; Fri, 11 Nov 2022
 21:31:45 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1] xfs_spaceman: add fsuuid command
Thread-Topic: [PATCH v1] xfs_spaceman: add fsuuid command
Thread-Index: AQHY9In9UhsYOXn4KkapB2hzrpZPj646QOqA
Date:   Fri, 11 Nov 2022 21:31:45 +0000
Message-ID: <2d21d7fea86d7aa48cbe0d1616ea99b56a0617c4.camel@oracle.com>
References: <20221109222335.84920-1-catherine.hoang@oracle.com>
In-Reply-To: <20221109222335.84920-1-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|PH7PR10MB6652:EE_
x-ms-office365-filtering-correlation-id: 8a6a0a6e-ea8b-4bef-2a25-08dac42c222d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1HmWyDonjhn16JFBBLImpGlNKtOB2jkFR+5b4cJldIJ8rL+7UH+VbePwissjRRMKzIy92bARgUqaK4sRhZD6RTOeSwiqvOnb7zRBmCc+IHJTQRLfk9Y51QI8Ch4yzOY6MQhCGTlKI5Idf9peT29gUBQxNPv+tb/58MHj4NELLdKAnX1NFZCHoH/NEMlbGYT2DJs4ClKdUWDRmEk1LqAbJn3w5eZuf4bui1znJiIM06ROTaP53AjShFkIild2oXUog4ZjSDUW+w4Uma3NnwVM/boiTPHJFKPuFlj84kKNwM7sECr8IuwMPJ8FDMevnl6FwimGe31rWMn1Xl9NzVmOd8ITCVLotLFGf2keVzhzH9/SGfIoQu9znzfX3VRak1bzKO+PsL/aNh9iipVqf5gJVAOpurCUy4N1g4I274MewFMuM4G/jTov+hkq1PVKvYtjIvfPGZcGAVBarkHtxtTGAKGReWcChWTrSb5LojqY7W1GSUrT1jXvjygEg2xKYh+beYPmoodtUMSRzFTKgy4AB2ZA9Y2xrnkmyc5zNjN5ca/iNDGGcV5RQKRjlOFRr9nb+9pr3Y15+umA4l3crH6IxwnzswSR0VhpC3aAS3oeRrREyheffBle9yY/B64UbyHJdIbUCF5zRb7dBS7zpCVOZIZVcSOH9bfsy1d43gdKI5awQyZ0CUd0PCiTUdgHLXjHZLqrA67lnzRDYeWpFootfSTTKhGso8ufSu4EcPCRbpHq5lyQbmJo7PoSkzxW9T6fuFtyuKLMlLfUgj5g6MjYSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(186003)(6512007)(110136005)(26005)(38100700002)(122000001)(83380400001)(71200400001)(6506007)(2906002)(44832011)(2616005)(76116006)(316002)(478600001)(5660300002)(6486002)(41300700001)(8936002)(66446008)(8676002)(64756008)(66476007)(66556008)(66946007)(36756003)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEJERGZiaHYySDcxdkh3RUs5NlVQN0czUUNYSjVkb0tzTWhsZXRYK0t3cDhR?=
 =?utf-8?B?OWRUYjkyc01haVVFZ0l1LzNYM1VBRVlHRjE0ZXMwa0lvbXhZcG5qN200QVhv?=
 =?utf-8?B?aUpoZUIvZEtwN1BuNFRSdmlLaURsWnJBZzQxRHEvVjZkQXRoL1o3UlVjdHdT?=
 =?utf-8?B?TlFBNzJyVXdYT3l5WkxMTEx1WVBCSE5SNVhyMkZpU0RmQktkWmY4TGVuS0d3?=
 =?utf-8?B?ZndmTTJUaW1jc2g3R08zNGNMelhXcFN0K0NEOTU2bm9XeUtDdXhxZGN4TG9h?=
 =?utf-8?B?SUdjVGI4ZWVZMEZmMzVGM2NOU1R3alhaNDFKc3p5QTdBMTFiZEl5VC9oUjls?=
 =?utf-8?B?NExWakFZbnZ0aDQvbTc4VzRMayt6MVMrVHBCb0NNUHBRVjJyTXNtYWVUS1Bp?=
 =?utf-8?B?MVhLV1RLc1dUT253eWUvWEc5c3hyVlB1MENwQW1EU2liT2FiQTBPTUtwbEc5?=
 =?utf-8?B?TElKaGgza2IxQ2NDWFZVMDB6T0RreVpURUFlVUhNUWNtSmFVUW5HakRpcDVj?=
 =?utf-8?B?YnJjMnlCS0d5ZnhyMStPYS9XVmlDd3FObHdMSVRtMFpnWnVWbHJIOGo0ZlB5?=
 =?utf-8?B?SVQvRzR0TkZqWml0N1FjK1cwWEF1a0xVUlh6cVpqUTI5ckU5OTgyWVV6eWpI?=
 =?utf-8?B?QTBkTTFXdTd3NHA2cXpvOU82Ni9kNHNqYXp0NXdxcHJXUWdzRi9EZGRCVFFU?=
 =?utf-8?B?R01MbkdRZXhqTnRZQldzYXRFRlJTMjlxREh4bTJMVDVzSWJXb3g2WE91dDVI?=
 =?utf-8?B?QzJnQzBGOEFseXBWK1pHTUlnYlBYc0lrcVRNMmJTQVZ1TnJuL2N0b1dNVm9s?=
 =?utf-8?B?bko1VXRSUGR4MGI2SzhNd0JRYjBpRktDaVA0c1djQUtxNG1xbUxhd2ZRL2Jw?=
 =?utf-8?B?MGhCU2hRbWZWUVNsdWI1dU52bW9JOWdZMlpYcmxUUVZjREVJaFJmbk1hM2p2?=
 =?utf-8?B?THdzZnIrYzEzbHVSZzVJY1JVeUowVTZQaGpZbHZrQzVER0pkTkhxaFIzUXl2?=
 =?utf-8?B?UjJpMzlPT0lLQTNBSjhzQVdOaEFzWlFzMm1Zb0hzT1VEb2lNNkV2V1JwOFBs?=
 =?utf-8?B?SktYbXBaVkJ0VUptdFhvSFdmRXJQaGxtdDc2Ykw5S2lJSU1BWVBwOWxKbWNJ?=
 =?utf-8?B?RGZxMVZLT3NjWW8zVlYyT1lzVGJrOHRWTEp2cGZEZER5cFlad2VNWk02dEJs?=
 =?utf-8?B?RDFucUI4MFJaSXNQSUFSd1pjbTFtZlM5UWZMaXBwSzM3Vyt2a3BzNXNrY1NP?=
 =?utf-8?B?RTBRTVNacFZYTlJmdjlOVkJzY0NYamQ2eWtHaDMrOHBQeXlZNzFZT2oyUVZZ?=
 =?utf-8?B?QndUeEhCVmdid3RHc3RzejMzNkJ1K2pmbm1McDEwUndMMkpKdm1QZ0hLbFBL?=
 =?utf-8?B?ZkdlRDlEQkNUYmE5K2hIWlZwZTF4bk1telVTM29Ya0tHWGVYcFFmYWlzZU4y?=
 =?utf-8?B?WGkrRDNHRDdyaXJtU3hzazZSZ3BoVTE3N05Ddk1UODJUdldKRlh1VDBPL1Zy?=
 =?utf-8?B?QVJ1VjNIeDVrNVpPdXhNYXFBVTlRdDNIOHB5NENaelBqMGsrV3ErVGorbWZ1?=
 =?utf-8?B?Zm9VOHZIWGJQZGx5ZWkxeUJCTm00UlpqN2NOeVc1S2pnQ2NQa1RBbkJwcGZz?=
 =?utf-8?B?YU9ueW42d2dlNndPTmo5Ymo4QWVBUDBmYTRtaWFleklvTzJMYlVKUXhWZncw?=
 =?utf-8?B?YUthOFZMMjZtLzA4UDJhUGZYajdpS0ZJZHFKcUk1dlpHY2RFbG5MK08yVHR5?=
 =?utf-8?B?QU9Za3BvcDRsa3pLOWJUeWJNVkJSMGFBRTBMdmJOa1BNbzRBY0xjNkdCTjk2?=
 =?utf-8?B?SU56bXJObFpmbmpqNzJmZWMvS3FuL0taeVJhNjkyUlB3OUk3OXluWnhmN1pt?=
 =?utf-8?B?K0w1QTFBNXZiSXMrM1J3NHE2OUZIc1Y1bjJxbkJjYS9mTlhKaFdISU5SVXdR?=
 =?utf-8?B?VXhmdzFucU9oRDFobkgyM1VwN2Q5eE5zRWFaVDBlT2toa3g1eFhpd3VxUmNz?=
 =?utf-8?B?eE9NQ2lxUDl1a25tMXZuRVo4L2Y3eVJ2MjlzdnlwRUNrMklBS2tBV1h1ZFE1?=
 =?utf-8?B?dHNXVmRENEZIM2VnQnhQbHk4ZGF4bXpyWEFlVjNIdUZPR3pxNkc2Z3JhNmp5?=
 =?utf-8?B?ZHlzUk5McXlHRDdVeGZJeUlNOStucEh2cW1jaDB1Tmd3QkpBY0tDOUd5bWs3?=
 =?utf-8?Q?VsaT+LbwQlNApCThOgfBJy4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A00E3CF250C31146A2551F773A4B48DD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AvEP++cMguB+szkbKwYQZ3FnxrTatxg/uBncZcnrAi1jjbJEbDwgOTQlxN558djKN+8y1/9VDiFi7eJyuda3uSc48iWRTegxBEDkY7xk0qPCJefdYhAE10GxPoMsUoIEntDsokRx+oa9Od+9RybqOqdBSlNO92qvWTpg9MCJOYolznKNgOKhmYUSYFCi9hG3u6X5F/vlN4TDNUAeC1+SKJVNqs4nXLdFsxbCMFXyoxIkd+Ij0zGN0SA+qh07xpva2jSfxJF203rPjudNEw06BsWFvTEdm4GHJRnB38WyQsvtyAn/uQiFpYMyJszCz+KMjj7WBZgJEXoLolbFe/5tFe6Qu8RPvp7TNO6muGGFppXBqN1vYDInaH7AzFVC9LTuUJH7phuZNrVDGvd8aeiHpZLVPDxc4Wyjty1LR3luAZCyD1OLIW3NrgyvJYVeaT3T2flwTgMSHWJncGiZ0kyaZhSeUE5CPeTGLTHTYZLnJbPuY272yhzRaQIcZC86n6zXcO8ZxJQpBE3AqPgwascS45tc7e5FiyvxRM0zC2Za6BT05lv9+joQFnGNDdZteilXDjvu1EGml11H+cS6tL/J+Z7teclIWpYi0T4P0Lh1UVWe9G2qhHbaL1lLbHCpSGEkmhbNHLtyNocfjxBSbfu5whs1doglRS/rGPDb286zCputLyC20kJRszhVzv/+aG+9G0F43+P/Br7uTQj7bSgQX1d+t10CXd7IreOyON23i9IMqd1g0aYKAdjdyO63Ew3Op+nt4/OK2t0DMFCMcyuy4A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6a0a6e-ea8b-4bef-2a25-08dac42c222d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 21:31:45.6868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5qLAaJTDJozrd8ehUqC9qURnH3/aqrWNoRETUv9gYL3rIN4uzKOAaJjJGjifKrxaym2RGwtm5X9TsY6N+RSyZuQORM92tJssXQPedAiLMyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110145
X-Proofpoint-ORIG-GUID: RgHvyXINPFx0EC-c1AM5wFTfcY_adnJ1
X-Proofpoint-GUID: RgHvyXINPFx0EC-c1AM5wFTfcY_adnJ1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTA5IGF0IDE0OjIzIC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gQWRkIHN1cHBvcnQgZm9yIHRoZSBmc3V1aWQgY29tbWFuZCB0byByZXRyaWV2ZSB0aGUgVVVJ
RCBvZiBhIG1vdW50ZWQKPiBmaWxlc3lzdGVtLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENhdGhlcmlu
ZSBIb2FuZyA8Y2F0aGVyaW5lLmhvYW5nQG9yYWNsZS5jb20+CkkgdGhpbmsgaXQgbG9va3MgZ29v
ZApSZXZpZXdlZC1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFsbGlzb24uaGVuZGVyc29uQG9yYWNs
ZS5jb20+Cj4gLS0tCj4gwqBzcGFjZW1hbi9NYWtlZmlsZSB8wqAgNCArLS0KPiDCoHNwYWNlbWFu
L2ZzdXVpZC5jIHwgNjMKPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKwo+IMKgc3BhY2VtYW4vaW5pdC5jwqDCoCB8wqAgMSArCj4gwqBzcGFjZW1hbi9zcGFj
ZS5owqAgfMKgIDEgKwo+IMKgNCBmaWxlcyBjaGFuZ2VkLCA2NyBpbnNlcnRpb25zKCspLCAyIGRl
bGV0aW9ucygtKQo+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IHNwYWNlbWFuL2ZzdXVpZC5jCj4gCj4g
ZGlmZiAtLWdpdCBhL3NwYWNlbWFuL01ha2VmaWxlIGIvc3BhY2VtYW4vTWFrZWZpbGUKPiBpbmRl
eCAxZjA0OGQ1NC4uOTAxZTRlNmQgMTAwNjQ0Cj4gLS0tIGEvc3BhY2VtYW4vTWFrZWZpbGUKPiAr
KysgYi9zcGFjZW1hbi9NYWtlZmlsZQo+IEBAIC03LDEwICs3LDEwIEBAIGluY2x1ZGUgJChUT1BE
SVIpL2luY2x1ZGUvYnVpbGRkZWZzCj4gwqAKPiDCoExUQ09NTUFORCA9IHhmc19zcGFjZW1hbgo+
IMKgSEZJTEVTID0gaW5pdC5oIHNwYWNlLmgKPiAtQ0ZJTEVTID0gaW5mby5jIGluaXQuYyBmaWxl
LmMgaGVhbHRoLmMgcHJlYWxsb2MuYyB0cmltLmMKPiArQ0ZJTEVTID0gaW5mby5jIGluaXQuYyBm
aWxlLmMgaGVhbHRoLmMgcHJlYWxsb2MuYyB0cmltLmMgZnN1dWlkLmMKPiDCoExTUkNGSUxFUyA9
IHhmc19pbmZvLnNoCj4gwqAKPiAtTExETElCUyA9ICQoTElCWENNRCkgJChMSUJGUk9HKQo+ICtM
TERMSUJTID0gJChMSUJYQ01EKSAkKExJQkZST0cpICQoTElCVVVJRCkKPiDCoExUREVQRU5ERU5D
SUVTID0gJChMSUJYQ01EKSAkKExJQkZST0cpCj4gwqBMTERGTEFHUyA9IC1zdGF0aWMKPiDCoAo+
IGRpZmYgLS1naXQgYS9zcGFjZW1hbi9mc3V1aWQuYyBiL3NwYWNlbWFuL2ZzdXVpZC5jCj4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQKPiBpbmRleCAwMDAwMDAwMC4uYmUxMmMxYWQKPiAtLS0gL2Rldi9u
dWxsCj4gKysrIGIvc3BhY2VtYW4vZnN1dWlkLmMKPiBAQCAtMCwwICsxLDYzIEBACj4gKy8vIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4gKy8qCj4gKyAqIENvcHlyaWdodCAoYykg
MjAyMiBPcmFjbGUuCj4gKyAqIEFsbCBSaWdodHMgUmVzZXJ2ZWQuCj4gKyAqLwo+ICsKPiArI2lu
Y2x1ZGUgImxpYnhmcy5oIgo+ICsjaW5jbHVkZSAibGliZnJvZy9mc2dlb20uaCIKPiArI2luY2x1
ZGUgImxpYmZyb2cvcGF0aHMuaCIKPiArI2luY2x1ZGUgImNvbW1hbmQuaCIKPiArI2luY2x1ZGUg
ImluaXQuaCIKPiArI2luY2x1ZGUgInNwYWNlLmgiCj4gKyNpbmNsdWRlIDxzeXMvaW9jdGwuaD4K
PiArCj4gKyNpZm5kZWYgRlNfSU9DX0dFVEZTVVVJRAo+ICsjZGVmaW5lIEZTX0lPQ19HRVRGU1VV
SUTCoMKgwqDCoMKgwqDCoF9JT1IoJ2YnLCA0NCwgc3RydWN0IGZzdXVpZCkKPiArI2RlZmluZSBV
VUlEX1NJWkUgMTYKPiArc3RydWN0IGZzdXVpZCB7Cj4gK8KgwqDCoCBfX3UzMsKgwqAgZnN1X2xl
bjsKPiArwqDCoMKgIF9fdTMywqDCoCBmc3VfZmxhZ3M7Cj4gK8KgwqDCoCBfX3U4wqDCoMKgIGZz
dV91dWlkW107Cj4gK307Cj4gKyNlbmRpZgo+ICsKPiArc3RhdGljIGNtZGluZm9fdCBmc3V1aWRf
Y21kOwo+ICsKPiArc3RhdGljIGludAo+ICtmc3V1aWRfZigKPiArwqDCoMKgwqDCoMKgwqBpbnTC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFyZ2MsCj4gK8KgwqDCoMKgwqDCoMKgY2hhcsKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCoqYXJndikKPiArewo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBm
c3V1aWTCoMKgwqBmc3V1aWQ7Cj4gK8KgwqDCoMKgwqDCoMKgaW50wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBlcnJvcjsKPiArwqDCoMKgwqDCoMKgwqBjaGFywqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgYnBbNDBdOwo+ICsKPiArwqDCoMKgwqDCoMKgwqBmc3V1aWQuZnN1X2xlbiA9IFVVSURfU0la
RTsKPiArwqDCoMKgwqDCoMKgwqBmc3V1aWQuZnN1X2ZsYWdzID0gMDsKPiArCj4gK8KgwqDCoMKg
wqDCoMKgZXJyb3IgPSBpb2N0bChmaWxlLT54ZmQuZmQsIEZTX0lPQ19HRVRGU1VVSUQsICZmc3V1
aWQpOwo+ICsKPiArwqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpIHsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcGVycm9yKCJmc3V1aWQiKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgZXhpdGNvZGUgPSAxOwo+ICvCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBsYXRmb3JtX3V1aWRfdW5wYXJzZSgodXVpZF90ICop
ZnN1dWlkLmZzdV91dWlkLCBicCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBy
aW50ZigiVVVJRCA9ICVzXG4iLCBicCk7Cj4gK8KgwqDCoMKgwqDCoMKgfQo+ICsKPiArwqDCoMKg
wqDCoMKgwqByZXR1cm4gMDsKPiArfQo+ICsKPiArdm9pZAo+ICtmc3V1aWRfaW5pdCh2b2lkKQo+
ICt7Cj4gK8KgwqDCoMKgwqDCoMKgZnN1dWlkX2NtZC5uYW1lID0gImZzdXVpZCI7Cj4gK8KgwqDC
oMKgwqDCoMKgZnN1dWlkX2NtZC5jZnVuYyA9IGZzdXVpZF9mOwo+ICvCoMKgwqDCoMKgwqDCoGZz
dXVpZF9jbWQuYXJnbWluID0gMDsKPiArwqDCoMKgwqDCoMKgwqBmc3V1aWRfY21kLmFyZ21heCA9
IDA7Cj4gK8KgwqDCoMKgwqDCoMKgZnN1dWlkX2NtZC5mbGFncyA9IENNRF9GTEFHX09ORVNIT1Q7
Cj4gK8KgwqDCoMKgwqDCoMKgZnN1dWlkX2NtZC5vbmVsaW5lID0gXygiZ2V0IG1vdW50ZWQgZmls
ZXN5c3RlbSBVVUlEIik7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGFkZF9jb21tYW5kKCZmc3V1aWRf
Y21kKTsKPiArfQo+IGRpZmYgLS1naXQgYS9zcGFjZW1hbi9pbml0LmMgYi9zcGFjZW1hbi9pbml0
LmMKPiBpbmRleCBjZjFmZjNjYi4uZWZlMWJmOWIgMTAwNjQ0Cj4gLS0tIGEvc3BhY2VtYW4vaW5p
dC5jCj4gKysrIGIvc3BhY2VtYW4vaW5pdC5jCj4gQEAgLTM1LDYgKzM1LDcgQEAgaW5pdF9jb21t
YW5kcyh2b2lkKQo+IMKgwqDCoMKgwqDCoMKgwqB0cmltX2luaXQoKTsKPiDCoMKgwqDCoMKgwqDC
oMKgZnJlZXNwX2luaXQoKTsKPiDCoMKgwqDCoMKgwqDCoMKgaGVhbHRoX2luaXQoKTsKPiArwqDC
oMKgwqDCoMKgwqBmc3V1aWRfaW5pdCgpOwo+IMKgfQo+IMKgCj4gwqBzdGF0aWMgaW50Cj4gZGlm
ZiAtLWdpdCBhL3NwYWNlbWFuL3NwYWNlLmggYi9zcGFjZW1hbi9zcGFjZS5oCj4gaW5kZXggNzIz
MjA5ZWQuLmRjYmRjYTA4IDEwMDY0NAo+IC0tLSBhL3NwYWNlbWFuL3NwYWNlLmgKPiArKysgYi9z
cGFjZW1hbi9zcGFjZS5oCj4gQEAgLTMzLDUgKzMzLDYgQEAgZXh0ZXJuIHZvaWTCoMKgwqBmcmVl
c3BfaW5pdCh2b2lkKTsKPiDCoCNlbmRpZgo+IMKgZXh0ZXJuIHZvaWTCoMKgwqDCoGluZm9faW5p
dCh2b2lkKTsKPiDCoGV4dGVybiB2b2lkwqDCoMKgwqBoZWFsdGhfaW5pdCh2b2lkKTsKPiArZXh0
ZXJuIHZvaWTCoMKgwqDCoGZzdXVpZF9pbml0KHZvaWQpOwo+IMKgCj4gwqAjZW5kaWYgLyogWEZT
X1NQQUNFTUFOX1NQQUNFX0hfICovCgo=
