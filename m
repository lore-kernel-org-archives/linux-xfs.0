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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C255EC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 712A864DBD
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhB0A5V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:57:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhB0A5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:57:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0j9KM100267;
        Sat, 27 Feb 2021 00:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HUi3j9/xbC7XEERnzcumeueYEhCNPD825m8acU4uvZU=;
 b=ZGW3//T8iwTbzfWQ2qrbxYq5MJ1K53cb2BNcHIA1Z1o36TVzsueLqUEtDSfc62DLQrXp
 RbDcx/9y1IrFiqd67FRvgvkKJhNS3Bxqi6eWMZoovdd9yGVmoXAuDKhAR+n6X3lYgGQ3
 iKKx+Bmnb5V9rdttLz+HKJ+2OXIMV7FjV1nAKiOse9CnMUpIAauZuHKJnRs88gRexdRP
 BI8DjYerZt3g1FZ3m8ljJAMNv0E4Ac+Y7Euibqcwqfl8UoAgtwv76kkslYA9U2jkZ9Kh
 r7O2rdV2wC6Mqhz/wpw/TzbhWUf/WWHrI9lpzTabazZbRaI55EKNH1VyHq7AiSaL5VHQ Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36ugq3tj0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:56:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0kY48106685;
        Sat, 27 Feb 2021 00:56:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 36uc6whuvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:56:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGrSDidN/VG4Qj+ZDSHtCSOgS8RBiZ2NsNmbmOCPvA7jskd1j6bGvo+iwg+usJQi6BNDLZvDaVPYzuL61TDA386yJORw/rSFcIUmmFiNttk844HcM53yZcTDovLdeDj08jfFQPNzVVhlB0auqXJsg29H4QLhh6hPNMBSSMSDVBq0z9BwKACFdRRxwebRFQhOD5QgPV+NQZgQBWhQXfbaGYo8RV8PYWIzXLc3Nf0S+kvYxCOgf+gsPxlXcM9FUUWQ6U9S0xM5EESR0konDZhLEAryJ1OW62J2gklRDId5fTCGQuAmr7wv5VBUSH9csKvnwf6egjBHhO4NwqrTQcOHCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUi3j9/xbC7XEERnzcumeueYEhCNPD825m8acU4uvZU=;
 b=FEe7HyAuTIyhSS4YoSLXBd/cSKxkYgf6P6pfQgxw6EakRsCAR1TAr1qEQvSeCJMdD3Q9Ev/c1ClIsOooobMhz8px+o+TD4mhmolmhOcWnyXKD0IyvHUESENI1C7zfHSJ1PaRM+Sv4AbcNuRKlx2LDb0WW/KikNY2hPneFvFluP1L0gLVTpnUs7qK9i501s6Asp23yET281ErPHkJPynQj/P+lhmvdEXLU1Nhoz4pka6jaKfVyI8dUBGjVO86MYmcWvfvuIsGyT4Pw3T7XWoa7DpUrAadxgCmbNcbPmUK1EkGJMRj5PH8GgPM8Vpf9FlnVdryzFD77Yj6rngxOTxEiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUi3j9/xbC7XEERnzcumeueYEhCNPD825m8acU4uvZU=;
 b=ZRuPEuKNIj5fbsv98wR+idtY3WhPug8A81T+AACnSM/y+CZ8mGC+5H1O7YkOFI47o1IHKapJ6v5Tq2YuWeCKTvHA6L6Sb0ZXfUr+7KjDY6E/mmKSlg3oCtSfSMeU4meSN6uwg/U/1rVol7Kj+6ThPp08EQHc8C952E5hG0M4Pbk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Sat, 27 Feb
 2021 00:56:23 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:56:23 +0000
Subject: Re: [PATCH v15 16/22] xfs: Set up infastructure for deferred
 attribute operations
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-17-allison.henderson@oracle.com>
 <20210226045802.GB7267@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <88ef7647-5898-888e-e4f0-0a115835759b@oracle.com>
Date:   Fri, 26 Feb 2021 17:56:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226045802.GB7267@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0098.namprd13.prod.outlook.com (2603:10b6:a03:2c5::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:56:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc4c0523-5790-4bf9-eaf7-08d8daba810d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4496389DC6F26118137EB5AB959C9@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9wCcj1xKJkfhIHMvbFYkvcqLbQjxCpTRs+MLVRXIlNbhJOXXf4T1t6intRioaKiWkNkVveZ9zsXk9UnYfeHaRi/4IukLNEuWzLaJCVOdqe/ikR1xhao0jzGyage7F6hjHV5KGWyteGsS1U2JCAjyyd4AXcqf86+RAnGeFeqwd2ZO9XlHh6ImVUy+Y0nwl7vNUAPgBeSzgi+W6g7N6DHcoj/9Z7OPNEsUmFewkxGC0LSM0xMJ0hnvMONc5nX8ReGOsjo8MP1Kcmbv7ipXavpH9DKuAl+c184Ei/IJrv8b5J4h/KrnTSW6SRiMV0J/nuF/VoOnzfLn2rCeSTAUj/Jxijc2TBcYm50bVW0AFIQ+eTJWfvX7+UuT40hTPhvdjhERxn6hHcpZSaD38oQQSeuDGf2ET+Ujr6PpO6PX1puZvmBzj3Ay5bw4iZTT7VtRrVJn1TvVUUBrnIRue8LjDu3dM1hrRXZQo9oUP90yK6ewqv5BVe+DWMVbgGBIRp+qyEXRhgxCHF3gbivZgxG470XlsU6ZXClExwWjc8VuAnnK67ltbUs+GQmuQL28pFxyTEj2xkOd2hsV5ElLSDZZN/2SBbj+TlzA0R2MHsiOJ7P8Vwc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(366004)(396003)(31686004)(86362001)(26005)(52116002)(186003)(16526019)(2616005)(956004)(44832011)(316002)(31696002)(16576012)(36756003)(53546011)(6916009)(6486002)(4326008)(8936002)(8676002)(30864003)(66476007)(66556008)(478600001)(66946007)(5660300002)(83380400001)(2906002)(45980500001)(43740500002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MDB5MXo5VS81ZE5Jc0ZjM0pPZmdZQjJGS3B0ZEN3dFh5ZFB0cFZLNXZHZDc3?=
 =?utf-8?B?UmpEUUFnQkg3azI1RWdSTFJDK2pSOTZQU3ppU3FCcndQR3lFUUNORXVZS3Yv?=
 =?utf-8?B?OTRJNGdsdTFNOHl2WnJld1pONmgvMUphTTFYeENhOWdhUnRha2ExWklkZm03?=
 =?utf-8?B?Nmk1NG9xOWFCM0FXNDhhWTQ0MVR0MWpKekZkY2Vzclh6ODQ1SStlMGR5b2ZL?=
 =?utf-8?B?VWprYTQ4RU5IODZCQTFHR0ZqWG1UZkNRalBmMThwTVE2SXpLUlhld0hzVWJp?=
 =?utf-8?B?SG1kS0hSYTUyY0tFWkdGN2RWNzh3KzI2cGk3cDFzUGtQa1U3WFMrZzhBK0Mw?=
 =?utf-8?B?NkhpdEV1S3ZmdDlHU2EydFZnSzY5K1p1MFU3dTVVWHdZM3ZOYVlEUzgzNWdh?=
 =?utf-8?B?eHJNRTNUTXduSUJGdHlzZ3FjaU14b0JYdTBad2c2Y0x2MzFraUpsUUxqNTA3?=
 =?utf-8?B?NUxBdy80L2tlV0NRSVVteUxHMXUwV3lxMFdXSXZ6V0RCYW5LNDB1RFZ5Q0dj?=
 =?utf-8?B?bkdMTG9sT0lVNmRrOTBQazdvVHB4Qnc4cDByelpzSWFSWkVsdTNuOEhiRkRz?=
 =?utf-8?B?N3lQMHBvak1LVW0xRThvQVl1V2pOM1ZIUFA5VWQrNUZjU3VHVWszK0lzL0lR?=
 =?utf-8?B?SU1rZ1FHWHJXUzhZRVNseG5vL2VrVkdXL29UUlZCSU1jU3hiUTNMbm9rWTRz?=
 =?utf-8?B?dXEvZGJnMGJ3R3YxdHV0VjdZaG9OVGVIR2MweGc3L1VMU1VNRkNBTHF4NlFW?=
 =?utf-8?B?TWZ3UDY3bVdzYUhFcUdab01iYlNxRDVDY2E3VHVtVzhYRVJTczVxdjZqUmZr?=
 =?utf-8?B?OXhWQzAyVjlrSjlSd1JtdkRpTjRlMmhYWUlnUFNuZjE2RzBMQkUzeENOZXk4?=
 =?utf-8?B?bVFCaHZtamlqeHIyVHpZeGZEZTI5R01sd2lLNlVNVE1aSHkxa29QM3llTUVG?=
 =?utf-8?B?STdVNW9pNFc5M2dGKzJOQjVTTFNnaXd1Ymd2akw0TmlTRSs3OGxpN0QwS3Jt?=
 =?utf-8?B?RWRMWXVtZmRURnZ0R3ZqcEpwdUVjNTdDQW9RMzNNNnNTdFlRYmZtb25HcXBB?=
 =?utf-8?B?cG5CRCtmL2hxR1hDcEtVM3VyZ3YvU25TVUNCSVh0Z0pkZTlXdDhGeHdwNWI2?=
 =?utf-8?B?aUhEdDJFdmZNazBOOEZUMGJ1dDhCMWViZTRySDBhOERBL054a0RBUFZ1OURM?=
 =?utf-8?B?Zks2NDZkaTh1RGNiTHRYYjRYSGw4NjFQNUQxSXRrR3F5c0pPeDZOaHBoZUta?=
 =?utf-8?B?WVV1djhleFUvRUJEU2ttWmtPNzh4aVRsRkc4dEhnZzc4VVJxN3pvTHVQOUVV?=
 =?utf-8?B?S1RSM09GZXBnc1MydnlaaEN2Z0Y1bkJvNVlCUHRsb3I3UnJ0SnV0MzZ4cU1r?=
 =?utf-8?B?bXR2ejc0aUJtTUJUY1daUm9tTWd6dEIyY3FNK2wva015Z3I2UTA0ZmhSQVIz?=
 =?utf-8?B?WTBiWXRBQ09seFJYSERHV2QrbHFvK2Q0NktYSEUxLzlUNXB4RzR2M1ZOaDMz?=
 =?utf-8?B?SUo3V2VPODF1MS93U0RIM1Z6RW45am1Ud0N2b3BFbU1XWmNGRHdFL3NNTDFT?=
 =?utf-8?B?bHIzKzBMemRWLzh0RE9Fd0Z3QVcxVWVLVTRJM3U0VStLNGRyZmlnNkdXNWVU?=
 =?utf-8?B?VjlWM3RvMUlQVEo0dXpmRHlBaGhsNWZVWXdITWxSdWVsWFNuTmsvaGdsVnE2?=
 =?utf-8?B?S25OUXcxN0MzZW92UmdVY05hVkxHYnQ1U2wyNzVYUmh0MHZzdVQ1NGlKRmky?=
 =?utf-8?Q?C4Bn/alMkwNNN3pMtoZgLi0tKZZXzqz2Mf3vJlu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4c0523-5790-4bf9-eaf7-08d8daba810d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:56:23.8025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JS6m0PR5keINtQ50SeqKRvkTWHry2IcVAuF/9iQQeHl5R6a46fwZmclR1YRA3eDSgaZ5AKwnnX3A1uWp04HBMQVNeTuKpSraAiyc4MdWY58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 9:58 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:42AM -0700, Allison Henderson wrote:
>> Currently attributes are modified directly across one or more
>> transactions. But they are not logged or replayed in the event of an
>> error. The goal of delayed attributes is to enable logging and replaying
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
>> attributes as deferred operations.  The xfs_attri_log_item logs an
>> intent to set or remove an attribute.  The corresponding
>> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
>> freed once the transaction is done.  Both log items use a generic
>> xfs_attr_log_format structure that contains the attribute name, value,
>> flags, inode, and an op_flag that indicates if the operations is a set
>> or remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> I saw a 36K patch and thought "Jeez!  This should be broken up!"
> 
> Then I looked at atomic extent swap (which does add its log item code
> gradually) and decided that maybe you just don't want to explode the
> patchset from 22 to 30.  That sounds (kind of) reasonable.
> 
> (...and by 'kind of', I probably mean that if I end up taking everything
> up to this patch for 5.13 then this part really ought to get broken up a
> bit for a future submission.  But let's wait until the end of this
> review to decide that...)

Yes, I've thought about falling back into a "Delay ready" sub series 
again.  It think the focus right now is the state machine and getting 
everyone on board with that, so I think it's reasonable to delay this 
part for now.  Since really the statemachine is a bit of a pre-req for this.

Allison
> 
>> ---
>>   fs/xfs/Makefile                 |   1 +
>>   fs/xfs/libxfs/xfs_attr.c        |   7 +-
>>   fs/xfs/libxfs/xfs_attr.h        |  31 ++
>>   fs/xfs/libxfs/xfs_defer.c       |   1 +
>>   fs/xfs/libxfs/xfs_defer.h       |   3 +
>>   fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>   fs/xfs/scrub/common.c           |   2 +
>>   fs/xfs/xfs_acl.c                |   2 +
>>   fs/xfs/xfs_attr_item.c          | 828 ++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_attr_item.h          |  52 +++
>>   fs/xfs/xfs_attr_list.c          |   1 +
>>   fs/xfs/xfs_ioctl.c              |   2 +
>>   fs/xfs/xfs_ioctl32.c            |   2 +
>>   fs/xfs/xfs_iops.c               |   2 +
>>   fs/xfs/xfs_log.c                |   4 +
>>   fs/xfs/xfs_log_recover.c        |   2 +
>>   fs/xfs/xfs_ondisk.h             |   2 +
>>   fs/xfs/xfs_xattr.c              |   1 +
>>   19 files changed, 984 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
>> index 04611a1..b056cfc 100644
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
>> index 2b8e481..e4c1b4b 100644
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
>> @@ -61,8 +62,8 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> -STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> -			     struct xfs_buf **leaf_bp);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> +		      struct xfs_buf **leaf_bp);
>>   
>>   int
>>   xfs_inode_hasattr(
>> @@ -144,7 +145,7 @@ xfs_attr_get(
>>   /*
>>    * Calculate how many blocks we need for the new attribute,
>>    */
>> -STATIC int
>> +int
>>   xfs_attr_calc_size(
>>   	struct xfs_da_args	*args,
>>   	int			*local)
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 603887e..ee79763 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -28,6 +28,11 @@ struct xfs_attr_list_context;
>>    */
>>   #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
>>   
>> +static inline bool xfs_hasdelattr(struct xfs_mount *mp)
>> +{
>> +	return false;
>> +}
>> +
>>   /*
>>    * Kernel-internal version of the attrlist cursor.
>>    */
>> @@ -390,6 +395,7 @@ enum xfs_delattr_state {
>>    */
>>   #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>>   #define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
>> +#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
>>   
>>   /*
>>    * Context used for keeping track of delayed attribute operations
>> @@ -397,6 +403,11 @@ enum xfs_delattr_state {
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
>> @@ -410,6 +421,23 @@ struct xfs_delattr_context {
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
>> +	uint32_t			xattri_op_flags;
>> +
>> +	/* used to log this item to an intent */
>> +	struct list_head		xattri_list;
>> +};
>> +
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -425,11 +453,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
>>   int xfs_attr_get(struct xfs_da_args *args);
>>   int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>> +		      struct xfs_buf **leaf_bp);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>   			      struct xfs_da_args *args);
>> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a12..e9caff7 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>>   };
>>   
>>   static void
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 05472f7..72a5789 100644
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
>> @@ -63,6 +64,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>>   extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>>   extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>> +extern const struct xfs_defer_op_type xfs_attr_defer_type;
>> +
>>   
>>   /*
>>    * This structure enables a dfops user to detach the chain of deferred
>> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
>> index 8bd00da..19963b6 100644
>> --- a/fs/xfs/libxfs/xfs_log_format.h
>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>> @@ -117,7 +117,12 @@ struct xfs_unmount_log_format {
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
>> @@ -240,6 +245,8 @@ typedef struct xfs_trans_header {
>>   #define	XFS_LI_CUD		0x1243
>>   #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
>>   #define	XFS_LI_BUD		0x1245
>> +#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
>> +#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
>>   
>>   #define XFS_LI_TYPE_DESC \
>>   	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
>> @@ -255,7 +262,9 @@ typedef struct xfs_trans_header {
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
>> @@ -863,4 +872,35 @@ struct xfs_icreate_log {
>>   	__be32		icl_gen;	/* inode generation number to use */
>>   };
>>   
>> +/*
>> + * Flags for deferred attribute operations.
>> + * Upper bits are flags, lower byte is type code
>> + */
>> +#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
>> +#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
>> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0x0FF	/* Flags type mask */
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
>> index 3cca2bf..b6e5514 100644
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
>> index 53456f3..ac35121 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -24,6 +24,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "scrub/scrub.h"
>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> index 779cb73..79f7bd2 100644
>> --- a/fs/xfs/xfs_acl.c
>> +++ b/fs/xfs/xfs_acl.c
>> @@ -10,6 +10,8 @@
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_error.h"
>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>> new file mode 100644
>> index 0000000..8c8f72d
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.c
>> @@ -0,0 +1,828 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
>> + * Author: Allison Collins <allison.henderson@oracle.com>
>> + */
>> +
>> +#include "xfs.h"
>> +#include "xfs_fs.h"
>> +#include "xfs_format.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_bit.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_mount.h"
>> +#include "xfs_defer.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_log_format.h"
>> +#include "xfs_trans.h"
>> +#include "xfs_bmap.h"
>> +#include "xfs_bmap_btree.h"
>> +#include "xfs_trans_priv.h"
>> +#include "xfs_buf_item.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_log.h"
>> +#include "xfs_btree.h"
>> +#include "xfs_rmap.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_icache.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>> +#include "xfs_attr.h"
>> +#include "xfs_shared.h"
>> +#include "xfs_attr_item.h"
>> +#include "xfs_alloc.h"
>> +#include "xfs_bmap.h"
>> +#include "xfs_trace.h"
>> +#include "libxfs/xfs_da_format.h"
>> +#include "xfs_inode.h"
>> +#include "xfs_quota.h"
>> +#include "xfs_trans_space.h"
>> +#include "xfs_log_priv.h"
>> +#include "xfs_log_recover.h"
>> +
>> +static const struct xfs_item_ops xfs_attri_item_ops;
>> +static const struct xfs_item_ops xfs_attrd_item_ops;
>> +
>> +/* iovec length must be 32-bit aligned */
>> +static inline size_t ATTR_NVEC_SIZE(size_t size)
>> +{
>> +	return size == sizeof(int32_t) ? size :
>> +	       sizeof(int32_t) + round_up(size, sizeof(int32_t));
>> +}
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
>> +
>> +	*nvecs += 1;
>> +	*nbytes += sizeof(struct xfs_attri_log_format);
>> +
>> +	/* Attr set and remove operations require a name */
>> +	ASSERT(attrip->attri_name_len > 0);
>> +
>> +	*nvecs += 1;
>> +	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
>> +
>> +	/*
>> +	 * Set ops can accept a value of 0 len to clear an attr value.  Remove
>> +	 * ops do not need a value at all.  So only account for the value
>> +	 * when it is needed.
>> +	 */
>> +	if (attrip->attri_value_len > 0) {
>> +		*nvecs += 1;
>> +		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
>> +	}
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
>> +			ATTR_NVEC_SIZE(attrip->attri_name_len));
>> +	if (attrip->attri_value_len > 0)
>> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>> +				attrip->attri_value,
>> +				ATTR_NVEC_SIZE(attrip->attri_value_len));
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
>> +	attrip = kmem_alloc_large(size, KM_ZERO);
>> +	if (attrip == NULL)
>> +		return NULL;
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
>> +	if (buf->i_len != len)
>> +		return -EFSCORRUPTED;
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
>> + * The ATTRD is either committed or aborted if the transaction is cancelled. If
>> + * the transaction is cancelled, drop our reference to the ATTRI and free the
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
>> +/*
>> + * Performs one step of an attribute update intent and marks the attrd item
>> + * dirty..  An attr operation may be a set or a remove.  Note that the
>> + * transaction is marked dirty regardless of whether the operation succeeds or
>> + * fails to support the ATTRI/ATTRD lifecycle rules.
>> + */
>> +int
>> +xfs_trans_attr(
> 
> xfs_attri_finish_update() ?
> 
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_attrd_log_item	*attrdp,
>> +	struct xfs_buf			**leaf_bp,
>> +	uint32_t			op_flags)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	error = xfs_qm_dqattach_locked(args->dp, 0);
>> +	if (error)
>> +		return error;
>> +
>> +	switch (op_flags) {
>> +	case XFS_ATTR_OP_FLAGS_SET:
>> +		args->op_flags |= XFS_DA_OP_ADDNAME;
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
>> +	if (!xfs_hasdelattr(mp))
>> +		return NULL;
>> +
>> +	attrip = xfs_attri_init(mp, 0);
>> +	if (attrip == NULL)
>> +		return NULL;
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
>> +	 * Corner case that can happen during a recovery.  Because the first
>> +	 * iteration of a multi part delay op happens in xfs_attri_item_recover
>> +	 * to maintain the order of the log replay items.  But the new
>> +	 * transactions do not automatically rejoin during a recovery as they do
>> +	 * in a standard delay op, so we need to catch this here and rejoin the
>> +	 * leaf to the new transaction
>> +	 */
>> +	if (attr->xattri_dac.leaf_bp &&
>> +	    attr->xattri_dac.leaf_bp->b_transp != tp) {
>> +		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
>> +		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
>> +	}
>> +
>> +	/*
>> +	 * Always reset trans after EAGAIN cycle
>> +	 * since the transaction is new
>> +	 */
>> +	dac->da_args->trans = tp;
>> +
>> +	error = xfs_trans_attr(dac, done_item, &dac->leaf_bp,
>> +			       attr->xattri_op_flags);
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
>> +STATIC xfs_lsn_t
>> +xfs_attri_item_committed(
>> +	struct xfs_log_item		*lip,
>> +	xfs_lsn_t			lsn)
>> +{
>> +	struct xfs_attri_log_item	*attrip;
>> +	/*
>> +	 * The attrip refers to xfs_attr_item memory to log the name and value
>> +	 * with the intent item. This already occurred when the intent was
>> +	 * committed so these fields are no longer accessed. Clear them out of
>   +	 * caution since we're about to free the xfs_attr_item.
>> +	 */
>> +	attrip = ATTRI_ITEM(lip);
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
>> +/*
>> + * This routine is called to allocate an "attr free done" log item.
>> + */
>> +struct xfs_attrd_log_item *
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
>> +static const struct xfs_item_ops xfs_attrd_item_ops = {
>> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.iop_size	= xfs_attrd_item_size,
>> +	.iop_format	= xfs_attrd_item_format,
>> +	.iop_release    = xfs_attrd_item_release,
>> +};
>> +
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
>> +	struct xfs_attr_item		*new_attr;
>> +	struct xfs_mount		*mp = lip->li_mountp;
>> +	struct xfs_inode		*ip;
>> +	struct xfs_da_args		args;
>> +	struct xfs_da_args		*new_args;
>> +	struct xfs_trans_res		tres;
>> +	bool				rsvd;
>> +	struct xfs_attri_log_format	*attrp;
>> +	int				error;
>> +	int				total;
>> +	int				local;
>> +	struct xfs_attrd_log_item	*done_item = NULL;
>> +	struct xfs_attr_item		attr = {
>> +		.xattri_op_flags	= attrip->attri_format.alfi_op_flags,
>> +		.xattri_dac.da_args	= &args,
>> +	};
>> +
>> +	/*
>> +	 * First check the validity of the attr described by the ATTRI.  If any
>> +	 * are bad, then assume that all are bad and just toss the ATTRI.
>> +	 */
>> +	attrp = &attrip->attri_format;
>> +	if (!(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
>> +	      attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
>> +	    (attrp->alfi_value_len > XATTR_SIZE_MAX) ||
>> +	    (attrp->alfi_name_len > XATTR_NAME_MAX) ||
>> +	    (attrp->alfi_name_len == 0) ||
>> +	    xfs_verify_ino(mp, attrp->alfi_ino) == false ||
> 
> Please put this validation logic in a separate predicate.
> 
> It probably ought to ensure that there aren't illegal characters in the
> attr name too.
> 
>> +	    !xfs_hasdelattr(mp)) {
> 
> Weird nit: If you mount with -o delattr, crash, and remount without that
> mount option, we'll report that as a corruption error.
> 
> Not sure what we want to do about that, it's a rough edge but it's also
> an experimental feature.
> 
>> +		return -EFSCORRUPTED;
>> +	}
>> +
>> +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
>> +	if (error)
>> +		return error;
>> +
>> +	if (VFS_I(ip)->i_nlink == 0)
>> +		xfs_iflags_set(ip, XFS_IRECOVERY);
> 
>> +
>> +	memset(&args, 0, sizeof(struct xfs_da_args));
>> +	args.dp = ip;
>> +	args.geo = mp->m_attr_geo;
>> +	args.op_flags = attrp->alfi_op_flags;
>> +	args.whichfork = XFS_ATTR_FORK;
>> +	args.name = attrip->attri_name;
>> +	args.namelen = attrp->alfi_name_len;
>> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
>> +	args.attr_filter = attrp->alfi_attr_flags;
>> +
>> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
>> +		args.value = attrip->attri_value;
>> +		args.valuelen = attrp->alfi_value_len;
>> +		args.total = xfs_attr_calc_size(&args, &local);
>> +
>> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
>> +					args.total;
>> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>> +		total = args.total;
>> +	} else {
>> +		tres = M_RES(mp)->tr_attrrm;
>> +		total = XFS_ATTRRM_SPACE_RES(mp);
>> +	}
> 
> Isn't there already code in xfs_attr.c that does this?
> 
>> +	error = xfs_trans_alloc(mp, &tres, total, 0,
>> +				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>> +	if (error)
>> +		return error;
>> +
>> +	done_item = xfs_trans_get_attrd(args.trans, attrip);
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(args.trans, ip, 0);
>> +
>> +	error = xfs_trans_attr(&attr.xattri_dac, done_item,
>> +			       &attr.xattri_dac.leaf_bp, attrp->alfi_op_flags);
>> +	if (error == -EAGAIN) {
>> +		/*
>> +		 * There's more work to do, so make a new xfs_attr_item and add
>> +		 * it to this transaction.  We dont use xfs_attr_item_init here
>> +		 * because we need the info stored in the current attr to
>> +		 * continue with this multi-part operation.  So, alloc space
>> +		 * for it and the args and copy everything there.
>> +		 */
>> +		new_attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
>> +				       sizeof(struct xfs_da_args), KM_NOFS);
>> +		new_args = (struct xfs_da_args *)((char *)new_attr +
>> +			   sizeof(struct xfs_attr_item));
>> +
>> +		memcpy(new_args, &args, sizeof(struct xfs_da_args));
>> +		memcpy(new_attr, &attr, sizeof(struct xfs_attr_item));
>> +
>> +		new_attr->xattri_dac.da_args = new_args;
>> +		memset(&new_attr->xattri_list, 0, sizeof(struct list_head));
>> +
>> +		xfs_defer_add(args.trans, XFS_DEFER_OPS_TYPE_ATTR,
>> +			      &new_attr->xattri_list);
>> +
>> +		/* Do not send -EAGAIN back to caller */
>> +		error = 0;
>> +	} else if (error) {
>> +		xfs_trans_cancel(args.trans);
>> +		goto out;
>> +	}
>> +
>> +	xfs_defer_ops_capture_and_commit(args.trans, ip, capture_list);
>> +
>> +out:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	xfs_irele(ip);
>> +	return error;
>> +}
>> +
>> +/* Relog an intent item to push the log tail forward. */
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
>> +static const struct xfs_item_ops xfs_attri_item_ops = {
>> +	.iop_size	= xfs_attri_item_size,
>> +	.iop_format	= xfs_attri_item_format,
>> +	.iop_unpin	= xfs_attri_item_unpin,
>> +	.iop_committed	= xfs_attri_item_committed,
>> +	.iop_release    = xfs_attri_item_release,
>> +	.iop_recover	= xfs_attri_item_recover,
>> +	.iop_match	= xfs_attri_item_match,
>> +	.iop_relog	= xfs_attri_item_relog,
>> +};
>> +
>> +
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
>> +	if (attri_formatp->__pad != 0 || attri_formatp->alfi_name_len == 0 ||
>> +	    (attri_formatp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
>> +	    attri_formatp->alfi_value_len != 0))
>> +		return -EFSCORRUPTED;
> 
> Might be worth an XFS_ERROR_REPORT here since this is evidence of incore
> memory corruption, right?
> 
>> +
>> +	buffer_size = attri_formatp->alfi_name_len +
>> +		      attri_formatp->alfi_value_len;
>> +
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
>> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
>> +	.item_type	= XFS_LI_ATTRI,
>> +	.commit_pass2	= xlog_recover_attri_commit_pass2,
>> +};
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
>> +	ASSERT((item->ri_buf[0].i_len ==
>> +				(sizeof(struct xfs_attrd_log_format))));
>> +
>> +	xlog_recover_release_intent(log, XFS_LI_ATTRI,
>> +				    attrd_formatp->alfd_alf_id);
>> +	return 0;
>> +}
>> +
>> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
>> +	.item_type	= XFS_LI_ATTRD,
>> +	.commit_pass2	= xlog_recover_attrd_commit_pass2,
>> +};
>> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
>> new file mode 100644
>> index 0000000..27c6bae
>> --- /dev/null
>> +++ b/fs/xfs/xfs_attr_item.h
>> @@ -0,0 +1,52 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>> + *
>> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
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
>> + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
>> + */
>> +#define	XFS_ATTRI_RECOVERED	1
>> +
>> +
>> +/*
>> + * This is the "attr intention" log item.  It is used to log the fact that some
> 
> Well, it's the incore state tracking for attr intent log items... :)
> 
> Aside from the nits I 've pointed out so far, this looks more or less ok
> to me.
> 
> --------------
> 
> Ok, so here we are at the end.  Looking at my own atomic extent swap
> series, I broke this up into two pieces -- one to create the barebones
> log item (with dummy implementations); and a second one to create the
> defer ops code and connect it to the log item.
> 
> Oh, heh.  The first patch is 16K and the second one is 47K.
> 
> That might be a good way to break *this* patch into smaller parts, if
> nothing else -- concentrate on getting the log parts working, then
> connect the new state machine to defer ops and log items.
> 
> That said, as this series gets longer and longer I find it really more
> difficult to go through the whole series one by one vs. just diffing the
> whole branch and reviewing that.
> 
> <shrug> I don't really have a definitive answer for which is better.
> The xattr code is very complex, and I struggle even combining both of my
> usual strategies and attacking review from both ends.
> 
> By the way, have you been stress testing the xattr code with all this
> stuff applied?  At some point it becomes easier to pull this in and fix
> up the breakage than it is to review 22 slice-n-dice patches every cycle.
> 
> --D
> 
>> + * attribute operations need to be processed.  An operation is currently either
>> + * a set or remove.  Set or remove operations are described by the xfs_attr_item
>> + * which may be logged to this intent.
>> + *
>> + * During a normal attr operation, name and value point to the name and value
>> + * feilds of the calling functions xfs_da_args.  During a recovery, the name
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
>> +	struct xfs_attrd_log_format	attrd_format;
>> +};
>> +
>> +#endif	/* __XFS_ATTR_ITEM_H__ */
>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>> index 8f8837f..d7787a5 100644
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
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 248083e..6682936 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -15,6 +15,8 @@
>>   #include "xfs_iwalk.h"
>>   #include "xfs_itable.h"
>>   #include "xfs_error.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_bmap_util.h"
>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>> index c1771e7..62e1534 100644
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
>> index 00369502f..ce04721 100644
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
>> index 0604183..290e57b 100644
>> --- a/fs/xfs/xfs_log.c
>> +++ b/fs/xfs/xfs_log.c
>> @@ -2070,6 +2070,10 @@ xlog_print_tic_res(
>>   	    REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>>   	    REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>>   	    REG_TYPE_STR(BUD_FORMAT, "bud_format"),
>> +	    REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
>> +	    REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
>> +	    REG_TYPE_STR(ATTR_NAME, "attr_name"),
>> +	    REG_TYPE_STR(ATTR_VALUE, "attr_value"),
>>   	};
>>   	BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>>   #undef REG_TYPE_STR
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 295a5c6..c0821b6 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -1775,6 +1775,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
>>   	&xlog_cud_item_ops,
>>   	&xlog_bui_item_ops,
>>   	&xlog_bud_item_ops,
>> +	&xlog_attri_item_ops,
>> +	&xlog_attrd_item_ops,
>>   };
>>   
>>   static const struct xlog_recover_item_ops *
>> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
>> index 0aa87c21..bc9c25e 100644
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
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index bca48b3..9b0c790 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -10,6 +10,7 @@
>>   #include "xfs_log_format.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_acl.h"
>>   #include "xfs_da_btree.h"
>> -- 
>> 2.7.4
>>
