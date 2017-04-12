Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57746 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdDLQUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:20:25 -0400
Date: Wed, 12 Apr 2017 09:20:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170412162022.GA8663@infradead.org>
References: <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
 <20170411144906.39323b30@harpe.intellique.com>
 <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
 <20170411181355.59c1ee1f@harpe.intellique.com>
 <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
 <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
 <20170412151520.GB6126@infradead.org>
 <f1bbc038-a9d6-76c4-2f40-52797c5cf9d4@sandeen.net>
 <20170412154534.GA1145@infradead.org>
 <5eb9533a-7c20-23a4-b5f7-9f7cd54e3996@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eb9533a-7c20-23a4-b5f7-9f7cd54e3996@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 07:15:40PM +0300, Avi Kivity wrote:
> This preserves the ability to do O_DIRECT reads at 512 byte granularity,
> yes?

No.

> We make use of that (it's probably less important on NVMe; still why
> waste bandwidth needlessly).

In that case it would be the wrong thing for you.
