Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094BDC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C481B64E6B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhBWUTt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:19:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44684 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhBWUT0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:19:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKESvu042730;
        Tue, 23 Feb 2021 20:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xMl6ybtpm17hsOWkoo7I5vmUZC/TYwyGnlzVdvhkVZc=;
 b=zn5+A5OPrNGRxAyLV0N4r6TwN08eIGqvK8iGIGqOKQUtCqnXaaNhL+L4CA/+iR0V4DuB
 s01kt8KnY/aw2a1IKtw/zhTu8Zc3JfoVyXVF5++ll3qByO/Da9ifS9PG2gA6LSUNcZ3r
 y9RMTeLvis1fEyDl2uu8Mb1Bji8LXtrpgsle5O9hDx26KfSZKHOjGuIt4nLxDpMpwGni
 u6i0yNyQWZBvf2J7iReSfsZ4O3kKZchKs8xlZtqc++O6hXIksx6F1yFqDiQC/20nmNvd
 7t8hYTRCLC01QPZp3SMkHxm2Au9OjY+wSXY1CQ4+7z+KaVO8LPHdata/7wNsyaj/vBnY CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36ugq3fk98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKAQ7S185703;
        Tue, 23 Feb 2021 20:18:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 36v9m52y25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNuNkn06+9EqDJWfecsJ4n0deQFwiW0ODi8gv3NeYANHL6iTNBG1e4ljDNGxVZ+OLjOUhWdDJNpRY1kFvMI8G0kzeJTONU1m8gTshhVLpy0BcYYyBCQ0P1DDfFBPypbJYaHa1BRgZRym5xqx8OgGnK53GfGTqjzA8MfPbNVSC8yH3AyvsSdL+abBgKcqXPQ4Mpv1mee44yW15W2CBkRLGEh4ctRQzS0lRCKZGDjA5dXld5bl8M4xl47rBay4KMbd/oQQkAw+205dAe4BqAf8iUbGqIpNUnfqu+5bjg9+g77O7cO/4M63/Wmdtwq+KbeglqvkQnZe2m3CrlbcPpvdqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMl6ybtpm17hsOWkoo7I5vmUZC/TYwyGnlzVdvhkVZc=;
 b=HM57FDziGLJ/1HFh6J3sxGmjKQvQSjSwvQXaFLniqQaOsVUaS9ioYhFiDuup8FtaTJAV3Qkb9WEzwbl7B6F6AhcggNTEfYDrS5szIl8WR7S6tBRA09v/CRBdyWs6sOc8b6lJvBirwC3S5GRbFW+3IJq9nKjOqyg1Rd6qygStMBkec6/1Wa33YYjwrjx4ycRJb+l/UOSYrXvhOc5IKXluiYI5og/KdJBn2mqEMVOIZWh8i1mVEvAT5ou4I+JTcua6fHaI965Lc628gICYFbc1T9ieKf9gnb3HJ9G7B3m+0/lA5HJTK+4sCjDvXu2MCv8sBQb0JZxTWQSq3pQq80gJrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMl6ybtpm17hsOWkoo7I5vmUZC/TYwyGnlzVdvhkVZc=;
 b=sDBM6aAIa1zbpaCYKJjB2B0tK5EcwR2gL/XfY6tJjpQ4V7dKZmrRh+LELnj5gvmQiYU5g7o1zMBUVpF3+5hgoPUU0FeIllKV/78WhpLBw3x03hAxpYNuui/2P9sq4qSMWeJjGmaPOKlgPdB5aXwLgPxWBQSoddMv9KRk+4Vygnc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH2PR10MB3782.namprd10.prod.outlook.com (2603:10b6:610:10::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 20:18:38 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:18:38 +0000
Subject: Re: [PATCH 3/7] xfs_db: report the needsrepair flag in check and
 version commands
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404923555.425352.13688646688421406378.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <adc4c051-0534-4da7-406e-592f87027aad@oracle.com>
Date:   Tue, 23 Feb 2021 13:18:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404923555.425352.13688646688421406378.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR03CA0016.namprd03.prod.outlook.com (2603:10b6:a03:1e0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 20:18:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cda3074-1d73-4d5b-a33a-08d8d8383459
X-MS-TrafficTypeDiagnostic: CH2PR10MB3782:
X-Microsoft-Antispam-PRVS: <CH2PR10MB37823AEF663577B3A7E6E6A995809@CH2PR10MB3782.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:224;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEYZWD0htoEAddrwg5mwl5BCmBYlpPaZX5rwlPqsGbYQ0Xn63cC4LFcAtW/paIVmS4Bvy09lKlYZgHMPdgprhQMiKZv1p5jSERM7A+GAWfgrJmldDkVY+trYlgfTw9Mp0/Jt0/2jhFXItcWh0XSHH7q0CP6bGbAc3x3+oHOTBZNWs6MSO6QR42xqN+JwKwVKi8atrx8cqlcGBuqiiseAwMxbdYpRFVTpuhfg2XxBe9L+srblij8m95GKW/1Ctaj7sc8dejM+YsvD7IZBFcIhd07L1KZFrQa3C/F0KL5ouLjtMWqQ5UqEukZOtzxrKX7ypc4wysQRS6iZc7lnLrUSNZHAUDnnm82bnTlMBbAhZ+6+M5e0Q6VUgJHIBeEcy//SFCP55ZVRdaSynnUU1ezYLbXOQugwMJq6x8SlQQem8l/nLfr+vqGBMJw032qGnlFqnCADrTef4IDiI81VRhX8V9xrW8br4KiQgQg3tU//J3CeDOmN8I6zgcbPX+GeH5rz0Z831rPJugsO9drQOiLpESVMSLKaV/96uj+UPKT6DEBKx811HGxFXLF/6CTOUDx181a4P1am56MEFA7D6e862xc7/ykOdNp6b/9z5z3QOR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39860400002)(366004)(396003)(478600001)(2906002)(31686004)(26005)(186003)(4326008)(31696002)(5660300002)(66556008)(66476007)(83380400001)(16526019)(66946007)(36756003)(16576012)(316002)(86362001)(8676002)(8936002)(52116002)(2616005)(44832011)(6486002)(53546011)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d0owck5hWFhWUUxjanJ1NEJWTXRJc0dmcTk0SkJjbXkveHR4Tk5KaUJZR1hk?=
 =?utf-8?B?c0l3cXNGSW1idW10THZwZ2dYU3h5bGVRKzJlblk5ZnFCbitwR2JuTjZmOEE0?=
 =?utf-8?B?azJWS2pWUkhFeXV2cXZqSUF6UVM1M2FuRVdSWXBiWUFGSUVCYzlGbHg4MkVC?=
 =?utf-8?B?VGZBK0JFaVNSVElCRWtaV3dLMmZzZDNuMkczbjUzQ0ZHUTlYZzV5bmVnRnhV?=
 =?utf-8?B?bS9KeEdCdC8zSXhjdUJhRFZENFhyMndZMml1Q3QvSENOek1LcGNidlVEWXFM?=
 =?utf-8?B?V2pHWUlSVkRQQmZnWlNDUWQyMnh2eTk4VmE4STEwamxaQi8xWUVVN1BpeThW?=
 =?utf-8?B?VnFPYnJuNTYyUVJRY3haaUFBaGQvWGhDMVdIL1dRNTJYKy9IMlljdWxNWUtn?=
 =?utf-8?B?TlFtQU1IUTZtUEI4bDFFcmo0SDllV3RlNGlSY1pJR1c1emx1aUN0bHNaTHdP?=
 =?utf-8?B?eWw2WVlSYkEwVWhIU1o3bXFWNmdQM1Q5YytCRkpXYnZ5VmpTSlU0TzhRSjlp?=
 =?utf-8?B?aWFOc2wxNzRaOFY0RFNhanE1VjhvQndHdllaL0Q3Y2FHWUdpblEzamdUa1Nl?=
 =?utf-8?B?aVBPZnBFeUQxaFk5R01nUll6SS8xUG9IaVRwc2ljSitCWCtMeDQ5VnlTV3Rx?=
 =?utf-8?B?OTVjYVFhdTJZZmdhemttUDB1OHlzUUxGTmVHUEt1MGw4Ry9aS2xXL2ZKMnIx?=
 =?utf-8?B?bWhWQXJvMmIydVFjNUhDM21CUDA4S1EvcEY3a0hyNVdpTktSajMvamJQaUE0?=
 =?utf-8?B?MXI3azZROC9kTVJRczRWemFONlJDaktBd3BrMENsVHR1WkxPeXRYT2x4RTRl?=
 =?utf-8?B?b3ZQcS94ZjBGVDlGVTl2M0h4ZTBUZTNua1R5WThZL3VuWFYrdTYrTU1jZ0NF?=
 =?utf-8?B?S2dJazRJUDJ1WjEvbWw3ZCtDSEhhak9DcTNFL1RaTHRxUE5DeWpTUHZZUGcy?=
 =?utf-8?B?dndMS1JENTZYaEJCeWk5dXRPVkZOc1Y1RHUrbkVhRXlFbCsvU05VTHdUS1VP?=
 =?utf-8?B?clRjOW5CWEtITGpOcFZSOFNEMWVRQklNTk1QOUtjVXVSb3F6WFVQcS9kelNJ?=
 =?utf-8?B?RUsvVnJTai8xMjRpRkdOTVVpNDRvNDA2NmtzNU1qdnMvU2tJQkFIUlRuOTZ4?=
 =?utf-8?B?OHkyQ0lpeVg5bXM1Q1NCbjMwM2lpYkFsQW5ON2grRlp1bmYzdDF4cFl2WmRD?=
 =?utf-8?B?a2czQUNsQlVJOXZiQ3VJMW9zeVRrVktoZUsyc2RyN2dqak4zelladHVJZEpm?=
 =?utf-8?B?Tk1WNjc3clRXeFhaamkzcWlNd1RxYWlXUEJSZEJhbU9rMVR1TXlWWmJTTmFN?=
 =?utf-8?B?K0VBK083aWdLRlJUWjM2VU5rV0tlLzBnZkVEaHdnTi84QkV4eVFGWktzcEJE?=
 =?utf-8?B?c2pPSHpINWVscmpjTjZRQTE2MC82cmRlVGhpcFEyREt2STI5M3VyZUN0RHBG?=
 =?utf-8?B?dTBPMmp1bklSSjJmaFJ1cWs2ejJrV0tsbTF2OGo5OGs1d0dWM1hhb0h2ekdI?=
 =?utf-8?B?N09XVGRudmZ3UlNaMUVPK0F2ZkR1Mlg4SDlaR0p3ZmF4NTRXVWx5ZEZDeUVX?=
 =?utf-8?B?TTJvNmV2QUZJVmpIK2hUMU5rYms2cHgwbVZjdElXMU0wdTM5ZDJYVDFRV1da?=
 =?utf-8?B?eWViclpUYzZhM0J1QWNSakgwbk1RU1VHQjhoa1hGNndMOUlXMnhSSDBLakhO?=
 =?utf-8?B?aUVCYmNpNVhQNmxZUlhUVFhVMUxvdmwxRXRYQUZYcEJXa0R0eWRLZDY3dEJP?=
 =?utf-8?Q?uC/CQtMZkMEkNVl01DYiNCNJQJten0bTD4/zGLA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cda3074-1d73-4d5b-a33a-08d8d8383459
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:18:38.3193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x4fbslbgl2QAiR+0jQH0w9IqppUIilYU1khMPB8QwR4HpTiIQ2aBgwL1XECLNSfDiaaK2x+G5IPd8uzeB4IoHYWSsdiLCjoSviBrSEiMK3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3782
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:00 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the version and check commands to report the presence of the
> NEEDSREPAIR flag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   db/check.c |    5 +++++
>   db/sb.c    |    2 ++
>   2 files changed, 7 insertions(+)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 33736e33..485e855e 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -3970,6 +3970,11 @@ scan_ag(
>   			dbprintf(_("mkfs not completed successfully\n"));
>   		error++;
>   	}
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		if (!sflag)
> +			dbprintf(_("filesystem needs xfs_repair\n"));
> +		error++;
> +	}
>   	set_dbmap(agno, XFS_SB_BLOCK(mp), 1, DBM_SB, agno, XFS_SB_BLOCK(mp));
>   	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) == agno)
>   		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
> diff --git a/db/sb.c b/db/sb.c
> index d09f653d..d7111e92 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -691,6 +691,8 @@ version_string(
>   		strcat(s, ",INOBTCNT");
>   	if (xfs_sb_version_hasbigtime(sbp))
>   		strcat(s, ",BIGTIME");
> +	if (xfs_sb_version_needsrepair(sbp))
> +		strcat(s, ",NEEDSREPAIR");
>   	return s;
>   }
>   
> 
