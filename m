Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 17:20:34 -0700 (PDT)
Received: from donner.stsci.edu (donner.stsci.edu [130.167.251.65])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2G0KT6p003909
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 17:20:30 -0700
From: Thomas Walker <walker@stsci.edu>
Subject: Re: Should xfs_repair take this long?
Reply-To: walker@stsci.edu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070315202027.CNS24438@comet.stsci.edu>
Date: Thu, 15 Mar 2007 20:20:27 -0400 (EDT)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com


  Ok, here's the output of the command you wanted.  I ran it on both of the xfs file systems we have, both say bad superblock when trying to mount;

[root@hla-ags ~]# dd if=/dev/mapper/vg0-hladata3 bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x
000000

[root@hla-ags ~]# dd if=/dev/mapper/vg1-hladata2 bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x
000000

   [root@hla-ags ~]# mount /hladata2
mount: wrong fs type, bad option, bad superblock on /dev/vg0/hladata3,
       or too many mounted file systems

  Thomas Walker


---- Original message ----
>Date: Fri, 16 Mar 2007 10:10:31 +1100
>From: David Chinner <dgc@sgi.com>  
>Subject: Re: Should xfs_repair take this long?  
>To: Thomas Walker <walker@stsci.edu>
>Cc: Emmanuel Florac <eflorac@intellique.com>, xfs@oss.sgi.com
>
>On Thu, Mar 15, 2007 at 10:06:42AM -0400, Thomas Walker wrote:
>> 
>>     The terminal shows a lot of "." dots running across the screen 
>> quickly, and every few hours it says this;
>> 
>> 
>> .....................................................found candidate 
>> secondary superblock...
>> unable to verify superblock, continuing...
>> found candidate secondary superblock...
>> unable to verify superblock, continuing...
>
>The primary superblock is not good, and it's trying to find a valid
>secondary superblock. Doesn't sound promising so far - reapir can't
>start until a valid superblok is found....
>
>Can you dump the first sector of the device the fielsystem is
>on:
>
># dd if=/dev/mapper/vg0-hladata3 bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x
>
>So we can see if that really holds a primary XFS superblock?
>
>Cheers,
>
>Dave.
>-- 
>Dave Chinner
>Principal Engineer
>SGI Australian Software Group
