Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36601 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdDLRle (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 13:41:34 -0400
Date: Wed, 12 Apr 2017 10:41:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170412174126.GA29486@infradead.org>
References: <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
 <20170411181355.59c1ee1f@harpe.intellique.com>
 <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
 <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
 <20170412151520.GB6126@infradead.org>
 <f1bbc038-a9d6-76c4-2f40-52797c5cf9d4@sandeen.net>
 <20170412154534.GA1145@infradead.org>
 <5eb9533a-7c20-23a4-b5f7-9f7cd54e3996@scylladb.com>
 <20170412162022.GA8663@infradead.org>
 <08bec6a5-67cb-9185-e1e7-1e7d2223067f@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08bec6a5-67cb-9185-e1e7-1e7d2223067f@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 07:22:20PM +0300, Avi Kivity wrote:
> > > We make use of that (it's probably less important on NVMe; still why
> > > waste bandwidth needlessly).
> > In that case it would be the wrong thing for you.
> 
> Would it be under our control?

Yes, even if we switch a mkfs default you could still manually override
it as long as the device supports a smaller logical block size, similar
to how we treat 512 logical / 4k physical SAS and SATA drives today.
