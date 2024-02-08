Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82B754746;
	Thu,  8 Feb 2024 23:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434483; cv=fail; b=iS0jrMSK9anA2WQfWISmY+18yui5kLICd8mfMmMedTy1bJgRdEh0EYZQPeLFAGK+UqmQf2IjdmrDjnPZubCt9f7ZwbrJ832eIduwOtAkJzg2NWTXI5TBuJaCEqK1yBuWPgIkb1mgJ0c7g78Y8ytJ2w6uTGIDOzL6gxMZFPOHdCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434483; c=relaxed/simple;
	bh=ecSQRRLFi8oJvo87DGIjWps1RZJ27JgPn+YcCrvYVak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=onKFTzetgFk7XR/8HWHervnoEyT+TCnnCavY8mq0CNAD3MVJ5fSS+sf7u0aHP1vW3UUc3c9ChxbNS4ovzDS9ufMW981eKsPKX+iEDaK9uD1IPqF+DKhLP8hfEaPwJJWa7oKijNg6NMe0qG7Vid2kzA2JMgFj6AE0oiGpxXvZqNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fpQFymd/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tY/7qeJC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fpQFymd/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tY/7qeJC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LSxqM019790;
	Thu, 8 Feb 2024 23:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=KzzzBsI7AXLHlKBzl+5WWwVJi4dbh9jhxq5OAKdfvCg=;
 b=fpQFymd/EGKX5xvj+0HuHS5FRINaFWMLtOP46a/J9IcSDE3l5jZrVIUMut3o2u8N4uGP
 kb1xKZRGF2FW1iFyJrw/lTvSp7T59PsGGIwEdl1+h+2ve0IWQUxMc/3Flbdd7y5Z8eYU
 OEBxOXiPtrdJGNdwvDj6quFiatd1Uo5xh+nNSLWaFySx2vppgodkj9R4iiCDfsUnuUcd
 3e89mbhNbi4mnraBJSxv3UTxEe52swFlF8f/tA/dRWWri2T61CDMID2YL6VZ8+pYckHr
 zpF5S5n1KK6SkF/xTuAcaWeKE+Ldj1VBVSVm+Omq+2RjHNshRwDk4dnkO4fV7QKrBxGA hQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwewx44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418MbZUd038399;
	Thu, 8 Feb 2024 23:21:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxb7dhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTpvrK3OsCk8SShs2DYjMnz44+VdTT0QGVK4RQUd22m8q9r7fDxn3gjGK+/B+RfZE8S3hItYvJMyqhPw0PIyZKnBtb+dT3g4DjhVWEACCErO5uC2mdNPDF//AdWPlYrOy01kTWOmG7csrAb8WjSm3nWZixGLC6uVymZ4P9XP50WSnG5doJIKa8xvdQq5/y99aldyNvwho5jtEVGa7A2e8eLveiVe4uJNk9zDNpcHZa3NDcKOvXHBsPydXKCULGF/PV4OSbg1OBuSeLu30Gs8Aat13EPOQ/Ka9Ec/uZCX7QbYU2xm5FqumPbFhbvxMsj0MsLzoeniVeniM4xcxLjF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KzzzBsI7AXLHlKBzl+5WWwVJi4dbh9jhxq5OAKdfvCg=;
 b=YyfKbyyFaVIztPKiCwIpKK6FiFPnpe0IU7dBHYT3t/2tmcR0E7fpwHPCEjgagSfQ6Sz7y5NXf6mUol2TVrvZzTCJ0SSEhKF12NeY0zTx6Hke3pFF8PE6Jv+q/vfY81aBydnnnxP1FT+e85t1S2NJL/IakGLaXLmUo8XsNwJ48xqSwSR1hxux22HdbiG1hkcHkRkB0RMZDED2SygNJLCS2fLgwrjxpwnvt0wmQOU5ROWaO1f+Hgv5rA0TA7H3zPgdJS+xuo6e0mc7PR0aU4F+BYvSSdQGqaqJTVEHwERLKl5+tcp2xkVVzfDWAwzRfZrq3DP0AD6//Ta0ofpSjoN5Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzzzBsI7AXLHlKBzl+5WWwVJi4dbh9jhxq5OAKdfvCg=;
 b=tY/7qeJCGxaVF7QQCY5ELh3NhaRnC37q8KR5t5uPxaXZJgRfAoSdRoRQHriJORNdNYF9cwUDsJJo+R9gFnvSwB9TWJZksibaZdJmiI/cI6H59seWnzaOlXyvJFWillTTPjocu6aZJRh/iUw8mWVYFK11YP3QsGYbFmpB+FptMP0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:17 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:17 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 10/21] xfs: allow read IO and FICLONE to run concurrently
Date: Thu,  8 Feb 2024 15:20:43 -0800
Message-Id: <20240208232054.15778-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0029.namprd21.prod.outlook.com
 (2603:10b6:a03:114::39) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: 425e7fb5-8029-4dc7-1556-08dc28fca690
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	mY5ecHAnul3lwPqGYvMGBFnveMkLcqBlPff2xstKEAeJoRpqJDjuD8cwosK6QfVlfR9mNmIctven6OG3/v5AFIvm7g/KVkyBIR3nOOn1w93MyUAsLjJKs1uVVNqNXwzRMXv81l4NHbd2OdRiKj60ciPL7MDX32wLkRK0mRB8Yt9C0dpw/Y+Y0hn7+qWc0V9iscqcbaEkww3rpRP+lzgUdjCkWiPsMQSgmHAnf8EBn/bXlxKFOSh8VzdIxtq7kVgV8Y9CHlHYI2yPufXsREgOxRFcr9pdv5VY+Rc2m3OUWk8I97CONmWKmDFCE9UhlzOZ0JlLVRCHYhwv0Zry3yFlFgfmSpwwtjO8FKR5pNu40XvyuOie4N7dd7jyn/iBHbCVwDBH23DM71OXran9hC8BcffUybDl/ol8wJAD8qsuIQIfXJLOIvlWkdZIbyHEZ8qbl5IEo0LKHYwkLhslhTOPjtyH40rYbc3rU6Qv4VetZHidtYDEAfuBF1esAAe/F0eyfrPlVrldZ0fO2ius4VCuts5tQYg8bsU3QnTt4KeIHq8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(966005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?q0mBa+T0pSalgvt6EqcjzEQbehT7MH+7vnV54kUOFmu5DwA9kU40Y/sGDQNM?=
 =?us-ascii?Q?qN2xgHfoSJPTDbj2nm3AYYvipWR3d1erLDqkhvT1LyQ2R/EESs4W6noPO/XY?=
 =?us-ascii?Q?54Cr0I9sxBHmgH+d8ARk7l2mO7IlNNAwK03pOOhZzUxrgl+Z/Vo2zby8N9DK?=
 =?us-ascii?Q?s0tQDhV2ryzZ/WHHSH2UBSVqPBfb7F1KME5Ovj1kt84kMMFTZ8HOxXsUdchO?=
 =?us-ascii?Q?7gd0BLAYIliLTHhSqoyhWOoSDaLhOwG9FvWRD3oD7y/H9GIXVoLQoJTotNsf?=
 =?us-ascii?Q?hNdk3P1MSkLP3Tz0vCZLYAr4YxeD0izHjCbcr1gpTpTWnIMGWNCqdhwB8Ejl?=
 =?us-ascii?Q?C0/GwbwDQX5SPriUZd8wIemtgYnJWmxNyFRbnCBXX+U8RgYXCaYwX7FsbRpt?=
 =?us-ascii?Q?tpjY5QFA6XxXWOxN/UHLwsvohGRzyl5xKeNbdY0Ih+bbhYJNZ2gD3cIDNztf?=
 =?us-ascii?Q?KBfc0Cq1OaBz8K24UOFG/RK52K8WogFiDE05eyYvHEMN1+9iI+UuB5ot5b0o?=
 =?us-ascii?Q?LYMxFepQi9qr9KsHD7rgE9CEIZ48GNZWUTJ1vEbRliI9aeI0Nz9oalkosXny?=
 =?us-ascii?Q?GxYb+V/5hPOGIOhi+fvFfDUaCeOrjDO2wTp5ZVCzptclxbIRAnX00NvPiHwM?=
 =?us-ascii?Q?D0Wyaj+vR2qki1R7e+g3dcxlqJ1kOxFoYk0F2wWA4WWfw8lSMlz8EJr6XvUH?=
 =?us-ascii?Q?E2NmcPNWG7UbupEqR3kmyzmseHBJEnIVFbmCrklzS4uhdE/MljM+lx1LcP3Y?=
 =?us-ascii?Q?n36eqto1XrF1zibJKDMz8IZ6+tkAnBtCwSctRoGbEbpa3yBWiJkokupFkWEi?=
 =?us-ascii?Q?k7K86UrR/E4o447YqE1iHSj4z12OhkLkFt8bOiQl+O1Hb+luNndFi7YGCr1k?=
 =?us-ascii?Q?YtvtyTRotFqIh27pKZU+70/DuhJFLnvvDa7IXMgQvOmgWKysZoDq6lDqN7Ej?=
 =?us-ascii?Q?pOq8pUiboW/jPojj6L9Fe7G4AvRjaNa5/fTTJyH7NTnfAEJcJdHsK758PQmR?=
 =?us-ascii?Q?pFU3kwRMSzuROcVeOxSs8vou4gSkVI07ICFSFzzp1E6pGRvv6HJ9WGINHiqk?=
 =?us-ascii?Q?AyZLLM9UvEGEijJs6be4jXuJqXfNfpfeJ98mbLWJWJvt7bY/kKnmYAz8TdwK?=
 =?us-ascii?Q?jkkIPFUIACv1ODuMkZxji4oHqMP4AJHwy0jd+pi9QFQk+2/iYd7kTNacZhpl?=
 =?us-ascii?Q?QqZBxT5YVXr5dYwBvaa79Lun2iWZEoKUGm7wngZpK5gYgBtsdO7iKCsdGy74?=
 =?us-ascii?Q?8W96qLpW5kU3jS+3N3mn5DU/6uMy4hO44zhju57iTGrStGxf4ryOCr6LeFkK?=
 =?us-ascii?Q?4Qslr4glTMmgr/aR432CVTvMEr59oNajw79izcfs/rQW+Qr4C+rs0bkCSmhP?=
 =?us-ascii?Q?IPhHbrbtbgPSe44nelcgWcaKmfQ0cKEph5x69hLBhipE3xqjlP+eh+aGJ/Gd?=
 =?us-ascii?Q?m4LnPcUHLO4dhEojMPFdBESpUs9IB2LEGV4fd5eEv9QSUbOYQiNnrX8q57/Z?=
 =?us-ascii?Q?ZcIceQ+i6oBaLthWimQt4oZD4tqPFGxnPH3yVFSaPaCp15yEAF67La0WZjzk?=
 =?us-ascii?Q?uv/qzdtFpQCuQjLHQUv57GxVgmrbmYN9HAcVpCxTRblxFt61dhjeBRtk40v9?=
 =?us-ascii?Q?gy2n5GN+Pj3lgEc13BRlvd7zQVOxSSiBJ3xcKJowmgW5W1EJyXq0KNzk8qvO?=
 =?us-ascii?Q?rCUvLg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cpDDBYSeh+uLE4Edh1MiTHJTETazHsN2As8AtIQmOUYl7HpsllcIypHaAgsbFyqadVaMFInFUMT+KkopgKEnyY7Z5AxPdiLz/08lHIhiM53OedyhG0LSraot1g+xWHwf3mGm1pPEdooRgZI0crEK2g2Ax+gLIBzuHLU4GNQctIt4lUetqTQ0eeMmDPyjCOZWgOcg4c2pEOv9pnPhScniXcgzofK/Q/r+OROof6V1IMlJhmw8DvYVs6iRQLtm0NBlcMqbpGhuqKTDDzzra9eFVw7Tmrs8dlZwt72oAY4zXAdySGWse3aC4cvX39PhL/6hINXTmsh8cFboK92H2RrD//KfkR5slaQCjvp/B12tQq668CES2OZMGXSh5Ta4EP3I4K0dFFeswivRtMLcZ+wOoxxUYCq8+MEPFbUzD/VfF4cIu3yrFJtw80uVttUVFZksZssrU0AoWJh3s1KxKHiZ9eokSl9snscJY1MQlHLzNG4LrvhpeGKoWvAG7IOyTOGBLztsSYTkKpiOq5c30DwdEvaWtmd1Iy6zd5+t9wp94McipTSOWzxI4p3G7jFNshAQ6kkkTJGo/gZY8zPIL0zn7uY7S4SXvh2rAVQUaxicW/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 425e7fb5-8029-4dc7-1556-08dc28fca690
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:17.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZJkDZ9x/X++hNjQhBSDGhbi3GZ52RmOBgEZwfUUzU9/qLmjklQbmlp3D2Br2un36076K0/w93EHmyznYjDcaMKY+8INJHNMIu1qifRixm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080132
X-Proofpoint-ORIG-GUID: z0c6qOZflY0ENrMw4W-hCeLfFydAx_Q9
X-Proofpoint-GUID: z0c6qOZflY0ENrMw4W-hCeLfFydAx_Q9

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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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

