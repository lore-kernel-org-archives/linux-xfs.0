Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1172238AbdDXONH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 10:13:07 -0400
Date: Mon, 24 Apr 2017 10:12:55 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <2139341349.405174.1493043175630.JavaMail.zimbra@redhat.com>
In-Reply-To: <20170424132259.8680-21-jlayton@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com> <20170424132259.8680-21-jlayton@redhat.com>
Subject: Re: [PATCH v3 20/20] gfs2: clean up some filemap_* calls
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, osd-dev@open-osd.org, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross zwisler <ross.zwisler@linux.intel.com>, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk

----- Original Message -----
| In some places, it's trying to reset the mapping error after calling
| filemap_fdatawait. That's no longer required. Also, turn several
| filemap_fdatawrite+filemap_fdatawait calls into filemap_write_and_wait.
| That will at least return writeback errors that occur during the write
| phase.
| 
| Signed-off-by: Jeff Layton <jlayton@redhat.com>
| ---
|  fs/gfs2/glops.c | 12 ++++--------
|  fs/gfs2/lops.c  |  4 +---
|  fs/gfs2/super.c |  6 ++----
|  3 files changed, 7 insertions(+), 15 deletions(-)
| 
| diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
| index 5db59d444838..7362d19fdc4c 100644
| --- a/fs/gfs2/glops.c
| +++ b/fs/gfs2/glops.c
| @@ -158,9 +158,7 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
|  	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
|  
|  	gfs2_log_flush(sdp, gl, NORMAL_FLUSH);
| -	filemap_fdatawrite_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
| -	error = filemap_fdatawait_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
| -	mapping_set_error(mapping, error);
| +	filemap_write_and_wait_range(mapping, gl->gl_vm.start, gl->gl_vm.end);

This should probably have "error = ", no?

|  	gfs2_ail_empty_gl(gl);
|  
|  	spin_lock(&gl->gl_lockref.lock);
| @@ -225,12 +223,10 @@ static void inode_go_sync(struct gfs2_glock *gl)
|  	filemap_fdatawrite(metamapping);
|  	if (ip) {
|  		struct address_space *mapping = ip->i_inode.i_mapping;
| -		filemap_fdatawrite(mapping);
| -		error = filemap_fdatawait(mapping);
| -		mapping_set_error(mapping, error);
| +		filemap_write_and_wait(mapping);
| +	} else {
| +		filemap_fdatawait(metamapping);
|  	}
| -	error = filemap_fdatawait(metamapping);
| -	mapping_set_error(metamapping, error);

This part doesn't look right at all. There's a big difference in gfs2 between
mapping and metamapping. We need to wait for metamapping regardless.

(snip)

Regards,

Bob Peterson
Red Hat File Systems
