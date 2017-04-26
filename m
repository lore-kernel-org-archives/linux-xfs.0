Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031779AbdDZWgi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 18:36:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28BDAC04B95A
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 22:36:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <afe93fb1-ee3b-ce0c-ce32-d6d63acd05a0@redhat.com>
References: <afe93fb1-ee3b-ce0c-ce32-d6d63acd05a0@redhat.com>
Subject: Re: [PATCH] xfs_io: fix statx call for changed UAPI
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26316.1493246195.1@warthog.procyon.org.uk>
Date: Wed, 26 Apr 2017 23:36:35 +0100
Message-ID: <26317.1493246195@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> wrote:

> Due to a late-breaking change in the statx UAPI in kernel commit
> 
> 1e2f82d1 statx: Kill fd-with-NULL-path support in favour of AT_EMPTY_PATH
> 
> we'll need to fix the way we call the syscall in xfs_io.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: David Howells <dhowells@redhat.com>
