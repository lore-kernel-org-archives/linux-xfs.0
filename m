Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 07:51:16 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8IEp3Zd011412
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 07:51:08 -0700
Received: from agami.com ([192.168.168.132])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8IEoP2c007361
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 07:50:25 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8IEoKbF013904
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 07:50:20 -0700
Message-ID: <450EB248.3000108@agami.com>
Date: Mon, 18 Sep 2006 20:20:48 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: swidth with mdadm and RAID6
References: <Pine.LNX.4.10.10609151652070.31539-100000@limpet.umeoce.maine.edu>
In-Reply-To: <Pine.LNX.4.10.10609151652070.31539-100000@limpet.umeoce.maine.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cousins@umit.maine.edu
Cc: xfs@oss.sgi.com

Can you list the output of
1. cat /proc/mdstat
2. the command to create 8+2 RAID6 with one spare ?
3. and output of following:
    xfs_db -r /dev/md*
    xfs_db> sb
    xfs_db> p

-shailendra

Steve Cousins wrote:
> I have a RAID6 array of 11 500 GB drives using mdadm.  There is one
> hot-spare so the number of data drives is 8.  I used mkfs.xfs with
> defaults to create the file system and it seemed to pick up the chunk size
> I used correctly (64K) but I think it got the swidth wrong.  Here is what
> xfs_info says:
> 
> ===========================================================================
> meta-data=/dev/md0               isize=256    agcount=32, agsize=30524160
> blks
>          =                       sectsz=4096  attr=0
> data     =                       bsize=4096   blocks=976772992, imaxpct=25
>          =                       sunit=16     swidth=144 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=4096  sunit=1 blks
> realtime =none                   extsz=589824 blocks=0, rtextents=0
> ===========================================================================
> 
> So, sunit*bsize=64K, but swidth=144 and swidth/sunit=9 so it looks like it
> thought there were 9 data drives instead of 8.  
> 
> Am I diagnosing this correctly?  Should I recreate the array and
> explicitly set sunit=16 and swidth=128?
> 
> Thanks for your help.
> 
> Steve
> ______________________________________________________________________
>  Steve Cousins, Ocean Modeling Group    Email: cousins@umit.maine.edu
>  Marine Sciences, 452 Aubert Hall       http://rocky.umeoce.maine.edu
>  Univ. of Maine, Orono, ME 04469        Phone: (207) 581-4302
> 
> 
