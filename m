Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35466 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751270AbdHXLr5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 07:47:57 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/6] Fiemap refactoring 
Date: Thu, 24 Aug 2017 14:47:46 +0300
Message-Id: <1503575272-28263-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Nikolay Borisov <nborisov@suse.com>

Hello, 

Here are a bunch of patches resulting from review feedback on my earlier 
attempts to implement ranged fiemap lookup. All but the last patch are simple 
cleanup, aimed at making the code mode understandable and maintainable. They 
bear no functional changes. 

The last patch is a bug fix (at least I percieve it as a bug) for the -n 
argument behavior. More explanation in the patch commit log. 

I decided it's more prudent to put those cleanups as separate series since I've
run out of juice working on that and will perhaps come back to the actual 
ranged support later, yet I'd like to see those merged. 

Nikolay Borisov (6):
  fiemap: Remove blocksize variable
  fiemap: Make max_extents a global var
  fiemap: Eliminate num_extents
  fiemap: De-obfuscate last_logical and cur_extent manipulation
  fiemap: Factor out common code used for printing holes
  fiemap: Fix semantics of max_extents (-n arguments)

 io/fiemap.c | 174 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 86 insertions(+), 88 deletions(-)

-- 
2.7.4

