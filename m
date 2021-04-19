Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107D5C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 18:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0AD761360
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Apr 2021 18:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239801AbhDSSck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 14:32:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56838 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhDSSch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Apr 2021 14:32:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JIUKZm114313;
        Mon, 19 Apr 2021 18:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Z10zUjjG7jYlnzCSkEB96BegFtE+eG9o2cIG4E5jX3k=;
 b=oDMnRW6yO07kAX5dIc7khYyLwnflczoemYsOg2+qqIJdU+TJJguq3Ty7P/fHUKtNW/Bo
 ITKBiRZQ8aCxSpcxjF1c7+q6oPhCZ4pCR5eM3KajJ3iQB3ITukfJwFDec6C5wYTBywzF
 cIxC2EkEWRe9c4NILqmqBJTX8yJ2pKZ67Gsn/jptpFVFZOYUMB48rbd4fuFzgylcBX/Q
 dSNwG/izc5HHrSThRn1QPa824kttSkVZMEz5w9+ULvkbpLIqACDChKSeaYShfhuIJ9Qr
 s8HF/9UA+RILTvy4tO1tmYjft0OzUo1zPfkpWywFMJ3Inx4ayMxcrHVqvFSHgm8TkxqA og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37yveacbxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 18:32:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13JIQx1q090310;
        Mon, 19 Apr 2021 18:32:06 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3809kwtxj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 18:32:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbEBrNd/7xL7f1MC+2LiORWMLvgB3fZb8xYSt4pTHrBTG/Rp0BP6pkkRi0R20HcPIbeZXALeKMkPpFIwZ5p3YpI0PgdZgbQjKH8eI9XppQXK68hhGoV3fxn33W9tqOqmcS6+n5XDupooeNO1QhljVo78n4ES6j5ydfseYySfmeHWjisY16ynS0NH4UfK4XwrW6S7LYJilBBORlzzAzRhw+H+L4pLCcfZnlRCtAONNynNvb1xh3gy6b0CLK5mMdtT2SyBCZNbSnFKBNR55yMxiGvxGiJ6XBxfeNmbiNL5lQDC9RX9jQAV1GwagXaJPJ3o6SIYb8W6yp4Gxxst4tovXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z10zUjjG7jYlnzCSkEB96BegFtE+eG9o2cIG4E5jX3k=;
 b=bTtGdH8gwo+l0IKAKbbDJGeJB1W0AoBVs/iigbRqUMq5/9WX6Dy9x37AAq8/JojcZxbuootNI4mKMFwUcWFDZ9YVF9kTiQJFG9lCOIQTx5o/K7vYofkyP1VH7MOodzr1r+3TzmhceQEBBX7vqs80hogSL9ZRdPyVTNTmRH5lt3pZ3ZpCs3oosvYTBRamhER/b7b0jAoaiO7ReYqzC7c15s7LDuEbJF5SL/P0GX7xTUNUs4TD4pFvv4PwaYAuYcVraBhxrIogBZ+PwSFwppzaChvf2qmrKA/0+l6qIVG2LbJuZt02CJ9Z+bA+gAEvWO1GXWDn9mQESosBY1bVRI+zHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z10zUjjG7jYlnzCSkEB96BegFtE+eG9o2cIG4E5jX3k=;
 b=xvhzR5uUd45CoV5Kgw58YXCPHQhFqazbXzCQKZkxMkopS+3wLHrBANasXrUzrkdQm3Cl9Q/5F6bfFOvjZro50pxOEIBtwYFmx7azaZpTB+ocGjB8vWYuUxTyla2IlUE+dhWsyZ3vgmu4ixHychwifCFr3xfM0tJv3T+IUmmWHiw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5471.namprd10.prod.outlook.com (2603:10b6:a03:302::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Mon, 19 Apr
 2021 18:32:04 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 18:32:04 +0000
Subject: Re: [PATCH v17 05/11] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_clear_incomplete
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-6-allison.henderson@oracle.com> <87o8eaj1mr.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a83a5de6-2e6c-c4ec-12cd-b99522e83bc8@oracle.com>
Date:   Mon, 19 Apr 2021 11:32:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <87o8eaj1mr.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: SJ0PR03CA0206.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by SJ0PR03CA0206.namprd03.prod.outlook.com (2603:10b6:a03:2ef::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 18:32:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7f2e353-da94-4ad2-3e31-08d903616dc4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5471:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54719BDDE3B96B0D62D499D995499@SJ0PR10MB5471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnUMsKn4pZGoZQ98HE+ZrgizqdP2l5u047b28M4dACId6nm0Wqzd6cWaR+OH4JFQdNCvkXxokOUXloBtI6UR+rWbaQpZ3sRQKJj9eI8/2EBLc2xbXG2jo1Yr20Z12hApK38hIbYmwbRMEzCkIk0eV2nPNxCHAT0+mJ4C4wqwGoXOdzuC505bXqPF3IEapLutXsvUsrgWUhBArLx+gtsfxREUl+wMB70qZ81tKkEIDQu+E+kNCW3fuRy91P8mk4cQoDdmnXjefV0Q32bol9fzi7wNVzLsw18qNMuxfZMDFZ7UdgCSaaRic3hhvpyufAsPhDtCboNxvAyLtrlSC4Z5Lko97tS11cAwJmpZI8ozH3hiu31sxCFvYJ7PxUKMNXS2AFnZEMok6qoOZKBpbPZQClsT5DuOFQWorajnjDwrZJu8ZxhFf8J4xgLmE3WqoSEh5OXi6yx68+6XXjbrDDz8rd1OrVi12fu3ldzeVjZTThYQUHMmPU6SvDy0S7BQepe5SdYXlFZZZ8ETYrE2PnpA9rSgFz68GClL5R009I1V5bMWHfR/8+6pRV44tJXf6z4lODnNOhYoJjrRKGo5wbfs5BRH1OhCpvxd0IOHTRFtQTnHnabH+MrRY+nSmXb0nLy5wG4qavbRyQBMKsgaN7Bc3v9Ti2GBN2MbuHPjP9xp8dB3S4xXDrcHKUVGCHhOZGDNvzAnkk4u5dJtJVdVjPiQ7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(6486002)(186003)(31686004)(36756003)(53546011)(2906002)(4326008)(86362001)(31696002)(44832011)(16526019)(316002)(38100700002)(83380400001)(8936002)(2616005)(16576012)(66476007)(5660300002)(38350700002)(478600001)(6916009)(956004)(26005)(8676002)(66556008)(52116002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bFhvWGpNcHZZZERYYXlEamF2UzZzN3hwVzNXYUVNMm52SW1JbTJ0YmxjTm9t?=
 =?utf-8?B?ZHVrOTJwNWJhcmhIZnV3R0drKzU1cDI3aUdGZUVDTHpaUExOQkx4WCtrNVhN?=
 =?utf-8?B?S1k3VUIxeG1VOXM1cXd6K3R4ZUpIdlRwREErVEFSekNDMFVNRGRHbThKdElq?=
 =?utf-8?B?MWxHcXpCMTlDSmwvZU4xd0ZDQmgreXZBalo1M05raDU2RzFrbVkyZk9QYTFt?=
 =?utf-8?B?U3NkTnhjUFhPdThwdXRxd3VPUHI0R0w5QTJaMmpmMnc1Zk9sRDlRUWRSZjFp?=
 =?utf-8?B?RTVrVnpReHVVNm1TeFZ5YjJjR3loTVVjRmIxdmtLektvY1ArdWcrelNTMlg3?=
 =?utf-8?B?MDBEMG1sV3AySzNTdVlucDMwVVNJNEdNTVhXWEVVeDVOWkxkMzV2NFNMRW1H?=
 =?utf-8?B?L0lEZDVqdEs1eE96NDJidTZobjltUkZMVmtLT0psRVhwK1paKzQyZGh6cFpk?=
 =?utf-8?B?MUZWcVRNMVhaeVJZR1hhQWszRzdPSVRhM0wrdUltbW8yQStOYXgwZ3lsVUtE?=
 =?utf-8?B?U2FJa21YbGhuV1VLWisxZ2hDcXUzOHdrSHJvbE5GN3FEU1RtRnBjZmRYWm1h?=
 =?utf-8?B?Rk1pM1JPM1NBMXlFNGwwVlFodFRMdEdBUzVYaDZ4MHNZZDh1TWdmcDNDUGhX?=
 =?utf-8?B?a3BWajlaU25VQSswY1Fvbnk0K1Bzb0hIeE5YQUpJTCtvK2IwQUxNcVBUUWVT?=
 =?utf-8?B?M2w0ekxsdThncThSTjFHNGFlRlZKRmdYanhERWpjWGRHcGVRUDRySkpHbVJB?=
 =?utf-8?B?TzhTREJSdkRKcUpBb3prTjJXMVpJVnlIcFUwSnBWTjJDZUo0bi9lZTJOT01Y?=
 =?utf-8?B?aHhSSVpFU1hZZE1wcHRCQmgvK0pxRmRaaFBic25WV0JOUDBCUXpmNklqTTg0?=
 =?utf-8?B?ZTRjS0E1ODl3dUtGaXE1NXFFQ3pBRXBWNis3WjZuOGg5TjJLTCtJRGZZZC9Q?=
 =?utf-8?B?ZUxmM0lVSmVadHdtUUlaRjlCZWI1dUFLMVhFNGZISFdZRElHZWNlTUdCaGN6?=
 =?utf-8?B?UXVQZUVROUxvR3Y3d0k2RWNxUzNNYlZ3MFpWUDR4RUNobzROcUlLVWowdC9Y?=
 =?utf-8?B?SmpHRnQxU1ZXaDNxVC9rR1NoWFd6SjVCY1VHUjhubVBlOGQ2VGlaeUxpTExO?=
 =?utf-8?B?TnQ4RjB2VW5SQ2NIbGZsakJLWG4xdlZTbUUvb1dtNDc1bVVNZGxsc3FoVGNL?=
 =?utf-8?B?MnpNSjZuL3V1djRGZWlkVVZIS0UrZURGLy9SRmJiUVkzM0ZPak5mN3lsZnFn?=
 =?utf-8?B?dUV4b0p2anJORTdLSFZsRDJPQUQ4THVyTUFUdldjYVdxdktpSUVjM2MrR3do?=
 =?utf-8?B?UWFFNmFSSFZ3YStja3czOFNLdmd1N1FFTUFCT1hlcmpFamRLbEtTL293VEFs?=
 =?utf-8?B?dFJCeTZYaEE2SFUrZktDcHFrL0R4NDArdGtnaWEzclNaSjhLS1BBQXdHY0xF?=
 =?utf-8?B?bldUN045REZENWY4YWs5NVBLRlkyMVp6TzVYazlMTmlOTCtHcGo3MXNIV2c0?=
 =?utf-8?B?M3lHN2RIRkVUaVVyejIvRkFhZEw0TnBuWnk2V2p2cFM3dFNmYTZQaDRaSEl5?=
 =?utf-8?B?a0pTZGd1MnNiUi81Q3ViVlZaZU5VR2FqK2RUSUpMczFJSXJDS2VrN1BhUGRQ?=
 =?utf-8?B?TlBtdCttNXMrUlVWa1F2MDBMSW9hcHpIUHhpZmdUZEU1Y0NqNWVETm0yRE9R?=
 =?utf-8?B?K3RybkkyRzhJY0Ezejg1ck1vQTludTMxUDcyT2M2R0RIU3ozMUp5eUFVVEdr?=
 =?utf-8?Q?KuuEczo2mWmiPpFoQF2lsqQouNoYV0HWLm+ySLM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f2e353-da94-4ad2-3e31-08d903616dc4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 18:32:03.9597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7X+5N3ac6VQ8bRH+KmKWOHYxqRxjv28Of4o32AHWU8pGmt29jS+/bxGtkORxcFmc/eIKRa5rO3gti12/dItYupqVbXB/9Wh4XewAhCoxAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190126
X-Proofpoint-GUID: 8KmKcKHskSCQ8BPWZoDgjzpvYU11pa91
X-Proofpoint-ORIG-GUID: 8KmKcKHskSCQ8BPWZoDgjzpvYU11pa91
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104190126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/18/21 10:15 PM, Chandan Babu R wrote:
> On 16 Apr 2021 at 14:50, Allison Henderson wrote:
>> This patch separate xfs_attr_node_addname into two functions.  This will
>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>> state management
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index fff1c6f..d9dfc8d2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>> @@ -1062,6 +1063,25 @@ xfs_attr_node_addname(
>>   			return error;
>>   	}
>>
>> +	error = xfs_attr_node_addname_clear_incomplete(args);
Ok, so i think what we need here is an extra few lines below.  That's 
similar to the original exit handling

	if (error)
		goto out;
	retval = error = 0;

Looks good?

>> +out:
>> +	if (state)
>> +		xfs_da_state_free(state);
>> +	if (error)
>> +		return error;
>> +	return retval;
> 
> I think the above code incorrectly returns -ENOSPC when the user is performing
> an xattr rename operation and the call to xfs_attr3_leaf_add() resulted in
> returning -ENOSPC,
> 1. xfs_attr3_leaf_add() returns -ENOSPC.
> 2. xfs_da3_split() allocates a new leaf and inserts the new xattr into it.
> 3. If the user was performing a rename operation (i.e. XFS_DA_OP_RENAME is
>     set), we flip the "incomplete" flag.
> 4. Remove the old xattr's remote blocks (if any).
> 5. Remove old xattr's name.
> 6. If "error" has zero as its value, we return the value of "retval". At this
>     point in execution, "retval" would have -ENOSPC as its value.
> 
> --
> chandan
Thanks for the catch!
Allison

> 
