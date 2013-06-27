Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 214287F52
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 10:58:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02329304051
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 08:58:10 -0700 (PDT)
Received: from mail-gh0-f180.google.com (mail-gh0-f180.google.com
	[209.85.160.180]) by cuda.sgi.com with ESMTP id
	p6RaHGZXx1suI6XX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 08:58:10 -0700 (PDT)
Received: by mail-gh0-f180.google.com with SMTP id f18so364906ghb.11
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 08:58:09 -0700 (PDT)
Subject: Re: sizing log - is there a too big?
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <20130627014810.GA29790@dastard>
Date: Thu, 27 Jun 2013 08:58:06 -0700
Message-Id: <73A9FC1C-854D-4C23-B560-FEEF64A3001B@gmail.com>
References: <55C24454-59E9-4285-9A4C-C4BD24EDBEEC@gmail.com>
	<20130627014810.GA29790@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On Jun 26, 2013, at 6:48 PM, Dave Chinner wrote:

> On Wed, Jun 26, 2013 at 04:56:31PM -0700, aurfalien wrote:
>> Hi all,
>> 
>> Wondering if my log being just under 2GB is a bad idea.
>> 
>> Noticing flush-253:2/kcopyd which is my XFS file system getting
>> really high load avg and wait times via top).
> 
> What has the log size got to do with something that is happening at
> the block layer? What's your storage config?
> 
>> Doing a simple rsync over NFS and after a bit, the system gets to a load of 24.... yikes...
> 
> Let me guess - 24 nfsds blocked waiting for kcopyd to do it's stuff?
> 
> Load average going up when the NFS server is busy generally means
> your IO subsystem is heavily loaded - it's not uncommon to see large
> NFS servers that are extremely busy sustain load averages over a
> 100 (or even 1000) for hours/days on end....
> 
>> Upon killing the rsync, I am seeing loads going down to sub 1
>> after about 10 min.  I have repeated this to verify 10 min.
> 
> Sure. Processes blocked on IO contribute to the load average. Kill
> the IO load, and the load average will return to nothing in 10-15
> minutes.


Not so fast my fine feathered friend.

Same work load, same hardware.

Only diff is;

External log, its 2GB
And its Centos 6.4 which was previously 5.9.
Its 16 drives in a hw raid 6, but 2 are for the mirrored journal and 1 for hot spare so 13 spindles.  Before it was 14 spindles in raid 6 and 2 hot spare.

I did power cycle it late last night and will more closely observe today.

Very odd.

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
