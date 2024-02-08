Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C04D54729;
	Thu,  8 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434476; cv=fail; b=F9WTqU5er9l6V8WKYgQq5ncQWhiKtw02/OSnjHReMs9eKFdlTpcMIA0U5KhP4nudzgFzGupmmohun1+rA6v9nc4IZDuTcaifpkAMp9/VGB2wWe9P5GIkcOjgfDfAm8SKtPyer3MmjMKLPd3UOOYy/XF9jGwna+V5nJjRQuNAJkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434476; c=relaxed/simple;
	bh=bgMGbUdsfhHjXmwy95qWU1WmTdZvuY08zDqQmntKrd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cLUt0Publ2IbbnGEI47StIDTC3tJPJImbg/qTCRngSAnpjNhrcXVhmT6/9qYMuwehZtn5zqKDnmecaEoEFUR02bMBEZPEl3sCiKvYLV8HKNKWMpHkizKIABU2rY2k2pEy3hxX57zqnULfrm6SaF97p2qaZzaVySkiUbvK7czixA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b/gYYHwP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RZgNUCRP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b/gYYHwP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RZgNUCRP"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LTGJR024817;
	Thu, 8 Feb 2024 23:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=XxFWhBiaUiRLM6r8LC8FUJNTmffNzlLFQlcDlGPZbG8=;
 b=b/gYYHwPyCYvt/8D/zRzoH8uctTWfAqh7cMDgZ1bisryGKOUkmrpu5dRA1cBUfLY3zmB
 MxEHOKpkDfcm/EM8ThehgLs3m3XTbm4pMwiT0FuIZKp3B4EvQfGqutV5WN4elW7GWEao
 +kCGygHpFR48FovYZX6rGHyyJ8opI4Dh5QjcmqmjGuZW2xVL0ewVmmP24fMXe9K5Zpj+
 dt8CWc5m7DqAeC1IKl+ZKcuUToHN7nyiK9SjgEgQG8mPcizHavu+CbtzRqwnbLLpGajo
 zlmDpIlfngYaQAWGk/Ikfkp0OeKPeaFBHMfhlp9MT/1aqcK42LSYUo1UP4pS3xIgQmCb lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1e1ve2fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418MGR7h039531;
	Thu, 8 Feb 2024 23:21:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb4xwd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gydZqLUDXqe9BqUqpTkJv3un/loIuZnVksQas5hQiqeGodKJxorRuhNGSSzyIeMG8ZtHboPwnOz8WI0PSaZtsRKZFxKdw5PlKsmQvyVVSk1phc18ckeM++xLy3b6waYviFfMI9m0cgNgBc20OMdnjDonGV6YunIBzYOxqhXgeOQosSv2N+khJ/9Ao9hq8XG0Jyt7IM8ErlqTCaNn1c14MJnym/DF2ap8XRrxSNn7nWF3jEXqLtx2ch8aKkuLiFlp5opmcnrjE19tx5FNJKrpE7GaUwtSCBBaEy9DyDRN7XZGp2T3VvwbMFoJzuORbyDSMH9BUf704AchVUahMUzdIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxFWhBiaUiRLM6r8LC8FUJNTmffNzlLFQlcDlGPZbG8=;
 b=CtSXcCWBkaL1iP7GU3FSbkY7Dq4fxmcvx9u7x9JPjeFb8dcaIslpKhnb8qullORbexUdlWVZdUMD7BdcCv3a5UtMMgA3AmyRJm2rkSN1+5kQSqbyPrZV3IbSXZt9jN6VA+n5J7tZtv0Vgk9n/hMdt6MQSBfFQngXBmvlMjSJHaEmeTdiUCiV4qyrGibQpbax1kyt76wCw2e/6n1m/sgPChvaFkOyPgVqnzlIQVcV7Xc9nPB48FUvrOvXAFufT5kpIksrwXDuaubT/TF7Eh6zpGNS9pQ8nPQthDHevlyvrMtj1yb6gKVH3U7Mqj3qW9lUbbeFyaAr/W2/1KmC17bWhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxFWhBiaUiRLM6r8LC8FUJNTmffNzlLFQlcDlGPZbG8=;
 b=RZgNUCRP6gtR/PhCSJbYqia8uwpre1GXUCQ9mYRH+mm+a+CILoFe40t0IpwL7uisaOXxrHTInQa0cJXDxouKYeixgsfHsO9LBVHfLvcokYjNnVx0tm+w0kCXGI38S3491QpoaLqGKZH2SNjLYX+wjMr0RQWa98Q2I5OWsLh1qJ0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.39; Thu, 8 Feb
 2024 23:21:11 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:11 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 07/21] xfs: make sure maxlen is still congruent with prod when rounding down
Date: Thu,  8 Feb 2024 15:20:40 -0800
Message-Id: <20240208232054.15778-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40)
 To BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: 34485883-6f84-497f-6c3e-08dc28fca2da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3yC5MGs7U4SQf0MiE9a3G9pA/+NvCrbsYhIJigvH04Bl/e5doFyu2isReUSh9whOxNuSlRdTG7CrMWX6hqN8lAcAjgAAQhfERQqnZryU9J+em+U3W/+Oq7KHMHdJ+FxLnmzRkEwSnWLw70XRXtQzeN4myYWWkAlh9sqGmgThmqeMs7xWSJPCTMFpTuE5pJTcTTrkqCW7cQvfHNT1OJS6J/esH40yTkeixnXcx2fXW24WtDCM97VGznzmIE1Dd/o6o1T+Kvu09+mI6ROnstc7DurFlBia34T26ZLL1w4dxJf6HhcmBnWxM2VdQYZIGYUbgHo29gndCJyxFmMp0/jW94txoNtkY4vd7QDmGuXd49VVMJY4LlFKxAfOqjZkTFhUCf/CLzHXMdTnKWshUK5kPSK6vAqHA9HkfkLrLyA67pVtQxQArowaHhQ8UCmL91Roohux35qb58otYJbIWH7RJxtrjNtsSN9BeAb0s0meI92s+35Z6d5gQ8t6MMz58SABMn6wB7jD0OvZdLTZJ7ryli9+LpjEBXnwW5azc9wubYUbKWdRa1gVo3Fz/+QM9YEG
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(6486002)(6506007)(41300700001)(36756003)(66946007)(66476007)(6916009)(66556008)(450100002)(6666004)(316002)(478600001)(4326008)(6512007)(8936002)(8676002)(2616005)(38100700002)(1076003)(86362001)(83380400001)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?QIsBBaxvW+hfoJPT/RzP0DpMDiwfY5gT7cU1MPQMXMtVSMCacm2ui/RtD7tT?=
 =?us-ascii?Q?9qqs3uRS4vyxV5suAr4lzFZYP0T+vB4GHYQiIFijUFiJSrfkT+qIqCURAADQ?=
 =?us-ascii?Q?KGG08kTpIFvfLZlSyD0m6mYx2gnHixe9HeORAlPTN0eBOGX8sDqlHPhNmtqY?=
 =?us-ascii?Q?Zk65XCCcRF8NpKSNRPW4l9IrajkSBsUQI/xRh/PWNCVXfOqYh/8/CjRnD8Rf?=
 =?us-ascii?Q?UGLkc9RBO7MHVmPwr/MYzErBCDJ+onmPcgqT3mPrMgNW2O5bzXUDaUilWIid?=
 =?us-ascii?Q?KVXId3SD23fAkj+QgoWtqabLLzie2XhCJMxSbSnV+At2eBKSh+Z2GTcp6bYZ?=
 =?us-ascii?Q?ST92b+JEiwx8j/04Rw1XGBgxnPW1DDAs5FRmhtQ+JdDxB5B5ZC8STWiC3HXO?=
 =?us-ascii?Q?hwQ+RZyYtlZU4gUuLCWkprb8yI61oJHiMvSkpjUbpK723xTo2I3nyw4t/iXp?=
 =?us-ascii?Q?TVBluqpyE6bK1+V44tTJvBSH1yjSL/8iy4cxpOKB/W8wPf0Yk5iqf1zCnn/b?=
 =?us-ascii?Q?maHr0yb/SCsucjXcm3jdnrtgmuS1Yeuaxyi4F94eDCd2LWNQ6w65mZt6wd2s?=
 =?us-ascii?Q?yNDB2eCCsBC1BqdoKkHO7M9RzTxFUG2GL/SC3AdfbDB1AVdclfV9XrBSvUJW?=
 =?us-ascii?Q?jmbQ1OX+YAflhaa28D6Ow8A9gLvXSCnknh00eNqZf+0r4kLfyVOEFPdgOOEO?=
 =?us-ascii?Q?t//Nu+6Scr8Ze8fsm82Nxg+CMe8ap+ssyOKIQEOwPrIz9qNlfQ2DFPu/rieo?=
 =?us-ascii?Q?Xouc9aavn8/SRT9c/zh8wQ+TfyeGP5aGQR+DptB2QHo7vrYo+kBtUDzjd6np?=
 =?us-ascii?Q?R1OgupnFcSi4ltsUTBf3IBOeKV9fIVoiSHAsEEhnDn3nCffhFlFuI/Ohj5Jr?=
 =?us-ascii?Q?3bKfD+UTzgvIYzrMDlR0mKFnUGu9cqZRmz7b74R+OamOCz7cTz+gL9He+CaY?=
 =?us-ascii?Q?gyz8K2Dbf0iO1qU3bVX1R0GFPgdc5ZvbuBjdKkeB30NzcBOIXY+WB/NGiFQA?=
 =?us-ascii?Q?jVQ2kyp3bYG+o95AfSDiW4lfp9gzad92INvI1gaFOM+htfxvjN3suMJEXYSS?=
 =?us-ascii?Q?4Y8rn0OxKphACWjTyf0XN4OmIDE4ySp2mETxxU8e5qZbGnhO1DBVP0UraMa8?=
 =?us-ascii?Q?9fJKoLjCCGhtIfrnNNZ93p3/TxqjZYQciejea3YzwvTw2G69mB6fS1igbLY7?=
 =?us-ascii?Q?wDzF9x623uJns1UbmrRP7W0zNYxuBYjoz508Hf9qwpbVoN5r8grdjK3GJuTA?=
 =?us-ascii?Q?RqHifPMP0/stDRBdiCBQ056x6G6sc926M53/URUvBQc58cDbsqGSDjl0Iqk/?=
 =?us-ascii?Q?vCGBRMfMat9LSozaAqgOiws4Uv2NeuQeYnvb2PPXUz/0ihZal2EeZjA4DmDK?=
 =?us-ascii?Q?entjm/x5MMUdw/n3966iKGSyAmhBQaFeMDhchq3+/0KMBNYn+sPu6kBbzy9n?=
 =?us-ascii?Q?LuI+UPWyNTHrSXKXecT7Sdh1Vz9abuvdd36TMCjBxrOZvrjlauaM7WZhZ8Yu?=
 =?us-ascii?Q?TZVdbkZe8Rm3uAJwVYVAeO1i0CGs25JATmT/Bl3GxnEqpwP54+dJKSqblhRC?=
 =?us-ascii?Q?sDg0bvBeaByHQgQgtRDvfYtpGApJrR9ikmlurIFV2+SDiOd+tOngFWcVCeGP?=
 =?us-ascii?Q?MovNauIx1wC60jgxYSrk6qa/7K4giz5oH/0RNWfBm83tIX+Y7Cp1Vbz4ioKx?=
 =?us-ascii?Q?k9Il1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nL+7l+q4RVg9jYObjwt45Vz1bs/PMiDabYZj1aRcP/Y04+apqZ8UgiSNV8IfWb1IvC3VdJYYVXP9SbTdPSH2cJfZ2kxwflR57LQP7immogbyWJHAs4sm3zoBsLq0Zv0Fd12iqdyHyR2H46EHMIcWLISe1vCuULEbX5PVM5l2gXgq4RLs1G79rsPT/h/yXBORT9C33G1xTtICBYyqwx2LAyOv+XqCgJ6OBIjCjz/9RpaeW2j4T66emYiT/cEAM5QiAbbR3g47eMrCDaNho3W/zeuZEP2Sf1QNCfNFnqlwvkpkWMiA7JkKSq0kURI/BeGtcO5Thv6mZA2TlkUuJspsdqHJApZ9t/wuoPrQh4bR6J5HqfRfYt0kl3/R2Cpd3xOLE90ZpoVM56/wUocTegZFklwzPAbSEaS2XQDiU//WG+f+mlnAxgAjdFJGGSxsLNMR6JGEqsL/INhgW/bub/4xsIjgSF0stH4CbnhlzCtjiP9vbIYrGDrqH9zOauZwGFrJ8hLOcqPMGIhtag+yyh2VXFCFQXM6qYqDZvOyce2n9gr0k62pyj/eMvMql8dgcAmxF3sJUWf6tlhBsBmvuEX6O1Y23vTL12a8bt42F+c49vg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34485883-6f84-497f-6c3e-08dc28fca2da
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:11.0373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Baho1btvppJ20su6QMlPgSJ1j8GHQ1Do1Ls+oYqWj+D5Ou7qFKG1vkbTSvmWGUmyUFAWyskXFwP1xMBMLbdjPYQB5ZQwrKddaFBe/hB3qUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-GUID: W3Y6AJNaMxDG4Fm7VSiAn59NjExc6sDA
X-Proofpoint-ORIG-GUID: W3Y6AJNaMxDG4Fm7VSiAn59NjExc6sDA

From: "Darrick J. Wong" <djwong@kernel.org>

commit f6a2dae2a1f52ea23f649c02615d073beba4cc35 upstream.

In commit 2a6ca4baed62, we tried to fix an overflow problem in the
realtime allocator that was caused by an overly large maxlen value
causing xfs_rtcheck_range to run off the end of the realtime bitmap.
Unfortunately, there is a subtle bug here -- maxlen (and minlen) both
have to be aligned with @prod, but @prod can be larger than 1 if the
user has set an extent size hint on the file, and that extent size hint
is larger than the realtime extent size.

If the rt free space extents are not aligned to this file's extszhint
because other files without extent size hints allocated space (or the
number of rt extents is similarly not aligned), then it's possible that
maxlen after clamping to sb_rextents will no longer be aligned to prod.
The allocation will succeed just fine, but we still trip the assertion.

Fix the problem by reducing maxlen by any misalignment with prod.  While
we're at it, split the assertions into two so that we can tell which
value had the bad alignment.

Fixes: 2a6ca4baed62 ("xfs: make sure the rt allocator doesn't run off the end")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 31fd65b3aaa9..0e4e2df08aed 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -211,6 +211,23 @@ xfs_rtallocate_range(
 	return error;
 }
 
+/*
+ * Make sure we don't run off the end of the rt volume.  Be careful that
+ * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
+ */
+static inline xfs_extlen_t
+xfs_rtallocate_clamp_len(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		startrtx,
+	xfs_extlen_t		rtxlen,
+	xfs_extlen_t		prod)
+{
+	xfs_extlen_t		ret;
+
+	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
+	return rounddown(ret, prod);
+}
+
 /*
  * Attempt to allocate an extent minlen<=len<=maxlen starting from
  * bitmap block bbno.  If we don't get maxlen then use prod to trim
@@ -248,7 +265,7 @@ xfs_rtallocate_extent_block(
 	     i <= end;
 	     i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
-		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
 
 		/*
 		 * See if there's a free extent of maxlen starting at i.
@@ -355,7 +372,8 @@ xfs_rtallocate_extent_exact(
 	int		isfree;		/* extent is free */
 	xfs_rtblock_t	next;		/* next block to try (dummy) */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
@@ -438,7 +456,9 @@ xfs_rtallocate_extent_near(
 	xfs_rtblock_t	n;		/* next block to try */
 	xfs_rtblock_t	r;		/* result block */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
+
 	/*
 	 * If the block number given is off the end, silently set it to
 	 * the last block.
@@ -447,7 +467,7 @@ xfs_rtallocate_extent_near(
 		bno = mp->m_sb.sb_rextents - 1;
 
 	/* Make sure we don't run off the end of the rt volume. */
-	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	maxlen = xfs_rtallocate_clamp_len(mp, bno, maxlen, prod);
 	if (maxlen < minlen) {
 		*rtblock = NULLRTBLOCK;
 		return 0;
@@ -638,7 +658,8 @@ xfs_rtallocate_extent_size(
 	xfs_rtblock_t	r;		/* result block number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	ASSERT(maxlen != 0);
 
 	/*
-- 
2.39.3

