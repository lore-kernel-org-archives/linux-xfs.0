Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:34301 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdDLQPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:15:45 -0400
Received: by mail-wr0-f177.google.com with SMTP id z109so20736146wrb.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2017 09:15:44 -0700 (PDT)
Subject: Re: filesystem dead, xfs_repair won't help
References: <13452866-4e5e-371c-269b-cee60e0c6b59@scylladb.com>
 <20170411140007.05af2bcd@harpe.intellique.com>
 <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
 <20170411144906.39323b30@harpe.intellique.com>
 <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
 <20170411181355.59c1ee1f@harpe.intellique.com>
 <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
 <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
 <20170412151520.GB6126@infradead.org>
 <f1bbc038-a9d6-76c4-2f40-52797c5cf9d4@sandeen.net>
 <20170412154534.GA1145@infradead.org>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <5eb9533a-7c20-23a4-b5f7-9f7cd54e3996@scylladb.com>
Date: Wed, 12 Apr 2017 19:15:40 +0300
MIME-Version: 1.0
In-Reply-To: <20170412154534.GA1145@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On 04/12/2017 06:45 PM, Christoph Hellwig wrote:
> On Wed, Apr 12, 2017 at 10:34:47AM -0500, Eric Sandeen wrote:
>> Is it safe to do that on a device that /actually/ has only 512 sectors?
> Except for NVMe none of the storage standards actually guarantees
> sector atomicy, although the whole storage stack traditionally relies on
> it..
>
> Maybe we should claim a 4k physical block size for NVMe devices that
> hab 512 byte LBAs and a "Atomic Write Unit Power Fail" setting of at
> least 8 so that the mkfs sector size logic triggers..

This preserves the ability to do O_DIRECT reads at 512 byte granularity, 
yes?  We make use of that (it's probably less important on NVMe; still 
why waste bandwidth needlessly).

