Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E361CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 918C064EBB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhBXFko (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:40:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49044 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhBXFkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 00:40:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5dNTv070579;
        Wed, 24 Feb 2021 05:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=X6ID3fmNPyhuNikkNFcOBobfi2sN+uvo6TVHDdLQPtI=;
 b=CVvSZkTf6cyXfKRH3VPKDKdlweeOA4M/ehC/Yd3TbOHn2Pz7ywYiGgeajdMt/8KnY+RS
 sVfcD6NnEbwJZqi3zTzVK25JvSYX4LId9lNaaxgxTb4cBRzAaJkTSVRveRdkuc7Fe26E
 Z7bIWayp5nFP1ieUReWE95WEHTO4LXGhAkIVTGMlOzgouxSVHGdXZdIjDfMHQZ+2hK/k
 RnvsFr9QAGzTTIJAiFWNX6yQ1HFQjERLP4MdHdwunm0aw3Nppz7oIvjG0DOFUCjZmODP
 Bx1GwJkXuRIqqhNxotdgWcQqppsGbPqZHNomeAZGE85azSWwUKFcExJrtCyY5jzgK0/K Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur1ps1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5a9qh031747;
        Wed, 24 Feb 2021 05:39:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 36uc6sp3hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhpivcPx4uCq3OUPFOl49m7o6U0V630jbPO44LZpgNpN1lUhPzPoZTIa2/SQAhWctXPA8j99SrAOCpj83JlAObZD4E17izgELY2lN5P7OztB9QRhX+/mWSBlauDSAMQRNLwycM/goc6tjpo5iuRe/C5wt8W5cvAulkNrImuis8cBgBtMAE0TE0Hh2mhrM4gMoPaZ7D4AFycoZ8FjXL0nDY8w6tkm8odQ/xeEJ6KmhtIydDtTZeFFSG1W2R9AUlb3nkWz5h4EFx2AAymQw4f/gSQFahHltyN3RFfeRKVtLwyX95/RjSrFJE7hurHZMdHpXr6r5FuH7tNX7zUjSfwsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6ID3fmNPyhuNikkNFcOBobfi2sN+uvo6TVHDdLQPtI=;
 b=gBxZmDeOwBPHqzLd0RKp8hRYymwn/XriZu7truu8wGiAhiA5LtIfXAgxPuVjWg+WLglK3KR8hL9fBhLXTj3e2xV2Tp04hNkm58Zusn9UsN8+pJ6eJGwpgC/ac4TgUxIxchbu73CbHdj8BMj1iDrpbP3g3YpbNcpbbnnABT7wivIMUalJNTBVAo8OVGOHV6bfEJ/qh2ym4H4Rpagu7Kb2yosGfGddTOsdGtDWaPMZWMr78wUwlawPZVfg4P7Jcik/utlpqU97sPOrcLh1vZ/cEUs/M4ByZq2Py07Br6fw60OqbhgrJM9claqy1nxn4z43iuBcAEJLZ6UXoN4Yc4NDEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6ID3fmNPyhuNikkNFcOBobfi2sN+uvo6TVHDdLQPtI=;
 b=ZfgqcHnlBiCviEFcTOUZJG9tgIAMtGAg++ESfHeaCdIxVklFfA7eLDU1V9MJSGNzKlfnaHloGj970Q/OceywsxvF4ZGZ/piHclJkO8bdmscKXtxcDI2xi9JDHT8808PVR6IOsN7/2B3c7jmNjkHpvx/6tvqW5jIOf1yjxX1mK9I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2437.namprd10.prod.outlook.com (2603:10b6:a02:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 05:39:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Wed, 24 Feb 2021
 05:39:41 +0000
Subject: Re: [PATCH 3/4] xfs_repair: factor phase transitions into a helper
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404927772.425602.2186366769310581007.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9b9dade6-f4bf-e568-b2d4-cc392de30de3@oracle.com>
Date:   Tue, 23 Feb 2021 22:39:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404927772.425602.2186366769310581007.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:a03:331::9) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0064.namprd03.prod.outlook.com (2603:10b6:a03:331::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 24 Feb 2021 05:39:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5495fea9-9428-4aaf-a96f-08d8d8869563
X-MS-TrafficTypeDiagnostic: BYAPR10MB2437:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2437210CE52BC471EA58C1C9959F9@BYAPR10MB2437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVnZXcShkboFNrCusBnqjRIrml/8P6+zAP0KMgWNaVJjdphR+cGjSkzHqTc6YEL17zHVUAbthfNP+3NL8wcgUs4dVUYb6QQ+nU3mTKa+wXTJVhCpNTyYOwQOoKc43ZzPGWy0n1PsgbBHPWiJlW3CyQl1+IggU++9aUiRItejmsvLnmuIoRLSKPO1hjs3jR22rjgaGqRG+kCGUrdEecwPF9j+OqqDLNoHe9oJ/mvFHzM6McWWxvFZ39jy0ro5BhczdoP5tH0PTZCT2t7/2VsLoNsMVQVxeKpwcnP658PpciJZQoRWOHMQGMSJ2Qv83m74QH34dRmxQ6sGF+72QgnhwiHsw+o38jeFHMaE5GBPNNoKhSupJq+TCMUGFasiR6Odk9LawqzwmOqc+CWLHNcwhGadtRUo470vEqrdAnmdEjXXHG35QPYUZIm8qUwL0FVW7EndTPOUNhSpXiV+4t9tKuM2zL4sF6p97UsuARpi/Hc1yLEuC+/Ajq2/eY4RSeEaTn1lRPx/89ixtvVIfs+fv35WN0SJkBNPhLbFurA6TqhixdA8DG1Mm7logzVCUi4GL5RPcsyAtWRjB2rCZOGHGAlrUCj0HlkWTr+jXW/7igs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(8676002)(316002)(26005)(66476007)(2906002)(4326008)(478600001)(8936002)(16526019)(186003)(5660300002)(53546011)(52116002)(956004)(44832011)(54906003)(66556008)(83380400001)(2616005)(36756003)(66946007)(16576012)(6486002)(31696002)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cmRzUzRnQ3Q1bkNSSU1yMGNCb3g5NkdpdjdvTnR1WkVIZWM0T1V5bEhBZ24r?=
 =?utf-8?B?VVp4cnVrSVEzVG9OVkE0NnpEZ3l3RklWb29CcVJDTXBYVjFHUlc2NkN1MVlH?=
 =?utf-8?B?dmovaFQ2WEhHRWJQNVhLYXB3NElNeHgwTWtiRzhpeTVnakpZLzNWOVBmTFhR?=
 =?utf-8?B?Vmc3dHpxcWRsd0dJVVI4bHhZMFhNZjMwczNYaU9FZDgvK0ZmQ0lhOFd0Ky9H?=
 =?utf-8?B?SUxWMDlZclZCK1FKbkliemlZWUlzaCtUQm56dC9OYU1md203ZHAzZWNKUE1Q?=
 =?utf-8?B?QmFUbTF2a3JBM09yQytoUUc4bGFEVUR4MjVCQWs1cGdqYXFjc3pRRjEyb1d0?=
 =?utf-8?B?OVBHbHJjZXN4eTdENjhPUlNvYkNZUFBzdi9yT3FXRDR5eExRM0VZdnhNd0E1?=
 =?utf-8?B?Y01sOHdqV0R0TEVMVFlqeTllRHZtb2dwNGdmL3R5aEpxNS9rcFdXNjVlMXFZ?=
 =?utf-8?B?WXN2WWFSSlJ1eHA2bEpxalJoblNSSUhxbUNqelgwZENsVlpPYWIwTXlEMjRp?=
 =?utf-8?B?M2dmYjd6ckNEOUgwbi8wdTc4UFBacEdQWXdCUGNjMlNrK09MNXRrbE5jMmti?=
 =?utf-8?B?OXBkbWQ2cWN2YkY1dm1hZ0w0YVlleEJ3aXVOajdQU2N2c21nS0xENVNtZ3ZW?=
 =?utf-8?B?eE9jUVdYRVZyU2h1bmlrMWRBRWIwRldpQ1dydUE5WnB5NjZuY3pBeHFRNXdX?=
 =?utf-8?B?SFcvUy9XY0d6ajcrYTd6YlZKMWlOVXNKTUpHakJSZkg0VVY3TTJ6bXFBTjA5?=
 =?utf-8?B?L0ZVWmxoVzE0UGdKMWZTOXpsSmhRaGoxNjVvWm9yODZ1R0RXWi9XWUE0akRT?=
 =?utf-8?B?aXI2UHdsSHFGT1JQRmQ1cG1HeVEvcUVLeXNtQWxWbmlzam45Zm5pajBwSjk4?=
 =?utf-8?B?aXFiY0FjdzBBLzlrQk9pOUdGUUo4S0NFdWJ0QTlzQ3hZS0s3TzNBUWF0dHR4?=
 =?utf-8?B?bDQzUFhUOFhMeW9vekRWbmR0WXFJTTl4YmRaN0svSjF2U0JzVkowYlB6aHc4?=
 =?utf-8?B?bFNNelk4NE1rZnpwRzdIR2lGd2lJRk5vSWVOT0VMOVI0RyttZ3ZoeEhTTGxu?=
 =?utf-8?B?cUFoWDloYzFRdmcva0UrallPcTd3QjZVdXBMZkU1Y281YjJHdDBpZWc4TFFE?=
 =?utf-8?B?Z2llb0FJWW9CUHFuVWtCbERNRDJ1ajNydkl0NzY1MTMrbGdQK0pDRm1SZ3V1?=
 =?utf-8?B?amxXbjN2MGV3QzVydzgrTDN4OTZKQ2pFQmNEU3A4OHdLaG81TXNMalhLbitq?=
 =?utf-8?B?eTljNVg1Ri9RaG9Sb3NueHBBb0pyaDZTWUtrV0QwbjBiMTRUQlZBU21hNWEr?=
 =?utf-8?B?QmI0N0dCU00yRmp1bVpNZE4rWldkNmNvMTBkalltN281MklTaml3UGM5MjNo?=
 =?utf-8?B?RzRuQ0NnUThYeG1ISGNDeG1GaFNXMWx0V08rdXV3TkVQeklVZ3J1RmxRYnpi?=
 =?utf-8?B?dU5SOEFic3ZzNlREMDZuOWl3K3c3YnR1czNRdE9rYUNYUU5UejFUQlBjaHRT?=
 =?utf-8?B?TytDRW9uWUc3RittWW1zaWRuSERCOVo3am1xM2JtSE1Va2FuQmZMa3FwV0xU?=
 =?utf-8?B?RG4rUTFhOFpRMElIOXM5UDhydlhuYVN5eUxuTS9DRXMzTHQyMHNmWEpyNzRw?=
 =?utf-8?B?Y2JvbEtrRC84enJ5WUIwRzdCbW1tSVRaVGhWdmhVWXJOY1NnM01PclpaVTNF?=
 =?utf-8?B?b3BNNmQ1bmswL3puT0UyWFNKMWZDT3g5NUxielUzQldLaU9UbHAwYmVybkJD?=
 =?utf-8?Q?a9H2UwV143RpD8tOdKIryILVHy+1wI17UuTFqy/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5495fea9-9428-4aaf-a96f-08d8d8869563
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 05:39:41.7713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EbLHGTCW2NfO2QQpGZ3RELWcC2/P8ERlP7SUcMZI5IMV6jUrLgxFgHW2Zs1u2EVxL6CQv/mfE8rsPLOfEP5y/OBb90t3FepUbpue6AaIZc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240046
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:01 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper function to centralize all the stuff we do at the end of
> a repair phase (which for now is limited to reporting progress).  The
> next patch will add more interesting things to this helper.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Looks ok:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   repair/xfs_repair.c |   22 ++++++++++++++--------
>   1 file changed, 14 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 03b7c242..a9236bb7 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -849,6 +849,12 @@ repair_capture_writeback(
>   	pthread_mutex_unlock(&wb_mutex);
>   }
>   
> +static inline void
> +phase_end(int phase)
> +{
> +	timestamp(PHASE_END, phase, NULL);
> +}
> +
>   int
>   main(int argc, char **argv)
>   {
> @@ -878,7 +884,7 @@ main(int argc, char **argv)
>   	msgbuf = malloc(DURATION_BUF_SIZE);
>   
>   	timestamp(PHASE_START, 0, NULL);
> -	timestamp(PHASE_END, 0, NULL);
> +	phase_end(0);
>   
>   	/* -f forces this, but let's be nice and autodetect it, as well. */
>   	if (!isa_file) {
> @@ -901,7 +907,7 @@ main(int argc, char **argv)
>   
>   	/* do phase1 to make sure we have a superblock */
>   	phase1(temp_mp);
> -	timestamp(PHASE_END, 1, NULL);
> +	phase_end(1);
>   
>   	if (no_modify && primary_sb_modified)  {
>   		do_warn(_("Primary superblock would have been modified.\n"
> @@ -1127,23 +1133,23 @@ main(int argc, char **argv)
>   
>   	/* make sure the per-ag freespace maps are ok so we can mount the fs */
>   	phase2(mp, phase2_threads);
> -	timestamp(PHASE_END, 2, NULL);
> +	phase_end(2);
>   
>   	if (do_prefetch)
>   		init_prefetch(mp);
>   
>   	phase3(mp, phase2_threads);
> -	timestamp(PHASE_END, 3, NULL);
> +	phase_end(3);
>   
>   	phase4(mp);
> -	timestamp(PHASE_END, 4, NULL);
> +	phase_end(4);
>   
>   	if (no_modify)
>   		printf(_("No modify flag set, skipping phase 5\n"));
>   	else {
>   		phase5(mp);
>   	}
> -	timestamp(PHASE_END, 5, NULL);
> +	phase_end(5);
>   
>   	/*
>   	 * Done with the block usage maps, toss them...
> @@ -1153,10 +1159,10 @@ main(int argc, char **argv)
>   
>   	if (!bad_ino_btree)  {
>   		phase6(mp);
> -		timestamp(PHASE_END, 6, NULL);
> +		phase_end(6);
>   
>   		phase7(mp, phase2_threads);
> -		timestamp(PHASE_END, 7, NULL);
> +		phase_end(7);
>   	} else  {
>   		do_warn(
>   _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
> 
