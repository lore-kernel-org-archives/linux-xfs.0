Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C97FC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 08:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbjKHIdG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 03:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjKHIdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 03:33:04 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B7210F9
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 00:33:02 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A88UJE8004895;
        Wed, 8 Nov 2023 08:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=QGYK5NDuBTTgKCGUX1fgh33iIl+CNN4tg7gbOeeVkNU=;
 b=ESRrZh85oaq69Jsc8UCsk7pYWiK2DDydua9NTu4fTa4CCFAwq7oYGbvZykXDO3IHAsiq
 SbQssgYIJHoJKY6ogexvE8q5I7OWAI/llMp1T6AUsYCtreCeXs9QirBrDwXDPl6m7au4
 BewNDzXKa3fpn8sgTINKDzZMWNOJxqfwRQVXGEDu5PFCS7n91MTwjX0YRPyliGd89QPd
 NcTOaz2/+Z9XWIN/lwOouCgiVaWKkOEZRFxZmeSGWq7IAI5naLgmc7onOBF8nMVN1SF5
 paePUn+Nf1v/L5u1uTcJnBe3qtcpkitHK5siTinpC3nbkCUqxTNJDyBtyxMpLrYknVjy Xw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w22gwr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 08:32:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A88ILxH023788;
        Wed, 8 Nov 2023 08:32:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w24n0s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 08:32:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moL+w4JCfs2Abm1QS+L9ZG7KUIFfEPGrzyVJa2NQyYRrt42eiC9SresTZVwv7jjYwqEhEfbv3mOdRjIcoxpcOfGPnWLJ13IqdEyx6qRtFZhzF743vAT9qyfEs+8/ELlA2bR+X9JGcDuezZu4LT1YENGnPtbQNLv9ZhJvwPHb1HjsWXBG8XVyYk0hZNVNKTxPQVYwVop1LiU+WoYuPvWjf932gGvSvXVwxIm4WjACF0zGiaEFcWFHHVRQ7DbTTmFr8JJdcxDf9mp/vCwhHsJvI8obm12gIYRcR255CQBwmqros9nCsB68JvFlnbKgjo4c171UTHRynPFDBrZZTHLXPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGYK5NDuBTTgKCGUX1fgh33iIl+CNN4tg7gbOeeVkNU=;
 b=gqOn3B5Ovv4ln6ray37PauYGTfr09zULbtiWGe7wPFhd4mcse9E/IOl/Njdf3TK7WEoJ52BfvXf/9Gx2yOp0Sdhcjb10Id3iOmvYhvDHDb4Yubvfl2F2Z+nXzCLxrbgXtrU7XUpTB+REm5YgcOa3i+XCgJg9A7s+9IUDWxO7QVMNawSWsNUwV2vcHOd8yMTntLcyMiWPgZoEAMIcEOUHQcYe7iMjJe2liEulM6fgMU2ThmWZWONNJdRxvVQsXPETQqbYelfzL/YJpp+0SvQekWiRUs7bfOa98SnddfdBCHvHIZ2vzjXK3lpEtVM7PWYUmdMMlmZ9VpmhZnufr4Nz1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGYK5NDuBTTgKCGUX1fgh33iIl+CNN4tg7gbOeeVkNU=;
 b=r4bEJMS3HdWdmbzxDu01jrPJHX6kKaiIqVuLL74eCdMxfXiYlIYWG5HQziz1PU2jQeVWdrR+nGm5Y6/JfQAYlCSfze8E5fkO+TKlFxuidhKehmcQsUsqg12z62xCC8lpPO/HN+r6SgwY7yTPXhM5zFRNoae7E85uXNGUuHds26U=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by DM4PR10MB6088.namprd10.prod.outlook.com (2603:10b6:8:8a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.33; Wed, 8 Nov 2023 08:32:52 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Wed, 8 Nov 2023
 08:32:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 0/2] xfsdocs: Describe Metadump V2's ondisk format structure
Date:   Wed,  8 Nov 2023 14:02:26 +0530
Message-Id: <20231108083228.1278837-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 94727470-af42-45d5-cc8e-08dbe0354c18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxV/XNIVw6e8fceIvqVB/9ocfsvZ2YthEpCKrl7vadZydtmWfFLmx8XsTEqmOYYsTkI2GNcyxFGNj1rnaY0FJ1G7BD8tCnFEpAtj+zaZe7e1kVjR+NewQLl3G6eCO+DI1p0ihOJ7S2TfcuJkA47DrKtF+CGcn1HKb4HjTcA+8hmf7VI26pAPvurgeNH+R1b3vQHzBz349bGaaKYKmD9tEl+pMuPTV0o4nEDOd12S5jbpVQzrKl7J/VDE/iI79pk95zm362FdSKEcU0Nn6rmKOcPYPV77CsV8TAlqY5YfYiIdvkKHRLggFT3GgEtt/K8966BENl1mOBvxyBa3NbT+/YlFamNLklzWonsHqoxEZjQCkj29scNeBNOVrXXFNe5x7M/+CnuyUKPfQDe4QzFKkpqYArNHK4HvWzXhFaiwpiemP/RpxTGe3uscxRAlbtgia7Mx1SvCKsMn4t6qAEe4CPpsfbvjMaj8FdaTyRjieN6Q3V0tI+0Wyyyhz4hSCrc++xRjf830uPOFmb1pisEzPvnKarT3NgsaLwRXXw3ZVVJdJJCUc+LX4n892Xy+AUME
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(376002)(346002)(136003)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(5660300002)(6512007)(41300700001)(6666004)(8676002)(4326008)(8936002)(2906002)(4744005)(83380400001)(38100700002)(6916009)(6506007)(26005)(478600001)(316002)(6486002)(66556008)(66476007)(66946007)(2616005)(1076003)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4toO1s6t+jj6Mj7eexvyB4NZeMQoRjH+42Qrnw8WzaPCgumKulWltne3wttp?=
 =?us-ascii?Q?ei+iP/LVmqozqDl5bF4zRgGkv/v5EStyVYu144qWd9EpkQ6xp6ucz2BxhOv8?=
 =?us-ascii?Q?hbrLE1m/cvIbLCzxfOO0PHy8CKjj/F2LsoWJLfAv7ljObdbYv6WxvYg5cmLz?=
 =?us-ascii?Q?cc7g9IF+9t6OkOjPe+6IwTc5uVkkMI/4yZH0SNyZ8y19maELfsgy3PtWjR6m?=
 =?us-ascii?Q?d88yNmYaTjrAt8Ia9r43gWyB6C9SrzqAJKRaGtGdo1QH6JJzdx2rRwnBZSKG?=
 =?us-ascii?Q?14QTj5pfuvG7Ow9LdlBmW2zAb83eUw60NCfEIZoqBInTeegWV9GyCg0B7f2z?=
 =?us-ascii?Q?5TnXu4E1wMAozJf7j3Ho36zaXgkQ6vEr1/QzmQH0vRQtSMo4IxvHI0gBvwRQ?=
 =?us-ascii?Q?y3iFjIIt51DsK4Rce7fbuai9dIzdTOuxcZjISvvjVClw6Cx1eg5LMvQuzESr?=
 =?us-ascii?Q?C09aIxADOq3ROPUY+O2Vg9k5kdwuw/h9MDiwy/U4Si4a19yEfDA1NCi7GQYS?=
 =?us-ascii?Q?f2Ct1f7O9PUDdW44YzQc8yNtIS/aowrzJfvDo5JxS1ugKU4uSCQhsIYWJH9e?=
 =?us-ascii?Q?cwn7H8UoaSjERv+Pm4qJwpubICoE9tKcXEqTh31HFc80nH5FMMuIkPD8m59P?=
 =?us-ascii?Q?4XdAQDJ0/Eyq2INbTDBf3PptT590qJ13Qhh+9usPgJr85hgWjlID4wYkwQNn?=
 =?us-ascii?Q?sVHoSZkyNsk9HMy3aQTOAin4s4YhkIjYtslY9lpWwJE9gM4F7bbkVHET7X04?=
 =?us-ascii?Q?7dmW6lJwG/mnS0QmayhltruF+Nl/pVuEik7OGKn1jyfcPgRl3BQkb1VDfWFi?=
 =?us-ascii?Q?x3go+IZfSqDOBG8dYBLJNc1TCHijBTIrvHvrCe/Hu79hhZGmkcwLonh87yYE?=
 =?us-ascii?Q?qhVA3b+LpTpQqH2k9tmY18piTrhGG6eyDiLyrSM5ShlRLxj0ny4RPmGEKeW5?=
 =?us-ascii?Q?6XauUBRm/CIaPkFwcOnz5RAiXXCsxvVj6G5uzviaR+V1EmieeOTaxbB8VPij?=
 =?us-ascii?Q?Gp4L39U9A+6aPm2BPjwXs5rnMGZpUSlRber+Jphq5qLzHjN9vS05TSWTdx0n?=
 =?us-ascii?Q?0kofyRc37vZ0jp3wWZfpdJApOoVGXAiAoEf/l+kVzLbSY9eXd2xaHoxJX29u?=
 =?us-ascii?Q?L8anNCZT3mCQMvSUBqDCwSAag1t2tzc6cXVFk6GpitkulmUo4+DWbwcV3jwn?=
 =?us-ascii?Q?KmgKE514CIZgdBoxkFZx1lrvQZfBGBYv72IHJHD3U0lpIld4o6QIBIwaXg1t?=
 =?us-ascii?Q?eHFJ+kwKWgEBNzN0/gWR8l6ps9MUrbNxko3bgA+liclgWCBDKrChjVeM8wpF?=
 =?us-ascii?Q?8XURiAE/N4iPkebkwkcdcjNAav+D1AnDEsmBMUH2TqLmSbS21E2uKgPpLKOc?=
 =?us-ascii?Q?+q6HkoLBwF0ylPAdkAC7kbvK0hxqhvL1C1eH3qCl1W1VAwhNl4h5EXrfJfUg?=
 =?us-ascii?Q?XypmERdPvwbXCzHudewHYUKKwm1Q0RPyrfrSijG07QGJnm5dhy2XtYSHTIFv?=
 =?us-ascii?Q?Zf/wz9le8CiNcizDqA0BU8cLWauksvdhRph/T6FNlJ+62XUDS3bYwvenHoFN?=
 =?us-ascii?Q?7j8uWiF4ZFBE4KjVKcwdTeheNYW9/HpQgZaClV34?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /BIuRioChoiHYzYS9BLUgntYgFSEqHkSH4+q4um8XHkWUqJsm/BTItFBtURq8saJ/IAQqSS1Nplxims6DQWpt6I/Bbwc8OeE+1T8BKudxcsln6luC2X1QOtqbY6CDrmbIrj48uarU314rjWSge4P9LmIILpj6S0RQK/xdkO7DtQ4DTSuIFYMtPL0nB4R3zVSNpF+Dzimiyg7jmUlpFbkU5OVsxGu0DWT5Ytyv2Q+F3XY8/se6dIlzuqU+yWr6XXdxheOXb74VFv5njA721zF+XzB3VhM2huWMXv3EF7pWmna/YwLoE+iRCW1S6UFNtLHxZgbHt+peEoDdtmcZ8O2V3FmyNEtddCa8Gwjm9AzxryItAwlRmyeMxIvDHJEquTK/zIVKj7ysQPm3WYiXt/oZXLHlpGq6iiQWaNm5BOkw4cGWRl/aQ9a329FslF8NB2ALSRwOd7R+2ZUEmiOfI6X0L4RkpJeVLQg9kRtNdPxH7vaFoN1K23VMgorzFvOlRoxdQcFgXSzHNI4t+ElOJ60vKKkPXfRpudqGDR3LNQcLkuUsWjczBt6+3hIADVl7ciQ5RPjk+aDCjvcO4vHPsx1LuCbR0OO3kz59DDxgFLeWPrK8HHBOwbrkjJz64qLnVmC5enNYOIt4JtxbqDqqsal3UEGVzNZeR4ijWjlA9ibiFEWrfJTJxQVo9ayJlYE+IVyLFX7Dh3s60q9Nw74a29SDNhc5Uw5tZOhZ4zBVBWwxsNT2kDLhY5di+Bx1OZAhW0cGD1Pt7071fVpGO9FugUCwHKFSJk5KJBj35cSHdiuzP4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94727470-af42-45d5-cc8e-08dbe0354c18
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 08:32:51.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJ3vZ9RRDbygFzfM0rIVBcCytsD0OZGzzxlnV9IfLM27dSn/PvSWMym2hgFF53V8TQzkX3prd42lgLiulOv/WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6088
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=906 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080070
X-Proofpoint-ORIG-GUID: qfsBS2oPOnKmKnGYAoCgX4_cR8e8-wTa
X-Proofpoint-GUID: qfsBS2oPOnKmKnGYAoCgX4_cR8e8-wTa
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds description for the newly introduced Metadump V2's
ondisk format structure. It also describes each of the flags stored in
Metadump V1's mb_info field.

Changelog:
  V1 -> V2:
    1. Address review comments given for V1.

Chandan Babu R (2):
  metadump.asciidoc: Add description for version v1's mb_info field
  metadump.asciidoc: Add description for metadump v2 ondisk format

 .../metadump.asciidoc                         | 98 ++++++++++++++++++-
 1 file changed, 94 insertions(+), 4 deletions(-)

-- 
2.39.1

