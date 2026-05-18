Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EE43CF02B
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 08:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779094570; cv=fail; b=hD93KdzMRheXVC/Z5/XJDCPMQEimT/9ByEhKRhFaJD46sDef/+SYj9Us6UZZDc2GPNq9NFhS8kkZXWgKb4kx3dkDx3uLY406VBJNdULCKVYX98kTYcw7cybT2NyneueAbXlKR3uFCEIMqy1WgrKr+3sqmnbgoYRtV2H95lDkKUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779094570; c=relaxed/simple;
	bh=F1ICQYeH+U4QGvdMyEnaPAwhIP9LJgWI/JQ7inZYfaU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fsj2idxgH+wvRY9YYd2dZDL94iTvcQMoYcujpkUh4VAsWKeU0WK1cHRjhG4aosJFqQi7Z5zNylCci+Fv3oMpb1urPnfBoPQ9+KpBBL3neRN9+1cE3oSrYfItOQxME/oH/VtTTcFvCZaBdL9FLTfPFDks9gZI2niwY5veoxvlmGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KGMA+kTl; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=0CQb5hxZ; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KGMA+kTl";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0CQb5hxZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1779094568; x=1810630568;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F1ICQYeH+U4QGvdMyEnaPAwhIP9LJgWI/JQ7inZYfaU=;
  b=KGMA+kTlxlsq3hAErpjOeco+AkHDTKuQ4mVkt+NMkQxbSBwkmBRwKC3o
   Di3mNYtwgTbywpfLaIZi0nWcCADChoZeFDPNL53/i9/8nwTOO2oB6TkRK
   LJ/dTOI/OvJPdReB/7Iw48J1Ud7NDGlO1T4vcalIM4Hgn7zqHu59Tz7I9
   HNhP2hpX5jz1FH5GKa7kNcLAuq9SSAYMPackI+l4id/F2v3W4yCRY7XGI
   vdGBCYJ/Hn3daDJcUXs4XksV4s5Cd2W4tRC/6lXbMNZoKBLM851uVbOG5
   GykoLp5t9XocKrDmj8Ac6LMRNqkClyOQIUAKX/Ah1TTGLsNzR+6hFNmyR
   A==;
X-CSE-ConnectionGUID: rb7G48gZSkiylTzXLQnBFQ==
X-CSE-MsgGUID: NoqFxwqGQQKGtXBpNQ0Zug==
X-IronPort-AV: E=Sophos;i="6.23,241,1770566400"; 
   d="scan'208";a="143039193"
Received: from mail-westcentralusazon11010062.outbound.protection.outlook.com (HELO CY7PR03CU001.outbound.protection.outlook.com) ([40.93.198.62])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 May 2026 16:56:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kkUqNCrMW21pjdfQTXeyAEfE/EWcny59PmqIwhU87eitIjAQGiFRbAD38tHwc+eZruojOVvgUtiOiH25ruIUnI92g7MuLDtwzk6rJfwf4pOiUCMwRk9exls18GLj9UCJoG5LXXnLhk6JcFfbjokn6I2wDuBWIoqzuQcg2KW04dwqG/fDMJG7BR90mrFciZkaeF1WVSYtVGtycMgPy/y5TvxdgtvFwo3u9PNKAPpgK0KyX6nbTiJYUkARN6oQ4Pw3bNQRK/q3GFsjptvKyeE0nPRCNV+i/olUCkxsJtv/eSgfzLPHpu+8cDPgLeucUy8OcWl781dqGUDIfq9TEApfXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1ICQYeH+U4QGvdMyEnaPAwhIP9LJgWI/JQ7inZYfaU=;
 b=TlMVMBC8k/sxPs2WfvgHGQv8uv1deSUgZCXGe+i77WHrx1xju8MVveeqAERAxzMTV++i4JEyNXC/2trMwnT1fIp3rzS4Nv+LzuhfNAyawarrDuhjvCYKfINwY6Frqr8zcNnGMvbjotuigzj+847OMgdgCQvZs3AYFSYgw/oITCRoeLFPnzX1t4DFTmBls/YrfR/jKnKSfOo5ZO262vEPTBrEWd8z81xt2zWIkUZ0Cv/VjdbNEnamIFS1PL9EfhPDkbxs5kuwMEyhTu6cjv/ioKwKF6vG7AIoxX5ev/OC5OTEHBIzzoiPzW48EtFUkrMCb8nOzEXepJmrsRlyw7VKmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1ICQYeH+U4QGvdMyEnaPAwhIP9LJgWI/JQ7inZYfaU=;
 b=0CQb5hxZbC9gf9eScnzb8NtDFn4pWGZ6gF0A+4ZMJIRgw+03oFEXc3mH29+vYHjQWS6CLADBGRmUionpPQwVt2Pw0mVs/yLc2U50bQ5dSAPnWABoY9PGYcD/qew0Da/sPGJ6U4VNXXBfo6I3NztvKbk55Lv5mwZvHpLnfsasLiQ=
Received: from SA6PR04MB9269.namprd04.prod.outlook.com (2603:10b6:806:417::19)
 by DS0PR04MB8742.namprd04.prod.outlook.com (2603:10b6:8:12a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 08:55:59 +0000
Received: from SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94]) by SA6PR04MB9269.namprd04.prod.outlook.com
 ([fe80::f392:fdab:14ae:7a94%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 08:55:58 +0000
From: Hans Holmberg <Hans.Holmberg@wdc.com>
To: Dave Chinner <dgc@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Damien Le
 Moal <dlemoal@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: handle racing deletions in xfs_zone_gc_iter_irec
Thread-Topic: [PATCH v2] xfs: handle racing deletions in xfs_zone_gc_iter_irec
Thread-Index: AQHc5pLtZBEVxAwlpkeP3zS7gNWVJbYTaEAAgAAS4wA=
Date: Mon, 18 May 2026 08:55:58 +0000
Message-ID: <42149407-5702-4f8f-8973-28f3e705bdc5@wdc.com>
References: <20260518065224.9066-1-hans.holmberg@wdc.com>
 <agrERjRq10bm0rrY@dread>
In-Reply-To: <agrERjRq10bm0rrY@dread>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA6PR04MB9269:EE_|DS0PR04MB8742:EE_
x-ms-office365-filtering-correlation-id: 4da58bc3-7970-4f2f-1c6c-08deb4bb4793
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|366016|1800799024|38070700021|11063799003|4143699003|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 +KGH0msqvFn/AXYfOI5bbK0ZMPb+NssdWgKrxitQHN4Gp71T0uHek144FXJeF8/r5XGfYMi2ElugnXq2SIBdLhi5BEkndXS4oBvq5qLFCkeCr6PxJhat9vF3AHLDgwQ9fWWevZr6GMGfPo9Fp39RpDoycRbQD1h4CHjInkWr4aU/48C+LKkTeNUmLidcvBkVvP4yE1c3xQiI+N6dbqo2u2OKRYl9sD05oS3mPTh2Ecc3PgGLBVKnDzLMhV21FoAtUxvopS125wzac6109JfnCwIWxXyNimGUeMf3HAnLUoDcqzqmtbgKoF2XF7Cu6DeaJhUp/nDFPb+qIlzVOkxzhZ8JLuR+s/lFoK4Jp4iiOTycfirtd4lUK/fsNd8c+UV4oF0EZ7WemwHlLHRxX1mAImEvZFGZS/6A4PTVnAwuEkpd68Prhq7SlZo8FXn5tEwnyW6C/pKiodxLe34YfVEa03UCL2FaElVdKSuDvlFGMfnjz9YTPK5oFK8CpP0YC6hTcVdTSIppfkNll6xckXbjMySGvAu8eMxqWbd5C0XxjpXU55fd7oj9wobyJZ8tYH7rYObTG2+Evlo2l1Xt7/ztv5nwhxU+wj/Iapwm7BxT42vRevqH5IkpNGD3xaiNWF+At+lBajXdMWsQW++yCCLYKA6svnxcXF4bQtzW7DTQywO8rRdVCkyGuFLPtHQDsmR9cxNkn/LkFA8VpSiZeZq5fq6IAmXZZPjoN4gZO0JboQyakUqUq+XbpClx6PXfJoJK
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9269.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(366016)(1800799024)(38070700021)(11063799003)(4143699003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QUh2SldLa012RnZIMHl6cTlsWlpLWGpDa1NyQ2VnYW1ya3VTdGFSOGV1d3l5?=
 =?utf-8?B?L1R5VjcxZTgzTFZieU85WnZ6eEFwUVVONkxXbHhsNng5cURIM3E4K0hnSE1Y?=
 =?utf-8?B?WHliek4rQzhWb2t5Q3J5ekRkbXRwVnhJOW5peVBvdjNadEorQkJGTFh0d2c0?=
 =?utf-8?B?QVVSaXZLUlhSdFpFVjN4eWs3T2xnQ2FQN0JYNzdXeFJFMVRMY0R4Z2Y5d3BR?=
 =?utf-8?B?dzNNdWJJZVJxUGIxU1ZCUHdwaWRmcUxMSGd5VHd3ZTZTY1R6clVXTFBEYVRz?=
 =?utf-8?B?eFNINm42ZVU1NGNLeVR2bk8xOG5WUk0weWFEWVhteVNneEZmUjFEblcwRzZP?=
 =?utf-8?B?MmtMUnNmaDR1Y3hpa01kZUYvZzl0WWliaDVaV2pPK1diSmRZZC9KbGdPZmxZ?=
 =?utf-8?B?SG41ODhIbGR1OVk0SzM5My9FdnFrNUxCMUNpYnltY2Z1aHRKOFZLZkZBKzE3?=
 =?utf-8?B?YkZiejN3OS9XYmhRZ3FoWmY5STlpVHgzNnV1aVpINWwvN3RVb2xvcUpaVGEy?=
 =?utf-8?B?cjRXOGpzQlA4dUNLaHI3Rld2VlJLYnJTVGREVVRlTm9QbG1CSXhkSlJOMTI4?=
 =?utf-8?B?OU1hdnc0N0pUUG92NlRwUmxOTWs3MHRVd2dUSUlCQmNkZVYxaC82N1IvSmRi?=
 =?utf-8?B?V21GRHFUZ3dQVHhOS2QzVitJRlkzTmJvZVI3N2Z2VmczYitVM3JrUUYyRVJm?=
 =?utf-8?B?MzBiMnQrM3NhdUtxa3RNd2RuNS9aV1JNYlRXTCtadE9EYlhCZ011bEJlZ3N3?=
 =?utf-8?B?L1RsMDZ6aGtybTRDbjNKZ3I5S0JZVWNIQW5kOW5KSWU3OHVzRXFNd1o4aGZq?=
 =?utf-8?B?anBvTE1iUkFzcjZRWEgrM0V1eHZNdS9CY21GeUdwRzBoRFRGb1NWb3ViRXNh?=
 =?utf-8?B?S1E1SVNtZlozSHdISi9kMzBoVXg3SmpyRkZ5NWNJdlVGQmxRM2VGaUJqMnVl?=
 =?utf-8?B?Smc0TzYwQmZ1NEZLWVNxL3JXSzhvOGZ6VmMrTmNhUkZ5QXF4T2lLZlg0K0RI?=
 =?utf-8?B?cXIxNTlheURsaVBtZVFOL2EwRmM2eTUvYUhtUkJIbGVHN2x1VlJMSUYwUVJt?=
 =?utf-8?B?c1pCemNXNkE2RDM5TXZzMm1EZEU1eStxMDFaR3lzYnVaTmk3T1lLTFA2NFBY?=
 =?utf-8?B?RXJ0dDVWcjBucDFoQmFnYitrRG9XamZsWlZMR29IQUJlOHZRU0ZFd0xNWkVs?=
 =?utf-8?B?bCtTSXZmT1dJcjhrNnVUWHYvcHQvN05yNXlEVTg0cHRHL1ZlZVpRMnplZjRT?=
 =?utf-8?B?RzZLY3RUajJPdCtsVk45Z0FmNWpNbHlQdzJsdmFoOG5aUmdXRWE4SHowMjFJ?=
 =?utf-8?B?UGFFdHVOdHdnTmVMSUVUek1VdHo4SGN3NS9WN3NrTTg4TTNuMGd3N2p6cDl1?=
 =?utf-8?B?eGVzWUpCMHlzdjdFMUl3OEkrUEVNUXM5THoraDJmbGxjUW5xNkNJWjNPQmR6?=
 =?utf-8?B?LzFGNGUrbEw4UCtpU3pScGNWN0NpSnFWdytPWHlFVzRtdHJhNkxhYmU4Z0dB?=
 =?utf-8?B?ZUNWYnpzSmtQcnE5ZmJMUEhQR2hNVkVvZWtZQTJQSitaY1ZCMzRUVVFsdjJt?=
 =?utf-8?B?ekc2b1k0bk1waVF1NGpqQ09uUkp5eWdTekNDZEJlc0h6SFUwZjNGaUxFY3Zj?=
 =?utf-8?B?bnkxZUhrL0FtUmpzTWU3UEUvd0J4RFM5VFlsZUhXNlUzaTcwMm9rSHNkcmtS?=
 =?utf-8?B?UWI0M0tJL2tndWZXdEY0djF5RENDV21hcmRBbWQ4dDlna0dYVnR2ckRubFYz?=
 =?utf-8?B?TStEY0ZBL2g5VWJIeFROUU1oMHRZNmlTWlRlWkg1YzlhWmNYdEMwV09vVGkv?=
 =?utf-8?B?SlpRSkpMSVFRVnc3QzErTzBmd2p0dVJseWRqampmbDVPYlpaOXFLWm10UGtG?=
 =?utf-8?B?QUNXejI4Vy9sNlhSRWNyQU1VZmZWcUJyYnZhWmRMSG1hemNvVnV2M1VYN2tk?=
 =?utf-8?B?b0tjMHRqcWFQM3czWXZuUEZrMlM4ZGxsSUYxekFqdzZjZVYreWNnMkFFdUIx?=
 =?utf-8?B?UzFFNXpMa2dIbE44T1k3cFA0cU1CYXgyakgyN3psTDZscWV5dHRGaGYvY0Zk?=
 =?utf-8?B?WUdRUEtCQzNyOUp4YjdVczhpeE9ubzRTRnpHQ0l3QUUrUmRtRndyQ2pGUUll?=
 =?utf-8?B?a2w5ZWYxM0VvZnNxWm9SeUVOQy9FNzFmdGNQTXRFNkRyR3lwb3VCeHJaUjIw?=
 =?utf-8?B?ODUwN0tvYXNxZ0M1dGthNUJ1MHpmK3dFWmh1R2w1WDFTNG5VQStZQ1o2ektS?=
 =?utf-8?B?OXpDY0Z5U3QvcitzT3loVVYyZmxrdk1LRHdMZWx3QmZiVjRtVHBoblVMckZZ?=
 =?utf-8?B?YXRvZzhwZ1dlT2V5WmwxR0Y0SGlJbjN3eWNHVzNDWmJselF1OUVuZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A1100EBB1F3A84A8B61E35CB371162E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	WcKWG8KMR6r4FKBPn0W/dCUUyBw/vy5dtmtYoLrBbeGcswVB+bJsCgnjobMj76k1HE0aGS2aT++PktAwj8S8mABKvD4j4WAH7n+SEF9PDxlXisc0q1wr5C1K/aweve/xl7NZh9PwOpq8Hvpbb8HbcDkggIOdyv7XiQgAgTHG4/2Ge6qbDKsbbIQqZc7QB0eIWKCeGSrbVlcoJ1PJERbmC5ksqXzjGB1nuoq1LuBjgfxSbszxX97Xs0gwBn4q5HUGPsjYgkIiy7nRsNOwh8gvZPyvJ6NPNuQuBpXwUjJCsn3duWeR6BJ37TVcyl1CcqdUbfCV2Bvdnb1hEIL1ATgDyw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	v+jY2ak4o0rVs9kq+nReBN92HY3dHT3Ie5n39ENc163IiRjZhwEM/rWVBBfPQIT6YX0oRZyicXBndz4NHxRttOXbpcY26nNcmZ0tp1+ffcI3nxUTJGvqgipDSRQnM01jR4+D0SmlT+al1pbVKy3TsNwb1kFtUcbNVB16LPEU6yNdv1fAvIfh1amolSm5nEIY93bbrrZtoevjQ6EhnxZb5w/W8DxQuzGoE/jp0AlT0sxpfXRiZQU6zY1Vpez6J4ILwBl2Rp+EqWEB+UyRdtIsBiMiBkSM7KMO6AgvWmWPl9i3MsJ0Qv9+QGn5JSHp2c6mJowwT1FOG4R8bFVn5SbqsMeFQ42lIMRgGzIlmwo51J/SZdR+vVwpk69y+Iyi+K7Y0Y2xHEKfjzPvzvUzZt0H9GUnjKCT2W5LRrFItdfw2pE16V3iNQNocIN28B8s9TxU8H//mm2oWoNIf4DqMW1NaDYjyR67JpuiEGotXlmvGF0hzCfAIG5Uunj4hn9Gm9y+YN2pGf5fBB2DTsSXTsN4U0+O0jPMh5XG3CtEoDAu9v1g2wcjsKrMPyZ65Sb8HmLyhmI3h3AQXOZDUlrRW4Rewn22GlS3Qei3WAs0jeu60ij4aMVL6hwZpGoVB5MkEeAz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9269.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da58bc3-7970-4f2f-1c6c-08deb4bb4793
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2026 08:55:58.5566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xi12Ahk/q6J4Z82oEdBDXsXdI4yPWiUA1KyN9oBAbAzoAwp836KaaX80VTmeM1yy+S0jRQ3zBJOzA9mSiXGCKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB8742

T24gMTgvMDUvMjAyNiAwOTo0OCwgRGF2ZSBDaGlubmVyIHdyb3RlOg0KPiBPbiBNb24sIE1heSAx
OCwgMjAyNiBhdCAwODo1MjoyNEFNICswMjAwLCBIYW5zIEhvbG1iZXJnIHdyb3RlOg0KPj4gVW5k
ZXIgaGVhdnkgZ2FyYmFnZSBjb2xsZWN0aW9uIHByZXNzdXJlIGZyb20gUm9ja3NEQiB3b3JrbG9h
ZHMsDQo+PiBmaWxlc3lzdGVtIHNodXRkb3ducyBjYW4gb2NjdXIgaW4geGZzX3pvbmVfZ2NfaXRl
cl9pcmVjIHdoZW4NCj4+IHhmc19pZ2V0KCkgcmV0dXJucyAtRUlOVkFMIGZvciBkZWxldGVkIGZp
bGVzLg0KPj4NCj4+IEZpeCB0aGlzIGJ5IGhhbmRsaW5nIC1FSU5WQUwganVzdCBsaWtlIHdlIGhh
bmRsZSAtRU5PRU5ULCBhbGxvd2luZw0KPj4gem9uZSBHQyB0byBzYWZlbHkgaWdub3JlIHN0YWxl
IG1hcHBpbmdzLg0KPj4NCj4+IEZpeGVzOiAwODBkMDFjNDFkNDQgKCJ4ZnM6IGltcGxlbWVudCB6
b25lZCBnYXJiYWdlIGNvbGxlY3Rpb24iKQ0KPj4gU2lnbmVkLW9mZi1ieTogSGFucyBIb2xtYmVy
ZyA8aGFucy5ob2xtYmVyZ0B3ZGMuY29tPg0KPj4gLS0tDQo+Pg0KPj4gdjI6DQo+PiAtIGhhbmRs
ZSAtRUlOVkFMIGluIHRoZSB0aGUgY2FsbGVyIGluIHN0ZWFkIG9mIHN3aXRjaGluZyBlcnJvciBj
b2RlDQo+PiAgIGluIHhmc19pbWFwX2xvb2t1cA0KPj4NCj4+IHYxOg0KPj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgteGZzLzIwMjYwNTEzMDYzNzQ1LjgwNjctMS1oYW5zLmhvbG1iZXJn
QHdkYy5jb20vDQo+Pg0KPj4NCj4+ICBmcy94ZnMveGZzX3pvbmVfZ2MuYyB8IDIgKy0NCj4+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZm
IC0tZ2l0IGEvZnMveGZzL3hmc196b25lX2djLmMgYi9mcy94ZnMveGZzX3pvbmVfZ2MuYw0KPj4g
aW5kZXggZmVkY2M0NzA0OGFmLi45NmYxNGQ4MTFkYjIgMTAwNjQ0DQo+PiAtLS0gYS9mcy94ZnMv
eGZzX3pvbmVfZ2MuYw0KPj4gKysrIGIvZnMveGZzL3hmc196b25lX2djLmMNCj4+IEBAIC00MDAs
NyArNDAwLDcgQEAgeGZzX3pvbmVfZ2NfaXRlcl9pcmVjKA0KPj4gIAkJLyoNCj4+ICAJCSAqIElm
IHRoZSBpbm9kZSB3YXMgYWxyZWFkeSBkZWxldGVkLCBza2lwIG92ZXIgaXQuDQo+PiAgCQkgKi8N
Cj4+IC0JCWlmIChlcnJvciA9PSAtRU5PRU5UKSB7DQo+PiArCQlpZiAoZXJyb3IgPT0gLUVOT0VO
VCB8fCBlcnJvciA9PSAtRUlOVkFMKSB7DQo+PiAgCQkJaXRlci0+cmVjX2lkeCsrOw0KPj4gIAkJ
CWdvdG8gcmV0cnk7DQo+PiAgCQl9DQo+IA0KPiBXaHkgZGlkIHlvdSBjaG9vc2UgdG8gZG8gdGhp
cz8gSSB3YXMgZXhwZWN0aW5nIHRoZSB1cGRhdGVkIGZpeCB0byBiZQ0KPiBkcm9wcGluZyBYRlNf
SUdFVF9VTlRSVVNURUQgZnJvbSB0aGUgeGZzX2lnZXQoKSBjYWxsIGJlY2F1c2UgdGhlDQo+IGlu
b2RlIG51bWJlcnMgYXJlIGNvbWluZyBmcm9tIGEgdHJ1c3RlZCBzb3VyY2UgKGkuZS4gdGhlIHJt
YXBidCkgYW5kDQo+IHRoaXMgd291bGQgdGhlbiByZXR1cm4gdGhlIGV4cGVjdGVkIC1FTk9FTlQg
b24gdW5saW5rIHJhY2VzIGluc3RlYWQNCj4gb2YgLUVJTlZBTC4uLi4NCj4gDQo+IC1EYXZlLg0K
DQpJIGtlcHQgdGhlIFhGU19JR0VUX1VOVFJVU1RFRCBiZWNhdXNlIHRoZSB4ZnNfcm1hcF9xdWVy
eV9yYW5nZSBsb29rdXANCnRoYXQgd2UgZG8gaW4geGZzX3pvbmVfZ2NfcXVlcnkgbWF5IG5vdCBi
ZSB2YWxpZCBieSB0aGUgdGltZSB3ZSBjYWxsDQp4ZnNfaWdldCBpbiB4ZnNfem9uZV9nY19pdGVy
X2lyZWMuDQoNCkNoZWVycywNCkhhbnMNCg0KDQoNCg0KDQoNCg0KDQo=
