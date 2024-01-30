Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E73537163
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658287; cv=fail; b=CnENB1+58P7imPDYzLCxiVdbfvoM3D1ySc1rvHf0pCe6hoHqHw7DvMB2TMAjGraRzRKfpTz3OLKhVYkQxXkCvENikVWWhDjNMbFMZHcHXALqxYJC0/d7rRwMmXdOeYtTT1sCwxd4ZZ5PyLmVu5HIZAF5XfBDctTrSYWeJg45Eas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658287; c=relaxed/simple;
	bh=1EXSZ4iU3I8pgM4bkKizf5fGqqe4QT7Of0bIhF3Y3W8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JIpBPurZm/JffyaM++IkwQlZFYnr31vpSRZxWEy1/EXtmS9abSgW/xQ9qW4XLPPmxiNDaA+PcquorAOfExG73B4/bvUHnC0M7EeahuKCNesMjD7ZJoZdV6Hqrexc73bg6LlwKfo5+Pqtsz6xCNomflQ1DbvYzo/oUw7PbX3btxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kozaPgiW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eKpqwDKC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kozaPgiW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eKpqwDKC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx2ix003587
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=P9KaY+5IMBkxdj2U2wEtdky3D0IGhPhNPnyjLehqSQ4=;
 b=kozaPgiWaUCIpmlDquWqK6DMxaUtlF1SFqmtfcjw3Dz2l2Q96Bv4sVMjycOtrk1wg7ez
 HAyxZlhRvjm9JbiijAPPSOFsShi7npbQJqyvhZcKAxM0N5801D2cMDzQsL/xi2AmmX3Z
 1IA5Qo5/KT9VBmUjP+Ha3aTV39hB8cz+LI58hxFp1BPkYjPelCITRKxcJYLxcJhzfIdw
 M/lX7EzfCuY2PXYI96g/z16wi5DqTFr20S4B+urDIWtmvX0aoSaymK8Ok9NCCluM4E1x
 MDhgyMlTZEA4UHQS5mmYZgALxMgT8T9Nw/uj0iSIDG+ijb4KHJwdc25TuLaOjYwsGtH0 Xw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8eg9hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMTGBD007813
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:43 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9eh1qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQz+lyaOirCftNMrdu95FmMg9PFxtDI1IWaeNzbEQfaFOgCMdrcC6gJabD7q3Dxd/trV9up3UgsLbvtCBUVw17l212m1y3SAkXM3yebnBI2cf8StENW3ltlH729lq5Fl1FQduKnyWThF8A341bTqenH+W0pWg9v+W//1kKkSrzFnoOEbligXErI1UEzrqhB15zoqnvL5Pw3DJ+/56VaQy2RWRJ9LGyM0SUNxgC2anFLjoIwHiX3AroBbZe0K3fhpvWVW6b5vDO6MPPn4i1uwpQH1YEvMa1hM97jaOGlwnN7ENi3ahRqY+yp2ml87oY3S1XZdYvQSHQULa+vbgYyK1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9KaY+5IMBkxdj2U2wEtdky3D0IGhPhNPnyjLehqSQ4=;
 b=GsFC2frRz7wS/x73Y25GuHz5Lcg4SrbUM/f01lcUrQg5XHwqtQlfFtU7R3GBWLScDiQLWCGXrr7Dgbytzl5AXrcqaqqjxMAby+M7/bnYF2NPhZnhpmCq4wk4CfKFabFMjbyYUQHn4NuqPPDMVW3u7sJ+JQecZXU+C/gupBl0RXcsuIVN391nsdLc/RNi/NfyA9fcxblGPYWWJfTaAYxB4jLg/c7KnMhFI4U/CIbM27LqSwqtRL09V/IdEmP87elUNZggU9lFHvlQMNZikH3j7ngO+1p3laKAEGlypGGLwz+j/AnPY1oXxMplRKynH6JvRn2TMMdCe78+i9MOezc/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9KaY+5IMBkxdj2U2wEtdky3D0IGhPhNPnyjLehqSQ4=;
 b=eKpqwDKC3pNXL7nfhgyZ6sVsN2iZTS4mIBCZd4LecLf3chjEop2VFdavxXqFMow4Hd19Hl2qsRvrad/Yk7j57zT9ApJzlZQ7VwDmDgdmLXCSv4Qhj8NpTNrP+XVewoXONfv8iRwxkF4DPUnnls816Xn9U4ZlirLasBovFzcJ5xk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:41 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:41 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 09/21] xfs: allow read IO and FICLONE to run concurrently
Date: Tue, 30 Jan 2024 15:44:07 -0800
Message-Id: <20240130234419.45896-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 0df8ac19-9015-4457-a575-08dc21ed6d94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	YoayiRmttWDpK3QmJW8dz98lOBnGal9rBqrTAFMrTNJQvHS97PkyUNq9u5z5LHiac18ZPxRJw/OS4h1Cyglk6QxRhJNV6J2xoEmqfvofxZ74gv59ZOBuYo6ZJT7iRIBOZ8XJfmG+IHqnp6813gf6O4OVM1sZzp3Fvf/hKULVy1z18JXTGZoFneOGlaKxbpgPyMIfrDCpWbDmyeOMM/H+N7oeNyjq8NignorRtx2ENUBRH5p5j5qd/BTGfQ++mDDmVoq1pLXHG/vaOCPoQvWelMGqC0Xl6EcOt2H+MOB2AlE8gP7DRELXrAb7rUpHNY6qFjA9EbIZGS+6A4bS6itrp2sEV8RrDE01W0AQbf1qevrfPFpRn5xvJbNY0aauz4QRrsBMN+Iue29usF4po+zBwccVSaSnxp/u8vmjiquabckCDi604StqNs6RKwgIGOS4yzgdpdKC6gB8N5rvAPLm+M9MTDmwKyLIlxWhXYv9+OIjBEMvT06LfJW/pKzxg2Mf63TGfU+vfXX+5af0Z1adaiUvxmYf2tKaIZfItd+J/Ec=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(966005)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VOIZdVo4D3jY/Mfnr9/vvXrWqdrK6/mXhINjyBAOL76cVjGBOcYt923A0Iw5?=
 =?us-ascii?Q?SCEuRikPurBF0oh50JHUwGzQae8yf8YkHA/vpAA0RgQiQoBqMnPy0R6NpJ5f?=
 =?us-ascii?Q?LIOGqs3Q99u3VeDd6Ott0os0bRNTnZFNjgVpI6RUH0ZTfltyM0ZOyT9LMbo4?=
 =?us-ascii?Q?wbqSN5pumFVpIIrnJaNmeIlGtCm03YKW3DUHEP4Zj3NjygsPVo9W5uukyPhA?=
 =?us-ascii?Q?rThDdypqYNtTy8HI+b4YxQARNhaFkb4WOXcuOTSPJfIpj9zOKTynSdZtJXHM?=
 =?us-ascii?Q?GaRHjejxtoqjSzzGkE9dH/RBy+HKRdYAlZ6IW9Aj7ED2jtmOHhu0/+FIutCK?=
 =?us-ascii?Q?WPsFmXwUENxJDefk3YRY7dQLX5sKtE6zKTpLaMTogaiKCuFAEKsiZ4jFyfgx?=
 =?us-ascii?Q?vETL8hCNCNNiTrkHVxWCa12Y8K7pRtYyhgpKUjQ+jb+wc57An4PkbpHoDYVF?=
 =?us-ascii?Q?cliuWLDe7HV/fx3U/5RUhJwnE6zWSQ4Y6dS3MsBgPXFy3dnLNxu1li3pklcG?=
 =?us-ascii?Q?FNfkdV8LSKMI4P2u4cI13/vcNAygLEqccau234zldw3NMNnGtWD7Nbe+HVqU?=
 =?us-ascii?Q?TENFqpS67uu8vILRZA4JIFjuVJGRiQ0cR0f5XedMtX/flwDnZeYExt0FaOH0?=
 =?us-ascii?Q?0FuV7fynDpfIgGW4cnnsMPYSQg7d3qHm3So08qjJvD/LgcsRm4e2iTGqFBKj?=
 =?us-ascii?Q?HUovkcGY4NEqj9iVHWA03FkcLKoFgL01r41KL8eKhGNpyrr+4his6dSF0wtW?=
 =?us-ascii?Q?K017ND9K5gcZBKBQofjtulW457FFioF4Q6EbgWv1Lblm/8hnNRZq+A6SshjF?=
 =?us-ascii?Q?/upiS+kZrvRARE551klVhsBBbmwO+8/zZrUwNs06/xvvSPHXh3XSWWEkNZ3N?=
 =?us-ascii?Q?XB4p8qmMhrVvUf+iNOkdKTKTi+RyZ4azpYUuAQPcOY7MfZoO0Mx/jYW9NHWf?=
 =?us-ascii?Q?PrfNWw68VAnIxtgkBi2MumDynTyoyptDX//vL6X522ErSrIr5v8tANgau+06?=
 =?us-ascii?Q?3uP7rs0pPQ/efreU5yZ7tQtK0wn5rsmh0Gn3Nur305KLjt/cWiHjiveegSMT?=
 =?us-ascii?Q?ZmvkH864+6AYVR+GYQou1CPUIHRdMA4Zu0jgtTtp03yBVsY8WbwqAbUu66yl?=
 =?us-ascii?Q?jDhwoNoZFBAk+ccn7rPNhDdZ2jwCyVvhlDOC+XiiS8z//c/ydfRF0gNVA9Y3?=
 =?us-ascii?Q?DNcgxeIq1lSyteSnfQ7+rWtr9cqniCk1pl1fbGWuTzF9uGGuQZyxC5mnGkqe?=
 =?us-ascii?Q?mYvGhZ5NPirLjh07+/2pC8qIkOb4HIXmSkcaSaWbc/hF0AdX2forFNsKubak?=
 =?us-ascii?Q?8ztTJepvfFXPH2ECOkaINpcrxq+clJXmgfkY85kEgTh6kz2f1MfCOxKtbpo5?=
 =?us-ascii?Q?Av46aA4ZTS4i/Z5qQJ/0hg8TUZ1cIUCBML+BzKMOPbNlpQbi/SVqVD7RIJqa?=
 =?us-ascii?Q?b6Q3BdcCuPgVP6aosbRrJVVLFfv9jbwlKsq8K9aFs03L6bUykV5ZnURqUq/s?=
 =?us-ascii?Q?xqaUJDgqNZ121DLaJrmrWlK6ikymw0o5Idlm38xCnAgcTgWxT98LPFXTRl9H?=
 =?us-ascii?Q?LD/SiSWzNmWhztovbej9fgzDFzl/FE8KDWBLzhJHEBO/mx0ig+/Si10jN1jO?=
 =?us-ascii?Q?I3VCHivaXusX+EudoUi6vjUbG7deGLqcgjIPlh5hYZdRn+e9fTV/Xn1Vx7J/?=
 =?us-ascii?Q?kc/7FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ml/Dq3HOyRtOCx78cdltfDfB54tzlch+WMKepP6bEU2uH+JA927dA4eEjG1GwwDZu7lemBqaf4ffnaMzSxx5pJnqcFYOAXbvY+YjJNvgnKP9jfrh4n33iT7tGb1CiuCMu8AhrC+/KhjjeuNM05vikkrUYFij1kwRDNvjA1wBuRJgsX4QE08X0ThGFqudA01J9PjaoYqt6WZSFKbt53PyQ9jY0Zs+HkVP9wB1gUY1gZoE04y3hInlgPKsutqg3+dMFkzF00GoJUuj54xwqx/jlzruwu9um83WAlLfGgAHgeU7uL6xiyzuOSq5DVkvC6JT3O5Cm2v4/nwQ1SaecFs1AguJ7dM+mwiWoY/qGz1vsUYA5RRkmzby+ijjVgasGBv4xjxUmFI7VV1YSKWedHvQcJ0PFpboMTqoePooAvubVoCc/7Lmz0Y/dO449S8LWXrNIsj8b5nGJNnqsZKvi4bhQ78Whpcd+/u3spJVvvLFrYuLfiFze81hj4M71ddssRXqs/Pg3oeXVZS+wEj+vnC73eInExjGdMXWnZOH4/hG/UoNx3mzfLySXJCiDQgt77DPCMYb96GI3bq3tnHaw04vG5E0plgVINXzpZgbCDzGpOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df8ac19-9015-4457-a575-08dc21ed6d94
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:41.0875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXTId8us9W/JM2NqfYF9kIU4bR5q1kqfwe3WjRSIPt2++qUligoqyGVXXX8q4UpM0F1KyH+T47HUw+hcD3Y/gFH018qpqbWL2z2sleCLbJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: th5z8U7rJxmFbx5iqghspK9bnJ-C-Hia
X-Proofpoint-GUID: th5z8U7rJxmFbx5iqghspK9bnJ-C-Hia

commit 14a537983b228cb050ceca3a5b743d01315dc4aa upstream.

One of our VM cluster management products needs to snapshot KVM image
files so that they can be restored in case of failure. Snapshotting is
done by redirecting VM disk writes to a sidecar file and using reflink
on the disk image, specifically the FICLONE ioctl as used by
"cp --reflink". Reflink locks the source and destination files while it
operates, which means that reads from the main vm disk image are blocked,
causing the vm to stall. When an image file is heavily fragmented, the
copy process could take several minutes. Some of the vm image files have
50-100 million extent records, and duplicating that much metadata locks
the file for 30 minutes or more. Having activities suspended for such
a long time in a cluster node could result in node eviction.

Clone operations and read IO do not change any data in the source file,
so they should be able to run concurrently. Demote the exclusive locks
taken by FICLONE to shared locks to allow reads while cloning. While a
clone is in progress, writes will take the IOLOCK_EXCL, so they block
until the clone completes.

Link: https://lore.kernel.org/linux-xfs/8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com/
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_file.c    | 63 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c   | 17 ++++++++++++
 fs/xfs/xfs_inode.h   |  9 +++++++
 fs/xfs/xfs_reflink.c |  4 +++
 4 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..e33e5e13b95f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -214,6 +214,43 @@ xfs_ilock_iocb(
 	return 0;
 }
 
+static int
+xfs_ilock_iocb_for_write(
+	struct kiocb		*iocb,
+	unsigned int		*lock_mode)
+{
+	ssize_t			ret;
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+
+	ret = xfs_ilock_iocb(iocb, *lock_mode);
+	if (ret)
+		return ret;
+
+	if (*lock_mode == XFS_IOLOCK_EXCL)
+		return 0;
+	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+		return 0;
+
+	xfs_iunlock(ip, *lock_mode);
+	*lock_mode = XFS_IOLOCK_EXCL;
+	return xfs_ilock_iocb(iocb, *lock_mode);
+}
+
+static unsigned int
+xfs_ilock_for_write_fault(
+	struct xfs_inode	*ip)
+{
+	/* get a shared lock if no remapping in progress */
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+		return XFS_MMAPLOCK_SHARED;
+
+	/* wait for remapping to complete */
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	return XFS_MMAPLOCK_EXCL;
+}
+
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -551,7 +588,7 @@ xfs_file_dio_write_aligned(
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 	ret = xfs_file_write_checks(iocb, from, &iolock);
@@ -618,7 +655,7 @@ xfs_file_dio_write_unaligned(
 		flags = IOMAP_DIO_FORCE_WAIT;
 	}
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 
@@ -1180,7 +1217,7 @@ xfs_file_remap_range(
 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_iunlock2_io_mmap(src, dest);
+	xfs_iunlock2_remapping(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
@@ -1328,6 +1365,7 @@ __xfs_filemap_fault(
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	vm_fault_t		ret;
+	unsigned int		lock_mode = 0;
 
 	trace_xfs_filemap_fault(ip, order, write_fault);
 
@@ -1336,25 +1374,24 @@ __xfs_filemap_fault(
 		file_update_time(vmf->vma->vm_file);
 	}
 
+	if (IS_DAX(inode) || write_fault)
+		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
+
 	if (IS_DAX(inode)) {
 		pfn_t pfn;
 
-		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, order, pfn);
-		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	} else if (write_fault) {
+		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
 	} else {
-		if (write_fault) {
-			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-			ret = iomap_page_mkwrite(vmf,
-					&xfs_page_mkwrite_iomap_ops);
-			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-		} else {
-			ret = filemap_fault(vmf);
-		}
+		ret = filemap_fault(vmf);
 	}
 
+	if (lock_mode)
+		xfs_iunlock(XFS_I(inode), lock_mode);
+
 	if (write_fault)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb85c5c81745..f9d29acd72b9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3628,6 +3628,23 @@ xfs_iunlock2_io_mmap(
 		inode_unlock(VFS_I(ip1));
 }
 
+/* Drop the MMAPLOCK and the IOLOCK after a remap completes. */
+void
+xfs_iunlock2_remapping(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	xfs_iflags_clear(ip1, XFS_IREMAPPING);
+
+	if (ip1 != ip2)
+		xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
+	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+
+	if (ip1 != ip2)
+		inode_unlock_shared(VFS_I(ip1));
+	inode_unlock(VFS_I(ip2));
+}
+
 /*
  * Reload the incore inode list for this inode.  Caller should ensure that
  * the link count cannot change, either by taking ILOCK_SHARED or otherwise
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0c5bdb91152e..3dc47937da5d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -347,6 +347,14 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 /* Quotacheck is running but inode has not been added to quota counts. */
 #define XFS_IQUOTAUNCHECKED	(1 << 14)
 
+/*
+ * Remap in progress. Callers that wish to update file data while
+ * holding a shared IOLOCK or MMAPLOCK must drop the lock and retake
+ * the lock in exclusive mode. Relocking the file will block until
+ * IREMAPPING is cleared.
+ */
+#define XFS_IREMAPPING		(1U << 15)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -595,6 +603,7 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
 static inline bool
 xfs_inode_unlinked_incomplete(
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eb9102453aff..658edee8381d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	xfs_iflags_set(src, XFS_IREMAPPING);
+	if (inode_in != inode_out)
+		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
 	return 0;
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
-- 
2.39.3

