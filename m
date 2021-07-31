Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC2DC4338F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Jul 2021 05:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F5E560FE7
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Jul 2021 05:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhGaFLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Jul 2021 01:11:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27434 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229478AbhGaFLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Jul 2021 01:11:52 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16V4VwiY022913;
        Sat, 31 Jul 2021 05:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zjGmmEh7aoLCklAoaBuGirMsbdDWk7ekrkfEc+/xDgY=;
 b=YUKGtGVS/Eq8d4lD3nreU1P4iIOQF4AWFxgVazLNyJ9KtfW/vYxykSEN/yxZ6RiWoAoH
 w70+8QIKjMaqcysqMdBnyCnpqeNSjVDWRr25PdQbPpkcFxzeQ9KWO3Rx+/JsSACt/ToN
 xduY37sw3wwddzuEgIHyEVAZ7+T6f1vN2k9Ht5TizAIEx0BB3CuYAbql80FzJvcOZjBg
 vzh7bGxUvC/yR/t7+iUb22Ey1lA3FubggEQ/rVH8Cfoh2YfFp5gAJvgUm9Acc3NeMXRM
 xiKD6wnSfGkXwzP1NTWV9Yn31WEoAZhCBgkRZoV1wWrfmviC2mqORk8R02ZyGwV5waF1 9A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zjGmmEh7aoLCklAoaBuGirMsbdDWk7ekrkfEc+/xDgY=;
 b=lR00TpnQ4CXxulnzNz+zJbdxjZjPL1vchYGPzMEnC9hrhr9/rGjQy3BDIlnNoScZ+8DT
 Bdzr+CnPRRDzh95+RTZow+VjTdpnv4eENJ/VDDAODBqn98/U4264S05/E9DN77mq9RBL
 hvJGvVOF7FXlEmUEDR2kqycdgS7zrFogLxzZmK47yescaeRd8GYRjmvdFuBkSvdHlTNk
 twSsXofX3VisrUWiiiNjcpSqrgP/hOQMhSbHbbBgO++0zBMg5BDQ4PmwCxT8nCwdLU8k
 /V4shjWLH8PUBq7m8aAUExI8tnieZjq38blHHOf7uJpfOAeW7UMt4k+IUi1geK+ScKKY Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4wa2g352-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 05:11:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16V4V6Ar187364;
        Sat, 31 Jul 2021 05:11:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 3a4umtat5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Jul 2021 05:11:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8wIFTjXi6/E3T22Q6ob8Vqsuffe5LFyXf6NZSJqX2UE8WUjo3kvDGBwT5+94hWJC2zU8mKG6ISaVgO6h9+eJnkgzTxhiBPXGmQ0BnU0plhPN6dvZulUTBXgHZpcBJ30RVRB6qV590EG8LhjiMRQiGefjp4wq6K2GAJ141BJtWpQ77uwvoweQFpx1N9ptSDtSl0HjZjHt+wgOhncZGk46RLQW2QPbjZucFB+FJ1fM0ObDURoY160MFpeugbHKEotVIR37ZtqxjbNsSihVB/etaU79OMv9Twd/ohD+yrPY71OSV6+3T0fe1B37/arr3k9ERnCjFUS3snoGEEva9CpkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjGmmEh7aoLCklAoaBuGirMsbdDWk7ekrkfEc+/xDgY=;
 b=aRNSMU5dUFTfCblp8k7mWJQNu4Ib5sO51b0Usoy39C1XlRNOJTYdktlVClOEAfaxYpR2yOXRkmqlnqo5cCuiN6rC4p5G2ueiRwDyb/LKZbBqzqRZVpoQRGYi+j7eeOiXKfGiPKMdxLRPufyAEgb+vsY+93hlKVlXQU6O6nD9HcvSJ6K2L8uavdG/EucY7n03ghftNEwiHJ7YSsVu6eTUUeNu202zDIalKgCog3CMswzDHMNNY1TrBQkn3ngaCGSHGmZRk5IEaOlptHCkkKsbpxo/8R0I3UctecZOPpFD7TMa+UQQmKBHwQg11LQXAwlMD4pynJQ50+gXckBEmrgjnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjGmmEh7aoLCklAoaBuGirMsbdDWk7ekrkfEc+/xDgY=;
 b=T4dl66X0Q7XO3TCXqk7M8O3dNT6W+j5ek5CWb4+yg1C8/kfqj0UG9PgheWVSMW2lq4n8+xG+M8ZT5k5N7XKucY0eokXnsZkx3tAhGXFJkBgRClYlpqUjGMi3TY66YeR9mDvCC84HXjHKME1nzIRfhb7IEwsPIh2XBu41SAD1vaA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (10.255.126.71) by
 SJ0PR10MB5645.namprd10.prod.outlook.com (10.141.18.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.18; Sat, 31 Jul 2021 05:11:39 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 05:11:39 +0000
Subject: Re: [PATCH v22 10/16] RFC xfs: Skip flip flags for delayed attrs
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-11-allison.henderson@oracle.com>
 <20210728191803.GD3601443@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <95b364d5-053a-45cc-1bcb-8a0346b5c324@oracle.com>
Date:   Fri, 30 Jul 2021 22:11:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210728191803.GD3601443@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:a03:334::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.166] (67.1.112.125) by SJ0PR05CA0095.namprd05.prod.outlook.com (2603:10b6:a03:334::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.12 via Frontend Transport; Sat, 31 Jul 2021 05:11:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b69e32a-fa04-413e-25d5-08d953e1ad1b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5645:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB56459360C3F49645E792710A95ED9@SJ0PR10MB5645.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZFb8Gl4oTiR0BGX824eEo6W9gYseNcf7YjeR7+aJRL6DvHheMl/KiT1loNKwhDTgtcrYxo1niqxYH3KBidUTPpW/pucmwbORGZpXMDrCBwj34LbSFMHT9SFymHZme17MPsibACtuCqzU+QtjiaWgY4xLFA8ReTw5+NjS+HRcbsU77bAmQeiB/DX0NDrMp26B/1qclmp4QL1yCuQO8AQFZUBfZvnfDrschUYxBmCyPvBvev85lEtyGHhYrd2GkRRFlxt1rKkQwGmFgxb8RrGg1LiZanLkuuRheTcXaxHe46/V5ngaW1VUi1nI30j7rDpIRhzma+s8jrwdaIJ57+Pvmod3RFXOQKX/7auyZxwd95p0tly3NqPw5T5H/8kktv0ZVuq1Qv+tHncdCW9X7bCbJBe2pRufFSWtW7Izab3R67tVdwfCBT7VBI3aRQtSfKS9fAbSv4eQXU8ooOwmvzm92oou8CnMdmnMazIsLUefB5TehKJe/S0k44m1cVCZRwunrvjlAif+xDo7JcKKYGMWjJ1xh8x8PSDOWa/yAzt6WoLgCFqUD1g2CLgXAwX81M2z2Y3uQhQgDTpzxKJm493eS3JhgchPXx8EYzGLgS/2/YeLFZIUQXE+t174c17LhRKv3owpUwfSUwVi+JjV6ZwSMZy0o26fOuerJ2r9SriLFrx39eUu2qWR8RBIU6SJF1XjzZ/VZaHQGgS/dHDccDJ9LPvrBla+N++yl7FuG42mNlDadhawgqCej9cL80DIEu8n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(2616005)(956004)(186003)(6486002)(38100700002)(38350700002)(8676002)(44832011)(26005)(36756003)(8936002)(31686004)(5660300002)(2906002)(31696002)(52116002)(83380400001)(53546011)(316002)(6916009)(66946007)(478600001)(4326008)(66476007)(66556008)(86362001)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXlpbmNRNkNTaDlIWWh6cXdFUjBvRkZyWXVNdUh4TG52MHZhM2pkUis5N0JM?=
 =?utf-8?B?cWdpUnpZQS9DakIySXdIVEZkTlBsOHJQYll1ZnBpZUtYazNzeUR6TUhGUkJJ?=
 =?utf-8?B?OGtJcmdRVGRhTHdaYTdXZDd1dGdQVmJYS1BjaU9CL1B3VmR2cS9HTURiZEpZ?=
 =?utf-8?B?eXhNQ3RlT05YWXozcjhGTVhSVGVzM2ovaThIWTloZzlNY05ZWDhweHAzejJP?=
 =?utf-8?B?VFN1QmIzUjZYeE8zTDJweHlMYWRNMXV5NWtDMVk0R1NtTXJHL0xCY1JqV05q?=
 =?utf-8?B?WVhEUU4rZzJFQ2JBbWszMUg2SFNxNnZ3amhRUlVRMWk5SWJYdHE5YlNRU1lm?=
 =?utf-8?B?aGpRQW5aa1pyNVZuZFh2OXRQTEVPS1ZZMTlDM2drb1hnU3pPVUxPRjYxaS9z?=
 =?utf-8?B?Ty9UK0pEeGwrMHh0UE4wa09QV0FEN01NSGJvekl4d0FLOW5YUS80TGJxcXV2?=
 =?utf-8?B?eUM0bXBFTnpkSWgrWmFGNTZKaklKRE5lSkROeE5oUmJzeEl1MzQzWk0rZUtq?=
 =?utf-8?B?Y3o1RU53K0lnYkFWekdqajFxaGlwdW81UitpOE5BNDJwM0VnTUZ5SDY1OEp3?=
 =?utf-8?B?YjA4cEJXNXVOZlpwSWNNek11TXJHM3dadFFycDN0aTVhSlkrdjBRTGR2S3VV?=
 =?utf-8?B?VkdYR1lNVHgwZ0krY1VRQW96WG5Rc2ExbDZGNlp0RnFtcGlJL1k1OXFEY0tY?=
 =?utf-8?B?Uk5iK1BweHlSZFJJdzRVcU1vaDY3c1NDNUR3eGxoeUYwcFU0VnlSSjlCY29U?=
 =?utf-8?B?SGYrdk00dVg2aUJ4UTkyUTdGc0E5MGFNS2dxMHdoSU5jTWRjdjRwVTJ3d1Bj?=
 =?utf-8?B?cllzUWR6Ym82NHA4RUpicFNoaXFjZy95QUhOakpaQ0MreUsrWVZpMVZVV3Bv?=
 =?utf-8?B?eFJGTVg3S2lhZGZMd0ZzWHZvbTJDYVgxdWFSWlVHblQvb0o2SDQzcTY2U3oz?=
 =?utf-8?B?T3dPblZDb1lvNXUxaS83ZGI5bGMxM2lDS2pSOSs1RzdIYUxMMGpYcmt2VkVn?=
 =?utf-8?B?aDY1eVVicDRQWENyVk9hT21md09OYk9pYkx2NXVrYXNiQldNYnZSRnVFTlJt?=
 =?utf-8?B?dFdtSWg1RkJOZUlLSnZpY2dEbkdpTmw0L2lEWjdqVEhkeGtLd0NTdHNINTdm?=
 =?utf-8?B?YmpLS3VrTlVBdlRhYjV2S0x4d0lVUEp6VVJsNDkyTHAvRkk2UCsxaU4rOGpY?=
 =?utf-8?B?Ty8xSFBQbUFqQ0J1V1B0RUVGbWlZQUphSWo4Z2djSVRRREh4TWM1MzRjVnVn?=
 =?utf-8?B?ZHdXZUlKakd4RUNoR3pkVTNMS0oxWkx3bGptaTdTcm52YTNYbGF5YldzVllu?=
 =?utf-8?B?NGpZQVFIdGE2ZnZEemJ2UlBONHplOWQvdmtkeGdvT1NmdVVuNWt3OFVKK3JX?=
 =?utf-8?B?UTJmcEp1NGV4SU9ESVlIYlhjL0xLeHZyRThRc2dsWlRzbEFML3lxTlRvbm9S?=
 =?utf-8?B?Z0tqUGhrOC9tN3RWeGh1azN0ekg2RHpETlVuVG5ueGM5c295TFhOR2lxQW9K?=
 =?utf-8?B?ZkJtdzZJQ0JieGllUmhHVXh2MXcxZ0lib0JRK1g5TTZSSWZ2M1orVmNpR3F6?=
 =?utf-8?B?aytQZVIwcmczM2c4Q216VTZxRmFuQXRGVHg3ME1QdUpkek04enBuaWF5RDYv?=
 =?utf-8?B?TDdoeFJLdmhFMkVYdnJLTjJlcEdqMXNCeTlGaktSRWhKWjNQTmdqek1DL3FZ?=
 =?utf-8?B?OW9SSDV2OVArSkJSUGhjRW5MNmJJTE03L0J5S0RUNkxlcktSNjlHWjlkOGdF?=
 =?utf-8?Q?pS3eTbvhbo0nW1WHw1gOJWdcLgw5fhc50MD0TKL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b69e32a-fa04-413e-25d5-08d953e1ad1b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 05:11:38.8880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gA4RyNG5ocUzV0REPSwVpvWDrW4P1Eih0c4lVGSaP1gThdv0FutlwtSISbuC+xTOPJXqu7fPaJwZjylxmlUTCB/2zCgM7BiCFX0dR2idQ/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5645
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10061 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107310023
X-Proofpoint-GUID: wVceWJmL419dE33ITuN7YV6l97DT5unR
X-Proofpoint-ORIG-GUID: wVceWJmL419dE33ITuN7YV6l97DT5unR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/21 12:18 PM, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 11:20:47PM -0700, Allison Henderson wrote:
>> This is a clean up patch that skips the flip flag logic for delayed attr
>> renames.  Since the log replay keeps the inode locked, we do not need to
>> worry about race windows with attr lookups.  So we can skip over
>> flipping the flag and the extra transaction roll for it
>>
>> RFC: In the last review, folks asked for some performance analysis, so I
>> did a few perf captures with and with out this patch.  What I found was
>> that there wasnt very much difference at all between having the patch or
>> not having it.  Of the time we do spend in the affected code, the
>> percentage is small.  Most of the time we spend about %0.03 of the time
>> in this function, with or with out the patch.  Occasionally we get a
>> 0.02%, though not often.  So I think this starts to challenge needing
>> this patch at all. This patch was requested some number of reviews ago,
>> be perhaps in light of the findings, it may no longer be of interest.
>>
>>       0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter
>>
>> Keep it or drop it?
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> /me hates it when he notices things after review... :/
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>>   2 files changed, 32 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 11d8081..eee219c6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -355,6 +355,7 @@ xfs_attr_set_iter(
>>   	struct xfs_inode		*dp = args->dp;
>>   	struct xfs_buf			*bp = NULL;
>>   	int				forkoff, error = 0;
>> +	struct xfs_mount		*mp = args->dp->i_mount;
>>   
>>   	/* State machine switch */
>>   	switch (dac->dela_state) {
>> @@ -476,16 +477,21 @@ xfs_attr_set_iter(
>>   		 * In a separate transaction, set the incomplete flag on the
>>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>>   		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> -		 */
>> -		dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>> -		return -EAGAIN;
>> +		if (!xfs_hasdelattr(mp)) {
> 
> More nitpicking: this should be gated directly on the log incompat
> feature check, not the LARP knob...
I think they're equivelent functionally right now.  Looking forward, if 
we assume that the knob will one day disappear, it might be a good idea 
to leave it wrapping any code that would disappear along with it.  Just 
as a sort of reminder to clean it out.

So for example, if we ever decide that delayed attrs are just alway on, 
this whole chunk could just go away with it.  OTOTH, if there is an 
internal need to run attrs without the logging, it would make sense to 
check the feature bit here, as this code would still be needed even when 
the knob is gone.

So i guess this is a question of what we think we will need in the future?

> 
> 		if (!xfs_sb_version_haslogxattrs(&mp->m_sb)) {
> 
>> +			error = xfs_attr3_leaf_flipflags(args);
>> +			if (error)
>> +				return error;
>> +			/*
>> +			 * Commit the flag value change and start the next trans
>> +			 * in series.
>> +			 */
>> +			dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>>   	case XFS_DAS_FLIP_LFLAG:
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing a
>> @@ -587,17 +593,21 @@ xfs_attr_set_iter(
>>   		 * In a separate transaction, set the incomplete flag on the
>>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>>   		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			goto out;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series
>> -		 */
>> -		dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>> -		return -EAGAIN;
>> +		if (!xfs_hasdelattr(mp)) {
> 
> ...and here...
> 
>> +			error = xfs_attr3_leaf_flipflags(args);
>> +			if (error)
>> +				goto out;
>> +			/*
>> +			 * Commit the flag value change and start the next trans
>> +			 * in series
>> +			 */
>> +			dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>> +			return -EAGAIN;
>> +		}
>>   
>> +		/* fallthrough */
>>   	case XFS_DAS_FLIP_NFLAG:
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing a
>> @@ -1241,7 +1251,6 @@ xfs_attr_node_addname_clear_incomplete(
>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>   	 * flag means that we will find the "old" attr, not the "new" one.
>>   	 */
>> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;
> 
> Why is this removed from the query arguments?  If we're going to skip
> the INCOMPLETE flag dance, I would have thought that you'd change the
> XFS_DAS_CLR_FLAG case to omit xfs_attr_node_addname_clear_incomplete if
> the logged xattr feature is set?
> 
>>   	state = xfs_da_state_alloc(args);
>>   	state->inleaf = 0;
>>   	error = xfs_da3_node_lookup_int(state, &retval);
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index b910bd2..a9116ee 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -1482,7 +1482,8 @@ xfs_attr3_leaf_add_work(
>>   	if (tmp)
>>   		entry->flags |= XFS_ATTR_LOCAL;
>>   	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		entry->flags |= XFS_ATTR_INCOMPLETE;
>> +		if (!xfs_hasdelattr(mp))
> 
> Same change here as above.
> 
> --D
> 
>> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>>   		if ((args->blkno2 == args->blkno) &&
>>   		    (args->index2 <= args->index)) {
>>   			args->index2++;
>> -- 
>> 2.7.4
>>
