Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57330C25B0C
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiHJDI1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiHJDIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:08:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD507E01B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:08:23 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0Ds0s026739;
        Wed, 10 Aug 2022 03:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3k36NiQcFL3yN8RKQ9Mxlw/JA91OU6MUnPoQecqgm1Q=;
 b=pUYTvie7KZxg9Hvo35om1rGNO3OTXY2rkGQlbLniF4VW4U9XecD+3YCA0nqe9AYnRrag
 ecUlDveEVucPAQKAxJO0nnsBOtyulqVH23lnOHMyzwYl/gWL0dPXaACOUAoqpzn29vWB
 O2nn3QPIe0oxoZhCxO+8b8c/R5O7mbyVve3I4Zl4CT+SxuZL9iAPs5kSvRARqa6CjJ9Z
 w8Tbztq/TGQD0g/ZH+VKXQO3rUNakbzlcAPd1VFkPBZEAdj6eD/CNN3TuMrZi0P/SlDh
 IVF4DFjxzbePGt0d2eWNYtaMCmfCH2puNN238ZgA0q9h5MnxIcaHEKtN5CO4pyoYGpp8 cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq90pwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279NoP6x036614;
        Wed, 10 Aug 2022 03:08:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfgg4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vjk9frKlvZjLBLMUQiYbLbhzz0cdTiap4DqrYirqqvtggtQ20zGISfmRHPh/JIS1tXz6geWWWtvd+EK9c38LqApm1rEXV3XcdazRWUD7GvsZb4H+b94rFlkURYWdRBDinvQxMGlquxvvdBD4dtU1xd8GTZ/iYqdf7VuG+D1hTXuyo6gRTxWt8PwRDTy3bWhC3unlchREj2B4YvROdYUACDvye+sgumQEJboLBXJLGq4OJfpIUyB/dtJ+NuXA79Emh/zuVMzY5BNnvyqBehrChDiuPrPZxikd6JVd6pkm4oe1rw6ErzqG/zPRdnXy5TH9XgjKVvX4T7pqbwhtkzsJ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3k36NiQcFL3yN8RKQ9Mxlw/JA91OU6MUnPoQecqgm1Q=;
 b=CQu3FlorRRJJIzoGtf5ICuwV+6UzjmxjFKoiBFJcyCq5CYxHK0wtXYtD5yeFoySsHMoOAQTmdm2ztmcCSU7Gd/2pGCrqKanmOJl51ON6HtrmwEcswXAkpOZWN8bkhVmbn6ZbPvsBp/JiZ7rNi9PlmAyyjW2eGZ6CVUWo6z39f7Mv7vAYxHLjoV377bT8NLQQlphyBx483gv8MMmTPz9AWSaEWuVW/h7WEVuGjVE4UvTdr/lul3ygAacpajT5apiWNxmqhCmF5TyIDUs8RZYRnbXAFd8V/sTZrQAtlprqY3drNF+cCe42lO4K/bo0cUldHwkElYchqS8hZduGEhctdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3k36NiQcFL3yN8RKQ9Mxlw/JA91OU6MUnPoQecqgm1Q=;
 b=VM2b+fP5X+xPdmkDxRNMCN4yj/4xpoYVeqcATg27fe2fG0muHJIISCpWvDLf+VwZFSipfOLox49DBu/wAPvKlIw8Hkb5R9+D5ywSvkHYUQ8CWuwNl8wMCAa342y0CQu699irfTtAhRbJmhIz7RIgLHq8X9azAvIG6BO9xywhIZE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR10MB1627.namprd10.prod.outlook.com (2603:10b6:4:4::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Wed, 10 Aug 2022 03:08:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:08:16 +0000
Message-ID: <98f5bcf445e1659aa26e6809ce7b3ca660e99502.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 08/18] xfs: add parent pointer support to
 attribute code
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:08:15 -0700
In-Reply-To: <YvKRU6kZxHK5XxOQ@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-9-allison.henderson@oracle.com>
         <YvKRU6kZxHK5XxOQ@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::15) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24c6fd85-2ad7-4895-36ca-08da7a7d91c7
X-MS-TrafficTypeDiagnostic: DM5PR10MB1627:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5SK3LrMjsI8wugphfidyg1uSz6ylTjq+XswZ4GsEKVqdepY61LeIA+5LUTG/UxJx4dj4eX6AnayxzMwEKaeEmkg6Sl67eycVX/am7K9TbXtBeSOwpcUVyQbUHszZ76FJMEsdAPFhHD2vc3ewv3D3C/VoFEzohv8GIQfiLSRdGpotRWw0WpBkiwr31p4WKDYIm4IGSBsHmynMHH3VM4hIoNvTJOtdGWTPd2DC38yjoLpcr56F2BiGKgqa0PzcyBjStyZWa9hyqlA2PjQHYZQ32RD5w8VBO4962KlGSf0TDRseuEHg8g4PCDJY4lmwuN+V50wSao907dgkPav4t//60M5ikZnifeYrcemy5Ai2WGpSHjkxdd/swOKISRSlmK1GDpK6bB8dmST5MitDK1J4F/fz6uNpcAJO3o4JrVf83HAC/ogLd4sEacwQgBvn73izQT3M3znlcBzlBUyWBGoM9mtp1WWJa0DIAXxVNs4O6+nvO9EhZ5Hz2AUyPzN5UcE3d3L1X4kkMHvfaCfGk1AB1/Ggwro21Mlw5vhqAgWH6Iby01OXN7iFtzvAAlTjXekfq1AcYhMR5kJSlaGMBoOm8/RHASI8viUNbfbdQYxLWHynuy3R1uwRO4Lkc4pKlpIMSEh4rDivKPgscw83whCNhSQ5FODcvLtZFH7xESBZPObJrRMynPae1uR7eNmesl7DZzxh4zeaqAJaY/c9wLp7SMdhlDeiGwRGx7BE+NRg5tayBndY+12W5I6M+7fehUpjAMK2C3R9YQkxBVf3jeMro4ipshKkBxRviFaJJzsySE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(39860400002)(346002)(136003)(6512007)(2616005)(186003)(5660300002)(478600001)(6486002)(26005)(66556008)(52116002)(66476007)(6506007)(66946007)(86362001)(41300700001)(36756003)(2906002)(83380400001)(38100700002)(8676002)(4326008)(8936002)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0tPaWx1U0t0ZUFKb1p3SHo3ZllieFVadm55ejgzK2RnREd2TTFIbE52L1Z0?=
 =?utf-8?B?a2ZnUktLY0FjNldFa2Zkdk45ZDUzL1k2R0RROUdrQTFyQkVhL3RKSDVjb1dR?=
 =?utf-8?B?dEF1Y0hJamhBeG9jZjVWa1FSNWFrZG44S3BydlBYeFV1a0xWZTN1MjBvTzJN?=
 =?utf-8?B?N3JrNlQ4YVQxY2FjMTdvOCtTSGZpWk9lOG1EVEFNVnV1RU4vVjRkeVptMjBQ?=
 =?utf-8?B?dkFmN0xpK1oxaE11TGFMWVZ2OE1rTHZpYVU3S21GS1Zic2Q3VHM2dkljRHpK?=
 =?utf-8?B?dGJBWTNhejB6c2lIWm8vdzdCUHpORWxvdkZvSllFRjZNTXlNRG5qelhkemdu?=
 =?utf-8?B?aXZtejRCaDVrNldZMldrWkx0SUxEWk91L1RoZ2t6M1lqK3J6bUtXckl6UCsr?=
 =?utf-8?B?TzViWVFraGpVSFRSRmUwSkk1UFJLVFk1a1ZVeFVMaXZEMXFpeVl1eGJsVitz?=
 =?utf-8?B?N08xVEpGaDhlOG9lM2hSOHEzdUdMZ2RGb3g5cGVOZjRyTXJkYnluOTUxQ0hX?=
 =?utf-8?B?ZmY1aXQ1MTk2SzJBNEJyVFpzL09PdTJBU3V2K3lteXdZR0s5bzd0dnpxd0pH?=
 =?utf-8?B?VkRmYUNraUxPUlFudGd5UFd5YlRLUTFLZkdBNDRpNGpNc1BoclBJUkwxb2FR?=
 =?utf-8?B?SUx2VlBia0M0QzBEZEN4WFhMTFVZZisvTUNiNFIvS2xwQmhHa1A5bDNhbTlH?=
 =?utf-8?B?QTRmSG5ERHNMSHY1dnpMUldRQ1NDMlZ5aTlIWXFxNEtNbHVGQitaZ2ZGL0V2?=
 =?utf-8?B?MUY5SkNWVGVtTHJ3ek9sUzZFNHBOQ1pOcnN6dkxOYlZPNFBpbElFbTdNV3pp?=
 =?utf-8?B?bCt4S05kL013M3ZTajUxTVgyVkRoV0FLZ0NVc3JhODJ0S05wNFpGQWMzLzlZ?=
 =?utf-8?B?eGZodnMxbm1zZEVzcU5CZ3paTWQ0THJLTkY1YUI1TjJxMDcyVU50MmdWU2Ex?=
 =?utf-8?B?MXRUTEZBeUdjQjlYSmFBb0xuaDRJUWpMNGxzWEtsd1V6RENPNGVZcmVpNjVi?=
 =?utf-8?B?S0xlb1hRVDZzTHFaRFJ1M3FTczFFYlNOREdrdk12eGpkZzBlSG4ydllqUHBT?=
 =?utf-8?B?Q092OGhHNHlMUHg1YXh6dGo4SHN5RTVuTW83ZjN2L29lNURFeUxjWDFOR2c5?=
 =?utf-8?B?MHB0cGZYNnlCTG5SV3BLbUo5ZHgyTHhUb0FPRE01MC92QVc5TmNXcWlpK3M0?=
 =?utf-8?B?QW5KQXZmdXpSS3k4cWdEU0hyVkYwQ3hiYnNja0R4Q3NxZEtrMlF4WDhKUkRV?=
 =?utf-8?B?SWtUREltTTNiSnd2MHFFNldhOUFWZGJ2UkpNbllJZHlGbjZQaTJTZDFsTXBl?=
 =?utf-8?B?NHpPek1ZMytjUmJTVDl3eUdFUTRKYkUyUmUyL3prOFQzUkxtWVZPR3NCWFla?=
 =?utf-8?B?QW1NeGJEdlVxaDhDWEord3gwbGFBbURsSlgxd3hiWWRocVUvRmhEK0NCSzhs?=
 =?utf-8?B?UlhCbVJKdHRPT2lLSGdiL2k1RjZDRHVLVnNzNGowby9DTndEUWFaM2ZLaFEy?=
 =?utf-8?B?WDljRG1MbjB4L01COXdtSlVETXR3RkR0Rng4WkNaeGtzbVRNRy9nNVNUSVRG?=
 =?utf-8?B?VVY3M2o2Ni9KUFYrb01VUC9DbDZKdVBXZ1ZvZFp3UFV3bkpoVUUrZFBzSUEw?=
 =?utf-8?B?NVAxZ3pWUjAvTHFBN01OeVVCVDhFRTZDSFlHdTJDSmNWZlNGNDZGb05nZTdw?=
 =?utf-8?B?M25lL2FlTjhXNFdoanZaNlR6dHhnVXlVREtOMkQwclU2M3QxRHY1YTFBSkJE?=
 =?utf-8?B?bGxRazJHRlNTbUFEbm8wTFVnZzRlOHNvaEUyanFVdVdoY1NsMysvMnhKWFRL?=
 =?utf-8?B?ZWt6Y0Jod2xxTUR1cVo0djcrTFZzOXhqU0pKYStLNzhKODhEZUU3WUpqNDdz?=
 =?utf-8?B?VzBrbHBqc0ZHRytMN1pZU2RBNUYwdS9zN1d2QW5rS3l1dlZ6czhINDBxdDJM?=
 =?utf-8?B?SDFBWW5tc243WDRoUTFSSzdNSm9TT0lRZkZmNXFEVFd4V3d0UU5UdTZ4eUJp?=
 =?utf-8?B?WCswQWhuN3JxamlaZ2Y4RWpDOUVuZ1Z4VHZwU2xaWDBMSXRSQWF6TFJtRkpV?=
 =?utf-8?B?aFBPanozRjR4V0FaT1BNYkhxRnBCK0krYkZzSk82bVJXRTMrRlBoenJGU1lS?=
 =?utf-8?B?YXhQY2tsQSt4VTNEUlhoYjB1L2sxYlR4WUNOMi9JM0pPZTdENG00b05DZFF2?=
 =?utf-8?B?UWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c6fd85-2ad7-4895-36ca-08da7a7d91c7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:08:16.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+c3FzYWUW2B5Ra24cSeHPOzHWRV16ng+wWcsnRCruYdSbAFt7CTDRGK7ZrbHq7+3s/xuJIbn4pojpnGD9PKSenGhUmRTXwJyy0hWB0VCcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100008
X-Proofpoint-GUID: qp2WALIhIcqhPTxq-KvRJ0Ud1PBB7Je4
X-Proofpoint-ORIG-GUID: qp2WALIhIcqhPTxq-KvRJ0Ud1PBB7Je4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 09:54 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:03PM -0700, Allison Henderson wrote:
> > Add the new parent attribute type. XFS_ATTR_PARENT is used only for
> > parent pointer
> > entries; it uses reserved blocks like XFS_ATTR_ROOT.
> > 
> > [dchinner: forward ported and cleaned up]
> > [achender: rebased]
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks good now,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Great!  Thanks!
Allison


> 
> --D
> 
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 4 +++-
> >  fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
> >  fs/xfs/libxfs/xfs_log_format.h | 1 +
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index e28d93d232de..8df80d91399b 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -966,11 +966,13 @@ xfs_attr_set(
> >  	struct xfs_inode	*dp = args->dp;
> >  	struct xfs_mount	*mp = dp->i_mount;
> >  	struct xfs_trans_res	tres;
> > -	bool			rsvd = (args->attr_filter &
> > XFS_ATTR_ROOT);
> > +	bool			rsvd;
> >  	int			error, local;
> >  	int			rmt_blks = 0;
> >  	unsigned int		total;
> >  
> > +	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT))
> > != 0;
> > +
> >  	if (xfs_is_shutdown(dp->i_mount))
> >  		return -EIO;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_da_format.h
> > b/fs/xfs/libxfs/xfs_da_format.h
> > index 25e2841084e1..3dc03968bba6 100644
> > --- a/fs/xfs/libxfs/xfs_da_format.h
> > +++ b/fs/xfs/libxfs/xfs_da_format.h
> > @@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
> >  #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally
> > */
> >  #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted
> > attrs */
> >  #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure
> > attrs */
> > +#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
> >  #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle
> > of create/delete */
> >  #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
> >  #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
> >  #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
> > +#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
> >  #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
> > -#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT |
> > XFS_ATTR_SECURE)
> > +#define XFS_ATTR_NSP_ONDISK_MASK \
> > +			(XFS_ATTR_ROOT | XFS_ATTR_SECURE |
> > XFS_ATTR_PARENT)
> >  
> >  /*
> >   * Alignment for namelist and valuelist entries (since they are
> > mixed
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h
> > b/fs/xfs/libxfs/xfs_log_format.h
> > index b351b9dc6561..eea53874fde8 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -917,6 +917,7 @@ struct xfs_icreate_log {
> >   */
> >  #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
> >  					 XFS_ATTR_SECURE | \
> > +					 XFS_ATTR_PARENT | \
> >  					 XFS_ATTR_INCOMPLETE)
> >  
> >  /*
> > -- 
> > 2.25.1
> > 

