Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE3197F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 13:09:49 -0600 (CST)
Date: Wed, 11 Dec 2013 13:09:45 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Filesystem writes on RAID5 too slow
Message-ID: <20131211190945.GF1935@sgi.com>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
	<CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
	<CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
	<20131121234116.GD6502@dastard>
	<20131210191803.GA31162@infradead.org>
	<20131211002753.GD10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211002753.GD10988@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Martin Boutin <martboutin@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>

Hi,

On Wed, Dec 11, 2013 at 11:27:53AM +1100, Dave Chinner wrote:
> On Tue, Dec 10, 2013 at 11:18:03AM -0800, Christoph Hellwig wrote:
> > > xfs: align initial file allocations correctly.
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The function xfs_bmap_isaeof() is used to indicate that an
> > > allocation is occurring at or past the end of file, and as such
> > > should be aligned to the underlying storage geometry if possible.
> > > 
> > > Commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") changed the
> > > behaviour of this function for empty files - it turned off
> > > allocation alignment for this case accidentally. Hence large initial
> > > allocations from direct IO are not getting correctly aligned to the
> > > underlying geometry, and that is cause write performance to drop in
> > > alignment sensitive configurations.
> > > 
> > > Fix it by considering allocation into empty files as requiring
> > > aligned allocation again.
> > 
> > Seems like this one didn't get picked up yet?
> 
> I'm about to resend all my outstanding patches...

Sorry I didn't see that one.  If you stick the keyword 'patch' in the subject I
tend to do a bit better.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
