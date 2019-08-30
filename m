Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A88C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F1622CE3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 11:19:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="Sw1xDkp5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PVh7Chyw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfH3LTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 07:19:22 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37291 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbfH3LTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 07:19:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 2B3E050E;
        Fri, 30 Aug 2019 07:19:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 07:19:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        uqzR8kK3fURsCdRcNzGewWuzGwq52r/MFa2o8mc8jI8=; b=Sw1xDkp5dkJgme7n
        /5v04y56focbciW1tNOhUyh6JZSfq+gOVIRe+0StP3ViH+4bEcLGtH+xzHHuKc8Z
        Cz4MVkWN59GNjGvlY6Xmal1A2qBxjn02pxiKV4mJYXSqId5xvZf5qaUyVlzySIRF
        I3Z/raUbaTyd/Iu6Iym5Lv93JU4ZPIY4htXEJKhiglKn+rrvF9z4J/vNUzPaS+O8
        lXF9lgebJ7TXl60KmjLE3S0754Je5GjJS96CcNYDzsSccj7DyVM/MhGsvTfV18Vh
        CmoFW/39oXWbeo2UT/m6MMqHiOq8B3OdJoD4+raIyNatdsLWW7H68nYa39/cR6z0
        csX+eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=uqzR8kK3fURsCdRcNzGewWuzGwq52r/MFa2o8mc8j
        I8=; b=PVh7ChywKIFFa34ya59oDzppam/43abXKTOidGAyD6kIxONs1c8y5OsOK
        2uSlGxLD6FB1eAvs42AruowHBUNiI9rhBucU13KolHn2wCIgsmrJ82faaaRX9vZB
        5jm38nTA0lR9PFd7+4Dq+hryI+NVSQmiTyC430SsNvY6fHy/IQWZC+89Fo1ynpkq
        IG5x5bIDGxxswVsYmrS5sels+EaRg8TxGGL4GA1IqjkEYGEmCz87WcmXQauDVAlA
        NOcfS1iGmwQwUrCq2Bpi6gOD2JmrULOiBtsfMsQTF0t2bgJjQBGpMHJbOtHCJQKE
        4A4qppSSrbBimdBSA7BhOI3m4RDrQ==
X-ME-Sender: <xms:OAZpXR_1Emo-t8KSfVa-4ScJ9YyxI7uUkN3ykmvSHKLATsEefUQ2xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:OAZpXQmgRTnSIuFizu0j2JiGpgEGtQt_ZmipzvH1SCV-SNw1Xg8ZEQ>
    <xmx:OAZpXf8ZwbRHSC_Zn_km5LI1XguvI7fdxmG0r6IBKkmoirWZYEYbTQ>
    <xmx:OAZpXceJfYcyIpTX4KHpl7y_ObLtkJ0reBXaUufmWr5LTOOKFA3QUw>
    <xmx:OAZpXfkDDGbMoMFiHpu7FAXgGX6mslGO-YJkzYuj713syD6rhj0o4g>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5C7380062;
        Fri, 30 Aug 2019 07:19:17 -0400 (EDT)
Message-ID: <c6c4c6d0334407ca671b2b0337e027ef31d11b8e.camel@themaw.net>
Subject: Re: [PATCH v2 12/15] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 19:19:13 +0800
In-Reply-To: <20190828132822.GE16389@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652202212.2607.8621137631843273531.stgit@fedora-28>
         <20190828132822.GE16389@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-08-28 at 09:28 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 09:00:22AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .free that performs fs
> > context cleanup on context release.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index aae0098fecab..9976163dc537 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -2129,10 +2129,32 @@ static const struct super_operations
> > xfs_super_operations = {
> >  	.free_cached_objects	= xfs_fs_free_cached_objects,
> >  };
> >  
> > +static void xfs_fc_free(struct fs_context *fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = fc->s_fs_info;
> > +
> > +	if (mp) {
> > +		/*
> > +		 * If an error occurs before ownership the xfs_mount
> > +		 * info struct is passed to xfs by the VFS (by
> > assigning
> > +		 * it to sb->s_fs_info and clearing the corresponding
> > +		 * fs_context field, which is done before calling fill
> > +		 * super via .get_tree()) there may be some strings to
> > +		 * cleanup.
> > +		 */
> 
> The code looks straightforward but I find the comment confusing. How
> can
> the VFS pass ownership of the xfs_mount if it's an XFS private data
> structure?

*sigh*, Darrick was similarly confused about my original
comment so it seems it's still not good enough.

The mount context holds values for various things as the
VFS allocates/constructs them and when they get assigned
to an object owned by the file system they are NULLed in
the moun t context structure.

I'm calling that process "ownership" in the above comment
and, perhaps mistenly, extending that to the xfs_mount
object which might never actually make it to the "file
system" in term of that ownership, such as when an error
occurs in the VFS during the mount procedure before the
mount context is realeased.

I can try and re-word the comment again, clearly it's
still not good enough ...

> 
> > +		kfree(mp->m_logname);
> > +		kfree(mp->m_rtname);
> > +		kfree(mp);
> > +	}
> > +	kfree(ctx);
> 
> Also, should we at least reassign associated fc pointers to NULL if
> we
> have multiple places to free things like ctx or mp?
> 
> Brian
> 
> > +}
> > +
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> >  	.reconfigure = xfs_reconfigure,
> > +	.free	     = xfs_fc_free,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

