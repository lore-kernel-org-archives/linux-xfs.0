Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4RHEl1B237370 for <xfs@oss.sgi.com>; Sun, 27 May 2012 12:14:47 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	paFTDjqKnzm3IUjH (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 27 May 2012 10:14:46 -0700 (PDT)
Received: by obbuo19 with SMTP id uo19so5100086obb.26
	for <xfs@oss.sgi.com>; Sun, 27 May 2012 10:14:45 -0700 (PDT)
Message-ID: <4FC26101.2050003@gmail.com>
Date: Sun, 27 May 2012 13:14:41 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
	<4FC18845.6030301@gmail.com> <4FC19408.5020502@sandeen.net>
	<CAAxjCEzX4dmm6YuR__1_a6mw+D=vizV0VrCLqCC-d5GSgkbE6g@mail.gmail.com>
	<1338124504.28212.255.camel@oxygen.netxsys.com>
	<5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com>
	<4FC25126.7070002@sandeen.net>
In-Reply-To: <4FC25126.7070002@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Stefan Ring <stefanrin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Krzysztof Adamski <k@adamski.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/27/2012 12:07 PM, Eric Sandeen wrote:
> On 5/27/12 9:59 AM, joe.landman@gmail.com wrote:
>> This is going to be a very fragmented file.  I am guessing that this
>> is the reason for the long duration delete.   I'll do some more
>> measurements before going to 3.4.x as per Eric's note.
>
> filefrag -v should also tell you how many fragments, and because it
> uses fiemap it probably won't run into the same problems.
>
> But it sounds like we can just assume very high fragmentation.
>

[root@siFlash test]# filefrag  1.r.48.0
1.r.48.0: 1364 extents found


> It's not addressing the exact issue, but why are the files so fragmented?
> Are they very hole-y or is it just an issue with how they are written?
> Perhaps preallocation would help you here?

Possibly.  We are testing the system using fio, and doing random reads 
and writes.  I'll see if we can do a preallocation scheme 
(before/during) for the files.

So to summarize, the delete performance will be (at least) in part a 
function of the fragmentation?  A directory full of massively fragmented 
files will take longer to delete than a directory of contiguous and 
larger extents?  And I did some experimentation using xfs_repair, and it 
seems to be the case there as well ... the higher level of 
fragmentation, the longer the repair seems to take.



>
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
