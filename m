Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB566C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 11:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiEPLB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 07:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242196AbiEPLBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 07:01:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DE138B9
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 04:01:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G8lX8i007628;
        Mon, 16 May 2022 11:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QgfFmy2ecEA1o6NQoh4I2DSvosecT4lhtTotPzOnab4=;
 b=EX67BHB8ckmII/7W78ILLVc7et0rVjMU09QPeeZGYYinsPa0bIraHVNtDkilJQyB0H1a
 4tdc1BYBPXUq0Mn4WiuZQ6SXei+gAWJUXiosi63n/Xgx2KCqf4eOcS9vMMDddD3Jdw6I
 gqAr/v3QSpEKLtwd+8rdXpZsXEztvE/aThZ+iJmbVUDOQngSzSU3G0to8sfplSBy38nk
 eRsRTDoigtXweXP/8WNi8lS3jXsJLt20liShxVsDYAP3CYYHjFlYLuqi5ulryEYRdXmM
 eDcPta9UldwSLJcnt7UBdbGSrrd8j7TvrMv1tdnonXH4kdsSjmOHSIU0m7a+nLFa932s eg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g241s2xfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GAtYZ3008334;
        Mon, 16 May 2022 11:01:11 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v1gnd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7Sm5XNuC9hx/k5x0xa8XJ8Z8f2DyAS1XnhtUQE4gkYm/LXeDwF2cy0AYnuirEGZTFOXWBkQgIqNXH/NBR2Hlx1n7w/xMq8udVXEoO0UBolZZF7vgKMs2DnN2YReqZQAjGe9im0zzic0gjxopmblhc3eLhXxAmVJ6kUHkfw1A1oAcpSZrox4amS5D2sSxhAAyjYOa7KbH6gFaCCUpz7CPD40ZKGN8a7x8PPLxGE38K4fcfb/nLBq00/0I0j5RR1kUZ5Upqs1ViKj/bjnaKG0P1HH6und//5LvBhKK6WbwDs16bk6j6WBA4PS0Bo1QT1+ob9LABIa+3ImRvsY+DIjHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgfFmy2ecEA1o6NQoh4I2DSvosecT4lhtTotPzOnab4=;
 b=T7VOPtF8LXIB+8syFdecg8qv7eQ/PLr+hoE4LPVhfmUjHmr88D61ALoWbX7vpedIwyR7e61EIvjl0KEKbPMoG0TanzSdI3TBlJuaGmTlo2puwuKP1rtxyl5+yCbWQ3e7dCtC5TwnXqRuykjaQefCoDOlqGxXNt2UTLV3IkWcnW7kvGRCobQUnZe3jYZE/5sjh8mrCs6wdrMUKQwhSxRQ4kQPSpFgQJi1UkfTcRD9rMRLnHJyJf7+eeADxBVzd5jhQDXHZBXRejUSTJs1mLHANpjPKFl9EsQtAUG7YWn7DAo9BKiM0bwZ6WEX+d9pcUJud6beTM/kMvrmmwkMksBUqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgfFmy2ecEA1o6NQoh4I2DSvosecT4lhtTotPzOnab4=;
 b=SuLULVdFB0RnGooQ/ljJSJSjNVQuUjILyQK+uf4tHaN453M/4OGUEY0h2UFANSLgkoN6n2oSiIety3/fRQBRcMweznRtr+41MPgXneoTQH0K7487CSzOO3+mKPatIHSw/nAUozFdDeiXRwT7PCmkkKKv/s9/tDoaaxsMcP/zKAY=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BL0PR10MB3444.namprd10.prod.outlook.com (2603:10b6:208:73::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 11:01:09 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 11:01:09 +0000
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
 <165247403922.275439.1751140257416635238.stgit@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: fix sizing of the incore rt space usage
 map calculation
Date:   Mon, 16 May 2022 14:33:47 +0530
In-reply-to: <165247403922.275439.1751140257416635238.stgit@magnolia>
Message-ID: <875ym5spw3.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0013.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::25) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f4e2655-a486-4504-fb5b-08da372b61c7
X-MS-TrafficTypeDiagnostic: BL0PR10MB3444:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB3444261C27340AFC995CB991F6CF9@BL0PR10MB3444.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tabgNaJpLT8OzYRNA6QaY2eEBl0kmTdG8/dNLPSxTQ6dPRwtIwu1cpC8vjtPoZHVbn0ZuvyYEjyzszWfME7IR7vZN8A6N0w3Cy6hAF3GQ9dxUbKEaU7fZ7eWCcj7C8pvDp9U1jwP95XVnS01Vo4MY0MhazPR/8OQRfl8DGpFCSRsDFIHKJaZmg6RSd5cDCYZbYkfj4ibBSxF9oNROP5HxLthkSxmsuwvXCvJYQ3ynmd3LNk6OZCzSoBAJEwKPyeDfk5TVqjE7lFUDGkl9Fl7VHzIPh3QwbQcmWNN6RRxroby3+APpt+MiEMbCPS2hCZkPGD8LLJYjFydS4+SvVDLprMQN9Mf9gqm2d0R/Qosw+7vDTL9XI6Rcw6jeq16JNjc1UDOxbyCAB5+TC13lJg4ZfjujRLjLwBb8olOImXsgQDIZwfg0z3tA/czQGr1LNLSO6a3wnyCERrkNiPtFWufw+DzeH235fNtEo6NFqgJYOJLaRqmMhsQtya0O0RcGZFsayC0BVzNiiP9p4XzvH8FaYgc6KCkbiiwUrEuzV42L+9u+Z0oK8y5a+dp7nfeHEpKSQ8MPW7T12u21mYeAHAuOtS54p+ojJ0ANG+EE5EVVxdZdSDEr7DtA/kE+zOMjLnsVcwK1SLeUT1O+GU0F+1iPQdJByE8LxBs5E0w4Raz3fwFpuETUN5bklyizW7r32FXffBKhe5fYV1BUKXjaj5kjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(5660300002)(66556008)(508600001)(86362001)(38100700002)(2906002)(6506007)(6666004)(6512007)(83380400001)(66946007)(4326008)(6486002)(38350700002)(316002)(6916009)(8936002)(33716001)(186003)(52116002)(8676002)(53546011)(26005)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4OseuhAQLylRFJyph2S9wns/Q9KtgK3w7nDX8BJrSnC5la9sMWaxsx6+dM/V?=
 =?us-ascii?Q?VQfDww4DJEbP69s5+m6HyUNrRDBgwWWB5B45vQvHSX/dH7BMP0oHJ50RTrM5?=
 =?us-ascii?Q?B2aMFWkwQh2C/913Jj1zoxmkAnlQToemgJEYGSi03Brr72L6QHk7vZYGc4X5?=
 =?us-ascii?Q?7Ndz5wz1jNoExFqDRFBglKwGofIsEg7esTYoqyO5MJPA+rEC69KlyE0d6UaF?=
 =?us-ascii?Q?65HH/0l4NEq+oDVn4x3AHt0pNLpDbjLJIiLMY9lGdc043CSVXlAWalI8iUpX?=
 =?us-ascii?Q?LBF53itt5Y7tmDHaXQla92gDVHkFMwWLdN6DTSAG1h1MD7vW6xVsB2bqV2ht?=
 =?us-ascii?Q?y5CgM+XQXUSKxE1H4K1wzjZcsDWtLTUvJ/UXTQUzWaFAPRR1WoQusn8Z8645?=
 =?us-ascii?Q?tMemhUCxtOuU+jMMgqgXipWL8e85THHdlaGaF7MCCidE58J0/uzXSXJhqIlL?=
 =?us-ascii?Q?s5XtXgKSCz1psY89gPsraU+iPc+bXS12YwaSlnl3q+vHdUqHpR2gHxoylvmx?=
 =?us-ascii?Q?27XS9x97J5j7fC3s7Ugiqad7VgdCDUOfETIZBc8lwTIanp/BEEhd+MwBKXfq?=
 =?us-ascii?Q?ABYW0ajEPCo1LsWG8tFpf7ltD9PnJebI5jQQw2vWekQr5MDi3BUkM0itC/g2?=
 =?us-ascii?Q?HwlWs/toMe133vVQ1Lrb8NevY5aeGtAO0Q5yJpu8UGKKqz8XXWPj81JxG5PF?=
 =?us-ascii?Q?NWuvvJUMao+LXk61MaJJkkf61Zl95KEy1fQXJDeSxR5+AwYTXa59aZlEvrgv?=
 =?us-ascii?Q?DeePy9tGnk6ukTIr+QDdrni3nat2iqa2p2iB/KMaWaASkxPH/gyFYi0QxIIA?=
 =?us-ascii?Q?VJHtamwrKwb+wwpqeKudiN734tM/r9hytpd3bL6gQFBcXjS3ZO8PT4Z9HcUe?=
 =?us-ascii?Q?eteZ/AAeTpCK9m8rEv9nkIqGZMy5iVna+BJ2mTY2PunCmB8f06ZoEhw2vKr9?=
 =?us-ascii?Q?LbpLyKzIQ235iLlMbx4t17KoaTBk2hAfGC9RtUGvXoHw40BCNoIIrSMGjjfk?=
 =?us-ascii?Q?eMNaa7XayHIT1JLzo+uO3Sapir7vkZ/jlbf8kYqGhCxqP0oJJSwLpHpSK18u?=
 =?us-ascii?Q?7qdA25ikD8jkK44mpDbUXdMdD/MGFl6B1+SWh2U2NsSGQZfF3UWaZk4wObg0?=
 =?us-ascii?Q?tPG6IYhVDzFKaKNG8iBMIM3j/D+Y0RwcJZS08ygRZRo6O3F5jyZqjnGr69e2?=
 =?us-ascii?Q?ClUup/8QQ2zBYai2cT2+rkO60/73amxGFxPxkXBnvINXbO3/hhuX33/TNNiF?=
 =?us-ascii?Q?DbbmSh85s733chtLqn6SAd5XfA+IBfn/lrHCCLBGcTyAMYuFkSy0hO9WEhN7?=
 =?us-ascii?Q?VUy3NAC8B/Sm9611fz/7/lKKkjSUduTbi1/dW2LDkNFLqb+WgXWYwe0oHt2e?=
 =?us-ascii?Q?FURWRsHc6oKjt12vNumGZSUxGcgq7UZzfgfbpg1QroHUa0Tzop6/q6NOIfod?=
 =?us-ascii?Q?mgXZcNKJIKtMmK+44nfO6oJIRiVNqgzb1djiq+BYRKZAazy46BAQjsvXa5UF?=
 =?us-ascii?Q?1HD0idykdiQpdoImAC/1ZlUgWHaG5hFRvZ1IKYVT+uvf0Gzo6Uojvt1X0YhC?=
 =?us-ascii?Q?Yl8sUJcKBujRgapaY/pYTvXFiRxxHjl+vx+kHNZ0zlCH6UTlGW7+EEBGa0ZF?=
 =?us-ascii?Q?ZOfMbgnrLiLWsE/bErclOMCsoHakcjEiTM6zFaDCrw0NKr2uAM1gD0boYae2?=
 =?us-ascii?Q?4Wy3HMiyxJGeEVyVFqwqrZi+0/cuGO1SKmEtn1XSWOkiXsaA4kdZYS8T3Ks7?=
 =?us-ascii?Q?JanlWbO/Fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4e2655-a486-4504-fb5b-08da372b61c7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 11:01:09.2307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QLppVAlY6zKPIVqsObKpZkU9JnEDMWjms5VPjoyUdHRly+u0rQbo+pGhwt/BVG2Iou0uKj/h3AEnIwyAF3meQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3444
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_06:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160064
X-Proofpoint-GUID: s74Nbh4ww2kU4eRmHayjV4tsmZQplS3P
X-Proofpoint-ORIG-GUID: s74Nbh4ww2kU4eRmHayjV4tsmZQplS3P
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 13, 2022 at 01:33:59 PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> If someone creates a realtime volume exactly *one* extent in length, the
> sizing calculation for the incore rt space usage bitmap will be zero
> because the integer division here rounds down.  Use howmany() to round
> up.  Note that there can't be that many single-extent rt volumes since
> repair will corrupt them into zero-extent rt volumes, and we haven't
> gotten any reports.
>
> Found by running xfs/530 after fixing xfs_repair to check the rt bitmap.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/incore.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> diff --git a/repair/incore.c b/repair/incore.c
> index 4ffe18ab..10a8c2a8 100644
> --- a/repair/incore.c
> +++ b/repair/incore.c
> @@ -209,7 +209,7 @@ init_rt_bmap(
>  	if (mp->m_sb.sb_rextents == 0)
>  		return;
>  
> -	rt_bmap_size = roundup(mp->m_sb.sb_rextents / (NBBY / XR_BB),
> +	rt_bmap_size = roundup(howmany(mp->m_sb.sb_rextents, (NBBY / XR_BB)),
>  			       sizeof(uint64_t));
>  
>  	rt_bmap = memalign(sizeof(uint64_t), rt_bmap_size);


-- 
chandan
