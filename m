Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OCMIPp141138 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 07:22:18 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	DdHXkr6YYdnIXEFh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 05:23:34 -0700 (PDT)
Received: by vchn11 with SMTP id n11so6349121vch.26
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 05:23:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <505FD0A9.3090601@redhat.com>
References: <1348428276-13161-1-git-send-email-dmonakhov@openvz.org>
	<505FD0A9.3090601@redhat.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 24 Sep 2012 08:23:04 -0400
Message-ID: <CAGpXXZ+LGZcoztAcEND46ndhmGbKHjVmykAU4d11Jsf7B_L53Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] xfstest: add fio git submodule
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de, xfs@oss.sgi.com

On Sun, Sep 23, 2012 at 11:16 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> (I package fio for Fedora, is it not commonly available on other
> distros?)

opensuse has it in the benchmarking repo, but not in the main release
repos.  If it is getting regular updates and users will want to have
the latest version, it makes sense for opensuse to leave it that way.
This discussion may change that.

As of a year ago, xfstests dependencies could all be met from the main
repos.  (see howto http://en.opensuse.org/SDB:XFStests)

I believe a basic set of xfstests is run as part of the QA process for
every factory build (factory is similar to rawhide).  At least it was
during 12.1 pre-release testing a year ago.
http://openqa.opensuse.org/results/

Not a huge deal, but having xfstests tests which depend on fio would
either mean opensuse dropping those tests that depend on fio from its
routine QA testing, or it would mean adding fio to the main distro.

How far into xfstests is fio likely to integrate?  If it is to become
a core tool and it is not going to be provided by xfstests itself, I
can try to submit fio to factory.  It will just have to kept new
enough to satisfy xfstests version requirements.

I do hope that if the distro has to provide a fio package, then
xfstests only depend on the version, not the git check-in.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
