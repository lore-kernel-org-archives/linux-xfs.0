Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751731AbeCOMls (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:41:48 -0400
Date: Thu, 15 Mar 2018 08:41:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: always check for and process unlinked inodes on
 mount
Message-ID: <20180315124143.GB45325@bfoster.bfoster>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <d35d1067-a6f6-09be-9c4c-3e08a3bec3be@sandeen.net>
 <20180315121717.GA45325@bfoster.bfoster>
 <60f1a77c-61f7-08fc-dffd-4734b1efd322@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60f1a77c-61f7-08fc-dffd-4734b1efd322@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 15, 2018 at 08:19:40AM -0400, Eric Sandeen wrote:
> 
> 
> On 3/15/18 8:17 AM, Brian Foster wrote:
> > Have we considered anything like conditionally dirtying the log on
> > freeze only when there are open+unlinked files? It seems like that may
> > be uncommon enough to address the problem for snapshot users
> > (particularly the read-only use case mentioned in the cover letter), but
> > that's just a guess.
> > 
> > Brian
> 
> 
> I did consider that, and was weighing the advantages with the disadvantages,
> namely unpredictable behavior for snapshots...  I'm not sure how uncommon
> the situation really is.
> 

Ok.

> Regarding the mount delay, Darrick suggested that maybe we need to get
> all these scans into one place if possible, for efficiency.
> 

These buffers should be cached after the first scan, right? As Dave
mentioned on one of the previous threads, I think the I/O load is more
of a factor than anything else.

I'd rather see us try to eliminate these kinds of scans rather than
condense them into some kind of infrastructure that tries to
self-justify their existence. But as previously mentioned, I think it's
reasonable to add this one for now and optimize it away separately.

Brian

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
