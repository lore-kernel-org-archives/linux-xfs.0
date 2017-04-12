Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:33021 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753333AbdDLQWb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:22:31 -0400
Received: by mail-wr0-f178.google.com with SMTP id l28so20844212wre.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2017 09:22:30 -0700 (PDT)
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
From: Avi Kivity <avi@scylladb.com>
Message-ID: <08bec6a5-67cb-9185-e1e7-1e7d2223067f@scylladb.com>
Date: Wed, 12 Apr 2017 19:22:20 +0300
MIME-Version: 1.0
In-Reply-To: <20170412162022.GA8663@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org



On 04/12/2017 07:20 PM, Christoph Hellwig wrote:
> On Wed, Apr 12, 2017 at 07:15:40PM +0300, Avi Kivity wrote:
>> This preserves the ability to do O_DIRECT reads at 512 byte granularity,
>> yes?
> No.

:(

>
>> We make use of that (it's probably less important on NVMe; still why
>> waste bandwidth needlessly).
> In that case it would be the wrong thing for you.

Would it be under our control?
