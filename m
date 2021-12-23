Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D8DC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Dec 2021 06:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbhLWGGi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Dec 2021 01:06:38 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63230 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346536AbhLWGGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Dec 2021 01:06:36 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN19Uu7017364;
        Thu, 23 Dec 2021 06:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=csjRRDf6mUWF8M1Lxa1rmCjxoPZ8BS0WGgfCoLP6vJw=;
 b=D3PjeM8/dp8taJfHbTtMZszccHVAA+5AnMlM4uLVMZ/U7OMH2X+QSSQRVibfeWsCcN+e
 qSXp1IuwzTVhXMt90FkkZQ8GHNRIlaXCK5DW/xbXOAhecH49tpLkmY73twj43ZmPUVac
 mKtvLpukqxI+e1Yl2qYq+SdkUwXjsnwXq6485uoJpOSvUXCxQ7ldDIb95U1HrIZYQVc4
 vfL5XSdgsoEfSXAkDXdYH+T7PPNUxhOHhd7VNmMR4/+62I4YXY6WOmS6eKMqoIUgpmqR
 UFILQ2WVvKmCZsGP948fkolzC7QbLpl7cE8e/yYiEB0wSXuSZtNteA/ahJO7ud/fMIgw sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d4f6w0ar1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 06:06:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN6155N188407;
        Thu, 23 Dec 2021 06:06:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 3d14ryj3t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 06:06:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hfn43ZLjC7P0+GcRLwAdHuFtFkdYOwZUnOIMelBsY0or2/j5pQqi/xnGGsjV/yWZPmQf9oBRZt3IRgixoIbZa9A80yYezsm1C2q80uTBAcQEzaGjNEpkXeY01J4FKyFKkaZs9C6VHCzNDwxN7Rp4w3QPPUXFEarTGsF7lgsIBfwnbpaApXhX7nL5CAc6FGF7j9OYOFm8HcOiAMvwdHBWpogUeTjWijjz6sAlxNCrA/7jZfchvvNmJu2Z/hGygpMHHxckjMs98NE1AJoZVv6DGZMAhAFeA1puCR2hMRtVCfwIEd/CajjfB0PX8Vx0OjQxJwTonP7KqpwJt1DGdcJ7Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csjRRDf6mUWF8M1Lxa1rmCjxoPZ8BS0WGgfCoLP6vJw=;
 b=DNVdq9Bs1lX+F7ruA56yhxLsRojE/bkEh18hjoEjRo1GY+xSq1EJcH0/MZS7bXnXwanQErVEeERLzANyzGwafYg2WDSek1bnxR4LRW5SDoohcKyXgeq0P6GGrPQNpHEjaCSAnsAYiJeYTq4+6U5SjgF01HEEhg0NGomfcljGDw9CVKA40trEZmPAjmTGd04HW7uxcg/AnChvpEjyBn80wbcXDl/j4GddliY692cavPc5Kf+5+bdkxXj4GA/o6zB4ejKqJnr3ccGBH39NHcFjxjzUeNE8xdiGzMRLdzBZF5UesxFVrjGiw1MNgCg/odMfPzJtuk8ooxjSWvS2B+xN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csjRRDf6mUWF8M1Lxa1rmCjxoPZ8BS0WGgfCoLP6vJw=;
 b=IjZCnuPgjrl/e7lLtkJwv679jVHej+C3YgpSNXElfEAxfyVFOrPIh/NOmM5WdJGIVdaO7zg7QqxktTlXRvC2gY8VKO4753XFiWbPXBLDMqUl+FpR4G6Ud5J+3eaiSB5WKEmuZsFhuaISvSS8cfk+YDF3Wdbb46xKfip0dLzCrdM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 06:06:30 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%5]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 06:06:29 +0000
References: <20211110015820.GX24307@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH] design: fix computation of buffer log item bitmap size
In-reply-to: <20211110015820.GX24307@magnolia>
Message-ID: <87o857rh2g.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 23 Dec 2021 11:36:15 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0601CA0021.apcprd06.prod.outlook.com (2603:1096:3::31)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bdf178b-3574-46fa-6b18-08d9c5da5c37
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB47484D32F706DEAEA56B70D7F67E9@SA2PR10MB4748.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zj7IiRjWpKjIyoCEG2yVDnXoRdMX9xM7pVe44a7/2Sfnoplj6UHIJ0ZPzaAl2A9te2KR6IxCZJuons8GYdK1RKbbHayL+iO35S6Pp2NHBoaDqQZWLDloISWJPhER8zK8YnzvGGdiIjR4V/BktoyGE8XGhoYHR40gbUP39rFgRiY0Iguet3yG97vk3Gx3uCTjiKRibMfZANi7g0U8JxLp9IE0we484uqAnixHAKCkD/65/87eykEuEqjh4XtnB+PrEbSQRpuunm36wO5GSvoDHoY371bhazEd8mSCSxHGHxwPeVpiFbflRp+CggAppRrJZ4t/An//XiHQODR3gfG/3DUshdHxbU6VJxuQzMqkyjVmXEQvsJklQHaoFvjIaK16yb0uWP0eGKjv569ndACZxv3RpCVnCN8QybTyQThnA7tn4RjKgJqSScECc/UhrW4dpAPKH3+xEMR8t32/s892w995rflLBtI3ByqeMw7PrV8JRoeLCRW4/Pc/DtNCEFij+VOTLa9xRFO4l3EnqQhoSeOGEcZrmFlf/VjaJZ6KLEMTHW5G15mGkuUUnoVZ/neZ5kHGlGoAwlRicp/0F6SVzVC/hPfcO8eEyVywHveuPb0gRwt9766rEhKNzqxVjcE8GboNtYxX75QD4OAIZowXzTATX8aiXVWb9F+NfiepfzaVeEwwst3QbnRG+b0DkrrfLzaVl8Ngf1DgecayLjGbaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(107886003)(316002)(186003)(38100700002)(6666004)(83380400001)(54906003)(508600001)(53546011)(2906002)(5660300002)(38350700002)(6506007)(4326008)(86362001)(6486002)(66556008)(66476007)(52116002)(8936002)(66946007)(6916009)(33716001)(9686003)(8676002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Gn/h6nCX4vlEzFuwGbzysMnbgr3YN3Yo+ma4OunFVRGM4TvNU5kihScTE4D?=
 =?us-ascii?Q?50DsCbXFfZAXXxHAXSeaMLqZThmS+RREpbRbN0glKEExnrm+aMguE91UEiKu?=
 =?us-ascii?Q?ZmwP6l45Ha3/qUMf6/5EMy5OkWZiLMBy5M+99x9QxqABoau38ZZs7uz6R7dq?=
 =?us-ascii?Q?tDEB3VTh/q6kqi7vNNmoiydCRmPfS4SbMIra1M/kSV8cZM5Xr8mc68DU9XHW?=
 =?us-ascii?Q?GBrhP69Ovrm3ycCvwWFMnL+4Xn07GgpaLaal9Xhq9Pmrvns+d7+4etlI9QXq?=
 =?us-ascii?Q?0xPbwdqpfKwPdwGBDTJF3LPwG10gPWz34QxGKjQrYysbHUQNlRVrNVTupXc5?=
 =?us-ascii?Q?AFaoav2aExAcGlZMzQFS9Vh6/GBPfQB+/j7fD44F+c2vq0mvy70nxZ387f6f?=
 =?us-ascii?Q?nbnguMN1XBBk4BxQ7U3aNUb940eWzTPiHzskVmIrZcFaPOEY/f9gpHyFqD6j?=
 =?us-ascii?Q?hBBdHl2ZVUkqTolWMgNgSb4riEXFQcyQxK3wiRtV2w4KwtoO9T4w/r5XeFxi?=
 =?us-ascii?Q?ADwrNxpsLPvOD+khFuawWyO0fy/mvQMxFuKohUUaL1weQNCtClITpEPbtxAn?=
 =?us-ascii?Q?ZaDhK0ACYCZE++j3URzaTb3TWGLEP4ilbRO1uqFSLP1izHCb2+jY3Ez2jR1L?=
 =?us-ascii?Q?hdSfFxGQZlJ44RcwxgdWBxQotWfrm4FKGQYWqzkBJFrq0kBeZyGtA5tu8u/J?=
 =?us-ascii?Q?ELD5uZHoEKBTGrLShQCTOSrXiBl7djv2CaQeKHFGOFbEcvRZDnKvQ2p21TPE?=
 =?us-ascii?Q?2rDTWBBTEx86Ai9iLBjfbTGu7Jb91DRXcS5eDfsWNEsk6zjndgEckuQegm6i?=
 =?us-ascii?Q?p3NjsaORw7MjLPCG/7XQNCJJaJ29DEvUZ9Rs4svMxUQrnKoxe4G/e97ipkcb?=
 =?us-ascii?Q?yr6MbaYY+TiR/F0luiUuRVaolE5Sgx6yrkpbjmATExkXJXKX0NRcZ/pcBS6w?=
 =?us-ascii?Q?y1572jAyfGbXvWRDUI8LFWcIpaffW94dkrlYyGlX+GpL48yYxIBOCnFuJpWM?=
 =?us-ascii?Q?gBYR9jRPeUPu+KK01SwTsShSLKNVUsPVo8RXU2K/DZubbJpIS/fGE6CpvbbK?=
 =?us-ascii?Q?0RbgGPjHsUkvLYZrSgnccKjQb2tI0xBRKVOZEiimbtaYyPU15Mb2f2slgYkO?=
 =?us-ascii?Q?HfK72zjZZGJDL3pydRw7G9XYKCfmDG+5EuqK8kAJwH8qO9UwRYDZy1RTwPk7?=
 =?us-ascii?Q?UzIIzYJ+MQaHf5rPXWa2ueCciQyu9L0whdhiK6kEji1C4w+rF6sa6bCdvgVT?=
 =?us-ascii?Q?tisS+aKTuZHRq6fpyXvDgf50ecQyLFq56wKn1pjrO87vFtB9RY6sC6vFZcGc?=
 =?us-ascii?Q?eWwBmU5vyjXW9mlsXQfCjJ2hASyDmlBhOUnr12m9VxYJGDy9i44VxYa7nw+d?=
 =?us-ascii?Q?KFE/qKWjE7ySb+yXA66aP14Jd1E2dtjm5Apae8Sa5ZXZ5TGTrGq5uuEUv8hU?=
 =?us-ascii?Q?dmyVPG44jJEOWIDDtftShDDV1GeI1qLjtMCKsWyLIhNDtS45WHc/vHDfEbXg?=
 =?us-ascii?Q?1GF4UbyYn1YjV77e1Winnkx2/143NFqfCnrLHx+xsjzRO/AX2PB5PxABaP8h?=
 =?us-ascii?Q?S4n4F9X1tyaCzKJOBFySQtiDoAYd/a9aLVlfg7Rca+sDf8I6baG0poNYx3YP?=
 =?us-ascii?Q?VMRVnNBU9ist7qdE4kmp8Sg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdf178b-3574-46fa-6b18-08d9c5da5c37
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 06:06:29.8348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OssUwF5B9J/UnPre0ONUQwBvdMT8XSVG3CKKrpq691+KbDWGsU5jXs06qnhxWCVwISSRkHRj17FR65U1wKL37w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112230033
X-Proofpoint-GUID: QqMC0Rh8sncYijo4IJOC71o1AdmhnsBG
X-Proofpoint-ORIG-GUID: QqMC0Rh8sncYijo4IJOC71o1AdmhnsBG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10 Nov 2021 at 07:28, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Wengang Wang was trying to work through a buffer log item by consulting
> the ondisk format documentation, and was confused by the formula given
> in section 14.3.14 regarding the size of blf_data_map, aka the dirty
> bitmap for buffer log items.  We noticed that the documentation doesn't
> match what the kernel actually does, so let's fix this.
>
> Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  .../journaling_log.asciidoc                        |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> index 1dba56e..894d3e5 100644
> --- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> +++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> @@ -992,7 +992,7 @@ The size of +blf_data_map+, in 32-bit words.
>  This variable-sized array acts as a dirty bitmap for the logged buffer.  Each
>  1 bit represents a dirty region in the buffer, and each run of 1 bits
>  corresponds to a subsequent log item containing the new contents of the buffer
> -area.  Each bit represents +(blf_len * 512) / (blf_map_size * NBBY)+ bytes.
> +area.  Each bit represents +(blf_len * 512) / (blf_map_size * sizeof(unsigned int) * NBBY)+ bytes.
>  
>  [[Buffer_Data_Log_Item]]
>  === Buffer Data Log Item

The calculation looks correct. However, wouldn't it be better to mention,

"Each bit represents XFS_BLF_CHUNK (i.e. 128) bytes"

... or some such variant involving XFS_BLF_CHUNK.

-- 
chandan
