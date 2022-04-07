Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70B5C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 08:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241133AbiDGIVO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 04:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbiDGIVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 04:21:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D4D21E516
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:19:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2377Z0P3024447;
        Thu, 7 Apr 2022 08:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7YOK9BwKdit5VI3fUcVLBhQ+5aqYleDloGr6fMaoJSs=;
 b=iIvDWJhGLlZsH5CXN5Dx0MgWTVSFf33QovzyylR9Stzix3XHk7pOMVMoV21L58f+YzWG
 0hdB8Twnj8NtL/q+qYYPIpFrKuAVCZCHznFpGZQsE2j692BhPqSn8axFsDUb+jww7SPY
 jOGUe8jr1cf05VLK3s/o7tmCJRx84k2yteYPwSAJoPwKh/sx864Ufcghfqhu9ZTpE3lF
 7G2OzyUGzSI6bv06aGD8GE5Ka7tQQAIkeTz2ycq/iwOns1yP7ZQf/ubzOC12eibhjE6P
 1gNfJYPrfAm3B9dsnvfbewn+6yOxLmq1wd0CAZSpI4loQWvXTC7bxTP+pHfKfx1yA3wb 0Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tbaxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:19:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2378BcmO008036;
        Thu, 7 Apr 2022 08:19:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tt15es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 08:19:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMiTHYOAE0o4Zg8UnoAqR0fF3jCsIPBLNJIb93c5ys45srbIleTiBVRY+DTfFgdqvi56ul5r8uM2p8Mb44SP1VyOnEnhLpim3Lfgpr38x5os6hYIcOHGMO/Ro22YAqwspn/SnWVZg2rSCkDrgIFTsRS+/D1MPO+mzGBEFsQRjjW8qocNo23dT64WLmtxhMoXxgovDz0NqpiNiV7dKRuNhlB35dT1f3Y3qSFEXes5xi3IYZKSZNzmXPRpAKHTdio6DWGVFdsruUaSBwNbqetmBHlgXs+xbsdo+7zr0escpav06hEXzRMgWaey1ytO2H1BFUMfp5f2XElOjrX/zZcGGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7YOK9BwKdit5VI3fUcVLBhQ+5aqYleDloGr6fMaoJSs=;
 b=AY7CN0JQ5v663Mo9s8FrNRsiXyUCLHb3wJTazvgRNBu7RXpUCP4beYXpSu5p/ok2Uzr2KNzen/sdESfG0V72/2U17pHhZiAFgUQiyggPGqPq6tq4dPrq2TEjS0Nz6XyYoEvYDfK+IQvqElRmgPs9AqmahO5oN/zmTdhyZw191OuQGUWIRMCW2qVQyJkR/kgMQjvMqeYifMux26oJj9tZvXHJ+UZkYizR7PgCLbsl8VaYSIyA8VlmD9KQqFfOoPjxQ/6+xYGMg1bT+2pYKlK2ba0Nk9IV+B59GIuj1t1TyInnpnI5KGRg6rUOWNO/eNzmfi9mhLC34UrpcSqMXThrWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YOK9BwKdit5VI3fUcVLBhQ+5aqYleDloGr6fMaoJSs=;
 b=QKi0avHmJbcNR+0KEshS64rtchVnyTjMXbuCPyF//+gVHoiuRgSwSwTp1biigJCwoJfFzT102OSDzBMYV6vhlSIQ93H2kvah6I1Wcyz99vnlZhcTjRPtXi5WyNzBW9/dY3vQjrkZkoFWzqRtYPYrx2LjIZOu9gfOC+cmbycR5Dw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:19:02 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%8]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 08:19:02 +0000
References: <20220406061904.595597-15-chandan.babu@oracle.com>
 <202204070218.QyD2PQPx-lkp@intel.com>
 <20220407010737.GD1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     kernel test robot <lkp@intel.com>, linux-xfs@vger.kernel.org,
        kbuild-all@lists.01.org, djwong@kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 14/19] xfs: Introduce per-inode 64-bit extent counters
In-reply-to: <20220407010737.GD1544202@dread.disaster.area>
Message-ID: <87ilrlxq4w.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 07 Apr 2022 13:48:55 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0033.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10a87d7d-353d-4779-2a3b-08da186f462d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5613:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB561387ED8F4F944A988367F1F6E69@SJ0PR10MB5613.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eakaSzbFUQ6Vh8V3kRcIlmgBLW6omra5sbzA0IO/haKhC8h+tJeWpXe1NGDhzgVxWZb/sdw5ljVzyuxA2WMxM2neFOuapo17FH8XvaCxPDMx5H9z0eHWOKFehAUzWx5q+AHIK1oBJh1havX+MGPUMVELHjjE2qzNnHqFLe8wRWxyj8D+39OOosHAm5zHESICdsujJKBBbaxLk29iuHyZ11xp/I4F30mK/z7MfY747Y4VouUpUUR02ZxQEISgbhlrrahk+KHr8yX+DWUyJbXP+DkXX32mKlBKTWQ4A57Lzu6MX/6mpjkUBrPwZabSJUPVnFNwlFmPhxYj1bp4uEJYbDpIL5mBa4EBZNcKz8ce4Wo4u5PP0EWxwwxLiGcQ9fUNdT3MOP9jWKHWqH09z1J7SlqpBDDAftDnQPKqTfAILhHLnlyQZQbYebYBKISfVt4HGGfigr3tpRqQcvJaMl0H2VDdFy/4xSm9rbDQgINuktY/sWgxLR2BqBOWF85hQJ3IBWlsQmpX3KJxmQhDoLsiEo8UPWOB+iKS1F1kmxMM6vIaHNjOL5a41BtLndRnAbhUKtIxU36KEuCt7GAfB+NZs+RdUuxC0tzsvqcJkOUWsVd/M+d4kp8qpa9UYBHS8B7qkDCAZf58+rBrEWSXU4UZZdz4qkUZgKL76ZXmpn7iwIsVQi9jFnF/I0tRJs15j9vRNa99xzq/m6RCzlPb+0le5NU9m1Pm8wuZwpL5sTgeLWCNqq5HTIyKNLQQXc1mTdNzJUxzL95zi1S0asy9nboBCsqw19WqiDuXog46E64ct/TMHaI5Yhe5TAry5jmV3HO1GyFa9d1ZgrTrXxJBJBFEAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(86362001)(54906003)(316002)(66556008)(66946007)(66476007)(6916009)(8676002)(6666004)(6506007)(9686003)(53546011)(52116002)(186003)(26005)(6512007)(38350700002)(83380400001)(6486002)(966005)(8936002)(5660300002)(2906002)(38100700002)(33716001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7urDiPUTOYAs+2M9ZiZ6COCPZPrspQbCe+Dagl46VHL0yYMZi5BFnUGEKzIC?=
 =?us-ascii?Q?jfgbKkTvIgveLKdG3dgi4l236QdMCIH2wjF6sakZNj1ZhR3GOYJuY8zVec/C?=
 =?us-ascii?Q?V0U48EMVxuzj+Iw5IGR/nfQpN4yjLyyeS3FLlkM2bnI5IcFVDMJdayGuCF7c?=
 =?us-ascii?Q?hQC2O+TqpitiE7WBrx9unIvGRDghNQoif2yTkO1MpM1xmx1Vv519d4kxJ9lt?=
 =?us-ascii?Q?av+7QmPu0C6mwKi2Tsbw/9WBShfzyHqUDVffc84zAiMTnglb/KDsbyCq8mfM?=
 =?us-ascii?Q?Gz0n4p8pk6VoD+UCQNwqk2FW9u1HjXQyx+esm2B0h+CJCkzpWBpYufNF42HJ?=
 =?us-ascii?Q?Z+VHvLZZ/No6PMM8U+uu4Vh+opN5S/eCSJ8UANLci2Qp62d0eJrtHw//XTkp?=
 =?us-ascii?Q?mD57eaosWXcTmQuBhFGwX9STm5tyFCMmlweu9axSyY9NUPpjDlgSGZccxofF?=
 =?us-ascii?Q?0BSeKyzItOcGFF43AsOxokFBT8KoNE5YFUPgSHCOkq+XlqUeD2mkGwHqMtkG?=
 =?us-ascii?Q?cJfXaW8qd1isatFaJnQaosncZKUvIHGXgMJ/xqZR3YjtHAyE+XEwSWnjLsqw?=
 =?us-ascii?Q?xDUmPNcOD6qEqTgyUQCRw/Tf967E2w10FQN4ebKjwIJe5zxm0l3HsfysONEs?=
 =?us-ascii?Q?uOTUM++ynrIh6U4BVyChssMAxEjVX/jKJWTOAJdqVXYxVNzfWft+It8Vhkus?=
 =?us-ascii?Q?DQGh2KIt8g1iMjrIQ/8fHh4WK1IpT8w4OlfoiQe3h7CeiaR8yyx5qxENIYl6?=
 =?us-ascii?Q?kCMxwFAfuNy+OZIjGUjGqAUDqj44w4tlv81fAqbNxjCIMuPOdDWknfqB7Ozm?=
 =?us-ascii?Q?MXAvuKnuIuS9q6n65P4y8Fmq8xruElgkBoi/nNDu3hoJUsarnGRykMF2iHUU?=
 =?us-ascii?Q?ykaXBINt8eUuvMnxvKVMDtrpQmk7/8uXnj+4jcYZ3yiH5GbPkB7V9mHL8St9?=
 =?us-ascii?Q?ewTYcysvtCJ/PvA5Xl17Dvjax/XzaDNF73pxkhiByH4B+c+01oqnOSGHZ4fN?=
 =?us-ascii?Q?hWkX/qjT74WfBMxPkE/CPeMXucrA/O2xP8I6JaX5Aqz2CL5c6Fr+j6s10pfV?=
 =?us-ascii?Q?FvIPODd+Yuw/3ZjOWZNncrbAaSAnS3cCJW18YKDEKEBypAJuNcl5Gc/v6xJa?=
 =?us-ascii?Q?zZTU2lhOH3Hu1IkEk2LoGmRHxSBiw8my9wxARrr4L8uEJ7Wf3tP7mPzXzyNU?=
 =?us-ascii?Q?ulMMVtqswn3PWi+nB8sxN4REgTTVsvjEyaI+cEK11eXrSz3t7Er0VQo9J/NR?=
 =?us-ascii?Q?vaN0MSEBepFy3ZrK8I7j1MNPEvyruXuzPTnBFW6dh1bWlAGW7SkNNeF/dRnb?=
 =?us-ascii?Q?NxyaSI/PNdj/Ebsmy7prAnf+HlOmUXM0RPie4Nct1gLcEECa9EqfxDUOkqJB?=
 =?us-ascii?Q?92mqgcjzcqZ+fvD2LhXs5AdWM4YzWNPRNR6reUYxwQ7s92tN11FJBF1bc5s6?=
 =?us-ascii?Q?YCZePaR6nIHBLZNWKC21pRzM6b3txpg50bJO81slnfr3d3GAoIGj1QaqAkvv?=
 =?us-ascii?Q?YpI87rGmmaOL/gRBGoZyBDDvSwOIYavSSzphEDHCde8JblH31MNLnVj52wOE?=
 =?us-ascii?Q?KUYqdPy4LdmbjwtmobmQWt+ddGMeKt3MeTWbxr8l58v1RMD5u4u5NUMnDt6D?=
 =?us-ascii?Q?ZOv6DAKNKiha5YDzCJO5KK0+XaEpYNnqQPJjmEnAPqHWuAc/FEJQLZTfmLp4?=
 =?us-ascii?Q?eO3r0IDkNTFhuYVev9x723Hka9ZBaCWzAcwudrNnZYmbD5ALY/lwpXK8kpCp?=
 =?us-ascii?Q?MuBQguKtEN+HoRL0+00RJtXuZkQO5XQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a87d7d-353d-4779-2a3b-08da186f462d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:19:02.6648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ter8K3fjT+1c0ZR9XdvHu0ly8JlUAEZVIFVOeXrxwoTprGavFF7OJaIfvswC3LYiv+XXREHpmz3iPkv/SZXhQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_13:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=769 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070042
X-Proofpoint-ORIG-GUID: tJJHDsnMI-bSZO4JxWcJtkEBl0O9UDBv
X-Proofpoint-GUID: tJJHDsnMI-bSZO4JxWcJtkEBl0O9UDBv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Apr 2022 at 06:37, Dave Chinner wrote:
> On Thu, Apr 07, 2022 at 03:03:32AM +0800, kernel test robot wrote:
>> Hi Chandan,
>> 
>> Thank you for the patch! Perhaps something to improve:
>> 
>> [auto build test WARNING on xfs-linux/for-next]
>> [also build test WARNING on v5.18-rc1 next-20220406]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>> 
>> url:    https://github.com/intel-lab-lkp/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220406-174647
>> base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
>> config: i386-randconfig-s002 (https://download.01.org/0day-ci/archive/20220407/202204070218.QyD2PQPx-lkp@intel.com/config)
>> compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
>> reproduce:
>>         # apt-get install sparse
>>         # sparse version: v0.6.4-dirty
>>         # https://github.com/intel-lab-lkp/linux/commit/28be4fd3f13d4ba2bcedceb8951cd3bfe852cba2
>>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>>         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20220406-174647
>>         git checkout 28be4fd3f13d4ba2bcedceb8951cd3bfe852cba2
>>         # save the config file to linux build tree
>>         mkdir build_dir
>>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash fs/xfs/
>> 
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>> 
>> 
>> sparse warnings: (new ones prefixed by >>)
>> >> fs/xfs/xfs_inode_item_recover.c:209:31: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] di_v3_pad @@     got unsigned long long [usertype] di_v3_pad @@
>>    fs/xfs/xfs_inode_item_recover.c:209:31: sparse:     expected restricted __be64 [usertype] di_v3_pad
>>    fs/xfs/xfs_inode_item_recover.c:209:31: sparse:     got unsigned long long [usertype] di_v3_pad
>> 
>> vim +209 fs/xfs/xfs_inode_item_recover.c
>> 
>>    167	
>>    168	STATIC void
>>    169	xfs_log_dinode_to_disk(
>>    170		struct xfs_log_dinode	*from,
>>    171		struct xfs_dinode	*to,
>>    172		xfs_lsn_t		lsn)
>>    173	{
>>    174		to->di_magic = cpu_to_be16(from->di_magic);
>>    175		to->di_mode = cpu_to_be16(from->di_mode);
>>    176		to->di_version = from->di_version;
>>    177		to->di_format = from->di_format;
>>    178		to->di_onlink = 0;
>>    179		to->di_uid = cpu_to_be32(from->di_uid);
>>    180		to->di_gid = cpu_to_be32(from->di_gid);
>>    181		to->di_nlink = cpu_to_be32(from->di_nlink);
>>    182		to->di_projid_lo = cpu_to_be16(from->di_projid_lo);
>>    183		to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
>>    184	
>>    185		to->di_atime = xfs_log_dinode_to_disk_ts(from, from->di_atime);
>>    186		to->di_mtime = xfs_log_dinode_to_disk_ts(from, from->di_mtime);
>>    187		to->di_ctime = xfs_log_dinode_to_disk_ts(from, from->di_ctime);
>>    188	
>>    189		to->di_size = cpu_to_be64(from->di_size);
>>    190		to->di_nblocks = cpu_to_be64(from->di_nblocks);
>>    191		to->di_extsize = cpu_to_be32(from->di_extsize);
>>    192		to->di_forkoff = from->di_forkoff;
>>    193		to->di_aformat = from->di_aformat;
>>    194		to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
>>    195		to->di_dmstate = cpu_to_be16(from->di_dmstate);
>>    196		to->di_flags = cpu_to_be16(from->di_flags);
>>    197		to->di_gen = cpu_to_be32(from->di_gen);
>>    198	
>>    199		if (from->di_version == 3) {
>>    200			to->di_changecount = cpu_to_be64(from->di_changecount);
>>    201			to->di_crtime = xfs_log_dinode_to_disk_ts(from,
>>    202								  from->di_crtime);
>>    203			to->di_flags2 = cpu_to_be64(from->di_flags2);
>>    204			to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>>    205			to->di_ino = cpu_to_be64(from->di_ino);
>>    206			to->di_lsn = cpu_to_be64(lsn);
>>    207			memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
>>    208			uuid_copy(&to->di_uuid, &from->di_uuid);
>>  > 209			to->di_v3_pad = from->di_v3_pad;
>
> Why not just explicitly write zero to the di_v3_pad field?
>

Yes, We can do that since the call to xfs_log_dinode_to_disk_iext_counters()
will update the values of union members correctly for v3 inodes with large
extent count feature enabled.

>>    210		} else {
>>    211			to->di_flushiter = cpu_to_be16(from->di_flushiter);
>>    212			memcpy(to->di_v2_pad, from->di_v2_pad, sizeof(to->di_v2_pad));
>
> Same here?
>

This field too can be set to zeroes explicitly.

-- 
chandan
