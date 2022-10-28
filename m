Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F551FA373D
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 01:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiJ1B4u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 21:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiJ1B4t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 21:56:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9286FAEA1A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 18:56:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29S1iK3X019059
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7Uc454rlcf92qXftn+GSDU0y52XvEyj4jSuUKSgmR2M=;
 b=RoSc1Tz/hSh5fq6NPc1El75hsmhXuGH9Lzx962ZABY9mvmHrx0B6HCdMlTvSajjNcCTG
 ll7o0100KgAoYLdgDSoMHTl4CLLVKLpjGL9RnHD3jFu8Ej+gHtElBdx2SggiInaPxHRn
 IutGjheVBfOSlXqxzjFGI9nqV+OlUp4rnnYNefwa/mHOFeUnW2sw7dLtEZ+D828VzD47
 TwwJGsnlG6fvXmwRZ93iOLshms6gbWhN5fXSI/E2qpCNi5sc/iyxY4gOdbXyvUaWEePy
 sLuq/zhHbcqs3FeGRziYBmtm8aF2HLe73CFB91fwUsasosJXckbOS0n7P+EMbfoT/vOi rQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahec4jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:56:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RLbD2U011565
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:56:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagrkqu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 01:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPQaIk+8Rmm8sfAuFWvzD0pSJMT5AxXLSDhdg+oYyKcHwBIr/6uACc0pf23dmMTjqyx8kaBwF12wzWTtcSBxv+amHEdf4rqF4eO2v0s7ww9NO8riCfvGiL6AHTflGEsjaHbr9ioTq8h9g0EOzf5IAUpd2WHjhrhcDJoIl4gf7VEe03f/hOzSPv3cbKSkrOSXPOdMHYN+DHLmHaB7hvOcjAIRUUjA4oUIBW5eaWIu7W0y917EIwKi/hB9jqhXbTl8HeHcj8FD+40ievU+GhHa6l6NUUo/9uHrRoSNASv/9xAEMDLVgHcnHVvv/JXwiok6baP9E1EeEC2655D6JbasbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Uc454rlcf92qXftn+GSDU0y52XvEyj4jSuUKSgmR2M=;
 b=Q9/Qkspqd8Jrggmpv0bw/qj6wzlbYR1LlxtTwAN0K5OYW9KycR2QPfsiHhhhgSGBpCuVht3dnQyE25F/A6PiVwIOHgwt77NBoPMcSlXP3QRl9gy/ONDRZG1kKzjeOIXp8juEyrnbLMRcrqcrU5J6/3+PJFd0tCCEUGRcWolb7ssVCYS6j+oLASjgnJIaejWE6tE0IOkqG4eW67rWOadwqfG76Pnv8J/YPYOWRMnEzkeO7aPbsKZPYLDhL2KtP+5noyBgjiez792UbqaG1dH1bHoUwGoxeLnRrGH+1h1IIOGbg+omLJor9qRExjedQ3HC1PPpRhkfa+Z7j7RfAeBycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Uc454rlcf92qXftn+GSDU0y52XvEyj4jSuUKSgmR2M=;
 b=iGcxcArGtYVVn5csWlsEkRGOCz/OHpPK1QV0c6cvnl306CqKwYTNZygEd1d25/jYqxDUAidIriM/XB4/FkpABCtfSrEDCoeir59/uNYZWxuuygvF+gyJ7zT/FM7B2ivFJ17Sb82JVWj1vWS0b6Qtc/zXKb4QRgoxgNeukR+FRNQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 01:56:42 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::17e5:a392:97fb:39e9%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 01:56:42 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v4 04/27] xfs: Hold inode locks in xfs_trans_alloc_dir
Thread-Topic: [PATCH v4 04/27] xfs: Hold inode locks in xfs_trans_alloc_dir
Thread-Index: AQHY5ZyqBDki6rJQ6U+mwNEzfzTCba4jFdKA
Date:   Fri, 28 Oct 2022 01:56:42 +0000
Message-ID: <C9985F81-C475-4BA3-9B50-CDB276302300@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
 <20221021222936.934426-5-allison.henderson@oracle.com>
In-Reply-To: <20221021222936.934426-5-allison.henderson@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|BN0PR10MB5048:EE_
x-ms-office365-filtering-correlation-id: ca370e61-f5a7-4af3-8ce8-08dab887a8f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I4UCXL+x+y9zMtxfaeqXf7W7/PWwQz0Q/jVB8CVlwvKrQZ6oUZRfuz1g2eXrFZKykCgm6OfuCE4fbYeBYfi0Xa9bAzoR43Vs+przhcDO6FxEZ9soCDpM1JDEm/9TeIQ1UMmeTRDFQryYZ+q3vxtahXr6nxkwFFDS7VB7l7tuns2fvhNa3mnowByr883GhFtoJdyEd3plPx5oxcwGmHWqiUP6mCmdAGAhKecUadMBvIRa1MOTiMhtJhBNxYfADTtlhrbtun3GzOfJ5ehSPy5G4OaaBWTf9CTxUEIf6Ueyj2Ce3Sp7eXNwNYGJ7pAHGNVEtKGnZpRSc3PdZvkDMauojrVCSWs3bXrx0H/1QUWQtYriLKzkhECdlu5qd2cL79Sjx8sx9f7ZctN6qCo1PXMhLG0oNPLYfWqLS0Tv6FNd/AzfZwYnEaYbN9VvYpzmqDpzR6aKRnEWhXYN41Cvm1FItiYYMbbQfv2sYOAjwWCCv/a3YW2MZZ7MMsrIyP0hWqVabHPM0rg4nv+33A6KdrXXuHmwW66E1Uz2L1zQot5EbhFd3RGyooX6EJSwZhTHIUY/lSq6lXgVZEwdnfdNkADGt+1nWQ5VFkpgs/4cgLr5fv4uOZsBQyvz57FuEVpp3PJMByuWTB3hexfS982x+yB4DDMtfScYDvH6ud1UnLyrmzIAoW6C3huwHGiOhn3U3o7ODcbUMDYIUGWmPkplOX4w3OZUg5Vb/JttZmTmD1kxSlVH88eC7aswzjQue5bkXcm+DvlduqPIDnbj4fD/6F5i5+LyPTDZSGYnF7BUZcohN28=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199015)(83380400001)(8676002)(36756003)(33656002)(66556008)(6486002)(71200400001)(478600001)(6506007)(53546011)(5660300002)(76116006)(8936002)(4326008)(64756008)(66946007)(66446008)(66476007)(6862004)(37006003)(6636002)(41300700001)(44832011)(91956017)(316002)(38070700005)(122000001)(38100700002)(2616005)(186003)(6512007)(86362001)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/+mRjD0AFTZlXZRGAWodii/WnLbLWbXRV4vrM95m7qju66/gWFfCTfMfTf8y?=
 =?us-ascii?Q?g+MKgV+XEBT0VQhZXuRqr8ACZFqrF9+yyIrnFIFixCBRKq/DlJd+m4rDzS+T?=
 =?us-ascii?Q?5Oa+GZPU6xTpu+Mg7qs6FNmRwN5Q+oMGOYoOB8srgSMnkknNjwtWA8IrO4g0?=
 =?us-ascii?Q?STLQLjBuhvApnN6bl3LiDRYJQuo0JtKzNbn6TxVPhTkMMNIkX/c5NyFn6caU?=
 =?us-ascii?Q?+3rnGHAwVlgDzKQEbV2FjKcG6ytAjTuedbagKPqp+k4AcTFvN/yIIaAqFP5K?=
 =?us-ascii?Q?oGouBdQwXNa2lZEXET/kXWB54Mvzw9ejqPqKnDS8sQVPI9FsMG2Jpy3QIIo0?=
 =?us-ascii?Q?vQ3uVFIRZ+DxJa0FRRf8DeFkmgxL6hioJiizQkDgpO3+0OVSaydwxkaNxbFq?=
 =?us-ascii?Q?DMdU/QlKdCN/rg8HYsJYEvJ5avn4v6lhJCohih+vZmm7MDx3sCoqDU+B0gH6?=
 =?us-ascii?Q?7i1ivZkIUiCBDUggumZ/tujSuh4dZ0Ml2ujt9hYXx55bphHdYa2/wdlrmNs+?=
 =?us-ascii?Q?SkBH+pcZAc04IHd1rO8qymgcgdmts50Aui6TfOG5aE063YGmTIFa+wkEZaTR?=
 =?us-ascii?Q?mQQhgCZhHZ5FBM9QdQMUMayBGMUor2y4HG0uCD2CRIcb7CVlPFP97i8r1Rxi?=
 =?us-ascii?Q?8iD9877Ph51sLKvcXmGQrc9NAEgOZ36QFJdFeARXQWLWIOPaG2xj3uQ/hYNB?=
 =?us-ascii?Q?v1mTeBYo7pnrw5OJDY0Zf7w8jwa6t4fB3/DuTqCpdWAc/PJ4xWs8w8ZzTKUl?=
 =?us-ascii?Q?W4woYrtFWXhVD7ltPTQV+gmEz9RTvSC9vc8f5nzml2E2rBKSfQunN2uL7cAa?=
 =?us-ascii?Q?2Jya59rK/sgKOxn4RiNCBe9SjsAqE+1CsMmM9C8XhzmSvRQodNym8ZvQHUwJ?=
 =?us-ascii?Q?6jA2SFTjRu2r8ues87npXuuwrJFHMsui6XeSE+94JsNRwd7U2JB0MzqAPyxG?=
 =?us-ascii?Q?hDqQScOAiCINB/Vp7g3tpaxY006dEvil/sHhV8NcPBlMsAav0r1rFKNNHu30?=
 =?us-ascii?Q?wWP/2c0ThVqTUOkiJmcH/BA6GsttJFOT+5DIfepSOWEu6YKndMiwmGGtkOSp?=
 =?us-ascii?Q?EWYpRwbzZhPvBQ0oJBEbgNoMT+8rkmlZZoZkZpxTbwp6YY5vEy3zr8wiQP31?=
 =?us-ascii?Q?2rK8W2XsaNhsqY3IS8bVP7Ve2KNSOGW8LXltHNU0swUg1LHz6wl93LDz4xtF?=
 =?us-ascii?Q?Uy3iULWo/dyZle0xv9TtmLBc6Hdc4dpK9I0G5fjfJRLhHqExBz5FeundSZ++?=
 =?us-ascii?Q?T9hE/WJQceVU7fNBzghnZCQViF8XfRo5N+InUktClhTGV8HcmDd9u9IqNwXD?=
 =?us-ascii?Q?AgIgQPI/cEPFnKMA9wr+IivUgCMRql9OJQP3iocxG6hUHmmrIOapir3e8cxm?=
 =?us-ascii?Q?o0zNWDv7iXXs560UQm+6mO9VpTGJD1WvSedPypetJhbslZWWaaxS6E5nmg1r?=
 =?us-ascii?Q?ozj4MpUeurqiKetVKC0YtwrOyOUA99QN84/EDN/pySUoFJ9AgLKmZZ5DCHqZ?=
 =?us-ascii?Q?HILcLLQlVEEEk40aiOYHEcr8m/YyDua97S1yaoHuZWAtHkVRbWLJ5SRfWHWz?=
 =?us-ascii?Q?kFTTYmLTrCcWeUCr1Anr4U/YZEAWRQaEc9121G3R6v6nzJzdcSi9y1Xl15AV?=
 =?us-ascii?Q?Q8j00NBGWadz5kM3vtTMXFvOaoihdFPFNzJ2Fy3Taa0tpRn38LeoOP95jt/c?=
 =?us-ascii?Q?CDVPoUabHmGZV4uvbleZNbP9xNM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B083AB463A33A7498B16C8B9F0DFBD6C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca370e61-f5a7-4af3-8ce8-08dab887a8f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 01:56:42.0744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ehlr8cm/QU/sxgtHaTcUowmi3JSfkLqCk2aLgk/A4BWctCtFrY238qGFxZWIboeUZLngxb/oKpO+5++oplRxVVNY0vz1eX7GnpljgVdjSC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280010
X-Proofpoint-GUID: yvkRjJLBzFzm2eWLTcuQMryRhGP4h53v
X-Proofpoint-ORIG-GUID: yvkRjJLBzFzm2eWLTcuQMryRhGP4h53v
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 21, 2022, at 3:29 PM, allison.henderson@oracle.com wrote:
>=20
> From: Allison Henderson <allison.henderson@oracle.com>
>=20
> Modify xfs_trans_alloc_dir to hold locks after return.  Caller will be
> responsible for manual unlock.  We will need this later to hold locks
> across parent pointer operations
>=20
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
> fs/xfs/xfs_inode.c | 14 ++++++++++++--
> fs/xfs/xfs_trans.c |  6 ++++--
> 2 files changed, 16 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f21f625b428e..9a3174a8f895 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1277,10 +1277,15 @@ xfs_link(
> 	if (xfs_has_wsync(mp) || xfs_has_dirsync(mp))
> 		xfs_trans_set_sync(tp);
>=20
> -	return xfs_trans_commit(tp);
> +	error =3D xfs_trans_commit(tp);
> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
> +	return error;
>=20
>  error_return:
> 	xfs_trans_cancel(tp);
> +	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
> +	xfs_iunlock(sip, XFS_ILOCK_EXCL);
>  std_return:
> 	if (error =3D=3D -ENOSPC && nospace_error)
> 		error =3D nospace_error;
> @@ -2516,15 +2521,20 @@ xfs_remove(
>=20
> 	error =3D xfs_trans_commit(tp);
> 	if (error)
> -		goto std_return;
> +		goto out_unlock;
>=20
> 	if (is_dir && xfs_inode_is_filestream(ip))
> 		xfs_filestream_deassociate(ip);
>=20
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> 	return 0;
>=20
>  out_trans_cancel:
> 	xfs_trans_cancel(tp);
> + out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  std_return:
> 	return error;
> }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7bd16fbff534..ac98ff416e54 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1356,6 +1356,8 @@ xfs_trans_alloc_ichange(
>  * The caller must ensure that the on-disk dquots attached to this inode =
have
>  * already been allocated and initialized.  The ILOCKs will be dropped wh=
en the
>  * transaction is committed or cancelled.
> + *
> + * Caller is responsible for unlocking the inodes manually upon return
>  */
> int
> xfs_trans_alloc_dir(
> @@ -1386,8 +1388,8 @@ xfs_trans_alloc_dir(
>=20
> 	xfs_lock_two_inodes(dp, XFS_ILOCK_EXCL, ip, XFS_ILOCK_EXCL);
>=20
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, 0);
> +	xfs_trans_ijoin(tp, ip, 0);
>=20
> 	error =3D xfs_qm_dqattach_locked(dp, false);
> 	if (error) {
> --=20
> 2.25.1
>=20

