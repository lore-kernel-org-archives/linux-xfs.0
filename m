Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57248CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 21:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DDB420663
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 21:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="O21Yy41b";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ifbqgiU1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfJXVxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 17:53:19 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46997 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726279AbfJXVxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 17:53:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 36AB151B;
        Thu, 24 Oct 2019 17:53:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 24 Oct 2019 17:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        nBmR07ovLKF3YWzVsuEbPsX5QaBnktYPyCQwbG8NkyU=; b=O21Yy41b/4FzZa+P
        iwZP35RcuKy7kPC5jcjK5Tgl+K/tM32klLlTzqpO1BDsqhm3GpMLX08qbPiZTva6
        ulUzgOktlgPs9uOkJiJ5KfnAaJ2TJPvbVPTYGKuvVIqfGZr8BQBoFaAJIfNJPMta
        Pgujyh1BkI4lYyxg0jomJM2Ya6y3l1TCiKYZHNVnIoicxEv2GZ+nFv++N3h8vDpd
        CjIfxUvAJpzZBLHYQzixwnFl5HibitldqlUKsXIsdOGXwUvzqDg/sA/wC1sGyeCZ
        tbxSdKruWMC1OBdeEAF7QwH5CaZAZDZx6uvy6kN8S4BowNtRR7uJGx5P6zxaWZhT
        7LoxyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=nBmR07ovLKF3YWzVsuEbPsX5QaBnktYPyCQwbG8Nk
        yU=; b=ifbqgiU17irQb3P/8qYcN5OyryR8QNSVm3TRH3TCmn0LC5AmrNWwoE5X3
        AdnfOgMjLlT8TmIA2DmgKUQ7rNokbfv9oejNiVMaLg0aL82AY0g1nOhCY5CI5JSJ
        Ebr7dIEBy2vKVKPLnLJ+kGvDihGpVR6a5gyaz86+4JAWo9uhYrI6LW8DkCfVvbMC
        yq4zxSYxNy32+KMiaQyY9Yt6owgnc3kbSRClJyp1xTnn/+MRxWtiq7d+tp4jWc3f
        8uBQy2VOlqKcMUzNB4fIFn/VYWv6gS0wpaTTS3+7WBp1cadMNqZOCsgnjaL48Wdf
        vPUL4bsRMWCLSORon+DmyVN3C3BAg==
X-ME-Sender: <xms:Sx2yXW2V1CjpIxRC-IWAfW2dAbGV2cl0Ik6CkB9ZQ4Ae_FzvLe0b3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrledvgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dukeejrdefvdenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Sx2yXdWCZEjiEXyk1Jg0KvmUQ5k_3Y_DLeEK4D17sFAdVBkffrhxsw>
    <xmx:Sx2yXZ7_XTRdmuY-c8UKJdM97Q3gk4dApmzstO3UBL_afJoUXHUQGQ>
    <xmx:Sx2yXcLTVHhM2tll32cUyOjrztkzHGmJyj1Yje2VSyRCAugJiH1EIA>
    <xmx:TB2yXdNOXGdgbXnOFC8I1Iu_n_d7MqAawXOQDp_S_y1MHmshyFOSzg>
Received: from donald.themaw.net (unknown [118.208.187.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B75CD6005E;
        Thu, 24 Oct 2019 17:53:11 -0400 (EDT)
Message-ID: <90501efd6808a0816dbdf03b508130136bc8a94e.camel@themaw.net>
Subject: Re: [PATCH v7 09/17] xfs: add xfs_remount_rw() helper
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 25 Oct 2019 05:53:08 +0800
In-Reply-To: <20191024153123.GS913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
         <157190348247.27074.12897905716268545882.stgit@fedora-28>
         <20191024153123.GS913374@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-10-24 at 08:31 -0700, Darrick J. Wong wrote:
> On Thu, Oct 24, 2019 at 03:51:22PM +0800, Ian Kent wrote:
> > Factor the remount read write code into a helper to simplify the
> > subsequent change from the super block method .remount_fs to the
> > mount-api fs_context_operations method .reconfigure.
> > 
> > This helper is only used by the mount code, so locate it along with
> > that code.
> > 
> > While we are at it change STATIC -> static for
> > xfs_restore_resvblks().
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_super.c |  119 +++++++++++++++++++++++++++++-----------
> > ------------
> >  1 file changed, 67 insertions(+), 52 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 297e6c98742e..c07e41489e75 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -47,6 +47,8 @@ static struct kset *xfs_kset;		/* top-
> > level xfs sysfs dir */
> >  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs
> > attrs */
> >  #endif
> >  
> > +static void xfs_restore_resvblks(struct xfs_mount *mp);
> 
> What's the reason for putting xfs_remount_rw above
> xfs_restore_resvblks?
> I assume that's related to where you want to land later code chunks?

In the cover letter:

Note: the patches "xfs: add xfs_remount_rw() helper" and
 "xfs: add xfs_remount_ro() helper" that have Reviewed-by attributions
 each needed a forward declartion added due grouping all the mount
 related code together. Reviewers may want to check the attribution
 is still acceptable.

The fill super method needs quite a few more forward declarations
too.

I responded to Christoph's suggestion of grouping the mount code
together saying this would be needed, and that I thought the
improvement of grouping the code together was worth the forward
declarations, and asked if anyone had a different POV on it and
got no replies, ;)

The other thing is that the options definitions notionally belong
near the top of the mount/super block handling code so moving it
all down seemed like the wrong thing to do ...

So what do you think of the extra noise of forward declarations
in this case?

Ian

> 
> --D
> 
> > +
> >  /*
> >   * Table driven mount option parser.
> >   */
> > @@ -455,6 +457,68 @@ xfs_mount_free(
> >  	kmem_free(mp);
> >  }
> >  
> > +static int
> > +xfs_remount_rw(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> > +	int			error;
> > +
> > +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > +		xfs_warn(mp,
> > +			"ro->rw transition prohibited on norecovery
> > mount");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > +	    xfs_sb_has_ro_compat_feature(sbp,
> > XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > +		xfs_warn(mp,
> > +	"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > filesystem",
> > +			(sbp->sb_features_ro_compat &
> > +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> > +		return -EINVAL;
> > +	}
> > +
> > +	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > +
> > +	/*
> > +	 * If this is the first remount to writeable state we might
> > have some
> > +	 * superblock changes to update.
> > +	 */
> > +	if (mp->m_update_sb) {
> > +		error = xfs_sync_sb(mp, false);
> > +		if (error) {
> > +			xfs_warn(mp, "failed to write sb changes");
> > +			return error;
> > +		}
> > +		mp->m_update_sb = false;
> > +	}
> > +
> > +	/*
> > +	 * Fill out the reserve pool if it is empty. Use the stashed
> > value if
> > +	 * it is non-zero, otherwise go with the default.
> > +	 */
> > +	xfs_restore_resvblks(mp);
> > +	xfs_log_work_queue(mp);
> > +
> > +	/* Recover any CoW blocks that never got remapped. */
> > +	error = xfs_reflink_recover_cow(mp);
> > +	if (error) {
> > +		xfs_err(mp,
> > +			"Error %d recovering leftover CoW
> > allocations.", error);
> > +			xfs_force_shutdown(mp,
> > SHUTDOWN_CORRUPT_INCORE);
> > +		return error;
> > +	}
> > +	xfs_start_block_reaping(mp);
> > +
> > +	/* Create the per-AG metadata reservation pool .*/
> > +	error = xfs_fs_reserve_ag_blocks(mp);
> > +	if (error && error != -ENOSPC)
> > +		return error;
> > +
> > +	return 0;
> > +}
> > +
> >  struct proc_xfs_info {
> >  	uint64_t	flag;
> >  	char		*str;
> > @@ -1169,7 +1233,7 @@ xfs_save_resvblks(struct xfs_mount *mp)
> >  	xfs_reserve_blocks(mp, &resblks, NULL);
> >  }
> >  
> > -STATIC void
> > +static void
> >  xfs_restore_resvblks(struct xfs_mount *mp)
> >  {
> >  	uint64_t resblks;
> > @@ -1307,57 +1371,8 @@ xfs_fs_remount(
> >  
> >  	/* ro -> rw */
> >  	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY))
> > {
> > -		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > -			xfs_warn(mp,
> > -		"ro->rw transition prohibited on norecovery mount");
> > -			return -EINVAL;
> > -		}
> > -
> > -		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > -		    xfs_sb_has_ro_compat_feature(sbp,
> > -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN))
> > {
> > -			xfs_warn(mp,
> > -"ro->rw transition prohibited on unknown (0x%x) ro-compat
> > filesystem",
> > -				(sbp->sb_features_ro_compat &
> > -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN))
> > ;
> > -			return -EINVAL;
> > -		}
> > -
> > -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > -
> > -		/*
> > -		 * If this is the first remount to writeable state we
> > -		 * might have some superblock changes to update.
> > -		 */
> > -		if (mp->m_update_sb) {
> > -			error = xfs_sync_sb(mp, false);
> > -			if (error) {
> > -				xfs_warn(mp, "failed to write sb
> > changes");
> > -				return error;
> > -			}
> > -			mp->m_update_sb = false;
> > -		}
> > -
> > -		/*
> > -		 * Fill out the reserve pool if it is empty. Use the
> > stashed
> > -		 * value if it is non-zero, otherwise go with the
> > default.
> > -		 */
> > -		xfs_restore_resvblks(mp);
> > -		xfs_log_work_queue(mp);
> > -
> > -		/* Recover any CoW blocks that never got remapped. */
> > -		error = xfs_reflink_recover_cow(mp);
> > -		if (error) {
> > -			xfs_err(mp,
> > -	"Error %d recovering leftover CoW allocations.", error);
> > -			xfs_force_shutdown(mp,
> > SHUTDOWN_CORRUPT_INCORE);
> > -			return error;
> > -		}
> > -		xfs_start_block_reaping(mp);
> > -
> > -		/* Create the per-AG metadata reservation pool .*/
> > -		error = xfs_fs_reserve_ag_blocks(mp);
> > -		if (error && error != -ENOSPC)
> > +		error = xfs_remount_rw(mp);
> > +		if (error)
> >  			return error;
> >  	}
> >  
> > 

