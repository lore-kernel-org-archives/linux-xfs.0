Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D02CD342E
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 02:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjISCoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 22:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjISCoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 22:44:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9746895
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 19:44:05 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38IK3pbF012954;
        Tue, 19 Sep 2023 02:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=/qD8DDL7rHZo+QososLMnO0WUpVmOmzkevoYoRi6FgY=;
 b=I+rRu094PBhjdYOL8Yn/ht6na6UKWoIS3kjx/+p2rBvMdms5LGsB7c6LvOSO4WMuSJkH
 SOxoZ6pGQH0/fmQolGeH1i1R9il1XvvIUCjCbOPgGIt5k+B9xhxKZELFoesKyEgnJYgQ
 tSHbCBge4Etb3KdJ9eQ/fDIKHlCsKPx4bCPXH3pRtaENL8vBLCSoNmQ7H4E0HYmdlZVa
 p2qY/xJaFjW/qD6ZJ0qFGWi7pwWcCOwcbR5KfRAeLxnhrgYPzoNCH5axUZeMvunUUx7W
 d0KHEkiveKx7A0kltdjMO5xUdHAcPy/oHDuOgAYjMVXH0HqDmuI4RXjuohJbLqNEoHRH Cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t52sduw6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Sep 2023 02:43:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38J1D2Zf030981;
        Tue, 19 Sep 2023 02:43:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t52jav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Sep 2023 02:43:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kc9ZvUPQvzyICocAf54ZrRswXK5yIVshLhi2wrG2T+I1kgVWUG0eHQy3Etijbvgm2hC9epC068XZqur0DTH2XyThchP8a3RkN/IhXXt97UKmdtpn7Nrb9ejH/ma7oqMOh2qNBIO0ZO/Pv/kwxa9kMWRyjc2Okk3Gxax9f4RIM9BuxqRiswpXz9tlxU0VmmCvVF1+csxdS7ai0T2k2FNWQVBy1hnLYcwSTgZODsU+slVYTwtPvktirtw4zmw+8g3Y1GymIjmDhBqQoq9Gkw9xuFvwr/IeV/MxarXFkNVFYLvIKg3b0v6Ycg8EqvUDX8gcvZPv6wfVhnQf5KN4liHR1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qD8DDL7rHZo+QososLMnO0WUpVmOmzkevoYoRi6FgY=;
 b=lbP0XC0trtZ/0K6ga3V9nkln5/B+4iuAXoAOv5pju9uionxoQyMyU5kbVoEmgg9Mqwk8HxLkYwpkoOFFQKerXMXLQIokn4cCvpzVf9H2Hfh5qbVjUvkLee+Sm6B57lNYzVN8qLAPACMKPawtnlnG+kf5/X8p783u7x1ne5783XZvp2dRhkrpi79fzFRd4uSLl9Msr5dYAwwTKcwINnZ7hB9B8EGqsRwkyl6iDptQkiGepNfjJbPWIAyHB9VA5sXAHo5hFU/Rp/7r0kCxtxBc8b68jbznD7hqkwo2mnVSjDpZNbwRcYPOYoIU2uL3I0yUL2a7vCXyuQ+ToQgHo3s3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qD8DDL7rHZo+QososLMnO0WUpVmOmzkevoYoRi6FgY=;
 b=sK5EQzk9je71rKnqUZhxnvmSjI2uKYgiglmML/q1TExEMmpuMIns32jWe5CSmbzviz/hl+0e3tJ8ViXNJgwgG/M+DzYM5LY5vvTQOGoghRHTrgqHXwpjprznjoikAHC8lws15qvtPYHvp9qX2neC3SbPcbXJMz/hWC8IWlaH6UE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5202.namprd10.prod.outlook.com (2603:10b6:208:306::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Tue, 19 Sep
 2023 02:43:32 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::cc5d:531e:ee0d:6751]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::cc5d:531e:ee0d:6751%6]) with mapi id 15.20.6792.026; Tue, 19 Sep 2023
 02:43:32 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "Darrick J. Wong" <djwong@kernel.org>
Subject: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Thread-Topic: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Thread-Index: AQHZ6qMUuC67vt70cU2Pi0bQM763iw==
Date:   Tue, 19 Sep 2023 02:43:32 +0000
Message-ID: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|BLAPR10MB5202:EE_
x-ms-office365-filtering-correlation-id: 1fd065ce-5ed3-4cca-20c8-08dbb8ba36d6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eu1itqAKEiF5ubddFF0DrW1UniN5mCWmWF0gMg69voIJMiZ/QjNenGohzEJYcVUxbBtuVvUXlMGxL+xYj5ECiGVxegQXghQ1UVN1tsJ56ZWqGBK+jlepsJkkDJjVEYyg4B07cpnAM3ZdTlRsqXlZ05bVllnmnpKj0AjHC8LDgUdDZemD4IA7vhaCr5jemkZZWJu73FrU0dKIaK6rjs/bv+VWIvFwKMttSdzl3kp1jexVvmaMOpO/YxRAvsVvKlhmqFqtY/42Dai1QNf61uzbPwE6d0eNg5AwPbV8V+KUjAlrI12LhB7DbjXTIdm8aaCunpmkBjP3sQKlLghk+QFS5BFTa2kPjb1tafaNkc9EyCogk2W33Fb6deo+ScAuM0QQ4uj3xTADvxWXq4JFAndPMQxFhdQ9SeK9kVxl6Tyv54eubHsUsxXTysKsLoXIqIJR6yXv1au7axg7k7VfL6HfglDqhC5HyroAeIQFUvbv7kC5+meIwNYDUpIFPlfJW/31wL6AXB83D+d5Uu45Q1nlL/3z5Oi0viRvfOWYlMONCRH/oCFwZUq9p2Bk5Ev9i7fl+Uluxr2097y1UGoy8+jqd/231pQcjZoT0o/9KlEdmDyMyHan2yUIcFZExZermVvpp+P/XCs6nTsXTsTKfNUqEBJTnoR52oV3f+wG6omt+Pk1rqPno6veSyfshPZPgCtq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199024)(1800799009)(186009)(6486002)(6506007)(36756003)(478600001)(3613699003)(71200400001)(26005)(86362001)(316002)(2906002)(83380400001)(5660300002)(44832011)(122000001)(2616005)(38100700002)(6916009)(64756008)(66446008)(76116006)(41300700001)(66476007)(66556008)(6512007)(91956017)(66946007)(8936002)(4326008)(38070700005)(8676002)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LUwHNGTvOsm++alLmZCqdjINpt56dBoD+AyDYnfJC+cvwSj+XPDKYq8cTN9m?=
 =?us-ascii?Q?9KbHLBbLuP8gX0fwgYZxNmnsQmIFePc/p6t3wWNhR7mR63zMUROVT7+n68sl?=
 =?us-ascii?Q?dEHqZyrEMJvaEHWC6IHZV/p2qey5mJDLznfBueWWyR/7rymPpsWGf8+sK1fi?=
 =?us-ascii?Q?AePb/+mn/0wYN6aMQDYqGTPOJUNVp0E6jp1mW5QaCQyyF1nc4l6g3iA28u6h?=
 =?us-ascii?Q?QdYPuT9RzqkHvJsGzT9LUtxStb6bY6y5ZWibAXZA+zumy/LprWM88oqNuilA?=
 =?us-ascii?Q?JwUcVvxd/wueANBoEstnLjJ4WnAw2n22npwt9TE2p8s4uPYDjUasRDuXmYsd?=
 =?us-ascii?Q?PYHfeFXGsf/ApSfLSGWZK0q6JP+PxHD+AfEsRZQUbglKwzDAmMqDjHV8x/rR?=
 =?us-ascii?Q?oCLQ1M4GBt6KzCOla2861h21kuv5Q/fY0aMtZJzInfqrdVJUZ47Ju8rQPKwN?=
 =?us-ascii?Q?pEKpT9P58ZL2PzUKzJNeaH+3gLpn7Vn4+U0o8CWr3e0Re9hn9NF+IVxZROzi?=
 =?us-ascii?Q?4wDebLnfVCRrW5eVZqNOiLbUQ3ge/ggann6pti0R8nTk5k5P6183pyU3KBFm?=
 =?us-ascii?Q?v1uaS4v7FuJuZfpUY0ndUOv26tFAq/nJjiIWsxQliyusM8osvPNRMS9X4FMw?=
 =?us-ascii?Q?vUmXwZywwQkrzxLlcfueGkEH6i7D4wZPHru+UAMQCt2ozHw1p8S3rKF1SxjG?=
 =?us-ascii?Q?QconCuERcccrYMnfD3R2VbzZYPwXfPThFDbrutPf0lpG8a5G/d+vvJvTmmwz?=
 =?us-ascii?Q?px+9FBUk+UDfGqc+jZOW7JB7foh81ycf/jYHFH6tKS4Z/afpVlOnSVY7oEQS?=
 =?us-ascii?Q?BwxEXBckic8SYYI+iW5BXuKmOaHohBw6YAQza03iOX4Z/PD5fgC7GqgUqfnj?=
 =?us-ascii?Q?6HjIZCMckpzETILQuJ2zRKXAXXBctkrGqeYKnx9zXJ4Sb5IvgJMj1Fc7vWNR?=
 =?us-ascii?Q?sCY6ttTey3F2Edr/qqX3JMN6sU/SLpDtI/TJsFyuZfkkOSHFbnFSgtWZ+8Gb?=
 =?us-ascii?Q?KoqSpGF+RXZRJnLw9MbRdfrugYnfahMFr+HiR4UmSpvKpg5VpNcFKpuzyTn3?=
 =?us-ascii?Q?ocRrp7V/hAJNVdz9LEBAbawmo0b0uo3yOjB9IzdMlyKQ7ZmFUOBFeezESWCW?=
 =?us-ascii?Q?rInTrFXRmx1ZP3nMLmQo0zFQHx+Vy/vHYviEe+oX3s5FMAx4sxIRuTdvh0Bt?=
 =?us-ascii?Q?gNL4suFpGptPWNYniqdzV7iK7oX8jOQ8JVEYQDsTjdKwQvYRZPw3tMND2PDP?=
 =?us-ascii?Q?rdpIhKb6GL5QZ1z45i18hFYHtAh/uPvbBbTOpVWfbGJgR1i2ctrGaHFvFJ3A?=
 =?us-ascii?Q?CTjLBCJKZhuAKLDAbDUK+QFqZOOqFEyQt4T9onF77ejazhE/GPXmwaAEvQq2?=
 =?us-ascii?Q?Ikd+MoNDdHzl7H1pYnGs1azWUZ/zR8SA/iPAg9SOGTdIckEbej9diLOxrCce?=
 =?us-ascii?Q?9SWDUlFF+Ar2mPv/Ahs+4oOyzI6XIS/stPNkk9DUP72AnhvrBTHRH0Ug6sAu?=
 =?us-ascii?Q?kbyBSKuiWWndL0wtZZlyJI9Qh0NZ8fZC10rJLMUFNVwSFV/olS/PUiWL/SVB?=
 =?us-ascii?Q?UklbPeRxUbt5jeyDmdoPLfZ2hhtB+x1CFbgjWq7mIoDTByQ1IVkoAX430k3M?=
 =?us-ascii?Q?oA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9EF8E88877C2894A8F38E5D0F1DE72F8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ikhMXxs3tV/2W7UWe81VTgU6iKb3A1MrcWTMx+Hzoutt36/Ksz+356EoWhozjA5f4CqJHFysII/NaaqjIt7b3HP6dPVKTuYr8iEqzLEahkA9xLIMEqdWufmMNoqdD0xaAE1mo+jtdj9rD5umGynvqONlCxGlg5O3g8ejxKmjBW5WioeifMmphuX9Bz/5OT82p2ILbScLAeo8fiUPRMFewhZDQ5PCoU2+s0n1cgQ1bsPSNeyRP5LR6OF5rnkgMfeJq+xyyY5BXd1dLTpHaGZCk3rqo8eH4s8g668QWEov1fUSSQz1EQ8j2Yom0oUkJ1XK8dxXN4XeCPGkcbZKELCFEvggUW/JJgw1J8jH1wS7JFrcHGazWhZ62QcnVibdB08Th1ZZyZ9vij3Dze3+MqqKvEpfUkniAklZvNP7SLGw2fmuSCjfEEPSOgA9YAVWnU4OseQCF/wRY13msXTj5SHaqdCMu5gDFS7UftDbPndbdMBXqS76MH3g93TNFWtO09BeTDdckDGS77U3ZQj1nE3P/9m5XmuF8MYRURfnQ/pRm6IdPRqZSH0qOUyVc127qEj20+05nZEUmMbzDxU4jznoj4P7M41dHiuwojxWCaGVQ+qzNpJ3GcJ7esx/GK8xOHb4a/1++PwVXUe+UfHe3AAgbCdZo204VbGXhEO8pfXYsSWU0wWy+vP90o7nyCos0SuSrrrWZe7E8idGXYLCVezxGoVsUKNDVBo87SGf7Yfv3kyclwE5HLUv5t7um7MouqM6NiM77uEmWgXKrqwR9diicAmeR0oRB3z919ZZ7PuYw+4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd065ce-5ed3-4cca-20c8-08dbb8ba36d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 02:43:32.6462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mux4bhkwex2db72qA+UT2tBhe7tH+LqhhfdEx64WFyUzvRITj95VnJI87EAoL2YEPY1dMfXACzeecXXn64B9KwawyxlBAv8BlWPS6LhGTZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-18_11,2023-09-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309190023
X-Proofpoint-GUID: t_BdsO8PBmftbbU_2x9rz2iGdtkcRWGI
X-Proofpoint-ORIG-GUID: t_BdsO8PBmftbbU_2x9rz2iGdtkcRWGI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Darrick and I have been working on designing a new ioctl FICLONERANGE2. The
following text attempts to explain our needs and reasoning behind this deci=
sion.=20


Contents
--------
1. Problem Statement
2. Proof of Concept
3. Proposed Solution
4. User Interface
5. Testing Plan


1. Problem Statement
--------------------

One of our VM cluster management products needs to snapshot KVM image files
so that they can be restored in case of failure. Snapshotting is done by
redirecting VM disk writes to a sidecar file and using reflink on the disk
image, specifically the FICLONE ioctl as used by "cp --reflink". Reflink
locks the source and destination files while it operates, which means that
reads from the main vm disk image are blocked, causing the vm to stall. Whe=
n
an image file is heavily fragmented, the copy process could take several
minutes. Some of the vm image files have 50-100 million extent records, and
duplicating that much metadata locks the file for 30 minutes or more. Havin=
g
activities suspended for such a long time in a cluster node could result in
node eviction. A node eviction occurs when the cluster manager determines
that the vm is unresponsive. One of the criteria for determining that a VM
is unresponsive is the failure of filesystems in the guest to respond for a=
n
unacceptably long time. In order to solve this problem, we need to provide =
a
variant of FICLONE that releases the file locks periodically to allow reads
to occur as vmbackup runs. The purpose of this feature is to allow vmbackup
to run without causing downtime.

2. Proof of Concept
-------------------
Doing reflink in chunks enables the kernel to drop the file lock between
chunks, allowing IO to proceed. Here we test this approach using a fixed
chunk size of 1MB. Testing this tool on a heavily fragmented image gives us
the following execution times:

Number of extents in the test file - 419746, size=3D150GB
 =20
command                       Time
cp --reflink                  18s
Fixed chunk copy(1MB chunks)  20s

We also performed these tests while simulating a readwrite workload on the
image using fio. The copy times obtained are shown below.

Using "cp --reflink"
read : io=3D497732KB, bw=3D4141.3KB/s, iops=3D1035, runt=3D120188msec
   lat (msec): min=3D41, max=3D18240, avg=3D467.09, stdev=3D1079.23=20
=20
write: io=3D498528KB, bw=3D4147.1KB/s, iops=3D1036, runt=3D120188msec
   lat (msec): min=3D44, max=3D17257, avg=3D520.01, stdev=3D1144.76=20

Using chunk based copy with chunk size 1MB=20
read : io=3D617476KB, bw=3D5136.8KB/s, iops=3D1284, runt=3D120209msec
   lat (msec): min=3D6, max=3D3849, avg=3D385.28, stdev=3D487.71=20
=20
write: io=3D617252KB, bw=3D5134.9KB/s, iops=3D1283, runt=3D120209msec
   lat (msec): min=3D7, max=3D3850, avg=3D411.95, stdev=3D512.18

These results demonstrate that periodically dropping the file lock reduces
IO latency on a heavily fragmented file. Our tests show a max IO latency of
17s with regular reflink copy and a max IO latency of 3s with chunk based c=
opy.

3. Proposed Solution
--------------------
The command "cp --reflink" currently uses the FICLONE ioctl, which does not
have an option to provide a chunk size. Using the existing FICLONERANGE ioc=
tl
would allow us to perform a chunk based copy as shown above.

case FICLONE:
	return ioctl_file_clone(filp, arg, 0, 0, 0);
=20
case FICLONERANGE:
	return ioctl_file_clone_range(filp, argp);

However, we can improve on this method by implementing a time based copy, i=
n
which we perform as much work as possible in a given time period. For examp=
le,
we could do 15s of work before releasing the file locks (recall a node evic=
tion
occurs after ~30s). In order to implement a time based copy, we will need t=
o
pass additional arguments through the ioctl. Because the struct used by
FICLONERANGE is already full, we are not able to add any new fields. Theref=
ore,
we need to implement a new ioctl.

The proposed solution is to define a new ioctl FICLONERANGE2 which differs
from FICLONERANGE in two ways:

(1) FICLONERANGE2 will implement a time budget. There are two ways we can d=
o this:
	(a) Define a flag that permits kernel exits (with -ERESTARTSYS) on
	regular signals. This is the least invasive to the kernel, since we
	already have mechanisms for queuing and checking for signals. This
	would not replace the current behavior of returning with -EINTR on fatal
	signals.
	(b) Add an explicit time budget field to the FICLONERANGE2 arguments
	structure and plumb that through the kernel calls.
(2) FICLONERANGE2 will return the work completion status. There are two way=
s we
can do this:
	(a) Add the amount of work done to the pos fields and subtract the
	amount of work done from the length field. This "cursor" like operation
	would set up userspace to call the kernel again if the request was
	only partially filled without having to update anything. This might
	be tricky given the "length=3D=3D0" trick that means "reflink to the
	source file's EOF".
	(b) Provide an explicit field in the args structure to return the
	amount of work done and require userspace to adjust the pos/length fields.

4. User Interface
-----------------
The current arguments structure for FICLONERANGE is shown below.

struct file_clone_range {
	__s64 src_fd;
	__u64 src_offset;
	__u64 src_length;
	__u64 dest_offset;
};

The new FICLONERANGE2 arguments structure will likely be larger. Depending
on the chosen implementation, we may need several additional fields.

	__u64 flags;
	__u64 time_budget_ms;
	__u64 work_done;

5. Testing Plan
---------------

The fstests suite already contains tests for the existing clone functionali=
ty.
These tests can be found under the following groups:

clone - FICLONE/FICLONERANGE ioctls
clone_stress - stress testing FICLONE/FICLONERANGE

We will also need to create additional tests for the new FICLONERANGE2 ioct=
l.

- Write a test case that performs a FICLONERANGE2 copy with a time budget.
  If our implementation allows FICLONERANGE2 to be restarted after a signal
  interruption, we can test this by creating a loop and setting up a signal
  via alarm(2) or timer_create(2).
- Write a test case that generates a file with many extents and tests that
  the kernel exits with partial completion when given a very short time bud=
get.


Comments and feedback appreciated!

Catherine

