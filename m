Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60195 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751265AbeACDQ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 22:16:26 -0500
Date: Wed, 3 Jan 2018 14:16:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv6 1/1] ima: re-introduce own integrity cache lock
Message-ID: <20180103031621.GK5858@dastard>
References: <c73e7421902a60bd14c11e1201ba74470d7c782b.1512500794.git.dmitry.kasatkin@huawei.com>
 <CACE9dm-ws8TKEAzFbCoGdhdEuFLoLtz8dAuF8tor19wMx1pH=g@mail.gmail.com>
 <20180103014048.GE5146@magnolia>
 <1514947923.3493.2.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514947923.3493.2.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dmitry Kasatkin <dmitry.kasatkin@huawei.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Jan 02, 2018 at 09:52:03PM -0500, Mimi Zohar wrote:
> On Tue, 2018-01-02 at 17:40 -0800, Darrick J. Wong wrote:
> > [might as well cc linux-xfs]
> > 
> > On Thu, Dec 14, 2017 at 12:22:37AM +0200, Dmitry Kasatkin wrote:
> > > Hi,
> > > 
> > > Could I ask FS maintainers to test IMA with this patch additionally
> > > and provide ack/tested.
> > > We tested but may be you have and some special testing.
> > 
> > Super-late to this party, but unless xfstests has automated tests to
> > set up IMA on top of an existing filesystem then I most likely have no
> > idea /how/ to test IMA.  I did a quick grep of xfstests git and I don't
> > see anything IMA-related.
> 
> Back in June I posted a simple xfstests IMA-appraisal test (https://ma
> rc.info/?l=linux-fsdevel&m=149703820814885&w=4).

That's a really, really basic test and it doesn't exercise the
problematic direct IO path this patch fixes problems with. nor does
it exercise the chmod path, or try to trigger deadlocks or other
conditions through all the other paths that can trigger IMA actions
and or failures (e.g. ENOSPC).  IOWs, we need a lot more than a
"hello world" test to be able to verify filesystems interact with
IMA properly. e.g. how does it behave at ENOSPC? 

How do you test that IMA is fully working and has no regressions
during your development?  I'm sure there's more than a "hello world"
test for that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
