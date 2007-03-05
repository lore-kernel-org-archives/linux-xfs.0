Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Mar 2007 13:19:41 -0800 (PST)
Received: from mail.atipa.com (125.14.124.24.cm.sunflower.com [24.124.14.125])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l25LJU6p024539
	for <linux-xfs@oss.sgi.com>; Mon, 5 Mar 2007 13:19:33 -0800
Message-ID: <45EC868A.4060607@atipa.com>
Date: Mon, 05 Mar 2007 15:07:22 -0600
From: Roger Heflin <rheflin@atipa.com>
MIME-Version: 1.0
Subject: Re: xfs partial dismount issue
References: <loom.20070305T141214-502@post.gmane.org> <45EC3DEA.3000105@sandeen.net> <loom.20070305T190248-708@post.gmane.org>
In-Reply-To: <loom.20070305T190248-708@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Charles Weber <chaweber@gmail.com>
Cc: linux-xfs@oss.sgi.com

Charles Weber wrote:
> Eric Sandeen <sandeen <at> sandeen.net> writes:
> 
>> Chuck Weber wrote:
>>> Hi everyone, I have a long running problem perhaps you can help with. I
>>> will include as much detail as I can. I can set up a spare server-disk
>>> set for testing if you have any bright ideas.
>>>
>>> We use XFS for samba and nfs on x86_64 Fedora Proliant DL585/385
>>> servers. Our busiest server has disk partitions go away. 
>> What do you mean by this, exactly?  The partitions themselves go away,
>> or are you talking about the problem described below where processes
>> start hanging?
>>
> Here is an example partition (1 of 6 or more xfs storage only).
> /share/store3 with samba shares on /share/store3/lls, lds, lxs and so on.
> I will get a call saying my groups share (lxs) is no longer accessable. I ssh
> into server and can ls /share/store3 but ls will hang when I ls
> /share/store3/lxs. Shortly there after ls will hang for the root or any
> directory on the partition. Other partitions will be fine and other samba shares
> will be fine until the queued up process load bogs the server down.
> 

Charles,

I have seen what may be a similar issue on SLES9SP2, we had 1 xfs
partition, and under certain conditions it would stop responding, all
non-xfs partitions were ok, and everything was fine after a reboot.

Under sysrq-t it appeared to me that 2 separate processes were calling
fsync and were causing each other to deadlock (and locking all others
out of changing the xfs partition).  I was not able to determine exactly
what the underlying bug was, but all of the hung processes
were waiting on locks in at least several widely different parts of the
xfs and kernel code, and adjusting the application to not fsync has
apparently resulted in the deadlock not occuring.   In this case
there were multiple (2-4) different instances of the application calling
fsync apparently sometimes at close to the same time.   With the
given application the failure was almost a certainly on one machine
(of 100) running the application overnight.

                            Roger
