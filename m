Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029C779959
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658297; cv=fail; b=bjB9/Rw3Vs1H5F/vKOlJIZt92wnHletMsfDiKKx3SVbJ9PO+PrZWir/atLbgqdMWs0boiYio0iB3f2nZCtGDxzlKff12R6mghYaCRkvvEyh3GbaP4eJebGIzD0bliv4Pg4bsR/lDZvv6rWCiHbwpfWQK4FMp8Cng27DeocK3cu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658297; c=relaxed/simple;
	bh=yfz0oSKB2JIkPGiKR/CO9khBhcyXMWf4Wh+4Rkp3+8k=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SVLwsZ0m1xkttDnvWLM1BoVVReH6xMjCqlK74vPotx215EsWwawjPP0Fz7VK9DvK0/dm/ItUpJ+avnERFJczy6xBBXAFgmcID108EiB5jWPS/vhTnJh/CCjktf9wWu9kA6SWpQxJ0OQ9R2TnXnfGwYL51+Jb8aCK9xgVH4TfQ/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L+ID5R3r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=k6G3Iugx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+ID5R3r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="k6G3Iugx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKx5h9016946
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=jlnX6uAbZdB/vZF7HYgMZrK0ZqIondb8E6yvQsbDz0g=;
 b=L+ID5R3rDLdP4CfdWWuGBmMR8+IeufIkfh14suHYp9NLu+1AotO9aQxrPn37lffysOfd
 UCSKPJkQbv2Zd+wgaRivunWxrCkJWzbweB/kticDR96AU/rkwvrQ5+qLYSlQUN7DiBaa
 cRCTVIFM0JsZPmpN914f9RSbc910XhWQZqoH5xnKD/s0Py4TXwnKkHvSKjgCkHgbCu4b
 DaDMmM7FOECOD7WQ2c4A9HCQjSZnF7wKTWyqB5+MQaO1n3S2PsB0XlXG1bVlKjXRxq1z
 vQyS4HkzHIJMOEz8FsXO9Pq9RxuMtcacws0Uyb3OlEqpXwJf5GYGfw53jEnO2EI4WLy2 0Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvseugcmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM5M2X007770
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9eh1sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFcbd9hDx+fJhYklSweh03D7UgwOJB1YMPk0p54WYn5JD2wZXaN9mN4NhYvYc0cUVcang8s4d6lhesprDo/BeS0rfrzgQBa/XzTr7MBT0TCz+OF1wU7wFN7zW13Oenti+ydrDi4Aiaa8KRxbkjwdJPCxZEXuvdamrlCjvZ1QerQw+iL4nxLaSDrCQ7Vou3jvwD8ukEmQMjIlTmf7a5iwTcevkJ3p+SIL6XyEnONAKOu18dbv4BrYxT4IxgzzuN0uDNgMyT14aSjZRoxkoTo6zjZmWJrGMFPgtYvEEIlmko566DY/n90befz6ToZeNMmaHU0DdgZ9jw2DKv3NMxIwTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlnX6uAbZdB/vZF7HYgMZrK0ZqIondb8E6yvQsbDz0g=;
 b=Gsg2O2LHgX7qhiavbmM1B21u3H4WxJeHp8Wp4CzdN+MZ1ZCt9RWd50jxjO0DyjMGD7frqbxfZH2sS4Dy8O4M7mBfs+Fr2NpstCi5XtaCxLBLF+2vQCuTAlov3Ur7zy+RdRvXxJIJot5ReEcxqm30X74vZADnXHhOrHCmznEABgyJbXI6nbF1yhCR9yJbdx5/QWiMMHgfrohuWlGs3Ig2VcIpQBKKfgY5/+iYpwYVzsowTV5RtIACKIgvY/xJc4KwSTHRAM7mgvRMgJHLIsyMa7zWMFlCFnpwwhbeCkRuSRNF8Ezbd8PNtuHHEBjmh0VKO/OBl0naTSnYxoYewCh6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlnX6uAbZdB/vZF7HYgMZrK0ZqIondb8E6yvQsbDz0g=;
 b=k6G3Iugx0IWXpc1RKtEM8H6jrzdRUXLM2mFBNM4bYVFgCV2d95Rv8mV5+k3u8GxeRIwJtpJPKrZrQwZnfNPEs0uEVKmdIbyi25p+bq09wszMcAqwVqzc3zFR1smZh1CWR+EzPbcWsAisV6tfPrgqEPn0tD0kznME1dVNtlE1eqk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:44:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:52 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 15/21] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
Date: Tue, 30 Jan 2024 15:44:13 -0800
Message-Id: <20240130234419.45896-16-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:510:174::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: b47ea998-9a8a-4aba-edf6-08dc21ed7443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7MhhrPCCv85eAFmU2clZRDxEgcZapGWPfQwbmFJpD1RFU+0DuxDoGMaM+ygUTdSjKyxT4SsDhDAMcx8/RT2vHfI/EA8FLdM1xGteG67ooiT0OdZFfIW6Udf037Wr7qYiyTCFFyfwkrfX2yT7JdbMNWLx6i9XzZu5o0r1aoNiqSahSbj3XDf4etcy3m0AoLe9D1h2dbM9daspe1i7YZiJBb8GEOgOQR2eExBpCdY2XyIYVScmu84o4KHNpnCeVAipb9t80nP9tiUU2tbFK5D+zINvzFYrNmhBQrlBTXdtQF7cHo8oGLAPPibO5m37psL9VKXBtiTFaSmEwr8/8D06urGmh8g7P4zIPi7oOomm9ZF2mg9QYKFa66mXhjpu137dzpDv0mS25UJOEKXDS59cSKQf4wjWvsEZdNUborcr5Nfr+7/bOnXZjdu96B5BtbNKLabtLbZnTv2PSAVHBScYVqASHLhy5EMwgNYyTydMYBZz8Y/aSp5d3VQnLcRjHeopw/DCmbz01rJDczY/OO9trIP6Wpy6prvNOtn+tvEw0SXHgh/n0D4v9FeCgd6zyxFF
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66574015)(66556008)(66946007)(6486002)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?c0NUcGRodzdsZnBhT1lGUDRKZDlaTmVVYWZRa3N1T0ZTNDhnQTA4VXZHamtl?=
 =?utf-8?B?amJiOWp2OG9OWUR1amVZempXN2tGZVNaMmJuQkFZd29FU2RCNVc2eklTdnIw?=
 =?utf-8?B?NlNrcVlxSDZsT0poSWVMa2xRc2ZZRnZpWGxHY3dsRWY2TkFuR04zSG1mVHBN?=
 =?utf-8?B?Slg3akZBa2xyZlFIM3Q1UzhiWllmMlNPUTRJTW5GNmh2bnJnWStUeWJTRVFw?=
 =?utf-8?B?cGNLdncvU3ZpVnBuNFNza3BqMEJ3YlM5SmtQZk5nakJuQ2pHM0QvbVYrZm5R?=
 =?utf-8?B?bnNwaFJQWjR4YmNiaTRlU3N2RVFQcTVYNVRQbEw5akc1eDlJbmhISnhWbTRP?=
 =?utf-8?B?TnlsNmZQeUVqM29OMUhUWmhvK2NKRWxpL0czR3BnZVJ1aWk4WmJ4WTRTdmVI?=
 =?utf-8?B?bWphWTlVa24yUXNsdlhTOUFtREFtZFBXR1VLUi8zRGM3Ty9jeWRVNnU5VEpx?=
 =?utf-8?B?U3pmOWdqNzA0ekptL0Erd3FuRno4NkJWSTNRLzZYd05vLyswK0p2azBSajZC?=
 =?utf-8?B?Mkd4T2Y5dFQ3dGFXY1k4UzUvdVV4V0VncnNHV1ViendYYlR4YlRPYlFtZnd6?=
 =?utf-8?B?RU9aSTRRV1M5UmloYTNmWlhhR1MwMERXS1ZhYVE3MEJTdzRHOGQyRzdlMnJq?=
 =?utf-8?B?WEc2d3Naeno1NUlCUTQ2RkJUSjVhbTNicDRnbHkzSy9OWUdOMmF2L2txeng1?=
 =?utf-8?B?SkhrVm5wSUMrMU9SeWJBUnVkMlRvclhvV2N2K05ycGtjaGd4UTdDQVFUaWx1?=
 =?utf-8?B?dGloMDhScHROTkdRM042d3dVMjZaWkVpS1hEMlRyU0EvSzE4eWRpWS82SmdI?=
 =?utf-8?B?VmRoRXR5bjhkWkd2eW1UWXRwb3RtSU40N3VwR1NOVVZUYmx2S0RDdXpiSk9M?=
 =?utf-8?B?QWcveFhSLzdpd2ZUeWhOakVwazBwQ2tja2xDemhaWUczT1M1bEpLSFBxTkxD?=
 =?utf-8?B?VngwY2dXWlNERGVzQTVISEZlMEF4T05rME83Nk5BSGl5Wkp5UkZ1cm1CdkQ1?=
 =?utf-8?B?and0Y2lPUzB4MVQwWjVUYkUwWVFaN1RmTit6TlNFNFQ2K1dxbEYwNXI0MExi?=
 =?utf-8?B?MWI4SnlyRVM3bnprTmovYXJlUGl6bW5KNy9TUlNYWjN1dWgyaHgrS3I1SS95?=
 =?utf-8?B?cmswK2ppR0lLRnNwOUc5ZEZLRncrM2FXMldjOHcxYTBERW5hdmVlVnp6RW9W?=
 =?utf-8?B?RTN2UGJjRktnMUNCWGhzU3RhRHY2WW8wQmFkQnU1NUtIL2JiTERPdlBDR21n?=
 =?utf-8?B?NmJ6VUczNk1LQnhpd2UwellkSkJGTGhHejFRbXFqekNEQ1lLK2RIVjFIL2FF?=
 =?utf-8?B?MEluTkM1NkhPN0hpdVRDekdhendpSUx4REJPaVdoaCtNZXduRm5PeVNDV2ZC?=
 =?utf-8?B?dzlUZyt5RTQvUXQvN2J3YVVDK0N2Mk1JWWRVRmY1Z21UZGM5TzBoY1JuVk9L?=
 =?utf-8?B?OXl0SFIxVUowbEk3eU1OVHFoaGZnU2orUzI5SGo2c1dvcFJzbnh3ZmVZMTM2?=
 =?utf-8?B?ak1VZit1TlRIcWNvT0pLN2ZOZjZ3UGxDZkg4QzBOUkRCZ21jTUlVdTA4VGdl?=
 =?utf-8?B?cVdRRTBieWdUSENqMjdWcGl4ZnBuL0QyazZ1b3E3R0s5c0NaZllEb2xYZ2pT?=
 =?utf-8?B?bXpjOWIwRytTYjY4NzVFeG92REx6K055TUpyVktqU1kxMU12YnFwRURrUld5?=
 =?utf-8?B?OGNMQWlueFp6VWNXcTdpbFdXRHFMUWNRRXdwMEUxZWo2VTJKWEltQUhtV1pN?=
 =?utf-8?B?LytoWlBvNm5XdXhGalllYzhCQlNQWDlhVW9lcHRLWHc1NWVrMy9KOUdZUU9h?=
 =?utf-8?B?ZTFKQ295dkNnd2E5NnBlTlFpZzB2Ly8vUzJIb0U4bFBjYWFNNmoxVE40UUJw?=
 =?utf-8?B?VTFjUGovaG5Pb1l0Z0IwVXdRL1FMNHU3cHhrYnZQTG1lb1M0ZkJua0dGckxC?=
 =?utf-8?B?ZmprRytqL3lmUzlwZGxkUGlydDNGMXNiVFRIWFJDWmpkdW5tQ2hwTjcxY2Yv?=
 =?utf-8?B?bTRzQVBKY3d6MFROclFveG5pS3Z2U0FiRG9zSkJuc1BNbnpVYm1Nbnd5czNP?=
 =?utf-8?B?MVpOeUNBVUE5R2NlTGdBeEh4LzgwbmVZQzV5OThCR3VrTU9BeXlNU0VMekNX?=
 =?utf-8?B?RVVKL0tQUVJ2Rlh0cG03bVJnd0lacC9kaVdoOUVqYUwwc28zL0UrSGJISTRL?=
 =?utf-8?B?ZGRQaDBSeFNTQ0UyaVMwQ2xCZVBid202ZXpkQnpyNXBoR1ZSOW9UZmRsZlBP?=
 =?utf-8?B?czdUalJTWGoyQVRyOHhTTW9vQVd3PT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pJPgAnZYGHPlaOzsaUAn+2Jd5OX5fOARqy7Hg9B1sBwdO/aFZCVTsgl6DGVXH89rutKfqk4NU64Pj2Vuw3XHpr1ahQhJqC4kAH541i4MxLO6uWANR70CIlgOq5BZxt4nuqIIC6B3kZFsgxF42usHyHDbF0qX2DNw22nJQ+7j72Qgv8RdYyLtlXySC/0NL2WK7SVvmOFhIUsLI/nffH8ZDsxgcI9mGsTuxfxLf4jqoCmUA3aqjpHh4micpDrxfEyR6AUOfHMRatO1rp7poCmSSMwQjsAJGeTgFp4UeNaB6t6PGPN2SetJaQj/sa+iG1SiNrFzjULQ8a/N5wbbviyZfFcXjlMeQY7/oa9AmO3lJbCp2sLnHdnYNMSgZ/r0l3w1aD0q7wycO8/gTtDkVLjlW4o0hJ4DvlTc/rJqumWqTIvKpZlxWWw8iJFQ2+e5oTn/bIqPfIfcbUZS4zY0aI0u/8awEurI1uACd0gj6qiE9Uv31RU+crHtkQjjHEOMQAI7KIc0qI1x7X2JEtvS6ZRonnJ8Leg7bTLBvliSqwngid39dd9PVBoVY4zTMo75rLZbxmMGdvwsL4jGVw2JKL7iSNU1rY9IrZLjZxdJ3vQ9yIs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47ea998-9a8a-4aba-edf6-08dc21ed7443
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:52.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACKO1c/fIUPWelrQLx1IqOoTgy5kCkr9WFhcHMEnMoukjah84cc2+MbarOA2pi0ZaXq5hp53idSq7kO6wuH+uWIgFN77I2T9v1srjXAfSkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-ORIG-GUID: XyNOEBhzm3lWIUWJv_8oq5tQHTyJEfLr
X-Proofpoint-GUID: XyNOEBhzm3lWIUWJv_8oq5tQHTyJEfLr

From: Anthony Iliopoulos <ailiop@suse.com>

commit a2e4388adfa44684c7c428a5a5980efe0d75e13e upstream.

Commit 57c0f4a8ea3a attempted to fix the select in the kconfig entry
XFS_ONLINE_SCRUB_STATS by selecting XFS_DEBUG, but the original
intention was to select DEBUG_FS, since the feature relies on debugfs to
export the related scrub statistics.

Fixes: 57c0f4a8ea3a ("xfs: fix select in config XFS_ONLINE_SCRUB_STATS")

Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ed0bc8cbc703..567fb37274d3 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -147,7 +147,7 @@ config XFS_ONLINE_SCRUB_STATS
 	bool "XFS online metadata check usage data collection"
 	default y
 	depends on XFS_ONLINE_SCRUB
-	select XFS_DEBUG
+	select DEBUG_FS
 	help
 	  If you say Y here, the kernel will gather usage data about
 	  the online metadata check subsystem.  This includes the number
-- 
2.39.3

