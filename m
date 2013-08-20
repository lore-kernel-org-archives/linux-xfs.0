Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 975EE7FB7
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 23:09:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D146AC002
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 21:09:01 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MYLbHKB6oPK6n2cB for <xfs@oss.sgi.com>;
	Mon, 19 Aug 2013 21:09:00 -0700 (PDT)
Date: Tue, 20 Aug 2013 14:08:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 5/5] ext4: Defer mmap cmtime update until writeback
Message-ID: <20130820040857.GI6023@dastard>
References: <cover.1376679411.git.luto@amacapital.net>
	<d59d6c9790bd3c36b93343ed91be5e0cda7e5f09.1376679411.git.luto@amacapital.net>
	<20130820023849.GF6023@dastard>
	<CALCETrU_e309onJKGg4EK2EyiZWCjNROsw83+VAK=2i_FVLWYg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALCETrU_e309onJKGg4EK2EyiZWCjNROsw83+VAK=2i_FVLWYg@mail.gmail.com>
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>

On Mon, Aug 19, 2013 at 08:30:02PM -0700, Andy Lutomirski wrote:
> On Mon, Aug 19, 2013 at 7:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Aug 16, 2013 at 04:22:12PM -0700, Andy Lutomirski wrote:
> >> A fancier implementation could probably avoid an extra journal
> >> transaction by adding a mapping_test_clear_cmtime call in
> >> ext4_writepages, but this should already be a considerable
> >> improvement -- we'll start one transaction per writepages call
> >> instead of one per page.
> >
> > I'd like to see more than just an ext4 implementation - btrfs and
> > XFS are the other main filesystems that should behave identically.
> 
> Will do.
> 
> >
> > Also, it's worthwhile to write a generic xfstest to ensure that they
> > all update the timestamp appropriately - if its' in xfstests, then
> > we can basically guarantee that it won't get randomly regressed in
> > future, and other filesystems can be easily verified as well sa
> > their implement this.
> >
> 
> Is there a guide to writing an xfstest?

Yes. see the readme file in the root directory of the repository.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
