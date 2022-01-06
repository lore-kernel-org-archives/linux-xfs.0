Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6F7C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 07:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiAFHDv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jan 2022 02:03:51 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15922 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234429AbiAFHDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jan 2022 02:03:51 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2065LH7n009876;
        Thu, 6 Jan 2022 07:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1QvOvUdWt5sOm7PDJCEeK5vb/MjoW/ccr8ssGSe1hjQ=;
 b=eLkCjtaHU57k0ucbnYXncol9zzKgOsJpL5KWUSXe3jO+3/5nOD0nPTbdt37fjPnqKhka
 OYcj3XylP4y6blMGgoEcMQCo020pJhJaAU/ORifLuWhXmA0WLqUnnBnmS+GweWFWvbxb
 /kMxW+r9hZ/OPPRwsYORRThBDilDcbN7FJV6EbtCEfQShhba0PkzolijGa+ZXQ9tgYGc
 W1NHctPoY/QVk6xxRIYQ6Lp4wCfhAoCG2KuaRXyCwtMCQonWzo3nREN20VZHOZIBEgiY
 +uxwbSOsfcCmOk52Q5FWMYQ/BD4fTSuSz76tPhEmPvBxAku+o+nNjXqaarL/uPA3V5vd sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ddmpp8ut8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 07:03:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20671JpA166070;
        Thu, 6 Jan 2022 07:03:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3020.oracle.com with ESMTP id 3ddmq68cb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jan 2022 07:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LP8kI3m/HwVvWT7PFcpaQPyq0LFdbgefedRMC0xYLftwKdklcx0kZYjHRMzHBNMdGDRIha6xO0YB8m14LzCqsIB73XedoY/lfcoFdvYyP2QbVuirE0kQWPtHtT84jf6xcBIfma+5S4b4iAhW26hwoCwHpJlYhAEy6pfPnyztGjgeVckNavkUm6FEdsJdxl6c6TvmCziomDXUdHLzFtqcFeivvVjTcOQ4auGzW7PW/STv76fvtNjfUv2NpvYrBBLCJEZhXEZoAXydFFF2CNA16C5RI7ddZ0bZgoRXuBlKAB47uSSnBxSyij82+mQVfLmDDqTFDx3K/TNybyhsKuyEGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QvOvUdWt5sOm7PDJCEeK5vb/MjoW/ccr8ssGSe1hjQ=;
 b=ImMejnYw6LK2ghZt5LjI5x7Z2/lcOtAfjapa6MKDZMVXfocSA+iv0K8W3CEaW0MAMUwgJHk/MDRKnS0xTk8nFLpcPapu4EBQ43fFo7X1dfQAKo+qHfQZbmopmTpDrPPXid7ikoXUZSKS5KSouqLiaJUEk3c415PAk7R4zaoVoFM0KSlY3mQUh9op485CwohUdWUaeIBm0QR+vQRY9Yb2KaGPdCL5ggtp4jhMQ2VksTwOIMxS7rr9dNl7G53v/mJTIM0yATJnH1VG9dgilF1YLQ8HnG+5wH0JGT7G0EojmjX3cIfokIiB58ZGK+0srZDEFvimWOYXnBcOXv2WpPUf5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QvOvUdWt5sOm7PDJCEeK5vb/MjoW/ccr8ssGSe1hjQ=;
 b=ZYzV2dmsrJxk01i8opHevSeGccYUbFS/yMygzpsr+la7iXF+rmkQsO71EjdfLD3/1jCjE6Br3pbrDop+DNtxD9cHl5fAUSe3TwEQJ5+CnxwYl78IRnPOHvNpcd+stdHLMGJnEaZIXL4PoSiNOSmD75tZpqcui9AADhjE55rr//k=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3040.namprd10.prod.outlook.com (2603:10b6:805:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 07:03:35 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Thu, 6 Jan 2022
 07:03:35 +0000
References: <20211214084519.759272-7-chandan.babu@oracle.com>
 <202112142335.O3Nu0vQI-lkp@intel.com>
 <87a6h22pjf.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220104235457.GM31583@magnolia>
 <87h7ai8e2o.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220105172117.GH656707@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, linux-xfs@vger.kernel.org,
        kbuild-all@lists.01.org, david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
In-reply-to: <20220105172117.GH656707@magnolia>
Message-ID: <87r19lwdky.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 06 Jan 2022 12:33:25 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 976da9ea-a0e9-4bb1-cd1b-08d9d0e2a80f
X-MS-TrafficTypeDiagnostic: SN6PR10MB3040:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB3040E4706678070A1E136E1CF64C9@SN6PR10MB3040.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 46XKKGHEO8IW+cqIEgS4reAQM5akK0AVvqId8gMDSt21sQT7JHU0GdNNtEmg8t1hxw4ahSdyaGnk+W65q6vfAHPUrHgcT3kKVdsPblYAWKuyUH4FDamQEOUNCeN6QRn1IjL8oUZDhYql0ecVkUlxzklCGXLrZ7UwRzAw8M4uh+BR1ShhSl1i6BHD933QHCpYuhtD9OuogIy7xjSbqeMnYNijUihH4TdZKfIFHenDv5Pid2RqH1FyOxMMK97+LaNa8EhDEYSsCKbmikOVTlYtNIokJNWgn8rKEZku5vPZeycK8jQkLg+urJlka/UOQCjSViah9Z0rCoEoSnjMtvGcQsjR0QNYBhk7o4cnhSBJ4HugLCxm8Aowhdul6gpEuVk/v6Q59Nb7bwLyIsI8JLVS9flHEfVkE01IoBLICKsSfgDZ/+k5b8XUBP13z1XOVq88/P4MRZrx6uxRzj5o9sx5E4U/ums40jELlpHK1l/JFN7+C58czjWRU42VdbC6uSWB9Q1Nt8j/axFAcJang2iyDIFjB6NgBoSYflNUCiIsafFm6+MiIsdNSDDX1dGI/FFUsvvsGDd2asFsZpamAamOqe6rFYv4cS0wOl3hkVmIBTgS9YoD5kPA/UOHOCWB27TOtj5JFodlgD/4qDBJ3MKbJZqTyGdqkzgmP66ucUy8Op88W8DgUXTWjsR3w6efXVpM5a/ufu0PlW5OX6GzoQtmh+pbqHfbRA+wQzfeOLX+S/b0gaHFaNyogLEUpub6nq4Sn1YKD6FzNhOn+r3lAl0W/by76VO28PLoeVMY9lUeWzCabght1So09PjOFnpCmp7B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6506007)(4326008)(52116002)(9686003)(6916009)(316002)(6512007)(53546011)(8936002)(66476007)(66556008)(66946007)(6486002)(86362001)(2906002)(8676002)(38350700002)(38100700002)(83380400001)(33716001)(5660300002)(186003)(6666004)(966005)(26005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lY5U9ejbvZNNLU/msY3FSWrVzMKzhw6ZMOrfyLt/s80u2bxJ+MvFg8QzUieP?=
 =?us-ascii?Q?c+KFQX2kfJUBKRuMGORwo+gAGfd91DcZWmwtqW8kO1X8w5iGr7EQgvtVjPQF?=
 =?us-ascii?Q?BzPTNG82nldkqwsHRFPh9rtuiBYGdb8BiWqRicAFoCwYQG73wSXJjxiC0ONA?=
 =?us-ascii?Q?9yY4DFSarou8YJkzKUDN7coby2gLgaU/Dah11lsSD+/5tvk15NGNyNvUznbH?=
 =?us-ascii?Q?oD21aP1KcARSIXiFR1FdxEKYJQC4R0ntg0WQbUKtqcIgtBHSi7ce1vQoF0Eg?=
 =?us-ascii?Q?lePeE2kHzpDDyWdmQ2sUPeEm4RjsH5c1MqgtM09h6ZXbAqpgzooAc7/D9YaZ?=
 =?us-ascii?Q?iuXfwd6ZZ4X6qBoD4/f378j0tPAgpDL0ygT+Uj/Nep0uH13CGhRIh2fA0XjC?=
 =?us-ascii?Q?GypNe/s3bfkL1h+pYHy09/VEK56h6mUeHKqrXnmsI+wahLMrwtPXghIqKX4s?=
 =?us-ascii?Q?XsFsbT1By4+dreSTvzj0iwP48n2vTcqCXjNplJ+VMFm4J3hAGs9AXCtuVT0n?=
 =?us-ascii?Q?URXC2zLx+NXh1zuGms6gpTAeiCjPBGBVPQhSm43T83lBa6xvE0HCe1u5m8qE?=
 =?us-ascii?Q?63OnxVmh4Xhh9D5ImQRUxry50Ha6xmCsImxdJbVQSUtzmIbmD3Gf0fefQkMY?=
 =?us-ascii?Q?vTN4ifgGvhIGHKvsCnoj38qZUYOs5GwwJIoq8d54JQbJswv7HoDMPZJurZgO?=
 =?us-ascii?Q?d/fuSv/NHxTqSPXpi8dihkaiJNgMBiMz9A24MmVoTIKNJUu/pBuXUjNDnLbo?=
 =?us-ascii?Q?JhZlf5O8e/YxRJQzbA30k7r/hnWKJjfkQmnMdXIqFYshrK/+XXeIza0UU9yR?=
 =?us-ascii?Q?rmZ3pVzGggm0yPFVUc4zCOShrfw6mXB6Ch3OAEbuMGiCwOUGlrPSTcgb/uWT?=
 =?us-ascii?Q?hADkddxDbRGcr4EE4DPZut7TRMiVPK4NB5JqEhGTasjZd+4FUOqt360a9iV6?=
 =?us-ascii?Q?eR01a5RT2D7wQ1DP23U89qnlP/saSC6OlYvbcH1AIGZH3l6UZ3P+vZ/KAAtq?=
 =?us-ascii?Q?Ba3I4j4IOaVdoXVagct8J9N+pjBEnOB5X17vX3uv9vGIrKxQ8Ave3vrCAd7M?=
 =?us-ascii?Q?a+Oqd+Cd/bSH/jzBF92JpPw3nG95r0OoVhFPZhplwhfGPHkT7IgxMpwXKUHn?=
 =?us-ascii?Q?UmX/JCDMCIa6uw8SZPuUYb7nOwzWRzsZzYyM+T05Jlr6HIj1M/VaioxI+jr5?=
 =?us-ascii?Q?jY1DcGgBXrdf2cQs4c5314x628Rz3zaYiFrtsr7w0qtnba22i7mVg+X6q/zT?=
 =?us-ascii?Q?oh0LYHtb1cJbCME2f+2FuspxV+3KQ2v1pWnfQ78JzM8uI6rVJ/GhFUJUhYUz?=
 =?us-ascii?Q?rJDFzj8TAljCc6/4XV+IwLNtiS18AwphoV45OUqiM0oLnfDK+gt84IS+eYYu?=
 =?us-ascii?Q?5R8Gf8rpb/jRGaU2PT9rEWmjVVC5jqt00mCguLnrFt6qfr4+mTXNF1BKDf0Q?=
 =?us-ascii?Q?10s1M0w3cuBOqFmbMeMR61sf0aKo1h0tigp7MsPZZQT+6J7P3nysnEwpEDy9?=
 =?us-ascii?Q?fSrXCX44k/R8jjrDApKCAPaunJ8e2rDlVk0OowbxvoOm65cUyiKsQwKntAJO?=
 =?us-ascii?Q?WTn8StQpFDrLS3BCrt1XmbN9kU7GqW8s7RmSbno/mkoVXgovtT5lt2hSCipc?=
 =?us-ascii?Q?WpMA+iepMkEmnz3uNN7F07I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 976da9ea-a0e9-4bb1-cd1b-08d9d0e2a80f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 07:03:35.4900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBjIdnq7A+ZP74uO9i4J+eQNz4/zVW+tGC6V4vilGmEgxr4yrnDB93H1hu8h7eTEFoSq4iCkEll3zAMkrJASfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3040
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10218 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2112160000
 definitions=main-2201060047
X-Proofpoint-ORIG-GUID: 4Bm-vW5G8c8jwyDJGZsdPZ5OZLN1a9D_
X-Proofpoint-GUID: 4Bm-vW5G8c8jwyDJGZsdPZ5OZLN1a9D_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 22:51, Darrick J. Wong wrote:
> On Wed, Jan 05, 2022 at 07:44:23PM +0530, Chandan Babu R wrote:
>> On 05 Jan 2022 at 05:24, Darrick J. Wong wrote:
>> > On Wed, Dec 15, 2021 at 02:49:48PM +0530, Chandan Babu R wrote:
>> >> On 14 Dec 2021 at 20:45, kernel test robot wrote:
>> >> > Hi Chandan,
>> >> >
>> >> > Thank you for the patch! Yet something to improve:
>> >> >
>> >> > [auto build test ERROR on xfs-linux/for-next]
>> >> > [also build test ERROR on v5.16-rc5]
>> >> > [If your patch is applied to the wrong git tree, kindly drop us a note.
>> >> > And when submitting patch, we suggest to use '--base' as documented in
>> >> > https://git-scm.com/docs/git-format-patch]
>> >> >
>> >> > url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
>> >> > base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
>> >> > config: microblaze-randconfig-r016-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142335.O3Nu0vQI-lkp@intel.com/config)
>> >> > compiler: microblaze-linux-gcc (GCC) 11.2.0
>> >> > reproduce (this is a W=1 build):
>> >> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>> >> >         chmod +x ~/bin/make.cross
>> >> >         # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
>> >> >         git remote add linux-review https://github.com/0day-ci/linux
>> >> >         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
>> >> >         git checkout db28da144803c4262c0d8622d736a7d20952ef6b
>> >> >         # save the config file to linux build tree
>> >> >         mkdir build_dir
>> >> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash
>> >> >
>> >> > If you fix the issue, kindly add following tag as appropriate
>> >> > Reported-by: kernel test robot <lkp@intel.com>
>> >> >
>> >> > All errors (new ones prefixed by >>):
>> >> >
>> >> >    microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
>> >> >>> (.text+0x10cc0): undefined reference to `__udivdi3'
>> >> >
>> >> 
>> >> The fix for the compilation error on 32-bit systems involved invoking do_div()
>> >> instead of using the regular division operator. I will include the fix in the
>> >> next version of the patchset.
>> >
>> > So, uh, how did you resolve this in the end?
>> >
>> > 	maxblocks = roundup_64(maxleafents, minleafrecs);
>> >
>> > and
>> >
>> > 	maxblocks = roundup_64(maxblocks, minnodrecs);
>> >
>> > ?
>> 
>> I had made the following changes,
>> 
>> 	maxblocks = maxleafents + minleafrecs - 1;
>> 	do_div(maxblocks, minleafrecs);
>> 
>> and
>> 	maxblocks += minnoderecs - 1;
>> 	do_div(maxblocks, minnoderecs);
>> 
>> roundup_64() would cause maxleafents to have a value >= its previous value
>> right?

Sorry, I meant to say "The result of roundup_64(maxleafents, minleafrecs) will
be >= than maxleafents".

The original statement was,
maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
i.e. maxblocks would contain the number of leaf blocks required to hold
maxleafents number of records.

With maxleafents = 2^48, minleafrecs = minnoderecs = 125,
"maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs" would result in,
maxblocks = (2^48 + 125 - 1) / 125
          = ~2^41

>
> roundup_64 doesn't alter its parameters, if I'm not mistaken:
>
> static inline uint64_t roundup_64(uint64_t x, uint32_t y)
> {
> 	x += y - 1;
> 	do_div(x, y);
> 	return x * y;
> }
>
          
A call to roundup_64(maxleafents, minleafrecs) would result in,
x = 2^48 + 125 - 1
x = do_div((2^48 + 125 - 1), 125) = ~2^41
x = 2^41 * 125 = ~2^48

i.e. maxblocks will not have the number of required leaf blocks.

-- 
chandan
