Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36245 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754878AbdDLQYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:24:22 -0400
Received: by mail-wm0-f44.google.com with SMTP id o81so91826255wmb.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2017 09:24:21 -0700 (PDT)
Subject: Re: filesystem dead, xfs_repair won't help
References: <9d2587d5-e1f1-e5bb-d276-bc6731b2fce8@scylladb.com>
 <20170411144906.39323b30@harpe.intellique.com>
 <68ab8fb6-1cfd-66de-d2f3-eab21796fb16@scylladb.com>
 <20170411181355.59c1ee1f@harpe.intellique.com>
 <02304e07-022e-0191-e62b-734b59a818fb@scylladb.com>
 <25551c0a-90e1-0b2a-ad8d-2b1e814b3b0a@sandeen.net>
 <20170412151520.GB6126@infradead.org>
 <f1bbc038-a9d6-76c4-2f40-52797c5cf9d4@sandeen.net>
 <20170412154534.GA1145@infradead.org>
 <5eb9533a-7c20-23a4-b5f7-9f7cd54e3996@scylladb.com>
 <20170412162022.GA8663@infradead.org>
 <dc48012a-7255-4435-4230-884ff9445440@sandeen.net>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <815d104f-b5c0-472d-6003-89da43c0c297@scylladb.com>
Date: Wed, 12 Apr 2017 19:24:12 +0300
MIME-Version: 1.0
In-Reply-To: <dc48012a-7255-4435-4230-884ff9445440@sandeen.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>
Cc: Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 04/12/2017 07:22 PM, Eric Sandeen wrote:
> On 4/12/17 11:20 AM, Christoph Hellwig wrote:
>> On Wed, Apr 12, 2017 at 07:15:40PM +0300, Avi Kivity wrote:
>>> This preserves the ability to do O_DIRECT reads at 512 byte granularity,
>>> yes?
>> No.
>>
>>> We make use of that (it's probably less important on NVMe; still why
>>> waste bandwidth needlessly).
>> In that case it would be the wrong thing for you.
> And it would be really interesting to see if the 512-byte DIOs you
> issue under ext4 might trigger the same problem in the firmware.

We only issue 512-byte reads, writes are always 4096-byte aligned (and 
usually 128k).

The disk that crashed was my /home; it did see some database loads, but 
not much.

>
> (This is all pure speculation, but that's all we've got) ;)
>
> -Eric

