Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2A2C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 06:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A80076124F
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 06:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhKEHCW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 03:02:22 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37278 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhKEHCU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 03:02:20 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A56NNS0031739;
        Fri, 5 Nov 2021 06:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HOx4jPxHxF8QRzFKrhGEM9JcCmDXHACeZO2JaglZje4=;
 b=H9rF3CUGRl3aoAYqLzgyAcGPFYALuBQ92Aqx1uvvHCwI+tFNEMt6aTgNw8v4YZXvMUIf
 CJ25Bj3UsyfIJbW/MzPscd3A+IadeNW0MkiHewt+KY9MwSmjHpimrA2pYUJByp/1YSMw
 Cnbj146nPcpXOKSdFgCiPycXvamBMSudAg7vAOnxFuJPEbOVR8KxO/vk5TlikCBxaMB5
 QdFFQsMHljtSATI39QMnu2q8uoKWKlFn52u/4jD/J1RGt/cCMUvBjGVF9HqhmdPMOatk
 RLwg2PfkPAMp6uGIf/h2/mm8ZF0olBwJqNlAsVg0+uzmsD2+Bo8sDGxDJK5u6C1Iyo+H 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7e110g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 06:59:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A56oORF162126;
        Fri, 5 Nov 2021 06:59:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3c4t60ub11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 06:59:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cH/TQKP7iXdzLbWQJeYkHAKKi9t3s1BPO+pTwFAR6SQ+RZIVyQJoyvbV6ypUfKmWnE3VmB9fnJif4/6WGHm18Q4rykAkjf1CjBHviw+htsZ7NOv8654LLtJIN1U7L1eWc7neJucbVL0tcY+sKNIa8oOk3HUioC/GmawBlxQiUVNcCKEBwHDhyHqOxFwiPalEKnrQruvim5/kIF6hgVzZCgxWnUqAw46vX0SZ26vKNBXFpnZn0MfXvCbvWZWLSuVfb1jBxFRKGN+Eu+2EIKDLqpYi4KgYSIBcdI93v7FlAH4+JYXs+2jM49dKo6Nx/Xk0c8oLAz2G+2QMgveHW92kSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOx4jPxHxF8QRzFKrhGEM9JcCmDXHACeZO2JaglZje4=;
 b=LjhEnrHPxvlaVfKsr3zf4io5nm+zDgTcvroZJVje6PqvPUs4p60vonvLfOxWBMl2S4cgyM+TlADkepgg0hl0PWMNx1l77O1jqUkIeCRaqWICNrmv5pdXfdSpta2/tLKNBnJnAR82GUU+cF4trLyGnSppvroSZLS7fM17c0YnUnmaP3gH6Kq/IC+yEZuuO8CD2Q7s1B1zQq8NcPzCSGGsk/EiCc+8K5GvkRMQGMuESdnIE0Jr+9Bk/C8MGiVDVwK4AkkVpZwVHTDn1Uxis6nyAc0uguF7zKqNXFYp00Fu5uLPaEgofjBnhY2W1/VVfMmbbJ+nhNZhjDwAbJxYSHbxYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOx4jPxHxF8QRzFKrhGEM9JcCmDXHACeZO2JaglZje4=;
 b=RMLID9alnfG5tHmvQkodE2goJDe0qaGSA/vzrPscPEFerCTsfB81K+jpBo9ykCerDtLhWy2kV/z3M6tmEhTidNhnyyfXCKsXqQ9L8+gLG1Aio4GI/dZRNsGmziKuIjd51QKAnKaNJ0gjGN+Bsqo2LFX8SghE4sAdJu2YL5mHdP0=
Authentication-Results: fromorbit.com; dkim=none (message not signed)
 header.d=none;fromorbit.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3511.namprd10.prod.outlook.com (2603:10b6:a03:129::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Fri, 5 Nov
 2021 06:59:35 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 06:59:29 +0000
Message-ID: <6f29c9ae-c344-9642-cd47-42a85225b1da@oracle.com>
Date:   Thu, 4 Nov 2021 23:59:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] xfs: Fix double unlock in defer capture code
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20211103213309.824096-1-allison.henderson@oracle.com>
 <20211104001633.GD449541@dread.disaster.area>
 <20211104013007.GP24307@magnolia>
 <fc3c7b3d-42a2-1901-280e-2a99c3b49226@oracle.com>
 <20211104221818.GE449541@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211104221818.GE449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0049.namprd17.prod.outlook.com
 (2603:10b6:a03:167::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by BY5PR17CA0049.namprd17.prod.outlook.com (2603:10b6:a03:167::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Fri, 5 Nov 2021 06:59:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6fb7f86-5834-4459-8263-08d9a029cfb3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3511:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3511C8C2A55A4135449CE8E9958E9@BYAPR10MB3511.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmYMFZ/hYFnEV7drWoeFwoOzC6/oRObjaqNcCQ+HVccjJo1rXFGYXJ2dueWMHaTV9MT79I9v5iecljBY0/c9YrnQ/ytu5sOVTlWfKTQ0s/KNj4pqTFs0ukM/SwNgS/RxdUeJ2fUPyB9OmPZdN4htx5lmSu6iC2hkGLFLMJePPM7zTiCTt7XL7EXyOCBBQcuENcy3YvU13RPflWD59+25n1KqCY5AVn5M/zJakilReOMxOfoI5C73NLRgD4+VoFEnx6SYvtZNwsdwPUomyVKRwBt8BOrqOizgA/qXNgNJ8P3EiVE/cAnKJpjWbth94E4QfDgXJd6IY72aIs66eMGJj0NR139f/w89klwBkGEA3KdMIvvAYsrp92rkTamN98WdKomAgnCnFbvOFA8w2LtiSdoF6RNygV71j4e8ZnYam0BwPtnZwFBEcrk3uDAC+LYYGlvcSBg9JTbnDmjfoW78HyLcYScRbQra4sK4XEpq7jHADNxuYfi+OHjeiA62VsCupMbP9Vx+J5ybOKY0B0sulbERjvQoEhF0+QeMX8uALRQfLZ4I1syGgOUBNoDu2oiCyv+XQS3buwJZdZrakIrYtoTq2IxJgQEXcnsWzOklcLvOvQOm1IUIn5Z5GOk4XBkhYW3E9jTn1iZMMzMkIIBd8StPpgVhuzkZr7H4Kf1i8ZfRITGkNLQAgBHVSDQZxL22eBMjN2TwW6PVw1rGeL94EoOWqJ8MbuaqwCfMk1YsS9/4JTLM8nY8wV37r7xghRrw/KViAOUc07tZyt//EqCCWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(8676002)(508600001)(44832011)(5660300002)(66476007)(2906002)(66556008)(26005)(83380400001)(6486002)(956004)(186003)(2616005)(31696002)(8936002)(16576012)(38350700002)(66946007)(6916009)(38100700002)(52116002)(31686004)(4326008)(36756003)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFg3ZHBIMnE5RGtXeVZ3TTkvU0ZpcXdPdmUrK2piZkZ6MTM3R2liUERML1Bo?=
 =?utf-8?B?OS94bDlidzJjeVpXTVJuVlRvVUcwNkhWZUgzR1VIaDJLeU1NNzd6SlllMG5J?=
 =?utf-8?B?eCthQytwTUdyQU1rNE9IamRvS0F0TmpUQWp2MCthdExPYkMxc3NEVXZxeTZV?=
 =?utf-8?B?S2xrNWtLamVURkJFYWE1azZTRXplZzIxSlIzcStKVGowWWZqK0RrSWVZeWlz?=
 =?utf-8?B?b3o5cG5Wc2E4c0o5Q1RBTjFwM1JGTHZUR3ZhQWhVNFFKY2hpUFdLN2dNRVdt?=
 =?utf-8?B?dlUyQW1qREVlSTlrbVRvVmNxVG83L3hZazhFU1pPdXp4c2VGY255VVExQjRE?=
 =?utf-8?B?VXQxVDVvK3VvYUxORXNDNXV4N0s5bE5GSjNQQ1IxMGQxbm1vQzRWYXk4SzJS?=
 =?utf-8?B?SmRxRXIxK2NFRDhRWEZnUlBwWW41Ynl2dVgvUEpEVjh2TTU1YVlPZ0ZRT3hF?=
 =?utf-8?B?OHVlQkU5R2VERzhUMkhtblZrSDBydmtsQXdsWFE1NVlMUXo3TkdVVktyd3BW?=
 =?utf-8?B?ODhyazJabE1rVnJDS1p4QW9uQUs0aG55WWI5d25vMUlBeDhjc1ZEK2Y2VXdF?=
 =?utf-8?B?bkNJaDhmYW1Rc0NTUDc0MjhRQ3IydXN6QkZKenFLNjlwL3ptT2tjaE9pdGpw?=
 =?utf-8?B?RjZva2lVb3JLN1ZsUm12Tno2SCt4cG5hL3JWYjM3aXFhVU1XTWJZS3FSdVJH?=
 =?utf-8?B?U0NabHZKUE5aNVVKbHF5YkozdjBVdlpIdUJmNDZVanREK243QndQbi9sLzRm?=
 =?utf-8?B?dXVCUDgrTno1MEJLbmlncWRrdE12SDc0RWEwakRieVg5YllieWFqRHpXWTlm?=
 =?utf-8?B?TElRNlFvMDZQdWh0MWRXeHRmSlAzb2tITTBvV3JqeU1yaHpWWk9nUStWSGdj?=
 =?utf-8?B?ZmxPTjVVaElpV1c4WDBDVE1GY3MrWEZXaUp5QThTVkdES0llczBwMTg0RHdQ?=
 =?utf-8?B?OE9GRVJnc1dmV0YvKzNkNy9WeC9tTXhlTGQ2aG1saFNEZXFSVjlWTEpsTzNI?=
 =?utf-8?B?ZVBSZG9aOVlyVFZiU0FKcFRHWjZHSUJ3RkkvSkNWcFhSbnRYL1NmVVorM2dC?=
 =?utf-8?B?bkw2V2phVFZyYVhvODdpYys0Y09wdmJ5dzVXdmRZeWUzRmV3U3ZacUpTWXcr?=
 =?utf-8?B?NkpTaDRoMTVvNk4vTUthQWtyZVRra0VJa3RUVWhpK214aVI3VHJrMUlHY1VT?=
 =?utf-8?B?WUU2MVZNbkNUOXFuMkpEZWhxM01kM2NxK2RYc2t2Z1lYbW1yT295Q2QrRjhp?=
 =?utf-8?B?RWpSTjdWZVduT0hXZGxneGhhTXVUQUkvcElCbmREVit0U0VjUnE2cGphcXdq?=
 =?utf-8?B?TmVQcnBPcjBKcWNEMUJDQjRJazdmVER1L09sUndPYjZVYXhKNHhBbDVJVG1P?=
 =?utf-8?B?M3RIVStSL0JkbnlPMjlzcm1WR3JYZWJSbEUrQVpZaWsxUjFiWGUyVldKNjc3?=
 =?utf-8?B?eFZoSkQwV0h1ZnpnK3RXSFMzYlpodDNRL2U2b3VVTS9TN3k4MStTM1FYK0I1?=
 =?utf-8?B?YkIybTBBQThtSGlFU01OSm9EWTJqSWdiYWM1VktzVkQvK0F0dlhJQ2dhbHpZ?=
 =?utf-8?B?VVFEcmxoMmhEMmQzaDJKcUg5V2c0ZkRDemhOZWpXNll1OHZMR3RJWVNPdWtn?=
 =?utf-8?B?T0tMR0hGOTQrSXdFQzRKSHduWHJYMjRpSEhlWFZ4YW9YZHVXZ2VzS1l6a214?=
 =?utf-8?B?SjlaTnZKbUt6czFaZEZwWDVvUTZ2eWpmb3FTdHJTaGtRZDE0cTh6SWFsbGNm?=
 =?utf-8?B?TFBFUWxoTHR0S1VQdFBpSkZuT0pwd0hteU1ML1RzOGE3OGZ5OXpTMTRVRzMr?=
 =?utf-8?B?M1JqNzNwc0VFbEtJcDNVMFJmekNTMHNhN3FJTm9uaCs4WDI3TnU5Y2RCS0o2?=
 =?utf-8?B?UEgrc3VJTmlaUW9CSGFZQW1YRXpHZkZ6cmhjMGR2eVlzc2I2c0p1MTlMcFl4?=
 =?utf-8?B?R040K0MyYXZlLzdKZXkxR09ZRjBOUzFvZDlYdG5YUUtGd1NDUVRyenoxNXp3?=
 =?utf-8?B?K1Ewb3hVRGU5eGhTT21GUmlkeUkxUDJrb05rdDhvekVGUE00ditNMUJRWWdj?=
 =?utf-8?B?cTRRb1VMMkdqanIwSzB0cjBIUUVHaUJHMEhCRjVXVTJNaXVlaGMrbjlrZ1Qx?=
 =?utf-8?B?aDVFSS82bW5aQ2FGM3c2M0MxNzZnV0JCNVVOWEdDd1FOeHZIQ1o4d0hsUkRo?=
 =?utf-8?B?WS82NFB1OU1RdDU4amt3dEpyMG1RcDJQK2o4djJmYlZiVEdCcFlROGpKbDd4?=
 =?utf-8?B?VXU5N09zTlRHY0NtdFNocFdkdENBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fb7f86-5834-4459-8263-08d9a029cfb3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 06:59:28.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4pi1pgoN6QQRROvLb5Kb6ZS7gYPDVmdXl9ltAA6lSsfDu7LOjsx9OjytLdwG82RClNJO2QZF/wnysh4UCM+C18u/D4pnt4Y7ErRP0Rcbvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3511
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10158 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111050037
X-Proofpoint-GUID: D6lRkrqjiGZrrTTETLohXrPDtWaJ7InO
X-Proofpoint-ORIG-GUID: D6lRkrqjiGZrrTTETLohXrPDtWaJ7InO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/4/21 3:18 PM, Dave Chinner wrote:
> On Thu, Nov 04, 2021 at 09:59:50AM -0700, Allison Henderson wrote:
>> On 11/3/21 6:30 PM, Darrick J. Wong wrote:
>>> On Thu, Nov 04, 2021 at 11:16:33AM +1100, Dave Chinner wrote:
>>>> On Wed, Nov 03, 2021 at 02:33:09PM -0700, Allison Henderson wrote:
>>>>> @@ -777,15 +805,25 @@ xfs_defer_ops_continue(
>>>>>    	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>>>>>    	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>>>>> -	/* Lock and join the captured inode to the new transaction. */
>>>>> +	/* Lock the captured resources to the new transaction. */
>>>>>    	if (dfc->dfc_held.dr_inos == 2)
>>>>>    		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
>>>>>    				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
>>>>>    	else if (dfc->dfc_held.dr_inos == 1)
>>>>>    		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
>>>>> +
>>>>> +	xfs_defer_relock_buffers(dfc);
>>>>> +
>>>>> +	/* Join the captured resources to the new transaction. */
>>>>>    	xfs_defer_restore_resources(tp, &dfc->dfc_held);
>>>>>    	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
>>>>> +	/*
>>>>> +	 * Inodes must be passed back to the log recovery code to be unlocked,
>>>>> +	 * but buffers do not.  Ignore the captured buffers
>>>>> +	 */
>>>>> +	dres->dr_bufs = 0;
>>>>
>>>> I'm not sure what this comment is supposed to indicate. This seems
>>>> to be infrastructure specific to log recovery, not general runtime
>>>> functionality, but even in that context I don't really understand
>>>> what it means or why it is done...
>>>
>>> The defer_capture machinery picks up inodes that were ijoined with
>>> lock_flags==0 (i.e. caller will unlock explicitly), which is why they
>>> have to be passed back out after the entire transaction sequence
>>> completes.
> 
> I'm still not grokking what "passed back out" is supposed to mean
> or how it is implemented.
> 
>>> By contrast, the defer capture machinery picks up buffers with BLI_HOLD
>>> set on the log item.  These are only meant to maintain the hold across
>>> the next transaction roll (or the next defer_finish invocation), which
>>> means that the caller is responsible for unlocking and releasing the
>>> buffer (or I guess re-holding it) during that next transaction.
> 
> Sure, but buffers that have XFS_BLI_HOLD is set are not unlocked on
> transaction commit. So this makes little sense to me.
> 
> A bunch of notes follows as I tried to make sense of this....
> 
> We have deferop "save/restore" resources functions that store held
> buffers/inodes on save and hold them again on restore via a struct
> xfs_defer_resources. This is only used to wrap transaction commits
> in xfs_defer_trans_roll(), which means that the held objects stay
> held across the entire transaction commit and defer ops processing.
> 
> Then we have "capture/free/continue/rele" which use the same struct
> xfs_defer_resources but only takes direct references to buffers and
> inodes they "hold" and rather than transaction scope references.
> Hence before commit, they have to be relocked and rejoined to the
> transaction. Ugh - same xfs_defer_resources structure, different
> semantic meaning of contents.
> 
> Uses xfs_defer_restore_resources() internally, so it joins *and
> holds* those items at the transaction level, meaning they do not get
> unlocked by the subsequent transaction commit.  And then it is
> committed like so:
> 
>                  xfs_defer_ops_continue(dfc, tp, &dres);
> 		error = xfs_trans_commit(tp);
> 		xfs_defer_resources_rele(&dres);

I feel like the part that's getting over looked here is that the attr 
code acquired the buffer in the middle of a multi transaction operation 
(when shortform turns into a leaf).  It holds that buffer across the 
roll and then lets it go when it no longer needs it.  This is something 
that the underlying attr operation is aware of, but the capture code is 
not.  So that why it needs to leave this for the underlying operation to 
have control of.  If xfs_defer_resources_rele were to release it again, 
that's where we get the double unlock.  I hope that helps some?  Unless 
I'm missing something else?  (i am sill recovering from my booster vax 
today :-p)

Allison

> 
> And then because the objects are held and not unlocked by the
> transaction commit, they need to be unlocked and released by the
> xfs_defer_resources_rele() call.  But we've hacked dres.nbufs = 0,
> so buffers are not released after transaction commit. This makes no
> obvious sense - transaction commit does not free/release held
> buffers, nor does xfs_defer_resources_rele(), so this just looks
> like a buffer leak to me.
> 
> [ the API is a mess here - why does xfs_defer_ops_continue() memcpy
> dfc->dres to dres, then get freed, then dres get passed to
> xfs_defer_resources_rele()? Why isn't this simply:
> 
> 		xfs_defer_ops_capture_continue(dfc, tp);
> 		error = xfs_trans_commit(tp);
> 		xfs_defer_ops_capture_rele(dfc);
> 
> The deferops functions are all single caller functions from log
> recovery, so it doesn't make a huge amount of sense to me how or why
> the code is structured this way. Indeed, I don't know why this
> capture interface isn't part of the log recovery API, not core
> deferops... ]
> 
>> Ok, so should we remove or expand the comment?  I thought it made sense with
>> the commentary at the top of the function that talks about why inodes are
>> passed back, but I am not picky.  How about:
>>
>> /*
>>   * Inodes must be passed back to the log recovery code to be unlocked,
>>   * but buffers do not.  Buffers are released by the calling code, and
>>   * only need to be transferred to the next transaction.  Ignore
>>   * captured buffers here
>>   */
> 
> This still just describes what the code does, and so I have no
> more insight into what is actually doing the releasing of these
> buffers and why they behave differently to inodes....
> 
> Cheers,
> 
> Dave.
> 
