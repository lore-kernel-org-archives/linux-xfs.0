Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C046CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 22:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61D402084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 22:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="i6T8KAxR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Eo6pmAId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfJXWCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 18:02:41 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:39063 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729864AbfJXWCl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 18:02:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 224785C6;
        Thu, 24 Oct 2019 18:02:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 24 Oct 2019 18:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        HLM9zvWTvbzl4sO/ANNqtkLXIJvdKSw5nOg0ijplVGY=; b=i6T8KAxROaElUefL
        1GyZFwC/ZzCeBn9Rp9IyiGQwqOGD3boVkXhaM7EOV+zasT98FTWaE/wxRCsVGc1v
        X1iPGxdoqWMQjq8mNIB5FzYLECjdyZUsjiIWDGzF1Ez9htpaoPF9hi2CN09p3Ktm
        Fix9xCj4V74sR0k1AtwlPsDyu20EeiaUqwG5BUL33zVJPnoNYfUb6tzUub6hfzAn
        R8jx2XEb0j7ONCZqXjdEfHqUFVJ6R6umBlWnlQvoY4IE9xX68XTduij2qK3wPT8P
        dBXKJ7T0HOuBnzmSTQ2/Az00jihYVBpbd/XPnlxtNcwtr9rTe2N142g+hDmQccGO
        ET5KEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=HLM9zvWTvbzl4sO/ANNqtkLXIJvdKSw5nOg0ijplV
        GY=; b=Eo6pmAIdQh0l/8YMMWFtm47BT3XYDM8RM4maiYmlD+W2sxN8sRxb1qQpz
        yfBX7I9rmb7bT6A81LzXOizpX06jwV9OjauNtxrNi8r0uJgONONGk7l42srMb/hK
        LwFFw4ctA6yleykOzVR775mrgzH9XGuvLQZJrFEcx/1LaJTPgH95bDDaAJGl3uLw
        KFCcWQuS7jgdlFihb1XzFAVR6tqwkzZrb73skAKeGhiTQrffh4c985KUgllzub2d
        /Jnkkw1Jhr6XRa24gP9Dr9RVW4RRpuecImNrOwVXznJPAvvhoMtCfABooPc2eczH
        47fPtPsJ5bwAG2ArBqheuYy2gWr3g==
X-ME-Sender: <xms:fB-yXV5H0zswVb5BL5SdRRRQTl74qxjpYzJIJHI5nicTHJc9gsOHWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrledvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dukeejrdefvdenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:fB-yXVuCfCVA0oKyHmT4VBnfgBAdlzR17XShIkN8lb01q4ZTRv9Rbg>
    <xmx:fB-yXfNLeCrP7RVqqDbcY-Ko3WCoFAkwbM6k0Zw55v1q4IKXOvHuTw>
    <xmx:fB-yXRrYPRWJZMZ_6vLwMj-QM6Wlguh62epWXnJCd3y7Hn2N2CG91w>
    <xmx:fx-yXQ3MGNpkjlY8baSoHKWZtErP2QRLq9_6i01zFVBfDnzT6JyhWA>
Received: from donald.themaw.net (unknown [118.208.187.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9C5D80061;
        Thu, 24 Oct 2019 18:02:33 -0400 (EDT)
Message-ID: <56575c2095a8e13847fab42c94fde6d3385cb556.camel@themaw.net>
Subject: Re: [PATCH v7 11/17] xfs: refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 25 Oct 2019 06:02:29 +0800
In-Reply-To: <20191024153803.GU913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
         <157190349282.27074.327122390885823342.stgit@fedora-28>
         <20191024153803.GU913374@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-10-24 at 08:38 -0700, Darrick J. Wong wrote:
> On Thu, Oct 24, 2019 at 03:51:32PM +0800, Ian Kent wrote:
> > The mount-api doesn't have a "human unit" parse type yet so the
> > options
> > that have values like "10k" etc. still need to be converted by the
> > fs.
> 
> Do you have plans to add such a thing to the mount api?  Or port the
> xfs
> helper?  TBH I'd have thought that would show up as one of the vfs
> patches at the start of this series.

I asked David (Howells) about this a while back and he did have some
patches for it but they weren't posted.

I can't remember now but I think there was a reason for holding back
on it.

I expect they will be posted for merge at some point but I don't
know when that will be.

> 
> I guess the patch itself looks fine as temporary support structures
> for
> handling a transition.
> 
> --D
> 
> > But the value comes to the fs as a string (not a substring_t type)
> > so
> > there's a need to change the conversion function to take a
> > character
> > string instead.
> > 
> > When xfs is switched to use the new mount-api match_kstrtoint()
> > will no
> > longer be used and will be removed.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_super.c |   38 +++++++++++++++++++++++++++++---------
> >  1 file changed, 29 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 97c3f1edb69c..003ec725d4b6 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -112,14 +112,17 @@ static const match_table_t tokens = {
> >  };
> >  
> >  
> > -STATIC int
> > -suffix_kstrtoint(const substring_t *s, unsigned int base, int
> > *res)
> > +static int
> > +suffix_kstrtoint(
> > +	const char	*s,
> > +	unsigned int	base,
> > +	int		*res)
> >  {
> > -	int	last, shift_left_factor = 0, _res;
> > -	char	*value;
> > -	int	ret = 0;
> > +	int		last, shift_left_factor = 0, _res;
> > +	char		*value;
> > +	int		ret = 0;
> >  
> > -	value = match_strdup(s);
> > +	value = kstrdup(s, GFP_KERNEL);
> >  	if (!value)
> >  		return -ENOMEM;
> >  
> > @@ -144,6 +147,23 @@ suffix_kstrtoint(const substring_t *s,
> > unsigned int base, int *res)
> >  	return ret;
> >  }
> >  
> > +static int
> > +match_kstrtoint(
> > +	const substring_t	*s,
> > +	unsigned int		base,
> > +	int			*res)
> > +{
> > +	const char		*value;
> > +	int			ret;
> > +
> > +	value = match_strdup(s);
> > +	if (!value)
> > +		return -ENOMEM;
> > +	ret = suffix_kstrtoint(value, base, res);
> > +	kfree(value);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * This function fills in xfs_mount_t fields based on mount args.
> >   * Note: the superblock has _not_ yet been read in.
> > @@ -155,7 +175,7 @@ suffix_kstrtoint(const substring_t *s, unsigned
> > int base, int *res)
> >   * path, and we don't want this to have any side effects at
> > remount time.
> >   * Today this function does not change *sb, but just to future-
> > proof...
> >   */
> > -STATIC int
> > +static int
> >  xfs_parseargs(
> >  	struct xfs_mount	*mp,
> >  	char			*options)
> > @@ -206,7 +226,7 @@ xfs_parseargs(
> >  				return -EINVAL;
> >  			break;
> >  		case Opt_logbsize:
> > -			if (suffix_kstrtoint(args, 10, &mp-
> > >m_logbsize))
> > +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
> >  				return -EINVAL;
> >  			break;
> >  		case Opt_logdev:
> > @@ -222,7 +242,7 @@ xfs_parseargs(
> >  				return -ENOMEM;
> >  			break;
> >  		case Opt_allocsize:
> > -			if (suffix_kstrtoint(args, 10, &iosize))
> > +			if (match_kstrtoint(args, 10, &iosize))
> >  				return -EINVAL;
> >  			iosizelog = ffs(iosize) - 1;
> >  			break;
> > 

