Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbdA1IBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jan 2017 03:01:12 -0500
Date: Fri, 27 Jan 2017 23:32:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 8/8] Revert "ext4: fix wrong gfp type
 under transaction"
Message-ID: <20170128073215.GA19424@infradead.org>
References: <20170117155916.dcizr65bwa6behe7@thunk.org>
 <20170117161618.GT19699@dhcp22.suse.cz>
 <20170117172925.GA2486@quack2.suse.cz>
 <20170119083956.GE30786@dhcp22.suse.cz>
 <20170119092236.GC2565@quack2.suse.cz>
 <20170119094405.GK30786@dhcp22.suse.cz>
 <20170126074455.GC8456@dhcp22.suse.cz>
 <20170127061318.xd2qxashbl4dajez@thunk.org>
 <20170127093735.GB4143@dhcp22.suse.cz>
 <20170127164042.2o3bnyopihcb224g@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170127164042.2o3bnyopihcb224g@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, Michal Hocko <mhocko@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Jan 27, 2017 at 11:40:42AM -0500, Theodore Ts'o wrote:
> The reason why I'm nervous is that nojournal mode is not a common
> configuration, and "wait until production systems start failing" is
> not a strategy that I or many SRE-types find.... comforting.

What does SRE stand for?
