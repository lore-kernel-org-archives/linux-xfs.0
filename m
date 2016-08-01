Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38A3C7D13
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 07:00:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 914B8AC002
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 05:00:13 -0700 (PDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com
	[74.125.82.54]) by cuda.sgi.com with ESMTP id 4OHT5Z0ESmlQMrxb
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Aug 2016 05:00:11 -0700 (PDT)
Received: by mail-wm0-f54.google.com with SMTP id i5so240748464wmg.0
	for <xfs@oss.sgi.com>; Mon, 01 Aug 2016 05:00:11 -0700 (PDT)
Message-ID: <57CF7681619F42CCB4C0CF589E9686E5@dinulap>
From: "Lista Unx" <lista.unx@gmail.com>
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
	<20160729233524.GD16044@dastard>
Subject: Re: partition 100% full No space left on device. looks like xfs
	iscorrupted or a bug
Date: Mon, 1 Aug 2016 15:00:08 +0300
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Lista Unx" <lista.unx@gmail.com>
Cc: <xfs@oss.sgi.com>
Sent: Saturday, July 30, 2016 2:35 AM
Subject: Re: partition 100% full No space left on device. looks like xfs 
iscorrupted or a bug


> Ok, so you followed my advice on why you couldn't post to the list,

Yes, I've created a new gmail account especially to be able to post to this 
mailing list which is filtering very seriously legit messages comming from 
legit usres, just because they are comming from yahoo accounts (servers) ... 
but is allowing ANYONE else to post here WITHOUT having valid subscription 
and also WITHOUT any minimal intention to post here something which has or 
is related to XFS. Just in last days, I was informed about new microwave 
acquisition, plastic delivery, or any other craps arriving here from a 
"trusted and very legit" source, like gmail. That's sound like really a very 
good job!

> but you ignored my answer as to the cause of the changing numbers of
> inodes. I'll repeat it here for the benefit of everyone, so they
> don't waste time chasing ghosts.

No, not at all, is not my style. Just mentioned twice to you, that we are 
not talking about number of inode usage. we are talking about max number of 
inodes which differ with at least 10 times less, for partitions with THE 
SAME SIZE AND USAGE!

> That is, inodes are dynamically allocated so the number of supported
> inodes is directly proportional to the amount of free space left in
> the filesystem. You have filesystems with different amounts

NO! Booth systems are almost identical (minor differencies) and this has 
been stated very clear on my first post. That's not necessary to comment 
each line in my post, just to point us in the right direction.

> That's probably because there are open but unlinked files present in
> the filesystem, and du will not find them. e.g. large O_TMPFILE
> files, or files that applications are using as scratch space. You
> may even have zombie processes hanging about holding unlinked files
> open.

Has been mentioned on my first post, reboot does not solve problem, there 
are no (large, small or any kind of files) exahusting inodes!

>
> lsof might find those files, it might not. There might also be
> orphan inodes on the unlinked lists, and without an unclean shutdown
> log recovery won't process them.

Yes, also mentioned on my first post, lsof does not show anomalies ...

> So it may simply be best to run
> sync, then press the reset button to do a hard restart which
> will trigger log recovery on restart.

The same, mentioned on my first post, reboot (which will clean zombies) does 
not resolve issue.

> If the problem still persists,
> then xfs_repair is really the only option to find out where the
> space has gone and recover it.

Yes, that was also my conclusion BEFORE to post here. I did not have (yet) 
possibility to put / partition offline (or to not be mounted in order to run 
xfs_repair) and that's I asked here, considering that someone in the past 
encountered a simillar problem or in case not, there are few other things to 
be done, in order to consider that the last step to follow is to put server 
down for deep investigation.

I am still waiting approval to put server down for deep investigations 
(xfs_repaid & friends).

Have a nice day,
Alex 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
