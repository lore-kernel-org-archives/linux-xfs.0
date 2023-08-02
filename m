Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F68C001DF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 13:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjHBNWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjHBNWW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 09:22:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DFD8F
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 06:22:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372CxVfr020632;
        Wed, 2 Aug 2023 13:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=XC+5mNLuoO9PNoIE3UBs65RjbR/gZNhJPH8a2Br+Rzw=;
 b=ochII/WYD3iPomsFf9sW77O8zHpDTC6VoZGj4raONXx4zbVkV9B5NjejbqqU1MrtPDxZ
 0XljCdt1Xm/UgcXe87VFSojpDKqyCEo2bHwVrwJuLFPPN4S6TolXsR9x9BR8RWkrMfox
 uEI1g+RpLwdwL/u46LijUxJAJeWFBakj0Etp7lsgeGt5rmoz7xNY2TFeWnBvhME1UWup
 unTeIhCpk2hiaoibh9JsI7ixAAOL9dVG/miPwwlWoRfaC9tQnzuAkVvUPXGGdcR90AbO
 qIRlQqU5004qLomqr3jtkLbRwtc/5FScwCoOtEGaSUs97R7HWczOdMPSVTi9N9I6DF8M FA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tcty6u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:22:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372BdnPN025103;
        Wed, 2 Aug 2023 13:22:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7effw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:22:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2ukKtHBz3l2YVmruc51qxbuc/mrDDSYYiAFfEXJn7PSuYYz8xkN6rgAoC5h/RBpjWLlcJ3huOY2ytIJCHbnsLtkWpzmAef1HqLTCdBR3AAwkdPka+40NCJDgNl7rOKTvCAJUzItyLg/fVR2iROxpDwzAk1/gJSYaojhf0TvgLX49ChyDO/cHc9CJUvq0I3JWEGy0KJsyFaERVLkU14t97z6LNhAFV7iDW9bBFTg8GF7BjD2p7MwXggppr0e/sCnxYWf9Emi89Pv8g1tibi9gGLIMH+zjTuMWT9r6Dljj6jS2QV0WCIPhKGkyFPhYhznUjKuBPmLEJQBdJ0wiPvV2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XC+5mNLuoO9PNoIE3UBs65RjbR/gZNhJPH8a2Br+Rzw=;
 b=GJzEDcSYmP7FqcDGh4y6s/rUkcZft2YVk7Ht3Q6qB0hQ+TOz91Mvv6kx5KE0+Vv0PhrPpMuuotuogohEGm8G2btSomi15JIfxW6eQo1wMr27dsGfyehoEZk0UJ7S+v7KvDhMu9pxmvBIngOHqkE7Kv3lDvSyWbPYqbCsIU87VhMUpuBVIAi7Uot+RTCSt7uXnfscLXLNwNyRa8SuGKybsTPIn4gxiQjYb64RJ0jwv2wHwl4s7D7uYpslsAfqE8Iz0XKKqTq34K95ZHlnWX/6+CEtNCgvppMr6mZlo87WbJFZ+gctH6rlrt0CrqbwAADHhew8yBn7rIeF6DBk71TLKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XC+5mNLuoO9PNoIE3UBs65RjbR/gZNhJPH8a2Br+Rzw=;
 b=EiYrH51U7Dgr5+cxMHLQLPY7ZFv1LSzPsfVaC8wnI/njxm8yfGyoqjhW3Mw0mMbLOw3FKV89EN/rZgYOtUs+s36+BEjNkI/8SXY4h7uNkf4c0QdppHako/0rJZdB0vUVs8caT9vn1TpVeSxO7mxZjcwk77yS8ObpxlrvdwUyI+E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CH3PR10MB7356.namprd10.prod.outlook.com (2603:10b6:610:130::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 13:22:10 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 13:22:10 +0000
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-14-chandan.babu@oracle.com>
 <20230801235120.GU11352@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 13/23] metadump: Add support for passing version option
Date:   Wed, 02 Aug 2023 18:48:31 +0530
In-reply-to: <20230801235120.GU11352@frogsfrogsfrogs>
Message-ID: <87h6phr349.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH3PR10MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: bddc2517-d65d-4087-6817-08db935b79dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BGaNgz8/R7JBDppokvp/gLanJHkACzJcSgLMcqCqSPvIILyhpt6ZTgdRoUvjuUHvD5JkvmMMmji472kCHBDM2slANS0XRD51tg8lc4/q5ZrAekLUIBtNlrEz/fIzhIKof2fQF1cXnIyEuECiVtxaLYG2N4m29GmnPuaJVrHiCL0q7bEjJKXZwysztd4ZFG9SpBPtSerYHAjqec+OFUxMYNkvb60Kw1ulGSFEbyJbDmQRuE6w8ao3pTkUnWAiRZItZ4pHxVo0noj8eeBxkU5yYxO5/7tQx63KIIfT1JC3k6yP6pg2QjthrIE59G9/CNLNedbrfkwHTc6C5mFxyAQvluC40LqWo7VFig6gEF3he29B4R+jwI3NSpLqCA2iuotPzstSmiaZyMYAkAwFUjyh0TZCo1rmTjPS0n6SntMgzJWK8UVcm249rZLHnLq8JknVdc1Sm1LU1xv1B6V5sdJZAdO6SE/3GEJPu2JKQG0RddnIUQLiyBGn+jP/ddgcfrx1TWZD5t5Ceo5CQ8qRlykYn36WzHMxx0mat039MvubRCAa6TE8o/Ey5mqzGKEBcFz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(41300700001)(2906002)(6916009)(316002)(4326008)(8676002)(8936002)(5660300002)(83380400001)(66556008)(66476007)(66946007)(86362001)(38100700002)(478600001)(26005)(186003)(9686003)(53546011)(6506007)(33716001)(6486002)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qDIWNRl5SDCPwcjtbMEHHNVAiR+ZZr+CkvyrgQmzRXwj79R1u63XOiDhQ7sj?=
 =?us-ascii?Q?khGXO3hjBcIVpM5cpbYeNtxL1FNBN2J4s/8AR9CO1nD87T1aPMj8b1e2RLkk?=
 =?us-ascii?Q?7buDHzKvDJSTe5a6eb/EuuwuPeitYxj0JkGht9L8yGkuYBQMNf9t0S33gGmZ?=
 =?us-ascii?Q?h3jkbvJqZRxAJKBhwrtMkMFgxO6aB4o6pSOwkXjePQ0vecGn9ezMVuZ1Fj6s?=
 =?us-ascii?Q?ppwbSxbTfPcir7hBnZT+1iO3rrIlyS16esX3uBsgsqVcYJKLIO17oINTaFaQ?=
 =?us-ascii?Q?ygla3Uf4RfmQHdxsIreP82ei3N55EGfm6M+gR6cFDgs7sCrJWEVQZDPujJET?=
 =?us-ascii?Q?ketFqRpHNGvb0bDvWpD1lKkjcX1QS4afYro2j1IiW5qa5S8IszqDZuCZ22ov?=
 =?us-ascii?Q?poJ4PpJvKQbVADaccOvWaNiQp5LRbgctiFt4unHzxzaXmTwr4oEFfmurxARx?=
 =?us-ascii?Q?xTLAzCMKsl1qtE4I2NxdWqCs94CSrDLJ6EMVBSRGoQqqneh6B6l5SdKQZnAR?=
 =?us-ascii?Q?GiBw7BNo7MOptgW7g+zwOTtzQ3ibiVacTxAoxGQI4ZmnTtrAZE9bAiXU6EwF?=
 =?us-ascii?Q?pU/SZamp31U/IMOayxtR/p1BWkL44307zOn3lmWlnG/WomH0LAvA1kZRroyX?=
 =?us-ascii?Q?aLGvi0y6nS7YSXJ9qYtiNOvpXO+hwu6mvM9GkF0ZAAugH4NJZOkbqvgUxIij?=
 =?us-ascii?Q?ocF8DuqYcu03d6FL6mr+swHex+UwjjeTj++4VdCqScHJeK3Dlhh7BK40MpGs?=
 =?us-ascii?Q?ElLY8369Eg4HQqI1a6S09eFXiePVBspN/+g4fr9JBsW6rJMAjimNPBj6mJmQ?=
 =?us-ascii?Q?FA0Ba2JF6g6O7PHwZCl9ufWby8595NJqxVbvggwq1WJQFZ7j5+CY8h6ss1h5?=
 =?us-ascii?Q?vyj8ll3rFY4nB//K2lT/yhHODJyOEsePQcRQahP820QPdHsy+67J0tBqCq4c?=
 =?us-ascii?Q?nNONS9saU5Qrw92OL+2TKLz3RoNjthvdTpyIYdkr4jHVH+UkdonG/qzgQezr?=
 =?us-ascii?Q?+Yi/QDwnV2S+y1LwqOKWEW81jxtPBOrd9f0klhcZa1D3T885ysmarvjWf/Ey?=
 =?us-ascii?Q?cjBDlVoHa5W4FeGLPo2up6wQBXHANf1/opqZ4NYPfxtzIBloSUF6nO9ESHZG?=
 =?us-ascii?Q?iZvOMSeHX8o7PDPl8Q4nZARfKHL8oUHTTDbeH0Le97oGwm9JRkG85pVshs2U?=
 =?us-ascii?Q?5GfiCzMMOHiN7723e45O4zmtETrRuSMsSZ+ZQ2Q/kHUMzrqUj6Uc8zyHys5X?=
 =?us-ascii?Q?7fJz0BjJGBOdklngmOsZjkDPZG0eZpOpKlSEyLuwuds6VHmDAri/ZOxYe9Zu?=
 =?us-ascii?Q?G1sa6vt1qF/1wWUOfzSbgKLgoo1O4IZqyBwpVQEWFAPs/sGQdm09rsRyGqlv?=
 =?us-ascii?Q?eMeyZ1P5nuznt0bE6rF3DsXcSk0nbYYY8RuNnIqMuudjrVV9PwOo5eozcOfo?=
 =?us-ascii?Q?hgtiqLmyj9cdyxPy4pP93r4bpAbsMixlBFjW9pNAaGFZfuwTwQ/fQKgWx9bk?=
 =?us-ascii?Q?6TlSqswZWOIhyFEX62UNkT42p/VfX6uEmnvEDfSjzFHIQRIGrbDDG3cDVVw1?=
 =?us-ascii?Q?LqniMWTrjNF5/H7Vetw5DfTIe8+pVE7XQv/wnanCMXfrJkXu0OY3Y9rhU4zo?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vKVa3ksOy4wBS+dik7R2c2a4lrt8+/nFrxI0QkxBtXLNhy8AVvCDOv4VIi9iZxiugBwiqsOcehSsrk+usQ4iQw04KjDDQIxfwv3at98I4TwZ9590K0dm0PqumjsKzVaBwHUZg7qzcTi7yU8V+CbJuCzgWplLsyPtJZFZfgCkGVM6BBN6Q7kYojP63asr5iVR9TZqmcIedM14ovTihT2jzu7KBvSJjpcTwFr3RBtqEjTxva9R71bctukpvfNvwqQKr4W9pqZ8YWUnVxDGSxAGPRLmCzr77NFlKCTE0JFRZwPTWxj2e/jc70NqV86+BpvOdQJAvFGmygCAqH1fxJfH+4l3kmmkNgDlQk0WppRuSt5uDA1jrwkt0euJT0sw04fV/lsFRLkMEZsuS/C9N94S4lw1HPgxq4FKPyLUEzkp9kem47lyTV0wqFh9XzYqxWvSiJwb5iypZHiWtmpKa5zqq7rGvNM3epjOA8HoenRe+NAK+yJbL9+HeuAgOMY994HQu1Jd0XQIicJACCPh8yfhBtzt80OOXJD+mqNzj8DMzqXYHSHYMFTsWsWQE8Ql13rf2Yjx56ir1u/QCYb5y28yE4qUKIYEpQ/NTUZm5ue8JL+nhl7IyRLdKq4QwABKZEwPBui7ZXzjAMAFCAhn1kuglDV2Z5bFh/OrazalIT9liqj0erY7n96hKRRooQ8TLbm/XZ4xCAPJyFWt5+7QHV765YFFfjdNGKOBzprm2p4wh9q1iUtHvCjh/ce4ZF57lYw/aGYlaCZsAo3Ffdt3xDLva9ijOaCErZ8024GohCaKpkY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bddc2517-d65d-4087-6817-08db935b79dd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 13:22:10.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ex6NXJ2TvE5wfnlTgJSov/zw8lqy/rl5jgH92ZCeWYrEbTmaUXH7WTj2NuefdntimolRLyKnSqurhaYDO5sImA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_09,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020119
X-Proofpoint-GUID: UoP860btIiqUlJAlaCnpZIG5tYTCvHqm
X-Proofpoint-ORIG-GUID: UoP860btIiqUlJAlaCnpZIG5tYTCvHqm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2023 at 04:51:20 PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 24, 2023 at 10:05:17AM +0530, Chandan Babu R wrote:
>> The new option allows the user to explicitly specify the version of metadump
>> to use. However, we will default to using the v1 format.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> Why did this lose its RVB tag from v2?

copy_log() and metadump_f() were invoking set_log_cur() for both
"internal log" and "external log". In this version of the patchset, I
have modified the copy_log() function to,
1. Invoke set_log_cur() when the filesystem has an external log.
2. Invoke set_cur() when the filesystem has an internal log.

I think the above changes warrant a review. Hence, I had to remove your
RVB.

>
> --D
>
>> ---
>>  db/metadump.c           | 81 +++++++++++++++++++++++++++++++++++------
>>  db/xfs_metadump.sh      |  3 +-
>>  man/man8/xfs_metadump.8 | 14 +++++++
>>  3 files changed, 86 insertions(+), 12 deletions(-)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 9b4ed70d..9fe9fe65 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -37,7 +37,7 @@ static void	metadump_help(void);
>>  
>>  static const cmdinfo_t	metadump_cmd =
>>  	{ "metadump", NULL, metadump_f, 0, -1, 0,
>> -		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
>> +		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
>>  		N_("dump metadata to a file"), metadump_help };
>>  
>>  struct metadump_ops {
>> @@ -74,6 +74,7 @@ static struct metadump {
>>  	bool			zero_stale_data;
>>  	bool			progress_since_warning;
>>  	bool			dirty_log;
>> +	bool			external_log;
>>  	bool			stdout_metadump;
>>  	xfs_ino_t		cur_ino;
>>  	/* Metadump file */
>> @@ -107,6 +108,7 @@ metadump_help(void)
>>  "   -g -- Display dump progress\n"
>>  "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
>>  "   -o -- Don't obfuscate names and extended attributes\n"
>> +"   -v -- Metadump version to be used\n"
>>  "   -w -- Show warnings of bad metadata information\n"
>>  "\n"), DEFAULT_MAX_EXT_SIZE);
>>  }
>> @@ -2909,8 +2911,20 @@ copy_log(void)
>>  		print_progress("Copying log");
>>  
>>  	push_cur();
>> -	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>> -			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>> +	if (metadump.external_log) {
>> +		ASSERT(mp->m_sb.sb_logstart == 0);
>> +		set_log_cur(&typtab[TYP_LOG],
>> +				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>> +				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
>> +				NULL);
>> +	} else {
>> +		ASSERT(mp->m_sb.sb_logstart != 0);
>> +		set_cur(&typtab[TYP_LOG],
>> +				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>> +				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
>> +				NULL);
>> +	}
>> +
>>  	if (iocur_top->data == NULL) {
>>  		pop_cur();
>>  		print_warning("cannot read log");
>> @@ -3071,6 +3085,8 @@ init_metadump_v2(void)
>>  		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
>>  	if (metadump.dirty_log)
>>  		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
>> +	if (metadump.external_log)
>> +		compat_flags |= XFS_MD2_INCOMPAT_EXTERNALLOG;
>>  
>>  	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
>>  
>> @@ -3131,6 +3147,7 @@ metadump_f(
>>  	int		outfd = -1;
>>  	int		ret;
>>  	char		*p;
>> +	bool		version_opt_set = false;
>>  
>>  	exitcode = 1;
>>  
>> @@ -3142,6 +3159,7 @@ metadump_f(
>>  	metadump.obfuscate = true;
>>  	metadump.zero_stale_data = true;
>>  	metadump.dirty_log = false;
>> +	metadump.external_log = false;
>>  
>>  	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
>>  		print_warning("bad superblock magic number %x, giving up",
>> @@ -3159,7 +3177,7 @@ metadump_f(
>>  		return 0;
>>  	}
>>  
>> -	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
>> +	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
>>  		switch (c) {
>>  			case 'a':
>>  				metadump.zero_stale_data = false;
>> @@ -3183,6 +3201,17 @@ metadump_f(
>>  			case 'o':
>>  				metadump.obfuscate = false;
>>  				break;
>> +			case 'v':
>> +				metadump.version = (int)strtol(optarg, &p, 0);
>> +				if (*p != '\0' ||
>> +				    (metadump.version != 1 &&
>> +						metadump.version != 2)) {
>> +					print_warning("bad metadump version: %s",
>> +						optarg);
>> +					return 0;
>> +				}
>> +				version_opt_set = true;
>> +				break;
>>  			case 'w':
>>  				metadump.show_warnings = true;
>>  				break;
>> @@ -3197,12 +3226,42 @@ metadump_f(
>>  		return 0;
>>  	}
>>  
>> -	/* If we'll copy the log, see if the log is dirty */
>> -	if (mp->m_sb.sb_logstart) {
>> +	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
>> +		metadump.external_log = true;
>> +
>> +	if (metadump.external_log && !version_opt_set)
>> +		metadump.version = 2;
>> +
>> +	if (metadump.version == 2 && mp->m_sb.sb_logstart == 0 &&
>> +	    !metadump.external_log) {
>> +		print_warning("external log device not loaded, use -l");
>> +		return -ENODEV;
>> +	}
>> +
>> +	/*
>> +	 * If we'll copy the log, see if the log is dirty.
>> +	 *
>> +	 * Metadump v1 does not support dumping the contents of an external
>> +	 * log. Hence we skip the dirty log check.
>> +	 */
>> +	if (!(metadump.version == 1 && metadump.external_log)) {
>>  		push_cur();
>> -		set_cur(&typtab[TYP_LOG],
>> -			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
>> -			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>> +		if (metadump.external_log) {
>> +			ASSERT(mp->m_sb.sb_logstart == 0);
>> +			set_log_cur(&typtab[TYP_LOG],
>> +					XFS_FSB_TO_DADDR(mp,
>> +							mp->m_sb.sb_logstart),
>> +					mp->m_sb.sb_logblocks * blkbb,
>> +					DB_RING_IGN, NULL);
>> +		} else {
>> +			ASSERT(mp->m_sb.sb_logstart != 0);
>> +			set_cur(&typtab[TYP_LOG],
>> +					XFS_FSB_TO_DADDR(mp,
>> +							mp->m_sb.sb_logstart),
>> +					mp->m_sb.sb_logblocks * blkbb,
>> +					DB_RING_IGN, NULL);
>> +		}
>> +
>>  		if (iocur_top->data) {	/* best effort */
>>  			struct xlog	log;
>>  
>> @@ -3278,8 +3337,8 @@ metadump_f(
>>  	if (!exitcode)
>>  		exitcode = !copy_sb_inodes();
>>  
>> -	/* copy log if it's internal */
>> -	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
>> +	/* copy log */
>> +	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
>>  		exitcode = !copy_log();
>>  
>>  	/* write the remaining index */
>> diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
>> index 9852a5bc..9e8f86e5 100755
>> --- a/db/xfs_metadump.sh
>> +++ b/db/xfs_metadump.sh
>> @@ -8,7 +8,7 @@ OPTS=" "
>>  DBOPTS=" "
>>  USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
>>  
>> -while getopts "aefgl:m:owFV" c
>> +while getopts "aefgl:m:owFv:V" c
>>  do
>>  	case $c in
>>  	a)	OPTS=$OPTS"-a ";;
>> @@ -20,6 +20,7 @@ do
>>  	f)	DBOPTS=$DBOPTS" -f";;
>>  	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
>>  	F)	DBOPTS=$DBOPTS" -F";;
>> +	v)	OPTS=$OPTS"-v "$OPTARG" ";;
>>  	V)	xfs_db -p xfs_metadump -V
>>  		status=$?
>>  		exit $status
>> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
>> index c0e79d77..1732012c 100644
>> --- a/man/man8/xfs_metadump.8
>> +++ b/man/man8/xfs_metadump.8
>> @@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
>>  ] [
>>  .B \-l
>>  .I logdev
>> +] [
>> +.B \-v
>> +.I version
>>  ]
>>  .I source
>>  .I target
>> @@ -74,6 +77,12 @@ metadata such as filenames is not considered sensitive.  If obfuscation
>>  is required on a metadump with a dirty log, please inform the recipient
>>  of the metadump image about this situation.
>>  .PP
>> +The contents of an external log device can be dumped only when using the v2
>> +format.
>> +Metadump in v2 format can be generated by passing the "-v 2" option.
>> +Metadump in v2 format is generated by default if the filesystem has an
>> +external log and the metadump version to use is not explicitly mentioned.
>> +.PP
>>  .B xfs_metadump
>>  should not be used for any purposes other than for debugging and reporting
>>  filesystem problems. The most common usage scenario for this tool is when
>> @@ -134,6 +143,11 @@ this value.  The default size is 2097151 blocks.
>>  .B \-o
>>  Disables obfuscation of file names and extended attributes.
>>  .TP
>> +.B \-v
>> +The format of the metadump file to be produced.
>> +Valid values are 1 and 2.
>> +The default metadump format is 1.
>> +.TP
>>  .B \-w
>>  Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
>>  is still copied.
>> -- 
>> 2.39.1
>> 

-- 
chandan
