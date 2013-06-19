Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4AB8B7CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 18:02:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2B60AC005
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 16:02:16 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id rGtKsSZBdwkBRFPl for
	<xfs@oss.sgi.com>; Wed, 19 Jun 2013 16:02:15 -0700 (PDT)
Date: Wed, 19 Jun 2013 19:02:13 -0400 (EDT)
From: Nathan Scott <nathans@redhat.com>
Message-ID: <1040361622.4508678.1371682933909.JavaMail.root@redhat.com>
In-Reply-To: <CAC2B=ZGm4W=oFY+8sWAefhH79qK5N7yma4qQh_AQaOGiQDUWhw@mail.gmail.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
	<CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
	<20130617111347.GL29338@dastard>
	<CAC2B=ZGm4W=oFY+8sWAefhH79qK5N7yma4qQh_AQaOGiQDUWhw@mail.gmail.com>
Subject: Useful stats (was Re: definitions for /proc/fs/xfs/stat)
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@redhat.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: xfs@oss.sgi.com

Hi Mark,

----- Original Message -----
> ...
> On a totally different topic, and if you like we can start a different
> thread on it, I'd be interested in adding some monitoring stats to collectl
> for xfs and could use some suggestions of what are the most important.

Did you receive any other feedback on this (offlist perhaps)?  I was kinda
hoping someone else would chime in, but can share our experiences with PCP
if it helps.

We provide options to record all xfs.* metrics & an alternative to record
just the core I/O stats (so log I/O and the file read/write metrics).  With
PCP one can record any subset at any rate, so those are just convenience /
default suggestions.

In terms of recording in collectl, not sure what the requirements/parameters
are for you but I'd suggest recording all the data (in save-to-disk mode),
and IIRC you've got brief/verbose reporting modes - I'd focus on the log,
file I/O and buffer I/O stats when being "brief", and expand out to showing
in-core inode/dquot stats, ail/transaction stats, dir/attr operation stats.
You might consider another very-verbose kinda view with all of the various
btree stats, but that may be going too far.

Note that these are all aggregate statistics, there has been on-and-off
discussion for many years about adding some per-filesystem XFS stats, but
to date that has not happened - perhaps someday it will, so keep that in
mind for collectl too I guess.

Also, be aware there is a separate file for quota metrics, for hysterical
raisins (/proc/fs/xfs/xqmstat).

HTH.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
