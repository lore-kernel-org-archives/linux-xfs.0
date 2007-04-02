Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Apr 2007 14:44:50 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.243])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l32LijfB006582
	for <linux-xfs@oss.sgi.com>; Mon, 2 Apr 2007 14:44:46 -0700
Received: by an-out-0708.google.com with SMTP id c5so1347883anc
        for <linux-xfs@oss.sgi.com>; Mon, 02 Apr 2007 14:44:44 -0700 (PDT)
Message-ID: <817da7960704021418g6e1d4662y3250be14bc01ab69@mail.gmail.com>
Date: Mon, 2 Apr 2007 17:18:57 -0400
From: "Charles Weber" <chaweber@gmail.com>
Subject: Re: xfs partial dismount issue
In-Reply-To: <45EC868A.4060607@atipa.com>
MIME-Version: 1.0
References: <loom.20070305T141214-502@post.gmane.org>
	 <45EC3DEA.3000105@sandeen.net>
	 <loom.20070305T190248-708@post.gmane.org> <45EC868A.4060607@atipa.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Roger Heflin <rheflin@atipa.com>
Cc: linux-xfs@oss.sgi.com, sandeen@sandeen.net

Well actually I did a test with ext3 and got the same result. It partially
dismounted after a day or so of use and seemed identical to my previous xfs
filesystem failures . My guess now is that this has always occurred when all
6 raid controllers (2 per card)  were in use. I could go quite some time
with 5 of the 6 controllers used. I consolidated everything to 2 cards,
removed one card and put in fiber channel card for my new storage array So
far no problems. If so then it seems something is funny about the cciss
driver.

thanks,
Chuck






On 3/5/07, Roger Heflin <rheflin@atipa.com> wrote:
>
> Charles Weber wrote:
> > Eric Sandeen <sandeen <at> sandeen.net> writes:
> >
> >> Chuck Weber wrote:
> >>> Hi everyone, I have a long running problem perhaps you can help with.
> I
> >>> will include as much detail as I can. I can set up a spare server-disk
> >>> set for testing if you have any bright ideas.
> >>>
> >>> We use XFS for samba and nfs on x86_64 Fedora Proliant DL585/385
> >>> servers. Our busiest server has disk partitions go away.
> >> What do you mean by this, exactly?  The partitions themselves go away,
> >> or are you talking about the problem described below where processes
> >> start hanging?
> >>
> > Here is an example partition (1 of 6 or more xfs storage only).
> > /share/store3 with samba shares on /share/store3/lls, lds, lxs and so
> on.
> > I will get a call saying my groups share (lxs) is no longer accessable.
> I ssh
> > into server and can ls /share/store3 but ls will hang when I ls
> > /share/store3/lxs. Shortly there after ls will hang for the root or any
> > directory on the partition. Other partitions will be fine and other
> samba shares
> > will be fine until the queued up process load bogs the server down.
> >
>
> Charles,
>
> I have seen what may be a similar issue on SLES9SP2, we had 1 xfs
> partition, and under certain conditions it would stop responding, all
> non-xfs partitions were ok, and everything was fine after a reboot.
>
> Under sysrq-t it appeared to me that 2 separate processes were calling
> fsync and were causing each other to deadlock (and locking all others
> out of changing the xfs partition).  I was not able to determine exactly
> what the underlying bug was, but all of the hung processes
> were waiting on locks in at least several widely different parts of the
> xfs and kernel code, and adjusting the application to not fsync has
> apparently resulted in the deadlock not occuring.   In this case
> there were multiple (2-4) different instances of the application calling
> fsync apparently sometimes at close to the same time.   With the
> given application the failure was almost a certainly on one machine
> (of 100) running the application overnight.
>
>                             Roger
>


[[HTML alternate version deleted]]
