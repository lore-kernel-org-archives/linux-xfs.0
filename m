Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663C8C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jun 2022 00:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383489AbiFRAc6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 20:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiFRAc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 20:32:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E16A1F60E
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 17:32:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HL2l98022329;
        Sat, 18 Jun 2022 00:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dG1Rv3C4Fppnqlj8PljZlNQPFIDOFUtbLYfENhqq3Ok=;
 b=KU1SA64ltIKl7hxAJFUIAdcFBqI/nu+yzmYjICRu92k9j4jbHPsdlQiB1BU8oQ1gz3Oi
 HbhGVkhpZqkR7xEDeUdER1z+UMPPTxfkVXcEM4Q6j1rd3t55cKBSsxXaxyKql7D25OUv
 3igTeNjcy5X5GAE5h9uGlK9+IDe5vuHBziGM0gL9xL8hKvNlXCM6xAubzvxbkkEAWXHu
 E8HOuANyjhX0TpepSCZUT56gVRqmi0P83ZrEli/G86nrMD03dMVw2s4vemQUgT8pJm19
 wV64hgThldsuhRt/CIv4VIQEpfztGVvIdd9wEUsQHXuQ22wU6ofdzTkA+Hby5ztqeNbc uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfcxt8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25I0QUxT004443;
        Sat, 18 Jun 2022 00:32:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbunyvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa7p3Euna/eciixluaJjPLQGYRYf2zbraCk3k2yOaBjycMt4zKlXphTI1RX+D8/Ubi8mgfnTTOrLQJ0huCvhmDzWg/3ZI1hxHig/I9itJkvIzD+ZuILR+r2zbXYx0dLLHhyBI6kCQi/Qr5s2UAakXAYBF/LIeK1MBSQRWVX6hF4UbDYOh8urBfdBYoJz/wgDZf/8rT8mf+AetS3NAfaqd80iGzczcG2PMBbbY1JxJA/z61HIuDBnODRxRpDDnk0DwDOCW1Aq2LLE+VCEVpDWU+LNW4S6GIm74aqWvSR2MX6WSn2VB8JzolIv1w9/c8f0wRrhoAk0XDKwu4w7tRWDQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dG1Rv3C4Fppnqlj8PljZlNQPFIDOFUtbLYfENhqq3Ok=;
 b=m3Tkyc4EuwiXSRb5vWZeFlhoogaVOg0lMpSMDLiAqQNLV3Y+3bvOKQDd07nMP9wHyKPt4PHwkPq9DPpzqiD5t6gNhqVZwkFCw4PkUYUce0n/Jv2NJpZRcwg/wf2ArHKNYC9Rr0iwXWnU0xHS1ndc5LGBqSXOttKtrpZz3i4a/8SxUK674V0VcM3DSBz5a1CWIAEUhJn+CrquIJDOLHyzBl7hfYP6MUQDaWiUjcnLEdLcX5gLdagNhNue9uSA9iqoJR/MvMoVOaX/MGX+qjUEcyYpm1B8qWhzVq/ahQwQ762THgEv4eokiAkGRpMXoMOYwwAuwCjl5ZQNObhz1oOzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dG1Rv3C4Fppnqlj8PljZlNQPFIDOFUtbLYfENhqq3Ok=;
 b=LkcdMzff+7yjssd8x9PhJI52UVXsrjZCyT/q4Dk8z0QfrctXSboFDxH/6wB7zp8K7E7+MnMqEH9gKXcr0Ly3205i+mdsW9oWGgSisgP5C1ok3k+N6dxdmfLo+O2T+iR3Gq2OWMCZjPihIcGwj3E0h6+xrXIzflb3GLxkHf4n/co=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5852.namprd10.prod.outlook.com (2603:10b6:303:19c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 00:32:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 00:32:48 +0000
Message-ID: <37baf16c95601e8919ebd1ecda704084cb121148.camel@oracle.com>
Subject: Re: [PATCH v1 11/17] xfs: add parent attributes to link
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Jun 2022 17:32:47 -0700
In-Reply-To: <20220616223923.GG227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-12-allison.henderson@oracle.com>
         <20220616223923.GG227878@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:a03:332::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da9b4eeb-596a-445b-1340-08da50c21239
X-MS-TrafficTypeDiagnostic: MW5PR10MB5852:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB58525AB8DC3B9A86C8255D5E95AE9@MW5PR10MB5852.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VbM+uTDwEvzmPPJvlxyVls0qr5Y6ZP8hWlxkXiIVnhGZe20kITwdFtixpCmOqyR1GpMc8YP/PkOX5QzYh4bIIacMmY8JZrEN1vMWYRJOH5btOXWqeJuiCN8P+1C/GuBfAQ1/ad776ynWD1NE87fCP6xGBaUEcrZWkNOlFZXEgZLd3gaDu2eHPggzlM7OuHP6i3QXDmC7h/7GvETwXIRCckSWxIhRCr+2w+2W7ucJkEwhJfN8Q8qzToiIXO+vThMpIj4LB596R8hPciB0vOJ5cqE480cOVdA9G/r0nBZirpOARkTeTfW5EdpfVt2NwTepfVk4fTdKjd1MFcEGJ1oti24nJCkBDt0Ra9+8HC9sC/MsX7gZ1jN6vsoQkH/F1D/ccSMFay3WJL/tbDQCl1AYIbjhAFU39ozOUcC/eoJqCDjrDKHiBm0ZxItG4a0ohU26oR0k48CCiO9apzR2SKlLOUwzkNS1eEd4Cmd/9O0pWmr22G6bEdowiDOlfQCdGyKJy8NB+IOOl0SxiHivGzoKy3y9d408BgYQYsWgEmPewUg1XBHcvKknMXzv8X6EhT1lCi1EH4EMQ8KjvxRAZVHXAigweq/96wNv8Xcy3V958+mAy86TYI+mPXKp1DohA+/AHbB0gr2U2vVF3ck73A61RLwZj4wiE40Z2zMThJw9n0o8PL5x3gWXhE8pY+qe8LA8964+PXXbKysYUvCK3+UgLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(5660300002)(8936002)(86362001)(6506007)(6486002)(6512007)(52116002)(26005)(2616005)(498600001)(186003)(2906002)(36756003)(66946007)(4326008)(66556008)(66476007)(8676002)(38350700002)(6916009)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0ZCVCs0SWtxOUM3V1h4K0ZpMFFLcmFTZzRLNG1JYmJnRUNNaVBOYTdBUnhp?=
 =?utf-8?B?OENqdlQ3eXRYdkhuazFvVHVtSkhyUHBERHNNc05IRGE0bmVvci9yaytFVngr?=
 =?utf-8?B?aFhET2Vic203WHNxQ1hhcUlSQWdRWkJ0T1Q0R2w1cU1ycjFXRGoxeWtKcEda?=
 =?utf-8?B?T2hDTW9IQ3h5UzloaEpVbkt6T1p1TElabkVQTlU0MjN5bkg3bFZDSHArOGZT?=
 =?utf-8?B?Y1hWblVrNi9QQ0hpSko3Vm5LSjR3dERSZjdJNEdsWjN4eWUvR0xzMG9oWmNu?=
 =?utf-8?B?REt2VmJvNzZjTkc3UFVzZm4yVUxLN1RGK2ZjbkwyVHU0V1pkblh1a2J1S01u?=
 =?utf-8?B?QmhFK1huR0FwTHBUZ2NJWmM2akdJWnhMNGlqL3hUS1V3QTJsdGx4Y0NBWGFl?=
 =?utf-8?B?VHNtd1oyS0FQYTBFUkROZ0V2YStvRURYbFhNZ3pINDFPbmFGMVdQT3lXU3Vp?=
 =?utf-8?B?aWkyQ3pnNWtPQ2NubDEyeDE1Tm56R2hlWG1WUnFJZ0d3aDVyTnMwS0p3Snkz?=
 =?utf-8?B?WmRWRlRHTEdZMGNKQ0JlL0RuWU56c0dwRDROU1Yzck1EdERDdU04V0xpM1hr?=
 =?utf-8?B?QXR3ZnIzeWZtSzZGOFYvSGVpQXVZcTlzUlFXQWtMUTZCUjF0V0N1amRqYzhU?=
 =?utf-8?B?a2h3aUdoTngwUzZGK0ZGUElJb0p5NWhLVXlUdS85Q1FINlZ6ZzBzcWhtN0ox?=
 =?utf-8?B?UlRKT1AwdlZxU2NvTEYxQUh2Z2JVU3BKLytyVjdjOVhmcHR3VEdyRVRBMHRl?=
 =?utf-8?B?TDFybmVWUThlRXZPTmt2bGpEaGJQOU5BRUZSN1laZUJVeWUwTGZqR0NJbmNS?=
 =?utf-8?B?dFEvRHZvRTh1UW1zRWp3RWNqRFhoOUY3N0VBQTVjZGdsZ0laa3hTMnNXcnov?=
 =?utf-8?B?US9kekFMVUJlb25VNzFscmRtR1pCKzFIeUJzTTZCNFRzU25la1NHWnBVY2d0?=
 =?utf-8?B?WHRxZ01QUmRnUzM5VUVxVkNvdUI0QTlrNXdjU09ZNVV4TmVXOFM1Tk1Hb2FF?=
 =?utf-8?B?MXIxMk5VOWFjeHRqWExFTGRSd2w0TlYyQWN0YTNEb3hzSlJtY2MwVWF3a0hw?=
 =?utf-8?B?Z2hGNTZTMk1yWkJrY2ovMXY0c2pXRVM5dW5KOXlNeGhzMUNHU1hCUDhHNUpy?=
 =?utf-8?B?UG9HVWNqMHFHKzFHbGhOSnJ0OWhwaURSQm9GN1Nyck9oK1ZiNzF5RUlRVms3?=
 =?utf-8?B?dE9BSWllK3g1K1J5VGJ1M29kaDNScDc2elJpRDI3RVU2bDVSNmlJazk4YWUv?=
 =?utf-8?B?MWFNS1p3WXdySitGSXdGMzVFMWJwSjgwb1F5SlVHTWYyK3V4VWdkeFcrOHNn?=
 =?utf-8?B?dmJ5QWJwVlNIaU1ja3pQSDgxamQ2a3prcnJ0a25vWUZ3ZnlQK2M4UitLTW1q?=
 =?utf-8?B?d3RYMmN6ODFuODlha2JZSUtRRmlyR0xtQ2thMy9jVW12SnFFZFoyRmRCV3BN?=
 =?utf-8?B?c1VlN21sd0xaMHozVStlTVNCMDZpSVY1cFo2b3pFejBXU1VxQjhEY0xlUkxR?=
 =?utf-8?B?WnlFRUxJL1paY1dtSnY2eTJxV3MzQjhPQXFwRS9RazM0Z2dXUU83QVdnNUpm?=
 =?utf-8?B?SG15aG4xVHNmMkRLUDh4YThhVkY1RE12YXE2NkJLSWFhUTk2WW81NHJHQ0Vw?=
 =?utf-8?B?WTB1R0JVSWVlbTBOVmdwRUx6c1pqR2JUUVV1citxT2VrcmxOVEpXVmg1SG04?=
 =?utf-8?B?WmVGWm1yLzdLbnhqVnk5eWJ1RUkwMTUyOWdieGlMSEVKeGVqN2xyWVVnNVNp?=
 =?utf-8?B?anZ3Q2RJTUZlbzNBVC9Pd2hDKytEOFF3Z0EzMy9xajlEOUs0dEwzUDJkeUZ5?=
 =?utf-8?B?b05Dd0pSUEY4UkxSSE4wMnd4ekR6ejZLdmRUWlFkTVgyaG9NRFNhcnZkTG9I?=
 =?utf-8?B?WThldHloc1ViSXNKM2dmN3dsUDVYTDhjQmdOaHo3dno1REtBNlVZdnpha0xU?=
 =?utf-8?B?cS9NTUZZbGpCYU5FSGdubHZ3eWJrNFhjUlNZNVlkRWU2RnNTRVJzazhydnhQ?=
 =?utf-8?B?S2M3UWszTmRqTWFyRDJTa05SVllyaUZFNExsaUd2c3o4RS9wbzY2M1ZFaith?=
 =?utf-8?B?b00vWWltSnQyOFU1RXJtU3RjVTVRakRhak1VeHAwMS9neTlWRVVCSVA2UkRT?=
 =?utf-8?B?Zy9wQnJ2ZmxSQloxN0R3cFZnMGRwVHFpK3R1cFlkZHl6dDNxWHkrQ3d3YVZs?=
 =?utf-8?B?TkdNY3hDd3RrMXZnektmTVgrd2ZDVmlRUGNKNEFpYy9PemM1RklZZDkrVkh6?=
 =?utf-8?B?aWhvd1dJVG5YSHVqekZjNkR6Sk1xdDcwUEZmNXM3ZnhNQXorZHU5ekMyUHlN?=
 =?utf-8?B?SG1uOWorQkcyWVFiK04yU0JnMkp0NER0YzdHMXhBRzQ1TW1CMkkwdmdOOW0z?=
 =?utf-8?Q?2rlkNoDdkVOF7tcM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9b4eeb-596a-445b-1340-08da50c21239
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 00:32:48.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4sMH/0Q//d4uTXe0YJsnepdbgO0jD14a6cG+xxn81JiraOMVhvMhFS3qFZ9HMRDe6A98Z9CrLe1gQREwh+LZAkNbqf923M2o+cNMW75+vAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5852
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_13:2022-06-17,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206180000
X-Proofpoint-ORIG-GUID: bA1dTL2FnVCkwnB7kOA719Wa_ZLY5yxD
X-Proofpoint-GUID: bA1dTL2FnVCkwnB7kOA719Wa_ZLY5yxD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-06-17 at 08:39 +1000, Dave Chinner wrote:
> On Sat, Jun 11, 2022 at 02:41:54AM -0700, Allison Henderson wrote:
> > This patch modifies xfs_link to add a parent pointer to the inode.
> > 
> > [bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish()
> > usage]
> > [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> >            fixed null pointer bugs]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c | 78 ++++++++++++++++++++++++++++++++++++----
> > ------
> >  fs/xfs/xfs_trans.c |  7 +++--
> >  fs/xfs/xfs_trans.h |  2 +-
> >  3 files changed, 67 insertions(+), 20 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 6b1e4cb11b5c..41c58df8e568 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1254,14 +1254,28 @@ xfs_create_tmpfile(
> >  
> >  int
> >  xfs_link(
> > -	xfs_inode_t		*tdp,
> > -	xfs_inode_t		*sip,
> > -	struct xfs_name		*target_name)
> > -{
> > -	xfs_mount_t		*mp = tdp->i_mount;
> > -	xfs_trans_t		*tp;
> > -	int			error, nospace_error = 0;
> > -	int			resblks;
> > +	xfs_inode_t			*tdp,
> > +	xfs_inode_t			*sip,
> > +	struct xfs_name			*target_name)
> > +{
> > +	xfs_mount_t			*mp = tdp->i_mount;
> > +	xfs_trans_t			*tp;
> > +	int				error, nospace_error = 0;
> > +	int				resblks;
> > +	struct xfs_parent_name_rec	rec;
> > +	xfs_dir2_dataptr_t		diroffset;
> > +
> > +	struct xfs_da_args		args = {
> > +		.dp		= sip,
> > +		.geo		= mp->m_attr_geo,
> > +		.whichfork	= XFS_ATTR_FORK,
> > +		.attr_filter	= XFS_ATTR_PARENT,
> > +		.op_flags	= XFS_DA_OP_OKNOENT,
> > +		.name		= (const uint8_t *)&rec,
> > +		.namelen	= sizeof(rec),
> > +		.value		= (void *)target_name->name,
> > +		.valuelen	= target_name->len,
> > +	};
> 
> Now that I've had a bit of a think about this, this pattern of
> placing the rec on the stack and then using it as a buffer that is
> then accessed in xfs_tran_commit() processing feels like a landmine.
> 
> That is, we pass transaction contexts around functions as they are
> largely independent constructs, but adding this stack variable to
> the defer ops attached to the transaction means that the transaction
> cannot be passed back to a caller for it to be committed - that will
> corrupt the stack buffer and hence silently corrupt the parent attr
> that is going to be logged when the transaction is finally committed.
> 
> Hence I think this needs to be wrapped up as a dynamically allocated
> structure that is freed when the defer ops are done with it. e.g.
> 
> struct xfs_parent_defer {
> 	struct xfs_parent_name_rec	rec;
> 	xfs_dir2_dataptr_t		diroffset;
> 	struct xfs_da_args		args;
> };
> 
> and then here:
> 
> >  
> >  	trace_xfs_link(tdp, target_name);
> >  
> > @@ -1278,11 +1292,17 @@ xfs_link(
> >  	if (error)
> >  		goto std_return;
> >  
> > +	if (xfs_has_larp(mp)) {
> > +		error = xfs_attr_grab_log_assist(mp);
> > +		if (error)
> > +			goto std_return;
> > +	}
> 
> 	struct xfs_parent_defer		*parent = NULL;
> .....
> 
> 	error = xfs_parent_init(mp, target_name, &parent);
> 	if (error)
> 		goto std_return;
> 
> and xfs_parent_init() looks something like this:
> 
> int
> xfs_parent_init(
> 	.....
> 	struct xfs_parent_defer		**parentp)
> {
> 	struct xfs_parent_defer		*parent;
> 
> 	if (!xfs_has_parent_pointers(mp))
> 		return 0;
> 
> 	error = xfs_attr_grab_log_assist(mp);
> 	if (error)
> 		return error;
> 
> 	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> 	if (!parent)
> 		return -ENOMEM;
> 
> 	/* init parent da_args */
> 
> 	*parentp = parent;
> 	return 0;
> }
> 
> With that in place, we then can wrap all this up:
> 
> >  
> > +	/*
> > +	 * If we have parent pointers, we now need to add the parent
> > record to
> > +	 * the attribute fork of the inode. If this is the initial
> > parent
> > +	 * attribute, we need to create it correctly, otherwise we can
> > just add
> > +	 * the parent to the inode.
> > +	 */
> > +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> > +		args.trans = tp;
> > +		xfs_init_parent_name_rec(&rec, tdp, diroffset);
> > +		args.hashval = xfs_da_hashname(args.name,
> > +					       args.namelen);
> > +		error = xfs_attr_defer_add(&args);
> > +		if (error)
> > +			goto out_defer_cancel;
> > +	}
> 
> with:
> 
> 	if (parent) {
> 		error = xfs_parent_defer_add(tp, tdp, parent,
> diroffset);
> 		if (error)
> 			goto out_defer_cancel;
> 	}
> 
> and implement it something like:
> 
> int
> xfs_parent_defer_add(
> 	struct xfs_trans	*tp,
> 	struct xfs_inode	*ip,
> 	struct xfs_parent_defer	*parent,
> 	xfs_dir2_dataptr_t	diroffset)
> {
> 	struct xfs_da_args	*args = &parent->args;
> 
> 	xfs_init_parent_name_rec(&parent->rec, ip, diroffset)
> 	args->trans = tp;
> 	args->hashval = xfs_da_hashname(args->name, args->namelen);
> 	return xfs_attr_defer_add(args);
> }
> 
> 
> > +
> >  	/*
> >  	 * If this is a synchronous mount, make sure that the
> >  	 * link transaction goes to disk before returning to
> > @@ -1331,11 +1367,21 @@ xfs_link(
> >  	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
> >  		xfs_trans_set_sync(tp);
> >  
> > -	return xfs_trans_commit(tp);
> > +	error = xfs_trans_commit(tp);
> > +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> > +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> 
> with a xfs_parent_free(parent) added here now that we are done with
> the parent update.
> 
> > +	return error;
> >  
> > - error_return:
> > +out_defer_cancel:
> > +	xfs_defer_cancel(tp);
> > +error_return:
> >  	xfs_trans_cancel(tp);
> > - std_return:
> > +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> > +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> > +drop_incompat:
> > +	if (xfs_has_larp(mp))
> > +		xlog_drop_incompat_feat(mp->m_log);
> 
> And this can be replace with  xfs_parent_cancel(mp, parent); that
> drops the log incompat featuer and frees the parent if it is not
> null.

Sure, that sounds reasonable.  Let me punch it up and see how it does
int the tests.

> 
> > +std_return:
> >  	if (error == -ENOSPC && nospace_error)
> >  		error = nospace_error;
> >  	return error;
> > @@ -2819,7 +2865,7 @@ xfs_remove(
> >  	 */
> >  	resblks = XFS_REMOVE_SPACE_RES(mp);
> >  	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, ip,
> > &resblks,
> > -			&tp, &dontcare);
> > +			&tp, &dontcare, XFS_ILOCK_EXCL);
> 
> So you add this flag here so that link and remove can do different
> things in xfs_trans_alloc_dir(), but in the very next patch
> this gets changed to zero, so both callers only pass 0 to the
> function.
> 
> Ideally there should be a patch prior to this one that converts
> the locking and joining of both link and remove to use external
> inode locking in a single patch, similar to the change in the second
> patch that changed the inode locking around xfs_init_new_inode() to
> require manual unlock. Then all the locking mods in this and the
> next patch go away, leaving just the parent pointer mods in this
> patch....
Sure, I can do it that way too.

Thanks for the reviews!
Allison

> 
> Cheers,
> 
> Dave.

