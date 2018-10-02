Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52530 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbeJBWDd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 18:03:33 -0400
Date: Tue, 2 Oct 2018 08:19:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: cross-fs copy support
Message-ID: <20181002151926.GC6706@magnolia>
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
 <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
 <FE6394EC-5CB0-4A16-AAC6-97F465A4E50C@dilger.ca>
 <20181002081544.GW3255@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181002081544.GW3255@twin.jikos.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: dsterba@suse.cz, Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>, Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Oct 02, 2018 at 10:15:44AM +0200, David Sterba wrote:
> On Mon, Oct 01, 2018 at 01:51:09PM -0600, Andreas Dilger wrote:
> > > Yes, I would expect there to be problems with his modified kernel
> > > for a filesystem that supports clone_file_range, because
> > > vfs_copy_file_range() will clone if possible, and this should fail across
> > > filesystems.
> > > 
> > > In general, though, I don't know for sure why we don't fall back to
> > > do_splice_direct() across filesystems, although the filesystems that
> > > implement their own ->copy_file_range ops may have their own,
> > > further restrictions within their implementations.
> > > 
> > > This call /is/ documented in the manpage as only being valid for
> > > files on the same filesystem, though:
> > > http://man7.org/linux/man-pages/man2/copy_file_range.2.html
> > 
> > There was a patch to allow cross-mount copy for NFS, but it hasn't landed
> > yet.
> 
> I found https://marc.info/?l=linux-nfs&m=144138779721907&w=2 that lifts
> the VFS check (part of a series that can't be easily linked to).
> 
> The lack of cross-mount reflink (based on the copy_file_ragne) is often
> confusing users, there are common setups that mount subvolumes
> separately and reflinking between them would require mount of the
> toplevel subvolume.
> 
> If there are 2 in-kernel users of the relaxed cross-mount copy, I think
> this would help to push the series forward.

I don't have any objection to cross-mountpoint same-filesystem clones,
though obviously we need to all agree that from now on the vfs /does/
support certain IO operations across mountpoints.

(I haven't any opinion on cross-filesystem copies, as XFS is incapable
of such things.)

--D
