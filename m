Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D76A151985;
	Tue, 22 Apr 2025 11:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745322613; cv=fail; b=ivGm+XXYnFK0tiORDJNaM0IVkMZ6dHL/gnN82GqtwG6/8S0Y07mpk+o452yVMrRV8KxZXKsPNr8XxZv3W09iqeZ+3lKy//liaRHCzHQPIpsoPTOEzUZ9tjN0TIMRI7lt3Xf5PWXbukr6kpn1W/ef8WMkMvZwmFL0qBDZnJGx244=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745322613; c=relaxed/simple;
	bh=kIJL7eo7qVkeFrLcm/kuNZrr7zG085Q+ssJATKJQtfQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DFRccVbD8uYG68RJRv1pqGvWYlvj7wwHiNkaTvMAW9iH+91a6TY6AY9xTJCvgZWT3twIpEeqqs7APaDSlIwy/LPTeKDeTR9AZuJ2ollBqpxkpa67opid2nnXEUVqfWu8yvr9H8kPPRgGyS/ITNPD6zaGPCdZ5QU+r454FwXcHKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=W3lu2R3g; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UbRxu89C; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="W3lu2R3g";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UbRxu89C"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1745322611; x=1776858611;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=kIJL7eo7qVkeFrLcm/kuNZrr7zG085Q+ssJATKJQtfQ=;
  b=W3lu2R3gANAhCibwciI80uSHRGEM5yxGzAW1I6yNvvj0Pf2cskGAohSg
   9zLmBDq01qhw8i9T5D8miqvTv2fc0nZdJ09FjLQCXxAKbb1IZmF0TcnMU
   GXUKDZzPMpYNMG1nA7r34aYi66sPSwO83D7jirJwql1EolSZo//tXpa9h
   GKqxRc+iUOQj/rjeyjq1V0LM1cLxBF4zp/x09dboHswqVYNvZCAdIIbz7
   QBTrAON6FGXkwq5jb79sn424qgteSyehjdH8gCSoDSLtdWJW1b/Zyin/E
   ax9Eo21y/4yRj3RHLf0S9zgjwa7nIEU52HycqcDjOn5sW/U8xhWb7bhjZ
   Q==;
X-CSE-ConnectionGUID: O/tHL57UT6iGhECVlU1Jww==
X-CSE-MsgGUID: jTY7s+8FS/y1TylNcc30eA==
X-IronPort-AV: E=Sophos;i="6.15,230,1739808000"; 
   d="scan'208";a="76808593"
Received: from mail-westcentralusazlp17010000.outbound.protection.outlook.com (HELO CY4PR05CU001.outbound.protection.outlook.com) ([40.93.6.0])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2025 19:50:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJhVMT5HC2VNEJNiMd5j/a1Yhv6Rd973nD5Vt2TbTvQL/JQeuwjer7VcKy4eEXhwZZQLFcRE+l9nE200l0y0oUQfopYaCZj7uELX7ijPrTGkMPEQB3GtQH2WGvTNsLRfVhrUEfJIQTc21543irvMKb0aR+V3fd0lVrqqcVllX8vwHZMrK/ELfsWJtceRCtHYyE2XKVTCRzhugnWyOAtqSPOItWJxTUaRXiiuwwc+jrDrIPPn/tMun+aw59hAwJ+35H1J3rGkWM3j/QnxYyDACb/RBOrfWf1RHyMb1O9AgzuRrgGuBnncFxuCgNFfvy/vUNq9X1tCoam4uVUwSBRmfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvVfTQKguCXMEW0YBj01Q1toB6JBnc8KEoIFTaHKK8Q=;
 b=rB1cI5eyAPK9uKeWiCEJJwHFemTWLkK0CEVCbBB6jmd6hhkvLH4U1nn9U78Lk6v1DdrTLKzmf2brtsntU0P0k5Znw40ZC655r0/gsn6r4F35uxWiUAhEo/SfDm5ZcbrIh6sGNmzRrdMQn+TNKoIma5kqY2hP3aUp3mXAu39OrUAfwyG8WiWUgze4YgzvAb5IrB4gojbaBWJu+AtNVkHqkmzdfjMxeOPx8IXd0jf8gaaTT69x5M7bHFnV4J1yHn1OgKZXwezK6pVZza5tO3Vp59Ds+LoNvC9KA2qEi/SvqwiZ7Pytop8XaItVoSJJqwN/RauiF1zlVlRtg340hyyfCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvVfTQKguCXMEW0YBj01Q1toB6JBnc8KEoIFTaHKK8Q=;
 b=UbRxu89C8VSisyrcyrd5tmy8TukARKtrH0mOOVqirOxAyDVfmbM6uCowNjeE3cWbYDJyw5se/NGKwy7InE7/HtQ0Qa5YOySKfU9C7oHqcoFxQWstAVGlc488F9IbXU+//iizwGAuMbysw8n7NtKXXMjyJObNfNLSYUx5WsMLe5Y=
Received: from BY1PR04MB8773.namprd04.prod.outlook.com (2603:10b6:a03:532::14)
 by CH2PR04MB6540.namprd04.prod.outlook.com (2603:10b6:610:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 11:50:07 +0000
Received: from BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5]) by BY1PR04MB8773.namprd04.prod.outlook.com
 ([fe80::1e29:80f5:466d:e4e5%3]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 11:50:07 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, "Darrick J . Wong"
	<djwong@kernel.org>, hch <hch@lst.de>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH] xfs: remove duplicate Zoned Filesystems sections in
 admin-guide
Thread-Topic: [PATCH] xfs: remove duplicate Zoned Filesystems sections in
 admin-guide
Thread-Index: AQHbs3yxy7ODo4rBHkGtk/rGTzlD5Q==
Date: Tue, 22 Apr 2025 11:50:07 +0000
Message-ID: <20250422114854.14297-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.47.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR04MB8773:EE_|CH2PR04MB6540:EE_
x-ms-office365-filtering-correlation-id: 181348a6-27d6-4af7-ceab-08dd8193d43e
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?HlEYAn0wE+WKOADCeBGUK4lYrtTHTszVzRVsr7UlYSpI6vrGuBV3neJ/jt?=
 =?iso-8859-1?Q?f8pXPHWsYZ2X0el3RbjFqH0aHyunxREpxm3XTNr0SZsBWUVspdIvA93ftP?=
 =?iso-8859-1?Q?XJgRNw3Bd+CpNhbC8iXlQFzZAflUUSBEGAYnuLGQn2ksBiQicgE4HBAHYk?=
 =?iso-8859-1?Q?j+9R+483mf2B3T7nHKur4OdAnp7z7glj9ZelPpJwvmrFhkxt/eui2NECHZ?=
 =?iso-8859-1?Q?3j1g+UNpGassMPlE402MhnYnX5GKusMdkPYEw6GqB9/6g0Mu/Vc96zHS+a?=
 =?iso-8859-1?Q?TqYFvYyiToUzDQk+8UlL6sGlZ5KlWSHzsl/Wo0GGZpDkBQQFXuaRPf6x0b?=
 =?iso-8859-1?Q?2J5bBjNqBGIxYHkKaHaIJi36Ok/87eyxPm5m/uLnKkNxxlMILVjRWqA/7I?=
 =?iso-8859-1?Q?B6Qy9GK+OE6qCbaCRhNir6/uXl8YSNq2VshBt6erwcAmSvDfeOWWEnIU4i?=
 =?iso-8859-1?Q?677WRJ0wivjQbK4x+M5Fr9qC/sDIyruMFs67GDlGU6Dcc7Y33TAPROMkGV?=
 =?iso-8859-1?Q?7NduVK6fc+MWM7265binAvSsbP5VIn2S19ygu1RcxoF2AtwdKAZqTmk+c3?=
 =?iso-8859-1?Q?gxf3/u4Hne0ZzDLU1zxQwo6mB8p1sw19D1rI2cAATwSrDKyM5FtfyydqEt?=
 =?iso-8859-1?Q?1MeUf+ww1uHrUN6A/9HtbQEmWgZ2nJa5oNWIld81znyys7mW7/jWi0ZLkW?=
 =?iso-8859-1?Q?qRxM7Ww1u1J3E6gf1TrbPl3iIk+c6gxawRT17kyp3t6HlcgSSFRREFRgnQ?=
 =?iso-8859-1?Q?ZyBO5z+rNyOyQOrFsLROUXxP7ffmdLrTtB1lOS0Cg2C01vtwyzGyXXaM/D?=
 =?iso-8859-1?Q?zW0GLoDKX3MX3QLGQW1ut7BkfoOpbRGzUbIhaX0mbp+WWDhA2sifyaNrq1?=
 =?iso-8859-1?Q?31dh08LBZR8K6xUmqvie6hU3z19XsWlTqFe6A0m7NJWzRlJkAax3yvnftM?=
 =?iso-8859-1?Q?Wp1uqePUmIbDkcm7v6qzCE9VRcd5XliUIfytA7BnTIxef1Jfqm6rYJAlFz?=
 =?iso-8859-1?Q?eIFuzKNAggXLuTXNmEJOOiNFmU6N/l+uRhh5VVJLiVAfHp7dANtdw2imkN?=
 =?iso-8859-1?Q?vW20LJBM3DMLakzpU/ha93V62rUtIXh4x4ZxYRYM4mC2Ss/LBSEb7vUXV1?=
 =?iso-8859-1?Q?mRRVTkl6+Nya4tjO/5ennTLEybQcxcf+86JAvf8gyzZeEc/ajTiBSeTbmA?=
 =?iso-8859-1?Q?qH6KAwLgTu7807lpG4sepUtVy/Z+iIyl9XcFWsTDu98wYMA4NK//mVYiid?=
 =?iso-8859-1?Q?J/aSGM6kEN8cTgcPk9wbDMPitWjFunUK2k9Lz0OnmFD3uNEC4BGqV8n+59?=
 =?iso-8859-1?Q?wEmKPWyYpk7ofVP5Jm2CNmSJCJ0F//QOvRYBqtGXZe/iMSQPZZO08Bdq3h?=
 =?iso-8859-1?Q?p9eW0EBJwetU9mizCg5N5p0t4Y40yoM3lO3Gs4bTbVUB54QmNpCEG7SuOo?=
 =?iso-8859-1?Q?LB6V00X52ebmr9z/CGYovN94mRgIHJ7HGEAuVgWb7OATYfp5nhnaGXcLY8?=
 =?iso-8859-1?Q?TEL5TSX6bW52hb4JChaQcGKV0wkLTtmyMFmpwTe5GcgdNZppv7cigGYz7j?=
 =?iso-8859-1?Q?sBVpOA8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR04MB8773.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?6ExrEjQgMvFe0vmtTmkR/b6spsDOnOC4ZRkY51oIw1b/qcdE/6eZyBNiMp?=
 =?iso-8859-1?Q?WeT2KT0BZE6DAzDLJvBVGBWRst+OU2QU1g2DqscW54WCW4QMZzN/f4lJuB?=
 =?iso-8859-1?Q?iruR3MFk5TZ3kpXv4ceVGDdd06XZugkj530oZz0SYXZ1b5b41L7HlcDCnL?=
 =?iso-8859-1?Q?6hT0CVAbFxb1+mxaHeTLM2CPVne2PtPc38FoMFO2r/fA6oA7aVt/iJTVWU?=
 =?iso-8859-1?Q?m0JgCqt4sxzxOeTCrVP7AYEA86qAWqmHl3ZsGn9Mzq92/t+GeTwrhUdeHH?=
 =?iso-8859-1?Q?ETj3rCeBdbQYuZbwFe5DJMWjd9d8iOCoYMUKiNf+WD8ePbCJfPIrbPAExv?=
 =?iso-8859-1?Q?0uhbHrV+Bw1vzkYfu27u05sKM09jLD8zxVIKbOrNl58CKUVzUqfNoyV1nX?=
 =?iso-8859-1?Q?Rv6eI0Wyyo1ypMPbz4S93KwHUi17dRufZrMxpgUqgXktOl3I6OpFoCyu/e?=
 =?iso-8859-1?Q?4x5akrlUIb3EebeupS15jN2OhYWjJu8vHRNmNwCDlxJM6RyoDUGvEwcB3w?=
 =?iso-8859-1?Q?nLbOSRT+IgNx3FXd5gSgL11yjmgAc0q7mB7QP4Z9is9zS9gBO4YKKBnQ52?=
 =?iso-8859-1?Q?67961ASjntBLv5OTmPQVHxG3LImr0oo+qBhVxIfhWNmmN8hrgfVSXkwkFn?=
 =?iso-8859-1?Q?DDZxSxMrSTqj/sYkOLm/hrfJxOrAHJCe1Z5CIEMAtltH+6B0hIaMabL6Ru?=
 =?iso-8859-1?Q?F5UhqhU1+RETxCQZ5mC2Mte6bmmV2qPfuW/Pl37GmkvOop9wdHblyH+gnY?=
 =?iso-8859-1?Q?6YELWzkACXnComcK5+MY5TlpNo1Sgs9FNt3vJO/FfSQRR6MFuiqRH3nvbK?=
 =?iso-8859-1?Q?hdnIVTD8qMU27rB3Y/bCo6ylouSCBNm/4dfzSDVVUbsnT4wHNosbCN+seA?=
 =?iso-8859-1?Q?1gg9JIKhVeGezs0tl+hvYQzd+FDJc42d8QviRVUWoCw9EiQyFV4d9zW8yb?=
 =?iso-8859-1?Q?YT3qTrrLfP2Vnz+V7us0/f2kH0GaTbA2YEO+Gtf9KeHoHHicIOfkhBcn4+?=
 =?iso-8859-1?Q?+vf9G1yelHxUjzhb61qdRP7+knE0ouTmVaYyElDXRLUid1u7ux6CS7Tqo2?=
 =?iso-8859-1?Q?iXKXD0OYNSCOfQ6MnrQlEgiwhbA+GLHkW+rmZMA+/3h4fdh3krjqFK/qwx?=
 =?iso-8859-1?Q?vJmaRQn4Hh9klsngoDzQKTShuRmQY0rLaiABcqF9GghmYlWhjiiFeFk841?=
 =?iso-8859-1?Q?SqZCJrmeBV/w9ZpuvIHueF6jDnJMrKrYlrxWfDm6NHjg+pOtOWw2BHWlCo?=
 =?iso-8859-1?Q?p3TnBub3hiiljuiSQm60IABc2cXnD58f+a4M1QJUn4CSxRMG3CvsHFNP73?=
 =?iso-8859-1?Q?7kuijpoEMTkByn6pWOaf+VpGSdXPyfw7M0pTFw5OX+V/SPb+bud75V1BPW?=
 =?iso-8859-1?Q?3BlI3UbRiGfAN+OgnbRt0jCwLrJNoQSHI/xYCgdcs7uL8KB518XsPf0nXX?=
 =?iso-8859-1?Q?FVSYelH3rhkdfmeoy+3Ea5EwdSlZQj71W40cOSmkMHtIlaEHCOYwC96sTI?=
 =?iso-8859-1?Q?DPvhagAYyqyYKy3/x/dpFa4eWhsPYseVapNX8xth7On1FceZ6x1TsAtMlk?=
 =?iso-8859-1?Q?ukKnmus8T2lKMXbW9eLNNYs27FsLpp5/BiBkEnEv5Tum2PLU1RmYM+S7pM?=
 =?iso-8859-1?Q?M45oyZGPP4F93JZ6X8xB4axAMFlK5dkN+K2eDiQLfnfPTLKpbJwRz5vA?=
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
	hO84ftM/0ffqSpYTQ/DgKpzhOtCS6DSoWMwCjyygX5Qw+ysrfa1Gu+XWz4zxuCLp12Tt0BJ+9vvBmLtoI/nYy9XnVbvZsGsMt0MP21VgHL70RmqyFPIJKtNMKHkWlt8xS6itC1uKe099xd0hPEkeRz8YWBJjEoEfVNCcxKJRSdPhkZVuvAy2EyqN4acMHy7nUliZdt6XcKLzXymVZHbaVtLCVXDrwQr1Wj2JTxmK+Dh6jb+abti1l/oTbzoh4HVPaY7XWNaBEl8+eTOzzQQGnhcxNhwwQ7c+K/F5hRkdIBmpelT4xGVIt6aQs3rMtamdSKSN8hoW1JxQ8u3ODRNxpUd5woaeZUFGo49iwMDz3c6UjVJSeG2vmBKDHm90LjPx0/dSFzaC4ARkEyOCadORhTE8MZD6cfBSr7gltP6Klx3MgrpfeVMS8sczjyR1h3n+ylHYInceCt8L3Er95ezx2xjhVOkvBYWXzSn7jJqI/n1OzIoXLxgTNnn4oWVqIWaawoHv4Pk0fKc6X+IuBJ5pg5jQDlZQL54BVN7HHyvxUDhqVQ2LZb+8IxWOtJzFZnKMyYURszLI4/WzHHjEaLZt0/4Rq1w0C4i0Dt6vbsBL0lpukBHj+vrOz5MK4V0qZCsZ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR04MB8773.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181348a6-27d6-4af7-ceab-08dd8193d43e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2025 11:50:07.7245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18IXu+lOCzzrhKqPSiJxgLiQp35V5H0heYbiHxXZqEmsgYksP+rUNZmKqchGJOtLIHLsUnQt6Pez0GPnq6x1RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6540

Remove the duplicated section and while at it, turn spaces into tabs.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

This fixes up the warning reported by Stephen Rothwell for linux-next

 Documentation/admin-guide/xfs.rst | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/=
xfs.rst
index 3e76276bd488..5becb441c3cb 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -562,7 +562,7 @@ The interesting knobs for XFS workqueues are as follows=
:
 Zoned Filesystems
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-For zoned file systems, the following attribute is exposed in:
+For zoned file systems, the following attributes are exposed in:
=20
   /sys/fs/xfs/<dev>/zoned/
=20
@@ -572,23 +572,10 @@ For zoned file systems, the following attribute is ex=
posed in:
 	is limited by the capabilities of the backing zoned device, file system
 	size and the max_open_zones mount option.
=20
-Zoned Filesystems
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-
-For zoned file systems, the following attributes are exposed in:
-
- /sys/fs/xfs/<dev>/zoned/
-
- max_open_zones                 (Min:  1  Default:  Varies  Max:  UINTMAX)
-        This read-only attribute exposes the maximum number of open zones
-        available for data placement. The value is determined at mount tim=
e and
-        is limited by the capabilities of the backing zoned device, file s=
ystem
-        size and the max_open_zones mount option.
-
- zonegc_low_space               (Min:  0  Default:  0  Max:  100)
-        Define a percentage for how much of the unused space that GC shoul=
d keep
-        available for writing. A high value will reclaim more of the space
-        occupied by unused blocks, creating a larger buffer against write
-        bursts at the cost of increased write amplification.  Regardless
-        of this value, garbage collection will always aim to free a minimu=
m
-        amount of blocks to keep max_open_zones open for data placement pu=
rposes.
+  zonegc_low_space		(Min:  0  Default:  0  Max:  100)
+	Define a percentage for how much of the unused space that GC should keep
+	available for writing. A high value will reclaim more of the space
+	occupied by unused blocks, creating a larger buffer against write
+	bursts at the cost of increased write amplification.  Regardless
+	of this value, garbage collection will always aim to free a minimum
+	amount of blocks to keep max_open_zones open for data placement purposes.
--=20
2.34.1
