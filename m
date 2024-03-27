Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181C47FF;
	Wed, 27 Mar 2024 00:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498381; cv=fail; b=svkT44zPNhpFQQv+PJ+wYZpiSnGC2oq+Fd78OzzFdWJ6Ayy49XqIwYDvExepsPqgMB3t1UuJF9BgzN9HNPpv6r3cb2WDFcyCFHQAs5h4DfpnA6sNAtDzAHOXSDubAR0m9/nb1DwIOcm15HTF3VuYiQczHHUnj84E3ioLcffDgpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498381; c=relaxed/simple;
	bh=eD4MDhTj0WjNYZxwYlv6wLx29+emTnQGHtMAlVWfi8Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z8XDfsGJ9Kok9JZxysmhGloccTFw4Dov6rr9yakGMNs9kD6vEDUYxuS53q8M6M9kuPoWphEyxEqlY7xNw8wT4q3JnIUwN84u0cjZjf0o5xerTdRzsHy7KJrsRKjrMAxsJ8M1Ys7z4USdTBZx41qw8ftUwEfxRlyBVwXF6sZzpOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LqwBqx+4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qitdkyy+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LqwBqx+4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qitdkyy+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLi0kY016419;
	Wed, 27 Mar 2024 00:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Auqw0sX6VUz2uJdB6R8O3dnJ0Nyboi3UaacxlOaG9Co=;
 b=LqwBqx+42Oh0pENnMg9q9tRRigeuiwc3kkQG+jInIWCbkMpGBd78ZJ/au+9RjUEoXYWf
 Ihnj4oldaCYzd3DNF001osNzOE8eyb76SDJvH/01mHHIjDQLrr6e4+7xM2rli1Rgvkl2
 nkxXDwCQ3IwZEauoKTu1eOJKlc/huOaSqEuMd6Gh578QeeLkJY6KdXroRhTnCh8a9OEX
 ygzcTPd4bPd1PvDYzs0g6m7TfrpsVDei6UpIeLMFqcnwavuvxwZvThf3y480JUWJnp0b
 UluXz6qwswcZ3I/41dt6zP8zRQaGzmOFLYI70CuobMi5lErQE4b9BnZhRpqfriKgG2y4 WQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1q4dxc0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QNYHVV021954;
	Wed, 27 Mar 2024 00:12:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh80x73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kka4eREhuD6X2HNyLaNo8a99RSh5wGYoXHybkhWMJWtXBwsaP3RkE6WcOqHOnogbGURlM3CzdWkeAb5H6ETKZLpdhMwh+kRgIdOp+kKmTSoF5JLv22PNsDOEo+WTHzO1TChkYR/Qe4e3bduJPhSSGl6JdlRIZThjTU4vYvugGEl72wrDgUMRP3IufABN7uZhGzbpdUsZv3aQyx0HAJvtQhaZ6iehQPOZnDHNlZjgNNMmqlq0RdkGwzWrSxiclRrbmfTVPWEDgdCcBv7WSbk/lPUT575+iTPjfYpjg7ElQMVOzbZXOBwA8IY5wEmqr8PzZmg3B0SwLs27zwl1BGoBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Auqw0sX6VUz2uJdB6R8O3dnJ0Nyboi3UaacxlOaG9Co=;
 b=VrSALDjNSpXPhNhc/1jFGYqeKiuvMSzBoiGDauhsXW9jq0wVkj17Xugp2Skx1YdwRLTbrfSorFJN3abI/LoXZLV70YRS48/lJuDLLfFqdz09vJ1pCEfDOl9N/nf94UWQo4FOLetQFSRi58kGv1MyOF6EA3cGNvtBTkdnHXZkfijnBd4mpCSsniBlgRTP+Au+PyOhBjuzouxGV56dMtuT81bldmICv7tuM5W/c++QsnEG15kzf0n0jwgYA19B0p2RslUYTLkGBmNw6mEXk8C9Kks1jURbhsCkAhPyrDSQ3gVP00oytnXiK1gbfMTlY5nYPcoxzVdOwOza6v0eoUYJEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Auqw0sX6VUz2uJdB6R8O3dnJ0Nyboi3UaacxlOaG9Co=;
 b=Qitdkyy+enGNtaPrR3DJRMhiUxMmiX5QbP7bPJGzEU4iVuIOzxkwqU9p8UkFm5GQxPxMuMt1TOPeXymJnsM/KPGWtXzURpIVPW08ndNRzzfblbxHHOX8Fb3gWo+5syot1oYAAyJXKx6NlsEThI5xFAQ+YCXVxFTh86XjqszaQds=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6226.namprd10.prod.outlook.com (2603:10b6:510:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:12:55 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:55 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 06/24] xfs: pass the xfs_defer_pending object to iop_recover
Date: Tue, 26 Mar 2024 17:12:15 -0700
Message-Id: <20240327001233.51675-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::39) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bBk3OlJ56xGoO8c4bzfRGE4Vs0zRlq/iZwjf1P+YT5hvSXDbbmPE54FhjKJmIJLkLaPLQyhOdp/b6+MVE4RaG0Bm/fX6u4tCZMx1X0PMJiKvEtNoIMzT8T3GTTv5yITwpSi/4VTGmVd4zxRUVY/95Uzcs/F4gftEXd7218fvhQ7UCxDhmh7/3I3AKsemy59kuEOad/S3FQs1E8chs8fJDy5kbk/XiPjFkoUPPMmOZtFwP59Mlqxnd34EG76ihLT3HdwavDHN5eAML4GXYWJqqKjR7y961P2NBkWk5UkAj8T4jRlVRm9fBfqpD/Io3Xeaxv9Luibrs6FsD/7+PqAV/OLw3t2wSPCRGkaSHJ42/1Dm2DwOmotW8HHHQzjfwPzwfgCsfd9np+xcTtr/MB4DtVv3lShhXN8EvVvioCMk3e0K1n3JEj25MmOtEynSALIqIsycJXXY2FC9V6jwqi4M3vSRMA5tU+JkYCqY70/6u+HNgakUwHjRld8v34hZyRp3d9s6Kfl6DoJ7vjZdC8VfQ+4wDkRYaWPaFXkXU68N9RH9lEtQ41ZE6ylDlyT+/QHU1SpVI2iwP4E2XbfWXNbCSHO1IQMrffgYh3q1Zos8Ytw5xoafDGPe2tRKJ7EneiHyxjmsGRyedFGEFQsWfAEdr+deRv7ZMECkqpv8svsf5CI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4KsB4la69E9HiLpwmkMWOWjLZAk73TlP8lUwst0CnwT2XcrwrIwzZmSkFGEO?=
 =?us-ascii?Q?iQml+srgyDNObwdMaYgfNqb4svVb+XJvrS1qVawL8QxTS1X99TYBpOQGmc7t?=
 =?us-ascii?Q?ofJmT3idT9HcMjt7Rr0iqLxsV9nwsn8MR2xozG0xMgR1qMFBD7/d3AqANgiZ?=
 =?us-ascii?Q?kJDJSnwjQG5u86BxaZDSsntwyP5QW2K5b2NJVQpJmqJ+tKDksRMUfeBpOoHE?=
 =?us-ascii?Q?EJn9uo6aSvS4SRBpHLtZnyxKT5MQmmG8vv8WX5Nntb6QGfz/1bVFubpSopuF?=
 =?us-ascii?Q?N3+vD1ZZQ9jLMB+2qy5Guk2kB0zOTvG6dGSr54de3ERSik4pDBwZp/9lYm9A?=
 =?us-ascii?Q?sydcVGnc4T7CQMdr8q5u+Gjt9qWwiWdOX8wjOMA2NsPvSE0W4k45oOpa2pM4?=
 =?us-ascii?Q?nbcKhtG2ZSIT382yq4DApYPI6JoG9ljteDsRXoNvQsJHUFOIhf6dOVuKxvZX?=
 =?us-ascii?Q?z7K9VF9QzHWF04IeGuOFQxR0XfcT4dvBz5QHt2bdbekik4FXCCHk2fyoutPb?=
 =?us-ascii?Q?++Fa6RYckdZ0ftKqPn67RCHtLBsL/I1dvUP31ax3aS4gKV4girltjyp3f846?=
 =?us-ascii?Q?c8LCwhDN3ZMG3QWvfwLj1AxozCfe2eO0RVmkeTOLoCR+8ZQC03vsPEOdygxe?=
 =?us-ascii?Q?oPSyL8ljghKIpkS3sCVtSsCZ0RfurkcZOE4BcXBNyHlXwRGjVGTLKCo04nEg?=
 =?us-ascii?Q?fiNkujmbyJCA0i5UhQbpo0StDcpWh+pKXgMvLB8zYK/qM3eK30zej+TX3uNR?=
 =?us-ascii?Q?yEQwfctaoiVGUxYPh0nOIA2SQjSigGxI63TjNpIoKbgulxF77r9zi7u4oXtt?=
 =?us-ascii?Q?vlFPjSQKRPP8sVNb/phBmu1W1iQ33NBAFzIlYmFCl7LFAMwm/AaDOpfTlEHw?=
 =?us-ascii?Q?yY+49MfNn7XRAdn3LSjPZ8WpSmTBOkA+RyGTge0uDqj1nF4VQ48j9wpPIJUU?=
 =?us-ascii?Q?owmbVVYQwEBKO+SEH9QS5YKDt/VWxzF0P25yk5qKk7OxYgSJF0G0L7T26PDY?=
 =?us-ascii?Q?3A7M01B6jwYM1ozAhruK/XlX+BmMe1xK8gG/fDnqxVDPhmFeCD7GgX0TRKUw?=
 =?us-ascii?Q?b+77Nw0BkpUXwhYQMolo44Sw5PP5Cp2x4uo66oFt/4AjutvHXzts5pq/mFtS?=
 =?us-ascii?Q?fszJXNqjY1fXsCTxBSD7cq/1qfMzTBcGRqcp9lgzhg71gqGtfFqlaoHjkHKA?=
 =?us-ascii?Q?7GYEWH7mau4uSaJ6fY5OZcLa9bXYqxFkhX+uN+FRfgtxF4VtcBK/eD4u0VTL?=
 =?us-ascii?Q?fBj8LTEpA4TWFi0RiV/yY0vabfon8I4SYju7nHWBrUJHhN0hZrAfKqfZc+jx?=
 =?us-ascii?Q?dwb7+q0Bc8yBp+67FwScpJxxHdDac2oZku1AVszDiL9oNc2tGqSuLKwaqv4p?=
 =?us-ascii?Q?WUAeEDKKMjXznFa31acGoBWMCt0cPnT4hBg67iUfScKtOIhEFkFhYhgZYJRP?=
 =?us-ascii?Q?kZrwGed2ur7atKU10Jhg7o6jWX8XSKTaX589ddPZ/hUR12FHQOSJDnGG7Gzr?=
 =?us-ascii?Q?bwsewHVntcoF5jJY/289j3khfCYTMHSoptJNYV5EUXWJnAElRR/hTt9FHwMI?=
 =?us-ascii?Q?Xsmev/7H4ltDcRBsG8QVUcIfAjvXWZNDw5umELWjFeppiZhhujyplmYaAkZy?=
 =?us-ascii?Q?Wp/Rp2/tp4AvWVqtdDWY+fmyUmhP1wnvjIuuzk6iR+oR3FwBdP4rPLTsZqus?=
 =?us-ascii?Q?xauSog=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IPLZLOrNPuK5+gC+20KEP9NapZ52Nvpf/EjStUKDMqnVPMM21Z2cFzw7hqIPNEP/9NKcDVgvhpu5Wij3Rr95CddTb35TQbovVHNXDIylHDidJ927GLU7a1XKYxuAQkPF/BrdjsM2sKbvfG9zjHF8iE/DdGa7KFhKftk6kofUAjWRHyDacMdhBGwGSmz6DdBxf9VNpQ+cpPlZaruTzhCH4zNGhqbCxI/CIb0gqhCEUUIbaXGIKFOYWE2QJ6oBeXERbxpzhX6zPOOjJh9V8Us+mJi8zn0sFbtF/xIpApu3/+VS2vMvm1Mody0P/2iZYl21IRzUqoJvHZHlGEYQqpBstuVE6w+z2rL832VeFxMYT9Dvb7Uz+PE3gWzrIqrM5guAtRMF9I18AA9OVDVmuF70IxU13YhjuqQLwVDi2R0e05JCuwWcnp/OuKEBvfC6UtmsxALmcgiN9S+yzijUmLbjKK6f55Qg2v/eCkxmEtYYfqhD04svUKKbC18Qxy+B8ozogWztimNKj3Qt70hAfMXNdkC75k4QgeT4WCxA9n1cBmc3N9ZMK14dztnmLLvt1JsNyTbbHFOGO8nQjK/eF8ckMe5UWTTfI7yEq0XZczaie2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f0bd1b-3763-4393-adc0-08dc4df2a6d7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:55.8699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8OjJcbbOG3O82XvpkU0sUpqNFs+cY13l6R+uv3t6XLwZWLEWURkl5YoFq3nKOfUAnP+CIdoVCKaGrQojK9ouobNS4x6QEEiwRjJsxdVAQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-ORIG-GUID: z9O-1LhkDTf5NYkgybJIdCm8eoVPy7q3
X-Proofpoint-GUID: z9O-1LhkDTf5NYkgybJIdCm8eoVPy7q3

From: "Darrick J. Wong" <djwong@kernel.org>

commit a050acdfa8003a44eae4558fddafc7afb1aef458 upstream.

Now that log intent item recovery recreates the xfs_defer_pending state,
we should pass that into the ->iop_recover routines so that the intent
item can finish the recreation work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c     | 3 ++-
 fs/xfs/xfs_bmap_item.c     | 3 ++-
 fs/xfs/xfs_extfree_item.c  | 3 ++-
 fs/xfs/xfs_log_recover.c   | 2 +-
 fs/xfs/xfs_refcount_item.c | 3 ++-
 fs/xfs/xfs_rmap_item.c     | 3 ++-
 fs/xfs/xfs_trans.h         | 4 +++-
 7 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a32716b8cbbd..6119a7a480a0 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -545,9 +545,10 @@ xfs_attri_validate(
  */
 STATIC int
 xfs_attri_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
 	struct xfs_attr_intent		*attr;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6cbae4fdf43f..3ef55de370b5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -486,11 +486,12 @@ xfs_bui_validate(
  */
 STATIC int
 xfs_bui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_bmap_intent		fake = { };
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index cf0ddeb70580..a8245c5ffe49 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -657,10 +657,11 @@ xfs_efi_validate_ext(
  */
 STATIC int
 xfs_efi_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b9d2152a2bad..ff768217f2c7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2583,7 +2583,7 @@ xlog_recover_process_intents(
 		 * The recovery function can free the log item, so we must not
 		 * access lip after it returns.
 		 */
-		error = ops->iop_recover(lip, &capture_list);
+		error = ops->iop_recover(dfp, &capture_list);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
 					ops->iop_recover);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b88cb2e98227..3456201aa3e6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -474,10 +474,11 @@ xfs_cui_validate_phys(
  */
 STATIC int
 xfs_cui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c30d4a4a14b2..dfd5a3e4b1fb 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -504,10 +504,11 @@ xfs_rui_validate_map(
  */
 STATIC int
 xfs_rui_item_recover(
-	struct xfs_log_item		*lip,
+	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
 	struct xfs_trans_res		resv;
+	struct xfs_log_item		*lip = dfp->dfp_intent;
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6e3646d524ce..4e38357237c3 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -66,6 +66,8 @@ struct xfs_log_item {
 	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
 	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
 
+struct xfs_defer_pending;
+
 struct xfs_item_ops {
 	unsigned flags;
 	void (*iop_size)(struct xfs_log_item *, int *, int *);
@@ -78,7 +80,7 @@ struct xfs_item_ops {
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_release)(struct xfs_log_item *);
-	int (*iop_recover)(struct xfs_log_item *lip,
+	int (*iop_recover)(struct xfs_defer_pending *dfp,
 			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
-- 
2.39.3

