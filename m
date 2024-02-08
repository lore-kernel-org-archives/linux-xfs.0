Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC923C068;
	Thu,  8 Feb 2024 23:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434489; cv=fail; b=b3Dfy7WaBNohhaiSoWgCrhAeepivCB6eQm9COqK614PN2KZTkfobGEY6dsUYbOtNI/2YG72qQyfpZazU1TFcRArpUyq6llaarJrDmzDyskWrJLuziiKzpRgUNtjSPhiEd+G/Thw8HqvuWnzOguGr7cHZtcn1XR4rttPmmAhyUZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434489; c=relaxed/simple;
	bh=Hed/nQSYL4z720ATZCJ2JuYTMAUMXqUS2G+phLtBZAA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rb2PZfRF+YAOw2M6eq2vW3+YfY2VgkDV8V/XSVtU/1HeTARl0Qr42X1ZAaO0Mihl4sVzbs1b8EpUclqvg4sqlsKxLUqLkLmkWv853YaU8C4SmIGcSLOfYm6s2MT5NwD0oKtwoMUqteYZ7iW8coatle4XydGbFHnOV4MmILStRGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YQllovxs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qSwt/Z4I; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YQllovxs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qSwt/Z4I"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LT1rx019836;
	Thu, 8 Feb 2024 23:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=g9foH6ZXwyntQ6vY/SA92JJazttYGymEG6Wy2VIWqKg=;
 b=YQllovxsQ2O99Id6IeqzN88ou0uPvFgNm8LOmKCNgqVwa6x+8W/pFCRC1aO/KYyCzSvE
 rZ2tOmkxAh31WkkDaPjZHj88lxozhLGekTpKMS/t+ixWBjmpppd2GRbwwnBx+DUZfsT9
 zs5ReCvfcJtSZji9gx5JnlooJhwprlprEnitK6KnzPA5UfcJBgouUVnuXpL70WqvOYsy
 bXcUrvZvF/4prmPFS1LhPxwx7ayPSLceyLMpqBDnKSJ5sxJdw3W2JPnG91+++zVnmV4T
 3KBN/ZURNxv0wl1HwJU8AFYYDXMJEvzlln51hD3h/WYjfwYQZHlGgCYMBp4ulpW6rMrb 2g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwewx46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418LgkuF036804;
	Thu, 8 Feb 2024 23:21:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxbdx6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+pUDBZFqMPsbCeKPKnlfDLBGBKMA+/dlvdKaz1gAzKu2ZIHNj3S3jWpHfdIJVwYX+PaXuLgMtmJz+ooDn2fAvEuHZwSbuYu4JWZ/i5AEPge1Mj6JHzJlHK7xIpHIhjbwDM1lgpmMbRaFLXFauso+ak0QdtiD71y762tMK4SVMqJlgjme3+dGOOgG66NCGQMOgvKWiVgN8WlsvFFblRjUGBLzthCNqy9Pjiq7fDGpM2LM+07KpHFzk8jNjQ4zy7qaCodrbHYpBoc7MrDmXhe/WOVeB3T/skKMJiAk649gf8uNsKqH0EUWfgb/yqO0XahDd6XYC+zo9Hc+zm1KqORUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9foH6ZXwyntQ6vY/SA92JJazttYGymEG6Wy2VIWqKg=;
 b=ksAS61iJd9iRJSkVEbISEAQPuHafjIyOG+qJ8r+u7OxH30DNwg6SNr0oyi/OUuzqtH5SLuezyARpJ2IKSLMr89swsNEYfYxxs8Qe58PiMDOVSGbjIt5Zzf83csslgGNc7d/JADKSt0mXQ51vOQ4wdNp9jQacErUWKGXAwz32RZPhh07r/hqLEGDsFAwQpdI62knqof0dilbJ25kBZhF6AshNpsI5Gz/wYGIc09txOqoEnvZ/LGd6tryXxlinI6SjdJckge5jj2rO26bD6jKYW6ED74++vq9jDfcDW/Cw2S9ybag0deYx5Y9SGqC+PhzR88FW6rw3zY3oZ2wn+J5/WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9foH6ZXwyntQ6vY/SA92JJazttYGymEG6Wy2VIWqKg=;
 b=qSwt/Z4IdLcOgBHM5Xc5S8P0iN1kva+XPLdnzK+Yf6ECQFBv+ySUdNpHaPePl4H074VDVny5P2RH5xACSxWDCJ28cifU7FYhD0oJH6BTY9GeQwqC5WHPop2yUqJLplvs0JsY11V7lqE1Jwzg7iT6xDpIzc0MpCRqnlbz+KMzNVU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:23 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 13/21] xfs: only remap the written blocks in xfs_reflink_end_cow_extent
Date: Thu,  8 Feb 2024 15:20:46 -0800
Message-Id: <20240208232054.15778-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::48) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: c55e4d6b-c828-47af-3d25-08dc28fcaa42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lr+BqXjlwfQ66hzOgoPaUvT/R2WjoXbzoHxYzVGptPr1BWH8h6fpskoPvIh+C/J1d6B2JSJhUskhYRwMzJAQ47St0U93cdw2xYXmIGkP5k0kAeydJUyAh6Z9oQwOfq6L1bVfZ2wlMKftZ5uV0sImCaew1lo5JHsajgHeR60rTqyGnwin1jy/4Lsln+2ORKdVy8mJMCJsqRPlqWuqKUvAw8CCzfg/mBJKQ/Sc/Nwcg1zQLCVI5CvxmvtYt4fnU0v+r2IveIrjhs7TGjmeTlyH7PuTgFd+Bb96heH/PYsm0fEzAVTSpbINa4pthmW/ooMKhZlx8yrRV7yh4eGrdcZjlcuibmxIVTEcrJHam51LW+N3j2++dqzREuoSH5MkmglKSjx1SmG0j49047Pzf24nvkQKEJhxU3iok0ENz6FuvR4tQROkwronwh1hXrUPCNfvLTEzpR8bJlwYeWn2mJggZi60RHYdBZweHFE0r9hu3TLn6MNcHofh9EdR49o2vMRB+jR778XJTo6TiXgu4slq9VzibJHfI/2ckMoZK16s5XguUABqt+E9Fk5PVtMuKakl
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Bb9A1aHVvGGtT7BZrGNYZOjq7leuVG4zu/i7R2XzcV8LNcGemV0tusjZgCcZ?=
 =?us-ascii?Q?ZegWhpg95gC+myVLpl13V3FCKGDhBeAFdrBw9z8iX1aZUhRdGTW2VervI9ye?=
 =?us-ascii?Q?tfW1DkIZazL/i0t7qypHd80Bv5xmMpierjQSxN+DpiRd3KzDciPsENwqCR+f?=
 =?us-ascii?Q?F3aXp4qer/RLLekt8x+eKAsvCA4eB+JK+QeoPspxfP+legC2nmY165cTV6Xx?=
 =?us-ascii?Q?VY6VxrtEno9FoFgiihD3YEol6GGXOpM9cm7qYy2aiB3U0UH+fhEyMYGRQWLr?=
 =?us-ascii?Q?9xFZsDL199v8OciibmlncleElRHXetL+QSPudtchc/yCP7QMwedLlZYsG4W0?=
 =?us-ascii?Q?KSvr0NOgXcuglPvFe4iJZi1tghtXkbOybjpzGnGxbCVipI68jOhNWHrfu+Tm?=
 =?us-ascii?Q?WK1/K+Om4iewIRkY0KaBR5whisl1HT5InPW3Jsd9K8mdIpiq0msSPabg/QkK?=
 =?us-ascii?Q?TmQVDSkZu6ONJg4pevANVAg9CH/UpPtH4mctwVcsdc8EdxdZmajGjpNRuPc1?=
 =?us-ascii?Q?KFACLXHz3az8AePiGbMs82rDhZXU99bTTBR1CC+mvqgTll3RvLjgOwnKyuvY?=
 =?us-ascii?Q?VLdb/UCO2k6T4UtoAhRcgKqdJunAXngVvYbn9EWT5FLE5vpvQRG4pTf4C+9c?=
 =?us-ascii?Q?zPKqyzUgohRKCYZWHIyz1xe2zaAyRy9S+nKh1syOXbfaAbhKVe8y1YuHaAUk?=
 =?us-ascii?Q?sEZsOEce8TQlmFpxGXAZ7qs/21WmQ0+WanMEVoRUHubBIeSR5yQLL0xZKjaO?=
 =?us-ascii?Q?MaPEUb79Mp8jC7gG4q6FdT09qVID+dIullJxCE3c0/hVXCMPFmR++U9kvUZn?=
 =?us-ascii?Q?FNRVbharDamiW0to+840zTrrEbyr7fSUZ7zdL8CKOxJM9O1EbI504H9D1J/i?=
 =?us-ascii?Q?2ETRv4aFalIzpR8hhZgA5yEa52NXy6RS1FhexjnrYV2KAqgrTdSDdwDrUdPG?=
 =?us-ascii?Q?oK1W7ObQ9IfD7U4NNiXiicm5cwjduHDW3raIoxNsU3kGhKIVXiggspRfACpe?=
 =?us-ascii?Q?TV1/LTrrtBXtfsBLDm/vi/opumbl7XzuwQrikw6nF69P0TCLjwVLxh6EQBX/?=
 =?us-ascii?Q?N26cREmwX5HtcCdeKzf122hxoAKfMOMfhgAMVuzp7GTb6icEua5bc2c04/Li?=
 =?us-ascii?Q?nnNH68W4W1okCg0iM+A7vj1yK3ANRpA7tTlwDj0ZS2H1xycVTy/fKbo3ctNz?=
 =?us-ascii?Q?UN+Z2eNZnAWOdwKm/EAVlUt4dj2GDOtMeGY1uEpH4rpQT8d1AiSc67Po/Ra8?=
 =?us-ascii?Q?PZcXwUbN0CNvfnEnQ20mZKFrzKGhrvHRl9uKNNTzWtozrEBI9TsZ0/aLsril?=
 =?us-ascii?Q?yGbSyhjksK5mNO1ICUvTjOXF8Z75dOdroisANItm9uyX8f9IyCckItjd1hCI?=
 =?us-ascii?Q?Yo2cYMwo6uXh0oJKaRL07EwHjME+LV7t4PJ47yuukqBO7j0Jyqfh3EmGcWks?=
 =?us-ascii?Q?nJXuBWO+9UV3K3wesIFAwlpLB7NgnDGhOf/KMohN9371Bw3RyJg9v/a+nfpj?=
 =?us-ascii?Q?aUY2BUnNDiHMqbMNrm5aCkp6pNvhK6fOqW1Mzwvm88Nyprbdxq7NoBNRIJB8?=
 =?us-ascii?Q?GuwSinY7cnZRAAtsEkttrFCGDOybG71mjXOAj8ZUWQTvORHTA4tekFOo07qP?=
 =?us-ascii?Q?O5DV38lrtt0Oa1kxolne5pQ/ictmPemJzLMtMNUf9YTCu62rSGeUPcm07lm9?=
 =?us-ascii?Q?KLB9Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	wPmKzOY2DxzJ03NMzoTxURfPe7rCrtqqtfm6GvfAYpJAIFZZpvlx2BqmhFPxnUTWXplI22va3hg+PNQ0RrwcJNQrRGEA3Mvm3Z9Jt3kFNTE5pl7nZhFXGaCrEKyl9TizU6Qc+1r9XS8D9MQxeBpuJWkbG2nvv5NYYqiYqWvANOSoAfDqUtWsmy0e7C94qxLmRgKjY1f3jaCMhCWkz6gycheRH5hYERp9Y1nA5jvqRNpx3oXL/fZoxakbhix4FXTlctTbMbjZuW9CQeyNRLwjiP1ggCw4oK/rdV5CO/mQ/RCcGci8a9f7+G0euLSlxODBip/kGsmf87rOGuFq+S7RBpnKd+ImmhQXXy7cK3VasitXzMYTqh3SI9NYv/3W3p09OkNxLkqqqyeDK7x9NKf8lLjPAdlEkrwCO+lFAfhF5l+ZUx3dGiI/O5C/SDwWmnRMlvRx+xldfvJMSw4gIYjfhq8QJJ2xhrosfOG1wZkNxHuENhzBq5wGllIcQCDTOSToZu7Qkp6oEnKPMoq2FxoFYPrQIGnQrwUaxz90MQ5LNs4AdwJk5khRM8lumNdsEet4NfS6THU0lxH1BOv3EPanwEEIhCUJLErFvwGecCyRWdw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c55e4d6b-c828-47af-3d25-08dc28fcaa42
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:23.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrhA5CnKD9lCiQcfqEk/yIF66aL/32OfIdartU/Mircd2MQUwPvQ5aj13JfHjUhLpY7rP3DrPrSTK2tPmNifTMgpvcmJTJuNdm8yZb50upg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: uhXlUscBfD9rku3vOsqIrDCqPTPUcZZN
X-Proofpoint-GUID: uhXlUscBfD9rku3vOsqIrDCqPTPUcZZN

From: Christoph Hellwig <hch@lst.de>

commit 55f669f34184ecb25b8353f29c7f6f1ae5b313d1 upstream.

xfs_reflink_end_cow_extent looks up the COW extent and the data fork
extent at offset_fsb, and then proceeds to remap the common subset
between the two.

It does however not limit the remapped extent to the passed in
[*offset_fsbm end_fsb] range and thus potentially remaps more blocks than
the one handled by the current I/O completion.  This means that with
sufficiently large data and COW extents we could be remapping COW fork
mappings that have not been written to, leading to a stale data exposure
on a powerfail event.

We use to have a xfs_trim_range to make the remap fit the I/O completion
range, but that got (apparently accidentally) removed in commit
df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents").

Note that I've only found this by code inspection, and a test case would
probably require very specific delay and error injection.

Fixes: df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 658edee8381d..e5b62dc28466 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -784,6 +784,7 @@ xfs_reflink_end_cow_extent(
 		}
 	}
 	del = got;
+	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;
-- 
2.39.3

