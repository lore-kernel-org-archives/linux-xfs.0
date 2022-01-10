Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC61C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 15:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236389AbiAJPmj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 10:42:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51822 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236361AbiAJPmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 10:42:39 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AE356k024767;
        Mon, 10 Jan 2022 15:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OngPzysjOj9GlzBi3DySUhoE87UpeFXQHKkdQguUdJo=;
 b=0EBD2L/AY2Gc6LdyB1ieWLaWAUJyk5xT3aqn0y+L97iQ5p39gctV+uKAIGP7z2F2a236
 UrrnYS+t0k7oHOOMzVXj5z8eByKMZLvGTSo95crcATqQ4iOFcMroA5pvgLRXzR6srVdv
 CmxKj3sfayO+ra6vCQjNSm1yRsU5qWhXXW+VooXBRejBcnYweoY7mQkGttYmTcvhIVIm
 DIi5bKJ3jG6Retp8B/QoRkkC7XTiaicQ0j1YMARVpi8gcegL/tEqXjs+vmpGm+/su9M7
 mfjNNmaMVzFUjgbd/wtunETIsVj8LSpBwZpQwDh0z/OQdlNRBvw1eEbQ3YbcnNP76wK1 Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgp7ng9x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 15:42:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AFfvSu114659;
        Mon, 10 Jan 2022 15:42:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 3df2e3era1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 15:42:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwVkfFLVPpvrpdPyQai9k8zk8e7G41uQqfVS4lqn1CyqwJ2W9vdBkz0hoisrZDjODNqoAD1nEXyQ5HsYsQ9lnrPBeKIiarEFRe9cRqt0FFMWamXUyt335cv0KDiP1u/IwwEJClmnldL/QM+32GcgICFa9uInZl5wjOXuhpvuQFCBfx8EBxrMQga9u6T3GxvJJVdNTgIdgR91z4ANELoaplmSgcqgw6F+3dwh/+dNBv0hGtvNEyBjMq/KRSZaY1/OlprBqAaiAj4fxJMi9lcjXAzHF9/n/mFoFKZRvXnx+WWqP1p1DLHvcRC4IdP/B8hvtV9OrQ0ANUOTLkYEhV5Keg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OngPzysjOj9GlzBi3DySUhoE87UpeFXQHKkdQguUdJo=;
 b=mOhY/gYDfWhvn2s1qfA1B2hurfZNVOviHvC69NCQVhLWKk9TKd3VKjOyBT92q5sNv24V1MZPBGKo+o6Pf95Q0UTjdD9u4G5N79hqwC93J/RxGpkg4fzYVrdFZVyZdsUYqfbR23IG9vPGhpK9l8FbuBOAdrBq9CgOXP9yS95ObTw86NGFL1q9XPMXzImSOZsoKbwpKoy20AwPRQitKS2QzLtYwVsy9ynonyV2fH7HMfMIK43vR+tldHwsbw12XlDaj+59VAZK3o3jCtXnluT3NT17gS+GU2K5kEJg9NjNJcHA1KVOlSWYWPiXNf5oCTdAR0LCOkpRajti3RNDh3XGeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OngPzysjOj9GlzBi3DySUhoE87UpeFXQHKkdQguUdJo=;
 b=ZdPfuB6Eu73vv9Qd0/5zW3Ohr3fr/eNH7iMuMyjpluI6OG/t+fFdELt4C7GvDKXQPwBubkVXzHXRFjOme3EXkONKkOIFUWdRMQHlgWlEAVFfuffjBt2AjTnCEt3yP3Oq9Eviu6YEfN5HAb4U+2BwqlRwzFm269p4UaEXSF3eOvw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4571.namprd10.prod.outlook.com (2603:10b6:806:11d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 15:42:32 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 15:42:32 +0000
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-20-chandan.babu@oracle.com>
 <20220105011731.GF656707@magnolia>
 <8735lzwmex.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220107190346.GS656707@magnolia>
 <87sftyursn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220108182813.GT656707@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 19/20] xfsprogs: Add support for upgrading to NREXT64
 feature
In-reply-to: <20220108182813.GT656707@magnolia>
Message-ID: <87r19fr40w.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 10 Jan 2022 21:12:23 +0530
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::14)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9d95fd7-dbd4-4dde-4dce-08d9d44fd10e
X-MS-TrafficTypeDiagnostic: SA2PR10MB4571:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45717ED05A0A38261A33E1D8F6509@SA2PR10MB4571.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7RXcRv985bzQ/xGAsu6qsdTX05fAmbms81MHvmNBYv9bCYgP2Ic1SWqeRV2+umbWH9j2xZ7hXZNmD85quuI8BDGVV8GyqsojcSxJ2LqwerU9U0+mqehLM1bhVue0kEpsuKwx6tB8QDKAg0RkRyih1HGIoBB7bNRFZYrWummCu3+x7xjdDZJmfY0D6krxZQRKXZmszFcIpgXQZ/OF0vVGFTu69dTEkeOmVQjyjNPY1haWTkWcV/VfOm0J361Jeu24WcELoKUjN7gkeTZhuEbKZDpoFdp1a3z1giE9f0Oaj5G3Tp8e79JGv5G5c+p6JDbfV7HsQrlQsvH70tMEzWvpdoDh+XpBgdXWevG/p/y9Wy3DLpmBZzBdoH4WpP6M3ZFbkIiIeEkauNZk2wt10aluyEUYMe1eBzaLeegvKua9feZrEpXmUN4faO4WQJ1K5zFCkgBZtBM/nI+lPC3EyU0sApzSJIS+VQXEMufr76tMFVP1SOutFE9uBMRR8Olz6+xVZSmE0JBtG0DLyNRQhMfcx1auhNrMAqxisHMUELEjjseS8u8SQgc5gax++0V4SEpazeOTX+cVS4rJuk62GhK/WsqSiHN80XUN138FpQQcKPgFGocDrg0B/HW18vCOD1tk6nEHIAErmj3S6V6XHAEIwDjyaPFvA52/YyGshsRsnLkxEmuBdB0FqqkCgS+ZnVuIhQVdgN3+LOzyA9W+iylUS47mmkz06qPt0fFGxZsOivOzVy8EGuCUEKnoB0xIG2rCW7p4kpUPFfr5RxIIACjfs150geFIsaRDdogxW73PEoKtAhsltB1/3hk1QGL/oT0A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(5660300002)(6506007)(83380400001)(66946007)(66556008)(66476007)(6916009)(38350700002)(38100700002)(6512007)(9686003)(4326008)(6666004)(966005)(6486002)(2906002)(53546011)(316002)(8676002)(26005)(508600001)(52116002)(8936002)(33716001)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FxczL6AeUQwJOxkMgKY2T+wsO1qyLN6fdoDV9gHmA553hJztkJDw3jGEgi0F?=
 =?us-ascii?Q?9rwhODLM6bmi+w+SOfRxW1bsJcp7UCfM6fStU0v3J7ed1MAe4DweXc3XQHBa?=
 =?us-ascii?Q?CuCLdVjX150e8KopUatF+NeFTFUODtW+te+TNlAHpn9tKnx4DHaygRdGXAJQ?=
 =?us-ascii?Q?I5Ume5MqmXZTkOYwHc0UA5RQUnK1liJLHLK3RCOdN31fkodgtWSP3BBkzoZC?=
 =?us-ascii?Q?yDlEMZhTrBlmMd1A2gYQJ2KYuY2H2DNoptysbh5t0NFFqDSoC3mtw0yM1OqU?=
 =?us-ascii?Q?j1WNH9+w/F/wQWa977TmTrzlWpxoM6VLl4VzhKqXlGNQwiE8/gjaz/QuGfFT?=
 =?us-ascii?Q?b+p5VN1SK31wEO+HOAWW0/cOeQ6Zt6X0P/o3224mLJGK9TYQXPK6pnwhouhC?=
 =?us-ascii?Q?R07ygIEyTEU7wR9Xk7cLyW3nID6ul90yXQtY3qR4WPCvckEloEYESd6gOrBj?=
 =?us-ascii?Q?7PLHa3T9InUxHeRkpHsk8UY2RGePsYTP4vovKkkwSruwsH+J8oYAzZI1nQ59?=
 =?us-ascii?Q?Ivdywj1CtOt03PXiispK0BGMSLwjM5LCXr+komMFk9LzhOit+mkDsQiBuOpF?=
 =?us-ascii?Q?TntEpiZh074YvscDgJPajdFp0A2HejV5k+ZReX1maIkbq3Pdjj/LwExRTiq5?=
 =?us-ascii?Q?qeKlOtUvJ0WfLC3SOhq2L9WgBJHPndnzkDLLD8YkNfyRd0e2/jDfsOfoaXAc?=
 =?us-ascii?Q?0sbSEefxcC3WnrRv8o6x3oX6OELiBQYGKPslEREVuWOCcL0FenY6V1P9QxP3?=
 =?us-ascii?Q?JNco7X6uf41U/wy26Ne3UF/IDGoktKQNWsL1ObQR6G9bA+uOVT2KMGVC5hzR?=
 =?us-ascii?Q?+lbXgdyo5DM8zonbZaoSbgj0plyaBbWyLgNqdBGO7gTGounSxYFTBIr/5LQp?=
 =?us-ascii?Q?ET+7tQUpXxXMEQttWSeBQYcuHEiSoiTupvOl0OBx3hc4YcbYcF71B3eDhpVZ?=
 =?us-ascii?Q?xfdZ3pvxw8IVpqdlC5TYGLdw/38tgg92RA/PIAvj2wPkdNb0Dm72Ftfj2jWn?=
 =?us-ascii?Q?KWtylCUYoA7wz2TULdwcjFqc+XQEXWbjx49dUpcyhMjQWEi3hXXXg+BWDjH1?=
 =?us-ascii?Q?38hIc/e8yIpcTcDPjehQudEU9w7GSizguNHxErqo5StAKGHMCtPAI5XYInA5?=
 =?us-ascii?Q?9sAIMUYpgHotDk+o15+ksK6SpaHfREBGZ6udQe7mYnqa9oZTZyVQWFD5B/aX?=
 =?us-ascii?Q?cKSS+dM08JFMdI7eHBmY/pFbJeUyYOLL3wb3sTkWisH0NhhfQ2JNJUZUmPzq?=
 =?us-ascii?Q?KweehR6Rgg127vYn1apqfPpB/3pBKUtLrreROBBC8dj6Z2OcQBgfTQNpG1nM?=
 =?us-ascii?Q?L3b9+AYaRHFZannQ8a3xpCoe+J04G6kEr2pa+DwqNXvx+XQsjLvZ3/7TlyXv?=
 =?us-ascii?Q?2VQcgSl3WUgMXBD92C1EFXXPyH2uTueXYh/llcC6U74SgpT+1oSNBBmXzYWZ?=
 =?us-ascii?Q?2fV0QWk9kCFe3PImW/GF1kkK8aIubn/1rREtLIfY8EgMDYkO8e9RS8Jnp/F4?=
 =?us-ascii?Q?y20suoRtyaP6MMjwAhJqYDBnBdtMfnqjHj/3B3kAN+Mix6DzeMGHXUbPhkaJ?=
 =?us-ascii?Q?A8vs1mzDM5RvVa7mPufE0YjMsiV30FQuCK8I5o2F2afOFUEBT8CHAxSHExm7?=
 =?us-ascii?Q?Iw7t96GCUTY077IyUeVhsHI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d95fd7-dbd4-4dde-4dce-08d9d44fd10e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 15:42:32.8717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CnyMGbbn4mxco5MssaIemJhB6SYqYXgXzS4oGeTE5XpMvVZyZL9mmvRNIn7ZFbe3JXlV6LSc01GMWbyWpna5cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4571
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10223 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100109
X-Proofpoint-GUID: BuiTPzeiyGTMGH28z4_sL4zvJ1NxRXHM
X-Proofpoint-ORIG-GUID: BuiTPzeiyGTMGH28z4_sL4zvJ1NxRXHM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jan 2022 at 23:58, Darrick J. Wong wrote:
> On Sat, Jan 08, 2022 at 09:46:08PM +0530, Chandan Babu R wrote:
>> On 08 Jan 2022 at 00:33, Darrick J. Wong wrote:
>> > On Fri, Jan 07, 2022 at 09:47:10PM +0530, Chandan Babu R wrote:
>> >> On 05 Jan 2022 at 06:47, Darrick J. Wong wrote:
>> >> > On Tue, Dec 14, 2021 at 02:18:10PM +0530, Chandan Babu R wrote:
>> >> >> This commit adds support to xfs_repair to allow upgrading an existing
>> >> >> filesystem to support per-inode large extent counters.
>> >> >> 
>> >> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> >> ---
>> >> >>  repair/globals.c    |  1 +
>> >> >>  repair/globals.h    |  1 +
>> >> >>  repair/phase2.c     | 35 ++++++++++++++++++++++++++++++++++-
>> >> >>  repair/xfs_repair.c | 11 +++++++++++
>> >> >>  4 files changed, 47 insertions(+), 1 deletion(-)
>> >> >> 
>> >> >> diff --git a/repair/globals.c b/repair/globals.c
>> >> >> index d89507b1..2f29391a 100644
>> >> >> --- a/repair/globals.c
>> >> >> +++ b/repair/globals.c
>> >> >> @@ -53,6 +53,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
>> >> >>  bool	add_finobt;		/* add free inode btrees */
>> >> >>  bool	add_reflink;		/* add reference count btrees */
>> >> >>  bool	add_rmapbt;		/* add reverse mapping btrees */
>> >> >> +bool	add_nrext64;
>> >> >>  
>> >> >>  /* misc status variables */
>> >> >>  
>> >> >> diff --git a/repair/globals.h b/repair/globals.h
>> >> >> index 53ff2532..af0bcb6b 100644
>> >> >> --- a/repair/globals.h
>> >> >> +++ b/repair/globals.h
>> >> >> @@ -94,6 +94,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
>> >> >>  extern bool	add_finobt;		/* add free inode btrees */
>> >> >>  extern bool	add_reflink;		/* add reference count btrees */
>> >> >>  extern bool	add_rmapbt;		/* add reverse mapping btrees */
>> >> >> +extern bool	add_nrext64;
>> >> >>  
>> >> >>  /* misc status variables */
>> >> >>  
>> >> >> diff --git a/repair/phase2.c b/repair/phase2.c
>> >> >> index c811ed5d..c9db3281 100644
>> >> >> --- a/repair/phase2.c
>> >> >> +++ b/repair/phase2.c
>> >> >> @@ -191,6 +191,7 @@ check_new_v5_geometry(
>> >> >>  	struct xfs_perag	*pag;
>> >> >>  	xfs_agnumber_t		agno;
>> >> >>  	xfs_ino_t		rootino;
>> >> >> +	uint			old_bm_maxlevels[2];
>> >> >>  	int			min_logblocks;
>> >> >>  	int			error;
>> >> >>  
>> >> >> @@ -201,6 +202,12 @@ check_new_v5_geometry(
>> >> >>  	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
>> >> >>  	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
>> >> >>  
>> >> >> +	old_bm_maxlevels[0] = mp->m_bm_maxlevels[0];
>> >> >> +	old_bm_maxlevels[1] = mp->m_bm_maxlevels[1];
>> >> >> +
>> >> >> +	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>> >> >> +	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
>> >> >
>> >> > Ahh... I see why you added my (evil) patch that allows upgrading a
>> >> > filesystem to reflink -- you need the check_new_v5_geometry function so
>> >> > that you can check if the log size is big enough to handle larger bmbt
>> >> > trees.
>> >> >
>> >> > Hmm, I guess I should work on separating this from the actual
>> >> > rmap/reflink/finobt upgrade code, since I have no idea if we /ever/ want
>> >> > to support that.
>> >> >
>> >> 
>> >> I can do that. I will include the trimmed down version of the patch before
>> >> posting the patchset once again.
>> >
>> > I separated that megapatch into smaller pieces yesterday, so I'll point
>> > you to it once it all goes through QA.
>> >
>> 
>> Ok. I will wait.
>
> Here's one patch to fix a bug I found in the upgrade code, because
> apparently we weren't resyncing the secondary superblocks
>
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=upgrade-older-features&id=e0f4bff35adcae98943ee95701c207c628940d8f
>
> And here's an updated version of xfs_repair infrastructure you need to
> add nrext64, without the extraneous code to add other features.  It also
> now recomputes m_features and the maxlevels values so you don't have to
> do that anymore.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=upgrade-older-features&id=acaf9c0355ee09da035845f15b4e44ba2ec24a6e
>

Thank you!

I have rebased my xfsprogs patchset on top of the above commit. I have also
removed the commits associated with atomic swapext feature though.


-- 
chandan
