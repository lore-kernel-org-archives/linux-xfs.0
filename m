Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598C0ECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 18:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiH3SF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 14:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiH3SFj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 14:05:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C87E128
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 11:05:30 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UI4G6c002294
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=v0lPFUgq9Fys0vGXHt6lLQ4xE9esvwJVXhMlO3D8Fb8=;
 b=diiE+0SbsPN8GWduyXzVkfq4LfV1Lg5fK7yN5TIMHWZy4L6Zr0YRS02Brw/bH3li6f1Y
 3pG5fioLiJ8G1WrjEn9v29ttf0duWA9jtZhV3WWVQL9h8rIr8HNlXpkm3Y8WwaKV4vGE
 MWeGVx80N5uH8wH2+mDDus0Noadz+vi1ZwSY2y8HixpXbteauAzpYe5smnHVK0Wl6AzN
 NdZkBVM/jSIltTA/SLoxQ4pAcrTIZbszahxfywEb51y27JdgY3VCrVst+cWL00y5V0V1
 9e2BbV7JVvbN/pqL9rYElbzsESPI93AXdPPZiQ4hGKCxTxiS75WVdSBm+WOz1ss/xRoe 5A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b59y25q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:05:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27UI3Q4j018389
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:05:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q47n6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 18:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpqU6MxJRuP4GKnqNyO81jX8UEjvVp5LHQXDzWpe2/9ted6sP5l7vH9pqdRq2p4/Z1oNvFZM6haEXz/nGCJwpy5fbI0ucVBHd2ostCKNjxT4Eu0sbWtRumze5sWGkObfEiP2iJ5Q0BtcEANu2fKdjphHbEYAkDnZ31RDV215Qo4rbAk3wzidt0+ezAYpQKUVmza5zmoC17Zv2Li7rAuNUAvrq3+uV6LfSK1QW3uLg89RVlTESVnDQavudaq9MFtelv4pDRpLrAtMmEtqGiNty5VJvXj0Bdft5RlqXKCyviKYlM3VwbJRa6oDDqffss579Py9iGHcOkfRB7PYp+HpFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0lPFUgq9Fys0vGXHt6lLQ4xE9esvwJVXhMlO3D8Fb8=;
 b=EeuqAy/hZoiW2fn3KV/Q6f2LUSPUQJrqk3L3CpcWBVrlYQT4njNR8X4b9/y7VL4ufCeSpGIlRAygw1QZzVLaVfnp8mbMI3b6ZiVI1k2jeH7hjuKPO4or8VFZ7xKYoy+7PlAUFa7GSe8XsSYaxb/irs6Vb+aaInbBi8gKP7pFnZwxVC1AfJk5Su8yHv5UcQynC6IEl36sLrOUP+stV46SQl2iAd6AjGyvAdssT14wzBP9z7ej9emttbvUV07987URFzhbIAWgzhB0d2ono4fzuArwSa9N70KCuC9W+qVemFiAAum/v+mD9gheZ4BXBzyqUBwCOAEDJSG8aXnzQbCySw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0lPFUgq9Fys0vGXHt6lLQ4xE9esvwJVXhMlO3D8Fb8=;
 b=ovVKra1Mb/MTf8kU+K4oWuQFuT2ETinwG+4uNsW6pgzTna+pXnpxygV8J3fv/Y9nbydQRsgFwcmJuSGwh6N4L1+7doMGONzhbfHWWlWyApCUQhtY3diaK5BFQVADfjUqjCtZFWahfvnl8Q0BkbpMXv5VBBXceuoBdngvk2875ZQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4881.namprd10.prod.outlook.com (2603:10b6:208:327::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 18:05:27 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 18:05:26 +0000
Message-ID: <8a59b8884e8dea7b05205be3a4c7f53f9da58371.camel@oracle.com>
Subject: Re: [PATCH v2] xfs: Add new name to attri/d
From:   Alli <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Aug 2022 11:05:25 -0700
In-Reply-To: <202208310018.1wKCQHzH-lkp@intel.com>
References: <20220829213613.1318499-1-allison.henderson@oracle.com>
         <202208310018.1wKCQHzH-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0211.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ad2c078-9fe9-4186-deb2-08da8ab23789
X-MS-TrafficTypeDiagnostic: BLAPR10MB4881:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBx6l5U1QleHpTR6hnkGwVpIOfwl5Jmqx+KqtkI9EjQ4X+vRbYc2zPBaTdIsqEw5QesOR1NrujBLsNBzPs6xsRHOX2OtyLZt4EgfKS7Rh9HKSXg8UHgqHosx+UUUR4UAt63nPIW5APnFF9fAMIL/WN7lMUs46Sff+VtuIfD9wp+Zn9PR3BhXfPdcQQ8wek1WETI5k3zOaHqNdptsCwuJfTq70VpYsEazzp8c6+27f3UGPnrcWgloOOkZkIedKZNKl3K9gt0dZV8gxH2ImGREyivP/lHasF74p+PPfGnqgnwrpgSXAXke7+JKCOhgMZSTJby5YcaXsH0P02vA74dmdMXHZSXrjrELOTCXVFGpOWpIJGULFxEKIfG9Lz83vElj//9Ip7uXL57z2EOezBigmU7bjfN3R0RoVP8MrP49g4/IFuP76wX7En/VDS+Y9omDXldGMwMKODhn+roZGy9UITA0/yXOh7W7d1MD7LQBLKrlea+hYCE6TRRdtyM+weN4mCU4bOM4iowcipdsOEgsC0SNlZsHcz6kz+QsGwGIejGWeb1gDz67cFW2JytUezFrCoSJQAspmWgfmIXB/NjjuLj9fJgullaoAr6/zMdGYa+no0DGxjEpGx1VzfujHAit5Jtw8FV/DU/q/biXMrU5GEUXcdg00w0/CpzPR2IkXYIpYyZ+25t5xpDEoysREwmk5tQKLQXheDefZqV5rMOph3Z6lc7ZqUFLB3Uc1PJcto09u7wOD197bn0ZhShATMsLb9mbdP6NEDrqbswCxMTTMqfduyrbT4IJSWBse1fhljaHtHI5nw8r2g2PH3uDEtjgpsRwRpvN0tRk4OHSf//fFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(366004)(39860400002)(346002)(186003)(8936002)(966005)(5660300002)(41300700001)(6486002)(86362001)(478600001)(2906002)(6506007)(52116002)(83380400001)(2616005)(26005)(66476007)(8676002)(38100700002)(6512007)(316002)(66556008)(36756003)(6916009)(38350700002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnlWcUJ1NnZUdENGbU8rLzhDbkRmTEFodldYeEQ4SWFYeVMzVG9Jbnhlb21Y?=
 =?utf-8?B?T0NPNWd4RXAvTDlJZ2x0NWxCV3FrenVpOTR5UXJXTld0R3ZMSWZGQTk4eUtZ?=
 =?utf-8?B?WE5zdzZRTG55d1oySkpCeVhpdllRUkVzSXUvcVAzcnYyemVRMFhtMExIY29J?=
 =?utf-8?B?MlBQbnkySGo0RTZvaE9keWY0NU5VQ0lTcFJBYXhEVmlhMjNJZ0NXZWk0Rmp2?=
 =?utf-8?B?U0RZSVBiVWZ4Zk9DQnB0QVVSQWEvNDg5alEvQlpKV0NvT2x0QTg4enRIT0tj?=
 =?utf-8?B?SVEvQUN6THhSQkZJd1gxZTNxMHlqbUw3aExCdG9uL2FZWjVscVJDUVlwQXhr?=
 =?utf-8?B?aDVJSnJwa1hIRXRrRlJDd2RDWHBvVDBqMUtENWpOT0hkYkpVS1FZckVpd0FV?=
 =?utf-8?B?RXlwM3FXMlM3RHB6YXBPbFFNNWJxb0JTbHN3Y1EvT0luWGswNysxa3MySytZ?=
 =?utf-8?B?bTZ1QkUyT2xJaDl3V1M0SGR6VENOK2FuR0pKdStLYzArUWR5N0NHZDJJMGNI?=
 =?utf-8?B?K3h5OFpaQjI3N0ZtWElybkl2dlFmZnF4QTdlUmVMNEdKUWhUWEdyT1FoaFV1?=
 =?utf-8?B?ZmpzbnhmcXgvMndhdnJCVGJwMDVoaFVhZHZvc29ZR3dzWDM2bFRsODUrOS80?=
 =?utf-8?B?eFpYKzJPMkErc0EyYTdaVzdVT3ptenhrU25PSGtFMHoza01vVW40aFU4SEo2?=
 =?utf-8?B?enk3cTAvMnUwSzJFQTlyOXJSYzJ5S1gzRm96RDNZY1JMUVc1cTE1Uk9leXNY?=
 =?utf-8?B?RjhMYnZndzVNWlVvbFZ6QmFyTDYycjNLckJ1WlpBN2xmcklYVFFGUnlRVHlV?=
 =?utf-8?B?MnRPSzlNQklmNUsyb0FDNkRvaVZSQTEwaTdrcWdQVklJaG8vSFhmTjZhbnlX?=
 =?utf-8?B?cjNwbnZ1aXRZWDF5aEJEWkhVSHg0T1BBNzArOUlFS3o5cXYzM3h5MUxxNXFx?=
 =?utf-8?B?bXE3NTRyb0Z0bUpwSmlLL2I3S1kxTUZZcmFwY21BbEJJMkh3TjRPeW1LSURO?=
 =?utf-8?B?VXNkWDBuU0lBMHNyWjc0Z0plbXhZUWRudTN5SlZJd2h1T3BneThCZHJyM0Vz?=
 =?utf-8?B?YTFTejlRM0RBK0Y2N1BLSGlHUkdEMTJkZWpheUFmNVA4cFV2bmZNZTYvc2VY?=
 =?utf-8?B?Tmp0elZ4N2c5T25CUTcxMG51Y3FyZGVzVHNYVW12YzQ1SXIvUEdSY083R0RC?=
 =?utf-8?B?Ui9IVHk4SkRFdU1xVHF4dnZ5YzRQRzhCOHFuWE9GajlUcFZMdUt0anE2V084?=
 =?utf-8?B?VTZhcGVoL1JCNGZmd0tPWUZDNk4vQnB4VnVldDNpOGFRdVZTci92eGNrNDV4?=
 =?utf-8?B?YTQ3S3pvTU8xWEY2QjZ5c1lsQ3BOcU4yUXU5aUV5QWwzUldZb3NxUmRjaFE2?=
 =?utf-8?B?SXVuNWNUL0FaUSs0clVwdGk5c0U4STNDeG94cnVEeFd2QjllUE9INExFS0t2?=
 =?utf-8?B?MUtsNFRtT1E0M0dyTWcwVGxZaXVYa2ZOeFZHNFBOT2h2Q1lGc0d5TmU5RUxt?=
 =?utf-8?B?Ym5aNWJxUHBUK2ZHTUVsYTJPQmpBb1d5UzVMZ3dJYU91VVUrdW4rT1lEWkI2?=
 =?utf-8?B?RFl3cDlxQi9WQzlHUUd0RjhsSFNpUmliZFZNMTEwNGhzb0dwaEl5ZFdpcTc5?=
 =?utf-8?B?MWtmUE9OUVFRQTlNdzBXYXZCTks0MCtoUVJvU2R6RklLbS9Bbk1CZ0F4ZW01?=
 =?utf-8?B?bERTc0ZkVEpsaHg5ODBjdU1EM1dzQ3VTSVNrOGtYa0hsZmtMMEhVWmtHZGNQ?=
 =?utf-8?B?UCsxaWhXWkt5RkdKRlFzMnlRZzhES29pakZQUWNYcDFsNTlvcmVObVBWblJs?=
 =?utf-8?B?dUcyNzFNZkZNMmcrbm1QWFgvaDFIaEFUZzBSY25oMjlQTGRydXN6aHFuM3FY?=
 =?utf-8?B?eTYzMENLSTVnTG9UNjJURGI5RlJSckU1YytUQ3c4cmo0ZG1NbU01akc3K2Fr?=
 =?utf-8?B?dFZDM0pBejRkMnp2eEZaSU9qcEh5WHgzNDRESVZoLzVhbFJjZ2doMjF5SWhL?=
 =?utf-8?B?R0RMTE90U1pOUmc2N3Zoem9pSEdBcTE4dEhOQ1JYb2Z6Mzlod0tRTXM0SnpC?=
 =?utf-8?B?ZGhPMU43UUdLeHVuMG1naTZ1d1lUaVpPcThtQjhHUTZNb0hpVXEvTjgvc0ZS?=
 =?utf-8?B?c1ZJaXJleXAyazdFc1Ftd052ZHFDd2F6UHkrYXZUNGtTaGpXV3RsV3dRMmtx?=
 =?utf-8?B?QXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad2c078-9fe9-4186-deb2-08da8ab23789
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 18:05:26.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHTkjQK6IHieg4ZwyGhDay/TmXDBGFSFnLdYyxgsQDkLv5w/NPyGcBd/tWuKUFcif+2XoqwA1fMxGWiDoZAEyi8HQyoEutGE4rsP11KlE0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4881
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_10,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300083
X-Proofpoint-ORIG-GUID: dJOAy9DR_FKfCqz8pwind2GovXf_Bism
X-Proofpoint-GUID: dJOAy9DR_FKfCqz8pwind2GovXf_Bism
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-08-31 at 00:31 +0800, kernel test robot wrote:
> Hi Allison,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on v6.0-rc3]
> [also build test ERROR on linus/master next-20220830]
> [If your patch is applied to the wrong git tree, kindly drop us a
> note.
> And when submitting patch, we suggest to use '--base' as documented
> in
> https://urldefense.com/v3/__https://git-scm.com/docs/git-format-patch*_base_tree_information__;Iw!!ACWV5N9M2RV99hQ!P_ML_BJdQByB_s-n0ArO4YhQL5J5odeU-wn7Z_WCCcblbKqP8g51z8T-Yrx9v7evOofMkoANqhTd_uQ$  ]
> 
> url:    
> https://urldefense.com/v3/__https://github.com/intel-lab-lkp/linux/commits/Allison-Henderson/xfs-Add-new-name-to-attri-d/20220830-053816__;!!ACWV5N9M2RV99hQ!P_ML_BJdQByB_s-n0ArO4YhQL5J5odeU-wn7Z_WCCcblbKqP8g51z8T-Yrx9v7evOofMkoANAw_F4ME$
>   
> base:    b90cb1053190353cc30f0fef0ef1f378ccc063c5
> config: x86_64-rhel-8.3-kselftests (
> https://urldefense.com/v3/__https://download.01.org/0day-ci/archive/20220831/202208310018.1wKCQHzH-lkp@intel.com/config__;!!ACWV5N9M2RV99hQ!P_ML_BJdQByB_s-n0ArO4YhQL5J5odeU-wn7Z_WCCcblbKqP8g51z8T-Yrx9v7evOofMkoANc7fxoPo$
>   )
> compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
> reproduce (this is a W=1 build):
>         # 
> https://urldefense.com/v3/__https://github.com/intel-lab-lkp/linux/commit/68f33e68647f25b811773b237669cf26e6b43382__;!!ACWV5N9M2RV99hQ!P_ML_BJdQByB_s-n0ArO4YhQL5J5odeU-wn7Z_WCCcblbKqP8g51z8T-Yrx9v7evOofMkoANaktysnU$
>   
>         git remote add linux-review 
> https://urldefense.com/v3/__https://github.com/intel-lab-lkp/linux__;!!ACWV5N9M2RV99hQ!P_ML_BJdQByB_s-n0ArO4YhQL5J5odeU-wn7Z_WCCcblbKqP8g51z8T-Yrx9v7evOofMkoANKKi62kA$
>   
>         git fetch --no-tags linux-review Allison-Henderson/xfs-Add-
> new-name-to-attri-d/20220830-053816
>         git checkout 68f33e68647f25b811773b237669cf26e6b43382
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> arch/x86/entry/vdso/ fs/xfs/
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    fs/xfs/xfs_attr_item.c: In function
> 'xlog_recover_attri_commit_pass2':
>    fs/xfs/xfs_attr_item.c:824:45: warning: passing argument 2 of
> 'xfs_attr_namecheck' makes integer from pointer without a cast [-
> Wint-conversion]
>      824 |                 if (!xfs_attr_namecheck(mp, attr_nname,
>          |                                             ^~~~~~~~~~
>          |                                             |
>          |                                             const void *
>    In file included from fs/xfs/xfs_attr_item.c:22:
>    fs/xfs/libxfs/xfs_attr.h:550:50: note: expected 'size_t' {aka
> 'long unsigned int'} but argument is of type 'const void *'
>      550 | bool xfs_attr_namecheck(const void *name, size_t length);
>          |                                           ~~~~~~~^~~~~~
> > > fs/xfs/xfs_attr_item.c:824:22: error: too many arguments to
> > > function 'xfs_attr_namecheck'
>      824 |                 if (!xfs_attr_namecheck(mp, attr_nname,
>          |                      ^~~~~~~~~~~~~~~~~~
>    In file included from fs/xfs/xfs_attr_item.c:22:
>    fs/xfs/libxfs/xfs_attr.h:550:6: note: declared here
>      550 | bool xfs_attr_namecheck(const void *name, size_t length);
>          |      ^~~~~~~~~~~~~~~~~~
> 
> 
> vim +/xfs_attr_namecheck +824 fs/xfs/xfs_attr_item.c
> 
>    756	
>    757	STATIC int
>    758	xlog_recover_attri_commit_pass2(
>    759		struct xlog                     *log,
>    760		struct list_head		*buffer_list,
>    761		struct xlog_recover_item        *item,
>    762		xfs_lsn_t                       lsn)
>    763	{
>    764		struct xfs_mount                *mp = log-
> >l_mp;
>    765		struct xfs_attri_log_item       *attrip;
>    766		struct xfs_attri_log_format     *attri_formatp;
>    767		struct xfs_attri_log_nameval	*nv;
>    768		const void			*attr_value =
> NULL;
>    769		const void			*attr_name;
>    770		const void			*attr_nname =
> NULL;
>    771		int				i = 0;
>    772		int                             op, error = 0;
>    773	
>    774		if (item->ri_total == 0) {
>    775			XFS_ERROR_REPORT(__func__,
> XFS_ERRLEVEL_LOW, mp);
>    776			return -EFSCORRUPTED;
>    777		}
>    778	
>    779		attri_formatp = item->ri_buf[i].i_addr;
>    780		i++;
>    781	
>    782		op = attri_formatp->alfi_op_flags &
> XFS_ATTRI_OP_FLAGS_TYPE_MASK;
>    783		switch (op) {
>    784		case XFS_ATTRI_OP_FLAGS_SET:
>    785		case XFS_ATTRI_OP_FLAGS_REPLACE:
>    786			if (item->ri_total != 3)
>    787				error = -EFSCORRUPTED;
>    788			break;
>    789		case XFS_ATTRI_OP_FLAGS_REMOVE:
>    790			if (item->ri_total != 2)
>    791				error = -EFSCORRUPTED;
>    792			break;
>    793		case XFS_ATTRI_OP_FLAGS_NVREPLACE:
>    794			if (item->ri_total != 4)
>    795				error = -EFSCORRUPTED;
>    796			break;
>    797		default:
>    798			error = -EFSCORRUPTED;
>    799		}
>    800	
>    801		if (error) {
>    802			XFS_ERROR_REPORT(__func__,
> XFS_ERRLEVEL_LOW, mp);
>    803			return error;
>    804		}
>    805	
>    806		/* Validate xfs_attri_log_format before the
> large memory allocation */
>    807		if (!xfs_attri_validate(mp, attri_formatp)) {
>    808			XFS_ERROR_REPORT(__func__,
> XFS_ERRLEVEL_LOW, mp);
>    809			return -EFSCORRUPTED;
>    810		}
>    811	
>    812		attr_name = item->ri_buf[i].i_addr;
>    813		i++;
>    814	
>    815		if (!xfs_attr_namecheck(attr_name,
> attri_formatp->alfi_name_len)) {
>    816			XFS_ERROR_REPORT(__func__,
> XFS_ERRLEVEL_LOW, mp);
>    817			return -EFSCORRUPTED;
>    818		}
>    819	
>    820		if (attri_formatp->alfi_nname_len) {
>    821			attr_nname = item->ri_buf[i].i_addr;
>    822			i++;
>    823	
>  > 824			if (!xfs_attr_namecheck(mp, attr_nname,
>    825					attri_formatp-
> >alfi_nname_len,
>    826					attri_formatp-
> >alfi_attr_filter)) {
Oops, this signature change belongs to parent pointers.  Will
separate...


>    827				XFS_ERROR_REPORT(__func__,
> XFS_ERRLEVEL_LOW, mp);
>    828				return -EFSCORRUPTED;
>    829			}
>    830		}
>    831	
>    832		if (attri_formatp->alfi_value_len)
>    833			attr_value = item->ri_buf[i].i_addr;
>    834	
>    835		/*
>    836		 * Memory alloc failure will cause replay to
> abort.  We attach the
>    837		 * name/value buffer to the recovered incore
> log item and drop our
>    838		 * reference.
>    839		 */
>    840		nv = xfs_attri_log_nameval_alloc(attr_name,
>    841				attri_formatp->alfi_name_len,
> attr_nname,
>    842				attri_formatp->alfi_nname_len,
> attr_value,
>    843				attri_formatp->alfi_value_len);
>    844		if (!nv)
>    845			return -ENOMEM;
>    846	
>    847		attrip = xfs_attri_init(mp, nv);
>    848		error = xfs_attri_copy_format(&item->ri_buf[0], 
> &attrip->attri_format);
>    849		if (error)
>    850			goto out;
>    851	
>    852		/*
>    853		 * The ATTRI has two references. One for the
> ATTRD and one for ATTRI to
>    854		 * ensure it makes it into the AIL. Insert the
> ATTRI into the AIL
>    855		 * directly and drop the ATTRI reference. Note
> that
>    856		 * xfs_trans_ail_update() drops the AIL lock.
>    857		 */
>    858		xfs_trans_ail_insert(log->l_ailp, &attrip-
> >attri_item, lsn);
>    859		xfs_attri_release(attrip);
>    860		xfs_attri_log_nameval_put(nv);
>    861		return 0;
>    862	out:
>    863		xfs_attri_item_free(attrip);
>    864		xfs_attri_log_nameval_put(nv);
>    865		return error;
>    866	}
>    867	
> 

