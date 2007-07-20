Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 18:26:53 -0700 (PDT)
Received: from bycast.com (bycast.com [209.139.229.1])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K1Qlbm023695
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 18:26:49 -0700
Received: from [192.168.110.101] (account mmontour HELO [192.168.110.101])
  by bycast.com (CommuniGate Pro SMTP 4.3.9)
  with ESMTPA id 2074447 for xfs@oss.sgi.com; Thu, 19 Jul 2007 18:26:49 -0700
Message-ID: <46A00F58.60808@bycast.com>
Date: Thu, 19 Jul 2007 18:26:48 -0700
From: Mike Montour <mmontour@bycast.com>
MIME-Version: 1.0
Subject: Re: Allocating inodes from a single block
References: <469D0666.6040908@agami.com> <20070717201921.GA26309@tuatara.stupidest.org> <469D7035.2020507@sandeen.net> <1184724090.15488.553.camel@edge.yarra.acx> <20070718035012.GA12413810@sgi.com> <469E65AF.4080003@bycast.com> <20070719023005.GB12413810@sgi.com>
In-Reply-To: <20070719023005.GB12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

David Chinner wrote:
>> What would it take to add an option to mkfs.xfs (or to create a
>> dedicated tool) that would efficiently[1] pre-allocate a specified
>> number of inode chunks when a filesystem is created?
>>     
>
> Like an extension to mkfs.xfs's prototype file?
>   
I guess it could go there, e.g. the "number of inodes" parameter on line
2 of the prototype file (which is currently "merely for backward
compatibility"). Another possibility would be a "-i minpct=N" parameter
to mkfs.xfs, i.e. reserve N percent of the space on the disk for inodes,
and after that's full then allocate more chunks dynamically until the
"maxpct" limit is reached.

Ideally this pre-allocation would be able to reserve space for the inode
chunks without actually having to write to all of those disk blocks
(e.g. to be able to dedicate 25% of a 2 TB device to 1024-byte inodes
without having to write 500 GB of data to the device). I am not familiar
enough with the XFS data structures to know whether this would be an
easy or a hard thing to do.

>> This filesystem was created with "-i maxpct=0,size=2048", so a new chunk
>> of 64 inodes would require an extent of 128 KiB (32 * 4KiB blocks).
>>     
>
> i.e. worst case.
>   
Yes, although in this case the "maxpct" didn't matter because less than
25% of the disk was being used for inodes when the problem was
encountered. It is likely to occur with smaller inodes, but it can still
happen.
