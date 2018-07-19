Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41869 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbeGSMRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 08:17:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id j5-v6so7715696wrr.8
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jul 2018 04:34:54 -0700 (PDT)
Date: Thu, 19 Jul 2018 13:34:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: filefrag and reflink
Message-ID: <20180719113450.sbdlljklwkky7isv@odin.usersys.redhat.com>
References: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
 <20180718195940.GA4813@magnolia>
 <165c936c-7dc4-7336-3d7e-268ec6746b56@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165c936c-7dc4-7336-3d7e-268ec6746b56@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Jul 18, 2018 at 01:27:40PM -0700, Eric Sandeen wrote:
> 
> 
> On 7/18/18 12:59 PM, Darrick J. Wong wrote:
> > On Wed, Jul 18, 2018 at 12:41:27PM -0600, Chris Murphy wrote:
> >> xfsprogs 4.17.0 mkfs with reflink=1
> >> kernel 4.17.6
> >>
> >> $ fallocate -l 1g tmp2
> >> $ cp --reflink tmp2 tmp3
> >> $ filefrag -v *
> >> Filesystem type is: 58465342
> >> File size of tmp2 is 1073741824 (262144 blocks of 4096 bytes)
> >>  ext:     logical_offset:        physical_offset: length:   expected: flags:
> >>    0:        0..  130136:         24..    130160: 130137:             unwritten
> >>    1:   130137..  260280:     131082..    261225: 130144:     130161: unwritten
> >>    2:   260281..  262143:     264714..    266576:   1863:     261226:
> >> last,unwritten,eof
> >> tmp2: 3 extents found
> >> File size of tmp3 is 1073741824 (262144 blocks of 4096 bytes)
> >> tmp3: 0 extents found
> >> [chris@f28s xfs]$
> >>
> >>
> >> Is this expected? When I do it on Btrfs, I see identical information
> >> for the two files after reflink copy, with flags "unwritten,shared".
> > 
> > Yes.  xfs doesn't share unwritten extents; what would be the point?
> > 
> > --D
> 
> <materializes somewhere on a US western interstate>
> 
> Seems a little weird that bare cp will create a written file full of
> zeros, while a cp --reflink will create a sparse file, though?

cp actually can have different behaviors when --reflink is specified, from the
manpage (formatting slightly modified):

"
By default, sparse SOURCE files are detected by a crude heuristic and the
corresponding DEST file is made sparse  as  well. That  is  the  behavior
selected  by  --sparse=auto.
Specify --sparse=always  to  create  a  sparse DEST file whenever the SOURCE
file contains a long enough sequence of zero bytes.  Use --sparse=never to
inhibit creation of sparse files.

When --reflink[=always] is specified, perform a lightweight copy,  where  the
data  blocks  are copied  only  when  modified.   If  this is not possible the
copy fails, or if --reflink=auto is specified, fall back to a standard copy.
"

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
