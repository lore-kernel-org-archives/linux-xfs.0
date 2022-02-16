Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22FFC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Feb 2022 12:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbiBPMe7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Feb 2022 07:34:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiBPMe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Feb 2022 07:34:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D1F1F8342
        for <linux-xfs@vger.kernel.org>; Wed, 16 Feb 2022 04:34:45 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GCNtUt014562;
        Wed, 16 Feb 2022 12:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xEQ1ned0+9IJe71M4J9ydp445rtOb0+fhOJEsmVqFz8=;
 b=RVtQNsNvTckzmqRoFlFqXL4Dm+iYkmijZGskV1X8HbZYMb+jo0/3yaA+QLIZQM5MSyvc
 acVJ/rwnr/GGxgCMjcaMYypk9U701NEraeGdxh691V/e8l3AEYHbUJ5ErLc99Tp8qb7/
 0EduQO5tfCFRuzwYO9ItCqhCJ5HYpL8Mdv9v+USTNw69IMxII5WIBeuLKOnHYltjbSWS
 zQomfvbb3PUXDeg6mdz5W6Xqhg3HneHp9ojsrE7U5GvtchuV3AbOp+frNHBZkWWA0vmo
 wVxXxgHmBk2y8CJreK869r4B7nOp29m/ZH4inz7wxpmECcvY3tMEIKa3tfiB3r2q5wvg hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nkdht1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 12:34:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GCUXD5063945;
        Wed, 16 Feb 2022 12:34:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3e8ns8wd4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 12:34:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOoQukeK3WLDlMkJaJjVd85H81U27Yxktj1/6yECTOHq4zsZwc2NqQ6he/4KY2wxiVcIwbX7gABv9DyrtfX7ApPmSOiCMf5DD/7tKD3xohk9lTOPsjnEFFdFjo14izNvF+7bqrgdqqcoKvO5ItkU7UMIGsLCdyDzwORVoLRgP/CC5qvyEQUAsBTOPPPFCAa2T22yHjZdvrO57bZjVcJtMIp+ABSOx5cwlPovR9lwb5+1H0E4oDyYWaXZ3G0X/ld8bYHXym2S0/q10NAok5Hjr4tWj2JVkTp36yBPj5FXHn/ERV6ej20xeGx7fC1LWI0q1Ieai3UFsmJk97MzbCar/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEQ1ned0+9IJe71M4J9ydp445rtOb0+fhOJEsmVqFz8=;
 b=ZlwX7AASrudBWTy73JmVAdC/rBlm//ZTkanuaoDy/Ayp5pjJYiXq5GL164OeUNm6Q7P+1akZTMbUCTINQ39VmkqaIRCcsWTjGwgIZPzkhMODdWFbn25m6JgpQ3LGYM4jhAlrtksh0kMiXv0mdUSeOVsp5NJKLd5+ezYpL/RQY5dvlcLVIcsyn+ZeSzeAby2pF4izKL9hSBOMFul2MbFvLxJnXd79uFaGgOu6VxxpE6onLMmgf+K/uhUdPlImzW/0TWrvGGomWRAmqrRLA1+e8YktP7ftGjVjCkJhuaZvjUcTLNYSliMNd+5YHo9NRk9pSMn6cKFntje7HG5MOpuJ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEQ1ned0+9IJe71M4J9ydp445rtOb0+fhOJEsmVqFz8=;
 b=kBWzJKOxGwFqEZC1UodTjFvONP8pTKQIALsDP+XyM5abtrowIttdxqut/MBZGO9IC5EYH1EvZdzB8jEIcjjt7Hn3GzfGYUwUrmlPUeA+PdoC5nc/Wqcd5g6w4UcheIxM42GZSlEo3np68V/HR282gIxkFBxDdT2q80fMR4vlc2g=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2363.namprd10.prod.outlook.com (2603:10b6:4:2c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 16 Feb
 2022 12:34:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 12:34:33 +0000
References: <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
 <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220214170728.GI8313@magnolia>
 <87v8xglj59.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220215093301.GZ59715@dread.disaster.area>
 <87sfskl5z6.fsf@debian-BULLSEYE-live-builder-AMD64>
 <87pmnol17j.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220216011633.GH8338@magnolia>
 <20220216035951.GA59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <20220216035951.GA59715@dread.disaster.area>
Message-ID: <87sfsjhtwx.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 16 Feb 2022 18:04:22 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::34)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa6bcdfa-485d-4f04-a903-08d9f148af18
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2363:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2363EA0A7E3CE8515151A562F6359@DM5PR1001MB2363.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6yiXT68DCJ32eBxy0GEtLAwRRnzwFV6xwFhMn2fsdfDJRNLCY6vBDn9z+lngfie8NxnKc6wWInqdP2mrfWIGi7Mb6MFYUvwwBlFT0iOA9EF1JqXu2wF7nuvlelgCghmIPOwdjd+2Wg5DCFXdt5Z3LiYFybGg4rzZbdebJP4h2o2ouBKcQlbfxgTX5buojGYiqeT9zJXagBY3VZVJl7VR66YdVQk9dpmMTAlJUn5Azk5OpkR5porJoUc2vhsUyQUB83BR+CJV99mSDucTRzvu2Ap6K3+WfJIljFtQ8po3c5UNgGEJNDSZtkFGPgGUw1PqSvfiGR52Dij3Bcr7WPJtFYfyFgxAHPnRsf98ADo157EGkbV77WgHJmEhhGfBoMAO8boLiw81xiDych7+1tfi9IodpFDZdTZnstja7H/n3DWzKoS8rHDxIoSi/3VATPsEACGlDgmdPE/BdxQUtbemHKdP1vVry3I0gZDUOLwoQTdrVjXvbsD2RpqmJFDlV2qoK1idYS6Eh4YlklYSQ1xsrZnPWAHptmDrsW0iqbtHWIz1AexK1u3QJrPEkbCMwXBp11j9ypgMmhBYaduFEg3XW0tTn7ohnPGFvHFG+bNhhgfizsB/M2LZJJVW1qFxqlHgNWSk7aNHBmPWHeu5qOZRj6981HL9c1CEiWT6zM8hTMNb8dYJfxYE99EaN7IwU5sZil0ZIWMCPdkFNADrKlHGTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8676002)(53546011)(2906002)(38350700002)(26005)(186003)(5660300002)(38100700002)(6666004)(52116002)(33716001)(6506007)(9686003)(86362001)(6512007)(6916009)(66946007)(508600001)(66556008)(83380400001)(4326008)(66476007)(8936002)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Go4u6XwTPDOF/W7r3rtK7vCdXEndXVVkMRMxwu0uBP8RSJrQFiGTdXJMsTuo?=
 =?us-ascii?Q?Kd8IjFNBtsU3L4ih4bUKPq9KFVVaFjOLSHBRgZQJZet8+pZ8inrqz5aOb2DT?=
 =?us-ascii?Q?fzVptaxAsaQtKY5bgS5v7N4jfY8xeo+D6cHD8DplitOgSV7m4wPpCqKDpxGv?=
 =?us-ascii?Q?S6BXUZceQjoK1Q9K9OMmOw7K7N4VES/vpSK2Py7Gwn51+ttdHSyg/+grsVWC?=
 =?us-ascii?Q?6WEG2nXx1RmqlQ7Q8TwQndyxLTAUb6Va2ysPpQAPmwTX1LxcrCer8GKM+Ce+?=
 =?us-ascii?Q?WM/lPwm/3VM/0pRuheeco7mDFH6uFHyScvgWgx5N1xVTN+XFdx0Vy2QoZyDz?=
 =?us-ascii?Q?/5OyR7RoNmKrsaLyeDRG2nxM32JBqmttVu18jG/QeiImdrchoTP9sVBU8h5A?=
 =?us-ascii?Q?+qHFOFgagSIwrzg5kd4Ap8WldGzHAu4d4Ul2bh3u4b19YPEMjoudPncY0yc/?=
 =?us-ascii?Q?I3wJnC3Awd/y5urStq05L6XRpgMhs3Ww4kmtEwVctTba2P7iX1s7s8Li1ol6?=
 =?us-ascii?Q?uggM6Som00xK5yoVmmbgfOiNs1UOJ5hlwCURtWHABmd4mEZn3mIBjC71C8ey?=
 =?us-ascii?Q?A9IB9g2J8xDz3J+NbANa+uvLzwDdXtqNTWo7BzujiBzZ/KG+ZedG7s111gLf?=
 =?us-ascii?Q?E8zvPu1oWTqanvM03QqxWcIi/unR+ZfEKR66aYDJQqDl1ZxGUiXutH+aZlNR?=
 =?us-ascii?Q?Yygum35P0vLXqBX0FWwra1e4WIB0x4I+noxdAgbTAQlLzEkkR0z0NFYhq6vm?=
 =?us-ascii?Q?txU0WmvOQ7dPLud8OMaLLzEaSFqB2QWTaB5NoXAN2s6qC+lTcP0lV2gI/kUo?=
 =?us-ascii?Q?VSyaRQ9L9lSoJ41s9f2jY35fhwWtEg6sZjnYI33GgweT19A/DiiY1sJ5yX2u?=
 =?us-ascii?Q?aWPXP0OEJ0o+7yrGiF0qTCflJ49n83Bs5d/MtwoQS2XWyiYHNSKbJ+zMKMRR?=
 =?us-ascii?Q?ZVoSpckojiJlfvV0zPBQTY4DrJBdaK9pPDfCqt5iX0eh0wl0bU4jtuRBXk81?=
 =?us-ascii?Q?Poq5sOwjBtMukBgMYwSaxZ3/TO13Jqfbt6UMVFQHbrbzt/aWEeqM9Yl5A+Y7?=
 =?us-ascii?Q?c/VZgpkwCV5J7MZ8gqAfit1U7ocM1odcy30p9ZWfcmEK5Euu/0XqVxe4B9/6?=
 =?us-ascii?Q?BlwIcyG10J11w81o/+3P7quo8Txs+FZxA1gNFD4tMs8It28Dyg+iFeLCvLWL?=
 =?us-ascii?Q?Kny9N/7lTzzrpVZiNg5F0/hRz5NU6/znADw9jWiSchDr3VyKif5XamHOJ3J1?=
 =?us-ascii?Q?9s4pTZkhkYxXIOfW4JSAcH9Bx//sOe9o8G2PUpmDuQ7qKWFKMKhXclehkCU+?=
 =?us-ascii?Q?GowwwUoQbTg63lGF/74UNczm3FMpuwHDNsEVZG5av8O8lmYlI0gjHZZN9aC+?=
 =?us-ascii?Q?Z3Pl7zruJVVYNY7Uv1EDOPSb2if61BGN0gXz1YI3jKpLhIej6L2f8PjCdBMx?=
 =?us-ascii?Q?7zLodDNxK3CpyrSqXDp65wdof75fbsbSClCYhbPhMiOCm420qANPHayAdvhH?=
 =?us-ascii?Q?au4S0ofHW0sUb4LcV9TlVPzTQeSpvtBA7c5GCESB5iXMhaeFcY9EiSW8H2MF?=
 =?us-ascii?Q?vkHfEVAbESqLKONl6iqHefmNDvf76ALJYJa1zB5VZ24b7nvLBTNC0H9nVJzX?=
 =?us-ascii?Q?UfMOFr13ezE+gkJPc57MkIE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6bcdfa-485d-4f04-a903-08d9f148af18
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 12:34:33.1109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwddMhFHe36JPPVfZWmG0dkw/3C/I22xKwWdFaFa3WzZhC8ictCgLdgV2VOTazg2uJcZccGO60nLwj0epa6hHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2363
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160071
X-Proofpoint-ORIG-GUID: KluKHOKIwtxKnt4Dl1gxkm39DfUkQran
X-Proofpoint-GUID: KluKHOKIwtxKnt4Dl1gxkm39DfUkQran
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Feb 2022 at 09:29, Dave Chinner wrote:
> On Tue, Feb 15, 2022 at 05:16:33PM -0800, Darrick J. Wong wrote:
>> On Tue, Feb 15, 2022 at 06:46:16PM +0530, Chandan Babu R wrote:
>> > On 15 Feb 2022 at 17:03, Chandan Babu R wrote:
>> > > On 15 Feb 2022 at 15:03, Dave Chinner wrote:
>> > >> On Tue, Feb 15, 2022 at 12:18:50PM +0530, Chandan Babu R wrote:
>> > >>> On 14 Feb 2022 at 22:37, Darrick J. Wong wrote:
>> > >>> > On Fri, Feb 11, 2022 at 05:40:30PM +0530, Chandan Babu R wrote:
>> > >>> >> On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
>> > >>> >> > On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
>> > >>> >> >> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
>> > >>> >> >> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
>> > >>> >> >> I went through all the call sites of xfs_iext_count_may_overflow() and I think
>> > >>> >> >> that your suggestion can be implemented.
>> > >>> >> 
>> > >>> >> Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
>> > >>> >> xfs_symlink().
>> > >>> >> 
>> > >>> >> Just after invoking xfs_iext_count_may_overflow(), we execute the following
>> > >>> >> steps,
>> > >>> >> 
>> > >>> >> 1. Allocate inode chunk
>> > >>> >> 2. Initialize inode chunk.
>> > >>> >> 3. Insert record into inobt/finobt.
>> > >>> >> 4. Roll the transaction.
>> > >>> >> 5. Allocate ondisk inode.
>> > >>> >> 6. Add directory inode to transaction.
>> > >>> >> 7. Allocate blocks to store symbolic link path name.
>> > >>> >> 8. Log symlink's inode (data fork contains block mappings).
>> > >>> >> 9. Log data blocks containing symbolic link path name.
>> > >>> >> 10. Add name to directory and log directory's blocks.
>> > >>> >> 11. Log directory inode.
>> > >>> >> 12. Commit transaction.
>> > >>> >> 
>> > >>> >> xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
>> > >>> >> occur before step 1 since xfs_trans_roll would unlock the inode by executing
>> > >>> >> xfs_inode_item_committing().
>> > >>> >> 
>> > >>> >> xfs_create() has a similar flow.
>> > >>> >> 
>> > >>> >> Hence, I think we should retain the current logic of setting
>> > >>> >> XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.
>> > >>> >
>> > >>> > File creation shouldn't ever run into problems with
>> > >>> > xfs_iext_count_may_overflow because (a) only symlinks get created with
>> > >>> > mapped blocks, and never more than two; and (b) we always set NREXT64
>> > >>> > (the inode flag) on new files if NREXT64 (the superblock feature bit) is
>> > >>> > enabled, so a newly created file will never require upgrading.
>> > >>> 
>> > >>> The inode representing the symbolic link being created cannot overflow its
>> > >>> data fork extent count field. However, the inode representing the directory
>> > >>> inside which the symbolic link entry is being created, might overflow its data
>> > >>> fork extent count field.
>> > >>
>> > >> I dont' think that can happen. A directory is limited in size to 3
>> > >> segments of 32GB each. In reality, only the data segment can ever
>> > >> reach 32GB as both the dabtree and free space segments are just
>> > >> compact indexes of the contents of the 32GB data segment.
>> > >>
>> > >> Hence a directory is never likely to reach more than about 40GB of
>> > >> blocks which is nowhere near large enough to overflowing a 32 bit
>> > >> extent count field.
>> > >
>> > > I think you are right.
>> > >
>> > > The maximum file size that can be represented by the data fork extent counter
>> > > in the worst case occurs when all extents are 1 block in size and each block
>> > > is 1k in size.
>> > >
>> > > With 1k byte sized blocks, a file can reach upto,
>> > > 1k * (2^31) = 2048 GB
>> > >
>> > > This is much larger than the asymptotic maximum size of a directory i.e.
>> > > 32GB * 3 = 96GB.
>> 
>> The downside of getting rid of the checks for directories is that we
>> won't be able to use the error injection knob that limits all forks to
>> 10 extents max to see what happens when that part of directory expansion
>> fails.  But if it makes it easier to handle nrext64, then that's
>> probably a good enough reason to forego that.
>
> If you want error injection to do that, add explicit error injection
> to the directory code.

The transaction might already be dirty before entering the directory code
(e.g. xfs_dir_createname()). In this case, an error return from
xfs_iext_count_may_overflow() will cause the filesystem to be shut down.

On the other hand, removing calls to xfs_iext_count_may_overflow() from the
previously listed directory functions would result in the error injection knob
to not work for directories. This would require us to delete xfs/533 test.

Leaving the current invocations of xfs_iext_count_may_overflow() in their
respective locations would mean that they are essentially no-ops for functions
which manipulate directories. However, with functions like xfs_symlink() and
xfs_create(), I wouldn't be able to add the inode to the transaction before
invoking xfs_iext_count_may_overflow() because this leads to inode being
unlocked when rolling the transaction.

Therefore I think we should not change the current code flow w.r.t to
functions associated with directory entry manipulation. i.e.
1. Let xfs_iext_count_may_overflow() continue to be no-op w.r.t directory
   manipulation.
2. Since xfs_iext_count_may_overflow() is a no-op, there is no need to move
   "add inode to transaction" code to occur before invoking
   xfs_iext_count_may_overflow().

>
>> > xfs_bmap_del_extent_real()
>> 
>> Not sure about this one, since it actually /can/ result in more extents.
>
> Yup, unlikely to ever trigger, but still necessary for correctness.
>

-- 
chandan
