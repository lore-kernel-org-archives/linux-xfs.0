Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 02:08:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9J98bEn019500
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 02:08:37 -0700
Date: Sun, 19 Oct 2008 05:10:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: another problem with latest code drops
Message-ID: <20081019091021.GB1925@infradead.org>
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016072019.GH25906@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 16, 2008 at 06:20:19PM +1100, Dave Chinner wrote:
> I just ran up the same load in a UML session. I'd say it's this
> slab:
> 
>   2482   2481  99%    0.23K    146       17       584K xfs_btree_cur
> 
> which is showing a leak. It is slowly growing on my system
> and dropping the caches doesn't reduce it's size. At least it's
> a place to start looking - somewhere in the new btree code we
> seem to be leaking a btree cursor....

I've been running

for i in $(seq 1 8); do
	fsstress -p 64 -n 10000000 -d /mnt/data/fsstress.$i &
done

for about 20 hours now, and I'm only up to a few hundred xfs_btree_cur
entires, not changing much at all over time.  This is xfs-2.6 on a 4-way
PPC machine.
