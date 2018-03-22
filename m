Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57166 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751713AbeCVTtn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 15:49:43 -0400
Subject: Re: [RFC] xfsprogs: remove irix, darwin, freebsd support
References: <20180321001456.GM1757@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <17870b11-8567-7938-e510-dbc22fd107f6@sandeen.net>
Date: Thu, 22 Mar 2018 14:49:42 -0500
MIME-Version: 1.0
In-Reply-To: <20180321001456.GM1757@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>

On 3/20/18 7:14 PM, Darrick J. Wong wrote:
> Hi all,
> 
> This is a metapatch proposing that we drop all the non-Linux xfsprogs
> ports.
> 
> Irix hasn't had a release since August 2006.
> 
> OSX doesn't support XFS and (afaict) never has.
> 
> FreeBSD EOL'd v9.3 (which was the last one to support XFS) in January
> 2017.
> 
> So, can we git rm {include,libxfs}/{irix,darwin,freebsd}.[ch] ?

I sent out the same query in May 2017,
"RFC: removing non-linux platform support from xfsprogs"

and nobody really chimed in to keep any of it.  I'm happy to nuke it,
and if someone comes back with a tail of woe, we can always put it back
in place if it's deemed wise.

-Eric
