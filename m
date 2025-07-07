Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B249822A7F9;
	Mon,  7 Jul 2025 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751894240; cv=fail; b=oXqIKXAnbo3xC4JEaBD6d8GJHdNjpJg3p5T6KzXmxCFyQvvjpF3s/zZVRqUKMIskMmrofEfS5ZU1rIThkdNGa5YIGREa7Z/zlCTDplGaYWolxLiLDMJTsu/zcd2Sj/F6jIUZQrXImWXcGAFaISLfr2OyLU17cnF8lYu3D3EVB6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751894240; c=relaxed/simple;
	bh=T8aKtHZ5k7ZD/Ewv4+4mfasvIN9SOkxZciSULt1kvN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V7R9b52ncVqLxjSXg+QXb803zzNzExr5nWtZIvKn9TT6D+t5G+R8odExppLLg2cjkXQvWM7y/iVzxx+m+AuLN4NOAFhaJsmDYw7fIXAy+8/ElFfUOzR4xGwEgZCVPyvsTjFuxjs4bXtJPz0COBebvS4CSzJgzsD8VsNKYquSxC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XgnCfdON; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JAxQD3xq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XgnCfdON";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JAxQD3xq"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567CpghD007212;
	Mon, 7 Jul 2025 13:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LBh8aaNl2XS1fgLcvR1qm3BqHnXvvnqOY73f78WI20s=; b=
	XgnCfdON5Ri7OMxiylF+fYtNTq6Xb0WjInmoati/ZRC6zVykwYrF1xHLa3XXtvzq
	Jpn9cKp8yXIs9dEnFrcQiONSzsQxsrx1hRTkwRkXiCKoqr7oE66x0sDuqDjnClRi
	FJIAXXzKBdNGXm+A1OKRWXEHHVE0QftzyVduH9trUcGx3gkfgyucvtyq18NQLEnO
	9IoFffG/lbaPi7aksziz+H0MLCjjN7QBSHt9kTdfKGaGuPjYjz1vMFtbHlqimxQ2
	qJTHamXC7irxa3/h2Ttb+CsGBcQc5BheFRhfALE2IWg6gRZ1J0+1bP8ZXAgjFD4r
	kZspli3HzAYokCF1C0knZw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47rem4r1fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567DAERd024335;
	Mon, 7 Jul 2025 13:11:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg8g3sn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVPXMjtL0QcYmRacJneha23kcRdKBuYSJUY618HzjSgrU2KHcycO3NYgg5boIFlUOjbqgSCU0h8UCrD7iy8PUjwHxCS4n89zL5ZQwRfLYjI0Nx8U+ARnyd1BKp7DeDFEkA7KlxcBGFHwm8zqlnT2t8h6Kz7sG8KQjjCs7LgMtrqUhIWhULpeCNchJqgdlEBIgSIajK5RTnmHy3vZh9sQ/p6c+WqKaQ47klF9W0cMJXm0F/TqLOEAnQr+HWngH0S1Oy45EEbnDL20Dn5yyJiSPbAyNHW/zomSFTkHs8SO6eAhcL32YcuAnUFUJwaXglgF26YYZetM3R/xPDC87ayotA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBh8aaNl2XS1fgLcvR1qm3BqHnXvvnqOY73f78WI20s=;
 b=jc0yZ+MY9DqjjW8kiR2sfll3qNq+fVoOyEiXUqgu+opfpcqL8wkyICHjDD98wQfODtKinF5j2Gr7h5D4yLlZVpDGStDfVvO41UvNaqvr51A8xbOAGbHPIHpgFff/OZ00G5JVZVna8etHYrvNBHWAt96C/Opd9CMzgUh1BDBEeew0dhET4owfuy5faEPR97DGa5W1cKlwwKJQsOKIfqebTvmgVrRdhlUIskXILkCmumeeiRXJvAdN0eCARU4wjJunhnwkqdO7HFwmQUcI/hucG5pfrQ9Jtmwvlj8wr80pO5rFeAZyI9AZ06A8F8UEzO6hdWuCKwumgmTN8nvZo0Yerw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBh8aaNl2XS1fgLcvR1qm3BqHnXvvnqOY73f78WI20s=;
 b=JAxQD3xqr6nZCBRDo4ax4b1OYmUiwsfdyA6PN7v9wKXPQn0mQRk3OANZjge/sVh2jc1OhQGd8aJo9CHVmIbWLUGmVnSVNIzzmNfk/+g+Atn8PMDqq5fkzqrlHlw+LMi6Wns4PqfcthGWSJAJFvRCugHhX4JvhKPgn0L8HiXuBL0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 13:11:50 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:11:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 1/6] ilog2: add max_pow_of_two_factor()
Date: Mon,  7 Jul 2025 13:11:30 +0000
Message-ID: <20250707131135.1572830-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250707131135.1572830-1-john.g.garry@oracle.com>
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:a03:114::23) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cb11c95-060b-42c0-bcb6-08ddbd57d581
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B8buy3GcSbXvdKvMpmdrxMnkOobdt6AnvYZ4XDDnQIXCe8K0YivTGq+F4r27?=
 =?us-ascii?Q?RnZ4GKXH7fFgcFyiywi1jwQNLuKOCzP2GXEe8ScdVoDaHFa/k45zCt+Lpss4?=
 =?us-ascii?Q?qn8wCV/MjQzegaWFC5CsUrWbhMSVHYoKDGeSU2x91YwTfjvPxdD91PkUHxYj?=
 =?us-ascii?Q?7UNpIRcC+Tg6+U3qFB/vRrILmuGVhaAzJe7SrVTdtmaaOw7a6LUkIP6sbmcm?=
 =?us-ascii?Q?ykfioF4jxYHYlzs9XUzaGbLaznedm40aqluscVaTHEHQWFp89zIr5Aw/zBSV?=
 =?us-ascii?Q?HhTJXhlklA7Y/xy6ysmsGZ0roiLHFuZU1HTZly/4YRsx/7ZtSN3X6zuzOdn0?=
 =?us-ascii?Q?M0eJtjU7lPpEvzevpgZEJydGTiSM27GePE93x4Mfj/HuhvBSEXinGeKJ0awj?=
 =?us-ascii?Q?2nCux3tcUYlyzR21z/RbCbf3MOhrAYtsTON5NQC/nebtpXe9FPUQgTtyHc5v?=
 =?us-ascii?Q?Mu6qWCJuRw6AUqJ7JUdCmHBXmlb2T2QiB1u2vjmlhJqBWBpRrllOWIv7SNq4?=
 =?us-ascii?Q?anW/Da5DodGH4M8gQLeI4SQRy0AbBp80iut85VnH6WVqlY7v5pjg/zzQuwBT?=
 =?us-ascii?Q?kTqpUb0Q6x0iyiMEwQixCKN/Myh5KhH4tjbGbX0dwbeJWwZjSi6kAgLQQUj9?=
 =?us-ascii?Q?B+in6Xz08pwXvcJdl8ZCnUrZfpmRbQ6mEcAUv1aQhJ+PUTgVFgRs8UYy3HeC?=
 =?us-ascii?Q?ZdaTKRWRr3YvImoDUqsrZlr4CBe+N4X0v/q00Jdvi5ZHVEOO9uFjo9pQ5wSl?=
 =?us-ascii?Q?qjDD5tjnbHLu9waxFg+lYwibidm5+IWNP44bJetXN3MVBOJbCwKIppx5AQWg?=
 =?us-ascii?Q?CdopCSvY8iFM9hNb8txJXtA+oySKZuQg+2aRZHGvXD3PlThEsCesRisH7Oj3?=
 =?us-ascii?Q?acxSjJrYTCy9JNE1lPn2H3Wsv88lak3XufSXLrnr/Slsu4iN5sSPWu++ibkG?=
 =?us-ascii?Q?3yeBBr4aFMUsVKiRhgLSdNOUnS2DE9UNJnN6Kx5TysQvn9cPF+6D8KppfRwh?=
 =?us-ascii?Q?99gjWizOTADoYMg0aIiH4mtLZ/2bvR+hlo3+6Ak5EieG7ugS73zbvaMLUQq5?=
 =?us-ascii?Q?7imtM0vaQEX8Xq54P3OYOwmeOBZ4ILAnn9BGhUhS+5OZ2AqoVpdfPK398F0R?=
 =?us-ascii?Q?ZCws95PV9Igj2DaiuNz5wqvbpDxfCnQ3BeYhdZVikS49CxThnc4Omm2kwjIF?=
 =?us-ascii?Q?s9UI5Xw8sZcivVTQ6JHZ6fU6FR7zmawLH0Gn3V/CPI+BTQFXu/rqABq0ov0h?=
 =?us-ascii?Q?w2Y2sU7ZPbI4jLb9qpF73h6Am6FUDgn3q9WdpIeAwA/lXjn1q+l1dmKAeXBH?=
 =?us-ascii?Q?SnVprjwbA62IMqdV1mIiP2hV8E/3Ja5POo9IY4cl4+MtkUVgSF2sX25zC9l0?=
 =?us-ascii?Q?ogPeL8CoC03UgA30byiNlMfqBGNkjzXEdyoJIjTeaeXNItguXOzuvehSDB4b?=
 =?us-ascii?Q?Dfni1fffVc8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q4KGuUwAAwHrrUWVrHPI4FIh6FednmQADVso0/ZXbRx9MxjysiarVK/6B9r/?=
 =?us-ascii?Q?00ZA3RpKa9oaVxWepatYIypKXKlrFwndJIkfknA5lvpw1jZJBObkwghHOm9g?=
 =?us-ascii?Q?PG2OfHd+7MUa1TSUqgwQDDGC65HEgfCb4pO8K87y+DeZ9oCGDGHghHztDqak?=
 =?us-ascii?Q?SWOFG30ILZntZunIu5s7IVyHeUSVRhBjwFQRs8TZPJaSC/v7TMHbsXRIkeO2?=
 =?us-ascii?Q?GbTGa2kTcILosiJOilqtS7Kv/V+k7JrSQwmGT5F6jSqDgzXgXybhdeC81vrW?=
 =?us-ascii?Q?W0gdnUGFe+P7nwxT0d9CECHbC7vRl3WE0VXo1Sc718jkN3FniWpMW1Bky037?=
 =?us-ascii?Q?bpf2XGfLJWZ+nQqzvptWRTNGTZ2p56mZghLx021kj+NsUFLmy5VekoRXSN5S?=
 =?us-ascii?Q?GDvqBHB3y95pPQK+3z4hNwOFzzpCFNHL87F0LkPGVaHjJ2KdHnXecrs+wPJd?=
 =?us-ascii?Q?Xel/6jw0Kgv5SmrG6w0DmBnPdKlvCVG25AcJyeXgzymW8oLEYqnPY/m37Dro?=
 =?us-ascii?Q?8m1Zk6txINAElup3/d3sNSoqz7DQp0Ccb8UTTSYJ7opvHx5uP+ltljuwUQr1?=
 =?us-ascii?Q?mJuTaauiBWeo8mlInPanhfbiAFcmCGePk5SSQ7Y06+rmSPILzpx9nHMCD2qW?=
 =?us-ascii?Q?qycQFIQo3aKMp7fknv+T3Ye4Ee23P0bp6CSMVc9UiOih8nrt/B6vvF7xxwpx?=
 =?us-ascii?Q?Esw8psiicNdSwSJ94TzF9IE7J6ItwUUxC1E9muu6qLtnleZgi471UJE3m5mi?=
 =?us-ascii?Q?xIeWjAr+9r51T9VXqLTx/GfdTXQPRtBqgTkocJXx0O+3MggtbEMyKW1Ev78n?=
 =?us-ascii?Q?rAGcDuuPqaaBCmC9aJqLNd3a9DAnceSXQCSfvbTwN5fTGuSqSXra9QZ8wab9?=
 =?us-ascii?Q?HK6xQZFYXafjVtePlkhct0no34zoPPqayKBJYFe1rZEXpPR/G94GfGS4V1fy?=
 =?us-ascii?Q?Lx6f8l2mjQXfleV5LT9qldu/9YtajcYj8F4OF574eWtJBFmyBbtiGwesfG1i?=
 =?us-ascii?Q?/RISlbLNJ8bz6AuaTlZuMhY3Q7Ku8xxGkarV0bCIt4LC7gqQRH6tUgxi1ke4?=
 =?us-ascii?Q?RBp8LIt9iLkN3naV4qz1kIC+GvfP+7mER6hFsgF7h7ZvSj3PX5L87mQhWxMY?=
 =?us-ascii?Q?iYCRxpxbHWRQXNUttY2wOsXCT9eM/XXeLDEajT38A7AdPc+hM/U23thnl54n?=
 =?us-ascii?Q?3WTwkWMOI7DBwyU9ZKNTeJScXL0nZEOpaWKc988OhjZ0DusKxqGFRfiPbH3W?=
 =?us-ascii?Q?ztbwpvghAVwFJuI6TzMDX7guePaZU7gFLTK7AYiC207k6f0vH2inP/s1M+z1?=
 =?us-ascii?Q?vrrEzF+qVmUcv5+WJqI+hQaDsf7CCIdNjmzumC0KTVsxHu5gPEflB6Bk3W94?=
 =?us-ascii?Q?Oqt9cTXgiS318KXKc0zXDV+pjbIubHr5CdI3+icgO40dVJVIZYPolJGUzOGI?=
 =?us-ascii?Q?FqgjT5hgIhCMDjUST3VXZVMm2lNJabHC1SAiRafL1ff36Vk0HUsYsTtJZ2LG?=
 =?us-ascii?Q?/TUNbaw5Vt+htbkh95foeWivBuLASvxkBNHIZHWjaSlzA1+5zQecouIf9Ngr?=
 =?us-ascii?Q?Qq0voOEDVr030QN62y/Kjnec32kZMadQG4PmB5+Oqc/reheHrVy+0XPGf6qk?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HJxB7vaYDfpFCUIJtkUPp+bJnksRLGGeyGc+OYoDfzl75IL4lLb0UitOY4dVAua69p0BlhmbWxvqrNIOgOJqOZyDNVGxhrKvI/xeagYZWW6s4CYKlCvjhlPClzUynM2thyjtjAXTJG7NrGXFfAXESng1w1vI1kdNaUdd6MWlcHfMK6KWBbyE+YFM1RZrjRIik0gqvhGb4xoInEb1IwfN3ZW9xVgT78ng4Z9V8eskotKGjY6nQZ8oqLvoIlkTpEonT3L1j9UNeB+/ICjVEEsdYeAJGZZfexiLf4/zoin02Ia7ssYvgNZ6p0hH2UdfoyCDh/O2/S6pen/pIMWw2DgZ1kgW/7vmnzQz4pGflbRmePsFwua1FP8cZAuUP78w4g4VjBpmwKif2D7iFbxU3sJ0S2yxgDveJksORKyK60d3pjv/Jd2NH5INSVusSVTsQ4TW2mnHNOQEDo3A9Oz/rfLcvMYF76cB+5g9+XHsDyFItY3wLdNX6N9OzjrRsM4BLADrhtl+TXi9wseTX8nL53HrWcw6Tp+1drCPiWgVuUFQaNm3Rq1roqcFhbz3nTACxKGAQvhtOvhXLrhtrJ+5SHZ0FX7YPzU3f3+ce0YUZq60ZIw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb11c95-060b-42c0-bcb6-08ddbd57d581
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:11:50.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0o3dr151GVwNOnBPBKdYjRqsYZmOt1+btsv2Ir0w8k1w8IYC2UB9s0cQfAkH9LZ9A4811GqJ75oXkbdR32kQlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-ORIG-GUID: NTVn_3q1R72XhrGr6nCDfAnMMBNUmz0N
X-Proofpoint-GUID: NTVn_3q1R72XhrGr6nCDfAnMMBNUmz0N
X-Authority-Analysis: v=2.4 cv=GvtC+l1C c=1 sm=1 tr=0 ts=686bc79d b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=9wh2qRDMZpkBaRsaGB4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfX+pIsDAn5Fi7Q RWEMNbDc5Z71VK0nF4aESEHww7og2znExjV9trkB5SYS0anqiwM8V37KABWArTCSnPZA2JpdyZs u+lxceeosCA8NNlcu92sdrTSuyOTHAHAslNEGODjvyLLsHnrmNL7eSHbDqY5qWJTHYU640GwrTc
 drol3UnJ5RgZ0oYfbT7Hv56LqvLpSdMR9XRzwZRN+xa4hnwH/msdiuwgXs1iGMXOOrpCthMS/LO Z1gjG20vBEImElTgvc/tkBTSEUxA+kGP+UmQmugUrm1ZtgAQfPrzKa5LdK3Ot768tgj9WMZi9AE TJCWhMobwLX4WSwpKzf+lqukC/ZSi3ETBWK5NXrJCQ7JZvXw6/8syHdqFAmqvme7ygtnLUf+w0F
 Mzuasgyo/hjRFzpO6Qa+vo2pgnrrcr80Z8wQZGfEVhrFaoLDSYPuQKqyFJg3ErQS3WrVQjXo

Relocate the function max_pow_of_two_factor() to common ilog2.h from the
xfs code, as it will be used elsewhere.

Also simplify the function, as advised by Mikulas Patocka.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_mount.c   |  5 -----
 include/linux/log2.h | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29276fe60df9..6c669ae082d4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -672,11 +672,6 @@ static inline xfs_extlen_t xfs_calc_atomic_write_max(struct xfs_mount *mp)
 	return rounddown_pow_of_two(XFS_B_TO_FSB(mp, MAX_RW_COUNT));
 }
 
-static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
-{
-	return 1 << (ffs(nr) - 1);
-}
-
 /*
  * If the data device advertises atomic write support, limit the size of data
  * device atomic writes to the greatest power-of-two factor of the AG size so
diff --git a/include/linux/log2.h b/include/linux/log2.h
index 1366cb688a6d..2eac3fc9303d 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -255,4 +255,18 @@ int __bits_per(unsigned long n)
 	) :					\
 	__bits_per(n)				\
 )
+
+/**
+ * max_pow_of_two_factor - return highest power-of-2 factor
+ * @n: parameter
+ *
+ * find highest power-of-2 which is evenly divisible into n.
+ * 0 is returned for n == 0 or 1.
+ */
+static inline __attribute__((const))
+unsigned int max_pow_of_two_factor(unsigned int n)
+{
+	return n & -n;
+}
+
 #endif /* _LINUX_LOG2_H */
-- 
2.43.5

