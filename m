Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A809C001B3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 12:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjF2M1G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjF2M0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 08:26:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9585D3596
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 05:24:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35TAoQeV003653;
        Thu, 29 Jun 2023 12:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Le54rLeKbusUtldv8bCqC2zCV56RRhhjtCSjavyuLgs=;
 b=TFCeUYVfJeXXrnbnBqAv5ymkPGOGrB29r9RxN6BlsNfu3HcizrRgcThr4bf9JoCyknYA
 tQ5mnvw1BFoSxw8T8oKJa0OEoWNlN4ET9IVHuap1TMXuN/aAIr7SIZbcsr+PjhM0Vixn
 FePGae5mFFFpu+gGhvRZaK4Y4qU6D0PFHVQHqDjXcQ/dnLt6gwexMERiTl+vu8LvNgHY
 vq+04sIUoiFqGSxycXePxY9ql0Exa0A5ig5UxIEa01InGhJfra+M3bUp2WjBiNAXNA2P
 L5CnRXJoz5d3BVt3HuTDgQAKf6kUxk8jUelOa6fUIrVkXgyP9goRhOrp69i7FAPL+QG3 Yg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rf40ea7xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:24:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35TBoBuw029638;
        Thu, 29 Jun 2023 12:24:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpx7akag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:24:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTZ3rN2wKGRFP4aDBeYwcLesYmuscS6UcJOxO7vE0UVSof/4R4c+S2sR3kOKPj+1f55JEBZWPhwlmgdtwWI/qwR+3eQVwKoZT1038zZQYypmJo2JQIJrYdPL/CDL9oQVpRK7hcM92fMJHvpkKd2k8HwXU1JucPvg5vvIciNzlaYKPqkMQ8sJnhqDHIJw6gmltb0VMazVfLBahQZ2gKnTTJcHBgK47KKFtE9idKqDJQI0qJO9zKbkZZ0fdtd0/vSbWLOCGuBiTCxCBQXulkGfYQNb1LTTRMmE1If2vs5grAMWg45/upwdk2WoXn7YNoy1OHPEAluUvjv81zp/rbl5DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Le54rLeKbusUtldv8bCqC2zCV56RRhhjtCSjavyuLgs=;
 b=nEqnSRnDFVKqauOms2gJj+65nAIsQ5p62I60mLwyGqJ11sP4KrFYc1JmVhjF1RnzPLzPurBNmD/jbnpEp9svVlB6g4/Pi2mjLn46eon4EcC1Jv91aRpDsJRtRsoNNExepVhPRznfs+gbSb3tIv20O+HaKuMKBnp7A7AwgcYT5MIluSeaAsJR8XKs+/P2vJWvTSwGYgnEKQ9nCvtSYy/zMEoRTFJjduYQEnjut1DTJW/D8CTnJD7i+R8Sz33QBOlajuvS+Eh6UPALETaeGyc6R5IVJ9Eyr9S0AN/4vJDb6apklqys4C13DZ/kcy2/fUxBJlsYlYAzwZ23Xu5SP8Vovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Le54rLeKbusUtldv8bCqC2zCV56RRhhjtCSjavyuLgs=;
 b=zAS8l0q6YOrQy0IdQlawHDWlpZfj3BSLKfYzR7tcs44frumB+dVj17Qa4NJUyZFDue+15R25N1dU0LGMtfI5+6hLK8/hkzZMAAikdHYOq6CkJ/l97t55FQCuuph1N8epU4m+4gwPcCjcVimISHsuGTQKQuPvnEvv9wjTVrngA0I=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB7717.namprd10.prod.outlook.com (2603:10b6:510:308::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 12:24:46 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 12:24:46 +0000
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-3-david@fromorbit.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: use deferred frees for btree block freeing
Date:   Thu, 29 Jun 2023 13:22:22 +0530
In-reply-to: <20230627224412.2242198-3-david@fromorbit.com>
Message-ID: <87a5wi1mnz.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::35)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c9985b-bfa8-48cc-7aa4-08db789bd33b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SnytMoA1BT5m2c5f3GipChJhTmD21sB2irMHp2AxH45462zz69fvF37HCwvF8iY3I6QQ8EDQX9tOlv+74O8CAXiq2DLy4/JTifUp7Z0txF4yIoj44D418cM42sSeZI/nmzjNKW8oiBw7+JUJ/f5tNjQbGi2NNN5e00S2laDq2Q0CaRndIptsv7LTWpxCE9T32cP5Yr677U4mriGF8kuO8u9THNXmel1U9Ruq5TzQ56XxvFLs2R5OJah81TwEXe0XWtGQVIv5IQ4EdTp8fg53p7o1gCnEyFrakNOsCBe9ybI+CraU2NmN/RRrLsk7qkfHA8Vrlpl+RaaN/4OsDlLjVo24Yrunm+JoktN6OCKl790b6Txm6hD4MhzARtUo1g2hb2aK6SeU/SIIIJt2Doij6F8JxNMrWg+QXJ4kLveGBRzkepEwgPYWpdf3ZXJS25B26iueariTIMxtJI6USdY+R9V3Mk2GTJ/jwSq9dK/Gsr+h+dK0eGC2PbxQ6Ndae/5ZVJkDABa6IcD6WWftnDCDk/vucfAcq93zDCAWm44IqfbKjaRPZnidYIAB3JPwfDXS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(9686003)(26005)(186003)(6512007)(53546011)(6506007)(83380400001)(6486002)(33716001)(5660300002)(8676002)(6666004)(38100700002)(8936002)(86362001)(478600001)(2906002)(316002)(41300700001)(66946007)(4326008)(6916009)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7b7Xs0BC4Ove3gsRdS86AZJbcmL1AUC/OPTl83jxnfw7dg4XRVixNlEA8uLS?=
 =?us-ascii?Q?jPouXEBGjD8Hc1LXOjuVB7mnDOAKT+T2v/8YpS7/q88q/1ifuuf64/btQtfd?=
 =?us-ascii?Q?wQwsVHDlTVhuDGAJ8PZkda0u2ZDX3vP+yJG5F8JLrW6pM3KPa3mcxeFYmcnV?=
 =?us-ascii?Q?ELkW8iqglQrBfD+WKrDFWWFFF/gzD+wD4Mv8S0F4nQmdbB4ApHh59Lxjb9i5?=
 =?us-ascii?Q?PZLUaPQO92mKHETuQ9bZ4JBEupyX2j6ZbBbMamJNhN7VwmkDfiKeOt2TiLGS?=
 =?us-ascii?Q?295BfayekJnld9CBm6DitbiWh7ZG54SyKVPahqILqVWm2dJWq7W0t2xm2TNo?=
 =?us-ascii?Q?nq7Qbb7WbqhrXCPyUmfmGaNL3Tje5pa/kpqnEbRELPT628d5DCEhLWktrmmb?=
 =?us-ascii?Q?nXJrD3SfkL26+P0ctVx5yNMTmLqe31mDwD8cO48WJleYi759QOGOB4YR1Bov?=
 =?us-ascii?Q?ES5zLod8V+oNGwTrm3aRUvQNiwr9bW1i7trmrRK1bqjkxYLNjQ0flNAR4aHS?=
 =?us-ascii?Q?1pudfABhXEL9GUXRClJ0byTBRDfqaTf87T+Dj1wq67jm0LXB86cfrTFHHQ1C?=
 =?us-ascii?Q?XLoACdCyvo9+YVtzF4sLvZXgp43m5ufpLOczl+WsHqxN1lA6SbXraQ6ISrar?=
 =?us-ascii?Q?GpyrLwJFEisVX+sIWDhsXFHSLAQMqFqefE7dzaATmYg7TsughnqwL+VWGWRI?=
 =?us-ascii?Q?E6fNr8VLE/JLdQYB9bd3hhxMNIIOt8gHTHh9NjWMnBVQBatxlygENNqCE/zR?=
 =?us-ascii?Q?Q9n7/6c5HvbZl4sN3kVim7nXu/4ExY1nhiF8i5JH0tLufpXq8FMXMxd87gH1?=
 =?us-ascii?Q?gWJXNWyqG+TR57ucF5b5o2GZpqPzU7f/fIHkZ9DBaE/pl70m39KsL9qCy3MX?=
 =?us-ascii?Q?Km9yCkKyZLSg/IjUhutjcyCghuqKF5lf1P8B+/U9Z6mg1DaXCwwBGcZq39wl?=
 =?us-ascii?Q?z1+T3MhIuEIHrk3XY6BlDsiO9PtGxvJv2/bwvTMgRb3Ys8Y4rrXA+BIcZveZ?=
 =?us-ascii?Q?b+wg/Cb9tgyLrfTAkhdNE3DZvy8cC7bU5OzqxqVBeV4pu/JLNrzk8OAdsnWx?=
 =?us-ascii?Q?L0aCeaBnPBC0AYQUgLMMne2UjpeaU/lmdDu2zOEGKVUY+05oItI+jibFSTNl?=
 =?us-ascii?Q?YrNUDqTDH/pdug81RmiOq7Zcyldhs1jZmV0slMnabQ3DlbzKrDm2uj9BhfrZ?=
 =?us-ascii?Q?1vHh40QZd1WIjCBzYHUP3S02CGgG+K65o5yy1jr/lBSo4VXWLlVar5n1teur?=
 =?us-ascii?Q?dayqe0optXQsLEv8T1dlwoQSQaZ/ClfUlSBvRT3o0aYtcFNqczr8ZrWR8GYf?=
 =?us-ascii?Q?rNwWEst6wpbMO9K9GNs/kMfGmrMv7NAhyDdvhf2sSHD6mfYERh+DvkcFeA2S?=
 =?us-ascii?Q?cEoRqAyt2QdoS3DydG3CgHeiR81tAvBLWPysfv0kyG1zCdu80MnmW91tynLK?=
 =?us-ascii?Q?AlTv+5Obn1Y9eZuv66AtzwjvHwZ/mg+OZ8bJLsJcpeOuINAmFBAStN23cEOe?=
 =?us-ascii?Q?v89ccXtja1TkjSvWwD14EDqLWWeY21HjiwZEW+OEz9VnsqVSfpht22XggkMC?=
 =?us-ascii?Q?BauFiRe3YagWUBjA1kHO521E3mHdV6zhFqqWP5/Z/CaOibG7p6ePtw0d4O5X?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AX3zLNgncFpucWObOXmHS4aoxrj0BY8vLX0jAu4w1U0exrMPTMGhtgjLACcMw+hQG+qnfDDbo+N3wD302tyZe+93Ho+WtQCaf3dDlEog91vUemKIiPZ12W8WF8YPJjyiJ833SKxBicYIn2xQj3AvJbyVD2pnIm7UUFw7xlTThNqLGIBDKhyZ8eXr/JW1DEt0McOqTj1mhOg/r+U5cyZXBL44Ddv+tLj/uNSaBK/uVOILyoV5RYBeNtbm9WBu+zhxIvl8Iv+y1Ozx50oZBZ1jUglly+jTh8Aq0G9Xg9VeI22+lugDCaZdj93XfC8cgMbZHSYyYmNzf9Mu9zl2qPfVEc4C4AN4zsK86UNbGijnaSS3fjwZxVM5DwRZR4pfB7LFZ0lWry2s9+lx1w1mrgS9eM3+imed+4ZKYnhYbCzwolk4zodQwMaDHO/A92lFe2oF6AjduLcBSLs4MIoVo31OeTEB4yTP8SwzCFtMeAc4bYpuURM/L/X0joUqodBdsPn0hLawNYhuVyuGAFDqWygswm/cLmGDoq0QU3iKav/Zac30Qpv1P1aYoLyfmqegH4kgMcRZdk7SfvZQS1DoUs9cfMDIqPyZf/lnBHaZ5G7rcKOdXMEpRCpPzn3wWUatx60G7E/1M36VbSkwBUyDDYQ0NU8zAf60+esG1A9sqCZT95O2Wo/fZAe1pjlIPeRbSLOf11onV2syYigBhkJovsZoZvimkluagUk5sV05SDh4CYcwINcR19sXaX91+AhpoGJOcvJA1nfgS1psP4C/mTehOr22PV+9TNuS4TyI+YlThas=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c9985b-bfa8-48cc-7aa4-08db789bd33b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 12:24:46.4918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdBnshiuo16h9FL6RVEScjH+UYK8LlhyXALhelJ+kzM2tRWqSDUG/K4I5wTD/J29UbTIHeOXuA16id1Sp9T2zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-29_03,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290111
X-Proofpoint-GUID: Q_FWPiG34x1vTHVVJGb4cQHCxtLR8V_3
X-Proofpoint-ORIG-GUID: Q_FWPiG34x1vTHVVJGb4cQHCxtLR8V_3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:06 AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Btrees that aren't freespace management trees use the normal extent
> allocation and freeing routines for their blocks. Hence when a btree
> block is freed, a direct call to xfs_free_extent() is made and the
> extent is immediately freed. This puts the entire free space
> management btrees under this path, so we are stacking btrees on
> btrees in the call stack. The inobt, finobt and refcount btrees
> all do this.
>
> However, the bmap btree does not do this - it calls
> xfs_free_extent_later() to defer the extent free operation via an
> XEFI and hence it gets processed in deferred operation processing
> during the commit of the primary transaction (i.e. via intent
> chaining).
>
> We need to change xfs_free_extent() to behave in a non-blocking
> manner so that we can avoid deadlocks with busy extents near ENOSPC
> in transactions that free multiple extents. Inserting or removing a
> record from a btree can cause a multi-level tree merge operation and
> that will free multiple blocks from the btree in a single
> transaction. i.e. we can call xfs_free_extent() multiple times, and
> hence the btree manipulation transaction is vulnerable to this busy
> extent deadlock vector.
>
> To fix this, convert all the remaining callers of xfs_free_extent()
> to use xfs_free_extent_later() to queue XEFIs and hence defer
> processing of the extent frees to a context that can be safely
> restarted if a deadlock condition is detected.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

-- 
chandan
