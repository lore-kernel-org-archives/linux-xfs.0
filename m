Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752610AbdDKSnz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 14:43:55 -0400
Date: Tue, 11 Apr 2017 14:43:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] metadump: warn about corruption if log is dirty
Message-ID: <20170411184350.GC3865@bfoster.bfoster>
References: <20170411141237.9274-1-jtulak@redhat.com>
 <20170411141237.9274-2-jtulak@redhat.com>
 <20170411183036.GA3865@bfoster.bfoster>
 <272b1e64-96fe-ab9a-12f3-1fc73a0c85ea@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <272b1e64-96fe-ab9a-12f3-1fc73a0c85ea@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Apr 11, 2017 at 01:34:25PM -0500, Eric Sandeen wrote:
> On 4/11/17 1:30 PM, Brian Foster wrote:
> > On Tue, Apr 11, 2017 at 04:12:36PM +0200, Jan Tulak wrote:
> >> Add a warning about possible corruption when exporting a dirty log, as
> >> the log content does not agree with obfuscated metadata.
> >>
> >> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >> ---
> > 
> > Thanks for posting this...
> > 
> >>  db/metadump.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/db/metadump.c b/db/metadump.c
> >> index 66952f6..74e24b2 100644
> >> --- a/db/metadump.c
> >> +++ b/db/metadump.c
> >> @@ -2726,7 +2726,8 @@ copy_log(void)
> >>  		/* keep the dirty log */
> >>  		if (obfuscate)
> >>  			print_warning(
> >> -_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
> >> +_("Filesystem log is dirty; image will contain unobfuscated metadata in log "
> >> +  "and a log replay can cause a corruption."));
> > 
> > I think a slightly more verbose message might be a good idea. For
> > example, something like the following:
> > 
> > "Filesystem log is dirty; image will contain unobfuscated metadata in
> > the log. Log recovery of an obfuscated image can cause filesystem
> > corruption. Please mount the source image to clean the log or disable
> > metadump obfuscation."
> > 
> > That could also say "... or verify that log recovery of the resulting
> > image does not cause corruption," but that might be overkill. Thoughts?
> > Eric?
> 
> I think we do need a good explanation, but that will take a lot of workd.
> We could also refer to the man page for more details - it's getting pretty
> long for a warning from the tool.
> 

Hm, yeah. Maybe the existing warning can be condensed a bit more to
something like:

"Warning: log recovery of an obfuscated metadata image can leak
unobfuscated metadata and/or cause filesystem corruption. Please mount
the source image to clean the log or disable obfuscation."

I suppose we could also just exit under such conditions unless the user
passes a force flag or something. Maybe that's overkill too, though..

Brian

> The other bummer is that we cannot detect whether an image has been
> obfuscated, so the restore tool can only say "if it's obfuscated...."
> 
> -Eric
> 
> > Brian
> > 
> >>  		break;
> >>  	case -1:
> >>  		/* log detection error */
> >> -- 
> >> 2.1.4
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
