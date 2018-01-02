Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751150AbeABRUP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jan 2018 12:20:15 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20171222120556.7435-6-jlayton@kernel.org>
References: <20171222120556.7435-6-jlayton@kernel.org> <20171222120556.7435-1-jlayton@kernel.org>
Subject: Re: [PATCH v4 05/19] afs: convert to new i_version API
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5111.1514913610.1@warthog.procyon.org.uk>
Date: Tue, 02 Jan 2018 17:20:10 +0000
Message-ID: <5112.1514913610@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, jaltman@auristor.com

Jeff Layton <jlayton@kernel.org> wrote:

> Note that AFS has quite a different definition for this counter. AFS
> only increments it on changes to the data, not for the metadata.

This also applies to AFS directories: create, mkdir, unlink, rmdir, link,
symlink, rename, and mountpoint creation/removal all bump the data version
number on a directory by exactly one if they change it.

David
