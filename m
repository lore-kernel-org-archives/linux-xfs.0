Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y25RVhqU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iDxMMuL/"
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D7698
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 01:17:13 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B79BBcc026278
	for <linux-xfs@vger.kernel.org>; Thu, 7 Dec 2023 09:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=weeA0S7NK7kfEdVTDk76YCekhSaV3zmcrMAMpFV0YS8=;
 b=Y25RVhqU7EhSnYvIlaGQhcTjB2jbOWqXiEXn0T7wa9v8cGwjjl/buzXZIJMQlQUTOmtu
 06RAFCGblA8bfY8TvIS2FHZZLy2qk0CYNrOaKskKyRu2YvQh9qjc2cM/JnCC2YeR2OyJ
 GRH2fy7a532QFh4xqGeCazwsk81A49iCshnLvWqAUo7NyAxsmhVdimLQa58ttqEDfdF2
 +BUVCN+UcyhOsuiFJiZq3EDV9ObOwTLdeRZ65EJakQFEIZi7mZ9OudXrFSBi1OnE86rh
 QYYWYIWVMXLhU3N7ZXO2y87BJIqzlVsnlA8CdzrCwZxP+E4uI1NWAV7NgysybNIlDmRw WQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3utdda3983-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 07 Dec 2023 09:17:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3B78mgM5036605
	for <linux-xfs@vger.kernel.org>; Thu, 7 Dec 2023 09:17:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3utanb625x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 07 Dec 2023 09:17:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3uc+yXLcOT8/LkKezL1IIEw7qb6s6PQOjHOYHZhPNxsqLHt5U8bu6Vhxph+1600TU3YiTMY5yR9WAuJ9RqiAQxHrgTqfbLAYshlpfxnK9u8gXq6Yl05U2M00vL5sho13/a0Z5jBMUNKsnE08eU+4dij/r+YshR8jarNGxolh/4KBZKHjp56AJ8wLjgWqBDi45oujjpZg72LGCnBG0AYAVczsCgPocxPYLq3ybidBHsccPpT3vJzsHUg8rkx73LIZgJv+rrkxIvaEGFik9uPfCmkJS3d0+LSRxL1jaxELVclUI3KH4X5hDMipKh5AAUmXOq3byy0wlsUqNZHIxXMMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weeA0S7NK7kfEdVTDk76YCekhSaV3zmcrMAMpFV0YS8=;
 b=T9yHcXe9f881Qoh/DcOCKPy83l2xDJyCZXrWkejFU0/AFlwD7WdtKeiGKlbcqJKZOtXWrTc9KlgVT6/Cx+D+8Rhu5Ip1LvhW+U6LP0PKZIb/N5PWCtQ0DqWvgYMIxgHIetSloW37LJWY7DOChcSoK/JsWVemmVkEzdA5zal4aNH2r4kDKfgiO09attlzkYnpFIBQGlST57kbRUCoPN9tR1ZcI4IB5p9HkIlttrKMe04Prj6MiimJEV9Ijn+7JYjtIIwHF+CRJ5Bqy3IpoNMhU3xyLMMO6KhxwIq2VetPVwmA6amGDhUYzj36Mye012mpgy+3BV8GXbHgb1QUi4CHsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weeA0S7NK7kfEdVTDk76YCekhSaV3zmcrMAMpFV0YS8=;
 b=iDxMMuL/Vjblx2RRJao/BjesHF+DTjPDalb58kHhm5SxOKwEkIJCrN33CbzrzgWPfMcB4hDOuLNdnQE0ZizgFICtLIWmrO6K9W6Sv2y/vAI+DC4o6vK8UZYYktDuFUFsjPWNYEBEkuxx1O0tWR/jY4CX0mk0vsCo+T6lRpi5EcA=
Received: from CY8PR10MB7241.namprd10.prod.outlook.com (2603:10b6:930:72::15)
 by DS7PR10MB5358.namprd10.prod.outlook.com (2603:10b6:5:3a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Thu, 7 Dec
 2023 09:17:09 +0000
Received: from CY8PR10MB7241.namprd10.prod.outlook.com
 ([fe80::a451:c44a:b11d:b96c]) by CY8PR10MB7241.namprd10.prod.outlook.com
 ([fe80::a451:c44a:b11d:b96c%3]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 09:17:09 +0000
From: Srikanth C S <srikanth.c.s@oracle.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Question: Is growing log size when filesystem is grown a feasible
 solution
Thread-Topic: Question: Is growing log size when filesystem is grown a
 feasible solution
Thread-Index: Adoo7fsDgjSQXcKXT42P8VN5uN3YTg==
Date: Thu, 7 Dec 2023 09:17:09 +0000
Message-ID: 
 <CY8PR10MB72412C0E92BBB12726E3A6C0A38BA@CY8PR10MB7241.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR10MB7241:EE_|DS7PR10MB5358:EE_
x-ms-office365-filtering-correlation-id: 1644845b-32ee-4181-1828-08dbf7054a11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 GLzCIFQ4285JrhwQCR8+nnNCukBMfCVpkZwEhlCDHNF6qGBUQThaOBVAzfVqGwKtxialhEu7KIEzzeFwxKkIn2oIJ/V/gpR858jnmdrAEKMfdP4NMr2cVRmzWhdlXeIw8emci8J+2olFS8FoIdoxmYHEmwybxVuW0V2buAoNKf+aXH9ZFL8x2zAhhLDNhYFVNwBALPE2/nEf7JWReWO+BGlI5TsyaeVqmK1QA6m747lIM9GQA5u0yEu8ZOPzI2XkPN/VBiteiG7K8IV2lSp5/tgQJFSUmxdIWvboQ/GoCKRq72b0jHlL1B3hof3+wIyrlqPf0GqD9ZgWT4fiV3Zf15MGNilKltq+Vemf2xzxhe6d0hakA5Nm2OyXeobzS2/r1T/gIgDPdam6NkKHGdH73MTlNffATAredXC3H8/FTtuCQw12FXkhXSKh88LtxoJxfqUUXD9YgtDKFOqkNTuXDdg8kmg/LSe9Z+vCX413qPlWPDmmtbgq0bYWmi/gUCZGg56wwNVCr/unJwTphlf9sxngqtIZyRAepLGXNX8A3ULz1IRZcpNj/igpclprk2Zkz20MVMAscrCgeBNzcMdptaqLuP6vKSXOccbFjf/zzoA=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7241.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(376002)(39860400002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(6916009)(316002)(66946007)(66556008)(76116006)(64756008)(66476007)(66446008)(6506007)(9686003)(26005)(41300700001)(7696005)(71200400001)(478600001)(33656002)(38100700002)(122000001)(86362001)(83380400001)(38070700009)(52536014)(2906002)(5660300002)(55016003)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Wwfw8apSJ1SNfLVCc3z4iiISCe19A/BOEorp6i3064sFUfd3oDHGuROWzK1/?=
 =?us-ascii?Q?6qz9M44xF3ME5W+QX3V94LARUwkM52dDnp73B3TColW7A+C1gOLLNKVd7I25?=
 =?us-ascii?Q?HcTT2WT11qeYTCiDwXbYqzBoWrdfx+Of71XHMSUIGiDcL8oR9aM5w/6Rq7XU?=
 =?us-ascii?Q?fD7bHseCFvCrnoyb494jwMZITKWDqrZUzv86G2E7/jBB1/jbeOUAazR2wgxx?=
 =?us-ascii?Q?MrdRjgEnZWalQQn6xR0xF8N2gYMikikSw2vn45A9aKTpcEPzF2QY6wjsEbys?=
 =?us-ascii?Q?rIZAqZROOpUL8Wrz/tOq9XrNcO8qYqbD9251f7PbyBTk5qtBMpH+UKIb97n1?=
 =?us-ascii?Q?D8fZ1OWhRWDbTX38fOM4spOKjzH2ZDVkOa/exDA5d8xOm42p3PWCnaLtNN6k?=
 =?us-ascii?Q?eYxQx3uBI8Ats7xnTX6Hre5dm0XxnCs7K6+gR3jQVnFIR9U73tdQvHxt0gbb?=
 =?us-ascii?Q?EhZqUapb+LBJjkr6cxPksqLBf9ElMU9F/tB5dZZdzc4Fekf2oJmn1755IJVr?=
 =?us-ascii?Q?NstYmygZFj5wrXml/bVUEvA5SNHanhpE81DGhCkIYSYhbeBvKYy4DWzVTVNG?=
 =?us-ascii?Q?U47E2McnSYriFONH02iJOLOwvZ448+JRIQNgRw7HfiEUf+COy8wGrKS4EF7v?=
 =?us-ascii?Q?uZELksQCok2f2ELWzepJZ4AafPCj1webfG9CwaAIzctiwo6SdRkYY5c3GVe8?=
 =?us-ascii?Q?2mART5Al7erAFBFcVzIbLZIgNqpd//4BVlUXr5qoJLxHe7y3S5Mm61cJAyRZ?=
 =?us-ascii?Q?kxvO6v83Tez0/H8GQU7U6pUaj/fH3daTRFSx9UmUD+0rzADXxW/CXb/JREX5?=
 =?us-ascii?Q?1THxGd25PSAJrSB8rGbJvvS6n0qk6TmQyOvj2vUJc43HE8wOb/aM2U3omtx+?=
 =?us-ascii?Q?g+WbO68BVU7kPRI7oltVlhHjAorYramaXceKfe81gNF5VxOVC08kv3w9zKQ2?=
 =?us-ascii?Q?+ZknD8VfvnkNHcbLC9vIuR+n5PCWx+UqhTKROTnUhFRkyFpNKnXT80J64jMr?=
 =?us-ascii?Q?qjv1hysm+IQaqOgyVQM4NUUdGONDpjkrEYqSTAkpqpeEviajmxy4Xrwhe/IH?=
 =?us-ascii?Q?3ocYupejCNDkvsPuPUe6MSDuLxG9SWz+oAk1vu9eqzx3ihibry/p/czYKcjD?=
 =?us-ascii?Q?aAGKWnuy7PLxcwoIYCP9a081elPM9b5MooMMLd+hFjJsAXdEEAgmr/G9GxxR?=
 =?us-ascii?Q?6TSpyAHVLRCfE6+0mIRTxOh+UZFZPb4MoioCjIwNNBo5On3xulgovhgJvbzz?=
 =?us-ascii?Q?P66NZjLEHxim6bORO1QxyD/Kp9GPfVoMJgKF2zEBiqnwu8V8hOwJfl8FLFRr?=
 =?us-ascii?Q?bWsCWDcsDbASlP0BYrjc9DcOe88rDXPAGQKMidJnequTsd2JME5Y1LHTl3H2?=
 =?us-ascii?Q?YOt0bnmww+1tN6aDKIbyuTKZrxgTT9YO+jmEMdtBXoz8ZTZ2FBHmV+ol2wE+?=
 =?us-ascii?Q?6zZgLB8hJCUVi7GtALuioTxZa2LpXdVefYTaId97UYVpwK8fDp+P2qJBMjiu?=
 =?us-ascii?Q?aiYEzR6QDvucNn5DpJ1AvtPxOeh6cbkgT2wJqotvxgId36Ra+OEu/J5S6uiv?=
 =?us-ascii?Q?dnCyFkxpzRzKMtJHeE+g3Byv4DAg8CV3QNJ1LLXZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bWrx+oqSRtgeV56AfHe4zeQeraB/yJQqbUa/w+yKxE36qa1RMvCjjy+jWr1D8U9w6SUvDIf2Rwk8Y0xJbwG2e2G7+aeOTEzQ9h3bLUBdBBhAbgvxDyezimwCMi0ZFJ0b/Ti2CjmsC4mDs1mel2W+6+70U0wGUtV4klPFa1SPV8nrSG79qjzFeCf56TioMO/VQCsfjrhVNgUDZaFbIf69duWCE4wgeTDDa4w20MZHDtG0VqbmQrSqotHY8y2lNJvKto55dgiuuzx/gkbi2ceie0FnJho+HedJZ47qPjotIdtmrJK5fiAFaIh/tIWmy0sCUm16tRHGAhoEWOniBCkegCVN6PnCAFNtStvIIqqRapt8OSRgHPEHZvHJXqAFojeZYVki+4IYgGlinx1Z5msLs5QNO/sl7Sp3NXG1vtg5TMLXLrM68WQHUJv1eExiasa5BZY0JiHEwXhUZXNGtl5cCjyDbvCOuqQHWsFsW47VRmMBsWgaRDlwuGS+9WOIi/vdzIbF4GabP0fSvMF30pOrmYf89eHp+C3wUiAPvB51Q9oI9NKdC0LO14bqqyUw6P6x4bDM2yca+l4oUqRXA0GWCBfQpK+DoKltzTD409IDTjspMFk+CcGdwZng5gPGGV4rnd6Rr4V7iIg3VD2tcMPZJ3ikf74k492pbCB8MNIVRb3TVftDwi/va6hH9j77YbEEwetcMKBXd8GTZL4dJtQZsX5exdQYZSuz6V/R83WWt8ryfmEHN9VzBT5gdDn1BppMT5cNWrTuajqi5hOSdJiVrg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7241.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1644845b-32ee-4181-1828-08dbf7054a11
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 09:17:09.2523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y9WbaKRPTWWoVUYtA4dLGNEqPQe28t+yWG8exxtoQOG5pMZq8f7+WytOKKAucoHFgCCinIOrDGP/Da6/Nzavsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5358
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-07_07,2023-12-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=718 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312070074
X-Proofpoint-GUID: _idLSgt6N7jxfz5o_-uStzn4TxtDxuyX
X-Proofpoint-ORIG-GUID: _idLSgt6N7jxfz5o_-uStzn4TxtDxuyX

Hi all,

We had earlier seen a few instances where there was an impact
in the read/write performance with processes stuck in
xlog_grant_head_wait(). And our investigation brought us to the
conclusion that the limitation in log space was causing this.
This was when we have a lot of read/write going through and the
log space was limited.

The problem was seen especially when the file system was small
initially and later grown to a larger size using xfs_growfs.
The log size does not grow when the FS is grown. In these cases,
we are stuck with the same log size calculated for the smaller
file system size (which was 10MB, the earlier default value).

The problem was partially addressed by the commit:
cdfa467 mkfs: increase the minimum log size to 64MB when possible

This commit make the default log size to 64MB for new filesystems,
but does not address the issue for existing filesystems with a
small log size. The only solution for such Fs is to recreate it
from scratch, which is not feasible for production systems. Hence,
there is a need to provide a solution - and we want to explore
possibility of growing the log size using xfs_growfs.

It would be great if I can get some comments from the community
if the change where xfs_growfs can grow the log is encouraged.
If it is, then any advice or comments on how to proceed with the
problem would be great too.

Thanks,
Srikanth
