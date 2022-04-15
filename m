Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF06C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 16:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbiDOQpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 12:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354701AbiDOQpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 12:45:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0E9DCE1C
        for <linux-xfs@vger.kernel.org>; Fri, 15 Apr 2022 09:43:17 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23FG5pLG001710;
        Fri, 15 Apr 2022 16:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7QMKVURH32kS1CbFfXG6FOmVHvOFpLwRuHi99zqAYtY=;
 b=ATYjAoV/0lFAx0rJrxfI6W8KfTLiJ+zuKHZPK6PROI7xw7p6iIBZghlqHYQTQZD1+dIC
 ePovgCTpMxZrNWAttQetRqEKXB/VKmM/CH61bgjxaLDP6G/VQSwZvW+kkRrtk08NFILP
 zTebGbFW4QiCtIlCHxa10WWxxANvBlI9T0hw+M+YxZ1xqYkuDygVEwjSn8c9YoaKZahr
 ZephAra5PhlCrglJWFfaZeWe92hzllSHcq3BVY5ztWFTiKMw/YxMmSo048pGI1VrDMCp
 AO+DuUjQ/qAuQuoD+uz5cwLTEbNBvfVqj1BTZmMUoGbFUU30BYuWvCnkmr9RZyR+JvP7 jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2qhx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Apr 2022 16:43:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23FGfsRi035108;
        Fri, 15 Apr 2022 16:43:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k6b0xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Apr 2022 16:43:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3BPGL0bO0K6NOiMAL+zgDyC4uMUDGmNNRg3YuSCtxuKX+6o+WbK6RL73fn0No3fXC8ZIOnDyKaBs4VKU3ou0FpWU5lMxLsrCaoYXkpgm6fu8b67OwVOTuz9bTL0c6w6/grB5/3z+Dq+06bgJvCtCxYpyJ/TnprFZLydqs/EoEfs/pLgUFne5C/3/XDdqptIhH8DThlunrQczyV/j6Pr9ASQ+rl/sx4HtODNWVbbWM/AVj03UO7Qk7YxTwll0GI9Ww6cMGnnIENjgn73wT45aGQaonZ0QtL0GEt5gK49rPMiNnjeZi5Ih7A5iyKoXR2Gm5KtrNFlhgevjk5lCZGSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QMKVURH32kS1CbFfXG6FOmVHvOFpLwRuHi99zqAYtY=;
 b=gnMDtYUOIl4vjKiySewAHSQfPDpA9RXooYYuO4xMBkhPSYi9rMwPQic6NkUg0BtcY5uuHlTq5iSfxWjIWDOObV3RQhjfY00Ok1o5GdcLcOgKFTLfGAPtY7ytykpiulPu0LZ9u9bYY0FQ2zjyKHLsQH7SKoHRlul2yhSps8pffxw5Lr2RtdqKRYgO6QYCEK6yhzNtUfbg02C9cLP4xUwiFZo03yKljl14M8tTd2y4JiL641H5ma0+4y5V+K7qRsRlWirAAlx6J5v+xmAMTASuxVXlhwXFYNT95qYLtq2Vj8sxE9WPrA7tgBLYQBHBKR+hDnt/RCtb/iW13o2X56BA3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QMKVURH32kS1CbFfXG6FOmVHvOFpLwRuHi99zqAYtY=;
 b=K5Zsjtem9b8CfHwoBF/acf5/w5Z+GfrGgzA3S2GV7KbE+YEr4mFaq+Zk4AYFqDUtp4yYWy9GWkxPsTwLI7+hT2YP+EqiRVe0kmgtQ+peJM34SEumP9/gsZvj+rkjMm4tz0r3o+xy/uwoKvbn4HLThu0Iyed0142HdVaA8UV2OU8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY4PR10MB1400.namprd10.prod.outlook.com (2603:10b6:903:22::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 16:43:08 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:43:08 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "sandeen@sandeen.net" <sandeen@sandeen.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/4] mkfs: don't trample the gid set in the protofile
Thread-Topic: [PATCH 4/4] mkfs: don't trample the gid set in the protofile
Thread-Index: AQHYUOfiBhSZ2rzcfUuIc0tHgRuYEA==
Date:   Fri, 15 Apr 2022 16:43:08 +0000
Message-ID: <B28D1D24-2E23-4F60-AA50-C199392BBE4F@oracle.com>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
 <164996216024.226891.9018863209797667675.stgit@magnolia>
In-Reply-To: <164996216024.226891.9018863209797667675.stgit@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: feb73029-1eb4-4555-9147-08da1eff0559
x-ms-traffictypediagnostic: CY4PR10MB1400:EE_
x-microsoft-antispam-prvs: <CY4PR10MB1400D894D7806942D00CA74589EE9@CY4PR10MB1400.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VY3P/7A3R8zCJqcxPcXSR4qZSLm6XefmTq/uQl44sUdfhRjzoILUmF8KVSzOEQ56PaA7jykqx31PAkvZi9hxR/YxP3G3k/GOo2fJ4vRWah7Umo48mHcWbgK3HZbbsPAuW4wA0+Fh37woRfnY+SSK5TxloIGdPGuFuUHNL7zKNQTCxzgjX4667ctVJdlNt7m0wfKA2LSEs087+GEz5HinanwzLT90YKD4LT2QldjTp7X07JjGYcYOScEKLslm49Zvk7BrsoexjL5l321tqPAsYX1XWWv7e1ncUveWrqVd2Yixdu/r1zmmbvLrJIPRlbwvG7SYUeAk9Squ6ZjxgFMKv+0EdK+TvxMnsDPdCEuPLnf51iN7+22mtxR1Xl0HNJXhrathF/wpxz3rWBXmN6v/W7hU984qkpB6cNuWuXv52ODMaCER4g5R+4fKhTEIVE9Ao6Jo5xwGQ6EvMyarmqfHECkFd0wHc1SkOE+JjHMlYov7lvi0AiGG0r88szvd2YZHQ1vLKPBnu/i0Fh/1l1nFJCDTyUA5oqQbt5Jl1dI2eK612td3koDecDGtYHiM9CMQMWG3i/CniPJYMYk3p6IBj9hC0hnuEryDKfzISIoJlta78t3wgWT56pT6Fr+za94OASx/1+HeNaif07or6dlxL0/U76CE9EtFY9Dmbv9JX3NZuTybCLHd259fy4/NQsd8D7v4A2OQKjpLGKjho+lRuOnfrqogLytb31RFDDL+Ero=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(54906003)(86362001)(2616005)(38070700005)(6916009)(38100700002)(71200400001)(36756003)(316002)(66946007)(91956017)(66556008)(66476007)(76116006)(6512007)(83380400001)(508600001)(6486002)(2906002)(8936002)(186003)(5660300002)(66446008)(53546011)(6506007)(4326008)(64756008)(8676002)(44832011)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xW7Siv1XopUcxpMBcTsb2vhPs8XJrLxJ9fqz2lZ/uGJzCyHRhdbUVU7mgwnG?=
 =?us-ascii?Q?3+va5ModU/KlcFkUodkcNCDhTiX68luOjdEssihrbJ/gjdN1xjv8DXc9Fqp+?=
 =?us-ascii?Q?9Fw/lkh9R6whDMT6yhOuYc8I4z9K7XoJzZSAn4jrLEdNeV8g3C4GKxrXXGpY?=
 =?us-ascii?Q?lh5/0TXgJGyjtvfdIk6v9uCg0TtD0BD96p8f2sNUuZAyJavBencbY8Bjqy5J?=
 =?us-ascii?Q?3UK7iKp1JTH9FE3znAuPmrO3AHvgwk1RwWAgvdi66wlnk5d9OG2vcFrWJ7Zf?=
 =?us-ascii?Q?TJqjSd0IsGF5G5EYd90lb4hVB46MBI849QrzhtPkC/bbn1xyXtGHN8WCazeC?=
 =?us-ascii?Q?cBoYlh4U0LFvtrQ85fR6FhDY6iItJzBL2jLqRja5eYVqGtE0f3bhg27qpejx?=
 =?us-ascii?Q?XF5PJvJkJ9oBp4qSGtoeriw8M0W9Y8at5OTF2/E5U0Yo7AhzQzXktYaeaxp3?=
 =?us-ascii?Q?2asxezgTx4eHAFyvmqjt/oKgpH7zbmHvysIQTCGw2SNRrVF1vnt6yfcW9Ieb?=
 =?us-ascii?Q?+Kas3XQ1eFVgLRQ8ew2uiEDL9zGgg2B9r2lUXciYSIMaWbzFRSEISI3R2bWH?=
 =?us-ascii?Q?BKjsPdTtlPUerosSXHFisWG5Jq3vkiDsHzxS57RUdjuFE8A3MEv3yIA2bpcj?=
 =?us-ascii?Q?u3L/LZDXccTBwuanOBh1YgoZg84uq7eUKFMakEYlgGYLLOoo7f5oM1hfJSeA?=
 =?us-ascii?Q?XwdRWRuRss9/SFfOnzWz47qlm0Dl2C0aGCZDcdFqHbHv1hx8j9kB3LjRuRMs?=
 =?us-ascii?Q?9DQq8AKsPL6RwTYoeR7n78VJAsKzqUUoPKTnqI5F+DG652EfDx1dXpP2fwwy?=
 =?us-ascii?Q?+BzZ9AkQ+YyQNWeqqKBtO4nwUJdj1kLpslz7BHVU8IrW30CloRn3F2x9arGA?=
 =?us-ascii?Q?kwfCbXMYn9GqJe7ePTme0NDmEAfDDze+uE0nK5roQBWhEjhtdVIpGrYa7W8p?=
 =?us-ascii?Q?qmS1RNLDbgT9JhLH2MGyPGgxVQ9edvC/W7++AX7Ytg8acuhjlTFwxpPI5qNT?=
 =?us-ascii?Q?xNIhKuwhQSbqQRlKCrDOpKx3vPgoNwslcOFdp8aH1XxHIiN6EpyIgtcKAl9b?=
 =?us-ascii?Q?IZyeKZDLTtL7ge5GeByn4eeEq0qdgoCreFN3nsMYXsmxnD4MSdr37K5+DDmP?=
 =?us-ascii?Q?8FzCn1bfc0Rt0iXV/ZVh5MbzzXkqCg+UG66ClNrgX5BrTn7lmsk4UbC4VcO6?=
 =?us-ascii?Q?+VWsQHMIukLrBuECqjfxucOIkn3xVk+tNcvNHXZBLapj5DTlh0Qlko/vczNO?=
 =?us-ascii?Q?LtV5vNPIAy0xEOPpsD6HTvnOLnaXOtnqwnLZWC0GjNK1I5L9yHIJO0HL4jny?=
 =?us-ascii?Q?SuaA+SVseLc7JOzVOWFLchXfn3MwaXV/NYRIAfWN/CBgw1WFC/fNSQcNMYSH?=
 =?us-ascii?Q?At8InEt7FHGxNJVIjsLiEIln+AhOFSR0+Pe3IJp7XCDnmDN+Uc4HplA1V3xI?=
 =?us-ascii?Q?w/Ug9hBcbysRYTIFOlA1sLbu/vNxoySQSe1HZPtIBEDMXDxEaLhY1vdmSai9?=
 =?us-ascii?Q?X9UbkxP2/CqOLfWkvzWylHzagndsH5Nwgwuw5hMSN00gVIsSpouh3xMdJJc+?=
 =?us-ascii?Q?5Z5zXgizjqVxwwVvPbWFByorlmPOUf3BKVMgF7NRkq+odSnwe+FLVBLKSM8H?=
 =?us-ascii?Q?ez7UACyVTWr0QbYQqiMRpILWaRMD9hkXW8TPY1G/c4C+USvm6JR24n014Tp+?=
 =?us-ascii?Q?YFbewFDnph3hFtnNrdJMshnwjdUH/v2hzHQ3fljJBme8rt+3UBM9Xq7ziqTC?=
 =?us-ascii?Q?m7GaWAOKU+bTWHedBE3Fqdf/MBcjjnw6WKEu83knBnjUVhPoKY7r4vT+JOdk?=
x-ms-exchange-antispam-messagedata-1: GHei2XfTZKLPLoGb9T9KWPt0i8q5aHzIp5r+gvz4AjrwSYlhbPGncyPW
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4D7C3E7A699CF4E9BC0E64E44451E27@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb73029-1eb4-4555-9147-08da1eff0559
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 16:43:08.0815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dKcHkRc8hBf3fLv3WIysXSxAQfRGVhcJH5kiFh/5L8Tgy3u5TLQ2cwB43xpfyouKMiie1gzmGMrWcWYUyp/JpvMv3saxMXBpILlL9aBINI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1400
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-15_06:2022-04-14,2022-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150094
X-Proofpoint-ORIG-GUID: JqvLNFlUyDczQGxHF3zZiDFDm3AvUSi-
X-Proofpoint-GUID: JqvLNFlUyDczQGxHF3zZiDFDm3AvUSi-
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Apr 14, 2022, at 11:49 AM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> Catherine's recent changes to xfs/019 exposed a bug in how libxfs
> handles setgid bits.  mkfs reads the desired gid in from the protofile,
> but if the parent directory is setgid, it will override the user's
> setting and (re)set the child's gid to the parent's gid.  Overriding
> user settings is (probably) not the desired mode of operation, so create
> a flag to struct cred to force the gid in the protofile.
>=20
> It looks like this has been broken since ~2005.

Looks good to me
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
>=20
> Cc: Catherine Hoang <catherine.hoang@oracle.com>
> Fixes: 9f064b7e ("Provide mkfs options to easily exercise all inheritable=
 attributes, esp. the extsize allocator hint. Merge of master-melb:xfs-cmds=
:24370a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> include/xfs_inode.h |   11 +++++++----
> libxfs/util.c       |    3 ++-
> mkfs/proto.c        |    3 ++-
> 3 files changed, 11 insertions(+), 6 deletions(-)
>=20
>=20
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 08a62d83..db9faa57 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -164,10 +164,13 @@ static inline bool xfs_inode_has_bigtime(struct xfs=
_inode *ip)
> 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
> }
>=20
> -typedef struct cred {
> -	uid_t	cr_uid;
> -	gid_t	cr_gid;
> -} cred_t;
> +/* Always set the child's GID to this value, even if the parent is setgi=
d. */
> +#define CRED_FORCE_GID	(1U << 0)
> +struct cred {
> +	uid_t		cr_uid;
> +	gid_t		cr_gid;
> +	unsigned int	cr_flags;
> +};
>=20
> extern int	libxfs_dir_ialloc (struct xfs_trans **, struct xfs_inode *,
> 				mode_t, nlink_t, xfs_dev_t, struct cred *,
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 9f1ca907..655a7bd3 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -271,7 +271,8 @@ libxfs_init_new_inode(
> 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
>=20
> 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
> -		VFS_I(ip)->i_gid =3D VFS_I(pip)->i_gid;
> +		if (!(cr->cr_flags & CRED_FORCE_GID))
> +			VFS_I(ip)->i_gid =3D VFS_I(pip)->i_gid;
> 		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) =3D=3D S_IFDIR)
> 			VFS_I(ip)->i_mode |=3D S_ISGID;
> 	}
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index ef130ed6..127d87dd 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -378,7 +378,7 @@ parseproto(
> 	xfs_trans_t	*tp;
> 	int		val;
> 	int		isroot =3D 0;
> -	cred_t		creds;
> +	struct cred	creds;
> 	char		*value;
> 	struct xfs_name	xname;
>=20
> @@ -446,6 +446,7 @@ parseproto(
> 	mode |=3D val;
> 	creds.cr_uid =3D (int)getnum(getstr(pp), 0, 0, false);
> 	creds.cr_gid =3D (int)getnum(getstr(pp), 0, 0, false);
> +	creds.cr_flags =3D CRED_FORCE_GID;
> 	xname.name =3D (unsigned char *)name;
> 	xname.len =3D name ? strlen(name) : 0;
> 	xname.type =3D 0;
>=20

