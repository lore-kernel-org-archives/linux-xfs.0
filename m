Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4093BC3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02C2421726
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="eupZ5mBv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rKRY9czp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfH3KzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:55:19 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46111 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbfH3KzT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:55:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 133BC3BA;
        Fri, 30 Aug 2019 06:55:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 06:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        QzUVNgXWHMoMuiyIxGhSY2LjRkCsh896eew5IKzxX0s=; b=eupZ5mBv5Y44r0Ub
        7YFouA/Ua9pgNB5lFf8wQiX9sZWu5A2rG6LPjV+HbsPkRGDoaKCNUh0HQ14lZtTq
        0man1KlBj76ej5jeFoff/2v1zjH8dzzl8DZVrcruhgHYmxET3hefHeW4ylBaWr36
        VklI0SD/b0I7r4tr5Uu720N7zb0IiMu/eRplWhQuMRGiYQazGfLGvIzeza/Y5Svg
        /GOAXsc9omwNZGyk6XEiAct3guoTRstK/KlyJvx6MoGaXGQGejxPgpv5DxWkH1gz
        J8H/wrOFMY995u+mpMk2QxBbvt+I3ZhLUkTi8iyFsv+Y1HQCib2/7AraETyyBm5s
        9T85QA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=QzUVNgXWHMoMuiyIxGhSY2LjRkCsh896eew5IKzxX
        0s=; b=rKRY9czpek7Q3+i27JD7jWINc1W1KJ0u3jTyW/TTwen1oGXW46HJiXGe0
        v+p0LQhLyi2Ns/KEG3dnaP1sdpvb2jLWwd1qoc421Pn1q//vF1kS/Q4qQ60JbPtf
        H2RAGoR1Jv0XPdjGbYuOukA0046RdHmC2I9zZS5xcxBcA6he4mlR+zC6Eo+NiFtR
        ZiBl6Z/gK1tQk4SQtG2N1NGaHIEfjYDXe3TTjmE7vp57ydsHUj/MLiKnUzc2L/RK
        4bdGs3k76reuufqqvA0n3ln1jqfvF/iTS3HR/nBsgccUp/OSYCEqAbalGwls3J4d
        tB4R2CVeSaF4d+LtZTJcSAvmuDe1Q==
X-ME-Sender: <xms:lQBpXcJPMgyi-n4VHcp3bme96HWbWmj_R_Bg0qof7LXX-bdIuXogpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:lQBpXXHY61fkD4bKi0C_EaThpwHbSM4cRR6nycppahab4kVDoMtU3A>
    <xmx:lQBpXfWTIzOJ105nkZqVfBo7t2jUrho-2QVFVI62rYqt90CGy1RpOg>
    <xmx:lQBpXYLRoKtpMfKpVvsOonfo9WNsGiuvI9SMiXkG0--eGjf2OUlXIA>
    <xmx:lQBpXQme-DJIODsMVahm9jIKnmo0FJCH_VElC3yrSnn2LGjm-NJySA>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34B998005B;
        Fri, 30 Aug 2019 06:55:13 -0400 (EDT)
Message-ID: <ae5bf33558520b42bc5117bf90366089d47838b5.camel@themaw.net>
Subject: Re: [PATCH v2 06/15] xfs: mount-api - move xfs_parseargs()
 validation to a helper
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 18:55:10 +0800
In-Reply-To: <20190827124158.GE10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652198915.2607.7532914515862448103.stgit@fedora-28>
         <20190827124158.GE10636@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-08-27 at 08:41 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 08:59:49AM +0800, Ian Kent wrote:
> > Move the validation code of xfs_parseargs() into a helper for later
> > use within the mount context methods.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |  180 ++++++++++++++++++++++++++++----------
> > --------------
> >  1 file changed, 98 insertions(+), 82 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 754d2ccfd960..7cdda17ee0ff 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> ...
> > @@ -442,89 +535,12 @@ xfs_parseargs(
> >  		ret = xfs_parse_param(&fc, &param);
> >  		kfree(param.string);
> >  		if (ret < 0)
> > -			return ret;
> > -	}
> > -
> > -	/*
> > -	 * no recovery flag requires a read-only mount
> > -	 */
> > -	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> > -	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> > -		xfs_warn(mp, "no-recovery mounts must be read-only.");
> > -		return -EINVAL;
> > -	}
> > -
> > -	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx-
> > >dswidth)) {
> > -		xfs_warn(mp,
> > -	"sunit and swidth options incompatible with the noalign
> > option");
> > -		return -EINVAL;
> > -	}
> > -
> > -#ifndef CONFIG_XFS_QUOTA
> > -	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > -		xfs_warn(mp, "quota support not available in this
> > kernel.");
> > -		return -EINVAL;
> > -	}
> > -#endif
> > -
> > -	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx-
> > >dswidth)) {
> > -		xfs_warn(mp, "sunit and swidth must be specified
> > together");
> > -		return -EINVAL;
> > -	}
> > -
> > -	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
> > -		xfs_warn(mp,
> > -	"stripe width (%d) must be a multiple of the stripe unit (%d)",
> > -			ctx->dswidth, ctx->dsunit);
> > -		return -EINVAL;
> > +			goto done;
> >  	}
> >  
> > +	ret = xfs_validate_params(mp, ctx, false);
> >  done:
> 
> This label now directly returns, which means it's not that useful in
> its
> current form. How about we move the validate call below the label
> (and perhaps rename the label to validate or some such) and just
> return
> directly from the other user of done?

Yes, I saw that too.

But I was trying to duplicate the existing logic, I thought
maybe I got that wrong but couldn't see it and I probably
have since you don't see the correspondence to the original
code.

I'll need re-look at that logic.

> 
> Brian
> 
> > -	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
> > -		/*
> > -		 * At this point the superblock has not been read
> > -		 * in, therefore we do not know the block size.
> > -		 * Before the mount call ends we will convert
> > -		 * these to FSBs.
> > -		 */
> > -		mp->m_dalign = ctx->dsunit;
> > -		mp->m_swidth = ctx->dswidth;
> > -	}
> > -
> > -	if (mp->m_logbufs != -1 &&
> > -	    mp->m_logbufs != 0 &&
> > -	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
> > -	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
> > -		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
> > -			mp->m_logbufs, XLOG_MIN_ICLOGS,
> > XLOG_MAX_ICLOGS);
> > -		return -EINVAL;
> > -	}
> > -	if (mp->m_logbsize != -1 &&
> > -	    mp->m_logbsize !=  0 &&
> > -	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
> > -	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
> > -	     !is_power_of_2(mp->m_logbsize))) {
> > -		xfs_warn(mp,
> > -			"invalid logbufsize: %d [not 16k,32k,64k,128k
> > or 256k]",
> > -			mp->m_logbsize);
> > -		return -EINVAL;
> > -	}
> > -
> > -	if (ctx->iosizelog) {
> > -		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
> > -		    ctx->iosizelog < XFS_MIN_IO_LOG) {
> > -			xfs_warn(mp, "invalid log iosize: %d [not %d-
> > %d]",
> > -				ctx->iosizelog, XFS_MIN_IO_LOG,
> > -				XFS_MAX_IO_LOG);
> > -			return -EINVAL;
> > -		}
> > -
> > -		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
> > -		mp->m_readio_log = ctx->iosizelog;
> > -		mp->m_writeio_log = ctx->iosizelog;
> > -	}
> > -
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  struct proc_xfs_info {
> > 

