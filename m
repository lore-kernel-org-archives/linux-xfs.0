Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B64183090
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329811; cv=fail; b=QvjHSVUmf0v7zH/RrXA2JDAunlMgCOIG23NVzkXdyrDkYvwenPacslzm8gosQrJQrAHSDtYM00eJ4XW0PjCpvC0XXgvS4pYLeh9OKerq+P5VFHWrkf6eAUjKBEM0OlHGGjXTC5YdoR5sA+gdoSkVj/ALBX7uT/CbcEQJ77TLo1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329811; c=relaxed/simple;
	bh=/orzX7XLPrxEoS3qndmy+k+sDZvyVrozlQWNR0pDNMU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Oa0XEgPZaRMXpupuW3GXy5GgluXHAetptApOFs4XzVovn+rEvY6QQUq8a260jAZURqPde0dL6jOXPVQSGsv9/nPWR3vPpl0aG7EgsRSBoGgecHTsgEdL9TdgKcIDEjH65blQMeLP392bZYghU8DCfauejWhaPIH7bUvluxYxe7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iEPc7MJb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NTbjXWgU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iEPc7MJb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NTbjXWgU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1goZs023646
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=aikzMMpciFRBSI9in0ivglFdYBjN67UIqzirxX0NUKY=; b=
	iEPc7MJbTD+KADeBG8fLiWb7TczeeVyJ3DFfh0/gV8b9wIhRRVluPUcSoGtVq27G
	/bjHlWCrlZc2ZZWo7d4veHBr/IkGy7zI7mYctJHWrtboGdLK3AXkPbr2kfrOlsRN
	r/EEwYEfnZGUhOA67LpXxmxXQmii9DD7Bf10x3Leg0HNPq7+9z58Dvo13uskAxAw
	Lsy2KzIBE2mTQQvCu/DOrDnEFXgnusbI/6tDK3pVZskwWymXGnJQNvZd+WTLVLUw
	YOmK+r/4NBBQm2Mo1ja3ktVH72R2JSwbDtkUuiTfT0nPU4dnv3KvIhuJYzsFKGzJ
	Yj8jih8HfS0aG5RiXlGWAg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7dtser-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DNDhaF012526
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynca1uw1k-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/Bh4WPk15BkCilZ7sA9b0pN8Z/IW4cuLWUkxhn5G8bZ7nktu1xr7FsG5z/fIb9CXUrvVI4hfhoKJKu1y3B63hf22hm6/mGErLpDMKgRMFeXOghlUreZpiuIFzlexuPoyrqIZKpeZ4j3iQ2/PldBC2Ubuyx0CReItiLzh5poF4j0i4AKvffUHG/r8ehrHBKI4Q8ODanlzpCTd9Ha5FRe0gLYeKFeZDaajYHyPORof8fho85zlg6ZKOqOCjjdk8p9gwU9Q8+UhIaLQ/PXrHm+kYzwzefTcnHSvCiLMlLxL8ji9Ib9sARyeemHs2N6Fy6k1YeySgpHoVPTHdee6RAg+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aikzMMpciFRBSI9in0ivglFdYBjN67UIqzirxX0NUKY=;
 b=j6vizkR1psb4SApbIlYuDGbkVztxUZD/eZ1b4qKZGYkNPtdiPdHdzQ3fUybqUNVq7OtB7s5rrhM8XG/gxJUgY0boN1aGtv6R36lJSCMRLWNxUhJFd7h6AIy7IVzhk9m5LCsG5ZmxbH5xS2TACc3BYuHkfKl//9zuBIFigyU0T8IvQPUSpDfFl/STpadRrPrCt+sQ0yFQE6RT9AT6zvuOSak+JfrP7mVSAZMRHp5PAHZoFgUbkXJaw/Qw3UzH7VM91r3nQAfEovopJx48ytKp3nUe9xUSm+lPgRV07gcDqTO+LuaiodC6ubCeRN4XT+DwXu/xf8b7YhGeiSPTusogUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aikzMMpciFRBSI9in0ivglFdYBjN67UIqzirxX0NUKY=;
 b=NTbjXWgUT0+phfoYUsFoE7s59NRI2xNjitNQsRsLJFeDiKj2N+i9xinUn1Jq+D/C6Qv9BLXe+PG2IhyYEutc9dSpO/Adwxky7nuOixhU54aO0Blkkhi/yzZXKK34PIKBKJHiK8bxeMc2HXIEhsVl3tmAg9aDx1OBP2b1q8mdDeU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:50:06 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:50:06 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 8/8] xfs: allow cross-linking special files without project quota
Date: Thu, 13 Jun 2024 18:49:46 -0700
Message-Id: <20240614014946.43237-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240614014946.43237-1-catherine.hoang@oracle.com>
References: <20240614014946.43237-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0387.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::32) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 55bf3a98-7392-4844-42af-08dc8c1450fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?tzA3deZEH0iSGdbisuSShT2ZpDkGwZFmfrC4ikFP1e8A6XaCfh8PnjeADIaw?=
 =?us-ascii?Q?2M/7XjCeWP9+ySqJCyqCR9kCZ3aQhhsToLIwFeYyYFynszlWOHpG7AsVSIlU?=
 =?us-ascii?Q?Vlj0RlDkEs2BS5kaAcLdQRN2CdhTNv+w26h8Z539vxCdWq3doXvVhrTWEbms?=
 =?us-ascii?Q?7P8tN6wLo1ZTaHHqWC9SBe9ZmNo5dVtf1yjzquWcJnjHexZpUcCcfU+kWV5T?=
 =?us-ascii?Q?eJ1rAM3d30zqR8WeFlKlQAVvqtDqvih6Cf+cfrRC8yDwHO7KFL0Ykiq505JP?=
 =?us-ascii?Q?ExvSC2+DzV9ql3nsnw2shV41JoJla8NmX3aPl2mFfejNgHi/EMoomP6Fp8Iy?=
 =?us-ascii?Q?sxhKupItD43V0COPg5/DnByU7342XQRuhF9ean0bYzQMrmVqkhiG/5FWMMGd?=
 =?us-ascii?Q?To7B8af4T/zYuwKPrQqZ6SRx81e8MfZXnuzR1ZVXpT0irfgqmhknbVr5/qc8?=
 =?us-ascii?Q?3IkwINYbdUSPdT+kLMwtb1Ws7nZoDV4txmR8hmBny6yINTfhUbyAfIfevcSJ?=
 =?us-ascii?Q?lUDmpAiougyhihcroyoK+8uIN64/NMjmRSUh+Wis4GWhSKPZIT6vTTb6aCvm?=
 =?us-ascii?Q?/P3ee2LfnG7bS0iXV+3V/W/e+3yJJvJtTg87rJS7M6xMFvh9vD5ceECBcABY?=
 =?us-ascii?Q?asavGBSJtrNe7D7gZl01A910luV2JwgzRj2wSCLNpR8DOgpnBmyJEeV4WQjP?=
 =?us-ascii?Q?4W33FWs5S0Iout9dNzN79NP30N53y6UV0VY1wPI9KHWNyKMgF022Nw35blvJ?=
 =?us-ascii?Q?jrB65VVLgqWOBiofj0AJRTmLFRtC6shxn05s/3IvSqtq7A84/pWmTLYKK98h?=
 =?us-ascii?Q?kWcO0RJlkJBRoOrpJgAiIKVDSwTIMBuek2N0/ubQuVKCb3M32HL/htW8jyHo?=
 =?us-ascii?Q?HUbRJKlMZe1KyPWeC3nTtQUykubckK8WLQeV1n++Fur5wBfKUJTLCmiMZJWP?=
 =?us-ascii?Q?gmYkmjKM4R5iSBx8OuPygjT7OxmxJSB0EBF85DmrzeKxT+bdh02dspwyDgWv?=
 =?us-ascii?Q?BZrwrKK3G87wqjGgNf1cXBX1+1GGcawLCi8zmwZXnx3EROHoeIcQ0hjWqN+b?=
 =?us-ascii?Q?BBB5nMg3TetlIRUTwk5sPt1LgAqdHD3sk5kNPmPK2Uoud19+xO5qET5otz6F?=
 =?us-ascii?Q?WfJf4pdqqyzqBygDBaCiWL6L8yjt9VimiwIe9dOGna21nN7BPSY/mw1JUmlk?=
 =?us-ascii?Q?EzQXb4MM2M7gJALVHJ/2je1qeQdu4rbDswQ8MzV40UiwT8ayfFlTrnfUJQaC?=
 =?us-ascii?Q?lN4KhasKhPlQFX2FLgkcP9FiT8GVSu3sx92xAxzeZsva5A8vvZEcJ4R9LtoS?=
 =?us-ascii?Q?3fOkmc8cO6Bwj9JZ6gnjfR48?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nRGEBDblws7gOk13iykfmXgSMtsGuCPJFU/WrUj13kDnxXusx+ZbSz/h0ThV?=
 =?us-ascii?Q?/FjPF+MAvVlMwVyk9GQeMQLkG/Po8kFJweVNZubuO4iuo56ZuacEv3JHxs40?=
 =?us-ascii?Q?Pp4YHkS2CpRHrDSMO8GhpuBX/4GpR5cPVceqS3u3xCOy0fBdaF6jqvlJJT6p?=
 =?us-ascii?Q?jNsCfPlQTXcAOIu2R8QJD8mggISeRhB2pzo7yhWOQg7f/A2n6mcdOAZqMx2x?=
 =?us-ascii?Q?m5IZMjIqTrn6/BU9EIg3Bjgel2UVwgc0ZUwh1YkyPY4UlAbmjtklOXw4QHMh?=
 =?us-ascii?Q?96IEyLXICknzjWZmWGP4M0BfeiB68fGx2iOMSnuedkDESXfIvq8CFdUKMjkF?=
 =?us-ascii?Q?UNOqqAbKHHrXjbKm6aJ8SAVmHNZUHisaDyg18NbjDdSzJsNNjOwszKvqdHST?=
 =?us-ascii?Q?w/+uGQpyqK96IAU7TGoMClfMja+N2er8W5HNbwpI++FtP1UPoiNeKPqji5BQ?=
 =?us-ascii?Q?Slc5dTA2LeJfqAJchOoecH9RajQiLSkM+W4TdCKkeBalJW+hUvFsrk+LCI9u?=
 =?us-ascii?Q?awBsAb5oXyObBFoDCA4peZG1B6uzCGJ5oXf9iDeG6Dhu2PqSBG3r21Hf5dNb?=
 =?us-ascii?Q?hgV/AqvcjwieWPvuMxgmj8KAlv3X0ztLOR6Aom7xZVBVpVbgpSLYDO36aJW7?=
 =?us-ascii?Q?Mm1Nz5xIfKr5GPz/Wbo7U2KTsriHLp/8Aiwk597MwvgRSzBsLps9Wn4j3V2y?=
 =?us-ascii?Q?us+XU09zogVumEVSsMsPGQ8PIT3tv9MsaenCY/IOlylLxNT6qanJjOHvoGX4?=
 =?us-ascii?Q?/8rDYnemp766nYh/fEs+u2rObqwWlwQxnE/N5MebDLCSUzHjWWi8DSMRnGpC?=
 =?us-ascii?Q?EpFRvxzaHOcjd7uUlID0lm1l/Scbjm/XLvnc9zHW6B52sTXwxzNduZa5N0Fo?=
 =?us-ascii?Q?RX613CvjX4gRjT8V8C5E3/vzGXFb8TXYxGa3kjRnGyCYpg1CaHTQN5V4eVPf?=
 =?us-ascii?Q?Y1Xttjfab6mYHgCBOCF/MSFD4y1Na1Z6ByrSiizQNYWD4CLJaHMKQ/24Smik?=
 =?us-ascii?Q?0Qf+tTFmvcadPWwiQO4bvy/7IUYdXGRnWMWd6Jl3hhZ5S7DhJLFk31tYs61C?=
 =?us-ascii?Q?iekQozKff2xURfTFMyg8hflCRXDwcbxtY0Qx6auo9f4UMO7mBuVjRRBElzRe?=
 =?us-ascii?Q?Fr50gXuQtE3SzAfnfZ3otcbNdd5fBnZhb3qx/H13lIApXm95M9PTZxF/5q7O?=
 =?us-ascii?Q?L+wMi+50jPEZgjfZm9GlNHCdT06Nsz8+m7dijl7mIPQFm566x2ru2x7qQTMt?=
 =?us-ascii?Q?4L/gFU3rG0S3PhDdI28wUzCYHb6IJD8n39phWH95efsHQGbFjtkHSnL2rHjr?=
 =?us-ascii?Q?JZ64LQwe5pK/wfyHO3Ffwept6H5IJG4Hv2Ao8PbXp/33MReC9V9CRqacoOP5?=
 =?us-ascii?Q?bQ9OYDypoMFPzDsPmQdLIhKZlcuTZwWyjS+CmON01UbvBwbEhMUgJEZOxa2/?=
 =?us-ascii?Q?NVx3cdbK/qjgt/CH3czjlaczbP2xb6afbycA2KcWvL3R7YspioygSuq9WJHr?=
 =?us-ascii?Q?XBYl6fP2M8tZLKiNUXrmGugzaXyy4LGl/hwn36SINOhPS4ENRzA7j3EQ0D78?=
 =?us-ascii?Q?hLftXwQ0MdaJGl1wp/b3vH+wl1kt6U1VtOTWmt2kGvB/FBRKM+Vv4CWI2Au3?=
 =?us-ascii?Q?90tU7lXCLg8GcBpbFKCvVOdKMcI12nrrrfLaVCrUnhkTwrZDZ5jDJMkjEQ7+?=
 =?us-ascii?Q?VmfdjA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IDWKOY1/0rpt6C4NFk+HdFdPw683K7E2D0q0rKqb6+lXiOo9+EuQR5UNR1ZLtypGoimC8hN0YpsLctXIyWVSgCF9zbRW+dBCezYP633afUzh/9KKZ9l4zB6DKhl/spD5thS+dx+gkP1ox1nHtMksYy23mZm3J4/8VW/rKujSMpFwepYnuLobJeb+QlizaKw9WXFoxe6VKJLIUWdo0TT7ZGnsBa+cTP1QClVW/e6x6K0Nn6Dcrz/zdHf6O8V5xiyFlc+Jp80KjAO6Ws++LoRKri4GAdux7PAO0N/g3fcs6y8QzISjnsfsNOHJwNIpO2AqcM9KbCB8QCXSv/q/rNe5dTbZMAc+qY2Mzp8PxCaKF41ATlLcG/hDkiARSW1tCK44WU8z6PJ8vear7HM8RznG3F6paoZ+Qfl2vDfMEWdRemCuynQBhQH0lQwS7KHx1MHc5VylzZuB9uJDqeKbaAVKpd4owR78e38rSBwj4rTY/ET6iw8DWz0zvdLGBZRDU56liUOaXkpWxVAD9MCibUXNnsTnDaccNm3+mgxrvMKRduZTnUzc1bd9NBXDjFSkpWhxhpdA67g4xEbDQzriW955sLKxZw2wLxnVXqwWcoVCJI8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bf3a98-7392-4844-42af-08dc8c1450fb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:50:06.7119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XbK4B5GdQcb3fZPrPi1CJMQ0Zn8KonSl6cEX12S25IrZvEEmd/oB18WVodOF2DJDTkHRON1gr6HfEHCz3d1rXpPIHv+WniPol2lXQkoD5cc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-GUID: UChlaab6HWW7jCqasiESVForSEKwp-Fh
X-Proofpoint-ORIG-GUID: UChlaab6HWW7jCqasiESVForSEKwp-Fh

From: Andrey Albershteyn <aalbersh@redhat.com>

commit e23d7e82b707d1d0a627e334fb46370e4f772c11 upstream.

There's an issue that if special files is created before quota
project is enabled, then it's not possible to link this file. This
works fine for normal files. This happens because xfs_quota skips
special files (no ioctls to set necessary flags). The check for
having the same project ID for source and destination then fails as
source file doesn't have any ID.

mkfs.xfs -f /dev/sda
mount -o prjquota /dev/sda /mnt/test

mkdir /mnt/test/foo
mkfifo /mnt/test/foo/fifo1

xfs_quota -xc "project -sp /mnt/test/foo 9" /mnt/test
> Setting up project 9 (path /mnt/test/foo)...
> xfs_quota: skipping special file /mnt/test/foo/fifo1
> Processed 1 (/etc/projects and cmdline) paths for project 9 with recursion depth infinite (-1).

ln /mnt/test/foo/fifo1 /mnt/test/foo/fifo1_link
> ln: failed to create hard link '/mnt/test/testdir/fifo1_link' => '/mnt/test/testdir/fifo1': Invalid cross-device link

mkfifo /mnt/test/foo/fifo2
ln /mnt/test/foo/fifo2 /mnt/test/foo/fifo2_link

Fix this by allowing linking of special files to the project quota
if special files doesn't have any ID set (ID = 0).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_inode.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f9d29acd72b9..efb6b8f35617 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1239,8 +1239,19 @@ xfs_link(
 	 */
 	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     tdp->i_projid != sip->i_projid)) {
-		error = -EXDEV;
-		goto error_return;
+		/*
+		 * Project quota setup skips special files which can
+		 * leave inodes in a PROJINHERIT directory without a
+		 * project ID set. We need to allow links to be made
+		 * to these "project-less" inodes because userspace
+		 * expects them to succeed after project ID setup,
+		 * but everything else should be rejected.
+		 */
+		if (!special_file(VFS_I(sip)->i_mode) ||
+		    sip->i_projid != 0) {
+			error = -EXDEV;
+			goto error_return;
+		}
 	}
 
 	if (!resblks) {
-- 
2.39.3

