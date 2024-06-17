Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CDB1991BD;
	Mon, 17 Jun 2024 23:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665459; cv=fail; b=scjl1hvTYPW1ec3RF+ObWo8LK8LN4UzXUEmcNSAhWA1sMJ7GCV9AN8fUOZkZz8H7JjOnc44b+m0+v6ilrNUtnUYzaSC59s712eUtkYRjJPxiNHw9iMmFzk/wSLVRDyV+iQxP2yTrzksesFuIcgZPLX50CNhFciwI6RtUqNXZsrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665459; c=relaxed/simple;
	bh=wwfWuopV32vj5By+ntrnscG4kVn1vvGvwbfpHqKUGpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CMXSJ7d/Gl4RkdctfZd+fPieDqeAtUx8avFloYQAH8EVEzMXgpAmYPvsFptcj097e9J2+hUs9nypipPAWEK9JUSnjTfPumE+yHmyqZS5weyew2hADF32nw1F9UGTDqhoIY+4JwU9s5tUkkX5VyB1nnzsTYrHlCC21+HFI1v89kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jtzwuhdn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KWHGtIUr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jtzwuhdn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KWHGtIUr"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXiXo030327;
	Mon, 17 Jun 2024 23:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=PKXadT6kTHh6j2GcIw7WKn9crtXhXVHDHzzKzWI8krI=; b=
	jtzwuhdnLT/ykD2hestf49aAdg3f+qOUQlrwK2WPiK4WHR67P3I3GAHAY0KiWn+i
	vdYoAKHAHtgVgs/Y6/Sr28ddflqfWtVwhjDDzkI5Mc/7dTKyyQylbkY1M/XLNboY
	13QldYmjQeMBaOsxHOdUVFCq+9vT/B+TibmksibJuj2FDcB0lFV9q/0ovgPcz/ph
	JlWXz/hrFCfWMC54JPZKwDWS9EUbUsf3hiZ5lujJjMKg8NE6Pvv8gXh2vaUspCtL
	znuYST4SCDKPE8BmS9bshCXK32aGVaB11ljdJ+1932ARhB7CmRWirCRn+C6R32Nh
	rKdBOr8XqE3FE6RKfiSPkQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1vebt9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HMoYkR015557;
	Mon, 17 Jun 2024 23:04:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1ddcc0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLYT+ST1dYhwkn9HoK7sgl3qQwho8Qs4JxbPCJJ/Kvtf1T8iwb3UdkP/d4sc6DObMtW1474ucDVfSCZxgigTYw9GHVd1PZ7WzlmoC75O2HwA/nA+3QWYXk6iX2uhJZ17qQ9VjxvWyl0ELU7nW9eeS+hDp+Ch67L8s71pGYY0INh/QOYWsgn7jkC9N95vqwpmD/QdWKiTT3znAVbQVuXJQu6+ZSwN/O9YRmBoDtzXNOKPumn/m5RkjLld6Hg8Qd/spp23nFnk+ZZQ+E6bNbMuWdNwlg42AXKFh+49nfdux5sI2osWUeglTIj4Tc/VsXboaYOagRPSXmDH0Ldf4cpkzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKXadT6kTHh6j2GcIw7WKn9crtXhXVHDHzzKzWI8krI=;
 b=Ug1teWZbFMWNMViYjwQCgERLucGHyZPv1SwrsMLvFgV7vpCr5un9/BG1jGyq4EFjeDZ2Yyz9teSZrse/QxGziiMs+v/RMMgmG5SMOhzZuNdh53kL9Jg+QAtrqsvOG+kaPkJqH30pE3BzP2PmDpXRBeAnPwkTBpOKjFv49kugMlmSxL2pU3rU9qeI6eQWhomWN+v2wpUIEhNPiSmNguTU+0ihUxhLkkEXFpV8qfXRl/r9fjJTzD8oupoxtEcHaC0CXwx178ooVvKz5/SsV9qqO3WIp/TLpLGPmx/UZ8sgq+5yVPXrCSzT7G5DqAfb1iqTlpYHB2X0jyxowCT16YbpQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKXadT6kTHh6j2GcIw7WKn9crtXhXVHDHzzKzWI8krI=;
 b=KWHGtIUrOwJrBWScrREE4mfX0iBKYpULijrKJqgxA/7ZvBJOn/onUVf8UVRb6Ni4W10eLEw/qamdxQmcVwxCku9kgnYzlQ3RmG+1r9OwLL8QKTA9oopmjv7oGAtu8MvOhmvDCjYHKnYP8y+sP7ADMv4aGoGIx3vXgnjN/COk/Kg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:04:13 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:04:13 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 8/8] xfs: allow cross-linking special files without project quota
Date: Mon, 17 Jun 2024 16:03:55 -0700
Message-Id: <20240617230355.77091-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 17318047-9822-4eee-2dc0-08dc8f21ce00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?xUQTM9uaa2K+thFe30E5BneH2YNNFHaOZdxTkRA489bHCyTXzKZbh+ApxX2u?=
 =?us-ascii?Q?uUPQdX5hGABZgma3/h90BeJHGOJGPBrYB61IOCSiIYI+vWDn9tCDyBApvrYA?=
 =?us-ascii?Q?dB8mNbuYywnMPWdp5rBKl4hjeHEzHLvREfVboOsR+12N5/Cyf9w5fmFrkM94?=
 =?us-ascii?Q?vVgR1ly0g9BMf5abe98SO/TEW1bY5i93tV0TJy39f3l8A6ge3uQROYRBdkW0?=
 =?us-ascii?Q?+CfF03sb1YvUJAUAYG8f0Ck643NExFa4PUzXSTvhPJYlzqtdySAs5XY91/Kw?=
 =?us-ascii?Q?P9YJw6iGiLBWoHekbo6R0h4kxbGLQctduMoR4SqCTw1IRvq21XRSFUjDenWQ?=
 =?us-ascii?Q?lo1w28Iu0TKfvowPIVNJwOSD/RGfkk87c8Md1pRuPYTc72fzk1Q5TTIt2Upi?=
 =?us-ascii?Q?7pO06nB5suH5YnfpRpBKSEj1y9EdqnSNx+f9gCIuUFLeG6nujdr1ZhofEDvt?=
 =?us-ascii?Q?dep88jpHhnalFu3H+zfrXxbZ3qtSeBeV9IYpJlVvGYrVzVKQFMlvD5yGMx99?=
 =?us-ascii?Q?lQ2AL3n5gIqx+CEQeO0K8Wq1NZwVpHlZHTyRspiP+qhgBnOOs5sl6HmKIkM4?=
 =?us-ascii?Q?nVy8dYWeDby0xgL1AMUN29xDBR5ffACs6f5tQicTrI6SnivVo6FZ+oRxnnp5?=
 =?us-ascii?Q?Z3chIC7WJy/57FLGuW/uDANe9Qm82q3DAVWAMqYTqk6aUFz65RNbW993iCw0?=
 =?us-ascii?Q?ZOddxqETX8vg/mHagIks12LfrQzLq4RfyxUuz9HLPo2sMCbiURFkERbj4XdY?=
 =?us-ascii?Q?+hW9XqJ23KxMraqZVncLpClsPJESSxQcgDWaiOIDh0D0oavq9jNEprKbUQPh?=
 =?us-ascii?Q?b1CfuzTkqqMeWtdY1y8dh7GdGhlcrZTTUPwRyq1GkdzYFawsIS0K+cjtCp5W?=
 =?us-ascii?Q?+rnj0dWxTzE2mWKSrIwgD4gk5aW40ZD3bPAd8myfAa568Sbnrhu8NH8NtyEA?=
 =?us-ascii?Q?QOgOZ1zKWpM0SlepVTch2KG/5alen4w7g/Kchsfry5AeYrdDJomAZlavjDIE?=
 =?us-ascii?Q?iHL1ScdjeI69cJ24yohUEauosocGHxAXvyYCgFT4m4zypRKjZS3MMKl3PLqg?=
 =?us-ascii?Q?zd0zoWOh19z50qo/o9Itu7r2NQAw9uT6rqtccvsNc3xB7J4fuXa+6ScUk4GM?=
 =?us-ascii?Q?KXs7rByMzXz3Tb9hHo6XX2MRWrCGhP32xFFpRqZU6IMJSNH0dkz9nENFluAY?=
 =?us-ascii?Q?k7MyZ2Az+H8t4YYn/x6S2gZlM3brkge3aUBgww2lOnTyebwFAXVByO26RMtZ?=
 =?us-ascii?Q?DqYa7QoJDrPnmixZ8BFc4dJcJptW/3DHDt/hOAxaUkNDkSigR+U1HAkytPKS?=
 =?us-ascii?Q?8QOSpCSfONCIFWJPy/VZ3MeO?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Qqx4aBpAH9fRZOgxmoKMOp1xOwhO3Q+noJ8R7JPxYSNNXUku3ru38UX0D+r+?=
 =?us-ascii?Q?0tMz49IS7Wea6q91NGWFmPFLXpHj0m+PJr7GKuMYITGaryyv8POMCTv7q+LU?=
 =?us-ascii?Q?aXDU1dgQEJkNzB5pAZIxaH5KbYB0LF6/i6MoJ3auUE9OZ20L7t48dhRr5F/b?=
 =?us-ascii?Q?SC46BhpeTZFi2DTZPcRpl6k9BXWz8/WSjfX3jjxVIoTKzJOwp3KzBpFTVhgR?=
 =?us-ascii?Q?zIsTO9yXsEJeRgnnv51dMNmQAiPJOexsq21EaIvAWqmWSyQAj6ueURn+7Lg6?=
 =?us-ascii?Q?vGpfXYAREnCNemIXPAWjBfby9xa6d6gMniCSsZX8r5B8dSJzPCP9doodK8V6?=
 =?us-ascii?Q?1r27t4ytgt/IeFfjvPI1mXhWQs0fAXLECuo0w4uVPKX7gUejpQ3P4G5cliId?=
 =?us-ascii?Q?gygj66u/Cq0d0OGr0vahXA+HTARk4RNLhk93wVScxLOAQoLxd2Uo/HbOzm9K?=
 =?us-ascii?Q?nO1KRTVcxg1W3+l7xOdYH62EzQeHvmeGEVz1hSolrMzKqWAqIDBQtluzXad5?=
 =?us-ascii?Q?aTZsEXPb68r8Aou0n/KZCESyZOO/puZy/zVtu/oswtc2sEjKcoGwjieD+DvK?=
 =?us-ascii?Q?0s0p5kLW3ABsc8eRkzJPhvuy99O42R38PVdV9be7uaCNoawRg6RCn0UoX+1b?=
 =?us-ascii?Q?pYWyrJUgT8fFXyMAU0H7H0tpXZapg1pp+lH/QwgccGM2fM5Hg01YfmiKwDY6?=
 =?us-ascii?Q?GzQA4zQpBTgrT5koIJ8/4MbVPhsjrJ2nEQSNGnQ0Oos9wqvk7VojFeL1nPv1?=
 =?us-ascii?Q?Q5lMm2qGkUj1M2lgUg8QJCLzVCE2gDSU8C23KWR8W8cBb9OQvnHB36BpWA1/?=
 =?us-ascii?Q?6Y+WQr/qxm5P620I6u0OGLo9+qLVlT+lWmrv0LsTiZFAG3zBvVtRZnkwuek6?=
 =?us-ascii?Q?413ArWzCx3QU98UtIBG7ZaDabqlmKLvpiQ8UuSXqY0xBU71S9xpIvCCiETzE?=
 =?us-ascii?Q?iXbC8i6Qhwg03uo7hxuabNEtp7I98Hnq80W1is/KERTtJynHTxJXtWJW5qaT?=
 =?us-ascii?Q?P6XxWVwsPcNG8KLAVSuFmpAfkdM6CwkjKkUg670vnRzG4f83Jsk27F7kueRX?=
 =?us-ascii?Q?N53Jb5OirSI+Fx0O02eo9EWPhFHI0UsasZ6JYy8Fn2gFMOAbaX8+ES+Njg26?=
 =?us-ascii?Q?kU+J0PuczsmRRBahB/ByvfeQjl5rNh6P3tH127TERzPg0esCj9WC6r+gQVEB?=
 =?us-ascii?Q?WVWsVacINevqZ/hlpzRwC38IME15LadT1X/zbjqgXuKHCOY2ZWMGYbZ2ZlF6?=
 =?us-ascii?Q?qNMwF9pqtzf/CkgMUtqxuyeLuk3N7OfSG/Or57Suv2Ltpq4Yczw9mTLkLgzw?=
 =?us-ascii?Q?TTtAG07CJRX7qQnbpcDOrw/aH2Ud8JF1GIz4jC8PYRA5+lCY5qC/obGBW4bI?=
 =?us-ascii?Q?H5YFgA8/VTXN0A9YVBrlURcWifNfqxjUCdRoqYBc4YoW6p3XykQnEO+KPC1m?=
 =?us-ascii?Q?MRHJOurUuiArXUoofhn74Ex6jyWR6M1+1y6lABhYrlfN6n7KtdDjRiolRvMs?=
 =?us-ascii?Q?GCTWNj3wi15jmMgMKfHwM6IIDuTUEgSI4pA4DcXlFqY+Tj2elb/wn8rl/vVO?=
 =?us-ascii?Q?pYlhSD9JhckCKTce2l+ckhdNVBaFwu5wdicjXMYhgV0tNPSVsU8vP4YMXpxY?=
 =?us-ascii?Q?PAmUiQFb8OCwYFhassdfIw6gbtL90fFAWUU/f6Y0FyZpAazfwCFCOotI7i16?=
 =?us-ascii?Q?/0R/0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZFAbR14if2gsF2KxIOEt5e0PyOn6DSp5JDW8H7aT9kGmwg9ZDLDWYOkOj6T6AEMqRV4LZLcKV9XxNcxbic0mhhvSpUjOTzUhsr42uJzbchG/gutqCDFzHvGiQzFo/hlKjwqTlFUe07GjUFs6WPi1leqNjHbkHCwgZl3r/R0/+k3JwZM1LgVzw+BRgIsszdhF90Hhge9rMT9Uq0bPQLNyCwG76k9Hz32ZCW2O4m+yCBZf28yB1HWBxmsodkjbW3yxt3gO0GiJ6hYOg1mWkF3aMWYZrXiAYM0fsi0qGnxZXYAZOetYj2dbDEBWMmtD+O5xpUWEzaY1bYTx9FWVs8bHD+CbsSG2EaubD/dTs7wCXQacrPYFlfdzkAvqqSy40E+7gowXQO33y36N1i4UgcOSP7E5+UqMRjpxprWSn3Y6hztKiX4diNdVcIwFlidrBR/YT8vK/WbhNmlHR8ErCUZKV7APRGUV28kSdxrJtYMMQ419ZV0Ktr7gu1fRvGQ/VGYd/O+FqCg0s0/52T616Hf0sHjXmp9kxNnPy4z+4ne2NMeId7rUl39ODsI84XTHPczw3Htfy9l6UqhdyACzIRuU1F9ZD0RjTBa21aLpFSlOxXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17318047-9822-4eee-2dc0-08dc8f21ce00
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:04:13.5333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8kuEh8AoG87bm8lO97jsdpH4l+amvlX8PdNMGBYCCQF0rrPozTQ+IXa4qPfkKhdu5G1SQrDBIFbd1R4TTuCCpSPeBCRe+PKhHpwNcJ7Imo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406170179
X-Proofpoint-ORIG-GUID: W-Ya57xfg0D_9JOO1efD-M6L3bYcOIPP
X-Proofpoint-GUID: W-Ya57xfg0D_9JOO1efD-M6L3bYcOIPP

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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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

