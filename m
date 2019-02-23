Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:59862 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfBWCqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 21:46:31 -0500
Message-ID: <5C70AC01.3060306@tlinx.org>
Date: Fri, 22 Feb 2019 18:12:17 -0800
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] xfsprogs v4.20.0 released
References: <59a16d27-0370-12c3-4590-071f88a9d3fb@sandeen.net>
In-Reply-To: <59a16d27-0370-12c3-4590-071f88a9d3fb@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 2/22/2019 10:33 AM, Eric Sandeen wrote:
>         - xfs_scrub: move all executables to /usr/sbin (Darrick Wong)
>   
---
    How does moving executables to /usr/sbin pertain to cleaning
metadata?  What happens if /usr is not mounted or not created
and the user is running the xfs utils out of /sbin??  For that
matter, if the tools are run out of /sbin, are you saying xfs_scrub
will move them all off of the root partition onto the /usr partition?

    If you are moving the executables, are you also moving all of their
linked libraries?  It seems if you are wanting safety, moving the libraries
and executables to the same directory would be prudent, otherwise,
why move them to to /usr/sbin?
>         - Merge libxfs from kernel 4.20 
>   
What is libxfs being merged with?

Thanks!
