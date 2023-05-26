Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D18C7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbjEZIw0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjEZIwZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:52:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A068A119
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:52:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8YaG7013795;
        Fri, 26 May 2023 08:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ZBb0tybu7i0pdj5gFu+LWR/0wskvpcPM9X1ND6m8v9w=;
 b=jN47hZE88mrRbDhSckdpUnRPUdglISzqTRM/AhfMDFo8LO60gxBo8PyNhZ4F1zM1I0nq
 4ws7PG/cUMqHRNsCjW7Zd50pmeAlprYQVEBQ9Te6FxtVRzpnnT+3BM/BWC73RQv2mh44
 cb9dJ+Wc6BZFxeRwSeqJH1HZQlSxi9GdYKYUSoY6wSnDCAl6RkUd4QZccI3svIvblRZ4
 WFVaQ5+EhDgkLAQO3+5maSaq3dcNnJHHaR4hgr0vT9yOCAPJcgxQHEI13Lu9OTR1e3lm
 9vtA4vivUKd+KqKelKtuXuKjzEX1RXPQ95NlyJ8pTHOu2h9MNiaFIWozhRGF3dlo+DK6 Rw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtscd81dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:52:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q6vI2Y028577;
        Fri, 26 May 2023 08:52:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2uy3pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:52:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfZmJahEpuenF58kkVGAVlGn12H25U6KBkeHiiix1PrdKoMdwhm/rxCpm7sbTRnD9tAsfNoGQLnasqPCp0GoMRMlj6Rx4n0rlJfPogy7g7rqeBMn6FxQOCQYwGcejEzhIumr0PLaH3X95QqYQ0MFWfD1FZQqRh9Hcr6V4/Yk3MMPvnUFg4B+/ri3B0KMxm79OauGnWIOdZsjBwAwIXK8hRVKDOIZhqp8SR8677MFVJtzJhX7CTxppOpoTx27qhqWLrb5RoPrUK1SqrnN5eQZ2ozENVh2F4jm7JnwnQW8pnGTbPbeRU2ZmVhYbQHqRLXtP3D3zuY3Pj55V/wlPuWKJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBb0tybu7i0pdj5gFu+LWR/0wskvpcPM9X1ND6m8v9w=;
 b=f9+PtbCLaDh/NIYbeA2qXCzhfK7xQakNK4Eeb54KiMKJiIZweCEiWR+zwFEBb0RhPOYkKKX0hF6ZC8I3qawlsZx4jJN7hYyuJqld5SAUeBj1jtkGF4lttlD3q9GCVH+vEf0ueq43kJkux1+g4ZoU6iIqcFG1KsQLdplErQkuCn40l5PyYXN/Am197xI9/UMjEMyIMDu+Nrf6C7fSWRwFGNWxLVEjWEoeZddinu4t0PnBvwZTPy4y1dxVhpxRNPtVWPccmpDRfgHeRU6XJYOlM9jZ+dE1ILi1tFvD5b+XftBCwtIEBWhsTYtoG+kXE0Tcdr5N6r0zYJr6PKnIHtMx0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBb0tybu7i0pdj5gFu+LWR/0wskvpcPM9X1ND6m8v9w=;
 b=ye5ZFv6dSQ+RCSm0bXyHotaV0fvM6b6J3M2ZyFjTOuZ0mZ+rqXi5Ym8fRuUIPEvG0+sdgGNRmwNyUe9tZbeufCWU0kvT5VvAM9dUeMeUXVjfQ4DzfdP2FhOUk/SZ9/z08x6Mx83DHtauhZq93IgXuBUxvgY23QEM7TBDWUe0L4Q=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:52:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:52:18 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-17-chandan.babu@oracle.com>
 <20230523174248.GW11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/24] mdrestore: Define and use struct mdrestore
Date:   Fri, 26 May 2023 14:08:12 +0530
In-reply-to: <20230523174248.GW11620@frogsfrogsfrogs>
Message-ID: <874jnzjwzp.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0187.jpnprd01.prod.outlook.com (2603:1096:403::17)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 994d105f-8fc2-4bf4-f539-08db5dc682ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBDVe5Hn+RYRyWclDtqC3I8uxTmMATd0jbx/0GWDRgCG9P7eXH8FUf1+7mqGJb7lfYj79OPMXMYWgyUSrcG/ja8wR3BTSlUvTQWcjTCfRiRZJiBhV6D28QvlzERtLLCjSlFxcnC7Qso9FkLI3pE0iUWXrLSugsmxZThx0BUiL7zFMMQp9oo/YKP8eDVSixVwkpBtJMeOY2rZKYBdyHbl4JDDq8oS7bplC4trjjN8sm1D788ClHdxNJvb9SCSC18CwhZZ+6GBK3gCk1YTn0PZ2CMWTGS7p0/vZrP+ukKwfePIr/5pJzf13EeVoLoxX3i3AFBrdUkp/nErolNmCypTlMaw2Q6So0dO5w7Te9Hpo/Dorz7fv5s+QlV2sH3eiDn5RjpuAYK3QddTxsEhnMYvGMI+dQ8aQZ7W0E46m33I2bwGilUNycZcZjpBa8oOVHq7FN6H+B+qIL+Iw4IMDhR+ZlizQQ1N/uLue6IhwaXL4gxCA8TfQU2VSIe/BEDUDenktE6XMmNYCUndaAAt0b3P6VO4iiXVBPZV4Sg7zgFjnau3C4Pq02MhNQb5IDAnnUPw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(4744005)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7o6ELxPAnChQUR9vRRq3nI4Ly6HbbqcjUwDkKDbLNIVRWVNDk9/jkviNXs11?=
 =?us-ascii?Q?Iy8Ljb5MkKXn9rhQJEkT0hZNW/m+4uWqW+4llKShKxpUWV8PpJs3jqwz+zIp?=
 =?us-ascii?Q?VKUI0nTxffGBpcG2lhNJwYjWQ/bvhIuidfdbWsgHg6Jo4heG4gNCYiDBu4i+?=
 =?us-ascii?Q?bDmHsTBB56RWMzjqd4xtwT/ahHBAc68ZEZwxstd4SJZHRiZXWa7v1kA8P7sg?=
 =?us-ascii?Q?nENCWWITqLhBEblQF76h/52C1MZYG0eijNmSJ+Yz2b/6KKY1HwvQlB1eQZSG?=
 =?us-ascii?Q?shkJQOrP2byIcUD724tmoru5H4YzCtg8Zr7KZTIBIqULQweKjz/D0FXB0cph?=
 =?us-ascii?Q?ej+ZhaFLpubEc/Um+WItu73OjAmINGTnt2nm/SUhlUw9WznhfQxb2aW+5pLG?=
 =?us-ascii?Q?SR7m0CgTvj2aUGGKDI6xzmAgbbQr5MutI+nOUeb7yuZ19rWpPo/DJaWYsSCz?=
 =?us-ascii?Q?mT3/2c/cYzprGNskM967FLztJTHJ+0Gy0woLrPMSD0PdFyFoCK066l+NZcK4?=
 =?us-ascii?Q?VEEzlJEiWeEf+EVyvsAq2DFnNu7fY1Cj62Jb1X90ZzQBXrp+0Te6aGeH62W0?=
 =?us-ascii?Q?uuo+5+lLkKr+o7R4om67mgvCnCixdXDrM6UKIwbYv5mzY8QKbvJ+PcZw0KmG?=
 =?us-ascii?Q?Siv5UGNvTLKh57CAx+mJduL2T7XB4Udwz5FPR5KudjaQgwmS34FALHbYEW+/?=
 =?us-ascii?Q?DSDB4aldkmAIiDrb1XLrUL8BpF99iyEf/0CKed6W33md5P7FRnGAjf49gC7m?=
 =?us-ascii?Q?R+iF62fCoNL6vMTEPL9xwmdcaPgZiCQ6YEBdtIthgLTK8mluhT01KR+aGvaN?=
 =?us-ascii?Q?1R7GazqorbANnx6+cSsjOQEYl7e8v2lm1bBdga2G5hwyqaWumneli6SOV5U9?=
 =?us-ascii?Q?qn/lFgtmLDwPiIdWk3xAU7kVM196ZUTPvk2lQPYtQru+mTyrz6tGgWZdVGiv?=
 =?us-ascii?Q?nJNrxiMr4ZSaOmnqbKyRch8hxoD3wOTru5WUbhDu2X+fjQ6I+6LhE1MdRL1B?=
 =?us-ascii?Q?aVriWeD332c8NCysLVXwSxp7JVAhGz3EbzLSwUEsPvTmFP+lwK7jAbFDNdVH?=
 =?us-ascii?Q?ODwKza+OLgM0ZHzmImkqE6c7/4d4f1LVynyawysQP5xUG/X5vOnH1apXh7ZM?=
 =?us-ascii?Q?9HJgwNUWmBGAIvXERGXN7LL8ak8C8/szo48Tz+p06+YUWrN3uNJ20mytp9l+?=
 =?us-ascii?Q?i0fbLtkNnyFLXhm43JA7R3pJIA0vsITiYAchLoFnrc5PPy36i5M1oTkYz7J3?=
 =?us-ascii?Q?9JhjuTfGg8i95b/PGmlJW5yTG8y971ZCj8jTJHRPluWCrGC5OGW9YZpqbE/2?=
 =?us-ascii?Q?Ij8tgD4vm4sp6gfn9HwDlIy9xup/ieAMa65Rbn4JCk0K9SCYl4ZKCehVV6xF?=
 =?us-ascii?Q?MwHH+gfJQQCeMWLdcmtwKuPG5CGyKA+orYydZ/xW3MFu6gL14CclQDuiVO1j?=
 =?us-ascii?Q?5IzmNo3CYHeY/ldteWW1QRkxOxuvjwd0jOo2/TFH6g3sDGVwAGEh/BiCOHWE?=
 =?us-ascii?Q?byGDsApgwWj7ESVeMLOn5MM8dJf8e3/vqe27He57aEU6im6+4Y6c6ykPZUPW?=
 =?us-ascii?Q?p03h2H+Hd7hj6fOScz2Ycre02QtK34sSAmIw4YrSdemr3/USN3UXNoN+XsvA?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: y2+Ed78uxTZZl3Sme7j/2qjJTPZtAAwzqP/C+aEpVuLqjTO5i0zGqRjYyx3/y6TN7tr0No2HXnoEtlD3wflB9UsGlnXIZxNKxc6Y1bTkekMVrjrnhdJgzwy+eFHwxwe/aYBy0snBAxdxyvgyidkCG1JAxd7cYJLbD8awsuc/YYNW5EP5MJru9WvCyOzHYIwAnpeangMzpEP7no0VWwrjOfxKvA461hpfTQpNnenCygVf7GOduwvFHIfFdSLy+9JH/U3HXXz1KwnRPanzp2QrbSXRU/XqBezt1vx/HAgdNedY1UoU/r1yhibcrINbdL4GFkI3YDyaLkG/3B6mxJw9EhJPJzbr03nkUheCsBo7NtYug8pdKn1urIC1CaL9NrfmTXoGRIzlz8mDvl31z2eDn9qFFHvTl9uzoBaK7T6E95JaKAWxjoi02Yn4//D3sMTk02os8StxmCw6NReS63avmrFk2KNrxwLnFK14w7DYK5rpzk7IY4vNDpjt7Gz0DsuUQs6SSTIyXeZudWrBMXkBKbRX7gbx9QwsrHiq1puTtTz3jDC6uWjLFaw0+FO0RiaIY2hP2mWiGVpaoAXHju0aZdZS7etvPzTtucZl+hnyZZ78eDOJysyQ95gJJEWmNIco1QcCEIbt5mT7XPzd2LP5LmK7lpycg+13P54FuARqvOfFd1xLk9W081zJx+DDM7PyswW+EmCfD1J60tPu7C9tVnUl6tObcwBcaBhwtHmZZuxe/4S04muA/2LeHAEZq6BwPN1XFF6UliE5i77R3DBtJZJfNvGv8SLUeESigq2XJ34=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 994d105f-8fc2-4bf4-f539-08db5dc682ce
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:52:18.3860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +XXeZ3T5G5bM+ZIKqfBh6SVSwsa+5q7+OXY9WbWXQazGpeDUJYyAs9VGLmdPKDx6RkP9fUuyeu1UR0E0VRIlZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=902 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260075
X-Proofpoint-GUID: wdVHUqyRs9kurqA6D17t5e2l9dd9AcTB
X-Proofpoint-ORIG-GUID: wdVHUqyRs9kurqA6D17t5e2l9dd9AcTB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On Tue, May 23, 2023 at 10:42:48 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:42PM +0530, Chandan Babu R wrote:
>> This commit collects all state tracking variables in a new "struct mdrestore"
>> structure.
>
> Same comment as patch 3.

I will add a commit description explaining the reason for creating a new
structure to collect all the global variables.

-- 
chandan
