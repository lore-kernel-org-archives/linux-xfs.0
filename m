Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdISUe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 16:34:58 -0400
Date: Tue, 19 Sep 2017 13:34:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: io_submit() blocks for writes for substantial amount of time
Message-ID: <20170919203457.GB731@infradead.org>
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <20170919145827.GA21523@infradead.org>
 <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
 <20170919173955.GB8139@dhcp-41-131.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919173955.GB8139@dhcp-41-131.bos.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Avi Kivity <avi@scylladb.com>, Christoph Hellwig <hch@infradead.org>, Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 01:39:55PM -0400, Brian Foster wrote:
> I'm not sure what difference it makes regardless. We still have to wait
> for an allocation to complete before we can issue an I/O. IIRC, the old
> defer allocs to a wq thing was more about saving stack space than
> providing async behavior.

At least in theory we could do the allocation from one workqueue
and submit the I/O from the next one.  Except for the lack of modern
workqueues that is what the historic AIO code in RHEL2.1 (and maybe 3.0,
but I'm not sure did). 
