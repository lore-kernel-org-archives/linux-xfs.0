Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAB871739
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404513; cv=fail; b=Acw0bYQoHfEcdt5W4caFsuLgfSPDbR3XUDeYy6NMkhkCgAPxaY+qKzooJj4txAWNUPOmK6hhfSa2ZwTxG+JWZ/XNEX9Cq37ivPWJZkVTI5WGCAnRgq8MbWhB/6RlW/QZPm81z8dA3dY2rs+uOuw40nPsEd4pN/UssSGFmmdKUpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404513; c=relaxed/simple;
	bh=cstpUEXCXLgYdXpPdsjpRrU3LZyqMjsv7hPtB0XEp3E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PDpZnQJNE7PTI9q0h6qktHW1XBts4xCmce9XtgFP4TwO+RmRRGlb57mAvEfBcgDwk9vhfURvaBbx0mUzEOQWffSUohsS7+YM7PreRV1YGvY/xxNRYAoUgm+4eWtQD3RXJbDEPGvA373JgYIwgGd6LvzgdASDbPg+UFukxVwUknk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kKh9AxtQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JJ5sMpd7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kKh9AxtQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JJ5sMpd7"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLGEQx027540
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=cePYlPqZxHd7Yw9S71e3PThDlkzeNg+RQnRl8voIzY8=;
 b=kKh9AxtQ9+u89GREzgquNJLCflPlbOWpcxW4KG9CmGbf668Z/q0+GgoaOeF6FcDaKiZa
 lkXArC7NjAcIc0Jf0b/4dZjj7LN/sBQlCx7kTlIUnBbr7H/9Is94My1nxDObZkXzhfkI
 1OmjQsrU2I+MOaX9Cri9/iAkpQrHPMi6nyobqobAL+1w2WOyv1kzpvn5d2H/Mlp0zaue
 oDZQdl+opw5tyJdQgbSQp5a/FdAo3RyjFvKbLcuEQwUPAicann4/0QI2pgIwWfrjeFgK
 HGrx0dsrcm7LEC2xHCJEnXZXCwJmz5+NDtIgvTSpfOAEv6VW1iGNN/GXB+9omvPNlrAX BQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1nv43s0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKKedn007109
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhccu0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKla1yCiONpOdjDi8SbLY8Tr3DZntdVHGFQsYFxo7vTL1OLJlpAs99Vb8Tb7JDhxxD/6OIyqzwpFo+I/qWd4cLjRcfvarMmTMgsrAQA41yWZ4sTrG+ICVlUTxXmS92TrBOzYanEV2uqc9dq7p4c2nk4wT7tObAeGIpk7Yj/TWalDwd+zkf5LECEokJWABrnwdnm0m8hjeyecP2vR+81VBRfA9mlbg0BSlrMqbmDS+e+oAIbMHUQB8za8CNZHGHx0DNm6YxRoGWtGdslgPW7fW59rTdfWnGgbuevi5FhM3oWGLI/NVLzUZa0DEkp4cjcVzKYhyi+/e5m8ZuCtsz/tbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cePYlPqZxHd7Yw9S71e3PThDlkzeNg+RQnRl8voIzY8=;
 b=Ipqya689uc/AHravldLcEi54EH4sxASF6+NdoJrJqKWNBaW3oDqrHUKMihhoBZ+VnJYDIdAbaYVbyQgsq9LA/v1/6F3NeKHnmGo2b0JXZn9okz9eDZmsMHVx1NkPJnh1yJWRRH/e5xYcTEvJfR9hMmYaT0CmwWkW/WZ7Q8sr3hO4fZsVf14JMCUsHjG9o5cTj1xQkiX01WqxBKFcoEc+N9kH4fEFUhX0+6m+qCzTno1sv/uJHno4dPpqacc8jKQRo6c5UsvZr6u5FRx1vBpAFrALjPULWkrOOXCoYvpKanLcNqHovve3FARmR9iXv5zGjHa4wCgB8QOUuOMMo+zF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cePYlPqZxHd7Yw9S71e3PThDlkzeNg+RQnRl8voIzY8=;
 b=JJ5sMpd7WXL8UJUTqTY3UEWbs8HItH4Ocp+ICUZMi7yc0iEB+c+AVxpYmzmzoz1oU0pgGIB1MBDD24nwmy0lIAaQgNCbHDse5uyxENjV9BuSxqERBKcxSyQv/2+awufwVMVyLgnIluiSkeWnDXBtwgFFfjaiOz8qGEz5vd+24ug=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:07:59 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:07:59 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 13/24] xfs: recompute growfsrtfree transaction reservation while growing rt volume
Date: Mon, 25 Mar 2024 15:07:13 -0700
Message-Id: <20240325220724.42216-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0128.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::13) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	e5waoyXT0Hr+iJx4AILp+6Uj3lUY3Ogcgka3I/ff6rXDcBtXA8EEmzViKjgsGyHuwJxBzVvs/lcID01BEl7uMO3J0aT5Up7Ahn2E+jF5929A+mYkVPGHbEykIjUlD2kfKFNfHjEIUavs74PY0+greGWFi6jQjeGcO7wf7ryX9tXa0ySvb5qBJRDkv4pULrZf4Ofm/d6REXSxYQ69dqPq9GPt7fXHvXVZhW6/7zH2WR5G/y3mWtGPp3DF7Od6hF49FRYiZmH307Lm7XbP34N6546sYTyR2ztnBTXTNqCdjMvMj8CKuRdJ9Sy4cICO7zsxvnRXq0AZDivRACqzCZHHUAHXRGqkF4O2JlGiGeFHz1bryYTWnns8QxGl6Ol5yhPBWcegXa8T9jUdyvw7ExtSJD2uAs/RNZ0EYlmLdLEg1z4dhkyz+9FJICund+hW2pD/CAvWq5Pz7f5LP5WwXxAu2inTdl9Sn6O2PcZOE5Ho8T5qUcZ03oxezRxS2ZXO7X1ICR9iEZbPIIj3sbdFRxsI88tOFzDNLeMFFpZm4xYKuWkk2fm6egvLJSwX4cnlxlcuo1oZgQXeaLi04rCOjo95f/Fhrk+Kk+2RBecYPxoxy4BUIGyoDhYVncuLKpeM3Vd6YJHa7mp1QNJ+GdLv5VKPxpM/4gTYX3pEUum11eT+2HE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?L9s5WOg1Jh+dpeaBRmRq2yQADXCeGmCYGZrfbtBn3oxiW6HNykoGjqJ34mf+?=
 =?us-ascii?Q?D9IMDncQZRA6WPwQN/Rd+JZ/A2afABPMzCAl5WVOKNMKQf/HDXSTDk6krA94?=
 =?us-ascii?Q?/S56T7FaJi/RwXaEx1RItWkqBFeqhhHF9fn3/JhujrGalqTMbYeYrSCoYswO?=
 =?us-ascii?Q?7I1Rc1ElkPZ7QJrPI4ds4C41W2yr0o5XW/XNScpFB2c/FXgfxx8wtXSr0oyO?=
 =?us-ascii?Q?C3Kg9iLKNqI1UMDS8NhmKSI6DQgOTu1QbUX3SE6afIn9XP/AuV21g9FhfUCX?=
 =?us-ascii?Q?EGfXO/gaTwbTbnMj8BjjxeXDLNs+4ZWXm+eWRrz6CKmNXrMOUwGPaKb7HP3P?=
 =?us-ascii?Q?Gr1sKfTKzg307DTXbG0qqpX4Qy2WjF48ddlU0QmxKkloMoyVL/osKOWGiycs?=
 =?us-ascii?Q?acoTI50iRIo/IVrlmcNAgE0Jse3zmkJoCdzZ2B0gz3f5qCIsiQU9WVn1e5Bi?=
 =?us-ascii?Q?CdMCgwV3fWGV1Nu1Qkz14nVDcmsW3cguhcgR1uONcAXIHMwJTDecXGlUfCaj?=
 =?us-ascii?Q?2g4wqys4vh4vRzhCeawXeB4ZkNXybQlO+8GI79HWVzqUSQadezh/7l6KFB9M?=
 =?us-ascii?Q?lLcBOQNJ+z2PMZfzh98EwficsEad9OmGvbqo5AcIT1I2ubE+ksgZG0kxobIM?=
 =?us-ascii?Q?fuQUcYGL1XiLsEA3JwZfxC1JqOe8YGGI/4xqpoJBE2RjXTut10huFfCOpqdy?=
 =?us-ascii?Q?UTq0sQ//nZDtjLE6+5stgDElxFMbfrq5BZ9ZtHr9dAE/AQAGdzgHP5sESo58?=
 =?us-ascii?Q?ZPeHOnTVbQujVYd5zUdTBYcJlF1+lW/9iaXhxYMNsNNPr7AfJODSSSp+IYwD?=
 =?us-ascii?Q?X7ahjVoZMhaGt6lF1fLqv1q2gcvsv2+EQaOFBERd61hA95A/ZBqakESeN3Ww?=
 =?us-ascii?Q?ECGxqg3h+hoc2iVICEzjHg1YTBp+qGw9DvuuQbgfletc06INFYKHQBQ7b/h6?=
 =?us-ascii?Q?ArZ+NgiIJ1okJ8CVqeC+rsOvOqMR6dCdv77r0nCisoDRcLprdZEN+BpTandg?=
 =?us-ascii?Q?B5TiovCp3M59wxES8Dd1pZdW+w46GCGK2Geh6eJDQl+AII6dAWQhPZ1PC4s7?=
 =?us-ascii?Q?Zbwasq/hezhQURDn2wFiqXg5PIl907m/3EkzzLAwm+2HQWoyuPC880YDzyYv?=
 =?us-ascii?Q?jsktCbCEBPy3qH6MxrZ5Fu6WbCcjgcwvxJ+7/CainVJlipA0lMyUKbXoMn5c?=
 =?us-ascii?Q?0bf5V+IbrCkojClgsKIwVoSftW9fBMb48T+WRT+Pa3N5sghYMUQnB+zbGpUW?=
 =?us-ascii?Q?/E6zKsOZ3XmKm75sYsBcuPYYUKg6n8VW60z7TNmE2wuVj9nZyww/jbzx13/g?=
 =?us-ascii?Q?I+jp+q9Oh4BeGC0UcZFONK0Hb5fwAFxw2dZlWNDwbi/ohpcjiDNyd9NzTDxT?=
 =?us-ascii?Q?rVyEMIV2WPzXqKpXNS3WGWQAYiO/7VXWe9x2hX37NuotDtr7e85k/DKe81ff?=
 =?us-ascii?Q?mqhc5b1Gs9vafbVBGlIFn4Dp4s/UbCCJlrv26cHJ6MmRzCL6ayE6L83US5X5?=
 =?us-ascii?Q?ilKhyKe25o3tANnh+cFctp5efAc86jIjiDFzvgH0+4tUN8vv53r4PPSbxTx+?=
 =?us-ascii?Q?CZaktmBqG5UKAFx9CrK4vT0vxQzQrqNEEwEbcBluc7DEAa7KHuDlJ5Di6Utj?=
 =?us-ascii?Q?a5mwRMDQtPTjZ8zcc8DBofqhnH61jqy+b0sbOdzysSkNuTzi8YGJDvxJToZC?=
 =?us-ascii?Q?W73awg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CUkg0H8AMms/qqlyvj8BU/mMrux77IPkIAza7jodsuhco7t2GBLhYUfcF6NhOn4D0Cq2/IfU2fbgaEeFlZhWsm1H+XnE3eWoXgrzModYtdaaYNDoxZCQ4DE7r+AYDwJTwYPEWYZ1mkXTQ2nitxob22wrS/IfMRXrJzN6PKTDuidVv2cHYjmwv9FaRyluxrKGKSVpvhiiBgt+hQ8yMN2+2Jt3eP/Z+MJGs4elokXd4eLehfBML4VDeHO4eltYvypS5+yF8D/AakLKIfFo8vi5+qJ2u7HKQU5e2/hxL8i4q4VTE4Z6uDlNYEE29ef5W9MlHjegw2O32jthiEKhe+kpA87ZBPXERToAtsGGUXPzTwzwvYyXroIpbPzIKPbVN+V2Qytf1XT3IWBgG3IGq5j/UDEIceGn/JjxyzDtCwLUEiRs9N9kf43big1ZCLKvq0TkxqtqmUz/puUxqLShZMLAMnd1beexNoJNlY2SZ4l1g62Y1p2FfQ0wNKPwYFsg6zOrzig7hZ8bede/anLnEVPCbPwh/J2T7Ry0d1ZwR2Y9soKysqKvLUrdqeX2MtXoA2D8s8hBrqVYLH5K6s0A+lOIQxba4A592Q6pr4ijLVSYjzc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f242f757-5bfc-43d0-0d5c-08dc4d180865
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:07:59.6610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5CUYtUYy9ztEFVzNiEV0Zae7Z5GunFuOAZMhCpn1ahumGiz2hWmljNzY+Q2bVTy+3z83x0f3r0QZEVi19ArR91LBkPfKpDeBdwhPP7AGtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-ORIG-GUID: iqulw9oW6LtLH4V8sEMYOYw2qmZXAHqb
X-Proofpoint-GUID: iqulw9oW6LtLH4V8sEMYOYw2qmZXAHqb

From: "Darrick J. Wong" <djwong@kernel.org>

commit 578bd4ce7100ae34f98c6b0147fe75cfa0dadbac upstream.

While playing with growfs to create a 20TB realtime section on a
filesystem that didn't previously have an rt section, I noticed that
growfs would occasionally shut down the log due to a transaction
reservation overflow.

xfs_calc_growrtfree_reservation uses the current size of the realtime
summary file (m_rsumsize) to compute the transaction reservation for a
growrtfree transaction.  The reservations are computed at mount time,
which means that m_rsumsize is zero when growfs starts "freeing" the new
realtime extents into the rt volume.  As a result, the transaction is
undersized and fails.

Fix this by recomputing the transaction reservations every time we
change m_rsumsize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e5d6031d47bb..4bec890d93d2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1070,6 +1070,9 @@ xfs_growfs_rt(
 			nsbp->sb_rbmblocks;
 		nrsumblocks = XFS_B_TO_FSB(mp, nrsumsize);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(nmp, &nmp->m_resv);
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
@@ -1153,6 +1156,8 @@ xfs_growfs_rt(
 		 */
 		mp->m_rsumlevels = nrsumlevels;
 		mp->m_rsumsize = nrsumsize;
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(mp, &mp->m_resv);
 
 		error = xfs_trans_commit(tp);
 		if (error)
-- 
2.39.3

