Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QHoZU5246997 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 12:50:35 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AFfFa4O33Ttia14o for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 10:52:21 -0700 (PDT)
Message-ID: <508ACDD5.8060107@sandeen.net>
Date: Fri, 26 Oct 2012 12:52:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests 224: test aio hole-fill at 4g
References: <4B633F9A.8000404@sandeen.net> <508AC5DA.2080502@sgi.com>
In-Reply-To: <508AC5DA.2080502@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/26/12 12:18 PM, Rich Johnston wrote:
> On 01/29/2010 02:05 PM, Eric Sandeen wrote:
>> Testcase from Giel de Nijs <giel@vectorwise.com>
>> on linux-ext4 list, ""Possible ext4 data corruption
>> with large files and async I/O," on 29 Jan 2010
>>
>> ext4 put byte offsets in a block offset u32 container
>> in the endio struct, so 4g wrapped to 0 leading to
>> data corruption when the unwritten extent did not
>> get converted.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>
>> ---
> 
> Hey Eric
> 
> Just going through the list trying to clean it up.  Is this patch still valid or does one of the other hole tests cover this?

There was some question on the list about whether there should be a dedicated test program to do this, or an AIO addition to xfs_io - that probably needs some thought.  AFAIK xfs_io still doesn't know anything about AIO.

I doubt that this particular AIO testcase got covered anywhere else.

-Eric

> Regards
> --Rich
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
