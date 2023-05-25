Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B8AC77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbjEZIuh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbjEZIug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:50:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5A899
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:50:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q84n5I008682;
        Fri, 26 May 2023 08:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=dL6DjFLiNpSkELWHLO6+javtsojLj0Utc5Kr65PRdfM=;
 b=ZP3U/q7EfdHuE/EhlN5O+4vnEj+LgxLdmmyo/PN34x1CvqKf55GQwqX0Dg97S/sJUF/o
 ZgLvGel2B+ykmRWyndhuV+woTLn5EJ1pklcDD9+Wd2La5Gn4M3rAm7n4zkKi+Wv2Sr2G
 moMFj8cn6fkxH1hvRf7ibmVjqFwzQczf2crgx/G/hTkG2B4s12nd0EWo9trjFV0BdCOI
 wEnN2+/+XWw0BXgRKyYUlTw6kMLmlr+jH814B6y1SfXDHG6QfPFRL6wSvRUJYwzJFENj
 Gvoqt94PEguwWy/zPZuyj0XCzTavryX8nbrgewXoAUtDl8ZvJYpABaOS6QlNxadf+6ds /Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg417-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:50:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8GDD8029303;
        Fri, 26 May 2023 08:50:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2uy22f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:50:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVr82aEDnfIuhaeZ+8JRDMKVj/tDu8VYAtqXOlD1J1Y4+ZFHwmdDt7LPcVZeXfOAZ9YMLdnt5pLgcwmg2m21ebqVl1aH/c8QVg1MEwIk4Go8JFGp4B+W9RO3c0pCntlPQPIosgzZrEazuwX5mLUYMcaiB+ulQdj3BRXaF8yxYkzNuYvEyhLLm1RAE5CO3nzAmSF/lwYox6cZazJGtvOCUAsUwTCuEWyhf/LfGfbDKomY76mUjwLW7Z+0HhxIzsAGbXdD6/wKI2+OBCAVpZRkjvX6a+AOK21/91wtIWMOAMhNVMiwC69RJ9TNkV9WKqPaa5mN3AlLppJQzS3H/Kiidw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dL6DjFLiNpSkELWHLO6+javtsojLj0Utc5Kr65PRdfM=;
 b=B9RsRwSoy8T9gqxjRdjmSFGVEY/bgwvCpeYXIxFPx18/Px2TsCm93mpJTPZ33zI3krQ3xZ3hRb8SCnh/xBlkdyZgp6maUv2u1oT6U8XS90nQrDk4g5zwpkOcP3HYrqhyBMaUxdp9D/jaxO7n6LqeteI27hWx6ynGo2677dHKSUqGs+BzftCb3hLkWSM3gHVsZ2606TNgEjWvmWx8bZtnFKFejoqplZRmAM+4EaQrzDIk5XfTfu2uqoEhmrOG85unP8jp3wXlzC4S5OOu2uy4Fu5Z28AUuimJ7lGnT9Vzugz4O2fIPa/a2MGLlsqiXh7k9Cf4YdgBhNKI/MQxvDt/jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dL6DjFLiNpSkELWHLO6+javtsojLj0Utc5Kr65PRdfM=;
 b=CIom17wa7J3nSn1YR1OaXwVs5EvJAUzih/4YnFnSgdKJSIWqAeNlrDRz2OK/203PUOuSfbcS4+WSO+UYHO0WUeoB0ObG6OM+BUUPmPwo5GPD2pU9lNoq2QBzKJ4ifwBMoEVdiB97ghrZdOJPfNN0vqYSPEPrW3m6ECJuQkscWAw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:50:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:50:26 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-10-chandan.babu@oracle.com>
 <20230523172513.GP11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/24] metadump: Introduce metadump v1 operations
Date:   Thu, 25 May 2023 19:49:32 +0530
In-reply-to: <20230523172513.GP11620@frogsfrogsfrogs>
Message-ID: <87lehbjx2t.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: ac18898d-9b51-445e-e148-08db5dc63fe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZNubniNMtC/N+zYMSSPuVmi5j8q/3go9XXwlzc2+5me21cE1LIDqIHyayd9TtoRraPp2WALuFdCS54ITIBCtKqb2sICaf3izbe74BSN52BZ7J/jzvtY+8+Gjqq0SXgwh7FLUtPoOhyXrOHkYz4ehgQ9Uc9ubPQaacRqsu8NpAuvh9L1g+BxMXF0hOpvi7OSFiKuhpdT6VCzSUiBQNtln9Hw5pwwdxHV4v3wOhQvrSTBRf0FplSXZ+tWj4LR4Ml3RaAoHi+tkE2Rejt71yL46ObfrZJ9h3kOWlcRStPQkWNjHk+oioXP3+N4xxUWrHMQ6O6pi1HREB8hRHyXXxrfVTTmCGHabI6rw/Zjgx2eRN3MTlu9EtM0/fCzbBNzHHmZFVaLFLi4lbp6mCbyTqC4EVkj9ZMI1fZrzXJE8MGHU/KXNYfpzDGRjryC71efrC7bH2kEa8ID9cMrL9SgJkPZnyzPv+PzpGw9de7z0oHnbEbRVMwyY41e7unwcwbuIIHeWfe1hsMLy7gGJgzRBsjfov5q7Roy+ZE3YieuC4s6Zfei9ANoQXTdJlgtLg0nW+q5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ekEh1aaq/xW6lrvfVJWmzx3S4FQEJ3a2r6mBU9mbf4TZGLhBetm6yhbAQtBO?=
 =?us-ascii?Q?ncuis4rHznhlD0t7bloTQr/UU9zgzCK/EoKnbc/EYi9/WFqNZ189KLYOPVkb?=
 =?us-ascii?Q?Xk/u88j41qlY3QZHdHpRXtCHaWCrU5irAN/aIT9CEe64nmQooCw7zEdig0Wc?=
 =?us-ascii?Q?ceAJfOvje+U+o5xlgKPkiZgawJ/0HD15ZK1CbJGgfirIzTGbLNer/3Ipec2R?=
 =?us-ascii?Q?AeUVePXVBOPxdUaOTzry/ERXeqXOXDtkL1H4D3k4OK0utV1d8ntXemj6LEZf?=
 =?us-ascii?Q?RjiOedENCw2o7oYgZPzfa8nSaCqVafa/6oDBQ/ldsemQSkBT1Ir1FbXqdiho?=
 =?us-ascii?Q?7faaiA5iSfmHNjMD+LKYNpOgc7FvnaTi8Qe1odSp6S63f10O6UXJydQ3FQFi?=
 =?us-ascii?Q?UMJksiN4Jsn8xiWJ33FEoBVrc7MPp4UKKiPLKtbspe4PlO78kXUgKZIWut+h?=
 =?us-ascii?Q?t/L4o3SsNTddPmHa4opRScaXH7thGsW9hGD7y1CZKytKHvKptakdLbd8iLlp?=
 =?us-ascii?Q?XuPtiZLSZ/YvC9uvJgfahibJXDqAu4782KmqQlRpvPsFkcaO02lfs2U46OIB?=
 =?us-ascii?Q?aHQwLaA9GFqAhpDx7+q46m+12aDffmMbHlragb/jBfHw5vgCVL/5Z97PHvR3?=
 =?us-ascii?Q?kJtjBD5NOky9A0DDQkU+/F9NSawStJ+Ig6TTcWyAfN8Y+VXUf++Zl+QhFfgr?=
 =?us-ascii?Q?zXVKGg9Bx2WoO73jEFOAogPoZvABT8LIEVGT0Pc9y9nn8+L1oYo3lTmT0Sym?=
 =?us-ascii?Q?lrxT7Q4Q1/DKNebr0gatcLxSj9q9iDfbNWGSpxC59QJfdeJXPBWPN8f78t1V?=
 =?us-ascii?Q?7zI/AFWSgb+ZvqMu50EGLvwx7cgV9LVLXplI9CU7urYVDawa1MU0+7r3pbql?=
 =?us-ascii?Q?ec+gNlLV3DeFut6JYrlrKu2jP58ZlxVUVlLegYzx37CxSslFYAB2gF5eBv7R?=
 =?us-ascii?Q?x6H+e7bb5PEmbx1D/yFlfav1Rh1+KOv/DCeHquyD0OhRR16dNJe7Cg+EzNZk?=
 =?us-ascii?Q?QYgKlHutDNNvFPvDxRNGmFD20UPga3HW8igeBRhsy9l8zBc3qS0ZKKfyWw/M?=
 =?us-ascii?Q?V8BvIaVRVQCSCyovo3OQjPyNCd6dftuRZ3Rh3IP3onKn8/UXfXz3wml4z1re?=
 =?us-ascii?Q?yyxYf0HrnPYYpf3QCq73SH3HDpyVfVVZGGYQTVbDgyD4BNeb/UIMHefcyxrn?=
 =?us-ascii?Q?WEn4hkcrRxT1z6G6r2gG2fm8Fto+QBDqTiqR0ry3JBaMho/SDUuZQyky8x2h?=
 =?us-ascii?Q?cnFFQnySubkUdvpliWMycIQz9WJy57iYRkr456E2Zjd7hL/IrQ6zqADe3cn5?=
 =?us-ascii?Q?AuzQajWGBBkZmjEuU4nW1QrhFRXxtOKk+d6aoywfxL94t7lDmzPbhQvLNRzk?=
 =?us-ascii?Q?YWOVDLLkoB/TbRVUkrF/O4TFPK010xr4oD9JdFpx4bTdJb1EiFZtMwmYie0f?=
 =?us-ascii?Q?hFoVt6l2ZEkdMgl/fqYbmXXsmoyT5VMbU9KN2MNbTOgG9417yJVR1JMTdCaw?=
 =?us-ascii?Q?Gyw7tyOYKqMzPGFbYOwcsRmpyvLp+jCY2+sOrw9/heVJYgzv+7ajrZGzpkYI?=
 =?us-ascii?Q?MDWkTdE6XbsVQHUsmLSZKWbSjIi4QnxAX2QqTRY7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: niKyersH7tdhqfmRFXQjieW7WZHGUZsS9VVTFOyR4YR/XcqpDA23kmzyaxQgeozwiXCGNjl+hwmkGZZvtTy86E2ZbGAkbYb3GnILOQg6zXu2ftMTyaiud/oujkIJ3eBpgkVhn9amqRSgtCGgCuobuGIZgG+MFZl6H9CSNWxsZOJl10HR3YI+cDCgUiiDWSe4VmQhiEf9zuNFZgtuyXW7utH8UZ/1MM3Mc+hLEijyXweod4fh6Rmz+LH/OrbZKcas3Pq3jlvNh2GcjdBE0l8V3UcnPgkStJy96xmhIS6GyHjwAdNeSdq7ikNIiLMXaqF0yNvOLYx1KnwjyOQdUA4DQy5hmHIPqSbfsCidL1gKzCXxsXaLx6ojhLpDEoT7Ro/5uD2addqyuwqhvnkEDcrheQvJegNF8k9CY5EyG8GL4JVu9ZJn33a5zUzvlWeCLZ+GRcpAkY8lkTL3tunL6d07XqTqjBIOPqGTsZlBxuMRS0kCMn0AuETPxIEx600ADrO7ijhDodjww642xEwyr8qrVc5nTtmve8zzaqouYofn8OsGyYlpx7mR4vc3x4nrkrpiFJgV87BwFXe3mc9Wa9oof3j9cg5F4+pScjMKBACXXUVUJbq4VoEVtblgUvs965dlO7b5gyVZW3ew1DXJaeRZSs8yd31Ta6kU8yt4vepv68trmqUudcKk/JNgGzGkSOvfjV0Ut2hfkA0RbzfYMjDl20W8p57zXU0CRHBmgzRnPwlCBP1sjQj+jxRkk5Wgi6iC47VRzki2vTSwT9Xivmy1t2E1R9hPW25Daki9mjgESuE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac18898d-9b51-445e-e148-08db5dc63fe7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:50:26.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntiKTttkdvsG4oqnQ/SUDqk+uNAqHTD7zqBHm5kkyYR0FhB/CMI4XSM9wr5mv5pJWdY2mvH27R/TLrfWBTOAmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260075
X-Proofpoint-GUID: yeCHmyWiiYDGLWFdUXCSiuWcpqJSTQNX
X-Proofpoint-ORIG-GUID: yeCHmyWiiYDGLWFdUXCSiuWcpqJSTQNX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:25:13 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:35PM +0530, Chandan Babu R wrote:
>> This commit moves functionality associated with writing metadump to disk into
>> a new function. It also renames metadump initialization, write and release
>> functions to reflect the fact that they work with v1 metadump files.
>> 
>> The metadump initialization, write and release functions are now invoked via
>> metadump_ops->init_metadump(), metadump_ops->write_metadump() and
>> metadump_ops->release_metadump() respectively.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/metadump.c | 124 +++++++++++++++++++++++++-------------------------
>>  1 file changed, 61 insertions(+), 63 deletions(-)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 56d8c3bdf..7265f73ec 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -135,59 +135,6 @@ print_progress(const char *fmt, ...)
>>  	metadump.progress_since_warning = 1;
>>  }
>>  
>> -/*
>> - * A complete dump file will have a "zero" entry in the last index block,
>> - * even if the dump is exactly aligned, the last index will be full of
>> - * zeros. If the last index entry is non-zero, the dump is incomplete.
>> - * Correspondingly, the last chunk will have a count < num_indices.
>> - *
>> - * Return 0 for success, -1 for failure.
>> - */
>> -
>> -static int
>> -write_index(void)
>> -{
>> -	struct xfs_metablock *metablock = metadump.metablock;
>> -	/*
>> -	 * write index block and following data blocks (streaming)
>> -	 */
>> -	metablock->mb_count = cpu_to_be16(metadump.cur_index);
>> -	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
>> -			metadump.outf) != 1) {
>> -		print_warning("error writing to target file");
>> -		return -1;
>> -	}
>> -
>> -	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
>> -	metadump.cur_index = 0;
>> -	return 0;
>> -}
>> -
>> -/*
>> - * Return 0 for success, -errno for failure.
>> - */
>> -static int
>> -write_buf_segment(
>> -	char		*data,
>> -	int64_t		off,
>> -	int		len)
>> -{
>> -	int		i;
>> -	int		ret;
>> -
>> -	for (i = 0; i < len; i++, off++, data += BBSIZE) {
>> -		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
>> -		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
>> -			data, BBSIZE);
>> -		if (++metadump.cur_index == metadump.num_indices) {
>> -			ret = write_index();
>> -			if (ret)
>> -				return -EIO;
>> -		}
>> -	}
>> -	return 0;
>> -}
>> -
>>  /*
>>   * we want to preserve the state of the metadata in the dump - whether it is
>>   * intact or corrupt, so even if the buffer has a verifier attached to it we
>> @@ -224,15 +171,16 @@ write_buf(
>>  
>>  	/* handle discontiguous buffers */
>>  	if (!buf->bbmap) {
>> -		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
>> +		ret = metadump.mdops->write_metadump(buf->typ->typnm, buf->data,
>> +				buf->bb, buf->blen);
>>  		if (ret)
>>  			return ret;
>>  	} else {
>>  		int	len = 0;
>>  		for (i = 0; i < buf->bbmap->nmaps; i++) {
>> -			ret = write_buf_segment(buf->data + BBTOB(len),
>> -						buf->bbmap->b[i].bm_bn,
>> -						buf->bbmap->b[i].bm_len);
>> +			ret = metadump.mdops->write_metadump(buf->typ->typnm,
>> +				buf->data + BBTOB(len), buf->bbmap->b[i].bm_bn,
>> +				buf->bbmap->b[i].bm_len);
>>  			if (ret)
>>  				return ret;
>>  			len += buf->bbmap->b[i].bm_len;
>> @@ -2994,7 +2942,7 @@ done:
>>  }
>>  
>>  static int
>> -init_metadump(void)
>> +init_metadump_v1(void)
>>  {
>>  	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
>>  	if (metadump.metablock == NULL) {
>> @@ -3035,12 +2983,60 @@ init_metadump(void)
>>          return 0;
>>  }
>>  
>> +static int
>> +end_write_metadump_v1(void)
>> +{
>> +	/*
>> +	 * write index block and following data blocks (streaming)
>> +	 */
>> +	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
>> +	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1, metadump.outf) != 1) {
>> +		print_warning("error writing to target file");
>> +		return -1;
>> +	}
>> +
>> +	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
>> +	metadump.cur_index = 0;
>> +	return 0;
>> +}
>> +
>> +static int
>> +write_metadump_v1(
>> +	enum typnm	type,
>> +	char		*data,
>> +	int64_t		off,
>
> This really ought to be an xfs_daddr_t, right?
>

Yes, you are right. I will make the required change.

>> +	int		len)
>> +{
>> +	int		i;
>> +	int		ret;
>> +
>> +        for (i = 0; i < len; i++, off++, data += BBSIZE) {
>> +		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
>> +		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
>> +			data, BBSIZE);
>
> Wondering if this ought to be called ->record_segment or something, since
> it's not really writing anything to disk, merely copying it to the index
> buffer.
>
>> +		if (++metadump.cur_index == metadump.num_indices) {
>> +			ret = end_write_metadump_v1();
>> +			if (ret)
>> +				return -EIO;
>
> This is "generic" code for "Have we filled up the index table?  If so,
> then write the index block the indexed data".  Shouldn't it go in
> write_buf?  And then write_buf does something like:
>
> 	while (len > 0) {
> 		segment_len = min(len, metadump.num_indices - metadump.cur_index);
>
> 		metadump.ops->record_segment(type, buf, daddr, segment_len);
>
> 		metadump.cur_index += segment_len;
> 		if (metadump.cur_index == metadump.num_indices) {
> 			metadump.ops->write_index(...);
> 			metadump.cur_index = 0;
> 		}
>
> 		len -= segment_len;
> 		daddr += segment_len;
> 		buf += (segment_len << 9);
> 	}
>
> 	if (metadump.cur_index)
> 		metadump.ops->write_index(...);
> 	metadump.cur_index = 0;
>

The above change would require write_buf() to know about the internals of
metadump v1 format. This change can be performed as long as the metadump
supports only the v1 format. However, supporting the v2 format later requires
that write_buf() invoke version specific functions via function pointers and
to not perform any other version specific operation (e.g. checking to see if
the v1 format's in-memory index is filled) on its own.

>> +		}
>> +	}
>> +
>> +        return 0;
>> +}
>> +
>>  static void
>> -release_metadump(void)
>> +release_metadump_v1(void)
>>  {
>>  	free(metadump.metablock);
>>  }
>>  
>> +static struct metadump_ops metadump1_ops = {
>> +	.init_metadump = init_metadump_v1,
>> +	.write_metadump = write_metadump_v1,
>> +	.end_write_metadump = end_write_metadump_v1,
>> +	.release_metadump = release_metadump_v1,
>> +};
>> +
>>  static int
>>  metadump_f(
>>  	int 		argc,
>> @@ -3182,9 +3178,11 @@ metadump_f(
>>  		}
>>  	}
>>  
>> -	ret = init_metadump();
>> +	metadump.mdops = &metadump1_ops;
>> +
>> +	ret = metadump.mdops->init_metadump();
>>  	if (ret)
>> -		return 0;
>> +		goto out;
>>  
>>  	exitcode = 0;
>>  
>> @@ -3206,7 +3204,7 @@ metadump_f(
>>  
>>  	/* write the remaining index */
>>  	if (!exitcode)
>> -		exitcode = write_index() < 0;
>> +		exitcode = metadump.mdops->end_write_metadump() < 0;
>>  
>>  	if (metadump.progress_since_warning)
>>  		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
>> @@ -3225,7 +3223,7 @@ metadump_f(
>>  	while (iocur_sp > start_iocur_sp)
>>  		pop_cur();
>>  
>> -	release_metadump();
>> +	metadump.mdops->release_metadump();
>>  
>>  out:
>>  	return 0;
>> -- 
>> 2.39.1
>> 


-- 
chandan
