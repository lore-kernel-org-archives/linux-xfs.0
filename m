Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 12:30:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2GJUZ6p027199
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 12:30:38 -0700
Message-ID: <45FAF061.8070800@sandeen.net>
Date: Fri, 16 Mar 2007 14:30:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Should xfs_repair take this long?
References: <20070315202027.CNS24438@comet.stsci.edu> <20070316013227.GO5743@melbourne.sgi.com> <45FA7C37.4070001@stsci.edu> <20070316192037.GZ5743@melbourne.sgi.com>
In-Reply-To: <20070316192037.GZ5743@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Thomas Walker <walker@stsci.edu>, xfs@oss.sgi.com

David Chinner wrote:
> On Fri, Mar 16, 2007 at 07:15:03AM -0400, Thomas Walker wrote:
>>    No problem.  The error was with the iflag=direct, apparently RHEL4 
>> doesn't like that option so I took it out.  Here's the output from each 
>> of the xfs volumes;
>>
>> [root@hla-ags ~]# dd if=/dev/mapper/vg0-hladata3 bs=512 count=1 | od -Ax -x
>> 1+0 records in
>> 1+0 records out
>> 000000 0000 6419 0000 0c00 0000 7419 0000 0c00
>> 000010 0000 8419 0000 0c00 0000 9419 0000 0c00
> 
> That's not a XFS superblock :(

lmdd pattern?

>> [root@hla-ags ~]# dd if=/dev/mapper/vg1-hladata2 bs=512 count=1 | od -Ax -x
>> 1+0 records in
>> 000000 7970 6f72 746f 203a 2030 0a2f 500a 414c
>> 000010 4e49 4b0a 3120 410a 560a 3120 0a34 6964
>> 000020 2072 2e31 2e30 3572 392f 3830 4b0a 3420
>> 000030 690a 746f 0a61 2056 3531 660a 6c69 2065
> 
> Neither is that - it's a bunch of text that doesn't
> make much sense to me....

[esandeen@neon ~]$ echo "pyroot" | hexdump
0000000 7970 6f72 746f 000a

python?

*shrug*
