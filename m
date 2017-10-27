Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752412AbdJ0MqG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 08:46:06 -0400
Date: Fri, 27 Oct 2017 20:46:04 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] generic: Adjust generic test ouputs for new fiemap
 implementation
Message-ID: <20171027124604.GY3235@eguan.usersys.redhat.com>
References: <1509107832-22286-1-git-send-email-nborisov@suse.com>
 <1509107832-22286-5-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509107832-22286-5-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Oct 27, 2017 at 03:37:12PM +0300, Nikolay Borisov wrote:
>  Since xfs_io's fiemap implementation was changed to explicitly show a whole
>  when a file consists only of it adjust the output of various test accordingly. 
>  Essentially only test 1 and 10 of _test_generic_punch require changes
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  tests/generic/012.out | 1 +
>  tests/generic/016.out | 1 +
>  tests/generic/021.out | 2 ++
>  tests/generic/022.out | 2 ++
>  tests/generic/058.out | 1 +
>  tests/generic/060.out | 1 +
>  tests/generic/061.out | 1 +
>  tests/generic/063.out | 1 +
>  tests/generic/255.out | 6 ++++++
>  tests/generic/316.out | 6 ++++++
>  10 files changed, 22 insertions(+)
> 
> diff --git a/tests/generic/012.out b/tests/generic/012.out
> index ffbf8a3..8045471 100644
> --- a/tests/generic/012.out
> +++ b/tests/generic/012.out
> @@ -1,5 +1,6 @@
>  QA output created by 012
>  	1. into a hole
> +0: [0..95]: hole

I suspect this will break test runs with old xfs_io too (and again, I
haven't confirmed yet..). Perhaps we need some kind of filter?

Thanks,
Eryu
