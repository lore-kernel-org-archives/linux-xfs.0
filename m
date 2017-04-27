Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935007AbdD0OBC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Apr 2017 10:01:02 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <9958b109-8b83-c39c-b6f3-249ffe3f812c@sandeen.net>
References: <9958b109-8b83-c39c-b6f3-249ffe3f812c@sandeen.net> <CAOQ4uxgzd35J8ii8WWifrjHowkKwTZh7=zmN5Q3Qx4ADEKtqXQ@mail.gmail.com> <1493279911-2936-1-git-send-email-amir73il@gmail.com> <20170427075946.GA22284@lst.de> <5818.1493297821@warthog.procyon.org.uk> <12937.1493299325@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13613.1493301655.1@warthog.procyon.org.uk>
Date: Thu, 27 Apr 2017 15:00:55 +0100
Message-ID: <13614.1493301655@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Eric Sandeen <sandeen@sandeen.net> wrote:

> but s_uuid in the vfs superblock isn't a pointer:
> 
>         u8 s_uuid[16];                          /* UUID */
> 
> (or am I missing your point?)

No, I'm getting it wrong.  For some reason I'm thinking it's a pointer.  I
should probably know better.  I wonder if it should be a struct uuid_v1...

David
