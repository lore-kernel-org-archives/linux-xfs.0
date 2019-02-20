Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58022 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfBTUZZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Feb 2019 15:25:25 -0500
Subject: Re: [PATCH 2/3] xfs_io: fix TOCTOU in openfile()
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
 <acf1deea-a637-571b-e501-c7cbcde95c38@redhat.com>
 <20190220015034.GI14116@dastard>
 <6af42461-f96e-9902-1edb-a71f023843a7@sandeen.net>
 <20190220172359.GN32253@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1c3da823-4b0f-6ba4-53ee-eb073f3657cb@sandeen.net>
Date: Wed, 20 Feb 2019 14:25:24 -0600
MIME-Version: 1.0
In-Reply-To: <20190220172359.GN32253@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 2/20/19 11:23 AM, Darrick J. Wong wrote:
>>> Don't you need to do oflags = fcntl(fd, F_GETFL, NULL) first?
>> maybe? We just opened it with oflags, but *shrug* I guess it doesn't
>> hurt?
> The kernel can set O_ flags on the file (e.g. O_LARGEFILE) for you,
> which means that if you try to F_SETFL with the original oflags, the
> kernel will think you're trying to clear those flags and misunderstand.

Ok, thanks.

-Eric
