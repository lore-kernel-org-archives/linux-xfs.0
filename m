Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEDAC00140
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Aug 2022 01:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbiHSBGL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 21:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiHSBGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 21:06:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D897B729E
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 18:06:08 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J0UgkI014717;
        Fri, 19 Aug 2022 01:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=YFeJIQ8Ndp0/7oHjdejUJZH9Rp6KKdoBh4ExKwRMVks=;
 b=qC6JD41ddxrvAFd4toJQuHK5z91rOnmiYpUq9SsQmxYuCIpHk39y/hFm+4j7ogEDZOgp
 HZiQBwmhCoywX6D34YsAdOYguC2KqiKRv2qJ7XmiMBfucSp0Ty9/D0slEfjpCC/mu/RJ
 rnj/otbTAA0SgX6hATGiXt96N0x/8Ts9Jow802bGcm+vJftvM6gLH+slTLYtoJeY2inF
 aJRWT+AplQhl5aMgjHYxYbetLHo0s3/tlG9PmDU4X9nkjPY+XkukuiwC7zg7aDvyDdZx
 17mollRE4IsxTA11o8gfozhPnPupnFDVyTxkVOHhMzlARyCtMceE7hVXfeKoiJAHACuo gA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j1ywd81mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 01:05:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27IMOE5D005806;
        Fri, 19 Aug 2022 01:05:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2db35h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 01:05:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcifOcpmbBt8TB+hh4XtEpmBJWqSGbipEDqNLM+RcRIWAX0HjY+CutvQIjJpDrydeo3mG0DzhxzwVSj/gScL5JXws/gs+DlfK9h8Qa9xTD9UjEwcvDC3ffvJ+BkWm14qD11bHzJSFFHYVvQLEJzK50lgBlSvg2qbVoBIwxEbZ/9TnGMK+GtuV79VoECHTwBWgCZkeFUzWtT0THrnRxCF4t7tDn79qnZGUxKDPDnkQgJyiJ5VlvVcOkJ+dXNB1R8LkYlKxJjAXecI1MFBLOGV9060UEFME0vBfS2snXawRDvnCC4hZrpWkuimw8YGqb+Xod/wG4SDr+ekX4O4gw780Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFeJIQ8Ndp0/7oHjdejUJZH9Rp6KKdoBh4ExKwRMVks=;
 b=Ve29CXj4pmXhJcJDJVuMMKKXdoQAdAlnMOdyq1oKDJX+Oq2sIWMqyXM49sKos/7dzpkfJMz4LCRIRDpabM/zU4JBe6zcht6ppJ8Es+SjVAkMhh7ODbgXqmxBDMlvBWEt+s3+T2sRv75V0QJBvPEu8voc84emCmlteY7oLSe6QHvTX9IqjVuC03PtxcVr1mShEajNqMhE2zSN7+X5ntxjqKFtHQHd8HTCU5NHC2Vap/RHdT8PRRBv+A+2HFY8yTM3SxpBLI/edyX6WU7eMoW8rU/XaeE5IraGzKdZKlJHB2mx0/s6SkI+OJ4lkxuMmjveYZX1FySq/yq5wcKU0PawuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFeJIQ8Ndp0/7oHjdejUJZH9Rp6KKdoBh4ExKwRMVks=;
 b=o5OlahaX7wlDEOvzD6UEVnAGDGjHhDUPcDfjPWVk88iqwznUtKG0k8BStgme7fQMQG06QVxzi463arM5Xg/Kn5oMymmagdpJh559FTQnMR+4qTrQNV1atPX4CNIXYLeR+M+d6rCpIcAAWDI55jd/yZUXTmd7dy+X3Un0ffOH3d8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH2PR10MB4215.namprd10.prod.outlook.com (2603:10b6:610:7e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 19 Aug
 2022 01:05:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5525.011; Fri, 19 Aug 2022
 01:05:57 +0000
Message-ID: <82cc6ff775832d34f32cdbfe9bd125487ec22226.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 18 Aug 2022 18:05:54 -0700
In-Reply-To: <9acef43634b41baba8711dc47aaa7bd0cf46874d.camel@oracle.com>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-2-allison.henderson@oracle.com>
         <YvKQ5+XotiXFDpTA@magnolia> <20220810015809.GK3600936@dread.disaster.area>
         <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
         <20220810061258.GL3600936@dread.disaster.area>
         <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
         <20220816005438.GT3600936@dread.disaster.area> <YvsmAgj348tlKfCL@magnolia>
         <9acef43634b41baba8711dc47aaa7bd0cf46874d.camel@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:a03:180::30) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c9a676a-d420-48b5-66f2-08da817ef8d7
X-MS-TrafficTypeDiagnostic: CH2PR10MB4215:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOEKbSvcR+GRrwHjozi/Jacqpf7yoOqQx/zls3TPf7OpGe0ZN3hV3k6UnrfFvYnjGh29oC7YzFivdXkhNoYteDJZZG8rLw+HKfKrvjtev3CBcSAGQaKwJHDRGg7frVzAO/aPUfHmOkkHJFsU6viifdOmoPGUxih/8nqormlSO9dCho/s/qlHCeswyp/nWV3DkQ++pcV9/HyAE7kMDbn3HLWAvKtBL1LaUhVaRvMor3EP80lqmfWIFcHYhDmhLHpSCSOW1wNLL1TmZevs1CARHeiUnnm7bGuDcT140U/v/RDPUuDn5d5Tq3QmsjSyzKGF2B9aQK69H70FR9OQMB1k+NdcWLZTsuuYgfFW/9CgRWvAJ7v5tWlQTi9Qwm1yYHWoq2GuAWwC0SiEzoXNsryV5qQ3cGoLG3VneliDbvPxq4+tFl5ooTntQOFTaNJN2/8oXy0mukDvv0Jx/UzGBLprDflCtZ2hJeMGJ4/+FxoBLXqiiYKZ12aqdA/7GURrjhGkKjjOogp1HCx2ryWldCLoXzBJgX6yG16crOZbGHqVf9iytaf3JBV1llHgqjVt9yb6Q+V5G6XasXGZCKfZBihk89N+HCMk7NItlOCU2Uact51eR6IcF8SZcG/LIm1HAqas7PFtdHZPTDDS1fLic4c9uKIRDZdrHKVA82Mnb6XdwhVAOAbbFHOL76hzkt/D93VQa57LBDz8VxKC+I7KTzOPy2Ndl/kRCJJdxJPTl7RQmcuthtHZt0MmIZ0hyMk2qqi0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(376002)(396003)(39860400002)(6486002)(41300700001)(478600001)(5660300002)(6666004)(4326008)(8936002)(30864003)(110136005)(316002)(66476007)(8676002)(66556008)(2616005)(66946007)(6512007)(52116002)(36756003)(6506007)(26005)(86362001)(186003)(83380400001)(38350700002)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akpuU3N3TUJmZk0zVERuQUV2amhZaVcwNkpBazh0U3ZxYTU3SFJmaE9kNEd2?=
 =?utf-8?B?YjgvU0QzUyszaVZrcm0vL3dwL1dPTzc3dmMyM1I3SVBXWFhuWmxKVzVWenN4?=
 =?utf-8?B?ZVFmOVVxTGJuY0ZPalNiT2dZWkVjYVM5QzlkMW0rSG5BSXliLy9zR1BLeENP?=
 =?utf-8?B?bFRsdm05a2ZIZ1B6ZFh0a0l2ODRhTG9CVGJDOFF1NENHMmsycUc3MWZGUTVj?=
 =?utf-8?B?OGgrbG1aZzFzOER6L3MrZmNpeDJ0a0UzVFhYR0NEbUNPaGRrYWtwRC8vL0dm?=
 =?utf-8?B?a0FZMk1wY2pWd2FCU2FqYjBLd253aWs4czZjZzdBVVpQRDV3TSs2RW9SRmxN?=
 =?utf-8?B?UnpDRUxmY0ZGSDRrZ3JhbWtUeEhYK2F6NkIzbW9GMklybHNJVDE3MVBRUGxo?=
 =?utf-8?B?YkhmTm5qamQ5WU5oZldiUnRsVjU2elZ4OG52ckY0bkZsZW1IYkhMQzJwZzNB?=
 =?utf-8?B?UEJ5bDZLcUExSEVXRUJScys2Um04VnAyYktldmllU3RKcGNOb292RXllNDha?=
 =?utf-8?B?dnlHeFVseXRFdUN0UGxIY1VGVHltNXptRlhvaDFudmhMdTFmRCt1VVRvY0VU?=
 =?utf-8?B?TG15RnFkKy9oejV2Ni8veWhRWFh5c1M1OW96SDB4WllFM0k1SUF1TTV2Q0Ex?=
 =?utf-8?B?endMbXhROUpzSW1EV1hLNlNET0FjY3JHR09XWWsxT2FaZUwxOWZKVk1aTnRZ?=
 =?utf-8?B?Rm4xZ1NMRmp5ejhhaEJ0YWJHSklqR3RUU290UlhpY0E4SlAyRWFnUUEvWGRt?=
 =?utf-8?B?ZXIvdWtCRldJaktEeFZPTmNkNlhQSytuSWt5RlBlcjl5Mmk4QkYvcHkwL3o5?=
 =?utf-8?B?M1BmblB6OWxScDRuekFrZytMcTJHVWJXU2c5RDdrQlpGZlpud3pCSVgyK0cr?=
 =?utf-8?B?OWNUZHk2QkVoUDZJR3pKQWJMSW1vYy91dDdFNktKUGRJT2U5dHFmRk5LdHlV?=
 =?utf-8?B?SGtXajZGWTM4SlErRFB2cFpTUk1qODFkazFLYytGZ1ZGM1BISHBYWkF0TElt?=
 =?utf-8?B?clAzazVUcG5zcjA5VXpTcHFjUXVSYm1MMXQvdFc4SUx4UFRPU2h1WjRQY0Z3?=
 =?utf-8?B?WGhYcTV2Y2xjcUxhK2RHcWEzKy9LOHNqZE5jUUN0V3JMZmZQS0I4VFdmUnpL?=
 =?utf-8?B?QU44dUdNbXZiZHE2WStKL25kbVNUYUkxVHFBNkNCM3EwQmdab1ZZM2tuZzhF?=
 =?utf-8?B?b1I2d3NiQzNOcm14ZFlMamJhOXpKVmUwaTUvQkxnWG1od1JJUXdQTlF4RE5u?=
 =?utf-8?B?WXB1T3M1WTF6Q0REeXNlY2JLSXFSU2hiZ3VmSUIrNnM1MTRCWHRYL21YOHVl?=
 =?utf-8?B?VklpQUJLZ0NNUW95VXpMNHJhS2NSN1BKeFFJTkRHT0pqNHAwdzRLUTE3OWJN?=
 =?utf-8?B?OWg3NUF6RzNHeW0zb25FTU9Pck90eDhaeVorWVZWTkpiQUlnTzJ1QUs3SGI0?=
 =?utf-8?B?UW5yY285Qy9xS1lneXlKR3VtZHBZNlppWFpKeXgvbmtLelRKK01PeTJTZE8z?=
 =?utf-8?B?Q0FLdFh1VDF5Q250cGFSdU4yS1BvL3FBbG1iZHRCKzhCcUhUdWlEdURLREdi?=
 =?utf-8?B?d2VVU2xkUS9TWmNHdTRIdGloNFIvaG5DSDdLT0hsaDRGSHFXcTJPV0lTSC9T?=
 =?utf-8?B?NXF1ek5Qcmo1bzZvblEvWjBZYThMc3NBUlozdktPelU2dmJ1aHpDTm1tc050?=
 =?utf-8?B?dS94VGVuSE5kK0xva2JZTW96STByTkFCcG9nSUJucUt4L2tEdHFpSDBNMlJF?=
 =?utf-8?B?ci9ZR3pJbXJNaVJDdGt4d255b1dOaFU3blRtT2RxVFM3QXdQdmJwTjEwa2pu?=
 =?utf-8?B?WThxMFJ3RHlzTWZheVNFSXB5SGhLR0Z1WkdtbVdCcVhxc1NjWmd5ZEVNRVU0?=
 =?utf-8?B?dzcwcnErTVp0U0RMc0h4NUNVdE43b1JYY21KVk1aeStkYlRPN1VQRkltWGNw?=
 =?utf-8?B?a04vejNHbXlZdEpxYmw2aVdyME03V0dvU2lGejZlNElpVXJBMHBFd3hQUmVz?=
 =?utf-8?B?NUdPUW0vZlU0K2VlaE1POHZ0L0QxR2dEcG9DZ3NPdzdqVzBGa1VRdnIranRH?=
 =?utf-8?B?NkZBV3Fqd294UXpkb0VZTDdDL1QvUk9oOVJuNzFqc2VMS1Ztb2h2NHprdFhR?=
 =?utf-8?B?eWMreDd1UVVBQ3pGZ2lOaVZxc05pZXd6cnJyQVNuajBGd2lyZFlKT2dLRjVS?=
 =?utf-8?B?S0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kpCFO6eubCKFWIGZz1wLY5m2vEO1VHCtLeXo7Znc2w2q6ztvG5Or3mVtk9/0III8aFyTwcASGRCXLgBAz6mIZvJEBJg0oRbx7I2cLLCMaasivQDyF6qurOcLj7e8T+4KIR0Uv51nrFF4c8Nimc7sZ9UVFQm+Yt8V9iUruSwJz/FJSPkaIRww45M31eUmadoTgPJAfINX1DU3JLoVd37OHIf88z+gZAZmBdKYSpt4SYOU+ND3r/ruAT5Xm8444YWPFRZD/ombA3XaWInNEbXWejv0D0txgWcT1Of/rcTq5sqDZQPHvNgZtpnuzw+5p95zUK3mUW4YH+/789xA3dtWhr/PkKh0b8O1WeVEI+z+nNKgoBSMU91YVS5+aMWi0E1VFA/0ukizNFhqUe0e/qD0Dlmy2hCpQZFJ8QWvFq4UrMvWVvmTJOTZfzBe167mcnve+IMFIB5mGGv5Sz8y/eLnrCvkHjFENDSvey8N3mSdTOK9IHmXRMDT6frr1QSZnY9DctL5s3T4oNHkyq09/OeSUihbYc0E6vh+KEJGOcu3TPWZeA3OZnc+ifEoGNy5ZrdTOiqCn7Z+/l53eWfish3XO9MyXMeRTBRcu+rO3WVR+9buKfVjeQgsa3oV0pHsVLPT8mHMirJSHUHBIoz4+rmCmtdX2vjnYYjSuL6pta5eI8duWulW5c3NJZBFeYdtkP1XQIp3Fv/TgX883DoJ67c00VzEQD66uVTSwbVIRxSVDEFVqdjAkEk3hyBnsxuuC4KiXNyvd2Kpi2JaxHpOg+/1/KMrj/qluNZJ54+VDIPe6qUXql2URfUvHdTYYoJfRNJO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9a676a-d420-48b5-66f2-08da817ef8d7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 01:05:56.9587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frqRr53M2WruTlMNA4lbgCLs0gxhpQgrw6lKx+b/gbBA2NyJt1JGIA1xA24QHj8C6chQpn+mzEJGhe3BwO/zF1QObmmc+aTBRj/tP461XoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_18,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=750
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208190003
X-Proofpoint-ORIG-GUID: hH5BmH4IW2qlN_55NjcR7LveUx8qK7xO
X-Proofpoint-GUID: hH5BmH4IW2qlN_55NjcR7LveUx8qK7xO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-16 at 13:41 -0700, Alli wrote:
> On Mon, 2022-08-15 at 22:07 -0700, Darrick J. Wong wrote:
> > On Tue, Aug 16, 2022 at 10:54:38AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 11, 2022 at 06:55:16PM -0700, Alli wrote:
> > > > On Wed, 2022-08-10 at 16:12 +1000, Dave Chinner wrote:
> > > > > On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > > > > > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > > > > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong
> > > > > > > wrote:
> > > > > > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison
> > > > > > > > Henderson
> > > > > > > > wrote:
> > > > > > > > > Recent parent pointer testing has exposed a bug in
> > > > > > > > > the
> > > > > > > > > underlying
> > > > > > > > > attr replay.  A multi transaction replay currently
> > > > > > > > > performs a
> > > > > > > > > single step of the replay, then deferrs the rest if
> > > > > > > > > there is
> > > > > > > > > more
> > > > > > > > > to do.
> > > > > > > 
> > > > > > > Yup.
> > > > > > > 
> > > > > > > > > This causes race conditions with other attr replays
> > > > > > > > > that
> > > > > > > > > might be recovered before the remaining deferred work
> > > > > > > > > has had
> > > > > > > > > a
> > > > > > > > > chance to finish.
> > > > > > > 
> > > > > > > What other attr replays are we racing against?  There can
> > > > > > > only be
> > > > > > > one incomplete attr item intent/done chain per inode
> > > > > > > present in
> > > > > > > log
> > > > > > > recovery, right?
> > > > > > No, a rename queues up a set and remove before committing
> > > > > > the
> > > > > > transaction.  One for the new parent pointer, and another
> > > > > > to
> > > > > > remove
> > > > > > the
> > > > > > old one.
> > > > > 
> > > > > Ah. That really needs to be described in the commit message -
> > > > > changing from "single intent chain per object" to "multiple
> > > > > concurrent independent and unserialised intent chains per
> > > > > object" is
> > > > > a pretty important design rule change...
> > > > > 
> > > > > The whole point of intents is to allow complex, multi-stage
> > > > > operations on a single object to be sequenced in a tightly
> > > > > controlled manner. They weren't intended to be run as
> > > > > concurrent
> > > > > lines of modification on single items; if you need to do two
> > > > > modifications on an object, the intent chain ties the two
> > > > > modifications together into a single whole.
> > > > > 
> > > > > One of the reasons I rewrote the attr state machine for LARP
> > > > > was to
> > > > > enable new multiple attr operation chains to be easily build
> > > > > from
> > > > > the entry points the state machien provides. Parent attr
> > > > > rename
> > > > > needs a new intent chain to be built, not run multiple
> > > > > independent
> > > > > intent chains for each modification.
> > > > > 
> > > > > > It cant be an attr replace because technically the names
> > > > > > are
> > > > > > different.
> > > > > 
> > > > > I disagree - we have all the pieces we need in the state
> > > > > machine
> > > > > already, we just need to define separate attr names for the
> > > > > remove and insert steps in the attr intent.
> > > > > 
> > > > > That is, the "replace" operation we execute when an attr set
> > > > > overwrites the value is "technically" a "replace value"
> > > > > operation,
> > > > > but we actually implement it as a "replace entire attribute"
> > > > > operation.
> > > > > 
> > > > > Without LARP, we do that overwrite in independent steps via
> > > > > an
> > > > > intermediate INCOMPLETE state to allow two xattrs of the same
> > > > > name
> > > > > to exist in the attr tree at the same time. IOWs, the attr
> > > > > value
> > > > > overwrite is effectively a "set-swap-remove" operation on two
> > > > > entirely independent xattrs, ensuring that if we crash we
> > > > > always
> > > > > have either the old or new xattr visible.
> > > > > 
> > > > > With LARP, we can remove the original attr first, thereby
> > > > > avoiding
> > > > > the need for two versions of the xattr to exist in the tree
> > > > > in
> > > > > the
> > > > > first place. However, we have to do these two operations as a
> > > > > pair
> > > > > of linked independent operations. The intent chain provides
> > > > > the
> > > > > linking, and requires us to log the name and the value of the
> > > > > attr
> > > > > that we are overwriting in the intent. Hence we can always
> > > > > recover
> > > > > the modification to completion no matter where in the
> > > > > operation
> > > > > we
> > > > > fail.
> > > > > 
> > > > > When it comes to a parent attr rename operation, we are
> > > > > effectively
> > > > > doing two linked operations - remove the old attr, set the
> > > > > new
> > > > > attr
> > > > > - on different attributes. Implementation wise, it is exactly
> > > > > the
> > > > > same sequence as a "replace value" operation, except for the
> > > > > fact
> > > > > that the new attr we add has a different name.
> > > > > 
> > > > > Hence the only real difference between the existing "attr
> > > > > replace"
> > > > > and the intent chain we need for "parent attr rename" is that
> > > > > we
> > > > > have to log two attr names instead of one. 
> > > > 
> > > > To be clear, this would imply expanding xfs_attri_log_format to
> > > > have
> > > > another alfi_new_name_len feild and another iovec for the attr
> > > > intent
> > > > right?  Does that cause issues to change the on disk log layout
> > > > after
> > > > the original has merged?  Or is that ok for things that are
> > > > still
> > > > experimental? Thanks!
> > > 
> > > I think we can get away with this quite easily without breaking
> > > the
> > > existing experimental code.
> > > 
> > > struct xfs_attri_log_format {
> > >         uint16_t        alfi_type;      /* attri log item type */
> > >         uint16_t        alfi_size;      /* size of this item */
> > >         uint32_t        __pad;          /* pad to 64 bit aligned
> > > */
> > >         uint64_t        alfi_id;        /* attri identifier */
> > >         uint64_t        alfi_ino;       /* the inode for this
> > > attr
> > > operation */
> > >         uint32_t        alfi_op_flags;  /* marks the op as a set
> > > or
> > > remove */
> > >         uint32_t        alfi_name_len;  /* attr name length */
> > >         uint32_t        alfi_value_len; /* attr value length */
> > >         uint32_t        alfi_attr_filter;/* attr filter flags */
> > > };
> > > 
> > > We have a padding field in there that is currently all zeros.
> > > Let's
> > > make that a count of the number of {name, value} tuples that are
> > > appended to the format. i.e.
> > > 
> > > struct xfs_attri_log_name {
> > >         uint32_t        alfi_op_flags;  /* marks the op as a set
> > > or
> > > remove */
> > >         uint32_t        alfi_name_len;  /* attr name length */
> > >         uint32_t        alfi_value_len; /* attr value length */
> > >         uint32_t        alfi_attr_filter;/* attr filter flags */
> > > };
> > > 
> > > struct xfs_attri_log_format {
> > >         uint16_t        alfi_type;      /* attri log item type */
> > >         uint16_t        alfi_size;      /* size of this item */
> > > 	uint8_t		alfi_attr_cnt;	/* count of name/val
> > > pairs
> > > */
> > >         uint8_t		__pad1;          /* pad to 64 bit
> > > aligned */
> > >         uint16_t	__pad2;          /* pad to 64 bit aligned */
> > >         uint64_t        alfi_id;        /* attri identifier */
> > >         uint64_t        alfi_ino;       /* the inode for this
> > > attr
> > > operation */
> > > 	struct xfs_attri_log_name alfi_attr[]; /* attrs to operate on
> > > */
> > > };
> > > 
> > > Basically, the size and shape of the structure has not changed,
> > > and
> > > if alfi_attr_cnt == 0 we just treat it as if alfi_attr_cnt == 1
> > > as
> > > the backwards compat code for the existing code.
> > > 
> > > And then we just have as many followup regions for name/val pairs
> > > as are defined by the alfi_attr_cnt and alfi_attr[] parts of the
> > > structure. Each attr can have a different operation performed on
> > > them, and they can have different filters applied so they can
> > > exist
> > > in different namespaces, too.
> > > 
> > > SO I don't think we need a new on-disk feature bit for this
> > > enhancement - it definitely comes under the heading of "this
> > > stuff
> > > is experimental, this is the sort of early structure revision
> > > that
> > > EXPERIMENTAL is supposed to cover....
> > 
> > You might even callit "alfi_extra_names" to avoid the "0 means 1"
> > stuff.
> > ;)
> > 
> > --D
> 
> Oh, I just noticed these comments this morning when I sent out the
> new
> attri/d patch.  I'll add this changes to v2.  Please let me know if
> there's anything else you'd like me to change from the v1.  Thx!
> 
> Allison

Ok, so I am part way through coding this up, and I'm getting this
feeling like this is not going to work out very well due to the size
checks for the log formats:

root@garnet:/home/achender/work_area/xfs-linux# git diff
fs/xfs/libxfs/xfs_log_format.h fs/xfs/xfs_ondisk.h
diff --git a/fs/xfs/libxfs/xfs_log_format.h
b/fs/xfs/libxfs/xfs_log_format.h
index f1ff52ebb982..5a4e700f32fc 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -922,6 +922,13 @@ struct xfs_icreate_log {
                                         XFS_ATTR_PARENT | \
                                         XFS_ATTR_INCOMPLETE)
 
+struct xfs_attri_log_name {
+       uint32_t        alfi_op_flags;  /* marks the op as a set or
remove */
+       uint32_t        alfi_name_len;  /* attr name length */
+       uint32_t        alfi_value_len; /* attr value length */
+       uint32_t        alfi_attr_filter;/* attr filter flags */
+};
+
 /*
  * This is the structure used to lay out an attr log item in the
  * log.
@@ -929,14 +936,12 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
        uint16_t        alfi_type;      /* attri log item type */
        uint16_t        alfi_size;      /* size of this item */
-       uint32_t        __pad;          /* pad to 64 bit aligned */
+       uint8_t         alfi_extra_names;/* count of name/val pairs */
+       uint8_t         __pad1;         /* pad to 64 bit aligned */
+       uint16_t        __pad2;         /* pad to 64 bit aligned */
        uint64_t        alfi_id;        /* attri identifier */
        uint64_t        alfi_ino;       /* the inode for this attr
operation */
-       uint32_t        alfi_op_flags;  /* marks the op as a set or
remove */
-       uint32_t        alfi_name_len;  /* attr name length */
-       uint32_t        alfi_value_len; /* attr value length */
-       uint32_t        alfi_attr_filter;/* attr filter flags */
+       struct xfs_attri_log_name alfi_attr[]; /* attrs to operate on
*/
 };
 
 struct xfs_attrd_log_format {
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 3e7f7eaa5b96..c040eeb88def 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -132,7 +132,7 @@ xfs_check_ondisk_structs(void)
        XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,      56);
        XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,        20);
        XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,          16);
-       XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,      48);
+       XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,      24);
        XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,      16);
 
        /* parent pointer ioctls */
root@garnet:/home/achender/work_area/xfs-linux# 



If the on disk size check thinks the format is 24 bytes, and then we
surprise pack an array of structs after it, isnt that going to run over
the next item?  I think anything dynamic like this has to be an nvec.
 Maybe we leave the existing alfi_* as they are so the size doesnt
change, and then if we have a value in alfi_extra_names, then we have
an extra nvec that has the array in it.  I think that would work.

FWIW, an alternate solution would be to use the pad for a second name
length, and then we get a patch that's very similar to the one I sent
out last Tues, but backward compatible.  Though it does eat the
remaining pad and wouldn't be as flexible, I cant think of an attr op
that would need more than two names either?

Let me know what people think.  Thanks!
Allison


> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com

