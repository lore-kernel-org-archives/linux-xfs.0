Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF6BC433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  7 May 2022 06:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348655AbiEGGFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 7 May 2022 02:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbiEGGFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 7 May 2022 02:05:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EB824BC4
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 23:01:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2472riDf023549;
        Sat, 7 May 2022 06:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+MB6bsZYsenoAj9GszIWIqpEyP8sDbjyKAe+V8HpWfw=;
 b=PkYF1sDhSRzOdiTOc21dxu+6Wtsf1dK7udmXhGeKYZNG0L7m23WVesUXwH5/+JqHg0q1
 6XIey+2ElWq5MwIPxUVLEc14QPfEZs48jDvgPn3xJ+7+O7/Cs7CNR6l71HY6Gke5V/Nh
 I0C4fXYKpKxQZ0qbb8C3MRd12GD4scnuHH9Q0WI/f2uBP2RxcV+1WeJGtnPoUB61f4zX
 1sRCx24Y8rDiFNwojaGAByrsu8HTAeNX7xpRUwumxCkgOd+1NrM5VzoxWK+AwHT/V9It
 KF7GcI28uc0VsRBqfeI4viW4JNRZP6GVXc75BSzCa7VEMMvsyGXTXpb/8jwmtGzBYTyQ IA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsg3tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 May 2022 06:01:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2473dwg9013806;
        Sat, 7 May 2022 06:01:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf703fnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 May 2022 06:01:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfOG3JGqgp7js1pn5nIotyRb3vKCdu7+ZdlZ3PMliu8j71XrYY0g1kkg2LREeTcQdwqeQMNkdnKbaQ1UHK7S0guYDEADSO2uPQl03JDWNImjyNnQ5XrpOAPSE4XgRjrHroRDyaEgwrs6TGNdUus99f2kP9t6OHTvSyObh2vMm2+ZonRXUC3m2wGTNwAXwI81miZBFVb99VzWK7RW6zPz3CHkbQlt1u/i/iEgGO22eX/JZ9vb4yJ8us/uBZeUd2DAc1NiZHYwe4eniECYaIel08691G7KX0Zch6UbC0wkRjWkkvj0tD92C8VCwqPZN2aezh4SQrKHOj+gEEKiE42jeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MB6bsZYsenoAj9GszIWIqpEyP8sDbjyKAe+V8HpWfw=;
 b=isBsXOD9edXTudQKkgVS8/vFQqXOwM0n32TBa3vrSo6wIMprVFrbMPqvP6qSDdPCB4vwnBNP/KaZGCeBHW7tszww4FxrCxD4SEhd+m8hIegfJuwQqXMQaGiS9bSNVmoLBnuYtWmPNtaoTK7H4sxnhQzO7c9WTPIvOqN0unFnoS4Y4J/UdJZaYzaGNnu9if1pXvAh9tCDnRO8UHJCYspQz0fZIFAbs4yxVZTf4wVoNzhpI8QwNfr4S4n0XbJGm3KbiSHhHtBiCWEzKpO4IAGBjjNbqBs0AG5OIQXHwnjhTiek8V6ncDAATUc241QZZJnFWK1blmYYLc0PymTo4w9kHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MB6bsZYsenoAj9GszIWIqpEyP8sDbjyKAe+V8HpWfw=;
 b=QKLqh0XCkllVokJThbAm1uv72ioU0/eBVpAx0nChtrPX7XguQbCBMYxvfV68J+Yn66p65P3LKotL6KAr0zzh/GVwm7nZHVd3zsXjn/AKSbS+nrq3EUgd9CwakG3+oU/xbN8JfJrLiKrht4NsdswGXxiemiH0bxp9dJxW+aZ72C4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5215.namprd10.prod.outlook.com (2603:10b6:5:3a3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sat, 7 May
 2022 06:01:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.020; Sat, 7 May 2022
 06:01:24 +0000
Message-ID: <c2159284a8b1c575140b7bbd3190fd38428b0a4d.camel@oracle.com>
Subject: Re: [PATCH 17/17] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 06 May 2022 23:01:23 -0700
In-Reply-To: <20220506094553.512973-18-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
         <20220506094553.512973-18-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:332::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d452156c-3193-4087-c311-08da2fef0435
X-MS-TrafficTypeDiagnostic: DS7PR10MB5215:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5215B625DC1A9CED50886DAC95C49@DS7PR10MB5215.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ICLppUUS0dlbUsCXYXC0bDZX2+pZrGtaqkvUN7IxcVOUEFvkUDHN2HV67fwMRgr1kIkSf5K/kD4muYWMXxsiD+FbSePj4gq6nU0TekEIQd5DrmTdlzDocHTMK+siCZNvGI4mMCmVW/1fU26k8h5QTsk6GsodVrZr/AI9QUTknNH2n74MJVFU+TUnYRGLuYBOHbFXMsTnLM4qJtb2SQrqvjMcjmF+ZvrAT8qQRdQy6K7ISKzsJI+MAe1qY5k5yWmGBojn+Zja9t3Ijw0AzpLqBOStJM+NLcRzXfHQ51OKXXVYS022eEeCGJZqyN+oQa3DSSJ03cF7j9CradQIuR3YpbsRubKR/QdE/M+EfJS5ibfXmpalCDLJmL2ENBes50tG/4bdhc0jS9aUt23mohmZsGeUa/d9V5q5sM0Cz6/Bsd8LpqEAv9pe7cQ/APQO8pmN1FXmxFAo7+bGf3iemiHcf7dPv+MfFYs3K19iGmwxq4gpRGMgAGY/sJl0GpgIbMZ3K/qwG9zOh/v/6V7vi2PiF4Kb5MB4aWSfZLq4pttSQfTjNToWb4bVlyS3R2wSvtYfb/dLmMHwMQAcLvjk3fqM/HIWFdkTh4VvV9LjZt1X3n7Uiig+S5mruBRrql4dOa95owXJypinjm4pOXutSjh/cFhZLUZ3dPFQuGoZagcPVLRQrewtvGu/JVk8A/w0wzDqGe65qothaWczW3mY1lNunw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(38100700002)(8676002)(38350700002)(508600001)(83380400001)(5660300002)(8936002)(66946007)(66556008)(66476007)(30864003)(52116002)(6486002)(2906002)(2616005)(36756003)(316002)(186003)(26005)(86362001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzA2WTlxYWRMZlIxSEd4OVBUbW9sNGtuMnB5QWE4UkZCMWlnaUM1MUpkTnFs?=
 =?utf-8?B?K0d4bTFROUI3ZXVnbm1sU2J2SHE0VVZVU1VxUFp2WlYxeHVvY096dDdKa21T?=
 =?utf-8?B?WjdrVXVQRHZ3RFcvOE80UndZa1piK0lUcEVHbGJXVk1pNkVsR0F6dW1iZVpw?=
 =?utf-8?B?QXFkNmtjNHRwUkd5RENzU2FTSXBrNXdmbFNzUmdXeTdKRjN3eWh0UUk4dTZJ?=
 =?utf-8?B?TUttaW5OUFU5amYrVnoxZkRrcUdFYktBS1g1NU5qQ1FzRndIZUExcldVSVJO?=
 =?utf-8?B?QWFKcXZGSVJUZk9kN2ZNTlNDU0lJN0RTbUJkVkFDMDgzTGJaTXllRnZvZGll?=
 =?utf-8?B?T0ZLa1I3SEtLMWhyUGJNUzhxd3FvS2tKV1RLdEovTXRpaGlMVUZHTjJvS0FJ?=
 =?utf-8?B?L3FoRVd0R21Td1kwTWk4SnROcUZuZ3ZKczRJTFEyTUNaVUZJc0Z1RERtNkpE?=
 =?utf-8?B?TGh2V2JFb0VzTTJOUVpmWW9VaEtURHplODJENnd5anlzMWVxY0VRMTNaZjhh?=
 =?utf-8?B?dVpJd3I4cFIrUVBJZXhDTDhDVzVTSzZGbzBacnk0cExUcjJJTkIxUWtha3E3?=
 =?utf-8?B?cmdraUljUXhzL3lmS2J6dUEyTDJtd281cDR2R3A1MWNiWWZXQk10b0o5RGhD?=
 =?utf-8?B?S3JvUWVhbzFvTlk1aVFlN01aelJyL2JaWDdFS2FMVGliM0JIRFRKYit5RmE0?=
 =?utf-8?B?a0piSFVwNExyWDBSU3AyOGJnSmV1NzNYMG5VdlZFeHhlWnpMOHNUdm1mVDNa?=
 =?utf-8?B?V2VFbEtyRkVQV2tNeHBvSHJ0WFBEM0hwaWNnemZzN2xiQ1k1N0dRTnNJU09I?=
 =?utf-8?B?eFNsNTl6WUQvRm93ZSsxVkZURHpFQkZzVU5WcGRGMnlhNmV5QzhSMXdXelZI?=
 =?utf-8?B?T3FCUU1sRFZud2c2RFAvNC9ZRnFNeDFmbU5UaGdGdnQwdmFSekFtdU9UaEZ1?=
 =?utf-8?B?c0NMS2x5dXg1NjYxazZBODVZaVRRL1V6YXZ2VmtRc0JJRC9OOGFrQXZ5YUg0?=
 =?utf-8?B?TnZwai9GZjdnaitycEpwMTRndnNGSkhjZzlxN2djcmwvQVd1aWcyRXZzU2lS?=
 =?utf-8?B?Z3ZyZExQcFJ1dENlNnBhY0JDazhUeUZadStuSE8yaEg1MnIvTjFNNVFUUTRR?=
 =?utf-8?B?VzEzNzdtd0liVXhyeG5xY0diS2xkWk9lbmpFaWR6RUl3OVJucVJVbHZxV2dR?=
 =?utf-8?B?bkRzdkZlN0cxV2NOME5VT2dWRzVwZmphNmVDMm85di9UYkFSTGtzcmFaK0Fa?=
 =?utf-8?B?VUZsOHhlU2VkdjlpRCtvRlZPeFQ5N3dBTXFmQ0lXNVJmdW5uK0hGSUU2bVZ5?=
 =?utf-8?B?QnhpNjhGNElpYjJzbDlSbDhiU3VxUkRLUmFKUmdTbjh4Qld0aXFJanB6aXNy?=
 =?utf-8?B?NThDVnBKTS9PR2V1aFZzRzdSVi90SjBKRS9YSmpaMEtLRWYwcGZ4UUZrcDh2?=
 =?utf-8?B?ZVQ5ZndtdkFpWTAvbThtUnFnaWRYbzBKNVNuWTRzeG9Pd2JNVzFLQ0ZtVGhX?=
 =?utf-8?B?Sm1XSlY4TnNnYkNlSHhBc0doV0tXVmRPekVXejdNMlZnSlN4eUJzbGc3MWN2?=
 =?utf-8?B?YmZnS3JibDNZdVFhM2luaTg0eTV5TXZRc0JGaUY2NWJQbVRuRlR4anpIV1Rq?=
 =?utf-8?B?MUx5aVRidGIzZWY2eU8zU0M1U1VCdncycG9CTk96STJpbG1OaXlGb3dkeUY4?=
 =?utf-8?B?TXVJL1N4YXVDdWdPVUlOcTJJUGZsZDV5eGtKUGhManlRN2Jta2VySUptbmN2?=
 =?utf-8?B?cnV0d2xUS0lQbCsxUVRVb2dhTEoxUENmZUNZcDhvMDlvb0dsaEJCdExUQUJv?=
 =?utf-8?B?N1dsWkE4dCtWUTRwUHU5QUY0Vmc5QldnV0JDdC82ZXZiYVk3ay9SbllvTFhJ?=
 =?utf-8?B?eWFjY295ZWptSmV4SWlUS1ZTZHp6dGJjZXFUOERYRTJpc2oyc2t6VUlkUXF4?=
 =?utf-8?B?aVNDVUdDMHd1cDU5dE80SHl6Z0dOaHNvTzIvL3ZWMzFIOHU4aGdqcWpPTzVL?=
 =?utf-8?B?N0gwMmRnU3JFbGVtU3AyZ29ialdXZXNmdlhEVTcyWTFLbFUyV0pWdjlIY0Z0?=
 =?utf-8?B?Y0EyNzlSWjU5UnRNKzUrZi9leXR0cGtJNHdsdjJqTytoL0hFa0ZHbUF3cjBD?=
 =?utf-8?B?dXRncHFQbDZyUnhTdUp1Sy9OWXhOK3N4dE91MjR1QkNpYjNDOXU4YzdONHJT?=
 =?utf-8?B?eHZ2KzcwVVRRM3lNQVBrYU1iNkVSTUpOd2RSbkp6UldwUzRrQ1ZlTTN1eUZ1?=
 =?utf-8?B?N1VIc1FXWG94V2RWVE1xcml1UTcwRWJQbWdFbTU2Znk2RnMvcTU3VlRTUXFD?=
 =?utf-8?B?Z3h1dVJsQW5nRTZObmswTVBvb3p4dnBjT1NXQnNNTW92WTd2bFBoTVkwRmEz?=
 =?utf-8?Q?KflN9VvMY4zxKgu8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d452156c-3193-4087-c311-08da2fef0435
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2022 06:01:24.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAGMlsjwAArhg2cwvhUg783Xd6AQQBnI1YWxdZ9o5DGNZ7l/1ocmNc3cKqgSMNLbvPaGV+b6QXvgcgnUNmS27UeJXny7qZHwZeEPm0+HqhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5215
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-07_01:2022-05-05,2022-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205070020
X-Proofpoint-GUID: Ibl8-asVZk_hOdHltsSrVJxxreHXQawh
X-Proofpoint-ORIG-GUID: Ibl8-asVZk_hOdHltsSrVJxxreHXQawh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-05-06 at 19:45 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We can't use the same algorithm for replacing an existing attribute
> when logging attributes. The existing algorithm is essentially:
> 
> 1. create new attr w/ INCOMPLETE
> 2. atomically flip INCOMPLETE flags between old + new attribute
> 3. remove old attr which is marked w/ INCOMPLETE
> 
> This algorithm guarantees that we see either the old or new
> attribute, and if we fail after the atomic flag flip, we don't have
> to recover the removal of the old attr because we never see
> INCOMPLETE attributes in lookups.
> 
> For logged attributes, however, this does not work. The logged
> attribute intents do not track the work that has been done as the
> transaction rolls, and hence the only recovery mechanism we have is
> "run the replace operation from scratch".
> 
> This is further exacerbated by the attempt to avoid needing the
> INCOMPLETE flag to create an atomic swap. This means we can create
> a second active attribute of the same name before we remove the
> original. If we fail at any point after the create but before the
> removal has completed, we end up with duplicate attributes in
> the attr btree and recovery only tries to replace one of them.
> 
> There are several other failure modes where we can leave partially
> allocated remote attributes that expose stale data, partially free
> remote attributes that enable UAF based stale data exposure, etc.
> 
> TO fix this, we need a different algorithm for replace operations
> when LARP is enabled. Luckily, it's not that complex if we take the
> right first step. That is, the first thing we log is the attri
> intent with the new name/value pair and mark the old attr as
> INCOMPLETE in the same transaction.
> 
> From there, we then remove the old attr and keep relogging the
> new name/value in the intent, such that we always know that we have
> to create the new attr in recovery. Once the old attr is removed,
> we then run a normal ATTR_CREATE operation relogging the intent as
> we go. If the new attr is local, then it gets created in a single
> atomic transaction that also logs the final intent done. If the new
> attr is remote, the we set INCOMPLETE on the new attr while we
> allocate and set the remote value, and then we clear the INCOMPLETE
> flag at in the last transaction taht logs the final intent done.
> 
> If we fail at any point in this algorithm, log recovery will always
> see the same state on disk: the new name/value in the intent, and
> either an INCOMPLETE attr or no attr in the attr btree. If we find
> an INCOMPLETE attr, we run the full replace starting with removing
> the INCOMPLETE attr. If we don't find it, then we simply create the
> new attr.
> 
> Notably, recovery of a failed create that has an INCOMPLETE flag set
> is now the same - we start with the lookup of the INCOMPLETE attr,
> and if that exists then we do the full replace recovery process,
> otherwise we just create the new attr.
> 
> Hence changing the way we do the replace operation when LARP is
> enabled allows us to use the same log recovery algorithm for both
> the ATTR_CREATE and ATTR_REPLACE operations. This is also the same
> algorithm we use for runtime ATTR_REPLACE operations (except for the
> step setting up the initial conditions).
> 
> The result is that:
> 
> - ATTR_CREATE uses the same algorithm regardless of whether LARP is
>   enabled or not
> - ATTR_REPLACE with larp=0 is identical to the old algorithm
> - ATTR_REPLACE with larp=1 runs an unmodified attr removal algorithm
>   from the larp=0 code and then runs the unmodified ATTR_CREATE
>   code.
> - log recovery when larp=1 runs the same ATTR_REPLACE algorithm as
>   it uses at runtime.
> 
> Because the state machine is now quite clean, changing the algorithm
> is really just a case of changing the initial state and how the
> states link together for the ATTR_REPLACE case. Hence it's not a
> huge amoutn of code for what is a fairly substantial rework
> of the attr logging and recovery algorithm....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
This looks mostly good, though when I run it with the new tests, I seem
to run into a failed filesystem check at the end.  "bad attribute count
0 in attr block 0".  I suspect we still dont have the removal of the
fork quite right.  It sounds like you're still working with things
though, I'll keep looking too.

Allison

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 97 +++++++++++++++++++++----------
> ----
>  fs/xfs/libxfs/xfs_attr.h      | 49 +++++++++++-------
>  fs/xfs/libxfs/xfs_attr_leaf.c | 44 +++++++++++++---
>  fs/xfs/libxfs/xfs_da_btree.h  |  4 +-
>  fs/xfs/xfs_attr_item.c        |  8 ++-
>  fs/xfs/xfs_trace.h            |  7 +--
>  6 files changed, 137 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 546e17574488..83fefee44bbe 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -71,9 +71,12 @@ int
>  xfs_inode_hasattr(
>  	struct xfs_inode	*ip)
>  {
> -	if (!XFS_IFORK_Q(ip) ||
> -	    (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> -	     ip->i_afp->if_nextents == 0))
> +	if (!XFS_IFORK_Q(ip))
> +		return 0;
> +	if (!ip->i_afp)
> +		return 0;
> +	if (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
> +	    ip->i_afp->if_nextents == 0)
>  		return 0;
>  	return 1;
>  }
> @@ -411,23 +414,30 @@ xfs_attr_sf_addname(
>  }
>  
>  /*
> - * When we bump the state to REPLACE, we may actually need to skip
> over the
> - * state. When LARP mode is enabled, we don't need to run the atomic
> flags flip,
> - * so we skip straight over the REPLACE state and go on to
> REMOVE_OLD.
> + * Handle the state change on completion of a multi-state attr
> operation.
> + *
> + * If the XFS_DA_OP_REPLACE flag is set, this means the operation
> was the first
> + * modification in a attr replace operation and we still have to do
> the second
> + * state, indicated by @replace_state.
> + *
> + * We consume the XFS_DA_OP_REPLACE flag so that when we are called
> again on
> + * completion of the second half of the attr replace operation we
> correctly
> + * signal that it is done.
>   */
> -static void
> -xfs_attr_dela_state_set_replace(
> +static enum xfs_delattr_state
> +xfs_attr_complete_op(
>  	struct xfs_attr_item	*attr,
> -	enum xfs_delattr_state	replace)
> +	enum xfs_delattr_state	replace_state)
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
> +	bool			do_replace = args->op_flags &
> XFS_DA_OP_REPLACE;
>  
> -	ASSERT(replace == XFS_DAS_LEAF_REPLACE ||
> -			replace == XFS_DAS_NODE_REPLACE);
> -
> -	attr->xattri_dela_state = replace;
> -	if (xfs_has_larp(args->dp->i_mount))
> -		attr->xattri_dela_state++;
> +	args->op_flags &= ~XFS_DA_OP_REPLACE;
> +	if (do_replace) {
> +		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
> +		return replace_state;
> +	}
> +	return XFS_DAS_DONE;
>  }
>  
>  static int
> @@ -469,10 +479,9 @@ xfs_attr_leaf_addname(
>  	 */
>  	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> -	else if (args->op_flags & XFS_DA_OP_REPLACE)
> -		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_LEAF_REPLACE);
>  	else
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +							XFS_DAS_LEAF_RE
> PLACE);
>  out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
> @@ -514,10 +523,9 @@ xfs_attr_node_addname(
>  
>  	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
> -	else if (args->op_flags & XFS_DA_OP_REPLACE)
> -		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_NODE_REPLACE);
>  	else
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +							XFS_DAS_NODE_RE
> PLACE);
>  out:
>  	trace_xfs_attr_node_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
> @@ -549,18 +557,15 @@ xfs_attr_rmtval_alloc(
>  	if (error)
>  		return error;
>  
> -	/* If this is not a rename, clear the incomplete flag and we're
> done. */
> -	if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
> +	attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						++attr-
> >xattri_dela_state);
> +	/*
> +	 * If we are not doing a rename, we've finished the operation
> but still
> +	 * have to clear the incomplete flag protecting the new attr
> from
> +	 * exposing partially initialised state if we crash during
> creation.
> +	 */
> +	if (attr->xattri_dela_state == XFS_DAS_DONE)
>  		error = xfs_attr3_leaf_clearflag(args);
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> -	} else {
> -		/*
> -		 * We are running a REPLACE operation, so we need to
> bump the
> -		 * state to the step in that operation.
> -		 */
> -		attr->xattri_dela_state++;
> -		xfs_attr_dela_state_set_replace(attr, attr-
> >xattri_dela_state);
> -	}
>  out:
>  	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
>  	return error;
> @@ -685,13 +690,24 @@ xfs_attr_set_iter(
>  		return xfs_attr_node_addname(attr);
>  
>  	case XFS_DAS_SF_REMOVE:
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> -		return xfs_attr_sf_removename(args);
> +		error = xfs_attr_sf_removename(args);
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
> +		break;
>  	case XFS_DAS_LEAF_REMOVE:
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> -		return xfs_attr_leaf_removename(args);
> +		error = xfs_attr_leaf_removename(args);
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
> +		break;
>  	case XFS_DAS_NODE_REMOVE:
>  		error = xfs_attr_node_removename_setup(attr);
> +		if (error == -ENOATTR &&
> +		    (args->op_flags & XFS_DA_OP_RECOVERY)) {
> +			attr->xattri_dela_state =
> xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
> +			error = 0;
> +			break;
> +		}
>  		if (error)
>  			return error;
>  		attr->xattri_dela_state = XFS_DAS_NODE_REMOVE_RMT;
> @@ -777,12 +793,14 @@ xfs_attr_set_iter(
>  
>  	case XFS_DAS_LEAF_REMOVE_ATTR:
>  		error = xfs_attr_leaf_remove_attr(attr);
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
>  		break;
>  
>  	case XFS_DAS_NODE_REMOVE_ATTR:
>  		error = xfs_attr_node_remove_attr(attr);
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -1284,9 +1302,10 @@ xfs_attr_leaf_removename(
>  	dp = args->dp;
>  
>  	error = xfs_attr_leaf_hasname(args, &bp);
> -
>  	if (error == -ENOATTR) {
>  		xfs_trans_brelse(args->trans, bp);
> +		if (args->op_flags & XFS_DA_OP_RECOVERY)
> +			return 0;
>  		return error;
>  	} else if (error != -EEXIST)
>  		return error;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index e93efc8b11cd..7467d31cb3f1 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -444,18 +444,23 @@ struct xfs_attr_list_context {
>   */
>  enum xfs_delattr_state {
>  	XFS_DAS_UNINIT		= 0,	/* No state has been set yet
> */
> -	XFS_DAS_SF_ADD,			/* Initial shortform set iter
> state */
> -	XFS_DAS_LEAF_ADD,		/* Initial leaf form set iter state
> */
> -	XFS_DAS_NODE_ADD,		/* Initial node form set iter state
> */
> -	XFS_DAS_RMTBLK,			/* Removing remote blks */
> -	XFS_DAS_RM_NAME,		/* Remove attr name */
> -	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree
> */
> -
> -	XFS_DAS_SF_REMOVE,		/* Initial shortform set iter
> state */
> -	XFS_DAS_LEAF_REMOVE,		/* Initial leaf form set iter
> state */
> -	XFS_DAS_NODE_REMOVE,		/* Initial node form set iter
> state */
> -
> -	/* Leaf state set/replace sequence */
> +
> +	/*
> +	 * Initial sequence states. The replace setup code relies on
> the
> +	 * ADD and REMOVE states for a specific format to be sequential
> so
> +	 * that we can transform the initial operation to be performed
> +	 * according to the xfs_has_larp() state easily.
> +	 */
> +	XFS_DAS_SF_ADD,			/* Initial sf add state */
> +	XFS_DAS_SF_REMOVE,		/* Initial sf replace/remove
> state */
> +
> +	XFS_DAS_LEAF_ADD,		/* Initial leaf add state */
> +	XFS_DAS_LEAF_REMOVE,		/* Initial leaf
> replace/remove state */
> +
> +	XFS_DAS_NODE_ADD,		/* Initial node add state */
> +	XFS_DAS_NODE_REMOVE,		/* Initial node
> replace/remove state */
> +
> +	/* Leaf state set/replace/remove sequence */
>  	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a
> leaf */
>  	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a
> leaf */
> @@ -463,7 +468,7 @@ enum xfs_delattr_state {
>  	XFS_DAS_LEAF_REMOVE_RMT,	/* A rename is removing remote blocks
> */
>  	XFS_DAS_LEAF_REMOVE_ATTR,	/* Remove the old attr from a leaf */
>  
> -	/* Node state set/replace sequence, must match leaf state above
> */
> +	/* Node state sequence, must match leaf state above */
>  	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a
> node */
>  	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote
> blocks */
>  	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a
> node */
> @@ -477,11 +482,11 @@ enum xfs_delattr_state {
>  #define XFS_DAS_STRINGS	\
>  	{ XFS_DAS_UNINIT,		"XFS_DAS_UNINIT" }, \
>  	{ XFS_DAS_SF_ADD,		"XFS_DAS_SF_ADD" }, \
> +	{ XFS_DAS_SF_REMOVE,		"XFS_DAS_SF_REMOVE" }, \
>  	{ XFS_DAS_LEAF_ADD,		"XFS_DAS_LEAF_ADD" }, \
> +	{ XFS_DAS_LEAF_REMOVE,		"XFS_DAS_LEAF_REMOVE" }, \
>  	{ XFS_DAS_NODE_ADD,		"XFS_DAS_NODE_ADD" }, \
> -	{ XFS_DAS_RMTBLK,		"XFS_DAS_RMTBLK" }, \
> -	{ XFS_DAS_RM_NAME,		"XFS_DAS_RM_NAME" }, \
> -	{ XFS_DAS_RM_SHRINK,		"XFS_DAS_RM_SHRINK" }, \
> +	{ XFS_DAS_NODE_REMOVE,		"XFS_DAS_NODE_REMOVE" }, \
>  	{ XFS_DAS_LEAF_SET_RMT,		"XFS_DAS_LEAF_SET_RMT" }, \
>  	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
>  	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
> @@ -525,8 +530,7 @@ struct xfs_attr_item {
>  	enum xfs_delattr_state		xattri_dela_state;
>  
>  	/*
> -	 * Indicates if the attr operation is a set or a remove
> -	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
> +	 * Attr operation being performed - XFS_ATTR_OP_FLAGS_*
>  	 */
>  	unsigned int			xattri_op_flags;
>  
> @@ -605,10 +609,19 @@ xfs_attr_init_remove_state(struct xfs_da_args
> *args)
>  	return XFS_DAS_NODE_REMOVE;
>  }
>  
> +/*
> + * If we are logging the attributes, then we have to start with
> removal of the
> + * old attribute so that there is always consistent state that we
> can recover
> + * from if the system goes down part way through. We always log the
> new attr
> + * value, so even when we remove the attr first we still have the
> information in
> + * the log to finish the replace operation atomically.
> + */
>  static inline enum xfs_delattr_state
>  xfs_attr_init_replace_state(struct xfs_da_args *args)
>  {
>  	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
> +	if (xfs_has_larp(args->dp->i_mount))
> +		return xfs_attr_init_remove_state(args);
>  	return xfs_attr_init_add_state(args);
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c
> b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 53d02ce9ed78..d15e92858bf0 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -446,6 +446,14 @@ xfs_attr3_leaf_read(
>   * Namespace helper routines
>  
> *====================================================================
> ====*/
>  
> +/*
> + * If we are in log recovery, then we want the lookup to ignore the
> INCOMPLETE
> + * flag on disk - if there's an incomplete attr then recovery needs
> to tear it
> + * down. If there's no incomplete attr, then recovery needs to tear
> that attr
> + * down to replace it with the attr that has been logged. In this
> case, the
> + * INCOMPLETE flag will not be set in attr->attr_filter, but rather
> + * XFS_DA_OP_RECOVERY will be set in args->op_flags.
> + */
>  static bool
>  xfs_attr_match(
>  	struct xfs_da_args	*args,
> @@ -453,14 +461,18 @@ xfs_attr_match(
>  	unsigned char		*name,
>  	int			flags)
>  {
> +
>  	if (args->namelen != namelen)
>  		return false;
>  	if (memcmp(args->name, name, namelen) != 0)
>  		return false;
> -	/*
> -	 * If we are looking for incomplete entries, show only those,
> else only
> -	 * show complete entries.
> -	 */
> +
> +	/* Recovery ignores the INCOMPLETE flag. */
> +	if ((args->op_flags & XFS_DA_OP_RECOVERY) &&
> +	    args->attr_filter == (flags & XFS_ATTR_NSP_ONDISK_MASK))
> +		return true;
> +
> +	/* All remaining matches need to be filtered by INCOMPLETE
> state. */
>  	if (args->attr_filter !=
>  	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
>  		return false;
> @@ -799,6 +811,14 @@ xfs_attr_sf_removename(
>  	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
>  
>  	error = xfs_attr_sf_findname(args, &sfe, &base);
> +
> +	/*
> +	 * If we are recovering an operation, finding nothing to
> +	 * remove is not an error - it just means there was nothing
> +	 * to clean up.
> +	 */
> +	if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
> +		return 0;
>  	if (error != -EEXIST)
>  		return error;
>  	size = xfs_attr_sf_entsize(sfe);
> @@ -819,7 +839,7 @@ xfs_attr_sf_removename(
>  	totsize -= size;
>  	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp)
> &&
>  	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> -	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
> +	    !(args->op_flags & (XFS_DA_OP_ADDNAME |
> XFS_DA_OP_REPLACE))) {
>  		xfs_attr_fork_remove(dp, args->trans);
>  	} else {
>  		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
> @@ -1128,9 +1148,17 @@ xfs_attr3_leaf_to_shortform(
>  		goto out;
>  
>  	if (forkoff == -1) {
> -		ASSERT(xfs_has_attr2(dp->i_mount));
> -		ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
> -		xfs_attr_fork_remove(dp, args->trans);
> +		/*
> +		 * Don't remove the attr fork if this operation is the
> first
> +		 * part of a attr replace operations. We're going to
> add a new
> +		 * attr immediately, so we need to keep the attr fork
> around in
> +		 * this case.
> +		 */
> +		if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
> +			ASSERT(xfs_has_attr2(dp->i_mount));
> +			ASSERT(dp->i_df.if_format !=
> XFS_DINODE_FMT_BTREE);
> +			xfs_attr_fork_remove(dp, args->trans);
> +		}
>  		goto out;
>  	}
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h
> b/fs/xfs/libxfs/xfs_da_btree.h
> index 13ee2e34f92f..835d1a1da648 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -91,6 +91,7 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if
> found */
>  #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode
> timestamps */
>  #define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation
> */
> +#define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> @@ -99,7 +100,8 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
>  	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
> -	{ XFS_DA_OP_REMOVE,	"REMOVE" }
> +	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
> +	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }
>  
>  
>  /*
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index fb9549e7ea96..50ad3aa891ee 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -554,6 +554,7 @@ xfs_attri_item_recover(
>  	args->namelen = attrp->alfi_name_len;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
>  	args->attr_filter = attrp->alfi_attr_flags;
> +	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
>  
>  	switch (attrp->alfi_op_flags & XFS_ATTR_OP_FLAGS_TYPE_MASK) {
>  	case XFS_ATTR_OP_FLAGS_SET:
> @@ -561,9 +562,14 @@ xfs_attri_item_recover(
>  		args->value = attrip->attri_value;
>  		args->valuelen = attrp->alfi_value_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> -		attr->xattri_dela_state =
> xfs_attr_init_add_state(args);
> +		if (xfs_inode_hasattr(args->dp))
> +			attr->xattri_dela_state =
> xfs_attr_init_replace_state(args);
> +		else
> +			attr->xattri_dela_state =
> xfs_attr_init_add_state(args);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		if (!xfs_inode_hasattr(args->dp))
> +			goto out;
>  		attr->xattri_dela_state =
> xfs_attr_init_remove_state(args);
>  		break;
>  	default:
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 01b047d86cd1..d32026585c1b 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4131,13 +4131,10 @@ DEFINE_ICLOG_EVENT(xlog_iclog_write);
>  
>  TRACE_DEFINE_ENUM(XFS_DAS_UNINIT);
>  TRACE_DEFINE_ENUM(XFS_DAS_SF_ADD);
> -TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
> -TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
> -TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
> -TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
> -TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
>  TRACE_DEFINE_ENUM(XFS_DAS_SF_REMOVE);
> +TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE);
> +TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
>  TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
>  TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);

