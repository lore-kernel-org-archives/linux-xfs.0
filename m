Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15275C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D00F320673
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 05:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ztbh3Vef"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbfH0FNb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 01:13:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48364 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfH0FNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 01:13:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R58kMA128384;
        Tue, 27 Aug 2019 05:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=245JwPpCKOVEyMfBi1nP34QAG99DOkafmlONjkjSuxA=;
 b=Ztbh3VefjMkIZP3EGqMeFKBqgu5Kk1I84/pRFhvCLKA0SHmQUwreIVgjcFio0cl0ouIP
 yEuSNji1rbL7voVAckyG6rD3eKPUGVV12EjWMkDQOQeWS9e+ZXWiyxGgZ3ZmHnnWpMR3
 o7KAlfPLCLn0n/0peEba+vAJZ36+lu8sk6KIEFp0BZ6Uf3A4qzdCfPG7RffJ30XTh35o
 F0yz9Qu6NRagzCy4Z1AT0usdS7f3+7lXe9yjxqIYhs5yvuzr/0xuQ/zZQ8dg1VUPkx8c
 MHqYdNP72Gpqe8ITB4i0VRMPbVZLzBgxvmDH437hSGNuHtmfueTW2QKgW3542RYhMugX 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umw3gragm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 05:13:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R5DQML160534;
        Tue, 27 Aug 2019 05:13:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2umj27qma9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 05:13:25 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7R5CUHi003393;
        Tue, 27 Aug 2019 05:12:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 22:12:30 -0700
Date:   Mon, 26 Aug 2019 22:12:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_spaceman: embed struct xfs_fd in struct fileio
Message-ID: <20190827051229.GQ1037422@magnolia>
References: <156685442011.2839773.2684103942714886186.stgit@magnolia>
 <156685443883.2839773.16670488313525688465.stgit@magnolia>
 <20190827050636.GX1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827050636.GX1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=984
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270058
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270057
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 27, 2019 at 03:06:36PM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2019 at 02:20:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Replace the open-coded fd and geometry fields of struct fileio with a
> > single xfs_fd, which will enable us to use it natively throughout
> > xfs_spaceman in upcoming patches.
> 
> I don't see a struct xfs_fd defined anywhere, or XFS_FD_INIT() for
> that matter, as of commit 7c3f16119231 ("xfsprogs: Release
> v5.3.0-rc0").
> 
> What patchset is that in?

Today's patchbomb depends on the libfrog wrappers:
https://lore.kernel.org/linux-xfs/156633303230.1215733.4447734852671168748.stgit@magnolia/T/#t

and builds atop the xfsprogs 5.3 fixes series too:
https://lore.kernel.org/linux-xfs/156633307176.1215978.17394956977918540525.stgit@magnolia/T/#t

(though I think it mostly depends on the first series)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
