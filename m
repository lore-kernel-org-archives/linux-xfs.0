Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAB2C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D85C564E6B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhBWUUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:20:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:47600 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbhBWUTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:19:44 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKItSr159134;
        Tue, 23 Feb 2021 20:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8opMjK3NwnR+GDhIdj1pgQOCn4eJ0RA/YcXqqz5WZD8=;
 b=T0byXTKVoR5kUuB6cR6Qhr5yq5/7qIRkvKaE1LihtOD/9nQXfohfq5kyrFFKy0TjqkxA
 xVb/v2ZiYffO6NGOFIjn4CXh70z310Pnt10LQiIbdc0YeGlOWLMGgN3BJwG8jOG8R5qF
 CGqyyS4cKookB+3Ij+vPh6w6iFZsMRHk6bO5cmMPaim8M96ugj00eP4lHTJzykNEGgXS
 FFIB0yl+1E6ZRsrIBvUegfeXmo1IJIaMQ19OTNQgRaNVhJRc8Af44oLTSXTkkECkccwJ
 dzCirtX47BqpjriUXo4DybgvnlDnUZb2EcLDz+Z/eRIvymiAPqKlgyBjqAt9KHOYrVqT lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36vr62331y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKA8q7116574;
        Tue, 23 Feb 2021 20:18:54 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by userp3020.oracle.com with ESMTP id 36uc6s80s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkG70iEh/tXPDDWakZGawIECJrBsUsvkb8sUrU18SrqmsKMy5ha86SnaRYMntZh+ac3RLMH521hs0go/WL4hH7s3hJLhzLfE7w90oQ9wgWDOv4BXsBQruXyJiAImMZWm5423+cc+BZZhD0QOMDY/OW8J4TaEB5gtKezzOdYYdaLgV5LhJ9xdm5Ki2/J4w9Oo9VE96SaMsyiPnBskeyogWi09/wuGK96q3fleDQtsW69V5Tkegh8eQukuNFszYsaDUMOFFhepdfQlZECk2C1PK65qpP1PDUDc6FvcIqMxxm7+BXxCwB+wriP3ID+SZ0Sib46LeY3hsYQzLag3U0F5pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8opMjK3NwnR+GDhIdj1pgQOCn4eJ0RA/YcXqqz5WZD8=;
 b=SHTlEsfmZyv2DPHFnfNBLHdmos1H1E5tIQtj2Yto1cHFMGxb26vc5sYchrVbSFCPjZiQHdkb4Dl3ffa30KtttktPdeTRKwY0HUtQfCrT5W7g2PKALM7iOWewOLPXKJrdq3rYrogGMccBO0yQDgS4jVelSfa+yDNjQ435YWNu2e7fmmON3M/vwZFrjC/gtyBAnaaaF1QwWEZRQOxrbGs6Ay5hP9i4HFnCfEVrqm9HWFSDb0VIOlVsvC6dunApfXt2/XG1ERpQ6HBWsGgjeiYElG3An9fvN9dP/eyFDk1sRWra4VVr94IndDoZst0RxgE/VcDVeNHDEP61NJRgF3XZfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8opMjK3NwnR+GDhIdj1pgQOCn4eJ0RA/YcXqqz5WZD8=;
 b=ZDFWEUvfR5QRSiJDmCqZ8mw7J2NKGBM7rdMwymGgO098m3OsGqDAeAYKb1bDVKnxXgABFiFq2iieWc/8A1D3nZ59XBxUItB5pUzOSFy/AmqoCxBn89ViF5RP6FoEN0SHeSNua3ukzqm+n+6n88h1FflyGbUnflr1Z/2Xjq42YyU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB4876.namprd10.prod.outlook.com (2603:10b6:610:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Tue, 23 Feb
 2021 20:18:52 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:18:52 +0000
Subject: Re: [PATCH 6/7] xfs_repair: clear quota CHKD flags on the incore
 superblock too
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404925290.425352.17614643483707405953.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <8f618e7b-bf7c-e711-cf4e-760299f364dc@oracle.com>
Date:   Tue, 23 Feb 2021 13:18:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404925290.425352.17614643483707405953.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::12) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR03CA0002.namprd03.prod.outlook.com (2603:10b6:a03:1e0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 23 Feb 2021 20:18:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04649a51-1539-40b3-e675-08d8d8383ce0
X-MS-TrafficTypeDiagnostic: CH0PR10MB4876:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4876A25982B1905F9C35CD4B95809@CH0PR10MB4876.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0L+3AuSCqM/jYbwdewTeQA+8uqOwNefP1duakHKUYHx5cqoztX1XYhQBWaY4KG052T3mcRmRJeErYlldv9LSiIZ2d7SUHG7Z2zAT5QfS01epznwI2ZwdVdZBl36Fnn2Vs73xFk+mpQrlWlPDMndSVQYhIJGOVl04WTxd8ZgPPohwKleupzU0CKBBQ5ImH6ACuIBdsy0rOJe/yaMG5LhBKwPoyF1PIc+baWKeSa/RYoULinTcb52gijNnTLUOdA9gBpOeMsYKh5OAusv8r6JFEXp03aSERTNb167zU7+eQTLHdtOHK6b4dS8h5lBNOw9NGaE660THxbPdv+t3JwstHxaQhtnQesgUIXjZj8Kcm0+EGTQBXRK7bJpMveiJFzc+cniWhQb5Grf1zGSQjaHwZdw+OEoISvuzQ+8od9SNWTMNM1DO8pIv/SpdIXitykU5l35v0jUF7U2O9Bh1PCxU+D8R4iZKaRqUOQTzlassh5RgJ1Se7wAmMcMzkCAs0l3EddVgNoegPbplezq7T3kSNH4k1rrAlIE3/2Yf9WiTUPLMP2GaBKeSvpu3Ql5ovYaDqznhADWvLDdLGq9VD7QyVt6+Cz4/3SM5gPA6tF/9JmE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(86362001)(4326008)(6486002)(83380400001)(2906002)(478600001)(15650500001)(31696002)(31686004)(44832011)(66556008)(5660300002)(16576012)(316002)(66476007)(66946007)(36756003)(54906003)(8676002)(53546011)(16526019)(8936002)(186003)(26005)(956004)(52116002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OVFLZHNqdjJxeURWalZEQ0pLTDBCTnBTeUl6MFZqTUwvT3NqUHBUc08wa1hR?=
 =?utf-8?B?ekZhcFc1UnRybHRaeEo5LzdpdVh1ajA5b2RSaG1nUlVqRnRwcnk5TkIwM2Fv?=
 =?utf-8?B?NHpNMHRla2gxeFQzbFphUU9MM2Z4dE9NY0k1WEJLbk1IK3JBczlmN1BxQjVr?=
 =?utf-8?B?ZFFTbU00R3hmWlE5R3Y2R2VieEdEajVMQmt1Sm1tNExVZThsUGl3YjcrcTAz?=
 =?utf-8?B?aXVqM21DNGNjem8rOHVQdktqQTBFREhDV3N2ZkdaVEZGUDVIcDhqRzlGMk5W?=
 =?utf-8?B?OWtiTmxWTDRwSlc0bmRhT0ZYQ3ZsZ0RDRmhvM2ZsRy9PMDdwcVhJNEFIcy92?=
 =?utf-8?B?QVN0VmUrRmpTM3F5OC9hWVpLT1FDaU1QdTZNc1ZiVi9lT09hWTBsS29JTGtv?=
 =?utf-8?B?eWRoeUp2eit6aDY0Q25weXpWKy8yZk9VU3Vlbi9OVVhWWFAxbWZzVmNMVG5x?=
 =?utf-8?B?N1ZCVE9LOVRzMk9QMFNpTTdXQ1BtZzdCdFVKZ1oxTU00OVhxV2JqNktkdzAw?=
 =?utf-8?B?ZXkrcVpNL0ZCYmc0N0lGN2FpMUF0dWRNTldBTnU1RGh5YWRaU3FFN2kvTWxX?=
 =?utf-8?B?NWsvUjBFTS9JWEJhRllkTDVZZHVMN0oyZzlnbXFsODFmS3RtSlpUdytjUmVs?=
 =?utf-8?B?bTV5RHg1cmxUT3VQRkk4UTk0Ukt6SEZPM3dXNmUza2VDdGlqemt5ejd3b2t1?=
 =?utf-8?B?eDhGeXc2RGdWSkx5ZjAvbkxCd3YvdFVGUGFEdHc2eUx5ZXhiQURjbVlHc3FU?=
 =?utf-8?B?V2xJVmJqclNyT01TS0FPcmlaek9HOXJMSiszS3JDZmtsRGpWTHBQQmt6WUEz?=
 =?utf-8?B?alBUUlh3M0p4aDBqaDFCMmlPZEFHa2RuZGR2QmxOdGpQcStERnphMnNyaDg2?=
 =?utf-8?B?Zmk2RTJ6ZnBTWWlDOGFVNjByaW55NUpIODYxbnM2SzdmN2VYWW44UGQzWEwy?=
 =?utf-8?B?QW5rVUVyaHBvY2huTDVJT3lFV2MybFA0Y2NUaGU5anJRTE9VeTI1UThZc2J0?=
 =?utf-8?B?NVFRcjZ6Y2RwT0ROYUUyRkNmTWxSUFdobm9QQ09tUUFvQWRDNFhoUUVqOG0z?=
 =?utf-8?B?ak1pRmYrSGpQOHVJcjNpcjN4ZFh1Q2xjcTVaTTZnY2wwOVFzeXdLUzlob05v?=
 =?utf-8?B?VUdPSHo0Y3BNT1ZWRHB4V1lLaHFkZCtYN1JtT3ZiQzhCd2tuOE5wOFRmL3Bv?=
 =?utf-8?B?OEY5V3V0U1VuYU9Yb3dWWmE1WEgwOS9aN1YxVnJJcE5DRGhJUjhMQ3NTSGpZ?=
 =?utf-8?B?aExWVS9oaXVGdmNEcjFYMUxJd0JYWEY5UEJpYmU5WmZFamFncHF0Q3ZvSDFJ?=
 =?utf-8?B?QXNVUUdZLzV0ZmZuRWdxSnZpUCtCTDlGaG1SMlBLckxiRGVGclhPM0ZXU2dR?=
 =?utf-8?B?VzV6aWdVN01LNUk0MG53R2dNZkx5QXJzOXBscEVSVjZvYXphZGtpSytucjZK?=
 =?utf-8?B?QkZjTFBvU1J2eXJxWXNRcmVJMGZMaDFKdVg3djFjR1VWZlk3L2U2dCtYaU5T?=
 =?utf-8?B?N1N3Q1M2bWxmeXJ6YW1QdUFRSGNwTk42eFdtVWpNZWkrbWErT2FyYXF4NVdw?=
 =?utf-8?B?Z1NTUXovMUNNUW5RTDVPWW4zeWpxZUR0WTF3WXdhNzZkS0VlcXpCVkdDZDFN?=
 =?utf-8?B?aGFBc1ZzTER4ZlQ2dGJWRDJ1UnRSUW45d1YwQ2JLbDdxUkxxenptZVVzQlgr?=
 =?utf-8?B?ZWZES3F1bFUrbGcrQWN6OEx5cnZxNUJHRDljODcxS0pNWDEvNmtqejE5MTEv?=
 =?utf-8?Q?OU46qoFpuQ1AKdPu37AsEGXA83csPMMOdOBfz5R?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04649a51-1539-40b3-e675-08d8d8383ce0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:18:52.5638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4SKObvLVoKczERpcx6SlYfy5tF2MDAWIbMOpAQ6Nw4LYqD3R9fF6oUflY2E+YSJ9QKoEN4HWFx2iJyy+IpNjb3rYvVxOZy35z2jtVnsKgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4876
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230171
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:00 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> At the end of a repair run, xfs_repair clears the superblock's quota
> checked flags if it found mistakes in the quota accounting to force a
> quotacheck at the next mount.  This is currently the last time repair
> modifies the primary superblock, so it is sufficient to update the
> ondisk buffer and not the incore mount structure.
> 
> However, we're about to introduce code to clear the needsrepair feature
> at the very end of repair, after all metadata blocks have been written
> to disk and all disk caches flush.  Since the convention everywhere else
> in xfs is to update the incore superblock, call libxfs_sb_to_disk to
> translate that into the ondisk buffer, and then write the buffer to
> disk, switch the quota CHKD code to use this mechanism too.
> 
> (Get rid of dsb too, since the incore super should be in sync with the
> ondisk super.)
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   repair/xfs_repair.c |   12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9409f0d8..40352458 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -717,7 +717,6 @@ main(int argc, char **argv)
>   {
>   	xfs_mount_t	*temp_mp;
>   	xfs_mount_t	*mp;
> -	xfs_dsb_t	*dsb;
>   	struct xfs_buf	*sbp;
>   	xfs_mount_t	xfs_m;
>   	struct xlog	log = {0};
> @@ -1103,22 +1102,19 @@ _("Warning:  project quota information would be cleared.\n"
>   	if (!sbp)
>   		do_error(_("couldn't get superblock\n"));
>   
> -	dsb = sbp->b_addr;
> -
>   	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
>   		do_warn(_("Note - quota info will be regenerated on next "
>   			"quota mount.\n"));
> -		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
> -						XFS_GQUOTA_CHKD |
> -						XFS_PQUOTA_CHKD |
> -						XFS_OQUOTA_CHKD));
> +		mp->m_sb.sb_qflags &= ~(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD |
> +					XFS_PQUOTA_CHKD | XFS_OQUOTA_CHKD);
> +		libxfs_sb_to_disk(sbp->b_addr, &mp->m_sb);
>   	}
>   
>   	if (copied_sunit) {
>   		do_warn(
>   _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\n"
>     "Please reset with mount -o sunit=<value>,swidth=<value> if necessary\n"),
> -			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
> +			mp->m_sb.sb_unit, mp->m_sb.sb_width);
>   	}
>   
>   	libxfs_buf_mark_dirty(sbp);
> 
