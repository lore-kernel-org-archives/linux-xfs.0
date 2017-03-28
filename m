Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57738 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752750AbdC1Qmq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Mar 2017 12:42:46 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <29491.1490712064@warthog.procyon.org.uk>
Date: Tue, 28 Mar 2017 11:42:34 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <4DB15765-D097-43B5-9F1B-43DE76D3BC90@sandeen.net>
References: <29458.1490711932@warthog.procyon.org.uk> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <29491.1490712064@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

I am (literally) in the woods this week so can't really comment at length, but generally:

xfs_io is useful to facilitate testing at times, but usually doesn't have tests built into the tool itself.

And I think you are right that it is a poor fit for some of the testing you'd like to do.  There is a src/ dir in xfstests for specialized C tests which get called by the test harness; that might also be a reasonable option.

Thanks, 
Eric

> On Mar 28, 2017, at 9:41 AM, David Howells <dhowells@redhat.com> wrote:
> 
> Note that the intention is to put the testing of the syscall parameter
> handling into LTP, along with testing of the symlink following and dirfd usage
> since xfstests seems unsuitable for this.
> 
> David

