Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47042 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdBNH6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 02:58:35 -0500
Date: Mon, 13 Feb 2017 23:58:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: fix inode uid/gid initialization
Message-ID: <20170214075834.GA12767@infradead.org>
References: <1487008001.3125.41.camel@HansenPartnership.com>
 <20170213194337.GA9852@infradead.org>
 <20170213213416.GA15349@dastard>
 <20170214060809.GA21114@infradead.org>
 <1487053651.3125.72.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487053651.3125.72.camel@HansenPartnership.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

On Mon, Feb 13, 2017 at 10:27:31PM -0800, James Bottomley wrote:
> OK, so I'll fix up the s_user_mount problems and I'll let you sort out
> the internals of removing the di_uid/gid if you wish to.

We'll need to sort that out, and I'd rather do that than reinterpreting
the fields.  But I can take care of it by ammending or redoing your
patch if you don't feel like poking to deep into XFS.

What we need now is test cases exercising a non-standard s_user_ns
so that we have test coverage for these changes.
