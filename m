Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36468 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbcJQGPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 02:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <20161016212839.GB14023@dastard>
References: <1476608111-28948-1-git-send-email-amir73il@gmail.com> <20161016212839.GB14023@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 17 Oct 2016 09:15:43 +0300
Message-ID: <CAOQ4uxhWDW7V4zakTNfaJpERWo1aa1-iOvxvaD2DqhwowpbxYA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: add command line option -M to run as multi
 threaded process
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Oct 17, 2016 at 12:28 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Oct 16, 2016 at 11:55:11AM +0300, Amir Goldstein wrote:
>> xfs_io -M will start by spawning an idle thread.
>> The purpose of this idle thread is to test io from a multi threaded
>> process. With single threaded process, the file table is not shared
>> and file structs are not reference counted.
>
> I can see this option being confusing to those who do not understand
> what is actually be done here. i.e. we'll get complaints along the
> lines of "-M say xfs_io does multithreaded IO, but I only see IO
> from one thread!". Can we name this "-i" to mean "run an idle-loop",
> which will stop people trying to use it for something it doesn't do?
>

I considered those 2 options. I see what you are saying.
Will go for -i in v3.

>> --- a/io/Makefile
>> +++ b/io/Makefile
> ....
>> --- a/io/init.c
>> +++ b/io/init.c
> ....
>
> Missing a man page update to document this new option.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
