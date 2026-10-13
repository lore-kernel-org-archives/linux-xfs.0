Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA84A6CEC;
	Tue, 13 Oct 2026 09:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884437; cv=fail; b=NvuCtkHzdS7kFoZATpqoclWJCF9FooE5uQP3qxnDLm0CmAytHgRHa8XC2JmacHb/0ugh9TnLraMbDg+aGUVDX/cipV7q1S7SoRknw/ATR+8xu8uSCMuhXk2BKc0nu4NROB60Pj7f9hFtoU6JWlH/FzwiQN6BTD/MQCCrIsnZ5lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884437; c=relaxed/simple;
	bh=E/xkZ1ptQmOz/sG91Xanrbd1Cf0AGu6udNOn0S49dQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PHZzaws80wMy61sAA7z85XN7EaQjdrAyvXgSpfNKU05qM8PTy9zZzEESUX75AiThoHTOKhYQ6EV6/zLS80E+s4tEqYC3pPZScadZ20XXtYY9GrWKEbXI8p5mOOEL3ZJGb0WktC/V+M0iLNMIe80MfLzoawuoPRbhRinXq+VoFTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fyxhh5H5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=giM8glna; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fyxhh5H5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="giM8glna"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2v60h4135007;
	Tue, 13 Oct 2026 09:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vPwPMcwir8JMNdahQi0AvpqKE0CBhssd7amyUXFYD/U=; b=
	Fyxhh5H58fVm3JG4o7VosTh/G2X8MH/RAR8/LPhjC67KFpPQdc2FPGfDtUgmI8RE
	Yyuic15DSNcWUL7AXClNORX2erOKjmF+R3fLEx8gOup41YrV3/fjb6+SssFavkbF
	dATCsB118hXJdl7SwghW106t3gwZibASAL8GyuWSQAFG0L0cJyd10x1R1jTSOSBD
	9sJ2/Ik3IYgtFEl3CyQoztEmd4iNe8MGfo2X7VnL5xYzOyR1/jjn8hDgZZGITXTk
	LxkB3zSGe9RkQ76WIoOrsr3cVHezIT5El6+R8oLoeDMl25lzTKsRCZQ36pmEOidn
	FHh6xdz8GMtdr/jycgBRgg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkq9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aJSC026212;
	Tue, 13 Oct 2026 09:40:32 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9289q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8TEj15ENPUswC58gOXtTUIrQ+x5Zw9Z7j/IlQ+vuLJCdVjcxHNIZEm9zo5kT0aIEJgWhQRl2UEOIhYzWwHEzqZYQdsTBl28zF2LmL7tfvpZ5OPEF9tzY9e8NC8fvmpmW03s8tUiDqJU+YWnj686smY3nKLZ8xq3C4LY3S/tzBNAt08NNPcImdQgCYNLrfzdx3EifjnZ+6fNz5X2hL5d74HfNcjgbBCF2FbRr7Q0JH/T4TpzFGw71za+d1ewqLC6kLbdLFxKLE+DUKQU3/sNKdl266tA4me4Vje8VAbCOw1nB/aHuABY0wAAiilrkpllj8hqSFQvw6wH+w4YgNJjsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPwPMcwir8JMNdahQi0AvpqKE0CBhssd7amyUXFYD/U=;
 b=o4QmKn0Itw1H0yQD9GV5bawYdrdekMfMimVMn7DQoOkWpHA3HJty65KfCkv8CFCVNne41trNjf24KodtHXmumvZZWPrInPb01G0z+XrYdh+5r86Uf5eGiQXWKnNY+ect45v3OSFxTXB+XW2df3nfLdpyQ65yCfItleIkTNxQIovuFfiCxX0rfD0Uul07AXkP2yMcZnPkU/D5K848/9os3ArC0tzofrxkLKyH8A8n0cbX6pyLn06P5c1jsHj7GAs1PWjK3T+XHiDTWzGPGPX1dpW8ag29/vNNAeylNFzTy3Oz6MtaF6PIMI3+IhbdEA2LpT/n83vHbOyEeSf6smA+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPwPMcwir8JMNdahQi0AvpqKE0CBhssd7amyUXFYD/U=;
 b=giM8glnax5aGRaSbZM/w6DBcG1WF1CdLEr8E79Rsio9nGdT08G7XhKZH+CT0zfPhV+/ky+sE4oA2gjAj1OsrYUdp5cJ+dBnldjM7PCUir9Y35CC6OxvkMBy0eNMz7QIR7cdyUT815qh63I78UdFTPvlBLEZlK6FYG3xdbnCrelU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS6PR10MB292770.namprd10.prod.outlook.com (2603:10b6:8:4b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:40:29 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:29 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 07/19] xfs: don't nest icloglock inside ic_callback_lock
Date: Tue, 13 Oct 2026 15:09:36 +0530
Message-ID: <a89064c0554a87b7776c4ac53deb2520486be292.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN3PR01CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::8) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS6PR10MB292770:EE_
X-MS-Office365-Filtering-Correlation-Id: 58d4a6b4-d7c3-4d6a-7489-08df290e045d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|23010399003|366016|18002099003|10067099003|22082099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	suQFYcqbeLau68qRuRsKtA5aL2zZZo8jsMSnjMAjaFCqUkkWCaXo57IgTAsbWRaK38MXbVd7motI8SqQmEevTMR5Hac5SKmUAEPLgjH1470lVvYKIUdmvZj/AkPQvvKMClfgP0G/GAg6nMgeIFnxQTXRxZy+PF7b1e3KZ4B163lvK9xRKgCrhB/n7cN+2mKCElU3DKOMuJTa7EXOxkLjcE3MvkiZyPjq7zX0R+zUq2FdBb5DQnLq+uU3QfhM6IiydSi+j2LGFpHG3HyI7BVfCiTqdRk7mJIvrAC4WjAmfUzNQqmeBLDSy/yWO0BiZerhl+LztFegMTCwyjKeP7EmkyEHAZJM0rn/l52VtJRN0+5vh/kc6g2YN+7U5N8oGsGloLv7MKFo+vI0Ja3KjBQy24vliyGQLWIc0xg1aikdDlAw7N5kU2Et6MWx46BuhnmM97Omhv96BqtEnsBNAqQjrcOZHwGaRmj95bKWnCWvEu73QKLepxQiYp3mEGkosUJLvyEQGWPyuY4yae080rGbSnnX1j9daNzmrHvS5TSUNCBgP/J+v7riahS3d0aanfmrI62crfVVnygCub3CApkN9smEe3n8JSvYxt5s9/V1F6l0qofHrL0otfuWkBKWzIktUbi5uoA/Y+paUVCedD7tsyi+wYC+yBPCfyrdG7WgCqc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(23010399003)(366016)(18002099003)(10067099003)(22082099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9osntKHvdoR6VSc9Ggw0qKwCcDxD/yUh6mUkl/K8hNr7Bgw4D5/NcJGS2zDy?=
 =?us-ascii?Q?3uobd9AVcuptxhgO3K7/9Fq4Zr6NJzKNhfFbB3374RFM/DF3mu0cxky6l36S?=
 =?us-ascii?Q?hbsb523LIpDzGR9yCyDQT7/inmbRJjpbl9f+sFUyJEIs8ipAMNd3GKLHl43d?=
 =?us-ascii?Q?KXy6zJlYKrvmaSjSpSWn/DiO/gTmipPk5K6EPcykxHQQO/g+UC5hKfzkI5J7?=
 =?us-ascii?Q?T21+6VsrkE8LjtxqeUtnBpesIxqNNXYrendnwd0DvPU20y3Sw9A3A1UE0dwy?=
 =?us-ascii?Q?Pnp7DjeBIBRiAnXdDqsJDuCCd3L/FWR2mA2kwPsBMPoEdu1uzJZFjSw6Pi6B?=
 =?us-ascii?Q?Dg3WknZllLkvS6l3T6g8RPT46RlbPWkyPC1JjD5sDvfxnvyD4p6lnqnGxsHi?=
 =?us-ascii?Q?mIn1PDM6kCppzasImdhBmyiP+uxpLRvs+JKj06Z6dxklf7HOnKeYVc9y9jIn?=
 =?us-ascii?Q?M3jGhqSWKvTiXCJFgj/Pj99+UKlnqlc+GTZUC7BpUDoT7yvzbcOdtTPVQ5tZ?=
 =?us-ascii?Q?ZQPtEUars5cWs3+zHvBfwNeBESizaG9JHkClGW+QBxbp6I9cMcvXhMLielkc?=
 =?us-ascii?Q?5j4lhRjpcMPfhXh56MtC5A8LwzKyrMx2MJuoYg1hO4/YmTuZljgpoc5WpEXd?=
 =?us-ascii?Q?uGQ0yCJxV13lHZXrCblJ5Wrmi1Gz6Vvd3JRw/zxg9OO+g6S8Coj9xCTXH2pS?=
 =?us-ascii?Q?A1v0CgO41JehOPwazoaPUg8AwR+EVGnUKlC1Hubpn8sAfuJIrQXtbh7D65TS?=
 =?us-ascii?Q?+3g/ImrGXfAXAf/4xSxf7OdYOGexOnH6CX9iW4AuO50oE6trSzk9GQfNFgro?=
 =?us-ascii?Q?mrNCNESM5jIrU68UrMc3HtsfboC445awJwzmtfNGjJJ1DqwVNYdttJ6ViT27?=
 =?us-ascii?Q?Oj4ePI7aQQA3MQt4s+Rsej1rOKoZ8OkyBJ80Z5JeQkNNDjjXwjRAGaaDCGHV?=
 =?us-ascii?Q?p1Q5wrJ0fXDbqUfWPB95/7VzfXe0LbISDUHoobzTN96RsdrVAHb5NwxgHJRV?=
 =?us-ascii?Q?IR6NpYyaxdsASDSlC/6olLgVohmoq3084Rm1X201NdfFGrfa4mJolx8h0a9c?=
 =?us-ascii?Q?4Dg8DDrpBqj9kgIzqql2j7uiVNR4VhNjmscc0Speka9PHyJ9wWFdrGtMCdyL?=
 =?us-ascii?Q?qtNFP885H+I0Du7D+aIVN8Ra8HwHfL2W3m2hpoZuvmoJsP0ig0BVeY1kYoye?=
 =?us-ascii?Q?Be8ns7cFETXUh6liVY93pyDU2GCZugLAPBSgzWOemK3raXGLo7wjZIG5YAoL?=
 =?us-ascii?Q?PW4fW5ohH5WXLAr1EP3v8ybuHl4mPxH4jLdHWSdI2v+msJflywidJaJIy26H?=
 =?us-ascii?Q?ko0GUsUdiqnRJ4BLbEoPzCoqd82rGiz7llIP2l6xENFWaZ9WbBo10OdIIjyZ?=
 =?us-ascii?Q?YMX4Es0YLxuI9XTSFZrgBAE9CX8Lw46NqaTTajEIsIF6Z7qj0XOgTjh30I4/?=
 =?us-ascii?Q?y8ck3hwdYsaMBSqAHSHEJsU5h9TVPWVXs7GJCDUDVZNbjlIOAI26t/32yFSg?=
 =?us-ascii?Q?LtfWsDM0Kjxy8z4VEvIO8dWoC5j/aNXlUdNI13r/uCNK+JmxP8fKr/mOUplf?=
 =?us-ascii?Q?Cg1cRG4vluKnvwws6sszbf6JdXjWI3MIlxrn01hakbMkUSgfkLDFP69BpoSt?=
 =?us-ascii?Q?guuSeVfdWG8l5f3YvNdhYLClQvR9HN5PbFS+pX1s4J508JmQu9D2SX8/+N1u?=
 =?us-ascii?Q?Ve9u7t25yFWW5TkaOwrGjDfFdpTB7MjBUgXKI6qzKfD5jUozVjHpJ/ZbvoPv?=
 =?us-ascii?Q?dfVBFOqzC3o5li2obLAduxza+4UM9IzSV4nBT/CIFGeyUseziLAIrG7dJ7fK?=
X-MS-Exchange-AntiSpam-MessageData-1: Be9NcQ8CbiuRDE+cBbULZ77rtt6h2M4m9hA=
X-Exchange-RoutingPolicyChecked:
	TkdnUxh/01oLB8FzrtllG7PKRrmJhvp4CphMWUgEAHgQC4d1W7aGni6JgBHeWDWnIwcSiVKCPK7ERqa0h+5qThwD1FQrOePe6mEqbIKuTjhViv4k9NOBKOp7mGYveXeHBKBwcr92cVZJBJdRiDvDk3K2cKfH8UxciYUIHPxDTtlTGjrmLf/Ktpw9TXnjWXPfvxqm2wiNJOuCXNL8IZIURhwngLjj6WLmyHibWLgM7FhcrZm36VhS/EQj9/rw1jzF4ZRLVnW2IqZ6cH0IHN2ta6Krt6Xc/9ixLrtBkFElDM6ZplPPE+HaJj1wwypib6lWe3sLBtwog+pqEQGQ58pCAw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/UhxoQy9ufHH/x6l9pVTXFmLnNgIV9c9oAlY145GfbyOoB3oxzKWL4mHcfCOEe6ujNT9JF+0YmE1Z0DuoGovJJ8bZDskoVWwLDPE/u/8BbVVkC93CooLBQdc1qRhH4dNOD2HgBY+VfqlPMKgyfgCgxWegOmW9JjWseJRXUCvwAnQ91y/0Yk8g44uNyLMJsaS+5dE7Eoyx141SxXIUU8BBAqIqXBbXboKZ818YYRS4fmWOg4iQVAQgbF8/RCFTuIU4Gsz7CqkoP8kIrsJPqIFg1qNRhXM05oJ+GrCSlp6eniSOOiLTmUVPd40wxSR4ZCjIhqVyXkKcnSdKyWLwzp6Lj+pmsgeFk0LQCDCpCv9W4YOOxm8sXz4GSMmWdw9Jbrz5lbtBU2T5NfNVXAlY2ElLWMPC+IPSvHXRdUlC6Etepj73sNRkj7X3m7ixDQ2Yc5C8FYQcFDAzXIlZQle2ZX4peIXp2CZGV4qMqK/1nzjtxS9xKx0Wx0KuCGkQP5OwZFSrmTCO4Bvwf9I1/OV7Ii0tiAZtQ2JNtSbUIlVl4d0W1QFurV5tWsJOtoScO1qKmlQV+8Dm6Jb6GvfWpmcPA/M+3re76A/ZBwhbevkqJNbK0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d4a6b4-d7c3-4d6a-7489-08df290e045d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:29.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cl9U5kz5NsdgKj15tRPX+WzYlrmJ+338cIj8yV3XEjkDFjxJZiEztx9BCTvh4s/PtZN4b0xuSFWd8sLsZDAE8xH8kP9QTvASrffKAjJOKJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR10MB292770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acdfc91 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Yrdf2Ick_R6uxJIQGh4A:9
X-Proofpoint-GUID: MpW65NEHHMeCXeQ0-xvk1g2JnDMs-YVP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXxgU57vkO4ZNp
 nLop1RAn+0ps9BSkMBJzIKvcEimpf8q1YmxzVi9n5FUq/Hyy6f8FhyzQslZl9lpjQBPXRNMdSAb
 FEpOgT1qX9FmJmM5y5gbAWjDalD6abLZgMP5+I0QnC/yhjaLiUVcUl9byY8Kk5V09THCYQm/nxM
 LFEFRFuaTKna3PT8g8ODUfcswZ7PshaBt3dz9Xo4S8GwND6OCc3KMtZ6/gH8t8l+WsXQagcmmGi
 qJ3CrVr2I+4NmcgfzeMAj9L1YEuZNj60iDJHniZtkX8J192QDRQerMS2ithON4b7Vb5xsBnfZIX
 DyAk2Zd0gao6XWo7lWfU3kbyPM+KWg4POnXnCHW92k85SUgsFH7793CwQaZWgEFAJx+i6ne5huW
 1unY5JZIrlRWkUA5IovOaZzNd7tO4CiCcdwZ0+1XV/h8ncZJHyO0wp9t7O6Add9xmtiA/80Lc3n
 LJTlrUm7ooNLwklf13Q==
X-Proofpoint-ORIG-GUID: MpW65NEHHMeCXeQ0-xvk1g2JnDMs-YVP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8l472kqURmA1
 a5+P0k/RiRsy3TY/Z8RtLfaDeZ2+qiYFi2HADpJwxKJjF54+S6ziBJtjRUArVYhGr552Jvpt1UZ
 LQRz5tRy4ZZ/Dcgwz9NpNehrJMXIpIOzDNJdTYAwlROTs+1FPKHJ

From: Dave Chinner <dchinner@redhat.com>

It's completely unnecessary because callbacks are added to iclogs
without holding the icloglock, hence no amount of ordering between
the icloglock and ic_callback_lock will order the removal of
callbacks from the iclog.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit 6be001021f0b307c8c1544e8b3ac87de20d711de)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflict due to the following missing commit:
	956f6daa84bf ("xfs: add iclog state trace events")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_log.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 22d7d74231d4..2b83b2b7786b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2721,10 +2721,7 @@ static void
 xlog_state_do_iclog_callbacks(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
-		__releases(&log->l_icloglock)
-		__acquires(&log->l_icloglock)
 {
-	spin_unlock(&log->l_icloglock);
 	spin_lock(&iclog->ic_callback_lock);
 	while (!list_empty(&iclog->ic_callbacks)) {
 		LIST_HEAD(tmp);
@@ -2736,12 +2733,6 @@ xlog_state_do_iclog_callbacks(
 		spin_lock(&iclog->ic_callback_lock);
 	}
 
-	/*
-	 * Pick up the icloglock while still holding the callback lock so we
-	 * serialise against anyone trying to add more callbacks to this iclog
-	 * now we've finished processing.
-	 */
-	spin_lock(&log->l_icloglock);
 	spin_unlock(&iclog->ic_callback_lock);
 }
 
@@ -2782,13 +2773,12 @@ xlog_state_do_callback(
 				iclog = iclog->ic_next;
 				continue;
 			}
+			spin_unlock(&log->l_icloglock);
 
-			/*
-			 * Running callbacks will drop the icloglock which means
-			 * we'll have to run at least one more complete loop.
-			 */
-			cycled_icloglock = true;
 			xlog_state_do_iclog_callbacks(log, iclog);
+			cycled_icloglock = true;
+
+			spin_lock(&log->l_icloglock);
 			if (XLOG_FORCED_SHUTDOWN(log))
 				wake_up_all(&iclog->ic_force_wait);
 			else
-- 
2.53.0

