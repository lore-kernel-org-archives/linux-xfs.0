Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BE707FAC
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 16:15:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 181548F8033
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 14:15:40 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id oQO7DdzPfD8tHWeL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 14:15:39 -0700 (PDT)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 21 Aug 2013 15:15:38 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 1A4BCC40005
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 15:10:05 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7LLFMAM025516 for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 15:15:28 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r7LLFLq3003786
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 15:15:21 -0600
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130821181919.GA21378@infradead.org>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
	<20130821064357.GA8822@infradead.org>	<20130821130152.GA9709@quack.suse.cz>
	<20130821181247.GL5262@sgi.com> <20130821181919.GA21378@infradead.org>
Date: Wed, 21 Aug 2013 14:15:20 -0700
Message-ID: <1377119720.17321.6.camel@chandra-laptop.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Abhijith Das <adas@redhat.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>

Chrishtoph,

After we figured that there are ABI/API issues with adding pquota
information to the end (while using the same command), I posted what you
are suggesting now
(http://oss.sgi.com/archives/xfs/2013-07/msg00212.html) as I also do not
like redundant code. Please see Dave's comment at the link above in
which he wanted me to change the code so that the two commands are
totally independent. There was no objections to Dave's suggestion, so I
made the changes as he suggested.

On Wed, 2013-08-21 at 11:19 -0700, Christoph Hellwig wrote: 
> On Wed, Aug 21, 2013e at 01:12:47PM -0500, Ben Myers wrote:
> > So you don't like the addition of .get_xstatev in quotactl_ops, and
> > fs_quota_stat would need to match with fs_quota_statv, adding the project quota
> > to the end of the structure?
> 
> That was what I had in mind initially, before the additional
> complication were pointed out, except that we don't need it to look
> exactly the same - if we use put_user calls instead of copy_to_user that
> layout doesn't have to be the same.
> 
> However it seems like going down the stat route and having a kquota_info
> structure might be the better way to fully separate the in-kernel API
> from the userspace ABI.
> 
> > >   Well, the trouble is with gquota vs pquota - previously we report in
> > > qs_gquota field either group quotas or project quotas depending on what is
> > > turned on. Generic quota code doesn't know this so xfs get_xstatev() would
> > > have to recognize whether it is being called from the old Q_XGETSTAT
> > > quotactl or from the new Q_XGETSTATV quotactl to know where to fill in
> > > project quotas. And at that point you somewhat loose the elegancy of using
> > > one interface - we could set qs_version to some special value so that
> > > .get_xstatev() recognizes this and does the magic but that doesn't seem very
> > > different from the extra call...
> > 
> > IIUC to make this happen without the addition of .get_xstate in quotactl_ops,
> > .get_xstate could also grow an argument to determine whether it was called as
> > Q_XGETSTAT vs Q_XGETSTATV.  If called as Q_XGETSTATV it can look at qs_version
> > to determine how much to copy.  That might be a bit cleaner than the qs_version
> > magic number, as long as you don't mind changing the .get_xstate interface.
> 
> I don't think we'd need that argument - the fs would always fill out
> both fields, then the implementation of Q_XGETSTAT would:
> 
>  (1) fail if both group and project quota information is present

There was a discussion on this issue and it was decided to provide back
only gquota information when both quotas are present and Q_XGETSTAT
command was used (instead of failing, which will break API)

> (2) export the pquota fields as gqouta if only project quota is present
> 
> > Anyway, please give a shout if I need to revert this.  I believe the commit
> > raced with the commentary.  ;)
> 
> As this is in-kernel only I don't think we need to revert anything, but
> it would be nice to fix it before 3.12 is released.  I didn't exactly
> race either, your reply to Jan made me look a it a bit more.
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
