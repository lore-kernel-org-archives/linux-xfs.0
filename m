Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jun 2008 06:03:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5KD3tLo011900
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2008 06:03:56 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A3C8258035
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2008 06:04:54 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.248]) by cuda.sgi.com with ESMTP id BA1a0RgRyQqsJsy3 for <xfs@oss.sgi.com>; Fri, 20 Jun 2008 06:04:54 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so5808199rvb.32
        for <xfs@oss.sgi.com>; Fri, 20 Jun 2008 06:04:54 -0700 (PDT)
Message-ID: <59a5c01d0806200604i65f8271ya371039ef30af731@mail.gmail.com>
Date: Fri, 20 Jun 2008 13:04:54 +0000
From: "Ashley Oviatt" <ashovi@gmail.com>
Subject: Re: xfs_repair taking a long time
In-Reply-To: <485AD667.1060402@qwest.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485AD667.1060402@qwest.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have run xfs_metadump on the array and here is the output:

root@slax:~# xfs_metadump -V
xfs_metadump version 2.9.7
root@slax:~# xfs_metadump /dev/sda /root
xfs_metadump: unexpected XFS SB magic number 0x00000000
xfs_metadump: read failed: Invalid argument
xfs_metadump: data size check failed
cache_node_purge: refcount was 1, not zero (node=0x80e2670)
xfs_metadump: cannot read root inode (22)
xfs_metadump: bad superblock magic number 0, giving up

It looks like the superblock got corrupted, and xfs_repair can't find
another one to fix it.

Any ideas on how to get it back?

Ashley

On 6/19/08, Ash <ashovi@qwest.net> wrote:
> I am having the same problem as the person in this thread:
>
>
> Which is xfs_repair has been running for 16 hours on a 1 TB raid array.
> It gave the same errors as this thread, saying that it could not use any
> of the super blocks it found. The last email in the thread says:
>
> -----------------------------------------
>
> xfs-repair did find candidate secondary superblocks - it discarded them
> for some reason or another. If they were ok, all repair would have done
> is copied them to block zero and then continued.
>
> I'm suggesting that you manually do this step, and then see if repair
> will run.
>
>  >    Before wrapping this up, if you could just clarify a couple
> things.  If I
>  >    look at the bytes at the beginning of each physical part of the LVM's,
>  >    what am I looking for?  "XFSB"?
>
> yes.
>
>  >    If I do find that byte string, why
>  >    couldn't xfs_repair find it when it did the scan and what do I do
> with it
>  >    if I do find one?
>
> As I said above, xfs-repair did find some, but rejected them for some
> (unknown) reason. if you find one, copy it over block zero of the partition,
> and see if repair will run. Like I said, though, you'll probably want to
> back up th partition first, or at least run repair in no-modify mode.
>
> --------------------------------------
>
> The poster, Dave Chinner, says to manually copy the superblock to the
> right place, but not how to do it. I am familiar with dd, but would like
> to know the exact command or steps to take to replace the primary
> superblock manually with a secondary superblock.
>
> Ashley
>
> (I sent this earlier but I haven't seen it come over the list yet, so
> I'll send it again. Please forgive the duplicate.)
>
>
>
