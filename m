Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56891 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753980AbdDLPPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 11:15:22 -0400
Date: Wed, 12 Apr 2017 08:15:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170412151520.GB6126@infradead.org>
References: <974df72a-04fe-fba4-4b48-89426b8783e0@scylladb.com>
 <20170411133033.65c89ee8@harpe.intellique.com>
 <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
 <20170411140007.05af2bcd@harpe.intellique.com>
 <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
 <20170411144906.39323b30@harpe.intellique.com>
 <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
 <20170411181355.59c1ee1f@harpe.intellique.com>
 <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
 <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Avi Kivity <avi@scylladb.com>, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Apr 11, 2017 at 11:48:19AM -0500, Eric Sandeen wrote:
> As an experiment, though, if you want to play, it might be interesting to
> mkfs.xfs it with a 4096 byte sector size, and see if that makes it happier.
> By default, xfs is doing metadata IO in 512 chunks, something other filesystems
> won't do by default.
> 
> I guess you don't know how to provoke the corruption, though, to be able
> to run that test reliably...

Btw, it might be a good idea to move to 4k sector size as the default,
on pretty much any modern hardware sector sizes are 4k or larger
internally, and 512 byte writes will always involve read-modify-write
cycles.  And unlike SATA or SCSI disks NVMe doesn't have a physical
block size attribute, so we can't even look at that.
