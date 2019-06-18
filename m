Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfFRPL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 11:11:56 -0400
Date: Tue, 18 Jun 2019 08:11:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190618151144.GB5387@magnolia>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
 <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com>
 <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com>
 <20190618150242.GA4576@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618150242.GA4576@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Amir Goldstein <amir73il@gmail.com>, Murphy Zhou <jencce.kernel@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 18, 2019 at 11:02:42AM -0400, Theodore Ts'o wrote:
> On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
> > On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > >
> > > Would you mind updating sha1 after it get merged to Linus tree?
> > >
> > > That would be helpful for people tracking this issue.
> > >
> > 
> > This is the commit id in linux-next and expected to stay the same
> > when the fix is merged to Linus tree for 5.3.
> 
> When I talked to Darrick last week, that was *not* the sense I got
> from him.  It's not necessarily guaranteed to be stable just yet...

Darrick hasn't gotten any complaints about the copy-file-range-fixes
branch (which has been in for-next for a week now), so he thinks that
commit id (a31713517dac) should be stable from here on out.

(Note that doesn't guarantee that Linus will pull said branch...)

--D

>      	   	    			   - Ted
