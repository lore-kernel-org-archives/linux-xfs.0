Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40C9450EE
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734488064; cv=fail; b=fPGznCAR1Z2j+7708K2aYgtG1wlmyS9A8tmAST2FdFo+N/BopmnEE8Ipp43ADEkAMCYr4SqsqNYQWcpVT4aM90G3hAUHmiaTefCGZ1z9yOr6WRHDym/GPARcc1CPtMpvBSbrASzbs/uWN3Ev8LyMqEJpHs7xjT8y3iXX5C9ZNjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734488064; c=relaxed/simple;
	bh=0eJXo7iF4mSU873YEJvnfI3EmoSFhnMj0YMi1CLy7TU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J3PG5crilADSKh6MXzM83S/Ef49wxYU5YkeBaDadYYWVHKaZTHtzFm8j8zuEj/KueKg33ImSh5FWFPB7NfjD+XSer4zNfSWEhQkvuM6//CMXKl0+jKKphhR2rBCPqW1HHzskSx1a4FLKGu/oL5/qT2pRsgYgxhwcGn7UAV6NT3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EPq49pTz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cDvlN04C; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EPq49pTz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cDvlN04C"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI2BqQl016231
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6CTIbb4k2UNORXIL+fUJc74QeihLPcTbUOpqx+94UK8=; b=
	EPq49pTzIbTtXDj3nwfCNqBNrdu38zq6LeU2Px9ncuAnvZRUoH6NPt6OXZkqx491
	Q8h/Q1GNaET54rkDB/pZ3/iooiy1J5eM6iWO7F5u4mC1rzuM3epuXKsWpOI6rVL5
	p/EhfEbVqKp7tUiOyRPrdsNjhzPvCUPkkDyVlb4uLv7dLlsbSknl8E6mnn7uLxdV
	du7bsj/ZtoeImGG3L3Q0HAQaf89e699soeRl5pEaDJHhSA/vgWcCaHyfSOpzEoya
	S0n6D69QEYbxuaAyYOZcYFtAT448V8ixjJv/UiN0r+QdJAUGw5EdzZp2CbrnYWhT
	AA6qJmCv8Llh207MUtjW6w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h22cqhdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BHNK4W1000913
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f9dc1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 02:14:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHTcxCuac4XcraFPBUQHQZQuL4EniZUjeqsrizPASX/L/TFlpX7rpQ/ijFGZ74kb0qfv3IrRUeujESysDzJwPrvBIblAvHgYIhACqHURmzWcxylCqWPfbBu6n2Kdbs3Iv1LLpF7IWAVTPLvUE5Z/EMmw7eL64CP0Q7Dyrt9ESYZytG5odEIAw+70B3758MJPOdh4Z4xW7EYn4oAGRf3eFfZBkeBWBivX0slG4MwEn0nSOuohKv1I/YTisqW098o7m2TaCHdoETaFtALyrg/9ZmQ7eO6VLYRg1jGC/lyMEUGo3sRKAbWcdXtKLZthgnlc/bxX1ay8fiQXgXBcFNBzqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CTIbb4k2UNORXIL+fUJc74QeihLPcTbUOpqx+94UK8=;
 b=BNL54HSD+rZDj6Whrk7jpzwl4P9obWtPNKvz6PrJ+gcLmHNKLYeVEqV/syiO/XL63q5NxqNSBvrYB+Lr8aHZSFtlwXZoHfv6qfAD5BFgtSzXDRzJOOOZEkQGfE6yweGAlfoNIbpwVeWMdLL8/evBUzV5bLdIQ3PyDc5j94lk0967bWGtjrNBTuuCOue8LkjS9TbUJhhxENa9nq8/8dBfshEvetGLXO7s4k9dSsgMZomH2lg66G9kqdrrIYKnapWuiUgsEQmEIokmkgdXmkWVvs8hStYTTMUTbfB86ps4futeniplXhtWsWaHC63cr3HRLzc5/tawKV04a4N9skDfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CTIbb4k2UNORXIL+fUJc74QeihLPcTbUOpqx+94UK8=;
 b=cDvlN04C5RWsLurn6qrBCvKuKYaVCrG9XX4X2k1qIRRtaJ45smn5GE1LQOeJcn6x+KA8qeZkg7wU70EofFznk0E7v7qnUbt1TRvV+vpzu62nHhK/oHoDiTibg3jCmBwQUPFcEKxt5lh6YjldA0cDXaSz6fWk6li/d+1U8q4BQ6I=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6959.namprd10.prod.outlook.com (2603:10b6:510:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Wed, 18 Dec
 2024 02:14:16 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.005; Wed, 18 Dec 2024
 02:14:16 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 02/18] xfs: verify buffer, inode, and dquot items every tx commit
Date: Tue, 17 Dec 2024 18:13:55 -0800
Message-Id: <20241218021411.42144-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218021411.42144-1-catherine.hoang@oracle.com>
References: <20241218021411.42144-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:a03:80::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d4e741-67d9-4b97-a855-08dd1f09ac68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xmjI1jse6swdoGrCmufOrOyeLWqy0IgCD89SnIt2FVlY8vv+w7FOApNZVLNY?=
 =?us-ascii?Q?mu0lUpvLx0hLB+5aUEPL86O/ysQFuuKYYXSN8DxwRpGRwjPRJyCugEeE9jk+?=
 =?us-ascii?Q?rKbWYR2Ocgftg88YLQWrp5Pfg93HY02afeNrlNShZCqR65CpurOYPvYNUScD?=
 =?us-ascii?Q?Bl3cTjyNbz8ojJatTjq4+lAAvQR1Hi6hPQudLjCVmJWpkHxySrdxf+BOc4ht?=
 =?us-ascii?Q?dI40xOmtYgJct/0rr3DvgTU7dOqTD0efb49m6eJjmJeDe5dkUVMgOtidV1xr?=
 =?us-ascii?Q?l1rja3/7Pg6VRjB//utmcH7IeTbTz6Xmj6KOoEPRQKtfe1G3vpxLVNY2W8f1?=
 =?us-ascii?Q?IKgK+dibFXF6s69xl42X8M+rVG24l7ktwQtT85OWwNjG/KO0JEZnGkokHmkx?=
 =?us-ascii?Q?SbsXQ98qWaO3dDlY8D5K7v5oEpe5TzGAufb4OORiPTjcrnhRI53R7p6VZsiW?=
 =?us-ascii?Q?JgyQAShW857qPdrpC433rR0qqZ3r8ASh3Jn0kEWU53ydU9MUlULYXsBea1Zi?=
 =?us-ascii?Q?cDfubj7exzBZHoJ9n4zOPQduiPy5mL13Au/9s44igODjUuRmzXJYLE+vBNVi?=
 =?us-ascii?Q?M0Fiow8UDI9ofayKSwOKMNZY0Xt/GZKZW9ydgcQAGLNUZ8S5UDOxe4jK8ili?=
 =?us-ascii?Q?DBMdIMNvkhjTyWBtO9rFrsS4wUTZF4qhgkfcHuUKAM55yZOlQeMOjd8HoqdM?=
 =?us-ascii?Q?qzxvF1gx9xS7sO8/5R0xiG6+HXAPicMuHNM99FPkheO7IDIp6FXZOANBgv1z?=
 =?us-ascii?Q?zS6MzZNRqSVwbRxYZaRKNHcKgQKREKP+U6U9OYtLyPRz8Rb5xN4LitPsIiPX?=
 =?us-ascii?Q?GmLg1U6VEKtvLYIFK6oUqSVhEzWWjLBJB7KRS1PwRQANcSC7tlwEf5IyqSIv?=
 =?us-ascii?Q?TgsU80CqlnsHrLbEwVi42EqECL5IvJp+q400gPdquN+HbNbbhv7+NjRy8znY?=
 =?us-ascii?Q?ncwy+cNBbBU4uarB4yOF9DrEQS/sNDRqIO8VyQDAut6T+wIuH1iYLMcvRoJx?=
 =?us-ascii?Q?2dV/NqK2KyWlpo6hDu5i+lNRj3qRx1JnJSZHlvZhBMvFpIMi+4fKb6VpxNI8?=
 =?us-ascii?Q?axPRKK+obrXkbB1I/XrIv63EmSI865XZakG7iVqTOHlSCqE2n9Z+D0GWJKq5?=
 =?us-ascii?Q?B5whzBdJ/PiLpWuhaKeoKvbhay9F+TUvGd6i78aMDs1SVRe+mn8z9tjDa/zl?=
 =?us-ascii?Q?0TuGRKOTYMe6eZ1jWSu/mV4WAUybYMJNuESeKctJbq4oAYypEQMd44hUBIkc?=
 =?us-ascii?Q?/RNTLwDSgP9S7TczOovKB4MlbW6rtLD5B3bHHFMGN8gDoiCNPykEzmJTpfMk?=
 =?us-ascii?Q?kA4PzS8OAAHdYfJez1gp6qutbAXudOr032JIykyHV5uz9NSDB1GmyyFLFAc8?=
 =?us-ascii?Q?MSL/RXAznPha5y7kfCZS6ENNequY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ly5PafFLlbC17k9nWYtdNOrf9abJEqeXeSvYiuKe1VtCVDXyBRkfIZmDD9gm?=
 =?us-ascii?Q?laUPO8ESsLRdvrnX06GcmVMy0wLwlVZuJLolHjlIgpJlU4qOe/D6nh2mSZrj?=
 =?us-ascii?Q?kNBdOkvmRJ8DYMrUJ2VN3oayrgUIFB0+bVXv1gRowCwoFIbOTUyfZMZZFWBG?=
 =?us-ascii?Q?mBhRNIwvGH1+4/l1m4W2r5y0pmNEQRZKvfeEXOGj88E9aq7N8poovgBYTNqD?=
 =?us-ascii?Q?1zcq2MW+VWlKB5qtfFHUxDRrvKWqAVzXf8t2hPAL7mSEippoNaVBFZbqG12L?=
 =?us-ascii?Q?Qzm3cFEprWhPJCvM0Xfcag9tiguMQzaxK9oHOjDvOyihKT6qDuRIKbmTlOyi?=
 =?us-ascii?Q?2N9JiBwjhhnbPKnj46P1JxcsvSHgvRaxGZ2BVdiJlsOTYXyggqZTy6JViQdu?=
 =?us-ascii?Q?HeXVGioQVL55WBjpSGYTQJYCp3qFpsJZ9LOaF/tUxeTEzVtMv+notzp1DrUh?=
 =?us-ascii?Q?K5TuwEv56r9QW9WSmj1keK4FOnjOOFEPeEcRpoHuehGZfr/48A9rpnxHTGnQ?=
 =?us-ascii?Q?g+3KPJdlFgVPjFM7Ba3/HIq/WEkE5wLmZgRK37fVb9UijIy/rpuxffsi+57r?=
 =?us-ascii?Q?S1tqyKzp9nrZvthein8rEHjI00hm0LsI8pfvx9me/SEPvyg98CAfUKOLhsX2?=
 =?us-ascii?Q?53XvWJ3gGdoohUOuxhLe37JQ6QHGVQTChKW8I4F9LQwNZDlCaAtWWEDQmB3w?=
 =?us-ascii?Q?acLVQZ/cXVedvCsvRhXxpGDYb9d1K0imReq4GFS16dV84sOVEvBR7kcwViH0?=
 =?us-ascii?Q?BfdzWniBSEzzJ07e6zmQJEgILAHXlDscPIuQquKor/nxP7I/+Nz3GZfthgPg?=
 =?us-ascii?Q?KChOGf0S+yEWDaWOKdRKg2XhN3OYIqEmMByvYl4grfEnJ4fgPVR+lYOiyV9s?=
 =?us-ascii?Q?kVYJ7SU4u6ORJCJlTcKBzlYSHLSksHXdOyegWFPvSxiY+NgLEf+Vkv7rZAgE?=
 =?us-ascii?Q?r1c7Y4D/oJjjDBYhxuFuZTDuD5mXLFlPgRirkbcwNkJn6oaxMVJtrD3zolr5?=
 =?us-ascii?Q?5mFjjonRq5ThDFiZTUAgNWygpR/DVUe0aKioh1DY3hyk+cdTRNcqFwsWfXyu?=
 =?us-ascii?Q?MRfptsUibB3hiOulptXvgQeX8mNMEJDmgqqvO5BNv7Gz9IzMHM8YStNdfWbt?=
 =?us-ascii?Q?FjMQU6BN3HZfS8aI+SYsGArjBMuakGe8eDDoh0xFFb2q2s4nNUqsxgDfnCUj?=
 =?us-ascii?Q?fhQZCt06qvs2nmaffUzxJAZPYENg18fSE1iFQWRFU3ptm2dnkqQqdvVXhtch?=
 =?us-ascii?Q?dxKLHdTrXrIjTP4wyRn2PF+hqqTrpfMcTE1yzdpxfAMXdcX+bYC5TXwCWfUp?=
 =?us-ascii?Q?WsduynQk/RQMgnTEXr7BfsEzMvn5xtyd4ONe6kShLFBa7k0uOCs1Kq+q+4Xj?=
 =?us-ascii?Q?+pArMWp8VH5K1+przzmoBBF6mZ8L74tNNxZmyOhmeyrvmqmVlnpAQ4PCyO+2?=
 =?us-ascii?Q?lOrHhOzaenR06zEdwYrtiJ/5HB9mQbua6NsFN/gxHoPEysrWMbvFuSD0VHiB?=
 =?us-ascii?Q?t3OsC5TJXMzaqxWfJ3szd50t0yTCPOXEEfIB3Nsmw726PRBbKJT2qq10OSvZ?=
 =?us-ascii?Q?i+xixMO1PnSL4yoonH2x2zprl6W+ijb8apgBxsCfeAfqgs4evew4WUkCt0X8?=
 =?us-ascii?Q?Xi53v9aCZ7WoeIAcYg+nJSCXoMXlHxIH42RiP/DmaFuDPmYXq9ENg6CVRzG1?=
 =?us-ascii?Q?rIANXA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E6xoMI590ggKcA6t1uqXNjPvfzovLqY09Wve0btbH65htqGw0dVnHl//dyafpGlJybLEccZynpF1KSBe9YoBhZLIv85/h42FpPx1sx63rNYzVjESw5t3b4mxshrBQGJl5tKwf7WCcD0mbyy2dYcQxIr+vwOWdrQt3eWpdqU0ak8FQ+HpWlMrewzU6NQURsshzi/wg2tUPROUFZnRJFwo0AgPx+8zF8ruML+qBy+T/1lBlatnBYB4IIoF7D13nedhczoJ3VivxccbmLpRPcnRyYi8/EaKGgkCsvQ7XOZVifBlrrlZNTbm19v6lzL3UKv85p/5KChW9DAoESXY6SbfcBwkGYuj4bKQZU1zM0M3k6bEcbWUCBsWeEXwELdPCJEy0Hwi42Shyt19ZbFx0TwobSoQySf/8KLqKOWFGygfuN6QeaFyvfT2S/S0wU+cLXQmx9NN/TmUCZAo3ZZ2Qjrca6FYM2gSkloMK2LxNviNudt8JyHbmmxgBe1GsMWC3JZrJ8dSI0F/l/RfuIpEbJA+xZqaSZH7RzpgT7ZuYOGuVTZi/dllOaTBK+ivts0DIjjCYw8zh2tW98fzZZqnAn3N8QGJIDdO98fHJIUyRPxH5wM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d4e741-67d9-4b97-a855-08dd1f09ac68
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 02:14:16.5794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sn3bNq2R0VKxa384IJFKM7nepbsq544WLVuwVfBV/+v/ZYPtVH8l7HFSWqOdKEGGJxPyvEkiS12RFog4zuXcmEcxkEdUrX+daFPyFhc1D6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_01,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180015
X-Proofpoint-GUID: -qYP8GaSCPDI3qsPQlkDZijRTbWP0zB6
X-Proofpoint-ORIG-GUID: -qYP8GaSCPDI3qsPQlkDZijRTbWP0zB6

From: "Darrick J. Wong" <djwong@kernel.org>

commit 150bb10a28b9c8709ae227fc898d9cf6136faa1e upstream.

generic/388 has an annoying tendency to fail like this during log
recovery:

XFS (sda4): Unmounting Filesystem 435fe39b-82b6-46ef-be56-819499585130
XFS (sda4): Mounting V5 Filesystem 435fe39b-82b6-46ef-be56-819499585130
XFS (sda4): Starting recovery (logdev: internal)
00000000: 49 4e 81 b6 03 02 00 00 00 00 00 07 00 00 00 07  IN..............
00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 10  ................
00000020: 35 9a 8b c1 3e 6e 81 00 35 9a 8b c1 3f dc b7 00  5...>n..5...?...
00000030: 35 9a 8b c1 3f dc b7 00 00 00 00 00 00 3c 86 4f  5...?........<.O
00000040: 00 00 00 00 00 00 02 f3 00 00 00 00 00 00 00 00  ................
00000050: 00 00 1f 01 00 00 00 00 00 00 00 02 b2 74 c9 0b  .............t..
00000060: ff ff ff ff d7 45 73 10 00 00 00 00 00 00 00 2d  .....Es........-
00000070: 00 00 07 92 00 01 fe 30 00 00 00 00 00 00 00 1a  .......0........
00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000090: 35 9a 8b c1 3b 55 0c 00 00 00 00 00 04 27 b2 d1  5...;U.......'..
000000a0: 43 5f e3 9b 82 b6 46 ef be 56 81 94 99 58 51 30  C_....F..V...XQ0
XFS (sda4): Internal error Bad dinode after recovery at line 539 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x4e/0xc0 [xfs]
CPU: 0 PID: 2189311 Comm: mount Not tainted 6.9.0-rc4-djwx #rc4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x4f/0x60
 xfs_corruption_error+0x90/0xa0
 xlog_recover_inode_commit_pass2+0x5f1/0xb00
 xlog_recover_items_pass2+0x4e/0xc0
 xlog_recover_commit_trans+0x2db/0x350
 xlog_recovery_process_trans+0xab/0xe0
 xlog_recover_process_data+0xa7/0x130
 xlog_do_recovery_pass+0x398/0x840
 xlog_do_log_recovery+0x62/0xc0
 xlog_do_recover+0x34/0x1d0
 xlog_recover+0xe9/0x1a0
 xfs_log_mount+0xff/0x260
 xfs_mountfs+0x5d9/0xb60
 xfs_fs_fill_super+0x76b/0xa30
 get_tree_bdev+0x124/0x1d0
 vfs_get_tree+0x17/0xa0
 path_mount+0x72b/0xa90
 __x64_sys_mount+0x112/0x150
 do_syscall_64+0x49/0x100
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>
XFS (sda4): Corruption detected. Unmount and run xfs_repair
XFS (sda4): Metadata corruption detected at xfs_dinode_verify.part.0+0x739/0x920 [xfs], inode 0x427b2d1
XFS (sda4): Filesystem has been shut down due to log error (0x2).
XFS (sda4): Please unmount the filesystem and rectify the problem(s).
XFS (sda4): log mount/recovery failed: error -117
XFS (sda4): log mount failed

This inode log item recovery failing the dinode verifier after
replaying the contents of the inode log item into the ondisk inode.
Looking back into what the kernel was doing at the time of the fs
shutdown, a thread was in the middle of running a series of
transactions, each of which committed changes to the inode.

At some point in the middle of that chain, an invalid (at least
according to the verifier) change was committed.  Had the filesystem not
shut down in the middle of the chain, a subsequent transaction would
have corrected the invalid state and nobody would have noticed.  But
that's not what happened here.  Instead, the invalid inode state was
committed to the ondisk log, so log recovery tripped over it.

The actual defect here was an overzealous inode verifier, which was
fixed in a separate patch.  This patch adds some transaction precommit
functions for CONFIG_XFS_DEBUG=y mode so that we can detect these kinds
of transient errors at transaction commit time, where it's much easier
to find the root cause.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/Kconfig          | 12 ++++++++++++
 fs/xfs/xfs.h            |  4 ++++
 fs/xfs/xfs_buf_item.c   | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot_item.c | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_item.c | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 111 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 567fb37274d3..ced0e6272aef 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -204,6 +204,18 @@ config XFS_DEBUG
 
 	  Say N unless you are an XFS developer, or you play one on TV.
 
+config XFS_DEBUG_EXPENSIVE
+	bool "XFS expensive debugging checks"
+	depends on XFS_FS && XFS_DEBUG
+	help
+	  Say Y here to get an XFS build with expensive debugging checks
+	  enabled.  These checks may affect performance significantly.
+
+	  Note that the resulting code will be HUGER and SLOWER, and probably
+	  not useful unless you are debugging a particular problem.
+
+	  Say N unless you are an XFS developer, or you play one on TV.
+
 config XFS_ASSERT_FATAL
 	bool "XFS fatal asserts"
 	default y
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index f6ffb4f248f7..9355ccad9503 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -10,6 +10,10 @@
 #define DEBUG 1
 #endif
 
+#ifdef CONFIG_XFS_DEBUG_EXPENSIVE
+#define DEBUG_EXPENSIVE 1
+#endif
+
 #ifdef CONFIG_XFS_ASSERT_FATAL
 #define XFS_ASSERT_FATAL 1
 #endif
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 023d4e0385dd..b02ce568de0c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_error.h"
 
 
 struct kmem_cache	*xfs_buf_item_cache;
@@ -781,8 +782,39 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
+#ifdef DEBUG_EXPENSIVE
+static int
+xfs_buf_item_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_mount	*mp = bp->b_mount;
+	xfs_failaddr_t		fa;
+
+	if (!bp->b_ops || !bp->b_ops->verify_struct)
+		return 0;
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return 0;
+
+	fa = bp->b_ops->verify_struct(bp);
+	if (fa) {
+		xfs_buf_verifier_error(bp, -EFSCORRUPTED, bp->b_ops->name,
+				bp->b_addr, BBTOB(bp->b_length), fa);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+
+	return 0;
+}
+#else
+# define xfs_buf_item_precommit	NULL
+#endif
+
 static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= xfs_buf_item_size,
+	.iop_precommit	= xfs_buf_item_precommit,
 	.iop_format	= xfs_buf_item_format,
 	.iop_pin	= xfs_buf_item_pin,
 	.iop_unpin	= xfs_buf_item_unpin,
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 6a1aae799cf1..7d19091215b0 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
@@ -193,8 +194,38 @@ xfs_qm_dquot_logitem_committing(
 	return xfs_qm_dquot_logitem_release(lip);
 }
 
+#ifdef DEBUG_EXPENSIVE
+static int
+xfs_qm_dquot_logitem_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_disk_dquot	ddq = { };
+	xfs_failaddr_t		fa;
+
+	xfs_dquot_to_disk(&ddq, dqp);
+	fa = xfs_dquot_verify(mp, &ddq, dqp->q_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot during logging",
+				XFS_ERRLEVEL_LOW, mp, &ddq, sizeof(ddq));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dqp->q_id);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+
+	return 0;
+}
+#else
+# define xfs_qm_dquot_logitem_precommit	NULL
+#endif
+
 static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
+	.iop_precommit	= xfs_qm_dquot_logitem_precommit,
 	.iop_format	= xfs_qm_dquot_logitem_format,
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
 	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 155a8b312875..b55ad3b7b113 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -36,6 +36,36 @@ xfs_inode_item_sort(
 	return INODE_ITEM(lip)->ili_inode->i_ino;
 }
 
+#ifdef DEBUG_EXPENSIVE
+static void
+xfs_inode_item_precommit_check(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dinode	*dip;
+	xfs_failaddr_t		fa;
+
+	dip = kzalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | GFP_NOFS);
+	if (!dip) {
+		ASSERT(dip != NULL);
+		return;
+	}
+
+	xfs_inode_to_disk(ip, dip, 0);
+	xfs_dinode_calc_crc(mp, dip);
+	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
+	if (fa) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), fa);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+	kfree(dip);
+}
+#else
+# define xfs_inode_item_precommit_check(ip)	((void)0)
+#endif
+
 /*
  * Prior to finally logging the inode, we have to ensure that all the
  * per-modification inode state changes are applied. This includes VFS inode
@@ -168,6 +198,8 @@ xfs_inode_item_precommit(
 	iip->ili_fields |= (flags | iip->ili_last_fields);
 	spin_unlock(&iip->ili_lock);
 
+	xfs_inode_item_precommit_check(ip);
+
 	/*
 	 * We are done with the log item transaction dirty state, so clear it so
 	 * that it doesn't pollute future transactions.
-- 
2.39.3

