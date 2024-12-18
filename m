Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0115B547;
	Wed, 18 Dec 2024 19:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734549470; cv=fail; b=LqhMEqeSJlrS5Pmez7qAaaB9Pm8JgFQZnrUG5g4h9SL2DNK6Ae5M1ArVLGQVnxgNTxKV5dsgqoXtbHKma1vGiJHXMJUWi5SzB9CNqRvzK0RF2qqmvtDycowuKLqd7NhaV0K0ZrxbnFfB5FHIHId9GxRPUZVZPTx1YLuJZ7Ig/Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734549470; c=relaxed/simple;
	bh=4/LfefC99R8B4BrLYyxyNHT221YnZhR6QE7WU2us5U4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fX78jghQrukD06uEUqkSLq8+O+cKziTrNDsBh5Ttz52lbDd1++eM2tu+MZyllbtpdhOcjQC2a/lzNBpk49phTQZE4eSwmCxHmXplDu/9VJREUt3tCnNL7kpKpQs65HkjJiPxOUSB40DOKsjlsvhqe1fBhyWwdIRnSS+/U60UMl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lfzuPpvB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Quw52uOQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lfzuPpvB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Quw52uOQ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIHQcmA024342;
	Wed, 18 Dec 2024 19:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kCTMZ8qNR4d/HNnY4Ii9wavpI/BBtPDG0bOSH7PkxMc=; b=
	lfzuPpvBCDFUPxM7kV8YAV+sMjBH3atIngHyp82vVPNsQyn9Gh6jhqZ2/6ftNXjg
	FFdn29Ekf+hetyuV4uJJ6D6oKTwXgd0Ca6PRV/a6Sm4avQtqrFutTvcwSrApUlqr
	7Mf4wZnAQS2MMV21YmiYaEjkmNVYWqP5+K/YqJLwAY1XMxWTAwT0SRs52xYSfMBf
	Eaom3Vxd3a5IJUalq2P2DIObEFIvxJTx36xBQ5kgp4oQZYQt5Q/mqLXpY39gPfcQ
	OJBz7sZ2+eLZ8xmQI0B24jJBIzvlY5cBcNyxNF2yj3nCGu0sFlwVT0HEgLLj4cwf
	qZibUTiGOhh2PZ6LYoNE9g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h22cseky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BII1ATC035673;
	Wed, 18 Dec 2024 19:17:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2040.outbound.protection.outlook.com [104.47.58.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fa8gcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 19:17:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uLVBp/wzaEWw5UgRQT3QN3RCd1n1Nc/WQg+J+oXFBh5YM6dEo25aJHygsrjndISVfP5YV/ruJoz4FG3AIeyjTvY+dGLzQqXFxPJUEi8BYAL4IxUH7JekyorbkioMP1aV/Bo0tSr0B2DUaFo4XUJFCP10f+Mu33cm/5d4Y2iqdCoqRXM2Kj3UjYtqQ54SGDGMpEnC5wgS5iaz6Fz4jAYcZ3jfRvQGkXWgn9WhO++SX9hXCyD3La5+WLzinKEWuGnkJI0QAkoAcm4/hvftzvJJGuiAf/8J91hEG/MplJEXYm5BbefiAE4fJJIbwBbAz3m1XG1PULHrVFjhJX5VtE6AHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCTMZ8qNR4d/HNnY4Ii9wavpI/BBtPDG0bOSH7PkxMc=;
 b=mCdj/ufS+SX8kaGHrcon9aV3hglx6b++D9uwy1ZBpJngHm2BP4STbeg5L7AGJCJIX7p9CDVFZJjE8WBMB9DDNS1KbhL76uUCv1Ha1ZGccrsvSzk2E+kVnYVyP5wbeJUVT6rRK5FNaRF7lck8G5czLfGGdo7MsCdAaxepFC9ioQRf9N8khc9s1IF1xzQgGW8eBeWpX0WZ0GL2HShYzRIACOE9iYbBNpotAtQAFX7c4eeSTRjPgJobya6rryVTBf+1RBkxpw+rCsTg91b37OrozVF/fjrHL9PDFay4HBmi08yYFBMLUD+24YYsr36VM9vf4UZ4Z6J+GTZsVpC4ftjoew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCTMZ8qNR4d/HNnY4Ii9wavpI/BBtPDG0bOSH7PkxMc=;
 b=Quw52uOQY8kgW3chL4oAf2f6/erW2jNdVzubccKqfdu7VW4OrkCYsn/ymr7nHwUSjc20kydIGmrO+IKTiE9klc1AFEqJFjTmfO0uNPbDWNAxc+jGtb/NleTT8/C23nBFEkTWVQscIgcNHmKmB4Ks90/wDLY1TpxMJ1j/aCp0GPE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.12; Wed, 18 Dec
 2024 19:17:43 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8272.013; Wed, 18 Dec 2024
 19:17:43 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 09/17] xfs: convert comma to semicolon
Date: Wed, 18 Dec 2024 11:17:17 -0800
Message-Id: <20241218191725.63098-10-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241218191725.63098-1-catherine.hoang@oracle.com>
References: <20241218191725.63098-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 73dc8bc7-a59b-4bcc-9320-08dd1f98a5cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T4OVMKeLl4POFi8fnoCvSUbMktTOvNHnhxG1OayT7eVCRwP7jBWVmynS7Ey9?=
 =?us-ascii?Q?tjR15MGU8T210K1LrtElVceoZuy/jGNp0FHA+vYPPRCMzvWDP9drb4GrKbG5?=
 =?us-ascii?Q?L0ZS/Gm7dWG4ErkrFSccZLf+jddHvJ9hcVyxb+kfe4oAJOlFit3icfumIqjw?=
 =?us-ascii?Q?EjSqxnAt6ajz2cyBCvR05a6R/aIsmEVjTQDMp6Rg4oeL3s4kMvjIQ2OqtLoo?=
 =?us-ascii?Q?RbdBhz4zYmeaD5R08YKWk1ko8wRHXwm44CQI9573+FJuZK+/cYVxi0iguePQ?=
 =?us-ascii?Q?O2ebjGfgvvaZwth4qBmvwhynOGfN4d8u/sgJFxiR3P8TtyvP8Cv0+cgfDCHH?=
 =?us-ascii?Q?NjSoO1xRj8ZurwfcrjrheThAsTB8DkKiJRtUBqD3GmWbNHZVoCqMAM5Ek+Dc?=
 =?us-ascii?Q?eqS7UTE+oQ6XckNd5hOyJ4CR2bd4L4VeFC15PHQo+YIqwvczvnUS+hjdF6oD?=
 =?us-ascii?Q?ZmU01WcruDPVX3HbvhSXiy2B2sF4FQd7CCNurrkeNbwc3jliYZVN4cJc1sTe?=
 =?us-ascii?Q?WZAVoB7uVYza3kKwRO9iBIv7vHVsSjoaGf0SaMqryJwSXfhuI93zvCdK5DBj?=
 =?us-ascii?Q?Z8R6Vliv0XMsznrzDoc3sBhqwWbxbFbf7YxBzztR08kNcYQ+8Sv0OlX8K4zy?=
 =?us-ascii?Q?KpHWi4pxk8SGl34akCsvrhsaZp8lBC4t/eyBAkkW89xb9ygk9HQl0dbW5vr2?=
 =?us-ascii?Q?1o5Fy97IfAwFLIWyU6INnydIHE7zdLlBJoqwWyUHS1HtWz16rV6Rt8eRyTqA?=
 =?us-ascii?Q?4FZU8lPsPvFhQitwfJclvMP6L/JIVjozl8M7XIRU7+YxSy0l4Rky5sDwO3Vt?=
 =?us-ascii?Q?NbZMzG8gMD1UO5jnHyVuNXkiAR69U4IcbtVkHzw86OPR7hZckZb2BbDI+yQy?=
 =?us-ascii?Q?7Ikm27cvHg2AUSKw/KYuJzeEwmRxVrTgueMc2XKHkZwhVHfn0mlxzSZUUIW/?=
 =?us-ascii?Q?ZxPKO6QlVFiFWlhu6JCz0Npg30QXDnzSoTp5+w5D8CQsFgOmqxjqIaHk+Jjr?=
 =?us-ascii?Q?IBwzPf7i1+yaIoPGmNReddOdVuflZYpQrLLdtbFSmLzcrhocM3k5mtH+fNRY?=
 =?us-ascii?Q?d/GQLwUVk7jSHq22OwRVmzXsiTE3D/iwf+TvbxozQfkY9nMkRkhxTDyhMYpv?=
 =?us-ascii?Q?qDOYCjckBZaTfmAmRVXxtPvu5mZ78iIG1YsjDbzW9MiXXLspQ8DItR7cIKzX?=
 =?us-ascii?Q?sK3dLKnYDVR8/e4UA3FPaUuxothNYze3qztoCgLy9mp6YVgw69pW10CFkxf3?=
 =?us-ascii?Q?0wAGmrADepiCRObpBEwGNNE6KmfNXDDZBG3c8ftfeAG63Yx+fXgvIzzXyLYc?=
 =?us-ascii?Q?JEXmDsMFWU4xO6nt6cW0rStk6a6FRGxHpaUHYjm2S9AJhMgLsokei9ySlMj0?=
 =?us-ascii?Q?T6shpV5DRuBeI+2If1isCg0pKeQL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p3o95OrzfMsYCkftN86W4RHpMN8cbI/sNeRJwwrqpWmq+1R4lHzFzZ3CVcoM?=
 =?us-ascii?Q?VQVG5Su1rCWmiuECzQgkkhRTpM3ymJCe8lYfry37E8z/9TB0Pk8+qq64cPXS?=
 =?us-ascii?Q?m/KbP4DVEKPxXQnI8XRsY/CAaWFULoO/VPJOoUUvyOrpQiq7NWAKwwJvu0YS?=
 =?us-ascii?Q?K2fmgEoW8bSWsrBfz/wM/D8ZPf6UC6QuPdBSJGBcG/zurUOWkgfa6WpDbW2e?=
 =?us-ascii?Q?1DluyoS0oge9me+lBgsrV5HMSPLgdgCFzust9kth3TGV2rpKYY+mcf+0Kb+N?=
 =?us-ascii?Q?5EwXYPvpeEt8YJXMcusHjKPn1LccpO5OWlEZuMpoe1BMHb8H6ZnVGdmTHEzd?=
 =?us-ascii?Q?1RKnsCstoLsqbTJ8xWtYoG48ks+TpuLvWLnWLprFT7WLfEUo8a9R3aU77Z1r?=
 =?us-ascii?Q?XShRVJc8v7bQPU6/zUOqW+F/bTMYhxS8R+zj9hhdJdv1dh542TmYZqdPMqt4?=
 =?us-ascii?Q?mmxS5ZkKyO/0gIkjl7TlBSlCqVz7DRKtGcsvpaqxQ/T0kaC9xPjPMwQKj9yU?=
 =?us-ascii?Q?Nt/Nvr3Xff+TKiItfKFB4HZSYS9yR9ei/Ni90R8fe6hv3LCDxDo9wb3DgXRb?=
 =?us-ascii?Q?btyAbSTCM/9hy6EDrb/sgs66tHE1HWIbKpeJ4jPdunPM/DrzBLa65o3rm8of?=
 =?us-ascii?Q?6LnaWm2BFOvAevtYc5fyzokNekp9NjBjZiRuG6qktGxZeYzHq2AN0ntyGWb/?=
 =?us-ascii?Q?1KvjGdAFGmFzRbYAeMeFlJL1eGANhsKYUh/BLG6EZQ9Q1zT9mG/eve6pumqq?=
 =?us-ascii?Q?Y++BlnO+1yR+lAayNxA51NlEytJoCBrJtl+0xlpsGR3zw5VLHNOMQSxp5Ps9?=
 =?us-ascii?Q?+asIEhZGVxC0kG5Z50LGaR/kawTfIXIwEiJkBT9P60whFCpiM7i1Uvt50rIs?=
 =?us-ascii?Q?OrDqq67V4J6Ld89ZaRVb2OwBCjZEQQ7LOMJDJgAUl71zOOvjsuwNvT/1L9sL?=
 =?us-ascii?Q?GLaMuPBfXNH0fQovjhwMAm/Od7ukRRrlpJvuTLoxEMxfyWLEuIRTB676FinE?=
 =?us-ascii?Q?6VifdTcSxGrXLrKxOMbEn6AR+S+DzGlBMA2McTMs9OcIe77Xcu3tZEUIgXOF?=
 =?us-ascii?Q?AJPAWsC+lSlR/CD1regMDDyxkCU70d5JZN9+TFEB/Ebf+DxdKc+WXOZvGOVN?=
 =?us-ascii?Q?VD8/Mei3HkgwEKyftwFLA0FXS19+jf9/ClK31fzzk9p+bYH/5Y3IX8JXeBmd?=
 =?us-ascii?Q?Rl1wEuJkUAM8YVLRp0lcdrWP4mvKRjT0mILeQ/WM9CBSpYmMXbUTD0U9cegf?=
 =?us-ascii?Q?ZLO/TZY29Y+tX4OXwvjSv9Auous0a12eZOJlgtlsH5A1/wbI1X6QrLu3CMy0?=
 =?us-ascii?Q?Y2bwui53aanEjsHbQzIPLjbcemY+kgQ7uRxsfQ4Ni4dpAMPBpNB/X6nLqUix?=
 =?us-ascii?Q?zTUqlg/y11HMhe13b22F20TM5+6yydhUyKU8QiTzymbcMWgiIrFHuhiB99vu?=
 =?us-ascii?Q?GDPA3uCZ06X+zfTB7hvTWvBssxovlJ7RGb4mjneMk3Tw5yPNOELY3CoYY+6e?=
 =?us-ascii?Q?UmadXVaF3B3yhSS1kBrRuZRpeOw6vW4k6ZSZANtmx9qj9BpnkgKqePV0Av5G?=
 =?us-ascii?Q?j+9bbpqsOme0AT5gBS4jQErEbIFWb/QYaxtSmG5ySk21imCxTvpF2Bb1kfdu?=
 =?us-ascii?Q?w+2vThTvhid0FZyv3chnuV35hNAVpihVCfbjRDOozrfsF1+FutnSMrTX7nKN?=
 =?us-ascii?Q?OJZLQQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XDXetbU3vq07nN1BFAbKhjrKHpREE5X3/2k35KPavO7H1zoPzliHOZAo0fxldlFLb1LGlSijNnt/YiZpySsuO7hURB8OPkepY+9tInOhKZsTAE0rPKbGstfAj+DG+LuIvyhgaWFpPgDTfiXRTq4tWGHZR/Q5qZhJZtWaxg9pOw1dqrEsWPe1gm2FsdA8NPQi8A3w14n+ezBdpmPJe2tLk60d8WgaPDlOD4AHMG/hSJIjlgapUi+YW+H5vZGT3gw0BuKrL/l2hk65gIs9BefNZebDm8zIWjBgHN5yhBSXLfbAtpM+JNEi/uhl/F8MXGkbLbuPXRoadrsk0VbBoDf3t30VoN7ivKz0vSsmmAqImjzR2RcW7FgoPMQelNji3nWyzwM8B59qSdtQyTSVDQ1/zkLqdNLlbXW9jCPBgMFzvd4XoFMs03+nx7rzkodLW5JYvlVe93sKDmmEyrXsvTCa4Wm+WNn/wmfaL1BcV4sfK6GJj5rOXJ0riZm+6qI9jmSzj1nQdiprKpb1fyfmhLZ8+1Co5qL46LSUA+kysAkiSFn+CvvVF3yGFJOV+FzMPxJ3K5Ir3hz1QgYitstEAUU1TJhovNw7E2kyePMHMN+Ur10=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73dc8bc7-a59b-4bcc-9320-08dd1f98a5cf
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 19:17:43.4782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqquw6Rw6Du66Cdsc3zG638Kq/z8B4pKmcuEFuYp4RG6Jhw9fvEekzsPANPOr6WFdES+h77hVI27TjDWzJrExOZxlQCaaUW9lg+CG0fUCMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_06,2024-12-18_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180149
X-Proofpoint-GUID: lRzUXqst4cYbiHapujG1Ga_ENw3mou20
X-Proofpoint-ORIG-GUID: lRzUXqst4cYbiHapujG1Ga_ENw3mou20

From: Chen Ni <nichen@iscas.ac.cn>

commit 7bf888fa26e8f22bed4bc3965ab2a2953104ff96 upstream.

Replace a comma between expression statements by a semicolon.

Fixes: 178b48d588ea ("xfs: remove the for_each_xbitmap_ helpers")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 876a2f41b063..058b6c305224 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -705,7 +705,7 @@ xrep_agfl_init_header(
 	 * step.
 	 */
 	xagb_bitmap_init(&af.used_extents);
-	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
+	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
 	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
-- 
2.39.3

