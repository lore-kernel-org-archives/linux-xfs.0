Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B652FC6FD1F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 06:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCNG24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 02:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCNG2x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 02:28:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1DF6C184
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 23:28:51 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v21so5393945ple.9
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1678775331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xUpzCIkz2FblEEncIDppVD2W8EIPWnx8ZdAJN/1P3P4=;
        b=Pn1yxFxq/i2u6Y3mGCXQSxmtXhNSbMGZVLrgnPHSWp4jY6xEyvN5Aew3JW8mxHQWtD
         dBRljS9AH0aBw82mgYYa9tEStlXwLQwk3310wyQhY43XDmpJeVl4Wb8YA5bQ9mvgAX0x
         SYPDXnIybogu0jciAMx8LVTk8qUBoYgaxPp5vxj2nwKY3BRdf2i9MZT9DVNBQnn9ZWj3
         djqvZPW2nkWv1j54Y7Qqsnei8Xy1o7etnNXf8FiRfoi8av8g7+rEXItqnurrEQR2rrbp
         FxkeJjso/N1wmIU4B5anzMP/aNOZDDEmgf4IKdFNQMghH7ZRthGNq0egGu32mBhrAIm/
         dTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678775331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUpzCIkz2FblEEncIDppVD2W8EIPWnx8ZdAJN/1P3P4=;
        b=uJcj+Nvxz4enMS6pYnFqAfWeq6mNui/p/drsFqAhFjw8WvA/V3gOKXekGIfv+CLCef
         B68aU0+JO8v3uw7wZESirIKwnn0Tk9qGYGbjxP5SL8KyYZeXz4nzzwn8zZuhovRffSox
         DY2s6bhSnoLmtNTjqYrvqiIMe8a9ZkiviZhkDZl/C0Rfhnry4KulbN05qDE5HhUqX1Wi
         1pY6oAd6LXnYFDJ1bA8lyosFQQRGJ6Pz7m8g/fWxqxGT8r69Jt9LLg6vk9CyBcN1I8gq
         MkEQh1dJrYd8pkF+0ECMXgzTl2RQt2hT1umWupJltrAkuka9++z+mqet6rplSy4DujIL
         6XoQ==
X-Gm-Message-State: AO0yUKXpdXazcsnx7AZY3Ckl50/H0LX3U//ofLJNaXpc0641OatlvjvJ
        PIwzvaz/+ryC8rpzZhM1UnSiYg==
X-Google-Smtp-Source: AK7set/FJaQZjfFJIOLv81AW6E88dFB4kkoS6/rq7uNHA7RY1T/Zetvb+NHl8ySrifpmj5PPUK/FTg==
X-Received: by 2002:a17:902:e842:b0:19a:b4a9:9ddb with SMTP id t2-20020a170902e84200b0019ab4a99ddbmr45078019plg.49.1678775330828;
        Mon, 13 Mar 2023 23:28:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id e1-20020a170902744100b0019c91d3bdb4sm851838plt.304.2023.03.13.23.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 23:28:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pby9P-008YmK-3F; Tue, 14 Mar 2023 17:28:47 +1100
Date:   Tue, 14 Mar 2023 17:28:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/4] setting uuid of online filesystems
Message-ID: <20230314062847.GQ360264@dread.disaster.area>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314042109.82161-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 13, 2023 at 09:21:05PM -0700, Catherine Hoang wrote:
> Hi all,
> 
> This series of patches implements a new ioctl to set the uuid of mounted
> filesystems. Eventually this will be used by the 'xfs_io fsuuid' command
> to allow userspace to update the uuid.
> 
> Comments and feedback appreciated!

What's the use case for this?

What are the pro's and cons of the implementation?

Some problems I see:

* How does this interact with pNFS exports (i.e.
CONFIG_EXPORTFS_BLOCK_OPS). XFS hands the sb_uuid directly to pNFS
server (and remote clients, I think) so that incoming mapping
requests can be directed to the correct block device hosting the XFS
filesystem the mapping information is for. IIRC, the pNFS data path
is just given a byte offset into the device where the UUID in the
superblock lives, and if it matches it allows the remote IO to go
ahead - it doesn't actually know that there is a filesystem on that
device at all...

* IIRC, the nfsd export table can also use the filesystem uuid to
identify the filesystem being exported, and IIRC that gets encoded
in the filehandle. Does changing the filesystem UUID then cause
problems with export indentification and/or file handle
creation/resolution?

* Is the VFS prepared for sb->s_uuid changing underneath running
operations on mounted filesystems? I can see that this might cause
problems with any sort of fscrypt implementation as it may encode
the s_uuid into encryption keys held in xattrs, similarly IMA and
EVM integrity protection keys.

* Should the VFS superblock sb->s_uuid use the XFS
sb->sb_meta_uuid value and never change because we can encode it
into other objects stored in the active filesystem? What does that
mean for tools that identify block devices or filesystems by the VFS
uuid rather than the filesystem uuid?

There's a whole can-o-worms here - the ability to dynamically change
the UUID of a filesystem while it is mounted mean we need to think
about these things - it's no longer as simple as "can only do it
offline" which is typically only used to relabel a writeable
snapshot of a golden image file during new VM deployment
preparation.....

> 
> Catherine
> 
> Catherine Hoang (4):
>   xfs: refactor xfs_uuid_mount and xfs_uuid_unmount
>   xfs: implement custom freeze/thaw functions

The "custom" parts that XFS requires need to be added to the VFS
level freeze/thaw functions, not duplicate the VFS functionality
within XFS and then slight modify it for this additional feature.
Doing this results in unmaintainable code over the long term.

>   xfs: add XFS_IOC_SETFSUUID ioctl
>   xfs: export meta uuid via xfs_fsop_geom

For what purpose does userspace ever need to know the sb_meta_uuid?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
