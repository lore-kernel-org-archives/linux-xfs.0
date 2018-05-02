Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:55335 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbeEBOTp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 10:19:45 -0400
Received: by mail-it0-f66.google.com with SMTP id 144-v6so17692844iti.5
        for <linux-xfs@vger.kernel.org>; Wed, 02 May 2018 07:19:45 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] sync discard
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <20180502124508.GD22857@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b219c171-1b28-d7ea-f5b9-c352da64cafb@kernel.dk>
Date: Wed, 2 May 2018 08:19:43 -0600
MIME-Version: 1.0
In-Reply-To: <20180502124508.GD22857@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On 5/2/18 6:45 AM, Christoph Hellwig wrote:
> On Mon, Apr 30, 2018 at 09:32:50AM -0600, Jens Axboe wrote:
>> We recently had a pretty severe perf regression with the XFS async
>> discard. This small series add a SYNC issue discard flag, and also
>> limits the chain size for sync discards. Patch 2 adds support for
>> reverting XFS back to doign sync discards.
> 
> Please explain the hardware and workload that you see this with.
> Also given that it is a hardware limitation a quirk limiting the
> size of discard requests and/or number of outstanding discards
> would be more useful than falling back to a broken mode of issueing
> block commands.

Honestly, from what I've seen in production, I can whitelist one
device and that one is no longer being produced. The rest is crap
in terms of latency impacting trim. A quirk or whitelist/blacklist
isn't going to be of any help.

-- 
Jens Axboe

