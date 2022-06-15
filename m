Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D7AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 22:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242636AbiFOWcO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 18:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbiFOWcN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 18:32:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7003A49258
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 15:32:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FLcXYG009908;
        Wed, 15 Jun 2022 22:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BvgGBiIM8uCqS8Trq23AAsQyk9NgzzdMLZlx8M9JJq0=;
 b=FTrPJ0aZFz3FE4P6OBNdadQuaeGMkFZEW9y+fX43Uv6NlC2750l2n8OfOtJPQi+F/qpn
 /DX04eVJ9mcBJjzSifoDrv5LqUrCAOXGq29YlP2FUYiI5v9ocRk7hRoi7ExlwC8MEXtE
 tcOHpV6X4idzu+L37eR1HVD0gHIeiRqzCWvYOiaDajxmNAf/DhfBIJWm4jLYw+bCR+RN
 pIgu4sTSjPSnkefCGfG5wSnBiUSSfb1PRn4In7C5D8BxvkD1/YyDlUTe1wpwntSC0YjU
 kDnfK3s9278R+Wi43GFqgi6w0yondDICSRP3ILk0mvmwY4KHPkHOwr/ugLobI964XQdc qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkkthsba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 22:32:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25FMGFQx019160;
        Wed, 15 Jun 2022 22:32:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpr2apbr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 22:32:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hi9MaLLYAhET1dH9aniWyceIkQ9kF0fNtr6DXdz3aqRHAUH+gC71TvjvNZDfrOpM85rpdfAM+EZeHNC4gL3QV/A0Ul1WbOhgmgq8+45Y9vq2qfCkAN2Kcmex2VUUGKLIif7ubKO7t+W/SzF+QrwICiNdSO2I1rT5AGarJ4yoyKMj4MgmZjrtp38gmH9pL0JWP969l6jJd5Dy11gdWAKPEFOBpa5rQyfX9r6XSXVJ0RVWhuz5VPdPkn7hUIkXazwZcCrTR3Wlf0Hoic/5SSrLNpQz6udILL+DrdIexSy4rM7SeERd3pWT+sc3eR1o8qK/TB2190syTkx0HDHRDw49gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvgGBiIM8uCqS8Trq23AAsQyk9NgzzdMLZlx8M9JJq0=;
 b=OPjNton2KDlOeZlcUTzYBpBbK6I+CED1gQ+pYNYYoxVaq9unlYKGRdnuM1zgT+pILJMyvmMV2bGbubCqZAHEuLTIDilmE/bWVVx8jmhyFLH9x1B6JMwsIvphi24mGDYZ93Epif1CBxnJa7gk5DQx1gbmK4qq767RKoG0zvR1STzcjtXv5A9ci0WB7DcI2sroy2PcuTHL1RWz0ap8cXlM8QyQNDFm1QEAWfT1QzlDFkejKbPztodijQcEhhLlCdEZ8Lzt3eKLHURVWwhNENCn4J5uadK0yZRnaJmo6kThxcgGR1TY6Axc05voUxA+b6p+QYVfEcYndnGbznS9NX10GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvgGBiIM8uCqS8Trq23AAsQyk9NgzzdMLZlx8M9JJq0=;
 b=zrr1HwPUjeyh9bEKtCck8PhXkKuBJ+PgGu7VROad197K0kZUoLH4jAoDESciyIeG5oj4mhA/aLDknqOTg4iV/t6k7Y3HvAcgu0lFHj+JzIxj9C5t95G4G1eOZB81vJ4OJkT6ZDU4OXxX4a3QlVZ8uheHe3MEzxN3oFfqngdUn+w=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5141.namprd10.prod.outlook.com (2603:10b6:408:125::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Wed, 15 Jun
 2022 22:32:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.015; Wed, 15 Jun 2022
 22:32:03 +0000
Message-ID: <63d2cfcfcdb649ff1f3c1e509928eaddc5eb103c.camel@oracle.com>
Subject: Re: [PATCH 2/3] xfs: fix variable state usage
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, chandan.babu@oracle.com
Date:   Wed, 15 Jun 2022 15:32:02 -0700
In-Reply-To: <165463579422.417102.2354416446860242047.stgit@magnolia>
References: <165463578282.417102.208108580175553342.stgit@magnolia>
         <165463579422.417102.2354416446860242047.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::10) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdd30658-f976-4adc-a72f-08da4f1eded8
X-MS-TrafficTypeDiagnostic: BN0PR10MB5141:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB5141C1F4E5C3573169738D8C95AD9@BN0PR10MB5141.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6l38U8OO+qRSEk98l4FXo6lUnddGNEsKWZGYvDqtEJIVGLJ5Xh7q+77SUcl8PaQgYxk3I8OrsaoZCU8VAdFRlkvYgQcS0iL+uUXon9XkpB0ObV00Wi8+FOWVbGvFjeSLMzkG3gWoGf8sdjFTzTP4V60DDyMqYOD0RdqjS2xD136pBz7gSP52lZyFMXuBTLxx+ZoeY505i/xdqyRoDbrUaVHJ04k9RVsB6G4m/EnrSGJxw/zWIqrKvBuVjOGFATAptJ57Krp/fsVqSRWD4R9KmXbNFtuj0bU8WoXZVHtgbWrzhL5Hm7jaBFKbeiwcYhVFE7vdR8nU8E3PRKah4J7h7aVubl+modD3cdjoGM+92/SAkFkaqxlALIUwXcanz2Ui7Ziw7m4RJdcSW54gKaeILTLKJDCzS996vWn+6PIKAwGzefuKqAI9F7zN4RuH8Q4n420Oi+lKLNiZ8manYb5ofg/3SerfWISIEo94zwhfJ0byzwV3uVvIbuo6iabs1+Y+KwGtWPKIIulCaxqoa/o0m60byCQ+bCRtoDftw41kzuJGNskD4nc5q/9bojlMAcKTgHERuPRAaAQFxm71ZtFOJJ1T0lIZO6MnMmx1VkY1gnAfCM+Gi/y9eCTvTDPQeK2F4SNZq8GlH1kxQtS4DZWaH2J3x63T3c+p4VBVP3BobWmd1AiOulc4viH1OopEp5negwvV7HqMyuspLtzQo1G0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66476007)(508600001)(66556008)(8676002)(4326008)(8936002)(66946007)(5660300002)(107886003)(36756003)(316002)(6486002)(2906002)(6916009)(2616005)(6512007)(186003)(52116002)(86362001)(6506007)(83380400001)(38100700002)(38350700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUhmb0ZSdzdadjBVWkExeE1BRGY4M1RzYjhYZGFwaUlrOEVPcW1hclQvWWR4?=
 =?utf-8?B?VjJHOGZXcTdsNEZZUjRTSzZnZlhnWXMxcUw1NXFma2pMa3N2aFRHV084M0lX?=
 =?utf-8?B?SGMxNUIrVnUxSXRBQkJxMEEyTmlhTUcvVU1FRWlEb0NCOFUvSkIzT212OWMw?=
 =?utf-8?B?aXRjMUV1bUFqNEVHajRrdGxBMzZIa1VPRDVCT3diZUE1akxlQXQ5QWZXaU5n?=
 =?utf-8?B?c05Ra29NS3pqSEw3SGhpODl4aXQxQ1JRSkdaOXF1L0JXcVVCVG52SE05OWVy?=
 =?utf-8?B?c3pHeXpDa1VuSFkzbDJPa0tQSzhpZ1Fxa0swM1BXdXpicmRIZFhacmMvLzYr?=
 =?utf-8?B?cTUvdDB5UlhMMHRKY2RJZmlVOXE0R1draEJMbEM0ZmxZNTh4cHpPUldtZ1k0?=
 =?utf-8?B?b2lySUxiZmZEL3hHUEhmSE1UdXk4NGlpOUM0RmpYK2cwRHlmSVRsVHVwVzVT?=
 =?utf-8?B?VDV6QXpOdFU3MmpEcVZ2SVdZTU90enEwL1FoYXhoUXRsVmdMdjNUSkxTYWRo?=
 =?utf-8?B?aksrTUNBYkFGZGxYbEh3azRuMnhQaW0rUUR5aHQ5d2duQ09iZ0RJQUhObkdX?=
 =?utf-8?B?YlEzd0NDVHI4Z1h6L0N6SHdFYXlNZ0NCZDBzZG5NdEVWZzR0V3ZobzVMbVpC?=
 =?utf-8?B?VTdIZTIvMDRPV3RDSjJyYUdheEdLSUx5ZmlCR0RYdXN0TlNnbEYzb1BxWFFQ?=
 =?utf-8?B?ajBLRTV1VkZFVHczVDhpZmhyTXc1ZGRiZWNabjVPWDJNbHlTQUU5ZERaYmtU?=
 =?utf-8?B?bGZEclRLQVZkbWdUSzNja3dOcjZ0T0pubkcya0hJM2VqT0xNSzNEc0NRQ1VF?=
 =?utf-8?B?aDRPRVVUOTFPV2VpbFJ0UkhhbU12bENGRXBEMCtzRkNWVnNpRkpTN2hmaEpi?=
 =?utf-8?B?ajE1NlRWRGZmMUxPamdVVDVPZXQvbkFSOVV4TWoyWFRmSlB2Ly9OUGpBeHBV?=
 =?utf-8?B?Z2ZYMVhub0xwYjBjdS9LcEZsRklua2xpZE5lYVJJNG14d250NXFUa0dManZs?=
 =?utf-8?B?OWRwVHBvSDd6T3RsTHRELzNib3kvZzRBcDB1MmRiNUpUV3MrRTVhYTQxUmdK?=
 =?utf-8?B?OXZMVC85VkVnNGNrWm9kM1NzbnB3Y3ppTGgyVlV1eFBRZlAvVUY1ZC9HYWRU?=
 =?utf-8?B?aWl1UmpHVDY4YTRkdXB1dW9oRGRPSWFNdE14MEFmWHJWRUZrR0pHTG4zMC92?=
 =?utf-8?B?VWVTT09ibjhEMm5sMC9ZR0tkbzNBS1kzZVVUWHBZSFowVzVWOFlEMHV2VFdi?=
 =?utf-8?B?UGhRZjVjOUF4cUFEQmV2cHFYOTNGZmlENVpyVlR3T1lpU1ZPYys1OVNwVFlP?=
 =?utf-8?B?bUFMenI5VTB5OU5LS3djQzJmYi9rNmJuTDlCNHFzMExHM2orTFZJL1gwdGlo?=
 =?utf-8?B?WUVqdXQveGZ1eFlWQVdGN3c2SHRZdDIxeFlkRjF0ZlFDTmJDK1grUnBNK3Yz?=
 =?utf-8?B?TFZraXZiT2NkVVVyWWJ4dGVmcC9kY09INFpONnJlMlZieEtJSVVZTnN6NHlP?=
 =?utf-8?B?WmdMckF1K3Mra0J1ZStpTGd0ZzMyUzRobVNsc2svbUdjRjlLb1QvbXhVQ3BL?=
 =?utf-8?B?YUpQU3l2YmlVd1dGQTZsVWl3Z0V0SHk2TktFSGFHdGdyY0NNSVcrNHZNZWZX?=
 =?utf-8?B?ak93NHJraDVYUERrbm51YmZzdU9VSDlRbk03ZmZHSXRqZXNEVlJzRFZZZjcx?=
 =?utf-8?B?NVBBa2hSVmM2TVJGcHA0eFFTV0NVbTFDMU1oTFZWLzI4anVDZkxUM3pCZjNG?=
 =?utf-8?B?TEFxTHdDcU1jeHVVVVpCc21PVG00NjNENGhDcVY1Vkt2bXBNQUVjeVVlc2RL?=
 =?utf-8?B?dDg2N2dhT3lONXRrelZ0cnZFOERkTkdCS0wrT0xiMWY0ajAwak5wN1cxcTBY?=
 =?utf-8?B?VmxNOWJGM1p4aDJOaTZJOEtKVnZiNlRTVkRSeDVuTDRUSzdZWlBCcmVuaWxT?=
 =?utf-8?B?Nng2Q3k5RVNjRWx3a2ttcnMvaEhnbCt3UE1LcGNORDlSMmxwOUF1MHhLUWRY?=
 =?utf-8?B?Mnd0aVEvWkFnTzlvU3psdytiVXIxR0didHJic2FLbjU4Q1RCc1ZaVDZ0azIx?=
 =?utf-8?B?TGNXY2orNHVNa1VQRFQrdmVpVU1MSjF2cm5kOXB6dm16SXJJc3N2MU5TQVo4?=
 =?utf-8?B?dnpSTExjMEQ4b2hzajF5N1NIREdieFJWZGFjWXE1MVpFdjErWGplaEtkUWlk?=
 =?utf-8?B?NHlNQTJsL2p0a3loWitsSjF2UmptSmFkekltRWxWMFNaQTd5WHBrWjRTcVNl?=
 =?utf-8?B?LzZtTEJFWFFFOWlIZEhOQzRRUUJpbklDSUFNSEZNOE9nNUUzbG4vR0c0aVVT?=
 =?utf-8?B?cjdNcVQ5dEoxbmdEb3dIZEQ1aTJ4UFdFeWM0M0JtSXhhQ2Y4NDQrZUVTb1NN?=
 =?utf-8?Q?PEZglH9enrzJDZKc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd30658-f976-4adc-a72f-08da4f1eded8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 22:32:03.3793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30AzH3H0+COAzACu7Jdd+swPKLiNdcDCJ/KORcn85NDHeaL1Xv7gGMr7jQcIrGcl3mMTOCLocQwPrOUhaxF44X6hvpgJLzmO0T4kD7DO1Eo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5141
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-15_07:2022-06-15,2022-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206150082
X-Proofpoint-GUID: x502vb6G7HGURd9fMHsuMwD4JTLoTVpW
X-Proofpoint-ORIG-GUID: x502vb6G7HGURd9fMHsuMwD4JTLoTVpW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-06-07 at 14:03 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The variable @args is fed to a tracepoint, and that's the only place
> it's used.  This is fine for the kernel, but for userspace,
> tracepoints
> are #define'd out of existence, which results in this warning on gcc
> 11.2:
> 
> xfs_attr.c: In function ‘xfs_attr_node_try_addname’:
> xfs_attr.c:1440:42: warning: unused variable ‘args’ [-Wunused-
> variable]
>  1440 |         struct xfs_da_args              *args = attr-
> >xattri_da_args;
>       |                                          ^~~~
> 
> Clean this up.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0847b4e16237..1824f61621a2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1441,12 +1441,11 @@ static int
>  xfs_attr_node_try_addname(
>  	struct xfs_attr_intent		*attr)
>  {
> -	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state = attr-
> >xattri_da_state;
>  	struct xfs_da_state_blk		*blk;
>  	int				error;
>  
> -	trace_xfs_attr_node_addname(args);
> +	trace_xfs_attr_node_addname(state->args);
>  
>  	blk = &state->path.blk[state->path.active-1];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> 

