Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbeABS5q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jan 2018 13:57:46 -0500
Message-ID: <1514919462.3462.18.camel@kernel.org>
Subject: Re: [PATCH v4 05/19] afs: convert to new i_version API
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 02 Jan 2018 13:57:42 -0500
In-Reply-To: <5112.1514913610@warthog.procyon.org.uk>
References: <20171222120556.7435-6-jlayton@kernel.org>
         <20171222120556.7435-1-jlayton@kernel.org>
         <5112.1514913610@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, jaltman@auristor.com

On Tue, 2018-01-02 at 17:20 +0000, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
> 
> > Note that AFS has quite a different definition for this counter. AFS
> > only increments it on changes to the data, not for the metadata.
> 
> This also applies to AFS directories: create, mkdir, unlink, rmdir, link,
> symlink, rename, and mountpoint creation/removal all bump the data version
> number on a directory by exactly one if they change it.
> 

Thanks! I updated that part of the the commit log to read:

    Note that AFS has quite a different definition for this counter. AFS
    only increments it on changes to the data to the data in regular files
    and contents of the directories. Inode metadata changes do not result
    in a version increment.

-- 
Jeff Layton <jlayton@kernel.org>
