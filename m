Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBA23101CD
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 12:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762346241; cv=fail; b=FbvYNOChSKqhqYkPLdvsF3GeE1O+qr/DGOJV0Zd6xbX9S5hK+LWLV69BiDFSTDy9qKPIJbHM/elvE3OJcSqFoc0LFn4oYOk6i5IGYrznvfB2VHDY8Wk17/pSbK2QJuceSSlZrcy5W4ewF4r/PAYy2UASQ+6gAhwQd0ngbvYCA6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762346241; c=relaxed/simple;
	bh=ps2vZZnMq93V9JxxVDACRTsMGWfbdIVGh14XW1kd6yk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=poFhbde/v4B6GYFKXiqV2h7iBkkvvHv4EVe9nsm197LzMLBClaF4FHnG16Vwn8tcZ4Cd7gLi3U4fGcbfFU9SB/BKHmERJHL59JsAFZG5DqjORdSq1H/y3nRf0zEeAfSn/6UxQvXLXNt0KfRFe1oAn6UuDgwF+DFJgnFuLDGmPNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=c0XC1xfq; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=N8YfBNPZ; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="c0XC1xfq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="N8YfBNPZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1762346240; x=1793882240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ps2vZZnMq93V9JxxVDACRTsMGWfbdIVGh14XW1kd6yk=;
  b=c0XC1xfq/aHXsxS/ydk9puwEGFkrhG5h8OI/5NdvEHFPP59AgyqScPDC
   t3EOWb5Q0CqS3hnzBKcT77/p+cu3gRmSIMwiPfmMC52YSOH6GbV/u9t/D
   MDRGTQTWt7dm3CiIwNF0VDTSrAWuDzLUz3AO2lOHvy7W435zRcnKQiEBO
   CQHBipKs4oV8Y4ugHg7zgW5VQ6Mbk6Mfsknw1XxF+EjEUsHyhfutGi+iS
   onMn64Y93kYtlGL4+nJ241r+1ojUwdeGxaJwhcKLD3fZhxl+JJEw79COF
   ZQyGKVKfM2/JfNCOhRSsRSWXgCHYbu34m9Rnco2W7YEb1VWSYrY+Vt6LC
   A==;
X-CSE-ConnectionGUID: x7YZR+z5REKl3L9JxYHtFA==
X-CSE-MsgGUID: QvOTYeKdS/W4X358COZxUQ==
X-IronPort-AV: E=Sophos;i="6.19,281,1754928000"; 
   d="scan'208";a="134180355"
Received: from mail-westus3azon11011026.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.26])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2025 20:37:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKN6h+MNqNVeWBGzGCYvGpU14xsYuBGPxcsuczNW9GjODHIz/AlRCeo17JlnkaycAO6NqcFeh8OJlZ4204dnSpzX7QtIaAWujM6D1FjMECB+JFkgo2ltrZ08EfL79aWSNw5ZKM2TP2FWSn7b2VtsDs7FTnkD/28SHCfZ9nrLPHpmLWgjCxJmeDR80vnRunqoxMBFOJtSqUx8/QQAYoqs4L9H1kcnB6UaeQ0fy9FEyfWUuQJIwCOE9VkkUN8Yfi9nnXAPW/lUOYpGiYLISgVDe0s8t7QH41/9/iE0WpEZyoGKlWg1yZUWEfqkw4WjWwY5y6lpWObtDtQzJd4iBsfRpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHwOMobriXsIBh9+DjTV81Vkxnqyw/1EsDnP8v1L294=;
 b=r0SAUdKoiiebbMsKwxF2b9LZHrrJsSGm90wSc9I2Uu3idtnMW0HSbifwGvywdrmWcPFZGQ56Duwc0zMtJnky4b1TnefZOd5BAnDtHFNSYHcZg8H9m0AANM62sRSmQRoUDnuy7PYRphHYrPvksudmhw4Vi9S+owgOJJcJtV7wW9e5trmj1X09suzhY5xWCy4vS3V9MWHjRwMuBDsaskEJ/MWCvyhTWyDzMUqY0pPgapvu7bXpbXtj/37ctLOZacffUQHsvbtCGwLbMKOnn3ZBxnwCjDWZZb9SkUBB4atIDqhQmXLfmCRhIKWq48QI2Or6qxobQUA/jR/1yn/PMEW7jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHwOMobriXsIBh9+DjTV81Vkxnqyw/1EsDnP8v1L294=;
 b=N8YfBNPZXTIxFgDEq3DKDmOZmrhNfUgQ8OIwU9WbFQnuRmBFbjIOgyRptsGCuX+MIzYtzZdZ4q1coJYKqAIZy48iGup+GTLqo6zywLZOojC5emKt5NhHJwTf1cPPtsY/0RoCZC9ee3ngf0rXFMY2vC9Dq5eygyPhz6UuLk/5Yv0=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DS1PR04MB9582.namprd04.prod.outlook.com (2603:10b6:8:21c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Wed, 5 Nov
 2025 12:37:11 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%7]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 12:37:10 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: John Garry <john.g.garry@oracle.com>
CC: "Darrick J. Wong" <djwong@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [bug report] fstests generic/774 hang
Thread-Topic: [bug report] fstests generic/774 hang
Thread-Index: AQHcSXl9LlvNthA6Oka+c9m+4a5IsrTjRJmAgAAdnYCAAG3sAIAAHemAgAAgzgA=
Date: Wed, 5 Nov 2025 12:37:10 +0000
Message-ID: <6xn2324slfvddlzwydjxigijdfu7gbpzk77iumjiubolirqzd3@fbuqjbbirtc4>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
 <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
In-Reply-To: <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|DS1PR04MB9582:EE_
x-ms-office365-filtering-correlation-id: 01c1387b-59f3-4f70-4665-08de1c680a2e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|19092799006|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?lwJP6Uvsal43ymcpSqYva0LhGZLjp7fvodzxSIkwt/849x0eULhKh9z8k1?=
 =?iso-8859-1?Q?YWgtweKZ9ZESzP3zwrOOn0XZiit07qG0pKqEBFWNyt+4ZiHNJ9YTk/PAFy?=
 =?iso-8859-1?Q?lZMcQvfcHlfQh1zujBbqH2tc8+IS7NnkLtNKyu/fk0r48orBjackyhmE9C?=
 =?iso-8859-1?Q?RHT3imCyl0FzFm6paMLdMrX+ErLQ1ws3f2b9pPCTgGioy8GT9VMWwkQE95?=
 =?iso-8859-1?Q?vJ7o5gZfibTIJp9Lp6zLfkjLUDByaGCiLPaTrT8BEgiqW2xNC8q5IpeGDC?=
 =?iso-8859-1?Q?XpbpRcSh+MQUXj3HKCQULdWYWSZ3QRCpwnE3CJpX2KKpQ4TpS3DCPbA0U1?=
 =?iso-8859-1?Q?M6ljq6WtMvblYf6xZzavAjdWhpmrD4ePUo8Uuua+vMQBs5+rNI09gq9LMn?=
 =?iso-8859-1?Q?LgMCNJN+eZk3pElDoHBuu9RtEfWrK185LzYntIdfyd24l6qPjVBHoMqgYo?=
 =?iso-8859-1?Q?Wt6L1Mgaga/wVKoUReT6HuSBj6jG46mAD08XisKgHoz0VOjJxcKDMG2Tjj?=
 =?iso-8859-1?Q?uxhPgjQeE+4QrIhsHsyqMJvpOnT5b6QRVDzN/Lflk1/iQQB+5SbfSR07dr?=
 =?iso-8859-1?Q?8baTk6uKoXKeHxW81Hss14+dPdvUCFGmPq4/j0ESsV+vxm1llQobuKsVzs?=
 =?iso-8859-1?Q?KcY75Isu3meHVf03zDeO7TeKWSrQoCKAOcGl88FI7Q1fJMKKQAmUvJBQ7Q?=
 =?iso-8859-1?Q?AzDbS9Vm0I6rvQt4dd4MB+iTVVap6prhZ1Rfjd787vnCyHK2tEDi4pr4/X?=
 =?iso-8859-1?Q?siXDAkPWAk7vWgI1Kf8bNQ+/eUp8i1YjAVbD66pWRClgJqecxctDGSlxDN?=
 =?iso-8859-1?Q?Qa87MmJ1ocgKRjIbt+zRmIMt6JvnMKil70TR0S78hQuN/PWFw2/Mq2OqWn?=
 =?iso-8859-1?Q?aIl0A2b8W2OKkssuVsS4j62L7ZrFC+GWYDo1/vzGhbqTQdcTMrsdThKzWt?=
 =?iso-8859-1?Q?vwMInye3znJj+1OMrbe7E0ObmkQ3apQea8tiXfmFKOz0lmt0k6qGV6upiy?=
 =?iso-8859-1?Q?dB4//4tmpehd6v6fYCAkfsTjNY5yw9YFXFiY4uJ9p1Evhrlhv+XAeuOsop?=
 =?iso-8859-1?Q?i0j4BbS3TajhSnfQWU5X5iWdJbj5o266odLB1/OLL5wcRyw9YmfkR+lxY9?=
 =?iso-8859-1?Q?9YB/2gULNToncbC7EjgWPZ9eqHhyuTYzwp6j3eBwB7zW/ncX6oJB2dlIO6?=
 =?iso-8859-1?Q?HLI/OG7DMTf1XR2f4YTR0/v5Ui1aSER1yf37Wl5/i0rG+BMtr2bcDZrqqk?=
 =?iso-8859-1?Q?IBhSSnvFP4g5DF6gh3/0f/PmHmh04oPQE/h4v9yjjKTer08WAnv4r4NAM5?=
 =?iso-8859-1?Q?pfsfMMqvT43zPN6vW+Gw7cc37n5pr6EBab2l8XrQPFYfZHtA9IIVq3gcFP?=
 =?iso-8859-1?Q?HzhglrCpT7j6JSoAI3W/WBOvgPz1cnWQD3//iXo29k+QFST17ZQVFDUi7d?=
 =?iso-8859-1?Q?sG1sbupuTbwd5bN1qYYvx7BJuzSK4gRQnMb6t415ES4uz+3yB+SifRig3J?=
 =?iso-8859-1?Q?YKRyvrGzhTF9oJVyHZUkPzD5WPMQIx7qt86AYzhF7ylw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?bMZ2zjVimZZG3VXGYC/kjA+4bDrpJVTKWwNtU0XBY3cueitJb00SVOpMGk?=
 =?iso-8859-1?Q?Y+5z5sR1fQf52UX4BZre7oNCd5kHQRhlrKGWRdQSmJ5t9+abMfoo/yYq1t?=
 =?iso-8859-1?Q?5ftHTYj2iHHllZOAJyziblzigwoDRLuvu7S3uhyccGFHW2RX5WxTnEBcwy?=
 =?iso-8859-1?Q?1f4yNG1CyXpc8kBA1uJpRPG5YaUxiURPBmNzhKdbytlfG/Tz0NAbLH+QjB?=
 =?iso-8859-1?Q?LL0+p5oIunTX8fkYwm/kXOiIt5ahGeeD88FkmwdNiQgrZ2SWJ1hGi/oBYS?=
 =?iso-8859-1?Q?P/tAGq4zqx+MJw9lbdCnKPSri5XQQmlo7KrzRKobBZqoNRfZ1h4JUXJLJd?=
 =?iso-8859-1?Q?4b5YTQUeFAl7GRnfSzgt21CGnDt52PSKXjvIU2rlbyIR1T9fK2hL59vjzV?=
 =?iso-8859-1?Q?SJ32OIDAWynDF8b/vdjEjxBxMymeA/9AECZzfpuv2E2gW67nonvsVqPLqr?=
 =?iso-8859-1?Q?1MYZcfNKc78T/gJrna+W+VmbI+Nge0WF3x9+sjLV4FQM5qjAaOC8RjqoIe?=
 =?iso-8859-1?Q?HnV8O1xCTtodZl+siadp1Ky5XWXDjid0+02pEYsOzGfErw9ndAW42NeKNR?=
 =?iso-8859-1?Q?tNjS7tBCZK83yciRk5yVQJUNQ1pBlGEgP14lQakM0GhWgxnwDDC/z4c957?=
 =?iso-8859-1?Q?QSb0K2BzOugnaPbFM/nYJY564LBzEuWAd2qCqauZDGzMlwjI+LMp3g0ViS?=
 =?iso-8859-1?Q?QZnNB6vBqfvoR156PFAYbkOSZELOcP4sSnwi9QZMumYDBbPUqav9XCX/HU?=
 =?iso-8859-1?Q?zoU5QYPzob8VC0K4oi05doQeEUCLPQMHoLpo3aKGZT4LRcmbCRtvpMR23V?=
 =?iso-8859-1?Q?c8OqPl6O2qcC4kvNG7iJ7bvu7blKZC8klmPwzw3gyGvLYgpZmZ2C5Jz1DB?=
 =?iso-8859-1?Q?xHkNYmf8kT6vDQ/rz8pd8z9FR6D1jHjCEEjlqeGS6nLoEqrRkHHSaOiqTp?=
 =?iso-8859-1?Q?GJZ6RTaIA3Rn07gzi+zwM3/y/TaoeOdXgpLaSlWdhLFz5/vrnLEIJtCjsi?=
 =?iso-8859-1?Q?iRRQrO6tHSv5WJTbijJ6KJb7Q9IhMUZunZkWJTdBK2G3jeKLWwK6KeEOuF?=
 =?iso-8859-1?Q?P3aF3EXr7xg9Anc79U316F1NJEfzMeIuzXuSAKxNc3Qw0KZ9tzBVsNuv/9?=
 =?iso-8859-1?Q?hCSH9yBXbiSb6fOeqZa9zFbRj2/0MtX+O/NdPLjzZ5oAh9LyS/f86aSd5u?=
 =?iso-8859-1?Q?lHnv9md5FzdiTm5f4ll308bHkp+PeB5mVnDMyQLgF9IGIRQtlwUMtcLIgs?=
 =?iso-8859-1?Q?e5/ERHYD6M1nS1dPxMX056xcWVKRNkj2X7IrNY+SutucmDhnyKteYYpgGb?=
 =?iso-8859-1?Q?FFDAGv/ExcrQiTZFgVOFUghO6u6g//ymq93ZBktBjI4kn7KWceROwGDzMR?=
 =?iso-8859-1?Q?5WLko4bTQSNHvd9dFyp+w10K8pxUnyXeWqVtkuBVU3JouHpkcbXw8OtMAo?=
 =?iso-8859-1?Q?RfzG1/8IoKu7kvYr6frUOu9/0Q/w982bK/0P5JvLQdCeH8+ONG3KgrQd91?=
 =?iso-8859-1?Q?GiEzMxAJjh3BTf275h7h4O+jI17ylx+P4sQy1QCirRkkID7RaFrG4CSJzk?=
 =?iso-8859-1?Q?eLmf3KsYWDMTv4w3hhvmlf/yANEaJ0LbXlhN5lS9kJaZGLa3tFdOiZvpXT?=
 =?iso-8859-1?Q?x1OoIhKt+/Lx0xwhYPI3zCv/Bf1jN76nvxXdykGHnoAIlT4G5nAqsrjPzD?=
 =?iso-8859-1?Q?4IiG/9bRpRfz2dpe6hQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <139350C690D6374AB264BB068F084930@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LI4yykdRxWUlVJ/+a8eC92WMSOviHV5nvD3m584JPLtM1qBFWIpGVwQrtulhA02zZue0Gww2W5FBPQ7OCc6AV5ypknsiUl7EkcqwrJb339oC2miGicxLcW2VzWn1RaBvEBQ9y5E3UrPT4upCNAOMgmzaigSRnj3eQXEfK8pun3kOncyY3M9Ft1KD0FmiqHV7tVMlUQ9s5hLvCCT81QOEfkX4mbKdt5W2rA6Cnj63TGFqf6liwULmZltc0gtsDa3/ZkQJ1ojaog1ipDXO8bIK9IbcMb0ggeTeNQjCU96Xig1QXhOd2m8dHuVS0ObXjOPyCU4Tserloq0ICFy/dntTcbOJfflZ7lgLj6PgyIz/UtydZXoMhZO1AkBZf7w3KC7Nc9nTCbcr1jT5IkjrYDTsMnJYyO/++NVRHimdDlhi+Q7u3NVOMsb8L9a79d3mS3MaYh7u9Av0amDdECp4stnqZfEd22MxQBjUa2xtyesA975l22WVl6lLDbJR7dzt9kXQ7fgF7zanNSiOwyY86uyKB6K3ei4FEpBtuT/xOoxTbe9Si34QGHbcOuKrejD/nfUvqgIDWetjOyR3ttRSA6YbgkKVN90EAmxAafzF4l7YK+Oyypu+g5mDu0vpOMZe2gvr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c1387b-59f3-4f70-4665-08de1c680a2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2025 12:37:10.5673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: js88HruIDnxMGup045tg8DjapqrjUTfBj5huCCdk7fbs7WTvp/wePuKPsHTr8U5xha3JGMgA1g4IC6oLDCfrW7YVHPU63cn+pU+QK4iumlA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR04MB9582

On Nov 05, 2025 / 10:39, John Garry wrote:
> On 05/11/2025 08:52, John Garry wrote:
> > > I don't think the disk supports atomic writes. It is just a regular
> > > TCMU device,
> > > and its atomic write related sysfs attributes have value 0:
> > >=20
> > > =A0=A0 $ grep -rne . /sys/block/sdh/queue/ | grep atomic
> > > =A0=A0 /sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
> > > =A0=A0 /sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
> > > =A0=A0 /sys/block/sdh/queue/atomic_write_max_bytes:1:0
> > > =A0=A0 /sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0
> > >=20
> > > FYI, I attach the all sysfs queue attribute values of the device [2].
> >=20
> > Yes, this would only be using software-based atomic writes.
> >=20
> > Shinichiro, do the other atomic writes tests run ok, like 775, 767? You
> > can check group "atomicwrites" to know which tests they are.
> >=20
> > 774 is the fio test.
> >=20
> > Some things to try:
> > - use a physical disk for the TEST_DEV
> > - Don't set LOAD_FACTOR (if you were setting it). If not, bodge 774 to
> > reduce $threads to a low value, say, 2
> > - trying turning on XFS_DEBUG config
> >=20
> > BTW, Darrick has posted some xfs atomics fixes @ https://urldefense.com=
/
> > v3/__https://lore.kernel.org/linux-
> > xfs/20251105001200.GV196370@frogsfrogsfrogs/T/*t__;Iw!!ACWV5N9M2RV99hQ!=
 IuEPY6yJ1ZEQu7dpfjUplkPJucOHMQ9cpPvIC4fiJhTi_X_7ImN0t6wGqxg9_GM6gWe4B1OBiB=
jEI8Gz_At0595tIQ$
> > . I doubt that they will help this, but worth trying.

John, thank you for looking into this. Tomorrow, I will do some trials base=
d on
your comments above.

Today, I have just done a quick try with the change below you suggested.

> >=20
> > I will try to recreate.
>=20
> I tested this and the filesize which we try to write is huge, like 3.3G i=
n
> my case. That seems excessive.
>=20
> The calc comes from the following in 774:
>=20
> filesize=3D$((aw_bsize * threads * 100))
>=20
> aw_bsize for  me is 1M, and threads is 32
>=20
> aw_bsize is large as XFS supports software-based atomics, which is genera=
lly
> going to be huge compared to anything which HW can support.
>=20
> When I tried to run this test, it was not completing in a sane amount of
> time - it was taking many minutes before I gave up.
>=20
> @shinichiro, please try this:
>=20
> --- a/tests/generic/774
> +++ b/tests/generic/774
> @@ -29,7 +29,7 @@ aw_bsize=3D$(_max "$awu_min_write" "$((awu_max_write/4)=
)")
>  fsbsize=3D$(_get_block_size $SCRATCH_MNT)
>=20
>  threads=3D$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> -filesize=3D$((aw_bsize * threads * 100))
> +filesize=3D$((aw_bsize * threads))
>  depth=3D$threads
>  aw_io_size=3D$((filesize / threads))
>  aw_io_inc=3D$aw_io_size
> ubuntu@jgarry-instance-20240626-1657-xfs-ubuntu:~/xfstests-dev$

With the change above, the test case g774 completed less than a miniute on =
my
test node. No kernel INFO/WARN/BUG.

>=20
>=20
> Note, I ran with this change and the test now completes, but I get this:
>=20
> +fio: failed initializing LFSR
>     +fio: failed initializing LFSR
>     +fio: failed initializing LFSR
>     +fio: failed initializing LFSR
>     +verify: bad magic header 0, wanted acca at file
> /home/ubuntu/mnt/scratch/test-file offset 0, length 1048576 (requested
> block: offset=3D0, length=3D1048576)
>     +verify: bad magic header e3d6, wanted acca at file
> /home/ubuntu/mnt/scratch/test-file offset 8388608, length 1048576 (reques=
ted
> block: offset=3D8388608, length=3D1048576)
>=20
> I need to check that fio complaint.

I also saw the fio error messages.=
