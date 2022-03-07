Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8C2C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 13:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbiCGNsK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 08:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiCGNsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 08:48:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D168C7D0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Mar 2022 05:47:15 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227C3E65009954;
        Mon, 7 Mar 2022 13:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GTcy8RCaKkk73nWyWqeTPy+ZPIWB78rHuKPKfMPsGVA=;
 b=GHEtWOqFQemcTEL/mnglk6RqT3adTZsfqUo/cTRaBPfAQEdL2xS6jw7ob0wt7VuUDHMr
 X5zVtgFRK9yaMTMQtlgaXXfm0Rs20GQjH4WiilZFEod09Ojk7eY5ioJm3mVFg8b4krPK
 Xpx6V8oc9STpX007YA91gRJxbX+ItKScwhqL2tjzeCSOdFUYkxCCnycQz+8C8DrHeD7d
 QdcaExz+OHY1AHMtJosaDN4C5f9rI88tD1/k6KVrXz/2BGWIjuMO/08R7nHPxQtaHeOi
 rKlKkMR0g+LxHnjUqcOw4DI6wuoh6L5BBoQKuHVox4DcaWanBwqdC+PtvtTKKS50LVzf IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrakrn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 13:47:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227Df9ZW139641;
        Mon, 7 Mar 2022 13:47:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3em1aj0jnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 13:47:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgg+hslmNgeFvRYg0NSa+tN8K6qhdNLu69bP3MRFR6OjisdCxVJTYTOmK84hPTaxXNxzIkOv1gFF/9JK6vZ/saMC+mmiD+gVi4a+sRJ4OhpZno3+A2GhePryAO/YFDCaWVM6ZCKIPZ+x/0wdHRZ8Y5yQS23u9G5iRtR8ign9W0/qEAaSDEytX2YM0f50UEQDkenUJsCcuXM90r0pDY5P4iOmXRce34FMYJVNYpiw07PmggBjfbIFo5J2zUY2whIVhkjZrjnbZqO9KmXiCIqRbgGl3aLamK6u/QWMgr6LrGaQ7zbctn3DPB2Lm5OXjeJWwJDZLtVN7fLRuJqqCWAUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTcy8RCaKkk73nWyWqeTPy+ZPIWB78rHuKPKfMPsGVA=;
 b=S3wV4rSDos0jT23etA3+1bvH84NreG/be+dM045gF5Rr+QuLus1vSH3K/QInMzLuTT2czUPilhsvcIwM/NmBPrQOU4pu3oGM/lsa5OtLlEtr2hAjz4xPmz9AvOuEjUQjdj8bCozKlwLuJEOe9qN2iKDWdvDj1whdAW6cIiy6MTRAqEb6LJyrNRXJTx5hcBuoxYVTJnt7gN1M9kZ7UOeamiCJKjJ2Gdrpf1CnGHiRvlSWfNc+n6BC10IZAIUSKugMUVh35XQrP5I4+7NVOV8d36fHeTrqqB93antRX1pBOIsWQ8uMRCbd3yfs6dSPXJ2hKqkgh8Fnh6PKp18PKJj/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTcy8RCaKkk73nWyWqeTPy+ZPIWB78rHuKPKfMPsGVA=;
 b=vHlrusiPX0s4ls/YhsVssy0ftiWXUAjrIKuwgVu/5PzciRj3bcMM7GRjurh+abpCTm3k/2/fDmauyjf1XPTdu9FrW7i9coESwS0ZYad04v/rQcW6+5z1Gi+2Bmau5WANfWyJrInznE6OmAbpYhredcnyR7tNgzMY7aaAedm0Xtk=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH0PR10MB5033.namprd10.prod.outlook.com (2603:10b6:610:c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 13:47:08 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 13:47:08 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-16-chandan.babu@oracle.com>
 <20220304080932.GK59715@dread.disaster.area>
 <87fsnwlg9a.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220307051339.GO59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220307051339.GO59715@dread.disaster.area>
Message-ID: <87h789swmm.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 07 Mar 2022 19:16:57 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0053.jpnprd01.prod.outlook.com
 (2603:1096:403:a::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2279b97c-c841-4337-8b84-08da0040f892
X-MS-TrafficTypeDiagnostic: CH0PR10MB5033:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB503398B4860A17619D7D8794F6089@CH0PR10MB5033.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dNleVF3NBOt3iImVG8yeqo8XZGU6EOZfTQLoodZDShMDQElyyw0YyMBXFPORNsO4D62+ot8/34Te96WAwNhUuwl2HpzYHpNQmhcbt1ddGBlue+VqHVXgjlcOgKxG9QZCxp8k8tfmRONixP/JPyeIoZjawuQ7N1zg3OPg6PA3teo4ZZVAKGYRGTInZKkFo1qgpD9I7wPEBojXTfs9sfRTwrcdZSc40pMq2usfy3O10M2kz270KLC4HE8jEEpL2R+1mIDXh1246XXWIW/yMHySMOGWiOtZS2pcDmecCmHaOyDO5lX3kuJPrHiP9k3uA7uUQaXuNqaTDqxZPaJ8F/G7qGltq6ZRVIXWBrRwnqlcaQ9O/gSsgrz9ueeSAyqWOdVbMH3IaUW0R1QTMwyns3YZsKEl4zN1Hp7u3KvirdS1aPV2vWPuTBt5Rpyec8RHL76buslUJcaSUCWs/30c8gbVI4HDF/Vas3RL6nyK9GxHsxDKppZM2L2JC+1UDgwnpoN1ufsMUya3w1N3L8u7G9L6Jhco2QoMQlhIDKeVSAl3YkftP+9lgLX+o7WU8Ls1mjN9CFwEaHsA6bfCTyPp/DOJmtHbfauWg40o+4jeibs7RPvC8aXkebQOd+IkZTzVcChw0aA/AwibGGCsYqV2UzX+B333xBk6mo3ZfThqjTr4OOtvALy04LzSloA6RnCLYBG+QOEzdugx4PbQkZWeOiFC8KSMcu6Q1DBXKbBXy6c9SboUNH/sB/H9sTaJ7XFYGK+9fUhwBuIBuffMtJfLlNH1C4XzsqEP/VfpzTMOFwtZZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(83380400001)(86362001)(8936002)(6506007)(6486002)(4326008)(966005)(33716001)(66946007)(66556008)(8676002)(6916009)(9686003)(66476007)(38350700002)(38100700002)(6512007)(508600001)(2906002)(26005)(186003)(52116002)(53546011)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?psF+lFBJf++ZG6RCzAnghierrj7bXUsVdrmhgszRiDtG/VK/pxhiQbl3A65u?=
 =?us-ascii?Q?xUpK9CLkCoD8/+W95ZbI+QNVvFdLpJ+LAE3annyr8lyc/vWSQ7+Uu4tWfkP7?=
 =?us-ascii?Q?EEMonN2u6xRYD4HjEOp6aRH75UKY7cHbj1qaYB40yerFvH3LmmTrcqr/Sr0j?=
 =?us-ascii?Q?33fso5BUV6oRJ29Mfljuo0N55/S18Nqm2BfcS2V+NNTT+bWxvrHZLXEBoFLO?=
 =?us-ascii?Q?5XLV1v+yOE9QebzEXTsbDV1vqp29P1PVMGBTMDKgskAs421LQPI9k+G2YUF0?=
 =?us-ascii?Q?4MFdxN5upj1Nlf5ro2mkVi4M9rDErutD+BPchN+917diWjzUIi/ZSqi9pV8v?=
 =?us-ascii?Q?Ny+s947M6gPL+90KV7hR9slmiyAxOE8KnbhmhaAgnbBoqKqJ2c4LslnugNRP?=
 =?us-ascii?Q?oyV3RupoF5SZoWhP9xXTKbZgO/tFSNBPKLTg8hQe8dJbU+10TZ8N1v7FV3FI?=
 =?us-ascii?Q?Rscf98OyAjun48JHlWLXoJZZZNLr8Czhwnm8MAGvH8cXilOJxWLsL6MurBC6?=
 =?us-ascii?Q?GT1vamVM7jXt+hxbE+au8wIrvcFtSVZPNfIoWfPS7WBmP+UHO9HiesInidaY?=
 =?us-ascii?Q?buEFVUxf/q4WMMWBMoL7icqQSLBqrRh9HQLceZ2IvNoUTBCRPwMVsaO5MrHA?=
 =?us-ascii?Q?pXwyU1AwXSN7hsRJCeL+RJ5ODje5ZYl3CfTCOkZt84S4DSNG2SH+ZCp0+1jU?=
 =?us-ascii?Q?w22sliD2AQbgdF2xmM68bIaQj6Cx35sYPn5lmzXqpNJS+Ex//h3LYNBM62EB?=
 =?us-ascii?Q?w+bNdLxM8LnYd6RNycER+oKYTCnTnKsaSQy6RYrjvLWgsOP4ngq9oSWFVvSl?=
 =?us-ascii?Q?QGp1tffuowFh53XaE3bBKgYbZQ+Y5iEYtv6lDrqreSNtgUl/yuYjLfekcdor?=
 =?us-ascii?Q?xnla9w/hGNme7sS+yeP+odCsw9KCXaaTzYajjBtnFhClSFbKkt0G1P4lY4ke?=
 =?us-ascii?Q?sO4jHVy1gJbEv5feL/TEz0w/R31mPipO5I2NrKlaTOz21PkMZymlTn97td2j?=
 =?us-ascii?Q?yTUwinGskc7C8RxBe+XEiMK2RNbcsch6bahyIskNzPvCG82PGu/TgdunV/xW?=
 =?us-ascii?Q?EKAB4b8krNTlzcpGX4BiCEnKviWPO+G1/Nj8ecQ7vulMI/7SqpLLz6oUWsVx?=
 =?us-ascii?Q?B6Wdm/wpVlMmmKSm+wRmQYSw5AdUP4zb/uNbGw0U6aWOndwR4arLhff0mMAO?=
 =?us-ascii?Q?bc2CC+Odnd15lwawjQ6WtK1rfOEecrFqsN5+A8rzRPY9QBXDHplZgBQBmKNb?=
 =?us-ascii?Q?6qbEpdOMXR7Xb/pFMHB99vdf1s04zhMYIbx00E8UdnMyyJ9dr12RwpJ0sB1r?=
 =?us-ascii?Q?mtElEgdZ6uDLhAlzE7R0HZoLUiwu6PfSsoXtR7gsSSIN0ODJzzpyGnxv9qx9?=
 =?us-ascii?Q?aegQwz2uBVIYJeOvIHnzbgEkDk23eTZNC7rfio2UKzAbvPLMOZvWqFixER6t?=
 =?us-ascii?Q?Oja2qV1K/ewufO9ySQHpjJUxgqUplhcLJBNzjoKUkV6OUGTV8IvM0slhjiCq?=
 =?us-ascii?Q?RrpQUBlWsHyUrm9p6zyIF61xgpfVrXAhm5I7MFMO2L7QKqfbcpnZfXU6iebT?=
 =?us-ascii?Q?3VTzAVtNAgHmXFjhXkkMfRMaL9B33OeB3ifr55EYlz5Gltw37gvCuexkroOe?=
 =?us-ascii?Q?gDSQ0QuBatGtoDgM0GQKTgo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2279b97c-c841-4337-8b84-08da0040f892
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 13:47:08.2417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4Sb2bj+MbPTaWJI2ePvl9lVLpA8YPTHLQlbCWl0NFSwFiHeloVUcvlOlBoVkwPCBni5DCSlX4z8j0d0d/8ejQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5033
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070079
X-Proofpoint-GUID: N8kWBcg_ynVkYL7f7Zaf901EaxNRhXO5
X-Proofpoint-ORIG-GUID: N8kWBcg_ynVkYL7f7Zaf901EaxNRhXO5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Mar 2022 at 10:43, Dave Chinner wrote:
> On Sat, Mar 05, 2022 at 06:15:37PM +0530, Chandan Babu R wrote:
>> On 04 Mar 2022 at 13:39, Dave Chinner wrote:
>> > On Tue, Mar 01, 2022 at 04:09:36PM +0530, Chandan Babu R wrote:
>> >> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
>> >>  
>> >>  	buf->bs_xflags = xfs_ip2xflags(ip);
>> >>  	buf->bs_extsize_blks = ip->i_extsize;
>> >> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> >> +
>> >> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> >> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> >> +		xfs_extnum_t	max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
>> >> +
>> >> +		if (unlikely(XFS_TEST_ERROR(false, mp,
>> >> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
>> >> +			max_nextents = 10;
>> >> +
>> >> +		if (nextents > max_nextents) {
>> >> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> >> +			xfs_irele(ip);
>> >> +			error = -EOVERFLOW;
>> >> +			goto out;
>> >> +		}
>> >
>> > This just seems wrong. This will cause a total abort of the bulkstat
>> > pass which will just be completely unexpected by any application
>> > taht does not know about 64 bit extent counts. Most of them likely
>> > don't even care about the extent count in the data being returned.
>> >
>> > Really, I think this should just set the extent count to the MAX
>> > number and just continue onwards, otherwise existing application
>> > will not be able to bulkstat a filesystem with large extents counts
>> > in it at all.
>> >
>> 
>> Actually, I don't know much about how applications use bulkstat. I am
>> dependent on guidance from other developers who are well versed on this
>> topic. I will change the code to return maximum extent count if the value
>> overflows older extent count limits.
>
> They tend to just run in a loop until either no more inodes are to
> be found or an error occurs. bulkstat loops don't expect errors to
> be reported - it's hard to do something based on all inodes if you
> get errors reading then inodes part way through. There's no way for
> the application to tell where it should restart scanning - the
> bulkstat iteration cookie is controlled by the kernel, and I don't
> think we update it on error.

xfs_bulkstat() has the following,

        kmem_free(bc.buf);

        /*
         * We found some inodes, so clear the error status and return them.
         * The lastino pointer will point directly at the inode that triggered
         * any error that occurred, so on the next call the error will be
         * triggered again and propagated to userspace as there will be no
         * formatted inodes in the buffer.
         */
        if (breq->ocount > 0)
                error = 0;

        return error;

The above will help the userspace process to issue another bulkstat call which
beging from the inode causing an error.

>
> e.g. see fstests src/bstat.c and src/bulkstat_unlink_test*.c - they
> simply abort if bulkstat fails. Same goes for xfsdump common/util.c
> and dump/content.c - they just error out and return and don't try to
> continue further.

I made the following changes to src/bstat.c,

diff --git a/src/bstat.c b/src/bstat.c
index 3f3dc2c6..0e72190e 100644
--- a/src/bstat.c
+++ b/src/bstat.c
@@ -143,7 +143,19 @@ main(int argc, char **argv)
 	bulkreq.ubuffer = t;
 	bulkreq.ocount  = &count;
 
-	while ((ret = xfsctl(name, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq)) == 0) {
+	while (1) {
+		ret = xfsctl(name, fsfd, XFS_IOC_FSBULKSTAT, &bulkreq);
+		if (ret == -1) {
+			if (errno == EOVERFLOW) {
+				printf("Skipping inode %llu.\n",  last+1);
+				++last;
+				continue;
+			}
+
+			perror("xfsctl");
+			exit(1);
+		}
+
 		total += count;
 

Executing the script at
https://gist.github.com/chandanr/f2d147fa20a681e1508e182b5b7cdb00 provides the
following output,

...

ino 128 mode 040755 nlink 3 uid 0 gid 0 rdev 0
blksize 4096 size 37 blocks 0 xflags 0 extsize 0
atime Thu Jan  1 00:00:00.000000000 1970
mtime Mon Mar  7 13:06:30.051339892 2022
ctime Mon Mar  7 13:06:30.051339892 2022
extents 0 0 gen 0
DMI: event mask 0x00000000 state 0x0000

Skipping inode 131.

ino 132 mode 040755 nlink 2 uid 0 gid 0 rdev 0
blksize 4096 size 97 blocks 0 xflags 0 extsize 0
atime Mon Mar  7 13:06:30.051339892 2022
mtime Mon Mar  7 13:06:30.083339892 2022
ctime Mon Mar  7 13:06:30.083339892 2022
extents 0 0 gen 548703887
DMI: event mask 0x00000000 state 0x0000

...

The above illustrates that userspace programs can be modified to use lastip to
skip inodes which cause bulkstat ioctl to return with an error.

>
> Hence returning -EOVERFLOW because the extent count is greater than
> what can be held in the struct bstat will stop those programs from
> running properly to completion.
>

-- 
chandan
