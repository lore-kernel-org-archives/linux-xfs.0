Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88777C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 23:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbiFOXkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 19:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiFOXkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 19:40:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6C834662
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 16:40:14 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FLcXhC009908;
        Wed, 15 Jun 2022 23:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZTK/o9SLfEBiEnFWe/Hd4dsACCo7Oac7HhOspESjJLI=;
 b=Of63/jzXgR7MmzDuEWgiskhNEowCPN3eVP/85eGmCvmrwrQ5pvyp+orBH0eAm8gqcFbL
 p/+H9xsDMiiLHuqcjiCy/3Rur0SK7FA2CZkGoAM7KtC4K20x1rwJsVb+UolHkSkX2aF7
 nHP2NTyJpIDxY+D1WDAZKLXOiyai/tH5i1H6QLbwGtY29jJXZvMQm4WzFOLOGua+6050
 SW9HtcV9fZ7kXOK67etZ9zhgkT17MZ87FFvDnTKDURUQQvBCEv1ReiEgcECqwG+K/5xG
 nC5TggD19xF2GFnUGnlzIc7uOqnECqFg13hUI1PAM6CM7MyBvnDTfVE66tajlfNwAqov ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkthus7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 23:40:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25FNKXeQ016313;
        Wed, 15 Jun 2022 23:40:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7ph2vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 23:40:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzkOQMQ/1faoOj3djCa5e8DS66US1NncJdzhqns7bdwRtPgqTfHQtO0BmoyhkG2LgUmNIwqDB2XQzWApVeXhK/8br+asPJXYdH0zyiNXQ+DhZPzluzqDFj+Z/ikomXMsH/6ayGe1dRSxxN6rspEZl/6BSs9i45BGEyNme1QET4/pCpiyl0IK0SmduYf6Yyjpcyk/ovKSKyDk1rQ9jzICE0DzeqrMABthwKx8QFpzmn3B+65N/523WkwXUpm8CSUTIrampa6MK3QVTn9KuuNmflZAgbuydXorU5vraa0Cc8mGOasiExrbTY2K0cukJuHDG/7cwdyqn+q/8ZdilzoxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZTK/o9SLfEBiEnFWe/Hd4dsACCo7Oac7HhOspESjJLI=;
 b=FDfDbb4VamZL302hit+hsvsWVFfhC8tX7/kc8+j9IFp8kwFxYqCHTizriwbXIQRSsl9HYKLGnjozKJFD5J7ct5zbG9WWLLU1gY+vvZbt8AJMA4JYwVQ7xfd2hsWfu5hl3hUFlYuXTvtDOCkXiGcr09+qEELfmXV9iGiuV7C32iqjIZbnsApwNNGvgMelUvzLpGxQtSf3elQ73xLIVXFbpx8+bo5SblM0EfP6Nk+7hIrpOckfEFoMKhPa2S9gD6PV04wD6zH4HSI9LvdkO8LoOnDLxCAsIhVPmeq5zJIBIh89HMQQogVosTyWK92nCqkFDjawZsZKFpd3i+HqS3KRhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTK/o9SLfEBiEnFWe/Hd4dsACCo7Oac7HhOspESjJLI=;
 b=uOjlRNESuglNfSsv4oaNsbiuOJZmA4cbY1dEW/IAao0A2B6XHJEvjoWXaD2XkTbqMBJOC1/dyWJfyVr311c38qD3h1eesjAU6dsePTyftXDMWSHOxKjZKLEGBpzKuI3D0dYLcnTL8M4/P+ptS4o54DYrWk7wBo32K0F6BHJz40g=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3779.namprd10.prod.outlook.com (2603:10b6:a03:1b6::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 23:40:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.015; Wed, 15 Jun 2022
 23:40:09 +0000
Message-ID: <fe4ec2a3959af674b29557d82dedd7924f36406c.camel@oracle.com>
Subject: Re: [PATCH v1 01/17] xfs: Add larp state XFS_DAS_CREATE_FORK
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jun 2022 16:40:07 -0700
In-Reply-To: <20220615010932.GZ227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-2-allison.henderson@oracle.com>
         <20220615010932.GZ227878@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0120.namprd05.prod.outlook.com
 (2603:10b6:a03:334::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4e3b3d0-54a3-4771-3f06-08da4f286203
X-MS-TrafficTypeDiagnostic: BY5PR10MB3779:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB37799BCB39C62B79EEFA373695AD9@BY5PR10MB3779.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKORzUcZQY6+S+hQNdeOiIRkswbpNxQLAZF2Gx1hoWJg8sdzJigm42OhFycpmJ43ZSgWUpmWSnh7zYnKKD7f8/HvexPX36ICwHsUoVJXHGzCwR2cE9S13M82DJOZWzV1EXILzcPX3tNaMXeT4fAVIzuuDYd9Us8eVnERgTwXvQwqvs79Ai9u9c4Fn+FwkaLySLvoBDGWKPfYE0wXbL23Cfgbz+Dp5TNQOh8vpnMHbxu7FagIw0SmLk6MTcnPHWlY/5WpvpWdMGGJamJlDlXLM4miHvq7T+YVzX3/2tz/OD1WwoIUTPF9WtZdGlDwyvH8oTFthpFtJK6B7rS4/r6nLYZFUQixP+t9BzfDkzXhzFhwi+OHO8Iwx6C9PAn71Pad90alWCEgGnETsRa8JmFR+dVMjwBW6tMWKkaWPjOfdN+bO+QZQy5nBAa4ldyha8dLUbb5gKi/C+q3ul6iQeqaGWEiDaeb52Z5GToFBcRBvV1W0UsQQCYmUqyKGSXoF7c6MYlBEdAKS5mpQPUT56N5u3QqJxmFdrDDI0IqNSpVpmPHuEN0F7DdWOEytBLJY1vpGMy6CtHNVQLVrqB4Q8n2Qt3mzsrHvkrg2BCc34ptWIDcsgh930KJWVQwjQKbnu/pDe83qqTEbE5qKcoe/z3uus3FfiHFQhCXGxf4iQsdepxgur6USoO2VHnOkLZwQ1d3U5ZAG1tNUivUyeLy8isLtGw5wc5wNvnbjTKy1bKfN3X9HRkhQ+9ieJKuOCXSzxjDjzrG2SXsFzmdBRhe1IaH7WRBIB28oFi1zPP4p92HyLtaxY/Tm6bCr4bIn8YfDX/1rAlVl9+4SFf4a+YdEc7luQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(5660300002)(66476007)(2906002)(38100700002)(4326008)(36756003)(8936002)(6916009)(8676002)(66946007)(66556008)(83380400001)(6486002)(508600001)(966005)(26005)(6512007)(86362001)(2616005)(52116002)(186003)(6506007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2l2Um9OWHFYZTJhYVpJNE83UE42Z0MrYnFPQVhNVEVXYUg2Y1BTdS9zYUJJ?=
 =?utf-8?B?aVpaaVU3enEyUWFpV2tJNGZyaEdjU092ZE1yemdzVk1xQUkxZXh5TTRvdnpp?=
 =?utf-8?B?bjh5VXZnZ1kwdXV5MUVta3FaQWozRkJiR2J2SmxybGtkdGxTTjE1ZmZZNlBt?=
 =?utf-8?B?bFpJdm1vcnBGZ3M2NE8xQ042UHM0RFhxTjhoRWJVYXdiOFAybFh6bXg2VWg2?=
 =?utf-8?B?NkFmblZtK1V3bUJFUHpFKy9yTi8rTUFiTWVvT2NpUzRnY3h6VUZlWStrUWtS?=
 =?utf-8?B?blkzL1d2M1YzcUNsaWJxWUFyL01TZUZ1cnRoaE54aTVvNFJBZjZjc0k5M0Rh?=
 =?utf-8?B?Z1BrbnpHUW1TYjQ4R2VxejVKR29XRGZFbUwvNzhVQ24yU1VZQ3l4K1hsS3oy?=
 =?utf-8?B?U1dtSVgraytKUnRNTWFXU3VBenRTZDJpRnQzbGg5c2lQV1BCais0Tjg5cEM3?=
 =?utf-8?B?OER6UEw2b2pUQ2lYZ0dEZ0FBbDRnOGpoL3lZdFFpSTVmSkd4b2JVdDcyNmdk?=
 =?utf-8?B?OGZ0aFRFUHdsNVhqSWRtWkUrMVRCbWpZYWw4Z3VXVXNqaDYzZUV5cW10UWo4?=
 =?utf-8?B?OEU3SHV6VForaDFYYnA0NThmWWtmL1F1M0NwQUJDWjRmYUtyQU5nMm5vRkdh?=
 =?utf-8?B?cW1FL29XSDdvSzgvbEZWQUJRVElvTVBITFhLMVpvRWJsOG5YbjhwQWhqTm1n?=
 =?utf-8?B?ZCsrTGtuNmUvd1Q3bDFtSDU2NmpKN2EzM0RubHpWbmRDczhMdHd3VW4rdU0r?=
 =?utf-8?B?akZMUFdWSk5nNHF0NXgzeGxHRG1JUGlPeVI4ZGVqZEIra1BkRmtHT3RrOG82?=
 =?utf-8?B?elgrYVIwVkRDL2N3TmIwa0dVTk9jaTVaZmJoK3dDT0xiaXJlV2ErRlp3di9X?=
 =?utf-8?B?Z1J0eGsyN0NtaHBORWRiQ2VSb3A0NHd0N01WLytaREpjNDhvTGFJbHVIUDgy?=
 =?utf-8?B?SDNmK25uLzJzcmk1Wmd4SlI1VXE3TVIyS09vQlNQTVZOUDhITXpJMG9ZSEtP?=
 =?utf-8?B?eDJWOWt6bm1RRkJ4cHNpcXB6QnExbGV5UVh0OTR6WUtZcUFoVytORDBaN0Fi?=
 =?utf-8?B?cExWeldOK0p6SGNzRS9tS2F3alJxWnRoUDczZmx2UGdab2JhMVVHZ21MRW9Y?=
 =?utf-8?B?cTZ1K09xU0xHa1ZoUCtwNmVBa1RueDlpczNHZnRHSStwZXF0VVBxNVZ6clU2?=
 =?utf-8?B?OEZON3BBWmUzZnkram5NZW1SaS9yU0JoSnA0VmpoaG5nWUhza2lUVnBFYUZP?=
 =?utf-8?B?QW01WjRYMHphd1NoY29CbjZsTS9aYkp1YVZBUmZSM0RMVGJ2MDFaWFBmQzlU?=
 =?utf-8?B?bVRQd1dzUHBJZ1JucUwwVTZwU1pxVDZmcWFrUDdneG13bk91K0RtWkF2a252?=
 =?utf-8?B?WE5oSGV2Q0YrSDZoczg4clVXVXRYd2l0dHp6SklQV3RHdjhWWWJUVlJuRHNu?=
 =?utf-8?B?ODVabWZuWlhWM0plaE1vKzFuSlBVM0xkRWJ2MmdHbnhWcjgxTzVMNUFlUlNC?=
 =?utf-8?B?MFhrU1FVNit4dm5EekpoTWd2QlBZWWFQaUFTSGpsbW5LRU5tUjdhNHRNak1i?=
 =?utf-8?B?SzJOaU5WSks1ZGJ0NGh1N296QjJDUW1LNmE2bGNxd3k2R05QNFhqTXhCNFY5?=
 =?utf-8?B?NXd5SWF0UFI2R3lFSW5xV1FzcFk0M2kxdEhoTGcydGtwYkFFaCs4U0YvamlN?=
 =?utf-8?B?RDYrQ25MU1JNMnIxUmJCRXNTMUhTaUNrdlNxSnJMRGpGdlVLZlFOUVcrNkk1?=
 =?utf-8?B?SG5LQzkrbHBXV1pjb0hnSmN6anFGTDNzbTdoYUtBdWhiSzRTaElXdU9rZDVs?=
 =?utf-8?B?TnBNWEY5U3BuTzFBaVZZWGdZUHNWL1F2S0tJcTZwU2g2SXduaVVSMm1DOEor?=
 =?utf-8?B?RjUwWFZ5R083YkFaMkNXRG5XT2NSZjM1VlpRU1d1UDJrUDZxYTZ4cWU0Ym9B?=
 =?utf-8?B?M3ZlMFA0OTBobDZSc0NpdTZha3FaWTlwQ3F1T09aQVJqODFrVjZHRUZxUlM5?=
 =?utf-8?B?WTZaWWZwV3Npbyt5TXVKaW9zcERrMDhpeElEc0tXc1laNnZWa0MvUWhVNXlF?=
 =?utf-8?B?TVNqa1ZqdTQwaXZjNEVDZlYxQ0ttL2lZcjlQLzZJTGIxbFYzS0gwVTZxN1kv?=
 =?utf-8?B?VWNXVEpEK0hqeXdaTmhZWTNPV2FLdmo5VUlUUGM3NS9jRm9DS3U1QVBZV3Bo?=
 =?utf-8?B?elFvZTlQZWFqVGNiTU0xQkNUYWlDUXlDVWlVbHl2Z0lrditSbkUveUdxQzkz?=
 =?utf-8?B?bVFGSElSc1R3L3pQTzlXS2RJRGtaUDJaZWxtSzBKdEZkdjg2T05QaFhmSGUy?=
 =?utf-8?B?Nk5kcmNDZkljd3lXQ0srU0tXcW9HOTZQWUVHcGVjVXg4Ylpna0ErYmtoZUsv?=
 =?utf-8?Q?yO8fEmRkr1f2nxQQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e3b3d0-54a3-4771-3f06-08da4f286203
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 23:40:08.9418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Xt47FJ6BOHmPyi0PIvK42Jv0uGEmdOPhPzy5sQsqXF8mbq3JCPPy/Ml6PXjsJbFKs0PBzAzM2wQB+NOwoHkyESqe6q/wkN5178yTzL+j4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3779
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-15_08:2022-06-15,2022-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206150087
X-Proofpoint-GUID: G6gAqXD6wdDhO-kG14EKljsGEU6974vs
X-Proofpoint-ORIG-GUID: G6gAqXD6wdDhO-kG14EKljsGEU6974vs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-06-15 at 11:09 +1000, Dave Chinner wrote:
> On Sat, Jun 11, 2022 at 02:41:44AM -0700, Allison Henderson wrote:
> > Recent parent pointer testing has exposed a bug in the underlying
> > larp state machine.  A replace operation may remove an old attr
> > before adding the new one, but if it is the only attr in the fork,
> > then the fork is removed.  This later causes a null pointer in
> > xfs_attr_try_sf_addname which expects the fork present.  This
> > patch adds an extra state to create the fork.
> 
> Hmmmm.
> 
> I thought I fixed those problems - in xfs_attr_sf_removename() there
> is this code:
> 
>         if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp)
> &&
>             (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
>             !(args->op_flags & (XFS_DA_OP_ADDNAME |
> XFS_DA_OP_REPLACE))) {
>                 xfs_attr_fork_remove(dp, args->trans);
Hmm, ok, let me shuffle in some traces around there to see where things
fall off the rails

> 
> A replace operation will have XFS_DA_OP_REPLACE set, and so the
> final remove from a sf directory will not remove the attr fork in
> this case. There is equivalent checks in the leaf/node remove name
> paths to avoid removing the attr fork if the last attr is removed
> while the attr fork is in those formats.
> 
> How do you reproduce this issue?
> 

Sure, you can apply this kernel set or download it here:
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrs

Next you'll need this xfsprogs that has the neccassary updates to run
parent pointers
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs


To reproduce the bug, you'll need to apply a quick patch on the kernel
side:
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b86188b63897..f279afd43462 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -741,8 +741,8 @@ xfs_attr_set_iter(
 		fallthrough;
 	case XFS_DAS_SF_ADD:
 		if (!args->dp->i_afp) {
-			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
-			goto next_state;
+//			attr->xattri_dela_state = XFS_DAS_CREATE_FORK;
+//			goto next_state;
 		}
 		return xfs_attr_sf_addname(attr);
 	case XFS_DAS_LEAF_ADD:



Lastly, you'll need Catherines parent pointer tests that she sent out a
day or so ago.  Once you have that, just run the parent pointers test:
echo 1 > /sys/fs/xfs/debug/larp; ./check xfs/549

Dmesg below:


==================================================================
[  365.288788] BUG: KASAN: null-ptr-deref in
xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
[  365.289170] Read of size 1 at addr 000000000000002a by task
mount/23669

[  365.289182] CPU: 10 PID: 23669 Comm: mount Tainted:
G            E     5.18.0-rc2 #84
[  365.289196] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  365.289202] Call Trace:
[  365.289206]  <TASK>
[  365.289211]  dump_stack_lvl+0x49/0x5f
[  365.289232]  print_report.cold+0x494/0x6b4
[  365.289242]  ? path_mount+0x641/0xfd0
[  365.289258]  ? __x64_sys_mount+0xca/0x110
[  365.289265]  ? do_syscall_64+0x3b/0x90
[  365.289274]  ? xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
[  365.289649]  kasan_report+0xa7/0x120
[  365.289660]  ? xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
[  365.290034]  __asan_load1+0x6a/0x70
[  365.290048]  xfs_attr_try_sf_addname+0x2a/0xd0 [xfs]
[  365.290423]  xfs_attr_set_iter+0x2f9/0x1510 [xfs]
[  365.290801]  ? xfs_init_attr_trans+0x130/0x130 [xfs]
[  365.291178]  ? kasan_poison+0x3c/0x50
[  365.291187]  ? kasan_unpoison+0x28/0x50
[  365.291197]  ? xfs_errortag_test+0x57/0x120 [xfs]
[  365.291592]  xfs_xattri_finish_update+0x66/0xd0 [xfs]
[  365.292008]  xfs_attr_finish_item+0x43/0x120 [xfs]
[  365.292410]  xfs_defer_finish_noroll+0x3c2/0xcc0 [xfs]
[  365.292804]  ? xfs_defer_cancel+0xc0/0xc0 [xfs]
[  365.293184]  ? kasan_quarantine_put+0x57/0x180
[  365.293196]  __xfs_trans_commit+0x333/0x610 [xfs]
[  365.293599]  ? xfs_trans_free_items+0x150/0x150 [xfs]
[  365.293995]  ? kvfree+0x28/0x30
[  365.294004]  ? kvfree+0x28/0x30
[  365.294017]  ? xfs_defer_ops_continue+0x1c5/0x280 [xfs]
[  365.294401]  xfs_trans_commit+0x10/0x20 [xfs]
[  365.294797]  xlog_finish_defer_ops+0x133/0x270 [xfs]
[  365.295203]  ? xlog_recover_free_trans+0x1c0/0x1c0 [xfs]
[  365.295609]  ? xfs_attr_finish_item+0x120/0x120 [xfs]
[  365.296036]  ? _raw_spin_lock+0x88/0xd7
[  365.296044]  ? _raw_spin_lock_irqsave+0xf0/0xf0
[  365.296054]  xlog_recover_process_intents+0x1f7/0x3e0 [xfs]
[  365.296469]  ? xlog_do_recover+0x290/0x290 [xfs]
[  365.296757]  ? __queue_delayed_work+0xdc/0x140
[  365.296766]  xlog_recover_finish+0x18/0x150 [xfs]
[  365.296949]  xfs_log_mount_finish+0x194/0x310 [xfs]
[  365.297132]  xfs_mountfs+0x957/0xeb0 [xfs]
[  365.297313]  ? xfs_mount_reset_sbqflags+0xa0/0xa0 [xfs]
[  365.297494]  ? xfs_filestream_put_ag+0x40/0x40 [xfs]
[  365.297674]  ? xfs_mru_cache_create+0x226/0x280 [xfs]
[  365.297855]  xfs_fs_fill_super+0x7f0/0xd20 [xfs]
[  365.298034]  get_tree_bdev+0x22e/0x360
[  365.298041]  ? xfs_fs_sync_fs+0x150/0x150 [xfs]
[  365.298223]  xfs_fs_get_tree+0x15/0x20 [xfs]
[  365.298401]  vfs_get_tree+0x4c/0x120
[  365.298408]  path_mount+0x641/0xfd0
[  365.298411]  ? putname+0x7c/0x90
[  365.298416]  ? finish_automount+0x2e0/0x2e0
[  365.298419]  ? kmem_cache_free+0x104/0x4d0
[  365.298422]  ? putname+0x7c/0x90
[  365.298426]  ? putname+0x7c/0x90
[  365.298430]  do_mount+0xd2/0xf0
[  365.298433]  ? path_mount+0xfd0/0xfd0
[  365.298436]  ? memdup_user+0x52/0x90
[  365.298440]  __x64_sys_mount+0xca/0x110
[  365.298444]  do_syscall_64+0x3b/0x90
[  365.298448]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  365.298451] RIP: 0033:0x7f7e4e213cae
[  365.298455] Code: 48 8b 0d e5 c1 0c 00 f7 d8 64 89 01 48 83 c8 ff c3
66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b2 c1 0c 00 f7 d8 64 89 01 48
[  365.298459] RSP: 002b:00007ffee6811418 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[  365.298467] RAX: ffffffffffffffda RBX: 00007f7e4e345204 RCX:
00007f7e4e213cae
[  365.298470] RDX: 000056006007db70 RSI: 000056006007dbb0 RDI:
000056006007db90
[  365.298472] RBP: 000056006007d960 R08: 0000000000000000 R09:
00007ffee6810190
[  365.298475] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[  365.298477] R13: 000056006007db90 R14: 000056006007db70 R15:
000056006007d960




> > Additionally the new state will be used by parent pointers which
> > need to add attributes to newly created inodes that do not yet
> > have a fork.
> 
> We already have the capability of doing that in xfs_init_new_inode()
> by passing in init_xattrs == true. So when we are creating a new
> inode with parent pointers enabled, we know that we are going to be
> creating an xattr on the inode and so we should always set
> init_xattrs in that case.
Hmm, ok.  I'll add some tracing around in there too, if I back out the
entire first patch, we crash out earlier in recovery path because no
state is set.  If we enter xfs_attri_item_recover with no fork, we end
up in the following switch:


        case
XFS_ATTRI_OP_FLAGS_REPLACE:                                        
                args->value = nv-
>value.i_addr;                                 
                args->valuelen = nv-
>value.i_len;                               
                args->total = xfs_attr_calc_size(args,
&local);                 
                if (xfs_inode_hasattr(args-
>dp))                                
                        attr->xattri_dela_state =
xfs_attr_init_replace_state(args);
                else                                                   
         
                        attr->xattri_dela_state =
xfs_attr_init_add_state(args);
                break;     

Which will leave the state unset if the fork is absent.
> 
> This should avoid the need for parent pointers to ever need to run
> an extra transaction to create the attr fork. Hence, AFAICT, this
> new state to handle attr fork creation shouldn't ever be needed for
> parent pointers....
> 
> What am I missing?
> 
I hope the description helped?  I'll do some more poking around too and
post back if I find anything else.

Allison

> Cheers,
> 
> Dave.

