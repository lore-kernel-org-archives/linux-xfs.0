Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B836C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B87610D2
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhDBJtf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:49:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58394 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbhDBJte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:49:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329mxv8091509;
        Fri, 2 Apr 2021 09:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tPnKDDKuMm6/ILMVsV2cy/MHVZdNPAJvIfQn5tyW+Z4=;
 b=BkgdigSRJoBRDljzAOneaAiPqXgGFcAJPjZaCvE4PHTHcbgGMftwbhg6twnNhJhOIgwB
 2Q1S0zA9P0RigzZR//2XFb0Hd+JZZT2cooHotp5T7MdTDswAe+qOXr0GPziXvB9Sq5VX
 /+sCEL+z231gOTgM49db0DSYz0SYin9SokjdNJS47eHli5em5E5F4W+BSOjPXQvNZYVG
 Ua3AzdUE6bly1QZ13EF4lzG0fRV6wZV9oXTXYVBdgpwgPgUqdJ8Rcr9G82Wh7L5seuo+
 wmCInkX7F4rsDrISwj0CXvWZDc+Kw5uvd42qqolaU45fKWFlCsT8+KMgL5jGof06rrwx ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37n33dv8fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:49:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329jc3D173538;
        Fri, 2 Apr 2021 09:49:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 37n2atw4ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:49:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhpCpw/ERWmHr5d4Jezf9mbRrhQbPwRPdtkkHrr2DRto6Vd/Q3LaQU/cu+meG7MQ2WtwErCKrSrvmZnrIUzjQT2/DEfNuHk6rro2udzE6j+I1uYeZj2rZsJ/IcrZgf0ulN0o5qEkTd3H8MnMgfp1RHZDTdSCkq3QeumKXXVO/P/gGn8LaWBI/1g/fxL0GSCI3zv6hjo12n9Db+YdWOP8m7sux7VAMMk5wOBGQY2vTi60GEs49kI+Fc1rX3pTl1ACgDcUakged85QuQOQgBWX65GlQ/NVsFT472hCgx8lOneKTfGbzs9cZysXz08aFjxwlyfx0akCA9B8ES/XyfqnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPnKDDKuMm6/ILMVsV2cy/MHVZdNPAJvIfQn5tyW+Z4=;
 b=ck5jmc1zw0wyEp/pRLLX7WiHZbd6hOzbs4eDfL5gmwdAOw0ANyfGz3liVEU66oLciYriNtaislLigtITLR6mG0m7ytuSJSaV2d/bM7nQM1FRB7LzAO4EFp6Cj8moRJfbnVb22LOAHGQS5FkpG/IB95XBvonIEwNBeu8NHLBgYG1z8S+pvoAogo+nFYKM4wQOcsvqqa1B8BG28jVXfLNnkxON6Lu8Jw070zjgZYA2Sn1FHCizHBA2T7bTlotoYY+o+KvPxPU/o+uhp82T6aLaqcuU/GIbkba6vJMTwE8F4+gmkwbj8gtpbDiMrULl3PmP/Q2FsTOI6qhI6zdoc5X9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPnKDDKuMm6/ILMVsV2cy/MHVZdNPAJvIfQn5tyW+Z4=;
 b=iGuwj6NfTc28VdopkmEsrIwVvZWikDvdi6ZauEOZF4tFk22721Yte9EsVLZm1guWQSLiMDqIMdmcyj6ngLWv1kfQI6UWtbbVZJzYOBmjuk4EQwSR66thnctPn9qYsXyqw/P2eHEkAmqTHXHa54diQODwr9RJrG0n9kcWSSIB1c0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3510.namprd10.prod.outlook.com (2603:10b6:a03:120::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 09:49:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:49:27 +0000
Subject: Re: [PATCH v16 00/11] xfs: Delay Ready Attributes
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210329215952.GJ4090233@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4fe20d74-7631-3c25-8eb2-bb7d760c0282@oracle.com>
Date:   Fri, 2 Apr 2021 02:49:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210329215952.GJ4090233@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:a03:74::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR05CA0060.namprd05.prod.outlook.com (2603:10b6:a03:74::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Fri, 2 Apr 2021 09:49:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f12fcbc4-a9b7-4365-e577-08d8f5bc9ab3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3510:
X-Microsoft-Antispam-PRVS: <BYAPR10MB351033E3E37DF117E92C5FAF957A9@BYAPR10MB3510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y8lZmylPahHadK0IOFFqwjVH5yK6g7jzGDM1gQZW0rxlfuo9WVnUUQqYZ9x1gZgTGIzUTEK1bVIcNL5SQHnCRIBnf0fbjK70TbOdV5IaHoNJBvqHPOudnRiexepHTRO280C5oPxRI/JROJ7Ya5BtGkkywD0uwqYOs+LuOFcs2DAmuYxR+lsvXjr5V38zRb6ketmJPBswLJ7bMH8BxEYYMsd8xabB8jhsLP/+YoXZuDXaiWLsE+G55Jhzvxg5pYAE0BjOQk9V1n/E7+d1UjrLrX0g8NhaZe/uQDKI57OyBqhWAYDhSvUgPoGxVH6eXlBchL/pwiNzsFgidX9qtrO7iQjTVb0BDhcxhs9O5usKTZbMzT4inDcDwLuHHycroHytpCCNfIucZCzc77HKf/xc4QE9bhLCM0lIUfoCVNV8GI7eXaYIL+qE/T4P3dj6zJ6HCZBnyhSHHUTZnFYi13Vq6saUdF+3YQnCPaO3sSy+vMz1hfRMhM+eltyiZnBzSUAwW/4fcwQVX8rVTfVOiLtas0OZ34ZqYPbIHc5ytQ7npgDsic51igQnwMJEvBNaXgbhPVxX1/BRDtXYUnbtSzI2jrIij6P8WXGRsa+4JqsFR8qp5Y5k3L/3n7zSFumUBFqnFerwE9d/WLLXm416LM3RJrK22gAT76MZheP+2BM8c85CuCSX8HyL1jMsAmb1V5W9Bl0AILAuoQmot9k38JRTiglDGLzp+j17+DRy0YaJWkRoewQCbScbPvYhy5g2G4kjKWz3BgtlNL220tDY8TlKWMhAe6i5ulo6r1u4yvefJdY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39860400002)(4326008)(26005)(8936002)(83380400001)(86362001)(8676002)(186003)(16576012)(316002)(16526019)(52116002)(38100700001)(31696002)(2616005)(66556008)(66476007)(6486002)(53546011)(966005)(956004)(478600001)(6916009)(44832011)(66946007)(2906002)(30864003)(5660300002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2hVOE5yb29vVXBuRzB2NjJCTjZULyt5YXA4UG41NFRISDUrVitvdUM1b1Rt?=
 =?utf-8?B?aUtPbVRYUVZnUnhOWHUxdFdvUXN3d3ZJdnA0UWRDNG1EbmdHL01HR1RPZGwr?=
 =?utf-8?B?dHdwTzlaSGlQTlA3S0VycExPTVFNeDd6Y3NDL3p2d21XNDVLNlo4cjVRT3pr?=
 =?utf-8?B?b1IyM1FtTnE0M3FHa0t6YVVRYldMdTYrV2h3QVdwMWtFNTJuWmpJOUt0dTNm?=
 =?utf-8?B?QmVrY0d0LzhLZ2ZrZkovV0U1S2NPeXh2QXRMUXVsWmtXWEIzQStjY1pybDQ4?=
 =?utf-8?B?V0Y1aExLMEtLakwvcThad0pvVVA1SGJCL3FHR25KRXMvZjN0ZWtJTWVXc2dk?=
 =?utf-8?B?YWZDMExWOURDK0NsbWhXdmpQZmZ6SC8xMzFybm8zWDVVRGJpejlqRTUrL003?=
 =?utf-8?B?NjJXdlRvazVVLzBhM3VzL0RSZ01teE02ZkU2bmQ4WDdSS01TZERUZWxDMEpK?=
 =?utf-8?B?NkUvTjdMbERid0ZwZkJYR0ZvWWt0cDZHZk9COTl5OVFaQWtqSjZ3RGpoYUVE?=
 =?utf-8?B?RlBlOEU2WHIrNGhmTEQwQktNcmlRWkZ3K3FXTUpLTGF0N3FseWNaYlA3OHhn?=
 =?utf-8?B?aCs0OXNvelZGVkwrQWZqU0JvakduQXQvb3A1U3ExTlhGMVplOEdickU4eCtx?=
 =?utf-8?B?MDM2T09DZmF4SDZaelo1dFdycUxTUjFzOEJUNjhyaVZhZ0ErOENFaFJHSm5n?=
 =?utf-8?B?SFB3Q1dzV0I1cjlJcHlkbnozeGl1RGJ6dzlyWU9DbU5JQ2k3U3lvaWRMUXQv?=
 =?utf-8?B?UGpGMDF4V3ltcnFnOXl3cTVOcjBwRjJ2QXFKdzRFNzBEUVBDKy9INDJseU45?=
 =?utf-8?B?WFRRb3hYajljZHplaU5ZclZLZ3RhWHlibktZeVNZc2pIeVNhUEtJc2Q4L2k0?=
 =?utf-8?B?MkFCM3B3eWtBUy90YzlVTVp1ZHlseUVJS3k2UnV5TkxmdTV0TmFiOE9BYUpk?=
 =?utf-8?B?MEtpQ3MrckdFZmkwNGRqSDhrY25QUUdTdDQ5RmtGN3FwUTU1NEtqaGdRZzhZ?=
 =?utf-8?B?ckM4YlRTRis4TzFBN09CblJyQWc4TmcycGIxeUNKc0w3L2crZDdBclFzSW9K?=
 =?utf-8?B?L0xFS0xZNDFCeWFOK25BVzBtZ2Z3Unk0NW4xSXIvUVc2Y29aNHlCQ3RMM0tS?=
 =?utf-8?B?eWxqbkw4eDJkVmhoMFFzMTBPRXhUM0ZXTkxVd1FUQTg2ZHduRDFNditTL1lF?=
 =?utf-8?B?RThhWDdqdlRnTnBEck1NMjA4T2pqK2c2MG5YM1gyRDZDd3k1U2gxSUxjMHlK?=
 =?utf-8?B?UG1mVXA1YmNsdmJrU0pLL2pQUVNLL3gydWhjSG85d21NMHhEbzZ4T1R5MEJz?=
 =?utf-8?B?TWcvS0xHMnJQSU5RdWRuQ01KVVM2UmhWazVmN0JENHJDeGd2MHlDeU9oYmtK?=
 =?utf-8?B?Mm03SFMySmVXRXdoQVlpVjdDSDFNcUttdUFrcjRJcGFFckp0VzRWRW9udnZ0?=
 =?utf-8?B?blFHdXNtYmY3QTNNNTROMHlMNjN2T0I5aEtraGJYRDVqSjYrRUQwSGl0M2tE?=
 =?utf-8?B?blA1ZUUwaFVmMjVCWkRTNlB2VFB5Z1piaEpJbE1RaUVGekVVdkJ1bm9pWXhF?=
 =?utf-8?B?SjZEZzJLc282N1U0VzZhamRYTm00Z0FtNHdySCswTDFrRVloSFlYWmJMeXRw?=
 =?utf-8?B?QWJrTGtGR0FrbFhIZjV5c0VxbWFxUHlLUTk1Zkx1YlE4aXhqYWpZY2JjYkZ4?=
 =?utf-8?B?ZTM3NjY4M25CM0xLTWFxRG4vdzk4eThxMFpqUmRLOFVIdFcvVGg4a0NzUkQ0?=
 =?utf-8?Q?0QZch7WYuThmM/BZwuqlvxWsjgp8DxE4aPCNKtj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12fcbc4-a9b7-4365-e577-08d8f5bc9ab3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:49:27.2974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34OBa/ubO7rjVoCc+AGn8lmuLBq0EesZmVXPb1b48hsUPdgrnOSTaevrHFy7Y/y8wdDCEyWqu/TXVSt36KkB0Po3hWXzzv8wxpbSY/13KH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020068
X-Proofpoint-GUID: cNRNMhwAVHirMW3eTXewTWHpqUAKVHKY
X-Proofpoint-ORIG-GUID: cNRNMhwAVHirMW3eTXewTWHpqUAKVHKY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020068
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/29/21 2:59 PM, Darrick J. Wong wrote:
> On Thu, Mar 25, 2021 at 05:32:57PM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> This set is a subset of a larger series for Dealyed Attributes. Which is a
>> subset of a yet larger series for parent pointers. Delayed attributes allow
>> attribute operations (set and remove) to be logged and committed in the same
>> way that other delayed operations do. This allows more complex operations (like
>> parent pointers) to be broken up into multiple smaller transactions. To do
>> this, the existing attr operations must be modified to operate as a delayed
>> operation.  This means that they cannot roll, commit, or finish transactions.
>> Instead, they return -EAGAIN to allow the calling function to handle the
>> transaction.  In this series, we focus on only the delayed attribute portion.
>> We will introduce parent pointers in a later set.
>>
>> In this version I have reduced the set back to the "Delay Ready Attrs" sub series to
>> avoid reviewer burn out, but the extended series is available to view in the inlcuded
>> git hub links, which extend all the way through parent pointers.  Feel free to review
>> as much as feels reasonable.  The set as a whole is a bit much to digest at once, so
>> working through it in progressive subsets seems like a reasonable way to manage its
>> dev efforts.
>>
>> Lastly, in the last revision folks asked for some stress testing on the set.  On my
>> system, I found that in an fsstress test with all patches applied, we spend at most
>> %0.17 of the time in the attr routines, compared to at most %0.12 with out the set applied.
>> Both can fluctuate quite a bit depending on the other operations going on that seem to
>> occupy most of the activity.  For the most part though, I do not find these results to be
>> particularly concerning.  Though folks are certainly welcome to try it out on their own
>> system to see how the results might differ.
>>
>> Updates since v15: Mostly just review feed back from the previous revision.  I've
>> tracked changes below to help reviews recall the changes discussed
> 
> Hmm... so I ran fstests against this on an otherwise default V5
> filesystem, and saw three new regressions:
> 
> xfs/125 spat out this from the final repair run:
> 
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
> 	- zero log...
> 	- scan filesystem freespace and inode maps...
> 	- found root inode chunk
> Phase 3 - for each AG...
> 	- scan (but don't clear) agi unlinked lists...
> 	- process known inodes and perform inode discovery...
> 	- agno = 0
> attribute entry #32 in attr block 2, inode 134 is INCOMPLETE
> problem with attribute contents in inode 134
> would clear attr fork
> bad nblocks 8 for inode 134, would reset to 0
> bad anextents 4 for inode 134, would reset to 0
> 	- agno = 1
> 	- agno = 2
> 	- agno = 3
> 	- process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
> 	- setting up duplicate extent list...
> 	- check for inodes claiming duplicate blocks...
> 	- agno = 0
> 	- agno = 1
> 	- agno = 2
> 	- agno = 3
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
> 	- traversing filesystem ...
> 	- traversal finished ...
> 	- moving disconnected inodes to lost+found ...
> Phase 7 - verify link counts...
> No modify flag set, skipping filesystem flush and exiting.
> xfs_repair should not fail
> 
> And xfs/434 and xfs/436 both complained about memory leaks stemming from
> an xfs_da_state that xfs/125 didn't free correctly:
> 
> [ 1247.150683] =============================================================================
> [ 1247.151799] BUG xfs_da_state (Tainted: G    B   W        ): Objects remaining in xfs_da_state on __kmem_cache_shutdown()
> [ 1247.153246] -----------------------------------------------------------------------------
> [ 1247.153246]
> [ 1247.154528] INFO: Slab 0xffffea00002e9280 objects=17 used=11 fp=0xffff88800ba4b4a0 flags=0xfff80000010200
> [ 1247.155764] CPU: 2 PID: 50257 Comm: modprobe Tainted: G    B   W         5.12.0-rc4-djwx #rc4
> [ 1247.156849] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1247.157996] Call Trace:
> [ 1247.158330]  dump_stack+0x64/0x7c
> [ 1247.158767]  slab_err+0xb7/0xdc
> [ 1247.159196]  ? printk+0x58/0x6f
> [ 1247.159615]  __kmem_cache_shutdown.cold+0x39/0x15e
> [ 1247.160248]  kmem_cache_destroy+0x3f/0x110
> [ 1247.160779]  xfs_destroy_zones+0xbe/0xe2 [xfs]
> [ 1247.161462]  exit_xfs_fs+0x5f/0x9b4 [xfs]
> [ 1247.162065]  __do_sys_delete_module.constprop.0+0x145/0x220
> [ 1247.162740]  do_syscall_64+0x2d/0x40
> [ 1247.163197]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1247.163810] RIP: 0033:0x7fd91cfe4bcb
> [ 1247.164262] Code: 73 01 c3 48 8b 0d c5 82 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 82 0c 00 f7 d8 64 89 01 48
> [ 1247.166352] RSP: 002b:00007fff89097038 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> [ 1247.167217] RAX: ffffffffffffffda RBX: 0000558b8e105cc0 RCX: 00007fd91cfe4bcb
> [ 1247.167998] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000558b8e105d28
> [ 1247.168781] RBP: 0000558b8e105cc0 R08: 0000000000000000 R09: 0000000000000000
> [ 1247.169562] R10: 00007fd91d060ac0 R11: 0000000000000206 R12: 0000558b8e105d28
> [ 1247.170351] R13: 0000000000000000 R14: 0000558b8e105d28 R15: 0000558b8e105cc0
> 
>  From a quick bisect, all of thse problem originates in the last patch.
Alrighty, I will see if I can recreate these bugs and get that figured 
out.  Thanks!

Allison
> 
> --D
> 
>> xfs: Reverse apply 72b97ea40d
>>    NEW
>>
>> xfs: Add helper xfs_attr_node_remove_step
>>    DROPPED
>>
>> xfs: Add xfs_attr_node_remove_cleanup
>>    No change
>>
>> xfs: Hoist transaction handling in xfs_attr_node_remove_step
>>    DROPPED
>>
>> xfs: Hoist xfs_attr_set_shortform
>>    No change
>>
>> xfs: Add helper xfs_attr_set_fmt
>>    Fixed helper to return error when defer_finish fails
>>
>> xfs: Separate xfs_attr_node_addname and xfs_attr_node_addname_work
>>    Renamed xfs_attr_node_addname_work to xfs_attr_node_addname_clear_incomplete
>>
>> xfs: Add helper xfs_attr_node_addname_find_attr
>>    Renamed goto out, to goto error
>>
>> xfs: Hoist xfs_attr_node_addname
>>    Removed unused retval variable
>>    Removed extra state free in xfs_attr_node_addname
>>
>> xfs: Hoist xfs_attr_leaf_addname
>>    Fixed spelling typos
>>
>> xfs: Hoist node transaction handling
>>    Added consistent braces to if/else statement
>>
>> xfs: Add delay ready attr remove routines
>>    Typo fixes
>>    Merged xfs_attr_remove_iter with xfs_attr_node_removename_iter
>>    Added state XFS_DAS_RMTBLK
>>    Flow chart updated
>>
>> xfs: Add delay ready attr set routines
>>    Rebase adjustments
>>    Typo fixes
>>
>>
>> Extended Series Changes
>> ------------------------
>> xfs: Add state machine tracepoints
>>    Rebase adjustments
>>    xfs_attr_node_remove_rmt_return removed to match earlier refactoring changes
>>    trace_xfs_attr_node_removename_iter_return becomes
>>    trace_xfs_attr_remove_iter_return to match earlier refactoring changes
>>
>> xfs: Rename __xfs_attr_rmtval_remove
>>    No change
>>
>> xfs: Handle krealloc errors in xlog_recover_add_to_cont_trans
>>    Added kmem_alloc_large fall back
>>   
>> xfs: Set up infrastructure for deferred attribute operations
>>    Typo fixes
>>    Rename xfs_trans_attr to xfs_trans_attr_finish_update
>>    Added helper function xfs_attri_validate
>>    Split patch into infrastructure and implementation patches
>>    Added XFS_ERROR_REPORT in xlog_recover_attri_commit_pass2:
>>
>> xfs: Implement for deferred attribute operations
>>    NEW
>>
>> xfs: Skip flip flags for delayed attrs
>>    Did a performance analysis
>>
>> xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
>>    Typo fixes
>>
>> xfs: Remove unused xfs_attr_*_args
>>    Rebase adjustments
>>
>> xfs: Add delayed attributes error tag
>>    Added errortag include
>>
>> xfs: Merge xfs_delattr_context into xfs_attr_item
>>    Typo fixes
>>
>>
>> This series can be viewed on github here:
>> https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v16__;!!GqivPVa7Brio!Ol0JaXyUI3K5MEGrBo_eMHzcTqcuIL9p25-XSZftWgn4bmbxeX_AJf7Hl-kP6ecxUskY$
>>
>> As well as the extended delayed attribute and parent pointer series:
>> https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_v16_extended__;!!GqivPVa7Brio!Ol0JaXyUI3K5MEGrBo_eMHzcTqcuIL9p25-XSZftWgn4bmbxeX_AJf7Hl-kP6QsZXJc5$
>>
>> And the test cases:
>> https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv2__;!!GqivPVa7Brio!Ol0JaXyUI3K5MEGrBo_eMHzcTqcuIL9p25-XSZftWgn4bmbxeX_AJf7Hl-kP6fAPHdk4$
>>
>> In order to run the test cases, you will need have the corresponding xfsprogs
>> changes as well.  Which can be found here:
>> https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16__;!!GqivPVa7Brio!Ol0JaXyUI3K5MEGrBo_eMHzcTqcuIL9p25-XSZftWgn4bmbxeX_AJf7Hl-kP6ToIBbr7$
>> https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs_work/tree/delay_ready_attrs_xfsprogs_v16_extended__;!!GqivPVa7Brio!Ol0JaXyUI3K5MEGrBo_eMHzcTqcuIL9p25-XSZftWgn4bmbxeX_AJf7Hl-kP6cfTeHmh$
>>
>> To run the xfs attributes tests run:
>> check -g attr
>>
>> To run as delayed attributes run:
>> export MOUNT_OPTIONS="-o delattr"
>> check -g attr
>>
>> To run parent pointer tests:
>> check -g parent
>>
>> I've also made the corresponding updates to the user space side as well, and ported anything
>> they need to seat correctly.
>>
>> Questions, comment and feedback appreciated!
>>
>> Thanks all!
>> Allison
>>
>> Allison Henderson (11):
>>    xfs: Reverse apply 72b97ea40d
>>    xfs: Add xfs_attr_node_remove_cleanup
>>    xfs: Hoist xfs_attr_set_shortform
>>    xfs: Add helper xfs_attr_set_fmt
>>    xfs: Separate xfs_attr_node_addname and
>>      xfs_attr_node_addname_clear_incomplete
>>    xfs: Add helper xfs_attr_node_addname_find_attr
>>    xfs: Hoist xfs_attr_node_addname
>>    xfs: Hoist xfs_attr_leaf_addname
>>    xfs: Hoist node transaction handling
>>    xfs: Add delay ready attr remove routines
>>    xfs: Add delay ready attr set routines
>>
>>   fs/xfs/libxfs/xfs_attr.c        | 903 ++++++++++++++++++++++++----------------
>>   fs/xfs/libxfs/xfs_attr.h        | 364 ++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c | 126 ++++--
>>   fs/xfs/libxfs/xfs_attr_remote.h |   7 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   fs/xfs/xfs_trace.h              |   1 -
>>   7 files changed, 998 insertions(+), 407 deletions(-)
>>
>> -- 
>> 2.7.4
>>
