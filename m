Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0ECC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21AC164EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhBYGUc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:20:32 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44980 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBYGUa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:20:30 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6EvJk184832;
        Thu, 25 Feb 2021 06:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ixPgUDDO5hvaoGCS0fvSNEJLCRgqYARuL1/ymOYDUDk=;
 b=nDnD0OGcbEs92qxIg8+6VQ0m3AB54C2MxIicpB3EU+27Z/nN1Rg/FaOnjcPMjEHQQpoN
 3CKYCwCZ5Sc5XAlvGv/zzuv0rgQj4qhLhVtfrTGUro+vbfPSmWDeLpxbMBS02unsVRok
 3c15fX0/fiiBmnHzgckzf4O+MrJk/bGMP6V+3XD7RRKgqUVtAh/0YKATwwAwUjLSZyB/
 UMjBlvXGPWCh9U5huJ+/fFhNC2JxouObuFXJmbqG6KufyySAwgnKseEfF25AXaPtpHPT
 p34pI//QvbN2wS1/lUduO3MdN7uKwNnqWWwBxkDi9+7lIxaSh0ktHzxdleOR3TKe+sDs IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36vr627p9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:19:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6Aaon159263;
        Thu, 25 Feb 2021 06:19:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 36ucc0t8pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:19:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEITusQUFpXPOa7curJ3iXf0aszlmw3DAvcyvr6SPQSTiQq/XR42X2tlQLURFf+Q9F0mM5X+cAhFIZUKpL85O+DUXR+QbhhrKIprgkOCo3j0pxwZz7Jdm7QK6w5l08U73HQGvf4dGR0VWxLCKLBXuBmyWpssOAaxi9674K98bxrxh1kUQpgR8YPVLruNunDpfGdp6vIFeo4dQSTyHSl6UNW/7/BfWWjUuPsFbftNuTKZjNwHgptLqyp+GQRDpCftFas5nyw3D8mjHPDUmUgq5rtafwbI+wZEtooju2QFVNI92LyQCf8DmDzPgtp/lAyzAicBQkqK/C/A6CoXZ6rGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixPgUDDO5hvaoGCS0fvSNEJLCRgqYARuL1/ymOYDUDk=;
 b=hLV27SiPETbR6EOaWZ7p78Zw3O1uw/3iJd2oPBc6dFcL9oAz90VoOJEj6RNRYsKBWwhJt8A9vjRmnmAQUcxVnkkFLTh6jJSm0eeZExf075SgiDlB5CXhxmeOTd7R/na9opusUUi3hkvuToUthchzYkm/MAX9IVUc1LNnK/i6eoGKkJwgV98HQ8mFKDzsyfrjXc+WS0guuiWcF73AS3XpxB6f1YcBtzyUgwKPAac3pOQS15ylC9UcQSfNeew/Xyf6ipZAd0YP2fh/RxqwmUW5sKcPXmUYJKJt417x7/ik1Iub4TsK+LM3n77RQkbxB8jmesru0e0jHHzuB/48vD7M5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixPgUDDO5hvaoGCS0fvSNEJLCRgqYARuL1/ymOYDUDk=;
 b=ZB/EdIyVh89lVkupF7oGoAkZUsncGdS6I/YYVtTjTm06L2CcU+IJSA1KcJk8hJeFgxtU+lGrWrokiOfgO/DQYG1WiHqRQQ78zxUfrnDLkK+FqhdMN5T8Hnx/mSpKnTei3IUqJlcfo47Vw/sTRgDrA6ZimUKHEHFymPcIErl10w4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Thu, 25 Feb
 2021 06:19:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:19:42 +0000
Subject: Re: [PATCH v15 09/22] xfs: Hoist xfs_attr_leaf_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-10-allison.henderson@oracle.com>
 <20210224184214.GI981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <35e692d2-82f4-6513-0637-6509c05e9523@oracle.com>
Date:   Wed, 24 Feb 2021 23:19:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224184214.GI981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0242.namprd03.prod.outlook.com (2603:10b6:a03:3a0::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 06:19:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1d96031-7f82-47f4-dda7-08d8d95556e7
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45104715DE378C4915508298959E9@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGMBshfNLLcD3cyS3MiBnFFgaW/dnhvxCllRc5XqRB+CgbD3J6HT2JPyGNfQ7cgdv8cm9k3meQw+Zmb4JAeZlln+er1heNR7LZSP0e4amu8Ru32Hk2QOa31KQU3Qt12qRLWfUZ3LDFDhDDDztNIrCQKhXBlpLKGLgfTzPxBWISUZmnkisqHi82/OtGQhKyQJ2so2ktVZM0nVc2Z1Fc6rxGAgNuRJETXDrYrsdwqYyoEfIlg5Jxiqye8Vx+I5PECjEjnCE33cN8W5h7+OjvVA9LJSChlDtKmTHMsljivPM679yTzpfgrLxa6jdqq6dX9ZmWh+Lcmf+5mfaSWOB8062c7Lp9KhJpDf2q3J6l7LOhitFuXdcN7DqfNN+ENWd8m0u85X1MHx84odglFNaCvtr5tFlmQxmmxj2VArO9TOTRYw1R3drW0Dgi3lwECeTm3Hrqy1Gh4NqKSH6Oh+sa3WcKXsdtEUluuTmEiLwWAdcRetHAU5fdt/pv+HCijfqPV0cHbzw939aflFs4RkLBCj4Z8xOBkM7HGFyJXveZwZDl3zuee/nvjemWv0JGfVQULML3HBuK3+zcoajU7WXsidgu+sGtYD1kaNFpQiMC4+fpI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(366004)(39860400002)(26005)(66476007)(6916009)(52116002)(8676002)(66556008)(2616005)(478600001)(16576012)(83380400001)(86362001)(2906002)(186003)(6486002)(5660300002)(36756003)(4326008)(16526019)(31686004)(66946007)(31696002)(44832011)(8936002)(316002)(53546011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eDByak9ZbFY0d2Fsc3ZrVG9GUFdVT21NMkJzam13Nm9NVThPNkRUQUVGbUd3?=
 =?utf-8?B?OVpLRGUzMm5BckNxbGRhOTVYYnl5M2UzdEtraUNReE1QWHNzeE5EOFA2VUNt?=
 =?utf-8?B?eTZycnc5dW9JWjVVNXhHbitVRHZQa2NJOWtMc0RzK1hod3Z0MlBtam1QMGdO?=
 =?utf-8?B?cUdvcXBaRGVvNUJHS2FPYk14STZPeUNGbkJFV2JXQU1jQmkyUnJBZ0IrWVNZ?=
 =?utf-8?B?dDBMa1V5bGZCY2tST0FmMytEcHZSZGU1M2Y4YXJDQXBSc0x2L0VsV0VLbGcy?=
 =?utf-8?B?NTBOc2FiS2VkcjgrRHRvaWJwa1BaSjg3Q2lrbmR0VjZXZnkyS0x4Sm9qRm9J?=
 =?utf-8?B?azc2MmdxQXU3L2VTaXExTTRMWkJHY1ZuMXg2L2M3NkFKMjBPVGU1U0VGWlBm?=
 =?utf-8?B?cDNkd1hZUXVrTkFiMnlTd0ZPUm9JMy9vdWUydVUvVXR4Y095UUVOTlNwS29r?=
 =?utf-8?B?YmtwTzNHdWhrUDBUY3gyOVUrQ2ZHRVNyNUZncXFRV0k5UjAwSFFOdGpxbncx?=
 =?utf-8?B?cTI0TSs1TW9FTlRPRFd3MmRWZS9iTTFIenoxSlpKWTE2MEM3OUlYbmtGTGp5?=
 =?utf-8?B?b3FUWnJGT0hCS3BYRURXYmNtK3ozRVRPS21CMzQ0cE5wLytQTnpqOVQxNUJh?=
 =?utf-8?B?enFrbWNaTTYwbkU0TkhUUXNpcmtIRXVrWHYwRCtqOHUvY2xOT2Izbmh2WTc2?=
 =?utf-8?B?TU5YRmEvSEMzU1Y2VW41Z3N0YkJSTmlMOXU0aFkvWHZwbzdLbEJzakwwMVRB?=
 =?utf-8?B?eXVMcEJiTGV2RjBDcGNYNFFSQnZtbVRCdmFZaUtHZ0ZFazA3ZjNwU2t2R2JM?=
 =?utf-8?B?L3hKeVhRZVhNTWtPc1ZJK3pWa01GM1J1TFN4TVJDQkJZQjUwRWdBNktpbnhn?=
 =?utf-8?B?VVpJRW1SaWZWaWtCV3dxUDRYTkNyU1FZMXJaUTdPbmkrZjNONklnOURHUmRE?=
 =?utf-8?B?ejZCUTRyZFluQXFzNCtvbHJvVFdWK3FvTmlUdEpqUzUxSXFXK2FNSlJ1S1gx?=
 =?utf-8?B?QmJrN1Jab2VTbjVsU21Id0VuSTQ2TjlQeUd4bDIxVEdRaGRqdzM5UU05blBQ?=
 =?utf-8?B?RDliSHBLVnRzTXgvSVdvMGl2cGlsaXltTks4TEUwWjlDdXY3RGFWd3JaYkFo?=
 =?utf-8?B?Rzl2eVFTUnFSWnI1QW42cWtCa3g2R2FQMDRRemtaTHRrNUdDSURVMVFCOWZu?=
 =?utf-8?B?VnlJdzQvVjZqREJaWnhlZGJyT01tcXVlZTgvWjdNSXBkTmVqNjJWNW9lbG1j?=
 =?utf-8?B?dkR5bmlkN3V0SGdJbVIrRzZyMUNjQnY0UlJXSjhDa3pyQXhRbVcwdERTRWx5?=
 =?utf-8?B?TmJvbGlZUzFzTCtCOU9VVGs2SmhxSTl6c1pwd2pLQ0w5ODVoK0xGWC94RmdR?=
 =?utf-8?B?d3JIZER4UEJybFFxc1FnTWRyQXNHTUdNWjhER0Jabm5YRitpU1hqQm03ZFUy?=
 =?utf-8?B?ODVkMlEzVTNtcmErMTRyc09lL2QrN0JLUThrL3M1cVFtZmVnNFFOQTZxaGNo?=
 =?utf-8?B?NU9oUnFnZGMvV1luTjlsU0xXVC9LWTE2NzRYcmRNU2wxWDVUOUZlRFIxL2Nl?=
 =?utf-8?B?VW5lZVBZcURidXpEVEprWUFnckc1cHFkLzdQbmxLNXRweE8yTzZBYzY3V0lV?=
 =?utf-8?B?K2JKTDk0ZC9sMnRtNDFiYU91WmJ4SFFXMmpOVFRjSlZIbFVlWlpSSUVXOFJv?=
 =?utf-8?B?VFVkMmd5RnVUaC90VFBZbGdFOG5HK2JrTm5FdkFEek4vVUpkR1lDTnB3MTdW?=
 =?utf-8?Q?WGbmLTCDunKtlQzg0Hir4JEkE10Xp4Y/ZIOZiJm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d96031-7f82-47f4-dda7-08d8d95556e7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:19:42.7613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+HmDYvf8J3g1R1GLZL/9SbV5Ai/AeNE+OhUZGSWokTXxLhvpz6GDiG8hw9a50Qd+HC4NGrXmSIB1FiuhesKJO/Z4laeoFg5YWVZotBaQt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 11:42 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:35AM -0700, Allison Henderson wrote:
>> This patch hoists xfs_attr_leaf_addname into the calling function.  The
>> goal being to get all the code that will require state management into
>> the same scope. This isn't particuarly asetheic right away, but it is a
>> preliminary step to to manageing the state machine code.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>>   1 file changed, 96 insertions(+), 113 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 19a532a..bfd4466 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -286,10 +287,101 @@ xfs_attr_set_args(
> ...
>>   			return error;
>>   
>> +		xfs_attr3_leaf_remove(bp, args);
>> +
>> +		/*
>> +		 * If the result is small enough, shrink it all into the inode.
>> +		 */
>> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +		if (forkoff)
>> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +			/* bp is gone due to xfs_da_shrink_inode */
>> +
>> +		return error;
>> +node:
> 
> Hmm, I'm not a fan of this unconditional return followed by a jump label
> in the middle of the function. It's a pretty clear indication that this
> is just two functions smashed together, so I'm not sure what the
> advantage of this is. I'll continue on to see what falls out of the next
> patches..
> 
> Brian

Yes, it does kinda look a little displaced, but the point of it is to 
bring code that will require state management into the same scope so 
that the state switch can span all the operations it affects.  Which 
seemed to be what the RFC was striving for?  Looking ahead at the other 
reviews, I think it came together for you?

Allison

> 
>>   		/*
>>   		 * Promote the attribute list to the Btree format.
>>   		 */
>> @@ -731,115 +823,6 @@ xfs_attr_leaf_try_add(
>>   	return retval;
>>   }
>>   
>> -
>> -/*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - */
>> -STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> -{
>> -	int			error, forkoff;
>> -	struct xfs_buf		*bp = NULL;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> -	trace_xfs_attr_leaf_addname(args);
>> -
>> -	error = xfs_attr_leaf_try_add(args, bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Commit the transaction that added the attr name so that
>> -	 * later routines can manage their own transactions.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * If there was an out-of-line value, allocate the blocks we
>> -	 * identified for its storage and copy the value.  This is done
>> -	 * after we create the attribute so that we don't overflow the
>> -	 * maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		if (args->rmtblkno > 0)
>> -			error = xfs_attr3_leaf_clearflag(args);
>> -
>> -		return error;
>> -	}
>> -
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the incomplete
>> -	 * flags on the "new" and "old" attribute/value pairs so that one
>> -	 * disappears and one appears atomically.  Then we must remove the "old"
>> -	 * attribute/value pair.
>> -	 *
>> -	 * In a separate transaction, set the incomplete flag on the "old" attr
>> -	 * and clear the incomplete flag on the "new" attr.
>> -	 */
>> -
>> -	error = xfs_attr3_leaf_flipflags(args);
>> -	if (error)
>> -		return error;
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> -	 * (if it exists).
>> -	 */
>> -	xfs_attr_restore_rmt_blk(args);
>> -
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> -
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	/*
>> -	 * Read in the block containing the "old" attr, then remove the "old"
>> -	 * attr from that block (neat, huh!)
>> -	 */
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -				   &bp);
>> -	if (error)
>> -		return error;
>> -
>> -	xfs_attr3_leaf_remove(bp, args);
>> -
>> -	/*
>> -	 * If the result is small enough, shrink it all into the inode.
>> -	 */
>> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> -	if (forkoff)
>> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -		/* bp is gone due to xfs_da_shrink_inode */
>> -
>> -	return error;
>> -}
>> -
>>   /*
>>    * Return EEXIST if attr is found, or ENOATTR if not
>>    */
>> -- 
>> 2.7.4
>>
> 
