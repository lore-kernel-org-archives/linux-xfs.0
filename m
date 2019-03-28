Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:47076 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfC1PHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Mar 2019 11:07:06 -0400
Received: by mail-io1-f68.google.com with SMTP id b9so17478971iot.13
        for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2019 08:07:05 -0700 (PDT)
Subject: Re: [PATCH] block: clarify that bio_add_page() and related helpers
 can add multi pages
References: <20190328035001.26276-1-ming.lei@redhat.com>
 <5258cad3-b324-660f-589f-73eb7fb8fa04@kernel.dk>
 <20190328150320.GB9265@infradead.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8e53a36f-2b73-55bf-e404-52cfa0192981@kernel.dk>
Date: Thu, 28 Mar 2019 09:07:03 -0600
MIME-Version: 1.0
In-Reply-To: <20190328150320.GB9265@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 3/28/19 9:03 AM, Christoph Hellwig wrote:
> On Thu, Mar 28, 2019 at 08:21:55AM -0600, Jens Axboe wrote:
>> This is going to create a needless conflict between 5.1 and the 5.2
>> block tree. I haven't pushed the 5.2 tree out yet, plan to do so
>> this week after I've pushed the current 5.1 patches. Can you respin
>> this one on top of for-5.2/block when it comes out?
> 
> Can we also drop the parameter name rename and just add the comments?

Yeah, that might be better to avoid needless churn.

-- 
Jens Axboe
