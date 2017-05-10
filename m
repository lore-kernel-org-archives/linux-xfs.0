Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754275AbdEJQS5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 12:18:57 -0400
Date: Wed, 10 May 2017 12:18:51 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
Message-ID: <1840580824.6421109.1494433131277.JavaMail.zimbra@redhat.com>
In-Reply-To: <20170509154930.29524-24-jlayton@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com> <20170509154930.29524-24-jlayton@redhat.com>
Subject: Re: [PATCH v4 23/27] gfs2: clean up some filemap_* calls
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-block@vger.kernel.org, dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org, ross zwisler <ross.zwisler@linux.intel.com>, mawilcox@microsoft.com, jack@suse.com, viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com, tytso@mit.edu, axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com, bo li liu <bo.li.liu@oracle.com>

----- Original Message -----
| In some places, it's trying to reset the mapping error after calling
| filemap_fdatawait. That's no longer required. Also, turn several
| filemap_fdatawrite+filemap_fdatawait calls into filemap_write_and_wait.
| That will at least return writeback errors that occur during the write
| phase.
| 
| Signed-off-by: Jeff Layton <jlayton@redhat.com>
| ---

Hi Jeff,

This version looks better. ACK.

Regards,

Bob Peterson
Red Hat File Systems
