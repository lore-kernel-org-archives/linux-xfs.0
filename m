Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF61722157E;
	Mon,  2 Jun 2025 19:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892156; cv=fail; b=MExWXb0uRwNS2L4NAYBrvIcmGzLQcCtAzJik0YpP0OyHxS648nNXG6ZQ/NWntP/5zr7sLgaVOojtbH8iklwqyUwvXlH6hU+pGR51GJW2lRJh//J1U2WuL7PH7feIk6ww1V3dyrFgYtUKouoQq9MwbhcaYPTtc0/vxNGJ8YkelSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892156; c=relaxed/simple;
	bh=3bQqztg4JJnL+Fpi6S6cJUmty9G8bPofITidFHA6LAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G5PrlXteKShuanepSJr79r+5CweWWL/pP4x0HoY6iRvEmYiPs+rYUf2P9OWQLYlEcJHwwb/ZN6E5cCIkaHLXh+l3yEPRO2tCXFlbhiCTrYYbEFHekUTa3OuO2Br8DILm/++1GbSlHKj/aVaWcmKLNXouuinV+xeAR0fTBLZbD9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R4emFtYV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jFPNJyNq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R4emFtYV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jFPNJyNq"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552HJP5T018790;
	Mon, 2 Jun 2025 19:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aQUkZDGRfVNm4bqmaVItXK1Fmdl56RiNVAuvynKCzwI=; b=
	R4emFtYVN1MzsNoIw3MZ/4I0qrMXwxn2UcY4iOSTIGgcye0ee5hTb6kZchm0Yp9K
	XHf49Vcp0pnChTlDLHNHIst7yjD9ZgLABOjKfVA5Ug5c4f+DBZJf24ImcFa+pWry
	rWgA8GMqv2XXwOpNfo63AXVkVX+EUqR7/mrgSQBaJS/TpHZsuwI3XQHl7n8YtyVj
	WUWKiZLRTWe5vU9VlRRUBP972edb8rMJWcLM/EhXl5RR5zRJ45MYSgaHO+OxychE
	yMQsa6v55Nf5wH/uCp45GqToKh3ms2tNAchoWRIZ3iTxgI2rfNxuUFXLDsRHkOHA
	PJid8huiaBrLJ5n6HDCBmw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8j07u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 552J7rlt030739;
	Mon, 2 Jun 2025 19:22:28 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012011.outbound.protection.outlook.com [40.93.195.11])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78d04w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Jun 2025 19:22:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IlGm9ig/bfXNRo1Dd9mwO+mrOzHjydzPZIMULPHOgGy7I8K2FjW52Ll83I4OUjMGighen6FPZCeKNWbvtzs9Kjf/FFp4UPeRySkWtuw4oHMQSdlRlhPnFKIjw7qDGWGEEILpZNmdc9g/+FITBpTPm17gi7n+NxzPaHnq4VKNtQMTZaG/plOsgth1Bx9xqGPL+GoC2x/arGOKk2c4RS2Rp6IsE4eo3jpt23tIIxqgIFt1g2EXguKztRb5FNAGoNimRK+h6ZUKBhSYJanTdS48sPIIZU+7eL80N5jmYTAI/y7TqiIQJLwjD8H3wwZof7Zzf9n928Hsg2fDD5X7JqGBHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQUkZDGRfVNm4bqmaVItXK1Fmdl56RiNVAuvynKCzwI=;
 b=RekdxdwOhKzDiZk6B+NPIQCdvfxIi6CzZqQKU9iQfKnRzdQf/Yt+K5Jz/r6+NSrZRH9MXQnK4cVrtQD8MgzNv1jiU2EtX0+2rzEDiJN248QdzPTjl+hcOAnzSlUBUMuMQiJnaiQJochihejkqnb2fIchHVhCHZkiFFLNfaLHE0PfmsGFQ+yu2FYrcasWP/HIXyAtVfDZyVWBOvYLN5a39vgIboEs6Qw1SdSxzLAkNwCXiDPSP6wRGtRQolJkfSjl1lzZDqZn8seZF0rdfj5JkIOto8te/B80S0tvDt+6xj8q9unbquu7el+qVBnZL6d4bJSYhgmNDa+rED3QvI3wqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQUkZDGRfVNm4bqmaVItXK1Fmdl56RiNVAuvynKCzwI=;
 b=jFPNJyNqWScdq1Vi10Gdj2isAmJ44UEH4eRGm62xZf2Emgkz6MpFHyJ4GsSMBqJEFFdPWWPK8v8JyqZ1xG0QnV/3RzQtxCitKUDNyYlmBdgugoMydaN29iuKmTzVgjb/j893ThZOz8/x72SWHChJEH59ggx2KIHt/OViMeOzJqQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7158.namprd10.prod.outlook.com (2603:10b6:208:403::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Mon, 2 Jun
 2025 19:22:22 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Mon, 2 Jun 2025
 19:22:22 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH 3/5] generic/765: move common atomic write code to a library file
Date: Mon,  2 Jun 2025 12:22:12 -0700
Message-Id: <20250602192214.60090-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250602192214.60090-1-catherine.hoang@oracle.com>
References: <20250602192214.60090-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: 29d18bed-2885-4442-03c0-08dda20acc75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gf0cpLPA1+vxH59nzbS9rqMIV/4+2uyuQ9Mp885GjpCek/OtDkDkIAocwaTB?=
 =?us-ascii?Q?YCtoxrGR5t8nLWgRTTNUFSuCeFNNecwcklMYFMZE0DujS9KnClJ8+lgo2Grz?=
 =?us-ascii?Q?AZuHwXkKkGl7LYWq4nBQV/SX1mGpKUfxEmPqv/hihrTgY1qKE2skXSsf2J/U?=
 =?us-ascii?Q?QO7Je7CCFwdtNAlfWd13CGjy5l7OCXIT/wbe/cFTED6BP6ivLvyk0fbz+5UU?=
 =?us-ascii?Q?oJx6C4JuDIjYU6i2pV5XoQv3daSZ7PGrQyuF15uZ+hSH/E2NbxLZN74b1dA2?=
 =?us-ascii?Q?J55Q4L2BC8MwSjkKwMsuGX0HGOWuycJYSOBA4uXflElWcL+s2HYTNo0/B3eR?=
 =?us-ascii?Q?XRjp3N7jF2Fd0pYY0YOzVHHxS24uZs6Svvsgpbw9l94W+q5qSipTt99/v+Yg?=
 =?us-ascii?Q?EtyILmz5EHAYZPo0XrkZ7H77QVrPz0S+i46lC8Wkw3E7hcMDunCpiP7ipDIb?=
 =?us-ascii?Q?luaDa8As0B+kvaV9MN/vs/BgVBuI6pVZOdGrUc+fLkqhTsPiHQnYZysHWBeG?=
 =?us-ascii?Q?wsyhbRVD++fQ5KthAqo0HLtkjvQjIJiMt068rbDyB41nQlaHDZfjPxEVx1+v?=
 =?us-ascii?Q?DTTL+TkKLBb7Ww0tmxYM4cy4bcFEtAcXrEAOobUO4LnW4jDstFej+wGSITMu?=
 =?us-ascii?Q?KyWMJR5mJnqKpEt9OeJ5mQy43Xi2ncFSeiU37avwQaCcafskV5uHnm8i9Buz?=
 =?us-ascii?Q?iCiFQQwwbjH81cGcKvfq3sNEnraxUqvLh7arzJvBb42UbMnkOQ7w3AwgNzED?=
 =?us-ascii?Q?2aZ/S6dxYU4a83C8MoCy3DR6hhyF6CvCp9+6B01APnYflTqb0OWYzWKAB/V+?=
 =?us-ascii?Q?ZvG5Op9J3XqC2pUSgGAm9hRqNastdboWet5aOXgosF6Qv2867KpZW+edLb6H?=
 =?us-ascii?Q?yD29nidVVdo0NsWi5Yvwoi72BK9VnxOR+UDW3WiGm8NrNvpoFdr+fCCEGAXu?=
 =?us-ascii?Q?dKSU5Fqx5aWp90phdbKFSQE39p22H1KX6C1+1dIcpWrcjh767vN+bwA1uYSM?=
 =?us-ascii?Q?KD6KQNcN81iv2UwUHOVVpcbnCpMHhDKrNPg0SQ9hk/Kj6Ci1HfO2+hU9UTM8?=
 =?us-ascii?Q?gPTHjaGv69mnY8o3n352HjljACX5xamWrOJrsFV8nqxDZHJVN/h0R/NOGjUi?=
 =?us-ascii?Q?fGZEm/Op7SAUy6jh4xEL06F4CyXdqr8Cy+XyZEAGJ6CE1EZxYWeQf8DKClaq?=
 =?us-ascii?Q?wOnP+D1ttZJL++hxs+9DUt9AwHcn/r8HkXcOrRX8RWb0RK8TGYtylAUGh5xH?=
 =?us-ascii?Q?1Hujlc+l3cMEri7UgC8s3dAXz9EoO4IqnwdogbtU4nV8DFKI8S1LeY3XhXPO?=
 =?us-ascii?Q?iR6zLZfDZNbEiR7BfNwLjFhK7qfs4aLcAwvsk8RCB3kcyjlMhtebl7WFNfUG?=
 =?us-ascii?Q?9q8frFxnl57o5VNyzXLUzrep2oXjENy+wW/e2o2nkUkyjKRjzf4kMRiiP4CF?=
 =?us-ascii?Q?4jeiX36AUOw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kVIzBT2Ps0bMh5Z/UapFKzh0r5x7tb0DeHivc6st6mpD50+oZBf4qASFv2dG?=
 =?us-ascii?Q?o5clOZlF5e7Hli7ltLE/jITE9ImaKJOd8FsPy4rhJvPeUTVps3JOGp6E0y7e?=
 =?us-ascii?Q?mKfoN03qeRNbnduF1ZaTJrQpbDSl9ZGHXYHunS2V7Ir4abjGhlzV8PpK0/dj?=
 =?us-ascii?Q?FSTqY5PX4qdoIRL8ZjadvYkrqOnA4YS9Rz++TQx28h0jccVELVzMGD8ThoM/?=
 =?us-ascii?Q?FkxV9X8SYK7BG9emcVBruH1BgqJSqxpvXThBzc35fw914cTR/YdIpGnI2InU?=
 =?us-ascii?Q?t9N+W9+3wxMvjDNZdzKfuTgMEs744w2EOkFObCOOyYpt0e+nsq0zSWXJsn84?=
 =?us-ascii?Q?tbcC/lHY4LE7qvFXAqkgmVMJffZ5dy033Zlfep5UDjOp1yi7bOoKBLpw9XZ8?=
 =?us-ascii?Q?07Wws9nHafrvg0e1+QqNN/5GPhDYTBuGXmMWtZR2dUnHT8nGeFC6OchkkJcJ?=
 =?us-ascii?Q?6o77u8ojZo9bv3StYW4DgcGIBgyXNpzZyeyFNPOPwesMB0dnZQ96KFkL87IT?=
 =?us-ascii?Q?iGlMDEk03ru1mcSpAZRyTkmG/jlkd/IItQs/F5OAORwUFyysr/GsF16ilG0x?=
 =?us-ascii?Q?xpuYNHxAcMpAyddl7npj5dc9uqEACrpO7W4dcQRZi6KO+RQGCWu6fPcXC1hF?=
 =?us-ascii?Q?fEuJ7sBGzfipev+NrP2ldH9uRjjv0FweVWBVmqA+fn/bcpiAhCOXrITEOe5L?=
 =?us-ascii?Q?e1PiY1O8esPYgs6uJlQwqQU1wSs1QL4BYxCe9UJPghmU6KnHh6f+YatSbTOw?=
 =?us-ascii?Q?GBMUGgAXUKHjxrV1YNlCDQi3v6Qh2e3QwxR/X/Dtb3/mnITbifnfCrioHjBr?=
 =?us-ascii?Q?4zVYEZmZu194QydkPDnDI3az/xxfKHIP/rD3A/1hsAs64l5zadexordQrKK6?=
 =?us-ascii?Q?5T6HzjHOJGclKWsTspIi6CcHHs604Gma3AAsu65yEjN87ZETG96H5Xxp+vsB?=
 =?us-ascii?Q?RcprnNWsqRkwMAa2B3OZ3hrZ9ilzk0uB7P0BBzJ13GpK+21Ra58U+UfFyQcN?=
 =?us-ascii?Q?FyuyoNcv4nOIWreJx8whYCk2oerPFH9C1gpliZQVmnhYdc3t4H0aHeQb38jz?=
 =?us-ascii?Q?WtDV5Paqlr6rwGU78+b2z/Kcfegy+JS3v5TQmWHlhWRQ62/M6+MC99gGaG63?=
 =?us-ascii?Q?9zU/dMngrNY3GjIkTrF8ovNtxcum3VeZM6B4ObEmKeeUr08GqGT3/6X55fwH?=
 =?us-ascii?Q?nOJN9ARG6l6OiKYLB7ZjKX+Fq8t/FPrK3lc5OiajPzoDj9XQ9vomks5uUfql?=
 =?us-ascii?Q?VEnTQpbdk/yTqQqMsJznRf891yDOtW8kDQmmarnuvlMp9evrf0h6X7/ZZT7k?=
 =?us-ascii?Q?bjFFbpwAsUtYVm8s+8CrfQKKhES3HfzzUxxB4IJLEW/d+fuInWM7tiUEzvWR?=
 =?us-ascii?Q?CMuONwehXvMJ37dH/tJU1K0ew8oJpRUe0joJJDiXAM/XhdC5OLplk6dRftxP?=
 =?us-ascii?Q?fysHHBXNpq+qty4CH+WHA7rM8ZcMKokqoyoDe+zSPYT0aQRqJSOvN6f7euB1?=
 =?us-ascii?Q?TexsCl/fNr/NmxG/CwSmCu/lK/CBTpS5JkrUwmyTffX4rqXZB69xBkoF7Gyo?=
 =?us-ascii?Q?L2PjAPMi9a5DFNAPhQou03+29QN5uje05jS8gsP5vsVtBHar093Ci6jmcsAU?=
 =?us-ascii?Q?yq7buk9yvm2h3xsQ+BMDGbTBvBem9z+/z35yy//W2DN1ai4z19KSBVpztkO+?=
 =?us-ascii?Q?UwY/dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KilPwHSaHsR21jnNifF+WX8a+AWkRjZAKtzWvltww8tHH74b0waL4D+5GVqpEV+XNtTpS/7pD3tnhWlh9TBIWe+b4VexJCTVyc2BUGZLXgiQHHlF8CF6T9Ab7CEzpm7Cm7WyTCquOn+0VENK+pZBcrqyIb8Snsm21MtdmN1iRCw93be59EkOCaaNiCSebhEnRlziX13fff8IRmiJ5VpB6xwnsSythqwnBwumi35lH6fwgcao9UZCBkC+VXdTXdFM1Dn8lA2wDc1sNhy8nLoaZEgRc55rtAX8XZbBMAezqfu9bhWGGJzVVAxDjNJ7q6656oSvQvHeO9pRuF2L5jxIjWVvLI09MUX9bhlXcDo0PAjyvgDDpVGyzeEOzLfTkikFLLafedha58TA33gEDHpnlTCxL8BjkdgeRCipYVjp7LRBFd3B/3D6Q6K81qz2RRLisNE5/4O7nXDsgZPJWzos0mOZd+gMoPBiXkZ8AsVG7e6ZiUs3AJojWF5JwKofcwNiTJBCS9VXent2RBVOVRHrkN97C7wFM6UDlTbZ0MHn3ONBmhCsoZZ+2tnXvFqO4WklL69uW2oXpRYJ7tSNEX/Am6wqTlBfcQARlQ2650z2s1s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d18bed-2885-4442-03c0-08dda20acc75
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 19:22:22.1923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6r0OWLETs77r9aUcVonZAz6cAEdKjnZcsUrzJ+Mmy9MyWv3ma/G9cZEcURQb3P9sfx8zI46aaVG/9aZImBhjU7T4eQXXhK7lhaTuKZC2EI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-02_07,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506020159
X-Proofpoint-GUID: JNolnigQe_aPOMC6LCq6JaOieZoQpQDx
X-Proofpoint-ORIG-GUID: JNolnigQe_aPOMC6LCq6JaOieZoQpQDx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAyMDE1OSBTYWx0ZWRfX4oNbi+VEvbiw Tqt/+7EWMwAPfA7bgOLLUP4Me07lY7jkHbzz/5bgupwtwxMut9Ohca1Z8P+EkcCldzxveqN6zhb vuTUoGnZUfIfoLhLaMB3oyNuHRTu2vb9DE8LD8TKy0RKqpyLKW0vxVHCCKrqHEbO4NY5On/cusp
 +SppWTAVj2MLk/Bp00BoIVEHPM0EWt0gCFcHRjwUw3m2eOMnI/PZYsoXVzcgLgG4tCOasnHAPB9 Bq9DIrACzUGrsnhrjvvIxkHywjAewNnQOuEl1GN0MkO4mThvPCZX6gqddiNUCzpJgkBTCa6qik3 adO8a8M/ZidsaaG43tF/amtxsqeMYPUUycITON3CJ8J8ABMzOb/acvEhZd2THrR8jgvhYg2O5Em
 q/FqVRy5Yp2GLuYLAKIMxiozCmf5eEUESfLGyuKpa40jYmvV+nIX38KLX7DEzS4kjTN4gBFp
X-Authority-Analysis: v=2.4 cv=QI1oRhLL c=1 sm=1 tr=0 ts=683df9f4 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=XlWU-9mzee8Wawx2FPYA:9 cc=ntf awl=host:14714

From: "Darrick J. Wong" <djwong@kernel.org>

Move the common atomic writes code to common/atomicwrites so we can share
them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 common/atomicwrites | 111 ++++++++++++++++++++++++++++++++++++++++++++
 common/rc           |  47 -------------------
 tests/generic/765   |  53 ++-------------------
 3 files changed, 114 insertions(+), 97 deletions(-)
 create mode 100644 common/atomicwrites

diff --git a/common/atomicwrites b/common/atomicwrites
new file mode 100644
index 00000000..fd3a9b71
--- /dev/null
+++ b/common/atomicwrites
@@ -0,0 +1,111 @@
+##/bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# Routines for testing atomic writes.
+
+_get_atomic_write_unit_min()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep atomic_write_unit_min | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_unit_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
+}
+
+_get_atomic_write_segments_max()
+{
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
+        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
+}
+
+_require_scratch_write_atomic()
+{
+	_require_scratch
+
+	export STATX_WRITE_ATOMIC=0x10000
+
+	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
+	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
+
+	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
+		_notrun "write atomic not supported by this block device"
+	fi
+
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	testfile=$SCRATCH_MNT/testfile
+	touch $testfile
+
+	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
+	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
+
+	_scratch_unmount
+
+	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
+		_notrun "write atomic not supported by this filesystem"
+	fi
+}
+
+_test_atomic_file_writes()
+{
+    local bsize="$1"
+    local testfile="$2"
+    local bytes_written
+    local testfile_cp="$testfile.copy"
+
+    # Check that we can perform an atomic write of len = FS block size
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
+
+    # Check that we can perform an atomic single-block cow write
+    if [ "$FSTYP" == "xfs" ]; then
+        testfile_cp=$SCRATCH_MNT/testfile_copy
+        if _xfs_has_feature $SCRATCH_MNT reflink; then
+            cp --reflink $testfile $testfile_cp
+        fi
+        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
+            grep wrote | awk -F'[/ ]' '{print $2}')
+        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
+    fi
+
+    # Check that we can perform an atomic write on an unwritten block
+    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
+
+    # Check that we can perform an atomic write on a sparse hole
+    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
+
+    # Check that we can perform an atomic write on a fully mapped block
+    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
+        grep wrote | awk -F'[/ ]' '{print $2}')
+    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize - 1)) should fail"
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
+        echo "atomic write len=$((bsize + 1)) should fail"
+
+    # Reject atomic write when iovecs > 1
+    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write only supports iovec count of 1"
+
+    # Reject atomic write when not using direct I/O
+    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires direct I/O"
+
+    # Reject atomic write when offset % bsize != 0
+    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
+        echo "atomic write requires offset to be aligned to bsize"
+}
diff --git a/common/rc b/common/rc
index f7d38894..94ae3d8c 100644
--- a/common/rc
+++ b/common/rc
@@ -5443,53 +5443,6 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
-_get_atomic_write_unit_min()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep atomic_write_unit_min | grep -o '[0-9]\+'
-}
-
-_get_atomic_write_unit_max()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
-}
-
-_get_atomic_write_segments_max()
-{
-	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
-        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
-}
-
-_require_scratch_write_atomic()
-{
-	_require_scratch
-
-	export STATX_WRITE_ATOMIC=0x10000
-
-	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
-	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
-
-	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
-		_notrun "write atomic not supported by this block device"
-	fi
-
-	_scratch_mkfs > /dev/null 2>&1
-	_scratch_mount
-
-	testfile=$SCRATCH_MNT/testfile
-	touch $testfile
-
-	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
-	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
-
-	_scratch_unmount
-
-	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
-		_notrun "write atomic not supported by this filesystem"
-	fi
-}
-
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/generic/765 b/tests/generic/765
index 84381730..09e9fa38 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -9,6 +9,8 @@
 . ./common/preamble
 _begin_fstest auto quick rw atomicwrites
 
+. ./common/atomicwrites
+
 _require_scratch_write_atomic
 _require_xfs_io_command pwrite -A
 
@@ -87,56 +89,7 @@ test_atomic_writes()
     test $file_max_segments -eq 1 || \
         echo "atomic write max segments $file_max_segments, should be 1"
 
-    # Check that we can perform an atomic write of len = FS block size
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
-
-    # Check that we can perform an atomic single-block cow write
-    if [ "$FSTYP" == "xfs" ]; then
-        testfile_cp=$SCRATCH_MNT/testfile_copy
-        if _xfs_has_feature $SCRATCH_MNT reflink; then
-            cp --reflink $testfile $testfile_cp
-        fi
-        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
-            grep wrote | awk -F'[/ ]' '{print $2}')
-        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
-    fi
-
-    # Check that we can perform an atomic write on an unwritten block
-    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
-
-    # Check that we can perform an atomic write on a sparse hole
-    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
-
-    # Check that we can perform an atomic write on a fully mapped block
-    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
-        grep wrote | awk -F'[/ ]' '{print $2}')
-    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
-
-    # Reject atomic write if len is out of bounds
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
-        echo "atomic write len=$((bsize - 1)) should fail"
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
-        echo "atomic write len=$((bsize + 1)) should fail"
-
-    # Reject atomic write when iovecs > 1
-    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write only supports iovec count of 1"
-
-    # Reject atomic write when not using direct I/O
-    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write requires direct I/O"
-
-    # Reject atomic write when offset % bsize != 0
-    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
-        echo "atomic write requires offset to be aligned to bsize"
+    _test_atomic_file_writes "$bsize" "$testfile"
 
     _scratch_unmount
 }
-- 
2.34.1

