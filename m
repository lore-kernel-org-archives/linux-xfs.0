Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96B2C77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 19:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjEQTln (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 15:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjEQTlm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 15:41:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97829E
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 12:41:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HIGrLG002395;
        Wed, 17 May 2023 19:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=bF/U/JrMzgwBBJB0X8VUSQi7UU3mMqGubKHEL62Ni7w=;
 b=pQVGiyv93RVnSMumdJx/JEbaZjjIzyEIC5FM7KyByjY+NKXuTLyAVHASvDCz3d63urZh
 WsXdpd97yGE+B76wW7wYvmfHIBc3ZTvc9+Ayb/Zld9Il3ghpiu++RydxrgsC1TW0wiaM
 D5MecqXErIaOJFXquc6Mwly/LSmEZ0GjIc8i00o8xKa9zDArVaezTZ3CALAbvhUqH93h
 MOVveNyEgcMSPMRhq9JJv+MfDEztw8xvXNkOiy5mjUZykk+nG8a+abc9eOIclBxMA8Q6
 ZwB79JUXPqWZY/38tjMej5GvljS72//dybeLACyju8uMw85FDdQzoaCHzzFWHMKRoC4V sA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxps115a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 19:41:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34HIusco025022;
        Wed, 17 May 2023 19:41:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj105v4sd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 19:41:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZLw7cS/zIEiATO8xmdxL3TTKCluHs/MOC7nkCGLShccd2jp83hI4657X+bifDpzyp7APg2Yq9ELs5bhTJ5P55ZQ1MG0zfOXGf3zND62/n6IGay+eyP3khEV/B5cwWBYFOURQhS55A5yayykSOUBbJIExtcJldt/h7mwFNX2QPZBksn9aF3atuVmXGuZAi9NJ0LIOQZI0VAKbLpdpikhBa9ADEEfAsemwePjRq/IUJfh2XjmX8tbi6Ikau0cEnoB+r0jRXPCEoa51nfm8WfRTomLdsZ9no8eRD3hm52NCcMNR5Ss8XlBoaslwL75rxfxDpdFYkEyx9cXr7UufRHsgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bF/U/JrMzgwBBJB0X8VUSQi7UU3mMqGubKHEL62Ni7w=;
 b=at6roQ2CqEWziDiArWYxdU/j4ffrsbSbQzjBT19vAQKJ+tsySZ4zucdTz3YKpPsDLbWL0WRxMogjuhwGDjictdnP76TyIFOewU0LGZ932s8m3+/RJ2Dad5Vxq39+nZzi9uxKQU68hxFFBHyxjqDFP9F7nZvdUTsFo75jbZ5UdUE8pVKxGcEd1aKYPb0K1EZ6DEwFYPg9AJpnpLJrGQDvFP6HR74xCGMoCoq5w9s/9dEw3X8lwC86H4lM++dAPX8yL/2+KV85eFM9JjG+5LD4OFa3/WEGuJAD6+igV41kRgcEhjJB4bBFVHYp6CsOcD6J4jTZ5nqScP2Ut5ZW/RXLmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bF/U/JrMzgwBBJB0X8VUSQi7UU3mMqGubKHEL62Ni7w=;
 b=RRoMaqRNO3QLDB1K3RYtRFmB7xYDt7lhvsSIvDdYfyaQqdjxDcsao6jk1xsujGTv6iqB40cGxILVROE+ylGABFmC6CelcmDxw3DwXZxx11jD/qn7lygwd9f+ar66wOdpWSb6XKmU63MwnJFPxgLRhI/RxkJN4KLcRZxU3FzYMXU=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by DS7PR10MB5341.namprd10.prod.outlook.com (2603:10b6:5:38d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 19:41:32 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%7]) with mapi id 15.20.6387.035; Wed, 17 May 2023
 19:41:32 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Topic: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Index: AQHZdv9AR28b2kBDxE2gDgdaeEYEXK9XEBuAgAAZP4CAABXWAIAAEsyAgAXgZgCAAJU2gIAAC2uAgAAEC4CAASoOAA==
Date:   Wed, 17 May 2023 19:41:31 +0000
Message-ID: <2D4697C7-AF79-482B-B2D3-C41418FC6911@oracle.com>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
 <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
 <ZGQwdes/DQPXRJgj@dread.disaster.area>
 <20230517015433.GQ858815@frogsfrogsfrogs>
In-Reply-To: <20230517015433.GQ858815@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|DS7PR10MB5341:EE_
x-ms-office365-filtering-correlation-id: 3144e67f-66d0-4029-77dd-08db570eb74f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F8s1Dfmpan8sqcKLdVDYMfBP4r/FX5zwz2KX53Cf/m5rkr7XPFMu8lZgyZH/9PFY5SkWClBhUBNirSqf6LSwr5INFhUreuFJ2dUIlzUSEnnOqpA6qZzBy5RnznoEMApGXJAcJ4GHa4S+caB3TcVtUd7pWPGqUic2srfJPfiqLEwmFpxuE3kstQT3M1PZgHf/lkl/GzKIMxUn+S0W+Fp0b/w4JK1pmg1bGKpyCagoreMwoAwtjkKzaUo8NEnGbvTv74C9qXmwE76+70Gsi+ZI4ynaHxVlMkeJVxAHTUIj/ZXgt/f2xwO9zqYDo0tAKtLpQT+U1G5t72cZp9z27WEi3TkFcLZhsVN9jTqAM37imxIYHxwrJ38rFCETO9In8+HJhr8uOZroQyzifYUwH7jEhaAlk/Fypjo5hycR9DQi5KXyMsDeCsnvhfDyc9TktOpgOtEqec0Wa9MfGtklNoeDfX4A3ACJUBuEVAW11LsxW/iRhSSEC4GYQnwPZWao8Nc4k0bGqqiAL9sZpUCs8wU4SUfq+tsyAp2itFR48CQawY6w3NssjuSj64zbS3qDuUpRerh7BYWFpNyi4gSqMzffFguFNRbq9CdsZEDvXReliplA4X/TQ9tIrMHK69Hptj8axnvrR3PMwNsb81zRWM27ZvBWg92Or8RO6iVahzGTNmw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199021)(83380400001)(91956017)(6486002)(71200400001)(478600001)(54906003)(2616005)(26005)(186003)(6506007)(53546011)(6512007)(8936002)(5660300002)(8676002)(36756003)(122000001)(33656002)(41300700001)(6916009)(66556008)(4326008)(38100700002)(66476007)(2906002)(76116006)(64756008)(66946007)(66446008)(86362001)(316002)(38070700005)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oD8sNsTLgILO7sPKqO6RdmAmI7DhK0HdVIclHC2ZOydCWo5qJ4orz/SodERe?=
 =?us-ascii?Q?Fn0nKy3gS4FPUFuyOwDZ4f5LFXTelalf+/MjdMirygFA+Az/d5kq/ljFhvJy?=
 =?us-ascii?Q?99IFYRwyGSCbaxsDlEF8rA1b7CIw92DC0e0aJtW6/H448SURNYQimKu8ipSu?=
 =?us-ascii?Q?jRn8Q6CGjY9toUgVG4xYez+LJWXak0gsIhWoYLX3XIr1M7uVRVyd/xDMdb+M?=
 =?us-ascii?Q?sSXAAolJYMqdN6F0odDHHXOVABqa5Xm0v/EEsxRE6o/D2DUCvNBOy4UB7FIf?=
 =?us-ascii?Q?b+q71jRPLz7yAVxpewvXB0ZzXtSg1eTXf6okNYdBiTZ9wDncmG9BRvGdJTRc?=
 =?us-ascii?Q?56SvJgCkc/+6QgxgaD4+QQSVabbTYVXmn5gH/o9r5lHLX7Y7D6g44cvHqZE7?=
 =?us-ascii?Q?TAbi+BdMuRK/GKE9SiQyuQXiu68Yo11hHht+RC5w3SfyVqZPKvsjfbPcQOFz?=
 =?us-ascii?Q?LnrutIl0BFVYovsRTAPqA2Z/1o4a/+McYorZ2NXJN6kdb5yOyOAq6vGIFJDC?=
 =?us-ascii?Q?fVGQX2GqQGCa98d9DgZco8I+LSY3MKDWZuxO5hR8I+GatQVslGAOkyy2iHQy?=
 =?us-ascii?Q?igyqzIV0pJ2FlpHVXgiJIf1i56cPittaQvveQd+vwDFt7OfyaO+9z6L8zL3r?=
 =?us-ascii?Q?bojm3r+q8/0QOorQpC6m2g6qoiD39K3xjMQ0qGwgZxpupHGTdZYE6sKXHg9X?=
 =?us-ascii?Q?0An2Arkw0+7OiL2NUiKhvvSVgA3xu0vZWphL0OVNdGa9pBZqzXeDvo31BCbD?=
 =?us-ascii?Q?IJvcdgZGO5U2ac8py4RnhgjYmN6QcmQRP3Tdd+tldB9yTVQzR2gMpZi+z0vc?=
 =?us-ascii?Q?Z3IXeh1vjPlKoKWPXzk5B2DvqjQJOEMg+9wN4yWujVt28mjPCQcd1Pco6Sf8?=
 =?us-ascii?Q?+KITG1ShRBevuaqzMZDLtGCeKLSZpg+cyW3M1t+O0R9A7dEd3XqoG0VB4mLA?=
 =?us-ascii?Q?FoGl7djsdujgYWV09lOSvHbqRml0TWAiaq6Y4riulmGmufhoDy78Yq/cpryI?=
 =?us-ascii?Q?BTGKN70Sr1nHYjjQ33Fw5oQ2W7w1aFqkDvcjJGTV3/NUAJmeGvLbYOSksjwV?=
 =?us-ascii?Q?VJWVX0GRpw7Yla8I84mklz/H5D6AQ37Smt6Mf1cTf5mMz81Nr+xkEwiWhPC/?=
 =?us-ascii?Q?B549bCZhU2eVUmE+g1E17IMO3CrrCljExIVpE1J+5DyfR7thgmDjt8DmWDsW?=
 =?us-ascii?Q?RdddfaLTYIGAYz1Df8B/+MPpuAVgKzOPfqZTt2kFVpSs3VTAIMrwwqcqIgq5?=
 =?us-ascii?Q?QMGeNCx9OFWsB4zKdUruhrFoNVbSJYrJMlgRuuWv4yxRCQV/x78UgCYCrxMY?=
 =?us-ascii?Q?xs8lDjJBQjDKUwgGnobcPQ/zCsO50Cc5Fjfc1zbgacjfnN4wz3htzS6Z9o3e?=
 =?us-ascii?Q?O/wvasZq46GMKAMvX/bbBEvrNNH7d2vOkKu0kLiMNQW4szIz9ZLhdG9qYN+9?=
 =?us-ascii?Q?MDl1ALOlaTJbXSf5hqvfAam7avI+ac5r9luNjtlEiOrGbDHJlzMEYA0Tvkjl?=
 =?us-ascii?Q?JDktx96SMsWFHDwAx1MKQtBwqQpG+cEOGoaQqx4390qPHdYlDJo71u9VO2YH?=
 =?us-ascii?Q?RFxD09qdQ8RFwgSFTUTwGxD2ZI0Fc13WQ1EWy7+50235484MmvpHGUvAOny5?=
 =?us-ascii?Q?wA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D8C38705F523F47A25A1D6B2719103C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 805GN2pBZI3CZwdqoy8AmDre8IVA5znHbc6CnIDNiTs5KYN8G6jRFYebpvBsL91vyBgLc/b5ZDIf4FzUaOPs80b2OnW4eRvpKeLqua4Q1sNaOJ/O9R4gCcNkflupLPKaHMh5CIJOWrdRBAgtcbRKvDgfFXCikH3elleRDFlUnSItdnCVbaXEfQ+23wiQNHuQsPk2yl1khZUH8EIFkppbtQHpVwEg3nJSV2DrlR9TRmieNSCSgmR6y27qrp/vohkLrkhWd+t+ZzUJ62nrCWazxagrTOv4PERtzUTo2tO+89pIKmspnbsxkmE/LGY9xRLCPICywkMaW6gDXgCS1UjM2NJNYEaK27jqZ0D+VRdKI9/uDpVak3Z4Z/n38s9G9JbijA9+k1rpJKdgginMme+7BFYJXrVRf7O75UgdvmHdX7DWjxDBWgK+KseVHHo0q8O5OKbTKAEFDSmqqG4pmviVDzDfGltxfIPcpsDBij0cFa+F76uFGfafm7UsNJ6gHLnsyURoxOJXg2UGZzkdTgoDm6n5IBd+9aXZVo2QmA/C2mD/3uLUv3qliydEkJh4b8mXy3Obdw0mX8EB+tKwCsPHFDkmWLZNC8Y/AfFa1o8av+Y/y8tZh1KFIHJqH8jd+Q7KjVz3w7V1N7cl8VASp67WCU+h1Q0iwCt2EANKF/X8zdAaCuur1ABs4hAedi7wg1iFQb6mPSXJdeqc7mzgoZwGTtdo3R6t4XCqySdCrBNXaoUuT3vyu2T7oTv3I3s8Bm1RyYOgFhstcaXXhqsRvavDwMGVT7BwS8QIZcFz3D/fK6hJ93W6AH0lbmWfVW0EyEsIpWPu7PI+udPRO5cXr47pzw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3144e67f-66d0-4029-77dd-08db570eb74f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 19:41:31.9337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h4PbM00XQDXTY+5snKtoB1MbfyBQwBOm19hFkIshwu0vYiXguarTx2D24R87aOzWpePHapIUE6rH4tj8z8EB3PQ+MOkx/8n80Tav/4nmJfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5341
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_04,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170163
X-Proofpoint-GUID: E6wrb0Vk6F5ZQjVs31anSsPrlVeUg_4o
X-Proofpoint-ORIG-GUID: E6wrb0Vk6F5ZQjVs31anSsPrlVeUg_4o
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On May 16, 2023, at 6:54 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Wed, May 17, 2023 at 11:40:05AM +1000, Dave Chinner wrote:
>> On Tue, May 16, 2023 at 05:59:13PM -0700, Darrick J. Wong wrote:
>>> Since 6.3 we got rid of the _THIS_AG indirection stuff and that becomes=
:
>>>=20
>>> xfs_alloc_fix_freelist ->
>>> xfs_alloc_ag_vextent_size ->
>>> (run all the way to the end of the bnobt) ->
>>> xfs_extent_busy_flush ->
>>> <stall on the busy extent that's in @tp->busy_list>
>>>=20
>>> xfs_extent_busy_flush does this, potentially while we're holding the
>>> freed extent in @tp->t_busy_list:
>>>=20
>>> error =3D xfs_log_force(mp, XFS_LOG_SYNC);
>>> if (error)
>>> return;
>>>=20
>>> do {
>>> prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
>>> if  (busy_gen !=3D READ_ONCE(pag->pagb_gen))
>>> break;
>>> schedule();
>>> } while (1);
>>>=20
>>> finish_wait(&pag->pagb_wait, &wait);
>>>=20
>>> The log force kicks the CIL to process whatever other committed items
>>> might be lurking in the log.  *Hopefully* someone else freed an extent
>>> in the same AG, so the log force has now caused that *other* extent to
>>> get processed so it has now cleared the busy list.  Clearing something
>>> from the busy list increments the busy generation (aka pagb_gen).
>>=20
>> *nod*
>>=20
>>> Unfortunately, there aren't any other extents, so the busy_gen does not
>>> change, and the loop runs forever.
>>>=20
>>> At this point, Dave writes:
>>>=20
>>> [15:57] <dchinner> so if we enter that function with busy extents on th=
e
>>> transaction, and we are doing an extent free operation, we should retur=
n
>>> after the sync log force and not do the generation number wait
>>>=20
>>> [15:58] <dchinner> if we fail to allocate again after the sync log forc=
e
>>> and the generation number hasn't changed, then return -EAGAIN because n=
o
>>> progress has been made.
>>>=20
>>> [15:59] <dchinner> Then the transaction is rolled, the transaction busy
>>> list is cleared, and if the next allocation attempt fails becaues
>>> everything is busy, we go to sleep waiting for the generation to change
>>>=20
>>> [16:00] <dchinner> but because the transaction does not hold any busy
>>> extents, it cannot deadlock here because it does not pin any extents
>>> that are in the busy tree....
>>>=20
>>> [16:05] <dchinner> All the generation number is doing here is telling u=
s
>>> whether there was busy extent resolution between the time we last
>>> skipped a viable extent because it was busy and when the flush
>>> completes.
>>>=20
>>> [16:06] <dchinner> it doesn't mean the next allocation will succeed,
>>> just that progress has been made so trying the allocation attempt will
>>> at least get a different result to the previous scan.
>>>=20
>>> I think the callsites go from this:
>>>=20
>>> if (busy) {
>>> xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>>> trace_xfs_alloc_size_busy(args);
>>> xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
>>> goto restart;
>>> }
>>=20
>> I was thinking this code changes to:
>>=20
>> flags |=3D XFS_ALLOC_FLAG_TRY_FLUSH;
>> ....
>> <attempt allocation>
>> ....
>> if (busy) {
>> xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>> trace_xfs_alloc_size_busy(args);
>> error =3D xfs_extent_busy_flush(args->tp, args->pag,
>> busy_gen, flags);
>> if (!error) {
>> flags &=3D ~XFS_ALLOC_FLAG_TRY_FLUSH;
>> goto restart;
>> }
>> /* jump to cleanup exit point */
>> goto out_error;
>> }
>>=20
>> Note the different first parameter - we pass args->tp, not args->mp
>> so that the flush has access to the transaction context...
>=20
> <nod>
>=20
>>> to something like this:
>>>=20
>>> bool try_log_flush =3D true;
>>> ...
>>> restart:
>>> ...
>>>=20
>>> if (busy) {
>>> bool progress;
>>>=20
>>> xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>>> trace_xfs_alloc_size_busy(args);
>>>=20
>>> /*
>>>  * If the current transaction has an extent on the busy
>>>  * list, we're allocating space as part of freeing
>>>  * space, and all the free space is busy, we can't hang
>>>  * here forever.  Force the log to try to unbusy free
>>>  * space that could have been freed by other
>>>  * transactions, and retry the allocation.  If the
>>>  * allocation fails a second time because all the free
>>>  * space is busy and nobody made any progress with
>>>  * clearing busy extents, return EAGAIN so the caller
>>>  * can roll this transaction.
>>>  */
>>> if ((flags & XFS_ALLOC_FLAG_FREEING) &&
>>>     !list_empty(&tp->t_busy_list)) {
>>> int log_flushed;
>>>=20
>>> if (try_log_flush) {
>>> _xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
>>> try_log_flush =3D false;
>>> goto restart;
>>> }
>>>=20
>>> if (busy_gen =3D=3D READ_ONCE(pag->pagb_gen))
>>> return -EAGAIN;
>>>=20
>>> /* XXX should we set try_log_flush =3D true? */
>>> goto restart;
>>> }
>>>=20
>>> xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
>>> goto restart;
>>> }
>>>=20
>>> IOWs, I think Dave wants us to keep the changes in the allocator instea=
d
>>> of spreading it around.
>>=20
>> Sort of - I want the busy extent flush code to be isolated inside
>> xfs_extent_busy_flush(), not spread around the allocator. :)
>>=20
>> xfs_extent_busy_flush(
>> struct xfs_trans *tp,
>> struct xfs_perag *pag,
>> unsigned int busy_gen,
>> unsigned int flags)
>> {
>> error =3D xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>> if (error)
>> return error;
>>=20
>> /*
>>  * If we are holding busy extents, the caller may not want
>>  * to block straight away. If we are being told just to try
>>  * a flush or progress has been made since we last skipped a busy
>>  * extent, return immediately to allow the caller to try
>>  * again. If we are freeing extents, we might actually be
>>  * holding the onyly free extents in the transaction busy
>=20
>                       only
>=20
>>  * list and the log force won't resolve that situation. In
>>  * this case, return -EAGAIN in that case to tell the caller
>>  * it needs to commit the busy extents it holds before
>>  * retrying the extent free operation.
>>  */
>> if (!list_empty(&tp->t_busy_list)) {
>> if (flags & XFS_ALLOC_FLAG_TRY_FLUSH)
>> return 0;
>> if (busy_gen !=3D READ_ONCE(pag->pagb_gen))
>> return 0;
>> if (flags & XFS_ALLOC_FLAG_FREEING)
>> return -EAGAIN;
>> }
>=20
> Indeed, that's a lot cleaner.
>=20
>>=20
>> /* wait for progressing resolving busy extents */
>> do {
>> prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
>> if  (busy_gen !=3D READ_ONCE(pag->pagb_gen))
>> break;
>> schedule();
>> } while (1);
>>=20
>> finish_wait(&pag->pagb_wait, &wait);
>> return 0;
>> }
>>=20
>> It seems cleaner to me to put this all in xfs_extent_busy_flush()
>> rather than having open-coded handling of extent free constraints in
>> each potential flush location. We already have retry semantics
>> around the flush, let's just extend them slightly....
>=20
> <nod> Wengang, how does this sound?

Thanks Darrick, pls see my previous reply.
thanks,
wengang

