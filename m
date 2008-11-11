Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Nov 2008 15:23:05 -0800 (PST)
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mABNMw1e026033
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 15:22:58 -0800
Message-ID: <491A13CA.6010404@sgi.com>
Date: Wed, 12 Nov 2008 10:22:50 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: review: xfstests/192 atime test
References: <49192204.3040300@sgi.com> <20081111223810.GK2373@disturbed>
In-Reply-To: <20081111223810.GK2373@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Nov 11, 2008 at 05:11:16PM +1100, Timothy Shimmin wrote:
>> Attached simple atime test.
>> 192.out and group file would be added appropriately.
>> Thanks.
>> --Tim
> 
>> _supported_fs xfs udf nfs
>> _supported_os Linux
>> delay=150
> 
> 150s sleep? It only needs a few seconds for this test.
> 
Not for me. Passed every time at a few secs,
that is why I tried longer as was originally reported.

>> time3=`_access_time $testfile | tee -a $seq.full`
>>
>> delta1=`expr $time2 - $time1`
>> delta2=`expr $time3 - $time1`
>>
>> echo "delta1 - access time after sleep in-core: $delta1"
>> echo "delta2 - access time after sleep on-disk: $delta2"
> 
> Why bother with deltas? if the numbers are the same, just output
> "same", if they are different, output "different"....
> 
Fine, will do.

> FWIW, is there a patch being proposed that fixes this problem?
> 
I lost the thread with people to'ing and fro'ing ;-)
I'd have to relook at the last emails.

--Tim
