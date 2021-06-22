Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF82C2B9F4
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 07:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A58D16128A
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Jun 2021 07:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFVIBz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 04:01:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4292 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbhFVIBy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 04:01:54 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M7uF66002080
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 07:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/8TzaTydSBztGpGLxvdutA6+k7XeNoUuq7528Gc3G7A=;
 b=AHWdxfb+9b5Z3uUAqcDW+TNPdIAC84H3C6Wt77BiHnMJCFXg9iRgqFN6wLvOWsvAdr6O
 6GnYGODcrTOpILLSVMatM69gjD2doSMg9FyuxV6QfeV0S3KfgGoj1tX+7mmmLZ5YZSDa
 Va2nLQG0bbTUuEVh+8MOSCfZcGyI4+cOXkqkvZcUjz3QeltMNvDLtUOfaONgYnduMPAT
 PqPOVHAWdCJt54c3zaDiBRpPEOWjcbeDHDVkXEOUUT1TywGmXYlhEdeYuaWq8ZjoqdCZ
 hogFcpPek5V5Ni8H6M2hCnbm/MEsSz3vcv8AlMV3GUyiGtXI5NwmZY00HqgmgEn4LWKW Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39acyqb71f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 07:59:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15M7tQPS008870
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 07:59:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3998d70p4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 07:59:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARgCq/wSe40uS/EyhEGPpqiHEgmz+RuAlyo5jlMcqyNckSUNzJ4rmOMtPLGbJl82ko4TMsRmYFlKkSmVzcYtN7OCebYWaMr+/eVyhizHCq6M/b3Tn2ee8WDn+cUkhozN2WUK7EeB8u3bNmNQyhSZiKR98uudIQXs11wS6WDfdJxSfcofxwNoliqT0ZcYLyiNcFpFEV14lr/MJ7o41OD7p2dJYAHzNnL86qnEeijBrVRUwFce1Te5WHC35qxlUv0AKbWOhSdspZX8lkOgLGncgmymGMS/ngC9KM/LDW7HKinFF2ZkhBIfcq3pLsafj/wXzpwurT8u68tX/h/PoOk8+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8TzaTydSBztGpGLxvdutA6+k7XeNoUuq7528Gc3G7A=;
 b=PNJKhaJPvQY8ZJGk8pSLlKO/At7ON916wKtF8U/o3ZMqz18c8lqsVdm0Y6uIceTixcqL2DQknhltSStZaSpfsf6hY0AEcZILfw8G2AGXT80R3M/KQ2Rl/fgGOHinSUL6XdDFMWKpa/wx/CVfaIZIOfPRkEeJCJ2/EfKqVla6Qv8YSuOaD/RGZl71TAfxW5TStN64vfgKtmAZlm2JaWldmxsYzbuoMUuWGGqeqnwfhdbz7cSnQ/W0ZlpYvOrWnN4ybV+8F6cvSPhgxRolR/O3Y5VCTtecFe3DSluWh8qIX72ruQiNaS0ZfPZXpX+xFF/lLTtrcybGTU4wTi0qoA67Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8TzaTydSBztGpGLxvdutA6+k7XeNoUuq7528Gc3G7A=;
 b=u16FXYwIpmFZ21s3hFdgaoT2um8/wkwLpptUr32OrCzQWUTZ7xqrEKaTzZ+AJYQDPh7SaMJPv0L+l4m9Eb1oA+FrsVt5NPTieIKMUh+rLDL9TOqP3QJF4TfEdV5aGrnCtIwz7NSGzw/AVK6zYj6Jq7Dp09TwCgPgQ6sUY3Y4wjM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5454.namprd10.prod.outlook.com (2603:10b6:a03:304::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Tue, 22 Jun
 2021 07:59:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 07:59:35 +0000
Subject: Re: [bug report] xfs: Add delay ready attr remove routines
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <YMtaw9vsW69xGseU@mwanda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c4aca634-7a63-015a-1c2c-245b47e2ebd9@oracle.com>
Date:   Tue, 22 Jun 2021 00:59:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <YMtaw9vsW69xGseU@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0139.namprd03.prod.outlook.com (2603:10b6:a03:33c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Tue, 22 Jun 2021 07:59:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3d6d8ca-c13d-4548-5ef2-08d93553acdd
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5454BB3F67940B696C94F26095099@SJ0PR10MB5454.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xz7KTjcAAnyyasDhPUb59hT1wINbceNiIf98HMpWLF0p5cXyFEUKXVJf0rsm0b9hCz8HONcIm9HReBt4it++MC6sL95i/S3s1C1WQvos6jH8rUh2hr6UvalkgSsFgi5oDboiit1jNcsLHq5MZVaEnkYV5aHAqWZqJrchIVu8wt/nhVA2E+P0hhHLRsm5ylxneCIWIEOSaWjcpDLCSv+r0NcTqdQFrKRvJimBCIWuTtNg8eQuNnQAql7NrZp/2nuZKFuGNJxR6Ucxumy3zW1zMBEeEWvEa96jeuN0iEPrkdQPPaA1+bmVEa8lo+TQ42VpfmmSHsLom9CEw1jGWj2VevkrybGQ2xNizYLK2P3XI0r3mUO8OR+RJ/WrxZ2ET2oX3/LDrpMbrXml1dHeFZ5HrlXzDf5y3KcxMnqqVuOGC83qSZUmyO4N6YidjdAiaeNoiwKl3vto5AWSw8baEqXov+xUvqUCddct4ztuinNXb6HRLLSyY7sxrHFj7/VVxaukwZw5BcQ+8BnFEkzqqmv5XMlmwEFOgCb/Tn9UcSkNea5Q6Cv9bI82aLHTt+Sr0UDoOCPLhy1DKtF1Q3+wqb2MhQbZLNDQgzVBx6CwEXv2jJRvBKsL4kUEunb4Ae7uqy/vG62B2taXedt65RnQUbwToFcgDfIgL72Fq855teXX6owQCm9MLFAJxMS/SZy+iGH/i5wa7L4FanuT4o/NOYWuag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(186003)(38100700002)(26005)(478600001)(16526019)(8936002)(5660300002)(2906002)(53546011)(6666004)(66556008)(86362001)(31696002)(52116002)(6862004)(16576012)(66476007)(66946007)(44832011)(83380400001)(8676002)(4326008)(37006003)(31686004)(6636002)(316002)(2616005)(38350700002)(36756003)(6486002)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3FzUWc5ZGU5eGtLSmhVM3c4ZjUwTEVwcmdnSXpMVWxOcmVaa2J3ZFBubS9Y?=
 =?utf-8?B?TWhXZ3diQVJ0enBDYWcxZ1N3eFZYSG82Mk5OKytHUktJaDdUZkdQZFpaeDZC?=
 =?utf-8?B?dWF1L2t6a1VhVnNCZ2NlSlBPbitKS3hlYlhqSTdIVVcxemFrS0JqVzJCcXBP?=
 =?utf-8?B?RjVDMEl3NG8vc21BWnAxYzBaV293NkVTTVZpT0xpQkZtOVdyci84UHRod3Bo?=
 =?utf-8?B?dVNBUkhrcUdSc3BxalQ5MmtmQ2Zlc0dPbFlzaFVqWFcya1B5NWlVdW5vaDQz?=
 =?utf-8?B?NmtMb3lwa3ljZjRJTVZnR2VzSmtMbW5VS003Wkh2VmpncW16b1RhQXMwZWJP?=
 =?utf-8?B?Mk5IVDhqNXV0REE1ZlluNWt1Mk1EQWdjS3RhUzBsZkswQXRRMWc4azZ2Z0ly?=
 =?utf-8?B?VWFFWXFjQWlTdXRnQ09icmtxTkMwemxCcko3Nml3MnlsSk1ISDNSd0JZb0kz?=
 =?utf-8?B?Vk10RUsvVTcyaHRvbjl5eCtxZk0zQ0VFYStnSjFpcmM1RnlhUVFHNUpDVjhw?=
 =?utf-8?B?d1RxTVE4K2FUM3hiemc5cGlWRExhVmV2ZWF6RndZUWhHbXBGYWZ5bVNZT2pW?=
 =?utf-8?B?QmhoblRWVm9qWm13SzgvK3lKdWZpei9jR2I2QTlhazN0N0xId0g2c2NsNU9q?=
 =?utf-8?B?OFVSSVlhajFjNGJiYkY1bkVQOVJnNU1GY21Yb1NQcWRsWGxpSnNTMjY4SWNz?=
 =?utf-8?B?WjI0WkM0eG9nVUthU0lxdUI1WFlpT2VwZU8rWE5ML0xHZ0dVaU1IQTE4eWNY?=
 =?utf-8?B?SGZBS2lDcmxqUjc2SVppK1JUSWphZDRyajBadnNTNmcwSmtDek5vVUg4WlZK?=
 =?utf-8?B?NlZzOFh2eTlWVUdBYjBqWTgrZHQrd3pSSnNhS3FvT2dKL0xlMFRjQ2kvbHli?=
 =?utf-8?B?dTlaL1ZOanVIM05CR0V0RGpvcVhsSFBWK0c5ZS9HTUJ5SVpPZEtaRjVZUmJL?=
 =?utf-8?B?MjcveWYzbUdhQzIxaXhSWU44M2JKNUFGbXp5cGlYcHZiT1ZCVkFLM21XdzNm?=
 =?utf-8?B?YWVISDhGN1NXVXFXOGlWREY4R3k2SVp2Z3VWQnJ1OGkwUWJTOW9SR2dyR090?=
 =?utf-8?B?ZEVhSElCQVpxbVVhQ1ozcUhpek84dW9jTERFUE0zY3VZZGRpOHBJZ3dxWGZJ?=
 =?utf-8?B?R1Z4MEE3ak9OM0ZBaU15c1RUdU9paFMxaTBxY2pPTnJvL1lCRStjRGtsQzVW?=
 =?utf-8?B?bUlrSDJNdndnNVozSlJKaWs2ekl5QzBEMHQ4enBKNlJKYzd4dm5TYndvd3ky?=
 =?utf-8?B?aEhqVzhQdG1xTVhZTkQyakFOWEk2d2lHQmtxOWk3bXI3OU05aU55MS9ybktr?=
 =?utf-8?B?c2o4WEtEQzNvYWR4SUkydUtwWG5EdEVVVzZSdnA0UStYcXZXUU1rUXVEYkFP?=
 =?utf-8?B?ZHExWlJ6cUE2b3dyRDQyM3ZDNWwxYjE5U3NPNzVTR0NJa3AxNGZxYTJJdFBv?=
 =?utf-8?B?OGYrNFFqTmlZWHR0bUNwSmdFdkJDd2xLZVc0d09XakJDUGhKUzhrN0tVSVVx?=
 =?utf-8?B?Q3dZUGd6WVpxN082bElmY3RvZDVQTCtScVdEdGtlS0JkSlFZaUU2ck4yVXVR?=
 =?utf-8?B?eE1FTVZKRlI3b215UHMyREU3ZHNvdzRXNVlIQlcvanpkeEZrNUt2cE9JVG9a?=
 =?utf-8?B?elNXQklSOVJBckxJc1hYZXJ3SUVOMlJ6VmN2Z20yZVZZcktNTjNjUlBHZGZk?=
 =?utf-8?B?dllmTldvU002dXRzTTBET2JRemRGQm1najFyVGNPaE5NODhyZnRQMC8zeWJT?=
 =?utf-8?Q?AumfW9h7D1kKYSuh5pypHcnyuDTeuboSaq31dIO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d6d8ca-c13d-4548-5ef2-08d93553acdd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 07:59:35.2773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejXcLkjazY6BInBPlJJRzGUyE8eazkj3Tc/pUm/v8fqraXD/RitnfvcPE9zSxHFz+k69C3i1Ajf9trRfEivdienqQ6+wPbzMgKCVWrvbWZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5454
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10022 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106220049
X-Proofpoint-GUID: NQ0huI7lkcsm-F_auhT--_MpGscTVZi3
X-Proofpoint-ORIG-GUID: NQ0huI7lkcsm-F_auhT--_MpGscTVZi3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/17/21 7:22 AM, Dan Carpenter wrote:
> Hello Allison Henderson,
> 
> The patch 2b74b03c13c4: "xfs: Add delay ready attr remove routines"
> from Apr 26, 2021, leads to the following static checker warning:
> 
> 	fs/xfs/libxfs/xfs_attr.c:1481 xfs_attr_remove_iter()
> 	error: uninitialized symbol 'error'.
> 
> fs/xfs/libxfs/xfs_attr.c
>    1469                          return -EAGAIN;
>    1470                  }
>    1471
>    1472                  /* fallthrough */
>    1473          case XFS_DAS_RM_SHRINK:
>    1474                  /*
>    1475                   * If the result is small enough, push it all into the inode.
>    1476                   * This is our final state so it's safe to return a dirty
>    1477                   * transaction.
>    1478                   */
>    1479                  if (xfs_attr_is_leaf(dp))
>    1480                          error = xfs_attr_node_shrink(args, state);
>    1481                  ASSERT(error != -EAGAIN);
> 
> Not initialized on the else path.  It should be zero right?
Hi Dan,

Thanks for the catch, I just noticed this report.  I will sent out a 
patch initializing error at the start of the function.  That should take 
care of this warning.

Thx!
Allison
> 
>    1482                  break;
>    1483          default:
>    1484                  ASSERT(0);
>    1485                  error = -EINVAL;
>    1486                  goto out;
>    1487          }
>    1488  out:
>    1489          if (state)
>    1490                  xfs_da_state_free(state);
>    1491          return error;
>                  ^^^^^^^^^^^^
> returned here.
> 
>    1492  }
> 
> regards,
> dan carpenter
> 
