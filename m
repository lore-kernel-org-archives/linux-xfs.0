Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24DBC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 15:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344123AbiC3PlN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348295AbiC3PlM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Mar 2022 11:41:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB49FE43
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 08:39:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UFM0bG027915;
        Wed, 30 Mar 2022 15:39:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=V65ufnhY8IKUNsEAVDGgDu2miW1a3MkyOOwd9wQMFh0=;
 b=amZ2kf3r9+bo/GiVgAFc6r9pGZ8bbRoyT0jA7OEyu7F765b9rOzHXeioBWsBkVqybV4E
 CdKAF5lz2tQPp4sbggAebcItW+xSjzXFSFDkx+W/vcEYClK4XWHfjwAiJGK2nUqlSVig
 stG0u7aRYyUEcLNI9BI++vv3wHA7hNPzwhQcaLsmp4hz5b0O475A+/SEgXOtCCM8T8uL
 ma6IeTladyacvGo7lSj0YOS/4sDSuKGVef1Ejl16tc8nUFY+JqCFVb7gwFS9PaPFtdw7
 5rg+4KNbkeq5h0bsRCiuRtud3Ny+3pXiYB88W+VH9sWODmAdwlRo8L5u7hMeu9qHGMAS +A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2hwf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:39:22 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22UFW4jr011409;
        Wed, 30 Mar 2022 15:39:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f1tg6xphc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:39:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlFwHIcsykoeIIbEokKpvEvI32fzX1bubCfoheca4t6vmyKBEvOIh4yHeHmOn8CS7saXftxeoWsIgcJTfLZJCkgZqaLCSf2SwyCxwT62dtBrOAddujQDVC8O4OvjBMvQFoMDf3KYWgSbfrXavqtlCFT/ETFGMW+urc9Mdx/UwsegrDPCzbU/CJYHArgunSc0TEEdzUhjtBlVmZbEBwRVxGw+14fm5GfnbMXQpHODweVKzJLbx3xMPVeHl63HMSxI1QVwpkzh4Uv7mlCpmG3deo90LMLb1dK3A4yJUFn4HcjH26WIONC66ZdeJYd+tUIQR8MJOO/QXn5fCRgKiBZpRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V65ufnhY8IKUNsEAVDGgDu2miW1a3MkyOOwd9wQMFh0=;
 b=DE8GMWC38Tn5XfvXOoz7TJGoLXlTBBmez1uJrtkunZ53N7AdS1vNc9/FV4SkHBVa8zDjEKdFX+Z4UlcgaVwPDms/8AGPnqEzC9PPGpKb/pEQ6TL27YqBe+rvRQghORV9k/rjHVJCyVNvtbiM/H9B8z4FhnjPk1IcFizlMgvFe8ZI9HTgPNqwVR2BvhAtBth7fISxvdCp/Erwn1NYVOt8KngcROXN1GLPwd7x+4VOJie+7iEubWbeVcAZYE9dxw0qb4gL5+uIXDOHxbbDl9Kxd82LZvo25c5m9iZ3Y8M9ZMbrbt6oQa+T6iId8BmLYHAQHUGFKEwRgrs4Abpwm9mk5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V65ufnhY8IKUNsEAVDGgDu2miW1a3MkyOOwd9wQMFh0=;
 b=kJ/XkLZkblePTTSWrG066ZZ/bCRYGageOYsYKAyLLh8mzVzmpbNsw02WN4bnKaqtmSE6t1ZoVX7wR8DoGKPUD4vkeEAbjFeDB07EXQv9uL7TzcZNIcHKx1Td017Dc+pl38d1r8Ickhy2O2e2msp/i/p/fzXcAW085UCg5tGTets=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CY4PR10MB1464.namprd10.prod.outlook.com (2603:10b6:903:27::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Wed, 30 Mar
 2022 15:39:19 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::15c9:aed1:5abc:a48d%7]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 15:39:19 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
 <87sfr1nxj7.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220329062340.GY1544202@dread.disaster.area>
 <20220330034333.GG27690@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
In-reply-to: <20220330034333.GG27690@magnolia>
Message-ID: <875ynvxxez.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 30 Mar 2022 21:09:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0031.jpnprd01.prod.outlook.com
 (2603:1096:404:28::19) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fa66eac-2150-44b8-c65f-08da1263749d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1464:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1464CE48437D06782459BB95F61F9@CY4PR10MB1464.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZQc7BDEQMVSTsxnGXFL4dV3ReM0mDWm36wTGaD+agQEqqiNo1b+RuryJJBqS6jNGpGW75qpftC1TdLv9CGXXQZucY8dwkDpPUtq/AZMgml3hDfiraNLmf/G1F6MCW8btDidOEDi2pR9ahvbvSMgbliPrd+wOhIKgOsuu8C891pkbCpLXGdNptfUxgyvShoFWuUX4xn1ATDQQRZDlmg6Lr6Bm1FgyyuWucpdjYCk/i1KzReWzfVd3OxvWspVackywbS+i1Zh/vWxHZftC9mP4bnGVYebZDDwvD1zh7oj2xjaFVU/dGGHvMx/JDodhGF8zdgp0CE6P6fYH4BWoXlg2P3sRfEzshKfUse3Twut6ov277aase/gbM8AKT7RgexYQqAjO98XU6eLAfPUe4zBSm9RWsOP9P3zT4XjbvBvTjSDlh4JJGHmqQP/rMWqOITseGT30LqVSwmWy43D+n3Iqk7CuVCvQBUQezV8CkGVcjtJo0L4A2OsIUfSP5gV9kVt5N6jXYZyJZGP20yeRgTttFK5JFW/KyjFGFI8240VtzkPWlKMUsi/Ey+jdiuUpKwvuyvYMluKk0mQou4QpjUmt97kbQHpoizsYhH1MsucSG2RKbiqer3hf+X4b1lohdXth6ZE7uScHJtyM4FdkaxNHKLe/nKywkgim8W9QSFr8mj/19CUEgigBOKLeC0fCGtDWWuvpGQKqKZXbh05SBdfwObJ4OSLmPy5/ZsCU+V4XqE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(8936002)(6486002)(2906002)(52116002)(6666004)(6506007)(5660300002)(9686003)(6512007)(53546011)(6916009)(316002)(8676002)(4326008)(66556008)(186003)(86362001)(66476007)(33716001)(66946007)(38100700002)(38350700002)(83380400001)(26005)(522954003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BcpGDTBtOJKnkdEZ8mvtOjNtV7cJ8f1NC+Glg0Acb5Vsv0RYF+Zwgwm0ci4N?=
 =?us-ascii?Q?LeyLFEODasdrKH401VxhasaU66+Fc6w2Cd4svH6nEHYvI+Eaon4JaW1pJHsS?=
 =?us-ascii?Q?Pafi6KSUnN+D2l7XDbhGY3ecdX6J37SEERfip1sydzS+icNXOuk49VRaryWB?=
 =?us-ascii?Q?lsetxTrKhPoURht+/dPAuS9pyiLOYvaUO+6PawdrIE8imdlHkhmTqJfatG6B?=
 =?us-ascii?Q?Co/xvCcTQcBQEi9iADdjlAPtFoacQxHF2fjQK6UXyYqsXAm7b53Eea8RxpKC?=
 =?us-ascii?Q?782SKuYrJ6s93ZE2u/7vOy7biMlyyejKiE8U2zt7lc0TDHcKSdXOm5uxsgI1?=
 =?us-ascii?Q?eYHTyKaG/1H46HXOhnQ+PzhnA6bueM3SRqu2w7fnSfGMHJwU/CgOf83zK//3?=
 =?us-ascii?Q?B3ioX+AFvOSrr+p+9MN+CwSaxXidSiMlZvLMTOG5yZM9hbyDOwueqfht/TGV?=
 =?us-ascii?Q?vyG4J5T9W0KJKdYBzJPxLPzRqhgtkWaXWHWlzxSISj7gG59vFS7uLlcMo2ch?=
 =?us-ascii?Q?+BOxnZ96QMrx3wWV6C/4S+5Zj/zMc/tjkuoJx5DJyKV5bml9GdohZfqtETzR?=
 =?us-ascii?Q?ifYwUkL/BB55da9FmifBvJ3VJdgHf3Gs3Ye5YIFrmoT9xqfMdsVpE53zgPvR?=
 =?us-ascii?Q?lmqeTj82xMaJosUCb3HiDKHou2e8Ltx4ZWZrhZ4OlDcrahfORiXA5nrYxXqd?=
 =?us-ascii?Q?tuU77rrXktQUcrd5oOkOHXIry5BneOiTN8j1HutSPprR1Jw/PXo9czuK4HI1?=
 =?us-ascii?Q?Iw2qfUfvBPik0p+9zeUlzCfrO182zr4l8Krea1OrDFIAaTwWtKZIixuItu3Q?=
 =?us-ascii?Q?nxQhFuRG5ZsK0RoqCaEbMgrDPfxCfKjGpcFflB0rePih5096CJ+M8G85wxvA?=
 =?us-ascii?Q?Xm0xyq/LrWrSn7cKTISbAhtmW+P2RPIYqcC9iztdTflyYsMEK8kK4eS1BWuO?=
 =?us-ascii?Q?8Ppoc7nNBZ11gNsybVfLlbIXafrfSXZInPWtAj4WLvXX8QvhcKiko2nvwPY7?=
 =?us-ascii?Q?+IbXDruQYFi5NrQbLg06sKWBFcd9bjsgZipkIfgYwMBZ0VvDx+9Mfd94aZ6D?=
 =?us-ascii?Q?6F385P3gSAKky/k/WCSPx+Y++8za30PCDmWDzSk1Y/J240QyJepbV++SZOs5?=
 =?us-ascii?Q?s4W53yvH6XBIVij2Vk5mVcd1DuWdrGluGDsyyajFfD/Jse6SxU3S5VK/eOQO?=
 =?us-ascii?Q?L/Zvnxd4pdpOI1QlvX931a2ox8Y8af9haswe/QRNOT1ySR+sBC5mMDfy81XR?=
 =?us-ascii?Q?+2ccgHrgfycgLSh3JK8BfLM7yxvKYW6RSYY3OZVywEffSw+0YLEGQtZ+fZPm?=
 =?us-ascii?Q?rkVjFGpi47wxa1hX7RjRoq1Tujh1hUnhMouZLctnX2tViRLI0UeAXoI5hm/4?=
 =?us-ascii?Q?rVNkW9JfFUrkk5aHzEKQx99YbbVWRkOiGy6PjWS8ch5/YHjhGZrtZJ31dPeU?=
 =?us-ascii?Q?Fq2bBP9kZaRXn7mWXe2SPF7NHQmuyF2jrFL/62a8fYg3GAUj3+P01O/ceZDs?=
 =?us-ascii?Q?3aB9M/v6GwStAPSn2yuyCggw3X2RwXJAnlttSXZo1SS5ncrzoVEMNgqCqPE6?=
 =?us-ascii?Q?8XIrpvJFYP5CzX8toQGHjgjTf8grSj7exzjxK63jUTUONbw2L45218yaqK0L?=
 =?us-ascii?Q?NkLc3yBn1+vbwpUi6IlK0Uqc/r+wrDQVV4eD5ycl/Or8zeGNVx14b6GvqWdI?=
 =?us-ascii?Q?BLcXvr5x1GE/Mq9SjrvHDH5yo7wrXCNU8ZwRL4tXvBbwIEVQUAteyNo7ibFE?=
 =?us-ascii?Q?ZR+mvZBn2QrpO8+y+dHm6y3o1ttOEbY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa66eac-2150-44b8-c65f-08da1263749d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:39:19.6248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cV0gtUktuj+GLZ/PWxnsKHrhKpW1mfHm67P+X9aloJOwQ05FiEXHQFhG3LkDoEYVGQ8rDLGHOq/k5t/Agxezg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1464
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-03-30_04:2022-03-29,2022-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300075
X-Proofpoint-ORIG-GUID: RFfqlzRqskgcU0ZiKufRTJAYYHhC3FG8
X-Proofpoint-GUID: RFfqlzRqskgcU0ZiKufRTJAYYHhC3FG8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 30 Mar 2022 at 09:13, Darrick J. Wong wrote:
> On Tue, Mar 29, 2022 at 05:23:40PM +1100, Dave Chinner wrote:
>> On Tue, Mar 29, 2022 at 10:52:04AM +0530, Chandan Babu R wrote:
>> > On 25 Mar 2022 at 03:44, Dave Chinner wrote:
>> > > On Mon, Mar 21, 2022 at 10:47:46AM +0530, Chandan Babu R wrote:
>> > >> The maximum file size that can be represented by the data fork extent counter
>> > >> in the worst case occurs when all extents are 1 block in length and each block
>> > >> is 1KB in size.
>> > >> 
>> > >> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
>> > >> 1KB sized blocks, a file can reach upto,
>> > >> (2^31) * 1KB = 2TB
>> > >> 
>> > >> This is much larger than the theoretical maximum size of a directory
>> > >> i.e. 32GB * 3 = 96GB.
>> > >> 
>> > >> Since a directory's inode can never overflow its data fork extent counter,
>> > >> this commit replaces checking the return value of
>> > >> xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).
>> > >
>> > > I'd really prefer that we don't add noise like this to a bunch of
>> > > call sites.  If directories can't overflow the extent count in
>> > > normal operation, then why are we even calling
>> > > xfs_iext_count_may_overflow() in these paths? i.e. an overflow would
>> > > be a sign of an inode corruption, and we should have flagged that
>> > > long before we do an operation that might overflow the extent count.
>> > >
>> > > So, really, I think you should document the directory size
>> > > constraints at the site where we define all the large extent count
>> > > values in xfs_format.h, remove the xfs_iext_count_may_overflow()
>> > > checks from the directory code and replace them with a simple inode
>> > > verifier check that we haven't got more than 100GB worth of
>> > > individual extents in the data fork for directory inodes....
>> > 
>> > I don't think that we could trivially verify if the extents in a directory's
>> > data fork add up to more than 96GB.
>> 
>> dip->di_nextents tells us how many extents there are in the data
>> fork, we know what the block size of the filesystem is, so it should
>> be pretty easy to calculate a maximum extent count for 96GB of
>> space. i.e. absolute maximum valid dir data fork extent count
>> is (96GB / blocksize).
>> 
>> > 
>> > xfs_dinode->di_size tracks the size of XFS_DIR2_DATA_SPACE. This also includes
>> > holes that could be created by freeing directory entries in a single directory
>> > block. Also, there is no easy method to determine the space occupied by
>> > XFS_DIR2_LEAF_SPACE and XFS_DIR2_FREE_SPACE segments of a directory.
>> 
>> Sure there is. We do this sort of calc for things like transaction
>> reservations via definitions like XFS_DA_NODE_MAXDEPTH. That tells us
>
> Hmmm.  Seeing as I just replaced XFS_BTREE_MAXLEVELS with dynamic limits
> set for each filesytem, is XFS_DA_NODE_MAXDEPTH even appropriate for
> modern filesystems?  We're about to start allowing far more extended
> attributes in the form of parent pointers, so we should be careful about
> this.
>
> For a directory, there can be at most 32GB of directory entries, so the
> maximum number of directory entries is...
>
> 32GB / (directory block size) * (max entries per dir block)
>
> The dabtree stores (u32 hash, u32 offset) records, so I guess it
> wouldn't be so hard to compute the number of blocks needed for each node
> level until we only need one block, and that's our real
> XFS_DA_NODE_MAXEPTH.
>
> But then the second question is: what's the maximum height of a dabtree
> that indexes an xattr structure?  I don't think there's any maximum
> limit within XFS on the number of attrs you can set on a file, is there?
> At least until you hit the iext_max_count check.  I think the VFS
> institutes its own limit of 64k for the llistxattr buffer, but that's
> about all I can think of.
>
> I suppose right now the xattr structure can't grow larger than 2^(16+21)
> blocks in size, which is 2^49 bytes, but that's a mix of attr leaves and
> dabtree blocks, unlike directories, right?
>
>> immediately how many blocks can be in the XFS_DIR2_LEAF_SPACE
>> segement....
>> 
>> We also know the maximum number of individual directory blocks in
>> the 32GB segment (fixed at 32GB / dir block size), so the free space
>> array is also a fixed size at (32GB / dir block size / free space
>> entries per block).
>> 
>> It's easy to just use (96GB / block size) and that will catch most
>> corruptions with no risk of a false positive detection, but we could
>> quite easily refine this to something like:
>> 
>> data	(32GB +				
>> leaf	 btree blocks(XFS_DA_NODE_MAXDEPTH) +
>> freesp	 (32GB / free space records per block))
>> frags					/ filesystem block size
>
> I think we ought to do a more careful study of XFS_DA_NODE_MAXDEPTH, but
> it could become more involved than we think.  In the interest of keeping
> this series moving, can we start with a new verifier check that
> (di_nextents < that formula from above) and then refine that based on
> whatever improvements we may or may not come up with for
> XFS_DA_NODE_MAXDEPTH?
>

Are you referring to (dip->di_nextents <= (96GB / blocksize)) check?

-- 
chandan
