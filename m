Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F392158D7B
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657141; cv=fail; b=dRdQPe0p7cGDKKri67OL4oX9NjldLke2GZkZlOo/kcgYJsu6A84bQaMq7ME+cfTpv0q9mNX1VRvVSEJlkixVL/zWMKAD3CE6a0WhqEp4e2Dxxhea7vmf6YNXAf+Z//DpFWM/tKDC4rhso/tJ6e7rfB+EUuym7GE2NxzLz/SNmDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657141; c=relaxed/simple;
	bh=Zt3oJ/twGwGOQRVa/bsuq4wiLF2dlb18fQvxRTuynBQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZW6kaMNez6C9sxesV1IOmloo3tJGNJI7+iE3XNSKdmRUHphfVXa4OI/6WrPiKRrmlC6MfgkT9jldI8ScX5BZP3DR6L7fVtkcVFnJ/pZKkdTNrfmkuS6fv4oKxEdTqH5cyj6sAYC94Z/xqldwdMjkzD9FIHBzLOa1k+E269emSGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BXxAd8Ja; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sG2QqdWe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BXxAd8Ja";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sG2QqdWe"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXUDR024509
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=BQgt7dGNuqV73VqoKy2M+ySGGJZUx/rhgtelARpS6sk=; b=
	BXxAd8Ja9GuciJNMUMSDijG1bfMJF2OwOu9n8OZiknUGOAsVJ/vuasqeFo43ALHg
	tifEEvEce9buu0KpiK6jhb3KZRY/thkXUfktFI4m2LhO7k6nO8tQfCLy1VcbfSid
	hog604e3OVtawzogC6nwdEk7UHzkf3Py+VoICBhSJZmgx5+ardHu2Y1Q1BNGc5B9
	gaiPTiHOOrSa5nk62pozLxnJ2WAok5CRuCtcdjAJXsRH1wUhZBJTc5hMK+Aphphj
	o7gPsOQwfYFKJP4P3msQMHM759Ck/ViTkz+sLWC0CtGz/fo3+ZOYs7+HEYlBoTyF
	RTrffvH01wpUxrrMyNGUuA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486KC9Q7006639
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhydejb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cLl8z7QByydPMgYGxY2NS0G8J40I2tb5leuwgX6rwWpGWWuBYTcGHDNfkART49D52dPLdrTkoSj6zm/qxT+hyLbSZhZBUBreIgPpDutBka/A6NLUHr7TWVC6beEPzOSWpQwNSb99Phuk+/rC21e6LFoutnkBJSIAzZ99xpmYXKpVXU1C3nE5luKVr/JFI9QzF++GxzTPTFjmuuVZmV+y2QWyHRxelxGrToye33CZIkEREncc9nwjltg1LiLfVMgdeZVrMuNXVe8iloUIgb5LrtsJXbEr68N8iCyP1vJvFiTmRgJlEyFjWXlgpAAy/EW0ixiuyRzEGtWvRk8hgetxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQgt7dGNuqV73VqoKy2M+ySGGJZUx/rhgtelARpS6sk=;
 b=ZAskOWJNVleRNeCYBooajBwfusVaCp7Fe9wi9GW5EggRxGqnqTG9rQpNxzLH3kVNnwVmLL5na5AM3ayFmlYhyDQQru8th3Gkv9hXXLg53syYhaDmr0++LKq1L2Ftx0lMdctrIz7FXAIipKn8373yg6SnLIlPypOoAaQxAGDETY0DiYwrwqNVd9KBGZmbMFPX+Xih97PoNX7mu8i4T35INoIYIdVn7KBV9wKv+MU9ZOSRVAn8cLv55dH8+3I6pQDNKbEbX9voJf+TzBr1ZUP3qNTS/zvjxSm8FSJAzTgiKRdLrCgZrPET3hyW3Ai5kQ7Jf1JLhjF7womOmgxklGY4FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQgt7dGNuqV73VqoKy2M+ySGGJZUx/rhgtelARpS6sk=;
 b=sG2QqdWeTbqPXeWOiSyuPWTfI1jePnFUAoy+UgR670BZgqDsjtpPT/2Ru78ye4kyW2xURDmGyN3Rp4mfr/Vs18F+aOH9361k85u9rjIa8Ina1DQ8bmMg1npzLy7WeA84/00Vi6QeQc3Ir6TJSlUXdGKiEDCNVjCyxwFhwU9+4tw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:15 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:15 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 17/22] xfs: allow symlinks with short remote targets
Date: Fri,  6 Sep 2024 14:11:31 -0700
Message-Id: <20240906211136.70391-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b43e736-0a1f-44e1-26e4-08dcceb894fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wd71DwiqmMhqB6YIQ5nD59RCzarfmh5a/QhOfN7QxX4zWeEvBhlHznhtzIvM?=
 =?us-ascii?Q?Qf6f1OS+vITnPp6b7ycQ5WJ8anTYG7SslT2ldQWqdmns6mYO3TGj+nrBwIjM?=
 =?us-ascii?Q?5aWJuqNtZ7BNX5s/6ea9R7+xB/Xny+OhbOA4a206I1fAksWIjaTPLAqcp3wF?=
 =?us-ascii?Q?rcyNHXFvseJX1fLn7IEiff3O7HYwxQLgMHA+6fwqFhg0+lOLDlk/3pAbSl8y?=
 =?us-ascii?Q?DZmP8d40rnniUP4bcwHKbK32SY7CLoIZ6mDcypnAjky3n0J1iropNDej8ylT?=
 =?us-ascii?Q?sKgtnzUiSD+/4lGu+NTw311iZfUmQo0BNGsgL+Gu91uuCUctM7kxseoGLiSC?=
 =?us-ascii?Q?aV3wQkiuLHKcbZ5uYC37krox5P1mtl/vfjfJgirSPfWv1BqopiMdXQAue99F?=
 =?us-ascii?Q?Hwm+UQpmEX68J+780ihqafAXYTOS1EP1Oa1H3XaX+JyfzO4TWhUVGVIHyR0l?=
 =?us-ascii?Q?mZ6GGuzHUIFFnX4OHnhn9FJLlvgx/7+jYwN5MYK9EmRJJ+COZEtBp7ubt9gg?=
 =?us-ascii?Q?4l9bbGUL6XmG5gowqLYqUpdGsQAGDi9SY9Q/girLJuaurq42TOXSFfUfe8Mb?=
 =?us-ascii?Q?dJH6EaTlyh26yIqibuS/FF0aWU3m/Hj0pRB1uhNEUA2GdNgQol6ZGfXP0m1C?=
 =?us-ascii?Q?Muat9YdMq6SZ6LhZChfd3uCmm+4Zkaduwd5PzO8DMfd1ea8sEyOzhAyaZgCI?=
 =?us-ascii?Q?BqGwRVUGU97MVNwgR5sdhPTwiI8T4WMkRRV53vxUJ+reJ/otBXyWesGBZv0L?=
 =?us-ascii?Q?0mVROacSuSwc7r+sfDE75BCFC3DOorWEaOIsTqFFhlQLZtPg5v5UG5kmjUd2?=
 =?us-ascii?Q?2xyMvh6XHt1wrDcFzZS5CkBCW/NMu+94ly2N3e3sgjc+lb7GZwGNsvtUCYA0?=
 =?us-ascii?Q?h00GCFITMzFwPJRM3sO0+WD3WUPtquq5/YZOyF0GauPeryrbF17ok5AbWqnR?=
 =?us-ascii?Q?ybiSUUj1dG9ThT/D3zQIqwi2d5vTaY0+JaBspi6I2+ftO0VYgWUpvf0WYL5t?=
 =?us-ascii?Q?2caprht1Xi6VFdd6r8cEKMk8rExGxLGV3M0PPKMP/k2fCF3Wxb/w0ZC9HHql?=
 =?us-ascii?Q?9+j2N7wEV/d31LRZFAHDGt0spDjleruLgmRHz6qGLo0ejDf/JDRCEtok2ytG?=
 =?us-ascii?Q?HQYy7BLD8V/xCOX+SRR/28BYX3ee7Bj23FWS3dtstlaYUejADjlReGoEvIIQ?=
 =?us-ascii?Q?moxe3YYk+vzfpAnQF/DIdIwFDfetRB61XzcloybDvDLeTUmhNf2BZcJsT72Y?=
 =?us-ascii?Q?3Sx6MuQeJ03ks8CvMnh1v9O5pyx0/ADC3SWXRxxcElUbCJDBwLF5gUBmxfiy?=
 =?us-ascii?Q?VU+RiuSUQmnNl7tJN6UUIkPjl4ljuAUThXLYIHa69YGsiw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jQwjBs1BzWlnfTUXmfQKLWtZ9fStTAtDFsq765MXOW8Ob3EZ4r54BUAvWtfG?=
 =?us-ascii?Q?EOR4HmT7loS+JR4y4I0UNlICrMuG+2qaOqD41EVncfxL1mmbKP42GY8SouyV?=
 =?us-ascii?Q?4t5K/ulhCtxMYNYAr1KBZ3+TPhw9iK5hX9mA9Ju0Uj0Zqah6g+ZiVO362iRi?=
 =?us-ascii?Q?4bLOuwDY4EidYVPCCugtRVrLfvhijBcFDPTBEP9rzOsC82xKSAcR+r+LxvHo?=
 =?us-ascii?Q?zFhrSKTsUutJYHuv7bTI9IurwWTYQY+UbHDBy6ybvU7i9S/PH4vraaSsqytE?=
 =?us-ascii?Q?JnVe6I6J0Wa8UPb/U8aewZ11jJE0KKUrCjCEMt4zZ/uF+VtDgIfimqqX2EJg?=
 =?us-ascii?Q?cNNUd5ESRRKTGyfGOXmEe4KzS6PWom5/I+OO+IjYBZXW313kk05UrOa5dIyy?=
 =?us-ascii?Q?urR0WTtSgt5IpK5V4sQnelrrL0EGl8BPT0UUIh7yFWK2uuoC0h9qgJe7zbnE?=
 =?us-ascii?Q?lQyXGvvxnZQQ1nIMfpnmeso51O1FylDzw6zqU9qL5Vj0X6frHGEi92Jkj/NU?=
 =?us-ascii?Q?BZnKWwnWe2mgTGl1xIDWZaZrDTNLEIN0qLUCKTY9T3xWS8kTxHx7omR0DvUh?=
 =?us-ascii?Q?aPhGAkjrsPKkNr9mVeLCfhmKLAOCVHHTCWeQWmZB1fywHmvhaNZA9QaWuTB2?=
 =?us-ascii?Q?5fB/eVCbdzDeKJbjxBHY+LQmZAG51sjgz2BO1iIZ1h2/GxQYJpRImh5LC5x9?=
 =?us-ascii?Q?L6I3oqKHU+IKjs2pZBFQHzscdxmLs7a6c79RKQQ+2XfhWxLsL+s4DAIF/Ehj?=
 =?us-ascii?Q?Uauek8DUOsUMpqFeGQ+E465sqJn0nN0vs18ovauSk2iabGn1NcM2vtFSaQmk?=
 =?us-ascii?Q?CQj5QCn1s9Y+GQr07Xo5SEknHPHc4CuU17+g0EV2giDXf97GuOrZY1NhwiM6?=
 =?us-ascii?Q?I3oHSopW1By+76p41/74hF5Ck3Jq47iJJeueOwPL2oAEzXvQ6X5a+s6PmHDj?=
 =?us-ascii?Q?4/vma+JD7O/BhvMXHnLUHJ3P6SYUkbY7Zq64HeZL8lcEEadXFiWxib2MZJVJ?=
 =?us-ascii?Q?f3anGebcXFM1d7EaT+0TE5mTFsA3IPu+qkix1a1IM5gNGXX/ql4xrlzeFNtV?=
 =?us-ascii?Q?vmrgzCJwTOLMXxcUmVumN1pDOrCgrZDGTJl22qPLtxk5Xw42KhT8wPebkOEQ?=
 =?us-ascii?Q?DzUBVCKAKCJXLN2Hc25D9DK0qvTnqtsWDJWmzZNBRQh+8QNvhmGEiOWZ98qY?=
 =?us-ascii?Q?uqKVndw6ADNJ2TXdMFkVI/0GaOMkVZlnOlurJQajGzHqfp2QENbhuVRYJb6p?=
 =?us-ascii?Q?+ocPYCO3axZwpc6mWVCldUYaTR/HJFVCfulq7OLc/CxSpl3JmJNLHXkysjPY?=
 =?us-ascii?Q?VHrSOVfEQt8biOstjZVw6MqpdZO4bbEfTBo6DgodTu4mQqq7c6R5+WZQ1Ct6?=
 =?us-ascii?Q?hD2D9BgkINzywenV7lpt6BgZD0N7ZOjxTe4pU1/zv/suh0UEuuY+C89SiBlP?=
 =?us-ascii?Q?eCP7Va5mlniBRb9PASEkDqhl+1n2iedS2c4lYizGpTvMlv0U0JerfWzt8Fra?=
 =?us-ascii?Q?pYfHcMqCIay5Z9LJZW0fW1S2k8EJGNuiPWWCUFP2RY9FMTyMaJWavFydEJdo?=
 =?us-ascii?Q?faesq9Ukrx3mkyoKWSH4YYnkCaEBCfu9Lx2TAhj4bczIFyfXblXMvkz5ubz3?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k9lHMjqvd2ouTK1kgbVzUPBq7ZQmMszNBXsZ6BkbJEVftnlUt9/gEDPLTs0T7hqDH/98FZ/DVUlr5mDBy+M5GP36MDmiBIXZ837R5hfH1y+chw5ojGcMZIXE0iur9US6QfH9CTycO9D45px2M+oAt2A1+5/nQQdH3wxWaPUHe+VUJr5xwmgCY+u73jN31JjWYoTXelz/XH12B1BqnVgGtA6hsgeVSCgXOX7+KI4HIjcmpHNfI/6dJ2hhtAFW5UW0kznqgHe2qfSE4Vcafl9TsYNpayhdI75BNUot4aB7ghoU/tevS8ZRMcxWofjKj4w8EHcAC5gnAbSzujPZro0WtU0TrOwf9X54Q8Hrftqz2+i7Nl5P0Vm5RtPx7FIHrQR3b/aBk7B0/skp9DWXkhwCik4LHtbW01Vdvyx44WKbUDklNVy1UDANmNco0HQoxSXpdV41WEDpEW46V6NMwZ4BL2/rQr7sjoIxV2LJo3OjVrNUQW7I8O2EpdDzOZ9di3HSi0sUERsv++cDPP1/fcQPiRSAkVVLw/Yt7yEHfk8Rz0EzBRILnwQ0S+wfBVSJiz8SYacArS17uAQae91N0VxSaQXy44ceyf+pgchwWDhVgYw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b43e736-0a1f-44e1-26e4-08dcceb894fe
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:15.0135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PRohFVrg8v/PNfp/HXmphDDdWFKe0pcxIHONgfmYsYbNNM4noWjgkzYnz3C8nkcbi4MXPzttXRIcdr2Sm+1OVr5GRFLyXGCYntq4dwVNpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: HJpce-WDxdg5a0VpUYmw4gmA2sRLQLJE
X-Proofpoint-ORIG-GUID: HJpce-WDxdg5a0VpUYmw4gmA2sRLQLJE

From: "Darrick J. Wong" <djwong@kernel.org>

commit 38de567906d95c397d87f292b892686b7ec6fbc3 upstream.

An internal user complained about log recovery failing on a symlink
("Bad dinode after recovery") with the following (excerpted) format:

core.magic = 0x494e
core.mode = 0120777
core.version = 3
core.format = 2 (extents)
core.nlinkv2 = 1
core.nextents = 1
core.size = 297
core.nblocks = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
u3.bmx[0] = [startoff,startblock,blockcount,extentflag]
0:[0,12,1,0]

This is a symbolic link with a 297-byte target stored in a disk block,
which is to say this is a symlink with a remote target.  The forkoff is
0, which is to say that there's 512 - 176 == 336 bytes in the inode core
to store the data fork.

Eventually, testing of generic/388 failed with the same inode corruption
message during inode recovery.  In writing a debugging patch to call
xfs_dinode_verify on dirty inode log items when we're committing
transactions, I observed that xfs/298 can reproduce the problem quite
quickly.

xfs/298 creates a symbolic link, adds some extended attributes, then
deletes them all.  The test failure occurs when the final removexattr
also deletes the attr fork because that does not convert the remote
symlink back into a shortform symlink.  That is how we trip this test.
The only reason why xfs/298 only triggers with the debug patch added is
that it deletes the symlink, so the final iflush shows the inode as
free.

I wrote a quick fstest to emulate the behavior of xfs/298, except that
it leaves the symlinks on the filesystem after inducing the "corrupt"
state.  Kernels going back at least as far as 4.18 have written out
symlink inodes in this manner and prior to 1eb70f54c445f they did not
object to reading them back in.

Because we've been writing out inodes this way for quite some time, the
only way to fix this is to relax the check for symbolic links.
Directories don't have this problem because di_size is bumped to
blocksize during the sf->data conversion.

Fixes: 1eb70f54c445f ("xfs: validate inode fork size against fork format")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0f970a0b3382..51fdd29c4ddc 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -366,17 +366,37 @@ xfs_dinode_verify_fork(
 	/*
 	 * For fork types that can contain local data, check that the fork
 	 * format matches the size of local data contained within the fork.
-	 *
-	 * For all types, check that when the size says the should be in extent
-	 * or btree format, the inode isn't claiming it is in local format.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
-		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+		/*
+		 * A directory small enough to fit in the inode must be stored
+		 * in local format.  The directory sf <-> extents conversion
+		 * code updates the directory size accordingly.
+		 */
+		if (S_ISDIR(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		/*
+		 * A symlink with a target small enough to fit in the inode can
+		 * be stored in extents format if xattrs were added (thus
+		 * converting the data fork from shortform to remote format)
+		 * and then removed.
+		 */
+		if (S_ISLNK(mode)) {
 			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_EXTENTS &&
 			    fork_format != XFS_DINODE_FMT_LOCAL)
 				return __this_address;
 		}
 
+		/*
+		 * For all types, check that when the size says the fork should
+		 * be in extent or btree format, the inode isn't claiming to be
+		 * in local format.
+		 */
 		if (be64_to_cpu(dip->di_size) > fork_size &&
 		    fork_format == XFS_DINODE_FMT_LOCAL)
 			return __this_address;
-- 
2.39.3

