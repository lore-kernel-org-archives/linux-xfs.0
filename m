Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Mar 2007 10:26:28 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l25IQI6p022416
	for <linux-xfs@oss.sgi.com>; Mon, 5 Mar 2007 10:26:19 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1HOHsf-0007SD-KE
	for linux-xfs@oss.sgi.com; Mon, 05 Mar 2007 19:25:53 +0100
Received: from fernwood-arbiter-b.net.nih.gov ([128.231.88.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 05 Mar 2007 19:25:53 +0100
Received: from chaweber by fernwood-arbiter-b.net.nih.gov with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 05 Mar 2007 19:25:53 +0100
From: Charles Weber <chaweber@gmail.com>
Subject: Re: xfs partial dismount issue
Date: Mon, 5 Mar 2007 18:25:03 +0000 (UTC)
Message-ID: <loom.20070305T190248-708@post.gmane.org>
References: <loom.20070305T141214-502@post.gmane.org> <45EC3DEA.3000105@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Eric Sandeen <sandeen <at> sandeen.net> writes:

> 
> Chuck Weber wrote:
> > Hi everyone, I have a long running problem perhaps you can help with. I
> > will include as much detail as I can. I can set up a spare server-disk
> > set for testing if you have any bright ideas.
> > 
> > We use XFS for samba and nfs on x86_64 Fedora Proliant DL585/385
> > servers. Our busiest server has disk partitions go away. 
> 
> What do you mean by this, exactly?  The partitions themselves go away,
> or are you talking about the problem described below where processes
> start hanging?
> 
Here is an example partition (1 of 6 or more xfs storage only).
/share/store3 with samba shares on /share/store3/lls, lds, lxs and so on.
I will get a call saying my groups share (lxs) is no longer accessable. I ssh
into server and can ls /share/store3 but ls will hang when I ls
/share/store3/lxs. Shortly there after ls will hang for the root or any
directory on the partition. Other partitions will be fine and other samba shares
will be fine until the queued up process load bogs the server down.

> > The other
> > servers do not show this behavior ever. The partitions show as mounted,
> > but access to the partition just hangs. Open file count, process count
> > and load average rise until the server becomes very unresponsive. Even
> > if we catch it before the high load average, because it cannot unmount
> > the partition, it must be powered off and back on to restart. Upon
> > restart all partitions mount properly and everything is fine for days or
> > months. There is nothing in log files that I have noticed. With sar, I
> > can track the files open and process count rise. 
> 
> Maybe try sysrq-t, to capture all backtraces when it's in this state,
> and see where the various threads are at.
> 

OK I'll look over sysrq
> -Eric
> 
> 
