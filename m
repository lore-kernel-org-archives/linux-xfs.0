Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:32881 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754724AbcKESOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Nov 2016 14:14:18 -0400
Received: by mail-wm0-f53.google.com with SMTP id c184so18635979wmd.0
        for <linux-xfs@vger.kernel.org>; Sat, 05 Nov 2016 11:14:18 -0700 (PDT)
Subject: Re: [PATCH 4/5] iomap: implement direct I/O
References: <1478276479-10749-1-git-send-email-hch@lst.de>
 <1478276479-10749-5-git-send-email-hch@lst.de>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <2dabe3ec-193b-3ecf-af5c-a5ba976de6eb@scylladb.com>
Date: Sat, 5 Nov 2016 20:14:14 +0200
MIME-Version: 1.0
In-Reply-To: <1478276479-10749-5-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

Hello,


On 11/04/2016 06:21 PM, Christoph Hellwig wrote:
> This adds a full fledget direct I/O implementation using the iomap
> interface. Full fledged in this case means all features are supported:
> AIO, vectored I/O, any iov_iter type including kernel pointers, bvecs
> and pipes, support for hole filling and async apending writes.

Does this include support for more than one concurrent appending write 
for the same file?

If so, that's great, but please make this feature discoverable. Right 
now applications have to benchmark or guess how fully asynchronous the 
aio implementation is.

