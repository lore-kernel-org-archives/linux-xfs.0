Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85CBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Nov 2022 12:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKYMJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Nov 2022 07:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiKYMJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Nov 2022 07:09:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B413042182
        for <linux-xfs@vger.kernel.org>; Fri, 25 Nov 2022 04:09:52 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APC0fvH012304;
        Fri, 25 Nov 2022 12:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CS+/4NGcbcz/ALVsMKZGd8vDfFWnYQ6dpHE+lAqo5Sk=;
 b=CxgeZYONRnNI45ZZSHY8mY4vfb02xcGoEDdFqCUOrZ8pyj4i2az8FoQi2FVGIu6sA07c
 ZYhMclvIP1UC99kK7x0c430B/UKHeeRzt9Aqkd8oQK8ECwMN9x6QFBRGJ1SsKTBcjwEN
 hcehBMhCNqV/2qhpwxOLW95jYu1tdSbjY0HSL7uR/wLfa7km6rxh+EXTeYasaTPiammu
 MpiuXLFEVv6q4SvSn/YAk/c/hc/Orb+OCoNs6fhdwNhAWFvdGntY9TOBYAXnxJLiUIOH
 KX4Wcmiq+Hfcx/DvRC3ASJa1z5cHovxcTJgWfn/0WLAxq/1//GxCMJw3xq3Yxppj7qs9 Xg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1nd8cnm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:09:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APA0LVH027622;
        Fri, 25 Nov 2022 12:09:46 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m233xt6je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:09:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNN3xM/dGm9eT2h5sVb4CCUDcuTtrEp5eeyu6d140hOLAj4pcnhRHb11s7dy4AMErxKr+031o+SWYOYyRojv+9nhA5EIuLatq9i5/rDr3cip3s+3JrPBNqJoGY2tPVV3n6m1nb60dQh6UfMn2WwHRK3/mqW6b1aCyIgCQCUzmiFxgPaaXF5I2ardsGHKJO2Aw7oCc5P/XbJD0DZoDr0CMHxDGoMN+25Z5kpRxROTXubRDqmSVaECG3KrMMKFLmyXnKwarpUsE6t3BAPk2m7TNOJ0z4uU0/mh8VHH36t9KL5tfzii3DOENKze7YaA18ZGrzXnewgRk7GS3vTCSNeByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CS+/4NGcbcz/ALVsMKZGd8vDfFWnYQ6dpHE+lAqo5Sk=;
 b=agLVDJiixGXrtHiyq9ZLRKfEqRtrn2QM/D3XSjmTbx3eJc5SdS+ul97wxwhMvv8tlTDXfMxgmLw2bF2gs0qSTdA8wDBvK+K4uB7JGDr0NhtWOt47nSnqVYNnZ8sqHN2HH9cm0Xdjr+EE9EAh1CBfrpH8DS5s6BV7DFIvHKNwMZPC55ts55/GghUyQn5+gTGJ7YbHO8knSGx8bNXscGFfs24TK/p3lkAzNJg9NAs5Gyk4xWHnGIlKYv6ijaY5O9/rDIkiWBg4ovVL0HDn50g9LXabywDbhr5ZFLOf4azZVyAsWmeIlZ+giFuEOaoFhO9bQiXXDOxSmHL6uLKQdvTNSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CS+/4NGcbcz/ALVsMKZGd8vDfFWnYQ6dpHE+lAqo5Sk=;
 b=hGexuxxlM60NIb/jGxZcb/juteIXLGdZVyAfKbSAPQ3X2TstYrp6d2/kfOhWr15XgHwcCC6w7rGANeC6rE9ll/cHHiTso4OlN6HBoD0lSaO1KEUlPHiABnJSyoz1FvXBFyITTBijpqqbVg/RD4qoB8GMH1yozXDsUVlfO2IcJX8=
Received: from MWHPR10MB1486.namprd10.prod.outlook.com (2603:10b6:300:24::13)
 by PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 12:09:39 +0000
Received: from MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194]) by MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::fe5c:7287:5e2d:4194%10]) with mapi id 15.20.5857.020; Fri, 25 Nov
 2022 12:09:39 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     Carlos Maiolino <cem@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Darrick Wong <darrick.wong@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: RE: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Thread-Topic: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
 replay log before running xfs_repair
Thread-Index: AQHY/wVBvROg5/0DFkCHIEtc3i5PT65ML1oAgAAzUxuAAAv1gIADHnuQ
Date:   Fri, 25 Nov 2022 12:09:39 +0000
Message-ID: <MWHPR10MB148619277A997E1D8A715257A30E9@MWHPR10MB1486.namprd10.prod.outlook.com>
References: <NdSU2Rq0FpWJ3II4JAnJNk-0HW5bns_UxhQ03sSOaek-nu9QPA-ZMx0HDXFtVx8ahgKhWe0Wcfh13NH0ZSwJjg==@protonmail.internalid>
 <20221123063050.208-1-srikanth.c.s@oracle.com>
 <20221123083636.el5fivqey5qmx6ie@andromeda>
 <c-vuqhpmmrL6JSN0ZRnqX7c1BUcXw5gJ9L2UZ2lG3H8hCJRNIn_uan2rVHLDUPwgY24Nv3WZpiBt2nflhVadtA==@protonmail.internalid>
 <CY4PR10MB1479D19A047EAB8558445EC7A30C9@CY4PR10MB1479.namprd10.prod.outlook.com>
 <20221123122305.oht2bspxqb6ndnlm@andromeda>
In-Reply-To: <20221123122305.oht2bspxqb6ndnlm@andromeda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR10MB1486:EE_|PH0PR10MB4472:EE_
x-ms-office365-filtering-correlation-id: 8ebd718b-face-4d21-50c1-08dacedded7a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8bOLDfRomwpNzXIEhpNdrAvlAITWxbyoA3te9soSkQzqCRwS6oRH6L9YCoYzuqskNXLAG8KWlHUBEcjMIUFvNACW8H3COLC3H2om7TNG2kWgnemFICbbaAltQ2gjgLOtSSjR3eW8PAjaWzRsSl3Ko3Y14LkKPRUnq/nzc14odk9cRFbXVXjTRcEFWXmxYn6pytCWkynEL7GmxiDY1KdEJYFgeKIRYEQvuKC1WVYMK27XD+DMA5AMvt2H6BWpMsLEngaGhbD9vgQtlLVke1mpGaA5FkrMmKtR9NM4LLiVapbwjtA9xg7pED7oZ1fwyfuXyBvUGXidcP+JkYkHX2HxEehATHZGt4aQ2v1us1XXxlDJCfMid35eK5mlvU/p/tMW+dBkHvfufrb9Iijp3jeZM5uahD+re1phoIFcm3qOXxfnQmTtg1PiLbUGnjwIsh3KWqWSGwbUSDFlWOuBoNDPK04X/ogHbSdAZqikM7sglMHO7bHqXGWoYpqHBfTrOFFkxEJfLqkFo7vzTFJH86s24gvj+pNHOvzdg3vPy3PryYXB3pAucvEMGiQHmjO75lBIAvAteWp4F0+SEvnGdzxKjukaChKNkQG8z9Xiv7xx+yGTRfi4pmvAyNPMrZsHY1pBaPBgOQcm0teMJq4ANcM7kj/oEvVsDEwVZtZNdsopZse8wBxq9ZgZxhj5C/FMdeEF+RFvNiLb/tmuDyhwf6gIfDGRtXPcVN2z7WJhg9u3e0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1486.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199015)(83380400001)(33656002)(86362001)(53546011)(7696005)(54906003)(6506007)(71200400001)(966005)(55016003)(38070700005)(9686003)(38100700002)(186003)(122000001)(52536014)(8936002)(26005)(478600001)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(2906002)(76116006)(6916009)(41300700001)(5660300002)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EvN8tXSauGVOpHRXOu0BwpK2nRaauEV+qOUFCqfYyVOQpu9mtMfFAa2ZWa4L?=
 =?us-ascii?Q?7Wb2jN+UJz70XTCxhXyyDbpuR/mHUgwi9/nhiteH8hqg/NsZo08sSID9nYY7?=
 =?us-ascii?Q?3ZEekTL6sVT+AqlkerQoS4BgQkjCERtw4EuUPgWicgDWw2rPMwYveCCvOF3a?=
 =?us-ascii?Q?nFNWSiLzcQ2mwyF8+Bv6jIGNtDAt5cnvlt1JojeTfiSHQsQqRnTDidWPpP/9?=
 =?us-ascii?Q?NetF/NDuvoMoDdbPjXgY9WYHR4Ay2TfyLZls9NBwy2+kqZU3bnqHGGdgM+Ka?=
 =?us-ascii?Q?Ohi44oKYsFjloBAxUbrCPNTH9rgdVuWcMcKiLDRFW65+YbeEKL+AVorBxATh?=
 =?us-ascii?Q?nAZvIOKrfDlEE2IIkCIE88mVXdQXKEVHf4ommkBgukVxUhv8dpsLpFhQJ5ep?=
 =?us-ascii?Q?JDmrsgXjpMZbDoBFdCxjU2oE1J+eXVvltUaRz15TePDu/abOs6dNtwE0+Zs/?=
 =?us-ascii?Q?sVsdABsYrgNFXc7sATD/BInHOOvQnwG5jCShNfJNj77sZAL4Xd+I3dNWSfr1?=
 =?us-ascii?Q?yAHdj0KCZ7YefXriqNhyXmZ7+hSNCMGi78M41CQmF+JzuRjNgg+x8d2GvmSz?=
 =?us-ascii?Q?PyZVc5cm80zZ4rqgwKiI58IgITNz+J+2og6cxakpg6jtflLOtj8+xCN0KvHz?=
 =?us-ascii?Q?AcBLza/oofVJeOvtf9IhdEOaBRas3IV0ZTisrtCtV6W7ho6SulbXKGmD1lVJ?=
 =?us-ascii?Q?0iEXWqPzHHUNArA9/5pjZxfjL2AwS5rDyuy2IpLLbdhHKRrPv0RTCChACX7P?=
 =?us-ascii?Q?rDS0geQoXUH/MiiPcdLY80zprmFJqzj3PuLgrE2TOvRScpTW7TTfEWo4Xilo?=
 =?us-ascii?Q?U+3sPvlEAGPKs+cYCKfAeiKPaui/XvwzZ0PbdjmzpdFeitFgUajGLKziTB72?=
 =?us-ascii?Q?egpIyveZazE0va3qTSvbBkBtrrXtmn29nqZMBU+gEfEhfcKiMX+D9XnyGKdQ?=
 =?us-ascii?Q?FngHIMSfS7pFqSYm/Ac5VLfBY+/NJa79Sxy5Lyqk6D/NrcUjOw8VF2GKoQLt?=
 =?us-ascii?Q?t4QfXa7/xqRau8xd5ONr0zvLlidN8/E3dj+eO3BxkQLaCQrtbWcjgwMoFf39?=
 =?us-ascii?Q?QDx7NGol9xbmYI8JY2kQm6h2fK5qUn40ESAJYcGL/C7I6FdMVvWCS65g9/f+?=
 =?us-ascii?Q?hhenTFHzoNxRKIpM9Gpeo7qJaQRXZRsRrpjCbvzoL4l5vwiWU+tdLZdh6w9m?=
 =?us-ascii?Q?wZy1iFyJK98V4FGp2FqcxSUJe9gPju0h0/6dTrNLwenFDHZb6ZirEyqkNcFa?=
 =?us-ascii?Q?VZxrOqkOI0DmIHha+DxsbN7cB6196HHIYuxXPb7qbr5hxe6UFX8AQT6Vt6ik?=
 =?us-ascii?Q?pCDA9H+483tfT+5Mv2JwxS8epaqXCAhn3E10uO6mQMI5Ao1A3MSDfg9GNmma?=
 =?us-ascii?Q?52LO+KDG5FawDa+p5qIexdJUOuPxtNgQ0gCoxgYdxrXtXfnlIWo3q/0RpUhx?=
 =?us-ascii?Q?tUXIoBZDB1UAUFyYLzo9o4rQMX4j/MW7Id44dSdlF7Ko+fC0+xFV3SgVsNtt?=
 =?us-ascii?Q?0Wpklt0FS1YdzJx/Ob4HxMk5AoKMa3ZyhqwtIhvO5Wlvy8Bt0c0kSCPpfVdL?=
 =?us-ascii?Q?exxGBw7ovXvmWULKiI8893M7fys8GPyROI29N5px?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3Bqd834ksl8G+Eu9i8U8XxCA+mufhUZMuvI+VYLzwxtVwxifagCDOXC9C2kcA4EcT/rn4EpAie+A4fuBN3FJDgcuETPDvGul6yn2Y7WnU5QVLm4lkPuHJZs9oVY5z12gaaAyPdIma2yfsSxUnjZkzZy/PWTFSH7zRRcYdJP9yDAKVJOFXQrPD1h5+sb5j/xY7LbbLsUlGfCSgAD0c7RGSOnJ9G2SL7nUBsUKLPIuYIIxCoUjFoIT9vzwzVgYq6SoLv9YzPokcZNWKFKxPoACZ5IWZntsT1dSIBSe6YM98fGnusEpLguaUKAgcykC+4IgUvacEZRqFBsxiP6Wmf112KSObICW8QJ1HKWUOf8kAIqN/KAT0fP68+C+8OODIaPWPgaogkrfAJxWPLcgLAjDkk5HADpCAJtqIDudA/vYeaa6/a9+xM/+/SWSEflM4K4i5HyWlcVRHndeTkD0kmkCeAn9yUXTaM84dv0sajNJc8p9Tp8Lt++rmGLsXtVR7YFop6zUeLT0oPMHtk+zxh0ZTSpCHpmEBO9BTaClyZbzRE1ph+N97SBmLyGISi7gNhpESeuDyPwroKcTcqEvMYAgh+8ylr80v+F6gOASQOivjh3ja8corIF7iOZ4MqZvQdn8GaKYf+8ejsds+2U2FAsotB9hLGkRUh1zYmOaoVWeEmTMwO32apFE3dwjyj4aKj2Vm7izhE/UBvYrsT3CbA1Ojzjhd75cRiqYCHpCjRx+wVqBASXBApCq/G/uSHAOqhkd+ZuFp1gxk21g0roK+tI45h0OEg91Zvgq9HqVm7IYdOPS9eSExrv5JHEpmPPBewbmG2p0IqXrf0K5rtWE5VsEpg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1486.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebd718b-face-4d21-50c1-08dacedded7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 12:09:39.3427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ez5QSIApjw0L2FPAyv/zfsY25JfaFPlNcZwPhZb/wlZzsYEr4gwSeDFjMmiIeRuf7MD/6kNc0vsE6Y/77ROQ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250096
X-Proofpoint-GUID: fmEw9HE2R4LBzDM4I_oed8ppcr8thFF9
X-Proofpoint-ORIG-GUID: fmEw9HE2R4LBzDM4I_oed8ppcr8thFF9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> -----Original Message-----
> From: Carlos Maiolino <cem@kernel.org>
> Sent: 23 November 2022 05:53 PM
> To: Srikanth C S <srikanth.c.s@oracle.com>
> Cc: linux-xfs@vger.kernel.org; Darrick Wong <darrick.wong@oracle.com>;
> Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>;
> Junxiao Bi <junxiao.bi@oracle.com>; david@fromorbit.com
> Subject: Re: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs to
> replay log before running xfs_repair
>=20
> On Wed, Nov 23, 2022 at 11:40:53AM +0000, Srikanth C S wrote:
> >    Hi
> >
> >    I resent the same patch as I did not see any review comments.
>=20
> Unless I'm looking at the wrong patch, there were comments on your
> previous
> submission:
>=20
> https://urldefense.com/v3/__https://lore.kernel.org/linux-
> xfs/Y2ie54fcHDx5bcG4@B-P7TQMD6M-
> 0146.local/T/*t__;Iw!!ACWV5N9M2RV99hQ!J2Z-
> 2NThyyDm__z9ivhioF9QoHsaHh4Tk733jtNbVMPGeA2vbmbw3h4ZGxOywQF
> v_lA1Zs_jsUgr$
>=20
> Am I missing something?
All the previous comments addressing this patch were about having journal r=
eplay=20
code in the userspace. But Darricks comments indicate that this requires ma=
king the=20
log endian safe because of kernel's inability to recover a log from a platf=
orm with=20
a different endianness.

So I am still wondering on how to proceed with this patch. Any comments wou=
ld=20
be helpful.
>=20
> Also, if you are sending the same patch, you can 'flag' it as a resend, s=
o, it's
> easier to identify you are simply resending the same patch. You can do it=
 by
> appending/prepending 'RESEND', to the patch tag:
>=20
> [RESEND PATCH] <subject>
Thanks for the info. Didn't know this.
>=20
> Cheers.
>=20
> >
> >    -Srikanth
> >
> >
> __________________________________________________________
> ________
> >
> >    From: Carlos Maiolino <cem@kernel.org>
> >    Sent: Wednesday, November 23, 2022 2:06 PM
> >    To: Srikanth C S <srikanth.c.s@oracle.com>
> >    Cc: linux-xfs@vger.kernel.org <linux-xfs@vger.kernel.org>; Darrick W=
ong
> >    <darrick.wong@oracle.com>; Rajesh Sivaramasubramaniom
> >    <rajesh.sivaramasubramaniom@oracle.com>; Junxiao Bi
> >    <junxiao.bi@oracle.com>; david@fromorbit.com
> <david@fromorbit.com>
> >    Subject: [External] : Re: [PATCH v3] fsck.xfs: mount/umount xfs fs t=
o
> >    replay log before running xfs_repair
> >
> >    Hi.
> >    Did you plan to resend V3 again, or is this supposed to be V4?
> >    On Wed, Nov 23, 2022 at 12:00:50PM +0530, Srikanth C S wrote:
> >    > After a recent data center crash, we had to recover root filesyste=
ms
> >    > on several thousands of VMs via a boot time fsck. Since these
> >    > machines are remotely manageable, support can inject the kernel
> >    > command line with 'fsck.mode=3Dforce fsck.repair=3Dyes' to kick of=
f
> >    > xfs_repair if the machine won't come up or if they suspect there
> >    > might be deeper issues with latent errors in the fs metadata, whic=
h
> >    > is what they did to try to get everyone running ASAP while
> >    > anticipating any future problems. But, fsck.xfs does not address t=
he
> >    > journal replay in case of a crash.
> >    >
> >    > fsck.xfs does xfs_repair -e if fsck.mode=3Dforce is set. It is
> >    > possible that when the machine crashes, the fs is in inconsistent
> >    > state with the journal log not yet replayed. This can drop the
> >    machine
> >    > into the rescue shell because xfs_fsck.sh does not know how to cle=
an
> >    the
> >    > log. Since the administrator told us to force repairs, address the
> >    > deficiency by cleaning the log and rerunning xfs_repair.
> >    >
> >    > Run xfs_repair -e when fsck.mode=3Dforce and repair=3Dauto or yes.
> >    > Replay the logs only if fsck.mode=3Dforce and fsck.repair=3Dyes. F=
or
> >    > other option -fa and -f drop to the rescue shell if repair detects
> >    > any corruptions.
> >    >
> >    > Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
> >    > ---
> >    >  fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
> >    >  1 file changed, 29 insertions(+), 2 deletions(-)
> >    >
> >    > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> >    > index 6af0f22..62a1e0b 100755
> >    > --- a/fsck/xfs_fsck.sh
> >    > +++ b/fsck/xfs_fsck.sh
> >    > @@ -31,10 +31,12 @@ repair2fsck_code() {
> >    >
> >    >  AUTO=3Dfalse
> >    >  FORCE=3Dfalse
> >    > +REPAIR=3Dfalse
> >    >  while getopts ":aApyf" c
> >    >  do
> >    >         case $c in
> >    > -       a|A|p|y)        AUTO=3Dtrue;;
> >    > +       a|A|p)          AUTO=3Dtrue;;
> >    > +       y)              REPAIR=3Dtrue;;
> >    >         f)              FORCE=3Dtrue;;
> >    >         esac
> >    >  done
> >    > @@ -64,7 +66,32 @@ fi
> >    >
> >    >  if $FORCE; then
> >    >         xfs_repair -e $DEV
> >    > -       repair2fsck_code $?
> >    > +       error=3D$?
> >    > +       if [ $error -eq 2 ] && [ $REPAIR =3D true ]; then
> >    > +               echo "Replaying log for $DEV"
> >    > +               mkdir -p /tmp/repair_mnt || exit 1
> >    > +               for x in $(cat /proc/cmdline); do
> >    > +                       case $x in
> >    > +                               root=3D*)
> >    > +                                       ROOT=3D"${x#root=3D}"
> >    > +                               ;;
> >    > +                               rootflags=3D*)
> >    > +                                       ROOTFLAGS=3D"-o
> >    ${x#rootflags=3D}"
> >    > +                               ;;
> >    > +                       esac
> >    > +               done
> >    > +               test -b "$ROOT" || ROOT=3D$(blkid -t "$ROOT" -o de=
vice)
> >    > +               if [ $(basename $DEV) =3D $(basename $ROOT) ]; the=
n
> >    > +                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || e=
xit
> >    1
> >    > +               else
> >    > +                       mount $DEV /tmp/repair_mnt || exit 1
> >    > +               fi
> >    > +               umount /tmp/repair_mnt
> >    > +               xfs_repair -e $DEV
> >    > +               error=3D$?
> >    > +               rm -d /tmp/repair_mnt
> >    > +       fi
> >    > +       repair2fsck_code $error
> >    >         exit $?
> >    >  fi
> >    >
> >    > --
> >    > 1.8.3.1
> >    --
> >    Carlos Maiolino
>=20
> --
> Carlos Maiolino

Regards,
Srikanth
