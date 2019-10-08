Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3300C47404
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 00:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD5DF20835
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 00:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lrsNd0DE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfJHAih (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 20:38:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbfJHAig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Oct 2019 20:38:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980ZBx8174799;
        Tue, 8 Oct 2019 00:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=U77D2dQkgutA7KfSQCXOC4hHjjMDgDdZqLaNIG1RC7w=;
 b=lrsNd0DEbwjgVkhfkeX1TSEEDkkcwBhUMrUa8UHaGGMzv4bBGbHLb5HgDVpqT0Xpt5gO
 HTaHrzII6pagKySf5PVdO1FaPSx+1IgFbRyyBYgh4BhMVXui3cl0uPf0jlSZjN2cXPsg
 9GvrpWMAAt1+JUqMoE7Ms/yF0syJLImbUgCwvCrcj6zX3jVYCtvj4ky+lY/kjinVKZal
 UGFbdPApsbqNTjCJhcYu0KsZ+U+kV1z2G/w39xn4Y/yR6xQiRiHwTNpC05YNrH+jeR4e
 4ar2SJ33MOilxxirzpT9Q3SYIu2z8F959AsN7uZrfEDa/rY/Clr/FOZMTom0SkaR9zrO Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4qa2gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 00:37:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x980YgHQ066462;
        Tue, 8 Oct 2019 00:35:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vgeuwkqek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Oct 2019 00:35:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x980Zo3W030063;
        Tue, 8 Oct 2019 00:35:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 17:35:49 -0700
Date:   Mon, 7 Oct 2019 17:35:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 00/17] xfs: mount API patch series
Message-ID: <20191008003548.GU13108@magnolia>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
 <20191007115246.GF22140@bfoster>
 <5693dea57f1f467c74676a0250eac15181b4af34.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5693dea57f1f467c74676a0250eac15181b4af34.camel@themaw.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910080004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910080004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 08, 2019 at 08:13:57AM +0800, Ian Kent wrote:
> On Mon, 2019-10-07 at 07:52 -0400, Brian Foster wrote:
> > On Thu, Oct 03, 2019 at 06:25:18PM +0800, Ian Kent wrote:
> > > This patch series add support to xfs for the new kernel mount API
> > > as described in the LWN article at https://lwn.net/Articles/780267/
> > > .
> > > 
> > > In the article there's a lengthy description of the reasons for
> > > adopting the API and problems expected to be resolved by using it.
> > > 
> > > The series has been applied to the repository located at
> > > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git, and built and
> > > some simple tests run on it along with the generic xfstests.
> > > 
> > 
> > I'm not sure that we have any focused mount option testing in
> > fstests.
> > It looks like we have various remount tests and such to cover corner
> > cases and/or specific bugs, but nothing to make sure various options
> > continue to work or otherwise fail gracefully. Do you have any plans
> > to
> > add such a test to help verify this work?
> 
> Darrick was concerned about that.
> 
> Some sort of xfstest is needed in order to be able to merge this
> so he has some confidence that it won't break things.
> 
> I volunteered to do have a go at writing a test.
> 
> I've given that some thought and done an initial survey of xfstests
> but it's still new to me so I'm not sure how this will end up.
> 
> Darrick thought it would need a generic test to test VFS options
> and one in xfs for the xfs specific options.
> 
> At this point I'm thinking I'll have a go at adding an xfs specific
> options test but, while I can find out what the optionsare and what
> validation they use, there's a lot about some of the xfs options
> I don't fully understand so I don't know what a sensible test might
> be.

Hm, that's evidence of inadequate documentation.  If you can't figure
out what would be sensible tests for a particular mount option from
xfs(5) then we have work to do. :)

So if you can't come up with something that seems 'reasonable' to test,
I suggest random gibberish(!) and send the outcome of those iterations
to the list to see what kinds of arguments you can stir up.  Since we're
only interested in testing the mounting code here, you can declare
victory if the fs mounts, never mind if the option actually has any
effect on fs operations.  That kind of functional testing should be in
separate tests anyway.

One advantage that you probably have over us is that our understanding
of the mount options and associated behavior is based on a lot of
experience working in the code base, whereas most everyone else's is
based entirely on whatever's in the manpage.  It's helpful to have
someone hold us to our words every now and then.

(This is going to get interesting when we get to mount options whose
validity changes depending on mkfs parameters, etc.)

--D

> > 
> > Brian
> > 
> > > Other things that continue to cause me concern:
> > > 
> > > - Message logging.
> > >   There is error logging done in the VFS by the mount-api code,
> > > some
> > >   is VFS specific while some is file system specific. This can lead
> > >   to duplicated and sometimes inconsistent logging.
> > > 
> > >   The mount-api feature of saving error message text to the mount
> > >   context for later retrieval by fsopen()/fsconfig()/fsmount()
> > > users
> > >   is the reason the mount-api log macros are present. But, at the
> > >   moment (last time I looked), these macros will either log the
> > >   error message or save it to the mount context. There's not yet
> > >   a way to modify this behaviour so it which can lead to messages,
> > >   possibly needed for debug purposes, not being sent to the kernel
> > >   log. There's also the pr_xxx() log functions (not a problem for
> > >   xfs AFAICS) that aren't aware of the mount context at all.
> > > 
> > >   In the xfs patches I've used the same method that is used in
> > >   gfs2 and was suggested by Al Viro (essentially return the error
> > >   if fs_parse() returns one) except that I've also not used the
> > >   mount api log macros to minimise the possibility of lost log
> > >   messages.
> > > 
> > >   This isn't the best so follow up patches for RFC (with a
> > >   slightly wider audience) will be needed to try and improve
> > >   this aspect of the mount api.
> > > 
> > > Changes for v4:
> > > - changed xfs_fill_super() cleanup back to what it was in v2, until
> > >   I can work out what's causing the problem had previously seen (I
> > > can't
> > >   reproduce it myself), since it looks like it was right from the
> > > start.
> > > - use get_tree_bdev() instead of vfs_get_block_super() in
> > > xfs_get_tree()
> > >   as requested by Al Viro.
> > > - removed redundant initialisation in xfs_fs_fill_super().
> > > - fix long line in xfs_validate_params().
> > > - no need to validate if parameter parsing fails, just return the
> > > error.
> > > - summarise reconfigure comment about option handling, transfer
> > > bulk
> > >   of comment to commit log message.
> > > - use minimal change in xfs_parse_param(), deffer discussion of
> > > mount
> > >   api logging improvements until later and with a wider audience.
> > > 
> > > Changes for v3:
> > > - fix struct xfs_fs_context initialisation in xfs_parseargs().
> > > - move call to xfs_validate_params() below label "done".
> > > - if allocation of xfs_mount fails return ENOMEM immediately.
> > > - remove erroneous kfree(mp) in xfs_fill_super().
> > > - move the removal of xfs_fs_remount() and
> > > xfs_test_remount_options()
> > >   to the switch to mount api patch.
> > > - retain original usage of distinct <option>, no<option> usage.
> > > - fix line length and a white space problem in xfs_parseargs().
> > > - defer introduction of struct fs_context_operations until mount
> > >   api implementation.
> > > - don't use a new line for the void parameter of xfs_mount_alloc().
> > > - check for -ENOPARAM in xfs_parse_param() to report invalid
> > > options
> > >   using the options switch (to avoid double entry log messages).
> > > - remove obsolete mount option biosize.
> > > - try and make comment in xfs_fc_free() more understandable.
> > > 
> > > Changes for v2:
> > > - changed .name to uppercase in fs_parameter_description to ensure
> > >   consistent error log messages between the vfs parser and the xfs
> > >   parameter parser.
> > > - clarify comment above xfs_parse_param() about when possibly
> > >   allocated mp->m_logname or mp->m_rtname are freed.
> > > - factor out xfs_remount_rw() and xfs_remount_ro()
> > > from  xfs_remount().
> > > - changed xfs_mount_alloc() to not set super block in xfs_mount so
> > > it
> > >   can be re-used when switching to the mount-api.
> > > - fixed don't check for NULL when calling kfree() in xfs_fc_free().
> > > - refactored xfs_parseargs() in an attempt to highlight the code
> > >   that actually changes in converting to use the new mount api.
> > > - dropped xfs-mount-api-rename-xfs_fill_super.patch, it didn't seem
> > >   necessary.
> > > - move comment about remount difficulties above xfs_reconfigure()
> > >   and increase line length to try and make the comment manageable.
> > > 
> > > Al Viro has sent a pull request to Linus for the patch containing
> > > get_tree_bdev() recently and I think there's a small problem with
> > > that patch too so there will be conflicts with merging this series
> > > without dropping the first two patches of the series.
> > > 
> > > ---
> > > 
> > > David Howells (1):
> > >       vfs: Create fs_context-aware mount_bdev() replacement
> > > 
> > > Ian Kent (16):
> > >       vfs: add missing blkdev_put() in get_tree_bdev()
> > >       xfs: remove very old mount option
> > >       xfs: mount-api - add fs parameter description
> > >       xfs: mount-api - refactor suffix_kstrtoint()
> > >       xfs: mount-api - refactor xfs_parseags()
> > >       xfs: mount-api - make xfs_parse_param() take context
> > > .parse_param() args
> > >       xfs: mount-api - move xfs_parseargs() validation to a helper
> > >       xfs: mount-api - refactor xfs_fs_fill_super()
> > >       xfs: mount-api - add xfs_get_tree()
> > >       xfs: mount-api - add xfs_remount_rw() helper
> > >       xfs: mount-api - add xfs_remount_ro() helper
> > >       xfs: mount api - add xfs_reconfigure()
> > >       xfs: mount-api - add xfs_fc_free()
> > >       xfs: mount-api - dont set sb in xfs_mount_alloc()
> > >       xfs: mount-api - switch to new mount-api
> > >       xfs: mount-api - remove remaining legacy mount code
> > > 
> > > 
> > >  fs/super.c                 |   97 +++++
> > >  fs/xfs/xfs_super.c         |  939 +++++++++++++++++++++++---------
> > > ------------
> > >  include/linux/fs_context.h |    5 
> > >  3 files changed, 600 insertions(+), 441 deletions(-)
> > > 
> > > --
> > > Ian
> 
