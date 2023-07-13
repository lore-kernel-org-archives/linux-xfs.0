Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AEFFEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjGMGlw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjGMGlv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:41:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3711724
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:41:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CL9FJ1023779;
        Thu, 13 Jul 2023 06:41:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=1fywVYJBC9qLh5th/mdXq0q7X6KJSbl8ayCkSqKEOio=;
 b=d4AuQZ+HJsFOUkM4gOY4YjTx4oSW41kvDPyn1K+aJ+AH17FEeIMtCEQ3s6hSucScVXd+
 WmfAgewE8zDfKIhkPEewePHw9jUXD9J0Y8w9jow2vnsQd/Zne/8t5E1WuD24JQEwCizn
 JpKXGvIQLI8O0L6JUCaHzQQZwnAvunQ2KYPigRInWzCnkM9gcEJyE0F0K8KeFz806uAX
 Hr35P2PdfARoL/iCE6aVYb8VnQZRxGnXY3OrgAApkmLa1r1N4yX2h7qb+dmQtNlj2raB
 XedGZoeO0FvRO4azcB/RCXjI3gdZE0/4yVnx7LSpJoqXDYW5/pkcF35saLVbAu/GvYTj kg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrea2xu27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:41:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D4tdXZ007211;
        Thu, 13 Jul 2023 06:41:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx87tdup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:41:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ayy120aUs+qqKYrQNZFW4IYSC+qmyP2rZca37V0InTTSkz9DcpO+PdKtjgm5YrfOklyd5+3NSp9kAVTzcC4cpgAyvyrM3WuqkMwbq71eQu3jQcnm2GlG07MwG3GM/qTVpfpNROrlpMkmbgOsUmV3FguZEKBylK4Z4WOIMnP7/aDTEcqG9xBXzBk6zlre590oo753Dfu0cjOchlBoK9J507iGK56M2kLX6qtNJ2tzwj1rhCT5ijmNWaOBQ1g2nWhShT7w2AYjF49hMpkVPnHNZgI2ClYJDU24XaplrgXDSzBpfb8EgBu8zJL1D91dFe9AKRUtePqqTvBv6K5A9sO59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fywVYJBC9qLh5th/mdXq0q7X6KJSbl8ayCkSqKEOio=;
 b=CfxFOw97LGwcB5JGYdaUSXmyTt46DdQkGzWtUE2Y9yByXtf+aQZRZvZqxueu+hRZevVorKImTXJIsVGtrCa2wJoxNnU7a+ypCkYbN8mM30IdnKH0yK22hsMb6435MogG2CvDI7UxkCkUZ9RPITmXVZ8OE4d3SNaf9ITFA7M4IvXAV2qM4kTUC7eMgbBOUH0iXcnsfVpjNyr7hr268T1W0F70Tc8jeS2OUg+EgD8wHbAEWUbf5jFzbGOCN9V4FYCuQs2mUxGJcDUpw/ikmf/SU2lBuWHTpLYaDzxnRaDQVzHAot/65z3W+UqanKoccAJm47441gJK1dqtAy+Q8XlHfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fywVYJBC9qLh5th/mdXq0q7X6KJSbl8ayCkSqKEOio=;
 b=QCzAeuTaeACd4DPq9KlDe+1+1ZVnLY5WWGsnmDlrY+54cJkTg6YdcVrz9NQtfRHaS0qzzIOG/X71MSvlrOObzXra/pSHcQBod0qrN/8w8hVSQlTbw9Lz9Np7pllgMCrQ+wlLaXCkegQ8tWCSFVSNQqnk9r63uM2IWXktrbXUXLA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SJ2PR10MB7759.namprd10.prod.outlook.com (2603:10b6:a03:578::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 06:41:44 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:41:44 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-18-chandan.babu@oracle.com>
 <20230712174609.GN108251@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 17/23] mdrestore: Add open_device(), read_header()
 and show_info() functions
Date:   Thu, 13 Jul 2023 10:57:28 +0530
In-reply-to: <20230712174609.GN108251@frogsfrogsfrogs>
Message-ID: <875y6ojotb.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0011.jpnprd01.prod.outlook.com (2603:1096:404::23)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ2PR10MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c65898a-a1ab-437a-f7a2-08db836c3944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RAIwOTCsOL1E1fr+V0ceXbd+oQptEqKf6iH/Kve2zxz2RJmYUafwtx3AA7nYPTDySOKMhZQujSs6PzRpCj5zR/dP4VnFBVX+eZsPW1Guz+J7xWT0BMAY9hZIfMRlrpXuJuZmoQxDSrhFzKfbqC7Jsn4mR3w5oMY8L65tJC6ZRWJZeFNMjjlen4iIMnfyLucKb2Oc+FtohgpceVXGK01gdxu6duMlMErugjJGOXeteZsH8OKYO7uZGQvUvO7NEFx8l09EBVnHODHMstjy+Rb+6XGalqnojBeQef5I1UMQt5VFv2Rmsr4fJ0uMPkZNdOHUF3sXUE7TQmyc2Bic6/Fj1Xv8IQpchdsB8oR+s/UWp4IVVpYcwaxeniN6Oxt5Ekd3JVE3KuedahdWVh7jZ8oTBuSnSDyVbW3S2IJlWqUgQjlDnRQbU0SZHih7KAhyTaK7d78Gn4iEmEVzH40CtilJB+BQX8BqKGCz7ANpUiQpLD0YBy9r0PZ4wl4/vDEy7mrfOE/bf7AWPazvali5CnqKDRDVe9b2gPqFAWCfDsJcsxmbB61HgD5bV42lluHjczB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199021)(86362001)(5660300002)(8936002)(8676002)(41300700001)(316002)(2906002)(66946007)(66476007)(6916009)(4326008)(66556008)(38100700002)(33716001)(83380400001)(6666004)(478600001)(6486002)(186003)(26005)(6506007)(53546011)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sLY4nQMMmGoYUocFDnz3szZ3TqCVsj6AbpI83JK1zLQrPjA262O4v9n1CyU8?=
 =?us-ascii?Q?JzkoChx8bLotufpDrKFHwJHjve+Ip1iIDWGfVsu1wOe9nbRY3FFMH38VD+rr?=
 =?us-ascii?Q?5jB38eJyR7LS828kv+UYiBtd6ZQ8IoaVEsOMKj2DPc1Gq78o2TZAZBM/HrTH?=
 =?us-ascii?Q?ouex1KOSuDP3xAgRC7zyAhFxBryPdI5h3gvSQckJMqbLpVcF28PJVEUEG/bB?=
 =?us-ascii?Q?A6rbmD/2dmd0+xHaekZWJkDeOHR9WZcM5IlnFzHUSNCVPbRY2U+qdIEMq1cR?=
 =?us-ascii?Q?jnQXX4pWd/7dCXyn5qBpJqBZpb7IUE6qMq2fz87yQcxIsEbedW8WvJiHG/67?=
 =?us-ascii?Q?2nl8PSOIjbEm/+uZCW67voaNKop8SPV53g5akvn3CKNGeIoKEOyX/gKA7AM2?=
 =?us-ascii?Q?4BAeW6wkl+2MpLM4Cb6MrYpWnV2RYbFSeSttiFM1HktHSGmmS6N1Qlvz32NZ?=
 =?us-ascii?Q?fUxMTLqHg6MV39hPkUCF/S9EO+68KX/Qv3nd9ufUK8QDoUN7KQg1X+vj5t0B?=
 =?us-ascii?Q?lW3YqNJx/gvcW/kreXaHsFQ4wu7Ei++eAGki6QMCrqR1WKT9DWE3LRFDz1gB?=
 =?us-ascii?Q?tbPVftFGecwJ97aajrrGPhoxNi3HjaTYWdedphpLKc39jzx3gdXXjYE9N//8?=
 =?us-ascii?Q?NPCjQFeL7ofzMo+1KDyezI3TrPED6ueoG/tTXioPQrE5rrwfP0w6EOTl0SPD?=
 =?us-ascii?Q?Tmp+CwP5Xb31RXoOipZeCfWvUtK+IKBTQS6vZH22g7dQidUqDckhBV8QTBON?=
 =?us-ascii?Q?zNmX2FLIRUXz8/YVVYTP2FQTi9m0k6CMXDBE3lpqflmcblkaffDWTxPm2poB?=
 =?us-ascii?Q?oUI7YqrgdbhupvRUF3CI/u2ktfog8me71v0uK2n+m2r1MYsyUg9xuulNCxGo?=
 =?us-ascii?Q?HSis9nP0M210u88CPPjYdxhYEUMd/G17YMyaNr5Nmbtrwldl6lp7Rjje2mkm?=
 =?us-ascii?Q?joHRweXMuIMdzIWbMKbJ0m5Rig5M+FNPd4c/g1R+bIQe3N3K1V328nCr+qHO?=
 =?us-ascii?Q?rxw6QLIvAl+T0bOLKhdbGjWt+TV/yDHA2UdKkk4l3NgYZQiPeJr+o9cX531C?=
 =?us-ascii?Q?47P9IQWaclLhGBdC2BSE4pFwGeV9y3h18kfnlBkoggLS270zzgvjjAiea06w?=
 =?us-ascii?Q?cFfZSMgjd+ivMiRuzPpaNjB42ZZy9ZSyEvaIWshiKQ2HvLJeJUv3pLUPC8ad?=
 =?us-ascii?Q?hixlEOEz3LAN21LG5f7Ybw7Kdi9OL0OXx94J6y5ABiLyG3yn4thqbzVYWOrK?=
 =?us-ascii?Q?L+jTp92C1r3zXY1DCLEO7xVshAoPZbbCc9MWaHumHuRsRLHR8pmBjpttdVsm?=
 =?us-ascii?Q?taOxV++6/QXkpADRRmdl/wXvrk1ZdMU1W4EunxJE/iz01LqkU+/yeDRmioBR?=
 =?us-ascii?Q?Agjv8d4M6HXPTrAbM+fmelSUJJT0iqeGg62e5s7Jwl0Rb3FhCSKarbQ8ZEB5?=
 =?us-ascii?Q?RqDTnpw6WWds5vaq3qxEEi3kBT8yAaVudQCJIQ6lh+ManlJ+0iJCb08/z2D7?=
 =?us-ascii?Q?eZgac9vX6vj5u6jA0BKjCUt7EhahZ14avF3pFCJi0SwaMoYttY59t5uGgsHD?=
 =?us-ascii?Q?6zWyfqc3SwruBQUFzNLFA6FK5ozE6eEIunBjmOVf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vUB7S2tfXiGrHcw/WC4sprTlPX95esmh0WX35aTB/kPnE8QteTEGj5SgKAkg8MrPajg3yeGJnRHyyC4haXtSGotwKrWhiJFCm+iOBGdDrkSn47BBwd79AxMo9IauNtbVtaUY6hOITZrKWvEoysKD1KVo4BskefSA4gYP1OUuTtg5iHl+3sfUNgh6oYxS3ae54Q25WCuXVblLf79jAvaqMX+I/UY1uI99KsMevKSYqFWknmZPVp6irbqj4Abp4NVis5Rba846rfwYczsxoOhfvzlWGs/cVmmwQDKTQOcIn/2Jp/zMGrfGauyelGkYPHrsn+wfYIu/hdi+0qnZ+I71lPok9Ye0BRY2V8TniCqhHqX/0Z/l4ZiIgG1gMzgwCM7USB+YpBDlpWgBHOLXvx069tVnQdqzhrIc2xlXF8RcSJj9H7eX5KrjTEYHBWJMu/dXs0EDVVSNE25i76vrS18ruLjvfphgoCrUn/dWLQojz9tOFEojAi+XIGhNunVe3TQ5j6541m3aHccKiJ67++ml4s42QJxDQ6AV8mi9ViAPXJQ3YVFtbJbv9NJnNDtg4+b2O4uX5nvPRzUggiPj6AqaSB19E+VIUG9/wRmgmuI1EB2wJigqWfDhL0azElnqcKuLQyPnuaTAysRNrU0beiMtyNEqUJ3J8j0/pzrMMx/ROZeFUs+Q5tDnXiQKJaD2buYOLqJ6MSFbJyk5dQHAdD0+3/LIW8Xj51l8RT1trNCpVY9P/p0BQzZRfuLXyehGGvbXpU7HmL2X130wGxhTlkII9iY5baVWUrLUIvk8AaqZ1UQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c65898a-a1ab-437a-f7a2-08db836c3944
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:41:44.4490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKLR7RFuwdEkAnwiAcPaiLODyPC4QW6wfXYuQCJ109la81hdUOc2k1edLu/LYPpiCGxz2HirFjJxf5zKhbA89A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_03,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130058
X-Proofpoint-GUID: 35gg2-Ez6-5qE7F6wIeQ__yj3IOuLTED
X-Proofpoint-ORIG-GUID: 35gg2-Ez6-5qE7F6wIeQ__yj3IOuLTED
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 10:46:09 AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:58:00PM +0530, Chandan Babu R wrote:
>> This commit moves functionality associated with opening the target device,
>> reading metadump header information and printing information about the
>> metadump into their respective functions. There are no functional changes made
>> by this commit.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  mdrestore/xfs_mdrestore.c | 141 +++++++++++++++++++++++---------------
>>  1 file changed, 85 insertions(+), 56 deletions(-)
>> 
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index 2a9527b9..61e06598 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -6,6 +6,7 @@
>>  
>>  #include "libxfs.h"
>>  #include "xfs_metadump.h"
>> +#include <libfrog/platform.h>
>>  
>>  static struct mdrestore {
>>  	bool	show_progress;
>> @@ -40,8 +41,72 @@ print_progress(const char *fmt, ...)
>>  	mdrestore.progress_since_warning = true;
>>  }
>>  
>> +static int
>> +open_device(
>> +	char		*path,
>> +	bool		*is_file)
>> +{
>> +	struct stat	statbuf;
>> +	int		open_flags;
>> +	int		fd;
>> +
>> +	open_flags = O_RDWR;
>> +	*is_file = false;
>> +
>> +	if (stat(path, &statbuf) < 0)  {
>> +		/* ok, assume it's a file and create it */
>> +		open_flags |= O_CREAT;
>> +		*is_file = true;
>> +	} else if (S_ISREG(statbuf.st_mode))  {
>> +		open_flags |= O_TRUNC;
>> +		*is_file = true;
>> +	} else  {
>> +		/*
>> +		 * check to make sure a filesystem isn't mounted on the device
>> +		 */
>> +		if (platform_check_ismounted(path, NULL, &statbuf, 0))
>
> 	} else if (platform_check_ismounted(...)) ?
>

Ok.

>> +			fatal("a filesystem is mounted on target device \"%s\","
>> +				" cannot restore to a mounted filesystem.\n",
>> +				path);
>> +	}
>> +
>> +	fd = open(path, open_flags, 0644);
>> +	if (fd < 0)
>> +		fatal("couldn't open \"%s\"\n", path);
>> +
>> +	return fd;
>> +}
>> +
>> +static void
>> +read_header(
>> +	struct xfs_metablock	*mb,
>> +	FILE			*md_fp)
>> +{
>> +	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
>> +
>> +	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
>> +		sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
>> +		fatal("error reading from metadump file\n");
>> +}
>> +
>> +static void
>> +show_info(
>> +	struct xfs_metablock	*mb,
>> +	const char		*md_file)
>> +{
>> +	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
>> +		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>> +			md_file,
>> +			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
>> +			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
>> +			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
>> +	} else {
>> +		printf("%s: no informational flags present\n", md_file);
>> +	}
>> +}
>> +
>>  /*
>> - * perform_restore() -- do the actual work to restore the metadump
>> + * restore() -- do the actual work to restore the metadump
>>   *
>>   * @src_f: A FILE pointer to the source metadump
>>   * @dst_fd: the file descriptor for the target file
>> @@ -51,9 +116,9 @@ print_progress(const char *fmt, ...)
>>   * src_f should be positioned just past a read the previously validated metablock
>>   */
>>  static void
>> -perform_restore(
>> -	FILE			*src_f,
>> -	int			dst_fd,
>> +restore(
>> +	FILE			*md_fp,
>> +	int			ddev_fd,
>>  	int			is_target_file,
>>  	const struct xfs_metablock	*mbp)
>>  {
>> @@ -81,14 +146,15 @@ perform_restore(
>>  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
>>  	block_buffer = (char *)metablock + block_size;
>>  
>> -	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
>> +	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
>> +		md_fp) != 1)
>
> Something I forgot to comment on in previous patches: Please don't
> indent the second line of an if test at the same level as the if body.
> It's much harder for me to distinguish the two.  Compare:
>
> 	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
> 		md_fp) != 1)
> 		fatal("error reading from metadump file\n");
> vs:
>
> 	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
> 			md_fp) != 1)
> 		fatal("error reading from metadump file\n");
>
> Also, previous patches have done things like:
>
> 	if (foocondition &&
> 		barcondition &&
> 		bazcondition)
> 		dosomething();
>
> vs.
>
> 	if (foocondition &&
> 	    barcondition &&
> 	    bazcondition)
> 		dosomething();
>
> The code structure is easier to see at a glance, right?  That's why the
> xfs and kernel style guidelines ask for distinct indentation levels.
> Please go back and fix all of that in the new code you're adding.

Sorry, I will fix the indentation issues across the patchset.

-- 
chandan
