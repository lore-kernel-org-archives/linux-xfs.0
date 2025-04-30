Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A1D19F12A;
	Wed, 30 Apr 2025 08:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746002486; cv=fail; b=a8EyMdD3QjBgVVhB3A8vwzpqOqBeV7++YdsIGMxQea34L4eqZoBLEBzziGK6V+G5QpJKjR4cgLiS1mBv3Mr6+eKs+4HRuNCCEF3K7eTPDLTTTQbC9l1aLj0cptMNShlwWTR8TQ9ExglYpPe6mBNC0KdFhxR/C/eGYpruhZ55Fq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746002486; c=relaxed/simple;
	bh=GrhwDpzX1LkBfCq4KAUCS3DETpUPaxYmWoWIgJreaA8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=EEvabrF877ePILBBLZoidrAbttPYkaqEOOmcP1KdCXPQ+isQrraaWY81mZ4zAX2ih0r19kk5rz8mW/M/oKq0w5yN78X+M5KTam4+vAshgMQUEcMI7pDui39A67OWZpAapNPEKJcmpojXbkIrgqxRF4YDa13Uz2LG3wKTGO0Oc4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=a5QcJHyQ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ySqYtk5s; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a5QcJHyQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ySqYtk5s"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1746002484; x=1777538484;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=GrhwDpzX1LkBfCq4KAUCS3DETpUPaxYmWoWIgJreaA8=;
  b=a5QcJHyQoz3WYPwo7+HVVhHE3GQLv97C0B+426rUhY046ElhCuK2Mr+Y
   czAtiGnww9K2PIu0OmHEb9zBm+EYYp+OKISDje6M75Qz68fC0H2xdmDi3
   BL+rlpOI/RkTLLj8X5Y4t5sr1TEpjzqsTSXnmRt0Qr2/cMLH4EzhU/b5W
   sPxOcQv701jGsnYNvC5PY2QwfRx6Qa3rj0OkJ/MUgFE/7BIGiqfXkFfBV
   OPxH75YTfew2LsnJoaPX0ZE5N+TzS6PRWuKp3QsOhG8tVhDrK/jK7Xsuh
   mSwtSoHrKUAItu/ImqJyM3yTuaEm/iv8npg6t+2gQXzZcUq55Jf4Oemml
   w==;
X-CSE-ConnectionGUID: 4bO2mHzSSBar6tp8BfNVEA==
X-CSE-MsgGUID: M2o35gztT+yHM5tAqdjumA==
X-IronPort-AV: E=Sophos;i="6.15,251,1739808000"; 
   d="scan'208";a="83812746"
Received: from mail-northcentralusazlp17013063.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.63])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2025 16:41:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iIez57pKJBQGvYzHc83t+2JktF/T+JY7Yv2oFmIp03nwEzw1ZLTRqwlal3tEAawoBdtXpwQr6T0/qGtsVWVLVMD3c7LdDh1DQoXCMaYxKcnIFw8NZ1IK6aFFkpRV6I1nOHo23PX55xh8TvJixyvtuMtv3ggzZlJa4draao2+AnoO8sI0v1aGhTU+08B3yi+YwAcgRDJagOOKbcgkjH0WczptHR+lP9tW52xzWptrB56S+5iwPVFLwDY1lDsw2Xcr1pzao8OigJmQBJo2aGdHucr+pX8MyA0Ug9oz0Lzg4CQR/a0ICkZCADuFS53ZEtosLrCTER38vK045qkPNXjh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCRj9YpQNG12qrWoAzaup+4kjiSzIV2YP0iCf1Kyo8k=;
 b=YqUuh8SGQUguPmWBmSTjaBmOiW69DxMdU8dOkPgwKHIgceXFaA4Qgy3EAVWZJC5rdHShuP71/6lWdPciJRVvVJnbwfUy4LnuFYup+6Afb90ZItzROZlRqpwGt/NkkYGgSyzrJPu1Hl8tEC8kSXfQWUv9sC5vAQwDup/xtR7vlHI760N64ZbHsnBsOswVou7dxnQ/YtTlWJg66AOJ6uybrtpGV6PvpUtHx2zvk9jtoXLZIQxAym0X6tyebQn7rw/xDLe18/z6oD14T0tYnubCknI7sJVtAc4eAbfiyhvwL37cc9tvlu7in8WBbAmpzq2LX85tvLWgpRHM9pThgfgoXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCRj9YpQNG12qrWoAzaup+4kjiSzIV2YP0iCf1Kyo8k=;
 b=ySqYtk5s4OsIM9OG7eTecAe6eIWYxDNWK3fWo1mY4P9QofN/C320ZVpvLHWta8BY58oPI1QEMuo+MStPzAxiH0l4zN8O7StjWKDgTgjpR8TEOx6T4B4EyJ5ouzqLk1GyREhPwsU8RpbGSsSm5K+jZrD2vy3Ftq2CZD3Tt7XYMvA=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by DM6PR04MB6922.namprd04.prod.outlook.com (2603:10b6:5:246::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 30 Apr
 2025 08:41:20 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%5]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 08:41:20 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [RFC PATCH 0/2] Add mru cache for inode to zone allocation mapping
Thread-Topic: [RFC PATCH 0/2] Add mru cache for inode to zone allocation
 mapping
Thread-Index: AQHbuaulT306JQiZvEGa3xD94cD4cg==
Date: Wed, 30 Apr 2025 08:41:20 +0000
Message-ID: <20250430084117.9850-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|DM6PR04MB6922:EE_
x-ms-office365-filtering-correlation-id: e9308094-1171-4c66-4902-08dd87c2c828
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?NbKnRKK03wg/R5yiib3IQNphPxO9Jl7UXXTVb94+trbm5CSe3mcqREUb8z?=
 =?iso-8859-1?Q?27dofAq3kWC8phFyk1+HXAd7fgTXWATURztgZCCV8HVUCfmCusGFZhM3GL?=
 =?iso-8859-1?Q?PXSRx2kcRoDq/Xba2rZwfkI4TgR8jJcPWG+mL8rDzoc/P9uudtWY2yI2Ok?=
 =?iso-8859-1?Q?/uQ4tXK0gQoTg7Vvuw0OPcbN2mgzy4CVOFYJXrG6IKjO6jVvzU54QaT/RU?=
 =?iso-8859-1?Q?0m7//MKvSug/qn9d8GmfmONza04rbow2dGibQBEr7w968pcgw295NOhpPg?=
 =?iso-8859-1?Q?GD3Iy+wQGgKFEi420LG+3X/O+tmw0P3KJlN74uWipXnCZUyUlW10OU2zBK?=
 =?iso-8859-1?Q?Nia7zVMPt86Vckf4eNkLHAB3/aiCLpSKvTyMXKA9nofCMBizz19F8N5xGe?=
 =?iso-8859-1?Q?SjVp3Za4wLGNi2YF/QCJh2toihgTIVtaCk3bQ5mhbMyhaODr//ZYpAMqvg?=
 =?iso-8859-1?Q?Dmt3OQb1F05fv6nS+zSRmvu8vj2FsxGugmkSYh3fFEWYGEoPnRqe12m9lb?=
 =?iso-8859-1?Q?bdg8KkknOvf6D3ScQOoPUay4F8xiMSSC/Snr1Z3XN1c2Tqn/oO5GMPTzPz?=
 =?iso-8859-1?Q?uHzfGrj1SpjSPekMbXjc49EcpxlXRD5DkyX/urTBgRjPu02dWzDe522sZe?=
 =?iso-8859-1?Q?v98qbi2Ww2mIYHVfTqoNdBXbflTo43Y5Y8bzOae4bnnJ+W5hHLC7hRX7jX?=
 =?iso-8859-1?Q?6nPf1htYmjy1d6i8OdH6XdtaYoDs1zCr2ksFMAosmHqiRniFCsBjEKyy60?=
 =?iso-8859-1?Q?x1ijIRfKCxQVy/R4jRuIVBcllLBeYXq/Pzx2DxjzqbA20nvtGrZwqhwMSL?=
 =?iso-8859-1?Q?QocmtbSmrB3gHJVpFz4E3ywJ7HfR11uDiflyWG+wpgepWff5H/Kit/P8D8?=
 =?iso-8859-1?Q?5P5rl2AfyC3ezLBQ2pOrUyeeLjLB33Iqrb/hyXLp+0WyGe4XuBkCYOb//7?=
 =?iso-8859-1?Q?Yg7ExxD31w1xu+5hLrFQG9aAiMVj+R4mS35KaWBLGd4AIYjh+Cnoo39Ch6?=
 =?iso-8859-1?Q?yNCwE2a9BdCdmR4VYoGmHJBVl1lozxgRUy3qZ4HCxPYLBJT+utKaZa9Z1q?=
 =?iso-8859-1?Q?CRIww+j+e/4Gg58GVCtK4FZ9MyuKr4lfZD6lfdbORhMRIEIW639qOg8rh0?=
 =?iso-8859-1?Q?7HWCEn4I4GF+2600tGl5tkXK5xtDqah6gLyPND7i2QKLnFm6WlRNV3bYbM?=
 =?iso-8859-1?Q?espDkAsRwduaUUZRwfejxsHFck0rLlFHXw23pJ5P9iTMfp0mprML+Wb3Er?=
 =?iso-8859-1?Q?12dgHrVskQsmkgcPSZLqEuWyf2RrLqlipO9a4W2FXcCWbjBk3iNBLHsNyf?=
 =?iso-8859-1?Q?BcUJdBf8uh2PkWVPZ2Ay8QZcDISfDb+n098qaGnj/xeLxn5lb5Qao62TXO?=
 =?iso-8859-1?Q?WKxtr2XNUJGRB2SsvrC81N5VQg+Xz8/qGr/aPyAbR6/8hmMgxgj6NfgEr3?=
 =?iso-8859-1?Q?QIhF06M8ov5V0TiFArPEIE05GzeSmsTs08fpQYb3qh4o5mwV0PnPlhJjDn?=
 =?iso-8859-1?Q?xf3bGJCKyfPlHl63jys/RKU2oaBigrGYDnJY1Tr5klQNMnJGgSnHMrEDg6?=
 =?iso-8859-1?Q?l2vl6mM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?zwP7HpXWLYZ0KUG+gUhDjz1lunp06WGFgGfNxcJscfcTj8gFslOysepDIV?=
 =?iso-8859-1?Q?GHN9CfgguqXt+sG5Sa9hmi2NxtV1Q4cHCWZ8EUtMDlTrERYzHvhIm79n0/?=
 =?iso-8859-1?Q?ykdo24X3EqT3aH1gWlvcbIeDl6gRuZgpsSZr/N4gawOsEnBfeNfF4IIsF2?=
 =?iso-8859-1?Q?stz8OHpzdfSa85Oo8cxGLLsW6n33bNHY1unr+PW1XM28QHdqq0SCMUA3MY?=
 =?iso-8859-1?Q?rfz12/gcKeRd1+phReoKX4IphrXln7ADFbbJHco8eqyXe8E0vee3oyiOxb?=
 =?iso-8859-1?Q?ds4/yGOgp774tWhK8mUDzTBuB3+0jqBiBFPeALrEh8AMoiiZoEHpS5eDTN?=
 =?iso-8859-1?Q?IAFwGZ6PKdqrcnbnCBhFRGUXa+O1gjFPqEk7hKTtPIK/2fkvXALJMKfJP1?=
 =?iso-8859-1?Q?ZHU8iNDFhl+Yqeo5woPvtb5567XUGf+XWA7HhyFaSm/uw0p2JqghRjRDIG?=
 =?iso-8859-1?Q?Owqj/yuznn6GoFd9hrwLSBATmjFJRZbV34SxoTUEx/5tb0gsgrv9lLSRWJ?=
 =?iso-8859-1?Q?Dg7SkSqouK1Lrcnxyi/Sgd2F/abK1w958MWzqMsRamANMZxntw3mUGtbhN?=
 =?iso-8859-1?Q?ZrV9YKSwqh/BRnjTko2R1ijz8Gt6gQMYdYrJ96YBcyKQlMKyFDJaroFt/e?=
 =?iso-8859-1?Q?Acdltm2Sc7G8ZWvD273xG31Eu7D8LFt0dCIdKSw1ukb5BuAnpGRFk0B2rF?=
 =?iso-8859-1?Q?ooVHFjFkA1HfOZ5vO53IKlMqV06qgHpoiE8q0Tuog0xjuB90u0GcnBWTgg?=
 =?iso-8859-1?Q?VsTRYrqNS9jzuQchhZLsFQ7ND85Joz+w3lXC+pdk7JQP9KxhT0b8Rhr/M9?=
 =?iso-8859-1?Q?P3sfc6Z4nsCylXooqYE4g4b3K4zYGdIG8qvtHtyko85VNR9k4453xtuuxE?=
 =?iso-8859-1?Q?SYkR3SgIZ9d2bQVtse17TKHzeDooRiX7NJxgaa671gfgG2Ag1+xqsv8Eh2?=
 =?iso-8859-1?Q?2ypyzxev0+ukr7XrxDQ3o14GhONqf3oGKijtkDYi2wpRnDt++yVdGRCxzV?=
 =?iso-8859-1?Q?yBsLRR4fsnwjB8CwZczIXsDMpYgzxN6ebzbwjHiAIqS6tB5Y+wYD72CTdV?=
 =?iso-8859-1?Q?SQA5OVSOgkLXKmKIdtS09zkS86n3utV5jWlnB57awZwdsaCt5oTI+ISlMl?=
 =?iso-8859-1?Q?A357hl4P+X6fOhZI+/3VAuwMWIX6hlJFoI6760VIkp0uwm84+yFkVWaQmJ?=
 =?iso-8859-1?Q?L/qy+52lq/Dp4f/BTgCZ31SkAL3MUcp3TGvCnxW2CJCGVdfhZb3G+C6FEF?=
 =?iso-8859-1?Q?tMuba2lRRV5L9WIXNz8mDuklCUctQWUCs17q1wbOkSQagY2d2Cl0XgywIh?=
 =?iso-8859-1?Q?XlLw+OFr7v0nQcjfSdFJY4l+RptVYiXm6tcDarRd6W/bbO02SZdMAmy3q6?=
 =?iso-8859-1?Q?adMNkmKNf/CX2d4s0a4HUHURhtmI0m0b3cJJiLGPbN1OcRjlxYRkkSgQKJ?=
 =?iso-8859-1?Q?fyTWfFhq5PjzvA6mvgXsbijBq1rF+Hy2ia8jQqhMuJOTIn4l6fupiVTXsc?=
 =?iso-8859-1?Q?tZNAZKx52A7voXO+OqVT8pmqn6Rnrc34JuoG3sRuvQMOEoRqTNTWdsn/k9?=
 =?iso-8859-1?Q?wmt767X44xYjxPmLernNzlQqwHNvLrvY5jANFvy4F71qYO0He7+JdQ8hl8?=
 =?iso-8859-1?Q?AomHHOYxpgNHhmofHyJ4x/pOiTxw0thXY+IIlJ31Pty9tqno+czUlDOA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9+FYm+dr0xmIPw1AvEYGaKzx3GcwYYP6CqiBl8bTO5bXnjcf6yE/qw1ejKYCgwEL0ZvHVnEjgItOLoslzRLqP7JAKugohODxfd4iIE515Pz7rBLuscnaVzVc4RWuqTN8Ev6bwtM1CVNKWK0vlw23VUDChJ+onouwxwyhKRxlhA+r7YY2CVlI5LYxeCdeK6KQM4+5wxqqpSbFQMfBOe4HEvZBlCSQCyfcOgSlEdixqhowS2EJCvY/Ug7AXziGknZ2D7zwra+0POAoLG324OYZ5DWlg98TWV7qwRg7zJB1/R0FehqblhqwaVXFvIHGwPiP+ZitDN/juBWJaN+GKdxvinkGvIQfBa/JRDcEH8QTGOnW8UmUowruIqAy9j7X8VbrIjO3Qfh0T/fQbggcriTLjk9PbDb4SvfrXs+qMQqY9iQjSFi4/HcQZD3eAjDobOrrUOAV+gJ60UeKkMIpRjqU5MdoVv5OxpnCCx0MrYsd7qtk066ZX79DUBH+6Me2dDAz4frekkoxLB5ozG2s7lolS//z+Ed/0uvm7ZnyYIhyGYMlx+mqAxltENdH4svnx3SikQejG0W1+OOB1d0pS+OyQpxFk12aQtX98hZBdqwn/6blGv6jMEJOV+W0nci8tUJK
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9308094-1171-4c66-4902-08dd87c2c828
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2025 08:41:20.7944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y+CiDpiOF5xHqVuos98MJTh1y6vcbRbut6f8x/fho3c5WZUG1SK40IiK34bSn+5FKnqjO5RH/oFfZJ/siE43NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6922

These patches cleans up the xfs mru code a bit and adds a cache for
keeping track of which zone an inode allocated data to last. Placing
file data in the same zone helps reduce write amplification.

Sending out as an RFC to get comments, specifically about the potential
mru lock contention when doing the lookup during allocation.

Can we do something better there?
I'll look into benchmarking the overhead, but any sugestions on how to
do this best would be helpful.

Christoph Hellwig (1):
  xfs: free the item in xfs_mru_cache_insert on failure

Hans Holmberg (1):
  xfs: add inode to zone caching for data placement

 fs/xfs/xfs_filestream.c |  15 ++----
 fs/xfs/xfs_mount.h      |   1 +
 fs/xfs/xfs_mru_cache.c  |  15 ++++--
 fs/xfs/xfs_zone_alloc.c | 109 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+), 14 deletions(-)

--=20
2.34.1
