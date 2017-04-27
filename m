Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35471 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753849AbdD0NIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 09:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <5818.1493297821@warthog.procyon.org.uk>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
 <20170427075946.GA22284@lst.de> <5818.1493297821@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 27 Apr 2017 16:08:43 +0300
Message-ID: <CAOQ4uxgzd35J8ii8WWifrjHowkKwTZh7=zmN5Q3Qx4ADEKtqXQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 3:57 PM, David Howells <dhowells@redhat.com> wrote:
> Christoph Hellwig <hch@lst.de> wrote:
>
>> Until we have a flag in the superblock that a given fs fills out s_uuid
>> no one can rely on it.  So please add the infrastructure that consumers
>> can actually make use of it while you're at it.
>
> Can't you just look at whether s_uuid is NULL or not?
>

You mean if it is NULL_UUID_LE? Yes, that is what I do now.
Christoph suggested that this is not robust enough.
I'm rather indifferent about the need of a flag.
