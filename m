Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F757EEF1
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658270; cv=fail; b=J/z79a76t0Glk7smOzwzZFgmnCL+64lyM5wXZp0+ccTgORnmmaXkN+uH7RDugEgRbxCLb3Yt9XAXJyPKzJZTZ6EuNwIlDs8ounHLUSOKRXQtq1yRJ81hNkd6z6s3vk//Bv6EbfiQmsugZfnrdFQ6sCMo0Ab5LLEQpogkIGTFndc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658270; c=relaxed/simple;
	bh=LHOWXE2WP6oiMElo5LkJVNOub3UmqdtG8Zt/tp0azSA=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=gVlSwcC4belsjHd/dlh7tsc2lZSbqgj0ml7G9cN33DFiKaoor9p8gEDsRsKI2gvHQvg11M9nqTf7YfVLtN91rdZUfSL6dJ4EHPrW5GBORAU7FbhJxTpf4b4HTvTtjA3Mw1JvRTlHfAvKsrj4d27EIse6qe8JZxfs7A2fY1B2Ul0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ezz6fE0S; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dp8S9j7z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ezz6fE0S";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dp8S9j7z"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxUhn026019
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=f8kQRzRcC1YEKqMDl+zis7xzbnnCfbWha1Eh4YVFWU4=;
 b=ezz6fE0Suq9PoRrHMkB6QWquOlvyKm7x8SE1uSwrAy38grK+8aGH+ZFSpoi9pgjrIFgO
 i2klg8X9B+UbiPvm/y61dvh0ZGw8g8BupM7u0tk9Ef2xl7LtHDlTnvGhcV1BCRx4FXon
 WEp5gaUTqRbl/oOxa007loGWM46P12T8NLWsFxEJRQ1Yb/irEz3BVIJr/Ps7gxMr0/Qa
 o3OyjVHnSCn+3x0bcPHw2rCdPphZia4GYuSSaYPvxDBiE9mcL/kBwevT1bQdytkw4zWM
 iqr6fGAvtLkyiEbPIpYb1j7k6SHunlGjQ/zCZTMTF2ooqAd/1bV2jbHnVfzXEB5FCfrS 7w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcghk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMEG30014646
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9e97jw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNE/z2ieaiA6GfTCEG617vtsPg2JFXfQZYfArOSCvHnOtYvJqzctR7HuSOScJwIx0HXMfU207/PeQ121CQLoVTYFoSU4dlPRk1uEeRd5j/mMZDy14HZcPF8Wh9KbDBX+oE/oD9eZ+EA0hx0im0JfYKvHUdN2kmnGyyrM8nYVeqC6OXWb7Bzl/u6HkRoDXvMnxTcD7aCcyumaYRA2JsH5BBC2SAvfiNwTKY1tY9MCUjWyEDQVGi8g1JAhOdO4xUGW4888iug/3gGBHhG9o8mq8eSk6nRShU6jzyg4b3O5yX4CQmTdVF3o91Dif/aIKEWTIk//JHGPksqKihp4FZtVrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8kQRzRcC1YEKqMDl+zis7xzbnnCfbWha1Eh4YVFWU4=;
 b=hO/uJAN2ZFaMVpJJdElYQdnv67oD0bNXles7Qp9Fu/oRJF66FCOrMTnT0FiBT5Mz9pB1zHYgxQxZU/liyg4eS0osZR7H+VozLZMxPIr3OdqGZlM93MM6MfaKnkQO4FBMSw0MvJDlxfuPT4vfSomrKFRm8iyEvmKmWKrRSNE27ijJ3EOJt2+KFbO+YdJGQjOrhf0Dm7c8/EY5aijjCy0eOqq2XQrbhqFWtp/wUdNZcj6YE11sXD80Xqf52rcTM2YOG1U9v+MPVvvwfhGsfALM6IAk9pAbLDryfsX0c0OaPokCQV6qgOiruaf3DiepFfcC56icv5KATZ+pFHmO+Q3/HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8kQRzRcC1YEKqMDl+zis7xzbnnCfbWha1Eh4YVFWU4=;
 b=dp8S9j7zO0wbk7GM29u55uy04SfQhwDsQTVBnFpnJBSo6LBolqOeMjbOpcS8oyKYuJP1UoNyDc8Z2+PSazMLwBjXTocHue267GHA79RqZiPXF661aCyCMkgp9iZ62lKEdGUSKv14jfSFRpq34aE2APpaU2aiuMvxvjWnJc0C4YE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:21 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:21 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 00/21] xfs backports for 6.6.y (from v6.7)
Date: Tue, 30 Jan 2024 15:43:58 -0800
Message-Id: <20240130234419.45896-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR21CA0005.namprd21.prod.outlook.com
 (2603:10b6:a03:114::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: ddd8f0b2-2ff2-42ea-9382-08dc21ed61a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	V4se0KYFsfmbtbIK0Xy5PkfUPNmbey5Moxq77BLBQgCMzWmMonMRnEsi5PERLATK/VEOsHywdoBMeIjTmSItmFhy52mmjf11aZgyGNftoy9c6WloLKJKxJNBHT2ZfCsoF02rXAPWKvqArgb0DhlraVuF8iY14RemjjEbiNcHFm1onJnW3tpuMkRqtZjkshqeKa/hfNvNJS+vzKX/U8s+NWBFJNuPptRbUfMkXaX90bZJVPYKlkRN/DKsHb1C35run1fB41avrvK0cyNVX5T50gi+iyH1GN7O39V3tlaa541wxYJD63i0RP2BAzRbSHUnP2FTE782VcP/YElqzyOgdBZV9/gwFJ+TuzVUvZ4hn5QkcRHIDq8Ynj+WVG6kY5B5I3s7MPBVyAxs1EWHjSiwyl7BbMnR2mKz9whaZeXVNU+gtrX5075CuQYzcgXCRg9jtLxdpV/ZCigk8LQ8TBre3S3z56o/O/1v+wWwnSOM6A5cNkA/lBk8sTI6aZrabKxtG9cSeG91fH5vwauAa0fMv5RPxWIv6Qvws73z/RkfcxOHwN010tyB0CvjEdkWES1zegFaWiE7WkFXKaO1edfftWyAYFhP3akh/8fu48pqEGPuo51yxZaeWIiJifjeSLrk
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230173577357003)(230273577357003)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZEhZU1Jma1RMZEZPVzZlU2t4NUFlZ3dhMTdtTnNPTEdScGp2UHoraWdDVzVT?=
 =?utf-8?B?aU1xTXdIQ2lVdEI5MlY4NGN3d2VMTE5ZYkQzVm16OHBSeUhmNVBoYm9xaGk5?=
 =?utf-8?B?aGZuM0tlQlZiNnNzZmI4TFNZRHZuaTBkZE9DcXZWYTg0Mzh6cFBQZVJzMGU1?=
 =?utf-8?B?V2w2WFZKQy9wbm1pVE5tL0FNUlVab0xDNmZrTUwzTytjWlVtdkRhL2oyaEd4?=
 =?utf-8?B?OUN1MEtMVmh2WmxDMmdwWGMxMEJzQjgxN1RSQlFWTnVodWw4RmkrSmE4WEhX?=
 =?utf-8?B?V3RjMGdacktXcEJwT3JxRmtHYW9MMG5IdXF5QWU4MnVmZ09DNEljb3JrS3U2?=
 =?utf-8?B?cmc0Q3VHWTRaQnY5VTVpZ0VJRDFQUU5USXE0dnFEWWdGUUY1UkFsakJibWpw?=
 =?utf-8?B?Z1doRE1XQkRJaDUycGZhcWJrb2xIWkphMzZRRmgzbjlTQmwwMm9LUlZHcllT?=
 =?utf-8?B?OXo5S3RWTmpoOFpiVXUwc0dNU01VOWNGL2pnQWJxNEpBOTVvOFZYWStpYzFH?=
 =?utf-8?B?SGJ6WktpYTRBcEZKem4xYjVycG15RWtBVWV5WnJFRFdoWEx3ZFhUYXZTemZW?=
 =?utf-8?B?MzhoVlMyMFZPSzEwNUFOL3JoeXhvaVhsR0E5N2RHd1RGd21FMk1zd0RNWWRm?=
 =?utf-8?B?UzNUYmZvRHdHZ3dFdmxBQVk0SHZzWkJwODZteHpTREVOWFV2OFhRSWpHaG1V?=
 =?utf-8?B?VE1FdElrNWpXM2Y1YVN5bmdTd2Uwc1VmYWcwMjNiMEtMMGpBbG9TclI1YU5v?=
 =?utf-8?B?NDh1REpZOVpmQXEwUHQ0S0R1b0kvb0NEd2RDM09wb2dEZ2lmSTNlNlBQWW9G?=
 =?utf-8?B?T1JTd2RWVjZ0Z0thdi9yYlAvLzlKck5wK0crRDM3STNBekdkM1kyakVFL01p?=
 =?utf-8?B?QUw0c2loS3BCWDVvNkcyMUV1NHpqL0VQZHZLbVlpbm9Qbjd2ZnZ3azl5akNL?=
 =?utf-8?B?cWw1d004WU5pUE5NQzFPalFBZzJEN1NyRnIydENBUlV4YVZkS3hjMm5tKzJW?=
 =?utf-8?B?NkFORHc2QVBBOGJGNzc3VlgyWFFyQmdXeUdaVGovU0tBc2x3dnRMSFBnV3dx?=
 =?utf-8?B?S0s0b1RMMG5LMVN4ZHk3SlRSR213KzlEa3FsdmN1b1hDYURFeUp0cjQ5UnpD?=
 =?utf-8?B?SlVvUmZ3TVBEdjV1OENNcXhLbWRvanU5OVpkZHlTNXlPYktxYzN6ZUphOEJI?=
 =?utf-8?B?UU1DL3IvdGNyRmdQTFZ0ZEw2ejIyWjhobS9ZSllKQTdqdS8rQnl6azFnTnhz?=
 =?utf-8?B?ZTQrcEtsNTFPT0xaMks4dFh6SGVtNS8rVkZhblRUVHczS08rRUhvdzdyT1hO?=
 =?utf-8?B?Zk04VlBTeVpkZkxIMjVRZW5pdWk1ZGx0OU5nay81YnNzdUF6Z2o0Ny9tbVRL?=
 =?utf-8?B?cGhFUy80TUROTnRMcXpyYlhyeVJ5WGdTbmlzaENhd1J0ZXNHc1FQZW5lMGxX?=
 =?utf-8?B?STI2UUNNeVptV3pHUkkyaHVLQXI3ODlYRUVDdTJqMDF4cjQ5eVpMaUJWcnVo?=
 =?utf-8?B?NVptUXo0N01RY202RlNsV3ZZVkQ5bkU5TTF1N3hNZmo2MGZ0NjFBWVZjTkRH?=
 =?utf-8?B?WmpJRld4c3RCVkkvZEpUdUJwRmJFVGd2UjdOMmVuM2toTG0zVTNLOUQwdGY0?=
 =?utf-8?B?eG85S21abTdGbjBqVDNXNmF4QUxnS0dQQzdFck4rMHo1VEZpQ0lxcUE3dHNh?=
 =?utf-8?B?UjhGY2JzTUFkSXdra3FMWTZzMGpZMFlFRXEwc0lJbHJXZ0tySnl1SEpUSndY?=
 =?utf-8?B?M2VXb25zOTBDdjdtOFJrTlFGaVdDZnVkRTRYL3p5bGxCdjZkdTgyKzJuTUpG?=
 =?utf-8?B?dGxwSHZWc2pUWXhSK21WVmFJVjlYK3JrRTJER2hNQ0Q5R3IxUHJicnhsM1k4?=
 =?utf-8?B?SmJNQmR6dUIyT2VYT1dTbzZxY1M2bG9pa0txU2N3SzBOWDJKQ3hjcEVEK3Bq?=
 =?utf-8?B?b1g3VXozdmovNWpDTXduSHZoSzR6NTVwTndZWjFoS24yOFM3dXVoZmtpRjE1?=
 =?utf-8?B?L3hOOU5xVmdKTFNnckxlMzVLVzVCNFE0VXBzR0NKdk1UVC9YRzB2aFFjbW1Y?=
 =?utf-8?B?V3p5WW5nbVNoY3loOGRwNnE4bXZuT2xUYklOL1pXbC83TGdndDYreDJBK0RZ?=
 =?utf-8?B?S1NHQ0lNdktoWEZVbzFQcjQ1Ti9MWUFRTG1BeVpSeGUzQjRtWjh6UWY4Q1Rw?=
 =?utf-8?B?b1hnc1QrekhJc2dVRTdXbEpVeHQ5UU9INCtGb0g4YXRiY2QrSW5xeHFtbjRZ?=
 =?utf-8?B?enBpRTJTa3k4ZmRqN3ZkdlhUcmxnPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RybGrvdY6hQLfPo0XFGNUN18jzvEtxcSgSgUfqSqOTXZyJlvgnlq5gkw5bAkb4ms+nGzvZm0rSqiIKgo23E4FExkwAAGtcH4LWssRjUcTHKmL9ShGIdu+6l4LGJJtR11RD8OdlBJNo2SdZDJYTqn6HSLitSBA93VvKPmIu0uJs+vO5TzpdP7GFvqT4sd9Z16/dvKipDI3bz97HKgpNWLGHoqTj5ZioQ1TklU3uqbI+HQ21MGWDvqfFFlV0U4i1XlqoSUuz3i/z82bv941qjxb0vuGyJ9ILUhE1Ej/oNs7/jjoTzQmwWdiBN+TRsies80v9f3pow/C1BbitGT6tI8lzOeEe4vGYM6hdjwIgQB4kICnBuEGRIPrO0V183oxHd3KZj1scX2TprXjv+LlSp9w1MLcDkjjDKRZi4jRca/CvZ6VGemMXxiGwfN4mevZCk0r3xSgcS8hzj3q9zb2vLYYAyKFzt0sP+EbCvyoD5RAXrDJVNpDdbNeghMU2JRF4E+Hd1nPlnlxRP3xWmwzUOHFKlbsziGgqFjAK3A41d5ZheDKUSthhq4AKBAl8bCYkuxm2WmRA0Uu3IGjl0eCJz7fcPVP98mT7IR6gnO0CZfmOI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd8f0b2-2ff2-42ea-9382-08dc21ed61a6
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:21.0511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1+Y/SNzKiiE8NShRI3vIaC95xaMBhRA3hYKAfuUsazyD22OTwA3mM6pqvFT+iJYfoKgNVL6PXUqqM+Qb2p7+D0xb5ZVBoMdyAolvUMYmao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: MikTt1wwNt5rS4-LAuQvE5jFi715KAnf
X-Proofpoint-GUID: MikTt1wwNt5rS4-LAuQvE5jFi715KAnf

Hi all,

This series contains backports for 6.6 from the 6.7 release. Tested on 30
runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1k and 4k block size)
4. Reflink without rmapbt
5. External log device

The patches included are from the following series:

[PATCHSET v1.1 0/4] xfs: minor bugfixes for rt stuff
xfs: bump max fsgeom struct version
xfs: hoist freeing of rt data fork extent mappings
xfs: prevent rt growfs when quota is enabled
xfs: rt stubs should return negative errnos when rt disabled

[PATCHSET v1.1 0/8] xfs: clean up realtime type usage
xfs: fix units conversion error in xfs_bmap_del_extent_delay
xfs: make sure maxlen is still congruent with prod when rounding down

[PATCH v6] xfs: introduce protection for drop nlink

[PATCH v2] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space

[PATCH v4] xfs: allow read IO and FICLONE to run concurrently

[PATCH v3 0/3] xfs: fix two problem when recovery intents fails
xfs: factor out xfs_defer_pending_abort
xfs: abort intent items when recovery intents fail

[PATCH] xfs: only remap the written blocks in xfs_reflink_end_cow_extent

[PATCH v3] xfs: up(ic_sema) if flushing data device fails

[PATCH v3] xfs: fix internal error from AGFL exhaustion

[PATCH] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS

[PATCH 0/2] xfs: fix recovery corruption on s390 w/ nrext64
xfs: inode recovery does not validate the recovered inode

[PATCHSET 0/2] xfs: dquot recovery validation strengthening
xfs: clean up dqblk extraction
xfs: dquot recovery does not validate the recovered dquot

add and use a per-mapping stable writes flag v2
filemap: add a per-mapping stable writes flag 
xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags 
xfs: respect the stable writes flag on the RT device


Anthony Iliopoulos (1):
  xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS

Catherine Hoang (1):
  xfs: allow read IO and FICLONE to run concurrently

Cheng Lin (1):
  xfs: introduce protection for drop nlink

Christoph Hellwig (5):
  xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
  xfs: only remap the written blocks in xfs_reflink_end_cow_extent
  filemap: add a per-mapping stable writes flag
  xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
  xfs: respect the stable writes flag on the RT device

Darrick J. Wong (8):
  xfs: bump max fsgeom struct version
  xfs: hoist freeing of rt data fork extent mappings
  xfs: prevent rt growfs when quota is enabled
  xfs: rt stubs should return negative errnos when rt disabled
  xfs: fix units conversion error in xfs_bmap_del_extent_delay
  xfs: make sure maxlen is still congruent with prod when rounding down
  xfs: clean up dqblk extraction
  xfs: dquot recovery does not validate the recovered dquot

Dave Chinner (1):
  xfs: inode recovery does not validate the recovered inode

Leah Rumancik (1):
  xfs: up(ic_sema) if flushing data device fails

Long Li (2):
  xfs: factor out xfs_defer_pending_abort
  xfs: abort intent items when recovery intents fail

Omar Sandoval (1):
  xfs: fix internal error from AGFL exhaustion

 fs/inode.c                      |  2 ++
 fs/xfs/Kconfig                  |  2 +-
 fs/xfs/libxfs/xfs_alloc.c       | 27 ++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c        | 21 +++--------
 fs/xfs/libxfs/xfs_defer.c       | 28 +++++++++------
 fs/xfs/libxfs/xfs_defer.h       |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 ++
 fs/xfs/libxfs/xfs_rtbitmap.c    | 33 +++++++++++++++++
 fs/xfs/libxfs/xfs_sb.h          |  2 +-
 fs/xfs/xfs_bmap_util.c          | 24 +++++++------
 fs/xfs/xfs_dquot.c              |  5 +--
 fs/xfs/xfs_dquot_item_recover.c | 21 +++++++++--
 fs/xfs/xfs_file.c               | 63 ++++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.c              | 24 +++++++++++++
 fs/xfs/xfs_inode.h              | 17 +++++++++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++-
 fs/xfs/xfs_ioctl.c              | 30 ++++++++++------
 fs/xfs/xfs_iops.c               |  7 ++++
 fs/xfs/xfs_log.c                | 23 ++++++------
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  5 +++
 fs/xfs/xfs_rtalloc.c            | 33 +++++++++++++----
 fs/xfs/xfs_rtalloc.h            | 27 ++++++++------
 include/linux/pagemap.h         | 17 +++++++++
 mm/page-writeback.c             |  2 +-
 25 files changed, 331 insertions(+), 103 deletions(-)

-- 
2.39.3

