Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727455AbeGMSAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Jul 2018 14:00:13 -0400
Date: Fri, 13 Jul 2018 12:44:33 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
Message-ID: <20180713174433.GA22284@redhat.com>
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net>
 <20180710224026.GV2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710224026.GV2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Filippo Giunchedi <fgiunchedi@wikimedia.org>, linux-xfs@vger.kernel.org

On Wed, Jul 11, 2018 at 08:40:26AM +1000, Dave Chinner wrote:
> On Tue, Jul 10, 2018 at 04:39:26PM -0500, Eric Sandeen wrote:
> > On 7/10/18 8:43 AM, Filippo Giunchedi wrote:
> > > Hello,
> > > a little background: at Wikimedia Foundation we are running a 30-hosts
> > > Openstack Swift cluster to host user media uploads, each host has 12
> > > spinning disks formatted individually with xfs.
> > > 
> > > Some of the recently-formatted filesystems have started reporting
> > > negative usage upon hitting around 70% usage, though some filesystems
> > > on the same host kept reporting as expected:
> > > 
> > > /dev/sdn1       3.7T  -14T   17T    - /srv/swift-storage/sdn1
> > > /dev/sdh1       3.7T  -13T   17T    - /srv/swift-storage/sdh1
> > > /dev/sdc1       3.7T  3.0T  670G  83% /srv/swift-storage/sdc1
> > > /dev/sdk1       3.7T  3.1T  643G  83% /srv/swift-storage/sdk1
> > > 
> > > We have experienced this bug only on the last four machines to be put
> > > in service and formatted with xfsprogs 4.9.0+nmu1 from Debian Stretch.
> > > The remaining hosts were formatted in the past with xfsprogs 3.2.1 or
> > > older.
> > > We have also a standby cluster in another datacenter with similar
> > > configuration and hosts that received write traffic only but not read
> > > traffic; the standby cluster hasn't experienced the bug and all
> > > filesystems report the correct usage.
> > > As far as I can tell the difference in xfsprogs version used for
> > > formatting means defaults have changed, (e.g. crc is enabled on the
> > > affected filesystems). Have you seen this issue before and do you know
> > > how to fix it?
> > > 
> > > I would love to help debugging this issue, we've been detailing the
> > > work done so far at https://phabricator.wikimedia.org/T199198
> > 
> > What kernel are the problematic nodes running?
> > 
> > From your repair output:
> > 
> > root@ms-be1040:~# xfs_repair -n /dev/sde1
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> > sb_fdblocks 4461713825, counted 166746529
> >         - found root inode chunk
> > 
> > that sb_fdblocks really is ~17T which indicates the problem
> > really is on disk.
> > 
> > 4461713825
> > 100001001111100000101100110100001
> > 166746529
> >      1001111100000101100110100001
> > 
> > you have a bit flipped in the problematic value... but you're running
> > with CRCs so it seems unlikely to have been some sort of bit-rot (that,
> > and the fact that you're hitting the same problem on multiple nodes).
> > 
> > Soooo not sure what to say right now other than "your bad value has an
> > extra bit set for some reason."
> 
> Looks like the superblock verifier doesn't bounds check free block
> or free/used inode counts.  Perhaps we should be checking this in
> the verifier so in-memory corruption like this never makes it to
> disk?

A proposed patch and discussion thread is on the list:
https://www.spinics.net/lists/linux-xfs/msg20645.html

Thanks-
Bill


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
