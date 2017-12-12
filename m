Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34764 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752431AbdLLPFE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Dec 2017 10:05:04 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBCF3jNT125420
        for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2017 10:05:04 -0500
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2etehshj8a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2017 10:05:03 -0500
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Tue, 12 Dec 2017 15:05:01 -0000
Subject: Re: [PATCH] xfs: include the XFS magic number in magic.h
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Tue, 12 Dec 2017 10:04:56 -0500
In-Reply-To: <20171212143647.GA10887@infradead.org>
References: <1513088469.3476.48.camel@linux.vnet.ibm.com>
         <20171212142615.GA25327@infradead.org>
         <1513089296.3476.52.camel@linux.vnet.ibm.com>
         <20171212143647.GA10887@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1513091096.3476.66.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, 2017-12-12 at 06:36 -0800, Christoph Hellwig wrote:
> On Tue, Dec 12, 2017 at 09:34:56AM -0500, Mimi Zohar wrote:
> > On Tue, 2017-12-12 at 06:26 -0800, Christoph Hellwig wrote:
> > > On Tue, Dec 12, 2017 at 09:21:09AM -0500, Mimi Zohar wrote:
> > > > Move the XFS_SB_MAGIC definition to magic.h.
> > > 
> > > NACK.  We want to keep the XFS code self-contained and no other part
> > > of the kernel has any business knowing it anyway.
> > 
> > IMA policy rules can be defined in terms of magic numbers, but they
> > need to be defined in magic.h.  Please reconsider...
> 
> That is completely bogus, and it should not be supported in any way.
> File systems magic numbers are internal implementation details.

Perhaps policies in general shouldn't differentiate between file
systems, but it definitely simplifies testing.

For example, currently IMA-appraisal only supports storing file
signatures as xattrs, but support for appended signatures is being
added.  Per file system rules could require different types of file
signatures.

Mimi

