Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46153 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdFALgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2017 07:36:10 -0400
Date: Thu, 1 Jun 2017 04:36:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 00/35 v1] pagevec API cleanups
Message-ID: <20170601113604.GA10829@infradead.org>
References: <20170601093245.29238-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170601093245.29238-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, tytso@mit.edu, linux-xfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Hugh Dickins <hughd@google.com>, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, David Sterba <dsterba@suse.com>, ceph-devel@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Jaegeuk Kim <jaegeuk@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, linux-btrfs@vger.kernel.org

On Thu, Jun 01, 2017 at 11:32:10AM +0200, Jan Kara wrote:
> * Implement ranged variants for pagevec_lookup and find_get_ functions. Lot
>   of callers actually want a ranged lookup and we unnecessarily opencode this
>   in lot of them.

How does this compare to Kents page cache iterators:

http://www.spinics.net/lists/linux-mm/msg104737.html
