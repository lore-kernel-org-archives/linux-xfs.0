Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CFB80034
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488078; cv=fail; b=QEQ6OogcwjB8/GR1ESofVe/BtV7hLp+wW/1WziVlDzgmZebeNw75LicUTl045pS2vqPL9Hyg4hsJ4yfYBEtGCEpdwpiTOKOjnQNV9dINA/0cN91xEivl8069tO9TaJ6gBxTdxndfHwwG3jnklk8VC0jANZWdluQVNiCQL/K0YaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488078; c=relaxed/simple;
	bh=AT/Q4DM0EW6mC3CtOocHwtIPbTYcOy/jkrh4HNRv8GE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jBZdBFDO1Doqbb+3NyXcj01MiFKJIAxTKXrpUJ8ACbEYjCXqQOF/qiM7PGTO9gBfV9QycZKY2YSV2T5OZYBSQLbDY3h8t+HHIjGd2+cFt8Mnyug2qBT/6pwwxFRAJJeinGa9dnR84lPJbAgmnr5kXuLGC8KSUGaSl1aCey0Pj3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m9A+EMf2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T4eh5f97; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m9A+EMf2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T4eh5f97"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BqAt016223
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=waOc3kf12XCaUTAgX4FkTdZrBlwkunwn2NQBvP3aFtc=; b=
	m9A+EMf20O5Q8axD1nSGCwnq5VyorYBZc/TWlBViKGuwpvdQvjrpdnou8UyLFgfK
	FU3y0fP6stKl9WOlCYh+V2Mrb6Ag19nqpbpgaB3/x5cJNs/6PDWe91+l1CKZLFhN
	iC7Q1TvKQ7fptTy5dc6ngRI6xe7F0eqGbxP9ZQGsvtO+43gT2X1y+A1LBpm6i2VZ
	UmzXS3EAHvAOPshEZedgn8dK8opVXrmIMAOI+1NX+DzpIKGRM7klllRlvLg7rgBA
	63k/Wwtdy83Kniuk/VtNgu7Vx4d632sspY30VeVQLkojhcj46UW0Ot60ZQx7vqH5
	x5xeVghZiw6n8P6I3XcpnQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h22cqhdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI1hjfO032631
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fffbfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOzxbCICmaRrRt9C4NksHA1xcm70sVIaJyz43AZ3CMqz8jNcXW+5EoQre9e9otPIGUF/U8t+mnlRK1PXXLJSQwibhN+ASJ7oRrw04ohB2vaNX0xLKvX1Wnn9lHSDTJs5nnEKaZxj+7NkBVBxtp9U9D1BS17lJwbbSRfXP9hpTN/g9VS95hBEpGM+O1A98FHf6tP0XyuhNbgyAKEkRFClFZejb4zNdocFxLMt+s7yta2/48o9GGI48V/Ix3vMIXJIJh03fSYtuLzUofbUUEnXc23JieZbxnJeBQKfGOTgDh0nRX7nvGWcRpnIUgVKCbYzmcC5JfjQDt6BoEVIwW7cng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waOc3kf12XCaUTAgX4FkTdZrBlwkunwn2NQBvP3aFtc=;
 b=iQjuWhSTP+ypePuUUMJw6xRUjCmF5HpLVwyMov9XMrYd+cGmScC7ruwZICFbHTUVQVf9pDYhAf7kWTMkp04Gcf29ShPssxMZeaY7eD2dCH/HF7+PiFaX98TikkA6PHdKYeW6iU40p6J7WIUBaRwy0f4VFlndGMxq33/iopP1vSHNCoiLr7wF/Xhml8DG3z7zLPbtPV9lBZiAiQDkusGbCOi8o420iVYSymkMNcjxWklsccjfsfcM2S3iG2G9+fmIjlkhXTtD9C3RGdlRKNBkoIt5KkPdfLlvRsIAyjnLwVK/3wQdrB2pXSH+tPShYfgKeJSvAoR0akY5jz+E/3ohcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waOc3kf12XCaUTAgX4FkTdZrBlwkunwn2NQBvP3aFtc=;
 b=T4eh5f97qjzo4mqfxTxW4RIqZfrTO9oA0G07DlCqecBlhA/+Wk3wnwiR+HdYDSKrGud4uNaoVzrXsTytv+KGlbUoUrJeAA6WE1y97q5tkBkgDQ8N9PnxAPIoBeig3Ealhxkosj4WHm11VX7zhELbHlHwXU/Vz+Au21mcsBpTLWs=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:33 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:33 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 11/18] xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
Date: Tue, 17 Dec 2024 18:14:04 -0800
Message-Id: <20241218021411.42144-12-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0198.namprd05.prod.outlook.com
 (2603:10b6:a03:330::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: f8446f16-3f8a-4aee-2fbc-08dd1f09b66b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yF4VOVVdn7Uh3gpsAH/MoPzzGki6LcOqulAmDiRBo+liOiUT6/xU63NcX5s/?=
 =?us-ascii?Q?/RXDWgWsjAkTmN4Phn3MR6SX/9ryZ0SYZOWGp8ltPdHOGhZVDm34EpEnavE3?=
 =?us-ascii?Q?owEasarrwUglSqnklrV+XOhH0xTn7+vpih3Bu7HSNcIOy760RlRD+Np1SB+S?=
 =?us-ascii?Q?z3Ho84/JJly574c8WYcCYB5L19sJouzN2OoAPDlbTQNXxxs9eXfW5Pr8cxP8?=
 =?us-ascii?Q?3K1Ym3m5oIg5a3+UXtm/aU0S4lRtOKMS+EhaOTGbuir7tQ6mG8GSJPORVToA?=
 =?us-ascii?Q?f//QdPjBOurnVYcs9EdTKj6nHaEXfj0knpZhveOx9YoQ/MGEstr1TQGvbltj?=
 =?us-ascii?Q?sW7PM7/JumHNC91KQrMJmZYR/9Ujg+d168sdGE4V3nRtpYZaceF+2Hgs7zsA?=
 =?us-ascii?Q?LmMScGE+DY0ZZC21pZvMzL8q93Yv6HaaIdtq4o6NF69Wj1JRehfX5doh7f8i?=
 =?us-ascii?Q?hrbtUQfC5tJn/6ITYMiZ4oYtxMjUAJiF1jCR9KKXRETDVmJ54kAZz3ewCcHL?=
 =?us-ascii?Q?8TcRj1g8g24nwStgSBwEBiLaR4FWXyduTAMLcxXoenvmB03RXDLg6mSD53WE?=
 =?us-ascii?Q?uq2/6VX/zEiaikfaws1ximoztPGN1HlYXT+96w1dSkGKtQJMldNZJUscAiRr?=
 =?us-ascii?Q?qlZ/+6pQDEzxe+IEsHBsKP12+ziD2HrGMbwXYLuwDqlGp8QLJAVxD5Lgfxn1?=
 =?us-ascii?Q?P7NmIPhofsMvmJg05eNThTsWXBaoRN44gJE7gu508wYFo+uQ3Lc0xbmxN3lQ?=
 =?us-ascii?Q?JCEd9+pNXIzzb3TMtrtfW/6+Ut2JwWScvDU+7Jw2i+eMYi1mwMPQmXmbJTV0?=
 =?us-ascii?Q?YKryh2Ljf8BzfZ/9KuP4Z+scFl81Hobi5eAkAOUgvnPXSX1qz95j+yjW5A4o?=
 =?us-ascii?Q?MDUxAGzRfTe6HM5Av0vDMpAUpMfu/gqlaLx39SXAT0sT2r0MLfG8ClCYwGU7?=
 =?us-ascii?Q?xCCX6LTV6OlXrCXSJ0NqekhCyef5YNpF7RVgYZU/Y2i5FGLspyWGfU+I1EJB?=
 =?us-ascii?Q?TeNkORa3dtEvmrxYQ75WLVSQWoPArgkKxDxEsOxxNQuIZVCuSdq9dVJ7fvr+?=
 =?us-ascii?Q?gpPh8eix0kHyFgOZw6nsJ2V+e2DRhh5rgyJ+787wKGPlNd49ClBpPXals75b?=
 =?us-ascii?Q?5iqTrwHlMafpolWqReeMS+5H2F/PYLbmAs8UW/RWbQ226XPlsS3yUYwLl4KN?=
 =?us-ascii?Q?Wg+r0DcJXhNU/TGGkeHSABU/38sc72sbodtJFeD5F3FT73fjifJJafHGdoZM?=
 =?us-ascii?Q?6el3xzlATj3rzKqESlaEBaxK5QOarhvh+7izcF2T/i3ArJAKFpzIUcsZWZAx?=
 =?us-ascii?Q?xgDRIKvGVnytfKHRsmmoFjliu1Y3HeS2mFzlztHGyO5VZIsgXX9cNy/xAhzq?=
 =?us-ascii?Q?Wso0cYKAzP/nRGt0laOcYz01mf58?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kXv9Zjcd9bxCyqCzHPomJZCrAw1+EQx9cheuu+Y0tGTnKi+dZjEN+LJVcQWw?=
 =?us-ascii?Q?vyecW22uM0F0rswfWOqdjv2QyJHNUKTIgZdqm55uRsPnUqqpm+h9BWsjsydi?=
 =?us-ascii?Q?hMNyMPqmpYjn/rbZJAB2wRGQli17duzhBuPGvGsJZUhex4Y2D548x2KicDpU?=
 =?us-ascii?Q?kyzK95QfrvZXXyjrvanLjIcf2qVmjQrHkGuyHt3a7TnmWq4g/lJMA1ya1yph?=
 =?us-ascii?Q?RANVWEnT+Bm4i29dy52/TP/iNVPUQNJrlrOKbsziZXGVNlfsfFiXvLD4W/6E?=
 =?us-ascii?Q?eOXVAi0dTgBvUMhpUuD3uPQvXfZIfvmGEbOdjeEUoXbprXXlJT/M2BABsARH?=
 =?us-ascii?Q?JfrtOUzjoqJ2FWzjJ+o5cObIuUHUDwgA9HP7OB9Dpy8LZvgOnJTt03remDhS?=
 =?us-ascii?Q?xNcNNF3+sAOsAU2y4og+WiT+gttKx/KYqjwT+eioHBic6SnOnVekpc650/Gv?=
 =?us-ascii?Q?Fhq+paEcuDYA7svZAXDiAf30MQHvDSvRdU2Ot8nNUECuPD2f2Ngx9b+6Mbmd?=
 =?us-ascii?Q?XNG4x7XyOSGJB7fUcv4YeybJMo3VWxpflnKEk4DGdbNmtmhu5TZTvebyP/ir?=
 =?us-ascii?Q?k9wGGE6tf+1kNNbFfRQL2lHvPTN3+W4ZEaT1UkQa3Q/QrJUWQAUKzKjULVB7?=
 =?us-ascii?Q?iZUSTG1LLmqCxe2Mwx/B19uIS+IRkoBh0cTzHfM80EaCUg2IEZAnVno7MQRf?=
 =?us-ascii?Q?huDndyK4SidxZV3xnpKk+mzAwXfSxkLc7Wc/3EuUZPMdhEn6cckyi7dTjCIx?=
 =?us-ascii?Q?c51eNhizi7myeJ3fil1fJx58tWrc+QNFagq84b2otNPDWfhPOu7Q3Tr8XuoO?=
 =?us-ascii?Q?1z9IHpCi2EJcE2UrkOEPwIyXycJQhMAaXlZdaYsGVrvdL5JebHeVRtga1Gy/?=
 =?us-ascii?Q?xWrg/wr0gFCmFsxQOcnQxIdm5NPylmJWde9mTLHIzfdi6xO2R5YEPwwZCThW?=
 =?us-ascii?Q?eJK5hKDqhgRdcKj9TKLEMRPLl8EnB7bAfqad7bRVKcHKJUEy+0d+r+361iar?=
 =?us-ascii?Q?ar9piY9L7xfh1WSqLy19wzLTmxaIdQx2QeXIJWwYL1+L4eLSVYLIX7zdls9E?=
 =?us-ascii?Q?lOmWpS0Q8KMn/g1DaoUF5ePgHjdRmpOO4l8l9hz4Mtech6F4s5nMbbywDJHW?=
 =?us-ascii?Q?sLcqhQNttBIi7dPfw5ypUSCCvb080mVTTm/Tq3q5KIm2Ma+NZEINym9rYX8g?=
 =?us-ascii?Q?lTx2oajBGMaozuGx0TYFLP9SiR1EPxxjmtlN9dPZncMnzV7vpD8wa+GknDdd?=
 =?us-ascii?Q?Mq2XbwfxKB2qF6PeIuwf2YxALnBKXeOylCJpc7LoClNP8I4SmocXs+nySR5u?=
 =?us-ascii?Q?/nTLMV949unX4hw7RXmbSdGjz73bVw83Fa3TJa7iPW2aPuvlJqd0jXgzg3dp?=
 =?us-ascii?Q?oT2SWZT40x5oPZ1j07CU5U1DkP85oqHH/KqsSO2tkGwqIWR3czt/t6sajDnK?=
 =?us-ascii?Q?ve8+Lnzs23/AjVn71fK1d7QTwvgB1FtOdZ/Zo8OeIEIjpxOXZVdjEai19haq?=
 =?us-ascii?Q?xFcw9n7g11ih7gSALq+KvnG3JgKvZK6I8UtBS8XzN3b+jmaclfsSpQwLw9T2?=
 =?us-ascii?Q?sAXmKl682Z2as9uLAwl+kM/37OYB9PSEmh4SNJNVTO96hamY98INyTtiGlHo?=
 =?us-ascii?Q?RbrONd4NfzgRXXK92LpWfsqJmXfnWjF5u/4p0q9RdIEZLMHC2JfdXdnCpjGm?=
 =?us-ascii?Q?AnbZmw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wc/8q7GKJiOX3phKNCxvbaLYrcEjwwUlZRp3AUQEG+fq167yr874EW6gqQ61ZMv4CpWM/rkLkOx7upYxUo7lSGLwJKjbXCqWUVsZwAPxmQGIUM/rIJVj2DHMOZiLrzVaYO2womVjfzxNFxCjFSIOpYp+xDARIPNWrtvWawP8SFT6AeG4K+BoAWKsJh3Ds/PlbP+zRMp9XedYQkArXB95yA7KKRba5VJh4Lvp3t8/QwFgzGYx02uxoJtEt6wTMfoYEymZDksn1CZmdBpoDPnp0Rifpnduz56SGY1YJBciHUoZ2F1m0BSwuYcElbfSEEl3GsQpSNICTwRxqLPHg5fYKjCtzeXLG59zFRod2E8NcorI3cILX0Ch/z9GsrRbaB90g/+mQ28ixVto9TWvZ3vyGJJip4XiHlNx3WAH6iUFuUoITsdn1xhPCoLOY08SwFDfDx23utEzsaHoUiPowlQWhl2Ml1lrk6UpTaxkV0dZPJ+6URvsUe7ybp0gWTnUQbhgrItNWsGN38Gm3NDfxFmsXCWmv61t7pLR+BGMl4xihsS+p+ml0CksOOJFYqozfNjqYtLTt9yiX7ueWkPcMgWO81jSYhyRiFaezeX6PMbFWRE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8446f16-3f8a-4aee-2fbc-08dd1f09b66b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:33.3801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWOOK/kNyBtXUuui3fGrmGo0KAU8DylbPnEVisddyVTQZLLZZhjBPAc/s+/qSBW7r/COMyeqCXgzKrmBNW2EOkwgH99212k88ViDMXTKOts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: 85HcZoIXMSwuoo-KeYc9kH3_wAqcezlr
X-Proofpoint-ORIG-GUID: 85HcZoIXMSwuoo-KeYc9kH3_wAqcezlr

From: Julian Sun <sunjunchao2870@gmail.com>

commit af5d92f2fad818663da2ce073b6fe15b9d56ffdc upstream.

In the macro definition of XFS_DQUOT_LOGRES, a parameter is accepted,
but it is not used. Hence, it should be removed.

This patch has only passed compilation test, but it should be fine.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index cb035da3f990..fb05f44f6c75 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -56,7 +56,7 @@ typedef uint8_t		xfs_dqtype_t;
  * And, of course, we also need to take into account the dquot log format item
  * used to describe each dquot.
  */
-#define XFS_DQUOT_LOGRES(mp)	\
+#define XFS_DQUOT_LOGRES	\
 	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
 #define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..1bb2891b26ff 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -334,11 +334,11 @@ xfs_calc_write_reservation(
 					blksz);
 		t1 += adj;
 		t3 += adj;
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 1);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -406,11 +406,11 @@ xfs_calc_itruncate_reservation(
 					xfs_refcountbt_block_count(mp, 4),
 					blksz);
 
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 2);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -436,7 +436,7 @@ STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 5) +
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
@@ -475,7 +475,7 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_iunlink_remove_reservation(mp) +
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
@@ -513,7 +513,7 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_iunlink_add_reservation(mp) +
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
@@ -572,7 +572,7 @@ xfs_calc_icreate_resv_alloc(
 STATIC uint
 xfs_calc_icreate_reservation(xfs_mount_t *mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max(xfs_calc_icreate_resv_alloc(mp),
 		    xfs_calc_create_resv_modify(mp));
 }
@@ -581,7 +581,7 @@ STATIC uint
 xfs_calc_create_tmpfile_reservation(
 	struct xfs_mount        *mp)
 {
-	uint	res = XFS_DQUOT_LOGRES(mp);
+	uint	res = XFS_DQUOT_LOGRES;
 
 	res += xfs_calc_icreate_resv_alloc(mp);
 	return res + xfs_calc_iunlink_add_reservation(mp);
@@ -630,7 +630,7 @@ STATIC uint
 xfs_calc_ifree_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		xfs_calc_iunlink_remove_reservation(mp) +
@@ -647,7 +647,7 @@ STATIC uint
 xfs_calc_ichange_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 
@@ -756,7 +756,7 @@ STATIC uint
 xfs_calc_addafork_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
@@ -804,7 +804,7 @@ STATIC uint
 xfs_calc_attrsetm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
@@ -844,7 +844,7 @@ STATIC uint
 xfs_calc_attrrm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
 				      XFS_FSB_TO_B(mp, 1)) +
-- 
2.39.3

