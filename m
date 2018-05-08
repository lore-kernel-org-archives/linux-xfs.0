Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43946 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755562AbeEHUSB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 16:18:01 -0400
Subject: Re: [PATCH 17/21] xfsprogs: Add delayed attributes error tag
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-18-git-send-email-allison.henderson@oracle.com>
 <20180508172107.GQ11261@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <51e55c28-386a-2177-000e-b69e9473f7b6@sandeen.net>
Date: Tue, 8 May 2018 15:17:59 -0500
MIME-Version: 1.0
In-Reply-To: <20180508172107.GQ11261@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 5/8/18 12:21 PM, Darrick J. Wong wrote:
> On Mon, May 07, 2018 at 09:41:15PM -0700, Allison Henderson wrote:
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Needs a commit message.  Eric might also want the xfs_io bit as a
> separate patch to keep this one as close to the kernel patch as
> possible.
> 
> (Though really, it's a single line, maybe not...)

I generally port libxfs to xfsprogs after it's hit the kernel, and then
fix stuff up as needed, which usually means "fix it so it builds again."

Stuff like this would get missed under that plan, so yes, a separate
patch to "enhance" xfs_io like this would be appreciated, to be sure
I don't miss it.

Thanks,
-Eric
