Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED89ECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0363520B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfJISW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 14:22:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50422 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731461AbfJISW0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 14:22:26 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIGbO-0000Kv-1H; Wed, 09 Oct 2019 18:22:22 +0000
Date:   Wed, 9 Oct 2019 19:22:22 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20191009182222.GB26530@ZenIV.linux.org.uk>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063684.32346.12253005903079702405.stgit@fedora-28>
 <20191009144859.GB10349@infradead.org>
 <20191009152127.GZ26530@ZenIV.linux.org.uk>
 <20191009152911.GA30439@infradead.org>
 <20191009160310.GA26530@ZenIV.linux.org.uk>
 <20191009180102.GA9056@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009180102.GA9056@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 11:01:02AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 05:03:10PM +0100, Al Viro wrote:
> > Except that I want to be able to have something like
> > -       fsparam_enum   ("errors",             Opt_errors),
> > +       fsparam_enum   ("errors",             Opt_errors, gfs2_param_errors),
> > with
> > +static const struct fs_parameter_enum gfs2_param_errors[] = {
> > +       {"withdraw",   Opt_errors_withdraw },
> > +       {"panic",      Opt_errors_panic },
> > +       {}
> > +};
> > instead of having them all squashed into one array, as in
> 
> Makes total sense and still fits the above scheme.
> 
> > IOW, I want to kill ->enums thing.  And ->name is also trivial
> > to kill, at which point we are left with just what used to be
> > ->specs.
> 
> Agreed.
> 
> > I have some experiments in that direction (very incomplete right
> > now) in #work.mount-parser-later; next cycle fodder, I'm afraid.
> 
> I like that a lot, and feel like we really shouldn't do more
> conversions until that ground work has been done

I'm not sure - for one thing, it's pretty much orthogonal to the
bulk of conversion; for another, I'm very sceptical about grand
schemes invented out of thin air in hope to cover everything in
the world, without finding out what _is_ there first.

Massaging the parser data structures can be done on top of the
other work just as well - the conflicts will be trivial to deal
with.  And I'm perfectly fine with having the parser stuff
go in last, just prior to -rc1, so resolution will be my
headache.

Alternatively, I can do never-rebased short branch right now,
with the parts of changes likely to cause conflicts, so that
xfs, nfs, etc. work could pull it and be done with that.

Note that e.g. conversion of fs_is_... from enum members to
functions would require zero changes in filesystems.  It would
allow to simplify them later on, but I would very much prefer
to do those extra helpers with converted codebase already
on hand.
