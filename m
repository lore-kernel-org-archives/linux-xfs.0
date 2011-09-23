Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NDuRYR104856 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 08:56:27 -0500
Subject: Re: [PATCH] xfstests: add new getdents test
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <CANOLnOPm+BEQ0QOYnYRkJqpGPwyUD9D+23dJe2OwgrHXqYFyVA@mail.gmail.com>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
	<1316722702.2009.59.camel@doink>
	<CANOLnOPm+BEQ0QOYnYRkJqpGPwyUD9D+23dJe2OwgrHXqYFyVA@mail.gmail.com>
Date: Fri, 23 Sep 2011 08:56:22 -0500
Message-ID: <1316786182.2879.8.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, 2011-09-23 at 16:03 +0300, Grazvydas Ignotas wrote:
> On Thu, Sep 22, 2011 at 11:18 PM, Alex Elder <aelder@sgi.com> wrote:
> > On Mon, 2011-09-12 at 03:19 +0300, Grazvydas Ignotas wrote:
> >> The test checks if no duplicate d_off values are returned and that
> >> those values are seekable to the right inodes.
> >>
> >> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> >
> > I have two minor comments on the C program below,
> > but even if you don't want to address them this
> > looks good.
> >
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> >

. . .

> >> +static uint64_t d_off_histoty[HISTORY_LEN];
> >> +static uint64_t d_ino_histoty[HISTORY_LEN];
> >
> > Is "histoty" intentional or a typo?
> 
> whoops, it's a typo. I might send a patch for this later.

I will change this for you before committing.

> >
> >> +int
> >> +main(int argc, char *argv[])

. . .

> >> +             nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
> >
> > You could just use sizeof (struct linux_dirent_64) rather than
> > BUF_SIZE here.  I suppose it doesn't hurt but there's no real
> > sense in reading more than the one you're going to look at.
> 
> I'm not sure if reading partial entry is allowed, manpage says it may
> fail with EINVAL if buffer size is too small..

I will keep this as-is.  I was wrong about the size you should
pass, but my point still stands...  For a single entry you need
to pass a buffer big enough to hold a linux_dirent64 structure
*plus* the maximum-sized name that entry could contain.  That
appears to be 256 bytes, though POSIX allows more.

Anyway, if you or anyone else wants to try to change this
in the future to read in a smaller amount here, that's fine
but it's not necessary now.

Bottom line, I'll make the change I mentioned above and
will commit the result.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
