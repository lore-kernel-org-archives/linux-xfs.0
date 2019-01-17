Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbfAQNth (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jan 2019 08:49:37 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190117075320.8327-1-hch@lst.de>
References: <20190117075320.8327-1-hch@lst.de>
Subject: Re: [PATCH] fs: move generic stat response attr handling to vfs_getattr_nosec
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15566.1547732975.1@warthog.procyon.org.uk>
Date: Thu, 17 Jan 2019 13:49:35 +0000
Message-ID: <15567.1547732975@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> generic_fillattr is an optional helper that isn't used by all
> file systems, move handling purely based on inode flags to
> vfs_getattr_nosec, which is common code.
> 
> This fixes setting this flag for file systems not using generic_fillattr
> like xfs.

The only problem I have with this change is that you've moved the flag setting
to after the ->getattr() call, which means that the filesystem cannot override
it.  I'm not sure that particularly matters in the case of these two flags,
but it might encourage similar things to be put there where it could matter.

David
