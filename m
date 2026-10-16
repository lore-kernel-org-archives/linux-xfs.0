Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2B44A483C;
	Fri, 16 Oct 2026 12:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792155331; cv=fail; b=Pj/bX/9EFgghM2hD4ceKu4jN5NpKwB2ZenTv1qmTh97fOIIXS1TUVvk6WC4fcrabHrc0LZ0NFKtn5VW06+qx4GmLEerfJVezMfQxkJnjQHmOTsVBuL/wwjMCzhClicHWsE3gkksYcQL2Rr96RDxk+nqPG+5O3evDqDxXsuP7KSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792155331; c=relaxed/simple;
	bh=GxDH1e8EnJDmeH8Bkl0+PYfBBVhqvP/qpF98I3fLNmM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mw5pyhxoN5NkldgMC/6oRbEtbF6Irjux2cdPDwCMHDoEcpM+qfDSdCG++D2xzLBZZVsSlm3a8hiQiijvX6UQSEWAfKMbWI3N91EIr1dPA9k8I5JaCfZ/hv1P4UotcYbhMp3YI/ZeYOEEbGLSDrsakK86Do7jtba7+faRgs6UKxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MCX1wpJQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Nt8fieNC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MCX1wpJQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Nt8fieNC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GCpnpi1815445;
	Fri, 16 Oct 2026 12:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GxDH1e8EnJDmeH8Bkl
	0+PYfBBVhqvP/qpF98I3fLNmM=; b=MCX1wpJQdhCyz+r/FyZGF3vPrxzgKnEUFv
	n+Oj91wW4QOxgqz5zU1uEzkzerX4JaTC4alny+NnRcUinWWgA9TXsXX1tigrfH27
	hSPaIx/gxyzzm4CLBtfMwC61LHdswXNfpyBoICzpaTg+iQtKElBD83hFELEvfyWc
	gJkf36/4N4j/cot+jYRHGJaSIX3VI1mI1jXYsmer9pJx0l4oFfSHrB3/1HUKpXoc
	FCopbdg/M6YOmExB2gu1HR/cuCXXDxtGal17B2BWAmlwUTScZTT2VatzqEMUgQYs
	rh8u9aw/+qvo4DysexJkaOFvWoriwrQDIoV/qanXhCbMGN/ruq/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demt1tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 12:55:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69GCpnVP039480;
	Fri, 16 Oct 2026 12:55:23 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010034.outbound.protection.outlook.com [40.93.198.34])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bte5r6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 16 Oct 2026 12:55:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NFYHg0kV2EOIUN2dSysy3sZnafHNOBNmOgUhFtLVrsr2TYQTsjxpfjh2N8tyXdLEJNbruuSpMeVHgaSFnVRrkd+9TeCDyJ2YIRXkqyFds+JNQFX5PchPW+VbC5OomZ9D6A4TvqdyQnyaFw/L1ZoMig2cPhKTWVg9lFb59TYMJ3eNGCOSNDnfnvHUJS9t1fUd5NjI3DeMaha5PgKPFUWbV2oPcEtWzIdQQ3VJKtPtwpjjaIU3IgXlyOkvQ6Ms1Ysl06PVHOI8CupgD9Ri5iqUzQknM3Ug9aloj03Jkp0Anp4ZMM6TjS87zmgVYE2vnCJVCpI+cwvqmy0wwtX+uENy/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxDH1e8EnJDmeH8Bkl0+PYfBBVhqvP/qpF98I3fLNmM=;
 b=aarRoTc+Qr/RbWSn21jKNoHifPsytTL/zDFB0LPo8gLmXEHyZ3Nt9gL1o9Ee3OqmFQz0TJZI1cwTP+/TvASpg21xcWpxV5HnS2yA3kd4UVg9VURVHui4oL8fc2C33L/Q7ZfNnyDQsTLHPbWGdNXpj8b/wKtNwSVVjq6XzRMdN1gRCENN2Q6pZx5a0AiUvAA0hGACkRyziWlJak42b04r9KJBnPqWAU3/z6Y7gUPhCggXhxNFy+1UJa3JZOQBKMVoS9kKb1NO/0hlOJmar2c//fqPoRG2r7a78+vSPZV++Bs98CswBEqHWYHucNRTGYXdpG1HooHH8iAnIpeSvXmWYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxDH1e8EnJDmeH8Bkl0+PYfBBVhqvP/qpF98I3fLNmM=;
 b=Nt8fieNCns1kNSjQREj7kh+hThjtvYRkDNgEb5feUYoJUjoXJF/8Z94Z/oYQToH1KBAlSCgAVIj7JN5GiYQusfgj7WQ7ufo/JSc4FL7oCdKAydZJ47Hk8I6gXPBc0WAM/PXwrz4JDPDtuJGQtjxUuxkESfqgqmST6oV5HSQ8KaU=
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 SA2PR10MB4458.namprd10.prod.outlook.com (2603:10b6:806:f8::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.11; Fri, 16 Oct 2026 12:55:18 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0546.010; Fri, 16 Oct 2026
 12:55:18 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "sashal@kernel.org" <sashal@kernel.org>,
        "djwong@kernel.org"
	<djwong@kernel.org>
CC: Mark Tinguely <mark.tinguely@oracle.com>,
        "catherine.hoang@oracle.com"
	<catherine.hoang@oracle.com>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "dchinner@redhat.com" <dchinner@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chandan.babu@oracle.com" <chandan.babu@oracle.com>
Subject: Re: [PATCH RESEND 6.6 v2 0/5] Backport of XFS umount hang fixes
Thread-Topic: [PATCH RESEND 6.6 v2 0/5] Backport of XFS umount hang fixes
Thread-Index: AQHdXW2YcHxSwrTehUSYp1PaBMFltw==
Date: Fri, 16 Oct 2026 12:55:18 +0000
Message-ID: <6960f2e371138b8362922ecc0785a2945f70aa48.camel@oracle.com>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
	 <2026-10-14-1-daily-reply-0009-xfs-umount-hang-6-6-needs-ack@kernel.org>
	 <20261015144723.GQ2705364@frogsfrogsfrogs>
In-Reply-To: <20261015144723.GQ2705364@frogsfrogsfrogs>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR10MB7505:EE_|SA2PR10MB4458:EE_
x-ms-office365-filtering-correlation-id: e9feb17c-7f9d-43bf-b19f-08df2b84bb00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|6049299003|23010399003|376014|1800799024|10070799003|366016|10067099003|18002099003|22082099003|4053099003|4143699003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 2uwYCr2MGZ0oWlCyoks7AKxa+0sovbeKq4zegcaJsCb7y6BM3beUwG/xNxygho+ft7jPW1qzV/6RJCtcs2XoVe9a3dsbjJRAiuqybrw65tPRXWMDsfTJG1RiauZVvSjZSZLrzwgehP+dRWfkInG/uFUlLQS3KGiU4nYKgyZOHLII6KP8AM0ZAEUbkCagFXKKWQ05JY4IMAvd0CBR1XRjlQJTjgjZBf9qx/NgsDtA31AEBl/lmbzYnMRb2Ktyj/kR3h2MUIOSPC4Ao/US7JaoG6PXtxkLA6Ch07CviIlYGklPcacj6i20cCEIiAQ9CHc/ZT8mJliuVwvk/5/0k+skKKBWxQL10dNZUvrJjg/0jFSqLIhSo3b3q7LCu8HA3DiOXkAVBCzZQznggGlZDS0Cq6LHqwOWTM+cCEg3lftjSVyd+Aj6CMOLrkSFtLzZTPPFhctuYJ3Ep8v+dxWhPacLbJORrbYo+69MIwpyBh2zaTbZpu8WOeSCR4kd1U1s0JfU4wTXOKcnEzXQrfB+fNp4VwMLZRwJe3cKgct/jUufcyeDHaQSFDUd7kTPNKUTa31982nBIL6rd6cek3eTowbEWlQP9BeEKEz+Hqg34FqPvXiH1Ug1GOKERLdA1uY8Ui9Vhed979tHmA+F9KDLl5nonoX8x89xErjRImDkyFjNdtnLqT+lNnUg5yOlscuhXL08BTueZHoAESB8c5Gh9P0VfWUo5D4LVt+ioYsJOAyTYnU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(6049299003)(23010399003)(376014)(1800799024)(10070799003)(366016)(10067099003)(18002099003)(22082099003)(4053099003)(4143699003)(38070700021)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TCtQTzlDZWZETit5SGF0MUdJMHZoeTJXOGlDVkgrUE4rYjQrYmhCOFUzTUhj?=
 =?utf-8?B?Y3RSMjlBR2E5Wng0ZkFRd0NTWGtxRnU2M01qcFZ5dXJXV1ZaUWw4WHdmUERs?=
 =?utf-8?B?MElkY1EzNHFhd1pzTWNSbG41MnRCK21JaDdOZXk2QVZSSTNLcVBxVjRGU1RW?=
 =?utf-8?B?UVlCdnU2NDJFbWRRS05xczJEZ0dGS3NqTCtMaGVsYmFGancrc3hWTU9CQ2or?=
 =?utf-8?B?L1cvZlVOa0d6RlVkT3VLTk5OY2ZGZGdiTk5UNlJOVWtEZjltYUFMMmNHZjJu?=
 =?utf-8?B?cmJyTnhmaE5pL0VobHd1RkVpZmRTMWRCbVV3TTNHOWV3R1YxZ0NXTm00dTlj?=
 =?utf-8?B?U2hiUTBwR0NPdndrZkptdXppTHBvNHh5cG1Qd3ptVlhQSzF3RFFhdG1SeGY3?=
 =?utf-8?B?MjRTOWZadG1yV2NaZXlFOWpueDhOa01lRmxkaEhaSGxRU3FOVjNVbFdmSkw3?=
 =?utf-8?B?aEQ1U1JXUGljTzgzcUozdUJrcFBod3BuNDFjc3BKbGsxMU5vUldwbXFSbURr?=
 =?utf-8?B?Nk9GMzNlTTdReHVYd28veGQ5VHVhaUNHK0RNVFdmKzUwb0xIOVN2YWt3VWl5?=
 =?utf-8?B?ZkloRWlFVHhLTU43b2RYVkt0d1dPVGJPWG0xTUxQejdMQko1T2hHM01BRzVt?=
 =?utf-8?B?a1N3eUVXYmhhWUFldC9lR1ZWK1pBK1ViSnlndVZHZTdOZkszdXI2VXFTNTll?=
 =?utf-8?B?b0RleVVOQ0svZ21RK1dhNXVzVHdwK2tDaUh4M1dTdGZaQk1jM0VMSGZOSC9z?=
 =?utf-8?B?bm9IYXFlcWRDYzV3bGhqUmhjZGcyMDVobEJ2My9aSDc4dWlQL0pkcTNpc1Fw?=
 =?utf-8?B?S3RaRCtmdSsxam9EOVpDd01FTmdDdkFpVU1ESSs1YytzVHVhd0ZZNklxT1Ev?=
 =?utf-8?B?WlYyakVESzdZQkpGNmpxejl2MjdHeTh0ZVBpM3F6MFU2aVhneWhJbitCc1Rv?=
 =?utf-8?B?U1REOUVUL1lyMjdtaGIzVzRnUDU1SU1tSkdsbE5DN1BwUzdGdFYwWVlOa1Jm?=
 =?utf-8?B?ekYzNFc0ODIrMnBNMDVvczJUV1hUaVh4akhZQ3NxaytKcGpjVlk3c0xRYXVG?=
 =?utf-8?B?eC93ZmZYRGtsWVRSMWlNVzJ2Ulo5NXA0WHkvSENzOE9KeXppL1hKZWljdFpi?=
 =?utf-8?B?STBRT1VDaTF5RHNodkNhYXVkQ2laWmF3VjJKWXRoWDhPTzRPRWs0Y1Q4Y2sv?=
 =?utf-8?B?M1dxUmF6czRmZkFYTDNWVTV4OEllS2d0cVFLaGlwZ25hR2tpOFRLeWRoNU5P?=
 =?utf-8?B?QlFVZmt2MXgzUnR4cDl2bW14TDlYZ21KOE5ISjY5UWd3bVV0eEdoVnhOb25J?=
 =?utf-8?B?UmRkclJhZTM3R3hYaUhsNHl0Vm9TQVFNYnFWV0VVZ2lYcFVkTnExc2xpbzNS?=
 =?utf-8?B?OEYzVjB2WU4zS0QvdEk1V0ZjRFJTYWZGeTBnQkVSNzhTVHJJeE1uTXpYNVlJ?=
 =?utf-8?B?dHN2NXYzeU9tSGNrNXJXd3ppQm0rTXVpUTZyVHVrSzZBcmdhNkdTbnVtZGZG?=
 =?utf-8?B?bE0rTnRjWHc4aWFSMXZQRlJDRVF6V1hYWFA3a0tvM1hrcmIzNHpENk5ac1dk?=
 =?utf-8?B?REQvcHhNNHFneCtFb202a3RnOFpBRXFVVkRJdHAvaEVaNk9RVzhrb05vK1U4?=
 =?utf-8?B?SU56QnRQNjM5LzhQamVZV2hWY00wZEt0YXNwaHdHbkk5cXFwTzN1TXd2dGdO?=
 =?utf-8?B?dS9JODlhdnI2dURNMTNBckJsM2l6cXdDbnIybklTcTltcmFkZzByZW1mMVIz?=
 =?utf-8?B?N2IwREUzMlVWRkZ4NmZ0MllUbSthZGVPckF3Y0hId3VyYVJzcjBHbmxGNVdK?=
 =?utf-8?B?SFIyV1RqVmVGU0JWZXVyQUxKRERHTkhESGRRQ3hSK1VYSUhlR1hGd29OSzJB?=
 =?utf-8?B?WUtYeCswWlkxUEFWQnVBcTdmYVNWeVZBSEJLdll6bG1Xcm5vY2dvdElxdlpZ?=
 =?utf-8?B?cVNvN3FqTGM1d2ROU0xlL2NMNkdISThJeGNlV2FaU2hwQU9ISFVUVDBEU1Ro?=
 =?utf-8?B?cUtaTTdWMTdhM1VMY0g4NUVhenliZFlnejllcmQxL2lZRkZoSm43eWRsc29T?=
 =?utf-8?B?UGpnUlprTUoxY3FyZzZKRnMrcUM0SFdMWmVheVFhWnRsdWhKUE1FQXFzNTZu?=
 =?utf-8?B?ZzdSN2NGMnJ2NWM3bGpsNXM4d2lROFVYOHNFMUZPNDJFbFJaTEdtNzZPMzY2?=
 =?utf-8?B?NUNyRVNRWnlOYzBFTGlIZjBkSlBXVzlueStpa2FZV09mQnRqbkYraHlscnh0?=
 =?utf-8?B?WG81Mk50MFdUdnJsMmVDREhFSHpwanIrQWFLZlY3aXgrL2dqbU5DQ0RubUJq?=
 =?utf-8?B?MFVYTElsOU9wVE53cDZXQWxKNy9YekR1ajJPQ1FpQXRnZXZTbTROdC9aVnJZ?=
 =?utf-8?Q?b2ESLjsxhxukSAreDTO0F6L/XJtb+KlJu6/iFVuFLDqGZ?=
x-ms-exchange-antispam-messagedata-1: RQAwFw8g19daHe4ZUFBSQfoKF7zzXc46rRw=
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="=-hhftEsAOpL4SXoDkMYFn"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	otTvfn1ANnFOR85TT5GUh8cdyj9a62OZI40D9Reo7rS7vbHevFEhRqwi5xiAYffxQrNKdVNR5WpsjJw36a9cp21mCy/h0S+ic0wgkJoxcZdK+d8Qt37D1uN5gtwY99qZU4pIouLZV8T35hq+HIHXWNA2A1Mb254eqzLEdT9DQ5wq0M717piQnBbmpDBhkouUxnA5TZ2Iy8HhgoEHIyG/LR7kzsJPT4l0rmJC8PiGxK/mgfk0uv3Zp34Ll11+Y7L3c7AtAkABWUQTcVxrSU+ei/XfiN9RBcQvOAEnfnx7Mmllembe1KO4TEieuxjH1sm2/fDypDPlKxpjXakqwUAixA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yrwpZScHQKe1+w1SNdQhuShEwRHRRI0ZdVQrJVUMD2/4iD5WycDXD2UY8ZR7vYPj6fNeEs7nUW5Hn59D0jJsoTjYgcAZmCprA0sWXYriaAHnV75pm8MycSeoBvVSUXv0wE0CmxuGccI7b0geZ2ie7rosLzJnWWYHuCad6ZPspNP4aaQjUSxFfkZcNLc/5bQqfYPh4VEF8QM0ZlYvc2XWp+J6M7H12Yz6gGQ996aGCYC2lV7kooBOfpVwnfUg7qMOiyBs023lSt3I+RZ6xgTKexWHNaUVHuz6jovhX8yAxePlk2drgbPZwYe4Xtb8o2FMC3GF4T2LrT1ZAJTwEv0QEEn+tjW8EL90aThliU4//LPlBEqhmq4VKN4kmO3kMfqAi2+rUIYKeLm+aSiapaGyHthY1mNIuQbYGBBrSEYiVvToAikskaW6DEYk7ozGVAe1yUL3guehgr8CUVhF0HXgqdrK3wlihXtGW8DWkh/mHmahtC3KdMEXltaFaj9KH+oI6aizsD+wVeP0ZPtlA+UtAnYFtJcPIsdJlw9k+xxfvSIzRP83zzlYzW+Q2JF+OGxQC1NYF+jx5QvnLqUZ+jqWbvwOi/qka+dpM6DLdNq0k/U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9feb17c-7f9d-43bf-b19f-08df2b84bb00
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 12:55:18.2908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G4yVwhxF3xbqHvSW4Q8krKvx9+Ts+RILxkxxS5hr00v+b+5F1VO9O7iI2KDo0KDcVYUgijmJ9VAcZhjCz+MY3rXByXE9tb+7ZEdTZHPLz4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=766
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610160051
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6ad21ebc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22
 a=pQZ6ADFxtuGNWDIU4j0A:9 a=QEXdDO2ut3YA:10 a=29urpoVNIHUA:10
 a=KW-58hyzwKrJCL_Zsg0A:9 a=FfaGCDsud1wA:10
X-Proofpoint-GUID: zXSRItDRfPYLHFnPhQ5UFPW1FMzcY20M
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MSBTYWx0ZWRfX+Yll83JQRFmC
 Wm+tmahuJQN3ef9Kij67M9zotIVVldBDRe7jbhcsYtPFWvWKmdrDYq33QBMnvo4Ihh7bWNLiegY
 BZY8KF1pandlRqI34vMEH1TimFTHZTJdKaSqYz9BPxkJMH4O04mq
X-Proofpoint-ORIG-GUID: zXSRItDRfPYLHFnPhQ5UFPW1FMzcY20M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MSBTYWx0ZWRfXynBVJdrSY32x
 2yovRKk03jmVOt23e1auJlfBChwhIfbYrm3PIDnB/t9AAXCcFaTt3JOtjG0W2Thmw6gGabjpxbh
 aBzVgQ7FFggkQSFDDB/6E8tWkViE+uZneOGyFcU442PhoHiIv6NUU2E+L2wZnL4+xdwkjKvqG22
 0NRuoqUGfC71xbDSX/xi2/O5EFRTo8BOeApca5md1nQ0Z3JCSIEKHRNEZJLzeUo4+BXCZxMne6R
 UQr4GwnDjIBQxoEbHxR82uD2uO6jJrmWT9wyXmzav6rIIyIWsy+HaTahtdpE38IQtKBX+kxj8zM
 Ilfjn6W90+ffL0lkpsUszs9LkWVxw6wW7ERaamwLakzRP/rvjVXUvptsr622cnAeHTO7VXJKVe/
 YcPGvMu9+/jglXhQdCIkMPMAp96iSYAPD6j0OiFDM/DTlyHmMzvme4NA8L/HvYWzkBxLf4SV2E3
 Pp7ohFfKVwqmQpKq7jQ==

--=-hhftEsAOpL4SXoDkMYFn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15 2026 at 20:17:23 +0530, Darrick J. Wong wrote:
> > I saw Darrick's ack on the 6.12 series. Still waiting for one on this.
>=20
> This also looks good to me,

Can you also take a look at 6.1 and 5.15?

Thanks,
Siddh

--=-hhftEsAOpL4SXoDkMYFn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEQ4+7hHLv3y1dvdaRBwq/MEwk8ioFAmrSHq8ACgkQBwq/MEwk
8iq2+Q//WsJHtD8SqhLiFY2Pjf2dGcK8XNdIndgSnLjS7BccPGaufLmqsCAMwpWR
LuSMGwcPTFSz6fddslRU5umISlIqX0MB2OTnJt6u/YZxLu9UvLN2pjB5ZCb6h5Pe
QQIg6oPpfZX00Hm4qh5zq2iq9vNjIiZ8d43pcvIiTxYxCsBrQ5BURFkFrEr/cvS5
0OXP8+jg5YuTlNzjuOCnqURLYHvbGNuy1/evmLfR22tmvihJ7LyB3hX83gF7wkHA
U87HJknxd9YLQLeVLg/6K/IFrCGIbDErPAmxMf9Gl560DCkUoER/xisFhslgSQDf
LV/PbHnG0Rro/HjZI1EXZEB8uDZ3ASJiEAswh5hZtvlaiY6FCdfQ3vM06ai0aG9x
v2mXQNpYsZvLKoQQJ2w9GhI7iRQnTsW3ngx/kvNcgOBHB6hyIHuK1QnZuvw/NYAW
Ggtpsah50ANLSArIn5jTON0U60ETL8Cdqska1TDXf0gQdI9sE0guIe5mWY6VL0YB
0R2clrnjxq3iCvWOwBleALvyKkx9pBBdrcXm1iKaE6eT+7ns9dxCG6O6ioHhyynA
aUBXK8hFxbhR2XzaQYdumQg/JA6nx0dhoYS3zWk4Yck2/WlHRxS6kMnFWadDBeF5
ngoKzPqbSPqdT2JSXbV/+iBjBolUw4dPjFYcXqEQ5c3vgHBzPnA=
=0rTS
-----END PGP SIGNATURE-----

--=-hhftEsAOpL4SXoDkMYFn--
