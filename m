Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Nov 2006 07:55:47 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA3FtdaG003056
	for <xfs@oss.sgi.com>; Fri, 3 Nov 2006 07:55:39 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 486F4D1BD465
	for <xfs@oss.sgi.com>; Fri,  3 Nov 2006 07:54:53 -0800 (PST)
Message-ID: <454B664B.6030701@sandeen.net>
Date: Fri, 03 Nov 2006 09:54:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mount failed after xfs_growfs beyond 16 TB
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <454A3B28.7010405@sandeen.net> <20061103093203.GA18010@pc51072.physik.uni-regensburg.de> <20061103123418.GP8394166@melbourne.sgi.com> <20061103154448.GA26647@pc51072.physik.uni-regensburg.de>
In-Reply-To: <20061103154448.GA26647@pc51072.physik.uni-regensburg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: christian.guggenberger@physik.uni-regensburg.de
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Christian Guggenberger wrote:
>> xfs_db mojo.... ;)
>>
>> Note - no guarantee this will work - practise on an expendable
>> sparse loopback filessytem image by making a filesystem of slightly less
>> than 16TB then growing it to corrupt it the same way and then fixing it up
>> successfully.
>>
>> Once it's corrupted, unmount and run xfs_db in expert mode.
>> The superblock:
>>
>> blocksize = 4096
>> dblocks = 18446744070056148512
>> ...
>> agblocks = 84976608
>> agcount = 570
>>
>> An AG is ~43.5GB, so 570 AGs is 24.8TB. It's to big, and
>> we will only shrink by whole AGs. Hence we have to correct
>> agcount and dblocks.
> 
> isn't the AG size 'agblocks * blocksize' == ~324 GB here ?
> 
> got further input on a secondray superblock form the colleague:
> looks more reasonable, I'd say. Is there a way to manually recover sb0
> from sb1 ?

you can copy it over field-by-field.... not sure if there's an easier way.

-Eric
