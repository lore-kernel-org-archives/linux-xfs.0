Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB98DC41514
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1E992186A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 19:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZlqisjAp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbfHZTPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 15:15:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729773AbfHZTPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 15:15:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QJBuAi059211;
        Mon, 26 Aug 2019 19:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6e5g+jO1D3bd86GBO+P63F3hpsVVzF4i/gwI35QJdZE=;
 b=ZlqisjAp3+zAneHg2lAMy/gVBaeMmcZw+C5oGoz5U8yI79Imk2Q/yeG2Ql8f0bSekmEa
 JK8sfC7NyMs6BPcTRtC4dsMx7M087BUi2t3TOlIOreUfUG990CwDSfkiGVqigQPFJh+/
 cnIy4S5vb6z9sDIKtrrLzvO5p41AzEAxCycmZX4u2sn+1+dOL9u4cniV1tvnt8s+cnrM
 6L9A39a2CMg6pUjWThABKk0QTmdwcoCwfPGQu6+V3RT7vQM6o8bSCXlsJuu+An4XA9ih
 lsNmbGPX1ZVgPWAC+G31H0Qiul8IZVemklgwL5ELRxxEQafZ6lan4br6cjXJcQaR0ty4 bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2umjjqs72g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 19:14:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QJDrpU040300;
        Mon, 26 Aug 2019 19:14:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2umj1tcxr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 19:14:43 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QJEgqc001191;
        Mon, 26 Aug 2019 19:14:42 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 12:14:41 -0700
Date:   Mon, 26 Aug 2019 12:14:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH] xfs: remove excess function parameter description in
 'xfs_btree_sblock_v5hdr_verify'
Message-ID: <20190826191440.GT1037350@magnolia>
References: <1566825695-90533-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566825695-90533-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260180
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 09:21:35PM +0800, zhengbin wrote:
> Fixes gcc warning:
> 
> fs/xfs/libxfs/xfs_btree.c:4475: warning: Excess function parameter 'max_recs' description in 'xfs_btree_sblock_v5hdr_verify'
> fs/xfs/libxfs/xfs_btree.c:4475: warning: Excess function parameter 'pag_max_level' description in 'xfs_btree_sblock_v5hdr_verify'
> 
> Fixes: c5ab131ba0df ("libxfs: refactor short btree block verification")
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_btree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index f1048ef..802eb53 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4466,8 +4466,6 @@ xfs_btree_lblock_verify(
>   *				      btree block
>   *
>   * @bp: buffer containing the btree block
> - * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
> - * @pag_max_level: pointer to the per-ag max level field
>   */
>  xfs_failaddr_t
>  xfs_btree_sblock_v5hdr_verify(
> --
> 2.7.4
> 
