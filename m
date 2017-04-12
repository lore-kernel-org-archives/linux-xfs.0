Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdDLPph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 11:45:37 -0400
Date: Wed, 12 Apr 2017 08:45:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170412154534.GA1145@infradead.org>
References: <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
 <20170411140007.05af2bcd@harpe.intellique.com>
 <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
 <20170411144906.39323b30@harpe.intellique.com>
 <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
 <20170411181355.59c1ee1f@harpe.intellique.com>
 <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
 <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
 <20170412151520.GB6126@infradead.org>
 <f1bbc038-a9d6-76c4-2f40-52797c5cf9d4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1bbc038-a9d6-76c4-2f40-52797c5cf9d4@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Avi Kivity <avi@scylladb.com>, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 10:34:47AM -0500, Eric Sandeen wrote:
> Is it safe to do that on a device that /actually/ has only 512 sectors?

Except for NVMe none of the storage standards actually guarantees
sector atomicy, although the whole storage stack traditionally relies on
it..

Maybe we should claim a 4k physical block size for NVMe devices that
hab 512 byte LBAs and a "Atomic Write Unit Power Fail" setting of at
least 8 so that the mkfs sector size logic triggers..
