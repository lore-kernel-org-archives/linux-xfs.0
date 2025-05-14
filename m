Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D616D270ECD;
	Wed, 14 May 2025 10:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747219851; cv=fail; b=c9k2LoCF0CoTnI5LC2syDx+PkVlq5MpWrMMacRvmUyGH9gdILvko5pL7UtILw/zFmz1R1RLUTmESM+p/Y3bKmoO+oyhU0Muf7vFNveEbqvMJjEBwFpMwZgKfR4nmbk2tgjX3Z8Kayw9xQ1qzOaV5wuQL/Qs+YH0fcisvdwYtr1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747219851; c=relaxed/simple;
	bh=ACUESYWWeHR0r2L93H5wY5mkmpPc+210GNYKC9mYfpg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CxZ3W/5XK1IHGXeOSIjum3St/U9tvK0XanDRHO4BJ0Yk/T4DR+T/9DXWuncKYfjRZvCRYbve9F54zkZ0gvSZL4jya0NUqDRiWsl/S5hOsMPE/k/EHvZeGBvKDYWy7bqzvm87tJI6hIVZB5tjtIEodqEIY7QAOrXNo0ySf9/bV50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kVSmFK3e; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=E9K6skXV; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kVSmFK3e";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="E9K6skXV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1747219850; x=1778755850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ACUESYWWeHR0r2L93H5wY5mkmpPc+210GNYKC9mYfpg=;
  b=kVSmFK3eLmm+0yLm0hAbL5CUJlwTB/LHGXJj4BYdx5KwmlNLA6XwMMcG
   OBfjT+RfUZLAzJOq56abwm0tJNG+oIkSXjxbM0v/4RkKONjDGnDKi4c09
   4SY8Lu324u4sN+jqno+2EZcpb6PxH0woON4e5S8LvjmGhuQvVjt46cC+Y
   TWJASwGE5CbXfXMgnaoExcBixJEApAlpsCWg/R+DxEAIrLdJf0M3UOE7Q
   szOND6oGcG3kxXpwwl2aUeKQltlZYsLWhGApqDoTliL8vB9Xk8JHvcx7l
   hJ3aSZvW5v5fJMGFU/8mcftjfu4tC77hAbhC5OCfB1hgYlexaNEatnB7s
   g==;
X-CSE-ConnectionGUID: KQ3rs/M4RxygvLmm7czzAw==
X-CSE-MsgGUID: Ri5CGzQjTo2JVh0G60gxqA==
X-IronPort-AV: E=Sophos;i="6.15,288,1739808000"; 
   d="scan'208";a="81835575"
Received: from mail-centralusazlp17010006.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([40.93.13.6])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2025 18:50:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t3g5LGLJxC4A2QKyXrgaWADWsrQcYq+SlYkVVfdju2CLq/Mlz3UxWRw+hqSUkVNYrxjziwM4qzTbrTK64U3nrWYlb9xZ7xDtBrWh7ZzvEoVQOM1NYwlQncOpe9netSKnTPjCYotBKsVNYXon+k3PKauodJiYuNQoydgcArU/TQ0/iP0hsipECFGow3OOW04KxB0uWXCRwTg30zWCxpKGPH2ovzjW9GDfSLXT1oF7IUw8s0n50ic11hhOMydD5ytTIEbok1qArD5J7/MkZcF4tt/5v/s3hEc05UAB/U9XbsjmlUssBcbWDTMBSmnb/FFinX8jTE0bL0pYdRoACxSw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9hj0LWCJvA3D/EqFLQquEtQTD8QV/K4HR6YGhne1zY=;
 b=VbYfWfV8CWceyeGkKWBEDEgaghpa1JdrWJLhVIaoshRPHqTIm0wjEwUkXhlW/nWV+jx+oaTfp7E2vywDhJDm5DjYqOqtDK4gR6aTtq9iZnPPxXx/2Rtl0Z1jvtIihjKWEoXHzkPkjJmnHapS/nyAhq04iUHoliGEUgeWzDGWFO44gEbzv6j+/EUqOFxMFYkxioLpY34umMj3YIGq0CX8o7tcx0vzttZhc603W0MK7a2eQzSOErODiJduYdLMKW7Ycu+v6qWn5W03JFEQtaG+YxqTmyspnhQt7WjmGHnHKJ2Y2ZJW8VxbuU+DAOwYzMeVRltosb+9/3v+iPRhG3qeuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9hj0LWCJvA3D/EqFLQquEtQTD8QV/K4HR6YGhne1zY=;
 b=E9K6skXVfealZqDm8LOYZjSf72gaduWU8+hWcwtGtf4d9vXhCZthNyZ62AlF1ypVV91qoLp6tTF61Sw4wLaQFMNl/uvRSXDhiLfmLhAUvLgD/CLT+ER8GSgSX6Fvu4QZV2ChSqyujt8qC2STWbzbjdkd4OFSL5hUEEm2Qp6suXo=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by MN2PR04MB7023.namprd04.prod.outlook.com (2603:10b6:208:1e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 10:50:39 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%3]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 10:50:37 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>
Subject: [PATCH 2/2] xfs: add inode to zone caching for data placement
Thread-Topic: [PATCH 2/2] xfs: add inode to zone caching for data placement
Thread-Index: AQHbxL4HboL/w4BaWkW80EG4DF1k0g==
Date: Wed, 14 May 2025 10:50:37 +0000
Message-ID: <20250514104937.15380-3-hans.holmberg@wdc.com>
References: <20250514104937.15380-1-hans.holmberg@wdc.com>
In-Reply-To: <20250514104937.15380-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|MN2PR04MB7023:EE_
x-ms-office365-filtering-correlation-id: 895cbd33-9a61-404d-8ed2-08dd92d5298b
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?RcfuV78Qi4q4oEiKYZjzAihih5DbaifVAwmgrp+LvIfkYLdKz8k9HeZBEK?=
 =?iso-8859-1?Q?MrYVkc2EieLR9ST5jXjoAR2hcGxJGQIXFDoJxZfzlup2fo24SW2/6pBmgO?=
 =?iso-8859-1?Q?mOcsrHOUpwua67kyhuguwP9TuW31ozGjiZi7k77RfMsVHryZRB1b5jdNzR?=
 =?iso-8859-1?Q?HLHcu9JIfl5fXMQ2wYbGOa4azlqlqKva4lj2Hkyebht6zyZaTzYo+yeOMp?=
 =?iso-8859-1?Q?0cARyq7yzWmQbnO/dowXwyM6ddYqg9WXg1OnehnfNBiUkS52mXbFdfO3Hp?=
 =?iso-8859-1?Q?eG5k8fu3KQA1eWGdG+DC9nCedk1bSncPTjH+kUKpy4MKeYh8EBTGqHjtoS?=
 =?iso-8859-1?Q?xswKu8/etZQtXMZQT01c4VZFudze9LxfyaJl5TPA6JGK6mEw2A4oH0NMgg?=
 =?iso-8859-1?Q?Iz2cIsDN/vITgjxZv1SHfKIVjFJZkbsi+7SSiUv3jLFVeoOCXwj7UUBC4t?=
 =?iso-8859-1?Q?kwZt6mLREsVBlCBwgg/87r4z2MaYpeYY44cjTdgs1ncLfYwQCYppMM1wVx?=
 =?iso-8859-1?Q?UAF53VI9RP5e/bGcGPo3lZwhufRG7iipeHc8KgzkcyJN5lLkM5fd5L752w?=
 =?iso-8859-1?Q?LDdswKeAyDwanZwCtxSso0xhDjjNhRWxj49nmNGEQbDqQxa++i/3ER+usc?=
 =?iso-8859-1?Q?bPF/tw2GDSRjdYcT8nqZ81p9giaqZj4qdDnxo2DTfwQlGnjwcLGJs4LYOD?=
 =?iso-8859-1?Q?EVvVPP1mXr80flnHO9cZap2WltqafPXevEgeQdKHj78ps6okO2cjKEwwJu?=
 =?iso-8859-1?Q?zxnK0+iNtZIffnXNWqkrXreTWG0mv2krvf8tjwIRI8rEnf/SYjLtdT7dLv?=
 =?iso-8859-1?Q?R2lYd6lYXf4XoqQyTVhxJcNYIjLxH28JfW51rFHBTKfsL4JzdlTnLSGKTP?=
 =?iso-8859-1?Q?GeXdYBKIMazkYULnlHH5ov0bWnABMkooj0W2Iy3oNDvQPvYAR5ORDkmeJ/?=
 =?iso-8859-1?Q?Cdym42CpCUzJuOuQysHbv/5+7k4EXb6Y9tX/PrXi8vjBGcRg2FcWW43q76?=
 =?iso-8859-1?Q?T76eupmxPuXCIPOC9Ij9uY2X2FxuOMcG5xQCETRtwFxO7J5qgVN6GwQCCl?=
 =?iso-8859-1?Q?qXZYfxOevRFJKbLKDttJw+aI1xaR/f2P4JxSuUgy1DoeHxF2LEviO+KUXk?=
 =?iso-8859-1?Q?YMj6TD5Kyy2HE1Yq5E+FKXAJq9rYnOZOGW6OKdHGiNduIv0cYcuBfpCAeC?=
 =?iso-8859-1?Q?+Xrhcr3BDbRIYut5Au/sBYndTcYiP7PynO7V2gcp9SOVOpFLWiLsmIZtmN?=
 =?iso-8859-1?Q?HTAEtU4v6BuPs2DwOxAZyYNDfYYUYJqpTeii3ZPGbKvBChhftRMNQk8Ryu?=
 =?iso-8859-1?Q?ynH/LY+5p7nL2HMNP3dkEAIu36x9lfxCARN8xxlKDUj9hsu01xhQPwkG1y?=
 =?iso-8859-1?Q?zg343ne+k2FniTHwT/STlTnRNDOsPO3VfKQTqZn1VWRM1QpJQAApyFYxUw?=
 =?iso-8859-1?Q?bVwUPw/IeZbW77oXzSGMfcgZTQj99+UtFwh8GRTo6DmDy2bgsY8u0UXYuc?=
 =?iso-8859-1?Q?vUf1ktC9Rmwu637HcAgHaRMrm+KpdoFMgyYVfYYmKPug=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?95nSoR0SCoO7Kbkl90SwhUp4pEDjg/1TgajCAoHNyyyCLb6ibwjnCdVcsE?=
 =?iso-8859-1?Q?lLuy8t3viTJW5KysGdotZVz3JJ9u/HSHYGdmqIrrekWq0u9hp52ez8shmJ?=
 =?iso-8859-1?Q?a+33W4LG9pr8mDWVvha+5htSzRVElUP2Zdis6QgoknsSIQJneWBrM/R4FV?=
 =?iso-8859-1?Q?IgdC4CPKogY4d1KvrBj7daDhasejUJNSM5gucePqcgEfb6UkCmOC4TBvow?=
 =?iso-8859-1?Q?5orWdJJHtiHt+6uDXmCSYOwdiDK4srgV4nQGq8rnbXG01kIyJkjMbbhepX?=
 =?iso-8859-1?Q?fzfrjG065RGchsZb11faJBzmQKqaKgY+I1DSkW8FM2SLPh1nSSm1h8TnU3?=
 =?iso-8859-1?Q?cx6TL/x/S4y5Xelr3Zu1kuMOfd1jgWzsyjNWa0xqyhdzCEIyPsLie0kOsg?=
 =?iso-8859-1?Q?sEKJTRjQpiGlggRsG+oAI1fETXh2XL9ZDuZozYOR/EJyfjde4p8UADZa0V?=
 =?iso-8859-1?Q?n225cWFuC/KkrgJ75ENf55RHDV0Vdt1/Px1FUM9OZXu0PKKElxJbalU7K/?=
 =?iso-8859-1?Q?SGm2fukQUHQ3s2RAtf8M1oMJRqj0bZ/waAbVlMRByHf8Aub7wjxkHNoMer?=
 =?iso-8859-1?Q?w+r7YCbt/cuH5Gl/X8V+GkVeftGlvvGv0oYVvIlg95ncWjEcC040Nn2WdR?=
 =?iso-8859-1?Q?0FzvNOzcJDT8XtxWKm9mhYreVcO18WypGNHQS/WiPabuZEijCYBtt/NPxj?=
 =?iso-8859-1?Q?QL0C8DlPzvKwsVNtzlrM2/Wp8zohSaaXwZ08bi6duc//7F6239Xx3RgYLW?=
 =?iso-8859-1?Q?GuhHGc9pn3npu+4iwPKHJCym+N+9qg96800z6riIWQY85Sb57nE4tdQx2k?=
 =?iso-8859-1?Q?ZNhooc3xmDQbbMMMF5mhs2xOnAPsU23EKsQcLiGV6uVpIoTqYnBtBmQTqg?=
 =?iso-8859-1?Q?Yj9LUIzfCNcWoddiRWCMvBPnwQTcQ9T5BMNQLSUoFviwjS4CVmXSfA4D6p?=
 =?iso-8859-1?Q?Jj+z9R43C2kD4Z3hwA/URpS7gOCWkJbu+bcw7uxF+uj5qjU0oYgGP6xuEw?=
 =?iso-8859-1?Q?U5/rRMQc4gsV2b8dOAraLmsg5vKEOKQQzM2pBakP3Rgy1VR/SDZp4P09XA?=
 =?iso-8859-1?Q?hPBVF6s/PSMqZalhCo6bhJp1IRE3dWm3hbsS1LvPkY7gheqQBQYH9P7b/g?=
 =?iso-8859-1?Q?MquU/hCZPS/hdUXM/HnDDfD4fwGdRZKbsshoKi2IM13kPsT9s6rRVjzjXC?=
 =?iso-8859-1?Q?7xVqJb+BiAOBLlvRfKEHLg+HfFR86ZOsll7W0VzyjGPt7CByiBld6WLQO2?=
 =?iso-8859-1?Q?8KLDknXHGkdcUOqdd1ZcETcELVKO6stMS+7zzLX00zqcH+9eLji9m4Od2t?=
 =?iso-8859-1?Q?mQ2HgDpcSw4XlVAAWuRI8R47gYZi96Y8uysWc3oJT1Q0PgeIG6893V0PFn?=
 =?iso-8859-1?Q?G7/eA0uSCqfvIGUq4KwlFLgqNVFN4mfliY9GN2BRINlZS2vbQfp5N5iDDI?=
 =?iso-8859-1?Q?z8/sUqZEhx4rURFHIsq5ah9rsdP5nhAf0vEvCAfv7GI1u2xDKBviOvdp+r?=
 =?iso-8859-1?Q?eztdjrrsE31LQPCU6l7lqeEtaYncbDnTAhQiy8PBCiLe0iRNDdj9aD6y2P?=
 =?iso-8859-1?Q?2CiaTPkTt/cWL+BQwNGH/+6qVMiZH9VDoeEBuL/+KN/mkEAYvU/4nWyU0v?=
 =?iso-8859-1?Q?FnSK6qM++sxiCpimLH828fIjKhdoeza2KRhKV+BP1WziSj4wjn7vbejQ?=
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
	ebdRSfI24B+BIQLHOvGLDP0qGT6WXjn4Rzdw2mW/6tZ8ujV1QZO2uOLxkxs/8Li+wtI3MXOkzl5z9KbD4+vqM6eWqVE43FQSiZ9HBatfFGmBO6rS5Ak9ZsR+dlDxrtKLmgshzjdb4g25H6vIRWb97T2hgX8V09Kd5+oZVpVGTQ5ud+VqpjUl2GZTXKb/z7FPjZ1lMv4Q2p2USQMisdI+qIe4RFj5LvecPO8MXStWs72hpfrOfsibQatYxQe2siBmVp1RDqO/VCZ1WYSP8AvCDqxMU/uAuniXGOIRYyds86XEWkOcCAzo0fdGQ6CbH/AtSFfMxXkZOCr2Ahfwnvh//w4AbHjL63r8Soa2Gxjbq+jYA8jWVtgK2r2+mRlEVhe2UZv9YfJs36RzDsAP83/WmdhGNxpid4LAMmaU8eKkVj3TH6jP6f0HzVONpvXdLdNDtOpn4Ofw9hCleD/RDBbZfVUcj/21UqQxF8+lEx+aJHbHOoiutKJNQrZaTV9NJNnNXGGRD1k+HDoqY4a94Gt1eAU0kD4kHyBjIY0CgE6MPrfquc6BQsz6I4HSZV3brgjIjA77uaVN9vYsv2DY0/j5XMOz1OTQVvGZLdHt8uKmJyi7TYF6JICOlJf99H2Cz9Zq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895cbd33-9a61-404d-8ed2-08dd92d5298b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 10:50:37.8803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 37U/OyaPABxn2GZZuQaqxbewgGdYDz9k+Q4xregItmSmiTuUUDEqyNXsNn5W1iGKX9yGWgzKv5xb1d9/F/F63A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7023

Placing data from the same file in the same zone is a great heuristic
for reducing write amplification and we do this already - but only
for sequential writes.

To support placing data in the same way for random writes, reuse the
xfs mru cache to map inodes to open zones on first write. If a mapping
is present, use the open zone for data placement for this file until
the zone is full.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_mount.h      |   1 +
 fs/xfs/xfs_zone_alloc.c | 109 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e5192c12e7ac..f90c0a16766f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -230,6 +230,7 @@ typedef struct xfs_mount {
 	bool			m_update_sb;	/* sb needs update in mount */
 	unsigned int		m_max_open_zones;
 	unsigned int		m_zonegc_low_space;
+	struct xfs_mru_cache	*m_zone_cache;  /* Inode to open zone cache */
=20
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index d509e49b2aaa..80add26c0111 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -24,6 +24,7 @@
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
 #include "xfs_trace.h"
+#include "xfs_mru_cache.h"
=20
 void
 xfs_open_zone_put(
@@ -796,6 +797,100 @@ xfs_submit_zoned_bio(
 	submit_bio(&ioend->io_bio);
 }
=20
+/*
+ * Cache the last zone written to for an inode so that it is considered fi=
rst
+ * for subsequent writes.
+ */
+struct xfs_zone_cache_item {
+	struct xfs_mru_cache_elem	mru;
+	struct xfs_open_zone		*oz;
+};
+
+static inline struct xfs_zone_cache_item *
+xfs_zone_cache_item(struct xfs_mru_cache_elem *mru)
+{
+	return container_of(mru, struct xfs_zone_cache_item, mru);
+}
+
+static void
+xfs_zone_cache_free_func(
+	void				*data,
+	struct xfs_mru_cache_elem	*mru)
+{
+	struct xfs_zone_cache_item	*item =3D xfs_zone_cache_item(mru);
+
+	xfs_open_zone_put(item->oz);
+	kfree(item);
+}
+
+/*
+ * Check if we have a cached last open zone available for the inode and
+ * if yes return a reference to it.
+ */
+static struct xfs_open_zone *
+xfs_cached_zone(
+	struct xfs_mount		*mp,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mru_cache_elem	*mru;
+	struct xfs_open_zone		*oz;
+
+	mru =3D xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
+	if (!mru)
+		return NULL;
+	oz =3D xfs_zone_cache_item(mru)->oz;
+	if (oz) {
+		/*
+		 * GC only steals open zones at mount time, so no GC zones
+		 * should end up in the cache.
+		 */
+		ASSERT(!oz->oz_is_gc);
+		ASSERT(atomic_read(&oz->oz_ref) > 0);
+		atomic_inc(&oz->oz_ref);
+	}
+	xfs_mru_cache_done(mp->m_zone_cache);
+	return oz;
+}
+
+/*
+ * Update the last used zone cache for a given inode.
+ *
+ * The caller must have a reference on the open zone.
+ */
+static void
+xfs_zone_cache_create_association(
+	struct xfs_inode		*ip,
+	struct xfs_open_zone		*oz)
+{
+	struct xfs_mount		*mp =3D ip->i_mount;
+	struct xfs_zone_cache_item	*item =3D NULL;
+	struct xfs_mru_cache_elem	*mru;
+
+	ASSERT(atomic_read(&oz->oz_ref) > 0);
+	atomic_inc(&oz->oz_ref);
+
+	mru =3D xfs_mru_cache_lookup(mp->m_zone_cache, ip->i_ino);
+	if (mru) {
+		/*
+		 * If we have an association already, update it to point to the
+		 * new zone.
+		 */
+		item =3D xfs_zone_cache_item(mru);
+		xfs_open_zone_put(item->oz);
+		item->oz =3D oz;
+		xfs_mru_cache_done(mp->m_zone_cache);
+		return;
+	}
+
+	item =3D kmalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		xfs_open_zone_put(oz);
+		return;
+	}
+	item->oz =3D oz;
+	xfs_mru_cache_insert(mp->m_zone_cache, ip->i_ino, &item->mru);
+}
+
 void
 xfs_zone_alloc_and_submit(
 	struct iomap_ioend	*ioend,
@@ -819,11 +914,16 @@ xfs_zone_alloc_and_submit(
 	 */
 	if (!*oz && ioend->io_offset)
 		*oz =3D xfs_last_used_zone(ioend);
+	if (!*oz)
+		*oz =3D xfs_cached_zone(mp, ip);
+
 	if (!*oz) {
 select_zone:
 		*oz =3D xfs_select_zone(mp, write_hint, pack_tight);
 		if (!*oz)
 			goto out_error;
+
+		xfs_zone_cache_create_association(ip, *oz);
 	}
=20
 	alloc_len =3D xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size)=
,
@@ -1211,6 +1311,14 @@ xfs_mount_zones(
 	error =3D xfs_zone_gc_mount(mp);
 	if (error)
 		goto out_free_zone_info;
+
+	/*
+	 * Set up a mru cache to track inode to open zone for data placement
+	 * purposes. The magic values for group count and life time is the
+	 * same as the defaults for file streams, which seems sane enough.
+	 */
+	xfs_mru_cache_create(&mp->m_zone_cache, mp,
+			5000, 10, xfs_zone_cache_free_func);
 	return 0;
=20
 out_free_zone_info:
@@ -1224,4 +1332,5 @@ xfs_unmount_zones(
 {
 	xfs_zone_gc_unmount(mp);
 	xfs_free_zone_info(mp->m_zone_info);
+	xfs_mru_cache_destroy(mp->m_zone_cache);
 }
--=20
2.34.1
