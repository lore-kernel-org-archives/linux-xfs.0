Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33230 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729262AbeGRUjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 16:39:11 -0400
Date: Wed, 18 Jul 2018 12:59:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: filefrag and reflink
Message-ID: <20180718195940.GA4813@magnolia>
References: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtSJUV-0LYCTS2mfeZWA812aqc5oQagsWZ5fi3xuXQ9ncA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Wed, Jul 18, 2018 at 12:41:27PM -0600, Chris Murphy wrote:
> xfsprogs 4.17.0 mkfs with reflink=1
> kernel 4.17.6
> 
> $ fallocate -l 1g tmp2
> $ cp --reflink tmp2 tmp3
> $ filefrag -v *
> Filesystem type is: 58465342
> File size of tmp2 is 1073741824 (262144 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..  130136:         24..    130160: 130137:             unwritten
>    1:   130137..  260280:     131082..    261225: 130144:     130161: unwritten
>    2:   260281..  262143:     264714..    266576:   1863:     261226:
> last,unwritten,eof
> tmp2: 3 extents found
> File size of tmp3 is 1073741824 (262144 blocks of 4096 bytes)
> tmp3: 0 extents found
> [chris@f28s xfs]$
> 
> 
> Is this expected? When I do it on Btrfs, I see identical information
> for the two files after reflink copy, with flags "unwritten,shared".

Yes.  xfs doesn't share unwritten extents; what would be the point?

--D

> Regular files behave as expected, I'm only seeing this on reflink
> copies of fallocated files.
> 
> 
> 
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
