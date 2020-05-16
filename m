Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAB9C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95B620756
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NQdQcquP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgEPRDy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:03:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgEPRDy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:03:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GGw8Jh159748;
        Sat, 16 May 2020 17:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0RiUe0USaQ8yDj6QQvZk/+7CR1OYuywHopTF5Rp3dqY=;
 b=NQdQcquPD8P72ZuzWvspfZLLsBrjk1AWd6Prts5EdB4JfBZ7iyj6KaUtR4f904mtGXdv
 BZnt/5RPRDY1WipEUYupIYYpSrtB8SOdME5VV46AllWMqk/qXRDnlKPcA9IptTiBg1WK
 rF8shGS0bU+j1xUPS9WEUy0g/3by6OcI9P3NNYSvrd0vYkZXumY6NExtLoVfWDH+HeO3
 RTw2b+CQIO8i54uIDnYgHSdb7nSWJTkrNkdRONSMjUn29buyLT/zc2sNRWEkq200MTnU
 qf1QAkMeT06lYIdjqfEMi5AX/oWBaHlAaxdpBD6kh5tliPsxd5LHJPN++jHmQcAwVNky pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tn19fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:03:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GGwBJC112383;
        Sat, 16 May 2020 17:01:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31259rey5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:01:45 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04GH1jtk019172;
        Sat, 16 May 2020 17:01:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:01:44 -0700
Date:   Sat, 16 May 2020 10:01:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: move the fork format fields into struct
 xfs_ifork
Message-ID: <20200516170143.GO1984748@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-6-hch@lst.de>
 <20200514212541.GL6714@magnolia>
 <20200516135807.GA14540@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516135807.GA14540@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 16, 2020 at 03:58:08PM +0200, Christoph Hellwig wrote:
> On Thu, May 14, 2020 at 02:25:41PM -0700, Darrick J. Wong wrote:
> 
> [~1000 lines of fullquote deleted until I hit the first comment, sigh..]
> 
> > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > index 157f72efec5e9..dfa1533b4edfc 100644
> > > --- a/fs/xfs/scrub/bmap.c
> > > +++ b/fs/xfs/scrub/bmap.c
> > > @@ -598,7 +598,7 @@ xchk_bmap_check_rmaps(
> > >  		size = 0;
> > >  		break;
> > >  	}
> > > -	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
> > > +	if (ifp->if_format != XFS_DINODE_FMT_BTREE &&
> > 
> > ifp can be null here if bmapbt scrub is called on a file that has no
> > xattrs; this crashed my test vm immediately...
> 
> What tests is that?  And xfstests auto run did not hit it, even if a
> NULL check here seems sensible.

In my case it was the xfs_scrub run after generic/001 that did it.

I think we're covered against null *ifp in most cases because they're
guarded by an if(XFS_IFORK_Q()); it's jut here where I went around
shortcutting.  Maybe I should just fix this function for you... :)

--D
