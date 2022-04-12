Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3CEC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352765AbiDLKBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376327AbiDLHn5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E678D45AC3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:27:36 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C7QGA5018415;
        Tue, 12 Apr 2022 07:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=WGX+w8I0b4S6Yh4n2Id5UUkklxUESsxzCY7P0sA0lAo=;
 b=KFcq3lNg5abRk57L64aFkaxA/GnemhDiU13kNmJgwgvuNSOjBRAn1q/vp8hOMmZZmPyV
 uLlsCnlF/1FVb/V79kjS4C3mDr4ZSZblaRK2sZiRkN0MtitQpMLMrKn61tDQpdfCz9Yt
 1kahpkJFnUXWHGPlpCIl8rBCNIMoP90rLxKD5+bfVIGEQeKzV2XAmtkJrlhlHwBSgEAE
 Ne4PAWFHROkWZZ/O9pQzSMQydTssi4aCF03YikqzYTChrsAewPqdaDxJOrAnW7QIDyQb
 rvwzxEIeRTOXRG5g5wNfN+r1NNx9oq4GlPH6CoKkzEszkVKMecnTYEbSdKi924lqZ3BB fg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1dvmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:27:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C7RWN1037894;
        Tue, 12 Apr 2022 07:27:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2fj9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:27:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwXFl3pI2H6Xel9NI8Fn3miMXVb3kq6zYt8Vebvq1DzQji5R7M98g37dfuO9b1y/BBXTk5xhlUKvw/e0SdUCdSGXFH97u35eHBoXajPqOABZEAFVsnn1R8kQLSbTAOMuxbd7sX1F9gdEvSbo14poOsAA+hZDnrvdi0TQdPuz7XEh8+HgDyvVCRYbafKgs5RTPRQD7A3CUuFxZab8UdDlvd5uLawV78IhiXyu5EU1NFUYSCjnC3VWwk6cdyAQqeTcW0Ow4Q/gpq41Wo0t/1/XUyxlNKLmX+ZafBi6ljc1UhExcyEus8a4j92v++D4+6oBw0hwy1Y0/XHk7HyOLsPNBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGX+w8I0b4S6Yh4n2Id5UUkklxUESsxzCY7P0sA0lAo=;
 b=n2+iut5TVzVN6DZLbdqk9L7fzHbj2Z7vZpFR/8nVfFRHit/0bE/vioFUXKafIt6XhxIj/ksAlgnxlwSOikWQUiCqVLAesi/PR+hcGpoPF1nRgAyGmNh4ugkn0YtexgCACgro03dv0VfKdcWLxjdkWNiBlWfLLAqlAJ/JHHwwaTlCCJlEBJH+yhOoyaFJUA/AF66CXaUSPfyOVy52z9m33yxhoBusrcq1o+vDDHo4vCSDhviTphAeFtD5vWpJuchX4eNpTCgpj+mcT2H4iPWUPYgGpw3bSwR/nGd+ShnfseRm09ZoYQ34TcX6WWvCop+8LbQGS18OWPLaoASDIjBofQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGX+w8I0b4S6Yh4n2Id5UUkklxUESsxzCY7P0sA0lAo=;
 b=MSI3ye1gTiPpMlacGfSs4k1DpIIRsc8YxXPXFOIZQt11dz7j20QCSu2xBlOJW6pxZ8DTTaM126AGAsCPtP/a2CAp4HhCfIRr8aunTBg+XExU8oBXwKc1byA5U6npOFGEPWaPpqK3ZtwZGjktBkzJuxV/vccGl36F4BYGfILYjZo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3464.namprd10.prod.outlook.com (2603:10b6:a03:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:27:22 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:27:22 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-18-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs: convert log ticket and iclog flags to unsigned.
In-reply-to: <20220411003147.2104423-18-david@fromorbit.com>
Message-ID: <87k0buzrqk.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:57:15 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:196::21) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8be1b800-813c-4b37-af98-08da1c55e248
X-MS-TrafficTypeDiagnostic: BYAPR10MB3464:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3464A9AB83B7328FAD745C31F6ED9@BYAPR10MB3464.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFSMp3Fg/mnsMNXithBFgArXon1Sl4o093iPs5RqAN92e1pmltgleCi43rmBqun4kP2T/5Am3Gw60/2zZdf4TcHSgsn5vaMTyF7NoDSp94ZWlA1NdMPFnHtxXLNSzqYtMl53p/+yTs1PyuAAobbNx4mccxWL+ldXP3cs+/+pdEGB9+bvmq+MVENMBBrGmpsgWZXJYoa2FXM+CRKkPg2SbMmGyNaIeZhjyLEECEdud0UNqRQL/WWLRJQQtPa/c7ym9C3n0VZ9G8b50F0wvh9GdpSQAwJllBhBtsVb5PB5tbJfsfGDQ8Pe5nTdmeNtbMD3xRRsI6akE+C2oDJNfR2PF/R9TbuPJfK+jrdSUYp0g0dUVZMQgN0bYd7UY5tco6PNZRDLy28feRl7MD/BuzJxBAGENOcyr/lDQ6/8CA7GpgHEWAbYoYinZVHy+Mp7nYBMdMlpTxcNHQW3R6qYNEim8pmKL4SGvrL5vtgPVOrP2ltjETJ90c/4oCOX/EKbU5Cx5vNjgkDPDq5pi2GD6qEatBxS/ydGNXz2YoOuqYziQkaRyVKwAFjOHOTb+1tWU+bROCiyRp0Ej+Kg7SdJwrjMGyaqfx7fg3vKmGEYDe6CenHfINP/xuqBpQKy3Tg7/4XyIV92ff+udBYUR5vosGvsAlNT/wOh5c3LTl/0bO5/xhHgLe+PwWE9awTP9R1IQ7lbxy4GYVSGsymigYVQS7FKcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(53546011)(4326008)(5660300002)(2906002)(86362001)(33716001)(8936002)(38350700002)(38100700002)(6666004)(66556008)(6506007)(6512007)(26005)(186003)(83380400001)(8676002)(52116002)(9686003)(316002)(66476007)(6916009)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ejE/mWbohHJRDHiz6MVIH2ZbpralANZEJSpa2yU7f1K2RO0zeazI6/oR6qYZ?=
 =?us-ascii?Q?Zgb5IQbrr1ZuDnH5xqgLI6+h/aNsUxPPNc2+TMKzO7Xs5/7f0cTOfzrsD4px?=
 =?us-ascii?Q?I6jy4T2iSRwgxCqSmEQ93cI9pyV5y68tMNxkTCtyepMOUVfYgZ3/mDR6IlBU?=
 =?us-ascii?Q?nqlOVMjcA+HFh66VTlXjmztRbB4oF6PdSoSVTGT/a762wcK0QWNAk9Z14bzR?=
 =?us-ascii?Q?H81x/upHkH6Cb7gYt8SY8dI13Nw/xcmfons/k01D//7DIDT3vT9AQZCvjbhc?=
 =?us-ascii?Q?HVqPi8njMpK/aSHwB34KGlPl4IPz7vO5J3cuk1znQ6yc3M8x9jgmcMyRUi7C?=
 =?us-ascii?Q?VqT2lq0py/Ee+9KgxFYoEldKxnCIWsfUAyThX3Tc0DjWFp+JFWXtsD1pyevY?=
 =?us-ascii?Q?syE5/kchOVe8yTudq2YE2ENNrrycoFPfGzpmLRi1Yn4FMKG7kiCumT0OhR2G?=
 =?us-ascii?Q?hz9JMtKHNZSIvyrr3k1rN68ilcYpTVZnheuxYj4X99q7xWT2uGzyEKdQEXOK?=
 =?us-ascii?Q?BnoZm3L9gKW9xQTWPX/PdlRQ6lvkwJUP9l7hGJGltqVSHgmNXk/oPL6NrN7k?=
 =?us-ascii?Q?N2NIASJnKMqvelJ5IxvIEuNL6C74Ubc8PhBnOftiKse/PFpnWoyFOYz5ZPR8?=
 =?us-ascii?Q?qFiEFfUqP7DcjgCEruxTLKFRrp3BR7L07JOi0jDU2pJs9x4N7JuEP/8f80ME?=
 =?us-ascii?Q?w8SYmXjGtUXpXnfXLCjYzIOfgwJQ3d9dpjeRz9xmBA+RvDry8arbmltAH09P?=
 =?us-ascii?Q?k/vLj5RmNF4gHNAAHaq9ids7DT0XZxsPIMTAdNiv+pob5Q8IeUj7KKGqxuBI?=
 =?us-ascii?Q?jcr0VxLcweBgJzGNlBusYsnPbPOV9e32rxBCOEYcu95nsNNLiAK5QWAtlkYA?=
 =?us-ascii?Q?l7hphTD7EdBhvxHfW5SYfDE57AJUuw2Vhk33iBA18oqFk0Dk2heDoIL0+zun?=
 =?us-ascii?Q?G6SEy3JDRro9ggY25XAlfqJEZIlgr76VYpSFB8Vs+Pgblyv2aYcAh+sNFtaB?=
 =?us-ascii?Q?xkq7n3Zsdh+4dtrLSw2lhyyetv+3aGotivuVONrL9XN1QH9wV02AiF0RsbNi?=
 =?us-ascii?Q?b9K1w7hQe72p14TIvwRjiUZuWNVkQq5VJqQ0CM8rt42udl6MTzXQY2ud9I3I?=
 =?us-ascii?Q?6au+E8xgSNfWmkgRHIxbkUZ6kcaTKm723pjrlmLqxA9FvHMFk6lNd7AO66lO?=
 =?us-ascii?Q?oy6YbYcWJ1DoJ4Cc21YgeCtVQ8Um1451ZlhvJogPUPYUDpoaS+yKQyTSsPra?=
 =?us-ascii?Q?bYAKmPxdnbug/z1PH1DzB9k4+Z7XNqUP5lq8+wqQiVrsGazW4pxw83GUi+0w?=
 =?us-ascii?Q?9/DJn27GewK3I342rWfVbXbM9kIZ5uxFzTyQ0GzEvf+13ok8zV1yFJtWhSej?=
 =?us-ascii?Q?VpxHzsnbzoxz26/KyBytjIe4JeGAS9oTrBUk86EiTbDnu4GmZfWg+4newrRN?=
 =?us-ascii?Q?yrOHb8ROKMEYTVaMEiNJYpywaSs8f/mZC6RXAcSVyqTYMIXZ4nArjxN5/UyU?=
 =?us-ascii?Q?Of7FdPMXhy3RDXOqCN7tMFv7NYhboTTeK5P7DIqpGEYXU2/+cuVcdDTlPCpQ?=
 =?us-ascii?Q?xc7v2SrbHnWmfBto/X0/MfA3J0FHhTAuDy/LXQbHEFYEoeF695WnCfCkf+X2?=
 =?us-ascii?Q?3MSByyAyLB15WUsqP+lpLiM9JgGYTdxZczN00j56BRXjn+63CKHYT7wrCi1h?=
 =?us-ascii?Q?n/+I3hB8NeRzB8oAWLm9PX/h72w3GRDHB/0ez/iiuH9qn6/CUR6q9loD6T99?=
 =?us-ascii?Q?UH7pKnQRgc14l6xJKOMBy0L95EofEqQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be1b800-813c-4b37-af98-08da1c55e248
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:27:22.3370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hhll348NjlO3lXiVYgx9o1XKr5cjnMef0aduqd1zQOSHRbp6syfEsjOYNcmMDlG8dE0g06tGL+zVdjZZuaAKVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3464
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120035
X-Proofpoint-GUID: LokLoV75ZDWYIf-HuQMvk6EG2GN_tYtl
X-Proofpoint-ORIG-GUID: LokLoV75ZDWYIf-HuQMvk6EG2GN_tYtl
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_priv.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 401cdc400980..438df48a84c4 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -51,8 +51,8 @@ enum xlog_iclog_state {
>  /*
>   * In core log flags
>   */
> -#define XLOG_ICL_NEED_FLUSH	(1 << 0)	/* iclog needs REQ_PREFLUSH */
> -#define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
> +#define XLOG_ICL_NEED_FLUSH	(1u << 0)	/* iclog needs REQ_PREFLUSH */
> +#define XLOG_ICL_NEED_FUA	(1u << 1)	/* iclog needs REQ_FUA */
>  
>  #define XLOG_ICL_STRINGS \
>  	{ XLOG_ICL_NEED_FLUSH,	"XLOG_ICL_NEED_FLUSH" }, \
> @@ -62,7 +62,7 @@ enum xlog_iclog_state {
>  /*
>   * Log ticket flags
>   */
> -#define XLOG_TIC_PERM_RESERV	0x1	/* permanent reservation */
> +#define XLOG_TIC_PERM_RESERV	(1u << 0)	/* permanent reservation */
>  
>  #define XLOG_TIC_FLAGS \
>  	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
> @@ -165,7 +165,7 @@ typedef struct xlog_ticket {
>  	char		   t_ocnt;	 /* original count		 : 1  */
>  	char		   t_cnt;	 /* current count		 : 1  */
>  	char		   t_clientid;	 /* who does this belong to;	 : 1  */
> -	char		   t_flags;	 /* properties of reservation	 : 1  */
> +	uint8_t		   t_flags;	 /* properties of reservation	 : 1  */
>  
>          /* reservation array fields */
>  	uint		   t_res_num;                    /* num in array : 4 */


-- 
chandan
