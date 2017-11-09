Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbdKIIT1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 03:19:27 -0500
Date: Thu, 9 Nov 2017 09:19:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171109081938.GC27461@kroah.com>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <20171107202648.GB10679@kroah.com>
 <20171108184615.GE26910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108184615.GE26910@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Wed, Nov 08, 2017 at 10:46:15AM -0800, Darrick J. Wong wrote:
> Had anyone involved us, I would have suggested fixing the whole XFS tree
> to use the shortened tag instead of each file containing its own
> mutations of the GPL, and our broader XFS community could have worked
> with you on this.

Great, I'll gladly send you a patchset to do this, what tree do you want
me to base it against?

Note, all this original patchset did was hit the 11k files in the tree
with no license text in it at all.  That required a tree-wide change to
resolve everything at once.  Unification of the way we describe licenses
in individual files will go on a subsystem-by-subsystem basis.

thanks,

greg k-h
