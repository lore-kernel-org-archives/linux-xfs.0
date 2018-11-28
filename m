Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54384 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728201AbeK1Xnp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 18:43:45 -0500
Subject: Re: [PATCH v1 5/7] xfs: Add device retry
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <1543376991-5764-6-git-send-email-allison.henderson@oracle.com>
 <20181128050850.GJ6311@dastard> <20181128073520.GA7084@infradead.org>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <f30fd190-28e5-938a-1cb9-3690559a60f0@oracle.com>
Date: Wed, 28 Nov 2018 20:41:40 +0800
MIME-Version: 1.0
In-Reply-To: <20181128073520.GA7084@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com

On 11/28/18 3:35 PM, Christoph Hellwig wrote:
> On Wed, Nov 28, 2018 at 04:08:50PM +1100, Dave Chinner wrote:
>> So the first time through this loop the block layer devices what
>> device to read from, then we iterate devices 1..n on error.
>>
>> Whihc means if device 0 is the only one with good information in it,
>> we may not ever actually read from it.
>>
>> I'd suggest that a hint of "-1" (or equivalent max value) should be
>> used for "device selects mirror leg" rather than 0, so we can
>> actually read from the first device on command.
> 
> Yes.  For one thing I think we really need to split this retry counter
> of sorts from the write hints.  I.e. make both u8 types and keep them
> separate.  Then start out with (u8)-1 as initialized by the block layer
> for the first attempt.  The device then fills out which leg it used
> (in the completion path, so that another underlying driver doesn't
> override it!), and then the file system just preserves this value on
> a resumit, leaving the driver to chose a new value when it gets a
> non -1 value.
> 

Will update as suggested, thank you for all your feedback :)

-Bob
