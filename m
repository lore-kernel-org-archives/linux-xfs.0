Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EDD1D6DA0
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657137; cv=fail; b=plJGtnnc+3+nGNn/PeGFZTBdkocuAAHKlBChVSeaM2tsI/FbDyEFrXO49aIUnKsfpgSfsMq9fsoth6fkN6P7LbvX6WIO/FYFdwh1eblhyoY9w4oxBUlA8hnmsz5e1GnwNetRvOjKsF6aW7nzWdVWye3/5DTxupfsV/L1XWoEk2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657137; c=relaxed/simple;
	bh=nCZ/+Qoq3dPpHMJLAKJhWk49L3MEfAkm+zPG/DFAyhA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iSgJ1uFGmV8KlsETVkP0UltiEHIjkVf3VPAU2TRYtdyXyDiDizbRoqebMDDJtfOXSTAewlMjsTsMQyOMGfXnrykMePDPdElTKfyNwLSBa6kjPef5oUp5ttK6S9DzES80hd8zUmdhWG241nbpUS9BZ2PcFfo8BYao1N6BTs+ZnJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wb3XZvzS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DX7lxEqG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wb3XZvzS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DX7lxEqG"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXbnI011424
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=IOTWp1NXFwEiaJ94OYY6c1j6PA419LIhJNDHKccFivs=; b=
	Wb3XZvzSKAmXhAF7vf3TSFzqFRK870x/dUFq2lMuTVNZ+bYg6FHTM1GbFQrGkPxA
	c3kSf/JZlprhVNs+m3tGv0MZryAeMp3v5teNJrP2II9taweusptBbnrv/u+ZMaiX
	oJ2WffsNJlXHbDYtFEuZK5eZfdPtD4R36orknEa5xots68ye0AY/QV4VD0Ortpf3
	YRxj+W/7Vg84TTePToapBShcgavQTgoMg62NQXpzknISNDJ7+GsfCK3I9nBmO1rS
	COjWmKPxjy9qXWHzQF1CGomR0POFs91y6K/j4eE/Z99p+M65Wdg/Wmk5a3/Z707n
	tpOak7ovf15TlEXT7A3TbQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkajbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486KE4vV036884
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhygea0r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q14ozpi8cDk9XiBt82zSAqmqr/OOvWhcEkYcOWLjQLJyXnUwYeH/XczFzcpjNBH4oXyXL6c/DTQMfSZLzhan2GbC1+vFsddI3srkCB5oH/J0sCH5gUZYiWPiegKpgekgKBu/7Wjb8pXlTQW6VavgJHvUJFc/L+ZxRjZXAEgn2/2kABOS7nMtG5ivIQWXfrE5B4CZnh11pBpbNgJp7Vkb25DlU1rOxORcWkLm7WUYqRqBfmIxagQxPcG8n/nAT2CxnBuQWTaHgehuTt3xJpxUqusSZC0v6T0dVyqzeIxQh/Z4BR3zFJXt8Ot1k75QhIgXxH1mag3fEdYSXDVHqKL99A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOTWp1NXFwEiaJ94OYY6c1j6PA419LIhJNDHKccFivs=;
 b=JSr0jEuF/sUmdf7HFPkPUN7DtY89aOG3xbyu9kRl5y8YkYSs0YarHeOEDyOGz1gJn4AcxxqtR8qN456BmAiD3aPz/MAKWhtpbUzuTW11qtasYl9o9wUgXxQlmyi1zFEkotWAwLaUO1erc5Sg8rS5XEZIWYGPcHi7kPxVVzqkDiWyDxz8V9/fxzaODX/moDo1jk6xNtUxlf3RorWjt1ycNaZE8BBPkEfl2mXIYg+2QmgZs3b/5eBBO2tACGLXy3JvpAq1WnMsqVDiu29zaPeb1ColwOBH0y02Fc+4FD7uR+Y156FJfmDossa7i/jKTxHdno0dr07VCDupsTatf0H/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IOTWp1NXFwEiaJ94OYY6c1j6PA419LIhJNDHKccFivs=;
 b=DX7lxEqGsCgBfN2Duy9bTNbrGjvqde/QS65ZWcz57gnUfykFAN7y4nSZg0NDsUSsHguxTGt5fstQfVwYWPnZe9AevdT5Qytg27K5LAZAcc67oQiPfwnz3RqvBH6aoOao63TsbIw2ZjcqfX9ISbympw1XTyj3LWIGbnYyhc7WPLA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:11 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:11 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 15/22] xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
Date: Fri,  6 Sep 2024 14:11:29 -0700
Message-Id: <20240906211136.70391-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0099.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: a33a3df9-467a-408b-ab6f-08dcceb892c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N/MW38McTXBlPh8udNW5kJFcy+EebZ0e3qd9slmFih9WyAQcfzztPPo4Y8Ef?=
 =?us-ascii?Q?BsA9o0peadmyS+mFevYgSWVH5f6NKRK70Ks3N7nuv+UCKQG6aVw1N8uDn0Vt?=
 =?us-ascii?Q?TofhAj8RO96ssezivoNAryB9oD5NAgVDchn0/KOWHX4nikuWFnVsrps+XXYR?=
 =?us-ascii?Q?OJf7Jcv7Tz/bRn/RppqNB1PIa3m/8PYsKsYSS/awBEgLcUjJHKV1qedkLwHo?=
 =?us-ascii?Q?NQHm/07OYWQsI/U4oqxJq50I39/SPjsqp7kvgT9eeyUlxMxcc52gxLegsLu6?=
 =?us-ascii?Q?5lyoci9aOguzDAeC5G9j8D1AdU45I3kK9TX/yWQH6PBlGLpk6x8FQHjJZTJB?=
 =?us-ascii?Q?B0MdlEptNlbXxz8S7OG7g9Lg1cG159ZPV84hX+1ikTHj4G611j5dN3xkCI4J?=
 =?us-ascii?Q?izbP//dBBdpsru5TbescIdFjR5gF/9Tk0QEJIvHfSlFJRCzBuvfDQk89VLqN?=
 =?us-ascii?Q?P3pinklwpCs1cah2tOjyVIxdtB0UATYcN+xFZxfDskGfVCIFogOdqZ6SsTFh?=
 =?us-ascii?Q?YB5yC7g89otnTvszXNDlQcoax6gDi4IkOZ0G4IgoAOF9C5OBWwDk8mt//DhG?=
 =?us-ascii?Q?rQCyXCnBWaXZEGBOiTcx2Tr/djTXnCVcbr5bjJx9O5oq/xEKmqx25yQWMj/r?=
 =?us-ascii?Q?BQvZWMxQjheteiDIUgtp/s8sTLW9HnpD4SmCAo8nAeqNXj/SPSrgkeA5YmgU?=
 =?us-ascii?Q?cPWZkZf3gy6sJvB+fiROC1bj/A7nBBFJQDTek9Oo/JZSAbMRG6X2vHvuuDWT?=
 =?us-ascii?Q?8xWxps6jBUeFp9x0uC4PrOO3v5zlZJbrCCeazJw/ucDttS4a2I+T4PulyvHC?=
 =?us-ascii?Q?7hp5GmSSBl8fPRE2Axjg3AJTcdDC6EUGhCz8aKSKftQPdX8+Hi27MxfWg9dm?=
 =?us-ascii?Q?3GPlTW2RIxpGmCk0uXapD4nE5iNagB/c7ah3d/Df0yRX4+kRwDD6dz1oD8ro?=
 =?us-ascii?Q?8mDUiN+C45KCI8O8JV1yUDSEKaNa8TwXcipcm8tqn4Za1w8e2JfsGV0zFeFc?=
 =?us-ascii?Q?CLwSV+xFbMY4OfNz0Cu9QVHUVD3I2NWjhGIiJnZdZ4YTxLOMGH/jCptmvkuP?=
 =?us-ascii?Q?0qL7mpiJkdmEarcTLIq1Pl8VfDDJMrFZCYlOhAfy9cEODJG8ZzqwhAElKBlZ?=
 =?us-ascii?Q?l3ow8ciTo1b1PhrgUAOuEQGTbg63WmQgRrfJBf6WJJw2R35/UMNgo33dHpwD?=
 =?us-ascii?Q?NuM6XkGNQ+vAIywtuTr662AHyEGEcQAVb/VBGmGSBSWyzBUOj6/kY1XzGrhE?=
 =?us-ascii?Q?fugMMNPfAaS5IqoGyPVXLTBdP0H7VYSejwLaPKUmRXQXVa50X4bzYLwhTCbi?=
 =?us-ascii?Q?u7j4FUMLVGfK9t4UIN7x79bfttdqXhL7Rd8+u+tyl/XVbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7vI+fOwcC0V44CmBvXUeGLS9mSNuaHx6O91e0ul7YKZs1Kx4X8DHujeCir44?=
 =?us-ascii?Q?Pi7wLVhTdqDbI56hVEboxz9fcQPziPwL/YGgSE9adDhSjWtRE/EwvqpoHjrx?=
 =?us-ascii?Q?JnHIKfNQhyCigcKNJL7EBgfBN/Ek74XIZF45UP+7bB1fRlTyLS6ylpmJJV84?=
 =?us-ascii?Q?oXsRFV65ny1aF5yTHPVkbLzb4nLNa3jhr7teSamP9AjsFABWzSHqYq/NhUxT?=
 =?us-ascii?Q?C3Qsl5prHFh3AWJaaTwHxLUqDA26iNv5rE8dlxOILNcgYYzpCpHBuFOXLCYm?=
 =?us-ascii?Q?rwfnFchKNiCA/ZDFQg3lPaM7jtbktECfbO9R90K3PCOt0yyP3ARcjz7zI3E0?=
 =?us-ascii?Q?VllbOp+RRoP6Zbd4yXGD8EE+G8t2uD53rtEtj5CTqVXrYmiZKwh50o7ty3iz?=
 =?us-ascii?Q?BvtqWU6Zu45cVIYcOBha0H/gRvXODDFPFWfSOUYViiZmXkxdbr4HqI5w2q4t?=
 =?us-ascii?Q?oohqxhcZdAxmGBS7H7/upHujyGX0sjr9N9Xzhx6yj0MuXgA4OItptShFBDUB?=
 =?us-ascii?Q?q2l/kngmsGu/3myDjAUiJUvkYSWSB4TBR3LLpNFMydOLpajNhUFidMVmuXOA?=
 =?us-ascii?Q?5im9UhFOFF7KmwNWS83FPpY7d1FnARrszlucln8hAVX7BfgDIqL/rerP0/Ms?=
 =?us-ascii?Q?EIGV/0DKG2BuwrIExiZH8g5D6vU6BvYKIqdwQGr8S66n2HNiteHzK4RJVqwE?=
 =?us-ascii?Q?v2NrITo9BdyYRi3d8yGrQVACBCN94rmEGtZmoRtVIPDv05/x2bo9C0IXK4MH?=
 =?us-ascii?Q?GzeWgTqP6kIecXubVAFO63T4/5Bn6zwHjsZ19VTQ5UCrMW84+OcCgD+AMNW9?=
 =?us-ascii?Q?ClEWqmD5gOIE1nhsb7CKH1GdQ5sTTjGshXs61f1SgT7PlusGlFR27wF1AeFm?=
 =?us-ascii?Q?JAWXuYv1o4MvluP4C3kZWrN8Qmvo/Ckp7rNYfuIYAFGCOrl6rbWB9DDAPo6n?=
 =?us-ascii?Q?FPKXGY/rOX1aP8pVyce/1kDNOq7vAgnpxesAthX3xCxBZce4SpYbEkx7cOWV?=
 =?us-ascii?Q?SnGYxXrCKDfyZFGc3PLxHGXHDikieWMwKi67l8g2Zk/V0ItnSX+EKRCw1uXi?=
 =?us-ascii?Q?QiSn3npK7uc8QYw3jaGIP2ps91IAFh9EXFLwt4mMndFZCeGxapA9PmaHgiGt?=
 =?us-ascii?Q?je6CK8CgMZlK4coyuBwLRyn+goPJIXQ8+sM4jwTCII8HJR5YdUUlc9dY7vNx?=
 =?us-ascii?Q?Me4RKrEz1euRiaG2PjD/as+ZOnueliZ9OXPWdEjC15Q7nAZl0dEL7QsKIkYm?=
 =?us-ascii?Q?DBTdKLsra46ioIiRsR3x6FOexSkUc272n6ounb2ZUcdUqH3sYNVsmuYWCtUL?=
 =?us-ascii?Q?tvQ2owCDWKIgNfJb2jLhTfKImMfosfkDUlov3tvHtJdct0mryCO+Jb+PODxT?=
 =?us-ascii?Q?uS9EQoenRTnaZn+Si6g6Vf/7ngRNEHpCtBYyeGziLi8NTUO5uyy2CeCSKeSz?=
 =?us-ascii?Q?MLsD6rBIgxjaymeDH7Aoxg8IQShRaNU34UxHTccx3dRV/yTW6Hk3IFHwewDa?=
 =?us-ascii?Q?riBpwukfK+aFAQ1iq/AuhrPwf0/rz7OU9OFv4kMscw4+e5J4EKuTHuB9mPPb?=
 =?us-ascii?Q?bZ1SUC2Ep2TKCOYqg1vCg+Pad54ralozUQlFoYzZgwVr8Ev/zpRRJqEYK5Rx?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ytQpYja+14sWVpTmfpyNrZl/7BqlkF7BhFWNXY65KWOVzR+lqJjG+5gIW5m67UGNn99SBDZL5Qq55vCRmQWuqHOakuJvV7lJDUas5aJWIvhI/yRDxvkzWRziu81p7Rvcn0j55uN0p6D9AUNrACn5aDP2DID8fueB3tHPzQe+bn+oNKK+2VFf+pH+21CcjNQvs/3wNQ9Sfqx/o/OoJSNyGR+WnX0pggFRcbGrphQR3+2jgTGt6UhIIm3c/A3+R88VJRcisOE548NfsJ5c4YI5RYyLBN5Qx7dst7qGfWTCzpFaBPeqMWJ9DeCrZYIzcW/QzQVyMgXZ1NhBqnXyysuWFnyNkAl61wimSFB2JOGPCNtVZIRSAzyVEDTh3gJp8wGWXjyObIyW8CfeeCzSpQt5g5GTuCEpofHaN1GShsktwea7ar+N+vzKprqxsHBUPycZzeDp84lApYOoyqQ1y94fOA/zB+mruzl9eyUeOj2rtArOlEpBYx8+Q92wv24mWRhLe15nDhW2lKrO/XQmTojuyrjtap3SvlrT2PxTpSL5ca1qHyp1yzhh33VyssbusZkJDKVsU47dYG9XwLBIU7MZ30/ONJ8f2IrlfvYAqoDmyhM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33a3df9-467a-408b-ab6f-08dcceb892c9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:11.3003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EhF4iVOrTbsawQBcNSvmmSfBQY2GMJF8yZqfGogcCLJnJHtDwmBhH8Zr/udcpTtIudfVTVv4FnnOTL9ICB5H4x8g8E68T77tMmEUYtCkqK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: vocMCXfQHJGf0MQc0wkCWh_3hZ388LOM
X-Proofpoint-ORIG-GUID: vocMCXfQHJGf0MQc0wkCWh_3hZ388LOM

From: Zhang Yi <yi.zhang@huawei.com>

commit 2e08371a83f1c06fd85eea8cd37c87a224cc4cc4 upstream.

Since xfs_bmapi_convert_delalloc() only attempts to allocate the entire
delalloc extent and require multiple invocations to allocate the target
offset. So xfs_convert_blocks() add a loop to do this job and we call it
in the write back path, but xfs_convert_blocks() isn't a common helper.
Let's do it in xfs_bmapi_convert_delalloc() and drop
xfs_convert_blocks(), preparing for the post EOF delalloc blocks
converting in the buffered write begin path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 34 +++++++++++++++++++++++--
 fs/xfs/xfs_aops.c        | 54 +++++++++++-----------------------------
 2 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eb315c402794..f63e7365b320 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4537,8 +4537,8 @@ xfs_bmapi_write(
  * invocations to allocate the target offset if a large enough physical extent
  * is not available.
  */
-int
-xfs_bmapi_convert_delalloc(
+static int
+xfs_bmapi_convert_one_delalloc(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_off_t		offset,
@@ -4666,6 +4666,36 @@ xfs_bmapi_convert_delalloc(
 	return error;
 }
 
+/*
+ * Pass in a dellalloc extent and convert it to real extents, return the real
+ * extent that maps offset_fsb in iomap.
+ */
+int
+xfs_bmapi_convert_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	loff_t			offset,
+	struct iomap		*iomap,
+	unsigned int		*seq)
+{
+	int			error;
+
+	/*
+	 * Attempt to allocate whatever delalloc extent currently backs offset
+	 * and put the result into iomap.  Allocate in a loop because it may
+	 * take several attempts to allocate real blocks for a contiguous
+	 * delalloc extent if free space is sufficiently fragmented.
+	 */
+	do {
+		error = xfs_bmapi_convert_one_delalloc(ip, whichfork, offset,
+					iomap, seq);
+		if (error)
+			return error;
+	} while (iomap->offset + iomap->length <= offset);
+
+	return 0;
+}
+
 int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e74097e58097..688ac031d3a1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -233,45 +233,6 @@ xfs_imap_valid(
 	return true;
 }
 
-/*
- * Pass in a dellalloc extent and convert it to real extents, return the real
- * extent that maps offset_fsb in wpc->iomap.
- *
- * The current page is held locked so nothing could have removed the block
- * backing offset_fsb, although it could have moved from the COW to the data
- * fork by another thread.
- */
-static int
-xfs_convert_blocks(
-	struct iomap_writepage_ctx *wpc,
-	struct xfs_inode	*ip,
-	int			whichfork,
-	loff_t			offset)
-{
-	int			error;
-	unsigned		*seq;
-
-	if (whichfork == XFS_COW_FORK)
-		seq = &XFS_WPC(wpc)->cow_seq;
-	else
-		seq = &XFS_WPC(wpc)->data_seq;
-
-	/*
-	 * Attempt to allocate whatever delalloc extent currently backs offset
-	 * and put the result into wpc->iomap.  Allocate in a loop because it
-	 * may take several attempts to allocate real blocks for a contiguous
-	 * delalloc extent if free space is sufficiently fragmented.
-	 */
-	do {
-		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
-				&wpc->iomap, seq);
-		if (error)
-			return error;
-	} while (wpc->iomap.offset + wpc->iomap.length <= offset);
-
-	return 0;
-}
-
 static int
 xfs_map_blocks(
 	struct iomap_writepage_ctx *wpc,
@@ -289,6 +250,7 @@ xfs_map_blocks(
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
 	int			error = 0;
+	unsigned int		*seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -386,7 +348,19 @@ xfs_map_blocks(
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_convert_blocks(wpc, ip, whichfork, offset);
+	/*
+	 * Convert a dellalloc extent to a real one. The current page is held
+	 * locked so nothing could have removed the block backing offset_fsb,
+	 * although it could have moved from the COW to the data fork by another
+	 * thread.
+	 */
+	if (whichfork == XFS_COW_FORK)
+		seq = &XFS_WPC(wpc)->cow_seq;
+	else
+		seq = &XFS_WPC(wpc)->data_seq;
+
+	error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
+				&wpc->iomap, seq);
 	if (error) {
 		/*
 		 * If we failed to find the extent in the COW fork we might have
-- 
2.39.3

