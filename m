Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:48760 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935733AbeFNCbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jun 2018 22:31:35 -0400
Date: Thu, 14 Jun 2018 12:31:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reading/changing projid of a symlink
Message-ID: <20180614023132.GI10363@dastard>
References: <CA+Xn3kwTnu8yd-DCy37323waPgNm0jNuL9NDhz8s8pY023COSw@mail.gmail.com>
 <20180612143608.ok3jqtl3l34vdlpy@odin.usersys.redhat.com>
 <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Xn3kyxiOj+irNiqKWQWfJ_aUv1RYFsH+UCnv3gnMuYJ=oUQw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Pronin <ipronin@twitter.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>

On Tue, Jun 12, 2018 at 03:17:27PM -0700, Ilya Pronin wrote:
> So the only way to remove a symlink from a project is to remove it?
> 
> Here's my use case. In Apache Mesos we use XFS project quotas for disk
> space isolation. Every container sandbox is allocated its own project
> ID. When the container terminates its project ID is unset from the
> sandbox and files inside it, and can be used for other containers.
> Sandboxes of terminated containers stay on the host for some time for
> debugging, etc. With such approach the inability to remove projid from
> symlinks presents a small problem: when a project ID is reused for a
> new container, any lingering symlinks that still have that project ID
> will contribute to disk usage of the new container. Typically not
> much, but still that's inaccurate. I guess we'll need to change when
> we "deallocate" projids.

XFS has a 32bit project ID space, so you really don't need to reuse
project IDs at all. Just keep incrementing the new container ID, and
maybe after a couple of billion project IDs have been consumed you
can look at reclaiming/recycling/resetting the new ID counter?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
