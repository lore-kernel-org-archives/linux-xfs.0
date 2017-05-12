Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:36172 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756893AbdELP5F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 11:57:05 -0400
Date: Fri, 12 May 2017 11:57:04 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170512155704.GF7704@fieldses.org>
References: <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
 <20170404183138.GC14303@fieldses.org>
 <878tnfiq7v.fsf@notabene.neil.brown.name>
 <20170405080551.GC8899@quack2.suse.cz>
 <20170405181409.GC28681@fieldses.org>
 <20170511185942.GD25434@fieldses.org>
 <1494586885.2787.3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494586885.2787.3.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 12, 2017 at 07:01:25AM -0400, Jeff Layton wrote:
> This looks reasonable to me (modulo Jan's comment about casting tv_sec
> to u64).
> 
> To be clear, I think this is mostly orthogonal to the changes that I was
> originally proposing, right? I think we can still benefit from only
> bumping and storing i_version values after they've been queried.

Definitely, yes.

--b.
