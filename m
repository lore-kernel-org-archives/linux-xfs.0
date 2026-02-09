Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCAF1B4138
	for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 02:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770605471; cv=fail; b=egmUJ98Ue5XRVOlkPORISLC+NNFB2crCvh2uP8/jGhnjvfIcwcPS/uq3BjJcf2U0BPPPjS5FBf2n+qWzwCkIkRFFb/nWxsLeNDv+3F2sNqVIq5/i/j3o188Q6ne3WORxJbjaqvPdU+JHDrEPuTQs4d1vEbr302OkiE9GCmuxc1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770605471; c=relaxed/simple;
	bh=5c3hSSwFQTSaxWo3U1RY46VfN4mlaK0T3CNr0gh7N2w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ac2Wl9R+qnmIziW6nAYetWB4ooNnmIexmcXESVv1RsUpStKN7gFgWz6m6nnJhK3yIscnbeq9tZtxFKvqADA/UORWCIfrMiD8hUEv6uEu1Fl+IjjuWGqMMXlLb7QNN3npteIOz1x8TlNrmRE6PWuqHH3O3+ldBRA56Y4RjgGL7yU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FEaTFdPT; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=oqwSwPKT; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FEaTFdPT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oqwSwPKT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770605470; x=1802141470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5c3hSSwFQTSaxWo3U1RY46VfN4mlaK0T3CNr0gh7N2w=;
  b=FEaTFdPTICdwgLViepva73vt2qM9CG1TWyMh2OCzn2pOy2PJSYS2Jy8s
   tUb065fNTYUiXxbUNd7RXbtJysh4QWQ2D+O7g6c713D5DJC9IXJa5NmxV
   O5QSqny2kFIhtfYagEo9P8jHloL99JFK9bOickvzvND2FjVDtCigg3Sep
   vlQUvu3A2J7JQt+ypTq+54NxiheO4v4NzCFSwubulUrpJUTcuf4BfCsG7
   OOLIRb9QtYdruVYkBijBdgx5lFL36kV4Kcx6L2Kd+NliWLDImm85kpCBK
   pVicC5/llA6pdzA7teDcDUXl4npKk0zFOcDPKC5t4PwKGCCqMhKsoOeTU
   Q==;
X-CSE-ConnectionGUID: pCaKzFTMTAyEbh4FMuE7Fg==
X-CSE-MsgGUID: 8/P99jflTMerhF0DyN9vlw==
X-IronPort-AV: E=Sophos;i="6.21,281,1763395200"; 
   d="scan'208";a="139505261"
Received: from mail-westusazon11010024.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.24])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Feb 2026 10:50:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pIst2R1wiOpFJjoV8lmylaInS27ZhFruOC80htX2XK5jYNNk4twd35pZwn3sozjTDasZ2V+s1GPQMwUVaGad9/gx2SoHBvJCC26pxb7OOSstSpWmiRfs7UaF6zOsRB1YJOmPME4WExESRqHmY44GjfV4YtdsOb3cLe2AbD4YeR0JIfIW/h1GV+0Ab/zoKhrVMJ8AA51aqqK051btpLdzf1ikT7bsY3uwQu41HuTrSs5JqaWwq6UYHTpQMsEzLqvPbXzCmnV2O7jt/vzzuPMDfYgWzxHBeL8IGdaF3sqGOD2uE1s1NRPswg2fHfPjmpWpJyS+LoEPuCl4v8b7zV+VeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=isdqHXWbYeeqxZVOl42wzFSSB0OXtcaJPtjzc6YZBNg=;
 b=Fc9bo8BIcfdXMEXYcjQ0p+r5ZPFKlwZOwA4bQaevaZghpnCTjFrcHR/weRTDn5C4mCOO9+CpNbYRzHl1xrw3lzhk57hDfBKHTwVa9c/M4XcpNkOxarVEhWaLrqJhG5BeEcy5Nu6jKTWpvXtrRyI1eiWPH6z+RkscnP4XhAoOToQqXdb8I+zPwOjHjzMEncE5zXkfcuPVx/04l0IUMbOubb1eIl85BOq+ZiIXriiHYkNoMDgHqI7xYvxPmF1p5u3OtywAgsz21wY39AJQA+9o106t/+L1mmI726+yikKTnrjVNEU6l/9k3b6uxNc13HpkOzaE6XA4EFiFZdXeP3DPLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isdqHXWbYeeqxZVOl42wzFSSB0OXtcaJPtjzc6YZBNg=;
 b=oqwSwPKTeCDpXRngQqzFt4TU0y/+DFNuKH8mI/XZm0gJkQKwfjebGTAseSbB+AOxekxleyPdfh+4gaZ2rVwpZNUtMmv587cHmx/STIU54ET0vT+KmaruV4kjL3OjCB2zOciUbG7avNjkaChhSXMejZRkwTtMmUJ0isbfBFZxKng=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by SJ2PR04MB8583.namprd04.prod.outlook.com (2603:10b6:a03:4f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Mon, 9 Feb
 2026 02:50:00 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.004; Mon, 9 Feb 2026
 02:50:00 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, hch <hch@lst.de>
Subject: Re: [bug report] xfs/802 failure due to mssing fstype report by lsblk
Thread-Topic: [bug report] xfs/802 failure due to mssing fstype report by
 lsblk
Thread-Index: AQHcl0QyMGi0b3KRKkOnzTIETMr5/bV18CqAgAO+3IA=
Date: Mon, 9 Feb 2026 02:50:00 +0000
Message-ID: <aYlHZ4bBQI3Vpb3N@shinmob>
References: <aYWobEmDn0jSPzqo@shinmob> <20260206173805.GY7712@frogsfrogsfrogs>
In-Reply-To: <20260206173805.GY7712@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|SJ2PR04MB8583:EE_
x-ms-office365-filtering-correlation-id: 5b49a092-c001-4378-b67f-08de6785eb11
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?oTlDnYVlFHWf2GIeNT2541SmiSEfrH56stbw/vt9/K/OzVv3+yCH/JY9NT1M?=
 =?us-ascii?Q?tOLg8j66OdJjVhxL57SM8tjkKSqAL3VBA8y54C2K0PN1cSHQ60Ay3jFzG725?=
 =?us-ascii?Q?t9nkalw5iSXxI3lCvBh3S+qkzVFu8Jfrk+iEoBZfXohnQvTpcqiQZDHecMxx?=
 =?us-ascii?Q?ZPAgVtUgDY+LgXvq+JzWsqnTwsmL5knHanSw9XqF/5ohi7rseopq41xdnscq?=
 =?us-ascii?Q?g6p/vM4Jqh+xvqjyrGMFpG9Vurp6tacHemOVNGUA8MvpODjbeIgsUFXcA04i?=
 =?us-ascii?Q?t962nb8isbrXUEF8wITt4I7tY6nq0sMMWCELq53fF8ok+FkoGWv083t7G1Su?=
 =?us-ascii?Q?20qbt8sjHuWcWLh/tfGh6ZOOG7KDqTQJl0mIUzTp4YDXe9f1bQVuYWo7R6L1?=
 =?us-ascii?Q?yQwCi8gVPwaSl8bfsyTu4GapYjwHWvFEVciPpe04QipX+Kk1SbAF3QF23HaM?=
 =?us-ascii?Q?ajSVNYvx2K3f6YMU/mK8w/cWoQMQGzX7lLvs0ZVneS/8qIKw19Oh5WI11nI0?=
 =?us-ascii?Q?tJkN7XtEv+2wV38+AcW6398BAqhYEb7/sDiD3J4cP6kH+CiFniFnL+5Cxs1K?=
 =?us-ascii?Q?sQ3yI4yn7Wrr6RNEb4egczc3rhMNLoEfPRDTPB3PYlD8TKFWwgkl3a/yHauN?=
 =?us-ascii?Q?D/oOZmeOi/R3tTTz7g3NSPqAsuCyBSsyrInlYprLvTS5p56CsulGubB+WObg?=
 =?us-ascii?Q?r0kb5ZH27nIAlMqxtZx5Rmhpc9C0mZ4iruW5s5bUH9OyTqhmyDR8pLrGi9Rs?=
 =?us-ascii?Q?PXxAm7d7ARmwEY7nGfmI6M9embVBOw1X3ZJG+06Ru6ekm41dhm7a4HIMhXja?=
 =?us-ascii?Q?CzXsujZYAi5vm8oqkBL+hQpSkglTdEWpFEWzDyMJobEERCeEC7ByorjkkSRv?=
 =?us-ascii?Q?Zm1i345aWOMguphiQJhSXffmqAbY2NW79K5ZieXguAhb2XoyJObYfIsr6UAk?=
 =?us-ascii?Q?lL2R3RdSQfYDRSayEiJNTKXmkX4fm+N9chdi7I/o6J/c19cR3RFUpLikXs8P?=
 =?us-ascii?Q?4bd2HMcZCu7QsikXKziRGsu6nbpGIaBd9KNOpvdhloOco47Wo+YP7R1NlHHk?=
 =?us-ascii?Q?PaQo2ps9Xah006Dx829LqtwJsDG+078yUaSMwG8C6QpmniEsEUN6Qv1fp7Hk?=
 =?us-ascii?Q?GfcaInKKkvYAxZJ9rHwhlSlnjpo7v9+Sg65jcsBCWcn8naTGjwTF2BxetlS9?=
 =?us-ascii?Q?D95jQSH0m1APwN9sQdAc+mWOPvIUBF+B3zbkosX+1DZrlGCSgDRZR6B5oLou?=
 =?us-ascii?Q?FpjfhRCwXRyrIAaLb7v7X8aTW7VWU3FJo94dJZAkxczYaYR6PyJ1vjT42UxY?=
 =?us-ascii?Q?1+UjBCESuCgrP9pXa6XAMzv3b/LQp6rEta/Pqzivvn/4WVcAvztl93NSlaTq?=
 =?us-ascii?Q?QbeeUa8lkvDVVU5YkbL6U/SrHY1EBt31yHgnIjKTFHsYtF8c9lrLqVGKrsi6?=
 =?us-ascii?Q?2NLEpmnl4p5eT8P/D1MAFX9zuCg50gtIIrkLPEO3WqP9HMsWyyjiISyDT40H?=
 =?us-ascii?Q?eZunL1TdXTDu1ggIfN3Z1q8leqlWI1bcqPWlarLR/YnNcEyW9cp5Zdh+FSLd?=
 =?us-ascii?Q?A9xu/fXQlPkJbz1Y/IjRS/fYOn1mNFdXMJjl7cYbDPCP0hTF0AFZbSg3LwJn?=
 =?us-ascii?Q?HCW2aY0fT2jzxzX9ycS95e0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?/er0iB+4aaoi2gZuJJr/gExhyprY093dETLblYCFRHFVBL8m8NwtyT4lKasQ?=
 =?us-ascii?Q?p3aq3AyRczYSav1j2JcjqVTA+QWQe0bQAaqIxx8VH7gMTMbazYheP2XEgYn4?=
 =?us-ascii?Q?rBgyZfuSMUMCbLFoE0XZDW4amVA31V2QwQqujrcatp1cOK3Y8npYzvHRmtKP?=
 =?us-ascii?Q?hOzPx+iFkFu9Bclge2gVxAiwYBOQr00z/4JpbSlCQZBJkE6ERzzOAvo9WNNV?=
 =?us-ascii?Q?QnzE2Xb1zq+R4fIdVhUwOICWFfIIdL63U7R4dc+Ujt+oFmn7ZqCJxzpRRpg1?=
 =?us-ascii?Q?SSkZli8xV3EbQW5QsU+sAdVUYieuwh9IAlMemtm2svlKCe8yEPn1qlS0QIHd?=
 =?us-ascii?Q?5D6u/6eeNeLhPPmsg/skWwmwKIzAjJTRmMGH70km0B4PIuZIu4uGUU1IxDW7?=
 =?us-ascii?Q?5xxjH78FfIuLT+5vBh/3U03aPJFqFama5XBiV0WjcwL8HLyp1H2jAcyEYbFL?=
 =?us-ascii?Q?DIxOW1DhhaRDx0M0NLTYJKLhWVOzxDadi++MBU2aT50Gfg/RYKIUbLdLhq/M?=
 =?us-ascii?Q?zjTzwwVedsHRqJqk5VoCQu377JQYYN3lJWOt3YUHSTLEuzAh/7W6pxebsQOg?=
 =?us-ascii?Q?fMhIKuBtu0RBsAKF4cnsIe5jeyONQIrS6+3LGjHeglspnDjTL3SJS5A2wDz1?=
 =?us-ascii?Q?ZRr/i5A8GxoiF+2Uy21GAYp9n805Y7awnX93u46WjwEQo1KX84l8+dsaRwxP?=
 =?us-ascii?Q?0SZlGUxt86iX53RtdnLMzz/r1seBkqeYowY8O88mCGZR6p9uSlh4QfJpbycP?=
 =?us-ascii?Q?Iu2KrzBXjJ8ilILc8vDJm7kg4+D94Zm1bqRLM2agvf4SYiPYiDBxRZpDL/x2?=
 =?us-ascii?Q?bNfl1z4VigQdRGKVfAmhxaRWGBw5bwWEI/MNEwBytFZtAP4CfL2oniGPj0gF?=
 =?us-ascii?Q?1kk1V4wuVEZw+h4Yllh7sjGF23mHh4Ne9MIAkLUdgZ7qX83By9qXyYNlkHUM?=
 =?us-ascii?Q?s1uqCXhnM4rllpWSbyRjtDTw6RrBnIoZv87kTtMK/JHnHr2P0YAYCIcCUnay?=
 =?us-ascii?Q?K8ceqya2MTHMEHWZLqhzgnJUIMmHQHMJrGprQ/+Rt2P8g9jZa24PWwPfC2m6?=
 =?us-ascii?Q?ttw8UJz3SJr9GTd5cEgE0AlCWJRSzVWrXFOYXOFedcHxIwCyw0jz5cPmQ9so?=
 =?us-ascii?Q?pfq+3GVH2vdtJqwjX6zrNwMt0YFKyRujN3Xli3+w6kq2xlES8VGFUoVedd35?=
 =?us-ascii?Q?U1gglReP9ZDeM//uJBrOttm3JZwCmbXSrAAD7VrRm4Rklv6D5GARmspnYnLU?=
 =?us-ascii?Q?G2WpcLzBhWjHAWwonpmZ4cMpgNpH37JoxcwJEjQHH/9L7vaRdUTP77khvLs1?=
 =?us-ascii?Q?SVDSAfC1fBkSnJyK2kiobV4Na9ikIoa36nTH24iIkrM34aGrxA0koXm0EUF8?=
 =?us-ascii?Q?lRvN7KJJGSqiw1UgUANLShnUhjpTTB1Dk0Nc1JYRoqt1+FfnD/l1x3kNWsu6?=
 =?us-ascii?Q?vjDgEJhnXFvzNo8MGye6Y6q/pBEefFpXJyFXa1St8KyAeZBpKUAMct9l4c1h?=
 =?us-ascii?Q?iBLHiIka1k+Tn0bU3ndeie+uDSGmldZFBVKdJ/5Ljz5gQwZVYw1zdiWokIMV?=
 =?us-ascii?Q?ty2d88we90m7lgTdxDEBw4NO8IHPdP+6aAkM1sthwRh9XZUqX6gjRNgOsD1c?=
 =?us-ascii?Q?BTdt6eCKED3XOVN0RmgSBjWbdKBOg5A+PkpIO4bQQR/dbghz3mANCZVloK/F?=
 =?us-ascii?Q?MQn+yDzf4FbGqBRuNVG6ujgTeYGMA8QW3pldu/0CzwaL8uhXg+uERABQAA1M?=
 =?us-ascii?Q?iZCSy1lLHqd1ntwOMew1+FtLkKgcU/M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A8633B321DDD54FB9A172DEF5C7D4AA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AYfEDCa3nVpqZXAjKbBzK7H49a3Qx2bpGivUu9eAkTmRBzmU+VJgPEiu5woPpBwgO/5BWd/z3h366W0LA1qD3jkVJTEd/mrymuHXvQwks8Pue3fMb4FQUMj/MuEUfTJWez18l+F+Vg5R/1BovWYpOGL88dV/wL+fjEVnFJb33UDyoGvuzBNw/MQmhgDWPgFJ0cJvnRsBoJ8OX7aO0REYDcjLVhz7Izx0wbvm1JCRMDmQKs8NWYqO9TXc7mWt5q2A9LP+yiB9rzAVe0gYfClcv5RD3gze8Kl7dZBDYh+Xwjk6cG9E0a4Bdcu/pgLakjCBS8iymFvsLDQxqiyRv1mq09oXGjDoZxUFLHQjrD0WWdlqHFSyt3uoYqDT9ct/pyBJaUuS0EAc+SnpyYpdPUVLfWjx5/XNKYblD+KxhH0Xn5fgiD6S1qcgqJnWP03lOxuEsqmrGj35V1iRUJ4gPGgDhOQxPFtc4da7tcYrGd88fYvnnIYvjzMpFmBoFEoiU1vcI8Wd6P3uVdNDvUdkQyqooBSF7q3RHdc3TBzcA9YJvisCS4kn78WKrmx6xaHRTm3CmIj6kHuD99pUAdRoDYml41ldgM5tOWRDpbHhORT4iSSSq1kAXQlODY1nwspTty8c
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b49a092-c001-4378-b67f-08de6785eb11
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 02:50:00.5165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bUbIVfUJ1e/BbO3lLIEfnwB6jxWQWdz4TKlVktuIxcMLgX1JhZfG+B3IiAjJ6QAtqnvBtgEzqn82w3uQLDTHblbjBuvOTsCEFjCUBrZixM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8583

On Feb 06, 2026 / 09:38, Darrick J. Wong wrote:
> On Fri, Feb 06, 2026 at 08:40:07AM +0000, Shinichiro Kawasaki wrote:
> > Hello Darrick,
> >=20
> > Recently, my fstests run for null_blk (8GiB size) as SCRATCH_DEV failed=
 at
> > xfs/802 [3]. I took a look and observed following points:
> >=20
> > 1) xfs_scrub_all command ran as expected. Even though SCRATCH_DEV is mo=
unted,
> >    it did not scrub SCRATCH_DEV. Hence the failure.
> > 2) xfs_scrub_all uses lsblk command to list all mounted xfs filesystems=
 [1].
> >    However, lsblk command does not report that SCRATCH_DEV is mounted a=
s xfs.
> > 3) I leanred that lsblk command refers to udev database [2], and udev d=
atabase
> >    sometimes fails to update the filesystem information. This is the ca=
se for
> >    the null_blk as SCRATCH_DEV on my test nodes.
>=20
> Hrm.  I wonder if we're starting xfs_scrub_all too soon after the
> _scratch_cycle_mount?  It's possible that if udev is running slowly,
> it won't yet have poked blkid to update its cache, in which case lsblk
> won't show it.
>=20
> If you add _udev_wait after _scratch_cycle_mount, does the "Health
> status has not beel collected" problem go away?  I couldn't reproduce
> this specific problem on my test VMs, but the "udev hasn't caught up and
> breaks fstests" pattern is very familiar. :/

Unfortunately, no. I made the change below in the test case, but I still se=
e
the "Health status has not beel collected" message.

diff --git a/tests/xfs/802 b/tests/xfs/802
index fc4767a..77e09f8 100755
--- a/tests/xfs/802
+++ b/tests/xfs/802
@@ -131,6 +131,8 @@ systemctl cat "$new_scruball_svc" >> $seqres.full
 # Cycle mounts to clear all the incore CHECKED bits.
 _scratch_cycle_mount
=20
+_udev_wait $SCRATCH_DEV
+
 echo "Scrub Everything"
 run_scrub_service "$new_scruball_svc"
=20

I also manually mounted the null_blk device with xfs, and ran "udevadm sett=
le".
Then still lsblk was failing to report fstype for the null_blk device (FYI,=
 I
use Fedora 43 to recreate the failure).

>=20
> > Based on these observations, I think there are two points to improve:
> >=20
> > 1) I found "blkid -p" command reports that null_blk is mounted as xfs, =
even when
> >    lsblk does not report it. I think xfs_scrub_all can be modified to u=
se
> >    "blkid -p" instead of lsblk to find out xfs filesystems mounted.
> > 2) When there are other xfs filesystems on the test node than TEST_DEV =
or
> >    SCRATCH_DEV, xfs_scrub_all changes the status of them. This does not=
 sound
> >    good to me since it affects system status out of the test targets bl=
ock
> >    devices. I think he test case can be improved to check that there is=
 no other
> >    xfs filesystems mounted other than TEST_DEV or SCRATCH_DEV/s. If not=
, the
> >    test case should be skipped.
>=20
> I wonder if a better solution would be to add to xfs_scrub_all a
> --restrict $SCRATCH_MNT --restrict $TEST_DIR option so that it ignores
> mounts that aren't under test?

Yes, I agree that it will be the better solution since the test case will n=
ot be
skipped even when there are other xfs filesystems mounted.=
