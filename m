Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09EF1E9B06;
	Tue, 25 Mar 2025 09:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742893861; cv=fail; b=Ddu7VquJUX2fQ9GHsmEBqymLyZinsgNdkC9yV9WFOR530cfmtvC6pw9ZTZtg5KIeY89/bckjsURj1siwBRcVNE1JhEM5B2dTBHNTu3K0ZpDA2VIaRuX3Vb9OC8Zs+uTnONm9iMl6ysZPG+0KhxVhmLdYxSekRI0R8wG8MMtCqj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742893861; c=relaxed/simple;
	bh=3CiKhhY7y1fQxI69TonjZi1xGok0dDWMT5DvMXnOByU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hY8KSupODNqwlhrZoASFImCR/I9OvgSELMr8e9iL66keH0w37uhRdP01+v5gjPHWdRw57yYSJ1pEHkcHfh92Qpn1bnxtVcwGF7xttrE8WrksJx86KeHyQoItzct25FWMtyualCcE1R5XTDNt/gYwrYkp847db0qZ2twbPg8xz6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=mf482or3; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Whq50MxL; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mf482or3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Whq50MxL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1742893859; x=1774429859;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=3CiKhhY7y1fQxI69TonjZi1xGok0dDWMT5DvMXnOByU=;
  b=mf482or3Z1bXxDl9AGlK97p3YJ5L3U2T7Mb1S+Y5XQQIe/lVxBcNQFeL
   /uIWAruXXC2NCVKE9AyuA/2YVkh12nrZCMjg59PywOn1Wz02h0Z7psyAn
   eXgW5X89ZOhIOyU3+b0ZsD//gLR4iFMp63bGwo5wOtvOpfOBL135JOlmD
   mjYCy9gu08447ci3KUhf9YDaX/B9ENeSq4mTiYT1XcvvTAlC8MpTlk0N+
   Fewew3/DNc2V5Vhmj4uQw7+lTcF7KLfqOnpc5TcFqYMcJYBY4Y7JFd95I
   uTtshJUNFUQffEiBxpeSIfP5UU88PGXbaQ6vW5WMDEUY6HwfDiSyDO/By
   A==;
X-CSE-ConnectionGUID: qGcy6+Y0TGyJwMLzSXEMjA==
X-CSE-MsgGUID: bgumOX34S1WF5PIQgJAvTA==
X-IronPort-AV: E=Sophos;i="6.14,274,1736784000"; 
   d="scan'208";a="59856590"
Received: from mail-westcentralusazlp17011030.outbound.protection.outlook.com (HELO CY4PR02CU008.outbound.protection.outlook.com) ([40.93.6.30])
  by ob1.hgst.iphmx.com with ESMTP; 25 Mar 2025 17:10:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uTtjaNvhw8cMPQdhoxjX3bOufnUe3VQCi1RMel7+gULzflaf1Jee8t0Mlxd8T5VebVKHhd2R2hFdG1a9efV46mAxoSOEENje8jkBEq6k3msZL1Dz8nDhuQgWyk22lSb7dPKHkHvnMRCMl8xZSyTV1yjdaUZNouWKJXE+2RdpWd+xxEJGdL9qIucQcda2gqIepkIt/V5qMGYMTFVOsdI9FyqRWhFuPaNW1tzZle4kxgTPWg75M48dCcJJhSZY65WUagJ/Q+qsQxFbMJsGx7N734AJ8MOswTh5T/wn9rQ22sLOuiJyn6wrtV8uXo2RrJDIkooW6wDwy33K0NdA24UvdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5RkLKmZy9ToegkBxmeyKqKmZ4IjOFtqqinxCYAAMmc8=;
 b=IXthmz3uuRfOAt1IDIoYcmF9Bh7XaywWWIsPi5coL4+oWosNPpqCdXVfXxYKNCjuJtbf3eqhCD5UYl+mlv/PVL4+1xzF6dnNUPAgn5RjOejqXIVdRc3ByWu1v+ZO4F/F0re6PtqAlZG+xJ26+TZHt08AxIWFzD6T+jTHW3DeDYf0Vq76O8f5T/K2idZ6PNJZAgJzi9QBV3gZ64Gw7LRZTq2pUZIo/rm4CNKjF+Jf381VQhbDWC47IDwFkpZzKIgtqSPSZ8dnXvfQQTpQv5bU4S1hBNMQvYWQ//zUlig3Xa62trsjDeGPMkNQeOOApNMgqgx7I2uDCtr5BRYeKkfbWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5RkLKmZy9ToegkBxmeyKqKmZ4IjOFtqqinxCYAAMmc8=;
 b=Whq50MxLDo00EC22XmZgnR9AXZTzkJKnZccguLt4DFgGhvhH67uE5tbiBhPfo0haOR2TLTREb7DZfP5nHFTz/EWnRGiDFeTLc6SDe0PWKVD5bIaSui76HQs/K/UCMkkUg0JTToYZi7PBs5vSdUFi0KRlDwHGfC9KGou7jQNQ6w0=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CO1PR04MB9580.namprd04.prod.outlook.com (2603:10b6:303:26e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 09:10:50 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%7]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 09:10:50 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>
CC: hch <hch@lst.de>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH] xfs: add tunable threshold parameter for triggering zone GC
Thread-Topic: [PATCH] xfs: add tunable threshold parameter for triggering zone
 GC
Thread-Index: AQHbnWXN7wqBus3oD0yp1n74cUSC0Q==
Date: Tue, 25 Mar 2025 09:10:49 +0000
Message-ID: <20250325091007.24070-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CO1PR04MB9580:EE_
x-ms-office365-filtering-correlation-id: 6e8bcc3e-5cee-4834-be9a-08dd6b7cefcf
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?GholzI76L5HfGMi+qEYosP2Mbf3bgqiaLPYEvJZquAzGeVWAIroFILN/my?=
 =?iso-8859-1?Q?AlDQFZPxMy9TjXw5vv/h2eDvubz9twgAO6c9nLxK3CzjE87PVo63+ej2AM?=
 =?iso-8859-1?Q?Vz9ojZbpCFuLq03QN9FEZIO2KBDNZYojN2XhOMsUq+mO3n0J7aVitSoBq8?=
 =?iso-8859-1?Q?YyRwJyITYr/rpJIfp0SAIEEr7hC7rfhtVp+bU31u2oukZOhTTiRr9vZ1m5?=
 =?iso-8859-1?Q?sRfFwORMTCwuXqTv+zDguVuwOD4WrhcIftUurYCZZiP3Phb6/8JAuqX3oS?=
 =?iso-8859-1?Q?1dG/Kpey/DJ8ufkUYyPA4lnJN3SLXX4jGndr8OcOg/87DMcYQQfh3ZUYOd?=
 =?iso-8859-1?Q?nrz+hg24jfR0SfU2nGZZTyTrdrKdfZTC6s4OVKuElXEKd8cgR5RwZ6rf/S?=
 =?iso-8859-1?Q?kpmjYERgypCZ0Ssnkq60Ff2Qu0Sm2CwgUD8BKOMMCR2TJVjAwYvnxn3ysV?=
 =?iso-8859-1?Q?3G5VAFNBbR6Ee4JpBcQKL4+aSPSrM8x2V+0nGKBhVNOEyF4pVLhA92YIAa?=
 =?iso-8859-1?Q?VuLXOVmXlJwInvL+PJc3CQyLpsFm++2TW8xqdICZBnxQfUxj2WJAcQS8cM?=
 =?iso-8859-1?Q?tYwrgH9+MZ3dnAJ04P/YjAjb7X3S8ggOKKPel+Z5x1dgwZl/upqDNu3hH9?=
 =?iso-8859-1?Q?dgh8MjOV4H6mxSDPG9Q0U8AO1UcddtBfHxpw8I517iu9wmbtNSoW9/wPxz?=
 =?iso-8859-1?Q?hheIByOC+Ycv8/a63ffUs96lTXNNyAvn3d6s/WA7Vm7vHBKTJiz9H7w2Mj?=
 =?iso-8859-1?Q?269RtYVp+EeyauoBHUX+s7ejFk38JrdUyFvHbDlTZVConG7XbNAf2sZWur?=
 =?iso-8859-1?Q?/jYM/ASfnD1g2VKqMj13jf1dWbhSPcCPP8dBL7eqj5nFkKJMdD5ePK05br?=
 =?iso-8859-1?Q?AQis2lPqCdoj9fbM+iBn/M67F5RwjjMT4mTtIPIRgUitAD9u6t7ZfWHj18?=
 =?iso-8859-1?Q?F0yHVMKJv3Prtxq1/VsNxfutN82wkCLGxmzqawM4QaIxAqHwcP5a7GtnLT?=
 =?iso-8859-1?Q?IU2P3b5IthNOrC53emppkGZ0veSM8nJEfNtldGFExd4pBnlDAr5qPFa9H7?=
 =?iso-8859-1?Q?Db2L8EfnJhiutrBGVMqQsRCeA1zGzRl5Funib6ZfmkDboQNe+DlvK/r+lT?=
 =?iso-8859-1?Q?Vc0VWzIQNUqml00Annu4RH2LgLmni23Ye0adopn61ZSqnvyBGrLlnhJ9PL?=
 =?iso-8859-1?Q?9uOVTugqgQUTtdapoUHjlYkjG6YMFE1C3pnNNWlWEWVcaW1OfWF6oMhggj?=
 =?iso-8859-1?Q?LrVeVF+FT+xqiaReFUd8pI0vJ+rjaekhQoQpmZgB4IkEqjDJPX2VwMaXvZ?=
 =?iso-8859-1?Q?h2oWR4Va9rayM6j/pGdLmR9KU/TbbocL1EZlEYznHel+2M+uDnLRliuWjx?=
 =?iso-8859-1?Q?praLEhgTU0ELV5zUY5A3hBuR+l7BMinkY3Ryg1LC8NSJsqws2fUkbGEx+h?=
 =?iso-8859-1?Q?IK9MKw0WkynzkeRMSeU6zEIbBIcoLAtymDnHSA=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?H+LP9jLdNajsv7P6cjArqQ4pGR42iSx405fSusHMGV9sGRzB4/k7t/crxM?=
 =?iso-8859-1?Q?+ywd4yom4zbASG0o32GFY4vv+D7JNuMwMfIfNyLp8nrF/ePAcMXr1nV5G8?=
 =?iso-8859-1?Q?ij44KRJ25IQTU9rdjluZPZSN4WWz6eLb8F251+EpY7TxGEJpfdh0HVzHJi?=
 =?iso-8859-1?Q?Ly448kAu3I/BqpSLOxOx3Q1YJwwTraU6J6damGTKsBUgnP6YjUCO11ucaA?=
 =?iso-8859-1?Q?lgUkr+StXyp8fn1vr/Wgx02IwC8OA9vJo7ox5qJ+qYjFOXipDl2/7FnmQq?=
 =?iso-8859-1?Q?IXNtf+WrhdR1Fs72e3bxTqixVWC57DdvHM4mQR5elwRzfdLAIAeiRfgSGm?=
 =?iso-8859-1?Q?oGhyzA2LEX8bMDhoab6DRvMkyUx4McpwaRS7mwQpXn37a6QHc18xBOn8e9?=
 =?iso-8859-1?Q?5RJlm0IXsuU83k9AnP3iIjdYm4HjyD1k2F22B9uCUwa3sOmw8xPsXVARR+?=
 =?iso-8859-1?Q?piXKGTScxMixBnHEWmqKIdoD8fE3JdjfBFUnSaJQ0ymAPbwXJhj3347JAK?=
 =?iso-8859-1?Q?NJSF7FnzirPyDo9IPGRrLgXSV9X3cE7S5vuZrHBQxL+WW4ivr087l+bbX8?=
 =?iso-8859-1?Q?H5NT2Q0Bh5j/hFsv2mcyfnTcHpDVGhNLEyWxinNP99O2gMPeMYgZHoKYKC?=
 =?iso-8859-1?Q?mKjHRNqm3xmiJL80rfPQNXgGJPNUaPponbsd9Kc6fIswFnRyCTfTvQQoT5?=
 =?iso-8859-1?Q?eLIgL5rPzbJmgUUFMx1l8vCexf1fCPMKhnS2cweo7+PNUUc9KlUqb8L0oL?=
 =?iso-8859-1?Q?GRSimzPk9aahwWxWWsv1zK25NqpRFdJPivZu5qVgf9qibHP3BcBvekvQlp?=
 =?iso-8859-1?Q?QIrhTUgE0hDOgHNtNTNUKJuEj68XXrd9U1F9XfHKSMr82VEj4pWERdJ/Vh?=
 =?iso-8859-1?Q?IL49eQav/WSoUQ5qCN0NIqo4x+pVMKiAgZ2RKwC1ZfhT9nQ0nKVZeZ1Iyj?=
 =?iso-8859-1?Q?5JyszQPEJ5IaceRItwBDEvBjn60v4j7cwKXP1FnObupX78Cy8D41gZEXPD?=
 =?iso-8859-1?Q?0nfjS1hRDpDkd76p5opuBD66kKGOOUk6Nvr1K714wKchzI6aaMg4NEUAL5?=
 =?iso-8859-1?Q?2/MFjHNVQzYs39I1ANnznP/daniGQSj/qQITlrAiMsTofM9lOdDGUMpmoU?=
 =?iso-8859-1?Q?DHJLMuxbDhdd9AHEg2fVM8+D6EVLq/okA370sO/gH2PpU66TzWP+K5K6al?=
 =?iso-8859-1?Q?dw2hdc0f91lwRQGFyvfXPyCS99+N70T3v46QSDxL9PSdldyv8ndcIfZuVm?=
 =?iso-8859-1?Q?SG3DDWd92WuG4THaaz08yG649mCXTMyqhHGDvFBKI/TtMwvqJ17JT15ARU?=
 =?iso-8859-1?Q?3mEe6O/hyFyF0XDptGk9VOwYwuzkgAMBcD5MGZMP1iJHy+tVpa0JbhX3PY?=
 =?iso-8859-1?Q?327IeDzIek71d1sh+BuwjJIuIv/T0FkKiE8nplHMHdZcUUnuxazxycCL3N?=
 =?iso-8859-1?Q?+r6xKKP+F1Lkiro8zo4NR9MMNbzkFe5tEjBhrG2Op6ClBmlKYvwbb/lRKM?=
 =?iso-8859-1?Q?PB5qzkoPdiRTu3Yy4o/46fAslCEfqjlAixV2r1rMI/vr8i1/XOKbFhywoy?=
 =?iso-8859-1?Q?j5XOGh+hK6gR9xmsCb2f4WFHcMzzzaJgmMqKtSi6YVT7pbgj6VGm2XQAtC?=
 =?iso-8859-1?Q?w7hWpb8rC6nScDyVHkxSrU1JAKSa/6ZkM0bhjHavsztpEdojJuQwSoyg?=
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
	p3zgpCXJgeEmNSK+5C5yg69pro6QKyQOS2eYRZnWBbSbkvs0MGMj6FTTMVYgZ8wND/RUmIZI+yL9+6/sps7XR2r4lJQBfT6H7hL7Zy6o3T7/4qBocwI2M4Ysm0ND1nFahR+gsL22lYiZV2kwx2cC9Tg4W8hPUmbmj2WQy9WcmsxHshWkXtRT8/8gmktU3sr8BjdeJ0shhAeEynNkN4F1U0FspLgdx6jIax9LkwD/d/82ltmhJRZEOQhpqMNAJT/iLxxelNsHjFzpoqyoLVXpz8NHuqsvBE5cvLH/yvhcVcTZGGxxo21KtfDZenUQNLYA0UJBQqa8VpzOSs9GFInWVFCXp/rBMS77u+OxfVv7mxPma7WtptgiaIpfIhQO0FqnxV3MI9xNrVZiHDMZfky4L1H5/lflfgrQozEJoRZCA9ioRe2+FbUNd484v7YfbaZ26vCcXVBhwtvQc0WBBJ5LwBfoWfDEr4RpXUYzO4w/ILARvgCICadRFdeYerr0tHxhBX4LIxaXBI981bYlRjxgWFgtFDnmunPfQ4l42Qpl8soeL8geCcl9/13uBgQ7CkRNacGmSkzl6w+NBLpzU8DzX0wNwaBS/bhhhxWZ5Zb3E4U/R0pwOzkZ74xhdUgDDoVM
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8bcc3e-5cee-4834-be9a-08dd6b7cefcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2025 09:10:49.9658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bpUw+3bFjLVkdnw44D541f8QQe9KdmZ8P5GkuzJ2SdD8lHXdLyBMRWmYgT0PYgL42rqVP58geuWw8W06Ms9gIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB9580

Presently we start garbage collection late - when we start running
out of free zones to backfill max_open_zones. This is a reasonable
default as it minimizes write amplification. The longer we wait,
the more blocks are invalidated and reclaim cost less in terms
of blocks to relocate.

Starting this late however introduces a risk of GC being outcompeted
by user writes. If GC can't keep up, user writes will be forced to
wait for free zones with high tail latencies as a result.

This is not a problem under normal circumstances, but if fragmentation
is bad and user write pressure is high (multiple full-throttle
writers) we will "bottom out" of free zones.

To mitigate this, introduce a zonegc_low_space tunable that lets the
user specify a percentage of how much of the unused space that GC
should keep available for writing. A high value will reclaim more of
the space occupied by unused blocks, creating a larger buffer against
write bursts.

This comes at a cost as write amplification is increased. To
illustrate this using a sample workload, setting zonegc_low_space to
60% avoids high (500ms) max latencies while increasing write
amplification by 15%.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
Changes delta RFC:
- Turned the mount option into a sysfs tunable (as Dave suggested)
- Used mult_frac to avoid overflows (thanks Dave)
- Added xfs admin-guide documentation, including max_open_zones
- Documented the default value and set it explicitly
- Link to RFC: https://lore.kernel.org/all/20250319081818.6406-1-hans.holmb=
erg@wdc.com/T/

I just realized that the max_open_zones *mount option* is not documented
in the admin guide, but that should probably be added as a separate patch.

 Documentation/admin-guide/xfs.rst | 21 ++++++++++++++++++++
 fs/xfs/xfs_mount.h                |  1 +
 fs/xfs/xfs_sysfs.c                | 32 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_zone_alloc.c           |  7 +++++++
 fs/xfs/xfs_zone_gc.c              | 16 ++++++++++++++--
 5 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/=
xfs.rst
index b67772cf36d6..20746e795477 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -542,3 +542,24 @@ The interesting knobs for XFS workqueues are as follow=
s:
   nice           Relative priority of scheduling the threads.  These are t=
he
                  same nice levels that can be applied to userspace process=
es.
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Zoned Filesystems
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+For zoned file systems, the following attributes are exposed in:
+
+ /sys/fs/xfs/<dev>/zoned/
+
+ max_open_zones                 (Min:  1  Default:  Varies  Max:  UINTMAX)
+        This read-only attribute exposes the maximum number of open zones
+        available for data placement. The value is determined at mount tim=
e and
+        is limited by the capabilities of the backing zoned device, file s=
ystem
+        size and the max_open_zones mount option.
+
+ zonegc_low_space               (Min:  0  Default:  0  Max:  100)
+        Define a percentage for how much of the unused space that GC shoul=
d keep
+        available for writing. A high value will reclaim more of the space
+        occupied by unused blocks, creating a larger buffer against write
+        bursts at the cost of increased write amplification.  Regardless
+        of this value, garbage collection will always aim to free a minimu=
m
+        amount of blocks to keep max_open_zones open for data placement pu=
rposes.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 799b84220ebb..e5192c12e7ac 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -229,6 +229,7 @@ typedef struct xfs_mount {
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	bool			m_update_sb;	/* sb needs update in mount */
 	unsigned int		m_max_open_zones;
+	unsigned int		m_zonegc_low_space;
=20
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index b0857e3c1270..40bfe0a7790e 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -718,8 +718,40 @@ max_open_zones_show(
 }
 XFS_SYSFS_ATTR_RO(max_open_zones);
=20
+static ssize_t
+zonegc_low_space_store(
+	struct kobject		*kobj,
+	const char		*buf,
+	size_t			count)
+{
+	int			ret;
+	unsigned int		val;
+
+	ret =3D kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val > 100)
+		return -EINVAL;
+
+	zoned_to_mp(kobj)->m_zonegc_low_space =3D val;
+
+	return count;
+}
+
+static ssize_t
+zonegc_low_space_show(
+	struct kobject		*kobj,
+	char			*buf)
+{
+	return sysfs_emit(buf, "%u\n",
+			zoned_to_mp(kobj)->m_zonegc_low_space);
+}
+XFS_SYSFS_ATTR_RW(zonegc_low_space);
+
 static struct attribute *xfs_zoned_attrs[] =3D {
 	ATTR_LIST(max_open_zones),
+	ATTR_LIST(zonegc_low_space),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_zoned);
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 734b73470ef9..31c2803bc8c9 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1195,6 +1195,13 @@ xfs_mount_zones(
 	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
 			iz.available + iz.reclaimable);
=20
+	/*
+	 * The user may configure GC to free up a percentage of unused blocks.
+	 * By default this is 0. GC will always trigger at the minimum level
+	 * for keeping max_open_zones available for data placement.
+	 */
+	mp->m_zonegc_low_space =3D 0;
+
 	error =3D xfs_zone_gc_mount(mp);
 	if (error)
 		goto out_free_zone_info;
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index a4abaac0fbc5..dd706635e3c1 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -162,18 +162,30 @@ struct xfs_zone_gc_data {
=20
 /*
  * We aim to keep enough zones free in stock to fully use the open zone li=
mit
- * for data placement purposes.
+ * for data placement purposes. Additionally, the m_zonegc_low_space tunab=
le
+ * can be set to make sure a fraction of the unused blocks are available f=
or
+ * writing.
  */
 bool
 xfs_zoned_need_gc(
 	struct xfs_mount	*mp)
 {
+	s64			available, free;
+
 	if (!xfs_group_marked(mp, XG_TYPE_RTG, XFS_RTG_RECLAIMABLE))
 		return false;
-	if (xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE) <
+
+	available =3D xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
+
+	if (available <
 	    mp->m_groups[XG_TYPE_RTG].blocks *
 	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
 		return true;
+
+	free =3D xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
+	if (available < mult_frac(free, mp->m_zonegc_low_space, 100))
+		return true;
+
 	return false;
 }
=20
--=20
2.34.1
