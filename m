Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34601C77B6C
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 10:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDMKZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 06:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjDMKZw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 06:25:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B105F19A3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 03:25:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33D6XuwJ006227;
        Thu, 13 Apr 2023 10:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=uIuSxydEPxg9QNd2umVEuy7lyCat1wt46uapDCBUtZw=;
 b=3O8l3dnQPR/t5PbxCPGtCMGu/+NV30rll4C5qfNWdZzEccojp4tA//grcPMR4RgFIBzL
 /hm7ccLgv1/IvG9zAaApfKmgw+fulhbRV8xH8wD/hYFe7/i43VcQt8CvdV2UC9vciF96
 iuTD8e+OlD8sVxFclCG7i8Qv5qQRdjfAFgvKEyIXYwZUMOhkBrcT17bskDERAT6Fh2We
 bqavPxqANyP5px5CIifMnXkadFpko6Vksj1HArHGfsl0YebJ/M1F8k5DqGxL0NjfRXrz
 8jqOyhDQpm4MV/SIEHnjvgH0tAxhVfv48SzfQNafLqshQAw2w2ss8P7aRIMO7aRXeaRm Bw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7jg00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 10:25:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33D9sAHW025058;
        Thu, 13 Apr 2023 10:25:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwds9gep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 10:25:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ha8Ty4ufm/LiOCKgH4U4656v1yVQmAVguRGz8l5dsuDldhYw+Fy42e8J197+/OsiABg3fQWq6MbDS/fkiZNCm2pnqZSQWfngbhidiukQ9CBrLtKOcqeEfGU6GSepncDH71AVY3V3fog6eviQ9WZiEE9DhwjYDsY+Mi6qOv35r0DFneC4ROFLg3YbdRoGInwrY9gm8d//cqxemv19JgLV6KUDLDyyUeWF5HtN0WtbNp4pebphze2mMeV2VczxOr6hVTKgeLZY8jeaI2pxkCWRMncNOvrbrdkQl39X6XqvSU2g5QDBLleduX83p0rv1AhgqQuOTW7r1ovsVsx1gm07Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIuSxydEPxg9QNd2umVEuy7lyCat1wt46uapDCBUtZw=;
 b=Xgca3UThPwOPCUsKwHAqlZUIjUI7e5jYdiQ0dW8pqgetviWb6nKIKAhwXQLPXWsZeb45XcqDnDY8d/vDPHIBo0QxiNrGIKrKlH1yUd+EzK84RrpVj0cm6J/c7ak4WfcKtTsZfacuhwKIxOnPMQF8MTHEz4zBMHQK5Xu35vFFSqAIudi/YiyZjTHPSg/2WEcf8OHi/S36OzB08lQ8fSwkc1mBnKLGqvho2pKA4K1864bVpF8berl1NU31CAUEhSw9c4muhQB8RVcx8hNidk3ATrrlnHXL3p+3w8uLK5fsAjxhiSbQWlSC0Lb4rWHeDnl5/GIlHjboGj/vbUSDbX9SUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIuSxydEPxg9QNd2umVEuy7lyCat1wt46uapDCBUtZw=;
 b=fF7whtWVE0HbTIgn04wvENWWm839vVGu7v3PLaggQxCcOTiDLVHpoMQfF6lGzLjuNuZqGSA6tC3FUJYfulHfSBte4+g3L8tlv6o0DD1Mi1jxvjOA11EdtUepWzbMZk6RYjs4ScVyTfV+ah9sIin/SNgdUcZV5kVVq5wSexJSjDU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CY8PR10MB6491.namprd10.prod.outlook.com (2603:10b6:930:5d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 10:25:45 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 10:25:45 +0000
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
 <20230411020624.GY3223426@dread.disaster.area>
 <87mt3djwj9.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230412235915.GN3223426@dread.disaster.area>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Date:   Thu, 13 Apr 2023 15:46:38 +0530
In-reply-to: <20230412235915.GN3223426@dread.disaster.area>
Message-ID: <87sfd4jcyn.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:194::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CY8PR10MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c0d6aa-6ab0-4c3c-967d-08db3c0970bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTrbQ91ivW/JGpgpAXflL64RjVapx8C4EZx++suT1CBDCafDVn+gWzbzOjaVN955g+ar+6AcbQDKGYSnHCt4VjDbbVPRsqJkQzYcKK+T21eOk1NpanCNHtpVblxRLcCQcLM4OesELU4Hg0kxoj1gtm2MEIVWL8DfJzy1rHCFMXwk8ZL9FwDz5OQXBWQOTdvPZK5Q4OS+MjW+kDiTRvMs2j9G4yo0WOIOhyKtO4Et4luMWMBqoIWs00wY7E5RCwdikbhtv8SA0D5c6KzGvi86miyPnYvUJ66Xu/Lpklm35TgQ0jgw6YQUJKSB0HBvXYwIJLkIZeoKmcspmc8RXvqH3w+Qq9tImqFluWPK8jJKy+zgbXVKQ99VyoNg+aqYa2G2hvgtJ7RPeSpwOpdq7r4gfOqksfodfuCoFSzAQuYlkZX6TD/pJ91+ciY2HFPPUCcpf1L2ljEyvAV1fT7K+Kd1YeDVZlXEU1803pc/YywqtefbfFu/dyyf/3OsbbHKhyVIrSQ8JPVvA1T2cWT331lWCxHyycN7gMVuajKoYBF5eWL7C2LnyORiTIXJvHGDESZJocwdMQATzT9EZQta91e4W0mTjLloCAQAEBN/UzZXDsY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199021)(33716001)(26005)(9686003)(6506007)(83380400001)(186003)(6512007)(53546011)(2906002)(86362001)(5660300002)(966005)(6486002)(38100700002)(8676002)(8936002)(6666004)(478600001)(41300700001)(316002)(66946007)(4326008)(6916009)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zHv9AlUpRYzBOt6ldcebXXdAWKOFooAW3i5lb77Hi4iwEskbAgAwm+pkmpbI?=
 =?us-ascii?Q?iqTvhZcmw3UdkchsCxkypsXrUi81BXSz4CZSbfYolADlwDijv9CfOnE/Fuq3?=
 =?us-ascii?Q?lS04PFEy/rpWs2HovIewnMoBVFDjqPOxuQ3mH1iH01ZbQ+P0XB5n20X+vMrg?=
 =?us-ascii?Q?2mq7i1UkVUWX5lwScY8HBFsO1W59wNLwdGN5NgCZU71Bg2HCewq244DHUBqY?=
 =?us-ascii?Q?pEIIwQyV1QZg2AVde2F6yLfMS0BEfk8ytuwP8yXrW1lCyTn7fdqklL7MXp1z?=
 =?us-ascii?Q?yyy4jmyRFaSU5LP272pJIyiWyIz7n0xzVxScSjhnU1S/22BpI+iwD0DxOD49?=
 =?us-ascii?Q?F2Uc4Bb2dV4jyJKMZlSpNRYoSC8cXiqUm9X4hH3ohPSw62typDU9awQd36E5?=
 =?us-ascii?Q?t1i+BncDe0ydhxR3joZUi8AthBrYzARASnJdIKegndT8uIzGBGGhFKPe4YSL?=
 =?us-ascii?Q?Q6xlDA0SP0OMZmDMH5IVbjfMayKFEYyHy0wZNPm/437qvO9BxWlkd4C9aNFk?=
 =?us-ascii?Q?Pc4iRrvhlmheBsip64WQvsn1mMqghjhi04/+tOssVFaCiWxQUHe53uHOMjpZ?=
 =?us-ascii?Q?i3WG3EuVfQv92PZlpU87lD6oWIAJ4zXlQ5pU3+FjluQ4Z6W8F/Oe+wkOeiMO?=
 =?us-ascii?Q?7ADimWp2JCNoLHpo+VIDMYXKlKiWmmFIU0GKqhJKJdDluecsphD0ldUQOyNj?=
 =?us-ascii?Q?EgMH8Zb8dZU8K3NPmU1jZkw+6qQJqFITKEf/yrgR8Xfk9DOAJMOhMm9nHkcb?=
 =?us-ascii?Q?4tH387DgkkPh/aEG1S8qlAyDQugbrsObsejhNYhd2ttuwMUvbL2esfnNfAhV?=
 =?us-ascii?Q?l3sfn1i2wnsyPvSabDJ18hlyieTcEldosk/8O7CPVQOyRichy7qqNpwJw0Xq?=
 =?us-ascii?Q?Hm5AP7nDDU8NTOO5SFs9vD2Z42Mu1HSlyqL/TnwgKdesrJAaXDjnNCOoUpps?=
 =?us-ascii?Q?IwRYLMWZWFjPKkRMCXiu+opV6d34pBbSJ0wykTcPNz4b4pZjOeNCcUDvPTkS?=
 =?us-ascii?Q?pgaXfUQfAH0CaprGjs5QtYrTN0RBDe2S/xzJf3QMNnWYk/DwO/t+lcPbCUbS?=
 =?us-ascii?Q?4r4TxEbIc7MKFFWqIXIm82njW4mi/6UC5v9TnY740pmDcw6pkZvjOszndLdJ?=
 =?us-ascii?Q?UshwwXU/kAGixAbhIIolLkH2BlnOrCtabRxYfxYFVdZ2iWkJd20XOYM2KbKc?=
 =?us-ascii?Q?oiCvC9I1QvUP6wdFja6DcwxDSRcHxXz7a0cZ0Ero5QwraMnLfNwklZmdRCgq?=
 =?us-ascii?Q?1riac0N7mBT/1f2vw+ah29B8hE3vWswMX2L0OXuEqIs1ujf+cDPOpfmrCGBU?=
 =?us-ascii?Q?iPaZ4DR6od9sy9FHLLGfmml7PVMTjHcOn2usKZNFW3bBJBsiTgMXy5qIlM5k?=
 =?us-ascii?Q?xQYgJ59mhwMspNxamSGkhWJfA2obgmXeir0H7x08rPiStfSEKVCOOovRuv1m?=
 =?us-ascii?Q?nR4mnWj7e2vLG06k4DbMatIJ1cVtE9tiT95ctDhbZ0z18aF8tcrgvh8GDHCB?=
 =?us-ascii?Q?lKnr2smwNzA02rmGlefAxzEcOC/WAlxfF4Tb0GaaKZg67rio6eGV2sqT1mer?=
 =?us-ascii?Q?wQlo9trvg0LznxqUm5qzCTx8hHWKY663uX94gKsH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2n0uDEBKefd87cSVu4fP1IhSDS2P8/10Tylh9cHDiln6gJjxD0iieqRpkYDYsAtRJQa2lnvFHUF+aRUBgPom4fNANfWdHq1TdlzNq/GrTZ41fJOSUn/zek/0hq7Cv8bP5qneVPYXYAzoq6Z8DjmHBpT6EbOB8vx8aY/ZoSq/n9VMHcY7jVgMjeqgIw6h0xmkMGF3snfNY4NTlEiWppDQhyPit3lpZd/xi9LRPn0jMFEyFMGLJT0rsY9WSPtQsZRIqdGDG7shJuxWtIwYHq9rH5I4dfIH/VP47vPIsDBVERQ3aBftD88m9rmh4Qle9+dc4kg5hSRmVaBN8koqfF9p13S+pzxDaMT+qJHbYayGKaYNr9gzYDnKcXDLcHw2n8IKSvA5FEkjwRlwuVuYclzDgZWgQgSg9eqMZOT1VxHS96Nop8PMb/vUzhbe4YiMcCCNcU524Qp1ZzA5IF6JGE3g63+/EFAOFjEg1o8srJfW+Tb5rPTxC82sCXn9+4Eog10gb3KLnWeLOUPD3I5kCHkEkZIlh8l4pG4zpmamPDjt8nzRh+jRFA99E8ncrg8Y0dlHiegsPD2O23VwmC/hnJxaHF8seTuLuBbyJ0VpjAGqOpZkh/mhe7HoRVJUjzjn3wllbcveXkln71DSSp+/Eyeg+31xXvNZi2Iy1ypCZcXyhGDKf2ERsCTLQYyPVaiftzg55rRwjKjypSj5eA/wtFHgCs7WtNr+KiBF5JVfi1CZt1tr9z68+iV9nTz3fHcLJpVUqXM+t+thr5nyBt/UQBFek2xCD1kjlU+v5bg19bexu8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c0d6aa-6ab0-4c3c-967d-08db3c0970bc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:25:45.0314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZsxEsffibQIUZKd9ppZZ31aDNgey4PHXoLHjkrZUnU/jJPLSIBfM+Dn4or7Q7f4HAEQZgJ0ObPVQe86fs0DqNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_06,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130094
X-Proofpoint-ORIG-GUID: 89oczaLEBFHc56Or1suY0tpF6BnrSQZq
X-Proofpoint-GUID: 89oczaLEBFHc56Or1suY0tpF6BnrSQZq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 09:59:15 AM +1000, Dave Chinner wrote:
> On Wed, Apr 12, 2023 at 01:53:59PM +0530, Chandan Babu R wrote:
>> On Tue, Apr 11, 2023 at 12:06:24 PM +1000, Dave Chinner wrote:
>> > On Thu, Mar 30, 2023 at 01:46:10PM -0700, Wengang Wang wrote:
>> >> There is deadlock with calltrace on process 10133:
>> >> 
>> >> PID 10133 not sceduled for 4403385ms (was on CPU[10])
>> >> 	#0	context_switch() kernel/sched/core.c:3881
>> >> 	#1	__schedule() kernel/sched/core.c:5111
>> >> 	#2	schedule() kernel/sched/core.c:5186
>> >> 	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
>> >> 	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
>> >> 	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
>> >> 	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
>> >> 	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
>> >> 	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
>> >> 	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
>> >> 	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
>> >> 	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
>> >> 	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
>> >> 	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
>> >> 	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
>> >> 	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
>> >> 	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
>> >> 	#17	mount_bdev() fs/super.c:1417
>> >> 	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
>> >> 	#19	legacy_get_tree() fs/fs_context.c:647
>> >> 	#20	vfs_get_tree() fs/super.c:1547
>> >> 	#21	do_new_mount() fs/namespace.c:2843
>> >> 	#22	do_mount() fs/namespace.c:3163
>> >> 	#23	ksys_mount() fs/namespace.c:3372
>> >> 	#24	__do_sys_mount() fs/namespace.c:3386
>> >> 	#25	__se_sys_mount() fs/namespace.c:3383
>> >> 	#26	__x64_sys_mount() fs/namespace.c:3383
>> >> 	#27	do_syscall_64() arch/x86/entry/common.c:296
>> >> 	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
>> >> 
>> >> It's waiting xfs_perag.pagb_gen to increase (busy extent clearing happen).
>> >> From the vmcore, it's waiting on AG 1. And the ONLY busy extent for AG 1 is
>> >> with the transaction (in xfs_trans.t_busy) for process 10133. That busy extent
>> >> is created in a previous EFI with the same transaction. Process 10133 is
>> >> waiting, it has no change to commit that that transaction. So busy extent
>> >> clearing can't happen and pagb_gen remain unchanged. So dead lock formed.
>> >
>> > We've talked about this "busy extent in transaction" issue before:
>> >
>> > https://lore.kernel.org/linux-xfs/20210428065152.77280-1-chandanrlinux@gmail.com/
>> >
>> > and we were closing in on a practical solution before it went silent.
>> >
>> > I'm not sure if there's a different fix we can apply here - maybe
>> > free one extent per transaction instead of all the extents in an EFI
>> > in one transaction and relog the EFD at the end of each extent free
>> > transaction roll?
>> >
>> 
>> Consider the case of executing a truncate operation which involves freeing two
>> file extents on a filesystem which has refcount feature enabled.
>> 
>> xfs_refcount_decrease_extent() will be invoked twice and hence
>> XFS_DEFER_OPS_TYPE_REFCOUNT will have two "struct xfs_refcount_intent"
>> associated with it.
>
> Yes, that's exactly the same issue as processing multiple extents
> in a single EFI intent.
>
> The same solution applies.
>
> The design the intent/intent done infrastructure allows intents to
> be logged repeatedly to indicate ongoing partial completion of the
> original intent. The runtime deferred work completion does this (see
> xfs_defer_finish_one() and handling the -EAGAIN return value).
>
> Indeed, we have a requeue mechanism in xfs_cui_item_recover() -
> look at what 'requeue_only' does. It stops processing the extents in
> the intent and instead relogs them as deferred operations to be
> processed in a later transaction context. IOWs, we can avoid
> processing multiple extent frees in a single transaction with just a
> small logic change to the recovery code to ensure it always requeues
> after the first extent is processed.
>
> Looking at recovery of intents:
>
> BUIs only ever have one extent in them, so no change needed there.
> CUIs can be requeued already, just need to update the loop.
>
> RUIs will process all extents in a single transaction, so it needs
> to be updated to relog and defer after the first extent is freed.
>
> EFIs will process all extents in a single transaction, so it needs
> to be updated to relog and defer after the first extent is freed.
>
> ATTRI already do the right thing w.r.t. deferring updates to new
> transaction contexts. No change needed.
>
> IOWs, the number of extents in a given intent is largely irrelevant
> as we can process them one extent at a time in recovery if we
> actually need to just by relogging new intents as deferred work.
>
>> Processing each of the "struct xfs_refcount_intent" can cause two refcount
>> btree blocks to be freed:
>> - A high level transacation will invoke xfs_refcountbt_free_block() twice.
>> - The first invocation adds an extent entry to the transaction's busy extent
>>   list. The second invocation can find the previously freed busy extent and
>>   hence wait indefinitely for the busy extent to be flushed.
>> 
>> Also, processing a single "struct xfs_refcount_intent" can require the leaf
>> block and its immediate parent block to be freed.  The leaf block is added to
>> the transaction's busy list. Freeing the parent block can result in the task
>> waiting for the busy extent (present in the high level transaction) to be
>> flushed.
>
> Yes, it probably can, but this is a different problem - this is an
> internal btree update issue, not a "free multiple user extents in a
> single transaction that may only have a reservation large enough
> for a single user extent modification".
>
> So, lets think about why the allocator might try to reuse a busy
> extent on the next extent internal btree free operation in the
> transaction.  The only way that I can see that happening is if the
> AGFL needs refilling, and the only way the allocator should get
> stuck in this way is if there are no other free extents in the AG.

If the first extent that was freed by the transaction (and hence also marked
busy) happens to be the first among several other non-busy free extents found
during AGFL allocation, the task will get blocked waiting for the busy extent
flush to complete. However, this can be solved if xfs_alloc_ag_vextent_size()
is modified to traverse the rest of the free space btree to find other
non-busy extents. Busy extents can be flushed only as a last resort when
non-busy extents cannot be found.

>
> It then follows that if there are no other free extents in the AG,
> then we don't need to refill the AGFL, because freeing an extent in
> an empty AG will never cause the free space btrees to grow. In which
> case, we should not ever need to allocate from an extent that was
> previously freed in this specific transaction.
>
> We should also have XFS_ALLOC_FLAG_FREEING set, and this allows the
> AGFL refill to abort without error if there are no free blocks
> available because it's not necessary in this case.  If we can't find
> a non-busy extent after flushing on an AGFL fill for a
> XFS_ALLOC_FLAG_FREEING operation, we should just abort the freelist
> refill and allow the extent free operation to continue.
>

I tried in vain to figure out a correct way to perform non-blocking busy
extent flush. If it involves using a timeout mechanism, then I don't know as
to what constitues a good timeout value. Please let me know if you have any
suggestions to this end.

> Hence a second free operation in a single transaction in the same AG
> (i.e. pretty much any multi-level btree merge operation) should
> always succeed at ENOSPC regardless of how many busy extents there
> are in the current transaction - we should never need to refill the
> AGFL for these operations when the only free space in the AG is
> space that has been freed by the transaction doing the freeing....

-- 
chandan
