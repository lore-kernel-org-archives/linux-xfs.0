Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ED3C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 20:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344472AbiC1UYe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344471AbiC1UYd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 16:24:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF3966ADA;
        Mon, 28 Mar 2022 13:22:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SHtV1s013595;
        Mon, 28 Mar 2022 20:22:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6f8tLCDdanZl5aCtbDKBPuNkygT79+9tkKNCuqJRNkk=;
 b=bYPSj6bRXr9jr9MadNpMm4Znh/tze669TvbwkuEaSgA1OhcGVlS4hrgaeSgFbR9JR3tL
 61jrRAku6SjOUsmCnIKTQ88ttSSbe3l67P3fRWKpYxP+X+ZIWOehD79FQMTK/xWMbvnK
 zLyvfWQbD3LynB9GY8bAeJHFKV1Rpg2RESHo2tLLFMqzo+zH481IZqdVP20IitQKPmuq
 7eheV91xCfT/zUfY6WUDyReuSTJZ2VP0dGKo/bZDduRz6DOJzop0H1wLn8jyGEVqpfPV
 ap7axItBLSSgaMfb0bS8Flvllo00lbHmUIQHd8q9KgGD1XEUe4UlliRoKmp6ZXU+QdIx jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0crrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 20:22:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22SKGaXx194044;
        Mon, 28 Mar 2022 20:22:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3020.oracle.com with ESMTP id 3f1v9fdt6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 20:22:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaHgDJM93qc8aqNzw+9plrq5ZOSx+yVnTbIB7+z8dAe35F2FOOVYya3iGLx5oc5f6CDwbC9g0UwzhSPSrDAiTWl1/6ea2vXv1t4gsBUCpBMQ7hVG463HnfGm3VQflht4nalY0kZ2gYcCR9SZWxtjNB7grgJXWhTkEhIO6/fbx8Fy/2VW2nIvoNmqS4ubDwJT196nGdvwYp08zwCEwU66eeFYm2ySpzSLNt1gq79O0TXtpxHkmgPJUlCFi2LmAtST90H0jiBxBAZ428zXqHl/txbUhyH/D+hRIHH+RTEcCbjxv22rfL6FVPUesNDF/Ot+P+KijzQdIMdLf6fcPBuMtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6f8tLCDdanZl5aCtbDKBPuNkygT79+9tkKNCuqJRNkk=;
 b=GFViJW9XVinfs167lL1w4jinoX/0kXS1t7i1oHIxpg/+9FFk+fdzyT6tUSORGRpWYGh85tsy5vv4pvf7GU0y5V2sspPN2NefSu2CcQzjyymjuMmwXsSB9gmO+1eCIvNcR0KD6HcFQGtKCF+dl9HN74f0FRG/z3vyUNivuM6CugFmVjOLmrMv5Bb4Bm1GoOMTHu/PnPXWPBXFrWvTD9IvtyYS5AY3Rq9TMHo8zlvxD+Kh7mn2Qr9X3X2H0sxauVK5GLJSfsSIagep1uxwG5krGC2wKl78r1KUGjOe3ho3Iq9mNAjMzy7j3E/i0dC6TYhM0OXt6tr0s1U6q9wpkLHMbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6f8tLCDdanZl5aCtbDKBPuNkygT79+9tkKNCuqJRNkk=;
 b=wJTJl5PprsE5FYKWPgnnPyYpE0odYWnoFJuZjpex/LHOUYEBdwRZRDONEureAxdVMjh/RjdT6pnoO1mcW0kMdwr7KQ2nUlmUwhJfXC0x5FXvf3sZkTduz4pjN74cd1cJVjwZF7/7qy+QKfDpL5rNUYL5FRSW23FCdcw1GU7R6iQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB4840.namprd10.prod.outlook.com (2603:10b6:408:12b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Mon, 28 Mar
 2022 20:22:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c517:eb23:bb2f:4b23%6]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 20:22:44 +0000
Message-ID: <84763f8a4624fde277d6811553594b1dd41005b4.camel@oracle.com>
Subject: Re: [PATCH v1] xfs/019: extend protofile test
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Date:   Mon, 28 Mar 2022 13:22:42 -0700
In-Reply-To: <20220325175919.GU8224@magnolia>
References: <20220317232408.202636-1-catherine.hoang@oracle.com>
         <20220323013653.46d432ybh2zpdhhs@zlang-mailbox>
         <641873A3-0E40-4099-9804-35D1D6792CFA@oracle.com>
         <20220324192600.5dx3vkmrl6z3snu5@zlang-mailbox>
         <20220324201730.GS8224@magnolia>
         <20220325133356.ektmgzck7rpaghcz@zlang-mailbox>
         <20220325175919.GU8224@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0PR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:510:5::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad698fe9-63b5-4b3c-27fe-08da10f8b790
X-MS-TrafficTypeDiagnostic: BN0PR10MB4840:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB48405E7C2B8FB5EBEBC180FF951D9@BN0PR10MB4840.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SqdSPydFUIMcFAHljfd/f5PjLGZTm43o9/VQE2Wc4uulDLXDCZSaCykynPgIm/qkWin7OSmkczxHhYzocXPjefnzMcQOu76Mps7VbFaWulVI3+WlOtyloCgvceSuZ4ObwsUjivouc78HWc4aZ7TCJ+AN12AMFKG1kyXKT+55EqqpPt7tOHOnSrOhTlxY0VN4ayxNeri0iQF3g+LWjZjNLssztEihU5jAAe4rQTZJNcnLLOJ7HvL+Niqc2IAVI2YrTRFODtCq2UzkBTQsOFo1c35bqZG3VzX7LmfqyNHyZh690EJjrER+/J2tyY5oxPnKISSZWdO/bYxhwE1yn5PkmCCtYubQcRaOsGe1SYSvIoAFhToRvOsn79bdlCQdQ0r1pVx3MoyLCvlFNFQdI/E8YEhlyJD+0CWbhOVDXeHKDpAeW1FEyJIlms3+yRrUADxWFQlkht1FCL6YJrtk1LKdze+aC/xBWQjNN7z2NYMJAm50jofHL9RbTTCuNlSPTtZARrlXo2VUzXR+lcI2t8z7/kfV3NpjNVhKuYOUMh7QkfCcNGR7N8NvYZGPNlEbW6bqk81Eg0Y/uka0NrkaQ5GNyy8Evwnx2l19mmoRUng5Cl8/YldlLaAuQ2LpLjdR/c/nVMj3P7AzkDlkzmiKnyXt637ZaVqGhHmJnnOHQz4eig0GNhlGncnQtvjDMhUxq7RBbezMQCQnYRqTVxna+tBt0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(38350700002)(38100700002)(316002)(5660300002)(110136005)(6486002)(8936002)(8676002)(2906002)(66476007)(66556008)(66946007)(83380400001)(6506007)(2616005)(508600001)(186003)(26005)(52116002)(36756003)(6512007)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjVNb2tlVG1pR3NmRjZhWlVseU5YbHNoSjgzWVg5L0hHRlREQkl4NytrdU1U?=
 =?utf-8?B?NHFSM0ZPakE1N3lQcHljdG8weEV6ODlLS1c0b3pxdVcxUDFPVXQ5ZjBHTyt0?=
 =?utf-8?B?QXhQOHJZV0FZb0RubG1hSWtrMW9pcllJT0cxbkx0Mms1UUZUZEx5V3V3QlFl?=
 =?utf-8?B?OEFEYUtHVVJxdnlGejYxUVhQMzF0M1ZjdERBTUJhUzFUaXAvRW85ZS9BWWF4?=
 =?utf-8?B?Tzc0aFNweUp1MWFNaDIvcHZ1Q1NDR09nRzRhd0ZWLzVTSjVhNkJqaFc3TnJF?=
 =?utf-8?B?QldGd3dhMWpSUW16ajNkRXJpcVBPQmxNVGoreko4aTIycTNOM3hHNFl5alUv?=
 =?utf-8?B?QjhWWk4vQ1lMMmdJcnVOdENyS0E4NzYva3FSMUpGRlhsQVNkL1J4SXRRWE5T?=
 =?utf-8?B?VHBQMjZlUFJ2dEd6d1h3bkVCK1VmZDJ0Vms3ZUV3bnV4TURNRGVFZFNaV2Nh?=
 =?utf-8?B?bTBHN2VPQjREY3NWS0RoY2lPb3pFZ0hpemcrZzgwQUtsTDB5MWpLMC9hbU10?=
 =?utf-8?B?dWxDS0xIVDU1M1hIQmRxWk0zeWtTQ3FZbmhta2xYc1lZYmY1WVdNSC9IMXJz?=
 =?utf-8?B?SmIvVjgvMHdEUjMxK2tpNmdYNWlPWHhRZXFKQkN5TDlUYzU0Q1pDS1BhcmpC?=
 =?utf-8?B?UFZCY2ZxdG5QT1RQZWpERytoVVB6eE0wMDd1QWJ2bEtSVDU1VnY1bVlRajZh?=
 =?utf-8?B?RFRCazFxejNNQXBSbjFqZnFBMXJqRnNPM2F2dzk3dlgvY3dHdnJmaHltMHlX?=
 =?utf-8?B?SElWelBKdDRFT0d5Q0dzQkg5TXJIc2R6UDhJMG04aGMrOFA2dXNtN3h1V1NV?=
 =?utf-8?B?SmFyUmhoN2lyS21oelBBY09VR211S28wSEdEd05XQ3dCVFZkODJvOGxsWXJu?=
 =?utf-8?B?eEhmME1PdHp0eVhCYWxaSXpRYzI0dzNNNVpKYVpsS2dlWVhUUnRPaVgxRm1B?=
 =?utf-8?B?bEtXdGd1dFBqdFoyeUxOY1RaNGJ4VnJtbFlXWXZvUmNUaFNLS1FjUWxZVXBP?=
 =?utf-8?B?ZFRtSm5pQlB4b3Jrd296cGtWeGt2cytzZlpYL1NhNXp5SVNEUGo4aHV5Q3RL?=
 =?utf-8?B?QmR1TXd0RFI5V0NZejFjWmk0ajNWd1BFMXorQkpDRWxwbngxb3ZrcXI1YjRW?=
 =?utf-8?B?WUkrVEZpNnoxMU1UNjBycXZnai9yQ2V2VHQ5UHVXMWZyQ2xzNjgyenZ5cnhK?=
 =?utf-8?B?TzQ4T2k4WXVzWEM5cExzQy9QQmc4OUpNMUlobnpmc1ovY1lPQThUNlR2c3ph?=
 =?utf-8?B?MlBtY0loK1N5MnRtZThObkNmcWJXSHZiQVRqdExrS1VTT3hXSVRNYXRNbHd2?=
 =?utf-8?B?Ui9GZ2thZ3lUOXFla2xXeE12T1dVTG1sTjZsdEt2RUVnc1VqbmZSMmhXUStN?=
 =?utf-8?B?Ym04T1lzdjZXc2pmZ1ZnYVVyWUlSVkZEaTJoRjNoNm1XM0RTdjhHeEs5dFZl?=
 =?utf-8?B?bkdNR1o1NUZXL3B6cHk4MHdJWVlINXk0RHVwaS9BT3FaNTg5b28yZTAxYkVW?=
 =?utf-8?B?cU1obW0yWEJ6ajJOcVRlMXM0YjJ1S0FBQkdoT2Fzd1FSbDJTWGV3WEg4bTV5?=
 =?utf-8?B?Q1JLejZib0lFYTl5bnJTdU9PbzZsZDBIcnJnMjlWaGJ3V3dkUUhoU25Mclpx?=
 =?utf-8?B?ZXZIWTlKTndtL0s4UEVncDB5eXY5ZERmVHZBbHlZREtMTDFVeFFDM04rMVlx?=
 =?utf-8?B?UU0yZmZqd1E5c3BKNEhhMXI1cUI1MGx2NGhhV3ZvRnhtWW56eloxdlpIcnBr?=
 =?utf-8?B?dnNSVVZNUW1lYmU1b25QYi9WTlFCenFrSGhaNUtXMVpvSm1tRzNuRURVMm5B?=
 =?utf-8?B?czFudnNva0JmUTNQZzF1OVFsVkZid2dTZ1BhZEpYZWl6WnVOWWVyOHMwVzVi?=
 =?utf-8?B?WTRwc2dLVXVGQ2h0RlFjUW81WGJSL3JDaUJKZlhKekdNNWFVVVh4VmdKbElu?=
 =?utf-8?B?ZmlXWTlWUGxxbzlrbHVLZVV4Tzk4TnAxd2VLWUtoTjFPYWZoVVZMZHZRK1Mv?=
 =?utf-8?B?c2hOei9ETm5HSTE5ZXhveWNhWkR0VkJGaEtYSzVkS09XZm9jVzVSVkpqbi9Y?=
 =?utf-8?B?UmtoUXJyVHpCS2pVTUtvaDV1Sm40a2tFVGlGRUZkUmJwZERQRGcxUnQ4Z2Fq?=
 =?utf-8?B?dmt1RjhLMk82VGNONVV1V2tUM2dvdmxONHZGNWF4T1Z0eTExZEFJQ2xSbGxk?=
 =?utf-8?B?bWRSTHVJNXRQUmZuZ0R3eWl3VFRyM1FJbWRlakFsVW0rc3pUTGdtQVBXVHRR?=
 =?utf-8?B?aTN5d2FXdzZoa3JSbFRHMUdqUGE4aFU3aFJUaHl5cUxrdDZkaVRGcldTSkJl?=
 =?utf-8?B?UVBLNnZjRTMrc1NGdzkxY1FBZ2ZZekFKZ1ppNzU0S1VpWVFTSG9EKzRmT0d5?=
 =?utf-8?Q?NpAo+n5XvgAaQfC4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad698fe9-63b5-4b3c-27fe-08da10f8b790
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 20:22:44.6134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5EXWUAU8b5GN7WgOEJeJd1kV+7YwV3aO4G3v3gQbCyP55dGXQYh/HqnCUE4kbNAtBchpumSyE26+ggBuTqV0j5xSJQj+ymqcmlyhjib1go=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4840
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10300 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203280111
X-Proofpoint-ORIG-GUID: xARQOlVJBUy7jxBtqNmWiQWHS-npfKua
X-Proofpoint-GUID: xARQOlVJBUy7jxBtqNmWiQWHS-npfKua
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-03-25 at 10:59 -0700, Darrick J. Wong wrote:
> On Fri, Mar 25, 2022 at 09:33:56PM +0800, Zorro Lang wrote:
> > On Thu, Mar 24, 2022 at 01:17:30PM -0700, Darrick J. Wong wrote:
> > > On Fri, Mar 25, 2022 at 03:26:00AM +0800, Zorro Lang wrote:
> > > > On Thu, Mar 24, 2022 at 03:44:00PM +0000, Catherine Hoang
> > > > wrote:
> > > > > > On Mar 22, 2022, at 6:36 PM, Zorro Lang <zlang@redhat.com>
> > > > > > wrote:
> > > > > > 
> > > > > > On Thu, Mar 17, 2022 at 11:24:08PM +0000, Catherine Hoang
> > > > > > wrote:
> > > > > > > This test creates an xfs filesystem and verifies that the
> > > > > > > filesystem
> > > > > > > matches what is specified by the protofile.
> > > > > > > 
> > > > > > > This patch extends the current test to check that a
> > > > > > > protofile can specify
> > > > > > > setgid mode on directories. Also, check that the created
> > > > > > > symlink isn’t
> > > > > > > broken.
> > > > > > > 
> > > > > > > Signed-off-by: Catherine Hoang <
> > > > > > > catherine.hoang@oracle.com>
> > > > > > > ---
> > > > > > 
> > > > > > Any specific reason to add this test? Likes uncovering some
> > > > > > one known
> > > > > > bug/fix?
> > > > > > 
> > > > > > Thanks,
> > > > > > Zorro
> > > > > 
> > > > > Hi Zorro,
> > > > > 
> > > > > We’ve been exploring alternate uses for protofiles and
> > > > > noticed a few holes
> > > > > in the testing.
> > > > 
> > > > That's great, but better to show some details in the
> > > > patch/commit, likes
> > > > a commit id of xfsprogs?/kernel? (if there's one) which fix the
> > > > bug you
> > > > metioned, to help others to know what's this change trying to
> > > > cover.
> > > 
> > > I think this patch is adding a check that protofile lines are
> > > actually
> > > being honored (in the case of the symlink file) and checking that
> > > setgid
> > > on a directory is not carried over into new children unless the
> > > protofile explicitly marks the children setgid.
> > > 
> > > IOWs, this isn't adding a regression test for a fix in xfsprogs,
> > > it's
> > > increasing test coverage.
> > 
> > Oh, understand, I have no objection with this patch, just thought
> > it covers
> > a known bug :) If it's good to you too, let's ACK it.
> 
> Yes!
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 

This looks good to me as well.  Feel free to add my rvb:
Reviewed-by: Allison Henderson <allison.henderson@oracle.org>

Thanks!
Allison

> > Thanks,
> > Zorro
> > 
> > > --D
> > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > Thanks,
> > > > > Catherine
> > > > > > > tests/xfs/019     |  6 ++++++
> > > > > > > tests/xfs/019.out | 12 +++++++++++-
> > > > > > > 2 files changed, 17 insertions(+), 1 deletion(-)
> > > > > > > 
> > > > > > > diff --git a/tests/xfs/019 b/tests/xfs/019
> > > > > > > index 3dfd5408..535b7af1 100755
> > > > > > > --- a/tests/xfs/019
> > > > > > > +++ b/tests/xfs/019
> > > > > > > @@ -73,6 +73,10 @@ $
> > > > > > > setuid -u-666 0 0 $tempfile
> > > > > > > setgid --g666 0 0 $tempfile
> > > > > > > setugid -ug666 0 0 $tempfile
> > > > > > > +directory_setgid d-g755 3 2
> > > > > > > +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 -
> > > > > > > --755 3 1 $tempfile
> > > > > > > +$
> > > > > > > +: back in the root
> > > > > > > block_device b--012 3 1 161 162 
> > > > > > > char_device c--345 3 1 177 178
> > > > > > > pipe p--670 0 0
> > > > > > > @@ -114,6 +118,8 @@ _verify_fs()
> > > > > > > 		| xargs $here/src/lstat64 | _filter_stat)
> > > > > > > 	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
> > > > > > > 		|| _fail "bigfile corrupted"
> > > > > > > +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> > > > > > > +		|| _fail "symlink broken"
> > > > > > > 
> > > > > > > 	echo "*** unmount FS"
> > > > > > > 	_full "umount"
> > > > > > > diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> > > > > > > index 19614d9d..8584f593 100644
> > > > > > > --- a/tests/xfs/019.out
> > > > > > > +++ b/tests/xfs/019.out
> > > > > > > @@ -7,7 +7,7 @@ Wrote 2048.00Kb (value 0x2c)
> > > > > > >  File: "."
> > > > > > >  Size: <DSIZE> Filetype: Directory
> > > > > > >  Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> > > > > > > -Device: <DEVICE> Inode: <INODE> Links: 3 
> > > > > > > +Device: <DEVICE> Inode: <INODE> Links: 4 
> > > > > > > 
> > > > > > >  File: "./bigfile"
> > > > > > >  Size: 2097152 Filetype: Regular File
> > > > > > > @@ -54,6 +54,16 @@ Device: <DEVICE> Inode: <INODE> Links:
> > > > > > > 1
> > > > > > >  Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > > > > Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > > > > 
> > > > > > > + File: "./directory_setgid"
> > > > > > > + Size: <DSIZE> Filetype: Directory
> > > > > > > + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> > > > > > > +Device: <DEVICE> Inode: <INODE> Links: 2 
> > > > > > > +
> > > > > > > + File:
> > > > > > > "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> > > > > > > xxxxxxxxxxx_5"
> > > > > > > + Size: 5 Filetype: Regular File
> > > > > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> > > > > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > > > > +
> > > > > > >  File: "./pipe"
> > > > > > >  Size: 0 Filetype: Fifo File
> > > > > > >  Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> > > > > > > -- 
> > > > > > > 2.25.1
> > > > > > > 

