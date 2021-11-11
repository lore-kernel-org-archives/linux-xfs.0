Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF2CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBD861247
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 00:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhKKAJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Nov 2021 19:09:47 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8016 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234143AbhKKAJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Nov 2021 19:09:46 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AANgDet032056;
        Thu, 11 Nov 2021 00:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=JXhY5igKjmHpugGMjS389cshoQD8hKDRjyucUAba32k=;
 b=K/2Qz7EROv4IdjD7AWi+5r0WsQtWQkF4VuYy+Umn74LJWCNnyMSR5w4lEhGdyueSeLFo
 Oycm522eC0Sc8sZ4UG++S66Z5J6MeYEFiVnReH6zg+9DwdaqRQ+CCp02GVp94RVRY2Ox
 v43MZ+UDRZ70GNkBXGRFpSiw8lVvtps7fpn4VvchIgPFu2MLyoUhFENRNFufQ/HqrMvz
 eVni9kAKJJxk7h8F+S5WvFViZiX3NVf30G4hR8cxff48yOvEIOXcFHieMvfl1kGGsmS1
 DkMm9u67atZ6FxLt3LTh/Jbbuh0Spu/ge8WQ6w6gs5r3r5Zf7glh+RHZK2hserdREwqL tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c89bqek3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 00:06:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AB06h8p029310;
        Thu, 11 Nov 2021 00:06:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 3c63fvfemg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 00:06:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoukJpOMa9C8LyRqk3EmysVRXnXEk9N8LtRCqJFsU0Nrih+0QnTTQseFettKPO2P2AU0/rIc3Icg4jdS5rEeVlcH1L5jgffPGygPm0tveXyojcmRqhoIfkKxdGcW/IGHCPdS3+/o33flKyZA3Hj4pL81P4ABcAQliDcx5g0sovo9RF1acIQwIpYkYHW9j1Fk4VSRDNILFwwtGurcNXNUgQhodshoer5+oV7kn+K4/RLXb9QPjQ1VEb2641lHWDqUQJLgyxvBCd4pzeXt3YS5cDdLfbxzHhaDG83QfSuKi81mTCcI1uCvMV/nAKGUFciYL5Fk6txegkla1rb26ssvZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXhY5igKjmHpugGMjS389cshoQD8hKDRjyucUAba32k=;
 b=MLL9AzaqXKlNuTDDWkVf86y3S7cm9WopPk0GIknCYMtVk/NRihWu3JxOtbossoZucub3lGShNfKHjtRwC7U9JNu2NpdIRJ1uSy11licQ8mITBJjDKjzLb+s09L4SYMdOtzkw9ttjp64NLFPJ3oVJ0Pd8EhfTYEhNGjDRdWHjKva3Gr17Fcxu5IYcQZAdkuIap8Y8JeCOwdTeCPMqPD8L+sVFRqB/dqwA5slnFqGx34DotXbn+mfaOan5lnlqHPZ96pMJFbs8Hs2I15rKLIcGhIphrUO8sVALlt9VLjXeFagv+U/ieLTNX/DAubeadvRtfHjRTA7Fzlc5rYQkQ4fzNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXhY5igKjmHpugGMjS389cshoQD8hKDRjyucUAba32k=;
 b=dNwTpyPhKyE8DOsj9uGP4TkZGVJBMPm+rwEswt6M/xtr2b+E239zZXu+QPfMlplXO1+VbFSJLV4Auik3ifLYnA6OzkVk+zWNXzvzH8cWZTB15zXxlXrvPgH6XUMilmJmrs+Vrv76IL6F72kzKvKggAbAUziaS44UL0AOsmgtCOc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR1001MB2410.namprd10.prod.outlook.com (2603:10b6:4:2e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.15; Thu, 11 Nov 2021 00:06:52 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::f037:c417:3f72:fc46%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 00:06:50 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v3 0/1] xfstests: add log attribute replay test
Date:   Thu, 11 Nov 2021 00:06:43 +0000
Message-Id: <20211111000644.74562-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR07CA0030.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::40) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by MN2PR07CA0030.namprd07.prod.outlook.com (2603:10b6:208:1a0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 11 Nov 2021 00:06:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78876d62-943e-4e43-2499-08d9a4a7290c
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2410:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB241066C23BBA4A4FFADDA42289949@DM5PR1001MB2410.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /j//kKWk6vBrnbakYZRo0LE7LPpVGGTRPB8Bkif5sNsWN95UYSM0/7LhJWNLaNstZhwPuBI9fyKDt/lTX2f7sznJkph5qSb9jxCa3ctpvwRJkO0GgRNmtMHGa5QnAtjUv5gYN0mn8N7Z9j51HHCdHC/NXGYU5yStgOI4eMGg8Wl6UGeeECO675u4k264wy1ZdE7fy5G41RJzyPeXbFpGu5p0qy+6oSPZs9vyLKZgoSaJiDatxF44sBdFfxETiuHVwCa28kIW0hj5eWKdEBTrSw5h84saT/Ec6cegBV12bnbpdmQfS9ucOYfi6yYlCBzk6A9vWt0Cz2KDELjXFS5l4vEq27DEKz9tjU2qHJ5KPLjht684Ws0QIekIKsSqng2NpTsJscawkb3eWxKPDF1sI0iWxW3NWTECSoCPRHOfXR9coQTVcjVQ+sBMGFnRP+ZDhH1naYTxkpy1nCC7krIY+za63qSLvaWLHVXqG2G28/ayoaZmitOZqG5zKxvOk8oh+x1g62d76wdCZD25pPBnmIMEhlRMXIQvhMkRz7evJGVSgrZClG+kn9EpE/F9fgvBd07J4wYTDDtjLwgJq5jaKzptyvvCQyH2xdNsTpXxmXHYWfavrYlqgXOdBkDtKakRnWCy9k674H3tSrEbUmBd549VWlDAnC2B3Qc7hgjuG6aP5I3TNHyNddSIzWsoVQx1mKB/uVsY8QTI1d/HPoGljIoVaEbIH5BbCKsUw9ykXLYbYVwFi1Av2nEBzQ65V35Cmd6fc71yndDfoveQ3oHVY4jRRuJg3ALPoz0Xq5z+dut+3xHXyh8KGzM9ZG+xvwtvDZ2pjwNzu9xSL7y7LHrimw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(8936002)(966005)(2616005)(36756003)(508600001)(38100700002)(1076003)(5660300002)(38350700002)(956004)(6506007)(44832011)(8676002)(52116002)(316002)(6486002)(66476007)(66946007)(66556008)(86362001)(450100002)(2906002)(186003)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWR0UCtzL1lCRUZEOGtrTEZxM1BjcUl0OTgzMUgrQWRSWGQySnlXbFV4ampS?=
 =?utf-8?B?U1dMbGxkMzVIaUREcGNram9HQ2tnVUlpd3Fob053MWRmczQxOTVZK1FDaC9i?=
 =?utf-8?B?WWtKSUpBZmh2eFNqN0JlSGVTTlRQNlg1bGVubUVzZURueVZUTnJJU1dGbnpF?=
 =?utf-8?B?UDd5aWdMdmFhSDVwZk8xY2dwaHpXOElSaDVlcCtCK3ZxUStsQW14MGxMZnpT?=
 =?utf-8?B?UEVVNnh6Ymp6TSt3RUZ6QSszeGNWMTZ2dEJJbm5GRGlnbVNCa2VJTDRnOGwv?=
 =?utf-8?B?SnZxQUVzU29hTy9WaXppdndTLzRmWTlCa0xlVHRKS1N0OVNXU25MbFM5SkJs?=
 =?utf-8?B?azRnb041NUxja01sYUFYeUx3aHVZM3RCaXk4N0UwREx1OXlCTHRzRlRiamR2?=
 =?utf-8?B?N05ha29FNlhHMTZsV1UyeXdHV2QzZEFCWlB0aUo4a0djOVZRaTdPSk5UQzFl?=
 =?utf-8?B?ckp3aEhpSnJNVnFCSVJNeDVQclo0YlpSbC83dTBTM1FwU3hFWHU3NlRvcHY0?=
 =?utf-8?B?T0Y2OFZ4dHZ2MStiNU4wTWZOZVcwM1pzR09tb3R3MkhuaG1YMzJjb2wrMnJv?=
 =?utf-8?B?OStNQVE3Yk85UmhlT2RIWEtNVE56cnhGV3Zqc1IxWW9Ya20rNTVpRG9DbkZF?=
 =?utf-8?B?ckRMWmEvaVE3Y2JhTnBYVHVVT01kVEFEUWM2ckREMGh6cktWaGN0WjFhSWE0?=
 =?utf-8?B?RWFxVEsvd1loTllJb1dIOG9XcHNnMG1hQ1R3MGpseTVQdURvN3RDZnN3WmdZ?=
 =?utf-8?B?UDhPeDhaZWpZVlppc050WWwzdTlENE9GVktJc3dKK2RiSHpiR1owS0UrdW13?=
 =?utf-8?B?KzNhQ3lDSE1OUk9vTTJsUitOUEhrcWc3bmpIZ285TWFlc1VCbnp5ZWlTYkQx?=
 =?utf-8?B?WGE1VnVDTHY2ZnBEWjh2RmhpSGs1T3N6c09MT0l0cVl5WEx5Z2NzTi9RbE1k?=
 =?utf-8?B?TlNQK1puNkk5RStLcXVzdlEwVlVHYzlPeGQ0bG1pRnRpQWRoTmNWUkNLdHFz?=
 =?utf-8?B?VG9oS2R2SGdRNkVEODh4enprdU5GdE9SNU5JTzduOExzMHlZK0gyVmlCL2Qw?=
 =?utf-8?B?dkxxR0ZMeDlvY29rTkRTSGhWL3orTmd5N3BVSGQvUzdVNW5jajBFQUdJMjVr?=
 =?utf-8?B?RkJJeFVERXIzazJNQUQ0TUFvNi9DUnJJc1ZYZUswVk5YaFJSSkN5S3Awc01W?=
 =?utf-8?B?aWlZVkZwQ0p2TDZBVUlLRllKeTUxeHNCZDErVDdaVDloSFRaT2dWeW1YdzRJ?=
 =?utf-8?B?cy9MY1FBbE9IMkdvc3JDb0owbHRtaGVoa3V5YTFVb2svQ1JoSjRjTmhXTEJS?=
 =?utf-8?B?M3hjaS9sa0NQRnlCRVhUcWhRLzEwdHhoQ3pyRUpoN3ZaS3RkbG1tbVFTNW9O?=
 =?utf-8?B?Njk4YjdrMmFYd1AwTEJpZXpZNlRid0ZMQXNYelZFZ0RGOVFXaVZrc3dDUUQr?=
 =?utf-8?B?OXBuZFlabk1BSGtOc3lvb09Gcld2eDFXR3pZclMzZVoxTWtaWXlQVkVOcisr?=
 =?utf-8?B?T1g5bURTOGNuZ096aFRrZVQ4eS9JVjNSS2MzT2JPeWUrR2FuazhxRHJ3WU1G?=
 =?utf-8?B?R1k1Mk1kYXFRWW9vaWdSZTk3SjFhclVJQjZnNUh4NmhmWXF0dmxyMFZUZC9o?=
 =?utf-8?B?NEY1ekJrWHYxc21oZ1BrV1BGUVlXaEZsSU94VXlHemRCaFFXR3UraWgwOXVQ?=
 =?utf-8?B?VVhNSW9ERm90eFBkZDJxT3E1RDlEMWR1RFVrWUx2cC9yV1Z5MmwxakpjcWRI?=
 =?utf-8?B?R0tVSlhWWU1YMy9rZlhaUFB2WFovS2VzVUUxSExnZHBBSTkzMVdoaDE4eXBE?=
 =?utf-8?B?OXh5alFYUk5FaUNjejBoVGhmZ2RydTFVbXh5N3hrYVpORnZ5M25ZOU96aVZy?=
 =?utf-8?B?L3RTYjV4ajNrSUhhWmJ3bzMrUmcxVCtCaGF6WUJuY1JIYlljTVE3UnlkVGJD?=
 =?utf-8?B?cnRGR1psTmdCSEFESHdCRnJTNTFYbkZYNUNKQm0yRVZ1b0VYcWcybWYrREg2?=
 =?utf-8?B?VEdqSzBNWi9HRGVId0gzb3pQdmtIc2NNdFNaekZyc3IxKy9DRzJKZks1M2Ni?=
 =?utf-8?B?QUs5b3hoREVhQkR3UU50VU8vSmxJWTg1Tm1jUVJMZkpiTUVJakNmaFBKMW04?=
 =?utf-8?B?cnBHMlUwYi9qY0hHRExlRWQ2NzJvN3RxdzhkSGMvL1FqSVZLSFhRR2ZUOTBM?=
 =?utf-8?B?bkdwZytSUE5OdEVPU2g1V1ZSOVJVSE1VNjU3ZW9mdXFmMFNKdTkzUEp0ak1I?=
 =?utf-8?B?K2lCcDZ0dWEzNythYUhKM0tqSDdRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78876d62-943e-4e43-2499-08d9a4a7290c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 00:06:50.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MCma83F0lqWsznLGsDsVwjTHjQ0LjMBxeUMTb1ot/u4GS84XPYISBnPolSI0LMkWlKxTGXgtr8UFTwYE0lXrMtMD5Sm9zWYN1uuQPL8fnoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2410
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=890 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100116
X-Proofpoint-GUID: P0iUUCZ94WTvEB8wl8HoOeEQnLQi2ccq
X-Proofpoint-ORIG-GUID: P0iUUCZ94WTvEB8wl8HoOeEQnLQi2ccq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch aims to provide better test coverage for Allison’s delayed
attribute set. These tests aim to cover cases where attributes are added,
removed, and overwritten in each format (shortform, leaf, node). Error
inject is used to replay these operations from the log.

Since v2, the following tests have been added:
- empty, add/remove inline attr         (64 bytes)
- empty, add/remove internal attr	     (1kB)
- empty, add/remove remote attr	     (64kB)
- inline, add/remove inline attr           (64 bytes)
- inline, add/remove internal attr	     (1kB)
- inline, add/remove remote attr	     (64kB)
- extent, add/remove internal attr	     (1kB)
- extent, add multiple internal attr      (inject error on split operation)
- extent, add multiple internal attr      (inject error on transition to node)
- extent, add/remove remote attr	     (64kB)
- btree, add/remove multiple internal (1kB)
- btree, add/remove remote attr         (64kB)
- overwrite shortform attr
- overwrite leaf attr
- overwrite node attr 

Running these tests require the new error tags leaf_split and leaf_to_node,
which can also be found on Allison’s github trees.
kernel:
https://github.com/allisonhenderson/xfs_work/tree/new_err_tags 
xfsprogs:
https://github.com/allisonhenderson/xfs_work/tree/new_err_tags_xfsprogs 

Suggestions and feedback are appreciated!

Catherine

Allison Henderson (1):
  xfstests: Add Log Attribute Replay test

 tests/xfs/542     | 175 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/542.out | 150 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 325 insertions(+)
 create mode 100755 tests/xfs/542
 create mode 100755 tests/xfs/542.out

-- 
2.25.1

