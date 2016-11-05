Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35515 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755032AbcKESSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Nov 2016 14:18:08 -0400
Received: by mail-wm0-f43.google.com with SMTP id a197so108982857wmd.0
        for <linux-xfs@vger.kernel.org>; Sat, 05 Nov 2016 11:18:08 -0700 (PDT)
Subject: Re: discard improvements
References: <1476735753-5861-1-git-send-email-hch@lst.de>
 <64a1c5dc-4a36-1ef6-606e-b382d36161ef@scylladb.com>
 <20161031151412.GA14804@lst.de>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <5a50a07c-369d-1a41-2111-f9ee91ac7425@scylladb.com>
Date: Sat, 5 Nov 2016 20:18:05 +0200
MIME-Version: 1.0
In-Reply-To: <20161031151412.GA14804@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, michaelcallahan@fb.com

On 10/31/2016 05:14 PM, Christoph Hellwig wrote:
> On Fri, Oct 28, 2016 at 01:11:55PM +0300, Avi Kivity wrote:
>> With these patches, is it reasonable to run with discard enabled, or is
>> more work needed?
> As usual the answer is: it depends.  With the high-end NVMe devices
> I've been testing with you absolutely should enable discard.  With
> SAS SSDs the same is probably true.  I haven't done much testing with
> SATA SSDs but I'd be more cautious there, especially as very few seem
> to support queued TRIM yet.

Thanks.

The big problem with "it depends" is that usually the information it 
depends on is not available, so the application has to rely on a human 
to guess correctly.  With the trend for machines to be managed by 
machines, it's really hard to get optimal performance.  So exposure of 
any information that can help to make a decision, including that the 
kernel can make good use of TRIM, will be very helpful.
