Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2FAC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 22:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243775AbiECWqD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 18:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243790AbiECWqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:46:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5B642A00
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:42:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243KTQM5030007;
        Tue, 3 May 2022 22:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4VujABf4dl00O9kIzUWsNqIcwEy2Ph+w4ZQW9JR1uPo=;
 b=IvEtkaaYE1uPaLkEYxLtxJqGyH0kYKPvgMcEaoRDSNhnMTymS4DWbub66pveWHnfn+W5
 1kKJyaUirrIXVkp9ZEC6cuVoGJlREjop0fOMevXaomu3MnCjQaQCeE/VfWWRQ9/hMkL3
 OV0G91lZbIz0ESurMVA+uTSFoHpTicS45vNKG3YTE/7GnYF1nl6U4QpJAkW9v/7UOrl8
 w9HtqNvIuqOi+B3AR8HlnXElATch7iPnu8lqiXXiXrpj9bNwYWPwccA8EIk8bBGT+yyE
 MSFUDs8WWD2Vq5E3PJTpO7+tSVkdgbItxHRWUP5QYmYbwyNAKGfjXyUlz1YH4q6VL47N Rg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0f0wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 22:42:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243MZRHt031677;
        Tue, 3 May 2022 22:42:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fsvbmsf37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 22:42:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mL+EoFx9Yn6Tva6q3tai+vbUne4MNEgGw/5u/ORtDkqyGp3lFyHexnp7CFzI32pxk41KchWn6D18CQqtl0/FGL12s9/Cy99DenJzZiaLJdluuCte4y8Jy893xjHF+V/T8BRc+zLzLc3bqk3W8CAUOwQW4szNJmIdhBGmNkT5yhu3bP6PVHpDwuAU3cwKiVNyqQLz3hRPeMVjmqi6g0h/LeN7jAN4etOK/IkWx/DUhPDkDdi5l+23qzABe9YQAUZ0/PcQJ6Vl3WXPF/K7K5Hz1/Y8MxtQr6nTs8/wjosb1VBMKvasSqmLBYCmrvENUHwBGJuzBubQcgm+jXCvVxBA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4VujABf4dl00O9kIzUWsNqIcwEy2Ph+w4ZQW9JR1uPo=;
 b=VH084ccBiXb18RwfHC0JwnYqGM2CVMQYTcWNbGg0Pa/p8MxVQGXBD158KTMGmgLsSe5P0jk2JSjw5bDc6SpIj8kqS/oMk1Vapcdx8sx6bcbARtpK42h2ix+gf9r7Jfvaeuyg/8s0qONraiu9B7QyYgXak3IQ61A6vXBqDhlnSd8VUiHbgg6dTKw2/qx2T0ugtzqR7icfgLekQj94eBAve/U2RccySZno0nSjTg31sMRQDND/9HQ7fHDE0xZlRL5NkCfHgSFKtzhpb27W2ju9y7ywfA7x5Grz+8Ty/qw0MQcomvSqwFHuOKji9CTkKAauFkIwl3ilSBQ7MiC3LFx7zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VujABf4dl00O9kIzUWsNqIcwEy2Ph+w4ZQW9JR1uPo=;
 b=HookawDab43ub7XFnd4e/VTh/eRw+Zl8y7N7dkMIxZlKCKq46+whHboIIbEAGNwJF6Qdq1iBInxUA5Ivif6HHs0Nk06EAljTpWeW1pPIun9nmT6wjx92GZZJm4ztpV4kA46mbdN1AB3+/PaFOCxRO692CseYfwrVNhmtOgLa9fY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4416.namprd10.prod.outlook.com (2603:10b6:a03:2ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 22:42:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 22:42:24 +0000
Message-ID: <65be4c4a6c108a46cf8d0d8f9484b5bca72fddaf.camel@oracle.com>
Subject: Re: [PATCH 01/10] xfs: zero inode fork buffer at allocation
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 03 May 2022 15:42:22 -0700
In-Reply-To: <20220503221728.185449-2-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
         <20220503221728.185449-2-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d33c984b-29ab-4a28-56b7-08da2d563160
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4416:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44167CC8E42F33223A5BF20195C09@SJ0PR10MB4416.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQFZ0eOFjz8015i+CQup13dc7fDUL7bVdHc2OxHdLgWvwOCpz+btvNE6fB4GednJyrtqvDd3Q2GqNkSmpfaly/ljL93E8p4OsZulHSDe/1LCpl3O50B3v43lKgkuP2kEa5ndQ/h2bABq48apYmmoew3vYT6pak8GGSB9gQRDLop+EZiEt8i8GLVlcruf2pC8fMUGkI+z74hdAaOD21Wq/5x7ZVEqVaqDSMdaVovBNBoP8Xa7iSi5/pehwkli7Wcg/nyyfjEMpLyj/bDhE6Vj+Z+dFcsNOjnqAih/+dRIcqksVavgmra2/WAWCUy1ZWwPFnYkEgpusz1GiQN3y83+J1T1m6JkCj477KvgyKG1sbjrZwT8ZsAfgh/BYjhn3S6AUMI1AultVJDAxLVcXYxKbIJEGQn9463r7yOQkWe25+84reEo2W1IvORMLtebZXovhi2dzEZW0wEOtoUzt/MBirTa9Lo5pqcphuZJ+V+3oC51GvjxnVY09RcJhhm26YHMqrUjps/Aue+FVs2StMxiiASYugWrP9DIZNf07JX+Vp9Hqt2mRWIVEwjyXOYk6iIhyCpXmPs4Bto0NwJ20JMwBK5eyNzaB1cmscMQZXgD0jZ73hzbvNYd9NKnLbaj437YxwtbP9aK/NADmyXUMefzg/Yf9fQ8lvNuu7WyG/EE7zLoGQCHokZTxWfDM86FaJ8eH/ESY8OfaVTAj6BGZH7qcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(26005)(316002)(38350700002)(38100700002)(2906002)(86362001)(52116002)(6506007)(508600001)(5660300002)(6486002)(83380400001)(2616005)(36756003)(66946007)(66476007)(66556008)(8936002)(186003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzQyMnVHMWJVZlBMUU9pa3NQTExzMmZnbkdudWMxT09OVk52RDhCbUZGVDZS?=
 =?utf-8?B?ZS9IRlFnMGhEZUw3OVlFWDhHSFMvVWk2SEVhUUpNeUU2VWJtcTd0dmg5UHp1?=
 =?utf-8?B?Z0FXa3lEOFlob2wxandLc0FpVGVzcFIvcnVoRC9DUTlmOG5zb1RYZzRaS0Zi?=
 =?utf-8?B?QU53dkVQQ1d5dnZmVEc2dGZ6T0JJWGJVbmh3WWlMNCt5TkJCbDM0STVYZUlL?=
 =?utf-8?B?T3NPd1JJVnVoZnBTdnRhTEpJdmNibUVoWisrNStYZ05NcVY4M0p6b1J4Z0Vy?=
 =?utf-8?B?ZHo0Zm1uUjkvVnNPQTJtVVhOR2QyTnNhMjFScGM1bks1VERxMnBZc0UzRXov?=
 =?utf-8?B?THEzekRjcGQ2cGhDdEZCNm9jUGVIek5CSlNPUE1BenhIWGpzR2M1Y3JFV2F1?=
 =?utf-8?B?NlhMZnFSOHBYL3VJRWVocWlZdmlBc0VMRE9LZGZjM0tCUmU3V0xXdHEzaUZu?=
 =?utf-8?B?amlVZVVxSjN5ZktlWGRHRHh3bkd2N1hHbkN3OTE5YlhraCtqYlh5V05kWnFG?=
 =?utf-8?B?TU5JNVVBTlRSeEFDL09MYXhOTmVucFE5Q2NQNEhpV3Vyby9kbHpaL0lVSUll?=
 =?utf-8?B?MUsycWZvcFpGSEpyZENpYmJTbUtId0xtV2dZN2F5UmpOVTYzZUlMcEFhOC8v?=
 =?utf-8?B?WGk3cFRsc085MTNGR1N3QVFXaG9HcUhtZC83U3Jnd1NCejBOZ1RGVTBsQ3ZI?=
 =?utf-8?B?V29JZmhXMDNUa2gxaFRYUnBaSjRQREI3Z3M4RUlwdWhHT2J4V1kyUmt5Rmtm?=
 =?utf-8?B?M3d3ekkxWjhrbjJ3QXFCM3NyeGJnTHRSclVXMEZPSDRUS0RhZTAwMHZybkVu?=
 =?utf-8?B?UjNZd2tpNHp2MDdCZ29QbHc0WDF5YjlhL1AzV25lWE9Uc0ExSkNUd01Xb3h6?=
 =?utf-8?B?RHBqY1dKaEwxRk9iTFRGS1BZVENoNm9ha1RrV2ZZRk5PY3hOMXAvOEdZK0Z2?=
 =?utf-8?B?T1FyemUrZ2RuMDdzTlBQRjZWTkhUcTZJUGttR1BhY3FrM01zOUZjL3JMTnFP?=
 =?utf-8?B?bGtwL0o4VGlOTmRnd2tpTm01VEJqUHhFanVFRzQ5VHJHYm43N3IzRWFPbmlh?=
 =?utf-8?B?YmpXbVYxOUlLNy91a1ZGWEVmSGt3M0d3UVJ5V09LZHBnTlFLWjZiUVRCcFd5?=
 =?utf-8?B?WG5WZnYzRE05WnNXVG51VkhXUzFRYTVyYkhCNkpMSlFZQkpteDlOTm03VFZF?=
 =?utf-8?B?NEJLK3NSYUR2dW44Ukd0bndjYVFSYm0wK0lKdEVVQzQvSXp0RmpXWFhORFNH?=
 =?utf-8?B?NURadnlzdjI3V0ZXN09CWGN5K2ZvVGNlc1dJR0FreEhkSVJNbURRNlBNTWd5?=
 =?utf-8?B?ZytyamZScDcwMmVnTDRTcTN2ZU9jSWhUaU9Mam5JMmQ3ZnFzd3dwTFdzWVRD?=
 =?utf-8?B?ZVB3YmJnbHIvMEJFK1hzVFpZYXZ2SzNDQ0FxbHc1QzljWFlYdjByQ3kxWXBT?=
 =?utf-8?B?UERHZnBXWFp6L0NNb2NRYWZ6a1M3UGRyZiszVWhxMUtvdjF0M1lSbjJaK2w0?=
 =?utf-8?B?SXRvaXhNaDI2V0FZd3RZS0Vmb2RXSU9iQXhWbzNXeTkwTXJUSXlBSzh3TG9p?=
 =?utf-8?B?QTdKZ2FYcWY4WmFBWXJnWTFtd2NHZVpFekRmMG0yTHdhOXJJU1czdkRoN3FG?=
 =?utf-8?B?TnFCYXYyd0piWmRLbWdBYmpVRkF1UGpjQ2w2emxmVVMwUWE4ZE5ZUzltMVFm?=
 =?utf-8?B?amUyYi8xZlJxZnlVa0lzM3F5MElsZWsxZXBRcmhlbTg2K0Z4a0tKUlhYNDlo?=
 =?utf-8?B?VXhSd0tPQXVxNXp3VzRMYkZTdURKYkE4bnZwcW1EaEtheVliMjhuOGlkYnlN?=
 =?utf-8?B?Q2ZaV3BaWllvSHRuT3JrUkJXUVQxS1VScHYwSE5CcXcvZWY5TlBZVUxWa0h0?=
 =?utf-8?B?c0dtdVdzYWNmRjRGREcrWGEzdE5CdTFkd2dZbzhPcVVDZ3BlTFpxM0c5U202?=
 =?utf-8?B?cUUzSERHem5zOHBvbFJLOTlYakxjOXZmaVpUdDBFallBWEFrcXc2THR1Y3hl?=
 =?utf-8?B?WUdaek1xZkVoMUtZWmpQOTZ6MzhWbldaS1RaclFxSkMyUUdvd3FBckRobzFC?=
 =?utf-8?B?bThuNUsyeG9GVmlkYVpPbm5zV0p3emVORGd3ZnVmZ2ZNYVFqN2FZNHNLVFBo?=
 =?utf-8?B?UnBhQzJ0Tk5ZbTlCTnZXb0JOcWowZVFHMmN1UGFCNU9DMkxBc1E3MUY0L25p?=
 =?utf-8?B?OHJjMGVhWjlyUS9pbWFub3RmRGh5dFlhZytmM3JHaTZLSXRYRkxJY0sreGFB?=
 =?utf-8?B?K3RtWUFRVElkRnlrVklUbCs3WENTK2Z3ZC9VUkVsQTI3bGV3SzVibjRUNGRI?=
 =?utf-8?B?VGlTbHRES05UWC95ZWhrUWpnTExmNDN1Q09HSTFMYmovUFc4bTg5Vm9MbDNZ?=
 =?utf-8?Q?x1ReELFsPyVWrPqY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d33c984b-29ab-4a28-56b7-08da2d563160
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 22:42:24.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmPe0QFz807e8G+c2s/VyOmODN2qOYUn6kMj+GUfPF2q1lp+gUaoJGH4qVU+AG/tKGKdR3JNgPvLYDnVsJUrlFBoLAuY7N7W1o+ZaejIt+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4416
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_09:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205030137
X-Proofpoint-ORIG-GUID: UG3zRgt2guUGEhNjkHYIkqk_X1d7Mukr
X-Proofpoint-GUID: UG3zRgt2guUGEhNjkHYIkqk_X1d7Mukr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-04 at 08:17 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we first allocate or resize an inline inode fork, we round up
> the allocation to 4 byte alingment to make journal alignment
> constraints. We don't clear the unused bytes, so we can copy up to
> three uninitialised bytes into the journal. Zero those bytes so we
> only ever copy zeros into the journal.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_inode_fork.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c
> b/fs/xfs/libxfs/xfs_inode_fork.c
> index 9aee4a1e2fe9..a15ff38c3d41 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -50,8 +50,13 @@ xfs_init_local_fork(
>  		mem_size++;
>  
>  	if (size) {
> +		/*
> +		 * As we round up the allocation here, we need to
> ensure the
> +		 * bytes we don't copy data into are zeroed because the
> log
> +		 * vectors still copy them into the journal.
> +		 */
>  		real_size = roundup(mem_size, 4);
> -		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
> +		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
>  		memcpy(ifp->if_u1.if_data, data, size);
>  		if (zero_terminate)
>  			ifp->if_u1.if_data[size] = '\0';
> @@ -500,10 +505,11 @@ xfs_idata_realloc(
>  	/*
>  	 * For inline data, the underlying buffer must be a multiple of
> 4 bytes
>  	 * in size so that it can be logged and stay on word
> boundaries.
> -	 * We enforce that here.
> +	 * We enforce that here, and use __GFP_ZERO to ensure that size
> +	 * extensions always zero the unused roundup area.
>  	 */
>  	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data,
> roundup(new_size, 4),
> -				      GFP_NOFS | __GFP_NOFAIL);
> +				      GFP_NOFS | __GFP_NOFAIL |
> __GFP_ZERO);
>  	ifp->if_bytes = new_size;
>  }
>  

