Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0E43596A;
	Wed, 14 May 2025 00:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747182572; cv=fail; b=t5yb1prwOaHLD5OJX5MJ7A1dFFNGCRmIyOEdljcrHDrBqCDH5BV/7nUkEJDdydw7FghI5lKFblLBohgfrXiL/1vTbwO7OBpNCbDlefzgKauZHCsnfIHx6ZMd75DpHXxBftb2nyK25kLzXeyVWKEMhBsVNoFKw0liOckRAhbjUXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747182572; c=relaxed/simple;
	bh=3i1Yf8IWU9mcsLy9EFzc8c8quonfL311oPiT4vGXD7M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iFdcnJsgkPMhKdfutFOyxcz/xgsHE/FZxABU2NPFPh6Y/GO3W1u3DpPaX7aRGKLJYbYoQ1ZNQDFhhCr6BZlC4dEjxA34EX9Nvmygzpw5GZsdAJwmQJHI1zq9AuLMlRwMtj/5wgPZDrScrpw8j4Ll5Yz7j6DZX94sMVoHJp150sI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=owqEsaqi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qujS9xfF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="owqEsaqi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qujS9xfF"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DL0jGX002790;
	Wed, 14 May 2025 00:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7V3VUy1MNIDQeWw8lo7mchzGEr1brGtZ+uZkN5MLYu0=; b=
	owqEsaqiXkQRduUMM8f+Oj3Ax9LABgleimSZKBzglYBUVQDi4DkxsRQUTv0WfX8b
	ic7J7dGmliRVMhjjFPFkIjX6Br+GUSR2dn+Zwo7ZNYOT5RVf4pRivLPnI4vad7fM
	HshkpIAcy0T5ByMuuEdjLfGs24BiCzcAEHXAnJxruLjBAlIlvtcsy/U23+1g8KIU
	JKZJiPBaTFwK3PT30rzDNXKb3PTTrv1p+6oySFND/Y93n6L4hm15H9YNRDKUMi+I
	HmB8sSyeX+ji/tm4orGv3swy6Wp3i+QMqIGzkURws9vQQhxPQF3RD2JYcFb1eKS8
	GyRiOqZMj3MPOXznoMixlA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcdrh3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNJFi5033214;
	Wed, 14 May 2025 00:29:26 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011024.outbound.protection.outlook.com [40.93.13.24])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbs8hyvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 00:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qZ89GkjhGpg0qm0ryFvcqD+COw7NNUMDy9ZXoam5GUvjyvqIyG2hFQvexIOrm2z97XCn5KCOCos+FZqXmh+76px8dGiA++YOBALr9vUcuu+XARIyO1J/MKztpprT+PJtbscJL1dDL/DJOBmutCFg0bAjAiQgEm+ojh0muTlCWvYPIPK2qUODVsoPemJF39hh8Oj4433N79HRXk+Q9B1tPey3E4fTvKE0jMNjv/ne5TWK6t56XmaqFi4oF9iHostFoB20Hj9ayONykh6FcBYUQ1jTZZhzyjrvUCiai29Yqi2eiq4tr/XmplwMNOUtr3ww9p/udyRV+3Lpti3dSIs9SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7V3VUy1MNIDQeWw8lo7mchzGEr1brGtZ+uZkN5MLYu0=;
 b=vLIHy514Ahl4ZUT1nBi9hZU7tKuE4MFI4QxRf4ZDllB4q2KQYahC56HZmxDbYlTBsQHQKzZaDQqK9kvu5tH2a/j/CFNmRhP4vECsNugFba1e3DN8DNvwHC6mNoeJIociVQCVX1q9GvMYTfrwSiKwjavWhjAE1bQW6c7ZjWfECK2vWZvskpyCjAgOcsMVd9pVTLI1ZwmSouduj2FSkoTN1bW/jWvwAZnf8jXUyskdI526K50Cqp3NJ7WX/5IpdHh6q+36JT3MH3xB/twRK/vWDVnfo7Mh+1HKVdQkcWN8fFTQb5foxwoviKga88JXEWYNHLWURfoNZcpm2prSNb195w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7V3VUy1MNIDQeWw8lo7mchzGEr1brGtZ+uZkN5MLYu0=;
 b=qujS9xfFHa1daxuLfNnanuXOBjmdIzBs03V8wyvMzc522M159XZlEZjpJRSkU8GrQAK42pUKy2NO/uAv7W1i3qg92fPxUqIA4aqFYCa8bWPem4Z1EomQ3oNLjB4B8YXK7V3IbLQl1/yNcdAx76LoJtfrvMJ6/b1+aCKL4uQ/wNk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BLAPR10MB5204.namprd10.prod.outlook.com (2603:10b6:208:328::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 00:29:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 00:29:24 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: [PATCH 4/6] common/atomicwrites: adjust a few more things
Date: Tue, 13 May 2025 17:29:13 -0700
Message-Id: <20250514002915.13794-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250514002915.13794-1-catherine.hoang@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BLAPR10MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d8a146-6f13-4526-73b0-08dd927e60cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PXTgg44cOXRIItpRE7VXSV1NDmcDn19wYzHNNAhYR9AttLRhai0oDubhoIGQ?=
 =?us-ascii?Q?foVT1FakGrdOxArJuChxgmDPumlqCffM/3Vp9aebdmIH6yPZw1wlClIVCCPa?=
 =?us-ascii?Q?L/9d+4RsK3LfzqtU2P6fbfWComDE7GLHFl2/Ga8SeITD2VQDX0DFmlmLJVfn?=
 =?us-ascii?Q?PTaBP1sfze6QXxb4dTQUQ9ZG879HSXUb/FN8elAf3rK5jeLbVjEIDAqQ9h9A?=
 =?us-ascii?Q?pjCe1Ib1akJzewA3AQJoniiWYdyQAtydEbeC1L2e31MR9TzBXWG1MUFzk2Xo?=
 =?us-ascii?Q?kx60TCNlQMz8fyKRo4gRCls7Bwa5A/ejye4sIPtDTWRFno6JSGEOigjuHUqQ?=
 =?us-ascii?Q?FkbGydZig80omToA0mL8TTU5WRQeJrcjcyUiAko0g8xPQF+crKL6ZSqGu3bj?=
 =?us-ascii?Q?030dzmGhKn7UvU+KIVmS9rwLlmUc+/U7f0xuC8rqEN1T9ah0myzVaC/dNsVw?=
 =?us-ascii?Q?JZm53zGtFIsdY1ZapA7wH+h3uO6SW8HDjIHfYk+o2v5R9FoXktCY5zE89yY5?=
 =?us-ascii?Q?GCEwytrUxPLDjGulvhQRBLZkSgnHx8SGkvKcVUgQC7Hf7nyfLBFNmS1/+yq9?=
 =?us-ascii?Q?gXUYmFLIDPJcoG4naD56grUnTZByp7fyXlpdSZVSetM5QWEDWF1b9ss7Y3Ka?=
 =?us-ascii?Q?I4GMV33Jx+2rU+KMo/Bdhowwk4hgeYV9I0YoBWT+SshcN0mPX4iN4XTa6ABD?=
 =?us-ascii?Q?bDtmjdzK3m4GBnzKHxn1kixy8yI5TWd7lfdKD9YKVLapyMmcgvdd5Jf8kVKn?=
 =?us-ascii?Q?a+akiC1HRzcZ7McQW4ukNAXmRA1E8itQKqgPmS+lY7Ma4R5Ue0bDNKIeVqMz?=
 =?us-ascii?Q?R4cOkKjgx0mP0vwMbJIrxI9WQZ++5fvzO89Py0nXSCxdZ6x00z2hXb6Wtcqx?=
 =?us-ascii?Q?MIW61KiSkvsZKGVNTlKfEeAUkwgdHyK5MemcpUVPjVHjQXmZwVQmULD8o7yb?=
 =?us-ascii?Q?T1gIiuTNqmbwED5iaBFJZHXs+bq+YJ8PdtwECZhFOOw9Om4Wm9+77GtPAZxv?=
 =?us-ascii?Q?8EFFaT9V9qcWrG7FTncEcffes7at7sHhyH7vAbFChwh8diPpoQd6/vyrImR2?=
 =?us-ascii?Q?bthwMeSVQa8O40w4DNPJhtfgTKvzVlavhsHWpea3YDzjyD6BEdimsOi/W0E+?=
 =?us-ascii?Q?VRq24ykmxFuWvKmoPbvR6OAkg1urFm/ZDGS87amlIwl+0lL/haNYmhjZGWq3?=
 =?us-ascii?Q?16/G3jNg6cYp5eCxAYGYfZ5HEhR9ivFZheTyj/UmmONYNqPgPXJqgK0Csp7L?=
 =?us-ascii?Q?s79KqVPB9jUtGb0xCefyXnDjA1JRdJxhtbF4FmtIBcHVkZH34O36b3MFbrl5?=
 =?us-ascii?Q?Uvi0I00mBGns4OtLUNds8qkXc9oGAnklpTSDzlXILTAaciub89Q6uc9ZyAVN?=
 =?us-ascii?Q?S8GBWaCI2Inmx80lI2ktni9ANAYIBMdCdTxObVWvJIsFlWjZdbhIQbO9vFn/?=
 =?us-ascii?Q?5GS9LWDMiaQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qfLxGLu3G64elCsTl8OYb6wCnjlcrPbXgXohNIldrZLoFXo4dZX2c1oDjd9l?=
 =?us-ascii?Q?zDU+U65oIUjKu4cFwy7rINP3ru1tO+sFffhcPC2xKPP4wFTwc+4OnEbvzwuz?=
 =?us-ascii?Q?7zPLiP6ZP+2LfBkXi9702JYAn8ZHsgkRwYN0eEMXKmczeIIuTvXcSvQeWB7f?=
 =?us-ascii?Q?JMiOB6roeAA11cIQIop0G7DcvfXkWc28eq4gKJ9pmX3XS8EVv16YNt+DZ4gf?=
 =?us-ascii?Q?IAOqdA83ilptLYBrK4ltZUJ6TGjW0HRx/tHtuMyv+FpWmQm5NqUV8NVRFP6u?=
 =?us-ascii?Q?+BeDASx5FBnVTqdfLPfTfTBWvRaBXsf1tGOd5D3NdEm5SRBdvjnSdmUZs3B0?=
 =?us-ascii?Q?579dIOVum4CfRh0Cm1ET6WHKpVW3MEhyngA12grwTU+X8qGNJf1uKT/EdTnf?=
 =?us-ascii?Q?E/X+2zQNybVtsWys7VV0HL7eDGt+iX3Si2isO77zwW36QFwUCf7lnnlLw1Dd?=
 =?us-ascii?Q?7nn97lC2c6FcAHGh07yZie3KSTvhs039ydjBxunhb/lQyCTJWax/U49noCiV?=
 =?us-ascii?Q?CbLYTiljGhcgraGU8Jhq4bcIgljDWb3a0RKI8/rXxB+OvnOjbz5KXdh7QMdg?=
 =?us-ascii?Q?qpW2a/m8xtesNq9K10JQhagvU3igstoiAF5+LPtAlSq0eP2c0V5hBAcs8rax?=
 =?us-ascii?Q?IutN5GOV9GzFvFZQt8iTxvPvvGPZ2PZGHUuLFvCyqOnwIE2DdHm4LrgDS2IJ?=
 =?us-ascii?Q?hD2siZ0HyHtJ5u/v7u7Z458IV4oN45fAOxTuYqHdg3LeDLJwYI5P2Z184qMr?=
 =?us-ascii?Q?zBlNvuHJu95oGZiVgfLc9SQXYd3PqQJ1y26UGCEZktn0lHaLSvU3Y7DaYl5x?=
 =?us-ascii?Q?DTFvGLZG7eeQYZdasLIxSG3k2d57cQafxXK9Pu86LivdpIMz5OgHmQJK5ZK3?=
 =?us-ascii?Q?8qlEuY+zGXsUJ/DvG7ZrzjpJmUPoJWPiJ20fcg43qCd1e/W0mWXq5YUDNvA2?=
 =?us-ascii?Q?iboCrQHyHa2FSOxtfbdlgerx2U8WZh27VEhBSP+SU2spMDF2BVgGLH17iFyd?=
 =?us-ascii?Q?pn49IkxJSkLJIEOpJGe/3DtSMsI+/iBddW+NPUMlkIdbs1FmiVcdHJodUB0x?=
 =?us-ascii?Q?rwHd8QvdF650+0ZJKEEe8PPjSJdESZ1RtijKHCfuclEjaHnzI6LJqQVeJYp1?=
 =?us-ascii?Q?DSZ2B2ZjbQCqdqFQE8f/ii6L+OwiJtEeJireSqi9es+rTCfxbdryMyFkAkYx?=
 =?us-ascii?Q?TNqeWARthJIr1Rpl64HNW9NnyM0uQsBLBtU4y917Gk6dplAZXkaOSADuDbpr?=
 =?us-ascii?Q?/9gMe/vOwWcijhqrCRl5oAKHaoDzsrinhdQQJflma5ETBl5Vpo48BTep0Jt5?=
 =?us-ascii?Q?AeXIAIoJUSeC8BcmctMptr6VsfjuwB1Wp/eOe2EITCnk29zH8nQ6AP2C+6U5?=
 =?us-ascii?Q?3wRwJPKBfb2gbyKtL0xdRs0g+khGbcHjh/a7DX+z63oQc7yFpPSLgYhXPBX/?=
 =?us-ascii?Q?TNPcT2Su6Y2xGBuINRrnowfQOZziQCOBLV7I4yi/QOvMOYhLrFHwo8/Varad?=
 =?us-ascii?Q?1X99dTLWQAvF1AN/t9LEvA/JRxYZB92/Sf4Ywd5p2cnOt5dmjUUOP8dUGL9Y?=
 =?us-ascii?Q?0z/8kL8LnClaUkAK0VNYa+dyZB/OfcOrxglt8e85r9jHDoNCI1N1hLVfqfRx?=
 =?us-ascii?Q?KdfC1Wu47bfHMVZCSRrI1uG0uIJblnIt8TVk8XBpyAa/rCeN541llnHO1p8k?=
 =?us-ascii?Q?JKifGg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fcPLSpGVx9tF6YqLew1y5qzpesIfPKj1h7Mq+864gg0GemQCXA8U3F8mgahC5S9dpzmt66KYvpZcg6Emb1nZAj49uZJl0ye/uTaQIRkNX4FDnh28Q/5K4tN3ChLHdG5gx5vOEhwd031Broy3jfNwtN11Q2Tj9lG++q5MZvprf9sDkL7bPsjWmUcrBY7+0gNlz8MP2tEXot346EzHhI7JdAPB51+qKvPgQbJiPYoodT5Nf3YGLx+ilYQ8PGfO3eS9O9wYNOSAIBLkboauojYkBy2bR6IphFV+zzu6d78lv7BZ65dO9JTlNlrMM6iGCHMWZtD38Mczk2HsQVVJ6gg/XkyfonsyAyJiVRtG7Zzjy4ZzQnRybHzR+EaR+j1xsQk9RPU6Tt8tzx0ioe48htDurKPa7ShTgWKaOOixYH/PIwvnpn9QRrDY8kfKgR60IoDOgznAvuENOK/g/UTiR7pt/V5aQ4D52/tJQY008+NjZGoK5wfFOhLrlM0BVf3/QMCedkTtl/3U9xAipWW6iydGSlc4DjyaOS6l8DRJBHAf9dMqPy2UBdZIN1YhzX4vGA+aGnSGW4H/FDDMd9dYU/P1QllhSFetlo+EcBURqvrUBzI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d8a146-6f13-4526-73b0-08dd927e60cc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 00:29:24.5609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: acvR/+Q8rMAQw6z2nxakSg44hREv50cE3v+97KVEE/0HhMfjd3n08TVeqMA1zwxnKmhQD7Fn/dCIjptQ1ErG+g15HoQAniXSJC9DFvcSI/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-13_03,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140002
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDAwMiBTYWx0ZWRfX+0yuk20fKuGk NKzH098ZdFPJOxTJRqST/HvlwTkkihTScmnKiaK4adcgKgVrQ55UTYjEWDoXtwIyon/b+wRy3Rm Il27vG0DXhhjYt/9oxkwlUblmnScoPtHI+QMJxyoOliCwdA6JPtx7b6ZMJFCHFKPiEWsbweCglh
 5iHybokkDqnfEz97OJn3iVz4N0RgjsIAawEMbGgeyUJxiDfybzhSVyAMrgMqpqKHzrYt+FQ2ihd qHBVjtK3jAZW1Bq6GeGPNDr7TWbdS3GFcDUY7RJqMMY0+qjuPmmqtkUik1ZID4ixhCi1ct4OEhW NLlgFaM++QfKC4dUvwtkhizlRkZGGnQdfZJpYtgdsEMzOlu1JhUkYOsGcrMUbTkN0Cjb2ED1fSm
 PvQ/EJ/BtpBjTLmHy1QJa5+3moY6xhdPrH5XAYI4lAN+oZwAAxkmVpzO6aK92eIVqag4LW3G
X-Authority-Analysis: v=2.4 cv=Y8T4sgeN c=1 sm=1 tr=0 ts=6823e3e7 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=-DNM3hN0B_qGNDMabmQA:9 cc=ntf awl=host:13185
X-Proofpoint-GUID: N9gNcv_qVv0RxzSpwuJh3Vl2c3EA4zvc
X-Proofpoint-ORIG-GUID: N9gNcv_qVv0RxzSpwuJh3Vl2c3EA4zvc

From: "Darrick J. Wong" <djwong@kernel.org>

Always export STATX_WRITE_ATOMIC so anyone can use it, make the "cp
reflink" logic work for any filesystem, not just xfs, and create a
separate helper to check that the necessary xfs_io support is present.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites | 18 +++++++++++-------
 tests/generic/765   |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/common/atomicwrites b/common/atomicwrites
index fd3a9b71..9ec1ca68 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -4,6 +4,8 @@
 #
 # Routines for testing atomic writes.
 
+export STATX_WRITE_ATOMIC=0x10000
+
 _get_atomic_write_unit_min()
 {
 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
@@ -26,8 +28,6 @@ _require_scratch_write_atomic()
 {
 	_require_scratch
 
-	export STATX_WRITE_ATOMIC=0x10000
-
 	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
 	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
 
@@ -51,6 +51,14 @@ _require_scratch_write_atomic()
 	fi
 }
 
+# Check for xfs_io commands required to run _test_atomic_file_writes
+_require_atomic_write_test_commands()
+{
+	_require_xfs_io_command "falloc"
+	_require_xfs_io_command "fpunch"
+	_require_xfs_io_command pwrite -A
+}
+
 _test_atomic_file_writes()
 {
     local bsize="$1"
@@ -64,11 +72,7 @@ _test_atomic_file_writes()
     test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
 
     # Check that we can perform an atomic single-block cow write
-    if [ "$FSTYP" == "xfs" ]; then
-        testfile_cp=$SCRATCH_MNT/testfile_copy
-        if _xfs_has_feature $SCRATCH_MNT reflink; then
-            cp --reflink $testfile $testfile_cp
-        fi
+    if cp --reflink=always $testfile $testfile_cp 2>> $seqres.full; then
         bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
             grep wrote | awk -F'[/ ]' '{print $2}')
         test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
diff --git a/tests/generic/765 b/tests/generic/765
index 09e9fa38..71604e5e 100755
--- a/tests/generic/765
+++ b/tests/generic/765
@@ -12,7 +12,7 @@ _begin_fstest auto quick rw atomicwrites
 . ./common/atomicwrites
 
 _require_scratch_write_atomic
-_require_xfs_io_command pwrite -A
+_require_atomic_write_test_commands
 
 get_supported_bsize()
 {
-- 
2.34.1

