Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C362176AB9;
	Mon, 17 Jun 2024 23:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665449; cv=fail; b=DG3Ucs+yturexQ2QBXBhJJ3jBATrm1FO6DitAvKOuFt2qNNqAvSsW5TBWuSGti+zJaaprqDU90ezXHBf4ib4QXEyyV89FXK+s4/vvAmIco7FE8cZwsbDyDpPlZF7KNGdEHlxS7J7O/GcCgJzLSbQ4n7gUZS4iZRWSE8JqUFDYn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665449; c=relaxed/simple;
	bh=Is5bJ7ZtIx5oMZcZcNOrZeYFCePaUIkFRaapgO+b/0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i0lxFJeBtRsqrYT+ldGT0hhPzELPGsRhPTN905tv2tOBmzLjTnw5/ZgfrKwkxmzpT8VJyar+k0JhN9oEdHanMPG8GuSUGpbFVu8a2H1CxgE23NijRrn/we1c2plt320IyIa8wQsq1ycYVl08uF6rvI2qWF+mxMbiq/wq8qXcBBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EjUcdCMh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ha8SRBIg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EjUcdCMh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ha8SRBIg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXiXn030327;
	Mon, 17 Jun 2024 23:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=tNQjQr8KWuQ1YZpEYgOpt/sjclv3MX/ZA7bZQtDjDYI=; b=
	EjUcdCMhP+aLwpCdWoZXTp/rg4V6X+YKJLrNeC7u97zdmxbS7iVEgE1GsBxUhLu+
	P/kk+XGIV4quAI+g0jCquvvu8tdzlxRoaUJC5PUKwOtoEjT6u3PgJIBwyFCjYRcd
	ejYvo6ePFaKPIGpUbaNfOJYtwZW3Me5J+KBkLrQEXPJIjNRH9yk1+HYfh8zzQwWw
	JfMGd11d3urY1wQfNokqgAZOl8mPRS9sKymFHEZREFyzoujr1CcdklkEZ0Vi6DDX
	lEOqmHTTlSgETro16IS5mWL96x2HNJ7HPXW0FW8qlxeZIrHnPkt0wJIVPxMcTmfa
	hATtcsT3gxE6geEUatwRXg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1vebt93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HM0rAt029434;
	Mon, 17 Jun 2024 23:04:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d77xnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjaa/vqp1tlTyMGaj8k9ZpiRPxjwgp6OpF2qGfDX7kZcL83akfXh0WvpFr+QvUKG7i57HsLlnGxjNChs4GA76eRxCs6vtc2P7smCHhSmDHWg/svXz7s0Sro+KriFM3/27WlIOAue7He0oVKjioo4LGfQNE0bA0Q+uHyLdzwvsLKwD6i1wTEcTruXQv12jj2d1DT36DiuXocJfnfnXXykNvzxIGT38DefNrEqsIGhWauRbQ7MMxQfqhp7yR90UQh0ZvSyHycEGILFMuAgzawqF78xbZeth7Weq/KYRQtkMp/inNubT2qdYtOR1vZieDowXQMh76sEUdTqhzmd4zsXhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNQjQr8KWuQ1YZpEYgOpt/sjclv3MX/ZA7bZQtDjDYI=;
 b=XccpfTZtzNDMS/8KnR/66QHZdAb0TF1OFNJYp6TiOuHwOjkCKWvsjleNKTls0oG+2Jn6IwXtnRbe4SoJ7fZqr7AAzLlGfr6jwi49d1IoLD+7BapUcptotuYgUjXfcwSD1v8qMUTiQlP9pkK2V/gCRG2u0lKjnUea+KOQ4vvgPKIsfyiulfd08tyICsxAwXHMv1gJXDmApOQqTWpipwkK7Nql73ECa3NduIvGnbArRseo7bqG6BzvpBXWUAq6ifcQQ4ejPDQjygmRr0xLeSFqaY2bVi+FtY62aYhkT7XTTC9UiF+dOCHifCCAV159TzhcyKabsnXjt+qybn2/H3MsSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNQjQr8KWuQ1YZpEYgOpt/sjclv3MX/ZA7bZQtDjDYI=;
 b=ha8SRBIgrVq23Vf3JvNco1wAfZ5XXgiNNPshLHf4VNcm1erMKhcgttagnC9lm1oDj+L2NwLV1CCI7qtGcbXbd7xo3x5qg3Ip55+3TKOmFmrpA9hg8y3mImvrRcahbNzOXHpcW9DWGFSOodoKKr4jZVSqLrJUIuW7EeYEIXw0JJk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:04:04 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:04:03 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 3/8] xfs: fix SEEK_HOLE/DATA for regions with active COW extents
Date: Mon, 17 Jun 2024 16:03:50 -0700
Message-Id: <20240617230355.77091-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0356.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d130138-1cae-4b79-5cd2-08dc8f21c864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?g28a7K5JOBOSaVnkDJrLmFBPP61p0WKkeej+Zx6DS5nTicwyb45eD+fXidm7?=
 =?us-ascii?Q?Qu6Wa7PNMnSdAmJiBLEEkxLA3Hkx+RcVLVOg1Br7xC4pqEGVdnO6owci3Hns?=
 =?us-ascii?Q?4EzfYH+WYplL1QG9lwb8bsCw9qJDdJiX4FrYRk8c3QnNKZPlGo9httt4A8TW?=
 =?us-ascii?Q?GdaRd1NnajGPVpliJJavv2YcP1Z45qcRPH284LzHTEIoSuerF1Vdr7dH9v2x?=
 =?us-ascii?Q?a4VIvSwOYbIrNkd1hJ0jMh9i3FUf/2wUg7FVr8c/xXwZ1RD23dP0bdo0goSS?=
 =?us-ascii?Q?+wVpaqwhvI0sJdvia0yGF43fJ+cAlOQgDEvKfFqmqi4MTEtRcCisK4QYxJZx?=
 =?us-ascii?Q?AWNy6DRQBaREIG767JIAu8qq8bV3kELnV5aZw6su17UNkOCBpG/suR1HIreA?=
 =?us-ascii?Q?obJTYK6rH5EG8gtQRLpY2fBepH7u/JK0TUYcWSl+qlzQg0d3lyqXSCmLiw9g?=
 =?us-ascii?Q?OjwAfBvnlwjbrXM6xbi6OohQbX/g57DdHtF2Xwy07GPY6qNJ2eymJG13q56C?=
 =?us-ascii?Q?rvUoknGok2nRMwzHk2DNy69halizKfH8DYZ0YIfP+qHF37ivhaZVLqjdNgvJ?=
 =?us-ascii?Q?MkQOkEgQI35FXPFvWNtXIB0/92PQq9pkEL4rjim6xDSXDxaDGA10sPrySpiC?=
 =?us-ascii?Q?OTAsT6W5rh3ziXAqZY1r8zfPiluZwJOex3Oq/a5XvyuwCEEAWiIvEK53GuWU?=
 =?us-ascii?Q?q8FD01Rv/P5OTnCd6X3H/EzwpVMQLGUSEZMJNK0N2eWDgvjttVjJZw5HRZqh?=
 =?us-ascii?Q?HdJGg/RKLi8iSmMpP4Zd1i8SGhsu7J1aLt2Q9H5QJPwR4KH9hYicLNxaSgo9?=
 =?us-ascii?Q?4cmEK2r63Cj109mZyndrQ3ILm5bRWm1Q+B0Y/KoVPMNcERtgf96nDvOBA+El?=
 =?us-ascii?Q?cwfN3JE3LCZp/MfhEKyeyOQJOFekVKj9n9an/9ly2H+xCN5/q+MDXmcBtKUQ?=
 =?us-ascii?Q?jLq4oWY+OGu4yKiqORw0vgIpw5lyDxtF/d5YbOyZIBl9rM1cDA0NAOV9Hqxr?=
 =?us-ascii?Q?NJyotO17iKupAfs/sJi092kzYwyOqX9M1dEDVR0XmK5xhzGqMdQk23mFm1WC?=
 =?us-ascii?Q?S3DjDCau8nOmYenMmdW7Vizgpn8QKwx3+ezmck8MXD6hfKN5tjUh+AlOUrgI?=
 =?us-ascii?Q?vvwu2qx8xO6hzHX2AuzVk8B6LpmpUGDDeqUgtr+c5Gq7EYV6w4UmbxzxTZAU?=
 =?us-ascii?Q?AeYi13VxKtn+GtPh/P9bONp9dpqpFsy6NEOZ1kxbCqOn8Xc1cmyG6/8iQGI9?=
 =?us-ascii?Q?Rc/TKYZYw8OKJjaptRrY?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+2KTy6ZVpjQFmhHlE7KAfdUs6sqBi5D26XcOFLupt3DWLqvXBUnsPO9LRq9Y?=
 =?us-ascii?Q?gU5LBJLcq3cAF24GHINPdkcm9RpOBJw84XoH9j1pZFFT2tOt3pCrWmAgNMLp?=
 =?us-ascii?Q?bAWPGGhU6fvLMLhERzgAHDsMKD4+DQF+EP2tAOyFBJwcnWKhuie2ILOwvzbl?=
 =?us-ascii?Q?M8jj8iAneuLC8eZRO4KyyXPe1OrAFjoAwdEGHz0EJh9+xuw2Y7CcjuZtNKoV?=
 =?us-ascii?Q?9PmYckIB6XJmmLcKcgXdqQndQnK2XduyNVmkLZYtU1c87jikTeE9Yc070mG+?=
 =?us-ascii?Q?8IBOX9UzRUCQX3mFij1rqOFT/xQqfaJVSLEaDP9lZuhjqOEst6kKb4LAsIj7?=
 =?us-ascii?Q?HfVut3uIBrBjdYdpPJJdvD1Sq2Qu7GTaIdzJb0ZOmt+zJHQ/RVJMujp/iAII?=
 =?us-ascii?Q?LSzND4QrY/9X7LMonK/LsDUHDjtEGciGG3hryFN4fqf+fiQ6XyQRZPkBpktn?=
 =?us-ascii?Q?fDMeNigGG2CY5S6w8P++0ss8pi41mRPdt9uFbVk1sOu9TCf3rxAxnS1OzQun?=
 =?us-ascii?Q?pSNfvbA2j1zidnXyK78PVvubi6lKBYKb/L82Ec2+GZJWiWUGhoyQvcfTYFhs?=
 =?us-ascii?Q?CKXu6WsjOFHk5lO+0La1KQsPJChdRWGvlBURgcR6ubdKwy7gugn6i3hcEWFX?=
 =?us-ascii?Q?wTwIkDosxm2UGK4SvuaEMDBxj1qWVmZJzmuFz7USAa6NLkjdsoDzcpIFo1o2?=
 =?us-ascii?Q?OP5eb9v/sd1uQ1/I7xfWbHG7O5IRxH0MjoqXp5x18sQlYib9rIz9Rs8Ei1Wg?=
 =?us-ascii?Q?vbrNKaDZrcw2Rsm1TM/Jts3zVB0ApgrLAWrHFQwgDyCjDp2qIGPQjbU+NtGU?=
 =?us-ascii?Q?6Ldwd5U7iUzF21z6vv/OOU0cxKMjoo75pMcUGF3r2ue0tKL4kYF9i6Cml+fQ?=
 =?us-ascii?Q?uUSX9Yn57Od3EWWRl0etnm9Bth54Uj06Ov3F8PJ7ACiIYVVvIe9tl6ZCNXkJ?=
 =?us-ascii?Q?u3Fh9XebxaLeEcE90MFBle5oVWYDC0qE+H9p+NAlpYssW70pdZaBWJi8Yfnn?=
 =?us-ascii?Q?Xp7UyDxxtKmJ4gk6HD40CyJbiWpHp51FmH6g27/ffcyLjik56S2lXKXxhana?=
 =?us-ascii?Q?ySjPqT+KAWuui1E5IYYybIq+yrf3EH4Uu8DfRBBOFz2KYHe4+NNlmzSEcfvr?=
 =?us-ascii?Q?xffZgJrt3og3i2F/RttwtGO6AiaExjFSnVXl7bAPpxucYWvqeu41+Zp0hud3?=
 =?us-ascii?Q?+5cnsWMkAJpal61lwQFO8o8o0sqOROUw5CaGjJMkeYWI/VhhcRAqufFRRAPz?=
 =?us-ascii?Q?mJpA+DHwKQoX6C9OUhSfq9D2HInHZ/6HCz/ZuflIFvnx0lgcQfdWI+Zawxz8?=
 =?us-ascii?Q?tfhMD5BJGFMVxwtIZ1uLFEvK09av5kvktrKgVsL03J/p19r9ikGyAe6GK8Cf?=
 =?us-ascii?Q?PaRhB9ZnSXH+GzBqKWLpmRRqqZbrxgssmqJNTfjgkWL+aV/cDLsQc/D/HaMe?=
 =?us-ascii?Q?74rflvmMqO6ImjMdBl6C660M0arA1NQGLCsCRObywDkKrdHxSBV1BEHYPSet?=
 =?us-ascii?Q?8MOwc4cp8D6VRaFcwgH7GPTdbopV9Wak80AEPdFTYI2Y14NL8kjo8XuZO4v9?=
 =?us-ascii?Q?CRFi6XWa17CDNNC283Xltdzl0qDCPiKmOdYvFhcUhN/Kovt5tSXkwvlQZ2ca?=
 =?us-ascii?Q?el2vhvtJ0cGSrrxuzAKpwfm/c4nt8s6WfAsguKo7MVvJRFJpg6xbGQ32ejDj?=
 =?us-ascii?Q?H51CkQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	f8LOPMu3BEybCQAMgeJ9wsHWd1XObGe3jCiRwHozRGoKR52eqq0j6NQPyS6+LeQEdxVQhO2ZYCnjUZWeKrJd6g/x8Pl6s3/L87d8o/dVtDTezHX6Ml5+mK4sqiowdwJmFuUZryg5erqTJfe/bERYnbo5IqWVeGLxglJc9elMulLBAlWPzHX3yAGOfM5uRMbw+uVaVxp9RSpzaAdQkjDhht1ZS5qCeoA5KG2XeiYBRIvLggqdbbtktZ3yU+vUg3iZDYrgItZRWjQwnJ4uQVEUDPquZa8mqJbO+UTzS48zfjd88huBRfTLuTuI0a5+fm4aUgMn1LV2LDYkZgfXYnRwgzaE2TDs6pac+ELog1U548Z8WXcfx8pzX19T1iJC3mSvey9zhI7OJn0qlbGvnxWYFXIjuWAjHxlY3Qv7AmUG91HNYSZ+97UujE/PLUv5ZIZJqQTLsD+OS5jYp1v355jOMq+C4shnJ1lJJEX4ql7zJGXX9XExFitLw/CUki09kfiHH/pLe8lM6DES2sBc3uSxqk5DO8VA4Dcr0/UZTIHV9nNlQZ4Hn4fQ3l2qQrmlI3LcSERgXJKPDrUZIelbfxnikhOysHzozcqM6CRkuYFOq2Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d130138-1cae-4b79-5cd2-08dc8f21c864
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:04:03.9358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NeEUby1xP39C5zcRVBG8Vx7ayB3fbTT67JXkQnrjo29/NcfMdUBCwdMIyR3AxcWPGa2TApAgFdrrJiwfy0X2yEq6khp1HFxMImLsn4Bxdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406170179
X-Proofpoint-ORIG-GUID: WhRX8xzvVVmQ_ydFcFqdWj6CH0Z0BDQo
X-Proofpoint-GUID: WhRX8xzvVVmQ_ydFcFqdWj6CH0Z0BDQo

From: Dave Chinner <dchinner@redhat.com>

commit 4b2f459d86252619448455013f581836c8b1b7da upstream.

A data corruption problem was reported by CoreOS image builders
when using reflink based disk image copies and then converting
them to qcow2 images. The converted images failed the conversion
verification step, and it was isolated down to the fact that
qemu-img uses SEEK_HOLE/SEEK_DATA to find the data it is supposed to
copy.

The reproducer allowed me to isolate the issue down to a region of
the file that had overlapping data and COW fork extents, and the
problem was that the COW fork extent was being reported in it's
entirity by xfs_seek_iomap_begin() and so skipping over the real
data fork extents in that range.

This was somewhat hidden by the fact that 'xfs_bmap -vvp' reported
all the extents correctly, and reading the file completely (i.e. not
using seek to skip holes) would map the file correctly and all the
correct data extents are read. Hence the problem is isolated to just
the xfs_seek_iomap_begin() implementation.

Instrumentation with trace_printk made the problem obvious: we are
passing the wrong length to xfs_trim_extent() in
xfs_seek_iomap_begin(). We are passing the end_fsb, not the
maximum length of the extent we want to trim the map too. Hence the
COW extent map never gets trimmed to the start of the next data fork
extent, and so the seek code treats the entire COW fork extent as
unwritten and skips entirely over the data fork extents in that
range.

Link: https://github.com/coreos/coreos-assembler/issues/3728
Fixes: 60271ab79d40 ("xfs: fix SEEK_DATA for speculative COW fork preallocation")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b153..055cdec2e9ad 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1323,7 +1323,7 @@ xfs_seek_iomap_begin(
 	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
 		if (data_fsb < cow_fsb + cmap.br_blockcount)
 			end_fsb = min(end_fsb, data_fsb);
-		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
+		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 				IOMAP_F_SHARED, seq);
@@ -1348,7 +1348,7 @@ xfs_seek_iomap_begin(
 	imap.br_state = XFS_EXT_NORM;
 done:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_trim_extent(&imap, offset_fsb, end_fsb);
+	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
 	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
-- 
2.39.3

