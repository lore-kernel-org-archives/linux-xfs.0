Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25F7C432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 05:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C3CD217F4
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 05:19:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="LPFbL2ag";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dzQYIh+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411739AbfIYFT2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 01:19:28 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:38065 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411738AbfIYFT1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 01:19:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A2E9847C;
        Wed, 25 Sep 2019 01:19:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 25 Sep 2019 01:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        sCCIKKAoaVzCiSvtMWQJfw7DpZxzPNULX+XaXZSDHcc=; b=LPFbL2agV+jtI2R0
        HNOMUYXQijYh587mtwWHgtalNhEDEHk38IP7JkSUOpONqC1uFOZ1+Sd5IiBYwEIb
        GchVnSRiRp0fbLhlaVP2JgdVPaJL4JgMrAKpVjRGtMr24+8Yse+lxUUvYETQsuyH
        q1VKBBRkOqdEcePlHZLEyPS8RZwKsrw38511hAvJ0Cfi6iO/LEmFkW7Ld9HY60ES
        hwFv70OuWRJpKHbZDX4ANIF+UvQ7UdvoMJ6fOhQQNk3vqmsJC2WSAPDlp4wJYy60
        fT5wcCFVPTAMV7X5gF4AZW27O51SQZ8K6umQnYbF/b+okY2roLoFIDa5ilwH8TQ+
        EFn8+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=sCCIKKAoaVzCiSvtMWQJfw7DpZxzPNULX+XaXZSDH
        cc=; b=dzQYIh+PZtlQ60wfp/LlN+vY7BR6UV5Utm7n0KC6nsmI3tbYgYFiNSSBi
        RLGXMh46HExRd+thdIPmf18P23uhSzhH4aS7yaqxrDBH+i5qCZlPL26fhgNzLZ1R
        qAkb445GCSCZedobKr8UN2/9jy3+Ln44UkWjY0b4d7a2u6I5B2vLeJE2vsYzn4qy
        YzUv3AowUyxIjfFisfxKFr0lKkVM9b6SNAcws2OuL8nSbtZ/DkuoNo+2RyHMlW6e
        c836bzct0psEAip7pcLfdTKoeyWiEJQugmY6pQYGYNWEnxTXPvnKGnj2saX44Sul
        FzL8b+AIcccySIzHkHd5j90Zk4zWg==
X-ME-Sender: <xms:3fiKXXAx4qIn-307c104ZAi3IZxmlQbIhyccZU99KhKPVo4Id4YhVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdelhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    duieefrddvvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3fiKXYZhNPhwfz7UAXflavGnOotJ2BOUCIZ4Y2HpT7l6k_rtUEKiYg>
    <xmx:3fiKXVcGWPstAF93yXESAHbXf7RbNubeZZj006ojv7myPUppKT_bcw>
    <xmx:3fiKXTeSAi_HgHarBzHzFG8PlMm07QXU5-ZUngDyuE6mWhR6I4y7Uw>
    <xmx:3viKXbk7ET5-Sv1ff-aawTdgKYMMiO7gLYpoyw2HowP3-W4tj93VoQ>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE69F8005C;
        Wed, 25 Sep 2019 01:19:22 -0400 (EDT)
Message-ID: <359eb242396b8ed10591477267fef34e9cbdd21d.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 11/16] xfs: mount-api - add xfs_remount_ro()
 helper
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Wed, 25 Sep 2019 13:19:19 +0800
In-Reply-To: <20190924143835.GE17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933137949.20933.11551905065222062958.stgit@fedora-28>
         <20190924143835.GE17688@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 10:38 -0400, Brian Foster wrote:
> On Tue, Sep 24, 2019 at 09:22:59PM +0800, Ian Kent wrote:
> > Factor the remount read only code into a helper to simplify the
> > subsequent change from the super block method .remount_fs to the
> > mount-api fs_context_operations method .reconfigure.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> 
> This (and the next patch) looks exactly like the previous version
> (please retain review tags).

Right, will do.

> 
> Brian
> 
> >  fs/xfs/xfs_super.c |   73 +++++++++++++++++++++++++++++++---------
> > ------------
> >  1 file changed, 43 insertions(+), 30 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index aaee32162950..de75891c5551 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1433,6 +1433,47 @@ xfs_remount_rw(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_remount_ro(
> > +	struct xfs_mount	*mp)
> > +{
> > +	int error;
> > +
> > +	/*
> > +	 * Cancel background eofb scanning so it cannot race with the
> > +	 * final log force+buftarg wait and deadlock the remount.
> > +	 */
> > +	xfs_stop_block_reaping(mp);
> > +
> > +	/* Get rid of any leftover CoW reservations... */
> > +	error = xfs_icache_free_cowblocks(mp, NULL);
> > +	if (error) {
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		return error;
> > +	}
> > +
> > +	/* Free the per-AG metadata reservation pool. */
> > +	error = xfs_fs_unreserve_ag_blocks(mp);
> > +	if (error) {
> > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +		return error;
> > +	}
> > +
> > +	/*
> > +	 * Before we sync the metadata, we need to free up the reserve
> > +	 * block pool so that the used block count in the superblock on
> > +	 * disk is correct at the end of the remount. Stash the current
> > +	 * reserve pool size so that if we get remounted rw, we can
> > +	 * return it to the same size.
> > +	 */
> > +	xfs_save_resvblks(mp);
> > +
> > +	xfs_quiesce_attr(mp);
> > +	mp->m_flags |= XFS_MOUNT_RDONLY;
> > +
> > +	return 0;
> > +}
> > +
> >  STATIC int
> >  xfs_fs_remount(
> >  	struct super_block	*sb,
> > @@ -1503,37 +1544,9 @@ xfs_fs_remount(
> >  
> >  	/* rw -> ro */
> >  	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY))
> > {
> > -		/*
> > -		 * Cancel background eofb scanning so it cannot race
> > with the
> > -		 * final log force+buftarg wait and deadlock the
> > remount.
> > -		 */
> > -		xfs_stop_block_reaping(mp);
> > -
> > -		/* Get rid of any leftover CoW reservations... */
> > -		error = xfs_icache_free_cowblocks(mp, NULL);
> > -		if (error) {
> > -			xfs_force_shutdown(mp,
> > SHUTDOWN_CORRUPT_INCORE);
> > -			return error;
> > -		}
> > -
> > -		/* Free the per-AG metadata reservation pool. */
> > -		error = xfs_fs_unreserve_ag_blocks(mp);
> > -		if (error) {
> > -			xfs_force_shutdown(mp,
> > SHUTDOWN_CORRUPT_INCORE);
> > +		error = xfs_remount_ro(mp);
> > +		if (error)
> >  			return error;
> > -		}
> > -
> > -		/*
> > -		 * Before we sync the metadata, we need to free up the
> > reserve
> > -		 * block pool so that the used block count in the
> > superblock on
> > -		 * disk is correct at the end of the remount. Stash the
> > current
> > -		 * reserve pool size so that if we get remounted rw, we
> > can
> > -		 * return it to the same size.
> > -		 */
> > -		xfs_save_resvblks(mp);
> > -
> > -		xfs_quiesce_attr(mp);
> > -		mp->m_flags |= XFS_MOUNT_RDONLY;
> >  	}
> >  
> >  	return 0;
> > 

