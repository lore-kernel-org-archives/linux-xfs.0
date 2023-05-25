Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C076BC77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 09:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242962AbjEZJFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 05:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242942AbjEZJFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 05:05:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2086419C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:05:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q84lAp008628;
        Fri, 26 May 2023 09:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=1ivLL1VIqvayXfdQzlOLx1FlU/ZGfF1H7a+rPhe7zmk=;
 b=R0EPZEHc6KMOcQY9L+M8Vni9ZXo27dbaXctte7KBgFX+S1KGceXTb3fWfEz5UpsMHVMD
 ivlUcsP3XMZCgQ4deW7Ie8CCFRTnCTnzjN6nrzZ4qogYRDh5WPY3BMs0Yv6/dMCBOwF3
 v7hXVD8gMt9bfcwjHaCuPVbuWbAaMDVAnEuURbqYhVr0hx5rmpnAfJN9rtQ78MkguUnX
 ueJEQoggtzWgjAiE1yVn9m0OE9IaP0zzs46Dr61meWe6aHwacd9ibV8SJ9Uv3SSZfOMG
 5WEIQVYr8MTJBcIGtzWzmpnYKMf1gE88Bq41Vvpq7wnT+L2MRb7WeNwZIPyqWKSuHC9l rQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg5hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 09:05:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q88uKB028715;
        Fri, 26 May 2023 08:51:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2uy2x7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:51:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vwt5+iRL3xQMj9fL5OASFc9qEnTTAhMDejQ22HTP7XjNHtPPhoJTusyeTvbWq7teaZHfJ91lrZeI0wOiWC6nNAG9JMP2O50URO4HrFuOzUPgFD5Aw1aqrf9W3DotIuO6mPtYJhcEfXEi3y34nMqFcJAwRIw/bE5q/1nCJXHhJXExIVB4C4AdA5wAokV4DdIhRXKhghaM/UMo17gPD05f7rAYpwysq6T5030FhLEp0cV5DJjmBhoJ96ZBgJ+WRKbNZ/Ac94hJTVN0FfNkfiGFmJlesuqBpwADnBbuS6uAK4XcoKaq752qHYbxEsEASDgeuzZw15BsvNoerwOqoJmlYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ivLL1VIqvayXfdQzlOLx1FlU/ZGfF1H7a+rPhe7zmk=;
 b=Dx5q019f4q1liFDK9XxcXABHYB8QjWuMSmjIhiYazU5YGHauGXwekn+Yjw5+3HmX50R7PDlxbcK7HC6/GsZj7hJ0cyqome2r/HCHIKIIkVrZY0Gzx7oAejrAPiZcieJby5nAq564zn4zu9AM7FzIvqENcMCW8V8bPRvCJhLcuLk/LpILPDMwWp39pEDnvyhbD38GDsyLgzBPY/iGzR6wDYMOMGR88AirRj59aYLi3xW7+Z1j+gtuyoeQf0QGVF9FYlpSRAIfJGE/qF0R5c+q0gB0c3Fr3YLUjkkDnQhSpEGxqQUSyHCW/QpOrh7vplf3D4dr+LKGrpGLdTDij4uxiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ivLL1VIqvayXfdQzlOLx1FlU/ZGfF1H7a+rPhe7zmk=;
 b=VSaeJxCxT10kbkRmcypXfmOHA2iKNPTPx586DQ8A1En7pGSRRpM09/2VGbKNEdlY0Gak8JBrrYAP3OWNaa/5+ZSay5LqNEPx1X4wZ9WrKQraK4SH/b7asVgmQr+wyTYcRgvzLadXuN3AUIKMZ2nqyuVZXeFxZUtDvsKk613xTJw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:51:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:51:25 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-15-chandan.babu@oracle.com>
 <20230523173930.GT11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs_metadump.sh: Add support for passing version
 option
Date:   Thu, 25 May 2023 15:01:53 +0530
In-reply-to: <20230523173930.GT11620@frogsfrogsfrogs>
Message-ID: <87cz2njx17.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f6e0451-8ea7-458d-a898-08db5dc66347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DTEvjKV7MkIlGO0NF/sz5D6phQEjv5fAe6/3wS2LpIhhdVCcUqR/eOGA113Bati13t2rAfqa21GKP40Wh8n71FdNAzgEnaQ6+qpk/yncgndbG+3cdnEvhqdqOBqDzCjBrClQs3YlEbOKzD7ElGg5QokxkmSlmGd+jQmdvWGVtUCnyCrtpAvXKANzPJPdY7VmGso46bIWlJI/mZeiCHunRaon3G26pXaDmkC6C57T1ia1JEEgb9to/6jEsMen/HALZfya1KgPuOxh0CqhxYkT0jbCdhbl20bILb8tDC3SsfW0FKYKmNipxGXzd0x5oEVSzDQxsZdnKazpEB9rzucLNivX39Fxe5lBCvYveR1YO+jsPqbQMbwbWXJOTqt4sVFWs67zQ4qOB7HdUaefEjB4KTEe2s6MGF7NnzBx9niAyxh4p5KaT2l8Axn/27Wlw0KRzPGpiktoHFniK6+wyWZa9zjrIPNjTL9VTYpem7z7F6h3tH52ketRmfKbrmmIlQMxFWHLaRbKk3aiwL/w0EkDbzr9vtc2EmmB5DM1KEm1Q0TpjY0Grt6afJyvbfJPyzmV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(4744005)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5dlaH6h1rwOZ6zZdG8uhAlVAgMvYULagSTpYuygCNazyaUIrDLUB272hUerZ?=
 =?us-ascii?Q?8Rh6UvXgkZ12Wm5EGfLiVjmTEF1pbSd8NEHDMDvbOusPrb+FQM5mpPfFXuWv?=
 =?us-ascii?Q?LV2JFZK4tacSsmwf3d+EvEDnSy21ziCO7sPlE+DlA7pRhoI4zQSM1yJ7Gsgi?=
 =?us-ascii?Q?FjymVMJ0RNvGZZjYVvFtBwUj2Crc8A6YEmmJUAzSHpw6pO3QvzuIiD+6+s2z?=
 =?us-ascii?Q?rwpuwCpUKM5ohpdvEYVgMOWsi7TUSQRQSVOdz9nOWwJynwUiFPNcd5Yf+zse?=
 =?us-ascii?Q?fN4ymPGcC6Zn2nCZez42L8SYiUXIeEI3LBdmeCtYouiTfNV0K/LOrerZiEj1?=
 =?us-ascii?Q?oSv12+S5d4BH1H6seTlrat4kFkDE6NGnvTQUNNj+6f5qHTiomSEjtiYBlBcW?=
 =?us-ascii?Q?RX4TJpsm8fYTnEOD7Ws/PuoSEPYm5PIdHFsoSoBqkA8r1taObhPO0Mn+weUs?=
 =?us-ascii?Q?exbtrAfh5JZTnV0tS1ieubG92W1TvvmjAI9iIlj4DDyyB6P65VWaCqbWsdT6?=
 =?us-ascii?Q?2KK5eCDBHVQmsANSSiI0c9OKCoSIBxwEu43ZAL/TU4EA33XOoPLs7J5gnobD?=
 =?us-ascii?Q?Tp9Lopgwg8eb+tmUoIeFANd58VUBT15WElMAeP+KhTRUbWpxJLNdXZsQPW86?=
 =?us-ascii?Q?mUXxvGprj70i5IP7It4CCIx8OPThBtvEnWwBN504kVypDyNe1VjE5HYy3z0z?=
 =?us-ascii?Q?r/xLFU5tAD7HAVWNya1iEeOBQ5uFpVhxcdx6X22ZAzWBR4yC979IjuYEVC16?=
 =?us-ascii?Q?Blo2uK/y+Okn8HQqJc7bhOKAjV2fXOvVJCdJEG+O0/JWJXj/yVCMI4MJSZpF?=
 =?us-ascii?Q?7LrEWuTxxpRdrxwnWd2LlIRQPQ8/GugevAHWFCXGTVnjx/mNxzXZDn4i4Nj1?=
 =?us-ascii?Q?Nem9mqAlHsciACrxlbjGihdTiZVGHKTG0VsDnaelOS/+01n83cn7LqhW+feR?=
 =?us-ascii?Q?FWsTcZNEfM3DUnT3dzWexvWvjwlDYY4ZABxzBHlZWPFxw5L2Qg0tO83AaaBC?=
 =?us-ascii?Q?baIyVv+cvkuGw1I4ZaTdIiKIwaUO5e1elew+yTJ6Vm9KF8ZKINT23ELRv04b?=
 =?us-ascii?Q?BiUqV0JePv/92QmVZctS5QzK63sT8ELCIJphLeOyzRoG3BaS7HJL5lD9htpi?=
 =?us-ascii?Q?hUakbROs7HpR3KIwElzcG7VjzYSVa95ANTg3/dKeuo82YP8Yao+oHrRnyjQi?=
 =?us-ascii?Q?s6xWwFDW3FKh+K6rrxSEa+DraOHZpBgvuhX/el39N2Nz8vnVV6x3QLfA/dTu?=
 =?us-ascii?Q?XI3PDeX2WNa5hZAx762ll3kbRTtUXXwZ9RVWDej7yyUWflTXvGJDZ+6wvuae?=
 =?us-ascii?Q?klr9MmOAk2D+2tuALNXV/hy8NzD2AhTnAYFgRA0byKqEa1N4c2f2WL6dy48a?=
 =?us-ascii?Q?VKPOqpUSWoKijf4MfxLD5J4u2mah00hYaEGmTpqfL15zX8F1wjlFIg3f5XFp?=
 =?us-ascii?Q?xw+3t4bs0oaIVkdokEySxRU6VM+HYp7yWgYMIJgq4XIgXnw7glcYFDtirtZA?=
 =?us-ascii?Q?SJxgUV/SsyqnEH+5JmIDbqyhC1esF+UFoBhBDbEKmxhlflPbh1urn4YzEVfl?=
 =?us-ascii?Q?rwglfTAa3wAq7+/JlvvvXz8QkcMRF3rpCYmtti57?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: b3PSCcRQWA3AdrvaLeNvSnJUJePlXiTK/4y4b2i6Iu29vhMRLYPCVYOiKRFboYVsl1cGsnTzygtQGhGXwRslIBpTPnhJX5yG6auaZ0hcm1EdzSlVQAyNvKtlJq2StkIcu/wLk7saJoSW61SwnHqEFgKNqbxJWOcGxfg0QKm6Ygx+jUWsGx0nuOIgTN0O4fCzM00WGjcbTXQWYegTyYQVDkVQafhyuvikMjJUTChjEbgBWMdJyKN/6iCBqhPFZM2UTaAQdIRh5NtkWthqMWNVcCJyOzhc9Ut2+bplhu4hjuNciyMHgpdO7SFwr6nVNvCdJgYet3LJWSCqrr/yvrzc/yv1Kv2qcU5LTQ1M7Evy9pu9VWfP/4umN4jtDRNsUOtQivsaIjS7NxJk8hAK4F6zbwnud2LTYKIiqnSB7fjOrZ2GpK3pxOvdHaKMA7LNB7OfxVjBVY2ZDl35JCV1zgwyvqy2ytxRAd0HPTE2ediDEoW52AuI6VyGuALEyxA7QLjHjlWBhYn8ZyNSgXtUXDaVNcIJA+8uIbRjJXFb2rkB0TKRbDv25Hsf8lm5kPgRvvZh8rpq29ti3pA1pbnna2gPkL7gGRNw8tVGfXTnCJkmo327UZuVaWhatQiaWp2zof3Gpu7x8jpuCk/jXEStHSOVP9zrq5JTiLXxPB/m0Kdzu43i5JLcVtbEOacw/4oP1ztzCTxbYyQ+4SVe6+ms0IiCpND+HkyssrfeNzZ/mKoLOZysBC5RbpXVOuo8HNu4b2MNbWaOr7BtlXlQGzwONRbPB8mp2C5/vArD9Heo4jUJMJQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6e0451-8ea7-458d-a898-08db5dc66347
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:51:25.5393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0MOZy/yUe9XUKqdf4XPVKmG9IYX2xsNPv9m3huNNVkWQUuoeNQEa9KOsxUrsweFYmPtl8I7K0gq5wqqYKKUq2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=762 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260075
X-Proofpoint-GUID: 1Kk4iskixcTOVbYbETsT6KjAVzmScyMW
X-Proofpoint-ORIG-GUID: 1Kk4iskixcTOVbYbETsT6KjAVzmScyMW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:39:30 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:40PM +0530, Chandan Babu R wrote:
>> The new option allows the user to explicitly specify which version of
>> metadump to use. However, we will default to using the v1 format.
>
> Needs SOB tag.

I will add my SOB tag and resend the patchset.

-- 
chandan
