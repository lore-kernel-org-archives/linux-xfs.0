Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37622 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdAJW3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 17:29:21 -0500
Date: Tue, 10 Jan 2017 14:29:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Message-ID: <20170110222912.GM14038@birch.djwong.org>
References: <20170110194249.GK14038@birch.djwong.org>
 <73a62730-59a9-cad4-ca33-f054e544459b@sandeen.net>
 <20170110212721.GL14038@birch.djwong.org>
 <c4127369-3be4-bb80-daf5-1548fd07df48@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4127369-3be4-bb80-daf5-1548fd07df48@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Tue, Jan 10, 2017 at 03:34:05PM -0600, Eric Sandeen wrote:
> On 1/10/17 3:27 PM, Darrick J. Wong wrote:
> >> What about sanitizing only the agcount, and saying something like:
> >>
> >> xfs_db: device fsfile AG count is insane.  Initializing only first $X
> >>
> >> (where $X is based on your heuristics)
> > I feel like "Initializing" could be misinterpreted as formatting the
> > disk.  How about:
> > 
> > xfs_db: device fsfile AG count is insane.  Reading only the first $X AGs.
> 
> Sure.  (I'm not sure what the implications are - it's more than just
> "Oh, we didn't read it" right?  It'll have implications for use if
> more AGs really exist?)

I don't think there are.  AFAICT we don't ever write the m_sb values
back to disk; the only commands capable of writing (blocktrash, write,
fuzz) deal with buffers directly.  There's a side effect that things
like metadump will only dump the first $X AGs worth of metadata, but
right now it'll simply OOM and crash.

--D

> 
> -Eric
> 
> > ?
> > 
> > --D
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
