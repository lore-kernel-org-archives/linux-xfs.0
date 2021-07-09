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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66B2C07E9C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0EAD613B2
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhGIXmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:42:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12550 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230082AbhGIXl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 19:41:59 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169NUkip005591;
        Fri, 9 Jul 2021 23:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UIpoumUxw/HzqhiohE0jFbLLYzdHyd7aacEhJKtVPfM=;
 b=TH011k3alSUEKTyUBvgWO6XzWXOAuLHTXbGIbSsHlj/18SEZcUBlatGkD6zZwa44n7k+
 tutvbRkQKo3XsQMbxr0Yo/os9kqXSCSf2HyuHDDXWVhe/dTgC/89/Dz+bE9o8Vdy6ljf
 Z+jS+YRey0ggGWz2GzD+iv8ICuqtlMgekoXT/6bhErNNXN9kc/nHAVTx0WuonwXxR4NZ
 A2hs7bX/GB3e4+5WZKtjmyvCJZC5Q/ggb+PIlhJWgO694+IInMtwySsFWcptXdQewgr3
 VZTOrdMDIFx4Y50hDUApBvJG0G8pX1KwN9GiJM4l5zk3FOfs1lXWPS+dB75Iaih40riV hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nphgmk7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:39:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169NUiF0043163;
        Fri, 9 Jul 2021 23:39:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2042.outbound.protection.outlook.com [104.47.56.42])
        by userp3020.oracle.com with ESMTP id 39k1p706eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:39:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNb12ggsr0BPnRuDZgwHAasHkCeiL86haMV/oy74t9t1uqQ9iEr1Hn9TDWs+f4aiKagpIxO3/t8+epGqzZVqKNFyTs/aWq600RoYQCyUFf751dTNgviN3on1HJMwoBt3UpcFrJ31Ekgn+tKXNEtSbExUUjRUzOYrrxkrLUlMdof22WzzeOnKCrNrSR6QH9KnUvyLrdvKPvaz9ypttuRWn19TnaHS5nPn5fnUIR9qMKpw1F6Jjv7ZlGVLpwYnPK2lSqlC+l9YsF5mCA3fZ+WiJv1at2HY1d+rUnAL7ffmZMHz/vZ/d5SOWeuYAjLdGfLXe7LIO3gU14qdi0gibJ0Osw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIpoumUxw/HzqhiohE0jFbLLYzdHyd7aacEhJKtVPfM=;
 b=htC1DvBc0118FeecCDOIMCed5ty5X4IdtoLFWOqTbntsF8AyFMhuSwNGA+RbwAcNG4uU/P30QiC8HAsYQwX90DvUC8ltD8YLX5GeQbboj9Ofp+26RoD/Pm64pGfjzCUib+BVHt4LCJBznwlPcrQtpH9n7zLRQO0DEaQsD4t6u5ByHC26Uj3nTaSPG+scS3sAiLE3QI1Hgr8cZAnKjzncJUI5GaOOO5wlUct2rWHcD2Avi7CVl5T3jMjZ5ILtbzJvVWWiL5j3EpF4aSm9WUvP6YB6ZFZXPTzeYArmvIIh4H0JctcLyeTSXJMwnel5UXA78pH4k4qxOoJqcUM1xMwXyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UIpoumUxw/HzqhiohE0jFbLLYzdHyd7aacEhJKtVPfM=;
 b=ZTbgpAU8xCzDGfY/Te9AJqxM/y6kuVHdENrRR6xE2O0LPJAJaivqUru8oF/E8cMnAq7Yxt4g2J2+HHfg1VsnfeXSEG9N4v7ax3XzhP6a3dxOH6QQleA2jpTOJQlhRvsFsNCu1TX4VVdp1UAuGlI0DBXB3QB8Ra6J//6f2RSBC8o=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5100.namprd10.prod.outlook.com (2603:10b6:610:df::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 23:39:09 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06%5]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 23:39:09 +0000
Subject: Re: [PATCH 3/8] shared/298: fix random deletion when filenames
 contain spaces
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561728342.543423.12599584091972556414.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <32619331-a62c-69f9-f634-990a745e926a@oracle.com>
Date:   Fri, 9 Jul 2021 16:39:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <162561728342.543423.12599584091972556414.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::35) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BY5PR16CA0022.namprd16.prod.outlook.com (2603:10b6:a03:1a0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 23:39:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e86b8747-9d7e-4888-e84b-08d94332bf5a
X-MS-TrafficTypeDiagnostic: CH0PR10MB5100:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5100311A3BBE1A95FABEA86195189@CH0PR10MB5100.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1jRpT9Vp91bZ3+rKX8R/rBghs3NrT9X0tHQjV4PW/4xfEV0uv5EY+1g/aSXO2BLzOj9dIaPCtI07jLHQ4lISWPcdcvJpDstowu9FrdH1m6C2z/qdAaveyHpjl/i2LA+vntvhCv75pI5+3lCxwjDwjxMMzEzGeOp3fCL17nF7ot5xK422i3u3JgodgJ1JA7TttSduiXRHQnLnfWoBEebUJU97jFd71BHFGpgM5hfktkP02HOLAdRkFf72ye2qgwUd5RuS3ObIvLYmMnL4sAMdnRFX58DkeqAmZKxWotnZKPKa7iLon6G4SL9OVZRjUf2pRob7tII7GZVrej+A1C1U7cNm7/M5YC6Xj/m7oi7DXxvx6vUQQXzYEdBkvLjbUREKzSphJ/iJ5RuNs+Sx+36DwMIjiYCWofHXT9KqVv3V+WetJ40miwx4Kj3/8tV7pKYktPOUVWm+ctBHuxiscaKwFjHFdFGkcgR+3zM3skBrSUGncQ2EvF3w/TSHO7nWXXc73vXaLkDtWo5QR79y191+Ux7ojhXvAx5CPeiB6efIa3aFqd5DGE74CtRHGcTpPjuXuTE/h9OZ8uP3PBlgqo9BNgEKkS0cEVddolFpn3sr/GYdPPSz5erpOgRCo+SgonYycBMm3VUG1sHKib46gYw7oJAZW5QWfhjOmnhYUaCKxu9ZUY6Jyjgs5H8E36aMA1vj3vkjn2N/NFhfvQX+CWOnfGHBGX3vbkQkg5BgIG7yM7X+Kl5+YRHF4LS7cMRzRtUfWg/rNtnlrbdhCZUfDNiUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(4744005)(83380400001)(316002)(31696002)(8676002)(44832011)(26005)(186003)(86362001)(16576012)(31686004)(36756003)(52116002)(478600001)(66476007)(66556008)(4326008)(956004)(53546011)(6486002)(2616005)(66946007)(38100700002)(38350700002)(5660300002)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmFhTTRVNFBPVnk0ajhESEpNMEVSZ1Ewd01Jd1E2RDBnSTQ4VjNSakZGajFy?=
 =?utf-8?B?MzVXQ2hwc080K3JFZkxJVEpXaUI1SjF5NjlmNXRtQmdNUVBrUm4xM09XUW96?=
 =?utf-8?B?bCtEWU9hQ014VTNHQnJxR3k2NDc5VEh6K1J5ZXVxN1Vndi8wZ3o0VkNqOXJo?=
 =?utf-8?B?bUtXSFQ0V0ZuTTlWOEtrRjhuRWFNZHJCVk1QODN2QS9OVGhFc3lYMUdZM0ph?=
 =?utf-8?B?WVBnQkpxS3Q4NnNiT2luUk0yKzc0QWUzUXlkZ09QZFI1MVErOXJBOUdNdmN0?=
 =?utf-8?B?MVkxSE9VZFl4MkplUnRMYS9LbERQMk9sWEtxRjVFTUhvUFl5aXh3Uy92TmZC?=
 =?utf-8?B?OWtzQXFRamZnT3JFd3hGa3NqNDNXZi9uRExQMlFKN0NYM05Ia1d3RDNxSXg5?=
 =?utf-8?B?N1Nqd1puR1k4aHdZSmc4V1Y0V1FYNml2T0dBS1R3dys4aHY0eEdEVmdBQ3Bu?=
 =?utf-8?B?NEZycU1XWi9zWWo0WHVFWjZiZ0VwWDNoYmM3UG85ak4zRWFqaGdFMGIvVThB?=
 =?utf-8?B?cHNJYndxeGJhZlJDNXV1M0Yram53YmFvZ1BpTmV4M0RkUXBwR1ZxcEQwcFl4?=
 =?utf-8?B?eWRZSHp1UzE5TkYwVUM3TW5IcE5PUS9zSXZ3V0VuMnNLYmJhM09NUzFMSUpm?=
 =?utf-8?B?S3NCUXBHN1Z6UzlLbGlhQy9tTms5MjFYM1lWd3RVTDJFemF5bU1QVXppT1N1?=
 =?utf-8?B?S0N0cmYwQTVhYjc3NGsyWnNsSDNaTWl1RU1INGozVnNWdlZsd1ptN1NrY0hM?=
 =?utf-8?B?ZkJmL3NUM2FYN1c2VHAxUXlnMHA2NURMYm1kN1U2RHBZVW9LYlZkclJpUUQz?=
 =?utf-8?B?SHU1aUdKNVJ4Tkx3czZFTVIwbFkxL0V1SDFqL0huVjk1dVRkVXJWZ0RtMUV3?=
 =?utf-8?B?T3ZpcWd5d21waUZCeU1tU0lLRTNoWkswQ0czMy9lem9WaEs3bk9ZV0phZmNL?=
 =?utf-8?B?UFBBSWlOdHdYRlcrYkM5MlQwWlpabjlyaVJLT1BtVUFKaDNCRUI4dXA2VDVl?=
 =?utf-8?B?R0lZSUFaT0JOR1V2YUtLdEFHdnhSbmVuNVVTMVc0eG83cVVEZjE2VVljYWoz?=
 =?utf-8?B?TjljOTNkZmd3akxvcXh0U2tWK2ZQQTl0Uit6Ym9MM1MzcEFiLzV3WnpnOTJm?=
 =?utf-8?B?ZW9BYWNFWTBkbmthejFoOUEwWDdtL1dOcDNOV3JncW12cm1samtLeVowbnZ0?=
 =?utf-8?B?SHQ4LzZWaDlzcEtEbzdia2FXS25DTzFoWTNhWFlPdytnMVpraXJDeG1UdE1l?=
 =?utf-8?B?cGpsZ0ozeGJKL2twWXN2dmhrMEVSNm9ZMnJSUGpTUDlIaUlQSGRBR2I2Lzc5?=
 =?utf-8?B?T2cxZXdYVnhsc01ldTdhK2orVGtiQ1lpYTVITzRtSXpFcEhUTnFDZWZ0NThQ?=
 =?utf-8?B?VXBPZVo0b2h1TUo5Nzh6aHRPOFVjdXdlSDVmVHZxSmhYYmJNTXBOTkRWUGJR?=
 =?utf-8?B?aFJoME5pdHBhcytyMnhRdnJpbDM1amIzM3FGdTdnM21OMjFPUERSOEY4ZnpH?=
 =?utf-8?B?R3dLMWQxUVVEMm5Gdy9lQVhVZ0VpWkJpeVNKelcwZnBWVGMxT2JSNExhNDgy?=
 =?utf-8?B?UTJWRDU2MEhIRXBrRUxrck1qSlBCZ3FtTk9DZzVzQWJaODd6cWs0NU1vdDQw?=
 =?utf-8?B?djgwYmpLTWN0QUhSTU5tY3VKNndpMTRnc2N4Vll0YzhvMlRNR0t3Z2NneHFr?=
 =?utf-8?B?ditmN3ZYSEdkNUw2eHBIWk1MR1AySmRZNFdZc0l0c0kzVEJrcVk1Y3F1eGNE?=
 =?utf-8?Q?syb3FtpIE81+gw+ylZjiUQwxWZcQJwsKDcNDbmO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e86b8747-9d7e-4888-e84b-08d94332bf5a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 23:39:08.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9t5Mr2FLWX63zX+tS1KduA03NNArZpZh+7C7ngOsekM4R+UBn/wsZbUXk5Y/i+Eu9QbSLR9fWXTDE2yW4/vXUCrTSN9urwbRnn+0YIkRfFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5100
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107090122
X-Proofpoint-GUID: bqpirM9DNbntmRkKECDByLQuD5ni8chM
X-Proofpoint-ORIG-GUID: bqpirM9DNbntmRkKECDByLQuD5ni8chM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/6/21 5:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Correct the deletion loop in this test to work properly when there are
> files in $here that have spaces in their name.
> 
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/shared/298 |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/tests/shared/298 b/tests/shared/298
> index 981a4dfc..bd52b6a0 100755
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -163,7 +163,7 @@ get_holes $img_file > $fiemap_ref
>   
>   # Delete some files
>   find $loop_mnt -type f -print | $AWK_PROG \
> -	'BEGIN {srand()}; {if(rand() > 0.7) print $1;}' | xargs rm
> +	'BEGIN {srand()}; {if(rand() > 0.7) printf("%s\0", $0);}' | xargs -0 rm
>   echo "done."
>   
>   echo -n "Running fstrim..."
> 
