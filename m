Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB44AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 07:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242463AbhLAHis (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 02:38:48 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18504 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242308AbhLAHir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 02:38:47 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B17QmGL015137;
        Wed, 1 Dec 2021 07:35:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yKumZVZAhe1u81D4rMtni8jhOGabkcxbvPzy94XwiSI=;
 b=C4vd7sSqS5i00Z6Vy/1rP8Y4MT/5gcnkog5uvZFdXy6p0SatV5jfFsBpOeOHoOfCaT+A
 DnTeCqvbq1+uDAVMgzQ+ct1kk5QP6zMGgoLnlR+LTT4+GL88B3LW9aYQGj8dBmtNst+o
 ntA1noLnr+eXV+zmbYpmmxIlJYwrk0FmaCnL3czX85HNRzoLaEWlD9NfKajDaR9oCMEP
 Od/Zz4VU8ePBXTuArreGqVtZv9aLziYWGlN3ZzQRPmQpcUyvWe1GMWVJ/e3rqn0ML3O9
 20FocENPKd/aS0aTUv4wP6qzCsVjOzV52U1eTAFezl9IFQJk/ffGGXqbFzbbhbGMKD7R 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmt8ceh4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:35:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B17FnO8022937;
        Wed, 1 Dec 2021 07:35:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 3ck9t1785e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:35:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlxD5TPevPcSUAYI6QfCNyueSxWhQFDD/WkoDnpmgY6BQ3LP+ATNxDeKmM3UEL/A3DWl/nL392MLxA4iHggc8rQjddKcmc7Dm+wOl8szZqOK2fDI6lw2WZUDXhBobiOIg9KRzmqtmFiIYcZ6/yuocx3eoRD0p/6yI7SyaPc/hBlK22JBJf8Hp7rSjsyrsJuGS77Py6OluIy7ui/OxDu575fZXdUMekfchgVpFJs47JVADTJAqtbxlYZf7/rKP2ojQ0Fd02fpCWdvKeIJCRbsDCIaTRgDS3NrdNdgB1IKmPJ7vsbeqinanUiFqwslNqVV63FND2cruLu9gyMiBaP3xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKumZVZAhe1u81D4rMtni8jhOGabkcxbvPzy94XwiSI=;
 b=KrKi4QHJ3y+ZRJJozwfsz2s+jr22pTFody7NJUwanrTCzTHYYGSjmvdBYaT3NAyqXIOIgzgh+OpoLH96KGcjDNBhJ/IAxawf6II6fqXaQzetpdUrlCeflrYSjzkDcGjjo+Z6O5cRvWm4XKbPM5xgzO/bVjw354nEfd6f5WWgk2dkX4AGFVT5MWzy1c6UfsnLSezoSyQWo4lOAXfeTOmeUr5DIZHJ0EExrp17hGssCPPzqfSpbEYgStDB0zZl3HLxOe6nI0QDNaK+CDsTQQSPAVW9IiOweUxzPE0qYjoPfWGkqY0waAG4hIiFRgbtNMx8OMiRiC7wy90Rr/2GH4ZBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKumZVZAhe1u81D4rMtni8jhOGabkcxbvPzy94XwiSI=;
 b=uR1PhsHIYBasD3KkeoVEzhJT/yILg0o+ITV9t73NdeeWVlsHDR2faXXQT9RfphYrsdLWh0EaJcM9O/eVhMr0aGFGyqqtzgBquUTq6bRcqYzQBSvJv4wUNOZ7BkeXytn8V/hO5dEVksoP14YXtdgiHB3y6VpZ0DUTMU5PHr0mDMw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (10.255.126.71) by
 SJ0PR10MB4429.namprd10.prod.outlook.com (20.182.112.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Wed, 1 Dec 2021 07:35:19 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.029; Wed, 1 Dec 2021
 07:35:18 +0000
Message-ID: <6dc7df37-87ca-c072-0912-eeacbee97fd3@oracle.com>
Date:   Wed, 1 Dec 2021 00:35:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v25 04/12] xfs: Set up infrastructure for log attribute
 replay
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
 <20211117041343.3050202-5-allison.henderson@oracle.com>
 <20211123235047.GZ266024@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211123235047.GZ266024@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0054.namprd07.prod.outlook.com
 (2603:10b6:a03:60::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.6] (67.1.131.99) by BYAPR07CA0054.namprd07.prod.outlook.com (2603:10b6:a03:60::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Wed, 1 Dec 2021 07:35:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 654a2d6a-9d10-4a6c-c98b-08d9b49d1fe4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4429C74F140E970DCDCA9E7595689@SJ0PR10MB4429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1TKn9hB2uNyo+u6XPgB+7/KU+GdJ4mIm5iEbwem9uEDeyEI+Irneye72w6LE0nWt6201kkMUpkM22q6bZBvpHL+rBmV5fMoigIkYKQbRqDu5mFBoAW5kXJzTcKmimU5jf+/vhK4sT3WNbo8TrVz2Eq9+H7mZ0jcRP6+lNnS5jjVkj7s+IF72TCgRNzgTDcGplREVqDoZRZ3OtS9X53jSurkVZIafZK0hGFpXZwFLAGEFs4bdJOIbzu44k+x8+YhhOQthOrJpLDfx16Z1hqMYpzwAWXcFTZ/w2HFQSInkdZkeFXJjvUxLqcou51PgxQLx79qd8gFDHYdeYDWmxwOt2KFIGSZ+5RAn1EgJEw4rSdXTCSVk8Pai6NIhdE/a4PqB66RZOjj1ayEoylTC6OU+Zh24pli0xYFoL3/MmWuf6Lzcz2BzUEYnPbF/YRHwGnnc/liwGFjQBNytQaIYLzFWRcM7nrHrIPrLCb/xiyRjf882eZZ9VXQtBrxJfBFA2mL4JF3HKgZgHQ1ugQnorr8OIINtTCTDel/UTGiaA/tbJ5aNN5eayXeMMhmULn0olrxvCZNZA//RNSYqbhcLsGufFoLeL46TEsomMWc7J2SnK0KRp+5Uraqg7MRn3Yw7uu58E0tzPy6rhOta0YH/4ZUz1P8seiNgGUwu8Mw2IC0JgZlgpIbp6cpecTIUslWiu5cpvWZA4tw5Pu2J4mhlFkgW9lfDJea84s7BIdAz8percKRs6AFNyeb2WnQxX1lrP4yg6F0ZlJ2V7OOakYQ9tqjte62J4myg9XLw4FJTy/PJXfICdk2hzmUr19KFzADvET5KcxEENSHO3aAyBp/jH+MOKt9e+KxUZWmEZWsS9ygIsoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(2616005)(38100700002)(4326008)(6916009)(966005)(31686004)(38350700002)(8936002)(30864003)(8676002)(44832011)(6486002)(5660300002)(86362001)(508600001)(52116002)(31696002)(2906002)(186003)(36756003)(83380400001)(66946007)(26005)(66556008)(66476007)(16576012)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkEvaHJkaGt4ZnZEYmgyNm9wRXp4eXRmcm42WUZlSk1pUkV1NTFBejQwSHAv?=
 =?utf-8?B?Z29HTC93SHhzWnQybXVSRXMxU1YvdUVlNGZnemJQbzhKVUlqZEh0Nzk0QWlJ?=
 =?utf-8?B?TklFMkxOTmphc0k1RFEwUy9LS0x6bllDUER6ak5iYStNUGQ0ZHlpMXdvVzQ2?=
 =?utf-8?B?dzBacVNBY21XUms4ZWxVV3Y1OFNZM3g1U05hNUpCYWFKVHJocWlSRWdpcG1v?=
 =?utf-8?B?bFRCc0NlU3EzbGV3U2huSndOYzExK2JnbGRjUTErYUl4V3FTL285a1lzTHFl?=
 =?utf-8?B?QmhBZDlXVVZQWVZVMmg5V3VDZENVTW8zMy96aWpMTGh0T0tUMGttU0VSZXh2?=
 =?utf-8?B?UjdtMVhjbVowMzljbCtnbG1iNGxIcFV6a1AxYmNCZzc4Vi9tS1d2Q1RmNXBV?=
 =?utf-8?B?REcwVi9kS3EzL0pWZnI2TWtlU1pmd0E5MGZFQURhSUI3UXYvV3ZlZFkxekpN?=
 =?utf-8?B?MExqVDFlMmtmVjg3S01OTE9kaElVZmhQcWw2aGM5YnRLWG5TN2FBdTBwanhr?=
 =?utf-8?B?WGJQTG82cUJvNzIyMEt3OGxqV29qbE43VG5ybGNlaFMwazhHVUM0NWpFU2ZG?=
 =?utf-8?B?VytPYVJXYU5FaW9zaWNINDdoKzlVeTZ0Y1k1VjF5NnN6QTZ3cmZoMlplaERL?=
 =?utf-8?B?UXVCN2JHRGMrZE9VWmlZcm8rZHRyTW8xYm9YZmhpWUhFNUZ1bnVBcDN5ajBJ?=
 =?utf-8?B?OFE3OGhmWkcwcThjYTZ1Nm05Y3JTRzR0QnN6N0hpOE1IM2JhL1VWKzhPK3cv?=
 =?utf-8?B?cktkV1doV2dwSGgybGdqb2xVdHN6aHlpb1h5QnF5RnBxWWRTbk8wTlp0VlNz?=
 =?utf-8?B?UkJkS0hXSTQybEUzZzd3a1QyOWVSYWpZclNMY2VSMUNEeTZPZis2SFM4RTBo?=
 =?utf-8?B?YUlGUGVNS0JJekpOMGlXNzVhRERqSC9QWVBlOCtFM3IxUHlCblVFUTdoNVI2?=
 =?utf-8?B?akRhQitwRHZyQUhXTDZydWk3U0RBTVI4WFdacGYyOThhbGRmTGgrUmZ3ZmZm?=
 =?utf-8?B?ems0UWtXSmNrdXJYQm1QdXJYTkl4bTg5ZHNSVHI5ZUtCbDNxVEd4WXlrU3BU?=
 =?utf-8?B?OUw1ZjNybk0vSjZ4V3FKMysySngxOTdkaW9Jc3ViZm5jL0Q5K3hZU2xjVzNE?=
 =?utf-8?B?OEF1by9YRUJpNzVDS2I2djlLU0I2QndtQko4eG1SdCtMc2hnaWVGSURmS0JP?=
 =?utf-8?B?S3ZCZE1OWjR6NVNQY0JQdkhUcFo3R3Bsb1F1S0d0UGhxOHFRU1poRWVNaERS?=
 =?utf-8?B?WFJRbGRMYW90NkZhWEhDVFE3N2xES1hCcEp5NmIrUGdEc1lxUm5OVDE3dm1v?=
 =?utf-8?B?ei9ZaUpqRjhvZUlwWWh0SVZnakJOUCs4UjJSY1FRYm9BcG9KNUlwNmdQb280?=
 =?utf-8?B?a2xtN1Z2bGdvcFJkRi9oWFdMVnk3OEErKzk4bU9Ha3FoaHVQNzlRd3JpeG4z?=
 =?utf-8?B?RWQ4R2wvb0k4N01RZUVCODhPS3ZMbytGS29WRFF4WnJVMkd6RnY0WUgvc3Rw?=
 =?utf-8?B?bTkxNXlRTVFaMVFoekhHLzVkRENZZ294YWF5VzM4UzV4QzN0ZDNma3llOWZM?=
 =?utf-8?B?SWtsYU5ISFp6MzVrTUtGOXVTS1hyYjVKMEFlMDlHQlJyWG82ZGFLRmtDTkdC?=
 =?utf-8?B?STlaV3BlOW1DWFdWM0VjakhUVkxMRVEvMDI2WnVraHVhbHEvNDd3aVVaUWdO?=
 =?utf-8?B?dUNvVFlBMnhHb1NmMDhpRXBzbmE2M0VUOG5Ub3N5aE52Mm1XRzA1c2d5cVBE?=
 =?utf-8?B?QlI4OWVnb1FteUhrSityb2JUMkl0MisxS2o5a0Fsd1ZOSnkyM1lESXdBQUFU?=
 =?utf-8?B?SmtsTkUzcGZsekRFQUxYZUVPOHU3K25KdXJYZjNZaHdmY1g5LzgzQ0o2cU1V?=
 =?utf-8?B?KzJSaDlReFlnREVJZjZuWTdHOU1BUStZd3J3bzRxOU1oZ3YrUlVqbThvWkdw?=
 =?utf-8?B?R3FxTi9jMU5kYXAvVnRpM0RRUFpWK24yam0rVXc1VERLTEUxdGxzQUl6c0Vj?=
 =?utf-8?B?NThObFFHdEVWQ0EvQ3paSldhSENmZEd2K3ZMSHZvMG95dEtIR2hTNjlYbmVl?=
 =?utf-8?B?Um1DQ3lhaXhvTk53MHpuTGFseEtTTGxGSWp5aWsvVlNNOUVLU2xFVVptUlZS?=
 =?utf-8?B?enljUmdCdkdOQUowSXZ3RWRWTkRFMDhXTzhIVCs3UU5zSDRIdThsU1RrSmhn?=
 =?utf-8?B?ZEdRVUN2UTllZHdER2h0TXMzbTB1RHRSN0RyeVhOK2xUaWZ2Y0w1dmcxNGo1?=
 =?utf-8?B?VWF2cGNqSWl4TWRBNERTdzgxTkN3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654a2d6a-9d10-4a6c-c98b-08d9b49d1fe4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 07:35:18.8872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4HRAHZVPIiB8in6rLFf8nN4Cr2KxA7q/s/WuTlMN2vY0oUeGK0z3Fl6pPwERaVVSR7fd1YJkWgWjc2WrHAe1m4FkMHNjOJl2GvgBmlbSJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4429
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010042
X-Proofpoint-ORIG-GUID: _qhwGvb0xY0FKQZyX3T2ah9PCDL-VwKs
X-Proofpoint-GUID: _qhwGvb0xY0FKQZyX3T2ah9PCDL-VwKs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/23/21 4:50 PM, Darrick J. Wong wrote:
> On Tue, Nov 16, 2021 at 09:13:35PM -0700, Allison Henderson wrote:
>> Currently attributes are modified directly across one or more
>> transactions. But they are not logged or replayed in the event of an
>> error. The goal of log attr replay is to enable logging and replaying
>> of attribute operations using the existing delayed operations
>> infrastructure.  This will later enable the attributes to become part of
>> larger multi part operations that also must first be recorded to the
>> log.  This is mostly of interest in the scheme of parent pointers which
>> would need to maintain an attribute containing parent inode information
>> any time an inode is moved, created, or removed.  Parent pointers would
>> then be of interest to any feature that would need to quickly derive an
>> inode path from the mount point. Online scrub, nfs lookups and fs grow
>> or shrink operations are all features that could take advantage of this.
>>
>> This patch adds two new log item types for setting or removing
>> attributes as deferred operations.  The xfs_attri_log_item will log an
>> intent to set or remove an attribute.  The corresponding
>> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
>> freed once the transaction is done.  Both log items use a generic
>> xfs_attr_log_format structure that contains the attribute name, value,
>> flags, inode, and an op_flag that indicates if the operations is a set
>> or remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/Makefile                 |   1 +
>>   fs/xfs/libxfs/xfs_attr.c        |   5 +-
>>   fs/xfs/libxfs/xfs_attr.h        |  30 +++
>>   fs/xfs/libxfs/xfs_defer.h       |   2 +
>>   fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>   fs/xfs/scrub/common.c           |   2 +
>>   fs/xfs/xfs_attr_item.c          | 431 ++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr_item.h          |  46 ++++
>>   fs/xfs/xfs_attr_list.c          |   1 +
>>   fs/xfs/xfs_ioctl32.c            |   2 +
>>   fs/xfs/xfs_iops.c               |   2 +
>>   fs/xfs/xfs_log.c                |   4 +
>>   fs/xfs/xfs_log.h                |  11 +
>>   fs/xfs/xfs_log_recover.c        |   2 +
>>   fs/xfs/xfs_ondisk.h             |   2 +
>>   16 files changed, 582 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
>> index 04611a1068b4..b056cfc6398e 100644
>> --- a/fs/xfs/Makefile
>> +++ b/fs/xfs/Makefile
>> @@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
>>   				   xfs_buf_item_recover.o \
>>   				   xfs_dquot_item_recover.o \
>>   				   xfs_extfree_item.o \
>> +				   xfs_attr_item.o \
>>   				   xfs_icreate_item.o \
>>   				   xfs_inode_item.o \
>>   				   xfs_inode_item_recover.o \
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 50b91b4461e7..dfff81024e46 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -24,6 +24,7 @@
>>   #include "xfs_quota.h"
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>> +#include "xfs_attr_item.h"
>>   
>>   /*
>>    * xfs_attr.c
>> @@ -61,8 +62,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> -STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -			     struct xfs_buf **leaf_bp);
>>   STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
>>   				    struct xfs_da_state *state);
>>   
>> @@ -166,7 +165,7 @@ xfs_attr_get(
>>   /*
>>    * Calculate how many blocks we need for the new attribute,
>>    */
>> -STATIC int
>> +int
>>   xfs_attr_calc_size(
>>   	struct xfs_da_args	*args,
>>   	int			*local)
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 5e71f719bdd5..b8897f0dd810 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -28,6 +28,11 @@ struct xfs_attr_list_context;
>>    */
>>   #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
>>   
>> +static inline bool xfs_has_larp(struct xfs_mount *mp)
>> +{
>> +	return false;
>> +}
>> +
>>   /*
>>    * Kernel-internal version of the attrlist cursor.
>>    */
>> @@ -461,6 +466,11 @@ enum xfs_delattr_state {
>>   struct xfs_delattr_context {
>>   	struct xfs_da_args      *da_args;
>>   
>> +	/*
>> +	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
>> +	 */
>> +	struct xfs_buf		*leaf_bp;
>> +
>>   	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
>>   	struct xfs_bmbt_irec	map;
>>   	xfs_dablk_t		lblkno;
>> @@ -474,6 +484,23 @@ struct xfs_delattr_context {
>>   	enum xfs_delattr_state  dela_state;
>>   };
>>   
>> +/*
>> + * List of attrs to commit later.
>> + */
>> +struct xfs_attr_item {
>> +	struct xfs_delattr_context	xattri_dac;
>> +
>> +	/*
>> +	 * Indicates if the attr operation is a set or a remove
>> +	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
>> +	 */
>> +	unsigned int			xattri_op_flags;
>> +
>> +	/* used to log this item to an intent */
>> +	struct list_head		xattri_list;
>> +};
>> +
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -490,10 +517,13 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> +		      struct xfs_buf **leaf_bp);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 7bb8a31ad65b..fcd23e5cf1ee 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -63,6 +63,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>>   extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>> +extern const struct xfs_defer_op_type xfs_attr_defer_type;
>> +
>>   
>>   /*
>>    * Deferred operation item relogging limits.
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index b322db523d65..3301c369e815 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>> @@ -114,7 +114,12 @@ struct xfs_unmount_log_format {
>>   #define XLOG_REG_TYPE_CUD_FORMAT	24
>>   #define XLOG_REG_TYPE_BUI_FORMAT	25
>>   #define XLOG_REG_TYPE_BUD_FORMAT	26
>> -#define XLOG_REG_TYPE_MAX		26
>> +#define XLOG_REG_TYPE_ATTRI_FORMAT	27
>> +#define XLOG_REG_TYPE_ATTRD_FORMAT	28
>> +#define XLOG_REG_TYPE_ATTR_NAME	29
>> +#define XLOG_REG_TYPE_ATTR_VALUE	30
>> +#define XLOG_REG_TYPE_MAX		30
>> +
>>   
>>   /*
>>    * Flags to log operation header
>> @@ -237,6 +242,8 @@ typedef struct xfs_trans_header {
>>   #define	XFS_LI_CUD		0x1243
>>   #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
>>   #define	XFS_LI_BUD		0x1245
>> +#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
>> +#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
>>   
>>   #define XFS_LI_TYPE_DESC \
>>   	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
>> @@ -252,7 +259,9 @@ typedef struct xfs_trans_header {
>>   	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
>>   	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
>>   	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
>> -	{ XFS_LI_BUD,		"XFS_LI_BUD" }
>> +	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
>> +	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
>> +	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
>>   
>>   /*
>>    * Inode Log Item Format definitions.
>> @@ -869,4 +878,35 @@ struct xfs_icreate_log {
>>   	__be32		icl_gen;	/* inode generation number to use */
>>   };
>>   
>> +/*
>> + * Flags for deferred attribute operations.
>> + * Upper bits are flags, lower byte is type code
>> + */
>> +#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
>> +#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
>> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>> +
>> +/*
>> + * This is the structure used to lay out an attr log item in the
>> + * log.
>> + */
>> +struct xfs_attri_log_format {
>> +	uint16_t	alfi_type;	/* attri log item type */
>> +	uint16_t	alfi_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfi_id;	/* attri identifier */
>> +	uint64_t	alfi_ino;	/* the inode for this attr operation */
>> +	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
>> +	uint32_t	alfi_name_len;	/* attr name length */
>> +	uint32_t	alfi_value_len;	/* attr value length */
>> +	uint32_t	alfi_attr_flags;/* attr flags */
>> +};
>> +
>> +struct xfs_attrd_log_format {
>> +	uint16_t	alfd_type;	/* attrd log item type */
>> +	uint16_t	alfd_size;	/* size of this item */
>> +	uint32_t	__pad;		/* pad to 64 bit aligned */
>> +	uint64_t	alfd_alf_id;	/* id of corresponding attri */
>> +};
>> +
>>   #endif /* __XFS_LOG_FORMAT_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
>> index ff69a0000817..32e216255cb0 100644
>> --- a/fs/xfs/libxfs/xfs_log_recover.h
>> +++ b/fs/xfs/libxfs/xfs_log_recover.h
>> @@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops xlog_rui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_rud_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cui_item_ops;
>>   extern const struct xlog_recover_item_ops xlog_cud_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attri_item_ops;
>> +extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
>>   
>>   /*
>>    * Macros, structures, prototypes for internal log manager use.
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index bf1f3607d0b6..97b54ac3075f 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -23,6 +23,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "xfs_ag.h"
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> new file mode 100644
>> index 000000000000..3c0dfb32f2eb
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -0,0 +1,431 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +
>> +#include "xfs.h"
>> +#include "xfs_fs.h"
>> +#include "xfs_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_mount.h"
>> +#include "xfs_defer.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans.h"
>> +#include "xfs_trans_priv.h"
>> +#include "xfs_log.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>> +#include "xfs_attr.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_trace.h"
>> +#include "libxfs/xfs_da_format.h"
> 
> No need for the libxfs/ here.
> 
>> +#include "xfs_inode.h"
>> +#include "xfs_trans_space.h"
>> +#include "xfs_error.h"
>> +#include "xfs_log_priv.h"
>> +#include "xfs_log_recover.h"
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops;
>> +static const struct xfs_item_ops xfs_attrd_item_ops;
>> +
>> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attri_log_item, attri_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attri_item_free(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	kmem_free(attrip->attri_item.li_lv_shadow);
>> +	kmem_free(attrip);
>> +}
>> +
>> +/*
>> + * Freeing the attrip requires that we remove it from the AIL if it has already
>> + * been placed there. However, the ATTRI may not yet have been placed in the
>> + * AIL when called by xfs_attri_release() from ATTRD processing due to the
>> + * ordering of committed vs unpin operations in bulk insert operations. Hence
>> + * the reference count to ensure only the last caller frees the ATTRI.
>> + */
>> +STATIC void
>> +xfs_attri_release(
>> +	struct xfs_attri_log_item	*attrip)
>> +{
>> +	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
>> +	if (atomic_dec_and_test(&attrip->attri_refcount)) {
>> +		xfs_trans_ail_delete(&attrip->attri_item,
>> +				     SHUTDOWN_LOG_IO_ERROR);
>> +		xfs_attri_item_free(attrip);
>> +	}
>> +}
>> +
>> +STATIC void
>> +xfs_attri_item_size(
>> +	struct xfs_log_item	*lip,
>> +	int			*nvecs,
>> +	int			*nbytes)
>> +{
>> +	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
> 
> Please line up the columns here ^^ and  ^^ here.
Ok, will scoot

> 
>> +
>> +	*nvecs += 2;
>> +	*nbytes += sizeof(struct xfs_attri_log_format) +
>> +			xlog_calc_iovec_len(attrip->attri_name_len);
>> +
>> +	if (!attrip->attri_value_len)
>> +		return;
>> +
>> +	*nvecs += 1;
>> +	*nbytes += xlog_calc_iovec_len(attrip->attri_value_len);
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attri log
>> + * item. We use  1 iovec for the attri_format_item, 1 for the name, and
>> + * another for the value if it is present
>> + */
>> +STATIC void
>> +xfs_attri_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
>> +
>> +	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
>> +	attrip->attri_format.alfi_size = 1;
>> +
>> +	/*
>> +	 * This size accounting must be done before copying the attrip into the
>> +	 * iovec.  If we do it after, the wrong size will be recorded to the log
>> +	 * and we trip across assertion checks for bad region sizes later during
>> +	 * the log recovery.
>> +	 */
>> +
>> +	ASSERT(attrip->attri_name_len > 0);
>> +	attrip->attri_format.alfi_size++;
>> +
>> +	if (attrip->attri_value_len > 0)
>> +		attrip->attri_format.alfi_size++;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>> +			&attrip->attri_format,
>> +			sizeof(struct xfs_attri_log_format));
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>> +			attrip->attri_name,
>> +			xlog_calc_iovec_len(attrip->attri_name_len));
>> +	if (attrip->attri_value_len > 0)
>> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>> +				attrip->attri_value,
>> +				xlog_calc_iovec_len(attrip->attri_value_len));
>> +}
>> +
>> +/*
>> + * The unpin operation is the last place an ATTRI is manipulated in the log. It
>> + * is either inserted in the AIL or aborted in the event of a log I/O error. In
>> + * either case, the ATTRI transaction has been successfully committed to make
>> + * it this far. Therefore, we expect whoever committed the ATTRI to either
>> + * construct and commit the ATTRD or drop the ATTRD's reference in the event of
>> + * error. Simply drop the log's ATTRI reference now that the log is done with
>> + * it.
>> + */
>> +STATIC void
>> +xfs_attri_item_unpin(
>> +	struct xfs_log_item	*lip,
>> +	int			remove)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(lip));
>> +}
>> +
>> +
>> +STATIC void
>> +xfs_attri_item_release(
>> +	struct xfs_log_item	*lip)
>> +{
>> +	xfs_attri_release(ATTRI_ITEM(lip));
>> +}
>> +
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
>> +	attrip = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
>> +	if (attrip == NULL)
>> +		return NULL;
> 
> What happens if we can't allocate memory?  Do we fall back to non-larp
> xattr updates?
I think we answered that in the next patch...

> 
> Another thing to consider: For 5.16, I converted[1] the intent items
> to use per-item caches to increase slab cache efficiency.  You might
> want to consider doing that for most common buffer_size==0 (i.e.
> regular runtime) case.
> 
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=f3c799c22c661e181c71a0d9914fc923023f65fb__;!!ACWV5N9M2RV99hQ!bZ_vx230FHUk8F0PkuWxcRlmbH8WhJmEeAT-6EVGmDbBLIjg6Vn042ri6cMqfWk_eKEK$
> 
I see, sure I'll follow the example you have there and update attrs to match

>> +
>> +	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
>> +			  &xfs_attri_item_ops);
>> +	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
>> +	atomic_set(&attrip->attri_refcount, 2);
>> +
>> +	return attrip;
>> +}
>> +
>> +/*
>> + * Copy an attr format buffer from the given buf, and into the destination attr
>> + * format structure.
>> + */
>> +STATIC int
>> +xfs_attri_copy_format(
>> +	struct xfs_log_iovec		*buf,
>> +	struct xfs_attri_log_format	*dst_attr_fmt)
>> +{
>> +	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
>> +	uint				len;
>> +
>> +	len = sizeof(struct xfs_attri_log_format);
> 
> Nit: the return value of sizeof is size_t, not unsigned int.
Ok, will fix

> 
>> +	if (buf->i_len != len) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
>> +	return 0;
>> +}
>> +
>> +static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
>> +{
>> +	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
>> +{
>> +	kmem_free(attrdp->attrd_item.li_lv_shadow);
>> +	kmem_free(attrdp);
>> +}
>> +
>> +STATIC void
>> +xfs_attrd_item_size(
>> +	struct xfs_log_item		*lip,
>> +	int				*nvecs,
>> +	int				*nbytes)
>> +{
>> +	*nvecs += 1;
>> +	*nbytes += sizeof(struct xfs_attrd_log_format);
>> +}
>> +
>> +/*
>> + * This is called to fill in the log iovecs for the given attrd log item. We use
>> + * only 1 iovec for the attrd_format, and we point that at the attr_log_format
>> + * structure embedded in the attrd item.
>> + */
>> +STATIC void
>> +xfs_attrd_item_format(
>> +	struct xfs_log_item	*lip,
>> +	struct xfs_log_vec	*lv)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +	struct xfs_log_iovec		*vecp = NULL;
>> +
>> +	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
>> +	attrdp->attrd_format.alfd_size = 1;
>> +
>> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
>> +			&attrdp->attrd_format,
>> +			sizeof(struct xfs_attrd_log_format));
>> +}
>> +
>> +/*
>> + * The ATTRD is either committed or aborted if the transaction is canceled. If
>> + * the transaction is canceled, drop our reference to the ATTRI and free the
>> + * ATTRD.
>> + */
>> +STATIC void
>> +xfs_attrd_item_release(
>> +	struct xfs_log_item		*lip)
>> +{
>> +	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
>> +
>> +	xfs_attri_release(attrdp->attrd_attrip);
>> +	xfs_attrd_item_free(attrdp);
>> +}
>> +
>> +STATIC xfs_lsn_t
>> +xfs_attri_item_committed(
>> +	struct xfs_log_item		*lip,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
>> +
>> +	/*
>> +	 * The attrip refers to xfs_attr_item memory to log the name and value
>> +	 * with the intent item. This already occurred when the intent was
>> +	 * committed so these fields are no longer accessed. Clear them out of
>> +	 * caution since we're about to free the xfs_attr_item.
>> +	 */
>> +	attrip->attri_name = NULL;
>> +	attrip->attri_value = NULL;
>> +
>> +	/*
>> +	 * The ATTRI is logged only once and cannot be moved in the log, so
>> +	 * simply return the lsn at which it's been logged.
>> +	 */
>> +	return lsn;
>> +}
>> +
>> +STATIC bool
>> +xfs_attri_item_match(
>> +	struct xfs_log_item	*lip,
>> +	uint64_t		intent_id)
>> +{
>> +	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>> +}
>> +
>> +/* Is this recovered ATTRI format ok? */
>> +static inline bool
>> +xfs_attri_validate(
>> +	struct xfs_mount		*mp,
>> +	struct xfs_attri_log_format	*attrp)
>> +{
>> +	unsigned int			op = attrp->alfi_op_flags &
>> +					     XFS_ATTR_OP_FLAGS_TYPE_MASK;
>> +
>> +	if (attrp->__pad != 0)
>> +		return false;
>> +
>> +	/* alfi_op_flags should be either a set or remove */
>> +	if (op != XFS_ATTR_OP_FLAGS_SET && op != XFS_ATTR_OP_FLAGS_REMOVE)
>> +		return false;
>> +
>> +	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
>> +		return false;
>> +
>> +	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
>> +	    (attrp->alfi_name_len == 0))
>> +		return false;
> 
> The xattr name should be xfs_attr_namecheck()'d as part of this
> function.
Ok, will add in a check here

> 
>> +
>> +	return xfs_verify_ino(mp, attrp->alfi_ino);
>> +}
>> +
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
>> +	if (!xfs_attri_validate(mp, attri_formatp)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	buffer_size = attri_formatp->alfi_name_len +
>> +		      attri_formatp->alfi_value_len;
>> +
>> +	/* memory alloc failure will cause replay to abort */
>> +	attrip = xfs_attri_init(mp, buffer_size);
>> +	if (attrip == NULL)
>> +		return -ENOMEM;
>> +
>> +	error = xfs_attri_copy_format(&item->ri_buf[region],
>> +				      &attrip->attri_format);
>> +	if (error) {
>> +		xfs_attri_item_free(attrip);
>> +		return error;
>> +	}
>> +
>> +	attrip->attri_name_len = attri_formatp->alfi_name_len;
>> +	attrip->attri_value_len = attri_formatp->alfi_value_len;
>> +	region++;
>> +	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
>> +	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
>> +	attrip->attri_name = name;
>> +
>> +	if (attrip->attri_value_len > 0) {
>> +		region++;
>> +		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
>> +			attrip->attri_name_len;
>> +		memcpy(value, item->ri_buf[region].i_addr,
>> +			attrip->attri_value_len);
> 
> Indent two tabs here    ^ , please.
Sure, will do

> 
>> +		attrip->attri_value = value;
>> +	}
>> +
>> +	/*
>> +	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
>> +	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
>> +	 * directly and drop the ATTRI reference. Note that
>> +	 * xfs_trans_ail_update() drops the AIL lock.
>> +	 */
>> +	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
>> +	xfs_attri_release(attrip);
>> +	return 0;
>> +}
>> +
>> +/*
>> + * This routine is called when an ATTRD format structure is found in a committed
>> + * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
>> + * it was still in the log. To do this it searches the AIL for the ATTRI with
>> + * an id equal to that in the ATTRD format structure. If we find it we drop
>> + * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
>> + */
>> +STATIC int
>> +xlog_recover_attrd_commit_pass2(
>> +	struct xlog			*log,
>> +	struct list_head		*buffer_list,
>> +	struct xlog_recover_item	*item,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attrd_log_format	*attrd_formatp;
>> +
>> +	attrd_formatp = item->ri_buf[0].i_addr;
>> +	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
>> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
>> +				    attrd_formatp->alfd_alf_id);
>> +	return 0;
>> +}
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops = {
>> +	.iop_size	= xfs_attri_item_size,
>> +	.iop_format	= xfs_attri_item_format,
>> +	.iop_unpin	= xfs_attri_item_unpin,
>> +	.iop_committed	= xfs_attri_item_committed,
>> +	.iop_release    = xfs_attri_item_release,
>> +	.iop_match	= xfs_attri_item_match,
>> +};
>> +
>> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> +	.item_type	= XFS_LI_ATTRI,
>> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
>> +};
>> +
>> +static const struct xfs_item_ops xfs_attrd_item_ops = {
>> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.iop_size	= xfs_attrd_item_size,
>> +	.iop_format	= xfs_attrd_item_format,
>> +	.iop_release    = xfs_attrd_item_release,
>> +};
>> +
>> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
>> +	.item_type	= XFS_LI_ATTRD,
>> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
>> +};
>> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
>> new file mode 100644
>> index 000000000000..057cea27b657
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.h
>> @@ -0,0 +1,46 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>> + *
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +#ifndef	__XFS_ATTR_ITEM_H__
>> +#define	__XFS_ATTR_ITEM_H__
>> +
>> +/* kernel only ATTRI/ATTRD definitions */
>> +
>> +struct xfs_mount;
>> +struct kmem_zone;
>> +
>> +/*
>> + * This is the "attr intention" log item.  It is used to log the fact that some
>> + * attribute operations need to be processed.  An operation is currently either
> 
> Nit: "...some extended attribute operation needs to be processed..."
> 
> (both the 'extended' adjective and singular usage since this only
> records one operation per deferred item, afaict)
Right, that sounds cleaner

> 
>> + * a set or remove.  Set or remove operations are described by the xfs_attr_item
>> + * which may be logged to this intent.
>> + *
>> + * During a normal attr operation, name and value point to the name and value
>> + * fields of the calling functions xfs_da_args.  During a recovery, the name
>> + * and value buffers are copied from the log, and stored in a trailing buffer
>> + * attached to the xfs_attr_item until they are committed.  They are freed when
>> + * the xfs_attr_item itself is freed when the work is done.
>> + */
>> +struct xfs_attri_log_item {
>> +	struct xfs_log_item		attri_item;
>> +	atomic_t			attri_refcount;
>> +	int				attri_name_len;
>> +	int				attri_value_len;
>> +	void				*attri_name;
>> +	void				*attri_value;
>> +	struct xfs_attri_log_format	attri_format;
>> +};
>> +
>> +/*
>> + * This is the "attr done" log item.  It is used to log the fact that some attrs
>> + * earlier mentioned in an attri item have been freed.
>> + */
>> +struct xfs_attrd_log_item {
>> +	struct xfs_attri_log_item	*attrd_attrip;
>> +	struct xfs_log_item		attrd_item;
> 
> Please put the xfs_log_item at the start of the structure to make
> walking a list of log items easier.
Ok, will scoot that up

> 
> This is looking pretty good.  Aside from the namecheck suggestion for
> the recovery validation routine and the question about xattri_init, I
> think this is quite close to ready.
> 
Great, thanks for the reviews!

Allison

> --D
> 
>> +	struct xfs_attrd_log_format	attrd_format;
>> +};
>> +
>> +#endif	/* __XFS_ATTR_ITEM_H__ */
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 2d1e5134cebe..90a14e85e76d 100644
>> --- a/fs/xfs/xfs_attr_list.c
>> +++ b/fs/xfs/xfs_attr_list.c
>> @@ -15,6 +15,7 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_attr_sf.h"
>>   #include "xfs_attr_leaf.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index 8783af203cfc..ab543c5b1371 100644
>> --- a/fs/xfs/xfs_ioctl32.c
>> +++ b/fs/xfs/xfs_ioctl32.c
>> @@ -17,6 +17,8 @@
>>   #include "xfs_itable.h"
>>   #include "xfs_fsops.h"
>>   #include "xfs_rtalloc.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_ioctl.h"
>>   #include "xfs_ioctl32.h"
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index a607d6aca5c4..4f1310328b6d 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -13,6 +13,8 @@
>>   #include "xfs_inode.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_quota.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>> index 89fec9a18c34..8ba8563114b9 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -2157,6 +2157,10 @@ xlog_print_tic_res(
>>   	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>>   	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>>   	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
>> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
>> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
>> +	    REG_TYPE_STR(ATTR_NAME, "attr name"),
>> +	    REG_TYPE_STR(ATTR_VALUE, "attr value"),
>>   	};
>>   	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>>   #undef REG_TYPE_STR
>> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
>> index dc1b77b92fc1..fd945eb66c32 100644
>> --- a/fs/xfs/xfs_log.h
>> +++ b/fs/xfs/xfs_log.h
>> @@ -21,6 +21,17 @@ struct xfs_log_vec {
>>   
>>   #define XFS_LOG_VEC_ORDERED	(-1)
>>   
>> +/*
>> + * Calculate the log iovec length for a given user buffer length. Intended to be
>> + * used by ->iop_size implementations when sizing buffers of arbitrary
>> + * alignments.
>> + */
>> +static inline int
>> +xlog_calc_iovec_len(int len)
>> +{
>> +	return roundup(len, sizeof(int32_t));
>> +}
>> +
>>   static inline void *
>>   xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>>   		uint type)
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 53366cc0bc9e..f653a3701f89 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -1800,6 +1800,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>>   	&xlog_cud_item_ops,
>>   	&xlog_bui_item_ops,
>>   	&xlog_bud_item_ops,
>> +	&xlog_attri_item_ops,
>> +	&xlog_attrd_item_ops,
>>   };
>>   
>>   static const struct xlog_recover_item_ops *
>> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
>> index 25991923c1a8..758702b9495f 100644
>> --- a/fs/xfs/xfs_ondisk.h
>> +++ b/fs/xfs/xfs_ondisk.h
>> @@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>>   	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
>> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>>   
>>   	/*
>>   	 * The v5 superblock format extended several v4 header structures with
>> -- 
>> 2.25.1
>>
