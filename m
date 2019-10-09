Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25095ECE58E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F388720679
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbfJIQDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:03:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48624 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731724AbfJIQDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:03:15 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIEQg-0005ME-Nv; Wed, 09 Oct 2019 16:03:10 +0000
Date:   Wed, 9 Oct 2019 17:03:10 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20191009160310.GA26530@ZenIV.linux.org.uk>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063684.32346.12253005903079702405.stgit@fedora-28>
 <20191009144859.GB10349@infradead.org>
 <20191009152127.GZ26530@ZenIV.linux.org.uk>
 <20191009152911.GA30439@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009152911.GA30439@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 08:29:11AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 04:21:27PM +0100, Al Viro wrote:
> > What we need to do is to turn fs_parameter_type into a pointer
> > to function.  With fs_param_is_bool et.al. becoming instances
> > of such, and fs_parse() switch from hell turning into
> > 	err = p->type(p, param, result);
> > 
> > That won't affect the existing macros or any filesystem code.
> > If some filesystem wants to have helpers of its own - more
> > power to it, just use __fsparam(my_bloody_helper, "foo", Opt_foo, 0)
> > and be done with that.
> 
> Actually, while we could keep the old macros around at least
> temporarily for existing users I think killing them actually would
> improve the file systems as well.
> 
> This:
> 
> static const struct fs_parameter_spec afs_param_specs[] = {
> 	{ "autocell",	Opt_autocell,	fs_parse_flag },
> 	{ "dyn",	Opt_dyn,	fs_parse_flag },
> 	{ "flock",	Opt_flock,	fs_parse_enum },
> 	{ "source",	Opt_source,	fs_parse_string },
>         {}
> };
> 
> 
> is a lot more obvious than:
> 
> static const struct fs_parameter_spec afs_param_specs[] = {
>         fsparam_flag  ("autocell",      Opt_autocell),
>         fsparam_flag  ("dyn",           Opt_dyn),
>         fsparam_enum  ("flock",         Opt_flock),
>         fsparam_string("source",        Opt_source),
>         {}
> };

Except that I want to be able to have something like
-       fsparam_enum   ("errors",             Opt_errors),
+       fsparam_enum   ("errors",             Opt_errors, gfs2_param_errors),
with
+static const struct fs_parameter_enum gfs2_param_errors[] = {
+       {"withdraw",   Opt_errors_withdraw },
+       {"panic",      Opt_errors_panic },
+       {}
+};
instead of having them all squashed into one array, as in
-static const struct fs_parameter_enum gfs2_param_enums[] = {
-       { Opt_quota,    "off",        Opt_quota_off },
-       { Opt_quota,    "account",    Opt_quota_account },
-       { Opt_quota,    "on",         Opt_quota_on },
-       { Opt_data,     "writeback",  Opt_data_writeback },
-       { Opt_data,     "ordered",    Opt_data_ordered },
-       { Opt_errors,   "withdraw",   Opt_errors_withdraw },
-       { Opt_errors,   "panic",      Opt_errors_panic },
...
 const struct fs_parameter_description gfs2_fs_parameters = {
        .name = "gfs2",
        .specs = gfs2_param_specs,
-       .enums = gfs2_param_enums,
 };

IOW, I want to kill ->enums thing.  And ->name is also trivial
to kill, at which point we are left with just what used to be
->specs.

Another thing is, struct fs_parameter_enum becomes pretty
much identical to struct constant_table and can be folded into it.

I have some experiments in that direction (very incomplete right
now) in #work.mount-parser-later; next cycle fodder, I'm afraid.

	Another thing is, consider something like "it's an
integer in range from 2 to 36".  Fairly useful in many cases,
and we could do helpers for that.  Except that they need a pointer
to helper-private data (the limits)...

	These macros somewhat isolate the filesystems until the
things settle down.  And one needs examples of conversions to
see what's missing - inventing a grand scheme out of thin air
doesn't work...
