Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Aug 2007 13:24:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7SKOm4p020447
	for <xfs@oss.sgi.com>; Tue, 28 Aug 2007 13:24:50 -0700
Message-ID: <46D48487.9080205@sandeen.net>
Date: Tue, 28 Aug 2007 15:24:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] refactor xfs_mountfs for clarity & stack savings
References: <46D37A82.2080608@sandeen.net> <20070828195221.GA7237@infradead.org>
In-Reply-To: <20070828195221.GA7237@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> Looks goo to me except for a tiny nitpick:
> 
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net
>> +		if ((error = xfs_readsb(mp, mfsi_flags))) {
>> +			return error;
>> +		}
> 
>> +	if ((error = xfs_update_alignment(mp, mfsi_flags, &update_flags)))
>> +		goto error1;
> 
>> +	if ((error = xfs_check_sizes(mp, mfsi_flags)))
>> +		goto error1;
> 
>>  	if ((error = xfs_rtmount_init(mp))) {
> 
> Please make sure the assignment and conditional are on separate lines
> for all of these once you're cleaning up this function.  In the first
> case there's also some braces to remove.
> 

yeah, good point.  That was just cut & pasting what was already there...

-Eric
