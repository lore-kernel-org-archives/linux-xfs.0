Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEB8C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 729A021670
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 10:33:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="qu1pha4Y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HoNdQg5k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfH3Kda (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 06:33:30 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34843 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbfH3Kd3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:33:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9E379507;
        Fri, 30 Aug 2019 06:33:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 30 Aug 2019 06:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        A+vNto/3MG3yIefLLsJIRF3nYGvhEcaYLEDNyOaxtaA=; b=qu1pha4YZBngUWFU
        Dn0Ttmr3sNc492BEQZXjA6YAtjgamvsNwdi6WhoGzJ2ldDx3oAGd4elGzTviQzVh
        0KUP4YjKM3TheOGspUxMnKVJhpaqAtCrw/MY63dH/vRSdXNC/PQJcrw4SPHEDuEN
        /AJFGW3j9JF+lPOYRob8eNSGryVpyxG3T0cYZnKGUTkd7XIR0t0yoYIE2X6WKSYf
        JH/TlzrpOBTz0FUuB4NNHONEm8f/K4VW9M74ZWcRql66SLI1DQ3cb9FJjQfQSGWm
        9jeLgXGT4p0tKggBl1tKAIpvt7llpwbUGM3RR2NQJ+9mAInEmfZRCeKtE2w2kB6D
        d6TnIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=A+vNto/3MG3yIefLLsJIRF3nYGvhEcaYLEDNyOaxt
        aA=; b=HoNdQg5kZpCJnUJDRbLw0ZDlbqZ7ez3ZwbczcJ333mGgYgx2USPXDR9Dc
        CcM0eBTIDbcpUQMIF/dMFfpEhnhQLLRxYx7ZqVs3Y8vfdjfALGlMjMehmUVPdZJh
        mvE/sXLJlM+yltR4nUfAk2JcxPP2NlTBcmItXidKCsVTipZ3nr0nAHbF/HK1a1yq
        QWcOfjS3G6Y9g8J1qEHDYhM8iB7tWJiWyg81JCGtJasJF/zBl86P10olJI6In9tN
        XEFXIiA2JOc3LPpAvbJ7Gxbkfx444N2shEJYg5OvR+pFx2WK+SfPDKhS/grgspvC
        0ChN7PG7YDdhH+fX+2losdLn2tB2w==
X-ME-Sender: <xms:d_toXRH6YvOFMnpJqLJXrFgP3nN2__MW7hzIleHc6_qMuII9BtxRRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeigedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtke
    drudekgedrudefkeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghm
    rgifrdhnvghtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:d_toXTOUmVqpj5ie4Iw4QYQ-Iy7ETLaSlrp_FoKLLA-ENSxeAeJHKA>
    <xmx:d_toXS6hGnUGHZclnElzmQku0wuGT3GcS1iCq4fsU1f7rYWfMyo6WA>
    <xmx:d_toXWgkDsW4lQATMfeqvqUCJTi_P46CMZUmc1h01nrYxsnVlnq2bA>
    <xmx:ePtoXQ1UJq0r9hy-gvEPC4G05cX9AD1RVMPneDWaRErePPLu-XAMQw>
Received: from mickey.themaw.net (unknown [118.208.184.138])
        by mail.messagingengine.com (Postfix) with ESMTPA id 39C008005B;
        Fri, 30 Aug 2019 06:33:24 -0400 (EDT)
Message-ID: <44dbdc61f4fe5ccd4c15c3f835ea078900e56902.camel@themaw.net>
Subject: Re: [PATCH v2 03/15] xfs: mount-api - refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 30 Aug 2019 18:33:22 +0800
In-Reply-To: <20190827124000.GB10636@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
         <156652197305.2607.14039510188924939054.stgit@fedora-28>
         <20190827124000.GB10636@bfoster>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-08-27 at 08:40 -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 08:59:33AM +0800, Ian Kent wrote:
> > The mount-api doesn't have a "human unit" parse type yet so
> > the options that have values like "10k" etc. still need to
> > be converted by the fs.
> > 
> > But the value comes to the fs as a string (not a substring_t
> > type) so there's a need to change the conversion function to
> > take a character string instead.
> > 
> > After refactoring xfs_parseargs() and changing it to use
> > xfs_parse_param() match_kstrtoint() will no longer be used
> > and will be removed.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
> >  1 file changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 74c88b92ce22..49c87fb921f1 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -153,13 +153,13 @@ static const struct fs_parameter_description
> > xfs_fs_parameters = {
> >  };
> >  
> >  STATIC int
> > -suffix_kstrtoint(const substring_t *s, unsigned int base, int
> > *res)
> > +suffix_kstrtoint(const char *s, unsigned int base, int *res)
> >  {
> >  	int	last, shift_left_factor = 0, _res;
> >  	char	*value;
> >  	int	ret = 0;
> >  
> > -	value = match_strdup(s);
> > +	value = kstrdup(s, GFP_KERNEL);
> >  	if (!value)
> >  		return -ENOMEM;
> >  
> > @@ -184,6 +184,20 @@ suffix_kstrtoint(const substring_t *s,
> > unsigned int base, int *res)
> >  	return ret;
> >  }
> >  
> > +STATIC int
> > +match_kstrtoint(const substring_t *s, unsigned int base, int *res)
> > +{
> > +	const char	*value;
> > +	int ret;
> > +
> > +	value = match_strdup(s);
> > +	if (!value)
> > +		return -ENOMEM;
> > +	ret = suffix_kstrtoint(value, base, res);
> > +	kfree(value);
> > +	return ret;
> > +}
> > +
> 
> I guess the use case isn't clear to me yet and it's not critical if
> this
> code is going away by the end of the series, but why not refactor
> into a
> __suffix_kstrtoint(char *s, ...) variant that accepts an already
> duplicated string so we don't have to duplicate each string twice in
> the
> match_kstrtoint() case?

Yeah, sounds good, I'll have a go at that for v3.

> 
> Brian
> 
> >  /*
> >   * This function fills in xfs_mount_t fields based on mount args.
> >   * Note: the superblock has _not_ yet been read in.
> > @@ -255,7 +269,7 @@ xfs_parseargs(
> >  				return -EINVAL;
> >  			break;
> >  		case Opt_logbsize:
> > -			if (suffix_kstrtoint(args, 10, &mp-
> > >m_logbsize))
> > +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
> >  				return -EINVAL;
> >  			break;
> >  		case Opt_logdev:
> > @@ -272,7 +286,7 @@ xfs_parseargs(
> >  			break;
> >  		case Opt_allocsize:
> >  		case Opt_biosize:
> > -			if (suffix_kstrtoint(args, 10, &iosize))
> > +			if (match_kstrtoint(args, 10, &iosize))
> >  				return -EINVAL;
> >  			iosizelog = ffs(iosize) - 1;
> >  			break;
> > 

