Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754930AbeAHSB3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 13:01:29 -0500
Date: Mon, 8 Jan 2018 18:59:20 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4 18/19] btrfs: only dirty the inode in
 btrfs_update_time if something was changed
Message-ID: <20180108175920.GF13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-19-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171222120556.7435-19-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Fri, Dec 22, 2017 at 07:05:55AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> At this point, we know that "now" and the file times may differ, and we
> suspect that the i_version has been flagged to be bumped. Attempt to
> bump the i_version, and only mark the inode dirty if that actually
> occurred or if one of the times was updated.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Acked-by: David Sterba <dsterba@suse.com>
