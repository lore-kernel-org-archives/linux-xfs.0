Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbdFAK0Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 06:26:16 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170601093245.29238-2-jack@suse.cz>
References: <20170601093245.29238-2-jack@suse.cz> <20170601093245.29238-1-jack@suse.cz>
Subject: Re: [PATCH 01/35] fscache: Remove unused ->now_uncached callback
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10375.1496312768.1@warthog.procyon.org.uk>
Date: Thu, 01 Jun 2017 11:26:08 +0100
Message-ID: <10376.1496312768@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: dhowells@redhat.com, linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, linux-afs@lists.infradead.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu, linux-ext4@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>

Jan Kara <jack@suse.cz> wrote:

> The callback doesn't ever get called. Remove it.

Hmmm...  I should perhaps be calling this.  I'm not sure why I never did.

At the moment, it doesn't strictly matter as ops on pages marked with
PG_fscache get ignored if the cache has suffered an I/O error or has been
withdrawn - but it will incur a performance penalty (the PG_fscache flag is
checked in the netfs before calling into fscache).

The downside of calling this is that when a cache is removed, fscache would go
through all the cookies for that cache and iterate over all the pages
associated with those cookies - which could cause a performance dip in the
system.

David
