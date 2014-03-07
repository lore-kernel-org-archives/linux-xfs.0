Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF3607F5A
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 17:09:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ACA37304043
	for <xfs@oss.sgi.com>; Fri,  7 Mar 2014 15:09:20 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	k3W83ELTpX15N3mD for <xfs@oss.sgi.com>;
	Fri, 07 Mar 2014 15:09:18 -0800 (PST)
Date: Sat, 8 Mar 2014 10:09:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hello, I have a question about XFS File System
Message-ID: <20140307230915.GS6851@dastard>
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
	<5318DB01.2040102@hardwarefreak.com>
	<279D0A265E5D4AF5B099BFAD4E8B1700@gmail.com>
	<531A4600.7050906@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531A4600.7050906@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Yongmin <dev.yongmin@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Mar 07, 2014 at 04:19:44PM -0600, Stan Hoeppner wrote:
> Please reply to the mailing list as well as the individual.
> 
> Note that you stated:
> 
> '...the concentrated part of mine is "Deleted File Recovery"'
> 
> On 3/6/2014 10:02 PM, Yongmin wrote:
> > 
> > Yes! there are no actual file data in journaling part.
> > 
> > BUT, by analyzing journaling part, we can get a Inode Core Information which was deleted.
> > In Inode Core, there are many information about the actual data, i.e. start address, file length etc.
> 
> Analyzing the journal code may inform you about structures, but it won't
> inform you about on disk locations of the structures and how to find
> them.  If a file has been deleted, no information about that is going to
> exist in the journal for more than a few seconds before the transaction
> is committed and the entry removed from the journal.

Well, we don't actually "remove" information from the log. We update
pointers that indicate what the active region is, but we never
physically "remove" anything from it. IOWs, the information is in
the journal until it wraps around and is over written by new
checkpoints....

> > By using those information, Recovering delete file can be done.
> > 
> > So the analysis of Journaling part is absolutely needed.  
> 
> I disagree.  Again, the journal log is unrelated to "deleted file
> recovery" in a forensics scenario.
> 
> I think Dave and Jeff both missed the fact that you're interested only
> in deleted file recovery, not in learning how the journal works for the
> sake of learning how the journal works.

Oh, no, I saw it and didn't think it was worth commenting on. I
think it's a brain-dead concept trying to do undelete in the
filesystem. "recoverable delete" was a problem solved 30 years ago -
it's commonly known as a trash bin and you do it in userspace with a
wrapper around unlink that calls rename(2) instead. And then "empty
trashbin" is what does the unlink and permanently deletes the files.

Besides, from a conceptual point of view after-the-fact filesystem
based undelete is fundamentally flawed. i.e.  the journal is a
write-ahead logging journal and so can only be used to roll the
filesystem state forwardi in time. Undelete requires having state
and data in the journal that allows the filesystem to be rolled
*backwards in time*. XFS simply does not record such information in
the log and so parsing the log to "undelete files by transaction
rollback" just doesn't work.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
