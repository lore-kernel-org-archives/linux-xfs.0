Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45316C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E962206B7
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 15:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p5xR70Yn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgGBPNL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 11:13:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33118 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgGBPNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 11:13:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062EvRqA018090;
        Thu, 2 Jul 2020 15:13:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fkBhnZiVd0Tony1gE/7vBe0pvzppTP1d69R2hvXUKpI=;
 b=p5xR70Ynh2Ce1W/ChYUmZH8ZKOuO3C8ogvGgCNCsj8S5mWZDOIt6FM/zblpGWTh9yid8
 EV5Au2joCeiboIe465+nEIfvP84qnq5/UPphoKlkbXz8avQIwfL9InfS8NFuQz+p2HeK
 CJ2hmpViiVM/3H/gVb7/A/rnDD9W7Q4V5AG6nZs/kPz3wl02E1QvZNB74EEa+tr8g+oy
 dER3XmNjJf+k/gfeHoda9l6QlWkp3d/J+EzmV6rKZt8D+Cq4qKxUo4MUQBJMJRzSrFYE
 h3NCnNuAbnMGG3B3QeXg78UPfbAuxkxsDzXiOAm3Pk2hqC2ExdxxbgWA4mEKCMdwES4i QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrby8q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 15:13:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062EwnTR089719;
        Thu, 2 Jul 2020 15:13:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31xg19hhng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 15:13:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 062FD5ao018044;
        Thu, 2 Jul 2020 15:13:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 15:13:04 +0000
Date:   Thu, 2 Jul 2020 08:13:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
Message-ID: <20200702151304.GA7606@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172899.2864738.6438709598863248951.stgit@magnolia>
 <20200701084208.GC25171@infradead.org>
 <20200701182508.GV7606@magnolia>
 <20200702063021.GA10046@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702063021.GA10046@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=779 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=788
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020106
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 02, 2020 at 07:30:21AM +0100, Christoph Hellwig wrote:
> On Wed, Jul 01, 2020 at 11:25:08AM -0700, Darrick J. Wong wrote:
> > > 	/*
> > > 	 * Ensure we got the type and ID we were looking for.  Everything else
> > > 	 * we checked by the verifier.
> > > 	 */
> > > 	if ((ddqp->d_flags & XFS_DQ_ALLTYPES) != dqp->dq_flags ||
> > > 	    ddqp->d_id != dqp->q_core.d_id)
> > 
> > Sounds good to me.  I'll make that change.
> 
> We also don't need the mask on the on-disk flags, as it never contains
> anything but the type, so this can be further simplified.

d_flags will contain more than the type Real Soon Now; I was planning to
send out the y2038 feature patchset (at least for another RFC) right
after landing this series.

--D
