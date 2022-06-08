Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFD5C43334
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbiFHJm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbiFHJmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:42:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68321B5866;
        Wed,  8 Jun 2022 02:09:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2586oaDQ010570;
        Wed, 8 Jun 2022 09:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bKSO7Xw850cu6XrH5RmPR37LKzU6pUkmLPoNUqOyay0=;
 b=ENOIkEzd3eJPDgoFx6aHOa/Tla3Kg1fg/Prf4otxETxa6HAef1eIOmN1Q+dG9c/ufNCC
 B1j5AzcqLexifgiEDG2Zbq1nMfTbwtZ2k1VHLE06QA2RVogcd1DnGF3x9rGAj4QyLFGF
 Ck3dca49OPEgo6nV+jHNWK1R80jGMbPdivfkjD4UKJuFVfGocZB/TZ8rGux0Llg2N939
 LK4zqcYT46WzI9Bzpvsj60MZcvjTDzbido8QKexCbkUWLChrapUsiJ4V1xHJbQxuGNfM
 XCTpeHuXvL0sWNycGacNzWz5BxnoAbOXL72Bq69uGzFHXMDIVOAGVwg0Oj4pSubgoiTD QQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghvs3bbch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 09:09:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25891sp6024799;
        Wed, 8 Jun 2022 09:09:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu3v6h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 09:09:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkpvkbkimjTLQ9IW9JBvbERRQlzpNu6Dy3HOvXOq69GsdoGybGSgzjbL728tFf70L5MterkeotJRdHrOvpA6axPVbpONxQpJsFAzBVU65B6Eaky9XELYaW4HNeBINui5bB5guI415i82EjYZG2gomcAltTQC/Qrmb/Wlns7bjqtZD/m/vxtnzH5Jpc3UAV1xNMz+QmkR+XOshssw7tH5jczBNrEisv5N9kAT+pzSNMaQuXx3G6fASBdBaAUYNSkvpjXFnYdt3ABcUHt/8btUiA1EyGTMNtahMma+rQ/3PkuR1v5+KbgoAvXqrvnrBLh9msVtls91f+vTC9/Mzhow6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKSO7Xw850cu6XrH5RmPR37LKzU6pUkmLPoNUqOyay0=;
 b=TAf3Mpbw1plkmUuMJvIdK0j2fN7BN+4cqaPG3RgL81aJutZw/jpQ1wnso48UHUMG0Gntx5wyI4D5bM7pswnZ2QoXY7t+d8091RYlJg6YQVz1TuoIiE6FOpdfwqIIXm5vdIBfJzXqwZXSOH1ZvYRnZfPwX1tm+bwg1vSsLrIjMkG9792YWe6/LhmCivVBgPaUgSXDsplWX22KMdh4TZTFYY1Z8rrQ1/hEoKOCf0erTcN+geV3umTuflVwK8rvY5kpll5OYEeuNjKd71NqKOHHrkm2KvWP7t5drqM9O43tgBbamvkPpt6es44DiVeRiOKoCd0KSbhZEbkVuZ9nox1vAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKSO7Xw850cu6XrH5RmPR37LKzU6pUkmLPoNUqOyay0=;
 b=PClebNL0NOjZE8cgqijDAP1dmm0Z2aah/oUxqwTW5WgYc8TKxV/vX5x3ld7ffGuU1z/ZVWv1xMyRIjbhQrMyMphgJ7P1jl3xKDCz5WZljXo+FnxVTeMk3TY5W96AXp7ECGztWyLYMLv6tJ8s1TxuMxol6i9+gZcpmHLoEH66Zzg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2480.namprd10.prod.outlook.com (2603:10b6:805:4f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 09:09:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 09:09:06 +0000
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-2-chandan.babu@oracle.com>
 <20220607235133.GR1098723@dread.disaster.area>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs/270: Fix ro mount failure when nrext64 option
 is enabled
Date:   Wed, 08 Jun 2022 13:52:35 +0530
In-reply-to: <20220607235133.GR1098723@dread.disaster.area>
Message-ID: <87y1y7fro5.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0026.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfe99a50-93fb-4e00-1f31-08da492e8a51
X-MS-TrafficTypeDiagnostic: SN6PR10MB2480:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2480E121C1E1E6E5840173FBF6A49@SN6PR10MB2480.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3fn9GsQzVyoV80pxdGxyF1qAnGM8tnUaa4nTX+mYc1yJPScQxYBoyEytZW37nfiLs+ImmlFfJN42xjeORWeI1Rco/vgUAeER233FleSDBcEge1jxxNZx/Vabr+hm92+AhErirJI+NsXX2yMUjAyfFtK8OsqUd+F3ggipKRqYrJnyQOetru7aCF+WuSgQZGarsA2frmXWPCwbKmHDDTnlxXJoqbB+OmIen0G81bnsyE0PX4V2HXHQksLmJ70No9AWzF7A2K7/ZTYXUK0BQCEPU47rE4yeW1gVoQ6bW7PGqAf3OgCU90oo96BUx4YdjGlyn8CnBTEQkuk15BdAPeWfA+JK9U5iOn4yRaDZdpZHtFi8A6KoH3fSfubVgXC+8OOldA5sgfdeNk4EAFTXNI44NlTQyUdbc0T649zGupVR6pQ9hBHnxSs8v2i+fQE1B9hkf84oOCwNHcEjJ2JWX5ngym0acNcnC4tytALqoZGPmjIq0Mx507JF0uX/sSLBSCt2UX3Ms4zUzXImYymSdOQ5OahjgadyVLoTNYd5+Zr4a35s27XCKk0YykCVoSBXN3y9YjMJhQ0S0iRxG4N/rIpJs+icK36I/ddplrASAKsxA0298h7P46MokP5OIj99XzmzHODIUt0UrDDhRNIdt53DI2l+Hc5QQ+BVnM1mqJToNe+hlkcNR47CPAV++VvDnOuKkPXAFw/ccQHI6JtLwchgZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(8936002)(4326008)(8676002)(316002)(5660300002)(66476007)(66556008)(66946007)(38350700002)(83380400001)(38100700002)(86362001)(6666004)(33716001)(508600001)(6486002)(52116002)(53546011)(26005)(6512007)(6506007)(9686003)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Obowsdg/wm1XGkYpWLx30h1PSiqC90fkb4ZrhQTcxWdCgeEALjS+ohkc6/cl?=
 =?us-ascii?Q?qpsf/QeEOM07VzypWiX+W9gYpCyUGaoOEePWaqGTlaw/em6ShSWnV2bl8Ywq?=
 =?us-ascii?Q?QtkevVnqbK/VC0Y9mNkzTq1YSOypcHZFoRuPEoG7geuFDOEC7/5T5ldMcg4R?=
 =?us-ascii?Q?52NzS7Kjfj7ca/ZgOEVnku94hOgBdeIMIvbu5dAAkQOW27e38fb9A/l5SFbm?=
 =?us-ascii?Q?sXTcWk/JDlLBmqupJkextEJwkl61z9PxRsKGvgkv6sZAPgGoB1srU3/3sjXw?=
 =?us-ascii?Q?EMgt9qegUvIM60+vPyxB9qmBEmxv/tqKy91pPdNAfXWY2dk8Cgv0oAK3vtCC?=
 =?us-ascii?Q?5eQJTEkGlfVWEEk6A7KYbGr5DCie1E94VpqQUY09OgVy2Rz5DCE1eQwSc66M?=
 =?us-ascii?Q?hiWIXizG5fVBvamNVUTNsDoF2Ro4FohYRyFFy3JKllXL8aFAgwVmzmFtkCSO?=
 =?us-ascii?Q?wUv+0cCI+xKtksh5d1rxke+v8VGd0vMb5RZLlWM9eWqzBQowRBL3OoskGLJ2?=
 =?us-ascii?Q?WisgH4mXwp8Svn0250PYCVWFI7Z20J0qPzRUVwC1JzJr3LMXYUH43bjhjk3p?=
 =?us-ascii?Q?jxLZM0e1jJbjq4XsstuVcpEGslRqm5DPuSXP8waSqnlQOvdwFr27xlRi3icM?=
 =?us-ascii?Q?nZznuFpiUYH/dTazS+IiRoCvE+0vYHFpHYSlx9R1Mlb0KPFh+rH81G+kJuHE?=
 =?us-ascii?Q?vVLYKSxhxgjcapk7YNaKfE0ZldxSe5OuGZp37od/UhziG23OW6sJo8yCrbpW?=
 =?us-ascii?Q?NBLUVBWtdsVn1Mk5yZCLCzmJeN8VjNtNZa0BwCNKkhI2KJS53qVsPaZwwCdi?=
 =?us-ascii?Q?24be5oEvHW6TARWQfehRUFcYvv7j3ABN/QjfXEvlEfzFdhGcdNrdsau+aGtd?=
 =?us-ascii?Q?+tT0Qj+5ktVq3SjBwrqOtFqRbtqJcZxOqZI/OzDT/aLHEg8CIik22yjNGvyO?=
 =?us-ascii?Q?wF/vwsNZBKWUlT7QBVYEjSP3okELKh1Fbz+aZFKrLliBgp4mA+2VmvR9W/Cu?=
 =?us-ascii?Q?rG1OB0XogMlZs90iOeMAbQ6t6G+hdYXK6ryy46b4jIcUbG9ww14mbly6uj7q?=
 =?us-ascii?Q?CrQzqiCKB1YWCvCLUzlIaUoLM7sxzLB9dMVPntOg6WV5dQeHbL4fVWU/Xy/9?=
 =?us-ascii?Q?ymh8NxI0Cz54dEeZR7pZX13jTTRD0+MlSHF6eqef6Z0dSyINmYj1eNdmX04G?=
 =?us-ascii?Q?52WtX9PBkCDs9AFzqo+y3hhlIr41NLIFzVCcsg9H/hA0JARcAfr/5VHcJOXz?=
 =?us-ascii?Q?ADTcz4etG39n6+bNkvnVA5KfeZ48gmbsn/l5mQtDOJbgfCc/wLdRE+x4A5Pi?=
 =?us-ascii?Q?Tu09LEUFRmemKWzc9/T+Ev6xcc/WABkAP9Puh5INcO11dK6NVNv10pWozDi3?=
 =?us-ascii?Q?+N0hLd2FF1oZlsM6GpEMz6PPOQzfP9rvOGMeqBbW9HBFN1cFmXOVYT6pVWYF?=
 =?us-ascii?Q?EGrjh8SUoHzsxxMRRtHCyIcdhjr+4SP6AgbitS1+mEewFks0wUv0lNS6qowz?=
 =?us-ascii?Q?C4vdqxz5680YRA+ijLktcrIlwLDN7Ywyxnv13jGtVVuoh26T38qyphTI3wkq?=
 =?us-ascii?Q?zISw5zEm6siuNjtlzF7Uzznv2FA41d/xR7ncEHxmsFi31spl8OjfUYwJNQgn?=
 =?us-ascii?Q?jZA5n0Jc2m48XVtvO8DZxXLp+hBrG8rhcTPuAOT848rh7eayr7zh0u7DVn/n?=
 =?us-ascii?Q?g1PUyHF4VllifeWQ1ACCaeQleJqD0VkKU372m7IGg3vq5hSH03QtJyaiJF4e?=
 =?us-ascii?Q?9V+2GkiUMg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe99a50-93fb-4e00-1f31-08da492e8a51
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:09:06.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PRuq2B2rv3MsZrO5MpdGtcUct2Zbf4jCT//QbXNqpuFhpdM2CQX0VK+5Fy8GENV/B814KlI9+72dbxl2gOqseQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2480
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-08_02:2022-06-07,2022-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080040
X-Proofpoint-ORIG-GUID: 38t8RNzMbWrz6sZPzjlAZHFU4WEC8nxL
X-Proofpoint-GUID: 38t8RNzMbWrz6sZPzjlAZHFU4WEC8nxL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 09:51:33 AM +1000, Dave Chinner wrote:
> On Mon, Jun 06, 2022 at 06:10:58PM +0530, Chandan Babu R wrote:
>> With nrext64 option enabled at run time, the read-only mount performed by the
>> test fails because,
>> 1. mkfs.xfs would have calculated log size based on reflink being enabled.
>> 2. Clearing the reflink ro compat bit causes log size calculations to yield a
>>    different value.
>> 3. In the case where nrext64 is enabled, this causes attr reservation to be
>>    the largest among all the transaction reservations.
>> 4. This ends up causing XFS to require a larger ondisk log size than that
>>    which is available.
>> 
>> This commit fixes the problem by setting features_ro_compat to the value
>> obtained by the bitwise-OR of features_ro_compat field with 2^31.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  tests/xfs/270     | 16 ++++++++++++++--
>>  tests/xfs/270.out |  1 -
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tests/xfs/270 b/tests/xfs/270
>> index 0ab0c7d8..f3796691 100755
>> --- a/tests/xfs/270
>> +++ b/tests/xfs/270
>> @@ -27,8 +27,20 @@ _scratch_mkfs_xfs >>$seqres.full 2>&1
>>  # set the highest bit of features_ro_compat, use it as an unknown
>>  # feature bit. If one day this bit become known feature, please
>>  # change this case.
>> -_scratch_xfs_set_metadata_field "features_ro_compat" "$((2**31))" "sb 0" | \
>> -	grep 'features_ro_compat'
>> +ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0")
>> +ro_compat=${ro_compat##0x}
>> +ro_compat="16#"${ro_compat}
>> +ro_compat=$(($ro_compat|16#80000000))
>> +ro_compat=$(_scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" \
>> +					    "sb 0" | grep 'features_ro_compat')
>> +
>> +ro_compat=${ro_compat##features_ro_compat = 0x}
>> +ro_compat="16#"${ro_compat}
>> +ro_compat=$(($ro_compat&16#80000000))
>> +if (( $ro_compat != 16#80000000 )); then
>> +	echo "Unable to set most significant bit of features_ro_compat"
>> +fi
>
> Urk. Bash - the new line noise generator. :(
>
> This is basically just bit manipulation in hex format. db accepts
> hex format integers (i.e. 0x1234), and according to the bash man
> page, it understands the 0x1234 prefix as well. So AFAICT there's no
> need for this weird "16#" prefix for the bit operations.
>
> But regardless of that, just because you can do something in bash
> doesn't mean you should:
>
> wit://utcc.utoronto.ca/~cks/space/blog/programming/ShellScriptsBeClearFirst
>
> IMO, this reads much better as something like:
>
> # grab the current ro compat fields and add an invalid high bit.
> ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" | \
> 		awk '/features_ro_compat/ {
> 			printf("0x%x\n", or(strtonum($3), 0x80000000)
> 		}')
>
> # write the new ro compat field to the superblock
> _scratch_xfs_set_metadata_field "features_ro_compat" "$ro_compat" "sb 0"
>
> # read the newly set ro compat filed for verification
> new_ro_compat=$(_scratch_xfs_get_metadata_field "features_ro_compat" "sb 0" | \
> 		awk '/features_ro_compat/ {
> 			printf("0x%x\n", $3)
> 		}')
>
> # verify the new ro_compat field is correct.
> if [ $new_ro_compat != $ro_compat ]; then
> 	echo "Unable to set new features_ro_compat. Wanted $ro_compat, got $new_ro_compat"
> fi
>
> Yes, it's more lines of code, but it's easy to read, easy to
> understand, and easy to modify in future.
>

Thanks for the review. I will ensure to resort to weird bashisms unless there
are no alternate options available.

-- 
chandan
