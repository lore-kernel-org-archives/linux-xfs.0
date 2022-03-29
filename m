Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987E7C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 05:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiC2FYH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 01:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiC2FYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 01:24:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B068D1B9FED
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 22:22:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22T0Sr5m016087;
        Tue, 29 Mar 2022 05:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HTd3ksHfFgvN2kg4JqiUtRaKRS1RQ8OKSqNIW5Cd0h0=;
 b=upqpGjOXRxTh1j1Sx8I0pf7qO3zY+FdMvN27MB5c4XRL36/Tpu//opwSIjniC+dkDR/u
 tf+zhi8WiYW8JR5oUsUJt6Hu195PX+5L0gMRVaLGPu1/GjK2wiHFozabse51N9YU5QB/
 1Ur2+UbTLPUnSRP/WhMwnkxne5jta/hcSrb19KAMC+T5v5rfw8Z1wb7HlD6shBxsFwrr
 FVFOUPD0v4hGHYKenghY4+Z4DWRd5U5G7HywL3qLaQUXl78/1icqs+62xya/4rP5OxMO
 eK0BUTfw51uUNwvdFZYqXbadJDnEy0frBmqBo0pzwLuACXuBk8tbAmnuK3pGJzXhzviE zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1terwfb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 05:22:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22T5HxSC159494;
        Tue, 29 Mar 2022 05:22:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 3f1v9fewub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 05:22:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBytIwxosejw7b8A9Z5E8+AgqMLV2QOS8wSTNXxJ+X2cnlYc0ucs84xKOtD6wLQvdgqqSAWZY6cXZt/66uYLxY7uS5Aup2ETSqxWhHxoAH++VxSTrcUNWFo/O4Dm7GTzGIKuXttKFW2ZdRo3je7wEgOmyTSxjO1B5JXgJyxEMMn1Mi96CCJ2T2w/Y9ixsvs31y0Ta28jymH21R6fmwrIJwnqevwQvT/3VOvlTvg3yImGewBU17pLYRcaEsphzA2TxWdr5cj2OZoUMZ8C3ZSHYKYrexW5vHmhYt+HAVJ5ZI13XiZlTa8FOdvz+eSq4yud3b+SnG1GtOCnG4sUPh4B9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTd3ksHfFgvN2kg4JqiUtRaKRS1RQ8OKSqNIW5Cd0h0=;
 b=AHQEhu3+5dw9BjelIkRLmI2cPcLhCkh6jn2RXqiHa+5sNByMLlp5epmX5O/FH6IK2s6u7TR2LV2GR8+qHYsraXd/RVuvfEKh6+E2uMtCFcOV08YkKJUqjD3eCNC/bRFRDn2obOMjT4D2/3I+oeolMYK1big09He9Ak3GkZvlLZ/zFkPEv6mae7J1MAgH5ytL07GLMjPJ1/TzqMwtmMDETstoJRSz7lDbtszsI6EfCOsjk6OINHQev5ZrkVcFgbXk2gagU4etW+sIDI+gFb/Q8ni0ByrzgznP3LXY7RQ6yMxu5okxoeD3V937XotBh09h/P2U24GHDbs047yEF3TEeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTd3ksHfFgvN2kg4JqiUtRaKRS1RQ8OKSqNIW5Cd0h0=;
 b=k3AJ00g+ZWFE371D5Su+gd9IKUghG4C2Un1SAmfIBqJDPxpEkSKaL3vj5xg1Z5CjSZN+wHQLwviv/0rLXF66JuGBh3COxTfrNFoFpWc5R7dSYNpfLCfzrqWiigviDD9IZ2jJHRYaevrNOf4diZFlDoLFmbb8wEsMzD2J34bDW5A=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Tue, 29 Mar
 2022 05:22:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12%6]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 05:22:12 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
In-reply-to: <20220324221406.GL1544202@dread.disaster.area>
Message-ID: <87sfr1nxj7.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 29 Mar 2022 10:52:04 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0071.apcprd02.prod.outlook.com
 (2603:1096:404:e2::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6198fed-d59e-4a98-b0f1-08da11441468
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4696B50BB5FA1936BBA1FCE2F61E9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5pTDevbA8I45kQ8n18hINMVcLaU1NwpVmpGVIbHhswLivkKTbwA+NgVsaq20Pf+TW8jmAwPrACzcSuEqNDLW93a4vKHYBNf3+wHkAkU+WmNgH8WMC/0XlKdG3xceePIZM4JoN0elg2OkMzMZWX8q+X7vsiNBYG/2micdm652PChHCrNNG/beZ60SyG1jj9uhuux/6Brznhpq0vRZ2wS9/2SEsYZCS+wQe7BaTAnegoFA9fArtZJ8cQJ9ynna6FeXIqklt43niH5snxNqqjDzHW7EU+EIQswbtEodKiAvmdkx46SiU0dnXUJR+z9pF3upMSWH/5WbZp9HgE6z4gQr0lUyI3YaOv5gaEorg1dQzfWzqSy/xjkFbNfBxxXk3jJAEAEO/eprv+UO1HHrlOu5gfSkVg+EZrpUITZLe1vgYZKQ6jF2S1FC2+IbDVUACsYxssys7Vm0nrlwGUoWWHiemmMPHevFR2wKjGtdBsYaS2KsQnkzAIKQLJyav9PVAt/R9VRa7o9/0wedFyZZMmBQQtgGDOxpIPpsrb6kofE4Di3qS+g7rZ/FOj0qt0llyIaECS65dglPODlv20i1vtiT8RNCaYr7PJQVMkogvvjcZX5o54yKUkdFWa8GrzIq4wdmciGhZpPgRr457GcY25bsJlLCCOLURyAxyAxiNg2XqQC7ZofRfba4AZFEGukFO8zDKMHf+p9YPAC/8K2Ml12wfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(6916009)(316002)(2906002)(6506007)(6512007)(9686003)(6666004)(508600001)(86362001)(186003)(33716001)(6486002)(52116002)(26005)(53546011)(66946007)(8676002)(8936002)(38100700002)(4326008)(66556008)(38350700002)(66476007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WTgFyqzntqZ28IzgQ7dudDTjqjA3d5XxeTMfjb7ZfFr4vWWo5TmQT/9GXO3c?=
 =?us-ascii?Q?eXxSIByTvd0TU3TO3H44AiTKSJyUiBdod8HQLrsMIZcTsZmAC0X2ACPtTuCN?=
 =?us-ascii?Q?dYRCskD2rPUjRa2jUtV/PMm0uOhZYSbQvF/QVh8GaE/beaMg/h4CwqNIGozE?=
 =?us-ascii?Q?z3WHZV8ETGX7aDLflVEICXzrGTK8M844xsBIf4m2LCFjaVS2rLCUaLNBfW6h?=
 =?us-ascii?Q?TGgdQ6nNL9D7auz/NbeBsQ/BPwoY6wDtDUXIK5eHgs8S+V/KVx6M3m32060p?=
 =?us-ascii?Q?Xkt+z/pYgppIt2ZnfRW+HpdJ4UeDL1gyhRqLoVFUs8jD5w5qiVHIqmpqPGWe?=
 =?us-ascii?Q?/UuOX66SLQzwAflrmQdNgx2wzN8tC7syLNcmkYUCVYyF7bg4PX1X5RcNxHat?=
 =?us-ascii?Q?fPajIA04TY7+oQuFL7wf/ZGO10vyTHcWJMOL8lK0bQtvb+oxJgdnjzvqOyBx?=
 =?us-ascii?Q?4W/hwzhsEoXB7aWxE09J4b1FhUPce65wI3HLUVOunlSzE602jdzO6C7fxqNz?=
 =?us-ascii?Q?oiKdPkmcY8yy5FVBMMNsVQZsmtaE77PIdZTBXgCuy4sXo0jbC7zIyTna3liP?=
 =?us-ascii?Q?CbBe3go6lEMUVzUUAS0LUA7g/eqIDRanDwwDSWLc6VlJLSxe88IVJJC01pup?=
 =?us-ascii?Q?yakf3pzAU8UZhtw6gOZsO/BbCsNm//rWevDz1nTygKKfgii6zEhH9PqU7zSu?=
 =?us-ascii?Q?TPBB7v/5R++/+zL2X/fusavxJJKowwqEKax9ykGiurM0mODvafA0/Rjmycyp?=
 =?us-ascii?Q?0b7pIpLbI+ayps+9QTlQ8ylYr7ctlfU496PRTwEuTeHxCeyaAFkNJ4RnjIBj?=
 =?us-ascii?Q?aSKhYls0qqVMnOjm+AmxDizdExkfCCLUdcqaq642qNZlwL/idTEWerIzACLt?=
 =?us-ascii?Q?kwKN520RTHqyPGgtqdefYuvczrYG2utWGKP839wsH3htF84FqhSkaWQtR25U?=
 =?us-ascii?Q?vFOU7S3V8q+p7xSVnuuHMWE0H+Xqs0FvhgNOsgHh+VfnEfBB9Bwn2k5x4ZSW?=
 =?us-ascii?Q?mkMT7skN/flolcp0V3moHfzROfC1yj3Tp1H46HNNpDkotlLr8C5ZhVkeOae4?=
 =?us-ascii?Q?VimFuzk8ymlBfIhBVwAsZ4zFC8PELIlMx8XQ3yePrz9iqwVDCFecHrIObwWQ?=
 =?us-ascii?Q?/AfPMf56vbCOGo1GLOWXpI1OkvxWq9eLOiqYiup5CDtHqBGWd5yz9+yuj4eA?=
 =?us-ascii?Q?gvjdyiZgirPLPAdaa8tKOKCUEGR9ihM33h2WGUdsvUOmzxwiNxTaqN88Od64?=
 =?us-ascii?Q?JB5q8GK/gFhiJ2Oswlr7OzcLLz5XiVr7XzLHznAnupcuxAl4NO3oUNo1Jr+F?=
 =?us-ascii?Q?GowzjFDINUVmctl/Lx/XdncUQGhXQG5oMl9whbqVWV+qosRlnt057Mw+/g2u?=
 =?us-ascii?Q?AR2PCfhEjBETiYGk2LI9CUMf8V/EGhpR0OIfjfsta6on7lC2JrhAEtuLaOxY?=
 =?us-ascii?Q?8XrVrPowA4B1y5blGyen5b+lURnWYRiE52OCkkpXBe97e0L0xV5v74a5/nFm?=
 =?us-ascii?Q?n49IvkrlBOmv3FW1Q9mzG79JwwSHD5APcl37syXqDDHi1f6CS7noXkNuiQUr?=
 =?us-ascii?Q?4bS5oYGcN2VP4dIxspSfmwawO9mwWfhE75OFccHguRJkN/N3aVFEpR0dFqkz?=
 =?us-ascii?Q?urMKXuJLQmtr5UQzDtUtGfoiGd95PnQbVSiOfMrbVFWgr8HYrd1g0UtGLGO1?=
 =?us-ascii?Q?9tuFFAqMd3jQZiIUOygmF3Je7cL7KspeYP42Yx911tRBe28M/yHakxwVE5gw?=
 =?us-ascii?Q?8YcklbRp7w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6198fed-d59e-4a98-b0f1-08da11441468
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 05:22:12.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A65/FZh79M23LXZane4NP9zdKO5CWJxFz6pExn1KUNf5nMmg7UHwICrQntrtQ5zIwcSmHQutTQPLOKTHBawU5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10300 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=797 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290032
X-Proofpoint-GUID: Ly7LGSSC2cVXZ8aG2ZnKN67_pOV5gPGj
X-Proofpoint-ORIG-GUID: Ly7LGSSC2cVXZ8aG2ZnKN67_pOV5gPGj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2022 at 03:44, Dave Chinner wrote:
> On Mon, Mar 21, 2022 at 10:47:46AM +0530, Chandan Babu R wrote:
>> The maximum file size that can be represented by the data fork extent counter
>> in the worst case occurs when all extents are 1 block in length and each block
>> is 1KB in size.
>> 
>> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
>> 1KB sized blocks, a file can reach upto,
>> (2^31) * 1KB = 2TB
>> 
>> This is much larger than the theoretical maximum size of a directory
>> i.e. 32GB * 3 = 96GB.
>> 
>> Since a directory's inode can never overflow its data fork extent counter,
>> this commit replaces checking the return value of
>> xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).
>
> I'd really prefer that we don't add noise like this to a bunch of
> call sites.  If directories can't overflow the extent count in
> normal operation, then why are we even calling
> xfs_iext_count_may_overflow() in these paths? i.e. an overflow would
> be a sign of an inode corruption, and we should have flagged that
> long before we do an operation that might overflow the extent count.
>
> So, really, I think you should document the directory size
> constraints at the site where we define all the large extent count
> values in xfs_format.h, remove the xfs_iext_count_may_overflow()
> checks from the directory code and replace them with a simple inode
> verifier check that we haven't got more than 100GB worth of
> individual extents in the data fork for directory inodes....

I don't think that we could trivially verify if the extents in a directory's
data fork add up to more than 96GB.

xfs_dinode->di_size tracks the size of XFS_DIR2_DATA_SPACE. This also includes
holes that could be created by freeing directory entries in a single directory
block. Also, there is no easy method to determine the space occupied by
XFS_DIR2_LEAF_SPACE and XFS_DIR2_FREE_SPACE segments of a directory.

May be the following can be added to xfs_dinode_verify(),

	if (S_ISDIR(mode) && ((xfs_dinode->di_size + 2 * 32GB) > 96GB))
    		return __this_address

as a rough check against possible directory inode corruption.

-- 
chandan
