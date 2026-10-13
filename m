Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB46F4DDB33;
	Tue, 13 Oct 2026 09:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884442; cv=fail; b=W/hC2+cGDi2qTmJMgZpawbvCLfiPPhYNUGFctw3DWvMKR0uWgXckxk+Tl5UTjcKPFC14NHnFalHawpH5/yqPS+DU0+VjjJ/JmtuK5eJVkT4Q/6mW/vAkuR94m5PVKd0UYrzQsCGX8fGs7laRNgtxp25DyB7lRIuDo8qrWR62bJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884442; c=relaxed/simple;
	bh=LjQxm0tFdlNXl7xZaUKn/m/kDGyXv3bhA4iQv7WlfC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u7nUc85XHHxvnYkwSC5m1zVSohp07YU5M4O+Nq/2dxHk7BesFVgHemQdzc75OfCnpX2mThGb81JnTqeA3bGJuC1yhhBdh7ua2PTc9+p+t3ulJ5E7Kj5w1PW+NYFY4n85UhkarfHUojmPwNyWyW6b82ZXS+6IOFIZGxXFQ1fqMpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iLxoIE8Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zrS7i4Xx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iLxoIE8Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zrS7i4Xx"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CFRe1440653;
	Tue, 13 Oct 2026 09:40:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TI6fPeo4uFVjGqM52F3EOF7wswHYgfrLi3ygYD4ltxc=; b=
	iLxoIE8QZ836KYSneuaHsfYtZiuwMnoCYP/RecqtbNOr19Bg9JwOW5H1uDSDQ/m/
	ab03m5govvOyxuIXI4AXw1kG12NsE3RAv2RIrSJxA02yiVQYTZAk+uS7CagVv2lS
	LS60Dxb3D1NeJ0W7mGH/gdlDgljdAPUNA6kwDikkoY84huvYiMJsebiPJ/7e7pld
	jgb3xPcPGZ/Ar8rkQCTFbcUHth2wAdQWAX12S8KlQbayvaLJ2iJV9aW0FbTnrE7M
	fHvhGKK6EwyPPZJKIUSZBV+sR3Gwrp1Tsmhcam7g9I+XuUl7syBHqT74bJzUrmpr
	WCxn9XFd3vwpCuIWuqXeOg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7upqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aU9D005433;
	Tue, 13 Oct 2026 09:40:36 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011062.outbound.protection.outlook.com [40.107.208.62])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2e7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MRvv57ONi0VM69KGQrwdLcp8TewlnykMOmfsuuzvYCnJ85jVk74a+zxOEPBvabCXH1cJ+fMbLENb38Fnq9MLcQFPyYB3ZtjekmTfHAdBDvSorfpU8LzHLPXsiaDQ7eMmfXfmtTKAOhbSFMqwwUJUNzZANmGRavGvOzJs1zo3dK4QFAXXiqbCjy7opB4qOKTimEg4N2RMbFr8xhywrxfksBYRWLPmW1ZEOaUU8pITRs+45RvqplPiQ/Mbd89PruolbqAkkXZzcuYSjB3zVvsTILi6Gii26vN+edNkjvqqFpxvyM8w8v5hp1KFp6mPTn9QjcvziWob7j3SBqRTJ+Rqog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI6fPeo4uFVjGqM52F3EOF7wswHYgfrLi3ygYD4ltxc=;
 b=fwJnUrspgpd3Nwln9Q9QcrKvnsR6NWJ/qBlUT0JOf3PdPsbpYCXb+O3ATUDpHOVBi4dJ9so+iY1C3AamWdZVqj5UuPFb4j58fVtntD4jCAfU0v2SiH/2x5HDx5DSXbL5T4F2XczdeOvMuG+yHZNclvgnWdNYRt1l+iR3lRh6HO4HLchLfDDCbtovB7GsWWrMp7L2TY9MYR+WYd276axu1nOOMiCkVamLvMdReykUfNzKqjsPkIdoeimyJmxbaMiub2qTXiKR8mFE5mcwN5AP1cg5ZWuRlZcbZI0jEJyIXRsx12eqgRpb07kklGlU2Uk29YplqVvxX8+x8XcWadS+7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI6fPeo4uFVjGqM52F3EOF7wswHYgfrLi3ygYD4ltxc=;
 b=zrS7i4XxpN6chl1Kbp2q1KE9o/fmOAbwqpwNDqiejd/I/9CR66v81xuPbuq1ZqDW5sFvnuO3q7a8eaUkVArvBkF60FOzVtHTpMCl44Nl1qnMFy+pcRO54cgUVyNeE5PsQCAeHTcVAB3vdvjGfC5d4vJbpgONsbeWTasn3408UCg=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:40:34 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:34 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 08/19] xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()
Date: Tue, 13 Oct 2026 15:09:37 +0530
Message-ID: <13b4cc126c442be27d657667dd674b5c3ba1513b.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4PR01CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26c::8) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: d60db228-238e-4703-e233-08df290e0776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	lGAb0k+gwmqezvjO3Fe4L3Vnu+QGcknWQ89qgK0UdThw7rEzDwV3gXF1lNh0NUg8RXEqXIOrXHGesljvVKp1aU7BPeZqSI1VJK74jevcfk0LNYSQp4qwctZL9rDlneAtzkC6FxxWTPy/VCYV0Mr2FAIhI9VeIBU+caYFS855jyXkm8HqZKWZ+dE9On4kLj1p5zmk+EVOjt2pGMYK6YlwH+3Go3ZRb1K/IBr8HMQuWSuAZj3n+wz6rO80joVtwnptvlAxuabOJO93NGyeQ8WTXBB3HcXUcj87rOeuStH6/Kl61ww1JK0s6w4vlaJESbHiyjB20vuaixxM+I0u9EYABn2Yb+guoKKMNdMUC/3M6TV6zRnYzu9IkJWrYWCFzyS7ZvGuhFGrmRFlVBnhYrkZ2mUDIgzrCQuBIgbFPdRw8wgPpldGuFi3nkqixuY7L26uNyrFEgwsriZ/m/1aN5Iv54J9EZI73OvAiP1f3d6lN2AiY3VsmtUcEchbfnTeuSlGdOuwH7HU+R+CMUOYnDIduFJW+v99w+f+gsX0PqjZKY026sOpFuOuxFBxDU3XDyOcjIrxJA7n3XXx45Lm1V3so89zBKTA6yVZ/uKstB0VMtHLdjbGx4bfrzKuZmtixF3ia6yLmngCqEQUle9XIp0a+qi7HzZfixwN9oUl+TdQAj4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?arcIzSdlWPSjnq1ykCDMS77LHkUWbMf/qvNYwhNwf71spMW3hMSMlHY2s3+7?=
 =?us-ascii?Q?IEn+yPQYPISUk4F7tgSvxk2sZ45wcRwhC8iesz6gHEeMZKckTcaRFgMTeVqU?=
 =?us-ascii?Q?zZ84AwmuRfIEDNOfC5i/IiHLtJCwdzitoYHXf8Xvume+hPaSZc1BH3JeaaLj?=
 =?us-ascii?Q?gknCLO7at/3vhyb/V8rwbuEm0t2tsBg7fEmCveYEnC7U1SyXrXe2J9DyHc18?=
 =?us-ascii?Q?p7O4PBjyYwT/NSwZ/W+9gkfBlnr6RWkA7x6+gKcHyl7mPjlC2Ci5QGSZToqa?=
 =?us-ascii?Q?B5/nkIy95HvPsogVwVLMjSYFpM7+lxsIeuPMf3It8KT5BVbfACn7G2l7d1r3?=
 =?us-ascii?Q?X8xvwAIqfIYs66+93r45PomlAdflFP35Wcycu95vKHbs3pWQHFIbAmLxNk5X?=
 =?us-ascii?Q?jloyjA25gTPZZFAL+TB1KXTRcTi1E3EE5KjhNrsLcHLk+/d16gDyKKsyQ435?=
 =?us-ascii?Q?2lCSJiSXTkK0Wve3ta4D6TNPAMfI4THDVoPHRAunpdDlGKGnTUsPmJllolGa?=
 =?us-ascii?Q?/0jJ4P5YFOyneMAYKJhxbCJYeeW5evBxULNrG8XD1yisX/aaGKI4By4A+poL?=
 =?us-ascii?Q?99iOdXMogBT+20lKCvJSNmIHDVlFhGfQAvd2b/bjAAe1AClqWrBQbVIwz7f8?=
 =?us-ascii?Q?3+biqhDzGPFeqKuDn3UCoP8BXQEYRjn/xwFd7ATllZrel7jB57YW+48w+Gb1?=
 =?us-ascii?Q?kqLHiy7p/3Htn+enC6iLcF/nTeYYEuReExkDERJ+hRbY3trmM+MkJQ9GWkII?=
 =?us-ascii?Q?buh6Evf1tbwjaKV2zotxPSkQE7SOdgGFC/nUDzEOrhB2e4CfyEPgFQ+QOP9b?=
 =?us-ascii?Q?Q1oCFIkuN+bFbBUfHJbAoZZax58JB741R1axIsxpERFnE+EPuAbMDRRFclma?=
 =?us-ascii?Q?11+hWAcH4i7euEBwbYPDYkzlXrWqkWxZGHRTvTwoE0SJmW8kHrIrAPAM3V8I?=
 =?us-ascii?Q?ehAdnn2kF6h5CThvpiB2xhZZPc4Oh8BalGIBwhf6XRCAZt/U9Y6yPL6CoUR0?=
 =?us-ascii?Q?oeLXi0ngrMI3bHH0n/qP2DXYQhJUiTov7lMZ/bpS3GHyXtY0Nch//XfHn3sb?=
 =?us-ascii?Q?Vh/CB43OlJ0w8e+u9kFlW/dsvuArshpGE0D2sYv0gGihaODnDTxz9v0dHdan?=
 =?us-ascii?Q?LBBD1NwheSd+53NXXUrtBG+6p99mbQoZ4DID0W9VcfCngBQfWpCOu8zGZ+Xw?=
 =?us-ascii?Q?5O/5+jre4JkZzm43tAyi03U8acGKZX8G/fUNlx7eOAZBu0TWA0lO7rIK0U1m?=
 =?us-ascii?Q?lNxYasQLEpeePf+MPl//j/Tylj1OsmWjdaQrPaYmPxZ1NRAKl4LAM3Q88IlA?=
 =?us-ascii?Q?VSjUTAsOvQu+b+q3NLC80lLBKEip3czwliRpiCXU0EVvjpyoWzi3/W0ewkAC?=
 =?us-ascii?Q?r1uqqFtJxnK2Hf2IZxJKvy+vzW/1xJlmlVHU3VmfzoG4qIYPG7p0oFhZ73k2?=
 =?us-ascii?Q?PjiSDotHuVWX/ojIIDWQGkOR0dGI1ELiwbdXeIm1Z5XBzJJP3ongZby/2FOV?=
 =?us-ascii?Q?5378oDGhDXBupKfeAsgrVDLTmeV5wvmfGAL6JpaP4iS7WjeACSMZ/HtSHpdu?=
 =?us-ascii?Q?A8DVSZ/fX8vrbHGgb3eVlgy9smmBpLE8WwdJ02+QvGrViIGdl/w6NZNp4Aq6?=
 =?us-ascii?Q?GqKjYQFKDkSydhjcwgEdToNbqivYaJL21OCiuqeEqOfzH/Oh1t5Lef+Wy8he?=
 =?us-ascii?Q?STHFjEPi4wEoVXUTU2JijzJx8pr9mqCxf6Obe4zGTkBDCH1vvUH2cE+Bs7nD?=
 =?us-ascii?Q?m3b3bHKqKZ8QxjADEH0Da80NYoGMBKxX+3/ehsl/KDKNLQ4itup4eYXznJ4I?=
X-MS-Exchange-AntiSpam-MessageData-1: y4PyaV75hFOfL10FSNeGSPuWeFnZmVgzsZw=
X-Exchange-RoutingPolicyChecked:
	hyXRdoLjxAqEt8cchYZWWvxKDM/pqCK7u0b2axLu2En+6aqzjFXzciHH0cC7WsP5DbYr5Z+MH/JV5Zj97eEbMQ1MOqvvwig0SRCXf1O9cR4zn6pC0dgs7RVdmgfR8SzJJtUstZWgV8xlSUfKKIeMIyK+SAJUz91wB9qZ1OvgLSk1o2f6quL1fXYnOGeu+FBLMFp+gXfD179Z/HMBvM6HXaBL3ovM+KpHfiFDhOGKfpzGPqQqlF6o9MvBvxnSRjuZGfdxbqvzdK55Dkpe8jZDpffS4QmK1HflG6/TQAjIyEnJ/JikWLx5LM2sjbJbtzbvKCNiwTf1JvrOqWMu89RJFg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sdsKmtuDWo4A8kMlWjX2C49qEkw5E4Edpg3h90CyBVYBLSvUG+UHDx2Gwio1L7ae5qZHensqXeGBSdUziq6eYrobNhuG7xgFERrxtAiP8GF/0IJlT3ltfjaemsTJWk0uhNej3/5ToNrrCO39jaxp+ddsFByDJtTBnbWlrhhNrqx/vs1j2FoWI5QMqMO1HXuVWSfbCl5SCBh6Uqe04NglLl1aWEQtWRZj8fDozfEXe3BeGLh3i8+4srYbriqXFXuH0tCkLTzYNoW3epTmj43XjfFIZvKYYPuUq94+Jd8oiopExrPJznaxf9xAOkcD5qHEQgzK22DS0nJeecroQLVfFaQRn8UFqg5r/AYi0jkAe2SYIuDVTqVhWwjL18vy9Rd0k9X+A4dVJ40yBXGFooueYi+efyweWVltiiZ3otVX/igW5+/TS2iPCuw5Z1V6Hx7NVkMPuAnNZVJj6pw6pDAcRwYpeQoz3UsjXaPAnhLxfXag7LRez+Iw6fJwAfbeSu9ey+nEEQID+n54NW5Vku4+dZe2bJa/ozr9xknR4RMGkQbb1MEwluCj11Gnvm5Dll+WKfbxoolqB3y7YC7nkoFKPOSX2Nxqw3BLogEE0SsRTR4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60db228-238e-4703-e233-08df290e0776
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:34.3097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkLGuMd1IwYanLpP4nCTIetENcesu9jOit6XkyPiBikTO7ey8ZTXiCVK9IE10zDFls6nVrD87Xg56Nw21PmS+y1BoBbRVIdDvBqN+DzsziY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acdfc95 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=28ojpAUaEbF8HSBGY38A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0WqYV09KWBzf
 HghM5AGyf1WAgyrcnHhV44DvKgKAp7EELmoJhwlGPBNQtYe+lhdlyri8ZrOVr+8uhyFxfKFPtFE
 PhesAPeir5a+EU633y9TXxKz7AYo/Oo2xftKVeewpM1TjnHHJSw94YPzcAV9ll/Fms2HOh0jrzn
 D4ZymFu23L7rf1n+IxJsR+b8bfO/YCWjGtRX8rE0I70vYxCQIin34Qx71zeS9BA51e9fWin0W82
 IopAQUuDPcNp/VW1X7OhSWryRVNWROltkIupuqZWx1Ob/nP92kjJMZVqBez59fi55LsUwp9acqh
 yDa55wbyb6TVHaiAhjKE2WrLK/QqqAZlOR3S+PM+4LqNccf5hESh17rRaUiQDXD5Yx7LrpfxVYN
 kJnPFiDkYJHTH1c5ipKOFKJ6pnLgDce0wDBAPuayR9hnE7bZ6Xlecr3j0ZwOCaEkxVaU3p+N9Ne
 L0GTIJqzj645mVWGkSA==
X-Proofpoint-ORIG-GUID: YMNEy6TLf2XI2VCENeM4DVMG5H7HEQbI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX77tI2EjmYLSU
 Djz1Ia62DG0+DawojfuayW68XDRUNHebl6afkWYl0p2pBiF5B4njKJDgZGl/MjPIMKjMQhOTfN7
 OEI+aprL9oGZFH5gqTobns5EzvFNrDgcLeQQTmjRwe5bT6+uxems
X-Proofpoint-GUID: YMNEy6TLf2XI2VCENeM4DVMG5H7HEQbI

From: Dave Chinner <dchinner@redhat.com>

Make it less shouty and a static inline before adding more calls
through the log code.

Also convert internal log code that uses XFS_FORCED_SHUTDOWN(mount)
to use xlog_is_shutdown(log) as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit 2039a272300b949c05888428877317b834c0b1fb)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflicts due to the following missing commits:
	956f6daa84bf ("xfs: add iclog state trace events")
	303591a0a947 ("xfs: cover the log during log quiesce")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_log.c         | 30 +++++++++++++++---------------
 fs/xfs/xfs_log_cil.c     | 10 +++++-----
 fs/xfs/xfs_log_priv.h    |  7 +++++--
 fs/xfs/xfs_log_recover.c |  9 +++------
 fs/xfs/xfs_trans.c       |  2 +-
 5 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2b83b2b7786b..bb57a125eae5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -244,7 +244,7 @@ xlog_grant_head_wait(
 	list_add_tail(&tic->t_queue, &head->waiters);
 
 	do {
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 		xlog_grant_push_ail(log, need_bytes);
 
@@ -258,7 +258,7 @@ xlog_grant_head_wait(
 		trace_xfs_log_grant_wake(log, tic);
 
 		spin_lock(&head->lock);
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto shutdown;
 	} while (xlog_space_left(log, &head->grant) < need_bytes);
 
@@ -361,7 +361,7 @@ xfs_log_writable(
 		return false;
 	if (xfs_readonly_buftarg(mp->m_log->l_targ))
 		return false;
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(mp->m_log))
 		return false;
 	return true;
 }
@@ -378,7 +378,7 @@ xfs_log_regrant(
 	int			need_bytes;
 	int			error = 0;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -446,7 +446,7 @@ xfs_log_reserve(
 
 	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
@@ -794,7 +794,7 @@ xlog_wait_on_iclog(
 {
 	struct xlog		*log = iclog->ic_log;
 
-	if (!XLOG_FORCED_SHUTDOWN(log) &&
+	if (!xlog_is_shutdown(log) &&
 	    iclog->ic_state != XLOG_STATE_ACTIVE &&
 	    iclog->ic_state != XLOG_STATE_DIRTY) {
 		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
@@ -803,7 +803,7 @@ xlog_wait_on_iclog(
 		spin_unlock(&log->l_icloglock);
 	}
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 	return 0;
 }
@@ -913,7 +913,7 @@ xfs_log_unmount_write(
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -1013,7 +1013,7 @@ xfs_log_space_wake(
 	struct xlog		*log = mp->m_log;
 	int			free_bytes;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return;
 
 	if (!list_empty_careful(&log->l_write_head.waiters)) {
@@ -1479,7 +1479,7 @@ xlog_commit_record(
 	};
 	int	error;
 
-	if (XLOG_FORCED_SHUTDOWN(log))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
@@ -1561,7 +1561,7 @@ xlog_grant_push_ail(
 	xfs_lsn_t	threshold_lsn;
 
 	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
-	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
+	if (threshold_lsn == NULLCOMMITLSN || xlog_is_shutdown(log))
 		return;
 
 	/*
@@ -2779,7 +2779,7 @@ xlog_state_do_callback(
 			cycled_icloglock = true;
 
 			spin_lock(&log->l_icloglock);
-			if (XLOG_FORCED_SHUTDOWN(log))
+			if (xlog_is_shutdown(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
 				xlog_state_clean_iclog(log, iclog);
@@ -2830,7 +2830,7 @@ xlog_state_done_syncing(
 	 * split log writes, on the second, we shut down the file system and
 	 * no iclogs should ever be attempted to be written to disk again.
 	 */
-	if (!XLOG_FORCED_SHUTDOWN(log)) {
+	if (!xlog_is_shutdown(log)) {
 		ASSERT(iclog->ic_state == XLOG_STATE_SYNCING);
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
 	}
@@ -2878,7 +2878,7 @@ xlog_state_get_iclog_space(
 
 restart:
 	spin_lock(&log->l_icloglock);
-	if (XLOG_FORCED_SHUTDOWN(log)) {
+	if (xlog_is_shutdown(log)) {
 		spin_unlock(&log->l_icloglock);
 		return -EIO;
 	}
@@ -3720,7 +3720,7 @@ xfs_log_force_umount(
 	 * No need to get locks for this.
 	 */
 	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
-		ASSERT(XLOG_FORCED_SHUTDOWN(log));
+		ASSERT(xlog_is_shutdown(log));
 		return 1;
 	}
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index fbe160d5e9b9..407e80d06bec 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -576,7 +576,7 @@ xlog_cil_committed(
 	struct xfs_cil_ctx	*ctx)
 {
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
-	bool			abort = XLOG_FORCED_SHUTDOWN(ctx->cil->xc_log);
+	bool			abort = xlog_is_shutdown(ctx->cil->xc_log);
 
 	/*
 	 * If the I/O failed, we're aborting the commit and already shutdown.
@@ -827,7 +827,7 @@ xlog_cil_push_work(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log)) {
+		if (xlog_is_shutdown(log)) {
 			spin_unlock(&cil->xc_push_lock);
 			goto out_abort_free_ticket;
 		}
@@ -888,7 +888,7 @@ xlog_cil_push_work(
 out_abort_free_ticket:
 	xfs_log_ticket_ungrant(log, tic);
 out_abort:
-	ASSERT(XLOG_FORCED_SHUTDOWN(log));
+	ASSERT(xlog_is_shutdown(log));
 	xlog_cil_committed(ctx);
 }
 
@@ -1041,7 +1041,7 @@ xlog_cil_commit(
 
 	xlog_cil_insert_items(log, tp);
 
-	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
+	if (regrant && !xlog_is_shutdown(log))
 		xfs_log_ticket_regrant(log, tp->t_ticket);
 	else
 		xfs_log_ticket_ungrant(log, tp->t_ticket);
@@ -1114,7 +1114,7 @@ xlog_cil_force_seq(
 		 * shutdown, but then went back to sleep once already in the
 		 * shutdown state.
 		 */
-		if (XLOG_FORCED_SHUTDOWN(log))
+		if (xlog_is_shutdown(log))
 			goto out_shutdown;
 		if (ctx->sequence > sequence)
 			continue;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 42cd1602ac25..6e619b34c6bb 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -441,8 +441,11 @@ struct xlog {
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
-#define XLOG_FORCED_SHUTDOWN(log) \
-	(unlikely((log)->l_flags & XLOG_IO_ERROR))
+static inline bool
+xlog_is_shutdown(struct xlog *log)
+{
+	return (log->l_flags & XLOG_IO_ERROR);
+}
 
 /* common routines */
 extern int
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 527facd5126b..46b1213e8ff3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -145,7 +145,7 @@ xlog_do_io(
 
 	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
 			BBTOB(nbblks), data, op);
-	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp)) {
+	if (error && !xlog_is_shutdown(log)) {
 		xfs_alert(log->l_mp,
 			  "log recovery %s I/O error at daddr 0x%llx len %d error %d",
 			  op == REQ_OP_WRITE ? "write" : "read",
@@ -3288,10 +3288,7 @@ xlog_do_recover(
 	if (error)
 		return error;
 
-	/*
-	 * If IO errors happened during recovery, bail out.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	/*
@@ -3313,7 +3310,7 @@ xlog_do_recover(
 	xfs_buf_hold(bp);
 	error = _xfs_buf_read(bp, XBF_READ);
 	if (error) {
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (!xlog_is_shutdown(log)) {
 			xfs_buf_ioerror_alert(bp, __this_address);
 			ASSERT(0);
 		}
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 73a1de7ceefc..d334bb3ce643 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -901,7 +901,7 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
+		if (regrant && !xlog_is_shutdown(mp->m_log))
 			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
 		else
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
-- 
2.53.0

