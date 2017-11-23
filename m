Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbdKWHFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 02:05:09 -0500
Date: Thu, 23 Nov 2017 15:05:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 0/3] fix failures caused by mount error msg change in
 util-linux v2.30
Message-ID: <20171123070505.GS2749@eguan.usersys.redhat.com>
References: <20171114123310.25286-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171114123310.25286-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com, linux-xfs@vger.kernel.org

On Tue, Nov 14, 2017 at 08:33:07PM +0800, Eryu Guan wrote:
> util-linux v2.30 changed mount error message again and caused several
> tests to fail (reported by Misono Tomohiro, thanks!), this is mainly due
> to two util-linux commits in v2.30-rc1
> 
> 6dede2f2f7c5 libmount: support MS_RDONLY on write-protected devices
> ea848180dd34 libmount: add mnt_context_get_excode()
> 
> This patchset introduced _filter_ending_dot, _filter_error_mount and
> _filter_busy_mount and improved _filter_ro_mount to deal with all these
> output differences between old and new util-linux versions.
> 
> I've tested and confirmed generic/050, xfs/005 and overlay/03[567] all
> passed with both old and new util-linux. xfs/333 is always _notrun
> because there's no realtime-rmapbt support yet.
> 
> Perhaps there're better and cleaner ways to fix the problems, please
> help review and advise, thanks!

Could someone help review this patchset please? Newer distributions like
Fedora 27 have already shipped util-linux v2.30. I'd like to see them
fixed before they're causing problems for more and more people.

Thanks,
Eryu

> 
> Eryu
> 
> v2:
> - remove not-needed _filter_scratch from tests
> 
> Eryu Guan (3):
>   fstests: filter mount error message for EUCLEAN and ESTALE
>   overlay/036: filter busy mount message
>   fstests: filter readonly mount error messages
> 
>  common/filter         | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  tests/generic/050     |  8 +++---
>  tests/generic/050.out |  8 +++---
>  tests/overlay/035     |  9 +++++--
>  tests/overlay/036     |  4 +--
>  tests/overlay/036.out |  4 +--
>  tests/overlay/037     |  4 +--
>  tests/overlay/037.out |  4 +--
>  tests/xfs/005         |  7 +-----
>  tests/xfs/333         |  2 +-
>  tests/xfs/333.out     |  2 +-
>  11 files changed, 95 insertions(+), 27 deletions(-)
> 
> -- 
> 2.13.6
> 
