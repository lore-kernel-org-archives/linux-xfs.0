Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 09:25:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RGPfCf015095
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 09:25:42 -0700
Received: from drutsystem.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 057241488E06
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 09:25:40 -0700 (PDT)
Received: from drutsystem.com (drutsystem.com [80.72.38.138]) by cuda.sgi.com with ESMTP id HlJpZwgxtDNnIYAe for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 09:25:40 -0700 (PDT)
Message-ID: <4905E4B2.2010303@drutsystem.com>
Date: Mon, 27 Oct 2008 16:56:34 +0100
From: Michal Soltys <nozo@drutsystem.com>
MIME-Version: 1.0
Subject: Re: Map a disk LBA to filename?
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <4905C81B.50103@aei.mpg.de>
In-Reply-To: <4905C81B.50103@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: xfs@oss.sgi.com

Carsten Aulbert wrote:
> Michal Soltys wrote:
>> 
>> Wouldn't something like (under xfs_db) :
>> 
>> getblock -b #block -n
>> ncheck -i #inode
>> 
>> where required #inode is reported by getblock
>> 
>> do the thing ?
>> 
> 
> Sounds nice, but my (ancient? 2.8.11) version of xfs_db does not know
> getblock (only blockget) since that also matches the command line and
> the usage looks about to be right, I'm currently trying that one, e.g.
> 

Sorry, I meant blockget.

> smartctl reports a bad LBA at 36922326. fdisk tells me the partition
> starts at 31069773, hence the block under question is 5852553.
> 
> xfs_info tells be a bsize of 4096 which I take as the block size, thus
> the xfs block to look at should be 731569, right?
> 
> xfs_db> blockget -b 731569 -n
> setting block 0/731569 to free1
> setting block 0/731569 to free2
> xfs_db>
> 
> hmm, no inode number. Does that mean this block is not used by any file
> currently - which might be perfectly fine since this partition is only
> 31% full.
> 
> Everything right so far?
> 

Yes, calculations look fine. I'm not sure what exactly is the difference 
between free1 and free2 - someone more knowledgable would have to 
comment (and overally comment about this method).

In my case when I check block allocated by some file, I get results such as:

xfs_db> blockget -b 4584722 -n
setting block 0/4584722 to data
setting inode to 36231069 for block 0/4584722
inode 36231069 block 4584722 at offset 810
sb_fdblocks 1330583, aggregate AGF count 7983498
xfs_db> ncheck -i 36231069
    36231069 stuff/data/arst.dat

and further:

xfs_db> inode 36231069
xfs_db> bmap
data offset 0 startblock 4583912 (0/4583912) count 832 flag 0

Here the file lies in the first extent, taking 832*4096 blocks.
