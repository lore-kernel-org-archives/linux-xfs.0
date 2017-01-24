Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750712AbdAXAa3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 19:30:29 -0500
Subject: Re: [PATCH 3/5] xfs_repair: strengthen geometry checks
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494393485.5256.16822617236354659766.stgit@birch.djwong.org>
 <0ed43e2f-2e9a-e53b-0770-1b50fee4b697@sandeen.net>
 <20170124001304.GF31202@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c6aba747-4c98-845a-9be6-a993d5ee88d5@sandeen.net>
Date: Mon, 23 Jan 2017 18:29:56 -0600
MIME-Version: 1.0
In-Reply-To: <20170124001304.GF31202@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 1/23/17 6:13 PM, Darrick J. Wong wrote:
>> So I guess the question is: If the superblock stripe geometry
>> is inconsistent by the time we get to is_multidisk_filesystem(),
>> what should we do?
>>
>> 1) catch it earlier in verify_sb, and copy from backup?
>> 2) keep that as it is, but only return true here if all 3 are set?
> I'm ok with running in slow mode if the stripe data seems garbage.
> TBH I'd prefer to have as few asserts in the repair program as possible,
> particularly since this is a performance optimization.

yeah.

> return xfs_sb_version_hasdalign(sbp) && sbp->sb_unit && sbp->s_width;

Backing up, I guess it's really not all that important in this
function, as long as we don't ASSERT.  I was actually going to suggest
returning true if all 3 were set, yes.

It just seems that this all should have been consistent by the time
we get here, having already gone through superblock verification
routines.

Might make sense to add it, but I guess that may as well be another
patch.

-Eric
