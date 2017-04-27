Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031730AbdD0M5E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Apr 2017 08:57:04 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170427075946.GA22284@lst.de>
References: <20170427075946.GA22284@lst.de> <1493279911-2936-1-git-send-email-amir73il@gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5817.1493297821.1@warthog.procyon.org.uk>
Date: Thu, 27 Apr 2017 13:57:01 +0100
Message-ID: <5818.1493297821@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Until we have a flag in the superblock that a given fs fills out s_uuid
> no one can rely on it.  So please add the infrastructure that consumers
> can actually make use of it while you're at it.

Can't you just look at whether s_uuid is NULL or not?

David
