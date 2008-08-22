Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 11:15:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7MIFe0n021534
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 11:15:41 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 818B03C319D
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 11:17:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id CBtroc2XMUUrNTsj for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 11:17:02 -0700 (PDT)
Date: Fri, 22 Aug 2008 14:16:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080822181656.GB15469@infradead.org>
References: <20080818212856t-sato@mail.jp.nec.com> <20080821132006.9949101c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821132006.9949101c.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>

On Thu, Aug 21, 2008 at 01:20:06PM -0700, Andrew Morton wrote:
> I don't think the changelogs actually explained why this feature is
> being added?
> 
> Which userspace tools are expected to send these ioctls?  Something in
> util-linux?  dm-utils?  Are patches to those packages planned?

Currently the only surspace using freeze and thaw is xfs_freeze from
xfsprogs, which would work for various other filesystems that implement
->write_super_lockfs now instead of just XFS with patch 1.

The freeze stuff in this third patch isn't and won't be used by
xfs_freeze and doesn't make all that much sense (and we already had a
lot of previous discussion on this..)
