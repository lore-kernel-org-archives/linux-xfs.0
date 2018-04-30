Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56140 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752521AbeD3N2z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Apr 2018 09:28:55 -0400
Subject: Re: [PATCH] fsck.xfs: do not use 'function' keyword
References: <20a302b8-a5c8-7cf2-94d4-3cc41560976c@sandeen.net>
 <20180430053059.GA21688@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <34b3e3c1-90a9-f901-eb3a-1bc86469ccab@sandeen.net>
Date: Mon, 30 Apr 2018 08:28:54 -0500
MIME-Version: 1.0
In-Reply-To: <20180430053059.GA21688@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jan Tulak <jtulak@redhat.com>


On 4/30/18 12:30 AM, Darrick J. Wong wrote:
> On Sun, Apr 29, 2018 at 08:15:28PM -0500, Eric Sandeen wrote:
>> It was pointed out on irc that fsck.xfs uses the 'function' keyword
>> although it invokes /bin/sh - 'function' is a bashism.  It's not needed
>> here, so just remove it.
>>
>> Fixes: 04a2d5d ("fsck.xfs: allow forced repairs using xfs_repair")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Does RHEL have 'checkbashisms'?

Hm, yes, Fedora & RHEL have it in devscripts-minimal.

$ checkbashisms ./fsck/xfs_fsck.sh
possible bashism in ./fsck/xfs_fsck.sh line 9 ('function' is useless):
function repair2fsck_code() {
possible bashism in ./fsck/xfs_fsck.sh line 62 ('command' with option other than -p):
	XFS_REPAIR=`command -v xfs_repair`

Apparently -v is only part of "User Portability Utilities?"
 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
>> ---
