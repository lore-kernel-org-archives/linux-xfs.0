Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256C3C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 07:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347643AbhLAHi0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 02:38:26 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50930 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347712AbhLAHi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 02:38:26 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B1710NX007277;
        Wed, 1 Dec 2021 07:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nn9Td8hHVkzV+d5WpnKtGyYAkXeYv52tugjHhYlNkgQ=;
 b=NHdANE4jHiB/r2BZHX8geey2r83jKOX6bET3otEygkkgOjM0vESZNvnwp8HX2PpUcbaL
 5iaX9Ro+xqvoDcZbwj8hX3WfBJeiu/EStu+ZVx2G9RjKpGj7yZ0E/ZX1l+VfPSIOpsBi
 vgSxmZ395cyRh0+7D2D9iz6IuVd7mtaLnsjlGpmL10uhmk9/e2NNoWCEnEy/pB50jVNa
 OkqHwryxjvrWDBFihJn5wnH9t08dZFMvg4BRpEneFDPhJi3t3eJEpqcYYfQTj48S9Xi5
 YDQ8lNKS4MQl/0yitUu82IJGmHsISrtOEq2nWhGOTl4Kdgp0W6xMXZae/Iv98SoHnDzs cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmuc9y2yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:35:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B17GKQV032031;
        Wed, 1 Dec 2021 07:35:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3020.oracle.com with ESMTP id 3cke4r9tg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:35:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXvs9360+bGLxmT0sIWrWH+UoPW5bioY4EoVH7K+MfLtLyt6joMBlAGoFwcq1J7LAD7hMsd0NFfKFMVNyp0t5I1p1LZP2hvZdMjGgbcQbu7Xc781J6Svj3ZD67yOVJ0iX8oisjfPs1DTJRgyUapxfkECSbIF/f51Bwe5Ltprdrk6qcnZl+1YwitG+NnKtcRqsoSE6UaSrV4dmCICiWtpJ1KIzXhSyIVAaqoxMvIKPMgIJdVUqgG+/7LSEW5s7civy9guXQH9Dm+GDvsApDL2DhoDraGJjhvUB3or+Ydc23RPWA+UGtIJbSM0kprdDygdeA3NhwJsIv+HllxqAOoaXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nn9Td8hHVkzV+d5WpnKtGyYAkXeYv52tugjHhYlNkgQ=;
 b=lsuodfDZWLll1D1I3AckHbg3RMXnob9CD2C+vs28IYGUT6Qg16+M3ydw63ZiGQnwtBEMWjPXcmNn7x6kftJkQ/tqe40nlQE5yu+CiJOdn7OQX+osBLKuBpSDxeUs2ctOtO/V4CzS5D2GXSEpk2WaOyjGeffVli8Mwy9UNtbYDoc5vPMuH07J+07b0o/ORLbJDg4CVaOAz/WggUEsj5qVNarB1/+7jdT9h0ly+fo/zvXuVGqK+FNPOBeS1SSriICppEE+GRlZQ7x2iAimA9KaXa3/m1jhjLri06DHPCng2gkg+sRSMND7GhDxWJAfzNIl6FQmVNCPD+TtVVUxPvrWMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nn9Td8hHVkzV+d5WpnKtGyYAkXeYv52tugjHhYlNkgQ=;
 b=KJKc0bDH3C8HoyFIcwtdsjy2fMgga7Mkx1CQktD0wOS7Zz+ACbgUqFX69X+p0fWRckxGDDqD4uNMPVKgSEkt0dVzocPbRlP/GWVBrbAn/m3uMroLq4vq5bFa+Ax3M1vEsK3EF3gtgSugiPTlAzZ0orriaefR47fpC8JNLToMmEE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (10.255.126.71) by
 SJ0PR10MB4429.namprd10.prod.outlook.com (20.182.112.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Wed, 1 Dec 2021 07:34:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.029; Wed, 1 Dec 2021
 07:34:58 +0000
Message-ID: <e000662b-e7c4-e61e-4658-ac0990bdf32c@oracle.com>
Date:   Wed, 1 Dec 2021 00:34:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v25 05/12] xfs: Implement attr logging and replay
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
 <20211117041343.3050202-6-allison.henderson@oracle.com>
 <20211124001129.GA266024@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211124001129.GA266024@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:a03:60::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.6] (67.1.131.99) by BYAPR07CA0046.namprd07.prod.outlook.com (2603:10b6:a03:60::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Wed, 1 Dec 2021 07:34:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8458162-03f9-40f3-9881-08d9b49d135b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44291FCA204A4A52DE9A8EE495689@SJ0PR10MB4429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AsJW+vuu6TSg28iK3DbkqUAF4O1jlQA30jWNNUcSngiPTxMzdeIceWlko8wnSGn4xcRkNqIFbGjqADC+twVZ996xRPmwRDFF6W9jbJnV4Adx0BLsW/7Y8oL/TRpNVspaFAO+5jVaxXmZILZyFWa61fln3Gw84vG9kht31img8JNdUWO/VI4hJF1kUuOfuafHEsF8BqKa84a6W1+Yx88cTwl0vT66imHsUqQgHjvUWz6wmsKft7UVIa68OZWsJZ7z42jQRefzReSoq9FtDzR9n6uc8TIzPe78QzNhKYJ+t5NcXciP9P09bDsp9vMVowaieqzf48mVM97IQ5RbaHAfilWuxO//rCJFJJVKJEWuNIOcU1FL15bc6ODrpoC8J9gSznq5ibGjNrBqHO6xOFzupQX0mEnWXI1BSn3wupflZH1oESkjk7FStT05t77BPqfzc5UGFgcLYY/d/IBDA0nhnV4uP71xxcXyc93lZuE8Y/fRa9vCkhAbhn/ky4nnsL3GlQd74Te/cXM18rY+g8RKWmyVwtiJg8Rbi+8C2PPZzMbomeWFfXJBlV3/OkAjjA6iUTlZtw4Sm1O4CTPHkpw4lFnPLpGjtHQs+j3QQGu2B4xwG1wW14uKS8+5aYyYc///C2J+/B/eIQSJ2KxYDxMBU8OTwDH/CADOtpV2QlyDO9uf6F48cGF+57WKB+4Bngucbh2aCAAw/Ir6HvWSIoVxQ07494zxEhWHgGzZ2Y1HvmQDA+HzjQf6vZZYkdHyEFAlVnfzST2DKiznE3naxyDjvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(2616005)(38100700002)(4326008)(6916009)(31686004)(38350700002)(8936002)(30864003)(8676002)(44832011)(6486002)(5660300002)(86362001)(508600001)(52116002)(31696002)(2906002)(186003)(36756003)(83380400001)(66946007)(26005)(66556008)(66476007)(16576012)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WS9IWFBiTnNjNTRrQjh0dHIxbng2bGJReUZuems2bHUwUlcraVVKeDN1LzN5?=
 =?utf-8?B?cmZVeXc4QmpqeHNickc3NGk0K3hKS002NUhEOEdMZXEzNER2dUJCNHBXaWdL?=
 =?utf-8?B?R0Y1emU1TmFWMkNFMlNhMFl2TTVUWDBhV0lYQ3dnbk16RXJUcGM4VURsaHl4?=
 =?utf-8?B?bW5vc29OMGR5aU1oQThFbUt1bE5QdC9tS0d0NlBRVHF2dHV6QlVINWZuMzd3?=
 =?utf-8?B?V2doNmwwMU5lYTdCR1l1VlpHMUk0RmR0TGpkZU9CNExPbkVWdmZmbDdvaHpZ?=
 =?utf-8?B?QjdPKzd3NTRyTEhFcUpFRVN2T0xRRWV0VUNEZUZGNUpzWm13Ri9GZlE4TERD?=
 =?utf-8?B?a2RYYmg2SENxL2wzRUx2QytCWmNudnRlWW1OdDl1VWRnQzNEMG1IaVRTU3pM?=
 =?utf-8?B?dGxla0pLQndLZnBMYWpMMVJUdlpjQmsyajJ6QVBwdUQ3NUJWSWVQeGxxVFVL?=
 =?utf-8?B?YWFRK0FtK1FWb0dXN0hHM3picjN4MjNKTVNoRDl2ZEU3cnJRUjhJYWRadDlE?=
 =?utf-8?B?UXNEWlVWZXB0SkppQUlrZjMzS04zU1NGT0hLc2c0NFRTTUszTzVzYmcxc1B2?=
 =?utf-8?B?ZUpxZlVDL0lhSW9ET1doTkt3K1Eyck5tMnF3aG5VOVlKWVIrU1k5SHFHNkE1?=
 =?utf-8?B?K2NmZG1zdU1rNU9oU0dTdmU2bXppVU1WSjJUT09xeWVWUFEzWGhZOGYzKytT?=
 =?utf-8?B?NzhoeVJHdGhBRy9iQUNsYU5KdnJ3cGIzc1ZEaDlOQWVFandXMTFZMThhVTNO?=
 =?utf-8?B?a1pTWGl6QVljWTUvRTZCbWQwY0ZIWFZWUUloRStVNVRKODFWYU12NTQraHk0?=
 =?utf-8?B?cXNwY0xWS3NDYXJ6UitpZUVuaVdWU1lnem1jTndFeGh5V3dNUXRGaHg2aFAz?=
 =?utf-8?B?NWVCR3BheTZ0Y2lDdHkvMzhNS3BrVEw2K2l6aS8vU29idGFLSmxXR3F3VG81?=
 =?utf-8?B?MVZOS0U5MHZ3T1kwOHdHT1RPVDNNbi9IM3lDS1JseWkwNUN4YmJQMC9URVJt?=
 =?utf-8?B?Wnh5enIrK0gzVUtGcmZYQUlWelRBM3FCM3dPSVE0Q3pvbzhaNmJMb3dGUFc0?=
 =?utf-8?B?dGEzKzFkc1FXcldwWGlhSUVKT2ZrMnIyanRYQ1pKZ3JZTlAvcTM0Tlh0Yk1h?=
 =?utf-8?B?ckx5UG1pd0FSZmR5WHpsV3FWbS94SzRQRmFsWGFqY3NEUXNSREVtZWFkeXhO?=
 =?utf-8?B?cWFHMnIwYldnQzEwbU9YRE5uRmFSRHRyNncybjRDcWFpZU5oUkg0aUVTRXUw?=
 =?utf-8?B?NE1YR3EwOUtHbk50czFmcFlqMWRhVk03RTJnb2pYY1RyTEx0d05pTGxHQ0t3?=
 =?utf-8?B?ZUpUMXd3dGFoL1UrNVNVcmZ5d2N3L1c0SVEvbXVNcVM1MlVOQnJQQnBoZyt4?=
 =?utf-8?B?QWZaT3NDRzg2aXBBR290aWFwRENiQklzalI3aWRtRDk5OU5KL2xzK0hEWXVn?=
 =?utf-8?B?a3hKVjVKQVpzS1NUeStvL3JqNVJRR3E1NytGZXpzdGIvRWtscjBZNmpxMyt1?=
 =?utf-8?B?SzE1cDloVjk4aHBuQ3U4cktLaE5oYXZ6VEFsNGRqSWxFaW9rTGliK1RDYkV4?=
 =?utf-8?B?c2o5bFNsTU1sMWhMeVM5M0d1azhTV0xTaXo4YWdHU01RNGJnSExyTG9ZVzhM?=
 =?utf-8?B?NmU4c2N3TTZxZklDakNGMVFqanFsaS9tZWVYME04NWNYUFIzVkR5OFdXemVt?=
 =?utf-8?B?aFlJSS9wRTZZK2tDN0gwaldJUGU2RzhYWTdBVWtlTExKVmsrMXh3TE5rWXJw?=
 =?utf-8?B?dHFqTDdZcVdlcGFJQUM3UEdsMVROU1BnRGF4K3h4YkowTE8yL2ZYNlZicStp?=
 =?utf-8?B?d0owaU0vMm1TajhDUi8rcjNjNjl5dzFHN3U2ZTlWa012dFF3YWhoVDgzbDJZ?=
 =?utf-8?B?aUpQNHpYdlp0YkVBY0piOUNzSEV0b0xzaEkxczIwZllvYmtsOWRXVm5XckU0?=
 =?utf-8?B?aWdkbTE0RzBRSlhUVXMyVDkvUlVMSkEwNFQxNHVkZHpDaWhjdFpab0ZJQm1L?=
 =?utf-8?B?bDQ3QkxQdHFXVUFreWhwOEY0NlJLYitOeWNtWDh2bHZqS3lkRnFqYVp0N1cy?=
 =?utf-8?B?a3d6SEw5NmNCVXBVd2orQTNKbXdZR056dEhIMFZKT1ZVNzJtcFZzZ3BnKzZi?=
 =?utf-8?B?cHFZT3R0Z2VUNzJoU01VR2FxUVUzdkI4Q3RjNm9Yejc4Sk9hdXg2bzAyblpN?=
 =?utf-8?B?MWZURXg2VWcxVERZR0I5RVAvdGNyaDd3UGJOb1VwMTF0N01KdHB6dkpRMldi?=
 =?utf-8?B?QVF1QlpOcUx2bVRiYlFPTkdLdUVBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8458162-03f9-40f3-9881-08d9b49d135b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 07:34:57.9182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Snud0rFimWJoSMnHzmJ6plVjln1d9ejwdiQWvwfAkB1br91/25ff71Wo5V4Kt6VICuPIDb8e4fJznXgPxCxvgBoeLbFiPC+3yigRObSZPys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4429
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010042
X-Proofpoint-GUID: hjMqhpHMug6nnXy8Eu4InUpA8ReqmGeE
X-Proofpoint-ORIG-GUID: hjMqhpHMug6nnXy8Eu4InUpA8ReqmGeE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/23/21 5:11 PM, Darrick J. Wong wrote:
> On Tue, Nov 16, 2021 at 09:13:36PM -0700, Allison Henderson wrote:
>> This patch adds the needed routines to create, log and recover logged
>> extended attribute intents.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  |   1 +
>>   fs/xfs/libxfs/xfs_defer.h  |   1 +
>>   fs/xfs/libxfs/xfs_format.h |   9 +-
>>   fs/xfs/xfs_attr_item.c     | 362 +++++++++++++++++++++++++++++++++++++
>>   4 files changed, 372 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index 51574f0371b5..877c0f7ee557 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -185,6 +185,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static bool
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index fcd23e5cf1ee..114a3a4930a3 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>>   	XFS_DEFER_OPS_TYPE_RMAP,
>>   	XFS_DEFER_OPS_TYPE_FREE,
>>   	XFS_DEFER_OPS_TYPE_AGFL_FREE,
>> +	XFS_DEFER_OPS_TYPE_ATTR,
>>   	XFS_DEFER_OPS_TYPE_MAX,
>>   };
>>   
>> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> index d665c04e69dd..302b50bc5830 100644
>> --- a/fs/xfs/libxfs/xfs_format.h
>> +++ b/fs/xfs/libxfs/xfs_format.h
>> @@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
>>   	return (sbp->sb_features_incompat & feature) != 0;
>>   }
>>   
>> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
>> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>> +	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
>>   #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>>   static inline bool
>>   xfs_sb_has_incompat_log_feature(
>> @@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
>>   	sbp->sb_features_log_incompat |= features;
>>   }
>>   
>> +static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb *sbp)
>> +{
>> +	return xfs_sb_is_v5(sbp) && (sbp->sb_features_log_incompat &
>> +		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
>> +}
>>   
>>   static inline bool
>>   xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> index 3c0dfb32f2eb..5d0ab9a8504e 100644
>> --- a/fs/xfs/xfs_attr_item.c
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -13,6 +13,7 @@
>>   #include "xfs_defer.h"
>>   #include "xfs_log_format.h"
>>   #include "xfs_trans.h"
>> +#include "xfs_bmap_btree.h"
>>   #include "xfs_trans_priv.h"
>>   #include "xfs_log.h"
>>   #include "xfs_inode.h"
>> @@ -30,6 +31,8 @@
>>   
>>   static const struct xfs_item_ops xfs_attri_item_ops;
>>   static const struct xfs_item_ops xfs_attrd_item_ops;
>> +static struct xfs_attrd_log_item *xfs_trans_get_attrd(struct xfs_trans *tp,
>> +					struct xfs_attri_log_item *attrip);
>>   
>>   static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>>   {
>> @@ -254,6 +257,163 @@ xfs_attrd_item_release(
>>   	xfs_attrd_item_free(attrdp);
>>   }
>>   
>> +/*
>> + * Performs one step of an attribute update intent and marks the attrd item
>> + * dirty..  An attr operation may be a set or a remove.  Note that the
>> + * transaction is marked dirty regardless of whether the operation succeeds or
>> + * fails to support the ATTRI/ATTRD lifecycle rules.
>> + */
>> +STATIC int
>> +xfs_trans_attr_finish_update(
> 
> You could shorten the name of this to xfs_xattri_finish_update.
Sure, that sounds fine if folks prefer that name

> 
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	unsigned int			op = op_flags &
>> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> +	int				error;
>> +
>> +	switch (op) {
>> +	case XFS_ATTR_OP_FLAGS_SET:
>> +		error = xfs_attr_set_iter(dac, leaf_bp);
>> +		break;
>> +	case XFS_ATTR_OP_FLAGS_REMOVE:
>> +		ASSERT(XFS_IFORK_Q(args->dp));
>> +		error = xfs_attr_remove_iter(dac);
>> +		break;
>> +	default:
>> +		error = -EFSCORRUPTED;
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * Mark the transaction dirty, even on error. This ensures the
>> +	 * transaction is aborted, which:
>> +	 *
>> +	 * 1.) releases the ATTRI and frees the ATTRD
>> +	 * 2.) shuts down the filesystem
>> +	 */
>> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
>> +
>> +	/*
>> +	 * attr intent/done items are null when delayed attributes are disabled
> 
> logged attributes?
yes, logged attributes is more accurate i think

> 
>> +	 */
>> +	if (attrdp)
>> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	return error;
>> +}
>> +
>> +/* Log an attr to the intent item. */
>> +STATIC void
>> +xfs_attr_log_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_attri_log_item	*attrip,
>> +	struct xfs_attr_item		*attr)
>> +{
>> +	struct xfs_attri_log_format	*attrp;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>> +
>> +	/*
>> +	 * At this point the xfs_attr_item has been constructed, and we've
>> +	 * created the log intent. Fill in the attri log item and log format
>> +	 * structure with fields from this xfs_attr_item
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
>> +	attrp->alfi_op_flags = attr->xattri_op_flags;
>> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
>> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
>> +
>> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
>> +	attrip->attri_value = attr->xattri_dac.da_args->value;
>> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
>> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
>> +}
>> +
>> +/* Get an ATTRI. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_intent(
>> +	struct xfs_trans		*tp,
>> +	struct list_head		*items,
>> +	unsigned int			count,
>> +	bool				sort)
>> +{
>> +	struct xfs_mount		*mp = tp->t_mountp;
>> +	struct xfs_attri_log_item	*attrip;
>> +	struct xfs_attr_item		*attr;
>> +
>> +	ASSERT(count == 1);
>> +
>> +	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
>> +		return NULL;
>> +
>> +	attrip = xfs_attri_init(mp, 0);
>> +	if (attrip == NULL)
>> +		return NULL;
> 
> Hm.  To answer my question from before -- if we can't allocate memory
> for the xfs_attri_log_item, we silently fall back to not logging xattr
> updates.  That's not good, especially since the fs is configured for
> LARP mode.  At least for this callsite, the allocation should be
> GFP_NOFAIL to avoid this.
> 
> (For recovery, which AFAICT is the only caller to make large
> allocations, I think it's ok to omit GFP_NOFAIL since that shouldn't
> happen, and having to rerun log recovery isn't the end of the world...)
Sure, I can plumb in a alloc_flags parameter here

> 
>> +
>> +	xfs_trans_add_item(tp, &attrip->attri_item);
>> +	list_for_each_entry(attr, items, xattri_list)
>> +		xfs_attr_log_item(tp, attrip, attr);
>> +	return &attrip->attri_item;
>> +}
>> +
>> +/* Process an attr. */
>> +STATIC int
>> +xfs_attr_finish_item(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*done,
>> +	struct list_head		*item,
>> +	struct xfs_btree_cur		**state)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +	int				error;
>> +	struct xfs_delattr_context	*dac;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	dac = &attr->xattri_dac;
>> +	if (done)
>> +		done_item = ATTRD_ITEM(done);
>> +
>> +	/*
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
>> +					     attr->xattri_op_flags);
>> +	if (error != -EAGAIN)
>> +		kmem_free(attr);
>> +
>> +	return error;
>> +}
>> +
>> +/* Abort all pending ATTRs. */
>> +STATIC void
>> +xfs_attr_abort_intent(
>> +	struct xfs_log_item		*intent)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(intent));
>> +}
>> +
>> +/* Cancel an attr */
>> +STATIC void
>> +xfs_attr_cancel_item(
>> +	struct list_head		*item)
>> +{
>> +	struct xfs_attr_item		*attr;
>> +
>> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
>> +	kmem_free(attr);
>> +}
>> +
>>   STATIC xfs_lsn_t
>>   xfs_attri_item_committed(
>>   	struct xfs_log_item		*lip,
>> @@ -311,6 +471,160 @@ xfs_attri_validate(
>>   	return xfs_verify_ino(mp, attrp->alfi_ino);
>>   }
>>   
>> +/*
>> + * Process an attr intent item that was recovered from the log.  We need to
>> + * delete the attr that it describes.
>> + */
>> +STATIC int
>> +xfs_attri_item_recover(
>> +	struct xfs_log_item		*lip,
>> +	struct list_head		*capture_list)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_attr_item		*attr;
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		*args;
>> +	struct xfs_trans		*tp;
>> +	struct xfs_trans_res		tres;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error, ret = 0;
>> +	int				total;
>> +	int				local;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!xfs_attri_validate(mp, attrp))
>> +		return -EFSCORRUPTED;
>> +
>> +	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
>> +	if (error)
>> +		return error;
>> +
>> +	attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
>> +			   sizeof(struct xfs_da_args), KM_NOFS);
>> +	args = (struct xfs_da_args *)(attr + 1);
>> +
>> +	attr->xattri_dac.da_args = args;
>> +	attr->xattri_op_flags = attrp->alfi_op_flags;
>> +
>> +	args->dp = ip;
>> +	args->geo = mp->m_attr_geo;
>> +	args->op_flags = attrp->alfi_op_flags;
>> +	args->whichfork = XFS_ATTR_FORK;
>> +	args->name = attrip->attri_name;
>> +	args->namelen = attrp->alfi_name_len;
>> +	args->hashval = xfs_da_hashname(args->name, args->namelen);
>> +	args->attr_filter = attrp->alfi_attr_flags;
>> +
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args->value = attrip->attri_value;
>> +		args->valuelen = attrp->alfi_value_len;
>> +		args->total = xfs_attr_calc_size(args, &local);
>> +
>> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
>> +					args->total;
>> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +		total = args->total;
>> +	} else {
>> +		tres = M_RES(mp)->tr_attrrm;
>> +		total = XFS_ATTRRM_SPACE_RES(mp);
>> +	}
>> +	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
>> +	if (error)
>> +		goto out;
>> +
>> +	args->trans = tp;
>> +	done_item = xfs_trans_get_attrd(tp, attrip);
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>> +
>> +	ret = xfs_trans_attr_finish_update(&attr->xattri_dac, done_item,
>> +					   &attr->xattri_dac.leaf_bp,
>> +					   attrp->alfi_op_flags);
>> +	if (ret == -EAGAIN) {
>> +		/* There's more work to do, so add it to this transaction */
>> +		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> 
> Set attr = NULL here so that we don't free it at the end of the
> function.  Just in case some day one of these other functions also
> starts returning -EAGAIN.Well, even when we dont get -EAGAIN, we still need attr for the buffer 
unlock right?  I think we added that for the capture buffers patches we 
added in the last review.

> 
>> +	} else
>> +		error = ret;
>> +
>> +	if (error) {
>> +		xfs_trans_cancel(tp);
>> +		goto out_unlock;
>> +	}
>> +
>> +	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
>> +
>> +out_unlock:
>> +	if (attr->xattri_dac.leaf_bp)
>> +		xfs_buf_relse(attr->xattri_dac.leaf_bp);
>> +
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +out:
>> +	if (ret != -EAGAIN)
>> +		kmem_free(attr);
>> +	return error;
>> +}
>> +
>> +/* Re-log an intent item to push the log tail forward. */
>> +static struct xfs_log_item *
>> +xfs_attri_item_relog(
>> +	struct xfs_log_item		*intent,
>> +	struct xfs_trans		*tp)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp;
>> +	struct xfs_attri_log_item	*old_attrip;
>> +	struct xfs_attri_log_item	*new_attrip;
>> +	struct xfs_attri_log_format	*new_attrp;
>> +	struct xfs_attri_log_format	*old_attrp;
>> +	int				buffer_size;
>> +
>> +	old_attrip = ATTRI_ITEM(intent);
>> +	old_attrp = &old_attrip->attri_format;
>> +	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
>> +
>> +	tp->t_flags |= XFS_TRANS_DIRTY;
>> +	attrdp = xfs_trans_get_attrd(tp, old_attrip);
>> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>> +
>> +	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
>> +	new_attrp = &new_attrip->attri_format;
>> +
>> +	new_attrp->alfi_ino = old_attrp->alfi_ino;
>> +	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>> +	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>> +	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
>> +	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
>> +
>> +	new_attrip->attri_name_len = old_attrip->attri_name_len;
>> +	new_attrip->attri_name = ((char *)new_attrip) +
>> +				 sizeof(struct xfs_attri_log_item);
>> +	memcpy(new_attrip->attri_name, old_attrip->attri_name,
>> +		new_attrip->attri_name_len);
>> +
>> +	new_attrip->attri_value_len = old_attrip->attri_value_len;
>> +	if (new_attrip->attri_value_len > 0) {
>> +		new_attrip->attri_value = new_attrip->attri_name +
>> +					  new_attrip->attri_name_len;
>> +
>> +		memcpy(new_attrip->attri_value, old_attrip->attri_value,
>> +		       new_attrip->attri_value_len);
>> +	}
>> +
>> +	xfs_trans_add_item(tp, &new_attrip->attri_item);
>> +	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
>> +
>> +	return &new_attrip->attri_item;
>> +}
>> +
>>   STATIC int
>>   xlog_recover_attri_commit_pass2(
>>   	struct xlog                     *log,
>> @@ -377,6 +691,52 @@ xlog_recover_attri_commit_pass2(
>>   	return 0;
>>   }
>>   
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +static struct xfs_attrd_log_item *
>> +xfs_trans_get_attrd(struct xfs_trans		*tp,
>> +		  struct xfs_attri_log_item	*attrip)
>> +{
>> +	struct xfs_attrd_log_item		*attrdp;
>> +	uint					size;
>> +
>> +	ASSERT(tp != NULL);
>> +
>> +	size = sizeof(struct xfs_attrd_log_item);
>> +	attrdp = kmem_zalloc(size, 0);
> 
> The xattrd items really should get their own slab cache.
Sure, I can add a caches for attrdp and attrip
> 
>> +
>> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
>> +			  &xfs_attrd_item_ops);
>> +	attrdp->attrd_attrip = attrip;
>> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
>> +
>> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
>> +	return attrdp;
>> +}
>> +
>> +/* Get an ATTRD so we can process all the attrs. */
>> +static struct xfs_log_item *
>> +xfs_attr_create_done(
>> +	struct xfs_trans		*tp,
>> +	struct xfs_log_item		*intent,
>> +	unsigned int			count)
>> +{
>> +	if (!intent)
>> +		return NULL;
>> +
>> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
>> +}
> 
> xfs_trans_get_attrd could be combined into this function.
Ok, will collapse that down

> 
> This series is coming along nicely!  I think with these last few
> things fixed, it's ready to go.
> 

Great, sounds good.  Thanks for the reviews!

Allison
> --D
> 
>> +
>> +const struct xfs_defer_op_type xfs_attr_defer_type = {
>> +	.max_items	= 1,
>> +	.create_intent	= xfs_attr_create_intent,
>> +	.abort_intent	= xfs_attr_abort_intent,
>> +	.create_done	= xfs_attr_create_done,
>> +	.finish_item	= xfs_attr_finish_item,
>> +	.cancel_item	= xfs_attr_cancel_item,
>> +};
>> +
>>   /*
>>    * This routine is called when an ATTRD format structure is found in a committed
>>    * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
>> @@ -410,7 +770,9 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
>>   	.iop_unpin	= xfs_attri_item_unpin,
>>   	.iop_committed	= xfs_attri_item_committed,
>>   	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>>   	.iop_match	= xfs_attri_item_match,
>> +	.iop_relog	= xfs_attri_item_relog,
>>   };
>>   
>>   const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> -- 
>> 2.25.1
>>
