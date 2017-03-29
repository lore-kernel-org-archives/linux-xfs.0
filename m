Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932829AbdC2X5L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 19:57:11 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <859.1490824354@warthog.procyon.org.uk>
References: <859.1490824354@warthog.procyon.org.uk> <29183.1490711359@warthog.procyon.org.uk>
Subject: The XFS_IOC_FSGEOMETRY ioctl doesn't like fds that are opened O_PATH
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5586.1490831828.1@warthog.procyon.org.uk>
Date: Thu, 30 Mar 2017 00:57:08 +0100
Message-ID: <5587.1490831828@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>

Should XFS_IOC_FSGEOMETRY work on fds that are opened O_PATH on an XFS
filesystem?  Or should xfs_io not call that ioctl on O_PATH fds?

David
