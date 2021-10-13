Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1B6C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 14:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8AFA61130
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 14:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhJMOqY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:46:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32246 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237240AbhJMOqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 10:46:24 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DEU01a003524;
        Wed, 13 Oct 2021 14:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=wQYz2khJjRuqvWG2cvcNSC7c3nlWVX8rIB67882jMJQ=;
 b=tGSNEoIUz5k5HmsJoqxZRtck139YVo68WzEY6e4WOTIR38nDmkExZ5usdqFl5bQ0L/4W
 nxKQq0brkOhy1kb8eef+dg2ZVTqsIQrASK450mAz9YIYKOJ7byCfWhveKZrnscsKMV6a
 LfhSPxN+5+w56F25aPYOzRUfArLDm93eD+AgAe8CA3guHHV0/NtQinIg0TxW65Jw0Osv
 sFqYHr8C4LtZLrIiz03ZfgjZFKnaKDBVXd7UB5iINnAVsSsyJLyIhsY9uZ8jtcZad0rF
 rvDklr87bOkGmT0MipJ90WiYbI8Y2I+3ObtFNmpFJ9QOr+CE5DgrDXGzXG5eXJCK1XhH 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbjcmxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 14:44:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19DEUjr6009651;
        Wed, 13 Oct 2021 14:44:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3030.oracle.com with ESMTP id 3bkyxtk38h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 14:44:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqY9Vsg+4cFp7zNk36hHk2ruRz2NQ5AUQTAcUDUjzeihweYKPPuSQsDi5gZkOibzdrzL20pxKLhpmFCHIxBdkmP7Q5elYqD0vs3B8OiTa8v3Hoe5feiJ7if95GSLfF3j41ceVu/E2zMfING9l7/C5NdCTOTZfH77fUCCNsd78mWRyWyBGzyj+9upQt/C3U1bTcRZTMvEddaKaPq+SL2ZMLsZoViJ7H9ANQ/ltP5eqTfG9KWvosQm0uvRW2PL7I8fP+OmEBlEdOTjI3oE+C0UAbPkUcuKsScT1thCfvwzwoAfpCVzP2ryCbpulwHMpKVwGPLSmF5Med4P8qa79W+0Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQYz2khJjRuqvWG2cvcNSC7c3nlWVX8rIB67882jMJQ=;
 b=Q1YZ0Wc4kYhD3X4A+LyBbh4QD+P6FGEpecTuHr6MMf2DwuwGGWUjgK+Db+rOjh+XTBGaWKAP7HKOkMIznqsQLrLKHs4ADOlrj4t4y9FTVWbXMUSgUOTcoRN327EC8egXpy99kOSfuNkqWZWV9v/f2goqqeat0FGHOuDozY2egklwwWDYoKvrdON74Ih/wq77q7VfHWzDzChgSIXgpTXSQRbY2JCZ62HmaZh+BqoaH4Ze7pcwy1V0izSA7QNvwYPYhIUKoNf2DCVTMfDtRM6vLdmTe2NgaK9Zo+YEH2KuHqKzNBHTHd3s0lws+96OFF5ZAqfGLVD8CRZpMmbj/B8xJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQYz2khJjRuqvWG2cvcNSC7c3nlWVX8rIB67882jMJQ=;
 b=K9OwVjl2K5vNFf/PJs7cE5i4D7xKEXr0+uvXAJKJf+UxS5RhuX111Ga3zd5z+R3qunPm7a77f+1hT0AlhE3I9TOKGF9TQFS1akIknsRJhb49f2v6uxedpn3sIFgfjU8t63jgFOeNoATZm2p+BmTXYszzKQVf5S+826mxVMb04Ts=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4617.namprd10.prod.outlook.com (2603:10b6:806:118::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 14:44:15 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 14:44:15 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
 <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930225523.GA54211@dread.disaster.area>
 <87pmshrtsm.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20211010214907.GK54211@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields
 based on their width
Message-ID: <874k9nwt6i.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20211010214907.GK54211@dread.disaster.area>
Date:   Wed, 13 Oct 2021 20:14:01 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0053.jpnprd01.prod.outlook.com
 (2603:1096:405:2::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.55) by TYCPR01CA0053.jpnprd01.prod.outlook.com (2603:1096:405:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.26 via Frontend Transport; Wed, 13 Oct 2021 14:44:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a9185dc-f9ac-4094-71d7-08d98e57ed58
X-MS-TrafficTypeDiagnostic: SA2PR10MB4617:
X-Microsoft-Antispam-PRVS: <SA2PR10MB46175A7B873248706DA325D2F6B79@SA2PR10MB4617.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBYyGMNmKCY6GV7fiSt3ZLB4ynUAHB9TkUF/HzkJyZzkBHcnibtE660Uh3DEyULbFFHhWCO1d6Hl5heafK9aO3KL3NHMUZTK9uNlJNiOG16PKOsmfLc22rMazkXIVvDqyzTmXQepKDnLD4mxhHWzO1xu7JAh63uXYBd27K/7dlriWhvw02HwpqJrAP2UgHmTlrCrehTVQoJ4xrYMecQMLV1YYpsSnkC3jZKRss2Dv+nt68IJ8W14hNmgiymFUMN01BrY7c9v2dezKNCl0RpjuSaTCtenxz9oDsXktjhbwkdx5X/gJWud3AMmMzWCPs+3zI4QjMMK91tSqpu9tCXUy6wex9aBzEqX71E/mDO2RgKoNuhsXlklo2BCmAxKXjeRWHRcKEVBeVKO/sh0gKoXb2FHee1w53bPnSPnnJVZe2Vrl6RpfSiQHkUm7plsJyHUOqX+x1o77wa/uJZC6oCeotIbbuszangn83ITT9dwwxUacqvXDdIuN5QGuZ+LCRWVaarMdflfvbN7yNX6K4L/6+bNboZTw/Yo4h3RaiLwfUu+1PbQq6+FRM5OUIvZ3r3LvR9JYyI0O9bIek024wbpsoXszjqvjdaK5MGv/e/pPpNK3Rl5jxXt8oMRuG3QI9jH0lSyKGJ3ErNq1a4TMmcicgv87PbneH3tU8MnUjMyNkriMZdjC0653j4NpdTEevv+jZrUd6ZClmW/RG0focPYkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(26005)(86362001)(6486002)(6916009)(8676002)(316002)(186003)(5660300002)(4326008)(956004)(6496006)(2906002)(38100700002)(38350700002)(66946007)(66476007)(66556008)(53546011)(9686003)(8936002)(33716001)(52116002)(6666004)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?52yDXpEvTDaRyoE+/zFfVMzzpbkJi7c6X9/sZO4BmwmobWlfME5TOM38jRMv?=
 =?us-ascii?Q?uQyBj8lTnguv1V2plJVwF9bn4ADJHbMeSbShGDxVaQxB92gJimvLxaFjKHDt?=
 =?us-ascii?Q?NsBe04Ndg5Gl4HHc7A9fo/S6pzTNrA3+GWsNZb+Or7+srlAU5Zc1j7lWp8y4?=
 =?us-ascii?Q?z0W7ftf19yjkmNbxc7wPDkeXU1nC3RG65yUJBlhBBfyR3M6S4FEIvmGT7sMc?=
 =?us-ascii?Q?eIG0EdeJSlsyyPpkzk7BVKXk/3keVoETTlBjgLktGVE4k5pxVP1J2agq5f3C?=
 =?us-ascii?Q?KUnfOe2tkIFtl6RodqpVIPxzh7KIO2t/M3QRoJIPgnI9yVmcpTBmgsnh+/BM?=
 =?us-ascii?Q?D3zrqi0FV7C2+sr4OIbswqNX6oJr6Ocpr3XAy35zTUHMolqh8XC3uG6+yVzr?=
 =?us-ascii?Q?8IxbZvXUJBFmyWEcfw62gGs80QnoVE1wQsZSu7NNUmVhtiuSgV/o97Dftssv?=
 =?us-ascii?Q?/xL/GlMEi3O5gZb9RCc0NCU3zLJYe3PogT0b6r9F0h84nqJCb4pv0qcb8n7D?=
 =?us-ascii?Q?HIrelES2rXPne5qIQbJuf9G1fcqaP44SKgDauj68VOygY/y1Pt+f9BDt7/8/?=
 =?us-ascii?Q?vNvjB5spKcUoXGtx+xAP1FQFS8yLXcGIZfIS116xzTUXm/QpO+DSp9pPP0EY?=
 =?us-ascii?Q?w7BueaxT2oDemRrg83W3vN2rqwIpZ5c5TwRjGHApXu3DCc0N291PEwoeg1Of?=
 =?us-ascii?Q?IaDA8wNiOUUIECNMDd2WEs/BPIBlFKty7g6Wz78UprbMgLPge9guQNb97PO9?=
 =?us-ascii?Q?KmVtEe4IRY/Nd9PdVIHp+hiV4dZ2IZQ8f0Pdcc1YwldXUH4KumUo8B82wwP4?=
 =?us-ascii?Q?ygouGhtiaz4X0NyB2nOwY6iiLUXBiYgdDB5rezl+ADSo26OQuARU4L5hzj0A?=
 =?us-ascii?Q?ocq4mxul+yxjl0Iw/cnZabR/e+visXfqfHhj8XvDVMe7Ll8g9aIC4ZwADG7u?=
 =?us-ascii?Q?Vyfj4lTpdKyZ1V+7nv4aA0ehdbOvCq/rq4NJl+lKB/rEyeLW9q8SkW+K1w0E?=
 =?us-ascii?Q?xZBch3snhEKvATJc5KHcxKoq31EJB94Lwgoi3V/Kc5p5OA/1qNliOcVGDIZe?=
 =?us-ascii?Q?qOoeC7jW7qKT+CbCBAtaT5rqKGKheDvWGiaa9Hk1R6CeKjBBjnTRgpIf3tER?=
 =?us-ascii?Q?CLdff297ltuZ2XbXCI2LRmMpjofLijwT0r9LIwDwT+Z5PB5gfOsW3PNc/UAP?=
 =?us-ascii?Q?/IoSYTUIAoGgP+NPJ9nqgx5R3BCRcea7b8LH9MhRxPneiMvER0ZyBZCv86QL?=
 =?us-ascii?Q?ach5sy7hbHAKS9mxHxapfZyeITIeu26TyoMi/cabQRlXvn6r8x0pBIamjqqR?=
 =?us-ascii?Q?UmlPpLWoff2U8r7cwhfxnKid?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9185dc-f9ac-4094-71d7-08d98e57ed58
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:44:14.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pG8dFwKdruHNDDrsKGIU4OGjfLHiXnt/uqxud82M1LmMo4M8wpPdzHVfPPwGrHWtnsl11uvN9JUahdORkOtOVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4617
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10136 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110130098
X-Proofpoint-GUID: o-nC_BLBDo2590AjShUMoGelNd_ZLG6H
X-Proofpoint-ORIG-GUID: o-nC_BLBDo2590AjShUMoGelNd_ZLG6H
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Oct 2021 at 03:19, Dave Chinner wrote:
> On Thu, Oct 07, 2021 at 04:22:25PM +0530, Chandan Babu R wrote:
>> On 01 Oct 2021 at 04:25, Dave Chinner wrote:
>> > On Thu, Sep 30, 2021 at 01:00:00PM +0530, Chandan Babu R wrote:
>> >> On 30 Sep 2021 at 10:01, Dave Chinner wrote:
>> >> > On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
>> >> >
>> >> 
>> >> Ok. The above solution looks logically correct. I haven't been able to come up
>> >> with a scenario where the solution wouldn't work. I will implement it and see
>> >> if anything breaks.
>> >
>> > I think I can poke one hole in it - I missed the fact that if we
>> > upgrade and inode read time, and then we modify the inode without
>> > modifying the inode core (can we even do that - metadata mods should
>> > at least change timestamps right?) then we don't log the format
>> > change or the NREXT64 inode flag change and they only appear in the
>> > on-disk inode at writeback.
>> >
>> > Log recovery needs to be checked for correct behaviour here. I think
>> > that if the inode is in NREXT64 format when read in and the log
>> > inode core is not, then the on disk LSN must be more recent than
>> > what is being recovered from the log and should be skipped. If
>> > NREXT64 is present in the log inode, then we logged the core
>> > properly and we just don't care what format is on disk because we
>> > replay it into NREXT64 format and write that back.
>> 
>> xfs_inode_item_format() logs the inode core regardless of whether
>> XFS_ILOG_CORE flag is set in xfs_inode_log_item->ili_fields. Hence, setting
>> the NREXT64 bit in xfs_dinode->di_flags2 just after reading an inode from disk
>> should not result in a scenario where the corresponding
>> xfs_log_dinode->di_flags2 will not have NREXT64 bit set.
>
> Except that log recovery might be replaying lots of indoe changes
> such as:
>
> log inode
> commit A
> log inode
> commit B
> log inode
> set NREXT64
> commit C
> writeback inode
> <crash before log tail moves>
>
> Recovery will then replay commit A, B and C, in which case we *must
> not recover the log inode* in commit A or B because the LSN in the
> on-disk inode points at commit C. Hence replaying A or B will result
> in the on-disk inode going backwards in time and hence resulting in
> an inconsistent state on disk until commit C is recovered.
>
>> i.e. there is no need to compare LSNs of the checkpoint
>> transaction being replayed and that of the disk inode.
>
> Inncorrect: we -always- have to do this, regardless of the change
> being made.
>
>> If log recovery comes across a log inode with NREXT64 bit set in its di_flags2
>> field, then we can safely conclude that the ondisk inode has to be updated to
>> reflect this change
>
> We can't assume that. This makes an assumption that NREXT64 is
> only ever a one-way transition. There's nothing in the disk format that
> prevents us from -removing- NREXT64 for inodes that don't need large
> extent counts.
>
> Yes, the -current implementation- does not allow going back to small
> extent counts, but the on-disk format design still needs to allow
> for such things to be done as we may need such functionality and
> flexibility in the on-disk format in the future.
>
> Hence we have to ensure that log recovery handles both set and reset
> transistions from the start. If we don't ensure that log recovery
> handles reset conditions when we first add the feature bit, then
> we are going to have to add a log incompat or another feature bit
> to stop older kernels from trying to recover reset operations.
>

Ok. I had never considered the possibility of transitioning an inode back into
32-bit data fork extent count format. With this new requirement, I now
understand the reasoning behind comparing ondisk inode's LSN and checkpoint
transaction's LSN.

As you have mentioned earlier, comparing LSNs is required not only for the
change introduced in this patch, but also for any other change in value of any
of the inode's fields. Without such a comparison, the inode can temporarily
end up being in an inconsistent state during log replay.

To that end, The following code snippet from xlog_recover_inode_commit_pass2()
skips playing back xfs_log_dinode entries when ondisk inode's LSN is greater
than checkpoint transaction's LSN,

        if (dip->di_version >= 3) {
                xfs_lsn_t       lsn = be64_to_cpu(dip->di_lsn);

                if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) > 0) {
                        trace_xfs_log_recover_inode_skip(log, in_f);
                        error = 0;
                        goto out_owner_change;
                }
        }


However, if the commits in the sequence below belong to three different
checkpoint transactions having the same LSN,

log inode
commit A
log inode
commit B
set NREXT64
log inode
commit C
writeback inode
<crash before log tail moves>

Then the above code snippet won't prevent an inode from becoming temporarily
inconsistent due to commits A and B being replayed. To handle this, we should
probably go with the additional rule of "Replay log inode if both the log
inode and the ondisk inode have the same value for NREXT64 bit".

With that additional rule in place, the following sequence will result in a
consistent inode state even if all the three checkpoint transactions have the
same LSN,

log inode
commit A
set NREXT64
log inode
commit B
clear NREXT64
log inode
commit C
writeback inode
<crash before log tail moves>

i.e. Commit B won't be replayed.

Please let me know if my understanding is incorrect.

> IOWs, the only determining factor as to whether we should replay an
> inode is the LSN of the on-disk inode vs the LSN of the transaction
> being replayed. Feature bits in either the on-disk ior log inode are
> not reliable indicators of whether a dynamically set feature is
> active or not at the time the inode item is being replayed...
>
>> >> > FWIW, I also think doing something like this would help make the
>> >> > code be easier to read and confirm that it is obviously correct when
>> >> > reading it:
>> >> >
>> >> > 	__be32          di_gid;         /* owner's group id */
>> >> > 	__be32          di_nlink;       /* number of links to file */
>> >> > 	__be16          di_projid_lo;   /* lower part of owner's project id */
>> >> > 	__be16          di_projid_hi;   /* higher part owner's project id */
>> >> > 	union {
>> >> > 		__be64	di_big_dextcnt;	/* NREXT64 data extents */
>> >> > 		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
>> >> > 		struct {
>> >> > 			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
>> >> > 			__be16	di_flushiter;	/* V2 inode incremented on flush */
>> >> > 		};
>> >> > 	};
>> >> > 	xfs_timestamp_t di_atime;       /* time last accessed */
>> >> > 	xfs_timestamp_t di_mtime;       /* time last modified */
>> >> > 	xfs_timestamp_t di_ctime;       /* time created/inode modified */
>> >> > 	__be64          di_size;        /* number of bytes in file */
>> >> > 	__be64          di_nblocks;     /* # of direct & btree blocks used */
>> >> > 	__be32          di_extsize;     /* basic/minimum extent size for file */
>> >> > 	union {
>> >> > 		struct {
>> >> > 			__be32	di_big_aextcnt; /* NREXT64 attr extents */
>> >> > 			__be16	di_nrext64_pad;	/* NREXT64 unused, zero */
>> >> > 		};
>> >> > 		struct {
>> >> > 			__be32	di_nextents;    /* !NREXT64 data extents */
>> >> > 			__be16	di_anextents;   /* !NREXT64 attr extents */
>> >> > 		}
>> >> > 	}
>> 
>> The two structures above result in padding and hence result in a hole being
>> introduced. The entire union above can be replaced with the following,
>> 
>>         union {
>>                 __be32  di_big_aextcnt; /* NREXT64 attr extents */
>>                 __be32  di_nextents;    /* !NREXT64 data extents */
>>         };
>>         union {
>>                 __be16  di_nrext64_pad; /* NREXT64 unused, zero */
>>                 __be16  di_anextents;   /* !NREXT64 attr extents */
>>         };
>
> I don't think this makes sense. This groups by field rather than
> by feature layout. It doesn't make it clear at all that these
> varaibles both change definition at the same time - they are either
> {di_nexts, di_anexts} pair or a {di_big_aexts, pad} pair. That's the
> whole point of using anonymous structs here - it defines and
> documents the relationship between the layouts when certain features
> are set rather than relying on people to parse the comments
> correctly to determine the relationship....

Ok. I will need to check if there are alternative ways of arranging the fields
to accomplish the goal stated above. I will think about this and get back as
soon as possible.

-- 
chandan
