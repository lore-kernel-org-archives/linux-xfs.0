Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46560 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163861AbdD1Ftx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 01:49:53 -0400
Date: Fri, 28 Apr 2017 06:49:45 +0100
From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Message-ID: <20170428054945.rg54cm5yftfuqfsf@brain>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
 <20170427193118.GH23371@birch.djwong.org>
 <984c6ee4-9ece-7424-420f-1fc26faca378@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <984c6ee4-9ece-7424-420f-1fc26faca378@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 27, 2017 at 03:30:35PM -0500, Eric Sandeen wrote:

> It'd be trivial to make that a vfs function and set a flag on the vfs super
> if the UUID is not unique.  Would that be worthwhile?  I can send a patch 
> if so.

This only tells you that the UUID it has is unique now.  As you are
contemplating storing them in the FS they have to be unique in space
_and_ time.  No check you can do now can tell you if the UUID is unique
for all time.  Right ?

-apw
