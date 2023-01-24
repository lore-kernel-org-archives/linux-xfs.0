Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF6DC25B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 05:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjAXFa2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 00:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjAXFa0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 00:30:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0792C664
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 21:30:24 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04KQa013028;
        Tue, 24 Jan 2023 05:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=W9MmgS0cOPheyPKCEd5701xdIVisGJZbplAawPU0Fl8=;
 b=qX7+J8juWf6fjmAfvsSbntIq3WokL2y9nQhYVkWc9PB1mDieQ7HFoE3maP0tV5AfsjP8
 WQ+Urk91sPC3Eq8WXSJhNshibgkz5GXWj95qFoG/EdHYMS1tDe0WbHANJ36b9qfPHkpM
 knS0ahEI76EHKYtzDtZ6AHZXfJhrNezLfnAf9/4eXCLDQcmnZeapLzsQCHDxf9AI19xB
 s/Uti8wivzXr5anm+etdL+it9Kjb8+nK6K8wdDTuUO41kq0y2p+XFjroY7ao4tr1kXXI
 wBLgenVH4OkeLp/zwWgDuoyP3LO5gG0Kgmb6uehI6VMtmEGZ68pfjackkATo8n33VrGT gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fccj7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 05:30:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O489Ph011661;
        Tue, 24 Jan 2023 05:30:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3yx6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 05:30:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOWMpHCJFUiPsN0xfuNkh9mLtZmRzRzrIciAavmIWO73w73ChOi8kI2CLOm0VE5gUw4O4KfcVyIrHAGcPoBH+gYcwgjLlRN5/CE+Bj3M2tXRWpa9CIc2BkpNwZvIiUHbmaSV09qf/sq13TuqBxyZPVWW/zi3dME/gPsvEeW5RlR5yfCj7IdDa7fRGyCVfDxqtiJpeV4AWFhriPefmj5KkWIPBeXW+O9EM2SBnYVmZI5BC0LIvZDEFB72DN0lE1Curl4dB6rox1jZcbkzhg/c/gW+oGwK5dkJGh9oIfApWe2zxprmnqKWtYg2PGGFUpBBdKivZlNFyYDOYwN+gbsX5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9MmgS0cOPheyPKCEd5701xdIVisGJZbplAawPU0Fl8=;
 b=RNfIV8w4JHGhucNI45vd9oEPMg3iLIIG8GVj6Dz/IfOhA3/YCD4UyzNzuJR3bg+80NZwiRjMTnP2nffP/8oiCVfi7mO4JHaPOVDhHot1j/TpK44knrHDWzh/vkUg5NIowas2EaqY2yhmbUmNlhOC5POEIW0yWXD4QzdWO6XuRpw5DyhhS3twCyQcF4Y1pYyqeMjl77KULU8GPygtb7cl2VlFOUeFGj3J+WTtWf+l29EcbDoYULC/phSynfiZQKHm24g1b5hwLaCRSU9RTS4XzOj1+uNDQnhX3Vq73vuMnEWzx2vGPNKtzQSJj1VNV28bOoNLMGcweVdKlmAeNgTufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9MmgS0cOPheyPKCEd5701xdIVisGJZbplAawPU0Fl8=;
 b=OWEViFbMo3a/X+zL1pn0zkawwXIbX2O9tgZScLh/QSLZMeRcjRaB5dGQHqHRRhqXMYwgFZ1GFP02QAcCyIN9xOMg/nRMP6gUI2B+NDxbXJyXT87f/JBAs5LygTebUBVRG46I6MNfLSBMi3chbAUFc0MA1ToEL272meTG3WJ1BC0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CY8PR10MB6660.namprd10.prod.outlook.com (2603:10b6:930:52::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.9; Tue, 24 Jan
 2023 05:30:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 05:30:17 +0000
References: <167400163279.1925795.1487663139527842585.stgit@magnolia>
 <167400163292.1925795.12938763753506074554.stgit@magnolia>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 1/3] design: update group quota inode information for v5
 filesystems
Date:   Tue, 24 Jan 2023 10:59:32 +0530
In-reply-to: <167400163292.1925795.12938763753506074554.stgit@magnolia>
Message-ID: <87cz74lct9.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0035.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CY8PR10MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d2c6eb8-394b-4694-7768-08dafdcc1393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsPW8+i3fUklVG1jEFRZDFUK61daJuUKAwsj+ux7uhEeZs9H2xw1DYDa5LAanfiBns8OxxFXp5SdUNrRJFC7Hr2HR7sFxY1GHiuvmwg+L/S4Ab5J5uZFk4rgWWQasKU8gPRhihbZxV0EkjWNGvq1ymTlztmYV/ANXeERy1jdF2LxvXiP7ZhAqGU21GDtZ7zgU27OwaVV71UtX24qaC2ykdU3f+NNc1J697oe8183ZFgR0Rfc4up4o0AxbwsxbtIasolv8r72Tm9tZpPKTZesB7WmMtvbQYdL/zZXXFsM5BkAinn+Ff+VLj6y9Lg/xMQQ98awxz5dTlM+FIInrzNP7b+PvRFT+qWf0C0Q5gu42i4oJDPdrFLSbgoaQabqq4Sjd1Ey/TpcEWAZ7FOefj4UHqtC4zCej2Sq19W/qWha98v4vWTkjdsSCpU8FOwnrWq3Kfj7yVZ5r5Gj4Gm+9KtTLku+McnYKblgIddzwRnjj6FsRiGp60WBBXG2pKFQ5Z4CWgZ/Z8Euu8GZ+vBeCrSHc/BWaC9xq/z1r8zxsKq62OH0oktUhg51oVum/Kdd52FLs6DaUFyJPYrofcSG6LHzTlkYUYO/qrnd0CVjEaF3BnYe6ktPv5lKIraUqoNpH5Xg3hTzQDR9C0H4tqT/hGkfoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(15650500001)(2906002)(5660300002)(6506007)(6486002)(478600001)(53546011)(26005)(6666004)(107886003)(9686003)(6512007)(186003)(316002)(6916009)(4326008)(8676002)(66556008)(66476007)(66946007)(8936002)(83380400001)(41300700001)(86362001)(38100700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CRM7zAldKTYPUSSJwwoLXBC1fvswtTRlLS4RZqGlqeNF/5TS+Om584wkZNRF?=
 =?us-ascii?Q?5Z0rl0fHX7djHyf7RIjjweRaXFUnLEllTR+Y3I+wcDb9wrUixeQJl1nkxAob?=
 =?us-ascii?Q?lTNfX7Di4ggjZsAe/g0oU0i5PCjMoMsCYpNw77CAWFqtmEtWSaee04N2QJtg?=
 =?us-ascii?Q?GNwRFmkiNNZHpIluPAwNc3rikeo47Av+6dF87BmAKOukhzdrALzJ9NEB61pN?=
 =?us-ascii?Q?BUkaBFin2jsKa4/aLjR5odY18xcEAS5xF1PRT+84V72jXSSWU2f6aTMo+FSP?=
 =?us-ascii?Q?HuGqXfH1YtzqZY80+QMZDkzJDfghQ4NAYf6pEDk9hwLI0P7N+74FPKmVIRn9?=
 =?us-ascii?Q?e3wusUSk+N6vS2ITiU537Ab7M2VuFNHpwsodIW5tX+M1ZQ1CJHvuFDO1lovZ?=
 =?us-ascii?Q?ukXPbUOMl517wr27Yjb3rGT3fNWuo3knl0/aSGaP3LwayMMxiisD5hdtKF5q?=
 =?us-ascii?Q?goJjZezoqFKGvTgQaoDpnsVXPJrVFMdnN/38P5ffydzHsB1kO2xX5mGLV413?=
 =?us-ascii?Q?Dzgec5wgQQ87A7BaHxOz/ZtGjCWMItBaR+hiM57NhDVbFLyB5aExQjVTYwFa?=
 =?us-ascii?Q?D9Pqj/Hj7SppFUSmwHgHV1TNFbVSYvIJYXWWPWiEmMQvbn/bMA3baMvMlKkj?=
 =?us-ascii?Q?HvbWTVXr8FhYmGr1ooLdmL8j1XlAi9kxBB6R8NpNeTwex0prk27g7oMq0uLB?=
 =?us-ascii?Q?B4kpWchdXkknNapRpnPcc25Ab//D/AFCU2tB6Grhv7c+qu6OTROSM4c94lmQ?=
 =?us-ascii?Q?VxDb576lCLMFkM/h9joesg9M6DpDrqKxV6nxxhB9e4OZRU2Izf1h+07sXY0x?=
 =?us-ascii?Q?coRguBqkClm/eP/SqELn3pJj5rFXNsQKjFOq+v8lKmfFJXYn82Pi7K0Alsm8?=
 =?us-ascii?Q?oTHltRSr0pW7F3ZWhTM+f94WCPxT2dIrCT6W3klvZZK+7q5radxgOeeDHv1r?=
 =?us-ascii?Q?YDl5DD/0/1ohy78yIesoOi7tyKghiyQAN7YlEnvjopfbgc/i4u9d74DXUAFg?=
 =?us-ascii?Q?zvEOgqKWwBoR/ij4HVne350jGfaq5mEHCMcWgS8a7Ulkio7oxmtftTkARDpV?=
 =?us-ascii?Q?5tGRn3SA99H31RKf2TJMf7Mr1v0lbMxu5ZGXzaUXk0zId+RE/ZJd3X+g02PM?=
 =?us-ascii?Q?Kfamrl+8VujavAWEY9puZ8W93RioNO+Dd2Mkl1XXXnMvNiNoJjukUdgBvZqn?=
 =?us-ascii?Q?r/U2YTGS8P96/eyQ9/11Zk/6L22fMlFku/NaGCeJUpNoulVM1kECha28bAr1?=
 =?us-ascii?Q?CoXDgN/SLACUT6nWvWo1AM0RUPWU2kSE1/ey+ANWAyhKCu5xCz6bPq/rARM4?=
 =?us-ascii?Q?m3VV8tfRKG/R8W3x3Ok/S2x62TZCN9OfY5dJFnSkCuy7x4r/qRUXje2SuMb5?=
 =?us-ascii?Q?ArERJVwqVYpQHLpWy/0u7IjPHVxqWicn46sxvmn++SzvWejKRnnpNXC4xomZ?=
 =?us-ascii?Q?RUhZW0o6FwxPVqb+/00XrdFl+TiLZ3oxXN1tYt1JhExoO0W/w8A6NK3QkMNx?=
 =?us-ascii?Q?IEZJQ5REyIC0GWXM0eL6LdpkomOldJtJ6qrf8c3vd2TZtKgcnMjqSyjcecw9?=
 =?us-ascii?Q?66Ut5Y38dX7nQ8LuRb9G8rVvcxd/MMjWOT0iA+sT3zS7yhwL80x7q/bEM0Ys?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9baHc6yakVf2lXrDha9rf9kADJ0RJZPEEyYYgNN+RLMaVflkDFyr5CrP8qoHuGGd17VIrrE51xCUmaRg/Gr/5CGG8k1OlLrfzLEVIpr7NwFlXJEYSlQkaABb6SWwtOl5ZlozdbWlN5R8ZIyJ9LM2q2SRledqfo+xFu1Y9btSeToX6coaxGgMdeWdqsvco6yz4VUUBO+WPWwaGWDWPHdUR0Aepdn6ZgqHCrB8BMLQ5BXh5vD+IWdQ3dWbfcu02Hbyuh5T0JW84nG/4yEXLA7Vz43zr86/qjn0atHhnwqjpfk+cpCxjFc2Df0qpVZK46PPED/lDiSnsAtalDhLAiwu9rB3LWQ+zfm/1DiTLXt2avukdRNSUkRUiAvK9nAvVlemYP/QDO4Ifnbx6VJ76nHdw1vFRI3EhW6sA6fGhAUUa8vSZ1dH9JFUMOheMqMwQXTaWyZaviGu9K5/QMo6RGBhWg9jTmX9/FybAruewQIc9clyn0XrSevyHwbCzD6I/gokS9Y7rmoT4pjIiY3FKbC+lcAS3eATRv3au0PAHpS5CHiZrv+R6ObH6cp2zLXEfBPzgkGe0YaLBroBIpkWcA/pODy74cLBbQE5X5S5uJNDDIJcMOZHTS4yUM+V+9sh0DnJvhw/O1uT3iM1ifHe/dYC1JtIhCJbWXQyVImLHFW4yVA/jHs1T8xtlWUwhBbzwkqoc2xS8W8gNnpuGJyR7WNETMNPPo6tBHKSUpfBTZdscX/cQ2yUgDArn4KB7Z9D/1YHmqe50DYLijPGlsjBRtCYfrzJ+M741mIqlxJx1WX2kzQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2c6eb8-394b-4694-7768-08dafdcc1393
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:30:17.3526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwjOh5hl5ZZYd2N7WnHn+4SVkooqWBWqw5Nyrs8FN27nebiTwxAo/p8imVbPD6SRQah3xAT7+E4BYJc4vRhmQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240049
X-Proofpoint-GUID: 7RVyxwa6SPKDNDPBlfMSuGDI81axnsAv
X-Proofpoint-ORIG-GUID: 7RVyxwa6SPKDNDPBlfMSuGDI81axnsAv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:44:49 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Fix a few out of date statements about the group quota inode field on v5
> filesystems.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

-- 
chandan

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  .../allocation_groups.asciidoc                     |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
>
> diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> index 0e48b4bf..7ee5d561 100644
> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -262,11 +262,12 @@ maintained in the first superblock.
>  *sb_uquotino*::
>  Inode for user quotas. This and the following two quota fields only apply if
>  +XFS_SB_VERSION_QUOTABIT+ flag is set in +sb_versionnum+. Refer to
> -xref:Quota_Inodes[quota inodes] for more information
> +xref:Quota_Inodes[quota inodes] for more information.
>  
>  *sb_gquotino*::
> -Inode for group or project quotas. Group and Project quotas cannot be used at
> -the same time.
> +Inode for group or project quotas. Group and project quotas cannot be used at
> +the same time on v4 filesystems.  On a v5 filesystem, this inode always stores
> +group quota information.
>  
>  *sb_qflags*::
>  Quota flags. It can be a combination of the following flags:
