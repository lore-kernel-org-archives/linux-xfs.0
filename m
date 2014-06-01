Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B98387F54
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 17:48:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A4E4C8F8037
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 15:48:29 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	iMrC6G9RAhjLlxws for <xfs@oss.sgi.com>;
	Sun, 01 Jun 2014 15:48:27 -0700 (PDT)
Date: Mon, 2 Jun 2014 08:48:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: What to do when... xfs_repair hangs?
Message-ID: <20140601224825.GP14410@dastard>
References: <CAA43vkVzWRTqNQh2VSi5yvFLtstmVOKRJUnYw_ZSkYJGsex8Uw@mail.gmail.com>
	<20140531000117.GM6677@dastard>
	<CAA43vkUBF3q-F6XYTPTVx43KXg_3_COgaK8wtHxRynshOT9smg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA43vkUBF3q-F6XYTPTVx43KXg_3_COgaK8wtHxRynshOT9smg@mail.gmail.com>
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
To: Sean Caron <scaron@umich.edu>
Cc: xfs@oss.sgi.com

On Sun, Jun 01, 2014 at 12:21:55PM -0400, Sean Caron wrote:
> Sorry, all, I was a little out-of-it on Friday afternoon, of course I had
> kicked off xfs_repair actually in the background with all output sent to a
> file, and I was just doing 'tail -f' on that file.
> 
> So I kill the 'tail -f' and jump back to the command line, it appears that
> xfs_repair segfaulted and died.
> 
> That line of text:
> 
> disconnected inode 1109099673,
> 
> was indeed the last thing that it printed before it crashed.
> 
> If I look in dmesg, I just see -
> 
> xfs_repair[6770]: segfault at 28 ip 000000000042307b sp 00007fffef61bad0
> error 4 in xfs_repair[400000+72000]
> 
> and that's it.
> 
> I checked with 'df' and there's plenty of space everywhere; I don't see why
> it would have faulted out trying to connect something to lost+found.
> 
> Underlying storage should be good; this is basically a RAID 60 built on top
> of a bunch of JBODs with LSI SAS9200 cards. MD sees all strings as started
> and running OK; no problems getting the array assembled at all.
> 
> Since Dave is saying it's OK to try re-running xfs_repair; it'll just pick
> up where it left off; let me give it another pass and see if it manages to
> complete, or if it segfaults out again. I guess it it poops out a second
> time, maybe we'll just want to consider rebuilding the filesystem and
> restoring from our copies?

You should update to the latest version of xfs_repair first (3.2.0).
If that still crashes, running xfs-repair under gdb to get a stack
trace would be a good start, or sending me a metadump image so I can
reproduce the crash myself would be even better...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
