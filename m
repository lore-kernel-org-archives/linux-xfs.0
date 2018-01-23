Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:39190 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbeAWO5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 09:57:07 -0500
Received: by mail-wm0-f48.google.com with SMTP id b21so2460846wme.4
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2018 06:57:07 -0800 (PST)
From: Avi Kivity <avi@scylladb.com>
Subject: xfs_extent_busy_flush vs. aio
Message-ID: <dde543cc-6641-c5ee-3385-520ef4ca821e@scylladb.com>
Date: Tue, 23 Jan 2018 16:57:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I'm seeing the equivalent[*] of xfs_extent_busy_flush() sleeping in my 
beautiful io_submit() calls.


Questions:

  - Is it correct that RWF_NOWAIT will not detect the condition that led 
to the log being forced?

  - If so, can it be fixed?

  - Can I do something to reduce the odds of this occurring? larger 
logs, more logs, flush more often, resurrect extinct species and 
sacrifice them to the xfs gods?

  - Can an xfs developer do something? For example, make it RWF_NOWAIT 
friendly (if the answer to the first question was "correct")


[*] equivalent, because I'm actually looking at an older kernel that 
lacks this function. But I'm moderately confident that the xfs_log_force 
I'm seeing was transformed into xfs_extent_busy_flush by 
ebf55872616c7d4754db5a318591a72a8d5e6896

