Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1F2C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3477E2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:08:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Igc+J9rE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgBYTIK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:08:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36174 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgBYTIK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:08:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJ3MAK010143;
        Tue, 25 Feb 2020 19:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=NLjjaROJFUNToOjOL5le64tYJ0+s5GfAPzigtAlgZiU=;
 b=Igc+J9rEM6WCMJaE0Vw0YOs3TIt8PpGPC15tEOA95At3L4m/nn4Dpdy2wCh0xwNaLoLm
 SRCV2Vd6qJMGJSyCVN/3nHIZ1dw30bkWxeUgOquEz11wa1ij6MySppu/aKdh08p4nLA3
 MvYhljvUDhaLFua/JIL4zVLgTjlCNZM6uvA9pfO9pEiSs0d2yc67FlnmXezGmi/UfiDI
 tdAQTLrUq/W41ycQNsU9s4bkvMOEV85ZP39TX9BZZQkplMe3L+95xDHyeRZH16v2OOJP
 rWBfWc9LzkgDb7AQnXwihawjY0ZQd8baBDcxp2tg6tPGfOh1BQSUV4geLxyRc2gvDuui iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2yd0njkgf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:08:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJ295b164470;
        Tue, 25 Feb 2020 19:08:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yd09b9hqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:08:06 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PJ8534007022;
        Tue, 25 Feb 2020 19:08:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 11:08:05 -0800
Date:   Tue, 25 Feb 2020 11:08:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qian Cai <cai@lca.pw>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix an undefined behaviour in _da3_path_shift
Message-ID: <20200225190804.GP6740@magnolia>
References: <1582641477-4011-1-git-send-email-cai@lca.pw>
 <20200225152805.GG6740@magnolia>
 <1582645616.7365.118.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1582645616.7365.118.camel@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=31
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=31 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 10:46:56AM -0500, Qian Cai wrote:
> On Tue, 2020-02-25 at 07:28 -0800, Darrick J. Wong wrote:
> > On Tue, Feb 25, 2020 at 09:37:57AM -0500, Qian Cai wrote:
> > > state->path.active could be 1 in xfs_da3_node_lookup_int() and then in
> > > xfs_da3_path_shift() could see state->path.blk[-1].
> > 
> > Under what circumstancs can it be 1?  Is this a longstanding bug in XFS?
> > A corrupted filesystem?  A deliberately corrupted filesystem?
> 
> in xfs_da3_node_lookup_int(),
> 
> 	for (blk = &state->path.blk[0], state->path.active = 1;
> 			 state->path.active <= XFS_DA_NODE_MAXDEPTH;
> 			 blk++, state->path.active++) {
> <snip>
> 		if (magic == XFS_ATTR_LEAF_MAGIC ||
> 		    magic == XFS_ATTR3_LEAF_MAGIC) {
> 			blk->magic = XFS_ATTR_LEAF_MAGIC;
> 			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
> 			break;
> 		}
> 
> 		if (magic == XFS_DIR2_LEAFN_MAGIC ||
> 		    magic == XFS_DIR3_LEAFN_MAGIC) {
> 			blk->magic = XFS_DIR2_LEAFN_MAGIC;
> 			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
> 							      blk->bp, NULL);
> 			break;
> 
> Isn't that if the first iteration in the loop calls any of those "break", it
> will have state->path.active = 1 ?

Yes.  The commit message ought to state that active == 1 is a valid
state when we're trying to add an entry to a single dir leaf block and
are trying to shift forward to see if there's a sibling block that would
be a better place to put the new entry.

This is to build confidence in future readers that we actually
understood the circumstances of the UBSAN error and aren't just
monkeypatching the code to shut up the automated checks.

--D

> I suppose this is a long-standing bug that need UBSAN (no obvious harm could be
> done later because it will bail out immediately in xfs_da3_path_shift()) and a
> set of specific conditions to met to trigger.
> 
> > 
> > > 
> > >  UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_da_btree.c:1989:14
> > >  index -1 is out of range for type 'xfs_da_state_blk_t [5]'
> > >  Call trace:
> > >   dump_backtrace+0x0/0x2c8
> > >   show_stack+0x20/0x2c
> > >   dump_stack+0xe8/0x150
> > >   __ubsan_handle_out_of_bounds+0xe4/0xfc
> > >   xfs_da3_path_shift+0x860/0x86c [xfs]
> > >   xfs_da3_node_lookup_int+0x7c8/0x934 [xfs]
> > >   xfs_dir2_node_addname+0x2c8/0xcd0 [xfs]
> > >   xfs_dir_createname+0x348/0x38c [xfs]
> > >   xfs_create+0x6b0/0x8b4 [xfs]
> > >   xfs_generic_create+0x12c/0x1f8 [xfs]
> > >   xfs_vn_mknod+0x3c/0x4c [xfs]
> > >   xfs_vn_create+0x34/0x44 [xfs]
> > >   do_last+0xd4c/0x10c8
> > >   path_openat+0xbc/0x2f4
> > >   do_filp_open+0x74/0xf4
> > >   do_sys_openat2+0x98/0x180
> > >   __arm64_sys_openat+0xf8/0x170
> > >   do_el0_svc+0x170/0x240
> > >   el0_sync_handler+0x150/0x250
> > >   el0_sync+0x164/0x180
> > > 
> > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > ---
> > >  fs/xfs/libxfs/xfs_da_btree.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > > index 875e04f82541..0906b7748a3f 100644
> > > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > > @@ -1986,7 +1986,11 @@ static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
> > >  	ASSERT(path != NULL);
> > >  	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> > >  	level = (path->active-1) - 1;	/* skip bottom layer in path */
> > > -	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
> > > +
> > > +	if (level >= 0)
> > > +		blk = &path->blk[level];
> > 
> > ...because if the reason is "corrupt metadata" then perhaps this should
> > return -EFSCORRUPTED?  But I don't know enough about the context to know
> > the answer to that question.
> > 
> > --D
> > 
> > > +
> > > +	for (; level >= 0; blk--, level--) {
> > >  		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
> > >  					   blk->bp->b_addr);
> > >  
> > > -- 
> > > 1.8.3.1
> > > 
