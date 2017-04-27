Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934088AbdD0NWM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Apr 2017 09:22:12 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOQ4uxgzd35J8ii8WWifrjHowkKwTZh7=zmN5Q3Qx4ADEKtqXQ@mail.gmail.com>
References: <CAOQ4uxgzd35J8ii8WWifrjHowkKwTZh7=zmN5Q3Qx4ADEKtqXQ@mail.gmail.com> <1493279911-2936-1-git-send-email-amir73il@gmail.com> <20170427075946.GA22284@lst.de> <5818.1493297821@warthog.procyon.org.uk>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12936.1493299325.1@warthog.procyon.org.uk>
Date: Thu, 27 Apr 2017 14:22:05 +0100
Message-ID: <12937.1493299325@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Amir Goldstein <amir73il@gmail.com> wrote:

> You mean if it is NULL_UUID_LE? Yes, that is what I do now.
> Christoph suggested that this is not robust enough.
> I'm rather indifferent about the need of a flag.

I was thinking more that s_uuid would be a NULL pointer if the fs doesn't have
a uuid.

David
