Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35541 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934282AbdC3Sfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 14:35:37 -0400
Received: by mail-qt0-f169.google.com with SMTP id x35so46959945qtc.2
        for <linux-xfs@vger.kernel.org>; Thu, 30 Mar 2017 11:35:36 -0700 (PDT)
Message-ID: <1490898932.2667.1.camel@redhat.com>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and
 optimization
From: Jeff Layton <jlayton@redhat.com>
Date: Thu, 30 Mar 2017 14:35:32 -0400
In-Reply-To: <20170330161231.GA9824@fieldses.org>
References: <20170320214327.GA5098@fieldses.org>
         <20170321134500.GA1318@infradead.org> <20170321163011.GA16666@fieldses.org>
         <1490117004.2542.1.camel@redhat.com> <20170321183006.GD17872@fieldses.org>
         <1490122013.2593.1.camel@redhat.com>
         <20170329111507.GA18467@quack2.suse.cz>
         <1490810071.2678.6.camel@redhat.com>
         <20170330064724.GA21542@quack2.suse.cz>
         <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, 2017-03-30 at 12:12 -0400, J. Bruce Fields wrote:
> On Thu, Mar 30, 2017 at 07:11:48AM -0400, Jeff Layton wrote:
> > On Thu, 2017-03-30 at 08:47 +0200, Jan Kara wrote:
> > > Hum, so are we fine if i_version just changes (increases) for all inodes
> > > after a server crash? If I understand its use right, it would mean
> > > invalidation of all client's caches but that is not such a big deal given
> > > how frequent server crashes should be, right?
> 
> Even if it's rare, it may be really painful when all your clients are
> forced to throw out and repopulate their caches after a crash.  But,
> yes, maybe we can live with it.
> 

Yeah, assuming that normal reboots wouldn't cause this, then I don't see
it as being too bad.

> > > Because if above is acceptable we could make reported i_version to be a sum
> > > of "superblock crash counter" and "inode i_version". We increment
> > > "superblock crash counter" whenever we detect unclean filesystem shutdown.
> > > That way after a crash we are guaranteed each inode will report new
> > > i_version (the sum would probably have to look like "superblock crash
> > > counter" * 65536 + "inode i_version" so that we avoid reusing possible
> > > i_version numbers we gave away but did not write to disk but still...).
> > > Thoughts?
> 
> How hard is this for filesystems to support?  Do they need an on-disk
> format change to keep track of the crash counter?  Maybe not, maybe the
> high bits of the i_version counters are all they need.
> 

Yeah, I imagine we'd need a on-disk change for this unless there's
something already present that we could use in place of a crash counter.

> > That does sound like a good idea. This is a 64 bit value, so we should
> > be able to carve out some upper bits for a crash counter without risking
> > wrapping.
> > 
> > The other constraint here is that we'd like any later version of the
> > counter to be larger than any earlier value that was handed out. I think
> > this idea would still satisfy that.
> 
> I guess we just want to have some back-of-the-envelope estimates of
> maximum number of i_version increments possible between crashes and
> maximum number of crashes possible over lifetime of a filesystem, to
> decide how to split up the bits.
> 
> I wonder if we could get away with using the new crash counter only for
> *new* values of the i_version?  After a crash, use the on disk i_version
> as is, and put off using the new crash counter until the next time the
> file's modified.
> 

That sounds difficult to get right. Suppose I have an inode that has not
been updated in a long time. Someone writes to it and then queries the
i_version. How do I know whether there were crashes since the last time
I updated it? Or am I misunderstanding what you're proposing here?

> That would still eliminate the risk of accidental reuse of an old
> i_version value.  It still leaves some cases where the client could fail
> to notice an update indefinitely.  All these cases I think have to
> assume that a writer made some changes that it failed to ever sync, so
> as long as we care only about close-to-open semantics perhaps those
> cases don't matter.
> 
> I wonder if repeated crashes can lead to any odd corner cases.
> 

-- 
Jeff Layton <jlayton@redhat.com>
