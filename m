Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C8EC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC3A361107
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhDBJrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:47:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbhDBJrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:47:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329V5Kj189781;
        Fri, 2 Apr 2021 09:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=f9wKTMA0E3ydanWRsK1KNQm9Nb8Fyy/4rslF6oJSD8Y=;
 b=Yy3TvkxoSSJFN5sPAv9IK6cBQWOkarF5AtEqsc2RXdAArhLcUwAWGWGlPPzMdchqpPcY
 uY7zo6JbQ+KXcNnNf4vW3CH8bYUArQtiZ/5tb5VpFher8b+ZJec5aAgYEoI5nfkiFb/N
 bo+UJAYbWF2JZicqXrySd+nHx1CjvtHagBRf/Kbvm77R/Di7I8o1ABmyOij0BinuaWoK
 voQNoeFOg4TWdiW1RwPx8FEP3N/7Ui92ay5Ev4i+Va+rKbkVJOc7iTOfqKzWEkNwzmpP
 b1FaCo/eM4DQWTwLxlTNORsGOVE+VOaeDthHR5Ohj70hChlhWaO8Q1MlX9fgUBXCqgpx mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37n2a04a58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:47:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329ilw2091486;
        Fri, 2 Apr 2021 09:47:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 37n2pbkyvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:47:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPDLn0ZXG2DzXQ8tbG0XsQf60xoNUir0OV3GPzXVD0/PxS/SFzEXoOWLPd6ytxmX0JYBX7PYTDoPaA1EQYx2edn+tzme/xHHV9SU6eiakFowkH2eAYAXtNYaa1gkeqASdVAZ9qlWj9Tf4odF+c11HuIW1TiPQTJw5+nYuBmF603EivPM5PbFNVfsPEoKtxWjx76WiXUuBX16xxiKV90U2+2HoV0HlFuV2G8YfYMxssv/i0iNLT9Ppwk3cRtJNwkfSftCgcz/7uF1E+r8BHtzrp8qVKKBYDyHEVqVIClDxzMrTwlD+iiQxw6S/G41hShnmsYjyfD/EjwfJN1poBYQ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9wKTMA0E3ydanWRsK1KNQm9Nb8Fyy/4rslF6oJSD8Y=;
 b=KFkwnJn7S47+f4aVGxSj4QBPXAuasT95m5qn+LrPRJwMXUs6TVTDGgI7SEQb96PCXzOB8SldW65QP9tbMvKHAME3/Q03PWnFbj8YJeC4ypIIdGMwnrRx0PMIHu7nxZcls83PMjJ7/bgGg4HWZm7/EuMK1gE1j0VBzTsobeLMUjYCxtWsSoHZtBjU7Anovhg6EzMlWC99sCPmzZoviEzArFvJmBWkYgRDCBRxg/yvnEamUkF7PB1O9UY2B1yMu8iPk3qoWqQssopCx2z/d1rpIwXrsjZVMqRVUu2GTE5/SlNfnAFCSm0PoENdRvOV8BDjaoWjfT2A7vDCD7eiTVd/iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9wKTMA0E3ydanWRsK1KNQm9Nb8Fyy/4rslF6oJSD8Y=;
 b=a+Ow7RPZDF0/wWkH1loN/GPBQmleTmULV/GWmrT3GQ64Xi53PP238GPsrnQEtu0rvliKchvGQXuCgKIRSW2Icc7qEXk0IFfk+6eR0CW/ffMbx2aN25t5mO5sWD8VUIbp+5yzClzjj4ucL1b31qKfvfN/lSwXVie0+TeSQPY1yA0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 09:47:31 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:47:31 +0000
Subject: Re: [PATCH v16 01/11] xfs: Reverse apply 72b97ea40d
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-2-allison.henderson@oracle.com> <87k0pqbb7z.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <21ebed64-f6fa-d57d-42dd-fd778d579c81@oracle.com>
Date:   Fri, 2 Apr 2021 02:47:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87k0pqbb7z.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY3PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:a03:255::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY3PR10CA0012.namprd10.prod.outlook.com (2603:10b6:a03:255::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 09:47:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e189d371-a010-42bb-216f-08d8f5bc5573
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB48139E3EB6A043852FE30BA6957A9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7F5BrfD6rRwkoiEWyvaSgPCpNUmQdHoYH4NqmosyOnAOKzOKZmEEOlDuEpGPJnvMEabH4xow/xNizuUwAGN/LJzChaxFcIHhCcwJ/0F3wrfGsGsh1ncmYUnuc2rpwDqnE1ELPjRwAIRTnywcpxZtWo5pFL9fF9e5XGOil6910XRjOADUQMRijKrPVCQQ5y8Iob0UiSfXncmpJfGLMb9qRkxhaz4to3xepRUny3RLvaw+hoikq6UjLHq7BOkjjfrCH7zyTBj3fN5g6EwaC07H5fp7XW3C3RHjavV3CCRAjw3AMDfdUg/6FK500iWAnxRHMzHNILytAjCY0nxYzChj+A44Q6G3Reh3Xcwiyt41OFKaRo8XjdwS/Jq7jbaAcIXLdYHvuVPeoNcIdq9v13Y5590uL9Au1vL//4xpsJpyJYalY5BussIwdhIKC8W+I5ds5yiZ9URny2Cz6pEx6d5nKHaQh7H6QuwsiNE4UbtnHl5/mgA6/bCe3OeYi9g1h+i0VFCrgR8+d/MHIP/ohbKzRNK7QVR9x70ha7RAguSZBjGDsFG6nh3rl4NyzKCH0gVPxnyK3BZK4AbgFzBt5XFIOXkynHjVMShszs8pW87mp8eZdZ7Pyt+oBqtBcZvHfdVJ61pEn8pEBL0oCexI23Z8S1vT124EPSVzoyYn3ofmKRuC5ChcdCz0s+LQWAYanuhqZ+KofrAGzHWJioODdVxf2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(38100700001)(86362001)(956004)(2616005)(16526019)(8936002)(26005)(2906002)(31686004)(186003)(8676002)(31696002)(36756003)(83380400001)(44832011)(53546011)(316002)(6916009)(478600001)(16576012)(5660300002)(4326008)(66476007)(66556008)(66946007)(52116002)(4744005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RUsrc1Q1VGFkZkdmWnJEOVJnbXB2YkFvSG9Mdkxzbk1keDZ4em82RERGeG1L?=
 =?utf-8?B?UlBrM1Y2VStzMUJMS0JRTzlyR0JQbnRUWjFrcElMWEUxWHVFbksvSXUzcVBm?=
 =?utf-8?B?UEkzd1VSZFpjRzQwV2R2RldEYlk1OWhyV3F3cFhaSDlqNEx2NHdKTSt0MGM5?=
 =?utf-8?B?ZnlrRm9YdnFIZmt2dXRGVlZVelIwRU9DTGRpRHd1bXNMaDFRK0JmQlFYVU9K?=
 =?utf-8?B?ZmFPNG5LRlg5b3dFRzdqekdkOUpLSVZOYXA4RmVrWlgvNElqOWNqcUxSdlhQ?=
 =?utf-8?B?U3lBeG5YdXlxSE9tM0NYVE92OUtPZGUwTnladjR1WE0zbFpXMmhSN3RNTHJX?=
 =?utf-8?B?QVJ2NFpNdjBOckxtUnNJdkhPdHZhcGpOUDNrd1ZoSUh2anY1K2l3Q0U4bkE2?=
 =?utf-8?B?NlhGRHpSRXFaZ0hwVSt4UGJHQzdPcU5tT3VNejZ0UFVxN3hYRENDdnIzTmd4?=
 =?utf-8?B?amY3R3l1YjV5b295bWFNUDhyRXQ5cFdaemk0bDZtMXJlaEo1V1NWZklacXBm?=
 =?utf-8?B?K2V5MUx0aUdvUldnVjNBaHVSQ3BldXI2UXlENmpSRW5sRm1aOEFXZDlFWDlq?=
 =?utf-8?B?VGEwblZpMGZsTGZaUEFuR0VSeTliM292bHBDRzE2NXJFZVNhVGU5THhidnhB?=
 =?utf-8?B?RUhSZjlKTkE1N2JTNHdkdFF2Rno2N1NhQWlVV1VKS2NzeHp6RUZCQThlbFZ5?=
 =?utf-8?B?bmlVeW1Cb0VUNEVYS2x3NUY2c3U3NmJwd2NUWXVLcXJjSUNlVitFLzdUMjh2?=
 =?utf-8?B?SlkzM3AxZHJ0aXdNSEE3UmdEcEsrWFRqNlB4YXNuUFozSDNJTkQ0ellFWUlW?=
 =?utf-8?B?WmFhUXJGcVovbjBZL2ZwbTZpY2xQblJWQzZtU2hweGFUb0hKOXhGWTFyTUc1?=
 =?utf-8?B?bjk3ZWw3dXYrSGFZUTEreUpFY3MxcWtjMVZ1dHhsMlBvNG9SMXN4dGRtNEVa?=
 =?utf-8?B?MHFweHpva1p6N3puK3F1dFFrbHpURkZqUWFPR1Q0NHlmL09qdnF3VlJ1RUQ0?=
 =?utf-8?B?NkRJek1seEF1OVdJdDhaWm84U0s5ZFd4TnlodU5aT0RmSVJjemNaOCtSUTdl?=
 =?utf-8?B?WFh2blROdTgwVFlMWk9IZWREQXFNTDgzRHhibGhmOVlSTjJIOExvWmJnc2Nu?=
 =?utf-8?B?eVhiLzQwU2JkS25Mc21naGlodmtwVU1zcUoxWmlNVDRHSkZ4ZXZualZpdVpk?=
 =?utf-8?B?SUJBZTlWSnhsaEdKL1hab2p6N0JhbnV3ZWE3QUVxdHRxbXNwbHBDZGNhVFpT?=
 =?utf-8?B?WEFrQlR4QS8wbGphM2doK3dtVkxYVEt6c2ZMT012NUlXQ1FwYVdoT3dTQVBw?=
 =?utf-8?B?SzVKUjNDR3V6MXRsZ2JRUzVTaDlrNWYzUGlJSkZXZTF5K2FhbDJ2ZUcwaGZr?=
 =?utf-8?B?QUROZUgzMnNOYXBPaGRTWXR3MnU0R0R3VjJuKzN1Qnc0ZE02ZlhndTkwUWlJ?=
 =?utf-8?B?ZXFpVlpzU1pUL1RPV0NlbkM5ejZyemlHM3lPQWtsbURUY2hJb1I3K0FZRUp6?=
 =?utf-8?B?YWdPTW1xSy9UdCtnazZEeCtKVDQyNncyekU3b0JkQkliVU96ZnZEWmdLUDlP?=
 =?utf-8?B?SmVSbkxQbFJlZXVKRG9yUXpXTnRFKzhQQTczZzBQTlVxZUE1UGhjMFBXZk5F?=
 =?utf-8?B?c3dsQnZsMTdYYk9rWU1uMlgrY3E3TVM4NytTaXZrU2w5YlZhL1ZFZm43TTFJ?=
 =?utf-8?B?WFdtczVFZGVRNUJyNmVHNDU1TmpCb3pENzlUNld3V0xNdEg1T0RLdEVBRUFo?=
 =?utf-8?Q?LkEmAFQh6ddRAOspl2VeUGkGHCUoSstm2b9Av+F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e189d371-a010-42bb-216f-08d8f5bc5573
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:47:31.0285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCeJ5fAvJL37Yp4zOMSoPpZdE1a/yDoCSfp9Ww2sNNbrbw8NNdmoRXwskduH0WRO/aJf4CfYAG5byJGnpzZfrqQtGa+Pg4Mbdum4hxzqIzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020068
X-Proofpoint-GUID: MY3OLIrPs2Lal1PbRT_alYCPlY8UQMGE
X-Proofpoint-ORIG-GUID: MY3OLIrPs2Lal1PbRT_alYCPlY8UQMGE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/29/21 1:44 AM, Chandan Babu R wrote:
> On 26 Mar 2021 at 06:02, Allison Henderson wrote:
>> Originally we added this patch to help modularize the attr code in
>> preparation for delayed attributes and the state machine it requires.
>> However, later reviews found that this slightly alters the transaction
>> handling as the helper function is ambiguous as to whether the
>> transaction is diry or clean.  This may cause a dirty transaction to be
>> included in the next roll, where previously it had not.  To preserve the
>> existing code flow, we reverse apply this commit.
> 
> Indeed, In the mainline kernel, __xfs_attr_rmtval_remove() invokes
> xfs_defer_finish() when the last remote block mapping has been removed. Also,
> xfs_trans_roll_inode() is invoked before invoking xfs_attr_refillstate().
> 
> Hence,
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, thank you!
Allison

> 
> --
> chandan
> 
