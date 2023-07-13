Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE578C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjGMGsU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjGMGsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:48:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF251998
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:48:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CL9t4x008422;
        Thu, 13 Jul 2023 06:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=fqn9urVVsHZ4nLs/Pe33kIc+d+9yFVCVYp0/9flvK6M=;
 b=oiKDHFaEXXPMc6lV2zZiDXI+5SDSAr67cwnTkkw0SO7nqNC8ZHkIyYa4aePZFy3KvUk9
 UV06F89+R0D1iLTm9Jkayfd+YRRhzejLgxAfv1XiVvBMwaZy2r+bIP0+TAzw7r6jxtor
 m2jYNCc8h0XhkOux1dl11m/wD621LVu/x5gEOTfInlaitrOWC+0Ouu6WFwzPZ26Grz5l
 pqeTrROZCZPYeSg10G2F18goV0yNvDGhJCPOfkk1ZZLvBfBa0Fn0k5IcpqcaTkuL4YMx
 DzbeTQbAw5PSm/ENg6oAQ+grqMdxhfXFyNy5v+zhH7ew7VD6/ivYVj0dT1DZqTksiyS7 BA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydu0tvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:48:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D6VLiY008346;
        Thu, 13 Jul 2023 06:48:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8e3hnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:48:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eB8XtOprVfeHcDd/5A7rrI9tL75lAwLKSHs2BXmIczz93RsKBnZWtjzeZjwEs7iKBZutjcQDUaiurG5BQpGddWpJNitiIhJDl/YK/F1ktL+NRnNcft4YmjuGln2IMz/EXHkODITGBcydiFVXJGe5ua+ZCliZ2XO2yla1nYEebTCIjVfs/yjeDdSaQEolK956q3JTwOgL+NFsKVw1r5nmR0p34F9zkpsGAQWZe87DKT5pMKTItZi+//f+GxgTKGCSlzyBg9IO0cAoaMqbm0E/1pK3dxZ8yEHXNd8p0eGFWzHyMQ54/1gNnIrbsx2TfOXTe9R+V2LnAJfmutuOZV/V7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqn9urVVsHZ4nLs/Pe33kIc+d+9yFVCVYp0/9flvK6M=;
 b=NXf7ZQ+FLizYXiYZ25grG/FDHZqwyarT0CREZ/oGYuIU0zcga11o9P8DQ8Uzmry0s2MOKfP3LsuNs7yLJiEcQ/wq5tAmMjohix2bqZ+kY5IAXywhpVDhdODS0xcJq/mkeHtowsmaAGBH+HZj4/CcVc7e9Thd6QxIBx6U4+WgnPYTLpqSNegR4G/eChr6ihEtCJs7YZSWNhIylSickVk287X8HeetY0DkLE+NIdHzYp7lFNkAbYIveySOYkV7nJhMzMyqhfv298zMqGUzJMV0dcruWukjx9ULEWJKQ7pN8lVq7DfY6AwVzLNNMO3RqaUhMwYloV1z1MaLXCPwgkHhiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqn9urVVsHZ4nLs/Pe33kIc+d+9yFVCVYp0/9flvK6M=;
 b=BwYHQ6jybkpYeJK3beAyQGyOWBbiliALUEBiWIJvVF5Y2ohBuTO2HlhEHiCWhfsq+zvyB1RDkM4HZnMYPfVD9XnnCgx33+5wDauYBASo2bL5ptibaVjqCzYlxRPPESH84cw34bRdLkQ46kzerwxd22E0/qJ69Qu48atOOt1q5xA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Thu, 13 Jul
 2023 06:48:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:48:12 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-23-chandan.babu@oracle.com>
 <20230712181003.GQ108251@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 22/23] mdrestore: Define mdrestore ops for v2 format
Date:   Thu, 13 Jul 2023 11:57:27 +0530
In-reply-to: <20230712181003.GQ108251@frogsfrogsfrogs>
Message-ID: <87wmz4i9y5.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4551:EE_
X-MS-Office365-Filtering-Correlation-Id: 5891909e-f9f1-44d1-612f-08db836d2031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVbZsiGUmjxZYyl48YcBcLO/nxYTa1jUmuF+uEazlN5uVOjvU5ir1GF19fZVBecyou5zyKyPaAJiKi5ooSDuakrtwaAvwEnng8mHKl8nhw7QmInjCl7lwcFlBHh8IkSSg3cKoJXmPn1ZDKswar0wNBO9tcY/o11mzrEYjpT9Jvok/ZHgZpk/1QFHmZyhj/PHUhPprWLqLzXfMSTcs2AzUDi144Qs4U05vK8shWyDCr8LHJCSN1+DY4oBFscayPmsQ8IykDQ41zlHaSlQaDlm1Yx54MpT3BA1sFr+gvm2wKh1gasE0dhJC2aD1zKWBqbWF0KHshBNcPdjRD1ZwNuaLjS22s62cwjE1TkD3Eq65WYRNYRa2bHcjuJ/9y8GgO2LSWWGT87mCBBiaHuije7SHD55SV08W+vop1lAT9P/IoZTc4yDsAeMBdmqE4vqOiBRghg3jlIkGXaPfHSB3BqTRMUEhlaAqG8Rh0hN3XVXNanEbW6T5V1fBhMCg2sfCWY0Em5vm0bvQxzXlnxMnsAAYeDXgt5PiV6sLBlbkAe3/9/EMN+w8eXb11jHRUVPCGq8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199021)(478600001)(6666004)(6486002)(26005)(6506007)(53546011)(6512007)(316002)(9686003)(66946007)(186003)(2906002)(33716001)(41300700001)(6916009)(66476007)(66556008)(4326008)(8676002)(8936002)(5660300002)(38100700002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N5hBHP0aT60KKqExbbYGMqfQ45s1oZcV0wOjm29+bLPgTV3bFGaTmT6EuS9G?=
 =?us-ascii?Q?rZaSJTe54YMR5H0o9eoruK+9trzh8pyXuRekOwKoUDUsxTT6lYKb/Rip+QUG?=
 =?us-ascii?Q?Im2sioswC+GnIaD6oxko85e+tYpOpNJc7Y9Y3TqQUSEEsga+4zpfV7EJ7csh?=
 =?us-ascii?Q?UGC94ti3IKSHGlSp3lutPpywfdsriOx1uT8Pohbou+x374ohLtFlFqW0AmuO?=
 =?us-ascii?Q?Gk8gBaIq3CcGYqwX6deaS5X88RDcyd8GkXphSjnD7dVaQ3WuE205o2/USrJM?=
 =?us-ascii?Q?HpfDtqRgJ4uEIXQiHd1dWrd9shUZLVO9D+w0LouM3FxqaRL3pmpYlCBJueo4?=
 =?us-ascii?Q?wtcLf4Cgdittib7PpT/eDQ/89YJCH8MjVnNWHpWoEqIK8JNfqasYrElbaPW+?=
 =?us-ascii?Q?2G90DG/TYmhZqq08TGFT6HOJoRvkW8jmjTJHp5fdn/40cggqCe7AoXmiI8Pz?=
 =?us-ascii?Q?jFPoLLRzh5NK0EaazMjOtQsaM3LHS++8sRDIGDK6MOUYxCVZyXE9d91Et8iy?=
 =?us-ascii?Q?3tT1fq/nljM2bRzPYy0Nnl5tBCWHyjUF7uLtzuh0nJgR7bKT4wQ0QCpM67om?=
 =?us-ascii?Q?2dzZrikk/M5SW03gC9DS2uj095XrWHhY4sbMFlhyWYJPfuHkhwuvr0lhJwCW?=
 =?us-ascii?Q?GONLNTz881GmsNcu9GtDLCyXQHNPln8ZoP0K8+xPugfFWL3dePlQbJR++xZT?=
 =?us-ascii?Q?1zGmmaJfOm2BW4fOAdXJAlbUXPpXhYZc87KHTgtAfwunnd+p7huvaI9f6Ikv?=
 =?us-ascii?Q?VfhfbA2csADPx57i0/0/28Dvri/6CVLPfMDnAkw/K/60rtp86KT99vx++D24?=
 =?us-ascii?Q?DR5vlDvWCwl9XrvtsFN6rQwCrUGu94166knGv6K2+EGTJbQd393Pc8JcikPO?=
 =?us-ascii?Q?46rIBGnkJMjY9fw9hOzcDPAgzHmDfn/zAmUsfGWjfkFwTv79LzgdgROiW+6i?=
 =?us-ascii?Q?ZrpUQs8frfDScuLMeodCjUVUl2qyFrHnt7csia+p/Oi87RoNV7EurJc3gkmZ?=
 =?us-ascii?Q?pgJD9lOctA+zZj7kOF6/TgQPny5ZytgwrklO16z63cVfyE+2lNXvc3zKdizM?=
 =?us-ascii?Q?Rs+E7r6qhkwV17JOKqaG4rU+fcWuIe9JFNs/f9e2OAv4OK3kLF1UM0Tsfxz6?=
 =?us-ascii?Q?uRC8ErKH9Sdgfxfo+sIVTtMMOAQ3IbduOf469cBYxMAxOzE727ZVSyvSWhlN?=
 =?us-ascii?Q?QR5WYFrvoz+qFit9ULRXxWw/cD29oKv2b7TT3AZ8ARqdqZbZOjro1TSUf+lM?=
 =?us-ascii?Q?Ct7nsrz9IV/jnXJyc9mzlMAgO24TuBU3c/J0VQTcOiVUY5YqEWG+boyNKTJ6?=
 =?us-ascii?Q?HLPKa4xQeiVlgNE5YbNh2MbWuGsgB9DJWMs7CMXQ2aISXF4L/VIw5Qwun5QX?=
 =?us-ascii?Q?P+/CeH2ngeiIDI+YXp023a+aOXWdREN0SIrkGnCAzZ9t9eRglGa/tRiqNdxT?=
 =?us-ascii?Q?lxsTjQG/jQqIAGgGWEqBuwEo3XUWe1oXubW/hCZkT9qbbFA14Tp+pKO6yfPI?=
 =?us-ascii?Q?2/hd4qMP2yLZJ9zd2QreJtcrXc6b2xcjiW1jxZmzPVi9jOK1SKz/ro8T17Y7?=
 =?us-ascii?Q?uoWMaFYK9krYXVu1aI/vfN4bnQTI6pxLsERMhIuZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LYFH42I7x7vEwoE4hQLGMnKqEQfOBQmQEKVKbPbvPfvr27Vk9ACOMWw7rNGQREpEeYUDozdC+AmuFpYcYby1sr/4EvbfgHmcCyZGk4BOjlF1Z0qHr8ZmiZbtlAOfYsFP2DFelf5sR08heyREROLsLa3r4c8rfUHsP6ewVCHNkJCpPNT5UqdsqZl6PqtxUzBzHd7SjQPwxqhd0lXPuUJ0klzoAq7zrtYoFViA3le172n9hUSsB5LeQFL4/MfXviVdyNGJMVwaEr4os2Kg7KMAQzPxU4kZO8+kwWzlbjjzqGQ1s1Xm7hBE5cLf5X9LWU0jpq7oI7DeCGiGRB2wO8s/9arh1kYAEKw5g1yw0r93gVy2qeYJ56+EVaSVU7whofcywJsvSQa00jdaUlcJGXzGWQvtSKcp1UUli33xudvy6X/Y7wR/h/+r7KoxRHAnq/iBMet24m5eGj71VDY/P145ufF1MhIVocHVYLZS8f44ACstDgUjhUhvU0oiAvfiiXGxDZQRydsjrl26LavtujQAnitXZpZqu15HdnXq2AuglYuTUb1MHe67PMki3izLjAVn8+6hsWD4S+BLAtFVLp2NRagkhdAoVT039sgn2Ft/RSjEMdQwvX5zvZhSFuPUrzKM16eYxavqARnO4Vrp+V6g3Z5T28UnsR6LhaxTuJ4hvpcX6lCyFUgN3vfT5hk0GjyYaVdVE3FuLkfuzDoWvMaHCd2oGWqxkiS+7hmZon59uw6RD7Xd5CugvbHIQs5Zr81gVN2Dqd7VWlo5CdaUISL+1ZjkhvHYwCncwJKLA1Bn3M4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5891909e-f9f1-44d1-612f-08db836d2031
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:48:12.0638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwQaF9YtiNQn1JJgeHCvey+f1DdV+qHlZpuiUCliSSo0rbO5wmeLLmaWARZojiwe5FwkRWLto46vaokyNkmnBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307130059
X-Proofpoint-GUID: 7T31EH1pma1LE0U1Ggx7TZ3EMuUWFY-I
X-Proofpoint-ORIG-GUID: 7T31EH1pma1LE0U1Ggx7TZ3EMuUWFY-I
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 11:10:03 AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:58:05PM +0530, Chandan Babu R wrote:
>> This commit adds functionality to restore metadump stored in v2 format.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  mdrestore/xfs_mdrestore.c | 251 +++++++++++++++++++++++++++++++++++---
>>  1 file changed, 233 insertions(+), 18 deletions(-)
>> 
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index c395ae90..7b484071 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -12,7 +12,8 @@ struct mdrestore_ops {
>>  	void (*read_header)(void *header, FILE *md_fp);
>>  	void (*show_info)(void *header, const char *md_file);
>>  	void (*restore)(void *header, FILE *md_fp, int ddev_fd,
>> -			bool is_target_file);
>> +			bool is_data_target_file, int logdev_fd,
>> +			bool is_log_target_file);
>>  };
>>  
>>  static struct mdrestore {
>> @@ -20,6 +21,7 @@ static struct mdrestore {
>>  	bool			show_progress;
>>  	bool			show_info;
>>  	bool			progress_since_warning;
>> +	bool			external_log;
>>  } mdrestore;
>>  
>>  static void
>> @@ -143,10 +145,12 @@ show_info_v1(
>>  
>>  static void
>>  restore_v1(
>> -	void			*header,
>> -	FILE			*md_fp,
>> -	int			ddev_fd,
>> -	bool			is_target_file)
>> +	void		*header,
>> +	FILE		*md_fp,
>> +	int		ddev_fd,
>> +	bool		is_data_target_file,
>
> Why does the indent level change here...
>
>> +	int		logdev_fd,
>> +	bool		is_log_target_file)
>>  {
>>  	struct xfs_metablock	*metablock;
>>  	struct xfs_metablock	*mbp;
>
> ...but not here?
>

Sorry, I will fix this.

>> @@ -203,7 +207,7 @@ restore_v1(
>>  
>>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>>  
>> -	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
>> +	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
>>  			sb.sb_blocksize);
>>  
>>  	bytes_read = 0;
>> @@ -264,6 +268,195 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
>>  	.restore	= restore_v1,
>>  };
>>  
>> +static void
>> +read_header_v2(
>> +	void				*header,
>> +	FILE				*md_fp)
>> +{
>> +	struct xfs_metadump_header	*xmh = header;
>> +	bool				want_external_log;
>> +
>> +	xmh->xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
>> +
>> +	if (fread((uint8_t *)xmh + sizeof(xmh->xmh_magic),
>> +			sizeof(*xmh) - sizeof(xmh->xmh_magic), 1, md_fp) != 1)
>> +		fatal("error reading from metadump file\n");
>> +
>> +	want_external_log = !!(be32_to_cpu(xmh->xmh_incompat_flags) &
>> +			XFS_MD2_INCOMPAT_EXTERNALLOG);
>> +
>> +	if (want_external_log && !mdrestore.external_log)
>> +		fatal("External Log device is required\n");
>> +}
>> +
>> +static void
>> +show_info_v2(
>> +	void				*header,
>> +	const char			*md_file)
>> +{
>> +	struct xfs_metadump_header	*xmh;
>> +	uint32_t			incompat_flags;
>> +
>> +	xmh = header;
>> +	incompat_flags = be32_to_cpu(xmh->xmh_incompat_flags);
>> +
>> +	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
>> +		md_file,
>> +		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
>> +		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
>> +		incompat_flags & XFS_MD2_INCOMPAT_EXTERNALLOG ? "":"not ",
>> +		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
>> +}
>> +
>> +#define MDR_IO_BUF_SIZE (8 * 1024 * 1024)
>> +
>> +static void
>> +dump_meta_extent(
>
> Aren't we restoring here?  And not dumping?
>

You are right. I will rename the function to restore_meta_extent().

>> +	FILE		*md_fp,
>> +	int		dev_fd,
>> +	char		*device,
>> +	void		*buf,
>> +	uint64_t	offset,
>> +	int		len)
>> +{
>> +	int		io_size;
>> +
>> +	io_size = min(len, MDR_IO_BUF_SIZE);
>> +
>> +	do {
>> +		if (fread(buf, io_size, 1, md_fp) != 1)
>> +			fatal("error reading from metadump file\n");
>> +		if (pwrite(dev_fd, buf, io_size, offset) < 0)
>> +			fatal("error writing to %s device at offset %llu: %s\n",
>> +				device, offset, strerror(errno));
>> +		len -= io_size;
>> +		offset += io_size;
>> +
>> +		io_size = min(len, io_size);
>> +	} while (len);
>> +}
>> +
>> +static void
>> +restore_v2(
>> +	void			*header,
>> +	FILE			*md_fp,
>> +	int			ddev_fd,
>> +	bool			is_data_target_file,
>> +	int			logdev_fd,
>> +	bool			is_log_target_file)
>> +{
>> +	struct xfs_sb		sb;
>> +	struct xfs_meta_extent	xme;
>> +	char			*block_buffer;
>> +	int64_t			bytes_read;
>> +	uint64_t		offset;
>> +	int			len;
>> +
>> +	block_buffer = malloc(MDR_IO_BUF_SIZE);
>> +	if (block_buffer == NULL)
>> +		fatal("Unable to allocate input buffer memory\n");
>> +
>> +	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
>> +		fatal("error reading from metadump file\n");
>> +
>> +	if (xme.xme_addr != 0 || xme.xme_len == 1)
>> +		fatal("Invalid superblock disk address/length\n");
>
> Shouldn't we check that xme_addr points to XME_ADDR_DATA_DEVICE?
>

Yes, you are right. I will add the check.

>> +	len = BBTOB(be32_to_cpu(xme.xme_len));
>> +
>> +	if (fread(block_buffer, len, 1, md_fp) != 1)
>> +		fatal("error reading from metadump file\n");
>> +
>> +	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
>> +
>> +	if (sb.sb_magicnum != XFS_SB_MAGIC)
>> +		fatal("bad magic number for primary superblock\n");
>> +
>> +	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
>> +
>> +	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
>> +			sb.sb_blocksize);
>> +
>> +	if (sb.sb_logstart == 0) {
>> +		ASSERT(mdrestore.external_log == true);
>
> This should be more graceful to users:
>
> 		if (!mdrestore.external_log)
> 			fatal("Filesystem has external log but -l not specified.\n");

mdrestore.external_log is set to true only when the user passes the -l
option. Also, read_header_v2() would have already verified if the metadump
file contains data captured from an external log device and that an external
log device was indeed passed to the restore program. It should be impossible
to have mdrestore.external_log set to false at this point in
restore_v2(). Hence, I think a call to ASSERT() is more appropriate.

-- 
chandan
