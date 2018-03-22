Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54712 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752266AbeCVUVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 16:21:06 -0400
Received: by mail-wm0-f65.google.com with SMTP id h76so18330136wme.4
        for <linux-xfs@vger.kernel.org>; Thu, 22 Mar 2018 13:21:05 -0700 (PDT)
Date: Thu, 22 Mar 2018 21:21:02 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC] xfsprogs: remove irix, darwin, freebsd support
Message-ID: <20180322202102.wpff347scdmfpv62@odin.usersys.redhat.com>
References: <20180321001456.GM1757@magnolia>
 <17870b11-8567-7938-e510-dbc22fd107f6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17870b11-8567-7938-e510-dbc22fd107f6@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Thu, Mar 22, 2018 at 02:49:42PM -0500, Eric Sandeen wrote:
> On 3/20/18 7:14 PM, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is a metapatch proposing that we drop all the non-Linux xfsprogs
> > ports.
> > 
> > Irix hasn't had a release since August 2006.
> > 
> > OSX doesn't support XFS and (afaict) never has.
> > 
> > FreeBSD EOL'd v9.3 (which was the last one to support XFS) in January
> > 2017.
> > 
> > So, can we git rm {include,libxfs}/{irix,darwin,freebsd}.[ch] ?
> 
> I sent out the same query in May 2017,
> "RFC: removing non-linux platform support from xfsprogs"
> 
> and nobody really chimed in to keep any of it.  I'm happy to nuke it,
> and if someone comes back with a tail of woe, we can always put it back
> in place if it's deemed wise.
> 

+1, FreeBSD never meant to actually have a 'fully supported' XFS port anyway,
and nobody was interested in updating it to comply with their VFS changes
between 9 and 10, so they just decided to drop it. And Irix is EOL, so I believe
it's safe to remove it.


-- 
Carlos
