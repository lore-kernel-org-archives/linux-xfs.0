Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81524D117
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171643; cv=fail; b=Uc7Hkw8mFQ7LK8TwYyrGlCj86wz7AvQ/aqTNUSk3SGqKYc3U/Bzsn7m0CH6j9kCs+ZTarkBBvPdOs2tH9/FtS2JJP+iyX4lmq1nW5jznu8nAJWAy0Xug2iZjch+llEuUY4C3o4sMelMOxoieXdSpyCLX1Aj0mJlMnR+pIsgvKuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171643; c=relaxed/simple;
	bh=9jdLXbKPGvpjeGaLcBjPtQQ8gALOgO68AiaPajhH/JE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gu2ZEpikzgaj7SVtgA0XOf2BXzf4fX/mkBXDQP8Na8KryOb5jNWCpw+M3haANRPj1MFPjlgyTzcXAjgk8kawwpY52IpL9wP4wXS+5XXGxHZBllOVF1IkvyIAnoyIVbQAlJYAl9/Xq+Fey390HHFM56QiF0wA+mYGrEBUYKCIGsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EAEAx47w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GcehDpYX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EAEAx47w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GcehDpYX"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LECpt017481
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=dH6ITgYzGSAXRWxmWl+up8WZ2wFyu3w11rbk+rKMkdE=;
 b=EAEAx47wXanO2XGUWuhVUHH6O7wHRbQoVMc4wpfSmy7NOxiq6DUk5xONgzK+IfmNlgxf
 WXy15sZ9b20EoFOiTjuY2CTYt40o1QRdFtvkJYxN3PPvY0JumvFKkTrgLra4Xgw1mhi0
 DzkZp7aZ5GetvfrKMHQg3mxTSdjRwX3/S+Qmj8ZLf83dgwFXfHIt2/vNcjOVZh7YLuY2
 I+/VBRBi27TXn8Hjl163pf3r4pCmOHIsaftXmePeCWDJbwW+KL2dcSv0A1jEwv8lSxKt
 pfj/gjRoYz3nFuf3Xfr2cJwEoGZXUvrbJA9HQe1s9AsTXmIayrEMveo6rLpU/VnEzMvb jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1d3ud83b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415L6U3P007043
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6k5pd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHnyDfvNVobVF/2/8YE33FOVK+/QaTt6n5VQbzTtPpv4B2yutLyFfslVAxR4ilFpz9VGqqrAgCQVq7mqla7e7B3u/zee2I6fPMjKKXV1Z6F3OJpfVaVutqz+mlntoN27EImZecyiEEizSt9wERRH6b1O7FtgOQLjyJW3nImP3rVS9nASiK+mnX5mT0bezQq14NGiX71fS3T2q+0if1we5+1nChHTe/bxrv3147uvC+zYp1USu2nbC2ajGKZExBj6QQn1XNJ6Jgh4SeReQws7JozX+1IF1TWIDIqIwZFILgH12a8qImjp9btMA3FgdRHrEnxWTcQzb2AsEbGEo765CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dH6ITgYzGSAXRWxmWl+up8WZ2wFyu3w11rbk+rKMkdE=;
 b=OpAX27Me8vnKR+tg+2Y63djopo+Km23wt4psR49Xz1wvGGc258stiwENSlt0GPHRvXLBD8iUovn/GMal/DeyYXyo51wYd6OupQO42ewU6rLM8+JgRMAO4S12kvvrCpULHz+LiA+bXQNTGY6z4XbLpxNyjdZBbR6VEGibEI7uJiABE8lRMw2CG6fwetYYzC8zg/aiiLYCLpJjIcR8gB0cM0bojdlEBCPajM1Ou/9E6wnFGv5m+GSJqYrRRVGk1NRxTNQyvsdJDzTuBesZPeh7elwakeAnYOmEUNHuRYNda3ffKddEe9Lq42L7lWjcIrJlLpENm+tjicQu6+ybNnqJfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH6ITgYzGSAXRWxmWl+up8WZ2wFyu3w11rbk+rKMkdE=;
 b=GcehDpYXHhNELzwrN+jrKvKv4hjbDpqs1715sWUbH+DYevvGrhualgXjSG7qcPTDXPuAP/dONkL0nkCQVpVq5/vWr28b05yfX1VXS/ulsbb9+1nsBYcZKOUeXeNR/5SM93dksih4JRR+vxzHI+s7tKQMUCt6ZBffCl8GBIX0Rxs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:35 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:35 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 09/21] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
Date: Mon,  5 Feb 2024 14:19:59 -0800
Message-Id: <20240205222011.95476-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0045.namprd17.prod.outlook.com
 (2603:10b6:a03:167::22) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 936c3825-932f-40f2-8e32-08dc2698ace5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IjAq/FB94cSxsoPlwpRAIJhDBtJRmhJHtrRuI3fEkn9Xjzp4GuquvCNM3Qkbz4ulRhYOPKNkBQyHuLmK0o41/+1XHmd+0xlucxUVeqSRfYbOPl0PawNL0jpGAcsar8DklkeupOKMGZ9VHgNRvWpD+SgdxZyN6/8HIrtSiNM66xF1QP91uPADmJ0iZ9Bm5IDqRbgDE3VPtPva8FDwbg5X1Wi8EN9HWj5SpAeL+Hwok9fHU7TJmX9xQvYKwcwMGD3RAotzf/kdBze7wz36fhKZFKfnRVtvrZdAx45VfVM7CMzhAKIMy8xkLvP9u5EsoU13Pq4DsamoszxV+YJKKIHpx2td9xR0O5+gZ3y3Cezq5Vqs8QlovvpRyri1HmrUaTtfvpyWztuoWrGeoBgRdOYuxk8W5ux8t5rvgpt0b8GAreaTS6oJ/0aLVZy0szLMk7tcYRahQS52N8sVTf907TUngcgTfzLJVhuAdqn+oo5zrtJkHjyeW0/i4PYjfBdmeVzo5//usCdrywa2bX3HO1A6A9xNeuvYbsPRP8ROmmeIvKR0EwG26LS7I026BbZg1dmD
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Zo+/MR30ED6E0AIHWzK+r1In3ZnREgDAXlL7BWSc/rdBlab8SbAa4lCPiKrB?=
 =?us-ascii?Q?TsNFpxCQVtL8+yV0UPcWzSO1y2kkFoLZK6jZn4ThPPpReXciTQHIOh+Xvj/o?=
 =?us-ascii?Q?GkOSUx3dGVkx50V4kjCbNh/6MVT3zDBKVV8kAq+gbU7n1cSzAsHXiz0yB433?=
 =?us-ascii?Q?K3ObbfIxXQNvFg2zZQlLZUATH3vH5Kel4GwQxHhbGzA1avxMeMnbV2vX2Yvg?=
 =?us-ascii?Q?o10qdCTPhKpY6qJMSL0rNsZHrERhMf+9EgjjGjM8yAK4pPExMRjkQo2l98zN?=
 =?us-ascii?Q?Jki8w9pg3ptHUsLs50Ga7dMr3fPEpI1A+okDiWPhxMCv542E7wKTr0Qp+Spp?=
 =?us-ascii?Q?qXRpqObsOk5VirzCrRXuJJfZlzg3zj68SLud+qOKAfwTVhtkQsOPKEkIOu41?=
 =?us-ascii?Q?mG7RT3Jdmnq94urg0Y+bhMs2R8F3RxprW413sOW8/G1IzbQ1mAgP/S+kvRWc?=
 =?us-ascii?Q?kRQx5iY3xSYW+dG6YXAoNTGKqAjRr7P9JVZAIbqmeTd2odBRRd1n5LuLwFmJ?=
 =?us-ascii?Q?p/9JYL2+gEsVnc3tzBRTLRuULtqDEghseOr3yld6JshrXAnRSVkFtzhK4qc3?=
 =?us-ascii?Q?D3fOLslCEatiMg/y+46JYbU9TQZuSiaPThOeUbOR2AWFZ51tQs14ZMRTVRKs?=
 =?us-ascii?Q?BNdZbEjfupuZdz5WJ99ptqLFdfprRQOZ2FL6Hy6Ez1lg4xUT+Kvvvi0gFFmM?=
 =?us-ascii?Q?AjzRMt3lO9o5oUPh2rWBvaLfNrt/mZicaTclIWP/qP+iVRir3f2Sn6ROny+k?=
 =?us-ascii?Q?P8NaNpiHyx1A6gRlQO6v0TyaKZ4p8ohCAmNf9kG++XgKoeSN1xpmyEONndT/?=
 =?us-ascii?Q?sXGu9lExG1tCpoWxgcV7spQEL1oOQd5kPjc7mFOs7x38gu2Z4Vz5gE4zxSWA?=
 =?us-ascii?Q?LgRjAJjPh3KxIhpJyIZQEduRZrzu+usuqUY1IWEMZWLttROMBIkRjXWvPI7v?=
 =?us-ascii?Q?rEh6/XLRDccMFQKwOYlN1+yZW9uigTUiANZJGLjhAwicoL/0XNhlErvH7BFJ?=
 =?us-ascii?Q?TiHZ13fUIfwX3GrvFbG8f1N7JrzhWQCEk6cyCnybipofqeVFA8i/M4ie4wU4?=
 =?us-ascii?Q?3BBAMxQw4QLLEnnsvX0yMZzDvuNjOt8W6vK3qYfg5NC0KNyHa9YEraOMxN7A?=
 =?us-ascii?Q?bE/FoPwXnCWhF+Qq4tmyftRhzGCHKzjzxV/rRxDYRvLAzBrQCB649tMUx360?=
 =?us-ascii?Q?qXgNRhc51O1JoL8Urt3LC/XfoAkAlvCdOyQoGvEjO1G+B9ehpIOSRfjJq+Ck?=
 =?us-ascii?Q?h3JqysoOQe1TyFrTL2DB1DO0G1JkjGu30FXF4h7D68ly0HjjDUwDuhLEtA+o?=
 =?us-ascii?Q?lKTY04/HCsgjC3Fo7Y0rS1UAuJALi/8e77f9YtrlajKCBl4Efl7LkRwKNOoZ?=
 =?us-ascii?Q?iI9i3xczhCithqST6OnV2KYhBhHuQmTzGrdPLbTlZtIOhZr4ypNvPNK+Caa8?=
 =?us-ascii?Q?PgN2uBLgnmirEMpad3f8zaj3B87Cq77TiFZAMNulFiYn5iFWIQir3UdwNzXh?=
 =?us-ascii?Q?RA5ntBJGmZMBcy/S2ActAqP3xQD0eim5pwLz5htA8v/wynH6X1Ur5OeYpCza?=
 =?us-ascii?Q?0swSLR4u2E/sh2Y1dg1JSZn/xlKugLWRRFgMHUgl370fWj69n+0NCBSYGVIZ?=
 =?us-ascii?Q?X92iOuMZln7OqKP0GcNH6qYUKe7H0b60TBNGkqIeLPIakYjwLnK1+YbvOpjk?=
 =?us-ascii?Q?4d5Crg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	f9ehO/40utZumldcpNGYaf829WDO9GBEXvENcoGz6l94Uza2HsjRCJ+BW1oImf0E9moyNCyVVuohC0qhxWBhWtchM+tGEizHv0juBkaRH+5Yb0+HW2wOA0l/lToR4/51enVNbHrBSpnkgyWbjkihW6btrtbb5YtkqKqCk18E991i0d17rAsUQOQ1Fb8XPFQE9Lv5JJfwzR/51PsAV431tNk6tXK7kXveCJP61WRBh67zHpHV8liclhTBa6/ZccGgXQ6/ffvmeWwuK4tbG/GTiGFmzZGS6u30Z5SOeCsnWYwMmgS8jMDoD0NlfZiJg6SkaVeKTiRw/ACG3vA2W76v0T9hOfTVjTYoq3gyZJTmnT9wyTBkvt+utECaQbjUIniIYFbwQUb3G08Psobe/lB5OoQUHsF9qv3bmQNMhFx5zJXvJ53dM/rNwvn83uQpnwH2Tq3RkJSczGmRVltFr/tavC+4ZdE8ziopz4GuCSE/x73CoQB9uLRp5g9M//zKRCpOMhsJfgQ22mQhoPzWUrlXkr7kxTptg26lrs8Go/uPP9/RGNWHlEZIywYyaMhXs7XS6KJTbLesS8FjeZcuUilp4VToBlYhTL+Efxf4lAspk1Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936c3825-932f-40f2-8e32-08dc2698ace5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:35.8224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNcDoFhsAo98VMYqs+N2Wd3GIlrpVmQo51XcqGXerAb4P6z41mUUR/O78J9lrZxnbiVv7VFrS7e2AOOsz/MNgQzvYgP7v3Eo3O8S2ZzohWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-ORIG-GUID: 4mmtMdgUmxfi8jfIrwQVIAo2Svrgf9N5
X-Proofpoint-GUID: 4mmtMdgUmxfi8jfIrwQVIAo2Svrgf9N5

From: Christoph Hellwig <hch@lst.de>

commit 35dc55b9e80cb9ec4bcb969302000b002b2ed850 upstream.

If xfs_bmapi_write finds a delalloc extent at the requested range, it
tries to convert the entire delalloc extent to a real allocation.

But if the allocator cannot find a single free extent large enough to
cover the start block of the requested range, xfs_bmapi_write will
return 0 but leave *nimaps set to 0.

In that case we simply need to keep looping with the same startoffset_fsb
so that one of the following allocations will eventually reach the
requested range.

Note that this could affect any caller of xfs_bmapi_write that covers
an existing delayed allocation.  As far as I can tell we do not have
any other such caller, though - the regular writeback path uses
xfs_bmapi_convert_delalloc to convert delayed allocations to real ones,
and direct I/O invalidates the page cache first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fcefab687285..ad4aba5002c1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -780,12 +780,10 @@ xfs_alloc_file_space(
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
-	xfs_filblks_t		allocated_fsb;
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fileoff_t		endoffset_fsb;
-	int			nimaps;
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
@@ -808,7 +806,6 @@ xfs_alloc_file_space(
 
 	count = len;
 	imapp = &imaps[0];
-	nimaps = 1;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
 	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
@@ -819,6 +816,7 @@ xfs_alloc_file_space(
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
 		unsigned int	dblocks, rblocks, resblks;
+		int		nimaps = 1;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -884,15 +882,19 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		allocated_fsb = imapp->br_blockcount;
-
-		if (nimaps == 0) {
-			error = -ENOSPC;
-			break;
+		/*
+		 * If the allocator cannot find a single free extent large
+		 * enough to cover the start block of the requested range,
+		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 *
+		 * In that case we simply need to keep looping with the same
+		 * startoffset_fsb so that one of the following allocations
+		 * will eventually reach the requested range.
+		 */
+		if (nimaps) {
+			startoffset_fsb += imapp->br_blockcount;
+			allocatesize_fsb -= imapp->br_blockcount;
 		}
-
-		startoffset_fsb += allocated_fsb;
-		allocatesize_fsb -= allocated_fsb;
 	}
 
 	return error;
-- 
2.39.3

