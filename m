Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB02C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 22:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiEJWbh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 18:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiEJWbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 18:31:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A0213F13
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 15:31:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ALgd5E022574;
        Tue, 10 May 2022 22:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=CswI0aPkp8uy+vVEPis0sp0aOIaEjgI4aSZxIuHSN+o=;
 b=K6xRkUPFfvisuvfqFh8yGCDTVDmGXalZa5yXzr8T1TgNmcj1QfVi5irZeRQKuUWWcdvZ
 cmFrgl9Zd5B0xHzRCqoUHoLfsagvDzs+w2rGq2hMMlMFjTYNqa1EYcneIzlR7z28Ws92
 LDG4OdilYesz+vXlnvegOk1fPhpqknPKy9U3E1KXeMWfJn8G/WKqknilNa/nwuiSILSH
 /50R0fhph5UY2fQzCj2WjDgUIOPhup2zo8A7Z0POXH3zaBR/GI7wdr5cb7p19WUqfxYw
 WLXiXvXzk18juunVMnQMtWQ0acMXxpIz4IasShbXsBgNihb/y1+U6PDUXFsMfPdbu2Gh 7w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwhatg4bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 22:31:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AMFcsf025519;
        Tue, 10 May 2022 22:31:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fwf79w0x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 22:31:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXtasiaaZqo9Yc4ODWwufzCDNzkIfem/0xQ4roXWFcivtEjK4qhwTMYk1gOqHGxYTDi4uXWN4jSVUobiEVpH2gNa6Ma2vC/W0PXgBnvgaNrP+k86g/XF0GVjOrw1aHlr7/mXAwRuZ8MQCrca77pVBK95NvrFEyZKyZLJ77q76/mcJyEGlOTFGpQ6zj16RfAgLM65SP72/Ht8EyqYTqD7PX+sdtweG/OzoJwLS/RTWRQvS/ZjzAwDF0yqHwVMHjowmtiLYzdI3jW9Ge1YqLkye5eNwqhGTjGmRx81OndPK220S0Q/gTDNiGzndw7C+TuSeyG7TkEOVJ3rbbPFEVxzhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CswI0aPkp8uy+vVEPis0sp0aOIaEjgI4aSZxIuHSN+o=;
 b=U1Q4le+uwb60SjuQPq5YkAcTbgwzqWdBl3JP40hcH1qUyz1TduLghbahuqoR4iUbi6hD49or0aqDpsMqLw/A5zKUNUAsxEjRH06UtJFFZ9StMx2Mx975KV0AnAoFKj9vELSS86ZDktLwF6CkU/zY2chJGIT4zYlxVI0PKV1uVpWIjWbIh3hEg/eXARA8/SmS0OgXTHTS4JFrDC9SF8Fj6NNv2SGo0sMb8oG7d9gF0Pi/c90cwyqc/PRAitNDKwrhM2BuGwne4nS2OIwhuBEUs5XlWwEP3SOYMkYZUa7x1WYW72S/FoadRdtfrMu5fshpQIgFHvlZDG8dGoz7Lq0nrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CswI0aPkp8uy+vVEPis0sp0aOIaEjgI4aSZxIuHSN+o=;
 b=dWV3MG/maTlLz2yHa8T52BSiXAoQsbvB694+PlFwt0tkWxBT3L5ic/uchXt9EshRSI+ne3qMafebZkic1+iz/EMg6yyxCgM26fTnIKSrs8SvQPSxRG2et4d7QUZZixIhLXeqt51fUClmMPvhx7l14RsAemHJpR5VfWUYGCbDUNU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BL0PR10MB3428.namprd10.prod.outlook.com (2603:10b6:208:7c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 22:31:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 22:31:30 +0000
Message-ID: <fe70c43373e1658d72b728319a42c68c19b69451.camel@oracle.com>
Subject: Re: [PATCH 16/17] xfs: use XFS_DA_OP flags in deferred attr ops
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 10 May 2022 15:31:28 -0700
In-Reply-To: <20220509081738.GO1098723@dread.disaster.area>
References: <20220506094553.512973-1-david@fromorbit.com>
         <20220506094553.512973-17-david@fromorbit.com>
         <20220509081738.GO1098723@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:217::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6683a0f3-9cd1-4627-a65d-08da32d4d40f
X-MS-TrafficTypeDiagnostic: BL0PR10MB3428:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB342893163247B3187891280F95C99@BL0PR10MB3428.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dboFVZ7767++ogjDLhKHrAlHQX46e87XjULCmERJVsiEazNgENOgZM3wqgwX79gxEahBsyG129U/zGXdpr3dbBr/c3i3N6x/g0c9ZR7keIS4oQuPhTlJqgSIUR/Dsz2UiDHTCqcB8gMQGj17s+c9+/b/T7A3vqAsCogI94HPZnnLQ+1RDXfTIM1rKZEKyGYnysRp9JX+uijVxJpGI/4NrM94fz3rUh4CD9LjxHkIVJX8vaPkIJrwR/U+15Isr7sIoKBP8jmhyCSHukz6FkX4ucTOG1vZvFwmr7g1Ojk9BHw24kZvfyTksK1r5jlCrfy8+yGjNUd+px00kNKH/BcP+msTgWsuAC0kqvkb5d4WnNz5YsAOyl5xzp0X7n3BiFxPOIAlpkhrd1W32DBAXJyobMs81SBycEZDvfvZMBLOG/lQGwACbqc2Tyy1dY9OyxE0WAvfFkWaTzxsbGrRkTyuIZ1nCvfHI3bOhVEex23HTMQvk2oNXtV4pWnGjFJh2ZiUtJnb7A5fLjJnRWA5nSpM8CokebioDhUHUBEcXLHjJhgNQaHR27almccNw2pXIJ17tcbpdq8RZj6gLyi9F7Yuytw/Iy8h1/Wqm1E7samD+QYRnNj9JUvBboQxeJzFOQuFxvic8dM9XI7DWVqfPj7SqOvjIMu8IKnnrHb6CAATT9RIzTNOgqh2PSqMaRJgiXnWWNlTslgpIgXkB8piMMeFsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(36756003)(6506007)(8676002)(66946007)(38100700002)(38350700002)(83380400001)(66476007)(66556008)(52116002)(6512007)(5660300002)(26005)(86362001)(316002)(2906002)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWo5c29id2tsV2NNZFBLYTNCeTZSQXQvM3IrTjcvWi9SNUhGOVREKzd1Rlhs?=
 =?utf-8?B?QWViL1V1M2VBRHNDVHdGN29OVVVDY0xRenBmVDdiZUVFUGVXQmIwU05LcnhX?=
 =?utf-8?B?YmdGU0JuMDdYRkZ4UnBGcTFQR3g5UUVuWTVRTThsT21FVHhWZFBBcTIrelRw?=
 =?utf-8?B?VGJ5RUdPRElLYk9vZTErV2puL2tSZW0yM3F5QklVRlR5VE0wYlM1Z21DTk9i?=
 =?utf-8?B?bS8rdGJjVXpQaHF0QTN3OGFFRHNuQ1ozVksyd3NReE1GcmIybHh2OVFNSm5O?=
 =?utf-8?B?TktqMGtYbUZzYzVHdS80UWhWeGVRRVJjK3o1L3JreEtsUHIrcEZkNXh2dXl1?=
 =?utf-8?B?SkR6UjBaa3BYRVFvVjl0SmVIYXVyM3BlUkJORW9IZ0g1WngxTzBpNXo4Qkg3?=
 =?utf-8?B?VER3aW1CSlVjVFZpQlFpemxpbDBzQTMwaXpjRkVBYm41djBJTysrTDVJbkRQ?=
 =?utf-8?B?eUJXTVhzK1BQZSthYk43OGZIT21xa0dWdEpzRWd3Q2ErM1ErajFvOHoydHFy?=
 =?utf-8?B?WXhqcEJySkJHTjlHaHdtRXFabVp4UlV4WnBhcTNqOHFaNXhrYTgwQ2hrcTN5?=
 =?utf-8?B?c2xnNGZaczZqenRhRzJBS0g1YWxEOUpMVXpmKzZDdk14eVFkaE55b2lXNTk4?=
 =?utf-8?B?WVZVNkhobC9yaEhEU2lXYm5raXIxdTJaYkYyR3lYRG9iT2RqY3BJckpTQlAw?=
 =?utf-8?B?RzJBeWdPSndUUWZkdFlwYjd3MFVBYUI4ZmFRaHN6cHBSZzI5WmRUbU9BdGRz?=
 =?utf-8?B?aTM4UUlEVERLVXVoOEpyT0FLNjZMRHYyYnBlYjd4MktzZTBweWp1ZW1BamI4?=
 =?utf-8?B?UVpYU0hpMzA3TWNFSGZGd21SbkVPSHBNdVppSFRhQXFMV21ZdElHcUpOZGFa?=
 =?utf-8?B?dnJxeWJLUlZ2WDV0S0VyK3c4ZVBVSnAzbjdZTElVdnRreW5mZUxlYUVjSjRU?=
 =?utf-8?B?ZUxJTDdYU3E1QU52U2wwaU9BWmExL21VNGlXQTVEOXg4NXNZSS9DVE1TZ3pX?=
 =?utf-8?B?Uk1WUWRqV0FyTmhNVFozL0xVL3VVRzhCU2dWaGpER3pnYzRiZllMeUJrQUlK?=
 =?utf-8?B?YmpqYlQrM2ZQRE5QSzZsL0FQV3R3Q1RIZGl3ZHVTOTdCY3hFTU4xQ2w4WEZE?=
 =?utf-8?B?T0hLVWtoMnpYeENWMHlOYmJJQ2R0eGRMelNEQkVMeGZTRHhpZnQzcGVmQXl1?=
 =?utf-8?B?WEV2eExsRXVjRWpwQk1HNVIxWW5tbXRleEpySkhQYlowcVdkNDhnZlRXbFI5?=
 =?utf-8?B?UjB3dHJNSlV1VTM3RWd3VVo5c1ZMa3Q3Z1pYV1Y5ekRpbW9rOXNnZGNYempQ?=
 =?utf-8?B?VHlQWmFFQzBRd2VVQlhGbnZsRk1BSy82TUdPdlNZTjRLVlJ0SmVBMWptR20r?=
 =?utf-8?B?RXdGRkZ3RXgwK0JidkdPNEJkd2lGRnh3NFlxWmQyREc3dFdFbmRLcmdxT2VW?=
 =?utf-8?B?Mmd2OGZ6ZU5FR2cvaG1UNXcyTGRXN2VmSGFtL2xjWWRxSXlxUEFmYmsycnE3?=
 =?utf-8?B?OUlLSHoxdW5GY0lwZksvWUxndHVnSkRlVmgxZ0JMbEJzbVp1aTI4WUtMTXJi?=
 =?utf-8?B?QlgreXRnUjNiL25KNzVFZTRWeC9zNXlPT2lSeWZNSHZlRzZoTkhpL1BaM21z?=
 =?utf-8?B?ZTRFRDBJZEVXQ1F3M3hZdzY1YWdjNllJLzJoZmJtbjVpbi9aWlBDOTgyUjF2?=
 =?utf-8?B?SnphejFrVEE3bEgvand1UGIzbjlDZnJGN0Z5TTZxbkxpM1BnajY0eUczWDBC?=
 =?utf-8?B?NmdVeVRRWDYzTTFuVU1wVmxwME1lT1U0QXc5Y3RmVGpETGVUK2h6aFYzaHRy?=
 =?utf-8?B?Zm82bmZJY0ZSZzJwa1NlWWJvc1orTU9EN1M4YXlSMzNMTjlJaURLbzJMbEJs?=
 =?utf-8?B?N3dCcERYaGlJZVYxdDNjQ2RhbWpUV01TME0yVDJMOURWUXpiTWJLdEorWFRq?=
 =?utf-8?B?UzlHT2ZtL2hlMy9nS2tKVExGMy9yZGsvN0pyVC84cTFMZlFWdGxDSnFYbTM3?=
 =?utf-8?B?UUpYczJZT1ZnQkVDZytJV0NlWHZZSUlrb0J6eXpRSE1LOFlYNTRyd0drT0dM?=
 =?utf-8?B?WlJ1NGNrdEpQTkZzbFpsaUZBQUQvd1JlK0Q1TWN5enJybDdQN1JVd2Fjcis3?=
 =?utf-8?B?N1Rvdktad2Q4a3Fxa2t1bUZFVExDWS9XOFFENTkxZGp6VDlXR3dQejUzS1Vx?=
 =?utf-8?B?VnIrOG5DaEtxYnlONXFka2xzQjk4VVBXZ3ZibXRuODI5d2pLeHZ4ZSsvcEhY?=
 =?utf-8?B?UE10OWpIakVjWVhXMm9ucXgyTXNTUFFSbnpnTVNjbWVVNjZTRlkxV003OFJx?=
 =?utf-8?B?WjFKNElpcVUzTDduMnRDMjBsbjF0T0xmcm5CMDZtQlMwWU9heTdtVmRreE1u?=
 =?utf-8?Q?82mru+o9MwPtg1Zo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6683a0f3-9cd1-4627-a65d-08da32d4d40f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 22:31:30.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Be3dJnQ1R8/q1eKGu4FCTyKn9lne1YKnNXvr7jEa0r307CyjjYET2PNPr7D64jNXi3wDk2Et1103l4T62Jy0wMYGiu4eShgTRtvyTzRih9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3428
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_07:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100093
X-Proofpoint-GUID: YObu1tpzaJnR9th8eQL6XZxHszLyNeaz
X-Proofpoint-ORIG-GUID: YObu1tpzaJnR9th8eQL6XZxHszLyNeaz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2022-05-09 at 18:17 +1000, Dave Chinner wrote:
> On Fri, May 06, 2022 at 07:45:52PM +1000, Dave Chinner wrote:
> > @@ -1357,46 +1370,45 @@ xfs_attr_node_hasname(
> >  
> >  STATIC int
> >  xfs_attr_node_addname_find_attr(
> > -	 struct xfs_attr_item		*attr)
> > +	 struct xfs_attr_item	*attr)
> >  {
> > -	struct xfs_da_args		*args = attr->xattri_da_args;
> > -	int				retval;
> > +	struct xfs_da_args	*args = attr->xattri_da_args;
> > +	int			error;
> >  
> >  	/*
> >  	 * Search to see if name already exists, and get back a pointer
> >  	 * to where it should go.
> >  	 */
> > -	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> > -	if (retval != -ENOATTR && retval != -EEXIST)
> > -		goto error;
> > -
> > -	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> > -		goto error;
> > -	if (retval == -EEXIST) {
> > -		if (args->attr_flags & XATTR_CREATE)
> > +	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> > +	switch (error) {
> > +	case -ENOATTR:
> > +		if (args->op_flags & XFS_DA_OP_REPLACE)
> > +			goto error;
> > +		break;
> > +	case -EEXIST:
> > +		if (!(args->op_flags & XFS_DA_OP_REPLACE))
> >  			goto error;
> >  
> > -		trace_xfs_attr_node_replace(args);
> > -
> > -		/* save the attribute state for later removal*/
> > -		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op
> > */
> > -		xfs_attr_save_rmt_blk(args);
> >  
> > +		trace_xfs_attr_node_replace(args);
> >  		/*
> > -		 * clear the remote attr state now that it is saved so
> > that the
> > -		 * values reflect the state of the attribute we are
> > about to
> > +		 * Save the existing remote attr state so that the
> > current
> > +		 * values reflect the state of the new attribute we are
> > about to
> >  		 * add, not the attribute we just found and will remove
> > later.
> >  		 */
> > -		args->rmtblkno = 0;
> > -		args->rmtblkcnt = 0;
> > -		args->rmtvaluelen = 0;
> > +		xfs_attr_save_rmt_blk(args);
> 
> Ok, removing the rmtblk zeroing right there is a bug. Not sure how I
> introduced that, or why it didn't show up until this afternoon. The
> leaf version of this same code is correct, and it triggers on
> generic/026 when larp = 0 but not when larp = 1.
> 
> I've fixed it, but vger is constipated again and I patches sent 8
> hours ago haven't reached the list yet so when I arrives I'll post
> an updated version of this patch against it....
> 
> Cheers,
> 
> Dave.
Alrighty, this part aside, I think this patch looks ok.  I've applied
this set, plus a small manual fix to put back the rmtblk zeroing, and
things seem to be running ok for me now.
  
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>




