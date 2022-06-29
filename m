Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37475C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiF2S6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiF2S6l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:58:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD7E193D0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:58:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TISo0P017909;
        Wed, 29 Jun 2022 18:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=mg957XWL4yJtz0ZCqfeepYcsTaZ20v2B3Z3zL2w/O+s=;
 b=RPcgeX28SHlBEHCw8vnQHG1VKwmBbaKZNExFk/ox7kkokmVynrdck1JEp5/kvA/wI+7Q
 KIWNdL0KGVpPCnqhNfA7G8/jGWhm1H2JReHrLyHejmwSErxjJZ+7Do9E8KOfP8TZg6LH
 z3q/1MEFpKTIflcxTb/s155ERQWAiwihIJ5Dy+kgPsQI/RCuB1VohgBP2ga18NIIjiMr
 IIyNjxZqrWip0DfB1IbudKpngv0TMmvkynykJrw3iZsGgI1E+QKkLUo2st0Axksujx94
 4ubysVmArG0gVqrj6T1MzmEz4agJF1qOycuN/8nsF/MnixRd72asRcPzr/ino3jr7Lh+ Ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwtwua6qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 18:58:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25TIuOGF026573;
        Wed, 29 Jun 2022 18:58:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt3cwsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 18:58:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4AIGfeGPdrlMb/lRt/vrBt2l/ucJBEvyfbeFIGGWk3JpRndFddn3gQsfR/fpFNGWEPL7aIpiyMedVF3DuqrQhRm3mdPqSGCk4llRoGRSzRgm9a0TTszdOvzb/b3AlXbR0OsYf/A5I96IynsFBUINowZ09l3ii7x7Mrq4zkUrjAjpbmVBnMAz36Sp6gnvZEccnaL4Ps8FezlYc8M5mgR+1B7Qki4usdnWlozFwBK0oFgSCobPJOD9piGKS6svFRbwYxHAHN4F+Jl7hUJtZxzDLndxg4GQljnaAk2wyv+gMEZiDDAuqbOrqCKU+lKPs9i0t5Jwmfw9O9B52s4YZ7YQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg957XWL4yJtz0ZCqfeepYcsTaZ20v2B3Z3zL2w/O+s=;
 b=Hj6aYbudOF6WONunCXe71+w2MCWBFpMVAjx2be0R9Fy0c2hAJmweAeXuY9gKLyGVwf0zoqXMDg8yZKjS9mjB5eFsUbJXNYFL30b/k3Ulw/biVolLJ5kaq5+657hbGQ/CPyq2OwbhkkidKKP3TTX/nQINfY7PocSta0B0iBJGs/Y0qp3qe3hzbQn0WR6YwmjtlDbi6Ls3lTADYdkJXjilcLx9fMn0gOzEoTdsT1Fm+YAi2BHsVhZieCW4oqzlca8UPkHuNG8hxfR7Jd+RwChcEb5264vnmMgFFRBrqwSWWgUB7A4wUXxZO/8ETaRfZEqHB9uELpE5S03+LI9XjSpG/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg957XWL4yJtz0ZCqfeepYcsTaZ20v2B3Z3zL2w/O+s=;
 b=W1tzFqyT6JFYMWPISuxUS1MT1YqrLujB7DIOQJX3Kt/ptTVrCutKc1p4Rmx2djkEYrKUFXaEil6EiUPZ6QIrVbSknRbgG/IBTx3ehdMQ3LDm2zanV0TRRiIlAEEraPsrAzxQ4veZNpQu1MRlgiZAT1Ev4Mcyag+LsdypXJRpZVg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4416.namprd10.prod.outlook.com (2603:10b6:a03:2ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 18:58:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%8]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 18:58:34 +0000
Message-ID: <8b5e7dfa30d544719a3bb964c1d518e15bf72f10.camel@oracle.com>
Subject: Re: [PATCH v1 06/17] xfs: add parent pointer support to attribute
 code
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Jun 2022 11:58:32 -0700
In-Reply-To: <Yrya4nPix+tL803D@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-7-allison.henderson@oracle.com>
         <Yrya4nPix+tL803D@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:a03:334::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e17b2c33-891c-4a5a-4fab-08da5a015dce
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4416:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txt/pQBl/uyQ3VwbyQOQ3MPFWvQUdWu/i99dmGGDEWOUqdrKqcuVp693NlBcjJgHCNMYlqmm7vLMHpH32NRnbsOIqpFkovmrvnz+iSQ5inTrolduWOg75IcP5+eAK0/BdrzC3HQN6UrHxFzvMRnuJLtvXRBoTJQgxkdiIV6ZMAluEWV4Hqhbn16tDQunM8SJgj3IrnyI0rabLB2c6P1NsS3xk0gsZLDj3mcuRpVDxs9eUyIXGDE9rVRPWOkaRMsV9Kh3P+mKtGa9+4TefkmTs6HeADtoJhoRxGX3ad65apX7aqRdPeYL0WNsQ5/UmZY53GvnhvqKyps4Id9goTI6hP3wfq9o4yUBodZLgvDIXfScmjuQGyPe4nEiVurKweC1Tpiqg81xOJCCj6zAXwRzQnhAKG9cyADHJYGrUDyVgUgx0l0D1XXpJCM27/Dnnk1deIVLgUN3YVswrXv4v6vm/sqbU6wxZbK9UVy7hJCnHS/ZhgLVWTpUVuIcDevieTJ5o0Ne7OSxhCQ1g/jG0XPtIAsetFVXdSvIicFgxtCiDoZDcnptzhikxjxnRU5U1LrJ+2BWqtsTzG0PV5VqGktYv7dHJ1Gy2Pp19WwRuiYyfOf7znqUAlzOK3sVhDp3iSk3XbDxMULHN5G+eNU2LmSG2oBuuQSWj/CmL4h0zSq/RDTSmTZD4ee+UmrkuoFiGJWX+Wxi4L8hoKjN0NnCmIfdnjVob9tJLdb3QNeJ438wSpmFWpWyyoHC4+qU2EndcIgI4zpjE6lsp8+QFAw0/E9WjWH3lbNcohdTRRvRXSwzXTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(376002)(39860400002)(6506007)(41300700001)(52116002)(5660300002)(26005)(6512007)(6486002)(2616005)(186003)(6916009)(8936002)(316002)(66476007)(66556008)(66946007)(4326008)(8676002)(2906002)(83380400001)(38350700002)(38100700002)(36756003)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkJNblBadnk4MWVmUTZNNTBuNE9zZnpKa013bU51d29JS054SzFCVko2aGVj?=
 =?utf-8?B?ZlhTNFZEcGdzcEFxdzA3Yi8rUUhlK2JMNDd2QjRncmdybm9kdk4yT2JSS2Zr?=
 =?utf-8?B?cDdLdzgxQUV1cU8zNlhXRytIT0RMclM5UXJCN3B2VDc5L0FqekE4d1BVa29l?=
 =?utf-8?B?YUl1NFB3Skdrd3lyclBLemFBbnF0VGlUd2hONXJCd3hNQkdteDVMYzJMVTFy?=
 =?utf-8?B?ZTRtdUExTjkzaUZRTEgveURUTHdpKzhHWC9wVGhpUkdsQVUvMzFoMjEzWlA4?=
 =?utf-8?B?MmQ0NFlsampRRWhHYjBqNDhBWXBpbE9yS2N1MmVxMG40bm1xL0RQMlc1UHF3?=
 =?utf-8?B?cElPam8rcE5BZHIra1pDckdFVWNEaWt3eU8xYTNWUVFKTXp2NWMrY1JmUWtk?=
 =?utf-8?B?VHUxWDdFRVUvNEU0WDAyNzdLSTljZElSQ0dZQU1zQUIzNy9wZUJaRFZoNjJO?=
 =?utf-8?B?ZUYzQVZlSFRWVkIrZjVsaGc0czBFR0ZBN1g2a09aQnhiekhIeExtcHV4Y1JB?=
 =?utf-8?B?UHhjSXdGdFZCUXdiZStUOVp0c1dwUzl1SDcyZVRyUGVIb0w5eFUwTjlNc0Ix?=
 =?utf-8?B?YXJqVXVkNVRWbmNmZjVGYlVWTGVEV3FkZnlZSzI0V0ZSbnZYUlUycWNIMGFZ?=
 =?utf-8?B?cTFSU1N5U0lxTjRIS0g2VkdwaHhzcm9wVDlMTFlOd0tYU1krS2lLTHU5eCtL?=
 =?utf-8?B?TVRUUFdEY1FaUFhIejRJeVcyREZlemhJN3YvY0JtdFZpTklvWWJlbUF3eE13?=
 =?utf-8?B?T2lPb053eS9qaG0vK1RQYzdhV0J2WWV2Y082RHJ5TzFsbGxxNG11ZC9BK2ZX?=
 =?utf-8?B?SjF6QXZCdGZvc2NScWIvSmRWRjFNTzVNOG1ZYUhkck9lTWRpRmR6bEgrQS9N?=
 =?utf-8?B?eExGTC9Da3Ewa25hV0FvTWZwei9oQWJ4c3QzU0FVOWFUWnd1bUFrSFB4SXpM?=
 =?utf-8?B?U2p4NDlndnlmYkVpdEVMWEp4cS85NUJhV2dOb2F3VG9MOEVaNjVrNUJKSjRM?=
 =?utf-8?B?TEt2c3duSFBJWTVnWXNnMm5HbUxvaU16YUorSjhNR1ZvZ01yZlFoaE4zdmZi?=
 =?utf-8?B?R0dzUG5LNFpwZE5qdmJHTGxIbnBmRHRFTVlNTndSS2Y0SG83RkxwalVWOCs4?=
 =?utf-8?B?cmFEcUpxYmxMaWY5ZmF1MVRPaTJzSFJ4Q1NuZlpTSUJCOXRrOU5sS0daMW1K?=
 =?utf-8?B?WTA0NGdZWGdPSGV2cjZWbkJId0s3K2xLUUlzOTlURzdndXRWeEtlNllzQWRO?=
 =?utf-8?B?NFU1eDlEQ0JmcFZHVXFOTFo3SjAwTWlzRHZZRkxCMklESElzL0hGSHpjSXFI?=
 =?utf-8?B?cWxrc05NeEM0cXVVWlFxVmhvYWt3ZDhmK2lFK1c1cXJlbGw0ZDRVaWJqL0FD?=
 =?utf-8?B?eVU3VW5hQXNZTFdDdjFhL0NxVTZTSURYUWVUbU0zVks4UnhBemJPcWVTQmE3?=
 =?utf-8?B?MjExdmpwVzZGRnJJckRxcEpMNytuMFliaFBlaTBaL3Vkc1c1VDBOdkFYZkwx?=
 =?utf-8?B?ZCtVWGVXVkRiczhZTzlvQ2ZKVWdlYW5KbzFHS0tZRnc4N0k3dWJ2Y2d5aFF1?=
 =?utf-8?B?SS95QjFFNER6SVN3N0Q3R1U4SFNXV3RvM0JZcHJxUDJPcDFKLzBKTzZzRVlU?=
 =?utf-8?B?eHFvUmxIdW8wUVpRdjFTUTIzZ0trYWRnZ0UzYUdidCtLN29oRTRraFNxN3M0?=
 =?utf-8?B?MnV6Vm1JandMQ3E2ejFrbDZyQURDcmpRSHltelRod1ZjU2Z1bHVSU3V5eVVq?=
 =?utf-8?B?VXpWTFo1NCtjUWRpeHozNmxxNnY5OXFoalRVOEh5UFByaTR1YmE5UmVKSkQ2?=
 =?utf-8?B?V1hpUWpVZ3hoYzZLa1JUQnJ3dVNIeTc2STFHa2F6NU94STR1cE5oaS9OUHpY?=
 =?utf-8?B?Z3A4b1N2bURCNnUvbEEvVFVsZHBwUCtYWjhSMXl1c2IzdGNGL2JpVTBxS0Vh?=
 =?utf-8?B?Mk8rTWNYR0NKOUpML2NVdjdMUkE0NVQ2VDIyQ1lkNzR1aVFMYmhOZnlubHFO?=
 =?utf-8?B?a1JBQm1jSENHeDFvczhMajkrZTZjaUNjd0dZQWhWN2ExMFJqU2E0RjlyVjY4?=
 =?utf-8?B?S0QzTG01c0o4LzJuRWw4MGFqdFFabnFSK3FNNE1KMlYxNnNKZVVIMGEvWEZm?=
 =?utf-8?B?NWEycFdtVi9YNmtyOTUyV3l1enduVGsrSEJKSzVRUzU2VHNQL0tUWCtOakUv?=
 =?utf-8?B?QUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17b2c33-891c-4a5a-4fab-08da5a015dce
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 18:58:34.3177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTGuUX/NT8UwP6X/DUHKZ3ewJhW01kW7s1Sijhrc5r413wZrtL2IoT5JBUTdWDWD0XFH3W+hI4IMRor0Wgh7sODmfwZ/9++fzfmasrSJ4Mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4416
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-29_20:2022-06-28,2022-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290067
X-Proofpoint-ORIG-GUID: D0wOBEp0UjCwRdshuHgsy44I-zgP_zNY
X-Proofpoint-GUID: D0wOBEp0UjCwRdshuHgsy44I-zgP_zNY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-06-29 at 11:33 -0700, Darrick J. Wong wrote:
> On Sat, Jun 11, 2022 at 02:41:49AM -0700, Allison Henderson wrote:
> > Add the new parent attribute type. XFS_ATTR_PARENT is used only for
> > parent pointer
> > entries; it uses reserved blocks like XFS_ATTR_ROOT.
> > 
> > [dchinner: forward ported and cleaned up]
> > [achender: rebased]
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 4 +++-
> >  fs/xfs/libxfs/xfs_da_format.h  | 5 ++++-
> >  fs/xfs/libxfs/xfs_log_format.h | 1 +
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index a94850d9b8b1..ee5dfebcf163 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -996,11 +996,13 @@ xfs_attr_set(
> >  	struct xfs_inode	*dp = args->dp;
> >  	struct xfs_mount	*mp = dp->i_mount;
> >  	struct xfs_trans_res	tres;
> > -	bool			rsvd = (args->attr_filter &
> > XFS_ATTR_ROOT);
> > +	bool			rsvd;
> >  	int			error, local;
> >  	int			rmt_blks = 0;
> >  	unsigned int		total;
> >  
> > +	rsvd = (args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_PARENT))
> > != 0;
> > +
> >  	if (xfs_is_shutdown(dp->i_mount))
> >  		return -EIO;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_da_format.h
> > b/fs/xfs/libxfs/xfs_da_format.h
> > index 25e2841084e1..2d771e6429f2 100644
> > --- a/fs/xfs/libxfs/xfs_da_format.h
> > +++ b/fs/xfs/libxfs/xfs_da_format.h
> > @@ -688,12 +688,15 @@ struct xfs_attr3_leafblock {
> >  #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally
> > */
> >  #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted
> > attrs */
> >  #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure
> > attrs */
> > +#define 	XFS_ATTR_PARENT_BIT	3	/* parent pointer secure
> > attrs */
> 
>           ^ whitespace
> 
> What is 'secure' about parent pointers? 
Nothing, it's a typo :-)

>  Could the comment simply read:
> 
> 	/* parent pointer attrs */
> 
> ?
> 
Yes, will fix.  Thx for the catch

Allison

> (The rest looks fine...)
> 
> --D
> 
> >  #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle
> > of create/delete */
> >  #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
> >  #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
> >  #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
> > +#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
> >  #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
> > -#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT |
> > XFS_ATTR_SECURE)
> > +#define XFS_ATTR_NSP_ONDISK_MASK \
> > +			(XFS_ATTR_ROOT | XFS_ATTR_SECURE |
> > XFS_ATTR_PARENT)
> >  
> >  /*
> >   * Alignment for namelist and valuelist entries (since they are
> > mixed
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h
> > b/fs/xfs/libxfs/xfs_log_format.h
> > index b351b9dc6561..eea53874fde8 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -917,6 +917,7 @@ struct xfs_icreate_log {
> >   */
> >  #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
> >  					 XFS_ATTR_SECURE | \
> > +					 XFS_ATTR_PARENT | \
> >  					 XFS_ATTR_INCOMPLETE)
> >  
> >  /*
> > -- 
> > 2.25.1
> > 

