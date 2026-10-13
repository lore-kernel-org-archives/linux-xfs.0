Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAD641D631;
	Tue, 13 Oct 2026 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884345; cv=fail; b=ktoKcFlsUOawd+hEbVtrBoGT70Jk7VAGCYRO9fNMV+eFvH1IzFoXxvGpqxPa3HEqnM0/M0+GnCdtsLcqwihAmTaxebvxEeA+iyNkpjz4xfbLXrqTB2xPmjMq8ATeXEcEECEPaWxQ9yiy4Xo325Lh8EY0Pz2dbhPJbT8HVSPdeBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884345; c=relaxed/simple;
	bh=wIC5ah5b9G3A38/PIe7V+7NvkOdhNmjbXQE4d+4hioM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KgleICStVdY98JTsNYOUbygjS0bJSQJ/dEnINaCHH1bSil3D1k/FWaCJk64Q8imGfExxCcv7SEFZFSof5CfPNq45YWhUd8p02mQ6x2vAu5m7ren3mmwQhNzmtf/oX9dEow9iTn8ztgsgkMpxSwHuv+ILDJ/wA3WfBu9hBjfWTR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hxKl5o86; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=akUs4+iw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hxKl5o86";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="akUs4+iw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BpGF3197993;
	Tue, 13 Oct 2026 09:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=; b=
	hxKl5o86c4u8gzOq4MkEhp495AGfebsjdF8/7AaKhsOVReDxE5HOcWiOV9Ndd143
	100gHr93G9yU/lS1vgQLd27jUqo9txzrgeM9eFg2Hc02i0NvseLw3FD2VZOQtRzo
	effNKZM6xI2FqnvGjKRh7CB25PpbNNHWlHsDi1i7N7W07su0PvBASixPue4WrP0O
	w3RpnGR4EygEkhsA4k3WNeR9rHLAdtRnnuqyeK3jSzk5ewCT8Bp6wrEDOppuunaC
	33qrCTXK0YT0+tQlm0mRnUvRmtueo9h616K/6du0IZmZQrGXd7I/W0XXkS2tcTaQ
	0MLivqmA1ivafEfIy1y2BA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:39:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aK9I026255;
	Tue, 13 Oct 2026 09:38:59 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt92671-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRMw/UHv4gd0OOeQDZl2ltBOmCZ4pJwof4vD0J88Su7IK9DEHVErugnAE9uk5ZOPzuK/KE8jwzgMA/V/AMSigJmc3L8xmOOQeNvhszeTHhj29XKVwRIrkO9P4qT+hzD2wwH3Ow4vkgyWrsyA1MuXALMxElut/Gi8RqwwOoW7CMRNyPF6LOdEvedCUshBTtHM7Xx9Su0IZNe7ikpl16S7JbYecTCbnvNhjfCKbT24V7rftirSJ4v7YisO4K9QoO/BLxkdWAoijHJtdyEjLv60isufkFOm8GuCV4fCuYq2OPgprW/wUfdveoVDlnA/pwGI0tTO5fiuX7fL6QqoQTF8NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=Y5iitbDNAhOtx/ne7WAQ9az7Mso3FspXEtxLDTLWN8IRXNFNDGCyK2B5DM4lrO7jD0JVndYTPQiOPW7d6y6ANZuEi0hPSgGpjJ1uEF8fAgenFKb/CM9wam0E8Vl0uE+0N1UwbzwvbJcqh/nF6Gm+2As5ovtVD7JvamXOL2TYBQs6+lu29cPmPZ4MnIciFX0e9Oy11wECpKmf3esCb2XM30ExbhRET4evHh15gK1bU8y0PBdstBitzPoJATInXNS3ykZRdm+iZcBKoZRFkyo4bOReRkNlfZbqIQ5watLp8aqoeQ0859TowRbiIJSHYDPnvboA2rmjLT6+scdtTViqXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=akUs4+iwFDc/SGDs9gLsxE3/RxG+xPH6JFWuGnF/O29F92/mpZaKlKRI0e7A1hUxSg4izUdYuZPlVNBqqQ6prImR3ziQY8RAUs3X1LPYWABr4uHWLxzgf0P28XHyQ/vBiSpAVxZTFf8bAzG9Naxp+bZ2Nuii0jGTZSTxGIlovR4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH0PR10MB6957.namprd10.prod.outlook.com (2603:10b6:510:285::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.10; Tue, 13 Oct 2026 09:38:55 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:54 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.1 v2 4/5] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 15:08:31 +0530
Message-ID: <cabb67cea29e57cccc9dedfd87c57dced80e0122.1791883290.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883290.git.siddh.raman.pant@oracle.com>
References: <cover.1791883290.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::18) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH0PR10MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: d3d40c64-16fd-487b-0aaf-08df290dcc1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|10067099003|261009223027099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	40dG7SU9Z3CzSHr2UkuqcFXRwXXBIgEkWcL50EHLZTZ92f7yU2otesRss61tgrf54kY9rHqY/XDNsGRsv8FEr6QX+0UoyQQMAJC8FE4HCnQ1EIRd82cGScdhyQCEoGNNxkTDe3e+ujpUe2SFqmdiWs4fWWodHeF3+hrkqJhwlkhfjROHVDnoiS54Xedow3V5BF/lmVEM827NBkKcHMlkV3l8zaDFLvYdubsnqi+hwMFp4zVcZZaZYAGu5tW7dq1ZW19BJ35n9CNIVd9cKy/gguSNCGOmiAv7CfksDcWnnv1STAVRv2DyJkHsLJjMX+z12q2VR5OraPXafkyUZ1MeItDVnDH9FRQs+XPfxa3FzLMhF3W22AdJl/g3Nc+O5gefTpQFgdppXozs5jyUSnOACPLW2Gj4Zs7ie/mY1eVZ1dHI7hMYe4DAGWucC/enNTLQqCco4YvhfzgZM3iscYz4USB9o+FNdT5k6kTiFJKvaAW4sGIl58fO6LT33X7U7nzkrWbCTZh8/fpC97mX8hgWPPnnkU/idIHebNZMQ6Q98J+Pq8PfL9Veq7RnpG3I9VDghkX5m2nq9eoDoh1Y0cWbaEI7puQSAGnhNoGsm7SHdZPjsOua2+/6Bs4jROxkNyLDmu7MSfyb7ltRohxc4+huPqLQRVWwSvE9BeWDeisMx98=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(10067099003)(261009223027099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TSSa4HxMDHVqb0HEtGprqEzQkJ9ILc/oedBko2eqwTJKNWro4Exmw3M4uFBf?=
 =?us-ascii?Q?Wjf6y5sTBQ8Vy024MFEhUA3ioJMmna74uWIyqKYCMjdfX6+W03jRbVdJFyhf?=
 =?us-ascii?Q?CfcvSDMbiV5LurKqCAgpqNqKBrsKVHwl9VoNw6GkXBVtQy2Mu0x2aAoCghRZ?=
 =?us-ascii?Q?/1B/8CrYhWmwxweHQhXIMx6+quAuUu3MRy40AtAPZBnQnrXCA+SNz5+iu+2J?=
 =?us-ascii?Q?8a4q2VQ1mWXAPyhfHx+K4WBa+cyjPzPHNgJIZpm1tIKg3YG2DyWsmQD3U87+?=
 =?us-ascii?Q?FDIKrKANJCtnwE5YpFblbOvZ5fR+SWrAni8clJz+w2iXLlxsVpuWJUugMcUP?=
 =?us-ascii?Q?poBFTZluvxVAgACV8m3mRAPi0IGkrxHyGp/annKJlpAttawmDXwa8l3p7iNY?=
 =?us-ascii?Q?0W+cVyH+UCWTpXi8lEcW2vgCN4FzkOf+QT3DHVY4Q/wx1yMhch4bWP+cI7RM?=
 =?us-ascii?Q?HD7+u3G6/74jMY6FkWVI6t67cUgAbuPCmOM84imH/ypaNpL8HFsEXTTbQ1tf?=
 =?us-ascii?Q?kkVZn7Ae1eFlNuMDQzEj6vbJzHhbMQrZpRyV/Kg8ckFKniw6ck7yLPjo6HpO?=
 =?us-ascii?Q?5hRgyDTwRUqW4ViLJw+obuh0OA/AeNZcRjC6DqVbK739hCjDm9ep1+pi98GB?=
 =?us-ascii?Q?5uUuXExx1tjtnG4/le+KiTVnRCtnBB7Jadyj9Kd3SNlDgVBqZy0cTbjE/9Y4?=
 =?us-ascii?Q?/qx7Tby4PRoJ8/+DS4oTqvfLvVIBj+M9JjT4DhEj62A6rSw1HP7mkNq29p8X?=
 =?us-ascii?Q?lssOm93CelenC9WuQnilWqVKNef3sP3JyAJY6w4TIpUOlFmn4ITTNep0nGch?=
 =?us-ascii?Q?8KbKGyxOeAciYQnUtWlAeklwK5bhi7SXwOBK3y05vRdYVANamQTI/0aMVsRT?=
 =?us-ascii?Q?puvArXi+HHBG4ZoyghQJyfJgJ/kE2amZyCkVUuKqbqKV0AKkwybFJ6ecsyg8?=
 =?us-ascii?Q?tozRwYF6a9T/OsrU60rLl9ce6/gmfyFEx8NvuGqEsoUuxt2F6BoO9aRQ0ULR?=
 =?us-ascii?Q?eACfhR6MIiXX0bExkVBIcAWp6g2U3mrf2dkblPrC4D1o8TED1rODafR48/yf?=
 =?us-ascii?Q?TjnftV60lU8fpVMOmSyKWcfbPeoHr7Hf5BHWHpZVD9w94S3NHrD3aSEnD2kx?=
 =?us-ascii?Q?B/QTofv9+wHNOE2fZShoIrVnXl8xh8Fqs67T08X3xMUgbj0qP/U2sCA19Oc3?=
 =?us-ascii?Q?i/rLa081O8RUZ6cCsxCRTqHNqc7ZprU9HzKb5xZZ1piJMcgQdHT7Xba/UAwr?=
 =?us-ascii?Q?DMtPFwYf6VyirCMshZ89ToW1MK3Jsv0SZQI2MMGcnG3QPloDI6NAsejdMWei?=
 =?us-ascii?Q?yt3peUYn9pJV8W45DoPfkFdZqm68NgN9oxcjFeuJHQ4jmmh6t69ir5KUj+Mv?=
 =?us-ascii?Q?L0oRxDMQzxMLejjkJrFrz/RiathAgfKMf6hgngZ71c9SU0CZ/VK1T1mj0qBj?=
 =?us-ascii?Q?hMyjxCwCZyyiMSpkDq1MfM0ssGSdqGeFchXnahzq0ylRymA/9JLuaGfkKkLm?=
 =?us-ascii?Q?b93/+vFOJ1pVf/hQL0+MKmZE7COmwYNzPF3EYzbdtHBCVLmTULBli4QW+BlD?=
 =?us-ascii?Q?4XkYhhhTsVsVId1Awc78P9AgyCO5LZ1yDJiE3Z67sGDsJpimO08DsDLqJzTb?=
 =?us-ascii?Q?bgG0QB+2jpBRq0a56bNtWli7lZ/Qln4Gpj2sQ525Wc4TQUKzsbT72mr0vVln?=
 =?us-ascii?Q?w5JQP2e87JCbtKXOR0fcWcTFPJe5aYW+aUacav7eaP2c2dMGqch900PJ3BKD?=
 =?us-ascii?Q?f0xmhvvb9k/Fxe8HApgIBH/qp4V6SFUEYVOclM1EhaXVRPaBfOYRbJ0P/DV7?=
X-MS-Exchange-AntiSpam-MessageData-1: NoGMgpgYmHFccyjl3sO7q4o5AdfGt2kUW+k=
X-Exchange-RoutingPolicyChecked:
	IiJDyFLyOdmhw/QuHnm5HFg8AiMplVoygSQLHrbA5vA0AKXTrf5AIPD5jTYZUvAwwkJOX4J1wfVhh+ZJveprpoxPeGRSFe4rlRW1w/3XJP6+kw95Ufy4lguE98uKmpTNaBIdgDITuUaMIV20nuegn8Jq0wNnDwFLn/S9Vm3XiaG/3TO9rpfqrsf/yCKNi7JEi5dHYblb1vxhiO8QfT6JSCWKGcqPzFf9VFkgwUJqaVP8+nUhDgpl8mECIlK/U83Rz9n9DovfuRiV6Hnzgu/8r7gh8akwSi9mrTh0/UPVdJPmC1XXSiYAP7faHcW76DqIdm+q+In/KSU1ZLvThwi03Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SWaXmiAxD1/EKMOt6X3gb8Y6t5o/iXARSe9hv0sbeUMp1mWTiBTS6mViNvMwWhI0BMZEwmSbihyTW9Lbs/s28HPttFBHjmno6s/tJ1m+3eChv347hLhSaXJ/x+LgG7qiDwoiwa9eB66Bc/UvOBlM6DZtadaP6XnerHePcLYct9cHy+bJYDf+wUJ1bZZzBulwdvqQewoajnWiHKipRmiVi2RF/E5bvGDkbimOVodTUijp3M10M6r4FQHr8FMP3+ypsDAvxerS5Ym/jUR1rfezScjA1lbDVLAK9sBXVEsgAp8/mR+XrociPWu394TIjsz0Br2J70RTpDc3dKPGGcsXiC+h9BK9h/Hjqr0r9GLlKQk9O0EM/k4iKvA+65nYAdNSJ0lPLjtyVawb82/51bqDKQQvvqv0ni6Br8m5YoX7VhGfm0MY5EmBzW1djHQGVdoku4YZPJPErx1geWN2ErNAxmCkUg/uLszr1qqyNNFeGS/ZoTV4Z/CsqT76E8gsvcFX8QMH8Eyl41MtviW5qLP6fQDZV/TzCmQtDi4x66O1tJzolwYhw0WCthdvOFFNjE2S6SU7sOvadOJfsAnZhSWW2RvR0bmcGGcRWv/WhkWceIE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d40c64-16fd-487b-0aaf-08df290dcc1e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:54.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g96HMwPT3q9FDZty/hzfeGzaR8D4n0ulS30OUadOB/Dt36c3oExZh6DdLfAXqM0UnocFTOGmWXn1pkFXUOhJRJ4xT/OMa3TLYMzZjAm0eqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6957
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX4ZjwDua5/dCP
 bw0pyhv+7SLD5ATW3/h0sSQ3k/mUPUGvR/MxAT5YPBM+FfYxcSXANyrzXankXFEIcHBTJE5zjPw
 v1YGOUP34RCue+j6j3hRB4MfhTRpVkomiXy/wqQFyUF3FwQZr2f3
X-Proofpoint-GUID: BUV6wXxQXpAL5eoP3ckiotjWwkCq5x7J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXwkj4SHhIFFu0
 wT4IUIBlpWAY/91rfK2se7JZUk6pAFWWj6OJ0c0lqrsLIBVCwWDsZjh4tWYR66WS44s199y3OvN
 mUs0j+O6Y7tWUoekzl+YNacdHG5R3qTBLFEwmyGeJQiUHhxNbni/d5q49vEnnLdJdeBlMaTEuXR
 y/fcpBjcdVjrtdOhzC+yRmeo3esFGbNvfVw2AdfJ7ghwPZgOWfXptjKa5Dt/wLTJdqXUtcBUNoe
 X6Re+wkIMWET6I7Ib4U0Gm6uTClIa8QNozFTJzstgPlIDTHrZ4oTVhK4MpwDtykFkfPCXptm1xF
 2mj0x+RnhkGiz0aBZoD97DIodSg9kUif7TOXEFtYAwkzgIKEhJ4CspZi53Bns25gUkojzQQRs8D
 2fzCGuUNc1tKGf+9AYW8/2/JhDobOks8xFU3/gpwNd2jamWSoPLtMJi5XRCArXQFUa8kbp0xyYw
 Z+Gz6etLSDRuYghkRGA==
X-Proofpoint-ORIG-GUID: BUV6wXxQXpAL5eoP3ckiotjWwkCq5x7J
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfc34 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1b323b3c0eb9..ade89a233e68 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -541,6 +541,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -590,13 +626,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -607,22 +636,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

