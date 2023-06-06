Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00DCC77B73
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 07:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjFFHXp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 03:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjFFHXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 03:23:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2448EEC
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 00:23:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566H4uL018716;
        Tue, 6 Jun 2023 07:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=bWFX3qJC/OW59wuIecp5DRjLkHRn8X1v+MeeIlRCKkc=;
 b=p2U7K+Inipgmi2YtIfPxEq6ZLW9/zAhp+WNQbNkKB3janx5bo49q7x+vnkgewhpOYgzc
 SNIVqlPvP5KM1G0C2k/WM0z+fkJU1m/Xy8/5JfJIJ7zq8anummj58UhP90sM7W1vUn67
 eNBsYhcFY9f0Bhd8yj/KfPL+RR6HiO8bi9/NBpPnTtLJ8fseTvJiIaUk6/0Qb07j6Ixj
 Mfmq5Hwrs7BNSw2B+QlwybEXrW4MndXrrq+kvm1XfcbXsy9p1Pdz5a0pSc+TX87fycNX
 EV7LasHyv5YUWJWMIzuZVmm5UbZCrDvmGciKoC2CSPTk1aZI3qh6jad+Ahbdk10kjD1I PA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyxh9mmuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 07:23:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3565e9tO020384;
        Tue, 6 Jun 2023 07:23:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tsx8w9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 07:23:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzEBZdgbDL9m1wMe7633m1BSaxCag7RjvBOk0X/7JQ9oIPExsl9pPMamiHMAwZmQnFgIpa5hhVAgYSIjX1hoAJqVznOdcrQRMzGeBVU0e9gpRUuKT5QcYgI+nfvF5uxIuVkVXALmTAd2/RnWcSGZWwfm3z55lf+GxfUROOkRP1b+qrdU/uDbmKdXwDfNTOYuiELASxX3AggtTdGPYlmO5VEWqOnpCnr61ZfHGMuWWap2mWm1D2tIU0iK+eO7HKaJ25arCP8Gbk8zChDgOFXseWsItynwMRyslmqwSeV/4xC3NtqVthFRqWj/aMafwKqToUu4Jtgm6KiWeyeK6FMhCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWFX3qJC/OW59wuIecp5DRjLkHRn8X1v+MeeIlRCKkc=;
 b=hRJLXxA7NkdUZCxwTovGOUEfuvXGMbw/JREv4N2/jtOp779DQYnKeBWsq6B8Nce5B60idOuDi+VlLztsx6afGYzrosgSTv83tkEM9gFIDKTyvdYC6VhnWSScUtux7n1tlGUExdXCmMxam10f8+X6UunvFg2xRaiT+WgjTLCD1sPfDKlVMgmmtuSortGBWjkZDO3/PQAZIk4m8j/7zmGN3B0bCRZfcdFgwuVN3qebH55QG76xWGDb3RgvNEzorPJAu5ZIJJ5E+EXHptWjT/Nzuzyfjat5LCMMqlkKEiaWib5cotm9lRy9Q7pJtZ8vrYLOHijKR+0jePliBNokD3N+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWFX3qJC/OW59wuIecp5DRjLkHRn8X1v+MeeIlRCKkc=;
 b=rQWmT5aOhqZcG+dKLH8+7FQiQBSScwBVEqCDCwBBoe6VgxFlYHl+JxUj7QR2U7f77ilOVLLdOeCXubWEMbFXhVFHCTtWU8AVAEDcgVU0QO4h0V6ozAb6RfWUvTeRsK5PQMRyohqcaPWu5L9avLot0/ytukO6XMYYQsz9EpUJ1Fo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 07:23:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 07:23:29 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-6-chandan.babu@oracle.com>
 <20230523164807.GL11620@frogsfrogsfrogs>
 <87sfb6462k.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230605192235.GA1325469@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] set_cur: Add support to read from external log
 device
Date:   Tue, 06 Jun 2023 10:17:47 +0530
In-reply-to: <20230605192235.GA1325469@frogsfrogsfrogs>
Message-ID: <871qiphx5j.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0183.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: 3099bb2e-d27e-43f2-5fab-08db665eecc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDhvB50d8BjnT098Uz7wbwcBoGQCme06ZdlggsBbBB9UNinlceIjDpZkgq7I81dDON62ZKVHsmj0rZn8nhqKLIxWshn7FRrg3xIUDauVR7/mbWDdDfBe81yNQPdz3R7DdupygaXR4AcJ49DuqKIExRCBdZy4+Au4D2OmUgzXdnVPL6MNizChomo3CIK3QU7vL4VEGm8bkfFrxKqdRwEMea5ecUoUv4VILC3vUTnihKTs35KjuXVMJZNZqnnyIy+Uy8cn3im4vrcjpQxoprAAR/gEHYiES25UASMTbm5jByInePzM8HnKZpZ6hKQdrnOeAfpECqT1ECsO0fIcUQhA7eyt8kbXFP10DsqTl97/pcS/oxFISHF/+u8IcPVX4a1tjH6dbsN3bO30NR/8QGIIpHiiWvh3BzgRBbRbBawnmyyXXCtQU3tbvAaa6QgEHeRh5VQDJjMaBfqs993sW1IKUqDPu9CJnwzQmQRpGyizUNCNBJX2Y9T740bvWQvDyJcHcnZHv8Qs2aEjzJpcBwKmha7szh2he1VO2pa24EaSrGI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199021)(478600001)(6916009)(8676002)(8936002)(41300700001)(4326008)(66946007)(38100700002)(316002)(66476007)(66556008)(186003)(83380400001)(6486002)(966005)(6666004)(6512007)(26005)(6506007)(53546011)(9686003)(33716001)(86362001)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NEmlamFIeIq1R4CMrM1smjWEx6vX4ufzzclXj+mzwTzRppUIrN/zMnh9Emcy?=
 =?us-ascii?Q?UJwfcfGw3JXE49SOqMRINavMsUaAixf+NrqgD70sqpXSrxm013sEvYpvghtW?=
 =?us-ascii?Q?xCW85rt719zD1beW9/CkHdVt01n/Ava3z8Ybv/8VXYvCd+/ZtVyOQiMSbNlh?=
 =?us-ascii?Q?97TEdIDaetPCV6OC/HUjRrpPi4RJDEhfzZAkM3X0O9r6AQk0bjEbF+H7gyQh?=
 =?us-ascii?Q?C9dCRlTnViK77+n2OGFfbEBU4Pt/e7NqV7aYrS6W6z9cJC62LwC5Mitr6jey?=
 =?us-ascii?Q?EYM5lC0LMsxSlbhdMHBoFmkkmyCuGCpGaoXc5RDMU2yG2r8aG+U+M5af4Rzc?=
 =?us-ascii?Q?/5/41LR9UfBz+t793n3QZGgUinK+WDYoWA3ghnpN2DGa7NLB2CjXx4O3QULA?=
 =?us-ascii?Q?OvX1PTZHGjoGex85qO0tmBk9q3SQjrFoogWB1+AotyDY5ZJGPhWMYnlXOFq7?=
 =?us-ascii?Q?2BD5cEvkJVfkL5AW78cl2h/wWw/w7eLAgQr12oABFYbTxGkDd8eci+fGydUQ?=
 =?us-ascii?Q?yk2bLr+mR6UDO7wCJpOwG0fx9Ck8Shbc1/dSwwb9/mfGC4rf/vUpBoLgPkXu?=
 =?us-ascii?Q?+Q/8VPU9mqeXCI/qNEosF3TyIz4qdfng28japwLyeeNVb9QyHQcUQiFWhNQW?=
 =?us-ascii?Q?28E2Te4NCYYVIeDmwlakT9DsJTw5bp1LbUeWpjGPn7KEX+pcqXKh++Tbm+J7?=
 =?us-ascii?Q?KLCjkkVIKqOQizNOtO/WGl8eyzf/qyHQ+3QrElgsz/eynUOSVYqVmMQwC5dS?=
 =?us-ascii?Q?bYX9lqtRdBCCE0/G4aAG3HQFPXmO3ZZ2bb1yli5E4HoKeSxWSZUeKtd99yeU?=
 =?us-ascii?Q?L+sRS1WUP3gJtH6+XEMjVk2VlyC2CmvM+VAB8GbbWuPfRuR44f78lW4z9fnC?=
 =?us-ascii?Q?AryekF8qcxmTEXWf95b9aSTeHXmYQ2K5iKTYp6S4CzuoTmBjzOiTt3b90u5N?=
 =?us-ascii?Q?fcj8ira5Oavuin5BudEOGJ3+tlezy+PLdyJF1To48pR4Iqi2fziLHgt36pdm?=
 =?us-ascii?Q?ZPuOFvRu+aXDjNveDVFOMMwngwV3lkOEY5n3DoqwnbXXt961NEg5pz5o/1y8?=
 =?us-ascii?Q?UgXDBRnoY8nue5yaPEnQddpLP+l/3aSquKu4wrySSwhigGs9tttRmtuRatFE?=
 =?us-ascii?Q?K/0i+fTfr1Qya9YPLBJ/kU9hlwE77v3YVVis+pWfuCXEMncb5eJxpwWCDH/k?=
 =?us-ascii?Q?ImrYEXal4XegYJINFaOzybi7cIx3RFYFvx4sI8kL5OuMsTFgJ/WBOkFMG8eP?=
 =?us-ascii?Q?TGdSfNadh3Vj+UT7K1T40U1wkk+BItA3Hminh9hzTjRuLNss4IepzoUWCF1t?=
 =?us-ascii?Q?toMoQZsJ+XP+mxQrvI/yO356S7vKIoOGJU3hifXqIlvBb9PHQAn5z3/BsKGz?=
 =?us-ascii?Q?UpK1SOO+ckDy/No8bPpKcrcnk3nRJ4jV2fIZBWNz3cm+skjZPks3qPHlkGuX?=
 =?us-ascii?Q?nar+KqPToCP1rCLfVat5eK/3mq2ebeu0BvEq+MlS/tCwGzT+GYuVzGyjLUHw?=
 =?us-ascii?Q?5IYD1Jss3jch2SfDUXG8IyK7ZlDWGKbyIjmKytIjG1LGu3mjFtBb8GYYaqeL?=
 =?us-ascii?Q?SCXO4ZNuV0Js9msjFQCmDdU+U/xvWrgQrSASUDIf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vEiszLrLALJFMaA5oW+RQIYjqKgrSQLDn0usA9+QDYVYY8w1L/v698mnlH3vuLuwectpsLqhy2pGtLyv7QSZetABpxsJnE3etumE/S8/qptnmGBk/4T7DalC71kN9Xbi4g6afWj7BY+izXWzWE6fIidqAUl2JIQBhZiUpyglWG8EV5qxC8m0xmOXKHnbvV1JIqZginJNXby3ZapxQPuryuNluCn8pxVN0i7ICMoDYm70UyiyEW4nX1p8Bx9qqznbymKz4en6OaO4kD111jj9tULDWApXFd+RwyouVrWj+lealfotuVPjpsRW9ZtK4V8FkCTh4V1oc70hABJ4C3Gb05K8VG2qy9MV9+Ire/4sl9J1K2e7wkQXXyKOXhXiHGeqtPBzFOHThdCC0TFKQuti6DGb4e3M/8QxZ+MCXKjQgjaeDbwP9YmJ6x/p/hFidzD4NrA9eA8STr2YqSTPPGG/NlzOWUnXcn73swg97bZEQ5p4GfCuucec8WIs89c20JV5ShPlCqOtVegAqIau1DaqQBQZVtj9c3yAFQX0KMw/bUfB+lcI/nC6++azkokr3eV8PIv3GojMFvSszpPNcfQr6V+tNpdpz1bmSuLeQChAiDiF2QSwwINpBA2nl3y3YkQM0Ml94/Vck5GQdSDBcUQIZVhevo6NPyUmnS0DeXs1qLtl+F9iCitIW9V3NNWQeSZLTStdI9venAd4nVZh8G9KHf2G966cgAr1ZN1dQNHs6h0hMtbunB3Xivyejp1bSpJQ9dKbdhwaK8Ct71QJmVQ0BwFwo7qCnMUfwZTJTh14S2s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3099bb2e-d27e-43f2-5fab-08db665eecc8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 07:23:29.1930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hm4ZAjnotAIiHYfgvwfZKye2iTpshkMl2Es4SuPgmBnRWw08XlDb4vuzTd8yNMq/pSdxzGHAGqsjhu+G5r5pwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_04,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060063
X-Proofpoint-ORIG-GUID: _7CyMlFz2qMqjmtPdAEWIW83s4oWdzyT
X-Proofpoint-GUID: _7CyMlFz2qMqjmtPdAEWIW83s4oWdzyT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 12:22:35 PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 05, 2023 at 02:49:49PM +0530, Chandan Babu R wrote:
>> On Tue, May 23, 2023 at 09:48:07 AM -0700, Darrick J. Wong wrote:
>> > On Tue, May 23, 2023 at 02:30:31PM +0530, Chandan Babu R wrote:
>> >> This commit changes set_cur() to be able to read from external log
>> >> devices. This is required by a future commit which will add the ability to
>> >> dump metadata from external log devices.
>> >> 
>> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> ---
>> >>  db/io.c   | 22 +++++++++++++++-------
>> >>  db/type.c |  2 ++
>> >>  db/type.h |  2 +-
>> >>  3 files changed, 18 insertions(+), 8 deletions(-)
>> >> 
>> >> diff --git a/db/io.c b/db/io.c
>> >> index 3d2572364..e8c8f57e2 100644
>> >> --- a/db/io.c
>> >> +++ b/db/io.c
>> >> @@ -516,12 +516,13 @@ set_cur(
>> >>  	int		ring_flag,
>> >>  	bbmap_t		*bbmap)
>> >>  {
>> >> -	struct xfs_buf	*bp;
>> >> -	xfs_ino_t	dirino;
>> >> -	xfs_ino_t	ino;
>> >> -	uint16_t	mode;
>> >> +	struct xfs_buftarg	*btargp;
>> >> +	struct xfs_buf		*bp;
>> >> +	xfs_ino_t		dirino;
>> >> +	xfs_ino_t		ino;
>> >> +	uint16_t		mode;
>> >>  	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
>> >> -	int		error;
>> >> +	int			error;
>> >>  
>> >>  	if (iocur_sp < 0) {
>> >>  		dbprintf(_("set_cur no stack element to set\n"));
>> >> @@ -534,7 +535,14 @@ set_cur(
>> >>  	pop_cur();
>> >>  	push_cur();
>> >>  
>> >> +	btargp = mp->m_ddev_targp;
>> >> +	if (type->typnm == TYP_ELOG) {
>> >
>> > This feels like a layering violation, see below...
>> >
>> >> +		ASSERT(mp->m_ddev_targp != mp->m_logdev_targp);
>> >> +		btargp = mp->m_logdev_targp;
>> >> +	}
>> >> +
>> >>  	if (bbmap) {
>> >> +		ASSERT(btargp == mp->m_ddev_targp);
>> >>  #ifdef DEBUG_BBMAP
>> >>  		int i;
>> >>  		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
>> >> @@ -548,11 +556,11 @@ set_cur(
>> >>  		if (!iocur_top->bbmap)
>> >>  			return;
>> >>  		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
>> >> -		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
>> >> +		error = -libxfs_buf_read_map(btargp, bbmap->b,
>> >>  				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
>> >>  				ops);
>> >>  	} else {
>> >> -		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
>> >> +		error = -libxfs_buf_read(btargp, blknum, len,
>> >>  				LIBXFS_READBUF_SALVAGE, &bp, ops);
>> >>  		iocur_top->bbmap = NULL;
>> >>  	}
>> >> diff --git a/db/type.c b/db/type.c
>> >> index efe704456..cc406ae4c 100644
>> >> --- a/db/type.c
>> >> +++ b/db/type.c
>> >> @@ -100,6 +100,7 @@ static const typ_t	__typtab_crc[] = {
>> >>  	{ TYP_INODE, "inode", handle_struct, inode_crc_hfld,
>> >>  		&xfs_inode_buf_ops, TYP_F_CRC_FUNC, xfs_inode_set_crc },
>> >>  	{ TYP_LOG, "log", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>> >> +	{ TYP_ELOG, "elog", NULL, NULL, NULL, TYP_F_NO_CRC_OFF },
>> >
>> > It strikes me as a little odd to create a new /metadata type/ to
>> > reference the external log.  If we someday want to add a bunch of new
>> > types to xfs_db to allow us to decode/fuzz the log contents, wouldn't we
>> > have to add them twice -- once for decoding an internal log, and again
>> > to decode the external log?  And the only difference between the two
>> > would be the buftarg, right?  The set_cur caller needs to know the
>> > daddr already, so I don't think it's unreasonable for the caller to have
>> > to know which buftarg too.
>> >
>> > IOWs, I think set_cur ought to take the buftarg, the typ_t, and a daddr
>> > as explicit arguments.  But maybe others have opinions?
>> >
>> > e.g. rename set_cur to __set_cur and make it take a buftarg, and then:
>> >
>> > int
>> > set_log_cur(
>> > 	const typ_t	*type,
>> > 	xfs_daddr_t	blknum,
>> > 	int		len,
>> > 	int		ring_flag,
>> > 	bbmap_t		*bbmap)
>> > {
>> > 	if (!mp->m_logdev_targp->bt_bdev ||
>> > 	    mp->m_logdev_targp->bt_bdev == mp->m_ddev_targp->bt_bdev) {
>> > 		printf(_("external log device not loaded, use -l.\n"));
>> > 		return ENODEV;
>> > 	}
>> >
>> > 	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
>> > 	return 0;
>> > }
>> >
>> > and then metadump can do something like ....
>> >
>> > 	error = set_log_cur(&typtab[TYP_LOG], 0,
>> > 			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
>> >
>> 
>> Darrick, How about implementing the following instead,
>> 
>> static void
>> __set_cur(
>> 	struct xfs_buftarg	*btargp,
>> 	const typ_t		*type,
>> 	xfs_daddr_t		 blknum,
>> 	int			 len,
>> 	int			 ring_flag,
>> 	bbmap_t			*bbmap)
>> {
>> 	struct xfs_buf		*bp;
>> 	xfs_ino_t		dirino;
>> 	xfs_ino_t		ino;
>> 	uint16_t		mode;
>> 	const struct xfs_buf_ops *ops = type ? type->bops : NULL;
>> 	int		error;
>> 
>> 	if (iocur_sp < 0) {
>> 		dbprintf(_("set_cur no stack element to set\n"));
>> 		return;
>> 	}
>> 
>> 	ino = iocur_top->ino;
>> 	dirino = iocur_top->dirino;
>> 	mode = iocur_top->mode;
>> 	pop_cur();
>> 	push_cur();
>> 
>> 	if (bbmap) {
>> #ifdef DEBUG_BBMAP
>> 		int i;
>> 		printf(_("xfs_db got a bbmap for %lld\n"), (long long)blknum);
>> 		printf(_("\tblock map"));
>> 		for (i = 0; i < bbmap->nmaps; i++)
>> 			printf(" %lld:%d", (long long)bbmap->b[i].bm_bn,
>> 					   bbmap->b[i].bm_len);
>> 		printf("\n");
>> #endif
>> 		iocur_top->bbmap = malloc(sizeof(struct bbmap));
>> 		if (!iocur_top->bbmap)
>> 			return;
>> 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
>> 		error = -libxfs_buf_read_map(btargp, bbmap->b,
>> 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
>> 				ops);
>> 	} else {
>> 		error = -libxfs_buf_read(btargp, blknum, len,
>> 				LIBXFS_READBUF_SALVAGE, &bp, ops);
>> 		iocur_top->bbmap = NULL;
>> 	}
>> 
>> 	/*
>> 	 * Salvage mode means that we still get a buffer even if the verifier
>> 	 * says the metadata is corrupt.  Therefore, the only errors we should
>> 	 * get are for IO errors or runtime errors.
>> 	 */
>> 	if (error)
>> 		return;
>> 	iocur_top->buf = bp->b_addr;
>> 	iocur_top->bp = bp;
>> 	if (!ops) {
>> 		bp->b_ops = NULL;
>> 		bp->b_flags |= LIBXFS_B_UNCHECKED;
>> 	}
>> 
>> 	iocur_top->bb = blknum;
>> 	iocur_top->blen = len;
>> 	iocur_top->boff = 0;
>> 	iocur_top->data = iocur_top->buf;
>> 	iocur_top->len = BBTOB(len);
>> 	iocur_top->off = blknum << BBSHIFT;
>> 	iocur_top->typ = cur_typ = type;
>> 	iocur_top->ino = ino;
>> 	iocur_top->dirino = dirino;
>> 	iocur_top->mode = mode;
>> 	iocur_top->ino_buf = 0;
>> 	iocur_top->dquot_buf = 0;
>> 
>> 	/* store location in ring */
>> 	if (ring_flag)
>> 		ring_add();
>> }
>> 
>> void
>> set_cur(
>> 	const typ_t	*type,
>> 	xfs_daddr_t	blknum,
>> 	int		len,
>> 	int		ring_flag,
>> 	bbmap_t		*bbmap)
>> {
>> 	struct xfs_buftarg	*btargp = mp->m_ddev_targp;
>> 
>> 	if (type->typnm == TYP_LOG &&
>> 		mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev) {
>> 		ASSERT(mp->m_sb.sb_logstart == 0);
>> 		btargp = mp->m_logdev_targp;
>> 	}
>> 
>> 	__set_cur(btargp, type, blknum, len, ring_flag, bbmap);
>> }
>> 
>> i.e. We continue to have just one type for the log and set_cur() will
>> internally decide which buftarg to pass to __set_cur(). Please let me know
>> your opinion on this approach.
>
> If I'm understanding this correctly, you're proposing to push the
> buftarg decision down into set_cur instead of encoding it in the typ_t
> information?
>
> I still don't like this, because that decision should be made by the
> callers of set_*cur, not down in the io cursor handling code.
>
> Take a look at the users of set_log_cur and set_rt_cur in the 'dblock'
> command as of djwong-wtf:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/tree/db/block.c?h=djwong-wtf_2023-06-05#n217
>
> Notice this bit here:
>
> static inline bool
> is_rtfile(
> 	struct xfs_dinode	*dip)
> {
> 	return dip->di_flags & cpu_to_be16(XFS_DIFLAG_REALTIME);
> }
>
> static int
> dblock_f(...)
> {
> 	...
>
> 	if (is_rtfile(iocur_top->data))
> 		set_rt_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
> 				nb * blkbb, DB_RING_ADD,
> 				nex > 1 ? &bbmap : NULL);
> 	else
> 		set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
> 				nb * blkbb, DB_RING_ADD,
> 				nex > 1 ? &bbmap : NULL);
>
> xfs_db can now access the data blocks of realtime files, because we have
> the high level logic to decide which buftarg based on the di_flags set
> in the inode core.  TYP_DATA doesn't know anything at all about inodes
> or data blocks or whatever -- down at the level of "data block" we don't
> actually have the context we need to select a device.
>

Ok. Now I understand. Thanks for the explaination.

-- 
chandan
