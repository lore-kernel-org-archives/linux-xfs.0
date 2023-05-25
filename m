Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC95AC7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjEZIzS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242588AbjEZIzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:55:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774B912A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:55:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8YYw2013770;
        Fri, 26 May 2023 08:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=SuVzkMj3dhIF6JGIFgD+rUk8/MRd6R8o2c9s06VxRoc=;
 b=Q4Er+WA/o+2wee5JVWAQpUBG/iiOpSzqFL6ySSDsx9hFzyidsaqKhlL9oljJTKQpKXKb
 hUdMeuLYipNB3SWxD3RclFoAHiC3J5ohs3tLq3Lp/sPwN4EwCDARQ3OtKmV+ZhvUp/g7
 kSPhdlx5yioNFSc4FMwzkoBeR61/+LL/sZrxl2+4yICo7SrQFwATu20Ao9ZHueVZ0N5J
 sEaSEzjhp0KZPR8qAxvBNTd72zceEna7TUToEqh/rVR+/PkEy498R7jOsd2/0VagWJjb
 SbITFE5lFRqtHrKifkuePmWOUvN/e6S7mkgX+SoaW5LodxUVMVJa93uapXOf0DY5ChRT 9g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtscd8254-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:55:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q6snDv023774;
        Fri, 26 May 2023 08:55:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk8y8wb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwaF04/7apt6A+sjqfjEE2uA8zTzjIlsWaXeI0fRZTGXpj6XnuNUOP+G+J9hz2lrC4wjmDru3V8QS5386MWA6sOgnZlwxly3aCslfRW9AkEnN4rghqysekaWkK3luSJy6H82BTfIrL1DbSnai0umyzyHuvwX3Tbmwk6BhpxXrW+5XfyGqMR+bq79ilMMGdg++MCjxxit5OyyGbat6DRE0wPHtsLl9+6yIOTfHyVZeYpPgcPmfti5hKPFUTN9AnZ3FjVfNqVofl6Ua32bbnTan8VubmvQgqbp8oqoxwExUrSXxVJDqVwPvmir40GH0StAW4BG9Nr5C7YKaV7UEZhwCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuVzkMj3dhIF6JGIFgD+rUk8/MRd6R8o2c9s06VxRoc=;
 b=a8X3AR3PZ5Q5cze0WOXJEWrSDI5bC10oA/qGxSWAO5JGj+PUSfZBk28yIWxWn53ASU0SkxPaHGY81QP4uQ6dhgJeXpN/QKhz/a5EeWVQG4gcg4bR4l4FptIjYH1GfrFNuEASGaALxFuqEKmx1Ej9GSYyDoRNAo9RcHQDi7W1CSYOqLHOlECHEjzn9OlRpFCYEkZ8u4hm9alXEKv50FNriaTdXauf9iYmxsv/TEAXY0TTiNsD9glQGgLvhQ9ppYFrcoVDq+yGEQH2dh9nnWG0spB8ub1cukB0E+1qX4ffoiP1ATUPJf0XA2gqrMApSJg4Jm1IrnBYd0n83KmHGOj1kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuVzkMj3dhIF6JGIFgD+rUk8/MRd6R8o2c9s06VxRoc=;
 b=SaRi/N8idJu1ElMdsTIBgNkp87UrWKXMRLns9WPcLaFt4KSvB/mEN5oOx/DQHz72O3DXBmhq5GawLNCYfA0ansetocoG9sW7YW1poFpQT3StLsl312mFIdkEQ3t2XW8oAqo3MCZ+dzRHgEsTux2l72qfg16ZAl5BPLJWaPzvl9A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:55:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:55:04 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-24-chandan.babu@oracle.com>
 <20230523180959.GC11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/24] mdrestore: Add support for passing log device as
 an argument
Date:   Thu, 25 May 2023 19:13:03 +0530
In-reply-to: <20230523180959.GC11620@frogsfrogsfrogs>
Message-ID: <87edn3iian.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0049.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::18)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: d413bd1a-ecaf-444b-3e33-08db5dc6e59f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1t5ld61HzO/NLqDG8Is0ux/8wyNac43Y1Tt7+V4L6Pn1/wf36M2DPQdGAnHETAMOmz4FHegKdHLCIn8JbcGSOy+oTFCqWXeUwcTNKK61ljpvbigyQD0NpiyvR/TO0my8hwBBpH/srGptJGiPcC4xs6nrmBVHYSWDsA8JEh58MzXCHOQvMgtCBrwoDvjaAhKdT08KepRllaiq2SLfvoC4RCk4x5Q8rJ9RQgqQyw0KHNz3JFKrIXvfXhWmqgAsCR0RDyjWodC23Twy9QO11eROUji78qJiTygH+SbjNouzJ9IuPN73uQq4yzhX82r4zh71hptgJAauw1rw3XD5NMUzFyAKbAkULdxE6uf0bcDbn8ZtbjlzQwIbWoD0B9Yi365mTqEa0cw/3baan1Sr+F7WMgb2cDp38cHGEbWo4jRSD9aegiTugx8pgTHRW7WyfGPWQFCt12CMhhTHdwrxuoFBloZQypVXpet9psUjjnlyGd8qEaohohaiVgUW17gj0fs8SMJHXTChei1BnRwHVKKCnEd5ZFeQTpElqtuM07NmE+bOqk41jdFrY+7BQ3+I6/pK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0NkaW0V9K3Ifkepo8nGA9DgDJ0BBdrodGCqWJmcpGvyY4itigDdA0AsEPtOw?=
 =?us-ascii?Q?owX1gvWIAEP6ECXPetLUMOCRVfm6p5cTfPisgjfJhc4jrSMXRzKMhDmc5eOn?=
 =?us-ascii?Q?PzO/iWdG0bIWDCFPaSwJ9L5XlQiILX39N//mzNFMmpjCByJzqdePYZcDYhn4?=
 =?us-ascii?Q?MJ4CbSJjNylqCWK5FF2NSaUAN3gVrBcZ8yr+RTmuSVp4loiVpGYxiMspAMCY?=
 =?us-ascii?Q?7OJ0HmIVs603GKjrBZ0r8jf2e0/U6IjlHY+oQJdIbn5oZJjDVP3oaobgKl9X?=
 =?us-ascii?Q?S6FKT5Euy8zQQd6Jw8e1qZmbAp0l9x90FEmWtWG8D/HuGKbZpf/sN9eMUbk2?=
 =?us-ascii?Q?gtCvm5H3pLSnr3hLSb7YR4dbyr3+8nZxzAN1B5nD/xULKaXOs5GES5R52Tgw?=
 =?us-ascii?Q?XKExJfM8pol0ADHvRvFYFkwd7/IoGKe4QRegEKjDW7bMu1ZyNPzuQpUmhgqf?=
 =?us-ascii?Q?SJWS9oWFtotKTejCz0AWN0e4pdgXg5RDr92cSun6yYpxnWC3Eq4yJohHw4yN?=
 =?us-ascii?Q?pjQcKmlOuxfeRHoD9CLvfSVcKkCra28VNz90XyGAbWuqYMQS37RPQc+599u9?=
 =?us-ascii?Q?svCcrsp3IGvPlEWjWCirLFSt+u3UvXDgSAzKBNSCbwO9CmoZYonmlNUxx6KN?=
 =?us-ascii?Q?zBgeQlllpVt9yxIr3Bj4T06r4AlAq4LODFpKvkvH3nNmzv/zGPerMCC6kJPt?=
 =?us-ascii?Q?BlSt7YVbv4KewtQItr9Jy0LgyHhd9mvtnoPXStxcelpNkdSm+Tgk9fBHtOso?=
 =?us-ascii?Q?CGhfkg01wA7B38KzvFWBdpNW8KIAX9DXmGWs8ys6o2qAya06hglrR9Go3rHy?=
 =?us-ascii?Q?63nmFd8epUeUL9gg+q+lZqLA/xWtQQn4wRjeuPLwW8tl9JsA0lqnkcYGZxL4?=
 =?us-ascii?Q?dS8alMxhFaYz4zgI4ydVvSLe4dqh+a0SUzASKDWFuqOoJQ5UpLEv7u5FhMSI?=
 =?us-ascii?Q?0AeEIl2n0XcOxVT5ZxsMRWW5QCkkZmwCELqbS+OucTXjZEy0GB62Jt30xWlk?=
 =?us-ascii?Q?BfTXKuEQKLTeS2wao0u94R4Fp9jnr4v5o/3ctTn+QOo9b/YRAzJuuRJw517A?=
 =?us-ascii?Q?YJysCrV5s8VpmgCSB85R3d4WL2BxPVsCylppXPEfkoix4RCnIbzvi28M7BAS?=
 =?us-ascii?Q?m/w0Ci8pZ5iHOXE27ynUfC1CLcZPxKEKtEpysVo5OK2P+pWA37qpi5FoxNgh?=
 =?us-ascii?Q?dyn63EUeLHGKVs05HzX8E6bnIxKZ7zHq37mrWHcc168q1oDTeF98xV0xNmGZ?=
 =?us-ascii?Q?JLV0z6wz/DFqNRJp3wux1fuQ5EXEhYH1nHSPLvnjiqwpMl2iedOrbbnbaNX9?=
 =?us-ascii?Q?WAUjt3OKyW+8/Zt0hX4Y02rJkyrPUEsxb2BarZPngArG0bvPjZXXvEEhJy9G?=
 =?us-ascii?Q?XI0xHr9dZl+lbTW4CzJF2KEvBOectbi8picS/nX+IDS8TJ3EEXHgRhLbOKpo?=
 =?us-ascii?Q?OF6kLsNj/mxlFDNf8LnHMtO10ugXl64VD9iUF/1aitLmmVpjWww8brHF+UmO?=
 =?us-ascii?Q?pmZZR67mEMjLkOZP5rpovR4bpD/LX9hxjDGpOJ294GZ/U9yDbh/w08rORefu?=
 =?us-ascii?Q?H3DAh2NEzflXpGf4lX4hXiW3vW7WWfPvJ9kS7ydcmcEQn3XNMdm2RjrIo5fQ?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: shhndZ0kS+ccqxYI0/GyiZrIxKFPwUhAvsxOTH1lLEZ8N5+tNT+PURE1j8AAFhNfHJuW+PHg3gv3pUrq0J0+j+ZVG/bKT2IV9g6Ue2ZY9DBl1emXPvovfbkzNnB5KNe77JjZNAsRqAz+w0qY4G261sqifNv1A4NlQVDCgevIcpsohjMLhnfnhBE4MKqT2Qakptj6T7IM6wwVRk3mIx6tD5xFx3lNG2cpx3kNBPhZaT4rE3tGW7H3tPV1iDK+jlcAl2pbqgA+/Red0qR4i+q1BeQii1E7kMN5i1MJDA4RTr3jMTuleovro57mG/ugRXlCTOGc3y4KWZnfpY37vBewsSUvrsfWHVINnh5U0HUJ+8l3OJnotMcekXrXI1TJcDWu62zbxZhTbG0JOdJOF10/ruql2bqgvDlHtB9BoKfdnTahjfqhBoJ2CYGUem/X2T31ya+llHYCGNIX42adO2PjR8M2cnc/mSTu5EY0v6xGIhYMbny28I7Yu25GkltzyqJyPuTNZLehpu9DtQO9eap18rQJ8UHV0cw5XFYsO/EQV4dRjYXwfTpjrJuktaHsR0U9d01DdyfKHZsTLpEKk35ehb/tmGreX49TOnXVfaquIblzwXohpAitBYmgi2bNzpi8zM0UKWG8DIh3IbRrkxjPE6ulQAGIm9Nd99IKIijnpfHgl0SmpzJCPxsLFcC5NP91uns9YUT1dCPBvtYHR0+5DuiFF5sX0PER+WMfi5HkgPlWZW8SMzivqhyWevZ+uS0D9P9t3H/rzf9DELAPtVLyo/y6bSsHsdR2GyyNgRxKWPM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d413bd1a-ecaf-444b-3e33-08db5dc6e59f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:55:04.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgN5oruAEPU1q9mmuELDLJo65HprTBv00MqBVLFoJ8gqk4qkcsxS1mpYGY+F0Pp8qILQ0yvXBA2ZKS+sIk3/aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260076
X-Proofpoint-GUID: uQvc-cfLV2c3aj6XFhNO86bumuxs_cLW
X-Proofpoint-ORIG-GUID: uQvc-cfLV2c3aj6XFhNO86bumuxs_cLW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 11:09:59 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:49PM +0530, Chandan Babu R wrote:
>> metadump v2 format allows dumping metadata from external log devices. This
>> commit allows passing the device file to which log data must be restored from
>> the corresponding metadump file.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  mdrestore/xfs_mdrestore.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index 9e06d37dc..f5eff62ef 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -427,7 +427,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
>>  static void
>>  usage(void)
>>  {
>> -	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
>> +	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
>> +		progname);
>>  	exit(1);
>>  }
>>  
>> @@ -453,7 +454,7 @@ main(
>>  
>>  	progname = basename(argv[0]);
>>  
>> -	while ((c = getopt(argc, argv, "giV")) != EOF) {
>> +	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
>>  		switch (c) {
>>  			case 'g':
>>  				mdrestore.show_progress = 1;
>> @@ -461,6 +462,9 @@ main(
>>  			case 'i':
>>  				mdrestore.show_info = 1;
>>  				break;
>> +			case 'l':
>> +				logdev = optarg;
>> +				break;
>>  			case 'V':
>>  				printf("%s version %s\n", progname, VERSION);
>>  				exit(0);
>> @@ -493,6 +497,8 @@ main(
>>  	}
>>  
>>  	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
>> +		if (logdev != NULL)
>> +			usage();
>>  		mdrestore.mdrops = &mdrestore_ops_v1;
>>  		header = &mb;
>>  	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {
>
> What if we have a v2 with XME_ADDR_LOG_DEVICE meta_extents but the
> caller doesn't specify -l?  Do we proceed with the metadump, only to
> fail midway through the restore?

restore_v2() has the following statement just after reading in the superblock,

	if (sb.sb_logstart == 0 && log_fd == -1)
                fatal("External Log device is required\n");

Hence, In the case of a missing log device argument, the program exits before
any metadata is written to the target device.

-- 
chandan
