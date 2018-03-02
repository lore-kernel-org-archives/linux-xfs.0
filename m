Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbeCBQY7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 11:24:59 -0500
Date: Fri, 2 Mar 2018 08:24:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_scrub: make interpreter explicit to python3
Message-ID: <20180302162455.GK12763@magnolia>
References: <20180224021512.23819-1-mcgrof@kernel.org>
 <20180224044018.GA19312@magnolia>
 <4f0ac49f-8a87-4b69-8b06-43ca6b9930a0@sandeen.net>
 <20180302090842.yln3r2qalmsvbw4j@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302090842.yln3r2qalmsvbw4j@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Fri, Mar 02, 2018 at 10:08:42AM +0100, Carlos Maiolino wrote:
> On Thu, Mar 01, 2018 at 10:05:09PM -0600, Eric Sandeen wrote:
> > 
> > 
> > On 2/23/18 10:40 PM, Darrick J. Wong wrote:
> > > On Fri, Feb 23, 2018 at 06:15:12PM -0800, Luis R. Rodriguez wrote:
> > >> Using #!/usr/bin/env makes some package dependency tools
> > >> such as rpm complain given that it cannot verify package
> > >> dependencies. Making it explicit resolves this lint rant.
> > >>
> > >> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > > 
> > > Looks ok,
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > intereting, my rpmbuild actually converts this on the fly.  ;)
> > But fine by me to hardcode it if Darrick says ok.  :)
> > 
> 
> Just a question though about this.
> 
> What if somebody/somedistro installs python3 on another $PATH?
> 
> It's been a while since I don't do any packaging stuff, so, I just wonder if
> this couldn't cause issues on distros using different install paths?

They can always patch in the path to their python3 executable.

Though, given the number of /usr/bin/python3 scripts floating around in
Google, I'm guessing a distro would have to have a really good reason to
put it elsewhere.

--D

> Cheers.
> 
> > Thanks,
> > -Eric
> > 
> > > --D
> > > 
> > >> ---
> > >>  scrub/xfs_scrub_all.in | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
> > >> index fff05da3ea7a..80f07d5c8b02 100644
> > >> --- a/scrub/xfs_scrub_all.in
> > >> +++ b/scrub/xfs_scrub_all.in
> > >> @@ -1,4 +1,4 @@
> > >> -#!/usr/bin/env python3
> > >> +#!/usr/bin/python3
> > >>  
> > >>  # Run online scrubbers in parallel, but avoid thrashing.
> > >>  #
> > >> -- 
> > >> 2.16.2
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
