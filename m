Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752644AbdG2RCn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 29 Jul 2017 13:02:43 -0400
Date: Sat, 29 Jul 2017 19:02:41 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 6/7] mkfs: extend opt_params with a value field
Message-ID: <20170729170241.GM18884@wotan.suse.de>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-7-jtulak@redhat.com>
 <20170727161806.GJ18884@wotan.suse.de>
 <30eae9db-14fd-b245-3aab-5c1670894b44@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30eae9db-14fd-b245-3aab-5c1670894b44@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Fri, Jul 28, 2017 at 04:44:50PM +0200, Jan Tulak wrote:
> On 27/07/2017 18:18, Luis R. Rodriguez wrote:
> > On Thu, Jul 20, 2017 at 11:29:31AM +0200, Jan Tulak wrote:
> > This also limits the use of parse_conf_val() in that we won't be able to
> > customize error messages with better context, so its a good time to evaluate
> > if we want to continue with that tradition or let parse_conf_val() return
> > int and if it returns 0 it was successful, otherwise an error value.
> Quoting also the other email (Re: [PATCH 1/5 v2] mkfs: replace variables
> with opts table: -b,d,s options):
> > Here parse_conf_val() is used only to update D_AGCOUNT based on the parsed
> > value. But note that the return value is ignored. In some other places the
> > return value is used. This is inconsistent, and I realize that the reason
> > we ignore errors is that getnum() is used, however now is a good time to
> > consider if we should just allow the caller to check the error value and
> > return a proper error message and bail on their own. This would allow for
> > better contextual error messages as the code grows. We can discuss this in
> > the patch that adds parse_conf_val().
> 
> And do we need better messages?

We could later when parsing the configuration file, yes. An abort is fine too but
seems rather grotesque. But also more importantly this is a matter of style and I
realize the old style is to just abort/assert, so I figured it would be a good time
now to ask ourselves if we want proper error messages dealt with / passed slowly
moving forward.

But yes, I do suspect we may want better error messages when parsing these. This
may mean for instance we want a string built into the struct that defines the sobopt
so we can use it to inform userspace using a pointer to the description rather than
doing a switch statement on each one and interpreting back to plain english.

> If some value is out of range, or it is a
> conflict, there is not much context needed, and better to not have to care
> about these errors... Do you have an example when it would be helpful? If it
> just spits out a return code, you have to add a check to every use and you
> will have many times the same code like what is in getnum() at this moment

Not really, if we are parsing say D_AGCOUNT we could have a member as part of the
struct, say "description" then we can use say subopt[D_AGCOUNT].description on
the error message, perhaps the only thing that would change for instance would be
the context on which the error was run into, command line option passed or config
file read, say with the filename and line number.

How would we be able to detect an error happened and pass exactly where the
error happened otherwise on a config file for example?

  Luis
