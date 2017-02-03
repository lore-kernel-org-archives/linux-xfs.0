Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbdBCGmx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 01:42:53 -0500
Date: Fri, 3 Feb 2017 14:42:30 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/3] xfs/263: don't hardcode inode numbers in output
Message-ID: <20170203064230.GA1859@eguan.usersys.redhat.com>
References: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
 <7df1dabe-3832-ffa7-cb80-07ee602bd455@sandeen.net>
 <20170128203012.GQ14033@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170128203012.GQ14033@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sat, Jan 28, 2017 at 12:30:12PM -0800, Darrick J. Wong wrote:
> On Sat, Jan 28, 2017 at 12:10:56PM -0600, Eric Sandeen wrote:
> > On 1/28/17 11:38 AM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Since we can't control the inode number assignments when creating files,
> > > don't hardcode them in the golden output.
> > 
> > what numbers are you seeing?
> > 
> > The inode numbers aren't important for the test, but I don't want to
> > gloss over something unexpected.
> 
> I consistently see 131+64 = 195 and things like that.

I occasionally see 195/6 inode numbers too, I suspect it has something
to do with 4k-sector disks. Test failed if I point SCRATCH_DEV to a
4k-sector scsi_debug device, and test passed after applying this patch.

Thanks,
Eryu
