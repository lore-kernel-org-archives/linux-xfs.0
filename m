Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:45155 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751779AbdITGOS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 02:14:18 -0400
Received: by mail-wr0-f177.google.com with SMTP id m18so1212255wrm.2
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 23:14:17 -0700 (PDT)
Subject: Re: io_submit() blocks for writes for substantial amount of time
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <20170919145827.GA21523@infradead.org>
 <04cb3ee7-e7d5-6bba-6adb-8ac1c28e68dc@scylladb.com>
 <20170919203403.GA731@infradead.org>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <89e89ce9-0182-0fdf-2872-8860054acfaa@scylladb.com>
Date: Wed, 20 Sep 2017 09:14:13 +0300
MIME-Version: 1.0
In-Reply-To: <20170919203403.GA731@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Tomasz Grabiec <tgrabiec@scylladb.com>, linux-xfs@vger.kernel.org

On 09/19/2017 11:34 PM, Christoph Hellwig wrote:
> On Tue, Sep 19, 2017 at 07:31:04PM +0300, Avi Kivity wrote:
>> For DIO, does it really need the mm_struct? It can just pin the pages and
>> pass them to the workqueue function.
> We can't pin all the pages for a huge I/O at the same time.

Is it not legal to perform a short write?
