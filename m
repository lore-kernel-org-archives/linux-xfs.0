Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32E9C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 08:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97887610A5
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 08:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbhHMINp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 04:13:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2352 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239698AbhHMINo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Aug 2021 04:13:44 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8BLaZ018611;
        Fri, 13 Aug 2021 08:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=wKgN6IOXZ5NB6szTksEjkaxdXWV9GcyEJtewoNX3qy0=;
 b=r898v59bkGvXq4o+TVVG1HcKvg6eaW6OJLFIOF35lWoFrhCggLyp5XY17K9M0NXIW/qt
 er8uBJMRavGKCHONRzmE+uJ+hmUQ2kOhBoyIcaCNZrWHoPKXYTKI62CMcdi9DAo4/WnM
 Fl7bMiVc8TIzasL9a08f5/RwHi/g0YsVZXqFESs8+MfeSONiOndkXK0h1UoEve3UySH/
 70cHOmVbggJjd1wKra5oZi2GAtvdh2EPOwbxyQxoP5Z/sqei3PapaxJa1hf7lRUdV2v5
 Jeqr7DV9BPnkvPS0hZZnosCVeZU8jFPfeK3SYCY7/MGzCtO9a24Skj3M6TT2X+NMH8uw ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=wKgN6IOXZ5NB6szTksEjkaxdXWV9GcyEJtewoNX3qy0=;
 b=W2ZSAYhzAlTY7fu05hl8vreDWYgY3nPb33t5KjkK61nQTI0zmyDhgXKRhAIpU/npTwDs
 11JgO0jxSjwwVH6AkOpgAT/yTj1DgUrRrpDFnZ5W+rrVDDaX+n6l/ZAnTeVNKZfke6Kl
 T6YtMMqw6RPKmMwtVaTI+27sFr9/XEtXuZbfUziMNiCdOkfujYRVnoDW0tnUhDzbPVml
 gyXxz985fNEnvIEKn2ZT795K24eSzyqzfvAbxefyIXKOqhN5fyLd6YkIW7y6Br2pgljT
 F/9p5MFVVl5PUoXreyy2bAUo8ua/4Y3pZHjJ1NivyRI/GwP0c94GA/V18PA7CgTJZJV3 uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acd64cukx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:13:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D86YGx126296;
        Fri, 13 Aug 2021 08:13:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 3accrdmf29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRP7saBXw8ShirrT2LIzk0MLRIgSI6vf1FWu6hvuWfzEK5cI5LNweMPIqVzqPCDcji5/ZHU79HTtNP8IPQIPiBCory4DvXRGLq/4P458SkupjBXi7JkOdC7jVGkm3vnvB1AAoJxSNppyQ8PyIF6+K/SuYOECcNuXfACr4mtn4iYjenIEr3WiqeSozOIP35yLvXewz2ua+02yJkqD7P1QEdKCH7DFNFMUYANSRgieIShsd4LfJ5lcHFiScOdU8IzV7jcAPMGvSK991USmjDlueWdjqer5SdFmFRqtC/erU8VxC/HIUBh4KmGZ2k2S2avnpUvmNRig6EgWB58R/v/6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKgN6IOXZ5NB6szTksEjkaxdXWV9GcyEJtewoNX3qy0=;
 b=LtF1cQma+r8Tu5ijtKFlxNA0nmRDvAwajvahQDPmZ4rD1ckX20+AD49rLMnGHflAnRuUuD8Tn85+ihvLO6U6vR4C8eukUht39In/fc1zMWl4AY/HmSTQlpUBombVuQAizFS49v90BnC1ZkeEjOH/ZySxlZhlfAfhdq9pk2LoE9r8COR+/H+k/2wdOG4gW9q6wPoJ6p8+EoiPK8N+2auzIXAODOcT8TuE5LUXtxfFs6Zet59oF7PHQ1YgUWZb/fHaxY7mubggFl52w/MWYXJlNusEpVcMMdLzii6YhdjtQEOJdPziWxfAm5pnc2EDu+HDWWxVhbf87xIDSVb5aixWeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKgN6IOXZ5NB6szTksEjkaxdXWV9GcyEJtewoNX3qy0=;
 b=gvQHAZ5CNNr5jmgvk2DmcUnkHof7zq+6YKxhPS3hrcbiz/eXUHTbFh9IamI7jxeNcYrkRgt8NgWcDKJfcyYxQ037J5dARGaMDTxDq24yoJMGnys1pYcHbZL2YpP7/9pxcZJQcBsSsUaZUz2XjmFZXgHx/SJlYAEb5tnQYXmrt10=
Authentication-Results: fromorbit.com; dkim=none (message not signed)
 header.d=none;fromorbit.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1373.namprd10.prod.outlook.com
 (2603:10b6:300:20::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Fri, 13 Aug
 2021 08:13:12 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 08:13:12 +0000
Date:   Fri, 13 Aug 2021 11:12:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
Message-ID: <20210813080715.GY22532@kadam>
References: <20210812064222.GA20009@kili>
 <20210812214048.GE3657114@dread.disaster.area>
 <20210812224133.GY3601466@magnolia>
 <20210812235714.GF3657114@dread.disaster.area>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812235714.GF3657114@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JNAP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Fri, 13 Aug 2021 08:13:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3759e084-d6d8-4474-7965-08d95e323168
X-MS-TrafficTypeDiagnostic: MWHPR10MB1373:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB13732EBEB7ADA6E9EFA811928EFA9@MWHPR10MB1373.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cE5l5007SaBitbSx5UMEzqTSpppDrkNppbbuyFvpkv5o+0wiM5jPaP7RUNnCeXXn8h3ojYfJxUGByiiNUw/D3erOA9H+59FAOO2EG0zTJhOrjwSuioyA1EGMjUFUKHjM4f5KieOsCZf5mKK5mBIoe+LHz4m+YM+xUCUMRSiyH5Pbnqdg4iJMhKo+ZymHwNfYQJaSVLapv8Ee3frPJDPqkxCzhsfWXRhsHDt5QpETF3PthMOwLxNmjKYnNMWBe3A3ITMjjwsSP2KrRXWR3hF5EbssPZf/+VkMjfMNkuLQPx8QbRyRulcqtctT43yZzaBFdbLjFhquk353gbe9v0j1CPlmM08IOPm+GZBvhGCXrY0R6b6vUbb5iZmJh4yrqCkyNFxoK4IiTxXbd5MGVwVTFGcMY8HhSMNuAz0bGvzVAlVzbIZLZjePddfts+tjopx+okqi3LEzb9w2g4navlPze+HULCF68mDP/LN0rYJphTPI61SgoK7igJjkfyZaQMEzmZMi3JLd0W9xw909zZDPsT/3fcFj/zmVgkhXDIP2wI/pqs6M2bqzICIp9BemT6RpZFycPuPda0IeI+guTdGDZtWBCvP/C1JZ8H55+Gq+LJX2e8MAe3N2XzZhP0fxDKvgjueex/WVJrt4RjeOv/+zfbJtoCI+92qAavkHaCqNl5ygB3tqrrtTkOlasGBbXfDla+3XJRXjG2bmxAt5fiX1Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(33716001)(66946007)(956004)(1076003)(66476007)(2906002)(55016002)(8676002)(86362001)(6916009)(9576002)(8936002)(66556008)(26005)(6496006)(478600001)(4326008)(44832011)(6666004)(9686003)(38100700002)(38350700002)(316002)(33656002)(5660300002)(4744005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?enR7sDz3H1qxNvMKLRR/ZgZQO7k/lmhDz8/jsE38o3v49iKkZk+lebAiQu9H?=
 =?us-ascii?Q?IGcsp61/GlgNABSMpYjdX0TIPGBTYKfYGQfVvbI/4diCh9EPElMx0utHHjfe?=
 =?us-ascii?Q?HAAX8ZRrtFcoAwiWbRsYoe6oU3R+9JB8Z+YEZ7VrkHBxRu8xCg53IXVfln/C?=
 =?us-ascii?Q?VqvdlFSxoaBoh2nF0BQp1wecJ3vY0gxiN0Rs+0WhU0bRFaQ0ryIuPJm1Fg7l?=
 =?us-ascii?Q?I+O231wGXL3afVXgLdpGPI64UH77cj8W42za73x2Fe5AJ6VPw0qyGVrZ76Ox?=
 =?us-ascii?Q?Rus1WYNjgpBqtDA3d+AQMkDvDSkj2ItYe7X9psRhdKmMeB4O/Bnfi5i++SIE?=
 =?us-ascii?Q?i+LpHeyAOuRuhZ53Ty8/3AEMAhnKtaVZXUo4fGtsaG8yuFRCBLn3nKlPCvPw?=
 =?us-ascii?Q?ayYnwAuorWlOIreSiJxt3xsfHYPbQz53z2AoUI5TQ9wEyQZo6Y/2jq6YAPUE?=
 =?us-ascii?Q?sYmWVJEaHnNpb7Mlan7BOAE5SefT5POpt1EgvLVNUVmL7UPYQaSCAmmLeLaa?=
 =?us-ascii?Q?3UNxdI4nKXDd2KzIWjApQ1vGKkh8q7w3foGW0qVeAH0VSD1gI1N8pZR1EwXJ?=
 =?us-ascii?Q?xObHyRKM6NfaShl9QWLOGqGZu9VT3Qq/nwCGJAd/CEiOMIoESdXropr12ex0?=
 =?us-ascii?Q?ljPon6Y/QhX+HkITJ3NctrpI00g47CZuLa/S60qlYTdaHlwtX5/9KiDmkeje?=
 =?us-ascii?Q?900H1hnC4iieFNxStCsvXHaDQctERBlJRCgwOI2sSW2wk6myRyceD995maSK?=
 =?us-ascii?Q?08K6tVkteinsRL7lAidWpWyJIqwtJ4rfM2w/vLcJBgBpYxiRhsJPpY3sJo+l?=
 =?us-ascii?Q?FkKBs9pugh2JKklGHlebClrf9G0+e4bwMCC8tFlXeI8ISq6BNrQJsOOrMfCk?=
 =?us-ascii?Q?MfGz0kxr8IRpmUru560CpLBGGfXzv+vrCaSUikJrXpMI/3bY12o8FMh0lF5U?=
 =?us-ascii?Q?cedGn5hhcAH70a1mTLvHAcqy+DgqpqGVURcADvXHA2vqEkSLbiGDFkkkua3K?=
 =?us-ascii?Q?Chl9zUVQ+jJRE0DT9qu6s7nrIAT8ryH/8mLOeDqMArK61SX+xAVKWbvvMLil?=
 =?us-ascii?Q?tqjy3ux7AyvQrEZIPGBpgMWjpYKyNuN+Ufk9CkvFq8z50FC+rFOtnT4NVGIh?=
 =?us-ascii?Q?phnw3K/6DE15XRepT+O3XPiD2AoIz0oyhw9/+Ew9jx0TZaB9tQdHPPyPcT56?=
 =?us-ascii?Q?OKfx8u1IofCqS/36jxgiQ8onS+QVCgwmy4VM5T+CSC5PTU3tMSjHBjYZJ3zI?=
 =?us-ascii?Q?Hl67haUcBcfZ0o9NCYEfiSueVyv3SeThHHXNZEF6thxTgEZdERad9cujyGcB?=
 =?us-ascii?Q?VjEja7qYcXJD7/x3gwwwTwKx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3759e084-d6d8-4474-7965-08d95e323168
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 08:13:12.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8QAqNC7oa729WZUGn77uAF1jVi1y11X4wrJZ2oAr/2iBiso0b/ZIku9ZmxmRQgFtsH7l8A+NKReNQ0D30gDKQ61luhAWnI7coBpr0tlLJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1373
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130048
X-Proofpoint-GUID: Y4d3O35aULSVKrehYEyM58ce_ORQnMdN
X-Proofpoint-ORIG-GUID: Y4d3O35aULSVKrehYEyM58ce_ORQnMdN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 09:57:14AM +1000, Dave Chinner wrote:
> FWIW, I just assumed it was a current TOT being checked because
> c809d7e948a1 was introduced in 5.14-rc1 and that's the commit smatch
> is, IMO, incorrectly blaming.  Commit 777eb1fa857e ("xfs: remove
> xfs_dqrele_all_inodes") which is the one in for-next that removed
> the XFS_ICWALK_DQRELE definition from the enum and so, under C90,
> gcc will turn the enum from from signed to unsigned. But we still
> build the kernel under C89, so it's not clear to me that the smatch
> assertion is correct...

No, it's still unsigned with -std=gnu89.

#include <stdio.h>

enum num { ONE, TWO };

int main(void)
{
	enum num x;

	x = -1;
	if (x < 0)
		printf("signed\n");
	else
		printf("unsigned\n");

	return 0;
}

$ gcc -std=gnu89 test.c
$ ./a.out
unsigned
$

> 
> Perhaps there might be some improvements that can be made to smatch
> to handle this better. Knowing what tree was being checked would
> also help us here.

Yep.  My bad.

regards,
dan carpenter
