Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E49C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 14:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC3161076
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Nov 2021 14:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhKBObx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Nov 2021 10:31:53 -0400
Received: from sandeen.net ([63.231.237.45]:35780 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhKBObw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Nov 2021 10:31:52 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 245757BBE;
        Tue,  2 Nov 2021 09:27:41 -0500 (CDT)
Message-ID: <e4923a33-2116-5484-d95e-6384d96649aa@sandeen.net>
Date:   Tue, 2 Nov 2021 09:29:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: cause of xfsdump msg: root ino 192 differs from mount dir ino 256
Content-Language: en-US
To:     L A Walsh <xfs@tlinx.org>, linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>
References: <617721E0.5000009@tlinx.org>
 <20211026004814.GA5111@dread.disaster.area> <61804254.3070001@tlinx.org>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <61804254.3070001@tlinx.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/1/21 2:39 PM, L A Walsh wrote:
> 
> When I xfsdump my /home partition, I see the above diagnostic
> where it  lists "bind mount?" might be involved, but as far as
> I can see, that's not the case.
> 
> grepping for '/home\s' on output of mount:
> 
> /bin/mount|grep -P '/home\s'
> 
> shows only 1 entry -- nothing mounted on top of it:
> 
> /dev/mapper/Space-Home2 on /home type xfs (...)
> 
> I have bind-mounts of things like
> /home/opt  on /opt, but that shouldn't affect the root node,
> as far as I know.
> 
> So what would cause the root node to differ from the mountdir
> ino?
> 
> I try mounting the same filesystem someplace new:
> 
> # df .
> Filesystem        Size  Used Avail Use% Mounted on
> /dev/Space/Home2  2.0T  1.5T  569G  73% /home
> 
> mkdir /home2
> Ishtar:home# mount /dev/Space/Home2 /home2
> 
> Ishtar:home# ll -di /home /home2
> 256 drwxr-xr-x 40 4096 Nov  1 10:23 /home/
> 256 drwxr-xr-x 40 4096 Nov  1 10:23 /home2/
> 
> Shows 256 as the root inode.  So why is xfsdump claiming
> 192 is root inode?

Because of an error I made some time ago; we have the fix for it,
and possibly a workaround to recover dumps created with this bug in
place.  Ping me off-list and I can give you an xfsdump package to test
with (hopefully) a workaround for restore, ok?

Thanks,
-Eric

> I used xfs_db and 192 is allocated to a normal file, while
> 256 displays nothing for the filename.
> 
> How should I further debug this?
> 
> 
> 
> 
