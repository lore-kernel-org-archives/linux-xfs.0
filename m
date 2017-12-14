Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:46759 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753703AbdLNRii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 12:38:38 -0500
Received: by mail-wm0-f52.google.com with SMTP id r78so12906991wme.5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2017 09:38:38 -0800 (PST)
From: Avi Kivity <avi@scylladb.com>
Subject: Detecting RWF_NOWAIT support
Message-ID: <b45afd09-5fa8-74ac-4ba4-9dc9074e30cf@scylladb.com>
Date: Thu, 14 Dec 2017 19:38:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

I'm looking to add support for RWF_NOWAIT within a linux-aio iocb. 
Naturally, I need to detect at runtime whether the kernel support 
RWF_NOWAIT or not.


The only method I could find was to issue an I/O with RWF_NOWAIT set, 
and look for errors. This is somewhat less than perfect:

  - from the error, I can't tell whether RWF_NOWAIT was the problem, or 
something else. If I enable a number of new features, I have to run 
through all combinations to figure out which ones are supported and 
which are not.

  - RWF_NOWAIT support is per-filesystem, so I can't just remember not 
to enable RWF_NOWAIT globally, I have to track it per file.


Did I miss another method of detecting RWF_NOWAIT?

