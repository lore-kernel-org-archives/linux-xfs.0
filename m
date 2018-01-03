Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54996 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751169AbeACED0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 23:03:26 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id w033wrTu061763
        for <linux-xfs@vger.kernel.org>; Tue, 2 Jan 2018 23:03:26 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2f8j8ghkdy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2018 23:03:26 -0500
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Wed, 3 Jan 2018 04:03:23 -0000
Subject: Re: [PATCHv6 1/1] ima: re-introduce own integrity cache lock
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Tue, 02 Jan 2018 23:03:16 -0500
In-Reply-To: <20180103031621.GK5858@dastard>
References: <c73e7421902a60bd14c11e1201ba74470d7c782b.1512500794.git.dmitry.kasatkin@huawei.com>
         <CACE9dm-ws8TKEAzFbCoGdhdEuFLoLtz8dAuF8tor19wMx1pH=g@mail.gmail.com>
         <20180103014048.GE5146@magnolia>
         <1514947923.3493.2.camel@linux.vnet.ibm.com>
         <20180103031621.GK5858@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1514952196.3493.57.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dmitry Kasatkin <dmitry.kasatkin@huawei.com>, xfs <linux-xfs@vger.kernel.org>

On Wed, 2018-01-03 at 14:16 +1100, Dave Chinner wrote:
> On Tue, Jan 02, 2018 at 09:52:03PM -0500, Mimi Zohar wrote:
> > On Tue, 2018-01-02 at 17:40 -0800, Darrick J. Wong wrote:
> > > [might as well cc linux-xfs]
> > > 
> > > On Thu, Dec 14, 2017 at 12:22:37AM +0200, Dmitry Kasatkin wrote:
> > > > Hi,
> > > > 
> > > > Could I ask FS maintainers to test IMA with this patch additionally
> > > > and provide ack/tested.
> > > > We tested but may be you have and some special testing.
> > > 
> > > Super-late to this party, but unless xfstests has automated tests to
> > > set up IMA on top of an existing filesystem then I most likely have no
> > > idea /how/ to test IMA.  I did a quick grep of xfstests git and I don't
> > > see anything IMA-related.
> > 
> > Back in June I posted a simple xfstests IMA-appraisal test (https://ma
> > rc.info/?l=linux-fsdevel&m=149703820814885&w=4).
> 
> That's a really, really basic test and it doesn't exercise the
> problematic direct IO path this patch fixes problems with. nor does
> it exercise the chmod path, or try to trigger deadlocks or other
> conditions through all the other paths that can trigger IMA actions
> and or failures (e.g. ENOSPC).  IOWs, we need a lot more than a
> "hello world" test to be able to verify filesystems interact with
> IMA properly. e.g. how does it behave at ENOSPC?

True, but for now we were looking for some basic testing - opening a
file and calculating the file hash - on different filesystems, not the
direct-IO path in particular.  Expanding the IMA-appraisal xfstests is
high on my "todo" list.

Mimi

