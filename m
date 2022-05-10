Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A15BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 22:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiEJWcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 18:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiEJWcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 18:32:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1654EA1F
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 15:32:00 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AMSXvE010429;
        Tue, 10 May 2022 22:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=F87nvOP4HcTGsA7L7z3tA3zX+piKHU7I1bCUSKilnr0=;
 b=gxYncM8cjkmm+imP4p93jf7l1hy+UOe4zBdqdx0oNHRiG8yqRYjq69wXDB8cKiuLpwr0
 bYfG6VoIrDLuSHjwcGIVTUuq4SoCnG+P+HAgYw/1RAcwShg15GCcPRqVhWbyX0UCcvP7
 z0UDxMQAqnlvqsPOHvytG+t7dA+hFpYiL7eF1hHz3r1xrGLZM+V3moh8l0gf0/DH65sw
 QKChPi5TW9niKNw8q9JRRqr7g8IBB49dQrQ86lIf7KaYSrioW+cQO6Tx1ZDbPtg8BD/y
 uPuefZKsPHBEuSwbpZIxxl1rD6YeTT61ZhkmUl7IlmwXPCph3z4uUq5K+CWRbeh7tZ2v YQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwf6c7y3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 22:31:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AMH01C019200;
        Tue, 10 May 2022 22:31:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf73ckwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 22:31:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ljd/9BNfq59GWgnIGoQlSb8347eUKFLkNKSE6biGj7oIDxoFytU8UNHT2GX2mc7v5he3o1tz1yPJUaHpBeg0tJYXOM0sG+pH0RVf5bAa/LwM0g3a4rGMxiS5GOXXt1GMyDfcEfFmpSlyurvLni5w0PQrdIolw9Jz4LRH+rXlzxXoh5E2mZcwKhQdqsciBtSMDPCCTsELbNXx9fEahsMavCjk79zsBgtJ5X+t235PmF8wiz63Txnm4+ft0TU+qBw2fVEUJ+IxtTLQM0U/qycq71TIgcqpNGCW5hn+F/XCBedJmzEYoPYcKIepaTtCvoLRJUBiq+jALPq0YfnXq94uuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F87nvOP4HcTGsA7L7z3tA3zX+piKHU7I1bCUSKilnr0=;
 b=MRq4k88fDCHqQGZzBu+7HZp95pr5mCLPlEqllkPdBz5b7bZi3WQwpt1nPZtTBQoR5xT2Ar01Y4t7J6fpjv/elAzjkDQxKwRXaXCth4Fl8fT2iLYEpoHW3ffIvjzyfWb1Oz1ynBtXo+xcR2zr0v1CGpHJwUHlOdjvlhddnbK2LbeKFNYQtPbXMwETSrI9XlPSzd6sppg/fBS7Yl9GUaUXqBZPZsBS9RAdxho+ZWfIDzp6DCnNEjxHn/J38hRIsdweBrNazYcf6OdAkrx/+UtpvegM9umOUcMRch/KVU/UanvakTNjwg4NGnIVVK2c009gay2rjBWdQGJqyV+T2KyOiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F87nvOP4HcTGsA7L7z3tA3zX+piKHU7I1bCUSKilnr0=;
 b=OHOAClPzMLbHiSakP3Sy7iTK9klDzH1JBMygan9J4nZ/8DjpCz9yG/G6e8VYMEB9GInDm2r9c2pa9kTZBJzs2khmjIW5G30ILFBfbiL29FErQ4bxhpl43S8ZJ+zpG3Cqz5C1II5zmGkbPpDkl4S1g+m3V35Wa/ICnbaQ/QgT6gs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB3428.namprd10.prod.outlook.com (2603:10b6:208:7c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 22:31:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 22:31:56 +0000
Message-ID: <b41184ad792d6d8cb406ff7bd1f6ae878be8f97a.camel@oracle.com>
Subject: Re: [PATCH 18/18] xfs: detect empty attr leaf blocks in
 xfs_attr3_leaf_verify
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 10 May 2022 15:31:55 -0700
In-Reply-To: <20220509004138.762556-19-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
         <20220509004138.762556-19-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf39bde1-60a1-432c-e45f-08da32d4e402
X-MS-TrafficTypeDiagnostic: BL0PR10MB3428:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB3428C2F7E5FB8FA3868BE2D995C99@BL0PR10MB3428.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OC0YKKe8G4p99z9aOAhNI0AQqGKfpqESb8vBtt4WgCOJo9FaR8n1uwYCA3KCUXZuP+domtL5RtBqsizFpVmidpJi+rOoMOi1KoBlfaooKMab4gA4czExI5t2PaXD8+NfcA+9+En3r2xEerCPXhnC5BxPw2sEk06TqTsFs3WvLcEv80NkxY2AsUYfodNxwjpAHI/BpxBeuKuP2HLcoGxiODNc+lqRFNsxZeEkXezaf03bHiDMfLqWddB3yP+z5V2KRX8LmvBD1QBltgub0XRD8qeIZxjwG3K2SGPs+bjDWJSu1pEK/mBo7rwKHfsFoeS/yOz4744R7i50PaLqczOITkMaBE2ctvKFnnY1aIHDYlM6f6Y7pk/ktMq5yZ8PFHFA9Wp1j9lAtlrRRPcFx4jvbcx2BZNe31ICTRTeRErqJpReBOnGWRdfvDtpmlho3SdPiXUOCoCxmqfg3bmFCUkhshTdQ8YK2mc5YbH6803hr5wI4R00XfcgCEpWubmr57BetOnVg4QraDyvSO93K7bhtSPXXzsRthrVoBqVnuHhX658nQCS6VetQZoss6X9ICDp5vJ5ivO0cSX7mU9z0K2Gipby1zZAehy9uqVHAm4DE/91EtkHODNsbFqg5+2i4ccYg8OlzGiX5eiUu83cYGS2WUfO4wtioj5r36mfcpZw5gOkC43ps4p+1CtKzPQGipw7nk3k8wkbjQ72o0jACWFD0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(36756003)(6506007)(8676002)(66946007)(38100700002)(38350700002)(83380400001)(66476007)(66556008)(52116002)(6512007)(5660300002)(26005)(86362001)(316002)(2906002)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzViY0FVNFBJNTlWZ2d6YlRzMGZEYk1VeU5qVENIdDRvaEJ3cXVXYmE0dW9x?=
 =?utf-8?B?RkhNV2l2VVduYlJIWlhHRWJxMlNLcmZkbGdOQ051bmE3OVAySERINFdXUjAy?=
 =?utf-8?B?NlZqVFRoaFdSNERNV3hvZW5TdGVweGIwWlF2OFMzczIwK1FLRGg0R2hTeGtE?=
 =?utf-8?B?YStoVVlLRk90TW5YZEtudUVYYXNGLy9rdGRYRnFwT0FRczd3RXVLQjJpK2Vt?=
 =?utf-8?B?K3JYSHFOTmFscDFFZXNuN2RER25ZbDVKODJTRHZhTkJTSWJ3Z3BkdXZIZzFh?=
 =?utf-8?B?d1E2aVBqWGczSnFUUFJNT09FVjVjdkFWUWQvNzlhSWMvVlhBRkV5M3BjRHFM?=
 =?utf-8?B?UGoxOHZZRTRPSGhnQTROTUZlOGN1OVRhbEJGK1dnSFFXVlVTUzUwMFZLaTA1?=
 =?utf-8?B?RnRWcVpSQ0FTWVdNc2xEWlgyYXh6bFdsWmcxdDdrdVB6SFF0MGVkTGFiVDJS?=
 =?utf-8?B?dzFKM1cvcWJDSEFiTFZrRDRKN0VZcmxla2ZZK0w4dTY5MlhKVlhVbmRNcW14?=
 =?utf-8?B?M2tQUkU4RjRKSXF0U0xwNWFYMXBJZkJYZkQ3QnhiK0RtNExyVG5wY0t5K20x?=
 =?utf-8?B?Q050YmlFOE1FRjFGNTJHaVoySFRYUGJ3bmQ1UTI0UjB6VFVlTUlGdDJ0VmRJ?=
 =?utf-8?B?LzBMMW5pWUtYMjdWZ2w3SFZjbWlhY1orLzliR1dVMjk3dk13STFDMkdWenB3?=
 =?utf-8?B?RXdDK3pSOWN5eWtDVlhhRTRRQmozSDdDdDhLblJmSkRIWXprRytXNXROT0Fp?=
 =?utf-8?B?cTUwUlhuaTFQUnNqNERYblk0TU0xVDZlaUc1MGNKMjk1aCtYc3JLS01PbGZI?=
 =?utf-8?B?YXBZZWVNVktyQ2JidS9hNmd5c0JjdGZCcGtWcWxUSk5QZUx1OHU2MWV0OTRu?=
 =?utf-8?B?N2lEWHN5N04xeVByUFQzSVZIYlZyRDA1Tkk0aklrUDlpRHNSR014Si95YXpO?=
 =?utf-8?B?MnVScTRNcVZqWDhlVGVFZ1ZMMzgxbDBPQkNNa3JDN1REQnBjeHR1VEJvbkIz?=
 =?utf-8?B?MkVOengza1Q1NlJLS3M5bDA4amdMYVZNaERUN1AzcGNkK2JQcjF5ZEpiMkVE?=
 =?utf-8?B?bm83QnpsbUdKdTgreWFCcGdONGdTajV5NFFoeVZOYzJuOGRCTXc5bUZwNUVo?=
 =?utf-8?B?ZlRMYU9HYkFab21sMm4xUUhEVDRsK2tLeWlkakZvVnp0MUg2VkRYT2RsWVZF?=
 =?utf-8?B?dzNKK0tNN2lzeDBJVVAzT3JOZnIxNlNlZkk3aFBLcmVnb21LWjhCRnNsZG1R?=
 =?utf-8?B?SmxvYWk2RzVHdjBXY2dDb1JNZUVUdHNJSDBIS1NPV3h6RmJySWNvc2ZnNkxK?=
 =?utf-8?B?TkJuRTZZbUtYUGl6MWhXNjFYM1J6eEw1NVVDN2ZVRStGTkREWW1kM1p0c3NW?=
 =?utf-8?B?Y1IzUzFOMHpRRmdrWUVYOXRzc3M4Y1VaS1BON29xOTZlL2ZHYXh6b0VpR00z?=
 =?utf-8?B?ZFpUamswVC82RkFrQTN1dlBmNHM2WGxCOUtYa2pWNjVadytqMGRvRW1NL3Zq?=
 =?utf-8?B?a1NxVm5IdG82K2JHbUxlQVRYeUtSRlJXNjRtYmVvRUxFUTc1Vm1jMjl0S0xV?=
 =?utf-8?B?TUpEUzg0OFB2SWh5YW4rNHdZWDZkeFl3cTM3cktHNmNxV2RrK0o2RXMyWTlV?=
 =?utf-8?B?UjhIQkdPMGV1b3Z0dkZhVzdZQnlZRXpORGk0SjIyem1HeHdrQnFBMnUzWWgx?=
 =?utf-8?B?ZkRWRDh0ZDBrVlhqempvanlxUnhyM3owQjhnNnF4RVhNbHdNU0N3SmE2eDJN?=
 =?utf-8?B?UFFoaTArUjNYMGJXMjVPbjRaMHpsdXM3V0xGNGpWTWEzczlYRUJ4SER1cEdK?=
 =?utf-8?B?RVhzZ0grMmFJWWMyNVBkbVk0b0hWT2dSdkdXWGY1MDJJTXFoSU1YNGNVMnJx?=
 =?utf-8?B?ZHdFY3hIYlF1N211U0g0TXRLOFlxUE1VUEt3MWU5azIvY3ZQbGorUlducUZp?=
 =?utf-8?B?L3NYdlhrKzE4T1VRUjZrRm1Nbk5yRFRVbjF0d0RSQnh5bkJsRUNwSVRIQ2tZ?=
 =?utf-8?B?WDlWUXFlYm9WYWh5aStsRXgzcGFERDRCMU5zWFR0MklGSm5ROUxyb2V5bUxs?=
 =?utf-8?B?UnlFMjdRaWNJTnpyRHlZcEozbUUxdmplL3FpbUJCaWxZTVRlUDBONThFMUdE?=
 =?utf-8?B?Ukt5aTBTUmp4QmY4cE1UOFJ3c3BCRW9SQ0tvdFdmSWpFZ2hJRExMNlp3OHE4?=
 =?utf-8?B?ckZXUUV3V2lmMng3SmdBL3hTaUs4YWlGSVp2ZExnWUkvNTlYbUlIK1NuM2sv?=
 =?utf-8?B?K0ZHTzAxM28yNzhHWWtuUmdhMFl5ak9Cdk9BQ1RIK204OE1kbGY0WGNSa0Q2?=
 =?utf-8?B?OWJNdEM4SmYrZ1RSN3puZFdTNlhTUGpxb0t3bjdNdXJzMkpNbmw4WVBkUmJs?=
 =?utf-8?Q?qBKDUW9cN0A2op2s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf39bde1-60a1-432c-e45f-08da32d4e402
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 22:31:56.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrMxNdr+FAKtE1pb8wm4jhCHDTEWIHb10lFIcWX3Sqp9njNMUJcmt6X7e7bIXpx74TKeUrNNbWQFCvuexUuos1EKu7msn/eqMG6Dg6nKfCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3428
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100093
X-Proofpoint-ORIG-GUID: H2xI13rqotwv3w4ez5o3A2Z4NMohcLiM
X-Proofpoint-GUID: H2xI13rqotwv3w4ez5o3A2Z4NMohcLiM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2022-05-09 at 10:41 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_repair flags these as a corruption error, so the verifier should
> catch software bugs that result in empty leaf blocks being written
> to disk, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c
> b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d15e92858bf0..15a990409463 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -310,6 +310,15 @@ xfs_attr3_leaf_verify(
>  	if (fa)
>  		return fa;
>  
> +	/*
> +	 * Empty leaf blocks should never occur;  they imply the
> existence of a
> +	 * software bug that needs fixing. xfs_repair also flags them
> as a
> +	 * corruption that needs fixing, so we should never let these
> go to
> +	 * disk.
> +	 */
> +	if (ichdr.count == 0)
> +		return __this_address;
> +
>  	/*
>  	 * firstused is the block offset of the first name info
> structure.
>  	 * Make sure it doesn't go off the block or crash into the
> header.

