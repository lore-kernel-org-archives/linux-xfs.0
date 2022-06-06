Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DDAC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 12:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbiFFMtx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 08:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237792AbiFFMtw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 08:49:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839692506BB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 05:49:51 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256BQHuq002310;
        Mon, 6 Jun 2022 12:49:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+06lgYfjLpU1ml4Jeni1+4LcjdPbTSPx1vhWt+RZYOU=;
 b=U1sEbQVZDnFFPfkiToLTRzSg7qQjHzlj4MQXRIAfjY0xLjjYLNhRKtOgHz0HFTLbUtiX
 oJ5sMUfXFaKcTUvWTT7ElYA4zaW4GVim4W0GEeY8fhGS8f3Cwv0JbP5pdaMAZFynxYmZ
 DoyqAG4a8FBD+XSTcNg7DPOdfMb2yU+QtW7n7NwKTuJSwzrsEiRxHE+Lu+hTpzdmHTqr
 Ohyud4dJYiVBOG0p8KatlgYFAV5UEP+htwVDdqoj8VGrHifCj2KJ/d2yTMETy/rtWTcu
 LX+7dt3nFv20yPh0Q91uq3Lla2huiJ9a8GzSRdwcqrM2P+xTDvy9dH75SDLdLFIHw5eJ Zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghahr8wje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:49:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256Cf6PR036441;
        Mon, 6 Jun 2022 12:49:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu8nm7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 12:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hs0r56vwMTTG1ioY7VYillTq9eM5q9fzHrWoV1uISxB9nSjKoi/naAczesfRAcbq6xeX9C124tO9nG8os1WycrS0O74mfXNUzqmLSsLyrM2NEoGnGjVkLoefEic5+FPrE8Oiy4fFuF/aR5Pjgqa2nI+HeKRCniRwjxvdmh4MN/CkIzMdswpluzNx6Hnraf5taOeMc2PopY1JvgI33YzWHoMuzqfswvFE/Qs5oDJehbpvsrdyW1jdBWNFk/sdThxYO6h9rFIrcbWhCNqRN/HspO7D93lYE1QoFBNc/NYddioyIS/VsgR5qCMHzX+UrsYsOe1G92e5R5CcmAeAjdE4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+06lgYfjLpU1ml4Jeni1+4LcjdPbTSPx1vhWt+RZYOU=;
 b=e2+UZMxkygfr7RlzInARpPoI1fGPOtYtSQBc+jlLr0ulXSkFS/v2zCgw9wSnLxTxmUO4+sJYqIkm2a4dp1pFo19b4QJ8MG4g4zmne1VPPkmACl/8eQ1T5BeCLax81+O5GX5cI2tzl+8PS8gB5XSnVmPx64zuMehhqX6zK2uh8lJ9Sogjh1gbfH9/bG9JuybzOaY9/F/gvvN/hzE2pRI0QSFqqZBjuXd9XyT2H9vzn4XBnrAun6W0wXrH7PQaPFZMhArzzvDVOOG7PuAkYRIprGsyFYhRnvHymzaBqucW/vJ+QzfxxK637Mc4+vNMN2A+/vp653Dj85lW/MuIeVcYLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+06lgYfjLpU1ml4Jeni1+4LcjdPbTSPx1vhWt+RZYOU=;
 b=P5gtPsK+mghyoe5Pj838fkusCtoOJQZM5hn+Zl0l45PSPcKjrcGIw0ZvWTi6zmmIvbn9uDL8dLkoNKlhIj62z/780UY3u55UzQ1M735V+pLYZfzdlvicNNAnT/81M0ti5FPhMP8vIX6gonVvJ/SU7tLBFjKgWw7BYlB2fz8uY2g=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB2523.namprd10.prod.outlook.com (2603:10b6:5:b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 12:49:45 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 12:49:45 +0000
References: <YpzbX/5sgRIcN2LC@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: preserve DIFLAG2_NREXT64 when setting other inode
 attributes
Date:   Mon, 06 Jun 2022 18:19:15 +0530
In-reply-to: <YpzbX/5sgRIcN2LC@magnolia>
Message-ID: <87mteqardr.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0165.jpnprd01.prod.outlook.com
 (2603:1096:404:7e::33) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b1236ba-0e31-42d6-4bc0-08da47bb0842
X-MS-TrafficTypeDiagnostic: DM6PR10MB2523:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2523F6B915D943CA3C8D2423F6A29@DM6PR10MB2523.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sU6w7KCT4pKkHO02uONRfVOg8RwKOP9cx0ZwyM7h1KFrEeZn6ULjqzRYxXLYTeyfQTEOwQcnO7wMGpgfU6Rg3wjxWNfJRDtdlctB+YlYZBx6rqr+QzDDXs7iUZGhF3/zJubT5CIEJkX+pr09eaYrAZ5Nzz00CWrTXGLxrKKB8kIBHouq/d0zP/8pOdL+5KsyfNejjrWQv3yq2oTvd2JcpOjU8emwXzY0v5hOmjVPcfSZ1JatXmy06+hlkOPFXjwwTr7Kp8KDQXXyn5J9jnB/6bM83NwG1CUZSvQ+Sj/pCGh/RTqDz/sTH7OZWFbSX+mjNc4hs6KT3/fooFyud1F9TTdW3BCnS3mwzffaQuC4aApI4+hbWturfKw6wCFGfUfXihUa+sBt8jOANsN52aLO9nQLDEyGqvutBC7a6Fn/pdyjoSjANJIuEv83I0Wox1WJ4/LLefhED1ER+3S4+TJwaInEGrqKDfA74obRZ1pGHOdZKYA462fC5WmNT8s2A13BcqL7EEb7tFYkpxyR8cFHUXezBxBNQjjsnLwIioVHRYsARHno7AKDMJ6hbv47FLXKFcA9w6Hqo3bqOLUyk66n/a4pDptgpe8GhqTyE8o5FO79ElNzLFw58lpZGnQDAVed3Hk60iHUGaDyTgc+fH0uMV2YiEGi3Av3tCb/1WD2PyzRAKSJjvltWD0NwBn+Bzz6/iGxm0jqvDaPZ5Y7xEoVDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(6916009)(66476007)(54906003)(66946007)(66556008)(316002)(6666004)(6506007)(9686003)(2906002)(6512007)(83380400001)(52116002)(508600001)(53546011)(33716001)(8936002)(4744005)(4326008)(26005)(6486002)(5660300002)(8676002)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9t5QSV8t6efOTn8mLC079Hqc9sjaeKbUmUy6bsR/TZO7E3d1uZEfLenQMkBP?=
 =?us-ascii?Q?sS45fN9yRavfXlvjMedZnOgJA2Z2QVPAU9HVGJa8zGbIOFCnwCA/heg1l4qe?=
 =?us-ascii?Q?+Z98hIdCr6tROeniFeZJ7vFKOSNl7gW/M5O1RkFbfb/AU4U9p80pGATHGk5E?=
 =?us-ascii?Q?Ug58Z1C80jUepWdBncRI2MdtCXpzeulEfsY4ecZ1DJYUtJSugR+QBM4eNj9P?=
 =?us-ascii?Q?T8185wo/qHWTW3D0UVkAaWyWthKx7tk3Ge7eZSe94TDEdMbCtd397KCfxPac?=
 =?us-ascii?Q?lrYtqWgxxDoluiS5coCMW7RbNJdyXUUibRtTUBE7L9QVb9V+pE7e5mlsFfMq?=
 =?us-ascii?Q?b8vpzgsjtgX33nxq1j+XLWZRuTk11ZBm2XNrX/ljPjUsKgdQoNfCa7598KPJ?=
 =?us-ascii?Q?zNgmHqh6d4SE4qxxlxnWOaldWA/mZ+5Ke1CDNfI7EJRRmVbnfNfmj/ZEqc5B?=
 =?us-ascii?Q?MLY/EwOJ3b5xao9Wd9oFOTwtjHzGV2fOiNLp0Q8ZVokWKwL5naC0LCYhOpN+?=
 =?us-ascii?Q?tE8CUk2FamVikjHq7UV+Wvf594t+VjISZsC1jdL7fFwD8fpeCabrzUWhhjXl?=
 =?us-ascii?Q?ddkPQB+xuIKCF/i1ugI4bqXxi3+U3uAeL6KIUlsD7h7pfhOC85Umr+VoUXhF?=
 =?us-ascii?Q?hiUQvpvTIBiF+0pK6ASJvRCA+mccYZE5kpj/j1IO39Mh492oFvn1p9aorWIg?=
 =?us-ascii?Q?ZQcgTn00oOCIwV/N222eMYbzqXThTtestpbmYJC8M1DKrmIgTTib/j7by51z?=
 =?us-ascii?Q?caUtZXWJikgQBDmH3FTut6rHP4H7+3wuq2+dYK/82fE5H861an18bQ2Losqe?=
 =?us-ascii?Q?j9pqf0o2KxsbGFtOirJDvJCyWKh70eLVtCVMLYSYhk6nsgtKMhFY+SivHkRZ?=
 =?us-ascii?Q?C5D7DL6Z2TB6GTxsjjVL4TAsFE8xyB45qllE9kWH8BsX6iH4B0dzkKKKyyfF?=
 =?us-ascii?Q?vUNZRUJnzNep0NZY7eDzv7wj40w2KNTJSghVzLShosEZH9mFr2UATijyRGYR?=
 =?us-ascii?Q?i9Y2qC5G9D0LJZ/Wdfm/v8DVHKwW7uxXHih1sGpgGOtJCF5+DAvf+tDPK3X9?=
 =?us-ascii?Q?EzxN3VhclqJJACiZDtRhs8BZ1iDiCO6v3LBpVWPoIewgOFTyySk7zrGJdne5?=
 =?us-ascii?Q?VNJeaZdYJgd0ntfA25yheqZVo+DPocbX82XISsTDprhUQBb9/LZvrUBb2kR1?=
 =?us-ascii?Q?ZEZ00sVyt2q96/oWn4mGc3XNepreTQso/gQgzZgzwR6+5A0FBwJN+jAPZ7cN?=
 =?us-ascii?Q?4sQVvogh2dkdPZDREy0k/+9yVcVQRGfrZ1xHByslu/0vOOKYq76L+r/dFZis?=
 =?us-ascii?Q?yTMleAMOrnd6koU4hfdCTHRnoIfkudRA5/Go5fO5gvYuhIyKTQkzId4C2ttt?=
 =?us-ascii?Q?ZBTO/S4HE1LIfffcc4+63O/OetCD91T2s2Ndfo+65LjAmW7radARZTunSEkF?=
 =?us-ascii?Q?JUYhdkPI1AsBSlohan6TBquLPDK4Rac19gBHwn+oM5XJDuVE67gScv9fPbCm?=
 =?us-ascii?Q?Z/Go862oLicPoMlxY7basUojhmcd7LMqE6T3G7QEJjIEpywlNd1oodfJrcDc?=
 =?us-ascii?Q?OcwfLH5Y5+AbujTC9AoSQC25VxgBytR5ydQvdZaDWFrFBKLITHTPADCpIDAY?=
 =?us-ascii?Q?rb7moL2R4yl3wVwjQSIsmcgm16iA5xMrGB+jn6PZrbZd9PuIn+zJWxWLdC0q?=
 =?us-ascii?Q?Sd4gI2ZS03hXpZD6y5zSJTxe/MlMi4rX7sR1Yo/DYVeBM3Gqv6wvnytxIBlg?=
 =?us-ascii?Q?EVaP0fMytrO3mzNyfT+rlh+39K+dN/M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b1236ba-0e31-42d6-4bc0-08da47bb0842
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 12:49:45.1708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kjCDpWT6yXoza/z6bMstY+6fEhK6apnW7+o0zy7gyjEdR9X3bt5+MMRSY0YUlhH1IOWm4d3e2Rqbe5Kok/QlIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2523
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060058
X-Proofpoint-GUID: 4RkGQohN_Vi3__CB6ed9XCWe_RgiJN0X
X-Proofpoint-ORIG-GUID: 4RkGQohN_Vi3__CB6ed9XCWe_RgiJN0X
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 05, 2022 at 09:35:43 AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> It is vitally important that we preserve the state of the NREXT64 inode
> flag when we're changing the other flags2 fields.
>

Thanks for spotting and fixing this bug.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_ioctl.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5a364a7d58fd..0d67ff8a8961 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1096,7 +1096,8 @@ xfs_flags2diflags2(
>  {
>  	uint64_t		di_flags2 =
>  		(ip->i_diflags2 & (XFS_DIFLAG2_REFLINK |
> -				   XFS_DIFLAG2_BIGTIME));
> +				   XFS_DIFLAG2_BIGTIME |
> +				   XFS_DIFLAG2_NREXT64));
>  
>  	if (xflags & FS_XFLAG_DAX)
>  		di_flags2 |= XFS_DIFLAG2_DAX;


-- 
chandan
