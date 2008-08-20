Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 23:05:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7K654pm022252
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 23:05:04 -0700
Message-ID: <48ABB602.5030404@sgi.com>
Date: Wed, 20 Aug 2008 16:13:22 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 981498 - Use xfs_idestroy() to cleanup an inode.
References: <20080820033302.AF92058C52A8@chook.melbourne.sgi.com> <20080820035642.GB6061@disturbed>
In-Reply-To: <20080820035642.GB6061@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com, markgw@sgi.com

This change was part of another patch that you reviewed.  This small
change got left out when I merged my changes in with your inode
allocation cleanup which you asked me to do.  I also had to modify
your original patch because it did not apply cleanly due other changes
that you made (the semaphore completion stuff).  I didn't have to take
your cleanup patch - I could have just fixed the bug.  So in amongst
your complaining I'll assume there is a covert "thanks for taking my
patch".


Dave Chinner wrote:
> On Wed, Aug 20, 2008 at 01:33:02PM +1000, Lachlan McIlroy wrote:
>> Use xfs_idestroy() to cleanup an inode.
> 
> I'm not sure what has been checked in this patch, even though it's
> recorded that I reviewed it. Yes, I reviewed the original patch, but
> I asked for changes to be made. I *haven't reviewed* what got
> checked in.
> 
> With the changelog being entirely useless - not even mentioning it
> fixes a memory leak or a deadlock - I have no idea what changes were
> made in response to my initial review.  I now have to wait for CVS
> or git to be updated before being able to find out what just got
> checked in so I can review it.
> 
> Lachlan (and for everyone else @ sgi), in future if someone in the
> community reviews a patch and asks for change, can you please repost
> the modified patches to close the review cycle before anything is
> checked in?
> 
> Cheers,
> 
> Dave.
