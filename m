Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51538 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751969AbcLTUR4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Dec 2016 15:17:56 -0500
Subject: Re: [PATCH 3/6] libxcmd: merge command() and iterate_command()
References: <20161216044115.21287-1-david@fromorbit.com>
 <20161216044115.21287-4-david@fromorbit.com>
 <20161220083119.GA12768@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <33d8976c-54d7-1a72-d768-778df7fcb4ee@sandeen.net>
Date: Tue, 20 Dec 2016 14:11:44 -0600
MIME-Version: 1.0
In-Reply-To: <20161220083119.GA12768@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 12/20/16 2:31 AM, Christoph Hellwig wrote:
> On Fri, Dec 16, 2016 at 03:41:12PM +1100, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Simplify the command loop further by merging the command loop
>> iteration checks with the command execution function. This removes
>> all visibility of command iteration from the main command execution
>> loop, and enables us to factor and clean up the command loop
>> processing neatly.
>>
>> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> 
> Looks fine, but some minor nitpicks below:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by, maybe?

> 
>> +static int
>> +process_input(
> 
> return bool instead of int (and switch done in the caller to bool as
> well)?

Everything below it is an int, fwiw, seems like a job for another day.

>> +	char	*input,
>> +	bool	iterate)
>>  {
>> -	int		c, i, j = 0, done = 0;
>> -	char		*input;
> 
> Align the arguments to the same row as the variables below it?

I'll fix that on merge.

Thanks,
-Eric

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
