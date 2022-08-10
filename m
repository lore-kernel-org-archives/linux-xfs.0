Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10141C19F2D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiHJDJb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiHJDJJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:09:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F2F7E330
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:09:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0EvQE001975;
        Wed, 10 Aug 2022 03:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=704SLjNIyN9qOgz/L9nZ03hajtavqC+IBgq86JeLmrk=;
 b=NO1UwBtlz2lUEMXOrEmS4vGO+mMeRwFT3TcMyo7vjdU7Gc8lrA7qBDmTxHhPJTM2A5JN
 QNGayYY67gz//xfUkHVlCpsSs9dD2jyFTRSkQ021/nT4WNWhsSVGjEDzLI6DskX26Hjy
 +sLA7OrUheaar4tcmYh7sVZobmgLmXjZfRmW69j6H9oGR3edHoyJh6SoH5j3RsIjpyO6
 n7bnGyn5R+/aPG3B31pNXiems+qQ+nDGmm6TUm4DMVTw92W1wwkiWAILc/97Wd9knhWn
 cMWdtHggXmTQ76BzrQNzo/Yr+o/3qvJsFm7ivnzoM0nq4iI6P0K6U9Yq+PuqcA9/gqUL Zg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqggntd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279NaihF024173;
        Wed, 10 Aug 2022 03:09:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfrfpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:09:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsoK08eP9JxVqk2v4Sew70blXOJt/izWKRL25PfYlkKGE6XSJSgGa62C7xwCcibhJ/7QUl7S9jyjBih8yfw0gCYJHy6xSLEI1T+LNwF8O/wdLtHc4qVMN5xv8bkbilpe0irkX8cnp06H3908XD7zdqNhLOzwjT7D+eRgaTNnBcSriJ3ZwxmAj/6pWLe8bdlhnLIcHXg68xFAmabWicrkAbP2EiwUeQj1Gyuqw17RGUv5kd9f9eiNeyxzy+Pjk5IwFiSynN/uEEqKao4j1Vi9dOq2tgdSgChWksob+1m6nWQlYd9fSl9z5OMJ3bHT1Zp87YP82H82ZURFcQkx+1iOBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=704SLjNIyN9qOgz/L9nZ03hajtavqC+IBgq86JeLmrk=;
 b=QqjLPJmYdQCRXS+g9HKBfM/z5GHdzLVg2me8To7APQxkw9dTiZ1pyfMfUAPeVzQqzpjT7wJLdsS2Wp99er6n9i+Qsu/2Kjl2HBsvIq+tDxNlA4dTBN3I6lrVaMI4YS8m3qeXZZKXgMp4b0HIMtrom/UVhohhW6lKr/Gpws24DmtKMlFpV0nIJ+d0pYRMo37XMn6NhJPSqfh3QZd1Q1dzCFmlnYmyHb7jS6Sef6XfCEemNe/7kxCBWuDe0OX9lgEjiB8Vej7ztDbwU9/cKfxdNnrFnaUWmQvLKVZdPFNbd1cdeMgKRWuhsgUoun7mn/V5Ktqg7S1HpdKqHoiAs7cw2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=704SLjNIyN9qOgz/L9nZ03hajtavqC+IBgq86JeLmrk=;
 b=pw9xd27HViEYIpc9exSzhsjKLjtJp+FRQ5B5nzvpFgFZj1kYqQoutta7mHtTFmLCSuKQIXN0n2OQEO7aSYU9/PAiA1h0/3Q1YkydeYfnaHyfWsgDOJ4HN3VekQDHGN6FCwhc8WT5RgLQwW8EAxqok832P5/QNIu8n+gotypWXpQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4545.namprd10.prod.outlook.com (2603:10b6:303:9a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 10 Aug
 2022 03:09:01 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:09:01 +0000
Message-ID: <32093abec05556ff206e272a9c17495a6deae8c6.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 12/18] xfs: parent pointer attribute creation
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:08:59 -0700
In-Reply-To: <YvKg3XBOmAmFli0o@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-13-allison.henderson@oracle.com>
         <YvKg3XBOmAmFli0o@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0111.namprd07.prod.outlook.com
 (2603:10b6:510:4::26) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f3c8808-71d3-4457-ba07-08da7a7dacc6
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nh4CbPJ/weazEaHhxR0E+N2S2VDqxoLlR2Ls6dsloSf0GARb1f374LNFE2mWMPZIXyKTdQnjMqZcC61tS0iqtp5cXqFB+kb/K0Hsh1F7zVr4LBOGL6Mzxf7CqAzSbqxByk8FflhffTvKpp1+KcIsYX1TapmYZ14efIulb0INRhdKiri6zCo4oCTzs6jx5+1+XdzX6xjHcL9hXLRt+R4wsoiNDVujJFoZH3NI7UZmDzwUc9JXHQD4jC1k1UofLZgBYyi2guo6xKi1ECESC4yMyV4YYIEhUFG9Z7b/ct7vleVMa0h11DRJG878X16A/GtOFSgMRXQ2p9sOvIDpfcpv3JnCZHqTlRFbyHXtrixfAPRPWHvlEGyDoWZR/F0mmaZJV1d/THelQtc7M2FDNMeoaSAOMIFBnUQWXoOTkc4aEMvyJDPYUrRaoFJ1M2C+hF2JTcRRhhjEkgIrPXxMyfCDDTq8vLrvURWhXybDcaV2LeoI1WEt8bK5HSIieQE0Ph7Rl07HwFTSSKpjkQFXhn7XJw9fhNuBleUj18efyb3i6R2uDqCW7bPiyJj96nqFY89Rj/IVb+bvAVDzft6he5y3xwGK/j7chmxKMgZSai4GLXxl6Qrn2qVwFG95EounODQrIYza2kMhj/R8u/Mr3Apw4BUhbhPaK3vpblK/x1SvGLkMbKRdSNwV1KfA/QCP3VnijPiKjP1pP6l1HoksnIOwSxAawqBn6jVy5oQOi8E2VpuXsF3R7UCVqUUuCFn1fGwP0VoZxnSQPMcB3Gz9Wj6fSer66LH5vnH+nb8r7Gd9ilA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(396003)(366004)(38350700002)(38100700002)(26005)(66946007)(8676002)(4326008)(6512007)(66476007)(66556008)(36756003)(6916009)(316002)(478600001)(2616005)(86362001)(6486002)(5660300002)(2906002)(8936002)(30864003)(186003)(66574015)(41300700001)(6506007)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVk0RkdKcDNSSndOUFJSZUlOQnRtcjhPdk9MUWZ1dVdXNzE2eTFDWUVLQTI3?=
 =?utf-8?B?TnFtUzhPNzQ2a0kvOXpURk1pS0hjREhEZnpzMTlqaVVvWW1zOVZ0VFJTQUx4?=
 =?utf-8?B?VHhweGRzc3phM1ZvWU83bjRTVXhSZWUvTVFBNUZTZ2szUXdHakpERUs3cEZt?=
 =?utf-8?B?bXgzYnJzUC9YblFwRGtlZGUzQm1CSmdoMnBFNVBEZS9ZVUpObk42VmJVVWM4?=
 =?utf-8?B?eS8xKys0a3dUdk9ORFA1NnA4aFhDSUdXWklqdUxBYk05M3JST0dON3NZY0Rj?=
 =?utf-8?B?ejZtM2o4NXZBdit5TlNmd1U2RlFFcmFJS0VDYmIydit1SXF1RjBRNXFxdEFv?=
 =?utf-8?B?VXNlMDV0TG9NS3ArMzBheFhzWG4wekVJU1FRd05YdGxINHJqUC9HYU52YmFW?=
 =?utf-8?B?Wlp6SGFITTRjcWc0bnd1d2cxQnZxY3o3b3lUOTFwZnNzWTk2aHB3cHBMRXA5?=
 =?utf-8?B?bmZXSzZUMy8wYmxwWmFjYTR4S0VEQkV2ZkwzN0Z3MGJWUEdsM1BRaGNkSGVL?=
 =?utf-8?B?VzkyY3FQZ1ArQkF2RWZpMElvcEtkc1drUFhUemljUndZeFRyb2szV29UbzdE?=
 =?utf-8?B?MFBFa1p3cUN6dkIyWUQxV0lDZklTS2VwRGVLMlRxRGtQemROa2JlSWdlNzdH?=
 =?utf-8?B?RmwxRjZJdi91TjZUQ3huMEpCOUpCZ3B5aG5BS2RXS1YzdlN4TUVxMklFT2Nk?=
 =?utf-8?B?Z3lQdjladE00c1lDMnFxWjkyQ2RWem83SVlkSjhwSE9KRCtHaHZET0JVSzNF?=
 =?utf-8?B?U1I0YWJlS1AycWl5Z2FqSDJsQStxVTEyUldIMVp0K2ljS0QyNFVLQlprQUE0?=
 =?utf-8?B?TTFOdVJWdEVoUXc1ZXNhdnExenpQUTRZRUhMR1NZZzB0aW1HZWRiUXZFc0xx?=
 =?utf-8?B?aGYweGVKckhjWFR2VXc5NWJGZEg4QXdtNEl3TUJubXh6TTJ0Uk1BVW1nMSsr?=
 =?utf-8?B?Zy9nVEJIcnVpSHlOY2Qza0tjdzc1UndIa08wc2RGV0JWUmhvVUo5NFRjRTBW?=
 =?utf-8?B?N0lxZ2t0eFFoMWtmMzVvNTdpdFBMLzRIOHdXVkpDVEJ0Mko3ZVY1NExGVEpj?=
 =?utf-8?B?SFFxL00rOWxJdlVad3FEOG01MndQS2ZoWG5kTlZkZW9URGpsdGszNnd4QlY1?=
 =?utf-8?B?L004WllMQXdIWkNGYnlqL1NaajhudkZhdTFIRWVTa3JLR3NMUmJCVmlqenNp?=
 =?utf-8?B?cjVzNTBMUEd4ZHVaNU1scTkwR2M0WVJOalAwcElwQ1oyU01xVjRIK1VxZ2p6?=
 =?utf-8?B?OXZrdElsV1lXdDk1QytWVDJvQTJtY1p6ZHZuZERrank2VHUwRWR2WVpSeGVN?=
 =?utf-8?B?REVYSlhlRm5adThKeTZFRlNUNER4eCtLYU5pQkFsUTVMdTBPNG8vNnhHMFFs?=
 =?utf-8?B?ai82TU93SDI2Y3NRWTNjUGxVZW1MajVKNzVxNzlkc21obWZwT2ExR05tbGdZ?=
 =?utf-8?B?eE5tUmdMZ2NEY0Q0Qks5aVNiT2dLclJxeFA2Si9NRXlGbkVyMnNGMkxJUFFi?=
 =?utf-8?B?NFhJS0x4WXoyaXhEUHk4YTdIMWdHNkRtYk9NaTcyNEZYZlhkQjBwWHdlTlJz?=
 =?utf-8?B?cG1IWTBNdDBZcC9zczFNZkQxWjl1d3I4VnpwaXg1SHYrNHNvbU1WV245b0xY?=
 =?utf-8?B?eUJxbjVmNWFYQW51STZOakVwc3NhTmZza3h1WHZ1NmpreHpwZzc1Z2RpNUw3?=
 =?utf-8?B?b3J6TFVYd1VZN1gvUzZ4RW80MEtSWGp6RmhlckdtS21qMVFJUHprZFd6SFYw?=
 =?utf-8?B?QjhFOWV0Y2s5WFdlczNsKzJUb0xzTHFhelZENjU2VDlwUGUzdUdpdVg0VmhF?=
 =?utf-8?B?V2xpelQ5NmFnbmUrSVgyUERyMXpnYWpmWEErakczNmVhdi9RYXJacFJVL0Vs?=
 =?utf-8?B?Vjh5UHUyYjVwTTNwS2RqSEIvdFd5R3ZXeGVkN0IxVXdvMjVZMTFaMFg3NGZG?=
 =?utf-8?B?UHJiaUpxbEw0eUo0MStDeXdSeEdKNlVRUFdSRVp3cGVadUhHRGxSV1VJVmY4?=
 =?utf-8?B?S0RvY2lkTUVPQ0lnWFFOWklkalFWMFRSVEZtL21iUTZXRWcrS2RiTVVuZlAx?=
 =?utf-8?B?ME5UMzhsVlBCQ0dFVkZwSUFzUndPcnAvaHg5ZXQvZXltUm5TYmFSUEE1bmN5?=
 =?utf-8?B?VGNXTEYxTEpJT1ZYSm5nWVlXRzVXbXlZd2NjSGJxMEIwQmNMa01qeGxtaHNT?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qoU2VpcakljlaO3dOI5AWaNdyKKvrzF+0oi5CBosfoftqw9x2tMVvCOwJJo5cLKORgvYPljvcCJBbHsn/jtjuudTw4Veh5IQq9Bxf+Yd9lUVw4aAx/GAHhuJ3+/hfA02HVCcDCpAYsuxPTT8UHRThMS0ymNo8zXqhKIUL38WdjMdJ2QTsaqSCjXp10qwvADpzovk6a3uX4w8+BgS4DVt3ToDY4ml4p9bcCMerrETOQObBi0S743+WwBUQvTYAlyqAqTTbPRpjMoTwd95xxXu6bObAANNC+HLgyzTUP3GkrF0fg5ckrGVUZ/1pcToTZR5Py/QlnDfKfy5q4v83X21xyll1LVaCY6fvkjW4iwP/rEnAlkgAqg1xpdNhuY670fKsBaA3DXhv3NsYaOv0fFEQ+MsJvhdHNsFJRGZtvMcipr6l6dCUzO2bL3Y5DFps21hIod7NX/uOQWbHPd+Fzjzx/gk1m4FsgZUArJS4eRSgtIDzf27ENT8lRJLrTiCvJcvGSaF0UNOaBucLE1Ghnb5wN1uzDUAfaXX6um/yU6g6rzk5FKpQ1LrjgeLWQl3RKbP9tioVqgcudDzQM11TRW4NGhP+oYPb7ruwUNYX/GlZk9f02vH6PdkRDjlOog72OqXv/flQ61cO6K0qu53f6OXrN/NMpc1THs0TxRk9eU//1y9M6giTgDHvMWHOpq4ne/DO0EH13E7cqOwtdT02KSaQpQJDIDIqnpwX0P6S0MlmV/n75Frj29wp/e2ar5il4M5GVbB9DeoEJ6/qhnLp1p3lA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3c8808-71d3-4457-ba07-08da7a7dacc6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:09:01.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uN6lOjmKyAtcFJZiSsRudNusq7I3gqgM6F1V0xdRh5zknRlL6jNTNcsx1ZUunwQuIE8Q5euDWyjXJr6psx6ej1xhdXSOZEmE8auRv1b4dPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100008
X-Proofpoint-GUID: cimbF8YqGyWHsCgp7nHXGYKe7gJznFZm
X-Proofpoint-ORIG-GUID: cimbF8YqGyWHsCgp7nHXGYKe7gJznFZm
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 11:01 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:40:07PM -0700, Allison Henderson wrote:
> > Add parent pointer attribute during xfs_create, and subroutines to
> > initialize attributes
> > 
> > [bfoster: rebase, use VFS inode generation]
> > [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
> 
> Nit: uint32_t, not unint32_t.
I actually thought about removing this little change log all together?
 I had initially added that to follow suit with Brians style, but
really the set has undergone so many updates, trying to keep a log here
seems a bit silly.  Unless there's a reason people would like to hang
on to them, I think maybe we should just clean them out?


> 
> >            fixed some null pointer bugs,
> >            merged error handling patch,
> >            remove unnecessary ENOSPC handling in
> > xfs_attr_set_first_parent]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/Makefile            |   1 +
> >  fs/xfs/libxfs/xfs_attr.c   |   4 +-
> >  fs/xfs/libxfs/xfs_attr.h   |   4 +-
> >  fs/xfs/libxfs/xfs_parent.c | 134
> > +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_parent.h |  34 ++++++++++
> >  fs/xfs/xfs_inode.c         |  37 ++++++++--
> >  fs/xfs/xfs_xattr.c         |   2 +-
> >  fs/xfs/xfs_xattr.h         |   1 +
> >  8 files changed, 208 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 1131dd01e4fe..caeea8d968ba 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -40,6 +40,7 @@ xfs-y				+= $(addprefix
> > libxfs/, \
> >  				   xfs_inode_fork.o \
> >  				   xfs_inode_buf.o \
> >  				   xfs_log_rlimit.o \
> > +				   xfs_parent.o \
> >  				   xfs_ag_resv.o \
> >  				   xfs_rmap.o \
> >  				   xfs_rmap_btree.o \
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 2ef3262f21e8..0a458ea7051f 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -880,7 +880,7 @@ xfs_attr_lookup(
> >  	return error;
> >  }
> >  
> > -static int
> > +int
> >  xfs_attr_intent_init(
> >  	struct xfs_da_args	*args,
> >  	unsigned int		op_flags,	/* op flag (set or
> > remove) */
> > @@ -898,7 +898,7 @@ xfs_attr_intent_init(
> >  }
> >  
> >  /* Sets an attribute for an inode as a deferred operation */
> > -static int
> > +int
> >  xfs_attr_defer_add(
> >  	struct xfs_da_args	*args)
> >  {
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index af92cc57e7d8..b47417b5172f 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
> >  bool xfs_attr_is_leaf(struct xfs_inode *ip);
> >  int xfs_attr_get_ilocked(struct xfs_da_args *args);
> >  int xfs_attr_get(struct xfs_da_args *args);
> > +int xfs_attr_defer_add(struct xfs_da_args *args);
> >  int xfs_attr_set(struct xfs_da_args *args);
> >  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
> >  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> > @@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp,
> > const void *name, size_t length,
> >  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> >  void xfs_init_attr_trans(struct xfs_da_args *args, struct
> > xfs_trans_res *tres,
> >  			 unsigned int *total);
> > -
> > +int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int
> > op_flags,
> > +			 struct xfs_attr_intent  **attr);
> >  /*
> >   * Check to see if the attr should be upgraded from non-existent
> > or shortform to
> >   * single-leaf-block attribute list.
> > diff --git a/fs/xfs/libxfs/xfs_parent.c
> > b/fs/xfs/libxfs/xfs_parent.c
> > new file mode 100644
> > index 000000000000..4ab531c77d7d
> > --- /dev/null
> > +++ b/fs/xfs/libxfs/xfs_parent.c
> > @@ -0,0 +1,134 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2022 Oracle, Inc.
> > + * All rights reserved.
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_format.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_bmap_btree.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_error.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_attr.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_attr_sf.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_log.h"
> > +#include "xfs_xattr.h"
> > +#include "xfs_parent.h"
> > +
> > +/*
> > + * Parent pointer attribute handling.
> > + *
> > + * Because the attribute value is a filename component, it will
> > never be longer
> > + * than 255 bytes. This means the attribute will always be a local
> > format
> > + * attribute as it is xfs_attr_leaf_entsize_local_max() for v5
> > filesystems will
> > + * always be larger than this (max is 75% of block size).
> > + *
> > + * Creating a new parent attribute will always create a new
> > attribute - there
> > + * should never, ever be an existing attribute in the tree for a
> > new inode.
> > + * ENOSPC behavior is problematic - creating the inode without the
> > parent
> > + * pointer is effectively a corruption, so we allow parent
> > attribute creation
> > + * to dip into the reserve block pool to avoid unexpected ENOSPC
> > errors from
> > + * occurring.
> 
> Shouldn't we increase XFS_LINK_SPACE_RES to avoid this?  The reserve
> pool isn't terribly large (8192 blocks) and was really only supposed
> to
> save us from an ENOSPC shutdown if an unwritten extent conversion in
> the
> writeback endio handler needs a few more blocks.
> 
Did you maybe mean XFS_IALLOC_SPACE_RES?  That looks like the macro
that's getting used below in xfs_create

> IOWs, we really ought to ENOSPC at transaction reservation time
> instead
> of draining the reserve pool.
It looks like we do that in most cases.  I dont actually see rsvd
getting set, other than in xfs_attr_set.  Which isnt used in parent
pointer updating, and should probably be removed.  I suspect it's a
relic of the pre-larp version of the set. So perhaps the comment is
stale and should be removed as well.  

> 
> > + */
> > +
> > +
> > +/* Initializes a xfs_parent_name_rec to be stored as an attribute
> > name */
> > +void
> > +xfs_init_parent_name_rec(
> > +	struct xfs_parent_name_rec	*rec,
> > +	struct xfs_inode		*ip,
> > +	uint32_t			p_diroffset)
> > +{
> > +	xfs_ino_t			p_ino = ip->i_ino;
> > +	uint32_t			p_gen = VFS_I(ip)->i_generation;
> > +
> > +	rec->p_ino = cpu_to_be64(p_ino);
> > +	rec->p_gen = cpu_to_be32(p_gen);
> > +	rec->p_diroffset = cpu_to_be32(p_diroffset);
> > +}
> > +
> > +/* Initializes a xfs_parent_name_irec from an xfs_parent_name_rec
> > */
> > +void
> > +xfs_init_parent_name_irec(
> > +	struct xfs_parent_name_irec	*irec,
> > +	struct xfs_parent_name_rec	*rec)
> > +{
> > +	irec->p_ino = be64_to_cpu(rec->p_ino);
> > +	irec->p_gen = be32_to_cpu(rec->p_gen);
> > +	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
> > +}
> > +
> > +int
> > +xfs_parent_init(
> > +	xfs_mount_t                     *mp,
> > +	xfs_inode_t			*ip,
> > +	struct xfs_name			*target_name,
> > +	struct xfs_parent_defer		**parentp)
> > +{
> > +	struct xfs_parent_defer		*parent;
> > +	int				error;
> > +
> > +	if (!xfs_has_parent(mp))
> > +		return 0;
> > +
> > +	error = xfs_attr_grab_log_assist(mp);
> 
> At some point we might want to consider boosting performance by
> setting
> XFS_SB_FEAT_INCOMPAT_LOG_XATTRS permanently when parent pointers are
> turned on, since adding the feature requires a synchronous bwrite of
> the
> primary superblock.
> 
> I /think/ this could be accomplished by setting the feature bit in
> mkfs
> and teaching xlog_clear_incompat to exit if xfs_has_parent()==true.
> Then we can skip the xfs_attr_grab_log_assist calls.
> 
> But, let's focus on getting this patchset into good enough shape that
> we can be confident that we don't need any ondisk format changes, and
> worry about speed later.
Yep, I will add that to the mkfs side.  I do have the user space
updates on git hub, but I dont want to patch bomb the list with it just
yet because it's just too much to review all at once.  It makes sense
to get the kernel updates out of the way first.

> 
> > +	if (error)
> > +		return error;
> > +
> > +	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
> 
> These objects are going to be created and freed fairly frequently;
> could
> you please convert these to a kmem cache?  (That can be a cleanup at
> the
> end.)
Sure, will do

> 
> > +	if (!parent)
> > +		return -ENOMEM;
> > +
> > +	/* init parent da_args */
> > +	parent->args.dp = ip;
> > +	parent->args.geo = mp->m_attr_geo;
> > +	parent->args.whichfork = XFS_ATTR_FORK;
> > +	parent->args.attr_filter = XFS_ATTR_PARENT;
> > +	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
> > +	parent->args.name = (const uint8_t *)&parent->rec;
> > +	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
> > +
> > +	if (target_name) {
> > +		parent->args.value = (void *)target_name->name;
> > +		parent->args.valuelen = target_name->len;
> > +	}
> > +
> > +	*parentp = parent;
> > +	return 0;
> > +}
> > +
> > +int
> > +xfs_parent_defer_add(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	struct xfs_parent_defer	*parent,
> > +	xfs_dir2_dataptr_t	diroffset)
> > +{
> > +	struct xfs_da_args	*args = &parent->args;
> > +
> > +	xfs_init_parent_name_rec(&parent->rec, ip, diroffset);
> > +	args->trans = tp;
> > +	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > +	return xfs_attr_defer_add(args);
> > +}
> > +
> > +void
> > +xfs_parent_cancel(
> > +	xfs_mount_t		*mp,
> > +	struct xfs_parent_defer *parent)
> > +{
> > +	xlog_drop_incompat_feat(mp->m_log);
> > +	kfree(parent);
> > +}
> > +
> > diff --git a/fs/xfs/libxfs/xfs_parent.h
> > b/fs/xfs/libxfs/xfs_parent.h
> > new file mode 100644
> > index 000000000000..21a350b97ed5
> > --- /dev/null
> > +++ b/fs/xfs/libxfs/xfs_parent.h
> > @@ -0,0 +1,34 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2022 Oracle, Inc.
> > + * All Rights Reserved.
> > + */
> > +#ifndef	__XFS_PARENT_H__
> > +#define	__XFS_PARENT_H__
> > +
> > +/*
> > + * Dynamically allocd structure used to wrap the needed data to
> > pass around
> > + * the defer ops machinery
> > + */
> > +struct xfs_parent_defer {
> > +	struct xfs_parent_name_rec	rec;
> > +	struct xfs_da_args		args;
> > +};
> > +
> > +/*
> > + * Parent pointer attribute prototypes
> > + */
> > +void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
> > +			      struct xfs_inode *ip,
> > +			      uint32_t p_diroffset);
> > +void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> > +			       struct xfs_parent_name_rec *rec);
> > +int xfs_parent_init(xfs_mount_t *mp, xfs_inode_t *ip,
> > +		    struct xfs_name *target_name,
> > +		    struct xfs_parent_defer **parentp);
> > +int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_inode
> > *ip,
> > +			 struct xfs_parent_defer *parent,
> > +			 xfs_dir2_dataptr_t diroffset);
> > +void xfs_parent_cancel(xfs_mount_t *mp, struct xfs_parent_defer
> > *parent);
> > +
> > +#endif	/* __XFS_PARENT_H__ */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 09876ba10a42..ef993c3a8963 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -37,6 +37,8 @@
> >  #include "xfs_reflink.h"
> >  #include "xfs_ag.h"
> >  #include "xfs_log_priv.h"
> > +#include "xfs_parent.h"
> > +#include "xfs_xattr.h"
> >  
> >  struct kmem_cache *xfs_inode_cache;
> >  
> > @@ -950,7 +952,7 @@ xfs_bumplink(
> >  int
> >  xfs_create(
> >  	struct user_namespace	*mnt_userns,
> > -	xfs_inode_t		*dp,
> > +	struct xfs_inode	*dp,
> >  	struct xfs_name		*name,
> >  	umode_t			mode,
> >  	dev_t			rdev,
> > @@ -962,7 +964,7 @@ xfs_create(
> >  	struct xfs_inode	*ip = NULL;
> >  	struct xfs_trans	*tp = NULL;
> >  	int			error;
> > -	bool                    unlock_dp_on_error = false;
> > +	bool			unlock_dp_on_error = false;
> >  	prid_t			prid;
> >  	struct xfs_dquot	*udqp = NULL;
> >  	struct xfs_dquot	*gdqp = NULL;
> > @@ -970,6 +972,8 @@ xfs_create(
> >  	struct xfs_trans_res	*tres;
> >  	uint			resblks;
> >  	xfs_ino_t		ino;
> > +	xfs_dir2_dataptr_t	diroffset;
> > +	struct xfs_parent_defer	*parent = NULL;
> >  
> >  	trace_xfs_create(dp, name);
> >  
> > @@ -996,6 +1000,12 @@ xfs_create(
> >  		tres = &M_RES(mp)->tr_create;
> >  	}
> >  
> > +	if (xfs_has_parent(mp)) {
> > +		error = xfs_parent_init(mp, dp, name, &parent);
> > +		if (error)
> > +			goto out_release_dquots;
> > +	}
> > +
> >  	/*
> >  	 * Initially assume that the file does not exist and
> >  	 * reserve the resources for that case.  If that is not
> > @@ -1011,7 +1021,7 @@ xfs_create(
> >  				resblks, &tp);
> >  	}
> >  	if (error)
> > -		goto out_release_dquots;
> > +		goto drop_incompat;
> >  
> >  	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> >  	unlock_dp_on_error = true;
> > @@ -1021,6 +1031,7 @@ xfs_create(
> >  	 * entry pointing to them, but a directory also the "." entry
> >  	 * pointing to itself.
> >  	 */
> > +	init_xattrs |= xfs_has_parent(mp);
> >  	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
> >  	if (!error)
> >  		error = xfs_init_new_inode(mnt_userns, tp, dp, ino,
> > mode,
> > @@ -1035,11 +1046,12 @@ xfs_create(
> >  	 * the transaction cancel unlocking dp so don't do it
> > explicitly in the
> >  	 * error path.
> >  	 */
> > -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, dp, 0);
> >  	unlock_dp_on_error = false;
> >  
> >  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> > -				   resblks - XFS_IALLOC_SPACE_RES(mp),
> > NULL);
> > +				   resblks - XFS_IALLOC_SPACE_RES(mp),
> > +				   &diroffset);
> >  	if (error) {
> >  		ASSERT(error != -ENOSPC);
> >  		goto out_trans_cancel;
> > @@ -1055,6 +1067,17 @@ xfs_create(
> >  		xfs_bumplink(tp, dp);
> >  	}
> >  
> > +	/*
> > +	 * If we have parent pointers, we need to add the attribute
> > containing
> > +	 * the parent information now.
> > +	 */
> > +	if (parent) {
> > +		parent->args.dp	= ip;
> > +		error = xfs_parent_defer_add(tp, dp, parent,
> > diroffset);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> > +
> >  	/*
> >  	 * If this is a synchronous mount, make sure that the
> >  	 * create transaction goes to disk before returning to
> > @@ -1080,6 +1103,7 @@ xfs_create(
> >  
> >  	*ipp = ip;
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	xfs_iunlock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> 
> I don't think we need the ILOCK class annotations for unlocks.
> 
> Other than the two things I asked about, this is looking good.
Ok, will remove the XFS_ILOCK_PARENT.  Thanks for the reviews!

Allison
> 
> --D
> 
> >  	return 0;
> >  
> >   out_trans_cancel:
> > @@ -1094,6 +1118,9 @@ xfs_create(
> >  		xfs_finish_inode_setup(ip);
> >  		xfs_irele(ip);
> >  	}
> > + drop_incompat:
> > +	if (parent)
> > +		xfs_parent_cancel(mp, parent);
> >   out_release_dquots:
> >  	xfs_qm_dqrele(udqp);
> >  	xfs_qm_dqrele(gdqp);
> > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > index c325a28b89a8..d9067c5f6bd6 100644
> > --- a/fs/xfs/xfs_xattr.c
> > +++ b/fs/xfs/xfs_xattr.c
> > @@ -27,7 +27,7 @@
> >   * they must release the permission by calling
> > xlog_drop_incompat_feat
> >   * when they're done.
> >   */
> > -static inline int
> > +int
> >  xfs_attr_grab_log_assist(
> >  	struct xfs_mount	*mp)
> >  {
> > diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
> > index 2b09133b1b9b..3fd6520a4d69 100644
> > --- a/fs/xfs/xfs_xattr.h
> > +++ b/fs/xfs/xfs_xattr.h
> > @@ -7,6 +7,7 @@
> >  #define __XFS_XATTR_H__
> >  
> >  int xfs_attr_change(struct xfs_da_args *args);
> > +int xfs_attr_grab_log_assist(struct xfs_mount *mp);
> >  
> >  extern const struct xattr_handler *xfs_xattr_handlers[];
> >  
> > -- 
> > 2.25.1
> > 

