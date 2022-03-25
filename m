Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C16C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 06:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiCYGD0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 02:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiCYGDY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 02:03:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBE7C681C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 23:01:51 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P01xxg010798;
        Fri, 25 Mar 2022 06:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=F12hjizXUEq9sBTfBgLiS73+u0AYTC3VMURJE0eUp0g=;
 b=XK9Ak8sCRHSFkAJ6LrLwRsl95iVyZqnPoURvrDZDtvF0mmTqZIGbsTsQn6eqQWwdIsyu
 wRiRHR6+Yv09MHW6eYcXBb72AjEHASe0HQUAQeusY6d7uJ2dN9U/FxiU+Oa+m0QIh96i
 joQ4JRt918e0TCJlJjhSVLLCjAt1hBztIm/B19iYHetgvh4+4Ei24YxPxAgBSbs+GfcW
 PKhz/abnA4bGKQvlXb3on6frc79qVrJZQOBJF7nHcmrONIwlEAXm5x64KyNRWsTzcQW0
 zDZoRYL+jYB2o2dN84gHQ0UR0vh/PyFNb2Ee7LQ2L/4FBthr7jndogBZzNeqUfrKK39J WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ssebkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:01:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22P5woKi165209;
        Fri, 25 Mar 2022 06:01:46 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by userp3020.oracle.com with ESMTP id 3exawjfxh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:01:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3UpbKpKZt3KJQNxNgIohi1Ewqypm2alh28lSPfku/cr4Y89ntFz2u6oXupiZ5dWop5L4L0PPLlIY9YaCd8ta8CoQJF360RvwUvpyNUl9SDJh2C2JZDPVvsfqBFTj67o/N+aSqQhVaakt7wRgvTG7D7//v+rLoxboigO9AAN2I/M6d+bvsKLy6rPGoWwbDSP4vsC+koT/2gAGX9TpogZQ2XcewJr7fTxN+btP/5Vy/ojkoGewfWQWVqRpvRw7+ofHzxVQlFy3N0s11Cj9s9Xc5AthT4aR1XbIj9wZ4LBtVO6SleAKSe9R1gI6wn6c7Htoafz62DHGSATE8fABbBc8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F12hjizXUEq9sBTfBgLiS73+u0AYTC3VMURJE0eUp0g=;
 b=BdKPEQ9+ukq+WtfJDRFKDEm113MKyPPSCe5if4zyeJWAPgw2+1iYHir/Prlh6YG9AAggZmzJHYjDM1RZjIj8OBsaAiH4nNl/QvTZBTx0nZuOCLB19PoaSk1aVgrjl2mxH7Q2j/X0qxftlXCdfj0q0QfN8+9gJuHEArHugekmQaPVWLRUpRoB6v4mzi8TdgtzvXts9lWyxTYyW8DRsksCjkU+dGDNVP/WrSPT7NiakgBrIwmxjGiKVQtV49gHB9VkhKs1QowbkC3KTOTipNRTVFwFMUl9J4IukuBbJo40TYkniHpaEYNmG+unohtD8tRJM+/SAdB/wRYtJlEGvlgu/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F12hjizXUEq9sBTfBgLiS73+u0AYTC3VMURJE0eUp0g=;
 b=bSGP3SSCqA+xanLE8UulClMhLArOKantluTrS5IAw0Bca3AB5Rz7CP7O/dDRU6KzL0H1ke1EruBUuSSvezrpvcGZrdTw5Rn2C0+Na4QW3hkSfjYovXKdV2uJh22vXgODFEGk2/r87zDZ0InbGXRxta+DGS941PsxukejqsM3+84=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2776.namprd10.prod.outlook.com (2603:10b6:a03:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 06:01:43 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 06:01:43 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-12-chandan.babu@oracle.com>
 <20220324214244.GI1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 11/19] xfs: Use uint64_t to count maximum blocks that
 can be used by BMBT
In-reply-to: <20220324214244.GI1544202@dread.disaster.area>
Message-ID: <8735j6y3ia.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Mar 2022 11:31:33 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0028.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::14) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e703805-c12e-4e00-92b4-08da0e24f014
X-MS-TrafficTypeDiagnostic: BYAPR10MB2776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB277621D89740204C61B703EBF61A9@BYAPR10MB2776.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OP0BhplZ13SUMiieJsz7Ga3K7y4JtQwZnoDdqQJ/rBK2WiTP3ozhw6qU2hCnSZwQ+oiTpjpYLpAakC/AAhAkxEP7GKP0X4qhIIbfFIM48kSUralyHxKjGLj4R2Z5foMYQS/eSW4D7XHUkQCgiNvOVN/stnP/rfpAEleX5FSLyjEUuRBS2PnEPOUGF12KW+oQIEi02yFUfCODn0Ex1L3yer9Fo2O3ZuaOrKRvnQxnBpagEPSTJWSTv8l2U89GOzDz8oyXTj2aUKEtZlc/8D0aQdNuqTrpzN4SusEl8V4Id1VRT9GadOu3UK2e0l8LQ3u6+DBfKUGRewLOGmFGwRRH0Qr8aZtywQwVwzusKfwB31lO+L+4v0GQe9Rxom0EZtjDUe+URh6W5JZ62sn94oX9Bp9brh41JkESX1eCSX0GLJdIQeXsD/uosOZtb7Tj1nj5Q7h0O3ICHfcGe9etdb+ZlrXGjKqmdjbUD3/YqGmUs3eZOaMz0ECI9je+32h7G0nom9FZ2gbvudfH+W19S9YlE0/Cyl0t2Ehxi29xMZjV/bYPieYk17XZzohWjtNzFXiA069gEjXqEu9Myb0oZSco6wXZVSZusisKWikEwI/mQvsqyUeFaQoGOavkBR8Z+qcjDGgXIZKLuMuqbWG4OSy01/lEo4oC4ieA2a/60CidjZd751LLGS+KkEWabI8MY4D4Im7+2xGMQGaOSln8jltVyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(8936002)(9686003)(6916009)(86362001)(4326008)(8676002)(5660300002)(316002)(66946007)(66476007)(2906002)(38100700002)(66556008)(38350700002)(508600001)(6486002)(83380400001)(53546011)(6512007)(186003)(6666004)(26005)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5LtZrpa28xNE5IoPsyH7k9Tstev+335wbSu87e7TRc1vP7r5+blPNIswR7R3?=
 =?us-ascii?Q?VlX0LOgDxwig1Hy3+g/M33zkubrWsJ77ZNYqAdNqX+1VxIY81zfc5jR1IcTU?=
 =?us-ascii?Q?6hm6I0BFoseBf6PcLD8J+CE/M+zPVbtlYxRYmyVQMOW8qjEqrDOF7s5+OwOv?=
 =?us-ascii?Q?hM7Yejj9Kmz7yndWFiPlFL0Z6rv3iMWC2UylzccPJDwF4KxNYfxjhAWzLqSR?=
 =?us-ascii?Q?06Ia2HWgjr1YP7QPhBk+lwtRbaDbij5YBOGO7whLtfF8oLHW4ALaoUHsnrNQ?=
 =?us-ascii?Q?93l7yw8avOLGmBD14qLCMRSj/tKKtjgQzHzEu2HRsySlrTytbo1tx1lH3Zeo?=
 =?us-ascii?Q?IXbAA6iziq7jfPn2+hbaxiS4w+fINv2u7TxB59uQP+H8jboTmUubUkvI5Kim?=
 =?us-ascii?Q?zZCLBOlooCvcu/0IJOzvf25XZvENH9go/KODUiPpdfaO6AjyXGMIJ9g5C4Oj?=
 =?us-ascii?Q?6erliJX0QYFNkiMfVVGVwC5g7KAz6O7Q3bfUv2T+pki1YY48pMfzkJCoDCt1?=
 =?us-ascii?Q?2PRDhXqOqFlgdGzn5+pBZ1JvNq9hPzxg/59lkaAKjBOVzgAr2eGnob1v32Oc?=
 =?us-ascii?Q?oC6APfFRGlUTnvsugQ9XH64CRJjFSV7Oq6t44/6+KIJ+RYhAuGQDPBgcTQ2V?=
 =?us-ascii?Q?+Vbsw0f0M9uEEvMdZOiKZaKJgBSBSmQsZzVxRDuaEEq4oq54g0Gvttdyt31m?=
 =?us-ascii?Q?b9Cl8NKKKJGhEmBposzaHPoYju1vu7XTEvPmWAQoS1fs34lJ9gbxSW+WsBcP?=
 =?us-ascii?Q?dv1w4ptLiXWtyFIAYIsKZGwV5x0AGn686WAk7955xHgTzxRv48juUS6pBgJ6?=
 =?us-ascii?Q?SanZUqJtztxSuVXJ5AqArzh5i7yp3pd6zhXEmVQyxRzA7hQ9VBW26bQXxPR/?=
 =?us-ascii?Q?lVw9VW1opLhGezzkEOldW9Eti3HAgk9RDNmlh+gOL9i1OD0XGY8askCRBDsN?=
 =?us-ascii?Q?U2EthkL9VFonKN8HXsHM+Wc+7kMaPvH31IB1pmdf+PIBEFFVRh8F2EpoUJKi?=
 =?us-ascii?Q?HQd49HQ0cPf2n4U3XJXmeeFB+4+WNdwunjJ9HTu/rZj3muFICAFWpW+JgSAe?=
 =?us-ascii?Q?n7oPLXYTDJTVsnk3gxwFkrlOGYAszHb6Q0fSXzKSW8vdukp7MgfTasm7mZWu?=
 =?us-ascii?Q?mBJmHKM6Zh4MsaRFdRMkGzxU/8JkAqRXuVMf6e91Ir7wsbg8JapEiRhN8mSS?=
 =?us-ascii?Q?QUDpGnfRTZJtqiD0QXT2rkEWTlJji+jrTIqByMY5q7dMh3DWIOMQMe2g6DyQ?=
 =?us-ascii?Q?8t5zue4qoWlPJiipMNKO0E18iNjXHCKf4zpFSIcpPmFb+FB+1qsQMh3wSsmJ?=
 =?us-ascii?Q?aNldx89dwxhvfFtU9pgQoq7JVDYuFppeaZ+3bEjMX/RxPEl5ZiqzzjvI7i1P?=
 =?us-ascii?Q?3ZxrmXqqvCIxroR7OgnHzYySazObLKBaqnm9S670kiVO4Xw5YOGPx64EIPj+?=
 =?us-ascii?Q?DWNE07gR8UpTMW9GenWU0L4T7uG9ui5277wtvKHz/P7yW4dJ0b/5Rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e703805-c12e-4e00-92b4-08da0e24f014
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 06:01:43.8493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /37rUkV72iNy+2Ei4f5lZ9asmzPLwdaHVDr9udwrChiBB6P0/Tk7fksNvG+TqmYGWIInQobLCRHAXbcOGoQytw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250031
X-Proofpoint-ORIG-GUID: apHwGKOb9fp9vXX4h-1UBlzXsopiwhQs
X-Proofpoint-GUID: apHwGKOb9fp9vXX4h-1UBlzXsopiwhQs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2022 at 03:12, Dave Chinner wrote:
> On Mon, Mar 21, 2022 at 10:47:42AM +0530, Chandan Babu R wrote:
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 9f38e33d6ce2..b317226fb4ba 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
>>  	xfs_mount_t	*mp,		/* file system mount structure */
>>  	int		whichfork)	/* data or attr fork */
>>  {
>> -	int		level;		/* btree level */
>> -	uint		maxblocks;	/* max blocks at this level */
>> +	uint64_t	maxblocks;	/* max blocks at this level */
>>  	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>> +	int		level;		/* btree level */
>>  	int		maxrootrecs;	/* max records in root block */
>>  	int		minleafrecs;	/* min records in leaf block */
>>  	int		minnoderecs;	/* min records in node block */
>> @@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
>>  		if (maxblocks <= maxrootrecs)
>>  			maxblocks = 1;
>>  		else
>> -			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
>> +			maxblocks = howmany_64(maxblocks, minnoderecs);
>>  	}
>>  	mp->m_bm_maxlevels[whichfork] = level;
>>  	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
>
> Hmmmm. Shouldn't this be rolled up into the earlier patch that
> converts a seperate part of this function to use howmany_64()?
> That was done in "[PATCH V8 07/19] xfs: Promote xfs_extnum_t and
> xfs_aextnum_t to 64 and 32-bits respectively" - it seems to me like
> this should definitely be part of the type size extension rather
> than a stand-alone change.

The goal of the earlier patch was to extend the basic data types underlying
xfs_extnum_t and xfs_aextnum_t. The "maxblocks" data type change was included
in a separate patch since the change does not fall into the purview of
extending either xfs_extnum_t or xfs_aextnum_t.

-- 
chandan
