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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8991C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE4664EBA
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhB0Azo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:55:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0Azn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:55:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0kv9u106638;
        Sat, 27 Feb 2021 00:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HRkDRQ6edF5QlbEJYDpJyOv77Y2z2FExItDrJcKrh08=;
 b=0b8eW4bPgR8WM008IxtWQ5wGm0rEm+BYPG3yNd2C4BiXl1ifrY5eSbvH8xdn4jbpmYVt
 xHchiH02zi35WRmPM7+T+Swp9d+1oEjy2PP/ES27jWpQO6D70IyFZo1zokBDcrs72WtF
 Uzqd6t6lzINXHLOevsQewhe9T5vzyVzV9fl+QMPBHSYc1ucRXxRFferzoL0eYYT+WAMk
 u+q2AuywTIYV0EbIoFtWkNOLNYgoxyWmPo+mZh2vseVYFidSiAvPH5WBEa7enLTo3yK3
 THGSMEm1zXR1nXynxpuKHxRAWpHW02+n/x/4U6SL33t1HbeEjUTmX82SBXnCQJD88p6K Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36ybkb00mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:55:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j2Ue005612;
        Sat, 27 Feb 2021 00:54:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 36ucb41wwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:54:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpeHpCNyY1oGZBWgj7KoeZGEeAfHWlhsLxdunmSI1IoWkotnHIv9JRL5qBqC6WrNeQXq0tYKR35cOdry0hk0kN5oU8JVg158zn5i2q0Ec77iBRac3ol57lfOXbIwZq3wWi29OjtHA6y18Vl1Ok1hgxKfUUB5JJj6Pu2UEH+PQ40Nl23dE12WLms1jSFkrYAyd/uZ92D/f6U0qoWeeIW3lHfNelhOhDR19+FNhR0Wt00iH/tBVqFCrp/rxR7bWtI4F3veKXZvpQ8hHgqVtxMnbDWQILj3ibYo7YgBw7gKWqh9hUF5E1s6UoOVKPAxloJko7nAMUEyJSBTc5Nb6xUA9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRkDRQ6edF5QlbEJYDpJyOv77Y2z2FExItDrJcKrh08=;
 b=YcGigRpZZJVZ+wkK30ySCzKm6kJvPziqFIrLHgxkBtQF3LBTZ4MnwcVyPVJqFTAiM/FQuDhrq0zbpcs2QK/eqE3oLqLD6RM6IKuCFP4ynzWjDuj4vdVHoV4GV+bHFGElzBf1Jr5wGeRYZG7UJ8kx08mW+npSgqP5MjZ40mBykBTmBy74f6fbrypWXeN4jj3SGqs0ZESXHquhnjBMrDOKz4sxMv4JpIJyK8cIsBcaiQJqEqn192xd57DPx4Bnn/W9p89NBCtInPeWxbXYQI/tSgL+xf+DnHx6Qmzy7Df7pdMDUSmieGJno6JJeCj0IDQ++YFMh9OgdEtHFFOXmtpVpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRkDRQ6edF5QlbEJYDpJyOv77Y2z2FExItDrJcKrh08=;
 b=Q3qXoyvgMB4YsLxQ7cBmf/0aQaZ4GA3DesOzmwySDS/nTm9YayxixZGfUd63okPDsDy0UnaqU8mGP5/XdTFGxJwJvdYnQ4QPufjyBOsfn5/jXJq1EOROVl/R9zcrzB4hw2zJ1aVhMWwk2XYM4DHNTeX0lYli1+RWR+ASsJgf/nk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:54:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:54:57 +0000
Subject: Re: [PATCH v15 07/22] xfs: Add helper xfs_attr_node_addname_find_attr
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-8-allison.henderson@oracle.com>
 <20210226040654.GU7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c6432ee0-8c90-43a6-7a00-33cd403c52d1@oracle.com>
Date:   Fri, 26 Feb 2021 17:54:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226040654.GU7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0107.namprd13.prod.outlook.com (2603:10b6:a03:2c5::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:54:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2da1f52c-240d-4837-79c5-08d8daba4dc5
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43068C11BC14BDF5A28A7096959C9@BY5PR10MB4306.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fj+bcgnmsKFfSgQ8cZLdy3w4N9DEZ0XwNWkQsDq56m+1iiF2EZ/vVWnGa75C2nUK6DRsX/w+04zw8EGEnbUINM2F2FmOV6Hr4qQ/IWH9FruZe6m6vd8hypeLRuIn7QbQbdIb9Llu8h776sPqRpALOqYIlEm3nI2Ygyt8vqfU9r+F8ZRdXB2BfVI/3rHU4P8/yeq1/mblJYamiiQrsEqyarF02bBwf4IfwTmWlqrFmbbm1jpYvJ0ymxtnaHOn6LXQPF9zVC1IusP/4hNUP1aGCgJVhSaCRVO9qqYIr1w3TjTaCoUUPo8jIWzXz17xcV9D1nxDWiRXiZJhBEf2QjKb75p9RI6G0L66VUIbGJcK/n5L/gmaNNMmtDsVrrvTlsL1TFYHAnwmEkKY65U4jMLb4Xi6hfORCRvNucd7NGqNPtyaWi2aZPSuB3GQ9EBkn9Lfhe1zqe9UqDV1RphBdhfMZXghAdueHNGQSFG7b5ak9M4Sg45/MaZuV+3et6aaSWPFa4pO59EUVx0NydmfCKTzMmTvX44G07ESxkbbR4ZCSGUV6uyjdazjdHMb97QdTHljEYhynTjlk8aAU+/aMGi0+gg22tnXAy8pro9XjDBrKIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(366004)(39860400002)(136003)(8936002)(83380400001)(86362001)(6916009)(8676002)(16526019)(956004)(2906002)(2616005)(36756003)(186003)(5660300002)(66556008)(66946007)(16576012)(31696002)(6486002)(316002)(53546011)(478600001)(52116002)(31686004)(4326008)(44832011)(66476007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OVVTcXJ0VEtOUHJmMjRlNEozb2ZsbjgyVGdEbW5SUVFGMUtCK0VjenRlM2Fh?=
 =?utf-8?B?ZjE3L2VnbkVibk9ubnBoSVorZFU1akJCN1kwMTFYazNlajU5VW5ZQXNBekJp?=
 =?utf-8?B?cXl6bXNwTGxJV0lLZzFUV29HdWZjOHN4KzJnT3RoY0xnWThoMUEyQk8vMVBx?=
 =?utf-8?B?b1BQSjRGVjcxTi9VaktrM2o4TUEwSk55TDVsVlF5MEVCQnBNcTBUMmF0RlRY?=
 =?utf-8?B?WGduWlpkZnhvVmhuaWMyWXh3QWVvc1NCeEdIYXhKc1oyK1ZyMzI5NnNuVS9I?=
 =?utf-8?B?dklWa3BTVytLVVU2UDNCQ2xTRVpDNHB5UjhFNXNvVFVFZWJsN2d2TDFpYkJC?=
 =?utf-8?B?V3R5dzFZbmIxNmIweStEUEg1c1o3dU44aTRiYklvd2g2SkhraE4yczJ3NmtX?=
 =?utf-8?B?RGRMeFdQNTk4dXpiWlFYUWdrN09ockhCeVB1U0hiN1F3b2gvRHJ6dmNVN1Az?=
 =?utf-8?B?Wk5KK0dOcFczMTJ2Wm80UDJTdmtwSXJVZWkvZ2ozQ0kybGYxc0VrSEU5aWVH?=
 =?utf-8?B?VDF4eGFoNWJEeGdPNkp2bHl3SWw0Y2loUXJpS1V3SUVyMk85NVBJYWhWeE5Y?=
 =?utf-8?B?QW9YbGUvKzJBS3NLZ2Fud2F6U0tXK2llNjR3NTNwcVVMNGx4M1dvTFJvditG?=
 =?utf-8?B?dVRmdXNPOXU3TzA2cWhzUDFLZWVKcGdlK2huem9FSTk2U0NPTE1lUFV0U29X?=
 =?utf-8?B?cjNCc0xsTzFOZVlsVkRDMDdhUGFvTzJxdmQwMEMyZksvWjczY2o2RFltUkFt?=
 =?utf-8?B?czUrSlE3MVFWd2xmbFJSNTRsUTAxQTM1WFZVYTJQWGV5cjU4cWdWNDR4SmFn?=
 =?utf-8?B?MUUyVVh5OGhlaGwxWlVGeDNEako4VWRDTGZJQVhOYnhDN2xuU2czSldyeGtU?=
 =?utf-8?B?TzBZWnN6aUFVZHZiaHd1YnhzZ2ZFUVE0N3pvT3Nub0NSL3lWY0g0djNpcldW?=
 =?utf-8?B?K25qSWQxNThyVFF4L3dsY3BHNmNmbHNHKzFoaUtvQ0hDVHg2cGdCVHVzV3Bp?=
 =?utf-8?B?eUlsK1FxSlhrMGNTUVkrUnYzcUVBWWpWa0hFM0JKNXZXampvbm1lTGUrOURM?=
 =?utf-8?B?VWtsVmxITVF2Z1h1OG9RaitLNVA5ZVdTVkRCNnBvMFljTk81K0E4ajlVRzhE?=
 =?utf-8?B?YVhidEk1cExmVjBYWnorZVdlZ0JUUG8xRW9RbEFNNzFXZGlxajczV3huT0xl?=
 =?utf-8?B?Y0pkU2tFK1pUR0VZdDlueDFucHdFNTlkNWh5R3Y4bnFoUzh5b01xNjVmODdR?=
 =?utf-8?B?bGdvZ1R5a0IzYVFvaXBLR2VlSEx6TUx0TkVuTmpadEU5Z215ZUhjU1FKR3k1?=
 =?utf-8?B?N2d0VUJ3Q2F5VnFjdDA3Si8wNUpxeGx3MStCdXMrcjJ2Z0lob2tPMGh5a1E1?=
 =?utf-8?B?R1YzYjNLeEFDK3ZhOVdBbEFka1A4OEJYbWdNUXd6NFRpeThKNXFEMDFMenU4?=
 =?utf-8?B?WFdFMS9IUXJzZC9LaXBSbjR1Z3djQXZaQlA4aXd2N2NnY01RZm1QNkJpeXV0?=
 =?utf-8?B?RUNjOS9ORFY3WE9QL3F3dVR2VW13bXJzeGxRTlMwYkg1QUxNdlFEVEcrNmVZ?=
 =?utf-8?B?Nmh4OENoWUhWNTc0MWt5bU9IS3MySFdxWjI4TVB3YmdvZWQyKzJNeEtRNzYy?=
 =?utf-8?B?YmxKMmJOVE1rOVNvVnJxNmx2MnphZDR0UTU2TG01S3JGWjhua2E4Z0plbVha?=
 =?utf-8?B?bk05VTB6bTR3SUJnbzgyWlVCZU5PNzlHaFJIZ013NTVPTnpwVFBKeCsvOWpY?=
 =?utf-8?Q?G7bkCKydYILJE4hVPRw+4YnTouUZ5BNB6zwJpKA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2da1f52c-240d-4837-79c5-08d8daba4dc5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:54:57.7122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+FXXwrK9Rlp0SHDv7sx5rXDEwIXl4em6NhK17lXjxHnvMB7nGgl3HlLWdlC+RiIC42uMfKe0ZV/TNO4ZqVyuGe3mLrajO7nz2GHaDWlCWk=
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



On 2/25/21 9:06 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:33AM -0700, Allison Henderson wrote:
>> This patch separates the first half of xfs_attr_node_addname into a
>> helper function xfs_attr_node_addname_find_attr.  It also replaces the
>> restart goto with with an EAGAIN return code driven by a loop in the
>> calling function.  This looks odd now, but will clean up nicly once we
>> introduce the state machine.  It will also enable hoisting the last
>> state out of xfs_attr_node_addname with out having to plumb in a "done"
>> parameter to know if we need to move to the next state or not.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks ok to me,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Thanks!

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 51 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index bee8d3fb..4333b61 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -52,7 +52,10 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    * Internal routines when attribute list is more than one block.
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
>> +				 struct xfs_da_state *state);
>> +STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
>> +				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>> @@ -265,6 +268,7 @@ xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_state     *state;
>>   	int			error;
>>   
>>   	/*
>> @@ -310,7 +314,14 @@ xfs_attr_set_args(
>>   			return error;
>>   	}
>>   
>> -	return xfs_attr_node_addname(args);
>> +	do {
>> +		error = xfs_attr_node_addname_find_attr(args, &state);
>> +		if (error)
>> +			return error;
>> +		error = xfs_attr_node_addname(args, state);
>> +	} while (error == -EAGAIN);
>> +
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -883,42 +894,21 @@ xfs_attr_node_hasname(
>>    * External routines when attribute list size > geo->blksize
>>    *========================================================================*/
>>   
>> -/*
>> - * Add a name to a Btree-format attribute list.
>> - *
>> - * This will involve walking down the Btree, and may involve splitting
>> - * leaf nodes and even splitting intermediate nodes up to and including
>> - * the root node (a special case of an intermediate node).
>> - *
>> - * "Remote" attribute values confuse the issue and atomic rename operations
>> - * add a whole extra layer of confusion on top of that.
>> - */
>>   STATIC int
>> -xfs_attr_node_addname(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_node_addname_find_attr(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state     **state)
>>   {
>> -	struct xfs_da_state	*state;
>> -	struct xfs_da_state_blk	*blk;
>> -	struct xfs_inode	*dp;
>> -	int			retval, error;
>> -
>> -	trace_xfs_attr_node_addname(args);
>> +	int			retval;
>>   
>>   	/*
>> -	 * Fill in bucket of arguments/results/context to carry around.
>> -	 */
>> -	dp = args->dp;
>> -restart:
>> -	/*
>>   	 * Search to see if name already exists, and get back a pointer
>>   	 * to where it should go.
>>   	 */
>> -	retval = xfs_attr_node_hasname(args, &state);
>> +	retval = xfs_attr_node_hasname(args, state);
>>   	if (retval != -ENOATTR && retval != -EEXIST)
>>   		goto out;
>>   
>> -	blk = &state->path.blk[ state->path.active-1 ];
>> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
>>   		goto out;
>>   	if (retval == -EEXIST) {
>> @@ -941,6 +931,38 @@ xfs_attr_node_addname(
>>   		args->rmtvaluelen = 0;
>>   	}
>>   
>> +	return 0;
>> +out:
>> +	if (*state)
>> +		xfs_da_state_free(*state);
>> +	return retval;
>> +}
>> +
>> +/*
>> + * Add a name to a Btree-format attribute list.
>> + *
>> + * This will involve walking down the Btree, and may involve splitting
>> + * leaf nodes and even splitting intermediate nodes up to and including
>> + * the root node (a special case of an intermediate node).
>> + *
>> + * "Remote" attribute values confuse the issue and atomic rename operations
>> + * add a whole extra layer of confusion on top of that.
>> + */
>> +STATIC int
>> +xfs_attr_node_addname(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	struct xfs_da_state_blk	*blk;
>> +	struct xfs_inode	*dp;
>> +	int			retval, error;
>> +
>> +	trace_xfs_attr_node_addname(args);
>> +
>> +	dp = args->dp;
>> +	blk = &state->path.blk[state->path.active-1];
>> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +
>>   	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>>   	if (retval == -ENOSPC) {
>>   		if (state->path.active == 1) {
>> @@ -966,7 +988,7 @@ xfs_attr_node_addname(
>>   			if (error)
>>   				goto out;
>>   
>> -			goto restart;
>> +			return -EAGAIN;
>>   		}
>>   
>>   		/*
>> -- 
>> 2.7.4
>>
