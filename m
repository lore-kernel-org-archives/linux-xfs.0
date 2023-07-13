Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79500C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjGMGkz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjGMGky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:40:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4901C1724
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:40:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CL9oup008382;
        Thu, 13 Jul 2023 06:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=uUJgzVgRZMoZVAuh8bWfvx5/hZctlb+9CC8VUm0Z2d0=;
 b=zS3QniPY1cC65oE0e9wv8HgBb6tfpZN8GiJftme1gt6i0LZfvTtXE5MCJaFtfYd+TmeF
 1vPWIxEN8QEOTm3mmgB6b9+hKVT4capvxRyd1VbsLSED/EBc6hoxRHFGpcY8187naJJS
 ZlhVCqwjOUtQOMgYMd2q1wuYiig6dEup/yIQSPAY/HqM3e/pGFPrpICKit6U/qPnYnBl
 DJheScSkdOaWf0Rda9SAvUiRIXhizqPU23e4XVpGbes03IR0zKJXQnI/fO0jtXbfsJAf
 p3nhgr6tIZM6u/DWfhpbFA2vvTdwb6AqKeUzf9/i8CB6LH/IBz7OstA26FU5ex38vZts TA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydu0tjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:40:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D5CxqE007120;
        Thu, 13 Jul 2023 06:40:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx87tcpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:40:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgIKXDE+sSMyjoDXV8GUJvgC9oR6nIqJSVeqfosn2r8ll2uYDyWzzPd0/A2JwFx9NbZrinNn5w+V6EXmGT569DR7uZUaq3ajQs4SsQBWHST59UBEqXJGtFj4X9rtk63bccMs7Re5W8VD525TgEWQ92myNH05PSvqv8M+ZYWG4jUwUtuW3AWX9eXLh7cFFStTrRj01qVXvYsYmY22FiH9Zj+xEVRm1i5AHOMaXpPewXlpGsxVG/dQZKybQoEhO6ObFdYyHM0vOjJS06TpUgEilG4/L9TQmDgcEgXq6+PXlmOJ2nwI1KTbRaQvGijiCUL6uS6EIJ3tiFxf26GRl28VPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUJgzVgRZMoZVAuh8bWfvx5/hZctlb+9CC8VUm0Z2d0=;
 b=ZIxplvWTm0JjIkS4cy7uif1Nmh6VAmsbhbV4RS7eCZlyixPDfEM+G3NfoiNJK/gvR3ChFuI4XUI1HQP7nMtIjAQBU1wpQ18g1OI0jtcXiAFhTQCxFfMzB22b46s+OJJz924N8bzULhjPP33GR4iyh/Xp+X3BZTzS04GiniSHKznI4ssN5pvEENJsves+XuBfu9TvMr1UbDaLlqFiutL0nnvjTAmI4F9ltlr6slaSNo5NWPqkYIqcLlidHpAvS77s6GOvWZKBq46D485WcUHQJTnn0gTgEo2oXosJuynmCWgzz/BfI3dYiKt/A7hLqFqvNse/LGOwPRzUT3JTgYcSeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUJgzVgRZMoZVAuh8bWfvx5/hZctlb+9CC8VUm0Z2d0=;
 b=qKsb0cbyfgZf1P17gLyT7SC260rcXDkUil5VNEmgc/MaZ44FI4q8mDzzSDmltxIcbcfyOTW/lXi4VS6WpSJ3zDX6ddJIiixeRGm/Vuw+k+L9F6W/i4pKmmHzApvtPKv61PTr6J9KAZSVBc846lcwr7OKkCCEvoqbeof0f4JSbas=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SJ2PR10MB7759.namprd10.prod.outlook.com (2603:10b6:a03:578::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 06:40:47 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:40:47 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-13-chandan.babu@oracle.com>
 <20230712173529.GK108251@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 12/23] xfs_db: Add support to read from external log
 device
Date:   Thu, 13 Jul 2023 10:54:26 +0530
In-reply-to: <20230712173529.GK108251@frogsfrogsfrogs>
Message-ID: <87a5w0jouy.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ2PR10MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 63026b96-f8cb-4391-02e9-08db836c16e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4dQ9wS6d6ugRDmfgtVOM4qm6UtZ9yi8mfajQOITUtjg4kWa354CEHv/7Ma3zj/mWTqSXQkbs/pneE90/JHj1j0IE2FKnlWLvCrAIPiQDUHwhe/TEJ0EvHUW8snfS3TTr66KxHLS7LWXKouVMP4HnjjCIYsOx3Oxw+gMR2yFZQB6qTIJrKS5nXnhejvYquOdEkHK/yAZP++khs+KIJVKPo8DfS29ksmyCMCG0ql6psRLDXWpZmDS+goFkBejM+7kalDuu8/bxzqXqBmitofure1Wx2pKos/lwK+mg4my/HCkgR+Y944E9JguxW/gGiglGN2cs0MueaT/fygXhG5sPIoTxGcaU8wP6+zsbGJBxHgtDMgU7jNdfTiSIVNuWowmyzej/xNrDHXvpE3Fzl3EG+EvMWqi186WI/91Sc8g44bo5VnRfaW13531iByWMY7PFrd2Ql6byjuodSNiKf06H+iNTA09q3ltaVacTXCJ/Rzw7hFof2akH0oH4ZS4dXWRjvK2Mbce1tT5eU8cD053XosoIbEI5nVxtFPKZESEq/pSjhg6710vCBfP9DqxrsRaq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199021)(86362001)(5660300002)(8936002)(8676002)(41300700001)(316002)(2906002)(66946007)(66476007)(6916009)(4326008)(66556008)(38100700002)(33716001)(83380400001)(6666004)(478600001)(6486002)(186003)(26005)(6506007)(53546011)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1WoAHe6qH2VGnRBwH4dPnRx78puCTxH18b/NKwVl+99rGRKyx6KK6/P6gzRo?=
 =?us-ascii?Q?6Pm9FuZezwmpyd5gI9e8AL1NZZgA87YRxdeQ/IZoT1uvhT8h6C6LqMMrtpUx?=
 =?us-ascii?Q?ofj2ld7t2AEpPCDgCvO3aaGeFeyT8L0bh2/fdpH+ZrCALJnj2cZTGe/8QY6R?=
 =?us-ascii?Q?bubZCTdASmmUStxl6lTPYVmSVVEZnN7ukQ/vvgfoIM9kH2kbd4sU1WhV/0L0?=
 =?us-ascii?Q?H6tAqmB0Zl9fCCSmBzaY7jwHA944CSv16Jy0VdrJQ9b46XWPvwRCKpppZxYS?=
 =?us-ascii?Q?uTvIpOddvE9jKcFj+aVWDEckgoTCMNvJkYKMgrlXBOkebfju4LpVHnAhzply?=
 =?us-ascii?Q?qPnw9FGCGoMpeJMJQSaUynYn/yFsUvu9uS62eLR3JZPX6k4P2QwxORX1RBYk?=
 =?us-ascii?Q?l3HbdwwyVjUVyfWfpxduWKfT4GRt7Q40JG+HFyXIZewa3g7w1mtaiQUe09+r?=
 =?us-ascii?Q?QLZJxNq6BClWTogdlWT8nZi6Mx+cbkZG4xuH8+D4nEUyAEh4rIPyHGVl2bAm?=
 =?us-ascii?Q?wQENHdbU2Rs72nKl6TxFObzwCszQ+IQqomM9aixZTc7ASxRY+mm6Mx3FjfAu?=
 =?us-ascii?Q?wZrQvy7Mys0bpxZuMILmxWA9B1U8ANlNj6fgQTmzKKzFrBv+IkTVgtIUJtoV?=
 =?us-ascii?Q?3HYK8VLNt1tBwU06DbS9wdt0WwW4RvNowkAooS+zdNZ3mPQdSw9FwOC21Zl3?=
 =?us-ascii?Q?q0RxyL0yqKOdOCsImoj+9d970sGx/Ky3U/CXSuavgN4tzdAvJUiJOHnPVK2I?=
 =?us-ascii?Q?YcQ3dLBG/fI0izGqVt7SayroCTTS/hKWity+h7bYIeILgdgesVLk/8LjB3So?=
 =?us-ascii?Q?Gy4t6YFbYKeh3NOcDUR0zitimqzIMq96vJP9C9iABBumEm5tXsHPKPh1bHmv?=
 =?us-ascii?Q?gPWigFZVTvu/Y0+0Wa633GDs2lrWizgSOrBj7+3RlIIIBok0RwIyRG8zS2rl?=
 =?us-ascii?Q?djZwwdJWJP2vmdM2Sy6F06CeapnP7d6IymGEsTcq2BD3UsJucui6q6+KZpWF?=
 =?us-ascii?Q?or03naXPAD3FD/F0wRHwM7edEO2UuuRFBApikCbFM9ngcwUp7OAlLIt/8ZzH?=
 =?us-ascii?Q?FKBaMjbeO++M88r2qKXlrBkLNmqzbvxtjhXayixUzMiKn9G3PaFXImSRgR+r?=
 =?us-ascii?Q?RDUcURnBUU3jGP4MejChttX+itofucD5kbgjFYhAT8CEKBt0/3Ib8bhuqns5?=
 =?us-ascii?Q?V8WjMlQXB6qT9XnZvZN5EGptMPDpTnJxW1bNzJ+nY/elzWDOoX65fwN0lUFj?=
 =?us-ascii?Q?xqYsiT4KbQaGxKLhLRbWVBTpxSfBAVuy7a376qnhZqlLZ4D7TfMgMbTkV2z7?=
 =?us-ascii?Q?JImO/6f8VJlLBLvC6ICeIfpPSwGY8RRsMqy08dgZJMLSnJb11HzIm/8zJ9fE?=
 =?us-ascii?Q?ju29LVIlrb/FmD6ReVPsKshQQ1tDreHG006gWul5eKlviAgsICdK+Q3XB/a5?=
 =?us-ascii?Q?Dexz7VStdieZ/gWmhL+HUsbjKDmMTOf0WAwIb7+f51szdFpcbSZQql+6rjsr?=
 =?us-ascii?Q?2ad00G2rB4qHHOL+HWqYpwxDcu/Z8OAf6yI+m4SmJIohAfHUj/Lt53ABAyo2?=
 =?us-ascii?Q?hOgIE3HqmXrYTJLkJxbYpRQZh4QY6/OHXlzIwoSl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sCMoXP6MJqX7qUCpVOsxOwyUUuAP85Gof8+iSs8+nEBnGjPiiCMA3wFXsO2lcvlsbzYg76QMmcPE8/Zwt5qImgNaYe8ovFW3w5ee0xHVAL0WnbdoRI/HZTW0VOTfYn692ITA5u2DIo+UQJDecvaOC4u/9cRigUAyn18muzCtILI8r7N8oeCwTDiGuqpGplPm0N07ELexI3HrhiFNdhRkP7Rj+/PSnhCzOI3bK+QT3hK08wOZU+4qydYJIsPvPtaYEJlrQmKIefaGAee7f3slsGqKt9H15ISiCfS2hq4ob1TOutKZ+yGHjk0s0mvfD0G0mWJWhisUZxYWXCTLo7sxNB/pYagzhGls4RwN07r3qhHefu2NW0cPW3dLubyIvVZNfkq19+Azq+o58Ii1+XTR2JKRvheiiK1DtGCAYWaIJLUfykIDjSND0F7H0eOPPUXZpJqP9zEYiaGklH/V4WfisnF1HAqUwh9C3v5Pt8HhK0Gx/e6lZ0d4rXxlFRF/DTnJZwE7eX9pOAv3vwQKtm4pZuHOPFhgjdwQ2y4hndXxN+bJpt2AJcP3TWWBigaMLMjA33LRCROxlD2o78HvD/82+2rob5baHgf8kPBrz7ljtwILCiMV8BobVB/jhEi0hx+4DKFMP80WGKlxfdDXXcw0usWWP9ZNronjl5Czjyf3g09ZuygI0GSrQjwMrS5PPAXHSZbk5tRjQpbKtcmSv4OguM+enNDzH/YqkBg0xoOxYlCIcMWW6ybXJJNppwFKxWRpZ+izdCxbdAkDzMpiu7Z+8Wsll3PQptnDCDrWDaVvOuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63026b96-f8cb-4391-02e9-08db836c16e9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:40:46.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5u1ALr9tcd+2BG0oZrMQDUd0IylY/2lYeUExVRU9SZyzZVA4HrCO+qN108wrJ7PpghS5WPdNyj7YrusDx6WOVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_03,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130058
X-Proofpoint-GUID: 32yDY1Jiqg-Z8js8X4u1RVZftokSgVKQ
X-Proofpoint-ORIG-GUID: 32yDY1Jiqg-Z8js8X4u1RVZftokSgVKQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 10:35:29 AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:57:55PM +0530, Chandan Babu R wrote:
>> This commit introduces a new function set_log_cur() allowing xfs_db to read
>> from an external log device. This is required by a future commit which will
>> add the ability to dump metadata from external log devices.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/io.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 44 insertions(+), 13 deletions(-)
>> 
>> diff --git a/db/io.c b/db/io.c
>> index 3d257236..a6feaba3 100644
>> --- a/db/io.c
>> +++ b/db/io.c
>> @@ -508,18 +508,19 @@ write_cur(void)
>>  
>>  }
>>  
>> -void
>> -set_cur(
>> -	const typ_t	*type,
>> -	xfs_daddr_t	blknum,
>> -	int		len,
>> -	int		ring_flag,
>> -	bbmap_t		*bbmap)
>> +static void
>> +__set_cur(
>> +	struct xfs_buftarg	*btargp,
>> +	const typ_t		*type,
>> +	xfs_daddr_t		 blknum,
>> +	int			 len,
>> +	int			 ring_flag,
>> +	bbmap_t			*bbmap)
>>  {
>> -	struct xfs_buf	*bp;
>> -	xfs_ino_t	dirino;
>> -	xfs_ino_t	ino;
>> -	uint16_t	mode;
>> +	struct xfs_buf		*bp;
>> +	xfs_ino_t		dirino;
>> +	xfs_ino_t		ino;
>> +	uint16_t		mode;
>>  	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
>>  	int		error;
>>  
>> @@ -548,11 +549,11 @@ set_cur(
>>  		if (!iocur_top->bbmap)
>>  			return;
>>  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
>> -		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
>> +		error = -libxfs_buf_read_map(btargp, bbmap->b,
>>  				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
>>  				ops);
>>  	} else {
>> -		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
>> +		error = -libxfs_buf_read(btargp, blknum, len,
>>  				LIBXFS_READBUF_SALVAGE, &bp, ops);
>>  		iocur_top->bbmap = NULL;
>>  	}
>> @@ -589,6 +590,36 @@ set_cur(
>>  		ring_add();
>>  }
>>  
>> +void
>> +set_cur(
>> +	const typ_t	*type,
>> +	xfs_daddr_t	blknum,
>> +	int		len,
>> +	int		ring_flag,
>> +	bbmap_t		*bbmap)
>> +{
>> +	__set_cur(mp->m_ddev_targp, type, blknum, len, ring_flag, bbmap);
>> +}
>> +
>> +void
>> +set_log_cur(
>> +	const typ_t	*type,
>> +	xfs_daddr_t	blknum,
>> +	int		len,
>> +	int		ring_flag,
>> +	bbmap_t		*bbmap)
>> +{
>> +	struct xfs_buftarg	*btargp = mp->m_ddev_targp;
>> +
>> +	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
>> +		ASSERT(mp->m_sb.sb_logstart == 0);
>> +		btargp = mp->m_logdev_targp;
>> +	}
>
> I think this should print an error message if there isn't an external
> log device and then leave iocur_top unchanged:
>
> 	if (mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
> 		fprintf(stderr, "no external log specified\n");
> 		exitcode = 1;
> 		return;
> 	}
>
> 	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
>
> because metadump shouldn't crash if there's an external log device but
> sb_logstart is zero.  The superblock fields /could/ be corrupt, or other
> weird shenanigans are going on.
>
> (Also it's a layering violation for the io cursors to know anything at
> all about the filesystem stored above them.)
>

I agree with your review comment. I will make the required changes.

-- 
chandan
