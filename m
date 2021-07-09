Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F75C07E9C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A16CD613C3
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 23:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhGIXlj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 19:41:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55832 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230428AbhGIXli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 19:41:38 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 169NUmax005963;
        Fri, 9 Jul 2021 23:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kwGtB4+TBsx9Ea+US5YwS4BdQgphhkhzBpEregDXLbM=;
 b=QLOvDxdtqN5Po1mam+Q4nmhNgu/bDGTM8U5S0mEd1DThWBDQccxPebvyBR0y28yhdjEW
 nGrTngXo02S5rSS19J+QnxfpSx9SnQ0V/xdyFYw/p9DQbFfkyeFuqtmuJ1jdc4qs0n2d
 gedX54lb7rZ8F+Q3UPZ/Ygswxk7o0ZYG5Hl6CnQMB0znxei+K9FcLNs3qQrR/4LsTdZ1
 AgaZF8/cJ0eIpjtek/LCu72akNMUpNHrG7FqCm8vGS5Kc+syC376EUUTebFg2i/ul7xE
 3KSToZ9o8Q5HiEGGutsdRkuku2/8FiNcnP82WjOJl+Dds3JEEOigK77//iFWYXRYfBML fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39pte5ghsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:38:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 169NUjYZ043264;
        Fri, 9 Jul 2021 23:38:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 39k1p7049c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Jul 2021 23:38:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4YmwDOGgCttP5H8xtea3hWHpDC/l8v2dQhE0OMmMlT9JcA9lK0sCMFsIYDlDr8dwUnkELk+qPxBi8WZxBw8srfKecvgw19fOyAQXyJxDf8kV1+t3gT2dosz/H/DayL7YcXIAkLiYt3Lxwg5b6bI4X+S8QfLznvlXbRWh4nA5NHYSxoumNP7bLWQK3dEq785rrgXGGYPGsg4XTgG/o/TBZ2Hh55oCp4jHFTtfSNSsnuRQIFXxkkJgx1IcOX4f2hSo4x/nqUf5js3NC8TS4H9dEEjOCbEHV+W2Cq92SZ12W8qMIoiB9flxEc0MgN8V5eUzX2XVnkZKh+uTBHD7AiQ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwGtB4+TBsx9Ea+US5YwS4BdQgphhkhzBpEregDXLbM=;
 b=Ye9uHCcVxxUeS4vGW4oc0hbI9XzjmrKobXDQUyxPA0upupUZMG/awA9HaDvu3E614RyrmEPu3r/1hJYRzVIrJ3zm+WJTANi1hUHwpsOTaIqL0j5wN1WpMOVbqnYAxiBEiwbzTFtyy9F2AU3uDV82U/I6qQIwC8DaS/bxNnRXXBflR2w+ihp090v+fvife75uWu17CBeBNJtdFw0/PlsS1o0t9pQ1FCCf3ZLRt7JH4hF4nwlLo/V72vyoozMjkg0n1ZnxnMRJYeguJW/9fXbFaIwpr00xAoVty8iTWqxiqGltsH5I32LaZSFAdgzdLGh7ifq7WrQfw9MadLzyhkpk/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwGtB4+TBsx9Ea+US5YwS4BdQgphhkhzBpEregDXLbM=;
 b=n1kxbUhWc0pFGCZcn+vKRx6L4fr3cUWAipSBX0aKyD6gv1kQY7IWCFH575AT0ubXLaBl99Qq6fUbBocjlCCWS/T2nDWG70C/47TpL2e9dSeB61w2btS7teJjsU9EGpqaqoHAHrJZ24DQCujA2otPVmZ9ysR3aHdO3FjTjuZFQJo=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5100.namprd10.prod.outlook.com (2603:10b6:610:df::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Fri, 9 Jul
 2021 23:38:48 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::807e:3386:573c:ad06%5]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 23:38:48 +0000
Subject: Re: [PATCH 2/8] generic/561: hide assertions when duperemove is
 killed
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162561726690.543423.15033740972304281407.stgit@locust>
 <162561727795.543423.1496821526582808789.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e600bbe5-1914-5f93-aec8-bab97b16c732@oracle.com>
Date:   Fri, 9 Jul 2021 16:38:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <162561727795.543423.1496821526582808789.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::36) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BY5PR16CA0023.namprd16.prod.outlook.com (2603:10b6:a03:1a0::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 23:38:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56dffdd1-afc9-4142-a6ef-08d94332b2ef
X-MS-TrafficTypeDiagnostic: CH0PR10MB5100:
X-Microsoft-Antispam-PRVS: <CH0PR10MB51005E6B9578EE056C2A798895189@CH0PR10MB5100.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZlgfPG0b4ygX4BlxTbznJ3gqcTSbZ9Q+BR4Rn9TGlLBb3p5qzBdW6cHh0/m1hLXkXg8YhnwS/HP0zt6Tnowx55sOh1YOZ6hEUNzX/6j3H9VY8d2v14iH+FGJ5VS3vAYCmqPhNhPLuSF8iWlWOMU3VL9loftBbEudRnzOjKar25FdZOzdSPzFNM6ZV1S592a0lmMHYRpoQn7vG0j4lEEaMMhyQPjuUeuChSbq8XxYRj37Zoi9KO1doTPPZGJVhxzpK2XJqyim0CAQjv3EHuJJP2csVizAFPyQwcI7hP2HmLVbgI2Bfmw9fblro562Sp8aaWjjs6+J6Ry9bNiWQKxO/Crclr4KZHa8j2sLCNWowALXhMrYieVdEslGoiZsVf9vJfxOkkjeBrE3dBRWES9amOFgwNtjyxNCx35Uu2c7nb32CZfgoaQ0BnVMde5O7i7mp5tQrcStOkkSOWsU4tSrf7/C4dgL9XUpCT5ZM0GttxYLLSsnvxKu1KHKmHkVXo1CXfKvwhok6h+135PlxW48fXyTEFMg2JNBT04r2b/Gb+14ohtOoW5cyv4HmsULc4dLVOR6daoe4iZaZ4lsZXZVbdVnBaUcb1eejTMVsbbl20GRA+wOqbIJhw20SdJhpl+WayEZCXz8sfhXjdSSi/OUEmP4iHe17MwhKY+pl6iuDPQ0ijA+svdiu2wufg9cY/PLqGgXkSU9TaV8KFvkfTvrajEPO8m9gDJJr3du74J2NrTt6m1S5DfBSUfwHalrPLGnNoXg/KV8CCBKN5v8Nw81Fi+6ZbDrVXsDw97ikfKuVo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(83380400001)(316002)(31696002)(8676002)(44832011)(26005)(186003)(86362001)(16576012)(31686004)(36756003)(52116002)(478600001)(66476007)(66556008)(4326008)(956004)(53546011)(6486002)(2616005)(66946007)(38100700002)(38350700002)(5660300002)(2906002)(8936002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXcxUlJJL0cxSks1WExsbHFNVlk1VHdqd0lDNEl1UGhSYXBZMG5yM0RkK1F6?=
 =?utf-8?B?UzFwYlpMVUlOSmZJNnBNNFoyN1FpeWN6b0ZFdVRvWTI3cGEyRkI5SDJ1YjEw?=
 =?utf-8?B?U25jNDdXR081cGpGOWhXa2Z5UWM2MGVnLzFKL2ZmR3NCOGR0Zkxmb2s2M09M?=
 =?utf-8?B?OXBseGo0bWluOTkwYVI1b1NjN0h2Sy9JeWhEUVYxdzIwWDhSK3BleExBNnhC?=
 =?utf-8?B?SWIzTzc1T24yV1lPYU54Nkt6V3dZMHE4cy9EdTNqZ0QyOHF2clZxWHNnTENz?=
 =?utf-8?B?OENhekpPMlA3anJHTkRsbGx2Q0dGeTE4R3pTeEh5ZGE3UEk5M2dKR2VFQTU1?=
 =?utf-8?B?TFVCTkhOYmU0dk9raGo4VWUzUXArT2NSaUdVUEk2blhWTFFlM0JlcnhHZXVC?=
 =?utf-8?B?Y3R5T2RIRERhZGVqVlRsYU55YTVHK1o1eWhQOEMrRzZ6VXNLUnBYekw1bWxt?=
 =?utf-8?B?N25HR1JKWlJ5T3ZjT1g0L3VKaTFyUVNiM2psd2pnV29ERFRMS0czNE8wc3M2?=
 =?utf-8?B?WXVab21uMitaS3dIZnJCVnVuRjhhVzVGSmxscHMzU2dWWGxOZEZtSXRPV3po?=
 =?utf-8?B?K2pia29GaE13UEczVXpodEFtQ0lUdVRpTk94amhQY0UyaXZxY1AxSW1HSE5l?=
 =?utf-8?B?dHVFMnc4NWRmU2xnTWdSWTBiejB4c1hwNWt3Q2ExTDRzdmJKTlo4cVI2NXVZ?=
 =?utf-8?B?bEJYL1l5SG9rbFd6ZURJdjk5Sk8yRW9GOGJ5TlMyK0FJdjRYTmU0MUZVdmdW?=
 =?utf-8?B?M3MyZWorNE0rbXV5Smp6cDRXL2c3WEdWaS9ZM09PQStsZllMcmdHKzBINnU1?=
 =?utf-8?B?Ni9GSEtzamRsSURMUzZlUDY1S0JuNHRXclUwRWxya1pKNkhDRTNYYmJHUzVL?=
 =?utf-8?B?Y0RNSTc3WFNOYTNDOGtoZXVqZG5YSzMrMUNkdEJmUHNmOHhyQWtsOWd0anQy?=
 =?utf-8?B?aTYrVWE2VXZpT0ZWV3NOWVVtaEZlYUgvaUdUTHNSK0lSUXhaRk10N1RaMEg3?=
 =?utf-8?B?dkhoTkx3UzlGODJld1hieSt0RGx2a3VZTVVHRjNxd3ZEKzc2UEM2c1dtMUV6?=
 =?utf-8?B?a1Zyb1VaVC9jQ3kxTU1vektwSXNYcVNycGUrRllWdXFuNHFVQ1dvOUpQaWto?=
 =?utf-8?B?bC9CTTRyRk9CM2dJckNmUzJPc04rWjYwdjg3YnQyUVJmQnBmVXlMQlU1UlFO?=
 =?utf-8?B?cm1aZU4rYXNOUTY1aXZFRVd5MTBHc21TU01EVFFyUURCUVVIYnF3T2hwWkZW?=
 =?utf-8?B?STE5VzJRY0toSisvNENFZW03N2NPZkZaQ3Q0UThxRnlpM0JjVVloWEJHV3Bo?=
 =?utf-8?B?a29VWG1Ldy9ZVjBHWTFoOUFaU2xRWm10S2RHZnBhd0p2a3ZybTA3ZWVycGZD?=
 =?utf-8?B?TjlqYnRHU1h6bTJOUGFCcHlDM3ZibTRvcHkyZFRBajhOY2tncDRJakcvUlc3?=
 =?utf-8?B?Tm5BNnlqNVp1UTVqaXpMMTJqSmdsRkxucFRNR0F3LzVnSEVyNDlPY1NyY2cr?=
 =?utf-8?B?djUreUdWRk1RWmlqUUx5c242T1pmVFIrbDAzMkJma0tMZCtKWGl0TDBNUTVK?=
 =?utf-8?B?VGRqU0o0K2V1MUo5a2NaeThpZDVhYTJrMEdtRlJYNVB0NERDM3hjL05ac2FD?=
 =?utf-8?B?MStWR0x3WW42b3FVSWMzbWZDelV3YTRudGtoc09IekJwei9QWXhuMzJDWll6?=
 =?utf-8?B?dE91cytselk4Si8zUWZQSU5hVmlVL2txOElDTUM5bFBNTXBraHFVcnc1Vnh4?=
 =?utf-8?Q?DT7iNMD+g56/5VnfoAw8zYXXR4Pwe7UDp6gGs0u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56dffdd1-afc9-4142-a6ef-08d94332b2ef
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 23:38:48.2228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbXKFktLpCGR0M4A0Oj4XNM8xkhn7mE/fxS+3hoOEtAGziTiA20b+JOdR6uiPG14NT2J9XdAkH1JYYIJlmRV6/htdfa5m7owiqH3MUZMZjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5100
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10040 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107090122
X-Proofpoint-GUID: JHhEI2RVx2nEB8hfS8RvpuPsYDDS-3J6
X-Proofpoint-ORIG-GUID: JHhEI2RVx2nEB8hfS8RvpuPsYDDS-3J6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/6/21 5:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use some bash redirection trickery to capture in $seqres.full all of
> bash's warnings about duperemove being killed due to assertions
> triggering.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   tests/generic/561 |    9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/generic/561 b/tests/generic/561
> index bfd4443d..85037e50 100755
> --- a/tests/generic/561
> +++ b/tests/generic/561
> @@ -62,8 +62,13 @@ dupe_run=$TEST_DIR/${seq}-running
>   touch $dupe_run
>   for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
>   	while [ -e $dupe_run ]; do
> -		$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir \
> -			>>$seqres.full 2>&1
> +		# Employ shell trickery here so that the golden output does not
nit:
I think I'd be more more specific with the commentary:

                 # We run cmd in a bash shell so that the golden output ...
> +		# capture assertions that trigger when killall shoots down
> +		# dupremove processes in an arbitrary order, which leaves the
> +		# memory in an inconsistent state long enough for the assert
> +		# to trip.
> +		cmd="$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir"
> +		bash -c "$cmd" >> $seqres.full 2>&1
>   	done 2>&1 | sed -e '/Terminated/d' &
>   	dedup_pids="$! $dedup_pids"
>   done
> 
Otherwise looks fine to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
