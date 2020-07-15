Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6DEC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D4AB20791
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 20:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sq4cX2uw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgGOUo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:44:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725917AbgGOUo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 16:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594845896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g2a4L43mlHm14M81VigWm8LszNWiP3GuKKS7akQpkmQ=;
        b=Sq4cX2uwiRVuWFNZ93X8yrRDQ07wdKUApoDDNmjXfffILOT54na5dRKyO0ubwY6Xt0Aw3v
        Va7/zj+k4Ez8elglOj+40NHH44ckaYGUTE6d5ZK6oDdKG3oeMFR0a5RRdxsg4ted+6BYA5
        HxdVNk8lxs/RldxYquFDIhgy9utziWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-Bkv2n1ylMIGJ9zTVqjz9bQ-1; Wed, 15 Jul 2020 16:44:54 -0400
X-MC-Unique: Bkv2n1ylMIGJ9zTVqjz9bQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B538A100A8E8;
        Wed, 15 Jul 2020 20:44:53 +0000 (UTC)
Received: from redhat.com (ovpn-116-87.rdu2.redhat.com [10.10.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3685A757DF;
        Wed, 15 Jul 2020 20:44:53 +0000 (UTC)
Date:   Wed, 15 Jul 2020 15:44:51 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH 3/3] xfsprogs: xfs_quota state command should report ugp
 grace times
Message-ID: <20200715204451.GA172874@redhat.com>
References: <20200715201253.171356-1-billodo@redhat.com>
 <20200715201253.171356-4-billodo@redhat.com>
 <359b4cde-f252-214d-6828-2d5f85050705@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <359b4cde-f252-214d-6828-2d5f85050705@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 01:33:29PM -0700, Eric Sandeen wrote:
> On 7/15/20 1:12 PM, Bill O'Donnell wrote:
> > Since grace periods are now supported for three quota types (ugp),
> > modify xfs_quota state command to report times for all three.
> > Add a helper function for stat reporting.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> 
> ...
> 
> > +	if (type & XFS_GROUP_QUOTA) {
> > +		if (xfsquotactl(XFS_GETQSTATV, dev, XFS_GROUP_QUOTA,
> > +				0, (void *)&sv) < 0) {
> > +			if (xfsquotactl(XFS_GETQSTAT, dev, XFS_GROUP_QUOTA,
> > +					0, (void *)&s) < 0) {
> > +				if (flags & VERBOSE_FLAG)
> > +					fprintf(fp,
> > +						_("%s quota are not enabled on %s\n"),
> > +						type_to_string(XFS_GROUP_QUOTA),
> > +						dev);
> > +				return;
> > +			}
> > +			state_stat_to_statv(&s, &sv);
> > +		}
> 
> At first glance, can't all of the above be moved into the helper as well?
> 
> Maybe something like this (needs fixing up for sure)

Yeah, I should further reduce the redundancy.
Thanks-
Bill


> 
> static void
> state_quotafile_stat(
> 	FILE			*fp,
> 	uint			type,
> 	struct fs_path		*mount,
> 	struct fs_quota_statv	*sv)
> {
> 	bool 			accounting, enforcing;
> 	struct fs_qfilestat	*qsv;
> 
> 	switch(type) {
> 	case XFS_USER_QUOTA:
> 		qsv = &sv->qs_uquota;
> 		accounting = sv->qs_flags & XFS_QUOTA_UDQ_ACCT;
> 		enforcing = sv->qs_flags & XFS_QUOTA_UDQ_ENFD;		
> 		break;
> 	case XFS_GROUP_QUOTA:
> 		...
> 		break;
> ...
> 	default:
> 		/* defensive check goes here */
> 	}
> 
> 	if (xfsquotactl(XFS_GETQSTATV, dev, type, 0, (void *)&sv) < 0) {
> 		if (xfsquotactl(XFS_GETQSTAT, dev, type, 0, (void *)&s) < 0) {
> 			if (flags & VERBOSE_FLAG)
> 				fprintf(fp,
> 					_("%s quota are not enabled on %s\n"),
> 					type_to_string(type), dev);
> 			return;
> 		}
> 		state_stat_to_statv(&s, &sv)
> 	}	
> 
> 	state_qfilestat(fp, mount, type, qsv, accounting, enforcing);
> 
> 	state_timelimit(fp, XFS_BLOCK_QUOTA, sv->qs_btimelimit);
> 	state_warnlimit(fp, XFS_BLOCK_QUOTA, sv->qs_bwarnlimit);
> 
> 	state_timelimit(fp, XFS_INODE_QUOTA, sv->qs_itimelimit);
> 	state_warnlimit(fp, XFS_INODE_QUOTA, sv->qs_iwarnlimit);
> 
> 	state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv->qs_rtbtimelimit);
> }
> 
> 
> Thanks,
> -Eric
> 

