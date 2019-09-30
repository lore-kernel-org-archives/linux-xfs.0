Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AEAC388F3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 02:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3EF220842
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 02:01:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nmvD7C9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfJACBt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 22:01:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45474 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfJACBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 22:01:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UK9n2M187348;
        Mon, 30 Sep 2019 20:15:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bNo7zEAR91pwgNPmSu8jzjuUdq53lNGl7t7fgXTxww8=;
 b=nmvD7C9Gjv8fNz1RxVvxj/rFIidukpl4c2VWzwTK+MdEB4tOD4u8UXOfmNMduBocnvfA
 TITGn6iWheHfa5LlGtqOZFEiIKk4BWzYiT/NRLpClAA+j3pjx5Fqt+/F1yVcgkTWXPhg
 t2hyURKlu0C8Keh6tJYiEe7tCWJVlH8hDxNbU8lbFfyM2cdYDGMuLoOR+i5efdKTw8Ky
 6HvDzH6lATW2VgxlczU1TBgZJ1WteaOrRYQNXrr9fhYK9ePNKMOzRVLJCPQT7qaS+fOt
 xJpqCX4jWVtDgBFqTqdV496sDiSQKHS1E2GcLe3VzbeNLRwBhoOUXdbiXUq6yb55PIhu bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfq1nff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 20:15:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UK8alV160790;
        Mon, 30 Sep 2019 20:15:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vbmpwxmr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 20:15:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8UKFBsS011492;
        Mon, 30 Sep 2019 20:15:12 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 13:15:11 -0700
Date:   Mon, 30 Sep 2019 13:15:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_io: add a bulkstat command
Message-ID: <20190930201510.GC66746@magnolia>
References: <156944717403.297551.9871784842549394192.stgit@magnolia>
 <156944718001.297551.8841062987630720604.stgit@magnolia>
 <fd86aa65-2473-d316-80d9-944100519f77@sandeen.net>
 <20190927041852.GP9916@magnolia>
 <3cdfef3d-724b-e786-131b-98454b600881@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cdfef3d-724b-e786-131b-98454b600881@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 03:02:27PM -0500, Eric Sandeen wrote:
> On 9/26/19 11:18 PM, Darrick J. Wong wrote:
> >>> +
> >>> +	inumbers_cmd.args =
> >>> +		_("[-a agno] [-d] [-e endino] [-n batchsize] [-s startino]");
> >> <missing the -v option>
> >>
> >>> +	inumbers_cmd.oneline = _("Query inode groups in a filesystem");
> >> I'm confused, why aren't all these ^^^ just in the structure definitions?
> > All of these ... what?  I'm confused, sorry.
> > 
> 
> I'm wondering why these 2 fields get set up in bulkstat_init(), vs at
> cmdinfo_t structure definition time, i.e.
> 
> static cmdinfo_t        inumbers_cmd = {
>         .name = "inumbers",
>         .cfunc = inumbers_f,
>         .argmin = 0,
>         .argmax = -1,
>         .flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT,
>         .args =
> _("[-a agno] [-d] [-e endino] [-n batchsize] [-s startino] [-v version]");
>         .oneline = _("Query inode groups in a filesystem");
>         .help = inumbers_help,
> };
> 
> like ~every other command does?

[repeating irc conversation]

_() is a function, but static initializers require constant rvalues.

--D

> 
> 
> -Eric
