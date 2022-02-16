Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5025DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 14:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbiBPOsK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 09:48:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbiBPOsJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 09:48:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8EC2A39C0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 06:47:57 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GEiMO7030428
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0Js3msEuxgpXPJ0wm72/G13vu1NuWrzRyN4gO2DPk0o=;
 b=giJpWzHSNljkmS2y/V9Ijhy5Pp6iMc69YGOMJVGR5KFVa/Dks1/HaechOvRYMBZ0+B7p
 R5l7xjpoeDtPy4GngjzKuavSktr2rX62QX6BomRUsvPgU+bjIP2ls3C9Yn5SZErdPLRT
 q1ZqHA/HEE8ev2NfEdlsP5dbESOhljNm3wHl2LxbeUu86yTibKSt7xJo9i/wNkDYtUun
 rk6V/Z3mOwRGHo97QWU4wgXTkCUj5f1/ZPu/OusX6Xp39UGQ7ft5RM2PHaWiIY1jjYoD
 jkd5axJEtFQqDEJnVL30dsIaJ84/2COjtJ7jUx4rSEU4Ld0QGTABbzBxQv3yZ1EE19/I cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nb3j6ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GEk8FE147294
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 3e8nvsk6xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 14:47:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPP+Q6dF5YJ+7+pN9m0rNhzXneW3MCRAymD6z/vSu5fHRYfPsCbhbUWwZU6H2JyYrepKl9fF33JxRbNGQSVDJ9++Rx9HQfdcUy7Nl0tFpG8qC90EOii/+gToRUIkL7rChBXJ39QGUppVxHn0icozrZAEQpVOVfct5wXasQtkNw4JnW1nc+03CHOZeuHsHwXmK/iB4fh7dfr3V9+Q45uiJmd2BEEfmzwx/niX6mMTdGX4pviqoXXlXczcGDXV5Y2qcMy+qf2vIVLyZU1o/cDQONhWwJoZjbeSsqoRx+XAWEmt0GbZhWM8xytbAB3NbQLFLYYzzVsMKIeHL0F74gaKxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Js3msEuxgpXPJ0wm72/G13vu1NuWrzRyN4gO2DPk0o=;
 b=QO51wjJJs8oRHWQDl+f0/MBy0ly4LnWEHsYZFWMfDRKFiD29oIs+ExJzqeJDllzd0JIooyLSCG3fU+awGxo0PQbAsIMMxs7gQG07KCYD6RLIrMttX3ZbjK8z8tqN3gKz6DnD3b6xcLFN7KgrY0XvaM5pM/ZyGdc6ZUy9cvCo3e5ToERhdEysQgTFZEsGh9rnjpIDC/7UsBBPwHyvqy44acZbbhAo/f1Dp+OKvPnKB5iNexpTfs5iMn0tGoD2XdT0it2Viy1AxXbeADzVpC/jkGZtmaMjSzdAQ1yvgHajCQTGSzHB54ZI/7F/E1VXyYt/yJy0PsU+mtkQ1bVSaf8hiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Js3msEuxgpXPJ0wm72/G13vu1NuWrzRyN4gO2DPk0o=;
 b=MKFnE5zSkj0y84W2CqRO7heqmA6yfQq19QS0fUAcHdmaSUsBF+eZaxXW0FM29+FU79wl8pdu/1oTwr1cdz+OBABS4PAhVv+EJZzaRUlp9Wiw+2x56NICjmYNkeD8Aef1DO8pIVbFpj2kdpWVjTSK8/r8JqHJJrpXJ2dYZJPhIBI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR10MB1737.namprd10.prod.outlook.com (2603:10b6:4:11::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Wed, 16 Feb 2022 14:47:53 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 14:47:53 +0000
References: <20220216013713.1191082-1-allison.henderson@oracle.com>
 <20220216013713.1191082-3-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v27 02/15] xfs: don't commit the first deferred
 transaction without intents
In-reply-to: <20220216013713.1191082-3-allison.henderson@oracle.com>
Message-ID: <87iltej2b3.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Feb 2022 20:17:44 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0058.jpnprd01.prod.outlook.com
 (2603:1096:403:a::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bbc9bf4-1db9-49cc-9de7-08d9f15b4ff4
X-MS-TrafficTypeDiagnostic: DM5PR10MB1737:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1737551648D0607EBEA1508BF6359@DM5PR10MB1737.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:341;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZW9dbLwPR0VqJwCuXzLEYVRsl/5Y8Jtc5PK99UwXfc3RT70atwLPQULx6uxDxpkDWFw7zLwEudtE65PnGU1juYHVPzO8V/CBB4R2JbWoOxx2yUNveWwjq5RV68Xa8RTp1a+6yh/jf5tmIA0DIV0aQUxQZnh0B64p+c0jbQqLOM9AR8MqhEn4oVzgrMoxnScwldNPzQNZpZuB2U/zTkAgh741Y6Y19W17vd4EzyyyqXVQT8RQjvFJS/JbnF6Hr/g3OWKLJrhsMXKyDv+PmHX7qqO2YJQr2f9a6icLe4EmvP+JtMjgRJNka82P9eyUmLSVPE9f6dKP8kmph25sbRNAK9WGw9Gs51do/sJhFWn4JGB4//St8uq7w5v6SeQc4OhxK/D1ZvD9qgqf9ZAFJM7a/0l/WCyCWgIn2POvDZF9pMFPEhiuxTdXDkUaUC8qzKSdyuB6cJW+Ics0bNpn1uetto5CH6YcW3TCGksB8FnlUMgxNzMf4rSmOSx6N9ZBP4AvqHrJ4VdgATA912DHhj2CgSIv+I6H+ZK0wsa9ruXBofprHUs+2+N3OhPQbkriErGSgGm9HjYtMudSf7lKp2HKA0rHL+529Ug3wU7k33bPod/EMxoABdIt/nL4uixQBqp1nvzGp8QBjHC46Dgn88L//0UcLQkyT5EOU7vFcmeS3msSxWmBRI0MC5mvOPWd13aUzvDHixwoVk8FRxoIzO7/T7XzUnt6rIPXg2e+XvCR8exNmSDjhZHjTeUh/bJtsoD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(66946007)(4326008)(86362001)(186003)(6506007)(2906002)(8676002)(508600001)(6862004)(9686003)(66476007)(5660300002)(66556008)(6636002)(6512007)(6486002)(83380400001)(26005)(33716001)(38350700002)(38100700002)(6666004)(8936002)(52116002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kMpJAwi33cs44I/aruUerqlvMpDcbifIkCkqDvYl1XUDv1w9NHrgNyAC2/Ec?=
 =?us-ascii?Q?+R0SgxmT+kTwkeQ342HtkyFK/4qs3sIJ6NIWcshk3dOgrMyWJoSBk5AEoeWP?=
 =?us-ascii?Q?rvY43JaezNb4I2YjBZp9AgBAOmqTqfOA9z1htQmHkStE8z6xC1smrN9FH0Hp?=
 =?us-ascii?Q?/hKQFO50Vr+Dc4f8e9QkOqpXzmrWkYyoVdBFWtxxC2gg0/okqgkgsgLlcDJo?=
 =?us-ascii?Q?Co0oEvgoGBsOf/zhbdIIkPxrmmtkM2aW8kkOn7mYVOzzCjZ4qpmAvNRjBKCq?=
 =?us-ascii?Q?0Uj1L65uYv3imMLYtRwt6GzO1gcgTAHS43rEnTcLaxOrEyedAv8tF3pWP3ep?=
 =?us-ascii?Q?mvsqqfkhUjagDkgrbbXrLIlhZEEwDJSF94I17s7RrZ9VmbFjlLBPa7FfWg8E?=
 =?us-ascii?Q?+N9nwPmoLAGpja4fCwaAtIubqL1q4/MwhruTlWCF8qQzgsKMBZrIHfziA9xA?=
 =?us-ascii?Q?R9B4AIfEAd0Q5Otp3xT+ohp6q5b7SQs6MkR1r8mkIqJXQG+74RCrRKkeeqcR?=
 =?us-ascii?Q?LuG414q1xd2W5Hm3xJVAFUYDexbXqRcLp0ubVbn0W28QEMSJ6ctXXtJTvudr?=
 =?us-ascii?Q?cq72NY7aiw8856VaUqI3FpyEBWPePGBn4sIxaxd6NuJ0/YIhrL9f6yG5lbHq?=
 =?us-ascii?Q?zCWOK15WaW4U8VDjmy5KrvdCsndbwt2Ck4DrpQ5dhU5CbhNrSBFpZhpAAhYX?=
 =?us-ascii?Q?kAWYZ8NLfGKgUo/wo+0F37jIObMyXHxlK6SejUuWJJgekVqgASpgoSR/mTp+?=
 =?us-ascii?Q?VvnKRtlTelQHVmRLZF0yG01R15rlylvjKEGf87h3tO3EQWSza620a1rfdUoK?=
 =?us-ascii?Q?AbRJe9NWVSRlIqH1T40vBXlIJFkzSXqVCQsNGHrNCCrtjpSEpbg09Hdfb0ao?=
 =?us-ascii?Q?ux9Rel48bDThO7YbJRrt+AUI9GQc/eU9DEZdI/8/KgNDRUdiP8pjLTiOUhqv?=
 =?us-ascii?Q?dgXbubbQd1e/e+NnJOtmQ+CJqnvhcGSF2o0eJWIB4jtjIkSbocpdRkFiNLbe?=
 =?us-ascii?Q?wq6RMRPE1N+nXbAag9iezmLKmRftI8YTUDZ3eXCyua3xJkpIJePmCfiXTSBW?=
 =?us-ascii?Q?tnUcb3/jke0BaZEyNUMIqL8INJl6wwc/NNhscsE2gE0IFpZKCNuvAi36QGwc?=
 =?us-ascii?Q?4pLC2B4Z14I4B6DUQEh7aDFE7eMu06XZ4bJXjeyrJmP+ywKwliOhTlRvfy/5?=
 =?us-ascii?Q?OnogY5cfoXAen87nfJBMVgus7F1tSHB7xXWt81pDKp1JEJb9TRUMwDWzVUwh?=
 =?us-ascii?Q?qd2vleYC6lmMwDXbhuFKXKxjeDsR62pbXUrtjllPR5AqHAFGNrZUr6DnLiBe?=
 =?us-ascii?Q?IbNkJ9mqbX7ZG+aTouJdWyKIwejMZKyccoZdkWH9e1QupfWcj1SsLjWGF92n?=
 =?us-ascii?Q?DE+LEvNNvzP0/hGN8evGBMMrsfR3L34sgIofICXbTcmN8CCvrydtw0xiVfuV?=
 =?us-ascii?Q?Qye/Zn+HHvyj0fPqDsZP0ywKxMhgWKmtolPDNwJ3M3WLvRKPHHoOULFJaz2P?=
 =?us-ascii?Q?j38OBFD9kpBBIcfFKND5gO9Yn/rusHBVgQtHxwX+D7vOuxzpp6G6T0+JiUqn?=
 =?us-ascii?Q?LKTV1GVjusKa8X3ffUSuipR+QX5HlvR7UOGYOZfgbO9oF1C8Av7QrMN0Uudz?=
 =?us-ascii?Q?AkBCnkiC7NOb66IAw8DTTR0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbc9bf4-1db9-49cc-9de7-08d9f15b4ff4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:47:53.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMQ3JkLNbhRqY8ZV9RFAEo85p7h3np4797i+sqmOpQ1MRLu1L9Sb8hBYzpXIsvLBUDQS/uqIAmZmdq/V14syBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1737
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160086
X-Proofpoint-GUID: V6KIFM64qoBkGv6l7MQlpahbYTXj2K3z
X-Proofpoint-ORIG-GUID: V6KIFM64qoBkGv6l7MQlpahbYTXj2K3z
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Feb 2022 at 07:07, Allison Henderson wrote:
> If the first operation in a string of defer ops has no intents,
> then there is no reason to commit it before running the first call
> to xfs_defer_finish_one(). This allows the defer ops to be used
> effectively for non-intent based operations without requiring an
> unnecessary extra transaction commit when first called.
>
> This fixes a regression in per-attribute modification transaction
> count when delayed attributes are not being used.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 6dac8d6b8c21..26680e9f50f5 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -510,9 +510,16 @@ xfs_defer_finish_noroll(
>  		xfs_defer_create_intents(*tp);
>  		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>  
> -		error = xfs_defer_trans_roll(tp);
> -		if (error)
> -			goto out_shutdown;
> +		/*
> +		 * We must ensure the transaction is clean before we try to finish
> +		 * deferred work by committing logged intent items and anything
> +		 * else that dirtied the transaction.
> +		 */
> +		if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
> +			error = xfs_defer_trans_roll(tp);
> +			if (error)
> +				goto out_shutdown;
> +		}
>  
>  		/* Possibly relog intent items to keep the log moving. */
>  		error = xfs_defer_relog(tp, &dop_pending);


-- 
chandan
