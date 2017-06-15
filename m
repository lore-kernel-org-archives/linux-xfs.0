Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751908AbdFOLX6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jun 2017 07:23:58 -0400
Date: Thu, 15 Jun 2017 07:23:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] metadump: warn about corruption if log is dirty
Message-ID: <20170615112356.GA5909@bfoster.bfoster>
References: <20170413081354.22170-1-jtulak@redhat.com>
 <20170413081354.22170-2-jtulak@redhat.com>
 <20170413115408.GA24893@bfoster.bfoster>
 <5bb73256-ff28-6b3e-0bc4-91402174d96a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bb73256-ff28-6b3e-0bc4-91402174d96a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Jun 14, 2017 at 07:06:52PM -0500, Eric Sandeen wrote:
> On 4/13/17 6:54 AM, Brian Foster wrote:
> > On Thu, Apr 13, 2017 at 10:13:53AM +0200, Jan Tulak wrote:
> >> Add a warning about possible corruption when exporting a dirty log, as
> >> the log content does not agree with obfuscated metadata.
> >>
> >> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >> ---
> >> Change: More elaborate warning message.
> >> ---
> >>  db/metadump.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/db/metadump.c b/db/metadump.c
> >> index 66952f6..2dd8593 100644
> >> --- a/db/metadump.c
> >> +++ b/db/metadump.c
> >> @@ -2726,7 +2726,9 @@ copy_log(void)
> >>  		/* keep the dirty log */
> >>  		if (obfuscate)
> >>  			print_warning(
> >> -_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
> >> +_("Warning: log recovery of an obfuscated metadata image can leak "
> >> +"unobfuscated metadata and/or cause image corruption. Please mount "
> >> +"the source filesystem to clean the log or disable obfuscation, if possible."));
> >>  		break;
> > 
> > Thanks Jan, just one very minor nit having read this again... could we
> > put the "if possible" closer to the part about mounting the source
> > image? Otherwise it reads to me that it might not be technically
> > possible to disable obfuscation, which is not the case (though the user
> > may not want to do that as a matter of policy). For example:
> > 
> > "... Please mount the source filesystem to clean the log, if possible,
> > or disable obfuscation."
> 
> Hoovering up old patches ... 
> 
> To me, Jan's original is ok.  "If possible" applying to both replay and
> disabling obfuscation seems reasonable, because "policy" may make it
> impossible ;)  So I hate to direct the user to disable obfuscation.
> 
> "If possible, please mount the filesystem to clean the log, or disable
> obfuscation."
> 
> Is that OK?  Gives the user options, and wiggle room..
> 

Sounds good to me, thanks!

Brian

> -Eric
> 
> > With that tweak:
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
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
