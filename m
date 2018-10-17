Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:44669 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbeJQSuL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 14:50:11 -0400
Received: by mail-wr1-f52.google.com with SMTP id 63-v6so29093202wra.11
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 03:55:01 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
From: Avi Kivity <avi@scylladb.com>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181017084716.GL16896@infradead.org>
 <d23ce960-0077-0446-e4dc-875a11b4d29f@scylladb.com>
Message-ID: <8058bc1e-e3e6-9bd8-ead3-95d804bae1b0@scylladb.com>
Date: Wed, 17 Oct 2018 13:54:58 +0300
MIME-Version: 1.0
In-Reply-To: <d23ce960-0077-0446-e4dc-875a11b4d29f@scylladb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org


On 17/10/2018 11.57, Avi Kivity wrote:
>
>>   - even once we drop the inode the space only becomes available once
>>     the transaction has committed.  We do force the log if we found
>>     a busy extent, but there might be some issues.  Try seeing if you
>>     hit the xfs_extent_busy_force trace point with your workload.
>
>
> I'll ask permission to check this and report.
>
>


An hour's tracing yielded zero hits. Of course, that says nothing about 
other times, I'll continue to trace.
