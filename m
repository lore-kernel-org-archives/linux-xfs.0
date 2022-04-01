Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F49AC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 07:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343946AbiDAHsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 03:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343951AbiDAHsx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 03:48:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA0025F658
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 00:47:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23148Pi4030446;
        Fri, 1 Apr 2022 07:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uf0V5C/aX4JrHR54M8sQefGRpqrFEr+QxJba2x8IB8k=;
 b=WSbggmQPbwk9WDZrjn5Lgni4GWXNNGB6eoTq3kBicO7Zs3eNjdwseeWfyQ78zCxhrz3U
 eyhVvruaINW+Q2OFGhHNtymS+bcapOliy6Xef8DBIhIR/2sDTliON9+qw5MWqlFJuX++
 6udPgbO67Z8Ut+QN1EIiBqau7kyGupztd/SJbQDhjgnw9iEOuhqVLZaGI85HL4KMnVyi
 b6aq8JBK5hK9pNZkKI4FX0E4+9oaiUdLQEl73BqwnXvzu5kWD7H7g0CdiF6NacKEd5c4
 kCFsIVOpdbJbIeNNi9f7RKF3YzoGpDq9FnAKsyoRbUHdxwbdBA/DpcWhvk28Ze7ws/6q ZQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0pbun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 07:47:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2317We8V025968;
        Fri, 1 Apr 2022 07:46:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f1s98u3pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Apr 2022 07:46:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Md10tFF0Ya5mAaVHSZBW76zN2f+Hb1187OTUyJ/JTlFTidKhyGtxjg5D4a6XHrgMVbga222PGpyTDxs3T1T9vW26RAr0UVVix0wdQIaspcCfZWhLaq14t6fmM+5zYscAWZNZQaxMyWsq0X9bAKczwO0ZycQPN0BSARdEoilQX28TiV1U4YjHru728SG2mxtqDj5+KhFZmAo5fnOawdSdyk5KbaGI0PGi8EseouTdmMak+b0j8Dt+nc+PNoUJktG2UK5YP4t2C02Ygae4cUW6QzqtRTLT/KWksBUoD+aubuVe+ZVWTMT6LtwTM+mQvNOhHpSvVtJTwd65L639JtzS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uf0V5C/aX4JrHR54M8sQefGRpqrFEr+QxJba2x8IB8k=;
 b=a2qi8D9AgmO4fTToULNuWJvK3uATmU+nZE0CmoEGw0X5KuxKpLJjDuruwSvPAHLXFUIQt4JG1aLG3RsHUYF73F8epdSNz+cZsS4VjJSKOzA1z0V9WOEnCVifBnAEWW3eKgVph9qbcCzCt27+OYL9uU/M4FOnF9TbOW6hhPvSlP0i0s85JN3UuzWwGRdcGYL2HrUm7piTmqKyK9W6+yAM2oUBJ8f2vTHdJn9NmLTWjpEzU6mjjn5PDzfvFnTnA9t9ou2C05W+XUxk8w7Ssa9rDLejFK4eY2Hljnl+3zQt/kKIOrlpV0T6AbCll2aMibHMuI+ygOfLkCpAaFCeq/q+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf0V5C/aX4JrHR54M8sQefGRpqrFEr+QxJba2x8IB8k=;
 b=FgJ0E6e/eyOvaZYztMxPhCs9AaXoKMZU6OOXzzNrTRRCE2/MueBuTtc6ScWt/8NCxrIz7MrBE+dUn6aWyPsWLayZ7oVGK5v3GgwVmySDRIGBwkZ5hv+dmHd9w/h+98OtcwYDBqKkNIQm0f/8DOtG72S79J/JeiO7gxA/nvfcR34=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by DM6PR10MB2618.namprd10.prod.outlook.com (2603:10b6:5:ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Fri, 1 Apr
 2022 07:46:57 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::f46d:8bb8:d2c5:cdde]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::f46d:8bb8:d2c5:cdde%6]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 07:46:57 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
 <87sfr1nxj7.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220329062340.GY1544202@dread.disaster.area>
 <20220330034333.GG27690@magnolia>
 <20220401012712.GJ1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
In-reply-to: <20220401012712.GJ1544202@dread.disaster.area>
Message-ID: <87fsmx6yae.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 01 Apr 2022 13:16:49 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::14) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc85338e-618e-4d1d-8742-08da13b3cc0a
X-MS-TrafficTypeDiagnostic: DM6PR10MB2618:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB26188931199D2A3D8EE37A11F6E09@DM6PR10MB2618.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HKgufHFJyc8sAF5JGobEK3jQSiPfNTOkueXFOZZAFOdRBMVw3QaO6PJQXuSaSfijYpaOXMIzlkzpZlfS8Jz0TCOaQszCdi98C5KONc8DWr2qvKm6rwEblenALABDwOEOz8rupfxcNzfTusOyq+fnIZJb6+97khTROk0Vx68tAIQHibShYoVn2MDX0utgBiLTVc/Dmg+jNInbcu87JnsXTuKIEXSpkcDriGEIzoY5PlsF+UTCleElHyGC1Y9Sfs1XoaSqN0w6yR5rn21z/gAY3/lIZ6ETGMey/D7TlnDu8Ob6VvgV6oP8A3yJ1gWeE/sFCMV74Xkg9CIFQNWCpdfYFkVjcBXeSiXiFgUiB06k0QmDGOiLLnJY1Mup/m2LyJY+wJ7nWth47OYiznQ1bZjdnq0jYxg7gODpgM04RccOun4jzAd54sPehtF7EM4Yz8kaa4AXAb7OcKimTnh6tTVF2WoDZlZ+Q3/YXb2xizh16tA+RJbw9q0+Q3UoeXzel4OPdrKVgocpXxEZNTA3u0YL/+MIPsbOZaxiBefO+L7f6Q0GmyuRkwwpfRw/sGvU6unoFTPlU1p6j4BZ63YlLbq8zgjBCzS+mYmo136uatkSry7vFE0E5/XnIZLjEhaqtoFU9T1+b/6TcUs0S/XwcC9eSixKmguve7R79ljxTvz6phD1kAntkO2jh4Evj6NqiO4MFUoWK26ujrgFXfhxnRNLhgMy1r1PsNGvhAQElknSddc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6506007)(53546011)(38100700002)(38350700002)(2906002)(52116002)(86362001)(9686003)(5660300002)(33716001)(6916009)(6512007)(8936002)(6486002)(26005)(8676002)(6666004)(66946007)(66556008)(4326008)(508600001)(316002)(186003)(66476007)(83380400001)(522954003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Tc8akE5qiGBk7u+je97xznqbdFhBJxPGMZVedvAsa0qR3a9Gk4UTjv7IMR0?=
 =?us-ascii?Q?cmFbrcU7ar6zDfP9iV1hkzCKerJHj7LKbhqmdoI/6RehHjWY208r7ShvZA7L?=
 =?us-ascii?Q?k8vgek6rsGyAVUNRj5Mh38SAtI22UZE2IehP0MElZdqEPRCNW3E28Akncv0v?=
 =?us-ascii?Q?FS42Km3PRUiPKzPT5hv9qi3aDV1N+4EbYdBoKjie/jLxesFiU3WV7lw+PXVP?=
 =?us-ascii?Q?rWjCntLu2lQzBZJuUd1Dvsy+q9sgH4DpzOuTRu2Bz2qceTIYSmr0fGCxLXOR?=
 =?us-ascii?Q?I5xOy0P0DUMMO3GLfsbmcy9wO1GHYDnKa+fXk65c7VBzkw2trWdKYO/sA8n2?=
 =?us-ascii?Q?6/Qq9VvcdrBvoZO7z8FuX9xbpKuJK7raQGgrz80lWENqoWHWVW2dtdEXdAeH?=
 =?us-ascii?Q?cxTzfNFyszN2kSPgLsHM2r23TaiHfK2Hohk6zMw72ZdZ7eWzpKV9ppiSxL2u?=
 =?us-ascii?Q?Mhz9esq15uzhY4UWCbpDzzR1sivA5NizqOZPaBs1a/def2YhT742Kx0VyLPP?=
 =?us-ascii?Q?ZIduP1FIvib/bVvRR432gYoyfPX9QgefNKwz9u4YA/BtCxV7TLzijhyc2IAY?=
 =?us-ascii?Q?KPkMIAbqsLiWVmSA36L41fzjaso3ZglKvinzur5ItlypM9mXTLuu4+pGFInJ?=
 =?us-ascii?Q?mtwVDlwJ9DKdyYCj7yoHl8vLKS9aJ8MzrTyoExov1GcL4I05WTJx0xwFu9YH?=
 =?us-ascii?Q?EzchzBfjerjXbq4ZMIcXfiyX6xtdwc5JBy8/HMeBEr+8nI8m3S93TAM40ujY?=
 =?us-ascii?Q?orPXn2doVX4s1xsYJWplbHBFlGGAB4G5WsdcJhrJSCi3acuXQPEVnMCqAuKr?=
 =?us-ascii?Q?LrjLGZj/SoA923m5V39Sf0gNNlsCrZ7Trb0mw1Z3d6MuRJq4xlnfdl5uvb30?=
 =?us-ascii?Q?8wN7aXB9BNvA8+o6BSLMB8My7PxD3VfCNwEln/5Ysyacl+c5+h7fvS0HoSQv?=
 =?us-ascii?Q?yqhiLiSGqlmp5j+fugyJAGbfHJmemfrj9WKTCxSRUExBKVfOLGnFOoCbXu6L?=
 =?us-ascii?Q?jjKNK16x1dx4xfoJC8mJuSMDoB0i0J48YDTVMBG7qNbrITDxECj+JTL8Jdh2?=
 =?us-ascii?Q?ULusE+gBbG76yX9oFjiBcAOlhXVP09+O+ltMs5U6gQjgLTqBOLv4jBGYswVl?=
 =?us-ascii?Q?CutZ8RxS9HictLVD/w/EZavbJRRyEgQ3HvbmbBAZIFA59itjYbf1VaXxvzze?=
 =?us-ascii?Q?2ikwh1t1nPqsoYF9QbX28yqHDoa3HHi/J8l1QkNaGwq2oUGoE0S0Gh0NsDml?=
 =?us-ascii?Q?JS6W1CwZNQNWKwkfdXfm4AwgpPZ49pJszNcI/0KDLSKfeIO7c+eVWmTtkxZv?=
 =?us-ascii?Q?wNlP6PkjYgYC2iWR4qAcNEMaJU20e3ON2660CLVFHxh+sVHY8iBDtR3XD+bJ?=
 =?us-ascii?Q?VQJyHEdqowD5iG1jxmCcIT1tLaYBziLsVdeceVQktQLy4HSLxIhejVWHbZNo?=
 =?us-ascii?Q?XSlnFPDrusfVQbyplz/Qxbh0onxN5bR0RM47kFcltBAEDgfdtq6/lfQ0C9Zz?=
 =?us-ascii?Q?Lv0r29Cjjxs15Pb7ExD8JncdxI/I/IEbgpYVQPM0rnardNjW1CPxCT1+X0ns?=
 =?us-ascii?Q?U32zLn4HJ3A34mcpNYGpVy6aPb1HWe7mBuDzgYZee4C7A/db0byPBByIVHtB?=
 =?us-ascii?Q?FCVd1jFZLHuoiPDC6zYXYNPaDFhI0W7BeNhvKZ6//5ac7PhWlxjDtlIIOMid?=
 =?us-ascii?Q?4te/Vpxqm1fjY/7XAcUD3gEgnbWP3QXWp3rsMlIzkOkd4OPpFR6eKi9iGmAE?=
 =?us-ascii?Q?hMgFNb2DXAP44156hLg3OKcqKDZcHEA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc85338e-618e-4d1d-8742-08da13b3cc0a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 07:46:57.2942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2lW/6nALHBelUxKW+fRakl0R3tWLlS+De9LzuKWyrt6r46Hge1wnS6vCH6MbiqKq7M/SH623HfLeSZfbCHHtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2618
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-01_02:2022-03-30,2022-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010035
X-Proofpoint-ORIG-GUID: OzxT7gjTRll6bI0xOuJkkMJR8T7h5uhU
X-Proofpoint-GUID: OzxT7gjTRll6bI0xOuJkkMJR8T7h5uhU
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 01 Apr 2022 at 06:57, Dave Chinner wrote:
> On Tue, Mar 29, 2022 at 08:43:33PM -0700, Darrick J. Wong wrote:
>> But then the second question is: what's the maximum height of a dabtree
>> that indexes an xattr structure?  I don't think there's any maximum
>> limit within XFS on the number of attrs you can set on a file, is there?
>
> Nope. But the attr btree is a different beast to the dirv2
> structure - it's a hashed index btree with the xattr records in the
> leaf, it's not an index of a fixed max size external data structure.
>
>> At least until you hit the iext_max_count check.  I think the VFS
>> institutes its own limit of 64k for the llistxattr buffer, but that's
>> about all I can think of.
>
>
>> I suppose right now the xattr structure can't grow larger than 2^(16+21)
>> blocks in size, which is 2^49 bytes, but that's a mix of attr leaves and
>> dabtree blocks, unlike directories, right?
>
> Yes. ALso remote xattr blocks, which aren't stored in the dabtree
> at all, but are indexed by the attr fork BMBT address space.
>
> So I think for XFS_DA_NODE_MAXDEPTH = 5, the xattr tree with a 4kB
> block size (minimum allowed, IIRC), we can index approximately
> (500^4) individual xattrs in the btree index (assuming 4 levels of
> index and 1 level of leaf nodes containing xattrs).
>
> My math calculates that to be about 62.5 billion xattrs before we
> run out of index space in a 5 level tree with a 4kB block size.
> Hence I suspect we'll run out of attr fork extents even on a 32 bit
> extent count before we run out of xattr index space.
>
> Also, 62.5 billion xattrs is more links than we can have to a single
> inode (4billion), so we're not going to exhaust the xattr index
> space just with parent pointers...
>

Attr dabtree blocks can be of 1k block size. My analysis of dabtree w.r.t
parent pointers had led me to this,

An inode could have 2^32 hard links with each link having 255 byte sized name.

- Size of one xattr
  Name length + Value length = 16 + 255 = 271 bytes
  16 comes from the size of the following structure,
      struct xfs_parent_name_rec {
      	__be64  p_ino;
      	__be32  p_gen;
      	__be32  p_diroffset;
      };

- sizeof(xfs_attr_leaf_hdr_t) = 32
- sizeof(xfs_attr_leaf_entry_t) = 8
- Number of entries in a 1k leaf block
  (1024 - sizeof(xfs_attr_leaf_hdr_t)) / (8 + 271)
  = (1024 - 32) / 279 = 992 / 279
  = floor(3.55)
  = 3

- Nr leaves = (2^32 / 3) * 3 (magicpct) = ~4.3 billion
- Nr entries per node
  = (1024 - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct xfs_da_node_entry)
  = (1024 - 64) / 8
  = 120 entries

- Nr entries at level (n - 1) = 4.3 billion / 120 = 36 million
- Nr entries at level (n - 2) = 36 million / 120 = 300k
- Nr entries at level (n - 3) = 300k / 120 = 2.5k
- Nr entries at level (n - 4) = 2.5k / 120 = 20
- Nr entries at level (n - 5) = 20 / 120 = 1

Hence with 1024 block size, we could require 1 leaf level and 5 non-leaf
levels. This breaches the maximum height (i.e. XFS_DA_NODE_MAXDEPTH) allowed
for a dabtree.

>> > immediately how many blocks can be in the XFS_DIR2_LEAF_SPACE
>> > segement....
>> > 
>> > We also know the maximum number of individual directory blocks in
>> > the 32GB segment (fixed at 32GB / dir block size), so the free space
>> > array is also a fixed size at (32GB / dir block size / free space
>> > entries per block).
>> > 
>> > It's easy to just use (96GB / block size) and that will catch most
>> > corruptions with no risk of a false positive detection, but we could
>> > quite easily refine this to something like:
>> > 
>> > data	(32GB +				
>> > leaf	 btree blocks(XFS_DA_NODE_MAXDEPTH) +
>> > freesp	 (32GB / free space records per block))
>> > frags					/ filesystem block size
>> 
>> I think we ought to do a more careful study of XFS_DA_NODE_MAXDEPTH,
>
> *nod*
>
> ISTR that Chandan had already done some of this when he
> characterised the attr fork btree behaviour w.r.t. suitabililty for
> large numbers of parent pointers before starting this extent count
> work.
>

Sorry, I had forgotten about that. I searched through my notes and found that
we had reached the same conclusion w.r.t 4k block size. But with 1k block size,
we could breach the limit set by XFS_DA_NODE_MAXDEPTH.

-- 
chandan
