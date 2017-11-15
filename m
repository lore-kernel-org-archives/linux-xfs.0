Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:57614 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753581AbdKOTgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 14:36:00 -0500
Subject: Re: [RFC PATCH] iomap: report collisions between directio and
 buffered writes to userspace
References: <20171114214625.GB5119@magnolia>
 <8aa299eb-e1c4-6d8e-f536-bf764661e1b2@applied-asynchrony.com>
 <20171115185428.GF5119@magnolia>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <54bcf372-c8e5-5a83-819d-e56b272a98b2@applied-asynchrony.com>
Date: Wed, 15 Nov 2017 20:35:57 +0100
MIME-Version: 1.0
In-Reply-To: <20171115185428.GF5119@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 11/15/17 19:54, Darrick J. Wong wrote:
> On Wed, Nov 15, 2017 at 02:16:01PM +0100, Holger Hoffstätte wrote:
>> On 11/14/17 22:46, Darrick J. Wong wrote:
>> (snip)
>>> +static void iomap_warn_stale_pagecache(struct inode *inode)
>>> +{
>>> +	errseq_set(&inode->i_mapping->wb_err, -EIO);
>>> +	pr_crit_ratelimited("Stale pagecache contents after collision "
>>> +			    "between direct and buffered write!\n");
>>> +}
>>
>> In this form the error message is IMHO useless since it tells me
>> neither the file in question nor the misbehaving application.
>> "Something went wrong somewhere" is not actionable information
>> and in practice will only be ignored.
>>
>> Since you already have the inode in question at hand, print at least
>> the full path + filename so that it's clear where things are going
>> wrong. Usually that will let people deduce which application is
>> misbehaving.
> 
> The whole point of the errseq_set call in this patch is to record the
> write collision so that all the writers of this file will receive an EIO
> the next time they try to flush the file.  You can pinpoint exactly
> which fd(s) in which application(s) caused the problem.  The old dmesg
> spew only captured which program issued the dio write.

Then what is the use of printing the message? I'm not arguing against
handling the error, which is of course much better than silent corruption;
I'm asking what the point of the message is because it doesn't tell
anything actionable after the fact. If you really want to rely on
applications handling this condition (which I agree is the right thing
to do!) then there is simply no need for the message; if I found it in
the log one day, I'd have no idea what to do about it. That's all.

> (And the whole point of this patch is to see what people think about
> that change of behavior w.r.t. us no longer letting userspace silently
> corrupt the file...)

No argument there!

-h
