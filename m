Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45296 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968146AbdD0H7t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Apr 2017 03:59:49 -0400
Date: Thu, 27 Apr 2017 09:59:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Message-ID: <20170427075946.GA22284@lst.de>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Apr 27, 2017 at 10:58:31AM +0300, Amir Goldstein wrote:
> Unless mounted with nouuid, copy the uuid of the filesystem to
> struct super block s_uuid field, as several other filesystems do.

This looks okay ... ish.

Until we have a flag in the superblock that a given fs fills out s_uuid
no one can rely on it.  So please add the infrastructure that consumers
can actually make use of it while you're at it.
