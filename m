Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E101822CC
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717178013; cv=fail; b=YbOh2ClkNxcv0gGqyvA0geNV/uGYBqexo6SxNVSZmR1QRAzEXjFj4yJxFq9UPCC24e14u1QWJQOtw/ypcoWnaWX9dOG6QBilnF8Oo4Mj4b6ibRMmCouZvqQgMu+irfyJgLeRoV3R01kgAgSai2VETU0wuQBpLUVmHxCywkTqnE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717178013; c=relaxed/simple;
	bh=W3/I1CFnh9xUv81P2ywX4hu7xaxZ873wqDIPCNTpTTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HI50WIDTeklTU2SCRniVpclMzdigrlUfcdwGURwEPavbgIx8WWfGb75ycEOrmcC7qm3Er/CIx5LlpBXFpjMkX1HwCXsNMqac2b3ezxnyfiE8IRTtducZ4i7WfKpkxCORidroXz1H4b+PZfrcGDP9Zcgi0ZYDXIsI9VRWhRdAPis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V9VWgg030176;
	Fri, 31 May 2024 17:53:27 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DW3/I1CFnh9xUv81P2ywX4hu7xaxZ873wqDIPCN?=
 =?UTF-8?Q?TpTTA=3D;_b=3DK0u9B+j2OAjyDW4QVRyadfV+zQDtQEnEldt3RatVwraIycGzD?=
 =?UTF-8?Q?RizcsA9vxm78kTmpCWA_Nzo/atyFgVR7N66GCcQnArXgNt1yLnXj6cNTVFX6U2S?=
 =?UTF-8?Q?SUQKhalrXe0MjWWjDuzweOgyl_svNdjDx6QriK94/86VJF/9Zutk0h40tCVa3Ue?=
 =?UTF-8?Q?IFcduLex9fUawj8MTMT6vcugr/n3o+w_Bs7zMq+rSqFrNeZ/z7/Y83ZcauUe/bs?=
 =?UTF-8?Q?JVDb6mC57ji4A7b7zH424AOuby0dWE5v1q4tx_DNunbLHTBCaexrdW1lgufKZFq?=
 =?UTF-8?Q?ca0/EWAGda03OEqQoolsC+zwCPG1wjxOlvtSKHs9d+z_uw=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hgbqwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 17:53:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VHnpGi026551;
	Fri, 31 May 2024 17:53:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50a61r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 17:53:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HV4lE8nmBCflpxshaiWqfgJEMkV7sKUgUOoYZyz1Gaag3+omhrv7zrHelKajeiuAZbMS3fwVaueZFvPCZWJlDx/8XfDPbJrvFDzuwoDxuuxYk1zyYTpR++ZNOMxANxXwOL7IM8fo2NQ7slQ2kdtmpfmR4+oR4qLxtAEzCzrLNqpuahJPJ5cBwPfzJ0Mr4KwNAHaIYirerypYnF4EXzNacgsvQQbhSDY1SE0wJNgS7UTExAwR0TLiLulpVRq2XFnRxbtKSsTuOrN/ro36Jvm9oM3sr/fYNfhm0PUDyR7uPbcna9oW3PmcCZdfcYjhSevAbAJOF4boFIlNi6fPQZM1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3/I1CFnh9xUv81P2ywX4hu7xaxZ873wqDIPCNTpTTA=;
 b=WUdpNPIJDbE4R4+A1xmz4dHkf6D4iRlHHxD2fFqW6JZV23yT0iA37ooZwmuG+mSnKGGCuhCpmrN3cVFPmSjqQTYZCAUDvr5Nk9g2svNyoJl8FAEk6nmMV7xL3fZi4gz9G1JKQhQrldi1+/qb3Ho/hd6Jzghh5d9fjRq/Ar0wsR+eDoedpFMGuOCohPnsjs9O0lxX770bj3DAJ5lk0wzvDnH2L13NOcpna6YUmVMZAuX0RPwD/fC8orhHfWWMPQn7FoU6OygQd6hrLD24IbZQ2cUGBGh021+nG9Zb0DquBJyiwAMFRv/Hck/6eg0XZzUq6vievP1GuR19/SmdTiouAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3/I1CFnh9xUv81P2ywX4hu7xaxZ873wqDIPCNTpTTA=;
 b=fq8RwFILYg9w191KEKCq5i+HykHQIUP04QkLrPA7ml51Jqn5AhJpkg3wd8U1E9WjberjU14o1Upb1DjzG7QpzR12kJj2FFV32qzCIh3UNESdnGH7BhaN6VRqZ68toO3U2aiCzZftqPg/yLZZon6aZOyR0imH1xRQqHCSugKRSYA=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DS0PR10MB7246.namprd10.prod.outlook.com (2603:10b6:8:fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Fri, 31 May
 2024 17:53:23 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 17:53:23 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Topic: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Index: AQHaqKDf/Bk+8/H/PUavladS1T7uCbGgcEQAgABMSACAENmfgIAAH2OA
Date: Fri, 31 May 2024 17:53:23 +0000
Message-ID: <B19C20F1-CFD1-47A3-B0F0-F69C66CD58F7@oracle.com>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
 <20240520180848.GI25518@frogsfrogsfrogs>
 <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
 <20240531160053.GQ52987@frogsfrogsfrogs>
In-Reply-To: <20240531160053.GQ52987@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|DS0PR10MB7246:EE_
x-ms-office365-filtering-correlation-id: 7bf4dc36-b9dd-433d-d0ee-08dc819a90ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?a21wREpMWkxURTU0bnkzN3V4ZWNWV3Y3cEZHMmdtVXo2VzlWZEE4Z3FRaXZ4?=
 =?utf-8?B?YnlyZU9ZSWhJZUpvTjE4c0VvNUVVYy9yYjBQVlhJSVJxU1hCZ0dGV3JCbS81?=
 =?utf-8?B?K1ljVnhzYSs3Z2pSWStsYmhqL2RxVWk2a3lVWXFmeEpoUWNRK3RvV2VpZk9B?=
 =?utf-8?B?QzJITWpGcUdmbmVtc2VPME5QRkw2MWY2UnhHLzV3YTVRM05wVGF5S0dnYWtr?=
 =?utf-8?B?NkNUWmFVaUZqb3Z1ZkRON1RpTHV6SzJrRTZCRHJleGtHTTNWMHAxNzMyTHNV?=
 =?utf-8?B?TDhVRmxiUThoSzdxMVdueDJoeGNVdHpjOGZtdUJvUkYyU3lCSWJ6MU1hRUlp?=
 =?utf-8?B?TkxwcFF0U2h6aEVhNFhlWk5OTlRUSk9tSmtRWnBvYUMwemNkYUlCUE1zSGhn?=
 =?utf-8?B?M01YVkVjNVhOdnNvazdpeGtFajJqeEZNVERMNlF0MGFucXV5S1hQTDcyc1Q2?=
 =?utf-8?B?ZEJvdTJ0QW1Zamd4YThMMHlXVDlFcjJDTVd4YWk0UDlhdnMzeWFzTnM2Z3BO?=
 =?utf-8?B?dU5wN09BTlBRa0RRb09heXJFaVJsSElleFNEWDhiT0RvcXhDZFhLTjU4Qzdt?=
 =?utf-8?B?emNFbWtDL0kvdVlqYmE3MlZhM0VkcFhqV0gzQUFDVjNWaXhrRXRyT0hLWmlu?=
 =?utf-8?B?cDhOS0laOXV1ZS81bExaUW5DQmMwUnpmd3cvenNncDBOSEVVR2FlNjUrSkhi?=
 =?utf-8?B?TG9JVlNCR1p0emlrc3dEb250Y0d2MjRnYlVnbThoNGZxVFBjMnB1b1grVkpj?=
 =?utf-8?B?dURXQ2Y5dnFFUjVwYzYySElTTUxueG53VE1lc3NSYWFBZnNzRGN6bXNhb3Ev?=
 =?utf-8?B?NFQwbWIyeEZwRlg3NkZJSHRsWXBydzRhR2V1Qi9jREQ1WnJiQjVyeG1PMVFq?=
 =?utf-8?B?Q01ISjYydmVXNEtZTmF5TE5hSEQ1TDBGLzQwWm9WVzRZNkRhTnZza3dvSzh1?=
 =?utf-8?B?c0R2TnQyc0R1UmZCVDc0bTRyYU9VTnBrSGVBV0F6UXVBeVFodXYwaGUxK2dI?=
 =?utf-8?B?dUFlSGRhTTJCaUJERUI3cW1tMFhXa2FrMzV4MWU0eVZZSDhDaWZneXoxVFpy?=
 =?utf-8?B?YllVd0w1eTR6ZGJtOXdQQlFMdzNYZjhTWTFpZmpJOWd6QVdyTGtCcEdNcGZs?=
 =?utf-8?B?bU9QR1NPRG9UWXBySDkwUUNnUXdHWmhZQWpqUzZ1YTB4allUQnFFTXdhMzQv?=
 =?utf-8?B?RHhrRS9RVmF4TE9ySEMyN2xDTmtOMkpzWGR0bGhyb3JaNlRnRFdhZUNRdkVH?=
 =?utf-8?B?bGcyMFN2NllSNDJ6RjBkTDNGMEt5SmltL0VIb3o4Um90RkpzbmRtTExMSmNZ?=
 =?utf-8?B?V3Y4TWJzVmFBQzFpMmhVNEFnamFsL2phZkhJYmNJOW1kbFd4V2FSVWlONmlK?=
 =?utf-8?B?dUlZSWVYdkF5Y09QY1FXM2ZXQVV4YUpXWUVMUEJzb2NyNFZBQXNwb29kWG4w?=
 =?utf-8?B?L3g4Y1lWaWJJWjJNZHIxSCtwY0djNiswTWEyZkdzZWNuVkh1dzZubVduTjc0?=
 =?utf-8?B?V09wblRqTEJxVWZiaE5PYWxSdDVYcEViMm9OV25zNkthNVprNzh2UTRDRGN0?=
 =?utf-8?B?U24yalVHWDNyUDJBSEY3WTVDZnhuZDZHOURmcDh5Ym1KS0JaVTZsN0FlM2Fu?=
 =?utf-8?B?Y2NDOXlpMlVhY3NkeFVuTXoyU1YwaWtpVC8xem5nYzYrVVFIQ0lKdGNkOUEy?=
 =?utf-8?B?VWlOSlZ5dGg5d0VKMHR0dkY1RXV6L1p4VFhDVDVHT01rM0hzM0xiVGpBZGRP?=
 =?utf-8?B?ZnVRQzFiVlgwZjhMWFlOdUQ0QmVxVVNZSWhnajdRZHVQc0VycUtNZUtWVXNX?=
 =?utf-8?B?TkNRRU82T21qWDk1QWJHdz09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?RVhnUTJ3alA0SERXZjlxbjJveU9kRHRkdUtDa2VsV1FwT2N6R2lTUjJOdEJB?=
 =?utf-8?B?dVdvVE5Cek1OeUdIWTVjNjVqeXdsbkkxQUJHYjhGdjU2T0J6b0ZJSnNEREFF?=
 =?utf-8?B?dGtpdXRTbXErdzJIUjl2U3NPWGg4UDMwYUVFQVFJckdnaHRxaWRnNmh5WGsz?=
 =?utf-8?B?SW14dVRBSEFra2NrTGcrdWlpaG1ZRDNjVVpYbnVWN1lLQnVmTklYRVY3YU5O?=
 =?utf-8?B?U3E0RVVGNDIzdm50TTNTSG1lSU5wNzFJV0pLNVltK24xMk9PZzY3SzZ2bzlo?=
 =?utf-8?B?b0JwUzNzb3MyWVRtT2FTVjhYZ2NCeW1HU1Q4aE5zYllUWXAzNUw4bGdVdDhR?=
 =?utf-8?B?NHdSUVB4QlFMTk5RMGxyUXZYNm5USVVhVWRQUTl2QmZyQlFWOFpRNEVGeERH?=
 =?utf-8?B?ZmY1NWQ2UCtXMkNsaCtFSThWbE9YNjEyT0tCVFlzbWZmbTZkZ1B5NWliendS?=
 =?utf-8?B?MDJyQVBhTHhrUTBrRGJPZlZ1LzNEUDllSWovMXdvVHV2bzVSb2hhQXNhN3pk?=
 =?utf-8?B?MkNEU0RQK011eWtsOTJxYmc0eEdEbjBkaTQzNHg1N2htRnRyVnNUTEQ1Z1FY?=
 =?utf-8?B?cUxrQUtaNDVYeXMvYmNtQXB0OUZES2hsekxtVW1GSGtJbm1mREdLR05iVzNx?=
 =?utf-8?B?UVRZWWJxNVJqT2VVRkd6Q0RNOE5DVUtwRUUyempsYW5aM01FZWhGSmgvV0Zt?=
 =?utf-8?B?WmhORHZxYW51YWkxT2U3bERtSHhRM1JyZm1PNkZ5ckUrTWMvM0E4eElUOVBB?=
 =?utf-8?B?ZThuVFVhN3l3QVFDUWtpaHJIT05IWjRmenNKRmU3WkZXR1FQeEgxUkNNUWp1?=
 =?utf-8?B?UHg1QWZjT2IzTEFyeFBZWmxHdmMya3JMVzQwVmkzMlNNOE42NXRBZDFKdTdS?=
 =?utf-8?B?K2tWL2I1N2J6TjRHczViWnRhYnE4Vm9saXliWHNmeE5QNmF5WXFaS0dVWm9J?=
 =?utf-8?B?ODdoVVlVVk95dWczY2ROSlNNdzZZdGp2VXN2eGczd0hJdFcwckRkNndTMjR2?=
 =?utf-8?B?ekZlM2RaSU9ycGJTdTdNYjZuem5yU1RsaVFuZ2g2OTR0Wkc4QS9XMWpXWWht?=
 =?utf-8?B?NGc4WjJzTlRGTkhtTkNkNkFXUFVLU0xRM0FvREdkeVpjR1d1OHhzUVNvQjNR?=
 =?utf-8?B?cnZXeGhYdnZSRlE4M0VhaXpvbDUrTXIrc0w3Y0ZxdjVhcStlcVVkTUJrbWt2?=
 =?utf-8?B?Y1dMR1BWRGZnY3FVK05IblQ3VGF0RW45WFdMMXRmc0R1UXlHWVo1MlVBWGRM?=
 =?utf-8?B?TnNUZ3ZaK2duejlNQW1sUjN2ajNsb0JUUXdkT2xaN2tJbWd1QUxSYjJVQVgx?=
 =?utf-8?B?QnpNbDhNZHJXTjh1YWFNZEdnQzhmdWpyb0xTNTZUNzZoejhLRC9qWGpoT1or?=
 =?utf-8?B?bVVSOTBWZE0vRUNjTXUrWVR5cWJJdEJJUTNTZkhScmtxZHYxV2JRSm5GMjlH?=
 =?utf-8?B?OGVuVUpXbmFUa2lFa0hZZ3hiTXdZMHBKNFRUV0tPcFFZVjRVUURQSFhIaEp3?=
 =?utf-8?B?bXdNcEFyR2F4YjByMlFleXFKOW5SWXM5TWVYQnFnejZsZTJ1QS9DVjdmWDZy?=
 =?utf-8?B?QktPY25YYitlTFRvWFlLb1RKYi9DOGRra0xSVlppYTZVY2piTW1VcDc0RS96?=
 =?utf-8?B?aVd1bUFtNVpKbTFhS1hYVm12L1BGRmdlTHdDMjNiV3M0SVcxeERYaUhxaVdW?=
 =?utf-8?B?UHdvWjlCdE9JVWhKaXduamFyN3NXQzBJR3lWT1N5ZlFidEtSdDdPQmxWMjFy?=
 =?utf-8?B?TElNYU1Zczl2RWE4YU9jM3VuWm9kV3V4amlINVNyL1duL1hveW4xVmlvUmdw?=
 =?utf-8?B?WEgzNkx3Q09xRnRscVhzbFdqVkQxVWdQMnNxOWdmejhGQjl4YnNXYTV3WTBI?=
 =?utf-8?B?bElnNFpJSlFYd2pESm1LNk55eHE2d0EwYVpHc0xVdG4xeVFqR1hiU2poVzEx?=
 =?utf-8?B?UVJkTXZ5UXZnZXRLdHJPS2xMVXV3WXl3dXVnTzBJMTh5VnlpNWRrRWk5ZG9D?=
 =?utf-8?B?ZjFBSmdhcnpQZUlsM2pPa2dCenU0Qm1zMm9MbThYSFdmU1kxVHZGNHhENjFY?=
 =?utf-8?B?ZlNZemY2NGY3V0xBT1BYa3NzSUNNWjNqWkc4a3JVa1hyR0poZ0hpMUtaY1NJ?=
 =?utf-8?B?VE5XS3FlZksrQ1VYRzZ3Vng3eVpWNGFYS1I4V2ZoNmRlZUQwb21mRlQvenJj?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E87C5BE5DC58534CA74DC53698649A14@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LrxkS3J2/4n92a9B5gHBKlyXejIl/j1P42rrpeWLhasypZ07wrTD/qsnBkyEvdFMtBf9npnpQtDmfHGjoBXf3A7LBV8UhjFdLU3gfOZjcioykeytwYL5hYAGDe8Lh8Zhnp9mQJ4KcjjPyJrsIniQ4bUejdLOP8IXXTc70FvckhFToRT1Oh8mVjZ61P7bweZNuEXfBx5amvfdci+6t8Lx1R6eaF1qT9dOPMMuu0WbBep6gysVnz4oLErWrEQmg4fHZOyqwgz69shlMLGN0rkiar1PM3tVxntEn9+kbkNOgsX0//JmdAmbcNs5d/HEIlkiqI6UCs0f7qA3U4eyhvup6uf4n4K/Zv2quR3blLpUqPsQ9kJxTQBfaBQ3mozGjCBkjc5LVHziKAEfaB1afYzgXCH/YM5ZLpBRiE14hbSgucDQVF4R6UKg2gC+4XQeQvTz5B1KqgCVTxbOwgVe7OoRyhLwPF4pLDT/Dkq2WL3dv9bF0Rw35WpZsLeKmHykjeU7CCAMyPtP8u9RzaWHjOjBUWwmlPhfWopV8i/G/zWmImNExRggI8YuA80cbjaxgGgpcHeJJBshgXZsMP5buMchCmk+c/xZ7zXqcnP0ILhV3PQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf4dc36-b9dd-433d-d0ee-08dc819a90ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 17:53:23.6007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3jWCovt4q/LKrPLSBmrg3ZTlIlYT58qjcBuUvfxPvPodYtV9Pw1xhuXx8DA7zyxLgDoqTTke04XfAPOKWpqlp0njNlqRUJcLgf3l7wyslrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7246
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_12,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310136
X-Proofpoint-GUID: _p5045mHOWfrSxq3eOUV0rFcaZgmkt-a
X-Proofpoint-ORIG-GUID: _p5045mHOWfrSxq3eOUV0rFcaZgmkt-a

DQoNCj4gT24gTWF5IDMxLCAyMDI0LCBhdCA5OjAw4oCvQU0sIERhcnJpY2sgSi4gV29uZyA8ZGp3
b25nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBNYXkgMjAsIDIwMjQgYXQgMTA6
NDI6MDJQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gVGhhbmtzIERhcnJpY2sgZm9y
IHJldmlldywgcGxzIHNlZSBpbmxpbmVzOg0KPj4gDQo+Pj4gT24gTWF5IDIwLCAyMDI0LCBhdCAx
MTowOOKAr0FNLCBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3JnPiB3cm90ZToNCj4+
PiANCj4+PiBPbiBGcmksIE1heSAxNywgMjAyNCBhdCAwMjoyNjoyMVBNIC0wNzAwLCBXZW5nYW5n
IFdhbmcgd3JvdGU6DQo+Pj4+IFVuc2hhcmluZyBibG9ja3MgaXMgaW1wbGVtZW50ZWQgYnkgZG9p
bmcgQ29XIHRvIHRob3NlIGJsb2Nrcy4gVGhhdCBoYXMgYSBzaWRlDQo+Pj4+IGVmZmVjdCB0aGF0
IHNvbWUgbmV3IGFsbG9jYXRkIGJsb2NrcyByZW1haW4gaW4gaW5vZGUgQ293IGZvcmsuIEFzIHVu
c2hhcmluZyBibG9ja3MNCj4+PiANCj4+PiAgICAgICAgICAgICAgICAgICAgICBhbGxvY2F0ZWQN
Cj4+PiANCj4+Pj4gaGFzIG5vIGhpbnQgdGhhdCBmdXR1cmUgd3JpdGVzIHdvdWxkIGxpa2UgY29t
ZSB0byB0aGUgYmxvY2tzIHRoYXQgZm9sbG93IHRoZQ0KPj4+PiB1bnNoYXJlZCBvbmVzLCB0aGUg
ZXh0cmEgYmxvY2tzIGluIENvdyBmb3JrIGlzIG1lYW5pbmdsZXNzLg0KPj4+PiANCj4+Pj4gVGhp
cyBwYXRjaCBtYWtlcyB0aGF0IG5vIG5ldyBibG9ja3MgY2F1c2VkIGJ5IHVuc2hhcmUgcmVtYWlu
IGluIENvdyBmb3JrLg0KPj4+PiBUaGUgY2hhbmdlIGluIHhmc19nZXRfZXh0c3pfaGludCgpIG1h
a2VzIHRoZSBuZXcgYmxvY2tzIGhhdmUgbW9yZSBjaGFuZ2UgdG8gYmUNCj4+Pj4gY29udGlndXJv
dXMgaW4gdW5zaGFyZSBwYXRoIHdoZW4gdGhlcmUgYXJlIG11bHRpcGxlIGV4dGVudHMgdG8gdW5z
aGFyZS4NCj4+PiANCj4+PiBjb250aWd1b3VzDQo+Pj4gDQo+PiBTb3JyeSBmb3IgdHlwb3MuDQo+
PiANCj4+PiBBaGEsIHNvIHlvdSdyZSB0cnlpbmcgdG8gY29tYmF0IGZyYWdtZW50YXRpb24gYnkg
bWFraW5nIHVuc2hhcmUgdXNlDQo+Pj4gZGVsYXllZCBhbGxvY2F0aW9uIHNvIHRoYXQgd2UgdHJ5
IHRvIGFsbG9jYXRlIG9uZSBiaWcgZXh0ZW50IGFsbCBhdCBvbmNlDQo+Pj4gaW5zdGVhZCBvZiBk
b2luZyB0aGlzIHBpZWNlIGJ5IHBpZWNlLiAgT3IgbWF5YmUgeW91IGFsc28gZG9uJ3Qgd2FudA0K
Pj4+IHVuc2hhcmUgdG8gcHJlYWxsb2NhdGUgY293IGV4dGVudHMgYmV5b25kIHRoZSByYW5nZSBy
ZXF1ZXN0ZWQ/DQo+Pj4gDQo+PiANCj4+IFllcywgVGhlIG1haW4gcHVycG9zZSBpcyBmb3IgdGhl
IGxhdGVyIChhdm9pZCBwcmVhbGxvY2F0aW5nIGJleW9uZCkuDQo+IA0KPiBCdXQgdGhlIHVzZXIg
c2V0IGFuIGV4dGVudCBzaXplIGhpbnQsIHNvIHByZXN1bWFibHkgdGhleSB3YW50IHVzIHRvICh0
cnkNCj4gdG8pIG9iZXkgdGhhdCBldmVuIGZvciB1bnNoYXJlIG9wZXJhdGlvbnMsIHJpZ2h0Pw0K
DQpZZWFoLCB1c2VyIG1pZ2h0IHNldCBleHRzaXplIGZvciBiZXR0ZXIgSU8gcGVyZm9ybWFuY2Uu
IEJ1dCB0aGV5IGRvbuKAmXQgcmVhbGx5IGtub3cNCm11Y2ggZGV0YWlscy4gQ29uc2lkZXIgdGhp
cyBjYXNlOiANCndyaXRpbmcgdG8gdGhvc2Ugb3Zlci9iZXlvbmQgcHJlYWxsb2NhdGVkIGJsb2Nr
cyB3b3VsZCBjYXVzZSBDb3cuIENvdyBpbmNsdWRlcw0KZXh0cmEgbWV0YSBjaGFuZ2VzOiByZWxl
YXNpbmcgb2xkIGJsb2NrcywgaW5zZXJ0aW5nIG5ldyBleHRlbnRzIHRvIGRhdGEgZm9yayBhbmQg
cmVtb3ZpbmcNCnN0YWdpbmcgZXh0ZW50cyBmcm9tIHJlZmNvdW50IHRyZWUuICBUaGF04oCZcyBh
IGxvdCwgYXMgSSB0aGluaywgYSBDb3cgaXMgc2xvd2VyIHRoYW4gYmxvY2sgb3Zlci13cml0ZS4N
CkluIGFib3ZlIGNhc2UsIHRoZSBDb3cgaXMgY2F1c2VkIGJ5IHVuc2hhcmUsIHJhdGhlciB0aGFu
IGJ5IHNoYXJlZCBibG9ja3MuIFRoYXQgbWlnaHQgYmUNCm5vdCB3aGF0IHVzZXIgZXhwZWN0ZWQg
Ynkgc2V0dGluZyBleHRzaXplLg0KDQoNCj4gDQo+PiBUaGUgcGF0Y2ggYWxzbyBtYWtlcyB1bnNo
YXJlIHVzZSBkZWxheWVkIGFsbG9jYXRpb24gZm9yIGJpZ2dlciBleHRlbnQuDQo+IA0KPiBJZiB0
aGVyZSdzIGEgZ29vZCByZWFzb24gZm9yIG5vdCB0cnlpbmcsIGNhbiB3ZSBhdm9pZCB0aGUgaWZs
YWcgYnkNCj4gZGV0ZWN0aW5nIElPTUFQX1VOU0hBUkUgaW4gdGhlIEBmbGFncyBwYXJhbWV0ZXIg
dG8NCj4geGZzX2J1ZmZlcmVkX3dyaXRlX2lvbWFwX2JlZ2luDQoNClllcywgdGhhdCB3b3VsZCBi
ZSBiZXR0ZXIuDQoNCj4gYW5kIHRoZXJlYnkgdXNlIGRlbGFsbG9jIGlmIHRoZXJlIGlzbid0DQo+
IGFuIGV4dGVudCBzaXplIGhpbnQgc2V0Pw0KDQpIbeKApiBjdXJyZW50bHkgaXTigJlzIHVzaW5n
IGRlYWxsb2MgaWYgZXh0c2l6ZSBpcyAwLiBTbyB5b3UgbWVhbnQgc2tpcCBleHRzaXplIChhY3Qg
YXMgZXh0c2l6ZSBpcyAwKQ0Kd2hlbiBJT01BUF9VTlNIQVJFIGlzIHRoZXJlPw0KDQo+IA0KPiAo
SU9XcyBJIGRvbid0IHJlYWxseSBsaWtlIHRoYXQgYW4gdXBwZXIgbGF5ZXIgb2YgdGhlIGZzIHNl
dHMgYSBmbGFnIGZvcg0KPiBhIGxvd2VyIGxheWVyIHRvIGNhdGNoIGJhc2VkIG9uIHRoZSBjb250
ZXh0IG9mIHdoYXRldmVyIG9wZXJhdGlvbiBpdCdzDQo+IGRvaW5nLCBhbmQgaW4gdGhlIG1lYW50
aW1lIGFub3RoZXIgdGhyZWFkIGNvdWxkIG9ic2VydmUgdGhhdCBzdGF0ZSBhbmQNCj4gbWFrZSBk
aWZmZXJlbnQgZGVjaXNpb25zLikNCg0KVGhlbiB3aGF0IEkgY2FuIHRoaW5rIHRoZSB3YXkgdG8g
Z28gbWlnaHQgYmUgdG8gYWRkIG5ldyBwYXJhbWV0ZXJzIHRvIGZ1bmN0aW9ucy4NClRoYXQgbWln
aHQgaW52b2x2ZXMgYSBsb3Qgb2YgZnVuY3Rpb25zIGluIHRoZSBjYWxsIHBhdGguIElzIHRoYXQg
cmVhbGx5IGJldHRlcj8NCk9yIHlvdSBoYXZlIG90aGVyIGJldHRlciB3YXlzPw0KDQo+IA0KPj4+
PiBTaWduZWQtb2ZmLWJ5OiBXZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNvbT4N
Cj4+Pj4gLS0tDQo+Pj4+IGZzL3hmcy94ZnNfaW5vZGUuYyAgIHwgMTcgKysrKysrKysrKysrKysr
Kw0KPj4+PiBmcy94ZnMveGZzX2lub2RlLmggICB8IDQ4ICsrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+Pj4+IGZzL3hmcy94ZnNfcmVmbGluay5jIHwgIDcgKysr
KystLQ0KPj4+PiAzIGZpbGVzIGNoYW5nZWQsIDQ3IGluc2VydGlvbnMoKyksIDI1IGRlbGV0aW9u
cygtKQ0KPj4+PiANCj4+Pj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfaW5vZGUuYyBiL2ZzL3hm
cy94ZnNfaW5vZGUuYw0KPj4+PiBpbmRleCBkNTViNDJiMjQ4MGQuLmFkZTk0NWM4ZDc4MyAxMDA2
NDQNCj4+Pj4gLS0tIGEvZnMveGZzL3hmc19pbm9kZS5jDQo+Pj4+ICsrKyBiL2ZzL3hmcy94ZnNf
aW5vZGUuYw0KPj4+PiBAQCAtNTgsNiArNTgsMTUgQEAgeGZzX2dldF9leHRzel9oaW50KA0KPj4+
PiAqLw0KPj4+PiBpZiAoeGZzX2lzX2Fsd2F5c19jb3dfaW5vZGUoaXApKQ0KPj4+PiByZXR1cm4g
MDsNCj4+Pj4gKw0KPj4+PiArIC8qDQo+Pj4+ICsgICogbGV0IHhmc19idWZmZXJlZF93cml0ZV9p
b21hcF9iZWdpbigpIGRvIGRlbGF5ZWQgYWxsb2NhdGlvbg0KPj4+PiArICAqIGluIHVuc2hhcmUg
cGF0aCBzbyB0aGF0IHRoZSBuZXcgYmxvY2tzIGhhdmUgbW9yZSBjaGFuY2UgdG8NCj4+Pj4gKyAg
KiBiZSBjb250aWd1cm91cw0KPiANCj4gImNvbnRpZ3VvdXMiDQo+IA0KPj4+PiArICAqLw0KPj4+
PiArIGlmICh4ZnNfaWZsYWdzX3Rlc3QoaXAsIFhGU19JVU5TSEFSRSkpDQo+Pj4+ICsgcmV0dXJu
IDA7DQo+Pj4gDQo+Pj4gV2hhdCBpZiB0aGUgaW5vZGUgaXMgYSByZWFsdGltZSBmaWxlPyAgV2ls
bCB0aGlzIHdvcmsgd2l0aCB0aGUgcnQNCj4+PiBkZWxhbGxvYyBzdXBwb3J0IGNvbWluZyBvbmxp
bmUgaW4gNi4xMD8NCj4+IA0KPj4gVGhpcyBYRlNfSVVOU0hBUkUgaXMgbm90IHNldCBpbiB4ZnNf
cmVmbGlua191bnNoYXJlKCkgZm9yIHJ0IGlub2Rlcy4gDQo+PiBTbyBydCBpbm9kZXMgd2lsbCBr
ZWVwIGN1cnJlbnQgYmVoYXZpb3IuDQo+IA0KPiA8bm9kPiBQbGVhc2UgcmViYXNlIHRoaXMgcGF0
Y2ggYWdhaW5zdCA2LjEwLXJjMSBub3cgdGhhdCBpdCdzIG91dC4NCj4gDQoNCk9LLCB3aWxsIGRv
Lg0KDQpUaGFua3MsDQpXZW5nYW5nDQoNCj4gLS1EDQo+IA0KPj4+IA0KPj4+PiArDQo+Pj4+IGlm
ICgoaXAtPmlfZGlmbGFncyAmIFhGU19ESUZMQUdfRVhUU0laRSkgJiYgaXAtPmlfZXh0c2l6ZSkN
Cj4+Pj4gcmV0dXJuIGlwLT5pX2V4dHNpemU7DQo+Pj4+IGlmIChYRlNfSVNfUkVBTFRJTUVfSU5P
REUoaXApKQ0KPj4+PiBAQCAtNzcsNiArODYsMTQgQEAgeGZzX2dldF9jb3dleHRzel9oaW50KA0K
Pj4+PiB7DQo+Pj4+IHhmc19leHRsZW5fdCBhLCBiOw0KPj4+PiANCj4+Pj4gKyAvKg0KPj4+PiAr
ICAqIGluIHVuc2hhcmUgcGF0aCwgYWxsb2NhdGUgZXhhY3RseSB0aGUgbnVtYmVyIG9mIHRoZSBi
bG9ja3MgdG8gYmUNCj4+Pj4gKyAgKiB1bnNoYXJlZCBzbyB0aGF0IG5vIG5ldyBibG9ja3MgY2F1
c2VkIHRoZSB1bnNoYXJlIG9wZXJhdGlvbiByZW1haW4NCj4+Pj4gKyAgKiBpbiBDb3cgZm9yayBh
ZnRlciB0aGUgdW5zaGFyZSBpcyBkb25lDQo+Pj4+ICsgICovDQo+Pj4+ICsgaWYgKHhmc19pZmxh
Z3NfdGVzdChpcCwgWEZTX0lVTlNIQVJFKSkNCj4+Pj4gKyByZXR1cm4gMTsNCj4+PiANCj4+PiBB
aGEsIHNvIHRoaXMgaXMgYWxzbyBhYm91dCB0dXJuaW5nIG9mZiBzcGVjdWxhdGl2ZSBwcmVhbGxv
Y2F0aW9ucw0KPj4+IG91dHNpZGUgdGhlIHJhbmdlIHRoYXQncyBiZWluZyB1bnNoYXJlZD8NCj4+
IA0KPj4gWWVzLg0KPj4gDQo+Pj4gDQo+Pj4+ICsNCj4+Pj4gYSA9IDA7DQo+Pj4+IGlmIChpcC0+
aV9kaWZsYWdzMiAmIFhGU19ESUZMQUcyX0NPV0VYVFNJWkUpDQo+Pj4+IGEgPSBpcC0+aV9jb3dl
eHRzaXplOw0KPj4+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19pbm9kZS5oIGIvZnMveGZzL3hm
c19pbm9kZS5oDQo+Pj4+IGluZGV4IGFiNDZmZmIzYWMxOS4uNmE4YWQ2OGRhYzFlIDEwMDY0NA0K
Pj4+PiAtLS0gYS9mcy94ZnMveGZzX2lub2RlLmgNCj4+Pj4gKysrIGIvZnMveGZzL3hmc19pbm9k
ZS5oDQo+Pj4+IEBAIC0yMDcsMTMgKzIwNywxMyBAQCB4ZnNfbmV3X2VvZihzdHJ1Y3QgeGZzX2lu
b2RlICppcCwgeGZzX2ZzaXplX3QgbmV3X3NpemUpDQo+Pj4+ICogaV9mbGFncyBoZWxwZXIgZnVu
Y3Rpb25zDQo+Pj4+ICovDQo+Pj4+IHN0YXRpYyBpbmxpbmUgdm9pZA0KPj4+PiAtX194ZnNfaWZs
YWdzX3NldCh4ZnNfaW5vZGVfdCAqaXAsIHVuc2lnbmVkIHNob3J0IGZsYWdzKQ0KPj4+PiArX194
ZnNfaWZsYWdzX3NldCh4ZnNfaW5vZGVfdCAqaXAsIHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQo+Pj4g
DQo+Pj4gSSB0aGluayB0aGlzIGlzIGFscmVhZHkgcXVldWVkIGZvciA2LjEwLg0KPj4gDQo+PiBH
b29kIHRvIGtub3cuDQo+PiANCj4+IFRoYW5rcywNCj4+IFdlbmdhbmcNCg0KDQo=
