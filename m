Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51034 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbeBXWIL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Feb 2018 17:08:11 -0500
Subject: Re: xfs_repair: add '-F' option to ignore writable mount checking
References: <5A914B45.8080200@xtaotech.com>
 <5c0df437-0f09-129c-945f-0f917bfdaa7e@sandeen.net>
 <20180224220428.GB30854@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a972f275-7502-ab67-4eed-61e0378ee6a6@sandeen.net>
Date: Sat, 24 Feb 2018 16:08:10 -0600
MIME-Version: 1.0
In-Reply-To: <20180224220428.GB30854@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Yang Joseph <joseph.yang@xtaotech.com>, sandeen@redhat.com, nathans@debian.org, linux-xfs@vger.kernel.org



On 2/24/18 4:04 PM, Dave Chinner wrote:
>> That sounds like a bug worth fixing, but I am much
>> less excited about adding options which could do serious damage
>> to a filesystem.

> TO me it sounds like something that should be fixed by a reboot, not
> by adding dangerous options to xfs_repair...

Yes, that was my point - if it's hung there is a bug somewhere, that
should be fixed - not necessarily in xfsprogs ;)  But without more
info about the situation, I don't know.

-Eric
