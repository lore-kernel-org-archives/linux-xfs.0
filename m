Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EECC83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6E22072A
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GiHoeJ+W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgD1WSB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:18:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1WSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:18:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMHaG2057470;
        Tue, 28 Apr 2020 22:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wh6uc60TPeonBVO1B6GXzDgNLbRFh3bQ/M9J+SYg9Fo=;
 b=GiHoeJ+Wa61C8pqfqnoqXWSZ4SCrrB4aq4tpCXc1ypMvF9tw7Igo6qiZBvDgO5ZB490H
 QCc+Vm/2OSO7AovIg2BAg7B5/K4DKnt3w9UWKWNdNbtrZLUcWkKrt/YQcKUGLDNC7wDp
 qKlswIWl7KBa+TwakAEjUgAK5XwsejAQk40oR9rIPzJAHS6iSYGkBcvywH+MRH3gu4rA
 8tb8AXQBot+qABn5xB5T04MTtOQOuAl3fAQfi3i0gYLG41XbuN5vBg3Y8Kj4AdbELGNP
 gpyIpz9WJHTsGBOy4+JCyk7jY+qtoCfPH/ZJUfaXDO8Ft8RgXgzVR7pLtMDmjuzn7IVp Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p2p081rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:17:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMChNh094888;
        Tue, 28 Apr 2020 22:17:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30mxph559e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:17:49 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03SMHmD8012746;
        Tue, 28 Apr 2020 22:17:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:17:48 -0700
Date:   Tue, 28 Apr 2020 15:17:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200428221747.GH6742@magnolia>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
 <20200425190137.GA16009@infradead.org>
 <20200427113752.GE4577@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427113752.GE4577@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=2
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=2 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 07:37:52AM -0400, Brian Foster wrote:
> On Sat, Apr 25, 2020 at 12:01:37PM -0700, Christoph Hellwig wrote:
> > On Tue, Apr 21, 2020 at 07:08:26PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Make it so that the deferred operations freezer can save inode numbers
> > > when we freeze the dfops chain, and turn them into pointers to incore
> > > inodes when we thaw the dfops chain to finish them.  Next, add dfops
> > > item freeze and thaw functions to the BUI/BUD items so that they can
> > > take advantage of this new feature.  This fixes a UAF bug in the
> > > deferred bunmapi code because xfs_bui_recover can schedule another BUI
> > > to continue unmapping but drops the inode pointer immediately
> > > afterwards.
> > 
> > I'm only looking over this the first time, but why can't we just keep
> > inode reference around during reocvery instead of this fairly
> > complicated scheme to save the ino and then look it up again?
> > 
> 
> I'm also a little confused about the use after free in the first place.
> Doesn't xfs_bui_recover() look up the inode itself, or is the issue that
> xfs_bui_recover() is fine but we might get into
> xfs_bmap_update_finish_item() sometime later on the same inode without
> any reference?

The second.  In practice it doesn't seem to trigger on the existing
code, but the combination of atomic extent swap + fsstress + shutdown
testing was enough to push it over the edge once due to reclaim.

> If the latter, similarly to Christoph I wonder if we
> really could/should grab a reference on the inode for the intent itself,
> even though that might not be necessary outside of recovery.

Outside of recovery we don't have the UAF problem because there's always
something (usually the VFS dentry cache, but sometimes an explicit iget)
that hold a reference to the inode for the duration of the transaction
and dfops processing.

One could just hang on to all incore inodes until the end of recovery
like Christoph says, but the downside of doing it that way is that now
we require enough memory to maintain all that incore state vs. only
needing enough for the incore inodes involved in a particular dfops
chain.  That isn't a huge deal now, but I was looking ahead to atomic
extent swaps.

(And, yeah, I should put that series on the list now...)

> Either way, more details about the problem being fixed in the commit log
> would be helpful.

<nod>

--D

> Brian
> 
