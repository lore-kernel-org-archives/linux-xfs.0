Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751739AbdHBTsu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 15:48:50 -0400
Date: Wed, 2 Aug 2017 21:48:48 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 6/7] mkfs: extend opt_params with a value field
Message-ID: <20170802194848.GI18884@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-7-jtulak@redhat.com>
 <20170727161806.GJ18884@wotan.suse.de>
 <30eae9db-14fd-b245-3aab-5c1670894b44@redhat.com>
 <20170729170241.GM18884@wotan.suse.de>
 <27945607-28e6-31ec-7844-b63a729d040c@redhat.com>
 <20170802165716.GF18884@wotan.suse.de>
 <4f4baa41-335a-5906-a5f7-45e01d9ce88f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f4baa41-335a-5906-a5f7-45e01d9ce88f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Wed, Aug 02, 2017 at 08:11:38PM +0200, Jan Tulak wrote:
> On 02/08/2017 18:57, Luis R. Rodriguez wrote:
> > On Wed, Aug 02, 2017 at 04:43:09PM +0200, Jan Tulak wrote:
> > > The reason for better messages is reasonable. About the style... well, it
> > > makes sense. But I would certainly not do this in this set. So, I think
> > > about a way how to keep the current behavior, but slowly build up the ground
> > > for something like what you suggest.
> > > 
> > > Using the same style of error-returning logic from the other email ([PATCH
> > > 1/7] mkfs: Save raw ...), the error argument pointer would be optional. So,
> > > when you do parse_conf_val(OPT_D, D_AGCOUNT, str, NULL); then you get the
> > > old behavior and any error causes a termination inside of this function. But
> > > if you instead pass some pointer: parse_conf_val(OPT_D, D_AGCOUNT, str,
> > > &err); then right now, we would print the message but do not terminate. And
> > > later on, some other message handling can be added.
> > I think this is grotesque. Also, how would we know an error did happen then?
>
> Just test if err is 0 or not, same as with errno.h. And the dual behavior
> would be only a temporary measure. Once all uses are converted to the new
> behavior, the terminating part can be dropped and the error argument will
> become mandatory.

Yes, I think this is not nice if I understood what you say below correctly.

> > > > > If some value is out of range, or it is a
> > > > > conflict, there is not much context needed, and better to not have to care
> > > > > about these errors... Do you have an example when it would be helpful? If it
> > > > > just spits out a return code, you have to add a check to every use and you
> > > > > will have many times the same code like what is in getnum() at this moment
> > > > Not really, if we are parsing say D_AGCOUNT we could have a member as part of the
> > > > struct, say "description" then we can use say subopt[D_AGCOUNT].description on
> > > > the error message, perhaps the only thing that would change for instance would be
> > > > the context on which the error was run into, command line option passed or config
> > > > file read, say with the filename and line number.
> > > > 
> > > > How would we be able to detect an error happened and pass exactly where the
> > > > error happened otherwise on a config file for example?
> > > Yes, I see the issue - getnum finds an error, but it doesn't know the line
> > > in the config file to report it. But with what I write above about the error
> > > handling, this could work.
> > > 
> > > if (c < sp->minval) {
> > >      if (config_file) illegal_config(str, line, opts, index, _("value is too
> > > small"), err);
> > How would it know what str and line are?
>
> The "line" argument is a mistake, it shouldn't be here - it is solved by the
> snipped below. The "str" is already there, it is what getnum() parses - only
> the "err" at the end would be added.

So you mean the error code would only be visible on the print out, but not
passed to the caller as a starting step. A secondary step would go and change
that to then return the error code and have each caller check it?

> > 
> > >      else illegal_option(str, opts, index, _("value is too small"), err);
> > > }
> > This seems convoluted and I don't really like it one bit.
> > 
> > > ... and later in the code, if you are in the config file, you could do
> > > something like:
> > > 
> > > parse_conf_val(opt, subopt, str, &err);
> > > if (err) report_invalid_line(current_line);
> > > 
> > > Thoughts?
> > Just my take: I prefer we do the right thing from the start. Even
> > if it takes us ages to move forward, baby steps, and clean patches
> > and evolutions, moving slowly away from the old crazy habits.
>
> In which case, I would just continue as we do now (terminating on an error),
> and then change it in the whole mkfs at once in some other patch set. There
> always will be something old and ugly we have to use temporarily, or we end
> up stashing one patchset after another, always trying to fix some other
> thing first, and never really fixing anything.

It seems like a change which could be fit into your series, it is more work,
but then again most of the work here was expected to be significant and doing
away with a lot of crap.

Up to you, I just am providing my own feedback and making clear the requirements
for the config stuff. I think it will be silly to add config support without
having the ability to catch errors and then indicate on its own however it
chooses exactly where the error occurred.

Will you take on doing the error code changes after ?

  Luis
