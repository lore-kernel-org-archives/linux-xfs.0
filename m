Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA23C2BA4C
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 08:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiAZIvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 03:51:06 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53638 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234764AbiAZIvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 03:51:05 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20Q4ea2o010031;
        Wed, 26 Jan 2022 08:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/ws9phjiXJ94MwaQTE4GNsZAgf/BhVpG91TcVNt/kkE=;
 b=e/S/jL0WDN6Om1YxW/++1co9c3IB3j54QWFdaUpTFIGJ70XIFxDbM1W1aYmRvQZ7b12V
 oCz+FJMSgSgxhkAnmWY7wNj+B+ebTM/WhchOU4ozm1Xh1XD8as3AY2skCcJEQ/jKdF+a
 Zwx0ayxH6SgSHgkvodx7ub7KXbBuT9FDe6ErKz/CXHed7mH3kOBiQ+hehaIJuV727L9L
 UA7MCRJdrebS5Hcw9isjN8jY6g8ZWHmVo2I7rfCx+VrZPpfoKFey83C4cMas9s+F6Fkx
 rr6VpFD3IF5Bx4cTMuo9GipQ+Wp0y/TftlAHALzemEJQ10C8TaY1/ObpGJRN7/SmY30j YQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dsxvfnebb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 08:50:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20Q8fN5J059695;
        Wed, 26 Jan 2022 08:50:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 3dr7yhavte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 08:50:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUeiNSSuKhKajaRgBhEL4f0L27cvDVwX5QLENm8cppsFDKaugE7eUXZ6z/WpQaqodldoynBdYW8K7bOKHA7S4ny7GSsIhiQo18tDmPzJAdyLCGwe/4t6G68fsoLxRKVjVqSp7jrz+ZTBC8liNKCQ/ffwnQABLov4Erwo4+eTjIXTGueQkvDwXI+Jihx/PLqDrcSdqAoOn59LYiEXP219JMylJSehLuXQI0NU6Ma8AVALhrdYNK8fz2LkcYM3jE2kEEc5WvbKnxKaWqSpoyGXZ0hG+J0GVjrVdItwxewnU6UcxRd45jL7PtynWWYJ2KWNgpMRNpYv9800atzDThLR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ws9phjiXJ94MwaQTE4GNsZAgf/BhVpG91TcVNt/kkE=;
 b=oH1uu6mwecCqk78p2Xovs9/+qBY2Q5BK5ISZoBHiB14crj8bjLRZrxRHkJrBwzpTwNBGiJOXQ+gBAcLsCBJ1bvItGC/8fL/JGqkivrA9levVtmMnWdZC7NXnQ4YBpl5+Z4EMpn+rPSUldmW4O3NJQNjhDxsMQls+3bZXPJ0+OtKZCzydqyAGg8hRjx3ki93fzsHC2OEMWqzOOSf+rwzox6F5+9fh3/bcCkyFErbWEHvqWiX3Oek3+7ElOohMgVk6QHZ0OTlrpt/Mee20KOSPW3PW4am7LTGzwqOlfR2GTE+6LtzPh56gUOTDzu1U8+OYO6Rp6sKqBaI96+T3ce/Kzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ws9phjiXJ94MwaQTE4GNsZAgf/BhVpG91TcVNt/kkE=;
 b=dWUhFiAXTpLTkhfANQqpmsO9yoGZwTb0T89p5jf3C951nSf2rjqH0BXs4UNkfF8qIJ+4RduDYsyANc2MnYZGDO6ZTVrSIg5RDp2s8592aRB8zYTKQ3w0OsAQb25Y7zE+JmBxskhb8bAqRNdZVXIGdwcZDZQjWKrAaN0wvzeyJS4=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1702.namprd10.prod.outlook.com (2603:10b6:910:b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 08:50:53 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.019; Wed, 26 Jan 2022
 08:50:53 +0000
References: <20220121051857.221105-13-chandan.babu@oracle.com>
 <202201260622.XxiP4fe5-lkp@intel.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     kernel test robot <lkp@intel.com>
Cc:     linux-xfs@vger.kernel.org, kbuild-all@lists.01.org,
        djwong@kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V5 12/16] xfs: Introduce per-inode 64-bit extent counters
In-reply-to: <202201260622.XxiP4fe5-lkp@intel.com>
Message-ID: <874k5qop7g.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 26 Jan 2022 14:20:43 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0085.apcprd03.prod.outlook.com
 (2603:1096:4:7c::13) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63bf7e1c-aa2e-4966-b394-08d9e0a8f560
X-MS-TrafficTypeDiagnostic: CY4PR10MB1702:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB170295256028A0115D8CDFD3F6209@CY4PR10MB1702.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJyf1PEqYWQ4lgTu43+3fSwKhg0UPyMkBOtQlZTRix+5co2W4SmYDz4aLRtBUvf9vYS0R+mOuZEUH9bVB2/JMoUd4d4faE2rftBR4E36VogbZTmB1VJElDF2G+gN2i8cmbBuP21T28UIN4Z1dUcDueeVwnI7JBqybbjA4cK6mud9KTkBAP1HvqLoFY4Yl73uEm0S/FkfAAPJnYrwkt0HygIriqRgcB4hfRMW1ghVR44XXkIbrJuwS1VKweTACORZkKzlxuJ79LjFVsvt/2w1sATgIj6G7rCOc3l5NRqTN8q6ex/rIcXMRLAw1Xdvvuttj8LTdqGcxnslcQxnLzGqleCVCtKpf3kNa/8h2nA8Qb6xopCFHfStQjil4FdNAlPxZmdhOLkCwaWzhuJOxk2odJUum+i44W7VnOW9YJRdXc7lRte9g+BkcSPVS8dyiGhSnGji6buQmNw33dSOd9aHIEC99lyTlMARrx9waPr9007ulbOw29TiZgZCpNLg/utMGzvqt5E30NzOrcHeNmzd0AvGexeFISgQu+T0ISQ/VjCt+55l4pVpuI1MQm4QrFAvNZLdwQkFlFt8uoIOIS44UANfqBVhbh4hgxwEJqVFfrJvdkQmcrfbs+xtG2e4TqvW9p0j5/m28HrDb2hGRatHPvdZBZIfBHyFWPPzlKecNNgdvZNFfqgHQg8qgGcMaI2vIEfJcVQUiIFvlxzjd26/c36KKmMAOTK4wspTb6ukrw12gNp+ba67V6kQ8kJKSQR4EV7rFFn4kYJObevV7nCMLJnUmT2BwTHAZnwaOz8y/2Tz5NsRO5Np0GI3taB1pO0f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66476007)(83380400001)(186003)(86362001)(26005)(66556008)(2906002)(33716001)(6666004)(38100700002)(52116002)(6506007)(53546011)(8676002)(8936002)(6916009)(38350700002)(508600001)(5660300002)(6512007)(9686003)(4326008)(316002)(66946007)(6486002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EOTnZvKS9EXtp+I1Ldzlj5GPShgoyjaQ1nudmaqm1+gDE0rFHaiEKsZv/N/Q?=
 =?us-ascii?Q?zaV7xIdt7wfSNvYEj84Gel6K3Mq3EGS8fbiKBOx/hsVU1XRRQLq9+sls+Ipz?=
 =?us-ascii?Q?QtO7UZY/V7g1qdXdbFFYf930a/gKDO0Q7c2msO5iDXff8fkSz1mLOZcmNT/R?=
 =?us-ascii?Q?KTHAdeyFrsqnIAvTGXrJAgeQnKxbVvEl1xdOFEj4BkGoMhbN9ppWCXRxhLPo?=
 =?us-ascii?Q?+Eb+kngtCatRxad5mX/ef3TQd6dwUuLbBplHcFel+psymU0HLzFIGtlPEURd?=
 =?us-ascii?Q?QB1V9pKqVP/M1ZrmrtxvUR3CPru6O23Jkk+f8NIIvQNSi6lTBjlZSlcU7/mK?=
 =?us-ascii?Q?JDV7y02HCt3TofkCr5o12NgEKRNplkATUMj6J/5vU+ciXEkfsWomgakAc02T?=
 =?us-ascii?Q?poskFK2wlgi9jVAen38TzVA2eBYDhm0VlFNSgOaRSV7ZV+uiKQgwkGJc6eZI?=
 =?us-ascii?Q?goUgJjNPZi97e9Q0DrHvpVNvqgewoUyYpGCMutedHBEf4aAbJMIL9qVdIWII?=
 =?us-ascii?Q?ivFIngwdpprum/Nnb2Pq2+j3TuNyf6FSP03JJQOmkdJ0nXPYnbS9owEUwzY7?=
 =?us-ascii?Q?Eh0ukpLhBfKOcRIvzIEmTPdyyQdrMqnII4VfrTsz2En33npNCeIk9Zc4HkxD?=
 =?us-ascii?Q?9yT+YVQUuDswOn94WgTMGe9j0/20ujNxupKoVqmppa9smIkb5EvSGy0UTSfk?=
 =?us-ascii?Q?l9FjM5p5Qf6ZHxpl8MSwHlzYuo3w3DlsarNAbezx7Ji8aiW/3UA/xQoqMyQz?=
 =?us-ascii?Q?tPFkuiNBH9DdHVK37Ia/jwJ4CUoQWb9tIkIMn64SZhE9qrHTrSLhFFpclarU?=
 =?us-ascii?Q?5LOH/l5GH+dGOw1L2aTWtpjkckFceQynUkcrlgpSwpGu+cDdKgF+t8oCN7Zo?=
 =?us-ascii?Q?a3fMhhOabIfIBMabTG4i6QNuSGq0tHwqfgcDxyqmZwuIg3nKBWNI37ZY51cF?=
 =?us-ascii?Q?hNczWu2YQkfbJhgKVmuWiAbGuytZCS77hVIHuAyGtXLuXAKq7AHCx8MP+4T/?=
 =?us-ascii?Q?cFznvJAB4U3+wwLOGVOPHtJhTs1KH5jQGx+aubEZdhR/kjn8qk53idZ6Njas?=
 =?us-ascii?Q?Oxc3cd1aNSDyh02UU0tI/jLBaPNwMRBLIZpCkZt1wVnZ8T0v4NksM1W2q5lX?=
 =?us-ascii?Q?oNOobHmGLhFRTnrWS7DD8+FVLO58/CNZsyzcbJ/xEl/+OFopU9gEAtbWZrw8?=
 =?us-ascii?Q?yUj9gy2057RVbWMz8hZb1AEnqK7MjW3OubMTEYCTyVIK5Dsgkk/ID7AREwEh?=
 =?us-ascii?Q?mIZuYgIAnoClbqOnwu3jYzptMVCbAVYvxXDKNe8uM6jp0fGcXAoex0ll3my7?=
 =?us-ascii?Q?weyf5Iq5nMdJW11vmyEUj5U0r2hXzYTB8mbPGYJAZ2PVBomLpTUQz3bTXvVt?=
 =?us-ascii?Q?oMRapZxawFezI5uFz7gZ7bhv6Q8buYe+ow83SWZs46AM2rPEn3jerM2cfpGS?=
 =?us-ascii?Q?elylu1wfSTAy8e5/6kdnB6KRjGVnetu/DMJ9nHWpHOg0DWvntDf43p6p7j02?=
 =?us-ascii?Q?M7fjNlASAiR6k9gd8qXkw9Aea1QvhvFlhpNTISh8VedfXAV0r5Ri+sg9l3CN?=
 =?us-ascii?Q?nrHtQoZuE1d1mXInMIQU1KD5WwW6wz+a07Ba/RlDCYbQ8hsx9GM4Pl89mFAq?=
 =?us-ascii?Q?c3Nl8mtPk6/htiyzzDeNjSE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bf7e1c-aa2e-4966-b394-08d9e0a8f560
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 08:50:53.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FmoGx0sMnGdb9rywGR6CDatUqwBUa4qJa/t/Ffsf2CbDV7Jb0MpdsSWCXiyx0f3zAipRG645Y1C9tYoeFTGsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1702
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10238 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201260050
X-Proofpoint-GUID: _A4-k4feVibq_OqCr8fpozbwHL-NP1iF
X-Proofpoint-ORIG-GUID: _A4-k4feVibq_OqCr8fpozbwHL-NP1iF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 26 Jan 2022 at 04:21, kernel test robot wrote:
> Hi Chandan,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on xfs-linux/for-next]
> [also build test ERROR on v5.17-rc1 next-20220125]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220121-132128
> base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> config: arm-randconfig-c003-20220122 (https://download.01.org/0day-ci/archive/20220126/202201260622.XxiP4fe5-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/f12e8b5064fc3ef50c9d26f15f4a6984db59927c
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220121-132128
>         git checkout f12e8b5064fc3ef50c9d26f15f4a6984db59927c
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash fs/xfs/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from <command-line>:
>    In function 'xfs_check_ondisk_structs',
>        inlined from 'init_xfs_fs' at fs/xfs/xfs_super.c:2223:2:
>>> include/linux/compiler_types.h:335:45: error: call to '__compiletime_assert_900' declared with attribute error: XFS: sizeof(struct xfs_dinode) is wrong, expected 176
>      335 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |                                             ^
>    include/linux/compiler_types.h:316:25: note: in definition of macro '__compiletime_assert'
>      316 |                         prefix ## suffix();                             \
>          |                         ^~~~~~
>    include/linux/compiler_types.h:335:9: note: in expansion of macro '_compiletime_assert'
>      335 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>       39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>          |                                     ^~~~~~~~~~~~~~~~~~
>    fs/xfs/xfs_ondisk.h:10:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>       10 |         BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
>          |         ^~~~~~~~~~~~~~~~
>    fs/xfs/xfs_ondisk.h:37:9: note: in expansion of macro 'XFS_CHECK_STRUCT_SIZE'
>       37 |         XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,                176);
>          |         ^~~~~~~~~~~~~~~~~~~~~
>

The following newly introduced union inside "struct xfs_dinode" and the
corresponding one in "struct xfs_log_dinode",
        union {
                struct {
                        __be32  di_big_anextents; /* NREXT64 attr extents */
                        __be16  di_nrext64_pad; /* NREXT64 unused, zero */
                } __packed;
                struct {
                        __be32  di_nextents;    /* !NREXT64 data extents */
                        __be16  di_anextents;   /* !NREXT64 attr extents */
                } __packed;
        };

needs to be packed as well. I will include this fix in the next version of the
patchset.

>
> vim +/__compiletime_assert_900 +335 include/linux/compiler_types.h
>
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  321  
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  322  #define _compiletime_assert(condition, msg, prefix, suffix) \
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  323  	__compiletime_assert(condition, msg, prefix, suffix)
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  324  
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  325  /**
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  326   * compiletime_assert - break build and emit msg if condition is false
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  327   * @condition: a compile-time constant condition to check
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  328   * @msg:       a message to emit if condition is false
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  329   *
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  330   * In tradition of POSIX assert, this macro will break the build if the
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  331   * supplied condition is *false*, emitting the supplied error message if the
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  332   * compiler has support to do so.
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  333   */
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  334  #define compiletime_assert(condition, msg) \
> eb5c2d4b45e3d2 Will Deacon 2020-07-21 @335  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> eb5c2d4b45e3d2 Will Deacon 2020-07-21  336  
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


-- 
chandan
