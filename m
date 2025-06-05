Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DB91FDE33;
	Thu,  5 Jun 2025 04:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749096107; cv=fail; b=USpMgqzD0fU7pqJIWIgQtoOIHhDW2oH5nHqmurB6y9qGZlRsx872Cy733hlEJESmT0YFeGYVEwCS0Onj9Izl1lOdN786uxblwLB8DQ70G6Y1990d8py+kki+U15BLRKWOo0DR9KtbUpQzAt1sP+kJRsc+h5vlp2F2tBNtLaEJ1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749096107; c=relaxed/simple;
	bh=OPJep3lvJqrve6WQJPkArxA0GqgQk2AzgFgEcRy3d/w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mxd3GIDSDgpF1XplW7HSKJyV8g/oXWBpUkkIcNHSQxAL+K2+TKN/93La53VDMhO66KkJPteiZc8j9atIHFSJFlOdTXmZEY1Q6CWbci48NdMfbRJjYTxYxW+ch+vnRzztlMRBFxdx4KkX5pwe3laOdTMfv7Ufb3CoEvFcMhHtH8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=an6zo6jj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YNfCWKiS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="an6zo6jj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YNfCWKiS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5550fYuo010447;
	Thu, 5 Jun 2025 04:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=etuP2Nw3/F3kG1d2YhhsxEhOXZt7TuRV+QEZ5q5XbjQ=; b=
	an6zo6jjAnAw5GuAXDHC77i5XnNrwlXlcNwhiYEQ8gT1fUi/NyK9eHUGu7tJ3tAm
	VP8ALnAnuKebDbvy8+ebPyWGL8tgcr0be3oCv7Qv5FCTS9hisP/pFcpQia+A9KFU
	rZ9Spj9zYDsBKV4JRkx3xyG29bgPsmM/fO7b+giMYbOk0FnU3+cwnEqINYIZUbEk
	incnmgH2g/oL5n3zVJtXrLO1+O1VJvgh9Ov6z4sVihe/Rob6AJSjjjdEYEbPG3JQ
	ljBKUIaA+dLouXEqDQxOLQ/PtIphmeiuIAeF3ilRy2bAc8nQFZAQgC8gQ/YFLHqi
	whVHL/hocquTD4iNksJFOA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8bn9a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5550uPgF040683;
	Thu, 5 Jun 2025 04:01:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2043.outbound.protection.outlook.com [40.107.100.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7bt70m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 04:01:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B+NUQKdMAN/HQhtplb7LSzXHmTUQmAoYbqEbYdfT2iRrO4stY/gjd5LlrCxWxLq0TZnSPyfMk1XU5Gaawl+TUWUHHPVUFGRRH1GgLJcCiSYTPNdhNl7p/e1in74J0FQ/q8AI7oyHsHeYafqDbAdY0kArDbipktYUgz2WF9qZYUnJRNeBH5D3W23e1Cw/ZkinX1z66qfyx93m+ThJgTWb0NcuMGqc5gz53b7RMxfW4R9Nk1lAMG9K1S/aBAGx3oesDixIoQYDv7PVLnbjMkrugnB+RgUjbclrEo56ILPlhr0whLncYY/4gVJNL6ETrJCVxarSoS9J/6EB/7Uxd8fKtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etuP2Nw3/F3kG1d2YhhsxEhOXZt7TuRV+QEZ5q5XbjQ=;
 b=NhaREm6wrfrg4z76Z5xxTsqoxJZIiSIuWO8bhVwuhHgtgDEnViLhjxzuyPX4hJK1eWvwgTKI8W+w4YKjAji0voGtYuLHRVZVH1EYzY1Ys0biTIuXASXHdhJsrjHrIa6fTJLfd7Ubqi+UmPt7Nhc1+X1xPGUYLa+jgLGuyPxh2sOXy+ZFuMqFF5Hyz17dfsAlFoQfvkIwKl9h0RaFVnEc7EU/BQ7tDyxLOavRg7D4YxNnUMyvthRuQd6SV9A5xbKXd/+kKrYd0JQXkB95WF28vKXnuNfBE41kXiLfIxl2YnGqBGDIowpcDks5k4LJ/G2Ui9WeYes8KwO+ir49/1yLqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etuP2Nw3/F3kG1d2YhhsxEhOXZt7TuRV+QEZ5q5XbjQ=;
 b=YNfCWKiSt6l1yUzSbYOLkSktWSjGPiRDeelXxnMIrkQ5KTS0GWDFsKI0xcdzgriI7WkKvrSXa65by62QLEyVR+WEMKb/Z//sMRjZJ4UcxBgaRS5WTioYveFZnVIF/pegi14gRJ3kmhmJuu/K24Y/QNJHNBwLoT6A8Gq9jHnCu/0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 04:01:30 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 04:01:30 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v3 3/3] xfs: more multi-block atomic writes tests
Date: Wed,  4 Jun 2025 21:01:22 -0700
Message-Id: <20250605040122.63131-4-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250605040122.63131-1-catherine.hoang@oracle.com>
References: <20250605040122.63131-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c3e4d08-41a5-40c9-49e2-08dda3e5a721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|10070799003|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QakwMZuBzJeGX7cTWAsJXBLjuodOBBDk4HxfFv2IxfMWb/e/lH8ixX5rZHk6?=
 =?us-ascii?Q?FeTEkLTPWywldPz5leJp+etfpIZalyLvAzCjz+8EcsJZ/bO1VWJ4YftJW7f1?=
 =?us-ascii?Q?C7QD0mWiRVdlvXC67+sZx2CWbQbLz4RD1BTHA7AwOixvjJyJ88mwZ2MAclRd?=
 =?us-ascii?Q?g5shEhcuF04YbSeNNmJGFpHKWwi3IfXnd+M5BhR2/iZa1FRDIqMjSsCy9bVZ?=
 =?us-ascii?Q?3lexgq4HqzWxHFpeBaEvE1R4PXu3OglBcHV28Fis2AR4pMvlHaAyFXSykHhu?=
 =?us-ascii?Q?wWesRjS61W7Fz5cQtwTF1+w9V/dFwI8YgtJWxMa4TbEk16hZ5T0b0B5C9VRt?=
 =?us-ascii?Q?CgQVWUfr7ClmlWQR7IaulJ13/H9emeRTNVu6d3Z6gtY+w3r7nfpdDHW/OnT0?=
 =?us-ascii?Q?pmJtqCKng8RMHtORUsTNeMumSoCydclWUvqpCxj9Lly9n/ddU9EvlD5mi4/z?=
 =?us-ascii?Q?i1jSk5RfGeOu+4CsT+54ft7KoCLUZTlNMX/OAAeJE8sBgBYmsBLqmCP3hX/o?=
 =?us-ascii?Q?reYmf/YT27ZZ9iu+q4ZImeSZMAINIiiQN3NSUdNK5AMCOqSEkjxpOHJuAHNu?=
 =?us-ascii?Q?WVNjvaL2RtgZSecuBqs2BcIjsR6yvM5t0vGvgYGV58YC8TxY10Cx5CiDrNw2?=
 =?us-ascii?Q?EPG8KQg2+vYo611YkaRs2O6LTw/ROb5bIYc1qimujbhF6Xrxi4+wXp9IcEmT?=
 =?us-ascii?Q?y8A4p0g6tJ4t05Py8YhK9706OWiCgeusHkwy6dOEuTcm3CXwblExAMzePI3y?=
 =?us-ascii?Q?rUHnmmVM6zcLyvLb7xN2ZvsnwDcfOCxoZ5dvtQWheVkMjiOlh/D1Hy0g97Qx?=
 =?us-ascii?Q?brY2cAAdsWHic83zshGXy0PAyvvkoKfnYG7QwgRuYBTo7kktVOTJx1PAuJpa?=
 =?us-ascii?Q?EV+cCT/jXnujhTeSNeuIWZL7NvouT4ybj3J9RkDfln+UrFYoNPKGlfsPP9in?=
 =?us-ascii?Q?g5k20Hs6Pmcmmtz1MEn3yYNBgBOxhLsgVovhTJBbQQNa2BrB0sCJsS5Oa3YS?=
 =?us-ascii?Q?0nOajna+B7+es/rmV+r7XlhaPijFONFkDNNN4Deho/P7Z8mhS0vPRo8X6JTd?=
 =?us-ascii?Q?9UU4em9Ah7wkMTG5tVgUoAOFzrv/J8JUS2aSQAlrCaMJXTyQm3QIgxDSI8yS?=
 =?us-ascii?Q?0tdKv7Py7pZy6QJMt0dc7MlyOgLiakLBUe1GFGjlalTTbtRvkHdNF2yIVJ/Y?=
 =?us-ascii?Q?+lf5O/kZogtoNrgE3s65tU9QvwiazhBuwovvi+k6ey9EGwY7F63b1Qg8oh2X?=
 =?us-ascii?Q?ayHbZz86yJ8iHUbZ7b6h0lg7HnJOzJ9zoDqnd7Uwh9xUvJ0FHvsOlBOWmpm1?=
 =?us-ascii?Q?ra+WJ85U1uveF1FHa5AAwb5Q0IkReTDum4JYPUcSLvmbNbatkR4Lm0Pe+/V/?=
 =?us-ascii?Q?NUcIPm92huFQECX74VIFFM9qcAqmNKT9i4232HgbAPbrAhThTty8YDTfNriH?=
 =?us-ascii?Q?JGqe/ggBwTc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eq69vVOZHhMd7b33+OmkPE546sPkhTOmw5OSBPnZ9oLKuTchSq+AKiBpHT7z?=
 =?us-ascii?Q?e3WSL5JbHzQMyE8SFRjJKbkMzY03P1QgY0ym4VCail/YjYEfaK3YpBXyqsTe?=
 =?us-ascii?Q?wYoDuhZRSl0J7rI1yFZsmdkWy6m8XRptE7NL5PDPbX9+txj26QdntYBEOSbT?=
 =?us-ascii?Q?/aFu5pNmac43QS5E8p3snWgl+3SORCszDkZt+nWNqWZQm0t2i4IrrqbwtLoE?=
 =?us-ascii?Q?0IcK9/FV9toJBD/LMmPz8dXt/nU9Ot2HTf4mUvg2GznCWgEkUiOWBde8zsbz?=
 =?us-ascii?Q?p/z9S0A7tk+mVjuvOdMKc182NrEojJaLew63cza+clu4k9cL9jYg6ai1fk4S?=
 =?us-ascii?Q?UVuIP/ycPCm3OtY/tfjGE+bzCElbz3iQAUDe+KKIUBDFWKznKDtVh75bBY8A?=
 =?us-ascii?Q?lyjBrf7QxUuQNxuMuWPINy3vwYoJq5LkL+srd9rAzFCA7QlNGIxLaPFVXeV1?=
 =?us-ascii?Q?UnNK+1ri61VJo5ceueKxnS8wQtNW5M71VfkookdL0R/9f6Dj5bhA4yQePh76?=
 =?us-ascii?Q?luSzD89MUcoycVFOJRIOl9apPldcTLqhkWZ++/7ZXC0i3Ga6NxbAULUm++3U?=
 =?us-ascii?Q?9reCF1lQgOEZVlN9in6G/MdEdNRFpERExiqFiKEJTVgPZ1Ikg6VZle93TqpU?=
 =?us-ascii?Q?J/086iizSS41MY8OGmdsp5ffetoW1mHr09ytG1R2T1M63bxAkknF6noFxD1d?=
 =?us-ascii?Q?J8CIr0m7Rqu6AQFxVFErjTY1KN3qAjmXSBJPjbqjV+zvzAUIGlxaV/90ry4y?=
 =?us-ascii?Q?Mh1eW+nugIEpF5ufIQUrs6ZslutJyt7WpgxF/rXcnp7anvXRfkpyXMY+F4rw?=
 =?us-ascii?Q?BMWsu/216DAUMO7ZfFNeiAUx4tu0Bm5uoxEplO4Ux9zhYfgoeIhs8NLkjdkV?=
 =?us-ascii?Q?tsrAh4vV8GP8vnYmIh0BlXGXjaCSrZ45WbzTDzbveTRUeLKWmfyP08QVYFWg?=
 =?us-ascii?Q?B3L/TqiokLqy2TKo6mS8JJvOPubbOrIfYlGb3Xo+bhS8xWyENRAIbfm1wIyH?=
 =?us-ascii?Q?M8PH3eA6P9ornoeUMqrZcKykvSeSvJCkrivOktaEjoPLipuNJfjPFq9zZikL?=
 =?us-ascii?Q?HUUCx+RnB3WaKEQ9NHLoPZzOzWTk7137DKvI6zqYwmQ6b3SqXS5VoWBQQHYv?=
 =?us-ascii?Q?YaHUGbPuhyY4TK+on7wkQ+p1aJdQD3DGjW3+/fuq3rL+nrd7R76/V/X0mi8C?=
 =?us-ascii?Q?ozOODeO99vs/MsA9BHfA9A2hXb35Kz6hF4W+N1EocI1idxN9rA4uDJS1Wkx5?=
 =?us-ascii?Q?tUD1Fbm7FnKn/oQBMdbAqUYPBlIQ5jk2VYqAK+GrqySMP/ckBcxQHRamHjOT?=
 =?us-ascii?Q?FIHPbbAqPAjvNRdQqU+0G0ZocrFK2MhuJDSW2pXQecg8d1wKA359ZUVugt52?=
 =?us-ascii?Q?+2bXsjhzYYPla4b8qfuFlkH81gvsQcVu44GQdydhk0hZwmC+e8K4B4gy7j/B?=
 =?us-ascii?Q?kN2jEwTUnvVzb0NfZ9axzI6tf4C8q1H2ks3zKTUhKI+wVW3fBXr1H1lIWfSp?=
 =?us-ascii?Q?pOBdquGNCmliem1QJvo/iXpqqxhaU7Ra/lsBAxBmBNECyfvJY9zC1cQPjYBD?=
 =?us-ascii?Q?uqiWNNS5wNQEPG02JAw+R80oJyiCYoyCHXZ0yZ095c8Rnz7VBdFlNzdKNreY?=
 =?us-ascii?Q?S9Ol77zBfpBt++ZaCdmvrHVKhpvkrE8jxzDfoAd60HAKN3zFVAFqO1etRLLW?=
 =?us-ascii?Q?FXdCKA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	clDOXY7dUHtWr1QLvf+YkSeajnuJG3/1QmW7uxAReffauGDNxUUAcU5Cf8g6Xc/TGHsvSwdwOWBJ6g5qCoKbJ7vVBorzwcAVGZJRw0fOMcQ2ek0l0tf3qjUYAUwHuqJS84JHGTTjYZep+yCasVAiYeuvczt+H4vvJCSdHpTUbXdFswQJrTmA2DhwTlKDFUo/vKNbNQCAKaniZzkP4211i/AvyU1XHG7ZckOoXCZ6/Q1iqy4WqOGjyBThyjiFTGuXUfDjvuE0hH7bFEEJPEqEpeBwyIxlsNWYnQEOTTMZciLyZonUekPoAUYuK1c5FZ/rWql29Q9yZ3Ite27Zu8o3QFqcFnF5CM466kZRnLFXeykIf5R1Yt7rFl1Oh6BYxOg4W8ISnsWl5KLGP1y4mK1LUlUd48sSJvKMsuVMYQ/yMWxS6VGQcMPXMl0GGBi5sSPqwT2rpvQ5fCvEmHiRfun90BV4/hjMT46vNFPQJEi1zbJovYhy+MGfNr7qR2UdEBS28CkfiHfXfMiwqemWnxnuc25Dp8dFbjUOjLYghPD3mKSTsH57L78jpuDLBuPMeuf5ZGCqaeGyWWMz19otSqYx1NqxGdPq5a6YIvCYg7mwbGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3e4d08-41a5-40c9-49e2-08dda3e5a721
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 04:01:30.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9CGFa9QdopLqhc32hqJxPujtSBvOTvzwgjOMQWxwm5DjdiFv2Yz2Kj8foi/Og6yMc9rBVFBH3c2nDCUgh7EBjOQ6q2TD5ZO7PL9JmuP4as=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDAzMSBTYWx0ZWRfX+VLvw3wB6Eqz yC8BtDVbrGQ/6JC6r33Bi9UlJ7xgXg5YQl706TGOgA9fbHvZ36V7zDvi114gHNCAy7xzR6wqeFp P9vgJCr2ug+UoOl0tOp4jTRK5cYDnwb5yeoJCdzfJtgddcokLsT+Q1Ylm+KXEFZvkRxD5eTFPf7
 AWc6KiVtrSEfZyfkMwX7B+OI81SStNhNkKA0T/GWHcl4/yvsLuh2zQa/T8m4byS1yHzTVSBf6au axCpf/PudsmubBgN5N8tvTFuinnHmRVwCzMR1ZDsOGDBltGYyHl0w2FCHnX2ArIaoMe6nQOETy2 bCKwUibmVJePT8MrdiqFTgDe2E0RKcUSxB4AbU2LcuDbUwbbht3WU25GdbFIizapN7xkUOyE2Df
 T1trHhCLlRRlkG4QrrI4oQcXGTDT8os+JN0ULAZxJt3JmOW6NGAh6a+Q8Ya7Oy3KNilz/1Ai
X-Proofpoint-GUID: Kt1mE9roqUWZttI5gYRJWiN2JVi-lSfL
X-Proofpoint-ORIG-GUID: Kt1mE9roqUWZttI5gYRJWiN2JVi-lSfL
X-Authority-Analysis: v=2.4 cv=H+Dbw/Yi c=1 sm=1 tr=0 ts=6841169e b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=L8ylOuakJ3cUHoZ6ZUsA:9 cc=ntf awl=host:13206

Add xfs specific tests for realtime volumes and error recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 tests/xfs/1216     | 68 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1216.out |  9 ++++++
 tests/xfs/1217     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1217.out |  3 ++
 tests/xfs/1218     | 60 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/1218.out | 15 ++++++++++
 6 files changed, 226 insertions(+)
 create mode 100755 tests/xfs/1216
 create mode 100644 tests/xfs/1216.out
 create mode 100755 tests/xfs/1217
 create mode 100644 tests/xfs/1217.out
 create mode 100755 tests/xfs/1218
 create mode 100644 tests/xfs/1218.out

diff --git a/tests/xfs/1216 b/tests/xfs/1216
new file mode 100755
index 00000000..694e3a98
--- /dev/null
+++ b/tests/xfs/1216
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1216
+#
+# Validate multi-fsblock realtime file atomic write support with or without hw
+# support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_realtime
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_RTDEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+	_simple_atomic_write $i $i $testfile -d
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+if [ $sector_size -lt $min_awu ]; then
+	_simple_atomic_write $sector_size $min_awu $testfile -d
+else
+	# not supported, so fake the output
+	echo "pwrite: Invalid argument"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1216.out b/tests/xfs/1216.out
new file mode 100644
index 00000000..51546082
--- /dev/null
+++ b/tests/xfs/1216.out
@@ -0,0 +1,9 @@
+QA output created by 1216
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/xfs/1217 b/tests/xfs/1217
new file mode 100755
index 00000000..f3f59ae4
--- /dev/null
+++ b/tests/xfs/1217
@@ -0,0 +1,71 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1217
+#
+# Check that software atomic writes can complete an operation after a crash.
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/inject
+. ./common/filter
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_error_injection "free_extent"
+_require_test_program "punch-alternating"
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# Create a fragmented file to force a software fallback
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile.check >> $seqres.full
+$here/src/punch-alternating $testfile
+$here/src/punch-alternating $testfile.check
+$XFS_IO_PROG -c "pwrite -S 0xcd 0 $max_awu" $testfile.check >> $seqres.full
+$XFS_IO_PROG -c syncfs $SCRATCH_MNT
+
+# inject an error to force crash recovery on the second block
+_scratch_inject_error "free_extent"
+_simple_atomic_write 0 $max_awu $testfile -d >> $seqres.full
+
+# make sure we're shut down
+touch $SCRATCH_MNT/barf 2>&1 | _filter_scratch
+
+# check that recovery worked
+_scratch_cycle_mount
+
+test -e $SCRATCH_MNT/barf && \
+	echo "saw $SCRATCH_MNT/barf that should not exist"
+
+if ! cmp -s $testfile $testfile.check; then
+	echo "crash recovery did not work"
+	md5sum $testfile
+	md5sum $testfile.check
+
+	od -tx1 -Ad -c $testfile >> $seqres.full
+	od -tx1 -Ad -c $testfile.check >> $seqres.full
+fi
+
+status=0
+exit
diff --git a/tests/xfs/1217.out b/tests/xfs/1217.out
new file mode 100644
index 00000000..6e5b22be
--- /dev/null
+++ b/tests/xfs/1217.out
@@ -0,0 +1,3 @@
+QA output created by 1217
+pwrite: Input/output error
+touch: cannot touch 'SCRATCH_MNT/barf': Input/output error
diff --git a/tests/xfs/1218 b/tests/xfs/1218
new file mode 100755
index 00000000..799519b1
--- /dev/null
+++ b/tests/xfs/1218
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1218
+#
+# hardware large atomic writes error inject test
+#
+. ./common/preamble
+_begin_fstest auto rw quick atomicwrites
+
+. ./common/filter
+. ./common/inject
+. ./common/atomicwrites
+
+_require_scratch_write_atomic
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_command pwrite -A
+_require_xfs_io_error_injection "bmap_finish_one"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+echo "Create files"
+file1=$SCRATCH_MNT/file1
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 4096 || _notrun "cannot perform 4k atomic writes"
+
+file2=$SCRATCH_MNT/file2
+_pwrite_byte 0x66 0 64k $SCRATCH_MNT/file1 >> $seqres.full
+cp --reflink=always $file1 $file2
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Atomic write to a reflinked file"
+$XFS_IO_PROG -dc "pwrite -A -D -V1 -S 0x67 0 4096" $file1
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_remount_dump_log >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1218.out b/tests/xfs/1218.out
new file mode 100644
index 00000000..02800213
--- /dev/null
+++ b/tests/xfs/1218.out
@@ -0,0 +1,15 @@
+QA output created by 1218
+Create files
+Check files
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+Inject error
+Atomic write to a reflinked file
+pwrite: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+0df1f61ed02a7e9bee2b8b7665066ddc  SCRATCH_MNT/file1
+77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
+FS should be online, touch should succeed
-- 
2.34.1

