Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8970C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 22:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiKIWVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 17:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKIWVn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 17:21:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BC412AE0
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 14:21:42 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9MJaQ8003220;
        Wed, 9 Nov 2022 22:21:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=v6rU/yLODjycjMsMuIbC5MBqvGyWxSS6I96kj36RVI0=;
 b=lTPFEjfKcvfJCeDhaT0mWtjJ1bomcX7ZdDUZipVBp5qKPxAKJVtNX51obOw3cgRdQPPX
 eL/6X2qexcW5jaQBI+ymz09aNshd4VQ6GyzqZs/dw2SofNecau06C3Qunc6+FgUn0B4f
 X9fwtjjlPn5RL+WcztaTjvIlr91tIVSeZd/JoFI7yTjCh9VKtrEMEWjZt4rjQ1ROSJoA
 /u9PmId5861yUp8DIX9lohdwoIJu0Huw49NRvNLCdjeDMKYdvzuYKsv7QMmkwx1/DylL
 lQfiH1M5ZBxJtVxzb0Mf3E1HxAnsyTXG2KOLpaQmjICRQ4FIQo5EidyXuPv65exxvmlJ QA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krmqqr1aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 22:21:18 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9KjfDL040957;
        Wed, 9 Nov 2022 22:20:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsfmq58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 22:20:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLdG8eq1bVTo7vpZm+9km6ogoL5jIIEI2bw7kBqZUpDIYp9R7rvrraQNRQLy4j9PuNGhNGt+PYoV51mHsC77OxdQgaWm3uudEgdNn7AwfGxNSBHTRkaVHbr3vIytrhYAxR3re/nfQTZ83piZ+MYCGohjWKcHDzjZ58bRgGaimYlE0gdG7DtflBpC5hCEhuT6fvqiOwaL/I1wAlkb0hLPpd1mJZae01jFaimHLEzY7dBpDVGVwlT4HQ1UTNj+Z/IDrQjuostt2GlBVUGAIWNrQXmP3tkTDBhCtl2+CRkfsztXOlN+LBtB//veM2gzAF1dQXt8VQP8I4fgymrcYdM/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6rU/yLODjycjMsMuIbC5MBqvGyWxSS6I96kj36RVI0=;
 b=JEjaLQZ5/pi/slJlpHP8FLMjyLIgnUeHaAK5W2QH/Up5MPO1+DUZCWaAktJqYK9h1zkc4IGIL0/cKtB7Vo7KSrEZy+Grm8BArhwlj4pPdNiHpgc/qe8bcX0iXbiIgnBgj0mi+a3jPdW3u1uoYA9T24QcYt+UOJ5OaFfrw0LwmRB6tsBsm6vZ2SS8tl/FOg7wht1lztC1qzmdDF9nKVaQaMLLlzz/0oQiHFUhi28T+HryHJKlUjTU8RyzCi/W1PYbpJg0rdeKBm7MJTJUy5spY7a7G01zNKDhXoKJtpbswrawhcgh1fNU0dhJdTEpEjFqIYmPzpjQQNuh3x72Sg3r3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6rU/yLODjycjMsMuIbC5MBqvGyWxSS6I96kj36RVI0=;
 b=sTg3Cg7vRHk4huWtcqgumTGNJ6gWIIWDIEKZ9jEF9RWEGGhL1fd217QyaiLWQXN4Gvq34B6gKzxUfk9y/MhPb+HAnnHO3Uv0b/IjWCPIDDenTcjvLAeCqVfPcR+GW8aNyMEqCG8+I8NKPqzD5vnUTzI/SW9Q7WpsqGA6ZCjZhdw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH8PR10MB6672.namprd10.prod.outlook.com (2603:10b6:510:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 22:20:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 22:20:09 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     tytso@mit.edu
Subject: [PATCH v1 2/2] xfs: add FS_IOC_GETFSUUID ioctl
Date:   Wed,  9 Nov 2022 14:19:59 -0800
Message-Id: <20221109221959.84748-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221109221959.84748-1-catherine.hoang@oracle.com>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0115.namprd05.prod.outlook.com
 (2603:10b6:a03:334::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH8PR10MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: 077c6c92-eb6e-403f-ff38-08dac2a08fd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zm2DMky7syMew+d9wkuBjB/LXHRG6qKHVaHNtLGtuP5z6AjcLctnCyYw91eo8km45J4g12Ph67z3GC6oLYfnS/7FuNbkscdaBevpwzY2YZRWHq85+Fyxbze+IFxNtVW5iMUFBh9g5S55dy8f/cMYCkAas59rLrn781X6PmBpuO4wGePPPHptdO3gom4XUi1HLxcjoU6ddtIFi49dGNtzGeq1wFaCkD77cwEdvJUkpFzkmlM7pxafniJYvynZSBmqEvsOvOUhqnIrbl0fLp//c1fVRQZFRLZZAZ4kHAyg0YZ+ptYqDwja1Ljg7ZIda7K4FjOxa7t+RPnLhnA4tyIwb5DNa8a68G1mUTexBo+8BHYXL91bNAHA4dZzDg7weigFDq7i58rLzHcVMXiOgtzkBMc+QSw/gF56XpGLR2ZmGVf2nq+igIw9xzInfbzbtHLAKTXXly8zch0vDzm9nGAc8bbRTiCVaEKnicZrjSVEk4J+n8XQxds7U6eT2QosQ+VfqNZBhYOLazoLkVUBa1oYh9XcXSWJiJvp50aJLGRRNIsCFpb9Pny4HIPIbifenIGJbolYD8+nmGn5ijoW0pjUNw1qFYPNN+TtCbo7yGdQBbktJfWvEeavUioLWODpueDx7toY/f0jg7uTcNaJ/6Vf/SLGFBuu/40kbuW4xSuTubz6xhP3fPkt5S5Xh6JqHDwDvrvJLVruvT0XPLTcylY11w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(36756003)(66476007)(38100700002)(4326008)(66556008)(41300700001)(86362001)(8676002)(83380400001)(6916009)(186003)(2616005)(6666004)(6486002)(478600001)(316002)(8936002)(2906002)(44832011)(1076003)(66946007)(6512007)(6506007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JMFunMW/aP5MnCAH34zjBi4kMudyPh9j64B4QHjLmj8Yb+59CWPPXsgK/5zO?=
 =?us-ascii?Q?wbvCGhVkN0xQIVDYVu9MuskmaRK2yLOO2P1VoYcALLpzB7iS3aC7FzLNUTEZ?=
 =?us-ascii?Q?rJG8KLJyn6Xq0hGwMXwfr36yGFbYlKhbV9SgV4vJPNhcN2j98MD90sw/myWX?=
 =?us-ascii?Q?CU5n1qJlfZEuCvkBWpE2xqLuEQLB6qKBxAinFHxLzBVrXuwhsC7XWvXNiuJV?=
 =?us-ascii?Q?+CHEQPTaDpDCm6kdmss5lB508gl4Y6Nb0SiHtRvlhcjSVncYywxpIAktbeAV?=
 =?us-ascii?Q?7bFhio0Pi8IWUDrefMHF812RhcjechzS5c+XV10VP80OsUnhwP/7EZF+WMYb?=
 =?us-ascii?Q?kPUUNmbWCX+7TUkf/4wjPEenPtCqa5iJOao3vdRtvLQhIBCp2wRf2/KCHn24?=
 =?us-ascii?Q?wQSdpWbXvqQY7jrAbQoe5CX37XwZ9N1zfDix/AuPPZmVittw0KUzRk1Sx+mv?=
 =?us-ascii?Q?ZFcaPorFBtGJUgqC5TAVIqDGf3QDQn44R25+IF5Z+vNzXDHDM3FmYpvYKC47?=
 =?us-ascii?Q?tPqQy3ZR6Nldi/XUAthfnbjtrzEwfaZukmk8q5/79rn7ZkILUxqSZPdhZykW?=
 =?us-ascii?Q?MRNdcG/FVSr3+rKW3pz1aPOHZHwuScGpw6f8ymyAvJ0E7TmL/vdmSptTQ/DW?=
 =?us-ascii?Q?2Y7Pvwk1cPX/EzTv/4v2W7sF09HtgVlmUlWYcnUpHKuw4Y+Lg0XDlsiq408f?=
 =?us-ascii?Q?N8nLip0CTorKyNlByvU30R89ZonhnP+8OB9S+IH0MkuXhPOr5/ZopvaaHOaZ?=
 =?us-ascii?Q?5p7ho4lfo6DR04y/f1Pl8dl3W13q76Ffa/fzs7UE01D47FVs30dPDvGNJX77?=
 =?us-ascii?Q?bfQtmj6we7G+TNJvPOh7FymzRXDi136d+Y7uAyWEQgwyfbydbYmeeO03EHYT?=
 =?us-ascii?Q?EnyW7PCSbZdyq9Xf1wQugdt+OLBNPMh7MduGfNc5fisOhVyt3BmsK3HjZ38T?=
 =?us-ascii?Q?yCzcmwdgjlJ6aNGrbgpxDvyCCsytpZJQLTFAHZHAZ5AFo86aE8Zl7lTXCoN+?=
 =?us-ascii?Q?ZhMWLxji9cA4sPnm14xUK+hsnDuQ8etO8aguDYOoO+kIZBsAP5++V9A8Mzvi?=
 =?us-ascii?Q?1UOhJyzm4mgKwYIcMK1kS+Bl3XRwDkdkw6g0jT3NLN77KOPyipeACmoDorp2?=
 =?us-ascii?Q?/2348K9775ylhrrL3ZMozkWAGf+o4wvy7rlo4LVZtN1HzKZ3rjHzMQ8fxrXg?=
 =?us-ascii?Q?5y+F/xcHZnGAVZYRZIqEsszl8KK6dPP8c8TjodVvgv+c4H1kUBXbwh16rv7K?=
 =?us-ascii?Q?iV8izvXMdeY7UlBmPUXz8n15M2JCohmb5f6eO7/pt3shKTht9uXzVDn4pxkf?=
 =?us-ascii?Q?FWUxxiZ2g4r43xLpsJcJmMh2J7O7PGpX/cYAeC3+yahD30qRfb6Hub3nINL6?=
 =?us-ascii?Q?wlc+2aQhvoqAnShhERbsz2HZO+7ns5zbP8fMkyEM7/PryVPv3KDNvwErPE81?=
 =?us-ascii?Q?NPCz/hQNVRQBkDtf5o4XtOhFtQnrxL1y9XCfSdVnxJgefLNm2KaA2OYQc5rO?=
 =?us-ascii?Q?gsSaZhl+aTE+K153jwLhUduF474xMdd23ZPnuZWqoAYdcyHj6dCYViuVG6dP?=
 =?us-ascii?Q?Qnszpzag4iRl9Xx+r1lRSvz9IHwXuw0jkoQmzhHNVowVgr5gvPKIp67Nezj1?=
 =?us-ascii?Q?SF4JjW0UlOn4wwEPOdwkG2NukG1P/ZzV8kTgaiDHqjKUwtN/qOoYyKSctvV9?=
 =?us-ascii?Q?Eyxq2Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077c6c92-eb6e-403f-ff38-08dac2a08fd9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:20:09.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEZyyiytAZ47r019jeWOpY6iBgNaMXVM41fHLyU4kv0c4XfqOC74qnAfFo3CL83cGY+PG4v9TwiztCXp90OovBJI7jwBYIvYsvlXUFAJsrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090168
X-Proofpoint-GUID: NlF9VRV57uG4esJbgct-XiFInNPkfyub
X-Proofpoint-ORIG-GUID: NlF9VRV57uG4esJbgct-XiFInNPkfyub
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a new ioctl to retrieve the UUID of a mounted xfs filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 1f783e979629..657fe058dfba 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1865,6 +1865,35 @@ xfs_fs_eofblocks_from_user(
 	return 0;
 }
 
+static int xfs_ioctl_getuuid(
+	struct xfs_mount	*mp,
+	struct fsuuid __user	*ufsuuid)
+{
+	struct fsuuid		fsuuid;
+	__u8			uuid[UUID_SIZE];
+
+	if (copy_from_user(&fsuuid, ufsuuid, sizeof(fsuuid)))
+		return -EFAULT;
+
+	if (fsuuid.fsu_len == 0) {
+		fsuuid.fsu_len = UUID_SIZE;
+		if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid.fsu_len)))
+			return -EFAULT;
+		return -EINVAL;
+	}
+
+	if (fsuuid.fsu_len != UUID_SIZE || fsuuid.fsu_flags != 0)
+		return -EINVAL;
+
+	spin_lock(&mp->m_sb_lock);
+	memcpy(uuid, &mp->m_sb.sb_uuid, UUID_SIZE);
+	spin_unlock(&mp->m_sb_lock);
+
+	if (copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2153,6 +2182,9 @@ xfs_file_ioctl(
 		return error;
 	}
 
+	case FS_IOC_GETFSUUID:
+		return xfs_ioctl_getuuid(mp, arg);
+
 	default:
 		return -ENOTTY;
 	}
-- 
2.25.1

