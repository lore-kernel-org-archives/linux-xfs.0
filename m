Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:52553 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdEJU41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 16:56:27 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Processes stuck in D state when accessing XFSv5 filesystem
From: David Shaw <dshaw@jabberwocky.com>
In-Reply-To: <20170410152348.GD3991@bfoster.bfoster>
Date: Wed, 10 May 2017 16:56:25 -0400
Content-Transfer-Encoding: 8BIT
Message-Id: <1A8D2EF1-9CE1-4341-916A-1927A63652B8@jabberwocky.com>
References: <C1597D74-938F-4236-91F0-4CA1D6907F50@jabberwocky.com>
 <20170407165616.2269260a@harpe.intellique.com>
 <CC0DA53B-D439-476E-AEEE-44951FE8B69C@jabberwocky.com>
 <20170407173946.GD55851@bfoster.bfoster>
 <2F0091FC-EF20-4A63-B89E-C97094091953@jabberwocky.com>
 <20170410152348.GD3991@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-xfs@vger.kernel.org

On Apr 10, 2017, at 11:23 AM, Brian Foster <bfoster@redhat.com> wrote:
> 
> Interesting, nothing obvious stands out to me. It looks you have smbd
> waiting on a pread over fuse and mmon waiting on a stat. Presumably the
> smbd pread corresponds to the blocked servxfs pread and the stat to one
> of the servxfs getxattr calls.
> 
> Any idea where the other servxfs getxattr comes in?

servxfs stores some internal metadata in xattrs, so it should be normal that it makes occasional xattr calls.

>> I will get the xfs traces the next time it happens.  It seems to be happening 2-3 times a week, but frustratingly, I can't make it happen on demand. Is there something I should look for in particular in the trace output, or some amount of time to capture it for?
>> 
> 
> Can you elaborate on the resulting behavior? Are these same processes
> always involved? Can you identify whether they are attempting to access
> the same file(s) or not? Also, does the underlying filesystem continue
> to function outside of these processes seemingly all blocked on reads?
> E.g., can you read another file from the XFS fs or is all I/O blocked?
> 
> Because there are multiple layers involved here, presumably with custom
> code in between (e.g., your fuse userspace), this might be easier to
> reason about if you can dig more into what's blocked in the upper layers
> to describe precisely what high level requests are active at the XFS
> level.

I agree that removing the fuse userspace code from the equation can simplify things.  There are examples that don't go through fuse - for example, there is a postgres daemon that is running directly on the XFS filesystem that has occasionally hit the same issue (meaning going into D state and staying there "forever", or at least 30 minutes until it reboots).

Unfortunately, I'm having a huge problem reproducing the problem now.  Where it used to happen 2-3 times a week, now it's not.  So on the one hand, great, but on the other hand, it makes it hard to debug.

I will update as soon as I have something new.

David

