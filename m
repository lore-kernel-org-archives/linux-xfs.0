Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48100 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731411AbeLTQDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 11:03:02 -0500
Date: Thu, 20 Dec 2018 08:02:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: RFC: deprecate mkfs.xfs protofile functionality
Message-ID: <20181220160251.GA27208@magnolia>
References: <e3b338cb-33d0-04d0-c14c-7b06a7b924c9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b338cb-33d0-04d0-c14c-7b06a7b924c9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 20, 2018 at 08:34:25AM -0600, Eric Sandeen wrote:
> I'd like to deprecate and eventually remove the protofile functionality
> in mkfs.xfs, because it's not well tested code which is really a special
> snowflake in the codebase that adds complexity.  And as far as I know,
> nobody uses it.

It also would seem to barf out corrupt long format symlinks on v5
filesystems, as I discovered while cleaning up mkfs and repair
yesterday.

> If I'm wrong though, speak up now.  Is anybody using protofiles?
> 
> (If you don't know what a protofile is, then you're not using it.
> And let's not turn this into a "well I could think of a way to use it"
> discussion, because it's been there for a couple decades and if you're
> not using it /yet/ ... unless there really is some new usecase on the
> horizon which would clearly depend on it.)

I'd rather have a mkfs feature that copies everything under a given path
into a newly formatted filesystem, and even then only if there's an
especially good reason why mount/cp/umount cannot be done.

So I say nuke the protofiles in xfsprogs 5.0. :P

--D

> Thanks,
> -Eric
