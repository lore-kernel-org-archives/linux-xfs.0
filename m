Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC48C432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 00:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CBC62082F
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 00:33:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="bqZvH8OC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="P37ZPsp+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbfIYAdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 20:33:02 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:55151 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388529AbfIYAdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 20:33:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9BEF4461;
        Tue, 24 Sep 2019 20:33:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 24 Sep 2019 20:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        /pULvNuQazwBLcyPG9YRVMKRFr/4uQq2cAADNF55Mw4=; b=bqZvH8OCNmIOt9tT
        5NyufrCM5SIbOtdvnrRyezIwW1f1zZlc3KSycNMbknHeurscH7Kd/qQywiXVmuC6
        eHd5YivFk5gArd1Y6ms5p/T+kmeMa5Yekb7kg8v2dDbooWfNEmRBGyXAXaUtcbUD
        tB2rmvsqUL9n8461O+/bKyZJtvFfiAZ+tWRyHSw77dLsmaRpqSpJKKLGNuVbmARh
        iQ7thiDg31Cf84LlZODEPd1vN9UT+BHwGUmbnnc/YCSp00Fs1w8MswAUzXPDjA2t
        iHlVFkrNp3Qy3cU7gWYYFFl0OvFcpcNEiNC3ZGk6XI4zAIW0OA9ylKj/VzVhEJV3
        N3tYdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=/pULvNuQazwBLcyPG9YRVMKRFr/4uQq2cAADNF55M
        w4=; b=P37ZPsp+4jvruQUA9lJ8i2PSEi6cU52VmUVdAnSaLnbKTNds+ALb1itek
        bBX+b+4mvNW3l/rKDcpJpjZ2F1as7h5nCYEmskOTFZSeX58EGyHhgfd0ExAE0nDV
        pAe6ocZ+dg67RQTr5Tr/GTuzdNnE9H/M4pvYpwL++xW4H8k7Ng8yM/3E7758vVuz
        mrsE18XJy6RSaVIMSDoVPj8lAiFFBzm7sIOfKCHh6a9U/tlZdjCfBZMUJgTJ6V4V
        DQXyDggL4CdKvZK/FtkJRVGpUukQcA2uRMZhJ0ZvdVolHN6LicIPhkbQV/1c4JCx
        uJ/x2w4+sakKGuKyxgz/bORsVPokw==
X-ME-Sender: <xms:u7WKXTCTYfl0UFyn6qD54Q5bf2Lt6S6nTVvPizt1Be98TAdb53-2Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    duieefrddvvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:u7WKXTJ-nQRlxngyKJX1NuwapkYoNRfDwxcUNdOECngKrL0AnHOxyw>
    <xmx:u7WKXemeWdqAI9bicNiRC_2JVEfTwgc9zILd2AiUpHS0OO9MLJZ5mA>
    <xmx:u7WKXZEHOD4nFE2ObN0exUWLZv8DtFprmngGan1a9f3H8q2uiceIWg>
    <xmx:vLWKXRTaOQg5Lyv8usuA5OVty-LzY1l1SdO-sZ90SsVSZDtMgLdGrQ>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E1DC8005C;
        Tue, 24 Sep 2019 20:32:57 -0400 (EDT)
Message-ID: <3e4e2058022957e152ccb919ed91e622dbe81b57.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 07/16] xfs: mount-api - move xfs_parseargs()
 validation to a helper
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Wed, 25 Sep 2019 08:32:50 +0800
In-Reply-To: <20190924143753.GB17688@bfoster>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933135854.20933.15258576633425282851.stgit@fedora-28>
         <20190924143753.GB17688@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 10:37 -0400, Brian Foster wrote:
> On Tue, Sep 24, 2019 at 09:22:38PM +0800, Ian Kent wrote:
> > Move the validation code of xfs_parseargs() into a helper for later
> > use within the mount context methods.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |  148 +++++++++++++++++++++++++++++++++-------
> > ------------
> >  1 file changed, 94 insertions(+), 54 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 6792d46fa0be..cfda58dd3822 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -356,6 +356,97 @@ xfs_parse_param(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_validate_params(
> > +	struct xfs_mount        *mp,
> > +	struct xfs_fs_context   *ctx,
> > +	bool			nooptions)
> > +{
> > +	if (nooptions)
> > +		goto noopts;
> > +
> > +	/*
> > +	 * no recovery flag requires a read-only mount
> > +	 */
> > +	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
> > +	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> > +		xfs_warn(mp, "no-recovery mounts must be read-only.");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (ctx->dsunit || ctx-
> > >dswidth)) {
> 
> Long line ^.

Oh, I thought I fixed those long lines.
I'll sort that out.

> 
> > +		xfs_warn(mp,
> > +	"sunit and swidth options incompatible with the noalign
> > option");
> > +		return -EINVAL;
> > +	}
> > +
> ...
> > @@ -447,16 +538,7 @@ xfs_parseargs(
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
> > +			goto done;
> 
> Isn't this supposed to just return the error?

Yes, I think your right ... I'll fix that too.

Ian
> 
> Brian
> 
> >  	}
> >  
> >  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
> > @@ -486,51 +568,9 @@ xfs_parseargs(
> >  	}
> >  
> >  done:
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
> > +	ret = xfs_validate_params(mp, &context, false);
> >  
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

