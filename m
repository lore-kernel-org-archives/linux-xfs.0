Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 02:06:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P96rOG014818
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 02:06:53 -0700
Received: from web34501.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E9C50182D17A
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 02:08:26 -0700 (PDT)
Received: from web34501.mail.mud.yahoo.com (web34501.mail.mud.yahoo.com [66.163.178.167]) by cuda.sgi.com with SMTP id wgNhB8UsxfVcnBvz for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 02:08:26 -0700 (PDT)
Date: Thu, 25 Sep 2008 02:08:26 -0700 (PDT)
From: gus3 <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: Speed of rm compared to reiserfs (slow)
In-Reply-To: <48DB48E3.3020104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <284797.30246.qm@web34501.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, david@fromorbit.com, =?iso-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>

--- On Thu, 9/25/08, Török Edwin <edwintorok@gmail.com> wrote:

> >> I did a test on my box, and indeed the speed of rm
> is order of magnitude
> >> slower compared to reiserfs.
> >> I already use lazy-count, and noatime/nodiratime.
> Write barriers are off
> >> because I run on raid10.
> >>
> >> Is there anything else I can tune to get faster rm
> speed?

Others' suggestions stand, but I have found the best way to speed up a journalled filesystem (of any kind) is with an external journal on a separate controller channel. If your XFS journal is internal, the RAID10 layer creates a longer data path when actions are recorded in the journal, then read from the journal, and finally committed to the main filesystem.

You may also investigate the speed of different elevator algorithms. XFS does best with "noop" or "deadline" in my experience. Most Linux distributions ship with "cfq" as their default elevator, which can clash badly against XFS.
