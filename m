Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45540 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425193AbeCBJIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 04:08:46 -0500
Received: by mail-wr0-f196.google.com with SMTP id p104so9281884wrc.12
        for <linux-xfs@vger.kernel.org>; Fri, 02 Mar 2018 01:08:46 -0800 (PST)
Date: Fri, 2 Mar 2018 10:08:42 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_scrub: make interpreter explicit to python3
Message-ID: <20180302090842.yln3r2qalmsvbw4j@odin.usersys.redhat.com>
References: <20180224021512.23819-1-mcgrof@kernel.org>
 <20180224044018.GA19312@magnolia>
 <4f0ac49f-8a87-4b69-8b06-43ca6b9930a0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f0ac49f-8a87-4b69-8b06-43ca6b9930a0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org

On Thu, Mar 01, 2018 at 10:05:09PM -0600, Eric Sandeen wrote:
> 
> 
> On 2/23/18 10:40 PM, Darrick J. Wong wrote:
> > On Fri, Feb 23, 2018 at 06:15:12PM -0800, Luis R. Rodriguez wrote:
> >> Using #!/usr/bin/env makes some package dependency tools
> >> such as rpm complain given that it cannot verify package
> >> dependencies. Making it explicit resolves this lint rant.
> >>
> >> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > 
> > Looks ok,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> intereting, my rpmbuild actually converts this on the fly.  ;)
> But fine by me to hardcode it if Darrick says ok.  :)
> 

Just a question though about this.

What if somebody/somedistro installs python3 on another $PATH?

It's been a while since I don't do any packaging stuff, so, I just wonder if
this couldn't cause issues on distros using different install paths?

Cheers.

> Thanks,
> -Eric
> 
> > --D
> > 
> >> ---
> >>  scrub/xfs_scrub_all.in | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
> >> index fff05da3ea7a..80f07d5c8b02 100644
> >> --- a/scrub/xfs_scrub_all.in
> >> +++ b/scrub/xfs_scrub_all.in
> >> @@ -1,4 +1,4 @@
> >> -#!/usr/bin/env python3
> >> +#!/usr/bin/python3
> >>  
> >>  # Run online scrubbers in parallel, but avoid thrashing.
> >>  #
> >> -- 
> >> 2.16.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
