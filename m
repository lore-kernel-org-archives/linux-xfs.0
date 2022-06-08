Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C0BCCA47B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 09:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiFHJmk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbiFHJm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 05:42:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59B41B75BE;
        Wed,  8 Jun 2022 02:09:31 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2586Ba8r006530;
        Wed, 8 Jun 2022 09:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6Md+D4mNTMtsuhL7UCKXmrap3vya1RDWDLDboAgQLvU=;
 b=e5dG60pZvmUpyBlHdmh5+6D42BWFaY75+qv17n9kUb9NFi0/EK9HCTuLvXyIn4gntDtM
 tQyF0f4EUZ05ayGdKbDzcB+0YybFe1L0HVmC6akLCeuBL9wbX6gCPye04dx53V2fmalF
 26h8peST/QMVBUX7Fa0E3dyP+x1CKXmjJnFMhh49CpgGVc0ESF3naB5jDrx/X6ImpFvf
 N2yK2AeGZyLl4tqb0yayAY+vKPh6jLlJ+y9OpX5D0Chqu2BTEw687GztkAsJ+Krr8e8b
 jMqnC1/TNo9R6pWMfFRDUBreDppEnFRZAwJj5qddkG1uxzyd+AYNixil0pF6xw3YAuiq tQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghexedb73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 09:09:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 258900iS026459;
        Wed, 8 Jun 2022 09:09:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu3fa3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 09:09:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJl/PQirJsD/xt0JTHfygzhHSR8P0t3SoujVu36QQql9NAdAtlXVlt69WuV1Yr3lkj71/k5dzASy1xqmZLwMlBIbWyPmLmrxAqXTpFtJQbcJ7J1UPqeT6MAZQVB7RgpzvcWqVmI4UFFqvz0ielp4rHdmBppXAyXp+xzRXSSse33ju8H2k3hOlzV5O6vE3Y4o6nbReoBLenllAVbeF3r8XLvuxX9JH0ReaB5mIMJqvxQCO1bD37Dir2M5CctGRS4XFkk/x1Eq3mbcvKFTCYxWJ7dlANt16y6VYR14wj9CacQhUdPdbsYXx+RPY5cF81SwLP5RlTDiiJ6MElgeAL37TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Md+D4mNTMtsuhL7UCKXmrap3vya1RDWDLDboAgQLvU=;
 b=njGojc7KW5DcTgZpZCmXoUIag/O8MEyPjagNaY6ylCXFe4bZPLmcfemOZLVcURCP+eYbQBy5eO44qMUwbUx1yLZKDRDokrBfiXrKJBy1HIJDOzoMlT/kdPWpNjP3MAX5OYhTsevfGOU/lQLfn2UywqUyEpxuB0sPuDDUPIOBpbZtBkU8pWD5SrmN6x4/Uv7TkpXjJ0xTCQnnRpjAKciY0sHamWjb1G8HFO1iEdPQFaOv7aXcOU3FHER5XTczP2vLZ42Pv57WzHf/6D+AyugQvM55K9hsLfvpjtn+tFs18wxWz2dq6yHCG8D41P3wKD/QminGir9S+9Sa+VViXXdv7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Md+D4mNTMtsuhL7UCKXmrap3vya1RDWDLDboAgQLvU=;
 b=xKmmJUjIX383dVZ5+fyAoMC/W6lvW0r1kSZkfXJSmyaw+HCexQWErncTSUigtWnGkj8CxnVkXWDsgt9BV/dkRvXj+t6mLIimhjnTKuEXBXz6+pG4mwDLw3cwqC3Iihx+cxgnf+GOg9h56yxRJDi09ciJOVr/zNB2mc3r6qXHuWQ=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (20.182.117.12) by
 BN0PR10MB5095.namprd10.prod.outlook.com (13.101.138.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Wed, 8 Jun 2022 09:09:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 09:09:24 +0000
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-3-chandan.babu@oracle.com>
 <20220607230150.GQ1098723@dread.disaster.area>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] common/xfs: Add helper to check if nrext64 option
 is supported
Date:   Wed, 08 Jun 2022 13:45:27 +0530
In-reply-to: <20220607230150.GQ1098723@dread.disaster.area>
Message-ID: <87tu8vfrnm.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0020.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::19) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92e53d34-593c-4799-2bb1-08da492e94d8
X-MS-TrafficTypeDiagnostic: BN0PR10MB5095:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB50954AE858C54A8573446C14F6A49@BN0PR10MB5095.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QBbpsQYRsSPJ7hCCYNJ+0ecohY3WakAQbcA45xN9xZKUMD7Ia5QppV4uvCHt2XewevpMIoLKmTg6L5oA/YoA1nFfi2Os5zVcQLYhKCMlnC5hiqFp6lD3vy9EcuLA2Aj5eEiWX4M/2Dl70r+Ixl33j0W3QDSQ2eDbReksRg8MyEkuakIRLl4ysP9Ax1hgKX6u9Ew2YZ8nsHSp2X7+T+qSvmz1EfRcRgCO8so7i709/LPazt2aQJKjbS6MZqFNPpsBozpCET6adIkf0Eal9tYqV07uJFGSxZhKgO3oo8wCA40r/l8AXOr1f0mHV0+qW4e6dQyOZ3YJ/Lxhjgun7I+DE/AwZAvb10SPmK7xoYLSLjm/SmaURyNLJ/l88qFU1QmZpGSVIrTxPF/cE5lv6C0WEjZelSyZiTY/dHBPj1XGo9/vri7jQWjXV6zV3C6HP7mp6YKpUDYv3NP/z6eu370myEFwdvSUlken5ZPviA8oTmvmrtgMucNhUJuNaDoteEWKuW+4Hxl7dkHD4jAHj3pOEJR3nMHWi6b5LbYiESO8XZx07fHWovgCju/kBJSkm7CJ16M3ipzYag8XQIuq7Wbvj/wLnSlNT2VNYsWO0Q4n3ujDpnr4qMvQPyjSgUfHUZpW2PCrCC1gTG2zhSHbSQs44HshJWF/mDNlm/oxuzlz7Q78XorKNosdfi1cYflXp38rOmtaDKAMrVreWRBnUN4gBGqW2tbJdRbKRh8WF80+eQk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(8676002)(8936002)(4326008)(5660300002)(66476007)(38350700002)(66556008)(66946007)(83380400001)(86362001)(26005)(38100700002)(33716001)(508600001)(6486002)(6916009)(52116002)(53546011)(6512007)(6506007)(9686003)(316002)(186003)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3qBU9pHWsFq0zDPliCQ4c/9VAPdTc5T+7OMbQKvrygwqUV4OsdDmxdL/wTpE?=
 =?us-ascii?Q?rpHcu+uv5AemheuWL5pwC0KOS/65JQb4tKQotmfzGufzU5nNGEztUy6t9/rh?=
 =?us-ascii?Q?ZHaCqNJF/W5Xl/3nW3pitCKtDEAODNT+wdRY7HVM7fP+r5Tc+lgfGed4RfAC?=
 =?us-ascii?Q?7wAVO/EwF9SxjMoI2283DByWABaa448ymGQhpag7AglqGjvJNbCSvpf5M+Cu?=
 =?us-ascii?Q?ErgRB3lrx9su+gi2Yk4os5LNtCFi8OQJAgT037qAxyvKqLRZ1xPYj98vYrxg?=
 =?us-ascii?Q?AiMyX/ltck99VB8FLaaa5LUPNRDhsluptNWYv/b84pzW4FC9s0n8wSyPFSYi?=
 =?us-ascii?Q?0pIFgcdp4ats43y1GTIhEVbkac+J1PJCeP5zdIZWl6Nsgs0Wm1eKsw2jhltf?=
 =?us-ascii?Q?UHpJLwu2f/vmRjyHxUWpMIeQKm2OJB1k6KI+8RRe+hfQCQXqsiK9PeXu+n/F?=
 =?us-ascii?Q?zpI8S4abpqaaJZlhOhY4SVhpIydDHcLoHm9CUScVJcNRLJGQSaoTzwBhvJm1?=
 =?us-ascii?Q?b1tIuZ/eqgCh4ypJyL3suEflaSNMIjB+DiQd8KIR6LxsmPkv/c8NwOGXCQ9c?=
 =?us-ascii?Q?V0rspHM+4pCG9MPHnBNEOFYEtusM8iau6PRvuRlIVxetacuW0pkOedOD9Nva?=
 =?us-ascii?Q?HSHInkto0hDre+0C2QWFzoMojm6zYT4s1QPOQ1dt5LrUXFIpBfWT4Hh6oSuP?=
 =?us-ascii?Q?u2hQRv4O/3CGSVOx9nUhMTwBVDsFcbbkckSzR614AwUv4ELHxHkQPzIPzNon?=
 =?us-ascii?Q?4B8XEVHq+qYs+Cbqs6XEUL/p5VRmnA10i9ZMBiqTHmxF4sCDbw7QUj8rCiJ3?=
 =?us-ascii?Q?yi1NGDaawTVOrbKKD44I1RH0goVaN7QJsZ2A/2pZwpLks/WQAL58geXipooT?=
 =?us-ascii?Q?eb2tIjdDk4hzzGnEBcTGWgSKLxRwr4GTXXV735Ep6DECDB9p0Y7BTxuA/JcM?=
 =?us-ascii?Q?BGJj6pxxmMFiXWRVisKRhG8S9Weyqio/XyUMDixYF+tg64BK9BCn4c4o66hs?=
 =?us-ascii?Q?Xfx99+EXm0Y3Omf/XfVWuKI0zAtSx785HjlgIlrdJjFoakc2YH0JwRqcvXGb?=
 =?us-ascii?Q?wIs0QO959KvX+XDPWPRSoBYDEoiQB+nlaLMGiMkl2DRm2KwggINgEj2RiRl4?=
 =?us-ascii?Q?1ZGQopsWVCSvCe6xoRX9t6BYtppsFwYdv7pgyyqvTccwdlA31KVZIM7v9dTd?=
 =?us-ascii?Q?9rXur2JrHWogi2j25f2BuLnryEfiTw996tjfMmTzXpG8bXOLfxRquAWWw/PH?=
 =?us-ascii?Q?6K8sdlUL8wcjcdV4XU78QbkeBm4eSFssBviC/+EEwpuD9QsngBKl2hvYJhR+?=
 =?us-ascii?Q?fe3pzoq0w5iVvNo08bdH509Wm5mVm4xY7rlfjCxzoYb1oBEb/ulSVn37Lcdf?=
 =?us-ascii?Q?yqMy13wO8dC+R3wiFtV78X783XoQ4mPpVy212I2pBrWiWJIt2Je0huuqIEDg?=
 =?us-ascii?Q?7JFdLgyIjy3p0hpAAh5Z0fOSYcDStENLDayMYALRLCTG8+IayLMc3Mw+XIa3?=
 =?us-ascii?Q?WupF7Iuh7q5itO357VejyuKlN8nv+C9JtVxaxms3QEwCxbXI+Ky726RsJDcj?=
 =?us-ascii?Q?C+VajsWMT2lUfWtutY3xFN1+BiDQ3KkkKU8ozoNi39K87Zda6bipE1XUtkwb?=
 =?us-ascii?Q?Qbk/LZ+YaeqnHicb0axFUrdSkGywaYWiRnVDIZ16xWGtWycYCeQHbxzi39ge?=
 =?us-ascii?Q?8yhen1sUc3as95512ThGa3/TzL6nogksb+pq2QBip8f+RGK2KgobUfdmGijp?=
 =?us-ascii?Q?0hJ75er6VQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e53d34-593c-4799-2bb1-08da492e94d8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 09:09:24.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcA0xVqZ0iXfoyJGqcnQxba2koR7o4nQ4pnlTxTsQXiV/8U4I4peDH6qxiN2xt5U87cdvjv2DPnX3Dv7Ujbl6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5095
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-08_02:2022-06-07,2022-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080040
X-Proofpoint-GUID: njjcww5QuSDMM6ox_N9RSudg45IwzFTM
X-Proofpoint-ORIG-GUID: njjcww5QuSDMM6ox_N9RSudg45IwzFTM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 09:01:50 AM +1000, Dave Chinner wrote:
> On Mon, Jun 06, 2022 at 06:10:59PM +0530, Chandan Babu R wrote:
>> This commit adds a new helper to allow tests to check if xfsprogs and xfs
>> kernel module support nrext64 option.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  common/xfs | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>> 
>> diff --git a/common/xfs b/common/xfs
>> index 2123a4ab..dca7af57 100644
>> --- a/common/xfs
>> +++ b/common/xfs
>> @@ -1328,3 +1328,16 @@ _xfs_filter_mkfs()
>>  		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
>>  	}'
>>  }
>> +
>> +_require_scratch_xfs_nrext64()
>> +{
>> +	_require_scratch
>
> Not needed - caller should be doing that first.
>
>> +
>> +	_scratch_mkfs -i nrext64=1 &>/dev/null || \
>> +		_notrun "mkfs.xfs doesn't support nrext64 feature"
>
> _scratch_mkfs_xfs_supported -i nrext64=1
>
> see for example:
>
> _require_xfs_mkfs_crc
>
>> +	_try_scratch_mount || \
>> +		_notrun "kernel doesn't support xfs nrext64 feature"
>> +	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "nrext64=1" || \
>> +		_notrun "nrext64 feature not advertised on mount?"
>
> This seems unnecessary - if mkfs supports the feature bit, and the
> kernel supports is, this should just work. We don't do checks like
> this in any other feature bit test. e.g:
>
> _require_xfs_finobt
> _require_xfs_sparse_inodes
>
> etc.
>
> Also, you should put this in the same region of the file as all the
> other feature checks, not right down the bottom by itself.
>

I agree. I will make the relevant changes and post a V2.

-- 
chandan
