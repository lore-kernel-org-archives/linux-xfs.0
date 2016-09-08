Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33628 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938732AbcIHIfo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 04:35:44 -0400
Received: by mail-wm0-f68.google.com with SMTP id b187so2712826wme.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 01:35:43 -0700 (PDT)
Date: Thu, 8 Sep 2016 10:35:37 +0200
From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [BUG] xfsprogs-4.7.0: issues cross-compiling for musl
Message-ID: <20160908103537.13c1c7dc@gmail.com>
In-Reply-To: <20160907222753.GR30056@dastard>
References: <1473241376-10922-1-git-send-email-ralph.sennhauser@gmail.com>
        <20160907222753.GR30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

Hi Dave,

will answer to 1-3 via Erics mail

On Thu, 8 Sep 2016 08:27:53 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Sep 07, 2016 at 11:42:56AM +0200, Ralph Sennhauser wrote:
> > 4) sys/ustat.h is missing in musl.  
> 
> Yup, been reported before. I'm about to commit a fix for that,
> mainly because certain new arches don't even implement the ustat
> system call, and glibc completely fucks up the handling of that.
> i.e. programs that call ustat don't fail at build time, the syscall
> is stubbed to print "not supported, will fail" at runtime. Hence
> nobody noticed that the xfsprogs code calling ustat was actually
> broken until a week ago...
> 
> Cheers,
> 
> Dave.

So this one I can consider taken care of, very nice!

Thanks
Ralph
