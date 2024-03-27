Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221EC4A23;
	Wed, 27 Mar 2024 00:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498416; cv=fail; b=HvSysXGZy/3pWX+xNrPvEURTtbWjnqjLTb0v+aqV6KPlaoWpkXHqErPUzuiwG3XEP3alY7cRM3HL20n5mXpu+QdTFs9cwhLeyheP72dxt2bmzEyqshXxg03jH5bd+ZcEoH7bdAiiYKJRoYwU+bhkvVJ5GRhZBcfeav6jm1nlu8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498416; c=relaxed/simple;
	bh=RpuUoEYfHIi1Gp8txTbHTd+2fUOZfrpbaDqBFF99w+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JPrua+hp0aE/h+7MBO61Sm2R4Kb702cJAf8bqkbUrWF8k7RsVr4JRSAdcbBdizBnA+w3+Hd7q9TOG2qiwPjpS8uTMgYAqouSbmYLNE0uh2QNUmJs5HNWczLvSv+FRJG5iElvcLeopgn9B2DRqC6b6sBtH1Qeclsu9A/vT38EueY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LRSes6Xc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wZ4IW0Oj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LRSes6Xc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wZ4IW0Oj"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLjlFX019156;
	Wed, 27 Mar 2024 00:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=4lqzprB0ib6G0Q7ETtN3XreHQcJ2RiKJpG8b+lPu3Xg=;
 b=LRSes6XcJoauG0+/nV6nDo4zRn8xIFIUXwdixA4LTqz1mg+oF7hGcnB93hn32KLaUB1U
 hucoEYZ8hDZ/QQQgKwJnir3sKUCikZ7eLSKsTwkeWdsyDXGNttDcGj4oUzBkHEGELR43
 jFwraf3oPGcMBtX2hiztbRchILMUjUqgCkqQP3EXBd2PQnDbYIC5kLMOIb9Y2D5p9P6u
 THGHneYydiKBrmW4EYfMaWFhOCzZLwbX4rwjStvr3L2LBGvUAeUUVgk/WQIU7Mvt1AUo
 Alhow+MmoEgPUSLmH7NeC5q2vEBCL+rdajZE07TGbBUPz/p+PBMJe9CXNBduT/XCgBr8 cw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybp8ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42R00VYK021951;
	Wed, 27 Mar 2024 00:13:33 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh80xnk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atzv8evM0VxZHm5+aclhInvLXRphDI20qgaQtwNUQT4zgxWtRhXpA/lfCclH53KtkWkK+6ouWlSOud64JZrUDaOZbBPthGa9fK/HbWr/NSgvt/XbURfO4dz3OqqtkPndDonzC1Gmkz/ReoI+vLTiUMKfvnPUqnH6DYO04jhOdyOfybZif241fcUEG2qifwWocV2Khg/21oyTeLVTkpSo3anVxY5cjRMHa8SpTvVzQYntMcmai8CmWxkMyUzD7lbme5PmhqIN8Uo7CMV68u7uOwpBqLT62ldNQ+EU6SmkGaAaNzs705EzBjlSXRlNjK6AtYToBCUt+5J+CLKE3oYNdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lqzprB0ib6G0Q7ETtN3XreHQcJ2RiKJpG8b+lPu3Xg=;
 b=NCTBnJ9MHcJQc7cDYdiOcKmUKRGMp2JVwz0/wRwi/7fYu83H9U4LQnpNC4CqNICvpTHVnHArTtzbVVtJlbzkaZbB2HGEweB4TaOzjkqIfUwtKRIpRfx8kutIVWjOHGZsmKR7mfHV+LUmzMWOzuj1xP7x8Ls6TOce0D84GJHEmZn9OlixExXhEkL5QgeOLA9nPXcR4d1lMNUfgEh1JcJkrDsTN+7Vqr3cgj+/PHkoJ+Lci9zYjx0QkAbdi6XxZI+jezmn5MrAw53cAXD6WDXBFcMj27qXoo9hfifHMCqYd+21Z1DqbDUbPhnB5uURcyuW37CmU5+e5YgPULO2DzYIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lqzprB0ib6G0Q7ETtN3XreHQcJ2RiKJpG8b+lPu3Xg=;
 b=wZ4IW0OjhLbltPyKXTFy5DRVlyDZKaSkbpmsAiwe+JxUu+JqIoVWF6AoCsFUW/f4S7qYMD1y4N9PTBScaO9uFk+pJYT4qXYBUQ0g8jJTC8AOHLgcpB2/9bwkM/80UoVl3w6MPi2ihdvKshdQkdDKr6njbr0W1Ywpuih/C9/Ttt8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:13:31 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:13:31 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 24/24] xfs: remove conditional building of rt geometry validator functions
Date: Tue, 26 Mar 2024 17:12:33 -0700
Message-Id: <20240327001233.51675-25-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240327001233.51675-1-catherine.hoang@oracle.com>
References: <20240327001233.51675-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB4897:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	sl8rGLdRysTs3N83nmwDp+ZjHZWE/vaUUPNK71jeB2HiOquKyVRtcSkXwlKKztCf2WCAW+3NUV8CtDL2LjHKhUEhH2bUMEVH4jgjBoqbzGuEFV/3Q7laJCj0tB6ePnKdtoJ8wb6Aw2zNSFaURm4tuAXgdAkmK+5y8SZbba0JkWvE71+QDtHX//qnZtqFf2DnKWUiKUdkIz5Zulioo4I5fstCFo7a2f7cExaCdoXJHajEJEah5TWPNa/iDQxYX0KUEiYOj85RyKFW5f9uh/bj12EKrb8KdBtAE7ScTjOCiGNG2OIkNN0VcEWgMK4JGYB+us3e6hYQ7ooNL1k1HKUQxoUpE02mPP8cQieHjzP7QkT0XZjTrGN7jRQ+jKr9WhBKPpInem9xgr+SoF9yLZ7EvRNzXuUomiWe4jUpCqcYsdNRqJS6we1T9/iTpamRk3978birNjLHuwllYOrWNdeGxeC8+G/Jve8FHJHRdfiGP9B4vCgGzuKzzFCoAa7g03L0XQ5llQ4xYx0/qHWcQvwKFq84L0EYGGpfyiS2xyqgSuD3LzFNsXAIYOhe9SsRV/HXA85iQLc+iQk7BZaE4oyfIFHJi+NRom6e4tHBJNTvVCPIHzNBG3vvbXWT5HC/1ME1qhzd39ldj66vgxJbsfPwqLLr+V5guyG5VfUJjB6cLEg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6L4XRu6GzP5eV/MCSbJ+5lQAE3VML/5/KfpdEHln5TrSLKugDglVCJ7GkM1D?=
 =?us-ascii?Q?Us7WeVVvRt4N3G2JMDRFZGBc1qubQT3OBdr43Y3vuDqKYC7f5y0cgMw8I+P6?=
 =?us-ascii?Q?OdD+1FqpMYjfyi4gtLUc8cCz9cu4+z3rhmQc80qxxx/J6pdjBURqXsd3SA69?=
 =?us-ascii?Q?YlhzAvEZFrYiqs4Z8E7Snq+voNrVV80FNRQ1jLofnkDy3ym2+TXBpZ55kRCJ?=
 =?us-ascii?Q?dZLNCQIPdInP8yUl+HT042oSelbiR7ykfWJ0a0VeUDpeJ8Trd01fBWwJq7Ye?=
 =?us-ascii?Q?ur17pUKX2zqmru3OmkbVhh1Vm7orJfVC4aQq0paGFXvHu/7zqTVDskD1FfID?=
 =?us-ascii?Q?goulTud7pw7yy2yLIFeBvN/eW8IDLrSdn4ExuxtV6Ytl/i2aYQ/WGxZkd529?=
 =?us-ascii?Q?fKrnK+89w39ZhqJMod2mRsFNkXAsElggREj81bIzImTekOGDa9pThKnKd9ZA?=
 =?us-ascii?Q?qIu8P+Bs8Q/u+jg6/VD7Ap4p0AnNMfInfGNkHMKGhKrt9kCX0WOYBJx1Ou+W?=
 =?us-ascii?Q?EXvidD1JHMTTPFHfO3e87nKPKNENEyXO2lql/X7DadCPVkUdprF2zgPFxZ+e?=
 =?us-ascii?Q?6J8gqs1lUOncHBpt831p75q4whBsofV1Z/tmB4jnjUf4SJXJVUwMKw/zKvmj?=
 =?us-ascii?Q?HMi7UjfcMQHex5PLRmUjgzMJSV05yERk+IS91wk8xKCw6Nbneyn4Wi/l2KFk?=
 =?us-ascii?Q?LhtO0t0IwoSXnPgXGzxg/t+ygNPMTh/jZE4uYpapY8AFObD6GmvsZhrysnVx?=
 =?us-ascii?Q?24fmZAYNnfXI0EDQs+PCOTfX5g+v4VCR0XM+gHhN6y9k3qhku0e+gPsDUtKR?=
 =?us-ascii?Q?rf4eNJ6RiRGi7Q3HMZAKmofOFmJjBl0mJrj2ZGa0GWHf64CZljP3e8aS3gS3?=
 =?us-ascii?Q?cmFVps1O9zDsxUQtb8hofcMpYQVxsd8ZpwPGSGOMHrqvNe322xWgMUYXVUYB?=
 =?us-ascii?Q?9vaT3Ob8qEyJ4TvkdeMyKPsjFyt9MMc+n2EnU+Qe0dAlqRH11VUTSf+oDc9Y?=
 =?us-ascii?Q?QoPuhK5TyyrY+QdoEYRlC7FAerzKcPLlOjnpy/E6wRSQyl9lP0+MxkD/acrI?=
 =?us-ascii?Q?K8uPdjhuGDvbzDOl0656LzqvU5ucmqbTWicZtBD4zrI0XXYxDR4IV5qMiEzI?=
 =?us-ascii?Q?N5PZ9MO3z5HTJGHV7TJ//HN12SAcKuHfRnAX94rSBYLAMSXTujTdUe89UxFc?=
 =?us-ascii?Q?kkce6tAK84aNTPZ11QsLS9apFx9NE7QWj5kXth87xujGO2QGURuUINUoxxQK?=
 =?us-ascii?Q?Mqv3SuJodTjLZFHu+qW4m6DBeJasoDIF8dip6u/hfC4wLqB+C/67XFNGQJpj?=
 =?us-ascii?Q?kxcU1AH4SjcRiiNMHhkPN7F9CMZlwKnChcabu4/Ai+ECsPE3CvlUhN+fEvA9?=
 =?us-ascii?Q?JwgthVIfczYSSB09pwdJ36K24pksIMW0/Le5ImX98bRafZaafqM/uxeStTFY?=
 =?us-ascii?Q?1F/KzKmJmioUf6TZLPvbYcDhjdBtbyFn0hh93eW/Asaq6WgRGqKANOUcutCQ?=
 =?us-ascii?Q?8Vv7Md8kqAIGFXe8c9o8wC7hlqk+h1lmeU62eMc2a/tyFMlLlB4IKur186El?=
 =?us-ascii?Q?s/12b+x9zt4PqHU99PI9eW4mAxq7dEt3PRIxTS92SUGQQ5ZhzGBhZuvSFNxG?=
 =?us-ascii?Q?m0NTJGI8oCA0T15cEadb6nYn9HLG/pkF9aVc8LMiX3F+Y4nIZB1NhEx1smn/?=
 =?us-ascii?Q?IYPi7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	snNPH1M5QkPlLhbrQphY850UhvbhEJczBrsuis+w+DNnS9eoNpBBm+t5JcVRb8dl6itTZpEoRzRhYJIWYBK20+TK0Ot+zCe5dzCGoVP/W5ThAC/1JCKPTA7uf3PRHMTsyD/HfIArhos2XaoNtx49xJ5e9RdNPFRTp+iLezaEP/nJufFGWC7L3Y3/mPSJD4ma1/D4SUdZSuy3J9qX7l4Xzzq3Bvzdx6cKkOm+eQVOWzSJHsFU30yuY01ij8zwCvBecmlIgW0U3lvBypoal84SdWtxhGn8B8v0mNYySWS3fmE/yTFzzvYRiaiWGIHzp+T9oDbyFlFUjxiOjz4Nld7X9yXUPzMxLgD7VeazphZix3aJl6dx1gUU+laplYSmgiM9IE6NiQWKZJ4BbuqinmeNwIfmBwjYhEsg21VDBikZyf1nRFdpPIjiBaZgXuokZ/SblPtFRdD9e87CeBGpkyXCB5CSzknMCP7MkeaknzxwCweV76ZziVGQE9KAhrE7kRJ4ND/kXcALk9MDJL37dYKCvtnnqymYszE5OqXzKzWWNjSAAralN9YXeSBWTNMiwu9Lo5soi8kBew0BAfkn+9dUBnYPhfQKTxxgPq2fwBzMuys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51866f80-c997-4ab4-54fe-08dc4df2bc3b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:13:31.6514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dRQ8rIoflPbJnWGPu8VCYsX55dFN938yBT52ZgKa3XGapvSu+EJ5PtmEzPvzi28ku7v3sKQE9H1loag8b3waP63QW2HG6lcTb7iW4Q+zb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: Pq2WGTIubqgB13QQeT6q5gDXsEwNbFCc
X-Proofpoint-ORIG-GUID: Pq2WGTIubqgB13QQeT6q5gDXsEwNbFCc

From: "Darrick J. Wong" <djwong@kernel.org>

commit 881f78f472556ed05588172d5b5676b48dc48240 upstream.

[backport: resolve merge conflicts due to refactoring rtbitmap/summary
macros and accessors]

I mistakenly turned off CONFIG_XFS_RT in the Kconfig file for arm64
variant of the djwong-wtf git branch.  Unfortunately, it took me a good
hour to figure out that RT wasn't built because this is what got printed
to dmesg:

XFS (sda2): realtime geometry sanity check failed
XFS (sda2): Metadata corruption detected at xfs_sb_read_verify+0x170/0x190 [xfs], xfs_sb block 0x0

Whereas I would have expected:

XFS (sda2): Not built with CONFIG_XFS_RT
XFS (sda2): RT mount failed

The root cause of these problems is the conditional compilation of the
new functions xfs_validate_rtextents and xfs_compute_rextslog that I
introduced in the two commits listed below.  The !RT versions of these
functions return false and 0, respectively, which causes primary
superblock validation to fail, which explains the first message.

Move the two functions to other parts of libxfs that are not
conditionally defined by CONFIG_XFS_RT and remove the broken stubs so
that validation works again.

Fixes: e14293803f4e ("xfs: don't allow overly small or large realtime volumes")
Fixes: a6a38f309afc ("xfs: make rextslog computation consistent with mkfs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 14 --------------
 fs/xfs/libxfs/xfs_rtbitmap.h | 16 ----------------
 fs/xfs/libxfs/xfs_sb.c       | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.h       |  2 ++
 fs/xfs/libxfs/xfs_types.h    | 12 ++++++++++++
 fs/xfs/scrub/rtbitmap.c      |  1 +
 fs/xfs/scrub/rtsummary.c     |  1 +
 7 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 8db1243beacc..760172a65aff 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1131,17 +1131,3 @@ xfs_rtalloc_extent_is_free(
 	return 0;
 }
 
-/*
- * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
- * use of rt volumes with more than 2^32 extents.
- */
-uint8_t
-xfs_compute_rextslog(
-	xfs_rtbxlen_t		rtextents)
-{
-	if (!rtextents)
-		return 0;
-	return xfs_highbit64(rtextents);
-}
-
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 4e49aadf0955..b89712983347 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -71,20 +71,6 @@ xfs_rtfree_extent(
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
 
-uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
-
-/* Do we support an rt volume having this number of rtextents? */
-static inline bool
-xfs_validate_rtextents(
-	xfs_rtbxlen_t		rtextents)
-{
-	/* No runt rt volumes */
-	if (rtextents == 0)
-		return false;
-
-	return true;
-}
-
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -92,8 +78,6 @@ xfs_validate_rtextents(
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
-# define xfs_compute_rextslog(rtx)			(0)
-# define xfs_validate_rtextents(rtx)			(false)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index acba0694abf4..571bb2a770ac 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1375,3 +1375,17 @@ xfs_validate_stripe_geometry(
 	}
 	return true;
 }
+
+/*
+ * Compute the maximum level number of the realtime summary file, as defined by
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
+ */
+uint8_t
+xfs_compute_rextslog(
+	xfs_rtbxlen_t		rtextents)
+{
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
+}
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 19134b23c10b..2e8e8d63d4eb 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -38,4 +38,6 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
 
+uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 6b1a2e923360..311c5ee67748 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -240,4 +240,16 @@ bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
 bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
 		xfs_fileoff_t len);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 2e5fd52f7af3..0f574a1d2cb1 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -14,6 +14,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index f4635a920470..7676718dac72 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -16,6 +16,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
-- 
2.39.3

