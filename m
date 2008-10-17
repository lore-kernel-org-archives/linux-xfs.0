Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 07:14:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HEE0ug023634
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 07:14:01 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 648C013A4FD7
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 07:15:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 7vSdd6q894hj6oie for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 07:15:44 -0700 (PDT)
Message-ID: <48F89E0F.6030307@sandeen.net>
Date: Fri, 17 Oct 2008 09:15:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption on the arm(el) architecture
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com>
In-Reply-To: <20081017070109.GA30726@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org, debian-arm@lists.debian.org, xfs@oss.sgi.com

Martin Michlmayr wrote:
> * Eric Sandeen <sandeen@sandeen.net> [2008-10-16 17:13]:
>> So is this a regression?  did it used to work?  If so, when? :)
> 
> The original report was with 2.6.18 but that was with the old ABI:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=423562
> I just installed a 2.6.22 kernel with EABI and I can also trigger
> the bug.  So it's not a (recent) regression.
> 
>> What's a little odd is that the buffer it dumped out looks like the
>> beginning of a perfectly valid superblock for your filesystem
>> (magic, block size, and block count all match).   If you printk the
>> "bno" variable right around line 2106 in xfs_da_btree.c, can you see
>> what you get?
> 
> bno is 0.

Ok, that's a little odd.  (correlates with the "bad" magic that was
seen, because block 0 is the superblock, but doesn't make sense because
we were trying to read a directory leaf block, in theory)

If you unmount & remount, does the ls work then?

>> creating an xfs_metadump of the filesystem for examination on a
>> non-arm box might also be interesting.
> 
> http://www.cyrius.com/tmp/dump5
> (11 MB)

Thanks.

xfs_repair on x86 shows no errors; however it won't mount normally (bad
log clientid) - but mount -o norecovery,ro and subsequent ls works fine
(at first I thought filenames were badly scrambled but then remembered
that xfs_metadump does this by default ;))

The remaining problem that I know of on some arm architectures is a vmap
cache aliasing problem that usually shows up as log corruption; that may
explain the bad clientid thing but not sure why we're reading block 0 above.

Do you know what cachepolicy you're booted with?  If it's writeallocate,
you might try cachepolicy=writeback, otherwise try cachepolicy=uncached
(which will be horribly slow) and see if the problem goes away or not;
it'd be a clue.

-Eric
