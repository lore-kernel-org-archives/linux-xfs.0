Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B043C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 14:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiAEOOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 09:14:43 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9918 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237013AbiAEOOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 09:14:43 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4TQv003673;
        Wed, 5 Jan 2022 14:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hW0ajaiXcyzOGCj8DAoXZLRHmJYYCh++s3SBjkOtypw=;
 b=ZzUuzzaumxfLghkEc15YIQ87c6xc3YsBiEGFOL9y46STlUmNE14Ko8anE0ADm6srH0ii
 DCpmTyNkjeYrfLMVf43O/EgXrCqqj7DyzunpD9v5mNB1spUoz3keWRFR+GXnosJ8Im19
 yYI005dmMQdH74eVhWgAqa1sIB33h8kwaQXEzrAyVo62MrZeMLvmNtM7o0kTzBEcKGOh
 sF/G6q+dbi+3jNM7eDS3KE0d4+9IVaWq/I1QmRQ9WWv5dFiVPoyqXzL2Q9uVeEVdjBdQ
 nNTUgP0z/9nI32B/gXOZRmWnWMteT+SUJOwMwxwUyrVPXG8vCnCb7ObUidUa6uPJfP2f /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc3v4mx0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 14:14:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205EBe5S153615;
        Wed, 5 Jan 2022 14:14:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3020.oracle.com with ESMTP id 3daes58wc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 14:14:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcpnv08OpwSB1Scx3we+GExO//8s9eeWt0m9BbaErG0GN07l3WZHEl4P87zqFtOf1Kj9kZlgVHsYFFnk6n4AIRZqFmPMOb+DsFgRqIIaEepqFlGXdes3WnVPOika1+LqqF/Vvix9SrsCOdfOsgstPgOT8lHf65SOWDO+A5ppsQPsPmmLBFoAFdLLS8tGCILigC7gn2GZCl6O7LeoXWXVnlXGitMHvynQD1IFMgGYV8L4V50NLkq8ti1j1EN9T7h9I12UUbHOVTXixp+qjncqeWIP15mhWk10zeI+EsGwUzYG7A8icQd6Oli16GZDuCiAvnzaSywQeSDqWPgVOcjUCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW0ajaiXcyzOGCj8DAoXZLRHmJYYCh++s3SBjkOtypw=;
 b=VfrGGKV0+w/fsICe21J8oJwhhAUznFXVRbulRUHCr98737pw9n6LdH0SjEMNXQy07bAhLfnP6XE2U1t7D/AByu0U0/Gv18ygpV/EhlV2L8TmJW9iF2mlXfpuo8xDESL4HDpQz1RXYw/VpAUgH1wiclEFCqRJ+E0J4rjKUK8NyiHksORkWuGd4Lz7P12eoIgZ14Ss65k1wfGjU/9Iv18AqmVCtQCnVypiDXFii+sRc9dode/VX2UGJS/zdV7Rc4hH4d3YMXq66V5tvDLZzKc3fti1S2j/icE9z487VjYeVGO0ThBdi/PgOasB+onpPyn/H/1dzB7u3A6lh8cab2VqFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW0ajaiXcyzOGCj8DAoXZLRHmJYYCh++s3SBjkOtypw=;
 b=K1Vj/l3eX4fR6Oe1CTlbnJZKideFKnTNP56Tud7y1cRqMd3wAVhc6fhB6EQUIxcFfRU2Hh+9w1QW6Rjc0m/erKJmXC/z4MVQnmArIuBFtqcOPh8ufDgEBEu/wTAStaopp7INFw+slA72RxNMNeMPvmYwzfGHImJySSzNw+CmamM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2813.namprd10.prod.outlook.com (2603:10b6:805:cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Wed, 5 Jan
 2022 14:14:34 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 14:14:34 +0000
References: <20211214084519.759272-7-chandan.babu@oracle.com>
 <202112142335.O3Nu0vQI-lkp@intel.com>
 <87a6h22pjf.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220104235457.GM31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, linux-xfs@vger.kernel.org,
        kbuild-all@lists.01.org, david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
In-reply-to: <20220104235457.GM31583@magnolia>
Message-ID: <87h7ai8e2o.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:44:23 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR01CA0004.jpnprd01.prod.outlook.com
 (2603:1096:404:a::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13f305f9-e310-48c2-8915-08d9d055b2e3
X-MS-TrafficTypeDiagnostic: SN6PR10MB2813:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2813A77E3E6FC466E608D93DF64B9@SN6PR10MB2813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y5JE1OwNC5UXViRTgYutGnJotp50RtRp1VtvbAFD9p+P4EVT4rV18iOE4xHdx47eiW3ULngWuRbchMScgzYGWZfatKFxRp8vwUF2iazGlJ+dCcUSBWBUanIJjpT5h3oyn8y95m+h84UBbMucdmMiN0My5kG5tqGTTjmG7iaUHz2TC9MPrXwkyQiD5rlLusHhTw9vfTmQR9lkw+bP/IYRzovRXAebRD7cXwdrGvtr9WIEoBmHu/MehNd2ajHtwFLSg26Xt3Vw0heAQiNmomoWF+v+QgfukWeybQGmuLV/FAu2VdVaIPKddyTQN1mea3IlT+HKAeX/v8jfxg0iquWvF2qVuvtv/ezJpmVmBccHyxKSSM6DTMpk+mMVvlk2sEqBFlNaY8TBHXRsNaisphdvO9gawZBUYSYNX68PsU84ew1yEavis2nzcmRc9INBkcqvawTi0K1EtOM8Go0UUB9PDzdct61GmDJkvUeAFfb3nfCnCjVlz+HnrGrZ1evGJY6EAFxGSE6OLQOeCSr6ulzDv79qUA9frsLRsVafRhABLBalSG3vlm5db/h6aoMomobq2VfpWCygB+3aWCOlSIA5IH0vWeFstnBPOiEybZ/XFiWwdREVN3IJEz5x0SH9FCrbFOYXCYrJGGrrAQKwgqUjcV7Y8pOnvyymhSdXPP+Dp1hEYxei6fteHS4JbkfO9v/k0Rk9ElCDECUgcZFYRznnRhQn9JUbj8dK2SA4T2RfcPw1Di9hU152hhrurMUS/6A7RkLvsFKpIraE8W6TC2zpn7Gv65O8xYBxpuQBUhSFeOAE1PyOzkNNmylhAKp/l2S/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(53546011)(52116002)(5660300002)(9686003)(33716001)(6512007)(6506007)(508600001)(38100700002)(38350700002)(186003)(2906002)(966005)(66476007)(66556008)(86362001)(8936002)(66946007)(83380400001)(26005)(316002)(6666004)(4326008)(8676002)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JSDMNPJdzRlpLUAZjkEjbTdLrTPDK3rYDg+ObaCV+5bZQRs2KOLce0Nzeyvx?=
 =?us-ascii?Q?PvKPSu6Q7lsaaUGtFOX99oM77NG1MsDlUIame/WVXkLQaml7F8sLpNJEF4YJ?=
 =?us-ascii?Q?oOhnJJk8tx5wK6DoJ1H85rGd8zNHztV4tBZsJ7QNBRGsADIXs6njQj9013Dz?=
 =?us-ascii?Q?KzO9DZ00Z4PuHF0YoojwElta9ArAov+7ZA/YUuIkool72a+/p7WHDUy0NFC8?=
 =?us-ascii?Q?RYmNeDOf5xF/DwgU3fzcJ2GEyzCVm7yW1d0zoEcNoq9TzkodLcHi3RRTUpKv?=
 =?us-ascii?Q?Jx/7TwshuAl9hQquuH+Sc0oiprjv5LOhmMy463Yd5sBs7rxLjWhfy9I+qyLL?=
 =?us-ascii?Q?cLDOZm9+RyT7U9obWxpNZyhUA6p87P4fYdWIQg4va+MSj/vioTmUgWQ+AHeD?=
 =?us-ascii?Q?IOg3shkr4iDzoe/iiHZUYjKkKLz1Ztz2sDB4Cn0d4KPnIa6tjh7m4Rqf2zK0?=
 =?us-ascii?Q?J/EUtSuHNwv6CmUKJEDgx4BiZOdRLJOpYOwyVaQmxmgxDA7RCVY9upc/n/Jo?=
 =?us-ascii?Q?dyLxtyjtTh5KSk6fsrS1g4XG8brzcC2WM5PPtWHyzPtdnjAvzXrj6SgBS2om?=
 =?us-ascii?Q?0zKeI/R00uMcvHyhR7k2KD7EG9ZYZSHYYO7zQjV4MpvMsbkZmXL0m8qaBpEf?=
 =?us-ascii?Q?SZ54MbKQV/3tSmUOvNDl1ypX6IP2KZOHuCWc4kfFCMHH+XDHHPlvg3a9zLll?=
 =?us-ascii?Q?XP+OURzqR8MVVL91fimYezfmU8B9zTHsWnyn4W0xAHPHTZJBlcqUZZ/BCA+S?=
 =?us-ascii?Q?zQh7dl0I4NxiKO2nSpj6EfhfbpCgssqWbLkcuv+imYYILKX+GOQ035HciO1P?=
 =?us-ascii?Q?vZj4WZzlCAWj1y4fD1EQx3MwMrQraYSazGpS/+bG8SYjFC/w62z9KuDG1C56?=
 =?us-ascii?Q?13MMPsYSOL2NqNR2dXaqSkeVEGw2UXzkN/fIF12007iwduyuBPqODRuy2NLR?=
 =?us-ascii?Q?f8TvvdK8LNCf/z+Ov/rQRHCiCMoX+EZGdmU/ihw41awctC2jl+tainGGYlUo?=
 =?us-ascii?Q?ll7j0QZvWLqErI0S9GTdrkSQ1TiXkZCgMQARUfqk9USr7TbXGaCYH9tIHrd8?=
 =?us-ascii?Q?9MaDEnERG1obyY59plMhk5l/n06wIPDF/JraH9Eq37j8SFvtz+X0YQ60T58Z?=
 =?us-ascii?Q?CtebQZeQvY6HrVYq9LenVNcvNcj1IXeOjFduQoOWYkZ4us7bTgX/x2mG99p/?=
 =?us-ascii?Q?u+y0xsbh+KFZ+Gxwpdt0SE/r75qwDY3rA8PABmjHsyCaKzbyHznkpdB4zie0?=
 =?us-ascii?Q?d3SMjMgirEZyAnEW5OF8kSVOPYjK//qDV9Zrr3dGhO2of+2UDLmsSLFMWLAY?=
 =?us-ascii?Q?H61DraAwc11YcX8gppZBppK+2Nw58T9/MOPTpQ+7e0SKwofCf8im0iAErON9?=
 =?us-ascii?Q?6alzFE3JvWq6+kblzbsVXXQWG3jLE/jwRtpaBQexG2SP0tsMYuDYFhpcQMAl?=
 =?us-ascii?Q?scSahGoo5FxAASs2m/8Y0XSuoOJ146ykavU/5lP+KDZuJ0r6slwKshUYQ7Ej?=
 =?us-ascii?Q?PeNpANQOsEfvOVXx7KOYh5eSHyPPmNkf7wAGyrpOVTCS280oizcor8um1UHC?=
 =?us-ascii?Q?k6naKKqtQz2k50b/+evOVWbE2qlhHqpl9f0kB4qAZR5HE7NFn5gf/SdGvbHV?=
 =?us-ascii?Q?JMy9A1L7ECJFy3pEumQqnAE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f305f9-e310-48c2-8915-08d9d055b2e3
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 14:14:34.3919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNVQRNlG52pegIrZCu4CJliQPkc0gvZqGEucAW1Bh7wgYTkVyLTonT5rHbW0VpCvgl+gkKygClqGy/FeWRMZyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2813
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050095
X-Proofpoint-GUID: P0GnHY-_rA23YjNTt-2XwBMi-J-pEROE
X-Proofpoint-ORIG-GUID: P0GnHY-_rA23YjNTt-2XwBMi-J-pEROE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 05:24, Darrick J. Wong wrote:
> On Wed, Dec 15, 2021 at 02:49:48PM +0530, Chandan Babu R wrote:
>> On 14 Dec 2021 at 20:45, kernel test robot wrote:
>> > Hi Chandan,
>> >
>> > Thank you for the patch! Yet something to improve:
>> >
>> > [auto build test ERROR on xfs-linux/for-next]
>> > [also build test ERROR on v5.16-rc5]
>> > [If your patch is applied to the wrong git tree, kindly drop us a note.
>> > And when submitting patch, we suggest to use '--base' as documented in
>> > https://git-scm.com/docs/git-format-patch]
>> >
>> > url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
>> > base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
>> > config: microblaze-randconfig-r016-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142335.O3Nu0vQI-lkp@intel.com/config)
>> > compiler: microblaze-linux-gcc (GCC) 11.2.0
>> > reproduce (this is a W=1 build):
>> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>> >         chmod +x ~/bin/make.cross
>> >         # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
>> >         git remote add linux-review https://github.com/0day-ci/linux
>> >         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
>> >         git checkout db28da144803c4262c0d8622d736a7d20952ef6b
>> >         # save the config file to linux build tree
>> >         mkdir build_dir
>> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash
>> >
>> > If you fix the issue, kindly add following tag as appropriate
>> > Reported-by: kernel test robot <lkp@intel.com>
>> >
>> > All errors (new ones prefixed by >>):
>> >
>> >    microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
>> >>> (.text+0x10cc0): undefined reference to `__udivdi3'
>> >
>> 
>> The fix for the compilation error on 32-bit systems involved invoking do_div()
>> instead of using the regular division operator. I will include the fix in the
>> next version of the patchset.
>
> So, uh, how did you resolve this in the end?
>
> 	maxblocks = roundup_64(maxleafents, minleafrecs);
>
> and
>
> 	maxblocks = roundup_64(maxblocks, minnodrecs);
>
> ?

I had made the following changes,

	maxblocks = maxleafents + minleafrecs - 1;
	do_div(maxblocks, minleafrecs);

and
	maxblocks += minnoderecs - 1;
	do_div(maxblocks, minnoderecs);

roundup_64() would cause maxleafents to have a value >= its previous value
right?

-- 
chandan
