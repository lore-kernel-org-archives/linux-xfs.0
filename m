Return-Path: <SRS0=2RH+=XM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1810DC4CECD
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 04:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C333120862
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 04:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="WKQ3u9eC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KMJLN76K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390819AbfIQEbl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 00:31:41 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54851 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfIQEbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Sep 2019 00:31:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 8D0D257F;
        Tue, 17 Sep 2019 00:31:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 17 Sep 2019 00:31:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        ZHQ5AHP5rDEcOo53PiLvJvN5BHXeFcFd1acG6xEZp/s=; b=WKQ3u9eCxIjRKXf6
        RytOi5SzLUp897heSMNEP1vGN/TBW1hOUEUdTZ39UQwZj/k/ai2RsCG9mK6tCcBn
        XpyFdd5hkah7+YoGPAV5ozTnBcCBWUy0w9fPsocvON7CphoThvOnJNyG23qLy+T0
        f05qDc3awcFffAhjvqoYfYDCNGEH0s8MIybddlWjDt1EPJWkz+8twTLiovh3eh0S
        bhEIS+zBksrKwyFlkTGm4G82JKCYzOLGvIhMBL3UPwQtOcFqYLF7w8HK8/KmgP6b
        c8WoaaXo0oeena2cIGWh5mV2r5d9B0GCQ1ahX9IK99jxczOEOwFXfgGdYOvB0jfH
        jLZD2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=ZHQ5AHP5rDEcOo53PiLvJvN5BHXeFcFd1acG6xEZp
        /s=; b=KMJLN76KIdXilQc0FUoX+WfMFIBa3IxixwPiY1lPqNIdVHfh7miHQuRbf
        cjAxup9J+Gyj8k3YbPZ7w4M+wIDO33i2mmSSLGgj91w3lUyXOR+F5nXvPR4nReIS
        Bpc7ebKrXu7Me269fAEK5XjwF7Li62hgFrgVQYXtgNGFA1J7MibWh8GJ2qVXH92T
        X/KvjPDcRvXGoB2eBiB7gR+Qxw5oxGg3PP/GwO8Eb1CLdtIEmxj6sKjFMvIwHcSl
        fpgTZo20c6utwD+NJvZn/YQhFZTuF9Mp/CwXkECzo35Q5SOIdz/6b5HvIIfktz2r
        7Ogj6pAaqxswJWsZ13p0LY/mC8BeQ==
X-ME-Sender: <xms:qmGAXZK_XHjRVI_CDFt1aunrO2m_h5oIs0Hc58TH9FkVlJ5a5CvRAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujedurdehjeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:qmGAXZF86WV_-VKzmxHDMeJZyrgcj0GROOJmgenggn08BmmH3P7bWw>
    <xmx:qmGAXWQG98GkQ0_ueLaGJN3F2UPAyeoHB7qtlEqPnAbmpJcdLhotTQ>
    <xmx:qmGAXSWawTc2bNYc5nQ6uPYNangOw00NTEXHwssAbA-S8gBb63g7QQ>
    <xmx:q2GAXUgrAmKmqbrxLg7q8QVBJ0ivHs3Ea8_a0pBotmjVjq5H6Vp1fA>
Received: from mickey.themaw.net (unknown [118.208.171.57])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53124D60067;
        Tue, 17 Sep 2019 00:31:36 -0400 (EDT)
Message-ID: <57fdef76dc3ae0dadacfd8a16323dc95740e9562.camel@themaw.net>
Subject: Re: [PATCH v2 03/15] xfs: mount-api - refactor suffix_kstrtoint()
From:   Ian Kent <raven@themaw.net>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Tue, 17 Sep 2019 12:31:32 +0800
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

I guess, it seemed sensible to me to create the needed function (that
doesn't take the substring_t returned by the existing tokenizer) and
just adapt the replacement to work with that, essentially because it
is going to go away fairly soon after ...

Also I think your suggestion would require creating a helper that
would be used by both and then would later need to be merged back
into the caller, having only one caller left at that point which
is, I think, unnecessary code churn.

Not sure I'm terribly worried about this one myself but if it really
bugs you I will change it.

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

