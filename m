Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37C1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 09:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbiEYJim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 05:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiEYJil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 05:38:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D856A5F4D
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 02:38:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24P6rV1B018609;
        Wed, 25 May 2022 09:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MgQzDdbVM7ICT7Bl5b5HafICYgxHq1GI2biXFWfaKws=;
 b=JS20qZTbV3INFgeA3CTtHaw3yIxLyZaBdgPxPM3MJ+THXN+9tY114inL3Fw3kQRfjwWa
 sr9BhqmFwTBj1i4j9aYyt/i7m5RMErBh2HBFq1x8o3cu14grOlQoAi2TC52ivSrGtxNm
 QVoL8MX8rgnBQ4EqSgoDj3lXo/sbMTy2hMiT5KFYGh7OMnOKzjj3G23l++6htIO0HKxI
 GGfRS+LYU8YPBrW+im84xcHupnij3Z4WLuDTP4AWIQCcoAbVt/32+/68ywtA+JP0P0Bv
 XuG6eZ8YZpUf1SMS2fC1D+L7dUFJ22z0ObifnfDYq/T3AQCp5uB3L+TODN9s9P//5PpS /g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tc1nkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 09:38:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24P9ZPvc027069;
        Wed, 25 May 2022 09:38:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93wqafck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 09:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+YYSFXIhWsT8GH8CfJ+M085bfm5e06Pb80u05XDu8GZup1rSw221a4/et3yqsUWN9L0HGYB5vGShxh+VJy5Zj/alKJz+13ZAXdg/c4d4K/ozS8eCe9d558rAVq5jC3ydFbpDDlZKntdnD4ENNIEd2whVGk4UNcFR5ndFhBIG9YFGaGduQDQPWZTxoGl4QVPJxrWY0Uw/5PWqyh1C/k08oS0Fg3MCfvPR2nDcXzmEI5WND32oOoywe0UVKxjO5vrL1foa6DkTJXCWE5C1eLDEqem51S36in5I2STqSjh/hm7VTy5KQ8dlZU573LBbjtZxdsH5hxfJIXkpFh0XG3Vfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgQzDdbVM7ICT7Bl5b5HafICYgxHq1GI2biXFWfaKws=;
 b=S3xq+yvwneOBEgG07/jb6UcFMmSm311w5M5uZsh+rAm2Kr1/M87qLTpBmMXsWOKDYmxghrop0VdNtHlQ+wRa1gNvBU76ZWKdLQA9aOggDFHzuww9LDr2NpfHKPZICFct9wDpXFik74v0cUsKMeI5tgL/RfduHsW+70fxetRNnQn+gy+7VA7R2LSJJOIiMFtIn8aTDK90MG6TgTCKyQ3+XZafEbDrPHi9F5ElbGkaED/0zheGDEx3dHAOz7Tr7ynTewOmvJtVpbAdUXptTNVVQQ4/7an9v8FwPpZkE0QE/AzGZBdLHMi3gS6cQ/rwgmqX2feywDMtdH0qgyFdk105UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MgQzDdbVM7ICT7Bl5b5HafICYgxHq1GI2biXFWfaKws=;
 b=VH/0EXLiuSnWKIA6WkOrU/U67PFlXHNpOuB6mpYUoz8W9HvYAqY4TkOOBkkCHjrYQY1D+u/a2NJNvesqMLBqw2TQxCiWWZUL+VldZKXa0i1lz5iyGRbWXQl+MqLTD7gQhviavNeoxUtThyjbMaAmmS27+d2ZvceEDKu67IPZvx0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DS7PR10MB5200.namprd10.prod.outlook.com (2603:10b6:5:3a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 09:38:32 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 09:38:32 +0000
References: <20220525053630.734938-1-chandan.babu@oracle.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] xfsprogs: Large extent counters
Date:   Wed, 25 May 2022 15:06:24 +0530
In-reply-to: <20220525053630.734938-1-chandan.babu@oracle.com>
Message-ID: <871qwiar5g.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c84b2965-ff83-4fed-c6a2-08da3e325533
X-MS-TrafficTypeDiagnostic: DS7PR10MB5200:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB52006A8BE073D54A5A3993E8F6D69@DS7PR10MB5200.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTg0/MVxQjD3rAH3kFA679YCg41NSapwWwk5UX0fV/lfrYyqkwgUbHt5+kBluEnXGLMYGyZcnGtzdHsuqeRUH5kNZUiYwShO2yoFI8DEuXHqgkl5VhHfa4w8w2kjVewMtsT6NbPKeLbgJxVIycgFSqyfATx4hEbeImBAAhIO5zpmAaTHznedR612wK/w7Isje7zfl1jGgPgoSTY+g4mdcL+ppKr/Z+N0lfdctOxHI5KHHjGFhnt/yHhqmiHDJSte7AhyBB9mVNFBjI87CeffnpzkkzQCUcnbg4v3CgBKUx6OJ5nYdnL6in3ukB8N1JT+HWGntiXGXh4YmoWLIIosGYGCAWuBC044s2aVsgK5mkLVb60yrzTQRc7gwu3zT6z0CuFiIJXJUbgjvNBxG618FaFcs0cJeVHX7FHEi/mM3yt0dboyKnBJpGjD2evKcvOkgg0/gfc7+AqxLXJbrxtel7km8pcwx4kdUFJpA3vlBmNq/MDMlkM5cW7rg1yt5i3Zth2aBVl8XkKtSSUaSfQUDF7zk5yrusk5Mg7ugjrW7tm4+Y70SS2oJi2fxZEuFIyMg3RrmP/51phMyI5WdjHBS4UI1n/6NWsvBYKZnKagfA5L+NcTWQ4IW8YDzXL6j6L6IIUubT8IcKeokg0ueMChGocJ+kbrXXCDA6rLg7x/Bpfv5WizOWOu9BvAZ62MmTIz7Jwr1sAc6fVQ/3K6ZC1UbhFKtkMepAWq6vCLx8BhCJ+LY71kYYsMz/1q0WUlovlqx7LXIYt3T8f5O42ll7RKDnnAOKZGYvR9fc718Bcru28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(6512007)(5660300002)(66556008)(66946007)(8676002)(66476007)(8936002)(9686003)(83380400001)(508600001)(6486002)(966005)(33716001)(6506007)(316002)(52116002)(86362001)(6916009)(186003)(2906002)(6666004)(26005)(4744005)(38350700002)(38100700002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zA7CYBilNduK3MRrfu/azjNg3W273yq259XYg04qajGihpPgUgXLVC0RALqg?=
 =?us-ascii?Q?wK+3c2vmpL8YD3aLPcSljWmVY44MS+f3nm9r04A5iktuhVxsUSwMihhB248v?=
 =?us-ascii?Q?lTstwAdibF3q9qNDQH2ChRr8VsJBNooJ8mwKMiBKYeS5/RkiqwzOIYuEa2hQ?=
 =?us-ascii?Q?3JRfwruB6g/IMI2T9OHau562IKNFq6tAdpggWXTGvlEHgeIXkEuF4q4Y9INK?=
 =?us-ascii?Q?fwf5fldoijwOU2QJbde0LUtdiAu5IIYkJMUuduBWj979Jc8JhI9QSopkZyhw?=
 =?us-ascii?Q?xKSvJY6lMl12sBS+1X2JvFayrUF3BmpzPkjwjaDvVxAum+cix8Qv43juIZLP?=
 =?us-ascii?Q?4Sg4iIW/2ukmg40APkySzrZVVQakcr9kvm/45+WCQIVuNkTZbn56eb8C0mq7?=
 =?us-ascii?Q?MCTybi+BvO6IoJvBuiQZCYXDEAn0xjhXs597JyGui9vNM90ph0l54ZW+9iQO?=
 =?us-ascii?Q?UwlvPo1nJtBj3TDqlyOw0CD9ek3z8OSn6AIeqhlyZj5scnu4mFID6WHEOCmV?=
 =?us-ascii?Q?tsz1r9VKi5odNFCY9eMQBrAZWVwsQG3+w97DbgSuaiFS+WvRLxMRpUGhmPH3?=
 =?us-ascii?Q?/KAXS+4bE0Mypt3UOJ9eZtGcBHqgfVLXaVavXpKCTD420qbq/Nk/AK3vBB2I?=
 =?us-ascii?Q?27//cpoF1nph89i+m+ShNx2aHwf6LyvX3fdBtCG7tXLTSe3f/WVcZKNUfAwD?=
 =?us-ascii?Q?FVPYVRzk806bz7Y37k3ZcdyHnggg4PdDxbjfwYu7ucbWn8qxRM1h9Q10NOdN?=
 =?us-ascii?Q?8NuK5g2vTzKzUJJmXHIloJUijvgBS3Jehps4QHmykAowGRL0fcVXg9mgTZsy?=
 =?us-ascii?Q?2+vEjb6n2gEl4pQ16YpyIpIwCprda9v0iJCtbFHPM7y9cCIpqLkTulzLHAZm?=
 =?us-ascii?Q?qyXca5p3fSMku+JTpZWvOh6Ym0yYGgIDl+le1E8reRcW83hDhNf8Xa/socEd?=
 =?us-ascii?Q?6eUT/fX/C087sl2qwa8mYX5LQd0YXUwNY+leVeDi/Tqmjj8EZ40VEEFrWdgG?=
 =?us-ascii?Q?J2DC25+b8+C8YoHZCdTLFFbyreSshgaN6tlZ9zEYsv0UZFIJIba07wsxDkXf?=
 =?us-ascii?Q?PqrXL2TOOAAMb2ihjLcZlQzfhLB9kbSuGE5/jSsT6ghKJDt9UAP8NeZSEueM?=
 =?us-ascii?Q?EuLUHzd2A2Z7N+kj8ylF0h2vc/zzdSXS3k26w4X4B4P72ICzGA8ashEDmZpE?=
 =?us-ascii?Q?o+TMXPmW5KkmdSE0uzyH5tZmpvI+B1O94S8zWfE5rIIWAsXsyrweCWLdLXEr?=
 =?us-ascii?Q?Eul2hLJewHT2Fq4O6g/MxVSg329ZF38QfGpIok7di/5c/qVySumhC+AeYP7r?=
 =?us-ascii?Q?CEZmLtAODb9GnZBZDbEszxniYXJHi+T1+017PB6j5dBCIiD7uL7bCNMwFiPw?=
 =?us-ascii?Q?leZxZtMThnl3QIiOssSgsr9KdQm9IUy8pQISkTO0hIeFWa9x5zs4pN8+ZpNL?=
 =?us-ascii?Q?Rdi4uObahWGy6cKnWmmE53qbTMT6eHcxJ5HJPUNaPXb8m3AffNOq3FdUXoci?=
 =?us-ascii?Q?5pZjDFEKMTwehl6ZTNw+i7V6PnqtsjACtTsaaXBRoaLfcdrhNIU8AEWVuOkT?=
 =?us-ascii?Q?3QKqlLYoZHN2qvlrEpYW4OWXJnZveJqvPxZhUkhEbJtq7moa3OC0LSmBdylJ?=
 =?us-ascii?Q?RLzoE2Ff6KrO2N1Jo6lcViygx9r0uQwBgaQ/nCYOvxW4VPOx4yaI5qSwHR3I?=
 =?us-ascii?Q?VIQQPREFmixiGh8uN+3BVr4Vy011x3AxsC1iBG1dbMW9aUN5BrBsf8sFutOU?=
 =?us-ascii?Q?R0PBdtbjYrnjd1p2QmPy2CCTiRcAquA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c84b2965-ff83-4fed-c6a2-08da3e325533
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 09:38:32.6652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DiqzY5hO+pHQwNFYmq987+tyCzLRh18EWBYiN0Z9yEfzRGnEgls/3Z9J2Oi/zrI+oF2UC8JcgbOmVRgJHQbYEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5200
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_03:2022-05-23,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=978 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205250046
X-Proofpoint-ORIG-GUID: Rp1kbOG6nLBumSqeOWjNmz7G3PF4KID6
X-Proofpoint-GUID: Rp1kbOG6nLBumSqeOWjNmz7G3PF4KID6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 11:06:25 AM +0530, Chandan Babu R wrote:
> This patchset implements the changes to userspace programs that are
> required to support large per-inode extent counters. These changes
> allow programs in xfsprogs to be able to create and work with
> filesystem instances with 64-bit data fork extent counter and 32-bit
> attr fork extent counter fields.
>
> The patchset can also be obtained from
> https://github.com/chandanr/xfsprogs-dev.git at branch
> large-extent-counters.
>
> PS: Dave, I noticed that xfs/070 is failing during xfstest runs. This
> failure is seen on libxfs-5.19-sync branch as well. The bad commit was
> "xfs: validate v5 feature fields". I will debug this and find the root
> cause.

The failure is due to the above mentioned patch changing the warning message
printed (in xfs_validate_sb_common()) when an invalid superblock magic number
is detected.

-- 
chandan
