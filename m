Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48861 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbcJUDAS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2016 23:00:18 -0400
Date: Thu, 20 Oct 2016 20:00:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: About reflink len = 0 behavior
Message-ID: <20161021030005.GB5257@birch.djwong.org>
References: <bedcb76a-4deb-bc0e-7a50-350a8a8db86f@cn.fujitsu.com>
 <94d643cc-fa49-4b20-b265-55d50af15e47@cn.fujitsu.com>
 <20161020154733.GA5436@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161020154733.GA5436@vader>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, fstests@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>, linux-xfs@vger.kernel.org

On Thu, Oct 20, 2016 at 08:47:33AM -0700, Omar Sandoval wrote:
> On Thu, Oct 20, 2016 at 03:50:46PM +0800, Qu Wenruo wrote:
> > Add cc to new xfs mail list.
> > 
> > 
> > At 10/20/2016 03:46 PM, Qu Wenruo wrote:
> > > Hi Darrick, xfs guys and btrfs guys.
> > > 
> > > Although such question is quite late as reflink generic tests are in
> > > fstests for a long time, I'm still not sure what's the correct behavior
> > > for reflink len = 0.

"reflink to the end of the source file" is the current behavior for both.

> > > Test case generic/182 is causing different output between btrfs and xfs.
> > > 
> > > For btrfs, dedupe will just return 0 and check nothing, while for xfs
> > > len == 0 means to check the whole file length.
> > > 
> > > Both makes sense for me, for btrfs len = 0 behavior, it just follows
> > > read/write functions.
> > > And I assume xfs follows reflink behavior, when len is not specified,
> > > then reflink the length of src file.

Yes.

> > > But since it's a generic test, we need to unify the behavior.
> > > 
> > > So, which one is the standard and which document should we follow for
> > > such behavior definition?

<shrug> I suppose since it'll stop deduping at the first non-matching range,
there's not a lot of point in having "dedupe to wherever is the end of the
file" feature.

(Also, if he hasn't already, I'm sure Christoph will point out that we
shouldn't really go changing the interface after the fact, even if the
interface was mostly undocumented and afaict not tested by anything like
xfstests for years...)

> > > Thanks,
> > > Qu
> 
> Hey, Qu,
> 
> I brought this up a few months back here [1], and I think the conclusion
> was that consistency with clone (so the XFS behavior) was probably what
> we wanted. I just forgot to follow up and figure out if it would break
> any userspace programs in a way that mattered (I doubt it).

duperemove doesn't seem to send zero-byte dedupe requests.

--D

> 
> 1: http://marc.info/?l=linux-btrfs&m=146828374631829&w=2
> 
> -- 
> Omar
