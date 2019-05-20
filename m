Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfETVbP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 17:31:15 -0400
Subject: Re: [PATCH] xfs: remove unused flag arguments
References: <ed89244f-cc3a-6bcf-316c-68edc8aee4cc@redhat.com>
 <20190520212139.GC5335@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a0756ae7-eb4d-c25a-a567-d8d27301d12b@redhat.com>
Date: Mon, 20 May 2019 16:31:08 -0500
MIME-Version: 1.0
In-Reply-To: <20190520212139.GC5335@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 5/20/19 4:21 PM, Darrick J. Wong wrote:
> On Wed, May 15, 2019 at 01:37:32PM -0500, Eric Sandeen wrote:
>> There are several functions which take a flag argument that is
>> only ever passed as "0," so remove these arguments.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> (motivated by simplifying userspace libxfs, TBH)
>>
>>  libxfs/xfs_ag.c          |    8 ++++----
>>  libxfs/xfs_alloc.c       |    4 ++--
>>  libxfs/xfs_attr_remote.c |    2 +-
>>  libxfs/xfs_bmap.c        |   14 +++++++-------
>>  libxfs/xfs_btree.c       |   30 +++++++++++-------------------
>>  libxfs/xfs_btree.h       |   10 +++-------
>>  libxfs/xfs_sb.c          |    2 +-
>>  scrub/repair.c           |    2 +-
>>  xfs_bmap_util.c          |    6 +++---
>>  xfs_buf.h                |    5 ++---
> 
> Do you have an accompanying xfsprogs patch up your sleeve somewhere too?
> :)

yeah it's on the list, trying to decide if I want to wait and
libxfs-merge this or just do it since IIRC it's kind of in the way
of my other xfsprogs patches...

Thanks,
-Eric
