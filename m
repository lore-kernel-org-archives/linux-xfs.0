Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755221AbdAKJIw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 04:08:52 -0500
Date: Wed, 11 Jan 2017 17:08:51 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 0/3] xfs/348: test handling of malformed inode mode
Message-ID: <20170111090851.GR1859@eguan.usersys.redhat.com>
References: <1482689376-23553-1-git-send-email-amir73il@gmail.com>
 <20170103055256.GK1859@eguan.usersys.redhat.com>
 <CAOQ4uxhJUPUsPjLg6kX4X7VMwE2DqzL_cNmEU3aEfo-37MH4bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhJUPUsPjLg6kX4X7VMwE2DqzL_cNmEU3aEfo-37MH4bA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 08:45:34AM +0200, Amir Goldstein wrote:
> On Tue, Jan 3, 2017 at 7:52 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Sun, Dec 25, 2016 at 08:09:33PM +0200, Amir Goldstein wrote:
> >> Eryu,
> >>
> >> I beefed up the initial test sent earlier today with more checks
> >> on mounted fs.
> >>
> >> The original patch testing only xfs_repair remains patch 1 in this series.
> >>
> >> Patch 2 adds fstat tests on mounted fs, which are safe on my test system.
> >>
> >> Patch 3 is explosive. It exposes an XFS assert, but I left a "safety pin"
> >> that needs to be commented out to reproduce the assert.
> >
> > My kenrel config doesn't turn DEBUG on, so I don't see a kernel crash :)
> >
> > I can push this test out after the fix lands in upstream, then I think
> > there's no need to leave a switch in the test.
> >
> > Otherwise tests look good to me. But I'd like to have Darrick to review
> > too, as he had written many fuzzer tests and suggested this test :)
> >
> 
> Eryu,
> 
> Darrick has actually reviewed patch 1 v1 and gave only minor comments,
> which I addressed in v3.
> 
> So how about merging patch 1 (v3) (sanity of xfs_repair) and leave patches 2-3
> for later?

Yeah, I was thinking about this too, will give it a quick test and queue
it up if there's no issues found. Sorry I'm a bit late reviewing these
patches, I was busy with other work these days.

Thanks,
Eryu
