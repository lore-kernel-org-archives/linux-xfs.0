Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35437 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdFRHQW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Jun 2017 03:16:22 -0400
Date: Sun, 18 Jun 2017 00:16:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: memory allocation deadlock
Message-ID: <20170618071617.GA26968@infradead.org>
References: <CAHeTc0YizqSC55utPpe+Rsupv+G1qd2Es2a-6V3PFtf8NxnfOQ@mail.gmail.com>
 <d2778fc2-8363-187e-1ba2-ecdc8ced35b7@sandeen.net>
 <CAHeTc0a3kFpZEyBV4RoDe+N4dPtEFtRN7aay8+JCz9F+iu1rpw@mail.gmail.com>
 <e9389622-5ffd-10f3-15b0-4eefc08921ba@sandeen.net>
 <20170616193740.GH5421@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616193740.GH5421@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Brian Matheson <bmath@paperspace.com>, linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 12:37:40PM -0700, Darrick J. Wong wrote:
> memory and make the problems occur less frequently, as you've also
> observed.  However, that leaves the underlying problem, which is that we
> need to break up the in-core cache into a tree(ish) structure of single
> pages.  Maybe that'll happen for 4.14 (Christoph?).

Working on it, but it will be a big and potentially contentious change,
so stay tuned.
