Return-Path: <SRS0=2RH+=XM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F4AC4CEC9
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 12:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2AF921881
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Sep 2019 12:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfIQMKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 08:10:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbfIQMKd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Sep 2019 08:10:33 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E8BF10C093A;
        Tue, 17 Sep 2019 12:10:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B5C4A7D1;
        Tue, 17 Sep 2019 12:10:28 +0000 (UTC)
Date:   Tue, 17 Sep 2019 08:10:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 03/15] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20190917121026.GB2868@bfoster>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
 <156652197305.2607.14039510188924939054.stgit@fedora-28>
 <20190827124000.GB10636@bfoster>
 <57fdef76dc3ae0dadacfd8a16323dc95740e9562.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57fdef76dc3ae0dadacfd8a16323dc95740e9562.camel@themaw.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 17 Sep 2019 12:10:32 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 17, 2019 at 12:31:32PM +0800, Ian Kent wrote:
> On Tue, 2019-08-27 at 08:40 -0400, Brian Foster wrote:
> > On Fri, Aug 23, 2019 at 08:59:33AM +0800, Ian Kent wrote:
> > > The mount-api doesn't have a "human unit" parse type yet so
> > > the options that have values like "10k" etc. still need to
> > > be converted by the fs.
> > > 
> > > But the value comes to the fs as a string (not a substring_t
> > > type) so there's a need to change the conversion function to
> > > take a character string instead.
> > > 
> > > After refactoring xfs_parseargs() and changing it to use
> > > xfs_parse_param() match_kstrtoint() will no longer be used
> > > and will be removed.
> > > 
> > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > ---
> > >  fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
> > >  1 file changed, 18 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 74c88b92ce22..49c87fb921f1 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -153,13 +153,13 @@ static const struct fs_parameter_description
> > > xfs_fs_parameters = {
> > >  };
> > >  
> > >  STATIC int
> > > -suffix_kstrtoint(const substring_t *s, unsigned int base, int
> > > *res)
> > > +suffix_kstrtoint(const char *s, unsigned int base, int *res)
> > >  {
> > >  	int	last, shift_left_factor = 0, _res;
> > >  	char	*value;
> > >  	int	ret = 0;
> > >  
> > > -	value = match_strdup(s);
> > > +	value = kstrdup(s, GFP_KERNEL);
> > >  	if (!value)
> > >  		return -ENOMEM;
> > >  
> > > @@ -184,6 +184,20 @@ suffix_kstrtoint(const substring_t *s,
> > > unsigned int base, int *res)
> > >  	return ret;
> > >  }
> > >  
> > > +STATIC int
> > > +match_kstrtoint(const substring_t *s, unsigned int base, int *res)
> > > +{
> > > +	const char	*value;
> > > +	int ret;
> > > +
> > > +	value = match_strdup(s);
> > > +	if (!value)
> > > +		return -ENOMEM;
> > > +	ret = suffix_kstrtoint(value, base, res);
> > > +	kfree(value);
> > > +	return ret;
> > > +}
> > > +
> > 
> > I guess the use case isn't clear to me yet and it's not critical if
> > this
> > code is going away by the end of the series, but why not refactor
> > into a
> > __suffix_kstrtoint(char *s, ...) variant that accepts an already
> > duplicated string so we don't have to duplicate each string twice in
> > the
> > match_kstrtoint() case?
> 
> I guess, it seemed sensible to me to create the needed function (that
> doesn't take the substring_t returned by the existing tokenizer) and
> just adapt the replacement to work with that, essentially because it
> is going to go away fairly soon after ...
> 
> Also I think your suggestion would require creating a helper that
> would be used by both and then would later need to be merged back
> into the caller, having only one caller left at that point which
> is, I think, unnecessary code churn.
> 
> Not sure I'm terribly worried about this one myself but if it really
> bugs you I will change it.
> 

Ok, not a big deal. I don't think I was aware of the transient nature on
the first review pass..

Brian

> > 
> > Brian
> > 
> > >  /*
> > >   * This function fills in xfs_mount_t fields based on mount args.
> > >   * Note: the superblock has _not_ yet been read in.
> > > @@ -255,7 +269,7 @@ xfs_parseargs(
> > >  				return -EINVAL;
> > >  			break;
> > >  		case Opt_logbsize:
> > > -			if (suffix_kstrtoint(args, 10, &mp-
> > > >m_logbsize))
> > > +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
> > >  				return -EINVAL;
> > >  			break;
> > >  		case Opt_logdev:
> > > @@ -272,7 +286,7 @@ xfs_parseargs(
> > >  			break;
> > >  		case Opt_allocsize:
> > >  		case Opt_biosize:
> > > -			if (suffix_kstrtoint(args, 10, &iosize))
> > > +			if (match_kstrtoint(args, 10, &iosize))
> > >  				return -EINVAL;
> > >  			iosizelog = ffs(iosize) - 1;
> > >  			break;
> > > 
> 
