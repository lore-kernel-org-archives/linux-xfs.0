Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364A9521890;
	Thu, 15 Oct 2026 12:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069018; cv=fail; b=Xqd5sJ7iW5E9Xf6eBITVWHl7mN2CeuDY6qGjKMhduEojvZdVXt7Z43NAt9EvmnhVORp2K+yyQI+gcE47kz//j0HkuZXQPxYaYDtZkHqENr6iRqpOwVljPgJwFi1i7kYIyZgfDrSu1Rovg37nw73QuV7n+zTVtlM/pczJYHCawro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069018; c=relaxed/simple;
	bh=v7TnykNQqvxD4VqcBWXLgOf1skYtpjYXTXT9h0peHGk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vo8RassPdsjs0FHJrefqW3pO2IssktoKydfJnPVJr2amYmAtseqAhEP7aCgijEpje4Fqdfs0vqqCQiN9c4Ok/CLunHi/kANUQB1fryGBzykxG8CSIsdPAqcnoc3efrZRq8puogaxiXERpL5oMIIv4Xo2CH3qv/8hKAVCDbiobBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KDZXti9d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hQPUv5jR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KDZXti9d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hQPUv5jR"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ELgBnM3434673;
	Thu, 15 Oct 2026 12:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=v7TnykNQqvxD4VqcBW
	XLgOf1skYtpjYXTXT9h0peHGk=; b=KDZXti9dd5FS5kgYhGGJLH5Dwb+ATCgOrv
	bHAf50busJgQDlnNptOJFd7QjlzpxIPkswE+YWSMoest3cWWdzQ6VRoMlhxjEdcT
	y+8Rl86f9cYXPJ/TIVMBdxcJFf1yI/jmGbXr7SDg/fr5t4u4/0jWOtIiDC/Cxy8/
	1i3oYyjV86T7110PFAivN565NKYjNhBa/ZiRcI79CeVaOBOsBP0jrpgkkNvKxg0J
	wnK8XOZYMNAXtsf7g+FSxtjEZb5+FFEJJPlPG/+TIttfYJUWfHFTzB7+XJDGz2k7
	ISam6jpl3giloENtUoLukskZGD/HOM4h96jgWu8KyZteIuPsblTQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsg2hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 12:56:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69FCpTO8029529;
	Thu, 15 Oct 2026 12:56:50 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btcwtxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 15 Oct 2026 12:56:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3NBNj+sMdvEKV78sE+BBEB9paqNmkDBuN2zwh5AwZ7q/4INXMbtWmLk84jz0zIOTJ1yBCILaJAWc35pTneJnQFYkw6lbv4kptYjfiyReFhaAva4niJGKC6K4sv2gjiRYKYVPfxuWXudyCJ0OsJEDAUJG6V2LthJ0wvi4lLhSZxhDHEoP5YWec7Rj9bEUZTxltu8OtdlaWYC4yZuBvzZJl8Wl2vvq/hmgKMCnYhy5lfPqKFrWJECnZwNehiH2mLPugoK0wN3WUpaQ2Zkoby/DphYrp6wCWys5qfo5cfpqN90r/yVPF96WBLjhM18/kD786vOAd0fQHIMLf/vXAipHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7TnykNQqvxD4VqcBWXLgOf1skYtpjYXTXT9h0peHGk=;
 b=xJG4doJoA9z3nwTeYpv+p0BEPIEcQSurDA/to2Y8ZZ/LmtOZ+i8EZ4yPirfiL4gSsq1MBO84xj7EXxilvizcYeNWXF5jSG1BBHe2qD5SsFe37adK5kvH/e9Ry30YSDk5gXCOAwcmSkLTdnEWxfqkMjrpsV03fHHLsh94Y+P/hzn95zqRkWurQFjAkXs0MhBTd/17UuKkZ9ncta6zkYZVKDTxy4Xc4Kv0o0WZLANikjIMp3bkMTOH8KEPjntlAQUaVY0UxUBvwh+N/rySgjmVDbQLMXpmyqtHz4LbpxcnaspYNUcqvZjwuayz9HqHSHiw+wSE+A+UQFyrqTvvQCouJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7TnykNQqvxD4VqcBWXLgOf1skYtpjYXTXT9h0peHGk=;
 b=hQPUv5jRwjmO74CzrHx0x5ExeNaaTBNAgQol7lXCHmLKtYkda6ZkIfkobPNH1LsHIp4ytQDp0RD4qTdoUhGUBJ4JV5Wo5xwdgJMjqnBAblDGWT3gOAqJT/yoTMbi6ncvet08yU2zt10M0XgZLGPpvCdjVuAfs5+D5JMDkoB5O8A=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 MW4PR10MB6487.namprd10.prod.outlook.com (2603:10b6:303:220::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.9; Thu, 15 Oct 2026 12:56:44 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0546.006; Thu, 15 Oct 2026
 12:56:43 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "cem@kernel.org" <cem@kernel.org>
CC: "djwong@kernel.org" <djwong@kernel.org>,
        "dchinner@redhat.com"
	<dchinner@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Thread-Topic: [PATCH] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Thread-Index: AQHdXKShYarxtlGlpki+dsD6arsQ5g==
Date: Thu, 15 Oct 2026 12:56:43 +0000
Message-ID: <e7feec9bf096ed64f581536aa314a21723cccc63.camel@oracle.com>
References: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
	 <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>
In-Reply-To: <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR10MB7505:EE_|MW4PR10MB6487:EE_
x-ms-office365-filtering-correlation-id: 0d1333f2-89a8-4154-b935-08df2abbc38e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|23010399003|6049299003|56012099006|38070700021|4143699003|18002099003|22082099003|10067099003|4053099003;
x-microsoft-antispam-message-info:
 vQPCBgxO1zVgVK6psRM+QplJrFdZC1fe5qB3o75HpHTr2FAvu3G/VEhiSusopdCZi3AbeNpDMOFQj/5KmcCIZ4GzAxiXM9uy7mABT0ZK3jPhkoMdF+iMiXskCL4DVKLWVC0IHS/sMDUNJ2IKuL1zL5S54uclbJIMQORIGMgMeyM7o8zD6FAnYaNetWeDVhZwMSxOQDdKJeziyayaxvjHAdj6sgsNZJrv1Dh+qMSjtdb187saEhKGDrY3ZKLuLK6zzpDNHBUpSNlkHE4EOMFfDwZK0mF/yw+aarC7SNAw8WHmTWD2rQyFa/KjJLgqoQBfIERa/Znrq6kxH1X2WtkI5679jAr9ajucP7xpN0ZntQpDXx1Xkr0qEThFTCopc2uc0Lb/jEFExlajQp4CzZWhiwRd3TPhapus0XN6tXCPCY/iekQd9HP+hJaf9wfEoi8/hYHqdWGP4JfnD7tLUbZ6ZnOwcnkRIuoFSgRx3efdHpX5RUNM3xCGxotDFP8RwoZdoIxibgCHXxtPr+V+/MmBYbkAcePMRC+qcpUBtM5fEUu5UNxL1TQ0Bnj2yZHKUu9fSntmVbqk3d1+bSrf51TenAlI7uXE/weMAXNXGAxK91pfEbGi7Z5RbzDagbkudWVJItrmmh3hNxm+hgpsBrz/jk0p5fQamB/JYcLHXRM09YR4cqXY6JlZeeN+RCxAHPv2eTLJ3VYrFnzNT+ataTzAB1w/2PbCQcaeYyMwkU6qo9A=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(23010399003)(6049299003)(56012099006)(38070700021)(4143699003)(18002099003)(22082099003)(10067099003)(4053099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bWY0VFFpRnFnTStuano3aTYwS0ozczlOY0F3VHZFWkRLZlpsY2w5azRzZFZN?=
 =?utf-8?B?YTE4dlVMdXdpK0JuV0hSUE95bGU3YmdEdFVWcUlSQzBIKzV3ZjUxZFBiSkhS?=
 =?utf-8?B?NHJ5V3FrZ0N1bTVYbTJ6NlJYM3Fab05SdHltdEVnQlRKRDhZbUdwc3BYOTIx?=
 =?utf-8?B?TldjenRTcVBVNlZWSjNZZkl1Z3hTa0VPQzQwYjRVWk0vQjNnN1lKL2xVR2ZO?=
 =?utf-8?B?d0NrTm1wSHVTdG1PaCtvR0tzK2NmdmRKMEh0UWRoTmJieldMZWpBak9CbERv?=
 =?utf-8?B?ek1SbllWUTJwaXY1NEdad2R4UGJYclh2bStvYmZSbXZJU1ZNSjQ0Y1ZmSWwy?=
 =?utf-8?B?a2J1ZXNZaUdkREFtQXRPVElSQnNqS1lLeFJLV1cvVXRaeUhOZFgyYjlIdHJa?=
 =?utf-8?B?dzdYSU1RMGlwOTBqeElRbkZCZEJnY3BSdEtPSWRsWlNjbmZ6QkhVVmZzWWVF?=
 =?utf-8?B?bVhTQUYzZkloVG5rVExJTzdvZDY0VTJDR2NsUnlDTnZjVUplNnhRL3dBY1l6?=
 =?utf-8?B?akNxS05GRERaSmlLM0ZTSkFvbTJFQzdzcmxTRCtjNFhzejNaTmMrbzJWTERm?=
 =?utf-8?B?TWxtTGdBeEIxVlcrNXJVTUFvR1JyTTdyNVVMa3VERy84eDcxcUY3RVQ3Z0c4?=
 =?utf-8?B?WG5zaUpwUHpLd3RqRFVjcEFDdmpDUEc4cFNpYlpaRE1zdkZVK1MxYzl2U3BN?=
 =?utf-8?B?eENkbHVNV3ZJV2RuZmJZOEhXNnorNklxcURmM2Z4U2lIWWZ4YUpZK29LdHI2?=
 =?utf-8?B?cjlXdGVNYktFS3BGYks4WlhhT1RDT3dWZnNHNWdWazJORG9tTW9Cejlza2Jj?=
 =?utf-8?B?NERiZzMrSmtkRHFVcjFIUjU3eDNHREdLOFhNYi82d3M5SDNXNGNRYThBREZT?=
 =?utf-8?B?aEppcTdQL3JFVEFmbGNvdU1zVzh0Q21WVUI3QkN3dCtRd0MxUU90ZThlUXpX?=
 =?utf-8?B?eVBxZ2hTVVlraWVoUFBtNVZBQWdZelRuNFU4ak1Cd3RoeWswRml6RHpEUXBs?=
 =?utf-8?B?TS8wVkpiM3RIK0c3d2xBRUpmZ0ZNZFkrb1Y4VlJMbk5sWnUwOTRxdVhBUkVk?=
 =?utf-8?B?UHNNUHYwVEFDM2tRbDY1cDR1ZGFxKzBuK1JSSHdsOVB3Q1UyZ0FCRzN4S1Zy?=
 =?utf-8?B?Uk9iQ2o2Y2s2aFBlVnhhenRmTmRSS2VucjFrZmNxSlRXdk9Da2dFVDJTYm0y?=
 =?utf-8?B?U3dSNTlNUXZRdDB0YUtPZGRCM2tTa09OK1UwMTdlb1VjeERjNVUyUjUxRnJ0?=
 =?utf-8?B?M1JZV2dFVmZ1SVU2eENGeHB2Y0toT3hUdEdFTHlzQUtNT2Vla2xjejA1UThC?=
 =?utf-8?B?dEJrb2lLSHBlaENHOWF1bENNVU0rd2dzdFpmMTJHY20wb1BpNEE1ZU5JcmR3?=
 =?utf-8?B?Z0RzbkE1alJWVzBxOHZRaC9haXI0VjA0Vnc1OVU0c2hKMzdFSTlIWWU5YzZW?=
 =?utf-8?B?Zmd2aVlCNzhkSmJVWmJ1TUlFdm14V0NtSFViNnFYZnZqUWcvOHpNczBtblZ2?=
 =?utf-8?B?anhTRFlrMnBwdjh3L3BFdVZpbjZleDBGNkVvd1RmOENlY0JBb3JKazhIVHpY?=
 =?utf-8?B?TmFkOGtqeXl5bkF4aUVhOGd0eVA2TzM0WUJjNncxOEZIS1RJdVBRQ3pMNEJB?=
 =?utf-8?B?d04ybXZLcVcwcU4xbXFmNS9EMklPelZKYlhqV3gyVlFRRlZjNFk2QXFESjVH?=
 =?utf-8?B?b3hvQXM0MktSWkFuamc4S3VHQmk4OFB1RVQyYzMwdDZuSHUzOWhmYVdBN1h3?=
 =?utf-8?B?ZkJXQm4rMFM4UFZxUkRwcDVNTEVjTzdDYUVQeDlnVUpVVnBuR2VITHA4b2pB?=
 =?utf-8?B?Ny91b0xvSEV0d2RIcFdiRjVrQWw3bnRLaXVBUkJaeXEvcExTRDlhbXNTcXBS?=
 =?utf-8?B?Y09RdzVrSnN6TXVTYzY0bUZlRC90cGh2TEY3cUx5Q1RnUFU0T1JTWXh5RXBE?=
 =?utf-8?B?Y2JndjNrdkw1d3phc0ovWm45NHhCNjc0cVI5Q1hxeGgzNWppL2dWUFBVNkJ3?=
 =?utf-8?B?V3pjQVROR1liMHhpUmQ5SWw1dTcxNWxlV3NHcytOdW5HbldndmJIbE9WK0xy?=
 =?utf-8?B?MVRpR3FZTVl0L3dRYmJDd1d5cHZxSXBqZGlkRkxnbTRUelo0Q1k5WlFUd2dx?=
 =?utf-8?B?ZXY3WVFTWW1vN2hwOVA1NllMMTR1T1NXODk0ZkdyOU1iUWlEeDZrSi9oV1Bj?=
 =?utf-8?B?S1VlSEJNVU9CcFovYUlGYytiakpiQUtmM290dFhzOFZsVVlCZ0VvdWRJSE41?=
 =?utf-8?B?TmRFUUptQ0l1TmNveit3SHFwOFVFZmZzQ0dTRDJhcnF3QVArdWxTb3pUbnh5?=
 =?utf-8?B?aW5uMUVFZnhlZVJhTlBFbDZUNUpNUFQ0RnRLSnZqWUIwajRlOE4wbGpZbDdx?=
 =?utf-8?Q?Viyyr6aviosGaLWuNFxHRgf1zu8m3SkyXWdilQCGFKGwG?=
x-ms-exchange-antispam-messagedata-1: jT1ETp9vJCc6JMibF7OFRczwezhqTfwWnKw=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-6AePtzhPaVlPR38UaPIM"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	w5Xz0nKvRNP8HDriHqhsys/vd1K/rlb2+ZxeNFIOTS/eOEz7jop9wYm8E9BEaiPOG40ykhnVuTvFMCaPKW+l0BWnk19qgp81eNDXTqLEUsZI/2knJT2Vcs7WZkABvtJtOmuznrvjgDqIKLh91Sll1YCZa37QPEsN2rGdyZdK0OiCtDn+OXiz6vfjrmBVyoR2y1MKA5ARwlSyIGPO9Ar0a/ifM7e987ZktRkGVgxl0mDZdr83Gldgtw61L9aidoizxNHFGXqBfCodAKJx3QtvNOa3DqDLQekvPC+ZOdCnADWN1EMOfPlscUPAowlmroibqbLl5w5skzzQXZLIz/RaBQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OlWe1+ecnynkZ3OHRUysML2rcSAmKLlXpWc3KkDR0wqePxbS/4G/IOjEywQ/65vdpzm0QoGpk5z4Hb3YVjWx0BiVDLcb+TwNE6BSQTnYLHk0De3GDfQMEaHvTms3LtVpvJreZE6CjkZuUU5A29EOew2KJ1AuXIVJrCSvg6/nqDpVZchnIvG8jl56wamReY8N3HjEdjF7FjK17VLDk7s7Q98kNiqErtrmowH+D7/d4VI7NwmGP9Mo0s1hkTqVdQ3WjK9JAnxqEjRY/KAv5obKmbjlxaew1lh2FziVBi3ZO2vlvJzx15TmjOVLksUaPC/ZCEVPm5oHh41Ez9rltcnebvEr/ArKsaxirX17V7KQC+5RV+Nu58g+sHBbXKPv5NnYURXnxMt6iug0qZkuXGGS0x8F0gBPZeKW8Sbj8y7Z875U+vBB/LRj9HkZ+b3yI8b3T6bA37fkOSwGeH7NKaVpxqDLnWA/d2NNE1AD8vd2wG3e00hPN+2e8aNvmWoNg4S+B+0FZ9PrqRwpJuR9uUpz366gdqJQb2B1c5rGErq3pwq62088wNZL7ZHYx2AS/vyt2vCyYvH0RMkouai0TIzIRDA9bUlWjEe9qAonh8+pjrE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d1333f2-89a8-4154-b935-08df2abbc38e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 12:56:43.7824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jr1dqfodTdqJxMrGq/sKbPknAippd2N4SCOe1VZsyV6qHLQ6TlcWhAlCw8X0sp6K/CpfNZ8Zn3KAF+q3XXgBCfGvHps5zTXadJubtOFwZFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610150051
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1MSBTYWx0ZWRfXzoMjzjLgfwoR
 LKj/QQSGXJj0OX09HiPwre3buzQdSiy/hSQKMsa9zwlJkYhKPEr8094aLw/bzUzJ8A0gLkGr/qZ
 etdVGznmU8Xe/zNKTlKjujomsQ//SEpPgCJZweOHW0aPhFSV+H7l
X-Proofpoint-GUID: _OECA8VEXq0WbQsDEavGalZQbQKcTs5g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1MSBTYWx0ZWRfX/p1GJVdCI7XC
 Gp4/X+S4FcDq6pjzSSU1Lz7M/K3ROnIk51b+HwV2nlrGq3aXQs8IVooqqu9He1A0rdVVcQOh5GQ
 K4LavLbquodTh+Ff3Cr4n85Kw0e4pAf5WUCCfny0gkuphNvQs3m8xxU0we53Uu3MGSA8md0ITcc
 lk0NDYIN50gqpN8Dk2bI9nLt2Ak7/KS+C8Ccg/sgaNQu8k87uSYhH/DhPHx6xnGigfxf5fjS3Iy
 Rif9wZV1Z/H+2bbcku/LmLW9o9L8Be68zEExUFL+DupSrKUUZTLGVIqWw9D8Mgq0IMPFHCXx4ux
 Z79FRxyCWcT4GGH1XCwhZf7PuHuM9T3TlUsPXk+0Lpb9FvWPBcMWo5LxqFlJWacVTpwoc7dm18o
 7RjLVqRXfOGnffvqop2Kd51yBw/psrZ6aTBLDFS5f+x/GDKzhkgk8yfkr+HFLznIUqTQ+qrRCp1
 GPtqJkwQO6LnNwO6p4g==
X-Proofpoint-ORIG-GUID: _OECA8VEXq0WbQsDEavGalZQbQKcTs5g
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6ad0cd93 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=GJZxXcdt-fME5yofwwwA:9 a=QEXdDO2ut3YA:10
 a=rCi2SWJt8Kgwak3U8FoA:9 a=FfaGCDsud1wA:10

--=-6AePtzhPaVlPR38UaPIM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13 2026 at 20:01:04 +0530, Carlos Maiolino wrote:
> On Thu, Oct 01, 2026 at 08:21:53PM +0530, Siddh Raman Pant wrote:
> > Probably an (harmless) error in copy-paste.
> >=20
> > Fixes: db6a2274162d ("xfs: catch stale AGF/AGF metadata")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
> > ---
> > Put in stables <=3D 6.12 after the backport series lands.
>=20
> Fix the tags accordingly to Darrick's review and re-send please.
>=20

I have sent some backports for remaining kernels and I would like this
to go into them too once they land. Should I still do it?

Thanks,
Siddh

--=-6AePtzhPaVlPR38UaPIM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQ4+7hHLv3y1dvdaRBwq/MEwk8ioFAmrQzYMACgkQBwq/MEwk
8ioqkRAAs+DDg4vOONiiSZE/+M7lr1iHXAKhde2ddAfEWjMorLvidV+c70MmBJtc
SdpfcuC/5TM16rb6RUEl78I7yMbptrINmPQhlSUhAocaN7KJ0QY+at++DdZ6oi5Q
Su9flH1RTfAheEcx1bFZpDf1tMQyHaXBlLvIePBQS1gUinWp1iDWqJLHVfT3MOID
xwBzsS7KIRtxqnzpCjoncujgtyifqeEK0s0XJcpjcdmmVstwp3TI3a89lq+TKr4X
slOmBS0EySvqSpzX+pXNexDQDsyD0ZKoEZdQf85sD6NjQxKiXTSO5yZ4Ik5djDvB
AO3y8Jv6lDGj3pjwHQnbPESGjETnLTvocXjRbgmm//xqRodIabxKn43gqPWBzXK7
bydme4mZYiXD7+u6XHiP/wLafbhnX2IglnMMmXw76stshCQlzE26j4BDUQotjYBT
ZZw0R+qvcsn4zLLxGuVncvzIpIFc3XVd0cgdvr6MXSY9PYpSUBgK/2OpKNLevPZp
r9jlMtSomdzRsEGu2OmwViS15js9QWm9f9t0SRPaG0pYcUqGffmdnf89GfjASYgu
zdze7YfwAJHX0R10p+QSkUgqeTyDxmR55nmM1P00OSNm3pE7YhgsSyqPLLf+KapO
s7c3KFDdp6dJ/ghVFvLP38tf0VBAVcVjYQpozMkxesVi8eilhts=
=ch7i
-----END PGP SIGNATURE-----

--=-6AePtzhPaVlPR38UaPIM--
