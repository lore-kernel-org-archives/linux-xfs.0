Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750741AbdIELba (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 07:31:30 -0400
Date: Tue, 5 Sep 2017 19:31:28 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 07/14] fsx: add optional logid prefix to log messages
Message-ID: <20170905113128.GG8034@eguan.usersys.redhat.com>
References: <1504104706-11965-1-git-send-email-amir73il@gmail.com>
 <1504104706-11965-8-git-send-email-amir73il@gmail.com>
 <20170905104641.GA8034@eguan.usersys.redhat.com>
 <CAOQ4uxi1mu5QXt3PJuk27WJvm+vS63ct+VQsDJvxvaLiEGzrAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi1mu5QXt3PJuk27WJvm+vS63ct+VQsDJvxvaLiEGzrAA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 05, 2017 at 02:24:20PM +0300, Amir Goldstein wrote:
> On Tue, Sep 5, 2017 at 1:46 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Wed, Aug 30, 2017 at 05:51:39PM +0300, Amir Goldstein wrote:
> >> When writing the intermixed output of several fsx processes
> >> to a single log file, it is usefull to prefix logs with a log id.
> >> Use fsx -j <logid> to define the log messages prefix.
> >
> > Would it be better to allow any string as prefix, not limit to id
> > number?
> >
> 
> Maybe, but I didn't see an immediate need for that beyond
> the concurrent test runs, for with numeric id is sufficient.

I agreed, I don't have strong preference on this.

Thanks,
Eryu
> 
> Besides, the function that prepends the prefix, prt()
> is sometimes uses for continued line, which results with
> weird looking lines like this one:
> 
> 1: 60( 60 mod 256): 1: FALLOC   0x30140 thru 0x30f3c    (0xdfc bytes)
> 1: EXTENDING1:
> 
> So it's not really worth fixing properly, but anything more then a single
> numeric prefix is going to look quite bad.
