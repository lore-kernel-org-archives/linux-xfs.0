Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E8BC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEE964EBA
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhB0Azk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:55:40 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57990 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0Azj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:55:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j5Zq105586;
        Sat, 27 Feb 2021 00:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3dS5qcJ5F+FXwexKXBUtZvc7pfnbLOodlzeK4Lxatwc=;
 b=aC0g0Pr10pXoRVDbq0pserdfeDwh8I5E3p6ZYmqSBzBiDDAQQ0PYNYkxcPFD3jUncLYx
 aUyw9Xa0F4wwNCZfCXw+tWRqJel/LoX7wRZsRoi6ujegyLOTdmnvmTSfbYc66rsRZArY
 wGk4+5SEccTric6rt/zA4g/7BzGuWWVGZrl7AF6qIauAeGwPeEGbcz5a5ctjO1UNOc0l
 XthU55UTTKJMl8PBCZ0/YV/vkBhYWzpjbJCZRuL2V6IzGiPZu7WzrvORK51wP3bz5/1U
 t2P5usG954eRX/EA6/x+KAaiFMXxfTfx7w8BWKybzu4G3btWOiIV25Fg6VHLfjlVmSap rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36ybkb00me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:54:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j3tU005862;
        Sat, 27 Feb 2021 00:54:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 36ucb41ww0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVGvdBPDQOnnvudDGZnq0LWGd+TwV4138A568Do4QoYnaRi1AP6ZwmpBo+iSmSUSrSRjbR6F3TbV2fVJgNBmupXwa8/iAZcDd7UrUScxqrmUwm+5i2JyFxRoZZwQLrntIiwhTy/uE0Cih3n9UmbcLoY7s4N7Eg2RMlEHPikNQhTpUqca6RAIPmMAFU4Sl+Qpv6q1t9H9xhlBiS4Yh35v+rL2ipM/WLjVEedPJM79ULOdIMFCbUQMl7eKP6TihQiXVj6PYbHkNarCA1Pi4TyLaLUwxh2tYVA8Odb0X8i1iVFcKIla92u+BUXfYvK3qE5H8TUphz4/kIe9utMqGTWrag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dS5qcJ5F+FXwexKXBUtZvc7pfnbLOodlzeK4Lxatwc=;
 b=lfs/ogUJ3novCSW1MRjcqrfw/AN6a3zHrMkRl3R8Iy+qTRnCM8jhS1o5ZFtdAkXdXXT+PCun6sL/ka0jP4vTTDOC3OvJ8n4ilEP/uOnZN2dWXxDrNkDuWiNYy0r/yQJKXljs2jlXGWmhqzMP4Ehw4RazzGAFeoj7ykcP7o0IxE9EeDRyzyPzasO1gxc0S5ntIcVaPsl+1hpn1R8BJijoLpbi3gG87C1v/X1jmjB7/+trx4h/x+Iek+MUJj8FQL2q17AenOFLckeU6p67/quQYlX7VmdBJrdsZcBU3kyTlvn7qI4McZQK6zo3D94VJHtU+TAtfciHtoC8ut9UcUmYqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dS5qcJ5F+FXwexKXBUtZvc7pfnbLOodlzeK4Lxatwc=;
 b=kGTO0VHHi6mzsoxurfFWRTw9LyLhapGrgLqSLX4g6BD4xPz52sgf2oRcBNnDrV1oWs+dDnuIBJ5v6KC/PlLMXo781x+zPe6gvSk3K1mBHpjFFQfYKpdzMQ2cHI9g6qcaMgpeRJq1Q/PAtakKp1Q3eyEYYhkkm66VUXJxDSWm7DI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:54:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:54:52 +0000
Subject: Re: [PATCH v15 06/22] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_work
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-7-allison.henderson@oracle.com>
 <20210226040201.GT7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <affae494-e7dd-4c27-aade-e640a731b096@oracle.com>
Date:   Fri, 26 Feb 2021 17:54:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226040201.GT7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0104.namprd13.prod.outlook.com (2603:10b6:a03:2c5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:54:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54cdf3d1-9e80-420c-6060-08d8daba4ad6
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4306DB0F6FBF61192C748A91959C9@BY5PR10MB4306.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hcdnH1tjBMqyVL0KiFTHeP/tbFerVRiusYJga+jxtu4MyLS7GKzfWohEyH9wQGQjZiV+v00a2e2a0top/RZZrRzXu18eRkb+SoP+Ed8YqLuT35dXJ43Ct5RAKrjhnrLsqJ0Ncz8F3T0tVBw2pUyhVp/NkAZAxGAm/gtlNPaXTV8JffkuL5iLndvA46iMEFewQPhuJbJx+z2vCODwNZKcnyk+Hy2LxRPO9BFkU6wgpdB3VfYH/d2iPraTrQ5rg8JiYK07NcV7XOgu1I7D2/4qXey6MM9ECRFIVRVSAFWQexb7JsHtHwwrVGJPATvL/GqjvTkkkX1Ls09FS0JIt+/MOz3uyPaEMSEjav2Dst+Mh+HNvIzdxtb+KiBiqlL3ZCv2Acce8dLalBC0S096uoof5i26D6lFaXoQZPsBn/zqRpygHwwwlpXZeLVvYB8OC1pGK444tz/y/tA6heTHznizZXyN4KhWCkT7ZSntD7M/4T6YE2CXKqc/MY3A5BTjqlN13pEtwQu4csXEo9JXhZe/5V5F0zaA9wM7A0Y6dvTdYre2UowuBWqVnCleq9nzH34X9l0ifc+VYRD3UoXoRPSuOf5VEOU5FLRdcGEgXS+i4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(366004)(39860400002)(136003)(8936002)(86362001)(6916009)(8676002)(16526019)(956004)(2906002)(2616005)(36756003)(186003)(5660300002)(66556008)(66946007)(16576012)(31696002)(6486002)(316002)(53546011)(478600001)(52116002)(31686004)(4326008)(44832011)(66476007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RHJkRkFjSTF5cFFjd3Z1TnVOT08wYmhsZEoxUGhsNXFzYTF5dEl1dW5SVjJo?=
 =?utf-8?B?Yk5YUy9PRk9vc0JHZzdjRFoyS3VmcFBUVGc5QnhNQ2pjZGVETkRpWnFqUzcr?=
 =?utf-8?B?SG1UYXdxTUdGbTQ5dHpScnpjQmJ6U2ZqTEJPRHM5S05Ud3lTM0ZDS2JRdU96?=
 =?utf-8?B?dEhtU0J5NE9Ib3NDQWYrWkFuN29nZXpSM1RsWVB4d1hGZ2lyakthUkR0SUUv?=
 =?utf-8?B?dCsxMXVSYjFsUmR1UmhsaGxRMmQxN2pUSGVuSWpRSmM5bjdyWG5sWkFucjAz?=
 =?utf-8?B?aE83V2RCVXZsSGpxTHVGdHhIRERBQjJraTJUZk9ESG1pZURkeHdGZVkzWGx2?=
 =?utf-8?B?Zi9lcWswQWc5OHYwVXFFalEzU2Y3a1p0cEtoY0dJSTFVU0FweGpzVW43V2FD?=
 =?utf-8?B?K2dRTGdqZ2JKVytIR3pjeUo5aiszSUhxWTFwNDBraGI3UUY1OHlaUVYvd3Jm?=
 =?utf-8?B?Q2puMU9mOEZCMWZscHhuZXdWQXQxK3NxYVV2TkRUd1hLZloxVmFUbWl6SkJS?=
 =?utf-8?B?cjJ3WTFYcjVWY1lveGVkUEtuNzhaVjVzMS9mSXJJTGpFODJlU1B2b1c3ejJh?=
 =?utf-8?B?YVhGcHFWRk05bzZoNFhiOXR2OFF6M2x0WnZWOG1sVllRakRIbXRNcHZuY3hH?=
 =?utf-8?B?SlFsYklMT3ZOeHBWMDk2R2h2SllmcGFDSU42UzZBR09GWTI4enQzUWNWZEN3?=
 =?utf-8?B?UU5QTDdCUE5DUG42V1gxMC8vZ0M3YWxTRnBLSFZWR0w3Uk81Z3l3amtXd1VQ?=
 =?utf-8?B?S1Z0NVZac3Q4dXc5ZVNtL284bGRmQ3I5S25KQjJaTG55ZFJEM2Y3aHh5a2RI?=
 =?utf-8?B?cXJZTktGSEpodWl2bEpia0M5VzF2UnZLeEpQellVVGtEc0dwM2xsWGVPL2Rk?=
 =?utf-8?B?RUlmWEo5TWM0QVpkRFFOV1lqMytCdTYrbkNpYkxiOVVHdjZMYnRpMEhyTWh6?=
 =?utf-8?B?V0tBcytrM0hNdEkwNmRnRHdwVVpGZFYvejhsMFhhV0lFdmtaTGJIdW9icktT?=
 =?utf-8?B?NXAydmpNeDgzL3dac0tNODVaRURpVWZQYmRHaHdOM1lvem5Bd3l4SWpsUnVl?=
 =?utf-8?B?ZTQ2eWNzZERrczA5WDh4NWVMbkE2d0tHQ1huV3doZCthR1hCc3hlQjI4ajhz?=
 =?utf-8?B?WU1qQ24yTi8yZUszRGMrNytrazI2dmVnQ25WdnAwMkhGR0g4WXR5ek5Fd1lU?=
 =?utf-8?B?ZlU2dlFaN1VROC9RMU9KSldQRGlaNS8wdHBuRnFrdDMzbFlrQnZEMXdhMlgy?=
 =?utf-8?B?N2JBTkdqZncvdUF3Tnl0N2FnZXRMam9KU2RUQUpNeXhkbE1XZjBkMzFSelZr?=
 =?utf-8?B?SU8yL08zajlqbnRMc0owSFV3Nk00WHM2cFZiR0VhSGRPbkY4UTZva0hzZlZX?=
 =?utf-8?B?bWc1bE1LZTBGQ3cxcmFlOWEycm5OYnhIdUp6ampQYnM2WXBkSFJxY3QxdE53?=
 =?utf-8?B?a2YzYmVPOU85TjlLR0Y0a05RL09EM3cxeTJXRHZHVGhlN1lYTTA4R0RNc210?=
 =?utf-8?B?WFR6UHN3WjcwS01Yd01ENVpFVGx4REd1YnNHbkpJR0Z3bkpsSkNZME8veGM3?=
 =?utf-8?B?WXNLbWdFbkxWRGZlcW1VQlplNGhrWE8vTFY4bkV3QkRleEdLcm1vdmxac2RC?=
 =?utf-8?B?OVltQ3Qzb0NRZmNSTjNveld0OWJVL3ptK3BFeVoyWkVCTVJJVmJxL3FHbmFm?=
 =?utf-8?B?VG8yODl3bHUwKzNDcHBjclhONHJmeERVNGNEdjdwKzhUbCtrcE5Yc25oTjh2?=
 =?utf-8?Q?91ck3AHEP+FuzIXZUEFuzi0OUxllJOw72h4qbgP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cdf3d1-9e80-420c-6060-08d8daba4ad6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:54:52.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9o+CfTH2JIqGA7MVB4xPMMFQCyw4xBD2W805qMvlMgfIhgqVlC0wfsXlRv8Ax9pN4IvfWPd+e+/cpkQQTBX0fi0TXZ3QuTYY/wN2E2YdmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4306
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 9:02 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:32AM -0700, Allison Henderson wrote:
>> This patch separate xfs_attr_node_addname into two functions.  This will
>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>> state management
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 205ad26..bee8d3fb 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>> @@ -1059,6 +1060,25 @@ xfs_attr_node_addname(
>>   			return error;
>>   	}
>>   
>> +	error = xfs_attr_node_addname_work(args);
>> +out:
>> +	if (state)
>> +		xfs_da_state_free(state);
>> +	if (error)
>> +		return error;
>> +	return retval;
>> +}
>> +
>> +
>> +STATIC
>> +int xfs_attr_node_addname_work(
> 
> What, erm, work does this function do?  Since it survives to the end of
> the patchset, I think this needs a better name (or at least needs a
> comment about what it's actually supposed to do).
To directly answer the question: it's here to help xfs_attr_set_iter not 
be any bigger than it has to. I think we likely struggled with the name 
because it's almost like it's just the "remainder" of the operation that 
doesnt need state management

> 
> AFAICT you're splitting node_addname() into two functions because we're
> at a transaction roll point, and this "_work" function exists to remove
> the copy of the xattr key that has the "INCOMPLETE" bit set (aka the old
> one), right?
Thats about right. Maybe just a quick comment?
/*
  * Removes the old xattr key marked with the INCOMPLETE bit
  */

I suppose we could consider something like 
"xfs_attr_node_addname_remv_incomplete"?  Or 
xfs_attr_node_addname_cleanup? Trying to cram it into the name maybe 
getting a bit wordy too.

Allison
> 
> --D
> 
>> +	struct xfs_da_args		*args)
>> +{
>> +	struct xfs_da_state		*state = NULL;
>> +	struct xfs_da_state_blk		*blk;
>> +	int				retval = 0;
>> +	int				error = 0;
>> +
>>   	/*
>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>   	 * flag means that we will find the "old" attr, not the "new" one.
>> -- 
>> 2.7.4
>>
