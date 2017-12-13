Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdLMIne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 03:43:34 -0500
Date: Wed, 13 Dec 2017 00:43:31 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
Message-ID: <20171213084331.GA19323@infradead.org>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
 <20171212142615.GA25327@infradead.org>
 <1513089296.3476.52.camel@linux.vnet.ibm.com>
 <20171212143647.GA10887@infradead.org>
 <1513091096.3476.66.camel@linux.vnet.ibm.com>
 <20171212233031.GX5858@dastard>
 <1513122931.3476.97.camel@linux.vnet.ibm.com>
 <20171213001342.GY5858@dastard>
 <1513128072.3476.121.camel@linux.vnet.ibm.com>
 <20171213025928.GZ5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213025928.GZ5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 13, 2017 at 01:59:28PM +1100, Dave Chinner wrote:
> IOWs, if you need to identify a filesystem *type*, using internal
> magic numbers is not the way to do it. selinux, for example, checks
> sb->s_type->name quite a lot....

And that is bad enough to start with.  It should check for specific
features, and not the file system driver name.
