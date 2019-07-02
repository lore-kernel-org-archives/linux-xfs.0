Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGBPQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 11:16:22 -0400
Date: Tue, 2 Jul 2019 08:15:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [linux-kernel-mentees] [PATCH v5] Doc : fs : convert xfs.txt to
 ReST
Message-ID: <20190702151545.GO1404256@magnolia>
References: <20190702123040.GA30111@localhost>
 <20190702150452.GD1729@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702150452.GD1729@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Sheriff Esseson <sheriffesseson@gmail.com>, skhan@linuxfoundation.org, linux-xfs@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linuxfoundation.org

On Tue, Jul 02, 2019 at 08:04:52AM -0700, Matthew Wilcox wrote:
> On Tue, Jul 02, 2019 at 01:30:40PM +0100, Sheriff Esseson wrote:
> > +When mounting an XFS filesystem, the following options are accepted.  For
> > +boolean mount options, the names with the "(*)" prefix is the default behaviour.
> > +For example, take a behaviour enabled by default to be a one (1) or, a zero (0)
> > +otherwise, ``(*)[no]default`` would be 0 while ``[no](*)default`` , a 1.
> > -When mounting an XFS filesystem, the following options are accepted.
> > -For boolean mount options, the names with the (*) suffix is the
> > -default behaviour.
> 
> You seem to have reflowed all the text.  That means git no longer notices
> it's a rename, and quite frankly the shorter lines that were in use were
> better.

Agreed.  Please don't reflow text in a format conversion patch, it makes
it very difficult to figure out which changes were to accomodate rst.

If you want to reflow text (because of line length etc.) please do it as
a second patch.  I'd rather break the 80 column rule for a single commit
if it makes reviewing easy on the eyes.

> This is not an improvement; please undo it in the next version
> (which you should not post for several days to accumulate more feedback).

Seconded.  Thank you for sending v5 as a separate patch, though. :)

--D
