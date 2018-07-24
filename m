Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388522AbeGXTWm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jul 2018 15:22:42 -0400
Subject: Re: [PATCH] xfs: properly handle free inodes in extent hint
 validators
References: <4203c670-0064-8735-0931-573fdbeeaa67@redhat.com>
 <20180724181052.GV4813@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <fc1a459a-dc00-8236-898f-5277d37eecd9@redhat.com>
Date: Tue, 24 Jul 2018 11:14:59 -0700
MIME-Version: 1.0
In-Reply-To: <20180724181052.GV4813@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 7/24/18 11:10 AM, Darrick J. Wong wrote:
> On Tue, Jul 24, 2018 at 11:00:39AM -0700, Eric Sandeen wrote:
>> When inodes are freed in xfs_ifree(), di_flags is cleared (so extent size
>> hints are removed) but the actual extent size fields are left intact.
>> This causes the extent hint validators to fail on freed inodes which once
>> had extent size hints. 
>>
>> This can be observed (for example) by running xfs/229 twice on a
>> non-crc xfs filesystem, or presumably on V5 with ikeep.
> 
> I couldn't get it to reproduce by running x/229 twice, but I did see
> x/242 blow up on the same problem overnight.  Which is funny since it
> hadn't blown up until now.

Huh.  Can you try it on a 16G fs?  Not sure what else might be unique
about my setup.

>> Fixes: 7d71a67 ("xfs: verify extent size hint is valid in inode verifier")
>> Fixes: 02a0fda ("xfs: verify COW extent size hint is valid in inode verifier")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Separate patch, but can you also modify xfs_ifree to zero the
> extsize/cowextsize fields so that 4.16-4.17 kernels without this patch
> are less likely to trip over this?

I'm confused - 7d71a67 & 02a0fda (above) went into 4.18, so 4.1[67]
shouldn't have the validator problem, right?

Are you talking about scrub here?

Sorry for waxing philosophical but my fear is that explicitly zeroing the
fields /now/ will muddy the waters w.r.t. what we should expect to see on
disk.  We had wrong verifiers, not wrong freeing routines - we need to
just fix the verifiers IMHO.  Scrub is experimental for a reason, right?

Thanks,
-Eric
