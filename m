Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756820AbcIMI76 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Sep 2016 04:59:58 -0400
Date: Tue, 13 Sep 2016 10:59:54 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Document error handlers behavior
Message-ID: <20160913085954.utmek4734tp2utli@redhat.com>
References: <1473326635-30209-1-git-send-email-cmaiolino@redhat.com>
 <15083dbd-d598-0ec1-25d7-26cb039dd78d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15083dbd-d598-0ec1-25d7-26cb039dd78d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 09:29:18AM -0500, Eric Sandeen wrote:
> On 9/8/16 4:23 AM, Carlos Maiolino wrote:
> > Document the implementation of error handlers into sysfs.
> > 
> > Changelog:
> > 
> > V2:
> > 	- Add a description of the precedence order of each option, focusing on
> > 	  the behavior of "fail_at_unmount" which was not well explained in V1
> > 
> > V3:
> > 	- Fix English spelling mistakes suggested by Eric
> 
> Please put the patch version changelog after the "---" so it doesn't become
> part of the permanent commit log; it's for current patch reviewers, not for
> future code archaeologists.

Thanks, I'll make sure to do it with next patches too
> > +
> > +The filesystem behavior during an error can be set via sysfs files, where the
> > +errors are organized with the structure below. Each configuration option works
> > +independently, the first condition met for a specific configuration will cause
> > +the filesystem to shut down:
> > +
> > +  /sys/fs/xfs/<dev>/error/<class>/<error>/
> 
> The above line kind of hangs there oddly, because the first thing you do below
> is describe a file which isn't in the above hierarchy.
> 
> Maybe we should show something like:
> 
> +  /sys/fs/xfs/<dev>/error/fail_at_unmount
> +  /sys/fs/xfs/<dev>/error/<class>/<error>/<configuration>
> 
> to show everything that might be under it?  Not sure if that's better.
> 
> > +
> > +Each directory contains:
> > +
> > + /sys/fs/xfs/<dev>/error/
> > +
> > +	fail_at_unmount		(Min:  0  Default:  1  Max: 1)
> > +		Defines the global error behavior at unmount time. If set to the
> > +		default value of 1, XFS will cancel any pending IO retries, shut
> > +		down, and unmount. If set to 0, pending IO retries may prevent
> > +		the filesystem from unmounting.
> > +
> > +	<class> subdirectories
> > +		Contains specific error handlers configuration
> > +		(Ex: /sys/fs/xfs/<dev>/error/metadata, see below).
> > +
> > + /sys/fs/xfs/<dev>/error/<class>/
> > +
> > +	Directory containing configuration for a specific error <class>;
> > +	currently only the "metadata" <class> is implemented.
> > +	The contents of this directory are <class> specific, since each <class>
> > +	might need to handle different types of errors.
> > +
> > + /sys/fs/xfs/<dev>/error/<class>/<error>/
> > +
> 
> The default for ENODEV is different ... tricky to document that.  Good luck.  ;)
> 
> The maximum for retry_timeout_seconds is 86400 (1 day), not INTMAX:
> 
> retry_timeout_seconds_store()
> {
> ...
>         /* 1 day timeout maximum */
>         if (val < 0 || val > 86400)
>                 return -EINVAL;
> ...

Fixing it, thanks for catching it, copy/paste sux :)

> }
> 
> The default of -1 vs. 0 might change with the other patch I sent, but we can
> fix this up if it's accepted.
> 

Ok.

Thanks for the review, I'll submit a new version in a few
-- 
Carlos
