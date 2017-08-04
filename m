Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751891AbdHDIz2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Aug 2017 04:55:28 -0400
Date: Fri, 4 Aug 2017 04:55:26 -0400 (EDT)
From: Carlos Eduardo Maiolino <cmaiolin@redhat.com>
Message-ID: <1977631726.66215858.1501836926842.JavaMail.zimbra@redhat.com>
In-Reply-To: <20170803223538.GB21024@dastard>
References: <20170803151915.7861-1-cmaiolino@redhat.com> <20170803223538.GB21024@dastard>
Subject: Re: [PATCH] Stop searching for free slots in an inode chunk when
 there are none
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave.


> > Add a way to stop the loop when a free slot is not found in the btree,
> > making the function to fall into the whole AG scan which will then, be
> > able to detect the corruption and shut the filesystem down.
> 
> That doesn't sound quite right. The initial scan and the restart
> loop are both limited to scanning search_distance records - we never
> search the entire tree except when it's really small (i..e less than
> 10-20 records (640-1280 inodes) depending on balance). If the
> pagino record to end of btree distance in both directions is shorter
> than the search distance for a given loop (i.e. less than 10 records
> from pagino to end-of-btree) then that is the only time a corrupted
> agi->freecount can cause this problem.
> 

I agree with you, but still, we are feasible to have this corruption happening,
and I've seen reports of users hitting it.


> IOWs, on production systems where there's more than a few hundred
> inodes (i.e. the vast majority of installations) a corrupted
> agi->freecount won't lead to a endless loop because search_distance
> will terminate the retry loop and we'll allocate a new inode.
> 
> To tell the truth, I'd much rather we just use the search distance
> to prevent endless looping than add a second method of limiting
> the search loop. i.e. don't reset search_distance when we restart
> the search loop at pagino.  That means even for small trees (<
> search_distance * 2 records) we'll retry when we get to the end of
> tree, but we'll still break out of the loop and allocate new inodes
> as soon as we hit the search distance limit.
> 

Sounds reasonable, I'll try that and send a V2,

Thank you!!

-- 
--Carlos
