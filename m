Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53985 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751162AbdHBQ5S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 12:57:18 -0400
Date: Wed, 2 Aug 2017 18:57:16 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 6/7] mkfs: extend opt_params with a value field
Message-ID: <20170802165716.GF18884@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-7-jtulak@redhat.com>
 <20170727161806.GJ18884@wotan.suse.de>
 <30eae9db-14fd-b245-3aab-5c1670894b44@redhat.com>
 <20170729170241.GM18884@wotan.suse.de>
 <27945607-28e6-31ec-7844-b63a729d040c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27945607-28e6-31ec-7844-b63a729d040c@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Wed, Aug 02, 2017 at 04:43:09PM +0200, Jan Tulak wrote:
> On 29/07/2017 19:02, Luis R. Rodriguez wrote:
> > On Fri, Jul 28, 2017 at 04:44:50PM +0200, Jan Tulak wrote:
> > > And do we need better messages?
> > We could later when parsing the configuration file, yes. An abort is fine too but
> > seems rather grotesque. But also more importantly this is a matter of style and I
> > realize the old style is to just abort/assert, so I figured it would be a good time
> > now to ask ourselves if we want proper error messages dealt with / passed slowly
> > moving forward.
> > 
> > But yes, I do suspect we may want better error messages when parsing these. This
> > may mean for instance we want a string built into the struct that defines the sobopt
> > so we can use it to inform userspace using a pointer to the description rather than
> > doing a switch statement on each one and interpreting back to plain english.
> > 
> The reason for better messages is reasonable. About the style... well, it
> makes sense. But I would certainly not do this in this set. So, I think
> about a way how to keep the current behavior, but slowly build up the ground
> for something like what you suggest.
> 
> Using the same style of error-returning logic from the other email ([PATCH
> 1/7] mkfs: Save raw ...), the error argument pointer would be optional. So,
> when you do parse_conf_val(OPT_D, D_AGCOUNT, str, NULL); then you get the
> old behavior and any error causes a termination inside of this function. But
> if you instead pass some pointer: parse_conf_val(OPT_D, D_AGCOUNT, str,
> &err); then right now, we would print the message but do not terminate. And
> later on, some other message handling can be added.

I think this is grotesque. Also, how would we know an error did happen then?

> > > If some value is out of range, or it is a
> > > conflict, there is not much context needed, and better to not have to care
> > > about these errors... Do you have an example when it would be helpful? If it
> > > just spits out a return code, you have to add a check to every use and you
> > > will have many times the same code like what is in getnum() at this moment
> > Not really, if we are parsing say D_AGCOUNT we could have a member as part of the
> > struct, say "description" then we can use say subopt[D_AGCOUNT].description on
> > the error message, perhaps the only thing that would change for instance would be
> > the context on which the error was run into, command line option passed or config
> > file read, say with the filename and line number.
> > 
> > How would we be able to detect an error happened and pass exactly where the
> > error happened otherwise on a config file for example?
> Yes, I see the issue - getnum finds an error, but it doesn't know the line
> in the config file to report it. But with what I write above about the error
> handling, this could work.
> 
> if (c < sp->minval) {
>     if (config_file) illegal_config(str, line, opts, index, _("value is too
> small"), err);

How would it know what str and line are?

>     else illegal_option(str, opts, index, _("value is too small"), err);
> }

This seems convoluted and I don't really like it one bit.

> ... and later in the code, if you are in the config file, you could do
> something like:
> 
> parse_conf_val(opt, subopt, str, &err);
> if (err) report_invalid_line(current_line);
> 
> Thoughts?

Just my take: I prefer we do the right thing from the start. Even 
if it takes us ages to move forward, baby steps, and clean patches
and evolutions, moving slowly away from the old crazy habits.

  Luis
