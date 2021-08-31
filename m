Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA38C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53EE86109D
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhHaSGP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:06:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28940 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240755AbhHaSES (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 14:04:18 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFlngv001701;
        Tue, 31 Aug 2021 18:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5ZLtIkemgewlgyNaNcrsV2WCdQ9LE1og7ppGC6YUn04=;
 b=xFkYWyy+98nabL3WaiVAZF0WsUT9Sl3sbWAQYiFTkxBx7D/TqlJbQHYrdYgR/DTcgZDW
 2j4L/kHkg/x/lPWqSb3MG4xm/oiCKm02XybG8Y5WNxM7gnUpitKy8b168Bg5L2gB+SAF
 BMk+qCu/ybokZODDmZglijPLjfv7WXiM1FBY4Y4xRLF5gqIwEgld18X71K2YIQ7Pgjf5
 o/TgFlryuhDFdMBl/6hAX89l0HSE1U/G0epl5poaNxNID86IC9LX0EUUCQ6gwAbd+6fi
 oFimTIhbS3emiFNBQ0y3MjYyz47Uj3xDQTcZ1JmTAkl+S3DnSEzhIyfrF6xO3bvApLBS uQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5ZLtIkemgewlgyNaNcrsV2WCdQ9LE1og7ppGC6YUn04=;
 b=Dm98MAt/zWXNkgbfZ25bdbdu44rABOAtip3zpTVNpHWhSjtKFZpDloBKsJjfeRC5s4JB
 sxmWWwH/+/Gm2XUoamN79jDB/STUWTaoRxhc1+wkccLZRH+5u/DTqo10SZM6qJj4Pafe
 S6G9i/C44fRCjDNXXLRtCli3WALZ9ZStVr5tHJA0djh14uwrOLTkUWgV+9crgPRAEY+Z
 ccR2/AbXsxii3VHXMarIW/9T0pPvExqMzBGCK5Qr1vDudUk0fBryABsuFReaOH9U6sOp
 w/lkUz16iqxFleG0EeYEK6EU2nQyAbNIaJM4GFlEPWWHeDVfdKZBjAF3t3OGc+EkApnz 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aseedhymy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:03:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VHuIqj008558;
        Tue, 31 Aug 2021 18:03:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3030.oracle.com with ESMTP id 3arpf4u7nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:03:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBulRXV42ho3Thki/PeTN345BtMEFOmCTVUB9rCoumozD5/8cYIDU04HKaEgpYSzstxOTcxNwse+kj/NIyboJwmQalLWjHkjdFyPKYMTrzL88IbM3+UPCWvbSI61qIlsqlXqhJV2IIeBgK1VNDcYwZtQizj3xs+KjUaX8xMdzGoWnu7C2zI2WYmPuDwLJJ1QBbF8qAW+u2TCmojeNVZkzSy4EBWC6Xowb03M0G4X/lasDHSR2e6EUUZcVANIoo2R1wgnVQeU716aksk/DJF2QnAsNtQ2H1aYPWmuLkCYdb9V1gnkqwJiAE9jwXrLuzUkpW4Ekcwr+fJs/YHA9hhJlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZLtIkemgewlgyNaNcrsV2WCdQ9LE1og7ppGC6YUn04=;
 b=Pcx2G/GMiVr3D7D52bs5a8TPuDaYIjs/GlUTjyCkmvmhXWiAz5gy3IUtPwhQaHWYUw9p/2mf1k1xsHwftT3dcH0f5zcc288lNsVxAUgLwssv9EU0vChTp8dDq1SvZmrSgiuexxXnsr4duGxDO8wZD770H4ZgfdnBsr9YdAcT2zw39R2BGg4beASZjC+8rDEM73vfrLzCZoQOJERYS18USmsvY5h3C9llmSc9kaEB++5z8c8b7MhZ0tGxo/uFB/bdUFSF4BIcapU2/4C3HDk5xdpwezBOnX85tQbX5MA4y8tU1M2q8DmpIN6sd8vMzyiMiOVxM6GKnWbWxkGIBcPEVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZLtIkemgewlgyNaNcrsV2WCdQ9LE1og7ppGC6YUn04=;
 b=DasgAWPCUQzqASFkV3W7savAxoHU2O8q/8SrqD6bTXAdBy+8MgEfsE0TbiP6peTmEZbUJtJn8ry9CD+gV6hkBirfrVYY65zxMZvjIN7C/Homjl+OmcFdnZm7CV9dVW9vuZ40lajNb+FAAE/W9+cnkVO4j7Br37KekQPnbc0rpjQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5488.namprd10.prod.outlook.com (2603:10b6:a03:37e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 18:03:18 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 18:03:18 +0000
Subject: Re: [PATCH v24 02/11] xfs: Capture buffers for delayed ops
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-3-allison.henderson@oracle.com>
 <87k0k79l6f.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <04a12fcb-952f-9a1f-c8ab-0429677ca132@oracle.com>
Date:   Tue, 31 Aug 2021 11:03:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <87k0k79l6f.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR03CA0124.namprd03.prod.outlook.com (2603:10b6:a03:33c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Tue, 31 Aug 2021 18:03:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58cd91aa-1caf-4dbe-73a7-08d96ca99cdc
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5488:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB54881D89545D583C431AF64795CC9@SJ0PR10MB5488.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:473;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4C2CR8aXamgHkEwdO6u+V17m200w/JiGn9IKNHGDCtTKcdEByQWlDTM6J/1/Qn3XOI3clZnaHzSDNRBbUy0ezDdmsdOZE/jwEVvcOI+nQWCCld2TYRzbvFb5giyoh/WnbJGSYWBkLyEjZBZjqoFVmy6Hud8nalnpXHrpKimyWkeC54fBh45PUoHWSaaaiE77Pcj9F6zxBIgo0OXgUk8jReircLOBrqVHqZgO83tBxpVBy7OJP0F66LlYk6eoxdwfR0f2ZgTgZvtUEiTLAY8UeLni6UtpAkaXXyOjQnA90cDs1VBK/fviarivT7qmpywGLLDjboFZyJ4j/i4xBX4CocNFo5uV2h4teG3LVEFiUIlAmHzyteKj9ezNtTS2ZJWFJTPlfvIkuKjQct7KLjKPx5xqAdBoGIJgUa+YzE4xAoeSeBGquCJP6leFXWLLWuNYT/DXCHjgqPWeJDss2cb8rplcB+y4tJfSNiLvUK/ezT7OUsRKA7wRx9vgJYij/nOVbObHA4qyXv5ge0tsmU2Xv2LyyfHhkADnCeZXR/QHM4IorgaHyDVwavlal9Td3le0/ig3hS6SAk4QHpbf6tftnfbUlXZGBMcJbVjBKAuMPU+UutB4eJs2bpjkp1LtFCE0qEB4bQ2aeuXPXE6MEh3oiQwHhBIyIEVt2s0UldyLw8KTjzQ7X3CczBOW9wP9iy4H8wEftFCfwOO2ZhWdUc6zTW6D2zTJlcvQEgAf5joG6aQCSNCm9c2uO6W5IG9KAWO7UY87Pwv8RXiMirYdoQvnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(86362001)(66946007)(66556008)(66476007)(186003)(31696002)(6486002)(36756003)(53546011)(8676002)(31686004)(52116002)(38350700002)(16576012)(38100700002)(8936002)(508600001)(316002)(6916009)(956004)(4326008)(5660300002)(2616005)(83380400001)(26005)(44832011)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djlnYXdQRlJjVmV6eHJlbkNYNVVOVHZtQzJtVThveXV5aXNDd1dEdmRqVVVk?=
 =?utf-8?B?SjVyTTV2MHVWWTFLQnRGL250VitOcm90ZFV6U2NVSWIyaVFIR2N3NjF0TXlm?=
 =?utf-8?B?ZFJPM3lySUxxNjZRc1d4YXFVbzgvZmp4QlpaYkhzekxwaHQ2UUhCYVpycVZq?=
 =?utf-8?B?VmFjN0VhMjRoeER1R0ZiWThDQ3ZmNkw1ZnAxMFRwc09EQTBNa3RSWUplbHp1?=
 =?utf-8?B?amtyQThrWU5hTTg1aFlhWmlhUERIMk5mcnV4TmdjeE5JUEV2MHU0ZFozcDJi?=
 =?utf-8?B?amlSaVl0ZDFtakhlUlZJYnpxZ0UzUU5MUEdQdjdnS1FRRTJ2NEdHMWZsS29s?=
 =?utf-8?B?amNuWDRIdzZ4NURQVjhvVXJkSzd4ZGQ2SVJUd05oTmF0OGE5d2Uvak81NTBr?=
 =?utf-8?B?M2lQSHZTbmt3M1BObktTUnQrVHNpL0pHYW53bWo1ZXdrbkc2M0IwWk43UXRz?=
 =?utf-8?B?TnVCN2R1a2NLa296TFN2ZVBNTnovSkR1U2hwSmUyMHprT3pKSmFuNVFUWVdV?=
 =?utf-8?B?SElYM2pIdnlyemVud3loalZGS2ZEZzFuN25sZzd5dXcyclFHZHVEWmRXdVFR?=
 =?utf-8?B?Y1dzcytlaFRnOHhPbDdaaU56VEd3cDBBNmt3SGZhRldsN0lkYytFZk5NS3hu?=
 =?utf-8?B?cmlHRHA1TE9nUXU4V0J2b3Z3RUQyd3NuSDFEVHFjQUdsa0t3dzh2Z3VQd1dU?=
 =?utf-8?B?ZkVaSldJS0hmWGJCQVNaVnVsTEw5ckRwenRjcG90dlBWa013cHB5OG56U3dh?=
 =?utf-8?B?bUsyWFkrMUxEb1N1YUVGdHRJRE41Sm42OFpISUNWdnk5V3NlQ2JqWCswVUJF?=
 =?utf-8?B?TmdqZkVpV2ZONW9JdFkxN0pHMUh5bFpERUs3T1FQNDN2SlNISzhxUXFTdjVt?=
 =?utf-8?B?UmJWZE5TWVhjZC9XdmhrYWxUY2NPNXh4bDgvOVQrd2xSTDdMeXJodmhWWi9D?=
 =?utf-8?B?dzJDNUpjdVp6UlVxc1B1YWRHRmhjdENJcUpkYXJ4SUtjSVhVNW8yYTRxUC8r?=
 =?utf-8?B?eENhRE85SWRDZ3Ivb0d0a1R1dDAzVDlpTjdSTnY0M2M3Y1BOUFNrODNOM3Z1?=
 =?utf-8?B?SVVBRXZYWnFBQTI1VWJnU2RjUndFVS9RcXNSQmJPK1hub0szdkdsWGJ3Tkhp?=
 =?utf-8?B?b2M3djVqbGtic2p1T2tZOW1mcWtDTlQxRW5lbXQ4blJwZDk5QjluaWdLd1dO?=
 =?utf-8?B?MzZwYTNEUkJ4bEJFbXovcHRqL1JzQ3M0bnJlWlRTV3oyNHhYU0RTZVM4dkNa?=
 =?utf-8?B?RkR0V01xK2RvTWlaOW9OR0lTUjJWVVc3MldkM0VHY0hwdnFnaWh3dFkya0kx?=
 =?utf-8?B?ZWFUdVgvVVhrQ2dubGVOY3AyV2Vka3lEQXZqM1JGTFUrbFY3R1FNRDZQdDU5?=
 =?utf-8?B?d1pRY3ZudytYdHpOTkl5Z1dtUDBSOHlZUllVVnlYMG9JOUt5OEhjbVBhUDBq?=
 =?utf-8?B?RmcvRU5IMDZoRlNXZE5JTXpHWC92cjlMcVVDdnlrTDNGT1V3UmRieXhRaFYx?=
 =?utf-8?B?WTExNEgvZGEyMEhESVZ5Vy9XQmUxbDdvSk1Fa29UbU9rN1RVVXpjcVJwNzJX?=
 =?utf-8?B?RnhWZnVHT2pOdCtPbHM3dEFra3lVMVl6WHNvZWE0dmY4YmFYUnhKR0VPbXBG?=
 =?utf-8?B?dldMaWhTVERTeHFkeTROZGR0UVBMcTNheFVJaC80RWJMKzhqbmFQUmMwSEc0?=
 =?utf-8?B?RldmRXB2aGxkTWtBTjE5eE9yZ281aGlIYW1mQ0VuMHhiMUJZcnFBNEhTQXVl?=
 =?utf-8?Q?mHF45xfIqdxewaQ8moebgzGBk7RYQpIV/jCnlMh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58cd91aa-1caf-4dbe-73a7-08d96ca99cdc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 18:03:18.8065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5qtALPxBgysJZyYXBHLBLm5ngtq42J6c3CeSqaQvP8EZeWDm9dQvrpqQyXfVGkDfiY182aa34/YJcasqMZZfrSwskuLW9N0seHJrVoSju0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5488
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310099
X-Proofpoint-ORIG-GUID: mxbqDktyckre2aSaNYtl602lGUnUkNuT
X-Proofpoint-GUID: mxbqDktyckre2aSaNYtl602lGUnUkNuT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/27/21 4:33 AM, Chandan Babu R wrote:
> On 25 Aug 2021 at 04:14, Allison Henderson wrote:
>> This patch enables delayed operations to capture held buffers with in
>> the xfs_defer_capture. Buffers are then rejoined to the new
>> transaction in xlog_finish_defer_ops
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Thank you!
Allison

> 
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c  | 7 ++++++-
>>   fs/xfs/libxfs/xfs_defer.h  | 4 +++-
>>   fs/xfs/xfs_bmap_item.c     | 2 +-
>>   fs/xfs/xfs_buf.c           | 1 +
>>   fs/xfs/xfs_buf.h           | 1 +
>>   fs/xfs/xfs_extfree_item.c  | 2 +-
>>   fs/xfs/xfs_log_recover.c   | 7 +++++++
>>   fs/xfs/xfs_refcount_item.c | 2 +-
>>   fs/xfs/xfs_rmap_item.c     | 2 +-
>>   9 files changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index eff4a127188e..d1d09b6aca55 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -639,6 +639,7 @@ xfs_defer_ops_capture(
>>   	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
>>   	INIT_LIST_HEAD(&dfc->dfc_list);
>>   	INIT_LIST_HEAD(&dfc->dfc_dfops);
>> +	INIT_LIST_HEAD(&dfc->dfc_buffers);
>>   
>>   	xfs_defer_create_intents(tp);
>>   
>> @@ -690,7 +691,8 @@ int
>>   xfs_defer_ops_capture_and_commit(
>>   	struct xfs_trans		*tp,
>>   	struct xfs_inode		*capture_ip,
>> -	struct list_head		*capture_list)
>> +	struct list_head		*capture_list,
>> +	struct xfs_buf			*bp)
>>   {
>>   	struct xfs_mount		*mp = tp->t_mountp;
>>   	struct xfs_defer_capture	*dfc;
>> @@ -703,6 +705,9 @@ xfs_defer_ops_capture_and_commit(
>>   	if (!dfc)
>>   		return xfs_trans_commit(tp);
>>   
>> +	if (bp && bp->b_transp == tp)
>> +		list_add_tail(&bp->b_delay, &dfc->dfc_buffers);
>> +
>>   	/* Commit the transaction and add the capture structure to the list. */
>>   	error = xfs_trans_commit(tp);
>>   	if (error) {
>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>> index 05472f71fffe..739f70d72fd5 100644
>> --- a/fs/xfs/libxfs/xfs_defer.h
>> +++ b/fs/xfs/libxfs/xfs_defer.h
>> @@ -74,6 +74,7 @@ struct xfs_defer_capture {
>>   
>>   	/* Deferred ops state saved from the transaction. */
>>   	struct list_head	dfc_dfops;
>> +	struct list_head	dfc_buffers;
>>   	unsigned int		dfc_tpflags;
>>   
>>   	/* Block reservations for the data and rt devices. */
>> @@ -95,7 +96,8 @@ struct xfs_defer_capture {
>>    * This doesn't normally happen except log recovery.
>>    */
>>   int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
>> -		struct xfs_inode *capture_ip, struct list_head *capture_list);
>> +		struct xfs_inode *capture_ip, struct list_head *capture_list,
>> +		struct xfs_buf *bp);
>>   void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp,
>>   		struct xfs_inode **captured_ipp);
>>   void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
>> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
>> index 03159970133f..51ba8ee368ca 100644
>> --- a/fs/xfs/xfs_bmap_item.c
>> +++ b/fs/xfs/xfs_bmap_item.c
>> @@ -532,7 +532,7 @@ xfs_bui_item_recover(
>>   	 * Commit transaction, which frees the transaction and saves the inode
>>   	 * for later replay activities.
>>   	 */
>> -	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list);
>> +	error = xfs_defer_ops_capture_and_commit(tp, ip, capture_list, NULL);
>>   	if (error)
>>   		goto err_unlock;
>>   
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 047bd6e3f389..29b4655a0a65 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -233,6 +233,7 @@ _xfs_buf_alloc(
>>   	init_completion(&bp->b_iowait);
>>   	INIT_LIST_HEAD(&bp->b_lru);
>>   	INIT_LIST_HEAD(&bp->b_list);
>> +	INIT_LIST_HEAD(&bp->b_delay);
>>   	INIT_LIST_HEAD(&bp->b_li_list);
>>   	sema_init(&bp->b_sema, 0); /* held, no waiters */
>>   	spin_lock_init(&bp->b_lock);
>> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
>> index 6b0200b8007d..c51445705dc6 100644
>> --- a/fs/xfs/xfs_buf.h
>> +++ b/fs/xfs/xfs_buf.h
>> @@ -151,6 +151,7 @@ struct xfs_buf {
>>   	int			b_io_error;	/* internal IO error state */
>>   	wait_queue_head_t	b_waiters;	/* unpin waiters */
>>   	struct list_head	b_list;
>> +	struct list_head	b_delay;	/* delayed operations list */
>>   	struct xfs_perag	*b_pag;		/* contains rbtree root */
>>   	struct xfs_mount	*b_mount;
>>   	struct xfs_buftarg	*b_target;	/* buffer target (device) */
>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
>> index 3f8a0713573a..046f21338c48 100644
>> --- a/fs/xfs/xfs_extfree_item.c
>> +++ b/fs/xfs/xfs_extfree_item.c
>> @@ -637,7 +637,7 @@ xfs_efi_item_recover(
>>   
>>   	}
>>   
>> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>>   
>>   abort_error:
>>   	xfs_trans_cancel(tp);
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 10562ecbd9ea..6a3c0bb16b69 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -2465,6 +2465,7 @@ xlog_finish_defer_ops(
>>   	struct list_head	*capture_list)
>>   {
>>   	struct xfs_defer_capture *dfc, *next;
>> +	struct xfs_buf		*bp, *bnext;
>>   	struct xfs_trans	*tp;
>>   	struct xfs_inode	*ip;
>>   	int			error = 0;
>> @@ -2489,6 +2490,12 @@ xlog_finish_defer_ops(
>>   			return error;
>>   		}
>>   
>> +		list_for_each_entry_safe(bp, bnext, &dfc->dfc_buffers, b_delay) {
>> +			xfs_trans_bjoin(tp, bp);
>> +			xfs_trans_bhold(tp, bp);
>> +			list_del_init(&bp->b_delay);
>> +		}
>> +
>>   		/*
>>   		 * Transfer to this new transaction all the dfops we captured
>>   		 * from recovering a single intent item.
>> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
>> index 46904b793bd4..a6e7351ca4f9 100644
>> --- a/fs/xfs/xfs_refcount_item.c
>> +++ b/fs/xfs/xfs_refcount_item.c
>> @@ -557,7 +557,7 @@ xfs_cui_item_recover(
>>   	}
>>   
>>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>>   
>>   abort_error:
>>   	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
>> index 5f0695980467..8c70a4af80a9 100644
>> --- a/fs/xfs/xfs_rmap_item.c
>> +++ b/fs/xfs/xfs_rmap_item.c
>> @@ -587,7 +587,7 @@ xfs_rui_item_recover(
>>   	}
>>   
>>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
>> -	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list);
>> +	return xfs_defer_ops_capture_and_commit(tp, NULL, capture_list, NULL);
>>   
>>   abort_error:
>>   	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> 
> 
