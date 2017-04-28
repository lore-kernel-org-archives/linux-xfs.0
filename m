Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34655 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162091AbdD1GYt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2017 02:24:49 -0400
Received: by mail-io0-f196.google.com with SMTP id h41so8904528ioi.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2017 23:24:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjuo=jnifmDDc2yT_A9tDGxaX56=HCg+7aaCpzVFCuMNg@mail.gmail.com>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
 <20170427193118.GH23371@birch.djwong.org> <984c6ee4-9ece-7424-420f-1fc26faca378@sandeen.net>
 <20170428054945.rg54cm5yftfuqfsf@brain> <20170428055658.GD22884@birch.djwong.org>
 <CAOQ4uxjuo=jnifmDDc2yT_A9tDGxaX56=HCg+7aaCpzVFCuMNg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 Apr 2017 08:24:43 +0200
Message-ID: <CAJfpegvd-BqsG8XTw4C_98OvJZQZN9YB0SVHczdAPc1EKSLpvQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Andy Whitcroft <apw@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Apr 28, 2017 at 8:18 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Apr 28, 2017 at 8:56 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
>> On Fri, Apr 28, 2017 at 06:49:45AM +0100, Andy Whitcroft wrote:
>>> On Thu, Apr 27, 2017 at 03:30:35PM -0500, Eric Sandeen wrote:
>>>
>>> > It'd be trivial to make that a vfs function and set a flag on the vfs super
>>> > if the UUID is not unique.  Would that be worthwhile?  I can send a patch
>>> > if so.
>>>
>>> This only tells you that the UUID it has is unique now.  As you are
>>> contemplating storing them in the FS they have to be unique in space
>>> _and_ time.  No check you can do now can tell you if the UUID is unique
>>> for all time.  Right ?

I don't understand this fuss about checking if a unique identifier is
unique.  It obviously is, if not don't call it uuid, call it nuuid.

Thanks,
Miklos
