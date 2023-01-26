Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090E1C54E94
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 00:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjAZAdU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjAZAdT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 19:33:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2D12B614
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 16:33:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PM3vUS020450
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=BfYI3hhGtR7Nxx3DMnleppnTcpiIz0r+I/aOvUewNsY=;
 b=m79mPaT6gaGRwlbtLp/0SkL9LB/dVkycMgZ8t41voZaANjvYBlO5x5d2VrgdvDSHnL0q
 DHi5O5F4Gi/ZVW8PbMXFqlW3H7WaBne1hVSLV/lyUfvy3SMJVcJAnHMhc5qadxPOp6pB
 u0reSLSPxVaV1/wBZWW3ryeVyiVTpRc8gfwdNkGfPhEU/OxWz+WiwtRso1KnjsCeSJ/m
 mIn4T7d1WpWkFG7+rkGEHax+TF0rY546mZU7nog4t3NdVJ9CrONEPdo5XDRDhz8xrKWq
 qlkLrtBgF/wPz7AoFJVgrtgJ+d+UoufekO+jfjiwD2yMCg04Wh38xRCKyoQMdCXxW6lH 1g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fchfnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30PNRxON028412
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:15 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g6tw3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHjndO7uRxmLbgWQcJIpFXLh99oqYz/Tv+zudRiQie8oqpMZ/4yiOxWs/kpPmobgcyTLAD8byGUfbLNRoRzrVnixLIBtcNe+citmLxX10jHXiiDcFYt6tZRKMN10BdEx8+X/FglY6rKtK1SMVq8miQpRlnBuiQXdEn4ZgHZAFztHIVuvS/gppjrrlWUmcwXgw08ozmR3t2n/s/jyL08K9CKUTEoohff6rFPSjUmn5uq68PQEGHR78oFj6wSSCWEtC4P7uo3lj2aMS6tp0oXCr1muhtPJR+cXov2oAwMydckrwHndScjrqRJvxFp3r/Y/sc+s89h8jnPcn2KoxFGhnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfYI3hhGtR7Nxx3DMnleppnTcpiIz0r+I/aOvUewNsY=;
 b=B2K6z/MXVKnX3NTSU4Hpqu4DYUHx8epxaBGI/87DXnM3JNiY4c+Pg2Elsm9BqvdxqFviZV+5huGNlbyXuQJMBqpTcUmb5eJ4zg3RarjS8Jg461sLeVH99ZTp6WGMaUbgCuhWSpJJAHjQUvS8rVP+o6fAhTovuGt7LXKM9MQaLZA4pDfAWj/xvUTvGi3+OxJj3xy3rE7/xqg/sQwYyean5iwZvvFam2aQuzpaV1WOWYbQ7Rg16VsJfqNKtGwemJOZr8iudG3RRbiwbvTRPYZR1BAfOPi+s2PkPg8ySOUuxvlfFzAjEYk2wgBcu0W58OZ1U2SwKa7VnOZlmZUZNPJQfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfYI3hhGtR7Nxx3DMnleppnTcpiIz0r+I/aOvUewNsY=;
 b=rUUbZlJckAgnrGuq9Ww2afX5YoKtSE6SC0klq7itF3tbbLcPJqWKeVkEFfHCyHcrsdGOxYONoGqzqsIRSS2WP6MfTSsKJ6GUHYiBA+npTdReLI03HPDDhQOZW1mKp1Cy7P49QxLNHp9tdB5bqr9tkziMtNFKn3tqRbovr1R18Ag=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5034.namprd10.prod.outlook.com (2603:10b6:610:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20; Thu, 26 Jan
 2023 00:33:13 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5%5]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 00:33:13 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/2] xfs_admin: get/set label of mounted filesystems
Date:   Wed, 25 Jan 2023 16:33:09 -0800
Message-Id: <20230126003311.7736-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5034:EE_
X-MS-Office365-Filtering-Correlation-Id: e623557d-6069-43df-8df5-08daff34e8d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCk75m121E7hwY+8CVpSmfvIX0VaGUUvWKiwHDmrZ5jRmtDztGdlmXlXJuKGNglbs4G0fbtT3Mpnc8El3I4a5F4TD7B+4XMjaLp7Jf2PdRIkZm0hvWlSqquxXXBF4De5T2lAMh5JPtVieRKL1DCVquZ16yCLk48eMa1N9Gd0zqkClyvIHXGCaxgKFE2FU7uqqxDSNlwRKTUfVjwUOP4yqY+g8+wWAC3v62I69MsVb7HZPl5w+jn04793ltylbBeifZTd20G7aw6hJtBZ+LoSYDM/4O0mg5b4AftwhiM4HZAHp3cCmW2bv8AWM6tJTKuG1YtOujsehmF3PfxPUSoIJlYQIErvznJH68b4F5nrMWCxV/4vuVpcXpFUNVZx2tOxAB0G9l7nnwhv2rtGBuvmvpGo1wGj5sgUdv8MCa5HsqW/6/Qw6S07xstc8xZwjOSPGLPoRwBiEB6TU2lnwAwGQ7M3/RBnw+hHMsdy84qlPpjIAOakfH3omieHBV31ttFU+AsIWWXqFdpDLk9cuvj4Eb+ShIgNparCV/woxYtU2ArMFJGIcIEub8Nt7iQqIKqQi0I0ORF2GPWcenAWc7OAB0ezQz5Ae37SsdSbWoVRYJacxLhVk2qqqTyllIhMdbIdew1WJJPKSy6qhN64kGHwaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199018)(1076003)(66476007)(2616005)(6512007)(6506007)(186003)(478600001)(6486002)(316002)(66946007)(66556008)(6666004)(41300700001)(6916009)(83380400001)(8676002)(5660300002)(8936002)(4744005)(44832011)(2906002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6TUQnataslJtynN+DjPFoT+dAUM/aGD4yVAFQzFkFzi5X8vGTkhaNLcH1JvV?=
 =?us-ascii?Q?B/Ks6yE7JLDrgeX16Ppm6kejf+C3cR7CxPEYi4gOBYXX5LO54wzD70r2C/Lz?=
 =?us-ascii?Q?eO+llSB9Ihn6WnGoTE/x1IsL3bekV+gSCf4Vf9JCqT1+qQRn8MyGGqPp8iFo?=
 =?us-ascii?Q?p8Y2OugekmgbBM12HHppBPgu1UshYsrimpkZSpz8EyexpOTNthggemcNakr1?=
 =?us-ascii?Q?2+kQscyhvaQ8AZzY71UH47sSU6Eux+SiZ3Sa+H93EtIy1XVoxd2teTDkdTf8?=
 =?us-ascii?Q?tfpu4/mknrIpotJb7dKYAqk1WUkkw7isNmgLv+ThphLhg6kLUE908MG1021J?=
 =?us-ascii?Q?guS2u4+KCG7MFLkHdoLepiv+2Cabh54Sl2qXJudxCSyYIrTr24mrhngbLWQD?=
 =?us-ascii?Q?ZgHRzvaP/3EEanHEhFUWY+Do7kjNB1P65jiKav/yzYKb+cUFyEQLqvMHAbX3?=
 =?us-ascii?Q?WpSVSP5hxrGM2+yWcEnqJB/VPVd/ZwdknqdfdxmxGEsZrSDQq3G2HM8n4BfC?=
 =?us-ascii?Q?UHY+D/wWZwA+Ae2GTNObDi5Q6ygd9wX+IEnjiyOuT5z+MZ1q67p0phSWSuH5?=
 =?us-ascii?Q?k7soTSoKBjzwRydUtpmi+SRVzJ8MNF7K1neMrB0ZkeuhVpazVQr/wZ1lLKug?=
 =?us-ascii?Q?CKFyuHt/Pct4g6ni5o6D5adplI8UYzkmdD54unInwtgGoY4dSHSF76yk9yGH?=
 =?us-ascii?Q?W1sGPvkbD7w0qlqL64KNmlvnSea04MxxIrEWeP6lzFPD/vd8bwhfuHEMq7vZ?=
 =?us-ascii?Q?lxcDYaQC8G0J3kv5hTJx3U1ksU68CLDnhJjMxiH0UEpzA76jrUVv2xLY2hFJ?=
 =?us-ascii?Q?2QNo/JAzdidix5ZN7PwJ/O1L1MKfI+ViCLNRvY64Gka6cAS5hXJMAZ/PhKTI?=
 =?us-ascii?Q?bu3R+NLKzKRjDKM5HNh8AjI24IyUFCN/DImDAtd24JsyIX9DImVkQIQGuDaj?=
 =?us-ascii?Q?X+UEZn2JqHyOV5OfE4XG9gS8HmwQ4pIegYZKz8ZLzm0ocUIokJUj5zlHyO/N?=
 =?us-ascii?Q?H2HNkzLfr3dEi7z58VuD2z9Q0YQ3wA0f+KhRWQnjSMxxuSLqwnE+8KILDd4S?=
 =?us-ascii?Q?EWduGhNGcG0+vb3C2C5NMalqc1ehR7PuR58kGNttXv9x+Iefq4E53+mKiOvf?=
 =?us-ascii?Q?grmE8q3c3/7JKbKapHhIDi9WsQYQvIW3lOkCrd1CiFafMflZFqRL5806SPmG?=
 =?us-ascii?Q?GEEBHrHIFnshXOrwcRLzPz8JPkb1o5KmxXBmCQ68rnwmMjU94YYOitTI8NM1?=
 =?us-ascii?Q?5/caP3imoKIPyGSzwClRdTL44N0/Pk34TItP3sifu/E2O9PGg/8R8iihMFm3?=
 =?us-ascii?Q?H8fOwfGNXNO7ZNtLMPbB2D+L8gBGl1qxFCGfmr1RXmUfkxlRTXOy7lUNAI86?=
 =?us-ascii?Q?ofg2x17C+hGMvcf84kI7SAIYsc4M+xzcz3ojkiu8mogr5WVU5J4BBnwlVl30?=
 =?us-ascii?Q?69X69qAeq937BVCpZGJnB/EMaJscj17dKJS1t8jVcF0DANLZTCMlud4uO4v+?=
 =?us-ascii?Q?/e7MtEDE5zQblkDl4Qwgj6WM0YQ+Ai2flXcZn4NSLsVo4BcSI08NsWor0vZu?=
 =?us-ascii?Q?FoIxdEeeAnBFwBc+KtXNkKpJMVdbbUute+iI2KklHbZtDeSNFMsBw/JMYaJ/?=
 =?us-ascii?Q?j3UgOychTFdU4sIZBEdHHbetqQw82+jZGD9fhoJPYHPNkjQJF7Fi+eWGU7rV?=
 =?us-ascii?Q?QQri6/4kDnYpmxkVUzmF9njvaAc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NIsw9LQQn9VC1x+0j3z2KnCjcChzeartyxF4co2QuDmxZhG194kqbuL56sOk+s1oNFkUrKXO3uMX7s98BkdtESNnRMHp80a3uPyalSZF8svJPyomD2cyXQhwSgIgun9Ta1N4aW7GoDrycrANjIrs4BdBUvJdOaPBl2PISXPRIZzpWjlPi1m2aa+Dr2knQpFltsVLtJ4k2xM90EVc3jBZOlzcuP+iWgcWOTvIOjutHLrnSQ2KfjQEckkwYcKTXj51OaMXkHbkQ7moVGgq5G2B683A3CBLmKWW59II54d+MF3rsefxa4tsVJ7s8oT0c9rcLG3nv+qJ5yFOYrZakeY+lqyAb84jq2xeEKdM3XwjN0tgj0MXJZFQIBbRC0d5SaRWQAbTY4hpA/fs+XWI5G2oPFG1lHkbt1Z2pXbDGajFQHAd6qCahRCh7ZAl5jpfSeBPjByZQn5kGDFG5svccvB1lTZT96ZVKGoNi6yPSMwiaqPjbvId2Ck2fJtbXGajvywFmsSrZlMFYhQ+7vir5FKIJuIQMahp7mDugM1/G2z/wA46qwPg3+JooDWSWovafDinEHcY63e7yaU0Q/vlDx+PXkNtOr5mIwOZzPN9evihGSiXGer+HOcsGEUR25NnHun3rHiFNudlHNAAdiceQihRVMOaEMcsP+56fLyDoQOIMnwfsPuExgE+P/1h+Ep0Vjv17PUGi5VcAU27BjfUHNjM1m0741DNeVkyOo87J15wzx0NHsU7zmwJfkBik9gPNFID8nqxy7i9psj0lg8jJhC2sw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e623557d-6069-43df-8df5-08daff34e8d0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 00:33:13.6805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPWoLyMd1I/FKLX+/FLsPcZOyCW5jijb80oEj+Yb6+zROUCX6eVscQNyWoZx2vGEoaMg6GSVQTlP3gGkQcm8wLBZ4tBQjRFeNXuGqqJW1qY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_14,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=925
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260001
X-Proofpoint-GUID: wr1CnlhIKYnMXT3_s7mTi_FPsKYEYmSz
X-Proofpoint-ORIG-GUID: wr1CnlhIKYnMXT3_s7mTi_FPsKYEYmSz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series enables xfs_admin to get and set the label of online filesystems.

Comments and feedback appreciated!

Catherine

Catherine Hoang (2):
  xfs_admin: correctly parse IO_OPTS parameters
  xfs_admin: get/set label of mounted filesystem

 db/xfs_admin.sh | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
2.34.1

