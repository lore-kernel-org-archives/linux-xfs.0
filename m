Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33631 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdHCOwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 10:52:51 -0400
Received: by mail-wr0-f177.google.com with SMTP id v105so6743726wrb.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Aug 2017 07:52:50 -0700 (PDT)
From: Avi Kivity <avi@scylladb.com>
Subject: Intermittent zeroed pages with AIO+DIO+XFS
Message-ID: <dac170a5-d11f-c8ce-3890-8b5629364c18@scylladb.com>
Date: Thu, 3 Aug 2017 17:52:45 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Glauber Costa <glauber@scylladb.com>, Raphael Carvalho <raphaelsc@scylladb.com>

Hello,


I have an application that uses AIO+DIO to write data to a file on XFS. 
The writes use 128k buffers. Very rarely, I see aligned 4k blocks within 
the file that are zeroed. The blocks are not aligned to 128k boundary, 
just 4k. The buffers are allocated in anonymous memory, which is usually 
using transparent hugepages.  The files are fully allocated, not sparse 
(checked post-mortem).


The writes are concurrent and adjacent. To avoid serialization, we 
ftruncate() the file to a larger size, then ftruncate() it back when we 
know its final size.


Does this trigger anything in anyone's mind?



