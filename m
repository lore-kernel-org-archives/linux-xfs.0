Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299E61FBCB5;
	Wed, 18 Dec 2024 19:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549470; cv=fail; b=AeoDVKsQbQJeHeSxPIULNpXnCaRxHFvbRKyDw6vd/97KQAhlvKuSNR+xUBwksmHxJMLlQjZscDlVDIpCqA+bD/pckE/DscIDZcunR3Df0BP92N4TZOR5ZPdPA91WXJnquMW2C/cRuFHgSS7ezJY0KO7FRF2TpKK13WmTxQGaF98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549470; c=relaxed/simple;
	bh=Fg+JlYpAqOiJHXu1oMI+jVXa1h+KpKg0jyIGpaokL2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c3hOmwLtpY66vssS5naiRkQ1sImQa+wvMN5RDSoDa37KNHOt1XO4JTnUGAXKwx2zQzSsotkQ45xbh9OdOiOWXWInXl+/xldvEl8wChjUC626XB2XNWl7n1MtkRP0FHNIJEbhrBd/G5//6ICcq6IUchmPMRGsNfwpEFLtgVRO1FY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TZW+cE1j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KM4T1Tl0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TZW+cE1j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KM4T1Tl0"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQc0M029546;
	Wed, 18 Dec 2024 19:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=f+9HP2HdKdvJC+P5RzVn93Ab04XUI3EqmNo0GNsVans=; b=
	TZW+cE1jlFwt04kMXUKd5ckdgVUY/44GOKY59fP8seEK8huc4C52Z+Tg7si7s78J
	mCpnCDVeJr5AKAiV+P0d4t/mJV40OngnwzNKT823R+12J9XTrUd9vcfRRY7KW4aQ
	OuxomMZGTlBVvFR7QOrOe0PT/zXg5LSIqkWV1VpZgLiuROCGqu6lBJY6ZvLasqVp
	Ta0bsuwNfPME4jTajAIFr4vlwlMn1lLWUFAwyzQHZfYNW8+j2UZ8VljaIu1q+4i+
	NUnCJsHg22R6i5+pqaltQiS3eN/ZQ8kcXDWQLyJ4tbaz9KNFxuGBrDp6PA6e+++y
	tC6hoayRF7BZxI0fHXnNNQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t2hcr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIIUIXj035296;
	Wed, 18 Dec 2024 19:17:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa8geb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RwZbMtcVt5zscEZfCk8KYtXNiJxYFxg8opUF8M6ag93a2uVFyw/5U3KPkZPLpZ26ww+zsYRa7yPU9h3s6HlDKvdl79ks+oOpGNrcCqT9qwVF2wMIcfdd+hbJFNk0CTm3jcujTDfvcqavNYvOZtGiC1IkRlIAk7m2uwbBHC19B7SbeC0Z82ts87TChwmzAGml7d403j18c8WOeBVT70clDirgt/WXc2am57hUZrivKh0YL/QAJ+NODfNJdEVs5G0nCYG5ImYZ8sYSFyV1aNWDE/4F2Eh/3mEm0h9Rv1RnyJcPavJv6yT2j29bZpOry4MncWIbQWYrCB2jjDWmcqMemg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+9HP2HdKdvJC+P5RzVn93Ab04XUI3EqmNo0GNsVans=;
 b=q60Of5eYRxKSWdpQZyJAB1ZvGRxF+TcJkH7PE5QAwPdiCDiugB1xzNVDjIUiUul9cUVFfX+dzoRps3XtJCu9MfTSjD3USsysZd5+Z1AkfexhAU2sSs+aeq9/0a56grk4L29QMuSnmRtdtWZdpeKYSlEyKGKWP/egWgm+0fwysvKQtWFbQvgcDtQvtifWxusnIQM9fl0cLXSASnjdIK2UWn7vuVslVaDVu3ZjHHPs480Jy7Hpd1g+nwj/EEmcnMdgScr04/oF8zQTrrQmb0gxLUhcerZmweQfkuhzCcT50se0cw6EZ+BPkQI7q9pkM45eKGT+dpXKyNZHGyUR/kjhYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+9HP2HdKdvJC+P5RzVn93Ab04XUI3EqmNo0GNsVans=;
 b=KM4T1Tl0LS+89g+J2L/IlD5l5MCCk/QtuveGkLl+cA/mbnKzZVL4edQg3XlnJnv+La8STuoKf0M2Dlago7ArlG14bWLKtDjTokV410ANQTFZu25gNm4LM623cPb6bamjpbEXLFnodaKuV27mycUsba+ENWJiLYtHeS/NtWDa7a8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:45 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 10/17] xfs: fix file_path handling in tracepoints
Date: Wed, 18 Dec 2024 11:17:18 -0800
Message-Id: <20241218191725.63098-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 485f2e31-c00a-4a01-ee27-08dd1f98a6d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xQFjSF0R9qsYIE9OLmlycomabNUUOROKqmQPzyjBSRslcvuZKT3YAntClLt2?=
 =?us-ascii?Q?oXM7svn+w0yoYwHl5yPb1H4rFiXffUhJhFpWzq3Qwn4w2hLkxhV1wuPLCcyd?=
 =?us-ascii?Q?RpJsvoqyMsF8OX2eRljUSXnlPpZdADJA6iwxVe/ALPPxd1Gcc+0Ut6f/mdvo?=
 =?us-ascii?Q?rB+mEbcN/Rsg6r9TUrDPQUL+PcS5iLlj6y22KasRT3hdjdHTZ7wlZWglL19A?=
 =?us-ascii?Q?BK+Ru14KDE7nVAdbMIQsoRg/COUQTLUdFgUBD4GHowzlyPBIAc6WQAcs6vFe?=
 =?us-ascii?Q?v9Ku2RbmkxwnzOImUPhKlJaGiF5AFjDwJih0vZV0pkpDHharZG7m/8XtxtJr?=
 =?us-ascii?Q?C4yPfHQu3aSthT6TPZIxqeMZy7+a7yCSyEAosjFE4cT9Wb1hQu8bfBzjVt1I?=
 =?us-ascii?Q?EZWy7Q9jwNc6Oxsl+AkMuaJWQBgnpWD2stFYY2MRqQiOM4Y8CvJv/AVMTVBF?=
 =?us-ascii?Q?No1cI+kA/HowRFaSFyvLex9HGXGPTLuKWXftfZGdaejYDwWZ3tdy2OJlzxAZ?=
 =?us-ascii?Q?0pluDePh9Tin93uJ3RBwWXi/YicfV8wwaYV9lVhBSa1xw4K2dTEyG4sZ2P8B?=
 =?us-ascii?Q?h4j866fXX/HUR8h5OmWE6x1rpC3FV7fgMkBhwJTLcK8BZxFJNuIkHczw3Ai3?=
 =?us-ascii?Q?dyU4nzUEhETUrki7LSQN+4KH2xwvAFwSJZxpioPTmxLLdRy2Q8dX4l5iKYvT?=
 =?us-ascii?Q?9pElfVwrvwpjU4CyRkfDf+o4EdZKLtpvo1XYrcxCksCom5pov9rqCOoWsCoq?=
 =?us-ascii?Q?8Wyn4yOS+tmk+rOslsLs2r4p40L/PdtJwP1WKjTTwH5Ooa4rtuIdZNaGEsAu?=
 =?us-ascii?Q?BSx4L3O25rLP3KonLnAgN3im5XHuW29Yn/pvqpY58YJXinrJPnMSNugvWkxP?=
 =?us-ascii?Q?R0HbG3JkAPrQxjtuWuD4x56UG3Gv7OEtFBEGTdx/jX1SlH9wZYisT4uQQ9eZ?=
 =?us-ascii?Q?tYVzmsprlsAGrwsQ+9by0YgdZlkjk7RbJhJGibQsVMqhtCW54E1V74EMEB1j?=
 =?us-ascii?Q?7LwV4v3gc4LTALbT0wczelhoWC4yenaZ5Z7c+ZcdAmaUAHqlZXjXVD4bmjZV?=
 =?us-ascii?Q?kFFMvt0aKZwk7NrDHM2UawEAN+TX5ws5wpq1gtBFyWpfsrJ8CdGIa72nphEn?=
 =?us-ascii?Q?LziSBBjtJpSulbyUGiY4Tlcl9Yryf/pCSP2Xuo7Yv57glUln7hHJ0HVpKe0m?=
 =?us-ascii?Q?CBP6CVBxDUxpKVf5G+gNb3D4J8W32nEg78CyeMh+alncjjkiCyHipjX1B731?=
 =?us-ascii?Q?5j1///uIAjyznHDjue05ZoWqAakGZfOTsVyg04OBia4gQlR5yVNWYmWkNK2N?=
 =?us-ascii?Q?zuZJyCX0PIR6yfdAVhbceji4ueM1iLmMkeU8/XqyN9QYQgcJAKBHT9mnrHlZ?=
 =?us-ascii?Q?c+/oAnvPsVhLmfBsU8+V6ateV4+g?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yRJWkUYCU5wk39lNUINB/um3fH2aV6XFOgy2vHZABTg3cN12WdtqQgSL8L3V?=
 =?us-ascii?Q?D464nXiEjS3iYcPKSYD82Iu3l6BMb/gYZihWjeoUK62VrjmEkmlRKhFRlUZ1?=
 =?us-ascii?Q?JEt/JDv7grvvNJvR5klhZOYD6vwsBjFugDjGC4KlaHOVv0grRioctprMGJwF?=
 =?us-ascii?Q?muWGOKLy4N2vWURwqeY0k+N8qIDO/pbP3xiSMF0J7m51yoeq9AQnefYawwFz?=
 =?us-ascii?Q?S/rnOy1gFvsEVj0ToxNgJZFFc7Rtmyxvu3nYvfK9taBAxk+QO90CSoXvsSI1?=
 =?us-ascii?Q?Y6wD9rT0t3A3Tt8USss3P9s1kpzrUFxzsBtx+pbPMLJ64VQxOpKfL9Wcy0uC?=
 =?us-ascii?Q?+wNN25KC2wpY80Dt3mram+Y02lG2mIOy8yYB4DEKJ/V2OS9zEYH5L539xeeY?=
 =?us-ascii?Q?HXhfgJ9QdnK+w6CvfeJ5FEP5ZVLdYqlj/X+xb+A3dy2EBtgkyEc5QkQjTE/g?=
 =?us-ascii?Q?IZPBFXcWJuAWb8vVJ09KGdw6wa+GVIlMry2IY8zRYZYE8K4NWLbBhUKQIof6?=
 =?us-ascii?Q?HWs5+JfzNb6sYInfrO42g2SA8TM/QC8xB6M5l/gXhNxiehL/WKpkBomEduZQ?=
 =?us-ascii?Q?M+nfmVIAHfgxeUm+ExRZRN1PFZM9RzwA20abGjZ0KxaiRpvzPtwDwfVouDsk?=
 =?us-ascii?Q?AOdc8FRxu71FlwtElF36hDDW6Ic155ngYrIz7TtwzC/da8G8cXxcBlGq14Tp?=
 =?us-ascii?Q?12d4znjyOPF6BFsUK3/KvKVYDT6uhYqPl/49NVw2GakdVasfUTquV9zjEU8F?=
 =?us-ascii?Q?PIXMsusrzdNFXvD6ivLVxS2fqZ/BpPYGUp4LWrzKzLppWIsysxwWUqnRn9AU?=
 =?us-ascii?Q?BXyCbuVrG8ik/fDe9OdsnsTfjtLML9j9FVwodvXL6IT43YFHoOq77qpQbNKn?=
 =?us-ascii?Q?q2Js7JuPhp1tzSdtTRbA03V2jm2ci6143igTjKLHtfQ/lMfXRkepwNIqPhmf?=
 =?us-ascii?Q?KOi0FnCxS7OVzijtemO5xGfesFVMGjjtRnrTQNEIJ2HBB9gDJ1pYqPsU/F4g?=
 =?us-ascii?Q?p+Ql0Ut+p6gcxwzmjUk/miu2rr92iVmwbUomDJqEu/e8uWOknnSuy9eL43X9?=
 =?us-ascii?Q?01l8FEN/e13CdVC1d2u3FAH06r6fgPyRWjq8R8yRq9ry3IZh3Lrtv4A4Vi7G?=
 =?us-ascii?Q?YxJl3KP54WyjJz2+Ym5oyF4ncj3g/XI2EM45kzY+uC2HqhfwdLjtUimMMrhl?=
 =?us-ascii?Q?rPzwIEzH+5pK7yKrdmOzP3g49lyQX+31AkZ+/NF/kUAL9nvjwHZLC9gdGlr2?=
 =?us-ascii?Q?CHlurWeykn3rVFoYIMoXx1esycryDIJdaZVPAytcr6zRiSzY2oMiQ/H9RpYb?=
 =?us-ascii?Q?6lYJDbcEqpvXcoChWXXuWcb5Ss0vsX70yJUU9Pl116TdZ4yF+KOwynPUPoQx?=
 =?us-ascii?Q?fV1TMKy4D4qTKXu3YNPvhNUUwmLlyp2+L/H9v7rDYfvZu5V8PpSp2vnOjzWA?=
 =?us-ascii?Q?m6D41lE7FpBTqIsjLiFKrEoAr0EBi9Yaaj74KgrE4D8u2DQA+HzXQmWMa3jc?=
 =?us-ascii?Q?7VJ2pTHt0TCbdrK0iPVV6p8OcK0ydD2j5aLJa6NZDIBjNRU9qeTbLc4hx8Pm?=
 =?us-ascii?Q?BCvxWJZYpy9hM/gfrH3UUYRoOPsSn1sXqFkSJ98gnoL/oDDY+OcBIlSMW8yR?=
 =?us-ascii?Q?5LxyK+8nd1ebbdaVfGykjhcFsNNLYOYZH1Stiq+4UwUwihNA5IS3vzoyApx8?=
 =?us-ascii?Q?L9yyqA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i484Pdb73+SOQjfJ4HDbmI/xTKvJq6Alinfsj0qW04sPCJNYh8PqskwFf4nxdQo1Igxq4PxNZm1pr5jDMXsiR+cYlFmmHxFIsqtbUrW/jt3crRHvtL6F2kyZIMECkYAPrAiv6pOTySZhvByE+Rj6tfmfKu/fhNf9xdKDSMF5Nkm6nZCvk92xUJUaUonNB7pKQ6zSOrNAyuNbRm3TqY6Q4CaEAXSZbGUqrWFLumfS/5lD/ZLBy/SHRSLU7Q6mKmEQjOcKWtpvH2J4+0+URXSiQkd1P9y8gJcKBq0T0GRxDIZGwbItj7fmoTJgitfOHf3XVGJ0l5DunQtsbTBi87077qc7YDl5g8sLgnG0Mmqso3D2+ecVzqM2xoxX1sC5Z8Mqsuzy+oJWU+rEPhvEwMcOm9FWdrtU0MxqIZxOT38dC0nsTJ3PjtlAe3/pYVYHeQRhq4d2IztyBnIgT7XzEm9gmwjO1cP/zpPuZso/vwlXwBC7F9znxfUIKZftOn/xb8nnwOXQyw3aE6KM8G8FNDet7bioFphwj218irerAQh7pnqRDE1x/QtWgxBJvWD9LWLLJ9EHwOTG088iFMQTcfWj8GhfkWKofi9fvbwRaD5WU0Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485f2e31-c00a-4a01-ee27-08dd1f98a6d2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:45.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOj924Ru72WR5CU5LTYxXCFG/ixDhdmOHN8RtrYxmCcBqX2ed/25CM2V1lZbY2itm+yqEY8E0OLCnl7KYYuBlAS8tN+G0cJBVYX319NIcCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-ORIG-GUID: pFFjEPuc-Z_QJM5y-xUgbYRKUAvEP1RL
X-Proofpoint-GUID: pFFjEPuc-Z_QJM5y-xUgbYRKUAvEP1RL

From: "Darrick J. Wong" <djwong@kernel.org>

commit 19ebc8f84ea12e18dd6c8d3ecaf87bcf4666eee1 upstream.

[backport: only apply fix for 3934e8ebb7cc6]

Since file_path() takes the output buffer as one of its arguments, we
might as well have it format directly into the tracepoint's char array
instead of wasting stack space.

Fixes: 3934e8ebb7cc6 ("xfs: create a big array data structure")
Fixes: 5076a6040ca16 ("xfs: support in-memory buffer cache targets")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290419.HPcyvqZu-lkp@intel.com/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index df49ca2e8c23..0497a2d681e5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -784,18 +784,16 @@ TRACE_EVENT(xfile_create,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long, ino)
-		__array(char, pathname, 256)
+		__array(char, pathname, MAXNAMELEN)
 	),
 	TP_fast_assign(
-		char		pathname[257];
 		char		*path;
 
 		__entry->ino = file_inode(xf->file)->i_ino;
-		memset(pathname, 0, sizeof(pathname));
-		path = file_path(xf->file, pathname, sizeof(pathname) - 1);
+		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
 		if (IS_ERR(path))
-			path = "(unknown)";
-		strncpy(__entry->pathname, path, sizeof(__entry->pathname));
+			strncpy(__entry->pathname, "(unknown)",
+					sizeof(__entry->pathname));
 	),
 	TP_printk("xfino 0x%lx path '%s'",
 		  __entry->ino,
-- 
2.39.3

