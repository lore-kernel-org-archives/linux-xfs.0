Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7117519C542;
	Fri, 13 Feb 2026 01:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770946002; cv=fail; b=be+FaE2QpJZ6dmORN90Q1h6EN04BLjknH0FFD0pFeoQoy41kzdXsJzfs+r17uhdu8UyihKd0NRbs1Bxs7vQDlF8zRYSQvMSZik58cy5DQT4Y0G9HWcIVlc7MCLBKPH9/ThpcQMfyqaCwEgidebZ+z8OYAV7mgg2FsNLvmlSQCZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770946002; c=relaxed/simple;
	bh=R/61meaX2kxvspcJV7WZGAyCBAAv2mrZ7q8nvysp49I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ugsz+eEtAnQBdx0m8dAuZkQzEMUDIm0E0x6Go4ypI7wf+xklACtb6aS2chH9bNnn7+yZeWlbR24vNO8OvC06OgvNHEj+7KvFv2QA/s5V5zIgzcs8JAupkpce6Kx5G6GrPldaegvpuwC2h6jFtCZTHQ5z09V0nOnG5Bm0BAvuZNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=lQ3qaVdo; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=iFBHxU3j; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lQ3qaVdo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="iFBHxU3j"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770946001; x=1802482001;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R/61meaX2kxvspcJV7WZGAyCBAAv2mrZ7q8nvysp49I=;
  b=lQ3qaVdoqz9msa81c3LVcYJBOWzjBv9saSbENR5usFxIPnODZlgZ5Ie7
   eo+WvBEPDSHS9PXsdh4h91D8xK2gJpvcq6fy3FLAq/xEihfe/XuwbXDgb
   9x4dYZlJQbyhvob1zYgRq41aVnl+W9gAsAthwejeM2yyi3C0s0OXE3gqv
   At2AqwIWguaumIptI7Lou+pBXg7jp2sWKbnGGzNe9YwxJWBJGHP/myeQy
   xxX4uZSUsEJS2TxLQUi1l8FAiLI5DEM2rUaYhi3VLD//1QbdyjaIY46mo
   BheNYifYFpoIFVsm7DJZ+L2nDo18FIamOoPA1of4AxjWcW6moqNIXPeFa
   Q==;
X-CSE-ConnectionGUID: rziojAmBTnexA3YqHaXR/A==
X-CSE-MsgGUID: Dp+ghFlrTz2QCL6fZFtpFw==
X-IronPort-AV: E=Sophos;i="6.21,287,1763395200"; 
   d="scan'208";a="140314764"
Received: from mail-southcentralusazon11012040.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.40])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2026 09:26:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZusOCe+ygcYVgudKwkY2Ey+PfcnnIQMtL0BbBWsUoqMzbp8BsoHFMVjX8Rj06yP4oDhnazJ2TlV5XhPuV89YR873J0RfabwIU4pDfvWKzWzYSxpPkfp5UU0Wbl1aiHB5AN4XjyjcWNsZ8eJS4oTiFk1Xfb6loaTjgjHhJFIJCfaDbwD+gi07ZahfeH3kgixdCFDRKuJs5iNrzCVzK1qFvmRs0+hBcbseU7lG7T07SWDXGZGkWkUVRGMfr8XGG0W+QU+zdsqmofq/s5EjTIeoQMWeHTwjfgz8FgnVgTI2wGJyQCTaPF5NU+TNpbgqILvhqRgvhZp5MYHsQXH7YqpQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/61meaX2kxvspcJV7WZGAyCBAAv2mrZ7q8nvysp49I=;
 b=q4A1ViUxq0NvvjtLMCuATdkw1hKOL787bQZnaIVDEJXLUgelVeJUqTJwjl+DH8V714Le9YVZpkkpJQqlClGO6IxaopuBAyo6D0hW0vieUYf2PYtBRGg+j6RlTuHlowGEUaSGb4GWZRMD1/F42nPXQQ08vd9CMZTQq0qB/UKLVWJMMNJ77S5hZKitjBMLBTfAnPRX7vcLjibxuHz7rLIyLR8nZFlI5pyETU9/4kPnDwb+/KpMrL8WTzLPmtvILNzKXa2SqhhMlZnCyKFwG3rLY4xiu2vN20hb34sRbfG0DoJ3et7VBNGYwiDQ+3riwJhRCCsOCPiFJcpF261S+KNfiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/61meaX2kxvspcJV7WZGAyCBAAv2mrZ7q8nvysp49I=;
 b=iFBHxU3jq+o3mWXpppkr1O1XjrzkMECGCLb5mC32DQB7X0BfeEUcnLfOGaxbEyFflKk74misGW8hyrJl5ukyS87Wwhebi6PrM7RaeK/g4zq8Op/jdx4l5YMRX3zs7nSxxJ9dnPXUDjc0YFT971OiAvhBj3Op+AxiFRm51liVdHQ=
Received: from SN7PR04MB8532.namprd04.prod.outlook.com (2603:10b6:806:350::6)
 by DM8PR04MB7879.namprd04.prod.outlook.com (2603:10b6:8:26::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Fri, 13 Feb
 2026 01:26:33 +0000
Received: from SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4]) by SN7PR04MB8532.namprd04.prod.outlook.com
 ([fe80::4e14:94e7:a9b3:a4d4%5]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 01:26:32 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
CC: Kunwu Chan <kunwu.chan@hotmail.com>, "rcu@vger.kernel.org"
	<rcu@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, hch <hch@lst.de>, Thomas Gleixner
	<tglx@kernel.org>
Subject: Re: rcu stalls during fstests runs for xfs
Thread-Topic: rcu stalls during fstests runs for xfs
Thread-Index:
 AQHcjrclowh1moKuUEq8Mwy02Ri3kbVnWueAgABxzACAANWrgIAAzoQAgABdO4CAAMgvAIAVW9aA
Date: Fri, 13 Feb 2026 01:26:32 +0000
Message-ID: <aY54lbpbvATqNqEA@shinmob>
References: <aXdO52wh2rqTUi1E@shinmob>
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
 <fc611e8e-0da9-4b88-83ef-092d300307e3@paulmck-laptop>
 <aXrl46PxeHQSpYbX@shinmob>
 <13b25e07-d7b8-4b4e-a249-b6826b2eea39@paulmck-laptop>
 <c33c3d3e-a59c-4f5a-a562-13e2cabc2faf@paulmck-laptop>
 <aXyRRaOBkvENTlBE@shinmob>
In-Reply-To: <aXyRRaOBkvENTlBE@shinmob>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR04MB8532:EE_|DM8PR04MB7879:EE_
x-ms-office365-filtering-correlation-id: 9fc9d74f-1a06-41ce-da82-08de6a9eebf1
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?8c6bbtiNqCaT+j8BlZ2MILp5PyTDc34iCvYnAm1W6rNrN//9sh50TAmU5ASj?=
 =?us-ascii?Q?BB9ZtFcqwyM1tvnFlkFtzV3K5SomLqJfCA5UKT8PoIAbfLFtDkkDghQyg0KE?=
 =?us-ascii?Q?LKVPF6KkTsDiOJaAhDre2n0ZBVWRwI9eNIPTIy+3FsJHKE004LpUZBJwQTtS?=
 =?us-ascii?Q?5if9XSV5qPAusBHefqVx5HfnJc5I/UrK+cfYs4sU6LBlcvZfHys6vXlz8Wuf?=
 =?us-ascii?Q?AmZEe3nI72INMpyysOVjWo0JPiSGkj/67mU/x9JxRPoI/fLh8ZMakR/gm51e?=
 =?us-ascii?Q?R3WflLXcHuyWVLt59ILlvDbYKemrnvndKIBpkdrdplhP8X5Gn+VmUlt/PaQg?=
 =?us-ascii?Q?k4S8ipCkhwqHljW79/rZ4Cz1PeZspaeJhVCG3Oti/WEoR1m5KVre+CVJVakz?=
 =?us-ascii?Q?70KqxQxYIXlOrbcyCeeHxpgX2LJq3x/wMyZ0gluWTROrGY+iEt3ripXmAjmX?=
 =?us-ascii?Q?tKFpcOsIFfQ+jTiGGEdvFGjnrMwUGV61fe2JlvQNO+MrLlJsZA2aunNo82Hr?=
 =?us-ascii?Q?SlYwhnJPb7OvaucJ4ZNbXpxzaPb6V3aZjUnikRVDwQJ1gs2MEfhib1nXdz1y?=
 =?us-ascii?Q?9tk8aWZBZO5gV864oLHfpwOfliRIcdcp69TugnaUEPgKAFErZx04W0XomPXE?=
 =?us-ascii?Q?tWV9jM8t5IkTbPq/5BS74pXkIfZ2fr+3+oQxEF8bmAPc+f7ScgzvVthPJtJ4?=
 =?us-ascii?Q?AbgonT3xsWF6uWVBSQtUspMejAkOY7Hj+9Y5LzG96x54JZCbTmJlWsdpi/K9?=
 =?us-ascii?Q?jaaKnQQQe1FImXgpGmA/Px9nCk1YmdNMgR6BRr1Ofv5sveFVsJugrByYx55D?=
 =?us-ascii?Q?jQwy6mAmh3Smj5EG+rVRAQa7/dYa0Odtkl6ATmHatC29RbIXnyxqG2W4HdnL?=
 =?us-ascii?Q?hFE+WXV4kexp3JgHvhCmFE3dfpdbxVVJoJqAIQuiOikRrs0dzCr01ahQqsoK?=
 =?us-ascii?Q?QhBNixZzWMapxMDfr0l4MLS3CHC4QUEQxK1lN+6smcw9gZDz+jgowQHiyvwa?=
 =?us-ascii?Q?hLJUIIDq0auIx93AeqycjLXKhTpqZXMNqVxbcN5kv9Q77UUDY5mrzOK5af0h?=
 =?us-ascii?Q?YdEQFsxEoEEkLUjOXQwx8nJYqvp01CizRa6YwvKtHZgoKOZe9Wl5ibAbNHTN?=
 =?us-ascii?Q?FvQ6Dyg3CX2qWcepZrbLfX73GPwDRB502MvYZ6el/ywcmRoP8Xs9QA0ACCAF?=
 =?us-ascii?Q?5y5kIddD0a1Ow1/FToFuDTXa/jPFJiia60VJ1Qgg8V+CHy8H6v5F0cdKHDRy?=
 =?us-ascii?Q?EMJ9lSOBMutaAjcv+dndZf/vE2HnmAB7mudLUhWgKtrWJjLXA8Osbk6zWorW?=
 =?us-ascii?Q?KLhn6eps2ef+zBDPJtJ0xNFxiFthI1kWmiRxX6ZAnwHw4TKIk+VYXoWyyBcJ?=
 =?us-ascii?Q?YI2DV7zvSin1ol8E/QfvXL64/bfT4H138Ja6buK3EKazFHhJeeKbEugB6xiI?=
 =?us-ascii?Q?9ZIRbCLJieE3e8XbQ3ZbegSeCHo0pfE+QRef8fZLYSq0roaZnvEYpRuf3hoO?=
 =?us-ascii?Q?cy5E5SNx2vmcd7asxowxfvsfNMdk60EQDwiN5Zj+pYfCfGhs4Q+xBsKSaldW?=
 =?us-ascii?Q?isV4hi/eA50ztOdpocbq73AgBKwmGXszijgoH6DTvXo6EVCmeFLgyRJAYNqs?=
 =?us-ascii?Q?fTew4RbHVLYlzO/UooG7oZw9RZ3UfZlbkbRVGwXp2r3m?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR04MB8532.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(19092799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fJICjD9Py2/hu1iBu5QLT5jHZq/1WGdaDlnMDSXF+ec8by4I3QVevlr50rbT?=
 =?us-ascii?Q?iQXvtxJ5Zo0Nmhfh9so0AXWNdh0b1q05DuFAtQU2C++nID50N5jMX0nxwCAx?=
 =?us-ascii?Q?R7D+pLF+ql41sW6RFsaDLkzJCeC3P/YFeEri3W5iBXqlVvI6o69WXVqmXSwS?=
 =?us-ascii?Q?EoPauaLPYu5HDhjG32J+cZCzGs2mS/k1AdeMWYZpwD0VxshmmyeSBPQ0/WzH?=
 =?us-ascii?Q?P8axdoksTGM/XYpYRTN7YkKrjOKpqMpYewFbIfcB+5wmY7c+Hinp4xXQiYLo?=
 =?us-ascii?Q?gBEPcF1803dAgGJIQAIFwO+ouhMAlPBY3lVvfSQwgXUBvT1z1eJd/MInh0cv?=
 =?us-ascii?Q?LBYaPpNj52ouSkDSBzXDZPauCQlaeqA00/SIPyyZ+tSCGEP4peRq9c3QEjdo?=
 =?us-ascii?Q?S5fCuilQNmIoheNtwT+Cp/ji2jMHkEScz0aNF8YfakUTgTn1vzjlnq2ZxArI?=
 =?us-ascii?Q?5d3saR3+w7/PebJcXWNiWI2RbFSqNReYVfNn5q2m4cnR5UJ0ICshAw5QHv3+?=
 =?us-ascii?Q?kENffXI+eSrIPx7ZDgk22s22kAxhPh56V/OGtO5HO1766sOEA8wbO18oCTHJ?=
 =?us-ascii?Q?+tbRycmEKmslccMFPOCutvraOaSFhuG05TP0YGclH4p5DfaSrHO75+QuZ5O7?=
 =?us-ascii?Q?yAA97D6LyRw1wlQUadttTlStwyoAxgUy7oRFuXzcUGQ7Vuo9G2f6L2wo5XDX?=
 =?us-ascii?Q?WlTFHiiZEZlmVCKlWtjKBiN1G8dQQXPprY3gp5rjW6xT1LqSaRGjmgBtp9q2?=
 =?us-ascii?Q?HvZky3+cyXY6fntPHEmqc6ocufYBtoZB5pcR7msgVqsMp2IvIE2zF8jjljq7?=
 =?us-ascii?Q?87HM1yTOFHMj3Ac0klnqGACx6Z4H58cJDJiE1hq7XcomlVAyB5RG7YA0ikZN?=
 =?us-ascii?Q?r9tf5Sj5Of1t1O7hrbAa/8BG+Sq+fxnHmNmW4/N1U8QS3hiRJ5MXYjfGzleo?=
 =?us-ascii?Q?85fLeKRiAP9JEdc1UV27yvhv1XzKF0I0uGlmuYcbxymNVE/Wu4w7vCc6uGex?=
 =?us-ascii?Q?HGmIP3R1a7xFc6MDLe86gAuA5nqRsM8ExEeepGPXGFZbWzWqIaXFzDiQdvP5?=
 =?us-ascii?Q?ycnBVZOLk+j4dpOVKC46TMT1bZjBS5FyWlEIxRpyEqWKHgnRWptHUzou2Fwo?=
 =?us-ascii?Q?hRo8jEKmOrQOlZ94WwIn/5ENcw8d4hibAwb/4B06ovz1LUpGQILxiSC8z4sW?=
 =?us-ascii?Q?OryQjaWq52Mjv04tnO15g1zxTFONmJgRiwXiiorORG4lsmoVrRjMKeUID054?=
 =?us-ascii?Q?tPS1HdZ2KjPrJkYzFkpYlCJWn3jNhQaHhHw8jH0eUgJxgGP/+2KvEOzlR9gv?=
 =?us-ascii?Q?7GvwAfXKvcjYhowy2DiPzQcZt2w8RbKfrR7+JOhNYyPl13SnmbHeIi6ftR3R?=
 =?us-ascii?Q?o4sNKila4pNoCuTPWyARlqp8A/g1cc+q6K223x1bplODeOuPAI6NCbvfdYJ4?=
 =?us-ascii?Q?fq6XISATWRLGREaGVsslI0z9gPtEyjc08fdg7sk24a+xmpGHUWmzy2rSZT/c?=
 =?us-ascii?Q?0UE+buu2KpmgJIc+7yDl5pcprcpRCn22JiBTkjNBlPw1Hs+2joH+0YwxlveN?=
 =?us-ascii?Q?7KUm7iEBY5LB0Egog+EWgWeNGaP+afyh9JLxYTOj4WB7YBm6XIL7kOsmftnF?=
 =?us-ascii?Q?Qif7bvmqxCNEmQ0NMzcwFAkdKMhR77NpzBTBMKqyBb+qjqJUFzgFSpz04pqH?=
 =?us-ascii?Q?Y/2LfmM4WsQakhnZLZbS+BUOjdFQwoAbC11leIw4s/pK5n1U3FFWnWfey6Bd?=
 =?us-ascii?Q?qY4cTiRBUUrJmhnwE2H+uvfnoRBSJf8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AAFAF4801002547938B22BFDE0C664B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DwKe6iJxPGwHBGRHwlK9eg3UC18AMKPXQSwVBDCVOlxnlvKPPMM8FFMUbOYMqdOiHUPsTIuA1ySUPzHHp0/PFZL3LVmVMMhDgWg4ORFQrEJjs58jcde7AeUtHCdloUIiiEk9XX3aRDEuvz2X3/wk6LdmWBCn33GWvB9+SVbMSG1vJVYmXigSXQi8jIhspXexf37x4qCW9CgHmhyVVSBj0HYwofnZ32nolyM0oyEMbyXl3KeM7mIeWUb+N/iFzMKz4u3ns3mRM/YIhLKRBq8E/hamuWIYMOxWpfRVVUH05HWb5bzfWSL9XfT8Oc5FrcJ1SHuSW0TssoULgs79YnVPelnmfqcETgAUusNA4Rj2+0KKnaouIkyMhPxDcPsHcRS/7lo94zpfQWJhioSc6C+Q4s9Be2OdmKFaXA8DkJwqIDSCWT+AyHXTB3cZpqQEaqnycViL9vKCqTzlHBHVZpon8LM2Nl3c2zrmyTW4ZXcqZ5M7QETc1p+oOo/ANywkx91Fj38MwKIl5eeDFQiAkWGNieOMCuDUSzIcK0fCJg0gAEv1LzHajGimMksqhoI7jcEQaZC874f/4nOHqKjybSqStqQ3jnGxw/ih+VF+AwVNq8TB6waYKJzU87Y0z66qxkyv
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR04MB8532.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc9d74f-1a06-41ce-da82-08de6a9eebf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2026 01:26:32.8864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pof4PaSTMMcjKDvyVwNumwtW22S0T5YbidOLSPKtm51ZnRuhPwPsOQmVqfK1vQr8+ik6nrQheBaM2sy1q06ESU0zAoDTZXLQA4Gypk3T9f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7879

Cc+: Thomas,

On Jan 30, 2026 / 20:16, Shin'ichiro Kawasaki wrote:
> On Jan 29, 2026 / 15:19, Paul E. McKenney wrote:
> [...]
> > And Thomas Gleixner posted an alleged fix to the CID issue here:
> >=20
> > https://lore.kernel.org/lkml/20260129210219.452851594@kernel.org/
> >=20
> > Please let him know whether or not it helps.
>=20
> Good to see this fix candidate series, thanks :) I have set up the patche=
s and
> started my regular test runs. So far, the hangs have been observed once o=
r twice
> a week. To confirm the effect of the fix series, I think two weeks runs w=
ill be
> required. Once I get the result, will share it on this thread and with Th=
omas.

Two weeks have passed, and I did not observed the hang! Then I'm confident =
that
the v1 fix series by Thomas avoided the rcu stall issue in my xfs-zoned tes=
t
systems. The series is already in v6.19 kernel tag as v2. Great.

Thomas, just FYI.

I faced mysterious kernel hangs during my regular fstests runs [1]. RCU exp=
erts
suggested the hangs might be caused by the recent MMCID changes. I tried yo=
ur v1
fix patch series "sched/mmcid: Cure mode transition woes", and confirmed it
avoids the hangs. Thank you for the fix. The v2 series is already in v6.19
kernel tag, so this report might not be so valuable, but just in case. (And
thank you again for the additional quick fix for my blktests failure caused=
 by
one of the patches in the series).

[1] https://lore.kernel.org/rcu/aXdO52wh2rqTUi1E@shinmob/=
