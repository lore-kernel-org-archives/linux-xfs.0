Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BF6C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiCEMrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiCEMrC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:47:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227491CC7FD
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:46:12 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 225ARlqH009954;
        Sat, 5 Mar 2022 12:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=p5mMmGeIYI5tNCktIgfonqn8aO2kYaN7vTQsfL3C1EA=;
 b=LTmkrlb4/R39OyzWTkgYjJnHIdheVr2c2gc1VtWHoItJPIrG8zLdpmrRn4h4+HmJwq2f
 E8ufh8ZCYewRVFNsAW1hzN9FHnBOX/2vFyp3L0qoYT+wqBZb7lTOZDi2tOlee+BuGMH2
 WZrlL9qz/OrVZGGbBrck3S7hsvtXqwmFRXn0fyZ+PQ40J2+ZpFK1V1YHe/xvIccOypOv
 INA2fRsczHit20PxZU9k7TkhgzLVR8IsC1ajjwwD87FMpHSl92QXZ7gG5fQiWdPY3CNx
 bns73xBdzle9TccE5gbHliLFsy3O++yYCTnf9bTjC9ANhRsRhcUMPbwRTJMz0xSGt8SP DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyragnnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:46:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225CZSfn154284;
        Sat, 5 Mar 2022 12:46:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3030.oracle.com with ESMTP id 3ekww9j7he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:46:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QbCXnP/g8iZIW/3gdtl3qkFWkWcqZt4wy3+N7nqZicZTTrWRQNp9bzSwnQAGRuc201doh7rhKD7esgZVIoxRyjAx25vOcZjC44HpFtQOSJIlarnIEoN9zg1/iDp/U4s8es+D35Y+mijssGnk037UlHR0bYllVUZe9wQ9djxKKDvDFjfFhr/M0hSlCOXb9p4gWaX+1aZjAYW3/bC84FJT+8v8E4TmstneWi+jLZtHVBXAe1epqtaDuBozIBs3evBQQ7TtaQ5VUOK/RqbF1NAy/2wnGWewMYHivkpg2BMuNgES9o1rxLE4cnTdlFfIFvJOoeMQOZZbp2d3OWtWlbmETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5mMmGeIYI5tNCktIgfonqn8aO2kYaN7vTQsfL3C1EA=;
 b=T1a5P6zcQin5ia2MpcQQbaXkCw9JaBwXCw81zGPVYEGgHDbYt+89Yd1ENPM7K4LfqAjn//mrKq1UnTSC/R3OijP03X3Hg0V9GPxUQNRb5X3YrgtfTCBGDbFFmN6+BjpGgIBzbv91EsakwVuV/rGIse7qjC6CISr1rly2uR07MMH5T2g1AqcziITCb8uilRDUkRdCAB03eyES3Rw80FZv+zZ2caih+6UU4QpFkkB8BnzcbEP1BOUdplLSekWf06Q+7a2Z/bE2mSXa3jVlEcJfZr0+7GCyeNRz/OAa90G6xKaHlPn3hQe7f8VFDiEkFnwSpAxfA5/8nNgeV3C+Vt31Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5mMmGeIYI5tNCktIgfonqn8aO2kYaN7vTQsfL3C1EA=;
 b=h/7lbop8es9wQX4neTO7FPoDx17UeDzkSQoUInxfNxgf4RluCWHtFUZABUidTWRPTplycGJCrIIjxhxRFJtvgGQBoNczwL9RksEHi1QqLxM08AP+Age7nK+r0TLL+lcZYW83E3QWXeSbher9E57DiG+xAWeJQl6QmcFqmIcGvd8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:46:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:46:05 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-18-chandan.babu@oracle.com>
 <20220304081549.GL59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 17/17] xfs: Define max extent length based on on-disk
 format definition
In-reply-to: <20220304081549.GL59715@dread.disaster.area>
Message-ID: <87czj0lg8r.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 05 Mar 2022 18:15:56 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0014.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b329b64b-558d-46bc-7dfa-08d9fea61d1d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2821BBF5954022D77614B0C6F6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YNWDkTIA9hoTCVBmknzFckh9jdZ1i+xzR+NIFy5W29unSyIbw+fexfGm4QqAvhJO6Wcl3eO0KSgiVVmW06uMrU8R2fTO/E0rhXivNo/9igJ3XhxJBwybBREqR2NqkM9Usp5kjuFTih0BEDT5GeHLNwNHlTgUhoeKZRs1pGDkrjliCTQv3AF/RlS6Kb9pFGHN41tK1F0DyJ3Oy+hsIbeL1eXRLWrr85W/tRzEnTvGS29aXVcpPZey0zT1SlFemw4gea9+csFAUJ4MHbORYfuEL6uJpz6F66IgInjdee95SBtobMd7IYr/QVJ21DbsrBk4Qjx21aCZRGuGSwPc1RXXzIQ0Dryz9YvYt32E/9ImfQyxI0x7vohXbceIS5lWmk9STBPea3FIYCt/24Fto2dSMTKPVlVZB+6Su78vnmS0DhhEsVTcUfUn7GRqEHoT84yql01U7ng4RG9rHNrwlQq3ZTv74iZeXt3W+RXjx5TJSKWen+hcQf+Za1qV2y9PBi5sRQHqB2RbuaAZkFCwWwKlZBjTcf8RRl2NJfDmfVw+Xh3SmWf/WuQxiAknhVQz2bmbm3bhKKERIifIG4Gmxn3zQph3mFwk+yIG0C0v38BNXM8LIiKA2aikLuAwzOacgXLOSaC/r8PjkWGUzdQNk8VBATJfmo3hG2xD50b7ORVBAO6ILxWU4Eao2rNtApG4APUTUe1KNgojMHcGDx/oZRCH5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?338PFEQWbYTm/7Ke5qKjMhQq4lhLsV2mufwXm2nQJuj0AVbiNVt8eb8W4I/q?=
 =?us-ascii?Q?6zhGpg02Cfph0WXBIgBiMuAoBDFRoI3zCX6ZvRY6hSrtc9pHoCLFawLMKIFg?=
 =?us-ascii?Q?pAy0+a50HZCx+SgkjiTV6gHPLXeoTVNFwx8xW5Rj9TuuCmUQsP+CMRa/AQz6?=
 =?us-ascii?Q?Yed2PVraEaeWWPNPT+wGcOM5MJfEB9KlWtLNXCQespF4TZmNrwhZ4ctUsrC/?=
 =?us-ascii?Q?9q+Fb6NfOXD+0v8Y04Lo9QKBB+tT/VkQkNSUdWdzd1VujzR3FIlG+I0wFXvK?=
 =?us-ascii?Q?oHwOewivJmTTv7Ix62k9wNcRVykH/VolZEz0o4R2L9eu3o0HclnUY62rdSE4?=
 =?us-ascii?Q?97FO+HEjjfCW0InTjV7hDoBgmd9DkhgCeyhhiFkyORf5GDdGrNrYYcO9jkWb?=
 =?us-ascii?Q?hZUBj6Kv3Xwiln+VlFV2fLZKrHKqFa/q42DkOOCtawVbVW4UR257X3t00RyQ?=
 =?us-ascii?Q?tXmfkx2VGZVifq3TJsWMd9dpfClKRQsaYpNHgNqw7DMl8kblj0U0qmvUDOAR?=
 =?us-ascii?Q?NK4VsWlfIi8I6U65LI0J/7lKcKMdinglIBqZ1cyoduk0r2xI9Y2uhd0sKI7r?=
 =?us-ascii?Q?Y5znznOJXsSurtK7vDvnHS26ej8McuvfJgDVUrJYYgDMJM0yZ1yuOdT6T+pn?=
 =?us-ascii?Q?0/mYQkWfeXIDvOH0i5efz3Kq25c1RW3oYgf43lEShv+xRFl6WSnQz/67RL3w?=
 =?us-ascii?Q?oV9UYXjGl2Nu1k9Jxlp2nCxNp4gFg0U2/ELaNGPDRsl1yIsEX5bOB/fR5Xtu?=
 =?us-ascii?Q?yEqEA22CRjIJlHO+rkrFsY04GhryvE35NG9/iRGbWE8Ez20nad5hM4OXp2mS?=
 =?us-ascii?Q?Eht/ruRwp6onHYCw0nFyjzyt/i4nfScUmLxnz02wC4kLmbtlJmlSN+N8U7Z8?=
 =?us-ascii?Q?3r3Mbqc5HS3ELVNxcXMqPeSfRaODYVrCuUwAiyWCE3mbMLiOGO+tcdHCUJ2i?=
 =?us-ascii?Q?q0nAun3XN9tSk4dgqUEXHVcV4AaydMPhGUGaQ+ldKilAU2NpAPUVu0/P1ONT?=
 =?us-ascii?Q?ejX6NqnKg65yJxKWeoLd35fi2MHEGin/xnxXedhtp7IF/kLSIAQBGl5g+K0h?=
 =?us-ascii?Q?UQT9sQR6J3PCCklPiawhN8kKd9/Y899q+tjC8tVzPJjhRLOMPQa2XPG/O2xk?=
 =?us-ascii?Q?v4iv9G7ebKe2MSoABb5VdslG0ksVq24qB+v4+DH6SfGqtvB5bOfzwEzw5/6r?=
 =?us-ascii?Q?x2XK0wg6502JOX9msZh4+UQ9FwS4TOszboV2ly4caTLhQpRFjBUFDDzO8W71?=
 =?us-ascii?Q?CDAZRvN2MukRNu+Uu+BGivQRPCIoZ10Bg1Fj0T4G0wcSlkz/Xd9rZEGyinNq?=
 =?us-ascii?Q?ZYqqzchFAhwToApu3surLa5UT8f29vFEWQ16YZnOSslZxYYyrd0Y31puvAuW?=
 =?us-ascii?Q?rBOsp5iCzcAJ2SyBlr75JJ1ZuySGL/bmEphru71KGzPaen6ayr1HJH53XMD8?=
 =?us-ascii?Q?jxHh0vqCOYvkJTTECWXM1/bBEzJgS5UYqGWfDfL7BvXw0oLgFlVdxY11Tqpd?=
 =?us-ascii?Q?e6dGeigCJCyry403wT4suwxJAcYs5ALToqRmyrT51xRAPFQ/ZVJvD4SowR+Q?=
 =?us-ascii?Q?Bh86BUUxAYCuzZHl9UzLlTF8V4iJ9fnS8DraQqtgFXTU4Q03bHVDERAYIFTG?=
 =?us-ascii?Q?VW50hVOzZ/h1cBBaILXbSqA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b329b64b-558d-46bc-7dfa-08d9fea61d1d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:46:05.8633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wyPLdJB7Yb2bpHjBXZjJbmZ8SOGy0XKWYvt2GN32Z+pU+rc7PPvA/RmWqlirDrJc6QZkVYaBZVx0hyJRK1MCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050070
X-Proofpoint-GUID: 7pvAK4UrrPmdD9pfGlp2uuiT5kX7L0js
X-Proofpoint-ORIG-GUID: 7pvAK4UrrPmdD9pfGlp2uuiT5kX7L0js
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 13:45, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:38PM +0530, Chandan Babu R wrote:
>> The maximum extent length depends on maximum block count that can be stored in
>> a BMBT record. Hence this commit defines MAXEXTLEN based on
>> BMBT_BLOCKCOUNT_BITLEN.
>> 
>> While at it, the commit also renames MAXEXTLEN to XFS_MAX_BMBT_EXTLEN.
>> 
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> Looks fine, but this should be up near the top of the series where
> all the extent count definitions are being changed. Also, minor
> formatting nit below.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
>> @@ -299,7 +299,8 @@ xfs_calc_write_reservation(
>>   *    the agf for each of the ags: 2 * sector size
>>   *    the agfl for each of the ags: 2 * sector size
>>   *    the super block to reflect the freed blocks: sector size
>> - *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
>> + *    the realtime bitmap: 2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY)
>> + *    bytes
>
> Break the line at the ":"
>
>  *    the realtime bitmap:
>  *		2 exts * ((XFS_BMBT_MAX_EXTLEN / rtextsize) / NBBY) bytes
>
> Which makes it consistent with the rest of the comment:
>
>>   *    the realtime summary: 2 exts * 1 block
>>   *    worst case split in allocation btrees per extent assuming 2 extents:
>>   *		2 exts * 2 trees * (2 * max depth - 1) * block size
>

Ok. I will include this in the next version of the patchset.

Thanks a lot for reviewing the entire patchset.

-- 
chandan
