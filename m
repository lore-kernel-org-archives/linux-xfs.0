Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEF6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 10:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B32A86113E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 10:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240917AbhJGKyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 06:54:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3660 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240896AbhJGKyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Oct 2021 06:54:36 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1979pQVO018891;
        Thu, 7 Oct 2021 10:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VFHRzmdo+BmQnHhBeibTYb3yMKCBlBsrNNh3TmZGZYo=;
 b=dGguNXtbi9H4BKH+SYeOf7z3rspe1xqIXgJWUL0MoK4rWXPaFeyJKgAtNxWe7WYVmVG3
 FDwGOM6u0Ta13RLbu5p2MY+NBSNaPGLpOJh+lnuylasSjpBr8ym11HKYgtBy/81vD+dL
 FI3C7AlP4BEhAf+FrUU5cBWVDvqYJ7M+u62kBQYL2rl3I8NLM3W9F/iF9V7R+5Jy1/E8
 qd37T56zCWu/sS0MvLQRLJ3+glDZ9GoL8isLMPhYSLlZpAckVyuTA5FGf2vmwFlj8pMD
 pe+ezH6O6Nr39cexmqQM5tQ6rZxx5A9bPDqpvZaWc44K3cBEGTRkrxW5vkzwNEdKhcal HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bhwfdgppt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 10:52:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 197AoQ08191225;
        Thu, 7 Oct 2021 10:52:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3020.oracle.com with ESMTP id 3bev90ryxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 10:52:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lw5ssRr8NewSfca1mUl97xq5t8FfnHOkarxXA72gKKHbCQ/EMhQmC/DajO0lbQmnjNEBngHf++NVZ65s4N+pr2n5r+WlxsSxjQpUonCjOy2MljbNC2+aCdV19QhYIgu6Hc396omL2be/3MiJk1Pawhkt4Kk8Rbdb8GQPW19himNHyFGG08/gx4173ZRtC5v32PCUabF8pYnqEcWUnt658cSQnb76O3OHD0Fgwwk/igs8ObRU8rUM1LxINlKFR8qXANJ4RILWRc2fQOxcnXz78+OpjccxF3Knw7QVkmn7urcgVQlUjpEoRylb9TJ1NCv8x62KcAn7SPYoQd6woZitFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFHRzmdo+BmQnHhBeibTYb3yMKCBlBsrNNh3TmZGZYo=;
 b=L3wTc2nFMuMW3+/VjLLwj6/2XQhbi/UAf8XOJyVVIw2vnXRtSxiZgzte80jk2rdnZUHnEj2oO9CO/aERjktKB22hGuZe7PdIEUgE9qjk2zpc2G9i5j9yMB/wlHOFjfk8UWut5bPod7nlFnNddVxIz6Z4OH9UeCD/cJpb7bHYxT9nUUxFLzmuH6HfahRvmvEJ8kjad6VscMU4WedZGfurEyLtH1kXkUpCPo+vi0GuluV741iHEM3AWHyBZ9yfHK8a6akHFuMWNEUU3I86ZByg3JLR2+UXuj6Ipbt0YfRvH80MMSxxR+icxMzPZR74H5d/zD1XAss5+waRzXEHthUaWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFHRzmdo+BmQnHhBeibTYb3yMKCBlBsrNNh3TmZGZYo=;
 b=XhkC4PSHUdyZyJ9sIMQhHV9JCnoCQzVyIGw26GLD38Ww46kwJ8xRBwFan+GbgT1rph9aDCYtLT5058jIs0MhodGnDyDbrK70lLQUqycFDwna5pbSNAWS2QHTaTd1uwa/sdUIsqVDlNVt3cGfFrhMPu5H6SyRzNFbN/jfhdHF6JQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4460.namprd10.prod.outlook.com (2603:10b6:806:118::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 7 Oct
 2021 10:52:37 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%7]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 10:52:37 +0000
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-8-chandan.babu@oracle.com>
 <20210927234637.GM1756565@dread.disaster.area>
 <20210928040431.GP1756565@dread.disaster.area>
 <87czors49w.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930004015.GM2361455@dread.disaster.area>
 <20210930043117.GO2361455@dread.disaster.area>
 <87zgrubjwn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20210930225523.GA54211@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 07/12] xfs: Rename inode's extent counter fields
 based on their width
In-reply-to: <20210930225523.GA54211@dread.disaster.area>
Message-ID: <87pmshrtsm.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Oct 2021 16:22:25 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0185.apcprd06.prod.outlook.com (2603:1096:4:1::17)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.4) by SG2PR06CA0185.apcprd06.prod.outlook.com (2603:1096:4:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Thu, 7 Oct 2021 10:52:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e50add37-24ac-4907-cb24-08d989809344
X-MS-TrafficTypeDiagnostic: SA2PR10MB4460:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4460C98E4E905B1E970C9562F6B19@SA2PR10MB4460.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fubXc4tE2Akins42Bv5amg9GDoqJPoLiUQjZ7wxeCyCS1VyrboNE4SJP09uvakEpAGAz/gWBGbXUxzrWcJ9/seg0oX0nkr6weVH4EEOD9rTi9HDSvpoGTGFX3PogteQHvqbZ6gJNEv+tkR3/SnYK/5oeEd+6KHMi7CbU/3CwY22guWhBA35d9kNC3ERT4Wf5x03RjaOx2UIh3DI35lqmaNDJ0arUFg/xzg75SB60/yC28ODm4EzDotdkUDB9FPzotEMtPwZMvnvcuDX0N3NvEzWOlkzW4AO5+byC6KZ8hVvvGfyw3iJVqvt6ZJyyN/iga/Snk2RsrNk++5y+hY6yI9S3iEPx/NWATNP7rnbT12AZATrsh4SclUL03zBp2cI8IJzGMGYY4VuLpoZc9/0FvDlPg6MiRS5Qa3RPJU9NdQmDNqsk+b5O0GiIG9h0Fzc+KlOPMC2mjpF6M9bgFZCxImrDGC+k6WeVxy3VUSqCoIz6rYN9wYaCuHNudZRWmkl8Mz8RjFvZ0ungPu01AwD5IlK/S7bfjrjUpl6sFwY4njiTm/1hq3xgYhcy4DRTCef0PyzzNUMALvfZaVhcBBmGNKVhsuG4ZFRn647smsrU87yHSFUkRwnbvozT3hF3u3o6ceYb0HGbDfpPcr/mTpJTWSqHSZBz5q7aP4zOQBVcDC23YzFsx3tZRtFI5yDGa3z+3fjcnNdkuGvt03K8z3y5Aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(26005)(4326008)(52116002)(9686003)(8936002)(6486002)(5660300002)(38350700002)(38100700002)(956004)(6916009)(6666004)(53546011)(83380400001)(33716001)(66556008)(66476007)(2906002)(316002)(30864003)(6496006)(86362001)(186003)(508600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OWHzyN+ElvtNzcSmL79oVC/GQF5tTqQ6uY7gf/6WxGvF5c/M2CNbAcR+ZnWv?=
 =?us-ascii?Q?xxL+eBl5kBI8AwCfTkcImgQel2Lw0kqohlnpUYs1326jRR5kO3dl3vg9HyAD?=
 =?us-ascii?Q?zYcoNt3LokMQDu5ZEl08jIy5duzHwXdMdZTO9Y4hMfD50V+iTCyKkjdWad9u?=
 =?us-ascii?Q?HLlIVOTbJBvJRL7U0qQfIBQciotw4CR+BO745/LBkL8uHefUahlqKuBB63H4?=
 =?us-ascii?Q?sL4gBFg2yoS2R4QFuUelLcWwU7J7oF9SSBDYvVMvm9mjkb/nlZtgJV0HPPQL?=
 =?us-ascii?Q?ECRLOEg15zjnz0L/C9GMiu2YBmnnbfNXGtv86Yd2igGy/hrXdW5Donc9tyeU?=
 =?us-ascii?Q?GmpEtqYFELVI5kfftAXbvVgB1DLQ/cajbBo1RxlZFsx0ufQKQm/tqUR57m+i?=
 =?us-ascii?Q?3VAmyobN4TACYhQd6kAOERv9zVBxWOYBYpTY+3CPxQ3kBlb0z2JMkurvuKfC?=
 =?us-ascii?Q?VHC65MECTVOyh5a/1xCvGZXve9ptjNnX4bvHLrNWRQnos3GQEt0TkuQJnwFF?=
 =?us-ascii?Q?f+3C/e9KxS6HI4IizsO+WSrEnC1jvOKkD9PHCppJ/NDmyLk/2j1nqse07pTW?=
 =?us-ascii?Q?qg+L6ARZtk2vSIOAC+VeorQcALIS+gM0J8T4s2qI9flPcCfRTnaHuPfOQ/KU?=
 =?us-ascii?Q?92JWSq+2MCOVMrg6qqE6at4FIKGM3qoIuZgbmwTuJxqKG1MDChCA5m/PKt2s?=
 =?us-ascii?Q?+/xKGFyYtYTQYjM4NCmYUA35G4U32V2LvXr85aM0/AJ7qxf9JGBUz2LCMDk6?=
 =?us-ascii?Q?do+vzc3OrK9F4qFfC15NoF3lKw7nE/rvENAFGez7BEAmnzjV4Pc0mzYUYq/N?=
 =?us-ascii?Q?nDdPAnYY1hUbwRAGJN4VL77F5TTYXiiFEpb4uq7yKvGBa7TxEm+MUeedPCbK?=
 =?us-ascii?Q?a6H8GvvbQvjbwxaO6kVJCS5AlFlkWa6LKf6Byi6QPq2s3OwRqA5OxuB5UFJV?=
 =?us-ascii?Q?3fEr0NOHvZ6uqMo6kiNPcna3wYbdzCLWR6FYdhQ5KokekYErzhqBuaQ3fkvM?=
 =?us-ascii?Q?C+4uYoASNw1nUcaz6U9Xwsr8QjnNqp3DqS2oXM7nnRzg5pBvavYViP02hFdb?=
 =?us-ascii?Q?AbAtldBiRHU+8zHn2ofs/7Jmaf5kDtKCqh5rpTISGbGq/KM7vdX9GXoEzeuX?=
 =?us-ascii?Q?+a+FYj2ufRlo0DvtVtNA7qdWzkYWtNb6FySE4VgrUvJgiVRol/fAxy5v2D0q?=
 =?us-ascii?Q?uGs950uEkQimAkAjrW43uQWa4kOw7RlWLLe1sXwKTR11V4kZo183dlw7qAt9?=
 =?us-ascii?Q?zCJHWj1Z6sVtzow7Ob1Zfoz7PoYBLGhPao2SXh0cIObmi0dHp8XwBa1IENRD?=
 =?us-ascii?Q?qV4BtMUCXXy5gFnW0CYzS0zX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50add37-24ac-4907-cb24-08d989809344
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 10:52:37.3565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMMi3BHtLLGbYXtYKb5hMl4UX/2l+MqOaVjtM+yECv3dkr1czrUH1oUXcE7vBQ4O6nNyKwlyBMbflCCXlK+dLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4460
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10129 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110070074
X-Proofpoint-ORIG-GUID: vYY6GM6U9IsFGl55WwSzoslsXoagiiJ2
X-Proofpoint-GUID: vYY6GM6U9IsFGl55WwSzoslsXoagiiJ2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 01 Oct 2021 at 04:25, Dave Chinner wrote:
> On Thu, Sep 30, 2021 at 01:00:00PM +0530, Chandan Babu R wrote:
>> On 30 Sep 2021 at 10:01, Dave Chinner wrote:
>> > On Thu, Sep 30, 2021 at 10:40:15AM +1000, Dave Chinner wrote:
>> >> On Wed, Sep 29, 2021 at 10:33:23PM +0530, Chandan Babu R wrote:
>> >> > On 28 Sep 2021 at 09:34, Dave Chinner wrote:
>> >> > > On Tue, Sep 28, 2021 at 09:46:37AM +1000, Dave Chinner wrote:
>> >> > >> On Thu, Sep 16, 2021 at 03:36:42PM +0530, Chandan Babu R wrote:
>> >> > >> > This commit renames extent counter fields in "struct xfs_dinode" and "struct
>> >> > >> > xfs_log_dinode" based on the width of the fields. As of this commit, the
>> >> > >> > 32-bit field will be used to count data fork extents and the 16-bit field will
>> >> > >> > be used to count attr fork extents.
>> >> > >> > 
>> >> > >> > This change is done to enable a future commit to introduce a new 64-bit extent
>> >> > >> > counter field.
>> >> > >> > 
>> >> > >> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> > >> > ---
>> >> > >> >  fs/xfs/libxfs/xfs_format.h      |  8 ++++----
>> >> > >> >  fs/xfs/libxfs/xfs_inode_buf.c   |  4 ++--
>> >> > >> >  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
>> >> > >> >  fs/xfs/scrub/inode_repair.c     |  4 ++--
>> >> > >> >  fs/xfs/scrub/trace.h            | 14 +++++++-------
>> >> > >> >  fs/xfs/xfs_inode_item.c         |  4 ++--
>> >> > >> >  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
>> >> > >> >  7 files changed, 23 insertions(+), 23 deletions(-)
>> >> > >> > 
>> >> > >> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> >> > >> > index dba868f2c3e3..87c927d912f6 100644
>> >> > >> > --- a/fs/xfs/libxfs/xfs_format.h
>> >> > >> > +++ b/fs/xfs/libxfs/xfs_format.h
>> >> > >> > @@ -802,8 +802,8 @@ typedef struct xfs_dinode {
>> >> > >> >  	__be64		di_size;	/* number of bytes in file */
>> >> > >> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
>> >> > >> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
>> >> > >> > -	__be32		di_nextents;	/* number of extents in data fork */
>> >> > >> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
>> >> > >> > +	__be32		di_nextents32;	/* number of extents in data fork */
>> >> > >> > +	__be16		di_nextents16;	/* number of extents in attribute fork*/
>> >> > >> 
>> >> > >> 
>> >> > >> Hmmm. Having the same field in the inode hold the extent count
>> >> > >> for different inode forks based on a bit in the superblock means the
>> >> > >> on-disk inode format is not self describing. i.e. we can't decode
>> >> > >> the on-disk contents of an inode correctly without knowing whether a
>> >> > >> specific feature bit is set in the superblock or not.
>> >> > >
>> >> > > Hmmmm - I just realised that there is an inode flag that indicates
>> >> > > the format is different. It's jsut that most of the code doing
>> >> > > conditional behaviour is using the superblock flag, not the inode
>> >> > > flag as the conditional.
>> >> > >
>> >> > > So it is self describing, but I still don't like the way the same
>> >> > > field is used for the different forks. It just feels like we are
>> >> > > placing a landmine that we are going to forget about and step
>> >> > > on in the future....
>> >> > >
>> >> > 
>> >> > Sorry, I missed this response from you.
>> >> > 
>> >> > I agree with your suggestion. I will use the inode version number to help in
>> >> > deciding which extent counter fields are valid for a specific inode.
>> >> 
>> >> No, don't do something I suggested with a flawed understanding of
>> >> the code.
>> >> 
>> >> Just because *I* suggest something, it means you have to make that
>> >> change. That is reacting to *who* said something, not *what was
>> >> said*.
>> >> 
>> >> So, I may have reservations about the way the storage definitions
>> >> are being redefined, but if I had a valid, technical argument I
>> >> could give right now I would have said so directly. I can't put my
>> >> finger on why this worries me in this case but didn't for something
>> >> like, say, the BIGTIME feature which redefined the contents of
>> >> various fields in the inode.
>> >> 
>> >> IOWs, I haven't really had time to think and go back over the rest
>> >> of the patchset since I realised my mistake and determine if that
>> >> changes what I think about this, so don't go turning the patchset
>> >> upside just because *I suggested something*.
>> >
>> > So, looking over the patchset more, I think I understand my feeling
>> > a bit better. Inconsistency is a big part of it.
>> >
>> > The in-memory extent counts are held in the struct xfs_inode_fork
>> > and not the inode. The type is a xfs_extcnt_t - it's not a size
>> > dependent type. Indeed, there are actually no users of the
>> > xfs_aextcnt_t variable in XFS at all any more. It should be removed.
>> >
>> > What this means is that in-memory inode extent counting just doesn't
>> > discriminate between inode fork types. They are all 64 bit counters,
>> > and all the limits applied to them should be 64 bit types. Even the
>> > checks for overflow are abstracted away by
>> > xfs_iext_count_may_overflow(), so none of the extent manipulation
>> > code has any idea there are different types and limits in the
>> > on-disk format.
>> >
>> > That's good.
>> >
>> > The only place the actual type matters is when looking at the raw
>> > disk inode and, unfortunately, that's where it gets messy. Anything
>> > accessing the on-disk inode directly has to look at inode version
>> > number, and an inode feature flag to interpret the inode format
>> > correctly.  That format is then reflected in an in-memory inode
>> > feature flag, and then there's the superblock feature flag on top of
>> > that to indicate that there are NREXT64 format inodes in the
>> > filesystem.
>> >
>> > Then there's implied dynamic upgrades of the on-disk inode format.
>> > We see that being implied in xfs_inode_to_disk_iext_counters() and
>> > xfs_trans_log_inode() but the filesystem format can't be changed
>> > dynamically. i.e. we can't create new NREXT64 inodes if the
>> > superblock flag is not set, so there is no code in this patchset
>> > that I can see that provides a trigger for a dynamic upgrade to
>> > start. IOWs, the filesystem has to be taken offline to change the
>> > superblock feature bit, and the setup of the default NREXT64 inode
>> > flag at mount time re-inforces this.
>> >
>> > With this in mind, I started to see inconsistent use of inode
>> > feature flag vs superblock feature flag to determine on-disk inode
>> > extent count limits. e.g. look at xfs_iext_count_may_overflow() and
>> > xfs_iext_max_nextents(). Both of these are determining the maximum
>> > number of extents that are valid for an inode, and they look at the
>> > -superblock feature bit- to determine the limits.
>> >
>> > This only works if all inodes in the filesystem have the same
>> > format, which is not true if we are doing dynamic upgrades of the
>> > inode features. The most obvious case here is that scrub needs to
>> > determine the layout and limits based on the current feature bits in
>> > the inode, not the superblock feature bit.
>> >
>> > Then we have to look at how the upgrade is performed - by changing
>> > the in-memory inode flag during xfs_trans_log_inode() when the inode
>> > is dirtied. When we are modifying the inode for extent allocation,
>> > we check the extent count limits on the inode *before* we dirty the
>> > inode. Hence the only way an "upgrade at overflow thresholds" can
>> > actually work is if we don't use the inode flag for determining
>> > limits but instead use the sueprblock feature bit limits. But as
>> > I've already pointed out, that leads to other problems.
>> >
>> > When we are converting an inode format, we currently do it when the
>> > inode is first brought into memory and read from disk (i.e.
>> > xfs_inode_from_disk()). We do the full conversion at this point in
>> > time, such that if the inode is dirtied in memory all the correct
>> > behaviour for the new format occurs and the writeback is done in the
>> > new format.
>> >
>> > This would allow xfs_iext_count_may_overflow/xfs_iext_max_nextents
>> > to actually return the correct limits for the inode as it is being
>> > modified and not have to rely on superblock feature bits. If the
>> > inode is not being modified, then the in-memory format changes are
>> > discarded when the inode is reclaimed from memory and nothing
>> > changes on disk.
>> >
>> > This means that once we've read the inode in from disk and set up
>> > ip->i_diflags2 according to the superblock feature bit, we can use
>> > the in-memory inode flag -everywhere- we need to find and/or check
>> > limits during modifications. Yes, I know that the BIGTIME upgrade
>> > path does this, but that doesn't have limits that prevent
>> > modifications from taking place before we can log the inode and set
>> > the BIGTIME flag....
>> >
>> 
>> Ok. The above solution looks logically correct. I haven't been able to come up
>> with a scenario where the solution wouldn't work. I will implement it and see
>> if anything breaks.
>
> I think I can poke one hole in it - I missed the fact that if we
> upgrade and inode read time, and then we modify the inode without
> modifying the inode core (can we even do that - metadata mods should
> at least change timestamps right?) then we don't log the format
> change or the NREXT64 inode flag change and they only appear in the
> on-disk inode at writeback.
>
> Log recovery needs to be checked for correct behaviour here. I think
> that if the inode is in NREXT64 format when read in and the log
> inode core is not, then the on disk LSN must be more recent than
> what is being recovered from the log and should be skipped. If
> NREXT64 is present in the log inode, then we logged the core
> properly and we just don't care what format is on disk because we
> replay it into NREXT64 format and write that back.

xfs_inode_item_format() logs the inode core regardless of whether
XFS_ILOG_CORE flag is set in xfs_inode_log_item->ili_fields. Hence, setting
the NREXT64 bit in xfs_dinode->di_flags2 just after reading an inode from disk
should not result in a scenario where the corresponding
xfs_log_dinode->di_flags2 will not have NREXT64 bit set.

If log recovery comes across a log inode with NREXT64 bit set in its di_flags2
field, then we can safely conclude that the ondisk inode has to be updated to
reflect this change i.e. there is no need to compare LSNs of the checkpoint
transaction being replayed and that of the disk inode.

>
> SO I *think* we're ok here, but it needs closer inspection to
> determine behaviour is actually safe. If it is safe, then maybe in
> future we can do the same thing for BIGTIME and get that upgrade out
> of xfs_trans_log_inode() as well....
>
>> > ---
>> >
>> > FWIW, I also think doing something like this would help make the
>> > code be easier to read and confirm that it is obviously correct when
>> > reading it:
>> >
>> > 	__be32          di_gid;         /* owner's group id */
>> > 	__be32          di_nlink;       /* number of links to file */
>> > 	__be16          di_projid_lo;   /* lower part of owner's project id */
>> > 	__be16          di_projid_hi;   /* higher part owner's project id */
>> > 	union {
>> > 		__be64	di_big_dextcnt;	/* NREXT64 data extents */
>> > 		__u8	di_v3_pad[8];	/* !NREXT64 V3 inode zeroed space */
>> > 		struct {
>> > 			__u8	di_v2_pad[6];	/* V2 inode zeroed space */
>> > 			__be16	di_flushiter;	/* V2 inode incremented on flush */
>> > 		};
>> > 	};
>> > 	xfs_timestamp_t di_atime;       /* time last accessed */
>> > 	xfs_timestamp_t di_mtime;       /* time last modified */
>> > 	xfs_timestamp_t di_ctime;       /* time created/inode modified */
>> > 	__be64          di_size;        /* number of bytes in file */
>> > 	__be64          di_nblocks;     /* # of direct & btree blocks used */
>> > 	__be32          di_extsize;     /* basic/minimum extent size for file */
>> > 	union {
>> > 		struct {
>> > 			__be32	di_big_aextcnt; /* NREXT64 attr extents */
>> > 			__be16	di_nrext64_pad;	/* NREXT64 unused, zero */
>> > 		};
>> > 		struct {
>> > 			__be32	di_nextents;    /* !NREXT64 data extents */
>> > 			__be16	di_anextents;   /* !NREXT64 attr extents */
>> > 		}
>> > 	}

The two structures above result in padding and hence result in a hole being
introduced. The entire union above can be replaced with the following,

        union {
                __be32  di_big_aextcnt; /* NREXT64 attr extents */
                __be32  di_nextents;    /* !NREXT64 data extents */
        };
        union {
                __be16  di_nrext64_pad; /* NREXT64 unused, zero */
                __be16  di_anextents;   /* !NREXT64 attr extents */
        };

>> > 	__u8            di_forkoff;     /* attr fork offs, <<3 for 64b align */
>> > 	__s8            di_aformat;     /* format of attr fork's data */
>> > ...
>> >
>> > Then we get something like:
>> >
>> > static inline void
>> > xfs_inode_to_disk_iext_counters(
>> >        struct xfs_inode        *ip,
>> >        struct xfs_dinode       *to)
>> > {
>> >        if (xfs_inode_has_nrext64(ip)) {
>> >                to->di_big_dextent_cnt = cpu_to_be64(xfs_ifork_nextents(&ip->i_df));
>> >                to->di_big_anextents = cpu_to_be32(xfs_ifork_nextents(ip->i_afp));
>> >                to->di_nrext64_pad = 0;
>> >        } else {
>> >                to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>> >                to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>> >        }
>> > }
>> >
>> > This is now obvious that we are writing to the correct fields
>> > in the inode for the feature bits that are set, and we don't need
>> > to zero the di_big_dextcnt field because that's been taken care of
>> > by the existing di_v2_pad/flushiter zeroing. That bit could probably
>> > be improved by unwinding and open coding this in xfs_inode_to_disk(),
>> > but I think what I'm proposing should be obvious now...
>> >
>> 
>> Yes, the explaination provided by you is very clear. I will implement these
>> suggestions.
>
> Don't forget to try to poke holes in it and look for complexity that
> can be removed before you try to implement or optimise anything.
>
> FWIW, the code design concept I'm basing this on is that complexity
> should be contained within the structures that store the data,
> rather than be directly exposed to the code that manipulates the
> data.
>

To summarize the design,

- We need both the per-inode flag (for satisfying the requirement of
  self-describing metadata) and superblock flag (since an older kernel should
  not be allowed to mount an fs containing inodes with large extent counters).

- When an allocated inode is read from disk, the incore inode's NREXT64 bit in
  di_flags2 field should be set if the superblock has NREXT64 feature enabled.

- Any modification to an inode is guaranteed to cause logging of its di_flags2
  field. Hence xfs_iext_max_nextents() can depend on an inode's di_flags2
  field's NREXT64 bit to determine the maximum extent count.

- Newly allocated inodes will have NREXT64 bit set in di_flags2 field by
  default due to xfs_ino_geometry->new_diflags2 having XFS_DIFLAG2_NREXT64 bit
  set.

Apart from the regular fs operations, the on-disk format changes introduced
above seems to work well with Log replay, Scrub and xfs_repair.

-- 
chandan
