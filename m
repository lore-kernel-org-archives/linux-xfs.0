Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbfBNPyT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 10:54:19 -0500
Date: Thu, 14 Feb 2019 07:54:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUkY=?= =?utf-8?Q?C?= PATCH] ext4: add link
 file support for {GET,SET}XATTR ioctl
Message-ID: <20190214155410.GF32253@magnolia>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
 <20190131034106.GJ4205@dastard>
 <20190131174059.GA10211@magnolia>
 <20190131204301.GK4205@dastard>
 <BYAPR19MB2758BDB15262B0333504B70ED4670@BYAPR19MB2758.namprd19.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR19MB2758BDB15262B0333504B70ED4670@BYAPR19MB2758.namprd19.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wshilong@ddn.com>
Cc: Dave Chinner <david@fromorbit.com>, Wang Shilong <wangshilong1991@gmail.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-fs@vger.kernel.org" <linux-fs@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>

On Thu, Feb 14, 2019 at 08:14:56AM +0000, Wang Shilong wrote:
> Hi Dave, Darrick,
> 
>       Thanks for good suggestions!
> As my understanding, we could modify 
> 
> do_fchownat() to change project ID instead of
> group id if AT_FCHOWN_PROJID(new flags) passed in.
> 
> Besides that we also need a new flag AT_FCHOWN_PROJ_INHERIT.
> to set/clear inherit attributes? 

That sounds reasonable enough to consider as a formal proposal.

> And for Project Get, we might need extend 'struct attr {'
> to include project id.

Let's add a new STATX_PROJID so that statx() callers can fetch it?

Also manpage updates and fstests cases...

--D

> What do you think?
> 
> Thanks,
> Shilong
