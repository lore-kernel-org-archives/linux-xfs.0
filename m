Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49648 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753085AbcKSAVe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Nov 2016 19:21:34 -0500
Subject: Re: new helpers to clean up extent tree lookups
References: <1479143565-30615-1-git-send-email-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b66cd943-7695-797d-cd80-d97019086e1b@sandeen.net>
Date: Fri, 18 Nov 2016 18:21:32 -0600
MIME-Version: 1.0
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 11/14/16 11:12 AM, Christoph Hellwig wrote:
> Now that Eric send out xfs_iext_count before I could get to it I need
> to get my other iext helpers out ASAP before running into another
> rebase :)

I could have deferred if you had spoken up ;)

(I did think that iext_count probably wasn't the end of it)

-Eric

> This series adds two new helpers that make iterating the extent list
> a lot cleaner.  They are the first step towards better abstracting out
> access to the extent list and thus allowing us to experiment with
> better data structures for it.  The next step is the manipulations
> in xfs_bmap_{add,del}_extent*, which will be more work than these
> helpers, but I have some of that in progress.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
