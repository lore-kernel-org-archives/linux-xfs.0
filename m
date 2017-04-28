Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41536 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756559AbdD1F5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 01:57:13 -0400
Date: Thu, 27 Apr 2017 22:56:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Message-ID: <20170428055658.GD22884@birch.djwong.org>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
 <20170427193118.GH23371@birch.djwong.org>
 <984c6ee4-9ece-7424-420f-1fc26faca378@sandeen.net>
 <20170428054945.rg54cm5yftfuqfsf@brain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170428054945.rg54cm5yftfuqfsf@brain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Whitcroft <apw@canonical.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Apr 28, 2017 at 06:49:45AM +0100, Andy Whitcroft wrote:
> On Thu, Apr 27, 2017 at 03:30:35PM -0500, Eric Sandeen wrote:
> 
> > It'd be trivial to make that a vfs function and set a flag on the vfs super
> > if the UUID is not unique.  Would that be worthwhile?  I can send a patch 
> > if so.
> 
> This only tells you that the UUID it has is unique now.  As you are
> contemplating storing them in the FS they have to be unique in space
> _and_ time.  No check you can do now can tell you if the UUID is unique
> for all time.  Right ?

Well, since we're talking about all time: "probably" :P

That said, Eric was talking about a refactoring of one of XFS's mount
time checks that errors out if there's already a mounted fs with the
same uuid.  We use it to avoid catastrophic mounting of the same fs from
multiple (misconfigured) multipaths/snapshots/volumes/whatever on the
same machine.  Not sure if that's useful for Amir's case.

--D

> 
> -apw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
