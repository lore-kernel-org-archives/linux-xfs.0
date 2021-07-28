Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB38C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E103960FD8
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 09:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhG1JDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 05:03:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5560 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233740AbhG1JC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jul 2021 05:02:59 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S92tCR031801;
        Wed, 28 Jul 2021 09:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iWO9dTpIPVd0eygywX1FHmVIpFywVFYnI0r+VquEVBU=;
 b=gH86CIebLAHC1vaPKHuQGw08HlvAZjOtmkR3EDI0b6OTWiIbseP+78RqrKHei3CMagxj
 wCgV62or35cy7o0GBv/+aysl5P8YnMxn/CS2epH2o7JdAvg5C7dX8hz3WmvoP/2crmiw
 nuw9bM0cVfIzwaIsn9SG3J1saLVzDiaoRBrFQOdcrzddFV/Be4WuTYaK8L4nfpcCP2Ii
 v+diB3l5BSTCZ7CEYwVh41X1aLrdr13xQfSXrkdCsJl7/zuAGQQoaXGYDeCMudVOHRS+
 Pm5gtJNan94sQtkTlKv+XedD8rRhdNjpQewEU2Tqg4qBa/gVwkDJ/8X+xK1TTmE9gX6J GQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iWO9dTpIPVd0eygywX1FHmVIpFywVFYnI0r+VquEVBU=;
 b=RacmaubQZsekDU2ORT9qleYPqOummDqdmr2x7MYMRhab6gEmhqHHPKCFpUXKjJmPRBTU
 xzkPvoYczwHCjtyc2wBxnQfcUy3b/v5OYUA5l4W+US+sBPyplOpgkfT/OqGJXjgDWP3t
 6W7SGUcpnloiEt7nQxzw9pD6HE33mx8V0jeaTP/1+/3DD5T14C0QPEtfN6SIAy0LQlXk
 jpmiJbtV5O4A5vVeCwN7+mWVQbIq5PqtL0Grbdi5SBD57zopk3mMJahfUghmQD3hDiDW
 OilIBd7tfPnHpZXFzOQ/t1CjQSXQzmLFeI5d8mOAXZwZP5yI8csQARwo73mTjmnwPvqw KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234n3u5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:02:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S90mlf137088;
        Wed, 28 Jul 2021 09:02:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 3a234x88u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:02:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRiPJce4y71Ns6/Ox9U3ycHvXBxWR5X4qUJXaZRL03coD2/MqSrEY6RcKkFI1dGfDPqkWE1z2oJYFORnM40T0XzWK8sIrQTxE+25LrrTvqtQXtKEQMF+8ObAL0C0MWLtL2YlMUpgISZusebqOq7CV1pWRRlOmawoeC2bcpbzEV9GP1mlOe4IOWutHXtbMeMM/S7aETVKoqiydEQa5lW9u8YkP7A2FpmgWI2uj2Zl6zXLQa85V3npuJ89j+NZ7mmiZRlXPrnJiANp2uDj0/JLQANmHIZl3njLBalAy+dH5qy6qJhv2txn4MdVpFYPA18pkSw8rTUvVp99j2HJiU89Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWO9dTpIPVd0eygywX1FHmVIpFywVFYnI0r+VquEVBU=;
 b=Wr9du7T7bxBuvYPq8fVDBdosMzW+JGpAD1ebyJhVPDCkE8C7JFatUzcLFd7PkprHJ09HQEY2oZoqGtUuCvZEtbhfKmvTiw3r2JxpeVhyimdQ+XqWff6tJtw75x+Cbg+oL+DHWaJdU8A1zVnZa7zFpuEqoovmNrmYFAar+TZFzWRdts207ioani/UPLj2cNP9sTIcrLM+dozE/xHIkrdWi7Pp5iFVyCEFF53XEiuksbasbpnykie5Kpj6H5K0zdEqmUTf3lFO2m1wMCQDX/i+h2wAEy8Pb/urYXPRkMmd5Fi/P9Dk+5/g7JnfOzQRG2iuZd6s7xbHhf8HmcDjvRe29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWO9dTpIPVd0eygywX1FHmVIpFywVFYnI0r+VquEVBU=;
 b=VhKN9wXOGRCTbZ8nWT2OXGGKd+m8nj5XsmP10jDX7ZEkeuHRLv/MVAHI0DnKy9B7zQsnpOLb5+rJqOPCrNTe0e19LHOjUMsnKmMmoQbPek5DJxtH7nknQvczD4tclZoXjr1NX6YmQB+fLeyhlb41TWT89SHK/aW+lt5VzuM21ig=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 09:02:50 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 09:02:50 +0000
Subject: Re: [PATCH v22 14/16] xfs: Add delattr mount option
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-15-allison.henderson@oracle.com>
 <20210728004757.GB559212@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4b57db7c-d7b9-7bdb-113b-4468edbd3b82@oracle.com>
Date:   Wed, 28 Jul 2021 02:02:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728004757.GB559212@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by BY5PR17CA0009.namprd17.prod.outlook.com (2603:10b6:a03:1b8::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 09:02:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40f5df88-39c5-4ba1-118f-08d951a679e8
X-MS-TrafficTypeDiagnostic: BYAPR10MB2966:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2966097AE87E9E305C6FB1A195EA9@BYAPR10MB2966.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GH2eR0rqfIOcoUOnFap0454XAIO5NcFCYNyCNNHueWVmIEm079084mNqc0FOZH1Q3nAPt8XEcXV0afD8J3rHQGhJ3QI4DKskHmL9N0lZC7JwK8fsi5T0LgK5IINDBHT0zhms12cAwjDsqBYsmznCk8bGfChsbZ1QlpEpKEV5LqJReX5d9tjuXVzZG1yxnCXlyc3on4hJMRLhdovfjK7shmtc86a7dtB5nDfFhEC4NTvYH5nWH9z54C76Qj9KuSg3uVsu1jiGk22qc8Lfhn2820M3USuTM10mVYj/IM7r6lfGheu67IRXYXLjMQsAYInWsLmFRU5qAR6QaC5EPJv1C9pm6KuvDUUJNUsvd8buH10OslzuWzGzOpceqVQzfxOxF5RyHT4Ltau6uqUgxbMxXNVjL+7NnAhcUvZz9Bbpz4MxvnT9V3lWUpZi7c05jpyLxsZPE3mWSNw8ciQAb/B43QTqKCMT5VxXjKrbbG3IsE6SCzUlPVAPzRlfWof+No4Nm6nRcDMdwmIafchBSDso4KzbqKEhpzTV/GRp3fi7tv6WvuT3kJ9f9GsQoDsI0BsKE6MW6V9L5+8xZbWxtJzmGQaKhQP63t41TI/4d2t72xtW7Dp6wH3lWWxTAvIycxHJ5D7+jKbrAPR9zWuI3Fk+Ai91QDC4TaPfcaY3RmEQhnzF9RKnJfrf71pkrtxb0RuAA6C2AQ3RBgFgP50Aph5zFljRFqCfML+nGTo7X8dAxQE+2qN9wZ2BPTMQZvI5L6OW2sO0m7bQnFfN24+eREtKfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(6916009)(38100700002)(26005)(6486002)(52116002)(2616005)(38350700002)(316002)(66946007)(66476007)(66556008)(83380400001)(5660300002)(2906002)(508600001)(956004)(36756003)(186003)(16576012)(44832011)(4326008)(8676002)(8936002)(53546011)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VElZQ3R1MXc5dnprN2I0cEoxWU5UZStLSWJEbCtNUS9lU2J0NENqN24zbEpQ?=
 =?utf-8?B?Umg4blRpUmNEdmFjeGJ4TEUyZWliUnYvakFwbnVQazQwSGhuZnl1NmtnRlR6?=
 =?utf-8?B?dVQ3UUxheEtmYnZsdEJNemdScTF4dWlhTTV6c0dUZEtMV3pzTTFHcGRneTBE?=
 =?utf-8?B?Q2xLVS94T1lVNHdCTEJEWVhLN2d6QnR5TUtjMFlpVGJNU08rVnI2TXk2alBS?=
 =?utf-8?B?bWJmMmNQK0hxNFcxYVdRQllLODZ2QndpT05PZDhTdk5WcTF6NmZMbW5sQ0FR?=
 =?utf-8?B?Y3NlRVVDcnN1UGNNdytZTGNLSVZ6NHp0emlEVmxodktIN2FMRXl6Mks2OENQ?=
 =?utf-8?B?TWh6Vmo5U0ZyKzRxWGc0cjlLcnRNUXV5d1B6VkxsSmN1NGErVlJNMGRiVjJT?=
 =?utf-8?B?L3dMcGNOOTJ5WmZtUWtCZG93Vjd5Nm02RXBBTDM2RWJ0WCsrUnJPcVF5Mjcy?=
 =?utf-8?B?S2dNZVJCemwrSkFnQk9jdFlON0dVWXB1dWNoM0FZOUQ1dXRtZmFXWTZ1YUZU?=
 =?utf-8?B?WnRQK3c4b1plNTRSWTVvTjBqZG5aMXdTSFVSeXhXZ3kySnp4SkFUdjJteTZp?=
 =?utf-8?B?eHVXZ3lQMEJuNDIyK2YzY3VsVjFaQUR5Z3pSZG4zZEdySW12ZEQrODNoZUl5?=
 =?utf-8?B?N05BUTdnYlRrcmdjMjg5cnM4YkpEdWVtVHAwUElmbFEzY25RcmFocVo5TlVG?=
 =?utf-8?B?V0Y3bzFGZmszcDVPWk5LTXhsODQwZmhFb3NRMVBxcUx1bWpkVjlKcWZBM2dZ?=
 =?utf-8?B?ZEZBVisyT280NXVMdTIrVWNZMlJENHNabmxmN3YyVHZFUzhqTW4zRWpqc3RG?=
 =?utf-8?B?dk9mS0x4Q0VRNnhpTUJoQlVyZk1VOVJraHlaOUhkcDlXcUs4RnZaL3JxblJw?=
 =?utf-8?B?RGhnYlZ2Q3ZGbFVLS3dBMzFHTU9ucEZvK21US1dvaDhKN05vOXh2aHpIVmd4?=
 =?utf-8?B?aFE2TE9zaDB1VTBmd3d1anJLQkp1L0hCbmZDRU9LRHVlS2Z3Q0VWTTVsL2xT?=
 =?utf-8?B?WHN1QnJZcC9xN1ZaWVRLMytDNkkvVmpEY2Y1TkJpdXpuRTFmdTJHU3FINDlL?=
 =?utf-8?B?L2daSVVzM1U1V2FoSzJ6R1V1RkV1blYwNzZKbWlhc0dsNE9Rcjh2K1dqd2Z1?=
 =?utf-8?B?cmliUlhWMlBORmU3VW1zR3F0cS9sTDI1NmRMWERPTm9yNHUzeFVDZTVGYkI5?=
 =?utf-8?B?OWM1NkhGeDlXVks3ZVBrSTNKSnBMTnk3ejh3YjhUNzRORk5QemRBNUNXNUJV?=
 =?utf-8?B?OThRMVlTWlRad3RKcnRJakMveThLU0NSd2hkcE9zbUpsSkViUzBmdWNqNHB2?=
 =?utf-8?B?ZmdiQjhaZWFWYnJRVldoaGtvT1ZQZWxqS0pDTklzMFN5SDBhaDJzMjl6a0tO?=
 =?utf-8?B?Q3JBUmVpa3NjTTIzT3ptNmFQcEJvd0pwY21TaHJpSTVQSDVzYnJ5MnJ1NkQ4?=
 =?utf-8?B?cXJLdDV1a0p3aFJuMWxHbmt3Q1pYUWlqQ004VTR5bTdRemU4cU9ycjUwRzJu?=
 =?utf-8?B?V2tkWEZwU3ltTFFoWStyRXkrZVZKTUxNVzJ0Smc0dzNqTGtpQkhoQWJqaDRm?=
 =?utf-8?B?T2RnTXoxYlRGS01MTmhTaGF5NmV6azdram9FVHJXTHR2Z2w4NW1zZGVIQlNj?=
 =?utf-8?B?VzJBaHdFa202eGR2ZTdsRjFXYmE4czBkbkV5RFd3RFd1a3VWQTh2L0pIbTdS?=
 =?utf-8?B?elRrUm9aaWVtdlRPN3lhNjFCVUYvRlhwMjdwZHU3UmJaelNuakZKNUxjYkc5?=
 =?utf-8?Q?ntv+jjwysTRcFJRDEYRZ7G1HnyJ2LLdAUL+kfwu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f5df88-39c5-4ba1-118f-08d951a679e8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:02:50.2075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eAG3fQC4/taCHFXYwMCWog2MoWL0BnTbwiGDi3iey9OyZhivHNe0P2FfcHAEP8gpOKPJyn2uPh+mK1Ay4Lvq0zlQ+EJ622NpUgTxG/tDHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2966
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280051
X-Proofpoint-ORIG-GUID: eX82yrm4bekSGVRHDrhuc_hhKrJl3ALk
X-Proofpoint-GUID: eX82yrm4bekSGVRHDrhuc_hhKrJl3ALk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/27/21 5:47 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:51PM -0700, Allison Henderson wrote:
>> This patch adds a mount option to enable delayed attributes. Eventually
>> this can be removed when delayed attrs becomes permanent.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.h |  2 +-
>>   fs/xfs/xfs_mount.h       |  1 +
>>   fs/xfs/xfs_super.c       | 11 ++++++++++-
>>   fs/xfs/xfs_xattr.c       |  2 ++
>>   4 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index c0c92bd3..d4e7521 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>>   
>>   static inline bool xfs_hasdelattr(struct xfs_mount *mp)
>>   {
>> -	return false;
>> +	return mp->m_flags & XFS_MOUNT_DELATTR;
>>   }
>>   
>>   /*
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index 66a47f5..2945868 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -257,6 +257,7 @@ typedef struct xfs_mount {
>>   #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>>   #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>>   #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
>> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
> 
> So uh while we're renaming things away from "delattr", maybe this ...
> 
> 	LOGGED ATTRIBUTE RE PLAY
> 
> ... really should become the "larp" debug-only mount option.
> 
> 	XFS_MOUNT_LARP
> 
> Yeah.  Do it!!!

Sure, though it sounds like Dave would prefer to see a debug option 
instead of a mount option.  Will name it larp though :-)

> 
>>   /*
>>    * Max and min values for mount-option defined I/O
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 2c9e26a..39d6645 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -94,7 +94,7 @@ enum {
>>   	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>>   	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>>   	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
>> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
>> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>>   };
>>   
>>   static const struct fs_parameter_spec xfs_fs_parameters[] = {
>> @@ -139,6 +139,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>>   	fsparam_flag("nodiscard",	Opt_nodiscard),
>>   	fsparam_flag("dax",		Opt_dax),
>>   	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
>> +	fsparam_flag("delattr",		Opt_delattr),
> 
> I think you need this line to be guarded by #ifdefs so that the mount
> options parsing code will reject -o larp on non-debug kernels.

Sure, though this may go away if we turn it into a debug option.

> 
> --D
> 
>>   	{}
>>   };
>>   
>> @@ -1273,6 +1274,14 @@ xfs_fs_parse_param(
>>   		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
>>   		return 0;
>>   #endif
>> +#ifdef CONFIG_XFS_DEBUG
>> +	case Opt_delattr:
>> +		xfs_warn(parsing_mp,
>> +			"EXPERIMENTAL logged xattrs feature in use. "
>> +			"Use at your own risk");
>> +		parsing_mp->m_flags |= XFS_MOUNT_DELATTR;
>> +		return 0;
>> +#endif
>>   	/* Following mount options will be removed in September 2025 */
>>   	case Opt_ikeep:
>>   		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>> index 0d050f8..a4f97e7 100644
>> --- a/fs/xfs/xfs_xattr.c
>> +++ b/fs/xfs/xfs_xattr.c
>> @@ -8,6 +8,8 @@
>>   #include "xfs_shared.h"
>>   #include "xfs_format.h"
>>   #include "xfs_log_format.h"
>> +#include "xfs_trans_resv.h"
>> +#include "xfs_mount.h"
>>   #include "xfs_da_format.h"
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>> -- 
>> 2.7.4
>>
