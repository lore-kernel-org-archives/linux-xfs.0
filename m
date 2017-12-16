Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756368AbdLPQkY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 11:40:24 -0500
Message-ID: <1513442419.3428.13.camel@kernel.org>
Subject: Re: [PATCH v2 05/19] afs: convert to new i_version API
From: Jeff Layton <jlayton@kernel.org>
Date: Sat, 16 Dec 2017 11:40:19 -0500
In-Reply-To: <82157aa3-ec0b-25e6-517b-704a3f81ec61@auristor.com>
References: <20171216134656.15561-1-jlayton@kernel.org>
         <20171216134656.15561-6-jlayton@kernel.org>
         <1513432186.3428.6.camel@kernel.org>
         <82157aa3-ec0b-25e6-517b-704a3f81ec61@auristor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeffrey Altman <jaltman@auristor.com>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

On Sat, 2017-12-16 at 11:18 -0500, Jeffrey Altman wrote:
> Hi Jeff,
> 
> A few thoughts on AFS usage below which might impact a future revision
> of the API.  I hope they are useful.
> 
> On 12/16/2017 8:49 AM, Jeff Layton wrote:
> > On Sat, 2017-12-16 at 08:46 -0500, Jeff Layton wrote:
> > > From: Jeff Layton <jlayton@redhat.com>
> > > 
> > > For AFS, it's generally treated as an opaque value, so we use the
> > > *_raw variants of the API here.
> > > 
> > > Note that AFS has quite a different definition for this counter. AFS
> > > only increments it on changes to the data, not for the metadata. We'll
> > > need to reconcile that somehow if we ever want to present this to
> > > userspace via statx.
> > > 
> 
> From the patch series notes:
> 
> "The inode->i_version field is supposed to be a value that changes
> whenever there is any data or metadata change to the inode. Some
> filesystems use it internally to detect directory changes during
> readdir. knfsd will use it if the filesystem has MS_I_VERSION set. IMA
> will also use it to optimize away some remeasurement if it's available.
> NFS and AFS just use it to store an opaque change attribute from the
> server.
> 
> "Only btrfs, ext4, and xfs increment it for data changes. Because of
> this, these filesystems must log the inode to disk whenever the
> i_version counter changes. That has a non-zero performance impact,
> especially on write-heavy workloads, because we end up dirtying the
> inode metadata on every write, not just when the times change. [1]"
> 
> 
> The AFS/AuriStorFS data version is an unsigned 64-bit value that is
> incremented by the file server as part of a data changing operation. For
> files, a StoreData and for directories entry manipulations such as
> create, rename, delete.  This data version is used to tag the version of
> any subset of the data stream for caching and replication purposes.
> 
> As Jeff notes, the AFS data version is not incremented for metadata
> changes.  Metadata cannot be trusted by clients without acquiring a
> callback promise from a fileserver.  The callback promise will either be
> satisfied by the issuing fileserver sending a CallBack notification that
> the metadata is no longer valid OR the callback promise will expire.
> 
> Something else that is important to note that it is assumed that local
> data changes that occur under a valid callback promise is newer than the
> data on the fileserver.  It might be useful if the new i_version API
> supported major and minor version numbers.  AFS implementations would
> store the fileserver provided data version number as the major version
> and would increment the minor version when local changes have been made
> which have yet to be stored back to the fileserver.  This functionality
> would be especially useful if disconnected operations were implemented
> for the AFS implementation.
> 
> It might also be useful to separate metadata version and data version
> although some filesystems would set the same value to both.  For AFS,
> the metadata major version would the timestamp at which the callback was
> issued.
> 
> Jeffrey Altman

Thanks. That seems like rather specialized use case.

If we did want to go that route, we'd probably need to give filesystems
a way to overload how i_version is handled and queried (maybe some new
inode ops?).

Given that nothing ever looks at the the i_version in kAFS now, I don't
have a lot of incentive to do anything along those lines in this set. I
think this patchset will probably make it simpler to do something like
that in the future, if you were motivated to do so though.
-- 
Jeff Layton <jlayton@kernel.org>
