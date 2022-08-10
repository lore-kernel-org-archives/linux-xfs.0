Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50159C25B0C
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiHJDJA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiHJDIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:08:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EAD7E01B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:08:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0DrZf020613;
        Wed, 10 Aug 2022 03:08:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=OaTGRq7cvcSHDW/0UNw2bZNkmLmWzkAonXosHmHLOjU=;
 b=c/kQPibA1Kvi6MlX3IZGBo/cejLfV6FxVaaO6IiOsLZePNo2rVE0z8jo/tG2oPgJdIj3
 iF4CrQBLemSFlvBGzH41siI6w255xkD4lcCDw6ppwgMOrEP+wE9+585AWNP7WBC5oKVc
 N98ZHWYb6UQumG0Yho0IN0NbmqdboOtn2pm1K+5435T70w9AXHiv6cQLuUtN72+A/06m
 FnNzVZyTutGeKyV9hW96yhbZLvgIwLfszRHGeJDlbxeogNOolEi8CUF4tIssTxLWAC0x
 BXllTE5kc4ruczxmid3qsvm4azy45L9iErLg4k9RqdWCBekp5q38oQXWPyaUsitUSmGJ wA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq9gp37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279Nn83T024126;
        Wed, 10 Aug 2022 03:08:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfrfgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBTf5yrAi7rxXjP+TanutgGOtW8lqKwtN0YGovmEPsllii0Ri3OyfkvPvZksnoGATOxPGR8I1mca0N+Tf0TItQvrlKyxppaeBm3FOQ9VhowDcXtR9BGRCXK968tJYgRWO92CUHSSOSWAKxNX7EVtY5JnGHj6STHccMgOOQnLV6eMP/8xFmEvobX3qPoUt2Vh87Uvi9y3OHG3VkbeDPfVL3rU+fowMyOt7B5V3fa1VGKhz2s8wkR48fCJdAi8qjp21ZE5vBI+K/LOl8mQRQ5WH72VBjH1N879fXsLSuRdCyX55g5ny7g79eKgL6pyAJCpoAJI95QDKDPR5gvuU/Ae4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaTGRq7cvcSHDW/0UNw2bZNkmLmWzkAonXosHmHLOjU=;
 b=fHtz8uWFld4fHfYGm43cxYTNkUdnaJPTc9FgfOeuBGDZeXqADrxX/Tni39bqAteXbjVQDJAcwXMZ0/AUbpB7DIx1F/BtwEgMeeos6Wc75p86GiuRLnrTa7ej1q/zzqZozg6m2LnibmxRwHGoRwHyIqZnVMibpFCc21swaUJhEn8UAy/lkCBRhkNlb79MGYnNByhF5oPjbiWp8uPyWg6illMniK5xuQbQFTyT3mUWWiOMMIfU1eLMgbn6oIZkhZwj0tVSAs8XgDEQI0vQop9fFAZZy7E+8go95Svza1KTbqT/gucBX7WzyxnpFF7MxVPVZ7qSz/nApHOFPgdhAtWYww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaTGRq7cvcSHDW/0UNw2bZNkmLmWzkAonXosHmHLOjU=;
 b=tk5N4VhrFuBcGdBlrM3/Ke6Wi5iL4qVAYOYdXaZ10Lj4yHPql/crh8GaJVNzEGuf6qXOb7PjXGQ/+wyY+2Ak0FCyTjB7JK4UutOYm40Y/V0Yy92h2tAFKh/10j7ySHDlBmwZ7L/wLPrJHwZWGi8IQCuvQhzwKoQvUl3UQrGdhb0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR10MB1627.namprd10.prod.outlook.com (2603:10b6:4:4::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Wed, 10 Aug 2022 03:08:43 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:08:43 +0000
Message-ID: <d539b09c0aa838773e82dabd9cf925355e995ccb.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 10/18] xfs: Add xfs_verify_pptr
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:08:42 -0700
In-Reply-To: <YvKSVtUDDaHVX4AV@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-11-allison.henderson@oracle.com>
         <YvKSVtUDDaHVX4AV@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::39) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8fe7705-8901-449c-e484-08da7a7da1d1
X-MS-TrafficTypeDiagnostic: DM5PR10MB1627:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHu8u8FNaTHk08je451VwihoAI17rly6TuRxy+Y+p5crC83zaRV61M3vlNwoxhGGrAbti0Vr/byELy2P3rrRoTobYzy7CqnOQFwZlCsNYtoQUETecOhBD6GsNDrtW5yfK9EKzq0p86j1nDGzKbdVZoJ27ohkNYal1cIi8RC8aWjnrXbl7YJdyQXM3IseSQZjQnd6b7OG5oOtjvWU8FaYuTSVGj9tE0usnIQ0PvUIn/9in7BM+Q8/PyO60SGP9FsjTSSHbf8Ff8KOtv9tkG3t213eA1OjbkWoZTsF5jKEuew3qfa3Eu8+m1bbwBE6/dA4EWQgopPNio0ue8IBxbC8PVhdNS6f/5As6Y6OCAb2YHznfvlxZqvemu/akDhRrleiBqLsJ8mURiUQPpDE74q+AZizPIjdWH4HmYHUiO9944B1IR9ObJxwiBdigqvjeI9IpNlR5PI0OPKM6zwUx+GizQ+75555D0gxOJ0+sexQNvc4eUqWFP7YVCUCvm72BSZpQNLLNj3R938UWbrFM0S9bYf7j52c7q/6CC6samWeY7q+6/dJlNItbdLUkX1uuNHZ8CNv7BPH+GAsy7vHLpc4Ja/V36KQ/L979zIEKajSJ9ebF8fav+/mJp5VlOgk44XzZqvIRFwOnYpBj821IMMIsJP2cIx9ezSiYDHDVqeAX+cDSEX0+LYxDY0Ad7VvadsBj9aCvBOPDbIbVPOKLoLVyaH/Kbmg0T/afKB4oVsih4uNJ90Y474pJ2iAMYkqX7X+v290pr7QwVw+YNEsNmdLZvK2cgLzO2hrtWHDJusNKzM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(39860400002)(346002)(136003)(6512007)(2616005)(186003)(5660300002)(478600001)(6486002)(26005)(66556008)(52116002)(66476007)(6506007)(66946007)(86362001)(41300700001)(36756003)(2906002)(83380400001)(38100700002)(8676002)(4326008)(8936002)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N05JazZPUG5xYXJRKzkyS1dNRGlvekg2SFR5WDI4eVlDWDRTSjgwU0ZGbVZo?=
 =?utf-8?B?eTErMDc2eWI5WVllMk9NUnlsd012RjNNcFRmRWtaV0JUV0xXMUhIdHl5azI3?=
 =?utf-8?B?bk40R2RlOFo4UzZua1hqZHZxTEYrVGRwQ29sZ0JnajhYU0FqQWJqTnJtZERy?=
 =?utf-8?B?eGtXcExMay83eWJaM1h3c0c5Tm9iVDRaZFN3eGM5clFuNXhkUHFpTDh4Tk9r?=
 =?utf-8?B?OU9IS1NweVlINTdUa3NZejF0cDNuVTllejB2eVFkNzRQeEZnelBJYUNhL1M1?=
 =?utf-8?B?ZGpBOUl5dUdaancySGFBWGRaTE9HeW9OdDVsc3RHbDA5ZTM0aWtNVnZMQUFr?=
 =?utf-8?B?VGhHQlZnc0tYME9lY0FaNy8zdHl4M3dlQmkrMzc4VW45eS85eDNhUmp0L2Va?=
 =?utf-8?B?elFMRnA2OFdYcm1ta0NCNHo0SUJEQ1ZwRHFnTStNSnlqZG4zUFJyMnNSMzli?=
 =?utf-8?B?bEZOdFVOaWxrSmZ2UkhlYVBnKzlXc2N0SFpvb0s3cnByNmVBSXAwT2ozU3RS?=
 =?utf-8?B?UzFDZmZUanphUlIrZ2trRDYyWUlra2xrNi9tRndOZ1pRd01GOGV6VFYwaytq?=
 =?utf-8?B?b2xWd3lpSnYwVy9UM0U5eGFZME9TVElYaGFJQi9yeVFBaXZJMzBZWTFvRVg5?=
 =?utf-8?B?OUpxVlo3NWNFeThxOHpMT3laN29Zd05nTmxTNGZxK1o1YXpJOUl3bkU3aXF5?=
 =?utf-8?B?RU5DOUtXeUR5UVUyNzFmRytmejVKSlBnZlBQdjhuSlZBYU5Sd1hQTnZZOS93?=
 =?utf-8?B?dkorZW9BdWY0RUV0TkJxb3YvY1NsR1RoS1E0WE9aT0hjN0xIa3lTTEFwT0E3?=
 =?utf-8?B?WU1EV0hMdGN0WHUvejk1ai9peW94TysvOWF2NERZWmlNcFhEeHg2RU4xVFNh?=
 =?utf-8?B?Z3hGQ1Jmb2Y0WStWaHU3b3NjOUZjM3AyZ1FZTE9mckRzQXl2SHZaTXdEVEQ0?=
 =?utf-8?B?NG9CL2VGR0dUWUxld3Y2SmE1QS9jazdVd0RvQml5cGM2bjdDQnhJQXdNeWJm?=
 =?utf-8?B?azNoUUc0RHB0SVFTUnpsYXNVWElwTkpLSUhObHlQcisvMG9YWTBBKzdZT1Zx?=
 =?utf-8?B?NHRRQWRPYlMzeHhySVBzWVdqMDI1Skd1QUkyanBhZnl4RTdhcXFqbU9uNUsr?=
 =?utf-8?B?VnpTZ0dhMk1tR29XNDdFNVo3Vk0rRFNTWTYrMlQ4bUVyOFhjWjFMdmNBOXRa?=
 =?utf-8?B?OFU2VFgremx0b2lJK3pCQmE0a0hYbXdUVWdjSU8ybFliSVhJaWdMZFVlSjJp?=
 =?utf-8?B?TXBUUFBHVTRHMEh0ZHcvdjJ4cGZsNXkyYWpCYS9UMzQrRDBmQWZqMjMvaTNs?=
 =?utf-8?B?NGl6dWRRdjJTN0VPK0xLeW5iZUswRUhWOFUvUmFBWUd0d2tqUGx1aS9pY1Vy?=
 =?utf-8?B?NkJ1R2Nhb1dmd2Y1dmNoSk9hb3ovMU1JS1BGQ24rV01HbHlGL25aR1NOMzc0?=
 =?utf-8?B?a29CcERTb2JhaWhUMW5RcFFwVWVWQ0E2amV6dE11TmM0T3JXU0dtZk5UZ2lX?=
 =?utf-8?B?SXhSVm5MUEFhcWlVMmFYZU1qd1pxT0lZQzdJbnJqYVdTOE9DV2FWZXpUZUZW?=
 =?utf-8?B?SVZzcng2M0VzRDZSNlp4OXJ6eGZrTHovdDRjc2tDeUtTT1VZWmNqWXlwRmZo?=
 =?utf-8?B?d1RNZjQ1M1lqdGNNVVlLWFNkV3FCZ3g4NVk3TXpiTitRaUQ5SnJBeDlsUEdy?=
 =?utf-8?B?TjBMVFlnODR3ZWtHNlA0ZDNBOXd4YmZkL081TFFjRnBoMENsMHJVa2tkYXkx?=
 =?utf-8?B?TjB2cEo0bDVhamh2dzNoLzV6WjNtVmhxUk9tYnFod2I4cTA3MXQ0N2VRTUxL?=
 =?utf-8?B?d2dudjVCdmVMTjV5L09tcERmaVZHL1l1QTNNNGdydE1wa2tKTzZ4TUlvODFO?=
 =?utf-8?B?N0xlQ2ZNWjlVczYrUkMyN0ZVMXVJOStXT01TL1QrcDMvZzdLa056VFY4bWR0?=
 =?utf-8?B?WHFsOGtvejZnRFN0VkNtVitnMzNxeVBmOEZtem9QdXRJUXhJUk9UL1UvbFBK?=
 =?utf-8?B?RmlDRjVYUGwrOFRYTjA5LzZ5MmVvYWluUHlJNnBEVHVBOXhrOFhkMUFqaEox?=
 =?utf-8?B?THlZWWV3WFZGV01jeDNRdklTZXBvaXZwWEp3eXlvR2VocEhPVE5aa25ySEpL?=
 =?utf-8?B?dFB2ME8zbWJpMndTMTArTEtrMUR6dCtURkVBZzR1NE9YYW5teml3SHpyWThk?=
 =?utf-8?B?Z2c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8fe7705-8901-449c-e484-08da7a7da1d1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:08:43.1671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p64nSY/PdLsTawhOb1uF3D0KRrVnXFbyDPbCfiuv8i9aj99YLWwhEEZXW6yMauIoeArPVdzpNlyAkfTDtQVmQzSV+Cproc6qNLGhQ5uyMdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100008
X-Proofpoint-ORIG-GUID: ioqFZDAkBf_46lbqWiCdaRWmqOBIsHv4
X-Proofpoint-GUID: ioqFZDAkBf_46lbqWiCdaRWmqOBIsHv4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 09:59 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:05PM -0700, Allison Henderson wrote:
> > Attribute names of parent pointers are not strings.  So we need to
> > modify
> > attr_namecheck to verify parent pointer records when the
> > XFS_ATTR_PARENT flag is
> > set.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 43
> > +++++++++++++++++++++++++++++++++++++---
> >  fs/xfs/libxfs/xfs_attr.h |  3 ++-
> >  fs/xfs/scrub/attr.c      |  2 +-
> >  fs/xfs/xfs_attr_item.c   |  6 ++++--
> >  fs/xfs/xfs_attr_list.c   | 17 +++++++++++-----
> >  5 files changed, 59 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 8df80d91399b..2ef3262f21e8 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -1567,9 +1567,29 @@ xfs_attr_node_get(
> >  	return error;
> >  }
> >  
> > -/* Returns true if the attribute entry name is valid. */
> > -bool
> > -xfs_attr_namecheck(
> > +/*
> > + * Verify parent pointer attribute is valid.
> > + * Return true on success or false on failure
> > + */
> > +STATIC bool
> > +xfs_verify_pptr(struct xfs_mount *mp, struct xfs_parent_name_rec
> > *rec)
> > +{
> > +	xfs_ino_t p_ino = (xfs_ino_t)be64_to_cpu(rec->p_ino);
> > +	xfs_dir2_dataptr_t p_diroffset =
> > +		(xfs_dir2_dataptr_t)be32_to_cpu(rec->p_diroffset);
> 
> I guess I should complain about the indentation here...
> 
> STATIC bool
> xfs_verify_pptr(
> 	struct xfs_mount		*mp,
> 	struct xfs_parent_name_rec	*rec)
> {
> 	xfs_ino_t			p_ino;
> 	xfs_dir2_dataptr_t		p_diroffset;
> 
> 	p_ino = be64_to_cpu(rec->p_ino);
> 	p_diroffset = be32_to_cpu(rec->p_diroffset);
> 
> (You can keep the RVB tag if you clean this up for the next
> revision.)
Sure, will fix

Allison
> 
> --D
> 
> > +
> > +	if (!xfs_verify_ino(mp, p_ino))
> > +		return false;
> > +
> > +	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> > +/* Returns true if the string attribute entry name is valid. */
> > +static bool
> > +xfs_str_attr_namecheck(
> >  	const void	*name,
> >  	size_t		length)
> >  {
> > @@ -1584,6 +1604,23 @@ xfs_attr_namecheck(
> >  	return !memchr(name, 0, length);
> >  }
> >  
> > +/* Returns true if the attribute entry name is valid. */
> > +bool
> > +xfs_attr_namecheck(
> > +	struct xfs_mount	*mp,
> > +	const void		*name,
> > +	size_t			length,
> > +	int			flags)
> > +{
> > +	if (flags & XFS_ATTR_PARENT) {
> > +		if (length != sizeof(struct xfs_parent_name_rec))
> > +			return false;
> > +		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec
> > *)name);
> > +	}
> > +
> > +	return xfs_str_attr_namecheck(name, length);
> > +}
> > +
> >  int __init
> >  xfs_attr_intent_init_cache(void)
> >  {
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index 81be9b3e4004..af92cc57e7d8 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
> >  int xfs_attr_set(struct xfs_da_args *args);
> >  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
> >  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> > -bool xfs_attr_namecheck(const void *name, size_t length);
> > +bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name,
> > size_t length,
> > +			int flags);
> >  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> >  void xfs_init_attr_trans(struct xfs_da_args *args, struct
> > xfs_trans_res *tres,
> >  			 unsigned int *total);
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index b6f0c9f3f124..d3e75c077fab 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -128,7 +128,7 @@ xchk_xattr_listent(
> >  	}
> >  
> >  	/* Does this name make sense? */
> > -	if (!xfs_attr_namecheck(name, namelen)) {
> > +	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
> >  		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK,
> > args.blkno);
> >  		return;
> >  	}
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index c13d724a3e13..69856814c066 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -587,7 +587,8 @@ xfs_attri_item_recover(
> >  	 */
> >  	attrp = &attrip->attri_format;
> >  	if (!xfs_attri_validate(mp, attrp) ||
> > -	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
> > +	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
> > +				attrp->alfi_attr_filter))
> >  		return -EFSCORRUPTED;
> >  
> >  	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
> > @@ -727,7 +728,8 @@ xlog_recover_attri_commit_pass2(
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > -	if (!xfs_attr_namecheck(attr_name, attri_formatp-
> > >alfi_name_len)) {
> > +	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp-
> > >alfi_name_len,
> > +				attri_formatp->alfi_attr_filter)) {
> >  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> >  		return -EFSCORRUPTED;
> >  	}
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 99bbbe1a0e44..a51f7f13a352 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -58,9 +58,13 @@ xfs_attr_shortform_list(
> >  	struct xfs_attr_sf_sort		*sbuf, *sbp;
> >  	struct xfs_attr_shortform	*sf;
> >  	struct xfs_attr_sf_entry	*sfe;
> > +	struct xfs_mount		*mp;
> >  	int				sbsize, nsbuf, count, i;
> >  	int				error = 0;
> >  
> > +	ASSERT(context != NULL);
> > +	ASSERT(dp != NULL);
> > +	mp = dp->i_mount;
> >  	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
> >  	ASSERT(sf != NULL);
> >  	if (!sf->hdr.count)
> > @@ -82,8 +86,9 @@ xfs_attr_shortform_list(
> >  	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context-
> > >bufsize)) {
> >  		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++)
> > {
> >  			if (XFS_IS_CORRUPT(context->dp->i_mount,
> > -					   !xfs_attr_namecheck(sfe-
> > >nameval,
> > -							       sfe-
> > >namelen)))
> > +					   !xfs_attr_namecheck(mp, sfe-
> > >nameval,
> > +							       sfe-
> > >namelen,
> > +							       sfe-
> > >flags)))
> >  				return -EFSCORRUPTED;
> >  			context->put_listent(context,
> >  					     sfe->flags,
> > @@ -174,8 +179,9 @@ xfs_attr_shortform_list(
> >  			cursor->offset = 0;
> >  		}
> >  		if (XFS_IS_CORRUPT(context->dp->i_mount,
> > -				   !xfs_attr_namecheck(sbp->name,
> > -						       sbp->namelen)))
> > {
> > +				   !xfs_attr_namecheck(mp, sbp->name,
> > +						       sbp->namelen,
> > +						       sbp->flags))) {
> >  			error = -EFSCORRUPTED;
> >  			goto out;
> >  		}
> > @@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
> >  		}
> >  
> >  		if (XFS_IS_CORRUPT(context->dp->i_mount,
> > -				   !xfs_attr_namecheck(name, namelen)))
> > +				   !xfs_attr_namecheck(mp, name,
> > namelen,
> > +						       entry->flags)))
> >  			return -EFSCORRUPTED;
> >  		context->put_listent(context, entry->flags,
> >  					      name, namelen, valuelen);
> > -- 
> > 2.25.1
> > 

