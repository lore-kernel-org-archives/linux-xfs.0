Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180C3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 22:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiEJWcF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 18:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiEJWcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 18:32:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD9547AD2
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 15:31:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AKu3Ie023623;
        Tue, 10 May 2022 22:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+ru8SWStR1umfbsnbx89v0vovq/vQjL4wUdNGgNQ47Y=;
 b=yEc6dUdBp6m2ydGhL67GCC7Nt18lhkH+z0bdnVUO5RJ59EhyaKHI+uBK7x7FGN9zGccM
 2brW8oyG/dydFdL9FHUHGUATOYHihRiX6PT14Zf37iG47VAZSqjZU72o7b2o7mj9nJuK
 xxQKCTIxt+LNrXL+hzV1Cczmv6rlOqJ0024lCvQTiU4hJy7uwLjTYtcTzFfWB9GFQAYR
 r+bpv75u4y+T3VA6B3Sh5pInlxlX74nWcy+2aZLLloeqHu2tfeLTnNOH+X6v9qsk3/a5
 4a+lk94M4DV2WKiHrCYoeckgl52uW8TIKfZnWA3BXYvqUcFhuRO7FEwNKHqaGysQWbTC QA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgcsr704-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 22:31:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AMFN9s003430;
        Tue, 10 May 2022 22:31:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf72vdvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 22:31:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCbwx8rKa5ezZyM96pW5Hfnl4rctwBrsP3wo6m5Qo1MEIi8jZaQ2Rf2Pbj6NMv1ECptmdZT6YpCnKICx2tlyJXYCF//DP+9LklYLMVbTJ3O4bNNKh5qNlRRzFyHxqzDyxX1e8t1FaudleZ4+uLNNzov49Q4pbF7OzgO7zab7gbofIscZ/Vp+GI4IxmAA4euJogoC5uJncqOuWL6FDoO84vcM7BLH/0rkuuc8h3U9vDdUZb4n1KpIvYW4eHCsgvgZ1Ed7vQy0sfnwyJPf86zxmN0zncWkMQDSTlYqW5cG6AlrlfkR1xD1HRXUWKdlJbPnX9iYJ3QJSND2ia7EtqVEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ru8SWStR1umfbsnbx89v0vovq/vQjL4wUdNGgNQ47Y=;
 b=cEHiUvHNw5xG++wHbPPJu9w/g4O8MM1/y9MH31b0Ge3alQp3jhb4GOTlPYoaWQBVl9eNYKXeIUfmpVvgz8VIOUme14qC8Sza9CjFCq92otZVXX75ESe8ACyumFkUFf5vQtHkeQ6wkxWbPTZfVKp3Kv+aypQbtPoFMBYkySna6y0KI8tB3Y8zGpxMHL1DCrDUL2RuZRv3Y33e5RJtN3PLe2XdrDSro4YVvWcJhTz4UvYGRWTaB2I6S6AVZODWBVGm2o7f7sWM68P5qcwHIa4a2EdV3FsBgWkZi8aTq6p1XjTbaNoXvhRuf41URg04Ozs9Q4ZFHJAY0hgwWkXiQYw9Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ru8SWStR1umfbsnbx89v0vovq/vQjL4wUdNGgNQ47Y=;
 b=ZCPEdPJl+DyE+QoxzD+EXMthmNlnK2SBQ3v37OSpEvanj782TjxQpav/iH01kqY7ybT076QhzC5lDhOe4XsTR7B9DM/KLXpptQ09Jerq6kFN//hp/uqL9zURDCsU4E94pWVbksAlpS4let3GQwv5bFukbIvX3eWHC204CsK0Vus=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB3428.namprd10.prod.outlook.com (2603:10b6:208:7c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 22:31:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 22:31:52 +0000
Message-ID: <89c2583422e0d0f75ad3bbe377de735c8256d531.camel@oracle.com>
Subject: Re: [PATCH 17/18] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 10 May 2022 15:31:51 -0700
In-Reply-To: <20220509004138.762556-18-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
         <20220509004138.762556-18-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 430aef89-cfb8-486f-9d80-08da32d4e1a2
X-MS-TrafficTypeDiagnostic: BL0PR10MB3428:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB342836A39A92C31F6F174BC395C99@BL0PR10MB3428.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdIJSxRlZP5GxBckCuILvqjZf0ooux+FPUsfMlIexidRJfT7coQ+WgUA0LSNFRbgPDJdMZxFYZB5veAL6f3RjWbpSYWYal6K/vqXMDFTaXPNTb8N78aLeX8t7pPS0j/MUggA7iNaYwJNHuY151aF62DI0OMnAOhdajct+VxyXNUFYJRi1rCfY7vuoKIsAF4Tt5zxi5oBOICV/3+NVhfq3PvUWv1qrjPZ1B3nRP+o4UFCrRKZ/FIhazzZYZB7Mmud8RlKXYtAs3qHeowHDcLIfiBGaF4ihr+ahTKtMK6DNX5P/JXOYvjp1iW1CfGuyOdVk3gqftm0yO90dauXjSgJ47taCCYr1BNVxrB+SmExSK+tXrV34DVU0v74avjHRH9HvGHGSS+iKvijbTk4OKmSjr7oK29MPW6HnAPDbZuegpiYigfqT25ZiH/hLt0IhtTsou5hkwXZdB2TqOUGe7Vw6WJLUAIXuGtZb4dVie1XJsVaEb9AhBpO54wGzDBw6bHEMgVUdr3h0CTXpFlakxnN8QPzlO3ygBb7gUSj0PaayrJmNvE01iCMT7fCmriuW3ilaGyKUhFxvWC5A/VDIxWOswa+fZd02388R0mJsExlIIYhP7W8Alh1LBDfgclGEoFwpwaELfVRPodr8uYtOllnsjNaEdmt/U+xZ+O7UKsDliLiKREJEr6VskmMU+kdxcke4ZE9S+83SG8FXwhgKiea8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(36756003)(6506007)(8676002)(66946007)(38100700002)(38350700002)(83380400001)(66476007)(66556008)(52116002)(6512007)(5660300002)(26005)(30864003)(86362001)(316002)(2906002)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXRvbTR1NmgzY2dmWUpkd0JYNStrVUo4OUlwSml3bjRaRlMybUJRc014YnQ4?=
 =?utf-8?B?VG9oWFhLOUYyamtaREdIZTZyMHlZcEwzT29IUzk3blg2eWNEOXY4Y0Z0Y01a?=
 =?utf-8?B?RE4zYkxqUFJ6Z0lGMmd2MXBCWmhMNmFkUmdRbTUydjBDSkxMME9SL2dqRUJF?=
 =?utf-8?B?ZjhqOHRzK3NkY1k0bDNqelljQkpHVzJSL2lTSURPTURGUVhYWjA2akVGQUhh?=
 =?utf-8?B?dUhzQ3EvVjh5UExxemF2U1R5NFhibUt4cm5GRUFCVzFYQVIrVUR5blhCdVlj?=
 =?utf-8?B?RnQwUHJiNjVRcDNpcXJZRFZmKyszVFZjNGFUSGUrRUpOcHhlQ2JWeVlvWDdx?=
 =?utf-8?B?K0wwMzBjOHozUnc1dTZmT1hoTi9QYlN3TmpEV2pkNGVjS1RWZ1lueExJRjht?=
 =?utf-8?B?S3VzaHBzMVp5UXg2RlRhVjlVUnYwckc2UkdVRVkySnRnNW9FZzhJM1d6d2VT?=
 =?utf-8?B?d0w5aXJFNmUza0hTSFZqNUFRWVpUYmFYeFcrUTVjNTJUcEJaME5tWkxmZ3hG?=
 =?utf-8?B?WWR3cHQ1d0IyT2x5dXY4dktEN3ZscU5QbHpoemJBeTBhTTFHN1B5Y3RnaWR4?=
 =?utf-8?B?YkJoc3lxVUk1Uzdub25HVXlCellYSjk5ZnRhWnhMMENwUmtkMVQ2RVFxYWxw?=
 =?utf-8?B?bXNEeU44WnFSTkttcDZuRUQ3VUFuWktRczdDUThzL0N1UENBWXgyU0tFWE9J?=
 =?utf-8?B?TklYeWw4dEIzWVRYaEVFRUZEKzUyVy8vdjlJclZKU1pkaUdLOFZLZUYvM0RJ?=
 =?utf-8?B?ZGczQjd4MlBPNlBWd0lXRHhoRzlMUVpYdTQ1bm1ucW93OTY1dWR1R0dWTU43?=
 =?utf-8?B?WTBqYXptMzFTcU0vbHd2TmdMak1kZHIvTlRaUnFMZTlyTFI4YnNLV0Q0QmRy?=
 =?utf-8?B?bkJuTUdiZzZTS1BncXNacncyU2p5TDB6Ylc0WVcvalZTZWVwNUpsb21yVUlL?=
 =?utf-8?B?b0dOWU42dnNKbXlQRXVLMlhENmRvNHVjZEp2Wmo2LzFuYXJlNzVRY3Vxb1hU?=
 =?utf-8?B?NE0vZjJuNkcweEV4c01tUWs3YWI0VkxKRi8wa1VnQ2w4d3dSb0ZQR1J1eU9N?=
 =?utf-8?B?eGlOV1UrNlJZeXE3Nm9CZjQ2L0FXcWovT0ZVVVdSU0FqelpPWjZMRENnKzFI?=
 =?utf-8?B?cURXRlBVOEtnSU14V1pkT1MrTlhoK2JIWXNXQkhJazVZNmNvbEdiNTFtKysz?=
 =?utf-8?B?VFJreHBLdG9Ea0dRN1BXSXp5SXNDeWo1NWp3SUNlQUZ4V00xZWxtMUlWSmxv?=
 =?utf-8?B?TWR5SVVuSEMvWUhSM1VFZTI1RENzQ0NtMmdzVVkvT0VoaEt0ajlpSmFhcHNT?=
 =?utf-8?B?aXZWVEpyYmhBT1NQU3piR0lrSXY0aDFuYjF2N2ZtOUNTZEtTcHRiN0lCMGc0?=
 =?utf-8?B?RExHVU5TeWltVGZZTWt6K3U2blh0UEZ3ZVAydSt6SnFFTlFMWDhNLzRVZVk1?=
 =?utf-8?B?SlMrQkY0d3FWOTBIUld6K05aRS8yemhVblhiOG4yaE1iZ1pPN3h4Yklkc1gz?=
 =?utf-8?B?S016ZzgxeUp1dkxiT3hPTkVVYkI4cGxEUFZ5ZkgvSDVib3ZFdUtMZTdLWXlU?=
 =?utf-8?B?TGNqQVdObDZ5TW4zZUtINXJESkd4V21nYXYvWndiNFhlNGxhSkMvMXgrMGFO?=
 =?utf-8?B?aHUyZ3dPVVcwcXppbWtFVk92bDRhUmZxRml2aW95WjdJTS8xL3BGWVEyeHp3?=
 =?utf-8?B?NlJZcGhyb01adTRoZTJYNTdNeVBxckxTd1M2SFF1U1BkQ0x3OTh1L1JuZ2ZO?=
 =?utf-8?B?c3NuVFlSdEt6ZGFvd2JsMUFoNU05emVwNVRCdDRaclBnb0JMUjE1NCtlRmRv?=
 =?utf-8?B?OEpoVC9VbDIyZEpSVUpDTjdnVVN0enczZmwrS3g2Vk10bVdTS2s5bWxSbkQ3?=
 =?utf-8?B?L3JXUmlveWpDRUJvMHRubnhkMHdRbk1CTjVMSzNVODlsa0ZneEJBaFB5YkM2?=
 =?utf-8?B?N2tOQmdLVmVrekxnandNNi9MY0wvNFdRRVBoeWZyZ3Izc0hDMkVZSmFncVlG?=
 =?utf-8?B?WnNReUd0MnJkRlc1TzdSUkdTOFRZZ0wwbEZwYjg1cHpMRXVnVHYwb0pROVhB?=
 =?utf-8?B?UlUySzM1UG56MGhFN2d0RmMyeVVhSlJzSDhER0JRNE41SWN1VkJFdnVIbDdw?=
 =?utf-8?B?WjZDcldGeUdTcDc3U0NFOEJxMHBZWjNML2FZZEFQNEpGMVVaMjFiNnowenp1?=
 =?utf-8?B?UXphVnNDM2laTUFLTE5idnYvdlBYL3c5RXluQTlTazBibWRmN2h4WnFLTHpi?=
 =?utf-8?B?RDR3VWNBY2Y1dk83K3l2N2NJTVBUQWhFMVhTeW40VXUzbU9oOTFMQjNXbFBm?=
 =?utf-8?B?QmJPMWt1QytqV1JjV2J1RGZReVBpWTZOVlFQN2hiMUUyRFA4SUU5U3p0SW4w?=
 =?utf-8?Q?jVa2U3NAgVijI4uM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430aef89-cfb8-486f-9d80-08da32d4e1a2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 22:31:52.7739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73t987I8Gfyk4IU4Q8A4ZWyg2yeEo+IVyaIFZz/nyH0NdHCn7U4+IdeZGacOyWpNZ2wO7qHbKUmknFAOfrduYjbgf28Ij78r9WKxyBNPP6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3428
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100093
X-Proofpoint-GUID: kJBwMnYNq01HMLy_z3lsXqtILam0XilG
X-Proofpoint-ORIG-GUID: kJBwMnYNq01HMLy_z3lsXqtILam0XilG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2022-05-09 at 10:41 +1000, Dave Chinner wrote:
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
Ok, I think this is looking good, and with the new fixes tests seem to
pass in my setup.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
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
> index 344497e37813..2f6b9bfd7768 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -69,9 +69,12 @@ int
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
> @@ -409,23 +412,30 @@ xfs_attr_sf_addname(
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
> @@ -467,10 +477,9 @@ xfs_attr_leaf_addname(
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
> @@ -512,10 +521,9 @@ xfs_attr_node_addname(
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
> @@ -547,18 +555,15 @@ xfs_attr_rmtval_alloc(
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
> @@ -715,13 +720,24 @@ xfs_attr_set_iter(
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
> @@ -807,14 +823,16 @@ xfs_attr_set_iter(
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
>  		if (!error)
>  			error = xfs_attr_leaf_shrink(args);
> -		attr->xattri_dela_state = XFS_DAS_DONE;
> +		attr->xattri_dela_state = xfs_attr_complete_op(attr,
> +						xfs_attr_init_add_state
> (args));
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -1316,9 +1334,10 @@ xfs_attr_leaf_removename(
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
> index 468ca70cd35d..ed2303e4d46a 100644
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
>  /*
>   * Storage for holding state during Btree searches and split/join
> ops.
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

