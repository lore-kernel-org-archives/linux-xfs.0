Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053C2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Dec 2021 09:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbhLOJUV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 04:20:21 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52520 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236374AbhLOJUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 04:20:20 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BF97jdZ007065;
        Wed, 15 Dec 2021 09:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=YoICHYdzfng9ydhYPFti2NGM0cwIehLPKOfNNJ8Obg0=;
 b=vDUg1yymPKz/0CB5z43V4I5KsOCWG3piUj4Cafr5ZMBDV60s7mGkK3mX/RD3UiSjZ7MV
 hWjahBpDIsg3MpYqc8YK9oMczTTrJoLNjVZXkWQCnXMjO4MrqwQzxJ3/JNC+eDwxpY+p
 wfOIYTNDgqga3W8fTLPcYz+foryGbvzeeM9dsJ2rmed4gz/e2kbSv34t9MG6WgUXVpxl
 x4niVoE9NDEzkI1ZKbrQbgo2kCLRcnHvKNkcf6NF4QWVhs97M95wUzy2/L5hASwcGKYC
 tEoRcHdiFf+wVpHK4t1hS/ogOOX5E63vyJzXpHGnxVrRYatV1EPd9mvwAu+xPBNakry/ Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfe8xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 09:20:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BF9AIOc051307;
        Wed, 15 Dec 2021 09:20:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3030.oracle.com with ESMTP id 3cvh3yv560-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 09:20:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eu6Q2c4vT5SK1EVC2JNLNpaz2bs4sRzwLiNMJSRUzSNurcoai+c7q47N4BbtcuRhufUrRn2oPOndlPgbxHIvZMzsAPCOIvgSRU/8NlVx+8juaRFrbg3KOkzqv296lrVb+oyqN4YLWO9MXphPi3sVgyBOW9d4AW8HhzB3Z5zt4HqwA4fhAuEuHQCI0w0z/h+aL5uqHN3NqfoEtaj9YRlxXf6g1bkC3c05q5FO3cwH6v7hREsP7U2W4r729iAQ0epNltknM4mXDPIhixqonwasqu5YVAAZSIiU0RHd59Hd7eyKhW8LdofrPDLqtj/KuNj25RaVNx4R49sKqU6O1xVm6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoICHYdzfng9ydhYPFti2NGM0cwIehLPKOfNNJ8Obg0=;
 b=WdplrFNlkn0EfoZ22M4YAiALcGkEwK/pau8smM2HIorgf20k9UYB7W8HOOJ+NDEAmYw31tWSMuLPe0itZPrC6cF1yrUT4L2mMXzwzEvFl7dQyFKJAz1S6PY698bdo8RvDzaN7CfsiKzwRWojKsIH7USFdhWuz7TZEz20UHwEH6HEPw1k6Hhw9dud4Gn5R2PThtY9wDZ+vtsDv7jJdKEcvaXybE9HyXfP45KCGeWaMMNc+vKgC9n14VADfVlIJZyVqdvPpUihDQXfYEUhUEkzGN+odxHiesgvlfKkAzqp50OpWZ0FtzOs67M/g1SpVKFHz3oN5pL7k2SUvCZj/FMzDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoICHYdzfng9ydhYPFti2NGM0cwIehLPKOfNNJ8Obg0=;
 b=thy9JEEJfB4ZrFZWtBVQsywfyv5dkXZnoC/E9QA0bJ3qxW4BxYtC5ozgmhpdi4UoKXk7Xoo6Hr+jNFW9WvcBe5T5aFpXysngZP70zAOdjNLzhh/TG8M/vY3OJJcxDhunALIHjeW+7xkuLyqaBDWo6AVhvovgSoxGgJocDB/TQGg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (20.182.117.12) by
 SN4PR10MB5608.namprd10.prod.outlook.com (20.183.99.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Wed, 15 Dec 2021 09:20:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%6]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 09:20:03 +0000
References: <20211214084519.759272-7-chandan.babu@oracle.com>
 <202112142335.O3Nu0vQI-lkp@intel.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     kernel test robot <lkp@intel.com>
Cc:     linux-xfs@vger.kernel.org, kbuild-all@lists.01.org,
        djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 06/16] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
In-reply-to: <202112142335.O3Nu0vQI-lkp@intel.com>
Message-ID: <87a6h22pjf.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 15 Dec 2021 14:49:48 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f84533c2-8a1e-4525-77dd-08d9bfac136a
X-MS-TrafficTypeDiagnostic: SN4PR10MB5608:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB56081517899BF8ED50589C87F6769@SN4PR10MB5608.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uweZu6Xh/JDsElLdX2l9/cb4kPUjR/o4bufAOhc3B8o6sPfqJ2HLfpjqVmPb4nuUC8bmLdksWryvshcLPpMSi4HhaEOO0A16Yu6Dp0DEjShFWblPotDk8CaCetd+PrKkS+d82AWmmTUhT1S24U2XCvQYgxs+Yt3r1xUZUylJsoJjUnPoMMhmCjnXbrZG5SIVs1BskETfrDlKUGKjbIUu/xW/EdMPEdD0RpujkYpXRMMN6wO35FbIBK7K5IJUL3Hq+2QnzSsiNFJhuclpdxuUM/n4rBhfsPv8kRjZHdSh36WstVX5reBzxuX0WwFcfHyyatOWiKfixUJRIbnFMGdpwuC0m0jPn+2GrBSCWRVDLThs4axTk1Ut64h4+/tbbDu7xFwoNzJxK/HcpGvpnjpvGi+R4/Ukc2ECm/r9hosfzwZ2t4BVkgR68IYC09wAP/VTfTDoWkdMm+a/Q8LHVEybCn6pdjKFpqWSOM5Q1CH+01XQBJrZAsqJWGMKj7t0xVDQdH6Yd+D9dUi9Jk1M88rtHWO3JltDXV1zR+GxONl/A1gQdSl78QAaAvHqOKwCzDL1xdOV3eJWezwe9bcNGn3/b/tMKLOMmer6gEPjc3juEViSwdxgN0AsmW40PGTeZX70ge2ERkmepEMv20h8thad3ijAM/uZp+kNIfVNSRU0RvoRKonG9loWtplveMhoIx5TsPsQMV1do+lxmSBsgI9WSx4cDFwllHy6OhANrrBzhwNOiYXNz3fL2j/A8Bhl3R6etzsxloMMt5dK/bGjBU24s1Wf2+adHee7rNgdAEhQr33v8hKBdN6cmFziDSLXcBN5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(508600001)(8676002)(966005)(4326008)(9686003)(186003)(53546011)(66946007)(66556008)(26005)(6512007)(6506007)(316002)(66476007)(86362001)(33716001)(6486002)(2906002)(38350700002)(5660300002)(6916009)(83380400001)(8936002)(6666004)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+y8EdO2F9GAjMDyorsevy/9igG/HoKqAnROMnwswTzM0eNrKMYKmscxU/8Pk?=
 =?us-ascii?Q?DUb6s2F32twrPrZVRKVEevZr88AiUUHOL9xEQDjB1SQg3kYpypqfjnykWhRO?=
 =?us-ascii?Q?7+CNkKZmOs0v8+beljGcpy/RXId5ut5FRI3CAaviWz32gpX1iRBo3zEbQMgO?=
 =?us-ascii?Q?IrrDDsMgWr1tvWzKX/+ODAcR6rAcQtstjIApFC0t8H+0WbEgT4pReXPdKQMm?=
 =?us-ascii?Q?pLOsuMZwnDU6EnldMlE+ARQNFEC7MtKgjxKGYIsbey7HSJJaskkWplwcXlkJ?=
 =?us-ascii?Q?t7yRj5k18l14PUDS6qOIGQV9gCrUkGD+c5u/gaHAR6p+ITajpKhjQ6WrLaeY?=
 =?us-ascii?Q?RvPsZoLGvGOi8axzZSmnXTFkaXAwNnBxCpd+GkCTqJsOmRYdKMQjW38HSH/0?=
 =?us-ascii?Q?ZC2aTJjmIYkFHL3avD3bOism3MlOcSc7TI8/rc8+nwzqSBbFM3XzUT6q70wk?=
 =?us-ascii?Q?2DV0an2KWb7n7ibZo9JTXLgFasvxAQBTeZHmXltrv+Ox3s7crrBdEZXBNJHP?=
 =?us-ascii?Q?0oDxK32vOcx2etfJWokcMDftkSAHJqRzep97PBBZvSz6jUDjioJUGdCahItB?=
 =?us-ascii?Q?roOZWQOmtHH7JXRaJJfg7AnYDqYM5E4uknHEhO24NqcDl7wi/CPGpyD+LK0l?=
 =?us-ascii?Q?h31hRB7JGl4SNwjmlMzx7UJrVmRhHvHTXG4ZlQt9Sy3q422C9yZZVQBmnBAN?=
 =?us-ascii?Q?VNJJljHCHntbpnCbqY1dCmKH/QlbL1EqW5Y3wfgJAlAPewjXVvwVfwx04nhO?=
 =?us-ascii?Q?9Xx1CZzm/7O/OjY29X9Woqfy3WuFpxsgyKwdkRjgSF7jazQf8kjqlToCBUA/?=
 =?us-ascii?Q?OqKVvYJ2kCFjeIapZZ7q+BhKuXYE+Sor8ANUDZUOprMshaGVc+ih51waZJBa?=
 =?us-ascii?Q?gGHha/dNDCN0c6pBzgsvXzClJiGpuR7npIHPFUYurf0NWj63/zKsJ3qMtmoA?=
 =?us-ascii?Q?QFPh2P6jXioKFJvZhqcpmpZaRv0WwmOzVpa5gksd8rMdoYHE9AmpBA4p5SrY?=
 =?us-ascii?Q?t6/J+QnrJGqqlcTaUsNr02uJT8EiG4kP5aolFwj442xAZcJJOmZ+XcnFSXqs?=
 =?us-ascii?Q?duW8ZR3XA4gMygijCDuFGM+nDQkmeONor6RAOrpYyzjNwKjNmyP5i9gQOTCl?=
 =?us-ascii?Q?anfX5qgHg3pQ7llUklVGCKk3I+cBCCmW+UFt84iBI/1JsNqnPHz2KLBy5N0E?=
 =?us-ascii?Q?l7kXrdfIYkZHYoxH5IePdTnLBxIUSIlmTyij0+jaOfeRculUZgbGzAZ/anjA?=
 =?us-ascii?Q?kUDtsCLMYfukYguuf3SpcyaOPfWomSLBUyr4xCnF+XdyZ45xC+0W/jYQcodQ?=
 =?us-ascii?Q?tL6lG1a7zzJBh8w6+ZX+NyKLnWQ1xtoNHROOHMkYuHIEt2qGwv2YWaq9lwGq?=
 =?us-ascii?Q?zMPW0JGsU15qIsJMxan6jZdBMN7uC6SSFgDs9Ne+GkluvKRcSEwOA57vwLvp?=
 =?us-ascii?Q?wxRjarapeTskaiS1i/xwciaOP1LXsBIi5UdEVA00zL4HAomqxhHq/HMkCg3W?=
 =?us-ascii?Q?wn/ubiRgZYKo9i78iS7RqRDc49LpDCFEvf+jpwzKdB6/OVJtThjhc7gU8nlw?=
 =?us-ascii?Q?Ycu32yl3eRPHLQaMTdROv5kuvYiR+Bhun0mXq3Tr5ry+XUg4zIcUaznbHP1E?=
 =?us-ascii?Q?GujzU0DEz+Hio0pYSM2PzWw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84533c2-8a1e-4525-77dd-08d9bfac136a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 09:20:03.4095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFA0UNiOelB61jt9AGM/CpSPviFLo0Em0LZobFOVk0oevnOVTGbH7jILPKvPu40mDliOAM/mqtXknF4kXWCqKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5608
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10198 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112150051
X-Proofpoint-ORIG-GUID: 8IQo9RuvHMt8N11eFEH_JJ5xRFSu10GI
X-Proofpoint-GUID: 8IQo9RuvHMt8N11eFEH_JJ5xRFSu10GI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 14 Dec 2021 at 20:45, kernel test robot wrote:
> Hi Chandan,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on xfs-linux/for-next]
> [also build test ERROR on v5.16-rc5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
> base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> config: microblaze-randconfig-r016-20211214 (https://download.01.org/0day-ci/archive/20211214/202112142335.O3Nu0vQI-lkp@intel.com/config)
> compiler: microblaze-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/db28da144803c4262c0d8622d736a7d20952ef6b
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Chandan-Babu-R/xfs-Extend-per-inode-extent-counters/20211214-164920
>         git checkout db28da144803c4262c0d8622d736a7d20952ef6b
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=microblaze SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    microblaze-linux-ld: fs/xfs/libxfs/xfs_bmap.o: in function `xfs_bmap_compute_maxlevels':
>>> (.text+0x10cc0): undefined reference to `__udivdi3'
>

The fix for the compilation error on 32-bit systems involved invoking do_div()
instead of using the regular division operator. I will include the fix in the
next version of the patchset.

-- 
chandan
