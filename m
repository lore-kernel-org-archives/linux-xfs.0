Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 18:55:16 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m671tE6a012756
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 18:55:14 -0700
Received: from web34505.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0080E1883A2F
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 18:56:18 -0700 (PDT)
Received: from web34505.mail.mud.yahoo.com (web34505.mail.mud.yahoo.com [66.163.178.171]) by cuda.sgi.com with SMTP id vxZYGierty2RqhUc for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 18:56:18 -0700 (PDT)
Date: Sun, 6 Jul 2008 18:56:17 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: XFS Recovery
In-Reply-To: <487171A7.4070602@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <719163.7411.qm@web34505.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--- On Sun, 7/6/08, Timothy Shimmin <tes@sgi.com> wrote:
> >> XFS mounting filesystem md5
> >> Starting XFS recovery on filesystem: md5 (logdev:
> /dev/md0)
> >> Ending XFS recovery on filesystem: md5 (logdev:
> /dev/md0)
> > 
> > That's normal output when mounting an XFS
> filesystem - if
> > you see more than this then there might be problems...
> > 
> Hmmm....I don't know if I would describe that as
> "normal"
> unless I am misunderstanding Dave here.
> There has been some recovery happening indicating that
> there
> wasn't a clean unmount (it didn't find an unmount
> record in the log).
> But recovery should have replayed the
> outstanding metadata to a time point in the near past
> and so no repair should be necessary (we have qa tests
> which do the
> test anyway and check that there are no complaints).

Maybe not "normal," but at least "acceptable"?

If it's a regular occurrence, it might be worth looking into.
If it was a one-off, with no further complaints, I'd ignore it.

-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
