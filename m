Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3748F42125A;
	Thu, 15 Oct 2026 12:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068893; cv=fail; b=O2uNh09fZC5IkaZ2IQ7sdfpDOLfK6U3RsT35Na54E9NMU7e4QlqDR4bjW6ay7qmcF35IwYEREf7iay0zUZrAWSO/3peJBEnengH0uV8Yuditk0EALguaLtq1vvqTXAhuEQrKI+dDetnD9mOA3wWdZBGkPUh502in5QiP/XtwfQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068893; c=relaxed/simple;
	bh=eY5OnML+Keo/lSWQOcgnZxw1oC/NROQ1/LXZ+MbN6IE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=haddNvyMD9sIgl8MpbgU/iJOv3DZ39Mkpj+qnbzHqyTCA/W1abHlZSH0t3sigrwiBt3/9fsCEHFnIi/WXYlOsON+L39R64KmLAKtimDlZRyNHJZxdLWfW9nPirIi8HfdfzgtvHG/S2armF8+32UcfQGwEz7TkC9C5Z7tuQXY8SQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ml8DQRit; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hb5m74TA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ml8DQRit";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hb5m74TA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69ELg30I3685300;
	Thu, 15 Oct 2026 12:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xmEHD/uNpau2x+rk19
	tKEMNYr65Tzp2eRVSEgE43Tfw=; b=ml8DQRitBlllfojaOX0ECYeCuQCiAruHcp
	0c+kzV1qfEv1E2ztyQkBAWMCsuLzMEkNqIEqwDF5K/Xjr9hrzM+9FJrIgERV0Dwi
	huZzBrj3knaNXe1Nvkae1FvKROJlor7iT4mjQ/yZLgZDR1YtWWronIs1JKhjCIMO
	0Ncwcglh9CxzjGwXixDtmA2gVkpz8Ompf0OU0vNby9k6oDzlEcU6SCvSG3Ccnn9g
	7bF/BdN9enVelEhKsSlWXMkiI7WwGrhOeNWbB8IVJ46CmxbYbk6KHvaL61QoxBic
	M3R1jID50RpLXf69GbuFKXpDEYmYT3AATd0I1zmac6gKunERn4kg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1qwn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 12:54:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69FCqTi0016703;
	Thu, 15 Oct 2026 12:54:46 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bts4a35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 15 Oct 2026 12:54:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWEywkw4oTAg1eQ0+G7tAzeqxYlaqrpRqSV5kXBeOhU1mUTXaMBTGGbc2AZwQR7U43665e0dgd26V/B1D4MzCoobFGfZvsIL7PwmbY7FcoHQsreB6eaFH6gSZcKJ2VLgxSt9yCXOo69mVZOyKSKkRZrwmLZY3OnOHhB3ZO8/vhMjnoh61CV317cSzKCsEQnW7htX6Ayqv3TSB1tJaT/TAUaMgCYzqQ/3a0dKlxrJzJ4poSeqGQ70HCoF0P8193KvG3/1Hpp7h9tgnNG/Gv8W36Xv7MqhsqjUQL2ev9hIvwIn6rp3pn6VoMfE7ZoxlritqY9cyFTDvrSkt4lVPPXHcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmEHD/uNpau2x+rk19tKEMNYr65Tzp2eRVSEgE43Tfw=;
 b=mHtGRiSlZMdElN7yBFVSLRbhOvAKiccHqt8zWCC8/TXHF2raz46SfR9uqHNp9aPEWONrSBZ4TYJAYKhN47HIIKlqCGcok3db31WnHmSvV/TCcOh9qeJ0mWSvhoQZzFuu7PZcg7vXFllXBNjMJpY/qOvj945rmyZmxtD3Y7NIopcJTW6KWb1lbmqfY+xDsWquhqXB5BFLvJC/kLSRIh430Bkmmenn8Ib673lxrA1c5bt+iWLtcpUN7DvnHEb7LlHoC0fLgsYLQjtD5yBbLvbTL/8PG1yqakGdZAPvBSXaQz2yaQVbkOsX3SilZIBOVymtUx8hmjqwkikw4QQjNbFBGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmEHD/uNpau2x+rk19tKEMNYr65Tzp2eRVSEgE43Tfw=;
 b=Hb5m74TAf1l5PuOnU3TpMbqf5g+pnnCx5xfKMZHTSO78Sgko2/fIPMONIvjvKW3WPn9aykbGLw5Ala7iEjuobNV1Zq5ppzbYaBAjCrE7xSZyjTfZD48LuRfEm8oWqwSx+azWeRqzzSkvq/NKlnvbVqv5cHsmyM3AolHH8x+zH34=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 MW4PR10MB6487.namprd10.prod.outlook.com (2603:10b6:303:220::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.9; Thu, 15 Oct 2026 12:54:37 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0546.006; Thu, 15 Oct 2026
 12:54:37 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "djwong@kernel.org" <djwong@kernel.org>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
CC: "sashal@kernel.org" <sashal@kernel.org>,
        Mark Tinguely
	<mark.tinguely@oracle.com>,
        "dchinner@redhat.com" <dchinner@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 5.10 v2 00/19] Backport of XFS umount hang fixes
Thread-Topic: [PATCH RESEND 5.10 v2 00/19] Backport of XFS umount hang fixes
Thread-Index: AQHdWvbMbBYchS/hTU21DKmK6PSxlbb+krGA
Date: Thu, 15 Oct 2026 12:54:37 +0000
Message-ID: <f6316f9f2422d54cacd75e20a79503638b689e72.camel@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR10MB7505:EE_|MW4PR10MB6487:EE_
x-ms-office365-filtering-correlation-id: f7cf631d-eb88-446e-9579-08df2abb780f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|23010399003|6049299003|56012099006|38070700021|18002099003|22082099003|10067099003|4053099003;
x-microsoft-antispam-message-info:
 NiD6cGK+5+nzlp48RTvPuVuH/1ZuYBUJeJw857BbcjFghRCeGMFgxroTkEfUW6mMqei8eXYANgXS3D2TQIbnzf3cXgQxYTBPTawXunSB9/Q+KE7P8rFE7vUsPAPa0CsT8n1aLHO2JbTPkawCCIgQs2Car6dC6IzZ//+hUtllPuTsWO+IjJgrIuQG41Ta6GVhL6EfZfhbHLEvXkEL9u37nWWe9g0DrD1wGD2xKC4jaKofl4C+FBBJ9WgRlQsve6++VMeb+7HdDlFCsKI1fI1B695NJBbBH++H0BgrytujF0mxdA5mlE5HKaONpg+w70y1Dd28Dg1X+pnZXuqpuEMGR+ac6DXxFhWNgMQU0sybQhNVuQkNIBdNMpe5gH3o3F4fkF0ke8LDhYQZKQDGo0ijgf6rHIOAIJ+8Xu8NAkwwBOGB/tzzsvYqyv+nxIWUyHUifW4+4A6PIz+N6zqHOBqAOSqSqNBJ0Z06FDJWqD9biSKjYNFd4//3PLq3MPtpbsOgtckfhKfROz8QGZEO7ZrbalGmynOVKN3Zuvu15K32qCkNs67/nc0SfHrRlT17jnFvJtcXzG1a/d+j7JPOB66INp64uJbhgDYtsfkMkH5tkfRAndOhUavkkt+sRMGLtI24vZ1LAUr7Ppr61jqzRyiRa8Y7ecpyRO1yC6lTZElKBfapISk7eUOqfufZe3NOqD0l+OpoKIbtIn5OMZqTEe8oZoljo8UatkQa32CmXbpb2h0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(23010399003)(6049299003)(56012099006)(38070700021)(18002099003)(22082099003)(10067099003)(4053099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QWFTTFlyZDFCc1Iwb0pFOGgvM3R1OUlIU2cwVEpuUGtoVEROZ2ZRcjNMY0pW?=
 =?utf-8?B?enlPY2pWRk5LR3FKYlhUanRRWGlHbW1NandyQnY1OUFUbmUzK0hKS09sZzI4?=
 =?utf-8?B?RjQrYXcyYlRRRkJIbnpsYmRMTXVJa2xwdWlSNU1vVTdFaXlmYWEvZkJLeDJO?=
 =?utf-8?B?WnZUcklDVHpFdHpTSUVxR3ZiNWdoOWNYVDlvSnBJRW1XZ2NaWHpQRERSaFdw?=
 =?utf-8?B?ZFlEWGErVEl2Zi9EdklXNEY5d21SbEU4UUFBK0YrZGM4Y0czQkpzSWx5Ymlu?=
 =?utf-8?B?WTBOMTJXQ1NOVC9mRUd5cEFkeU9nb1Evak9qaWRFQWpzdlM5L1I4ZTVGMk1B?=
 =?utf-8?B?RUZwS0NxaCswOHR3Z0lMaXNiUFB6TVBBdkcwYVBiUGhvWHYwcnArbUlpa2FF?=
 =?utf-8?B?ckhCdlM1UkVGaFI1MHdlbytnZmRQVnBWTU1yWTIrMlhjOTRUMEdYZnBFTGZW?=
 =?utf-8?B?VllodCtrcmxDYlY4WE5MdFd3ZE9HeU5weWUrQjZMdnRDZG9IZjNMQUtZMjFt?=
 =?utf-8?B?TDJMUUt3TjZOclBpR05uRDNUeXRHMXBZd1VNL0lCdVRhb1JmVWJUK214T3kx?=
 =?utf-8?B?SVFpT1ZuV0NER1E4cndObWhFTFQvWUtFSW5xQ0tvWDVLdGJISFVZNzhLQkVl?=
 =?utf-8?B?ZmVLV1p5ZjNzOWpBNW9zaEdsbXBVMk91UzlTWUNxenY4aFhUMitrUzA2M0hn?=
 =?utf-8?B?QU14QldxczV6eVMxZ2lyZmVZL1NwYzlHb0hSWXU5ei9XRkVHMlkrOXE4VUVH?=
 =?utf-8?B?M1lBNFRkZ29XZGV6L3JiSVhncGdhYWZxcmhRZ2NYWnlOZmZ6d2RvVU1FL1hv?=
 =?utf-8?B?NWFYTGJ3ZUJZMnpkUFVYWVpQSTBrcm1NdlFEVG12dEprbEZsWmRxQ21pbWly?=
 =?utf-8?B?V0ZSYkFyNnFVNG1jUDNpZTBCVjJJUUYwOTExUEpkRVNtWTF5K2hMd3EzUkpU?=
 =?utf-8?B?TWlUSjFSZk1DakFhYzZPYmtOVExtQ0pKU3pjeEhGVzUxaVJid2hLTTEyVWFJ?=
 =?utf-8?B?Sy9XcWR4cmxVYktBWEZMWnh0VmVnUVMybXFva1RMWFpZSVJnSmdBRGdTSDBl?=
 =?utf-8?B?SVdyWjI5L0NPVHRBRFZlaUZVWngvR05YS2hKaDlqOThVTmg4dXJoOVpHRUtX?=
 =?utf-8?B?QzdJVS9WU3pnSzM4UjZ4bXltVGpUUXRiZlVwc3AzS2ZOeCtQUk0zQnNML3A5?=
 =?utf-8?B?M2lEOWNMMDY5UVgxMHNMNm5KNFptNHpIYmpUUXZNTE5PaDY4RzV0TXhCV3Fz?=
 =?utf-8?B?YTAvSHdtWmtDcXhYcklVWnBkMTY2ek5aNnF3cDdyNXR3ODRCbXdNRG5NVkRU?=
 =?utf-8?B?Nk5mMG96dU10ZU56dVpJb2ZpbXJsMVhlTzJVQzNiRkRkRDYySnpjZ1NHdVFD?=
 =?utf-8?B?aHlBUGJqWk8yZ25oUVNWSTBLeTRYaEZqTEFNT3lsaXNkeFM0TTlEV1p3K3My?=
 =?utf-8?B?LzVYNzVmbnJKNmtUZFlNUU5MVEt3K3MvbnA0T1A5SzdJOWlieXVxTHBTYmJQ?=
 =?utf-8?B?MmZqQW1MMm5xelA0a3FwYmtINjZmRk1xS1pZZ3p2OHplQ09LczBIMVdBUlB6?=
 =?utf-8?B?d0lzMXN0VG83YTFOY2gvNGppSFpnSUxuekxJR2xIbHBmcCszRThkR01LWnpz?=
 =?utf-8?B?Y3VFZ3RmSWxqOUlvUGczUUVwTTR5SWJnRWdKWkwzaEFUME9Jb0hSdURGRHNh?=
 =?utf-8?B?bDF0dlhVU1NzWnpqNjBsNDBnMEM5Ty92ampZVVFIT1haWWIyZCtXeS95NlVY?=
 =?utf-8?B?NWp3NVFzMnRaYUJOOXhXaUZJTW9XRFJWaUNJaFlBdDFSVE04eUMyVjE1eUJw?=
 =?utf-8?B?SmVqUXNMNUpGNHRvZVBtajJFdTJkL2k4NTVMdXBJbFJrRjNaUlJucXhadnZB?=
 =?utf-8?B?VVBuRlh5QW55bkJ6WmhpRXpzUFZaYkliZXFqSEJmV1lyRHFzTS9BTVNCRjd4?=
 =?utf-8?B?RmRjdG1kWWRsRlBabmhURy83LzZpNk5EMlczdlhOK05iTXhWZEdNMXRIWllN?=
 =?utf-8?B?dHU5d0xQRmZhQ2k2eURTNmozNzJ0RkJqTHBxcjIxdWtXYWtrdVlhcStUWi9I?=
 =?utf-8?B?VGlnMG9sZi9OOHlCZ3M5aVRsMHJzNkV1R256WVdWODRYS1R3YnFWWDMwVEFP?=
 =?utf-8?B?NnRxcFlHM1ZBOGxudGF3bGZ2UUpwUm9YM1ZKREd3VFJ1MHdkWGM3cXJkSlpE?=
 =?utf-8?B?NElBZ2cvbmpwa3M4VmN4NVhpbmEvUVd0L1VSV1k4OWJsaFQ0a0ZUeGp3VU5P?=
 =?utf-8?B?aGRwY0EySnlBS211TUZ2T3lraml1MmtTSnNsaVpyZGx1c0h6VWNOYjgxUnY2?=
 =?utf-8?B?RnpLWXBVZnpMSzlVMVcyTk9CNytyV0U5K1IrZEhLdjRFcHMwZ3BOS2N4N3ZQ?=
 =?utf-8?Q?+CkCossk6QfGJlnTw2lz496LXKjA0+6/DOv5GEj3N2mt4?=
x-ms-exchange-antispam-messagedata-1: Jkz342cNEuLyViZCVKG/gQcSFwaZw8gDFcg=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-YpGpA1KQ7C5D8GY5VXWO"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	u0xH5h1GsFFEIfZciW0NLy1QI3qlDBcf9cBn0JJbbqnqQLqWNNUePwQTybOLL1VpdfyCVY9CVSR8rWBcX9jTxdPUIB1J0cuylWVGB3zQojy/smvxgLqWf8ayXDMmS0z7xws3MzGqnHF0O6ckd7uZlxPFyF98bWIxZtXuuFBhDtOAfmM4HfH26f9MBGoNOSxRZgNjDlL0oR5006pyqdHsfmxDxKlwlgncjkAysRAIAaaCnHGxND0KbCb9kXp/E2sfv1oBEpM1+OcajbrJBrqcOvww/8r0Kfn37xedvzf7Uz5UGurHjf0X/g+PNGwWWMTofMUs3stncwRFP29EylP//g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qW7baGp6QpPhxY71ZNm2FrlzRLSty881SHEwdnocMVz5PEFkn5HgGi5dCBY5myfaYNvOpmLBohWbhT7zmLefCyXueR1TUQeAmM8rCu7/zi5mGmN6wRBibBBWb+K84TVpBjhp5VyUdkdZ4WSVAky/SplLNgXGxF3Qed5GOVsNzyMqIYT5hewvBeHnW2vGitIxdxNsPVmidEMU0tsTpED40XozeDd4n28gmwOljq44aBTgd9IxNihtuBCizbOXB7v2mwxFJtN3krnppw1i0SXbx7tPsyh/IJ8rrap4glsvzpF0wYvIN9Tw4+lEpPYKiZQHKblaTe1+AiHETAYrKYFZM8B77CW7W5t9ImguFGjOxQPPnxoe+faL1S0RhqKMECQghD1sPaT/wEvTJr9OhIyupufQpiZ+CnbjeQKqtQmUKW6rlxjFXHm1Vo2lQEOsyqnnVX7Ca+rxs+TxU1fIOcmm8sd1R/IoqDwaXoxySzL0n3UHUm2gMuIasOtGjMkbWjMixtUMQdhTtmp/1Ltb6JCENbLBYYpjbXFPMZJHrlEggN0QHK7af0a2e0kE0QnYDr2YTauAiWgz0tK611t+XOu+AkzZKSg2KmdkKXXiN+CQiAs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7cf631d-eb88-446e-9579-08df2abb780f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2026 12:54:37.1354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G71MVMCscijipa15blWgso+S/VcnY10eC7QdQa4+sLahLKv3PHe40jXSsgmDoWJkot6gOJZjyzRlvNFyYnEIumDo25gF8H++vqoDTPc52ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=881 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610150051
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6ad0cd18 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22
 a=FJug4LhDIUBEBSkzHiQA:9 a=QEXdDO2ut3YA:10 a=v7S0zCmG_2DV8NGUlpAA:9
 a=FfaGCDsud1wA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1MSBTYWx0ZWRfX62Cn+WR+sPpN
 IiErqyzZs50k5d4YzCk8/5hiDFm8w0E+BpnyZuK1EMvfXvTI7mClK7e4nQ7DIzG44Kxebku45yC
 TsFKCrCB0HF/MT5aHE+51ZSJXmIM/i+5eTpnmeidFy0hQmvKdayn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1MSBTYWx0ZWRfXzwxWifp6Royu
 Tk+wXkqDpA+GcMZlTKrxDEkz/mvqqHClrf5sO1HPTpFmHYXxDaYX0KmCStxbQ9Pf2Wfev62+eEF
 vUmNIc55ExYi+I6p25TqUJd3HVhHT8dtO6vFDu5kBJvy3DEm5Qf8P02iha+PehxKlUQaC3Kc+fW
 4huY2NvCRU3bH3FJNhZQR5HBpP431FvFpo8Uo+5KzcHaycKJz4btE7A9thG4ZqWe7sugfsgvot7
 8iHSQjh600ZxgJYG/+/yHx44Dj4nl81xRBzAZNmRj2S+2riOag4f2KYsQNvmayAW6fC6hkgNYge
 co+bgjr2nzWRP0LMxbjfzfyv302etGsSmzbJySA0FLTgLfFaPltjCPfrAzpKXZqNaPgaYxvWLTN
 S8EC70ohh/SJAtrbM7XxlTkqo54hLqGUjI1Yvz1ByHXSVcIyFbNqAF8n+Ls8WgVxLyhYA2de0f7
 KvnrW1uv9g5YsfT3m3fkOMgN/+hVEd4ABLmLa4ZY=
X-Proofpoint-GUID: yqzudXbbHd75v3dtrj3FOa3mzpeCWyOD
X-Proofpoint-ORIG-GUID: yqzudXbbHd75v3dtrj3FOa3mzpeCWyOD

--=-YpGpA1KQ7C5D8GY5VXWO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

5.10 xfstests_xfs:
	Generic:
		Ran: 001 to 771 (661 tests; gaps)
		Excluded: 738

		Failures before changes:
			Number: 19
			IDs: 083, 091, 112, 127, 263, 269, 270, 363,
			     365, 373, 374, 681, 682, 700, 733, 749,
			     753, 754, 762

		Failures after changes:
			Number: 19
			IDs: 083, 091, 112, 127, 263, 269, 270, 363,
			     365, 373, 374, 681, 682, 700, 733, 749,
			     753, 754, 762

		No new success or failure after changes.

	XFS:
		Ran: 001 to 789 (281 tests; gaps)

		Failures before changes:
			Number: 15
			IDs: 019, 082, 104, 144, 179, 270, 300, 348,
			     442, 514, 515, 533, 597, 598, 609

		Failures after changes:
			Number: 15
			IDs: 019, 082, 104, 144, 179, 270, 300, 348,
			     442, 514, 515, 533, 597, 598, 609

		No new success or failure after changes.

Thanks,
Siddh

--=-YpGpA1KQ7C5D8GY5VXWO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQ4+7hHLv3y1dvdaRBwq/MEwk8ioFAmrQzQIACgkQBwq/MEwk
8ioxARAAkxVaai0wjL83k1KpngLd4fTN+rrBab5nJr2VbpxyIj63QSMIiOlaFwHZ
2CGWsbosnPNbhNu+xWRfdvLMMBj6jxc2xQADOVmRJFglSWvw3y1nqDiFcKjVtPD5
IbFcUiI4px39dZU8MqXuymWw7BgIjCe/ezzHD+eBO00syDg5NVM48nG74X2HjpoW
7QbmXvfHpBoAI4n4ZkAvkrf45BWEARYbmatF78i0pLoCsvME9NeFLpzN6mzYsL1q
dP1ZFso3BQwziNnq0X1fUYTdtk6Mx4J8h9HVRCrWWO4pJ+2C9bsiBCNQWRz5TY5Z
k+bBOnnvLbwvVMRbqkAEc46D2DFzBttzmzBc3FEaCKrHzhEu54MWUjUIVDVRlfaG
ARRtYyTDdW27yVxDRDwXtoqXLTOlO1tuPi46oo/2aGf6viNuREVx/V8LEeBvCPHv
pXOiL7IvoHfh3hVLKLEA7H4BuRqaw6kUEjCuXA/nvYd7T3+RVlwru302H//n5BO6
y2Hw/nVhGIu5l4PgzT3r33lCFqG5ikk/tLJeuZmnbHAxEvrLklNZmr30DKfIEncf
pst8u/1uaqpZ3WjT/+PQdBrCDD9z8WLrk3M6VhM/N3sHuPg5dsgtMq5prbldk5RF
/X9W8NGhMwXp0Eh8eTPffgKOc23ROxl1j1rzTy9MNCGrs2/ZRAU=
=W0pE
-----END PGP SIGNATURE-----

--=-YpGpA1KQ7C5D8GY5VXWO--
