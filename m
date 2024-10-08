Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B902CA8;
	Tue,  8 Oct 2024 10:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728384737; cv=fail; b=BIV3/ewuxIUioPyBXwwZxR9ki4cFWwMrsMpv4A8uUW1a07C3txvF2oU20n4hV1oAKex9UfPQfXHCMym5gOvlXSOy6vGVcgq2XKeFH13LFlFAhKzdapBc5bvFaAeCAibD7TOeosWcAMBMI3CJyTFWpW2uciottXWxXVsD/cAt7P0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728384737; c=relaxed/simple;
	bh=K8fTHpcHxgym6VIF2b4ZAEp53R6hHlD96aXl+ZJ9LPI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YbFl3ltgeO+d0/82tClpHt4XiJoSvRedkN1Z47c9AUlM5myNBjvQQDl52pk8T7ADSEFGHN+zMqHVU4EGxOxIlB4jRlfJdlJlheHirEghNvMYEXyFOSE5gcskxobzsW+0zLHOG/CFbqOCn+jyli7D8OTpt7pUjHOOBIviZIcENE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ji63PmC5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=s5gy7y/8; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ji63PmC5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="s5gy7y/8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728384735; x=1759920735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K8fTHpcHxgym6VIF2b4ZAEp53R6hHlD96aXl+ZJ9LPI=;
  b=ji63PmC57oGKyz42R19WQd3Uv9cjmMERaPfUU6mDGmKJiIfoH9oFzQQ2
   4mjNARZdTqIeQUazBAb05X6v8Hi7r5bY3s740lniCvxGRS0tcqvpVwuBF
   rFcJFJmfEXWupoBNYq0DeykooVvcDhwXdboGLesvozBlYs3KHIuX/TPwK
   sOnnksRH6uUr0gY6Uw28qGT2CeCIxVGdolG2HZODmB5qnCfCUwRBnZh2K
   W6GJx4ivD5KGZclHVuZcrXauXAUGUfSCsKAvhUhlmeRBS2LBGZZWzheQ0
   2fgDaUNmm25+FXUyce7clBcdGfaTet6a0twICDmGrOujQXX2aXv59gNDy
   w==;
X-CSE-ConnectionGUID: tMP+FXAYTxKEXmuBEOoqjA==
X-CSE-MsgGUID: n7aH/lxXT2q7KeGnDlCsfw==
X-IronPort-AV: E=Sophos;i="6.11,186,1725292800"; 
   d="scan'208";a="29398710"
Received: from mail-southcentralusazlp17012054.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.54])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2024 18:52:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwQH3h5pzGMVlERNHApSjOwS9tFZq5gik/yNJJBg5vLhRujsFCIc/J/8hr3jV0Yo8590WSedQUwb8sTWydAs7+/fPcKQeEC9B8RlbhVnhsqw9BjyT07GwS58D4r/NnYt0vWkMYFK+Yxu9o/uKCmXP03/V7pj4XhbCUV6EE1ckAWQZokiZJIJG/VnhAaZVMXQ+FcUKmmSNp7u/IqUX0A+KbHjAYH0KRWbnTqhrz33p1F8AMhoQ8p93YIqB8VUe3EfdOU3hi12IyS1ihTQji8kMX3Iu8BMoZlqmM7rBDNCqg6Q9NDqi+oNEer46SWQqHg8Z8uqT8ghgIPVts8zQGC9Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IirUZvH/9XqAnfEkAHoJ/JS8ebi2UEz5c4IHewlIch4=;
 b=dz519fdDJzuN+2bAsxGPRl6/cUANPwiKBJecUOHbOflszOz6anFiRjJQCtbpLga7hv0vDKFdFpsmypanJypFf4v3ebb6odlW8S0omLJ7cZCj2tmFcFACmSvm5+KvhTtahNL5Aq5+y0gEGT3e1RmgVsIZwq/t99eGi3OneTFDtHctOBTDHTEa/rYzSFjMGyr5otQBhWPAv0aCaooRxjlOgQmjvxEyTam02rig9BI+unlMz6+d7H8x9Q0/zmchSirm4H0O/zNPIqxJPNBDhyHnrtEDnsYkMCuIqmDQ338cvxdmrEp79NNP7i5PPhKb0KIPz+tB8SKx1CV1jGsKe2sYCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IirUZvH/9XqAnfEkAHoJ/JS8ebi2UEz5c4IHewlIch4=;
 b=s5gy7y/8y5DofiJ/gq200Re8qaz5xkDwe8WMiwJoQRpn+r96d5TJkNY6phDpP5WzBVOXgp6/Dkejm4jOMKTs1AuM5VFQOAKgThJFiSo7KpWqYNoqPlyLEZWjcodcZhI1BsC8HNksPGvebX+RdE9hOzue65jqDxgEyEl1IubqCyI=
Received: from PH7PR04MB8755.namprd04.prod.outlook.com (2603:10b6:510:236::8)
 by CO6PR04MB7553.namprd04.prod.outlook.com (2603:10b6:303:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 10:52:04 +0000
Received: from PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b]) by PH7PR04MB8755.namprd04.prod.outlook.com
 ([fe80::4372:e8cb:5341:9a9b%4]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 10:52:04 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: "zlang@redhat.com" <zlang@redhat.com>, "djwong@kernel.org"
	<djwong@kernel.org>
CC: hch <hch@lst.de>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Hans Holmberg
	<Hans.Holmberg@wdc.com>, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH 1/2] common: make rt_ops local in _try_scratch_mkfs_sized
Thread-Topic: [PATCH 1/2] common: make rt_ops local in _try_scratch_mkfs_sized
Thread-Index: AQHbGXAcQGX8i/zoQUuJrX58FKfjUw==
Date: Tue, 8 Oct 2024 10:52:04 +0000
Message-ID: <20241008105055.11928-2-hans.holmberg@wdc.com>
References: <20241008105055.11928-1-hans.holmberg@wdc.com>
In-Reply-To: <20241008105055.11928-1-hans.holmberg@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.46.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR04MB8755:EE_|CO6PR04MB7553:EE_
x-ms-office365-filtering-correlation-id: 57750f83-ca62-4208-0358-08dce7873f0f
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?rhxPT54vrmw/1nLq3kDULEip7LgIyGaHpup0D6KfnCIQFXWlWYvnBotuiH?=
 =?iso-8859-1?Q?EUQhzPZvXXOCs82qCmLU5Pzg5MH0uNzi6N+obm6PzhlJMX6CBwMgHUXpJj?=
 =?iso-8859-1?Q?LFugSknfZlANhh/n7g8tc4WPUP0RDEeUDUsXmQEwZrwcO/7VTFq6oFbiwl?=
 =?iso-8859-1?Q?3JVYs7UHa7Lc05gQ2tP6Gdi6c9eBhzEvexeZ3G7nY9NFlGtPl4saRr+Sxl?=
 =?iso-8859-1?Q?3pTmR/DaweAHS4A+xYqGt7Tf5J3dlyRGfesiJ7iyiAsnTyLgobs/Hk6kQc?=
 =?iso-8859-1?Q?CVi2vgjtYHmyFVWFVJOs4L7trlrFVWdK6OqZOxsGdaX+WebNVABpmTV8g0?=
 =?iso-8859-1?Q?E6ABACkAlveuXWFjq0e4I0y58uQF/W6QmDi+a1Q7BuAcGH/GAj1qFV85pG?=
 =?iso-8859-1?Q?R7UX3zNVPg6y+d1dVSueqjb+rmN8ZhhhZ2pNtx4q35U8RHt4F9BpLewCbU?=
 =?iso-8859-1?Q?ILMl1fNj5zPdSypKniDkKnKsmXlxhVw0+EeCbiJ9bHfHjeCMb9uo54mEQs?=
 =?iso-8859-1?Q?YGFWDM8zExGUrrWPhd44XDD3VwXssfQe1+/l0tGxuviuKYRGL0SddbaQpy?=
 =?iso-8859-1?Q?w4hnLD3IKJmBANrclgFYpPAXwx7yx7OLRCALAahNoyeXEvELgy3kMtbNaz?=
 =?iso-8859-1?Q?mV7o32LfMET82rvJNsI3WLjz3fEON8oFEiRCk2IpVCeKh5ZYwi+PmhYRc7?=
 =?iso-8859-1?Q?8Jv6/D2ruLFJMnt4MfM11zGHG2PN3/xGpQP+xdFH3iXeXNUt30MFfsWeOf?=
 =?iso-8859-1?Q?5LnAfnMAMcKD5NOwGMfhAwcJZczxiE9UVnl5F8ZfDBmK/HUtfvIMOfjna2?=
 =?iso-8859-1?Q?KEveBsvVwUrTbxfXoYyKCQzIZq9rwQ10zzyaz/+2jGFFZOWBxZko4V6Tpw?=
 =?iso-8859-1?Q?D22h6/cG1YFzRZ9IQD0rkIWht+xp/mzddu4tcNLFYyGtzBUNmTfX8YNYc9?=
 =?iso-8859-1?Q?6Sy64Sv9z6XZNt9LZZ5Qa5AZEp7G4Ls3AM6kPiWwJ/PTxe3kmxUVilxaCT?=
 =?iso-8859-1?Q?HJqd5JhDH6l4cBFdLHsFTKobo0AJ5/HzZjL4xMWtYT0Cxvg6hnc6KxDqsb?=
 =?iso-8859-1?Q?L6BDeKpJoxiFBRL6SC5bWUi+D+ZJBh44KFdS7NMKfY9EdaQqvIGLtk3L2f?=
 =?iso-8859-1?Q?BX9Xy6GWSlwVrCe+su5LS9qX6EDzr0fWOtIo1VT1lXZYXdhRORqSUJsJRA?=
 =?iso-8859-1?Q?CjYsZAbB+UDOrZwKhkMfaN2bSnF8AQ2MtK1dRmEWNHZd/VaoARn1rvLJBh?=
 =?iso-8859-1?Q?KSZGy9uTQAaM2ZidqES6Agipb5Vxe7bRm8jYciN8s4VOc4koaC4TMcOHml?=
 =?iso-8859-1?Q?O8jw71kKWiCDgdL3hJ3ekwguUighuzfFML33MOGT3ueJjgbwue/ADoXDY3?=
 =?iso-8859-1?Q?C64VykdrlGHnx8ilJFre0rcilWGYABFg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR04MB8755.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?QCl4w+w4oF/YcvfRD3q+wScg9YUcoqIWQud6jeOcGyeYlQrexi+YK015cW?=
 =?iso-8859-1?Q?A1ZiJBtjbuX6aFADR15G4O+e06iX7d/zEmbhCMiubE8cwLKG7u8crV/FN5?=
 =?iso-8859-1?Q?C9Y1QE9r7AkOMRwYajaUrhepcDh7sWnjDPwvAaQWtQfaU34L0O9xp8AFtH?=
 =?iso-8859-1?Q?moJ5nbqBwoo5K4olQX5Qu0bZzSUSXfNLTat33PpKYp00mpEYGRNmQcu29I?=
 =?iso-8859-1?Q?duVQULogXC15iTLkTFunoieDnp/FWnxkpDJf8E1B7/cULeyB0iGm4gbKJW?=
 =?iso-8859-1?Q?BpghjZoBIE0PSU4go17tbaV9Gcw4/s3oBOlWmUZeXf4+6sVn/fMD54jGsO?=
 =?iso-8859-1?Q?GtySGaON2ZxE4KH+bv4Ndei+oeL31MUZlJWZo9TPyGUEy7h3LsuCUlc/Mg?=
 =?iso-8859-1?Q?oI+fpBGunteU/7QViBQlU3erYUbXyxXaeo9J+Q/EVcanEmSnJBA61b9tn3?=
 =?iso-8859-1?Q?3FaS5jfoHH9MyFxw9Hokj08F3zFXwSAAJMXOLL7gfymp+LCxkDD4Th1bQt?=
 =?iso-8859-1?Q?SyGKtQMuRcR0/CddIuUVSaq/wLGGAJg3hwb92tMD4Gnpt4qFZRmsGObkzE?=
 =?iso-8859-1?Q?AwGgwNlDVfl5wNCzQ4JIqSVFd7b1s/03Oia7s3U39kDe4RAMI5HtYjZPDO?=
 =?iso-8859-1?Q?n7Fsp6ehkt99wl6IwvQrotbncgnnEtCvw/io7GqP2+1eKwEKcuz+PGjBRp?=
 =?iso-8859-1?Q?n5TyN4r7qeWaK4cxhFehdlwwPLsIsbu18YLndEzkU5HYeohgQ94u5axq28?=
 =?iso-8859-1?Q?RBHBjfWtoblZV+jVmjgdbtkJ1FBT488IvKpZt8N68/YJ7QEaOS9QuURPbG?=
 =?iso-8859-1?Q?VoFADHeRuRTMBc3AO+mJVPkL4ipidfRK1WOLcyjaWNeDtwrsj05SLG39j/?=
 =?iso-8859-1?Q?FC9ylGgGhl9jfkKrxDeGhahVF7W0JXubbG84sIrJoSBo6V8/gqpDFxCKh7?=
 =?iso-8859-1?Q?ixnkU8ZqAUXii+C/oAhpDBRXUinTntRUmF3FRBo3f0SdVKdqQhypuKxnr3?=
 =?iso-8859-1?Q?dlmcSziSVZyorTJA9ZQU2M3+BZ3SiJVLNqGM5EokuTc4KCestnAFENwQX3?=
 =?iso-8859-1?Q?Njm9Fo9G3dA6S7xIfXZKXqeD7ujxhI/lvQXNM9/NozHmVuh5vTLW2rHjSo?=
 =?iso-8859-1?Q?XLsQMvBCR7njWdOdauMeOAIS/AWKrxKVt7qsVGh/9zo5uFUWH0lhxHrzBk?=
 =?iso-8859-1?Q?vmQmwzRf/WqEYg6GI1Jb75BY2HMT47tNnFt2hPmuEORq4MxbxC+bGtACHc?=
 =?iso-8859-1?Q?giBd+CmnYasgdCTTMLl87u2MYt+nrpGt5dWhqxdOeYGyxLjC2FUsmPupYE?=
 =?iso-8859-1?Q?AJ7we1aRnNAbaxxrRRGlTxJAcdY6OTUDdMNV9VtA/29wbmo7aN7z7cuiJO?=
 =?iso-8859-1?Q?0xo6rOEoYF/q6d80sZR5xgpemMzF+0EWv4dtLqbBBMRhjVDjQRwhqqlOFm?=
 =?iso-8859-1?Q?KJbfy3kIp7JNE2+gIZtmvS6dSSjG/v3gCQxpHplPdNhfGUcXKoHKBDKOBR?=
 =?iso-8859-1?Q?7+0ukm74ek6gbqoE3TcI+RkFXYUAJmtdnpzwA3fPGOSrN+Uc2N0EkGShFl?=
 =?iso-8859-1?Q?qjciwQJ7cLI7jgMAox0OhW9GRbZVjrJm8+43Gpc76DNUK/g0wpR8wBRZKy?=
 =?iso-8859-1?Q?nHjHSpDWQbgFlyPCLSjWRWnHR7b7siciew?=
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
	pYeDt6Xh/XmDYOuua4vrFTQfN0/4O6SPR1od6oX8sK44hOrInGEBAv8gqnl6S4ZXlvMy8q+evM5CG8KNE8ZXEiiCVqyBzZF/+CK1VPDxF8+1Nh0cpihtAxKKWDuprxI2OSd4W63R2dkWCmmUFFOZ4w/8nKdR1YlOQ2MMlTA+KuCMja3Jqdyb6c3oBo1sBDfVcxlsF8PNgPzn3E1zSyiEgZKX0UYCBD6G5wHxq/Do54hMDmiqB6ydlaxhOhqSvcVqfGJz9MFfXjmDKfHF68ycQKHOFkSPWRlK2xCCdQWR9ybS70yyrYKBQ1nqvyw2uPGjBi/MCCht746UG1pO7c3bPzp+Fd6tmio8sp5Lob+yYvZT/sLQzSF7Z2qRMUtIBnLFQFnm/kuvOio5m8+fHkuQr+YlS1ivZZTGyfPVTBhR9F+iaZ/CLXU/vTxQdjyAH18qusRDI23rcOosmneCb61QKJB1kScSkJLgMDXkBkA20U581/FfU6YvgXfjrWvcAHIoE4M9L/F5nvcMXqTXwJUzydYFc0RJh1PZpx+dfp94HZqHiYc0e7TeoNC2xdn5pStjWa07LYkZNk1CiiJ205vJ5MdqmPTdEtGpsLG/7C1DN8URMwJuGTnW2wClltaVmA4i
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR04MB8755.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57750f83-ca62-4208-0358-08dce7873f0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2024 10:52:04.3467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YKZDWQy1ow5csh1BcR476r3D6bvSIkI2Lnp59ZMg3spFPeXozySNDPjalU6uf06pT3K9wkX7g0VP1k/vZgcgMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7553

From: Hans Holmberg <Hans.Holmberg@wdc.com>

If we call _try_scratch_mkfs_size with $SCRATCH_RTDEV set followed by
a call with $SCRATCH_RTDEV cleared, rt_ops will have stale size
parameters that will cause mkfs.xfs to fail with:
"size specified for non-existent rt subvolume"

Make rt_ops local to fix this.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/rc b/common/rc
index 35738d7b6bf3..c9aae1ad0b90 100644
--- a/common/rc
+++ b/common/rc
@@ -1030,6 +1030,7 @@ _try_scratch_mkfs_sized()
 	local blocksize=3D$2
 	local def_blksz
 	local blocksize_opt
+	local rt_ops
=20
 	case $FSTYP in
 	xfs)
--=20
2.34.1
