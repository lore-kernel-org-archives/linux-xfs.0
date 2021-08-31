Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EFDC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 19:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0494261074
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 19:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhHaTEH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 15:04:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26506 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233231AbhHaTEH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 15:04:07 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VIiRVQ002296;
        Tue, 31 Aug 2021 19:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IUkT7K1znp8R2Zyrqbu/0dmb2uJyWhiAZjhuNnIGRVA=;
 b=h451knqDaSv040CBHM3IQ+OrntMFh0xxEVQrg0A/1qyT02b6anoovA0Q/CYKC6nLOAWO
 9TkZrxkdO+xLbvAmLSOH4X876tj1TIfDa4IR6xOxR/GposbmhGs0+Qz2OPqB1cHCGFS1
 bEcpDtlprzGztuEnNY9wJMpu5rTAlFDsq+l+4mEmB9BtPye8JALOEMkljjlDbmtmWk3e
 vm65c+3kswvimNp9hIHOYsFF7Rlqh39aK7jrjWrZ0eqMB+lPCtGr64S8JMuu8TAg6Vt9
 r8t4+ZUCPoxad+7nFTPIeCSdb8UjpHJNbi08qjiOiQuahpHyyxD/U2PULCXmNOSP1EFB 2A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IUkT7K1znp8R2Zyrqbu/0dmb2uJyWhiAZjhuNnIGRVA=;
 b=xhCzFQ6c+iFll5w84z4iPYohMo9E3Vmk2ZOSs5iwzsSwnyJ0TyVS6TVxZPp9xRHsoBQX
 9M8uVspHtNouR60FmHvbcS8TSsz55U4BlmMJVLFqgARKmWNavRy9kv33c5W01JVGV2AT
 e4oFdUDEDI+ARBg+BewYgH9rc81lO2IzslP4xSvQ4JTdq+tDbsfjgSwDMrn+JiJ1HpZ1
 POHUi2Azy1pHlqM24/5iGpqdXpk2+J/WTQc28zZyJhc1NQoS92n/APaKFz11b641pqzF
 B9O/299jsirdKVrRxtsXJpTUihgq/YsxW5LtUYs7/KpWwAf1ZZJtxjDg055HT0uf8wQH VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3asf2mj0vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 19:03:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VIpcDH127126;
        Tue, 31 Aug 2021 19:03:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 3aqcy5979t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 19:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXqn4PHL+cocYU0Eu+Jhm6Hqam+Moiowo6ta5aWGH6fGqyOJQ8+HGF/jFGZa1mqWlBqDmtUSdg1pvjix9GbWf3yZ9hUeepAaHh/tqi7jNjJerq1wOUwpgKsoIfO0MVGa2EvLw2Mts75rESU+u9udHGwOmVMnbrMej9CKgyCt+NMTcUBC/Cs3zeMouISSkG8iaZa/wq7B2Tis7Bdjdlw8rtSYpPhHU2UpdrqSbj16U7VlRh1OQ0+hof5VZzdlu0Cux4fCQDVKPQgM30EGouB7rtGxvRNCfmPLvcuAHUTGojwYnljbjrfSjVR5R9lHS1jjkAZCuGzzbvEBkiKDQvf2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUkT7K1znp8R2Zyrqbu/0dmb2uJyWhiAZjhuNnIGRVA=;
 b=JwAJgys8q4NPlQhpxRcOHjwHVb0w3grYmo3wwbynEbhcEGDtWHvQ5cnySEMGSPYtx0DfB/EN3M5Qv4m+AEDjE88sGv8K108khUBf336FpIV/iSvuSv2acbRPm0OlICEDVhGOH52gmXJzfIwBka549XJJe1Af8Uc1VAK4XVXAe8zP07aJc/NnzOKgsbjIVNu9aTqi+PyU7h2X8lVrtW9UMMzNiVc5OaINh1vIQBtknbcbLl1/28jfSUul6CumrMvwqzP6OXTOxISO23Y3UuEdle9UdVo5wsCJQ3tI29+hcbWFuruyMGh6B16tZ7bG9EWelaIDcU1O39vAtN1cRvkqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUkT7K1znp8R2Zyrqbu/0dmb2uJyWhiAZjhuNnIGRVA=;
 b=k0MkLOigS296mwjUT9rHaMPglOsY3SKnI9Zhd0ddEY7anX7eLseB0rrTRVZHsFehyqYpg/GDNledLgsHmfMiXOmrUlyqZzRvW1WnqJ8FAGobSRbUOYDs0ztjv6m4f6K2/sGniQ/AZI1mFb+aKoI46ObK5QblwiAu+53lyr0fjWE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 19:03:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 19:03:08 +0000
Subject: Re: [PATCH v24 03/11] xfs: Set up infrastructure for log atrribute
 replay
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-4-allison.henderson@oracle.com>
 <20210831004851.GT3657114@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <2bc0d0a8-a6c9-0d1d-fb7c-89b6fc549907@oracle.com>
Date:   Tue, 31 Aug 2021 12:03:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210831004851.GT3657114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0057.namprd13.prod.outlook.com (2603:10b6:a03:2c2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Tue, 31 Aug 2021 19:03:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e03db96-324f-4bb3-bc93-08d96cb1f872
X-MS-TrafficTypeDiagnostic: BYAPR10MB3669:
X-Microsoft-Antispam-PRVS: <BYAPR10MB36690E496545728710C4201795CC9@BYAPR10MB3669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1WPQ1BExGLBOwQKW5AejtwvDku6n+230YmxWyiH5HXyB3op3BXXRYT7r12Y9JbMMH4ttw8eE4u6iQSNEreGS91oiS6OtGOCuaitH8XTIhr/soiDeRrAQ17QfO7jkWgkFvFQW5gQ48P0wf2XqFPUvTL7WcH0soMwZZtBfZ0TrbvMqDJ6hu9pD+l2f4sz82gdvP03/GSJOErqpC2BS6a2niew7VDuZ8qe3WMTuF5gRU4S6XDSotoo1Yr2TH5+PFvPAxvFbqJWVoy3THERV1tDN5gdqN3V0ArY5WMbgzPYQm40bard6X26I5Opbv6aGOLNy4lWFhjwdOTIJi4hdDCrX+VxfGoDmqOqOcO/U28PpquAauGsUiZ1OWL+Xh1C8QtRynMlmFI/bQBwzFI2AdGRKQcGfi5SN4RP+IrglxaXdrp6MUTFvLgAAi9weFPPbgmBX6PJocwjS8nmLxI4RhgWqoBFxN/4i4svEj3spZLcNkcV0VkeFjxXUN5nwkIVx3Ui4mU93BA3EOSFfpaeskudbgDYjVk1B7XsvMX0DXckcqlK0jtpdZQ7XfgXQdBS9RdXXKyN8ndRYxbq/4g7/0/lpQtraoprzg6R3etyLrsOeO1O16S6lxtImARK8+MApf/iRrvAk0mHabFLbbe9+YGNvvflyenLzX6z9wbTtk5iwWLsMk4JQMxG1/sN9RNPe0iBgImVHYcQoNanqUD8kMEedYuF9by0DunRyvNNhLbgkBt4k+5relYvJVgdulV0rMgaJXYzzEjmHcrpMo5aPZHWAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(136003)(376002)(6486002)(66476007)(31686004)(2906002)(8676002)(4326008)(38100700002)(38350700002)(86362001)(8936002)(316002)(5660300002)(956004)(6916009)(66946007)(36756003)(478600001)(2616005)(52116002)(31696002)(186003)(16576012)(44832011)(26005)(83380400001)(53546011)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGtOL1ZHeVNpd21zbTc4M0l5ZzJJRjFTTjR4aGZ2RElWaDAzUUtCdWRaYkVW?=
 =?utf-8?B?eGZmSUlORjQySU5CQUNjWkVnMXE0VjVxQjFIa292SERzaWJheXZrUHlFOEY0?=
 =?utf-8?B?ckVONWUzUG5iRUowYnpVSGpGdlpqekh4MmtFcHh3WEp0K21ZeVhCVFVjc3J6?=
 =?utf-8?B?NGVIZ2R5TmF3Q0dWODlEdUdVejBpZHBuTlhNd1g2UTc2M1cxNFc0azA2azZv?=
 =?utf-8?B?ejFQL056aG14RDhwTzJmWDdObUVsNWdpQUthSFVxWVhqL3FhMlpyUFI3ZVpH?=
 =?utf-8?B?cXRueXJ0UU1mdEliUUpTQ1lRanduTldmWUc4bUhsWVAzTFdBTWNnblF3eWtn?=
 =?utf-8?B?cVc1b1ZMVzZ5WTh0TnJQcnROWjdFMmhMeGRndlVIQTlBSUVrc1FCYytTZnZZ?=
 =?utf-8?B?TFdOMmZDQkhYbVRsMyt1M0txVzVQWmNTaytJakRnTEdCeXc5ZDI5cjUxemFw?=
 =?utf-8?B?TUltemVkSHZMY1o2SjNSV2xTeHBBenhXSTY5TFluc3VuQVU1ZzRQQmZkV1o4?=
 =?utf-8?B?MVZWYUhzNlova1dZaVRVbTYxRGtnRTVWMk5OMkZtbTQ3Vk1HUEtJMnBNVjNy?=
 =?utf-8?B?aitWekkwdVZyckpuQWpVYkR6NCtvcnRxazNRSzF0Q0tHV3VyNWJ6d2piWVZa?=
 =?utf-8?B?TnRrUk9vY0NDMXg5dFFHUU5QY28wQWRiZSsxNzlBQXVVb1A5WEVNS3JwbERz?=
 =?utf-8?B?MllYWHN1ZHptR2hKNzAxVTg0bTlMMEZ4U0x6M3NwMXA1YzVDdTdtdUFhZi8v?=
 =?utf-8?B?dUgrUTNqOXUvWmkrVHFDYXZHY0hiNCtQQ05iL2E5U09TRlU1Y1RnbmxISnFn?=
 =?utf-8?B?UTN1UTlTZkYxbDh3dnpNWVRwekhUcGZ1U2Y2dlNFWWpld3p5dFpYVEpGTkRW?=
 =?utf-8?B?R1A1bzNIUjJBS2gvVjE1NVFwQWJNZXFIRzBFZ1VndXVUR2dpcjZ1aWp5SFMv?=
 =?utf-8?B?aExnd2tuNGNueGpaeCtoUWlYZXUweGFPa3R2ZlY4N0tCelRzck8wdnJUTVlh?=
 =?utf-8?B?U2NLS05OUzR6YldPUzN2a2cvSU11Z0F2ck40MVFmSzFrMDdVK0swbDMvUTNV?=
 =?utf-8?B?RGY5Q2FZcFpMWVN3S3FFQmdoUkN5a0NOSVovTk1aOFJ4Q3Z4emdzeUdXRHlZ?=
 =?utf-8?B?S3hGM3Q3Sk5ZeG5kL1o5d0VVcHZHWjgrVGlIUXFuSGU2V1lRMlplczJSMnJG?=
 =?utf-8?B?TGFTSzRRMkxucURIWTVFK2c2QU5CREFxWG5kd2srZFJjM2N3K3Z4eno5cGxq?=
 =?utf-8?B?NnVna1Eva1RNb09iNjJHVDEweUwrcVYzN2ZiUis3Y1dLVFpPVk55amtVMHlq?=
 =?utf-8?B?ZzFQa2ZqQkNMdVJ6QkEvOElwUmVDQ3EvZWc2c0tVR0pCbjNEb2dOZXZvRmxP?=
 =?utf-8?B?RzJZS01GbEpUSGsrVjNjVmQ3T1JlbU1UT2YxZXV1ZURORVZMWlVyM0NmTStz?=
 =?utf-8?B?K2kwWTRUeWNxN29SMTEwVUdhU3VGMVorWU53dTJ4eU1WTUtNKzdiMHhzUWNm?=
 =?utf-8?B?LzhUSEdLM1NZQzNsRytVR2ZCeFFqc3IwaFBScDFzb1ZBcXhEb2RDVnZaaTVD?=
 =?utf-8?B?WkNHczIxTWh1WVA1YTAvZ3d5eFI3YXZ6WnlBVnl2bk9yOGk1U0pGSlQ3S1pB?=
 =?utf-8?B?N2VuK0JQSmtrdTdzcHBacTRNZGlua3BxSUx4cERlMmlyV1FDVUtFUktkRGQ0?=
 =?utf-8?B?STRBUEZpWk5aMUYrK1M1eG9rRXFRdHZBbFRVbGk4L2hsd3dPMC9ycnVwbVA3?=
 =?utf-8?Q?W5u5injvTMDxIPRWOGwlP+n7TdQbKqRHU6N/NKf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e03db96-324f-4bb3-bc93-08d96cb1f872
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 19:03:08.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6xqwmS2DhbqgW/ohUhMIasd0JU03Bbc0Uo8kn+hBKeHnOkBD6XaW7tXj4ClHtzetHudwKFSZ/e7H6o5Uf8E1X3M5ty2yX2Wp7eLZ6YNT34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310104
X-Proofpoint-GUID: KA1eK2QBJ2gOOBfWlE32YeuzcegJ4JqJ
X-Proofpoint-ORIG-GUID: KA1eK2QBJ2gOOBfWlE32YeuzcegJ4JqJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 5:48 PM, Dave Chinner wrote:
> On Tue, Aug 24, 2021 at 03:44:26PM -0700, Allison Henderson wrote:
>> +/*
>> + * Allocate and initialize an attri item.  Caller may allocate an additional
>> + * trailing buffer of the specified size
>> + */
>> +STATIC struct xfs_attri_log_item *
>> +xfs_attri_init(
>> +	struct xfs_mount		*mp,
>> +	int				buffer_size)
>> +
>> +{
>> +	struct xfs_attri_log_item	*attrip;
>> +	uint				size;
>> +
>> +	size = sizeof(struct xfs_attri_log_item) + buffer_size;
>> +	attrip = kvmalloc(size, KM_ZERO);
>> +	if (attrip == NULL)
>> +		return NULL;
> 
> kvmalloc() takes GFP flags. I think you want GFP_KERNEL | __GFP_ZERO
> here.
> 
> Also, buffer size is taken directly from on-disk without bounds/length
> validation, meaning this could end up being an attacker controlled
> memory allocation, so .....
> 
Ok, will fix

>> +STATIC int
>> +xlog_recover_attri_commit_pass2(
>> +	struct xlog                     *log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item        *item,
>> +	xfs_lsn_t                       lsn)
>> +{
>> +	int                             error;
>> +	struct xfs_mount                *mp = log->l_mp;
>> +	struct xfs_attri_log_item       *attrip;
>> +	struct xfs_attri_log_format     *attri_formatp;
>> +	char				*name = NULL;
>> +	char				*value = NULL;
>> +	int				region = 0;
>> +	int				buffer_size;
>> +
>> +	attri_formatp = item->ri_buf[region].i_addr;
>> +
>> +	/* Validate xfs_attri_log_format */
>> +	if (attri_formatp->__pad != 0 || attri_formatp->alfi_name_len == 0 ||
>> +	    (attri_formatp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
>> +	    attri_formatp->alfi_value_len != 0)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	buffer_size = attri_formatp->alfi_name_len +
>> +		      attri_formatp->alfi_value_len;
>> +
>> +	attrip = xfs_attri_init(mp, buffer_size);
>> +	if (attrip == NULL)
>> +		return -ENOMEM;
> 
> There needs to be a lot better validation of the attribute
> name/value lengths here.  Also, memory allocation failure here will
> abort recovery, so it might be worth adding a comment here....
Maybe we can add a call to xfs_attri_validate here?  I think we can just 
modify it to directly check the xfs_attri_log_format.

Thanks!
Allison

> 
> Cheers,
> 
> Dave.
> 

