Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36359 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422929AbdD3FED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Apr 2017 01:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <20170430005455.GV29622@ZenIV.linux.org.uk>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
 <20170429230159.GM12369@dastard> <20170430005455.GV29622@ZenIV.linux.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 30 Apr 2017 08:04:02 +0300
Message-ID: <CAOQ4uxico4NuXMpRNU4qOwxGRqF8=sdHa72G0JEK1fAgMt3u5A@mail.gmail.com>
Subject: Re: [PATCH 0/5] VFS API for getting filesystem's UUID
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Apr 30, 2017 at 3:54 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Apr 30, 2017 at 09:01:59AM +1000, Dave Chinner wrote:
>
>> Doesn't this make the struct export_opierations .get_uuid method
>> somewhat redundant?  Shouldn't that now be replaced with generic
>> functions that looks at SB_I_HAVE_UUID before allowing PNFS export
>> is allowed and then just use s_uuid directly in the PNFS code?
>
> Do we even need a flag?  Checking if 16 bytes are not all zeroes isn't hard,
> after all...

Nope, it's not hard and that is what we do now.
I posted the flag per Christoph's suggestion to see what others  have to say.

Amir.
