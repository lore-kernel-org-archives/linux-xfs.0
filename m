Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 08 Mar 2008 03:54:22 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m28Brx2b021321
	for <xfs@oss.sgi.com>; Sat, 8 Mar 2008 03:54:01 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BAEAF44BAA
	for <xfs@oss.sgi.com>; Sat,  8 Mar 2008 03:54:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id xLAulTBskzB9FOhk for <xfs@oss.sgi.com>; Sat, 08 Mar 2008 03:54:29 -0800 (PST)
Date: Sat, 8 Mar 2008 06:54:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
Message-ID: <20080308115427.GB27606@infradead.org>
References: <47D20F78.7000103@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D20F78.7000103@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 07, 2008 at 10:00:56PM -0600, Eric Sandeen wrote:
> It looks like all of the below is unused... and according
> to Nathan,
> 
> "dont think it even got used/implemented anywhere, but i think it 
> was meant to be an auto-mount kinda thing... such that when you look 
> up at that point, it knows to mount the device with that uuid there, 
> if its not already it was never really written anywhere ... just an 
> idea in doug doucettes brain i think."
> 
> Think it'll ever go anywhere, or should it get pruned?
> 
> The below builds; not at all tested, until I get an idea if it's worth
> doing.  Need to double check that some structures might not need padding
> out to keep things compatible/consistent...

This looks fine to me.  But please keep the XFS_DINODE_FMT_UUID enum
value and add a big comment close to it documenting what it was an maybe
a approximate removal date so people who care about it can look it up
in the SCM history easily.
