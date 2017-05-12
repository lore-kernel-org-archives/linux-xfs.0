Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:50504 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdELPTe (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:2:1>);
        Fri, 12 May 2017 11:19:34 -0400
Message-Id: <5915EEA7020000780015958E@prv-mh.provo.novell.com>
Date: Fri, 12 May 2017 09:19:35 -0600
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <a185194a-af56-cd53-cfb9-653e3b5f81b7@sandeen.net>
 <591571BC0200007800159165@prv-mh.provo.novell.com>
 <30296667-47d7-8b94-472a-1d4b96120c09@sandeen.net>
 <5915DE47020000780015946C@prv-mh.provo.novell.com>
 <23c75521-a65b-d105-f274-3d1aba09e6ae@sandeen.net>
In-Reply-To: <23c75521-a65b-d105-f274-3d1aba09e6ae@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

>>> On 12.05.17 at 17:04, <sandeen@sandeen.net> wrote:
> On 5/12/17 9:09 AM, Jan Beulich wrote:
>>>>> On 12.05.17 at 15:56, <sandeen@sandeen.net> wrote:
>>> On 5/12/17 1:26 AM, Jan Beulich wrote:
>>>> So on the earlier instance, where I did run actual repairs (and
>>>> indeed multiple of them), the problem re-surfaces every time
>>>> I mount the volume again.
>>> Ok, what is the exact sequence there, from repair to re-corruption?
>> Simply mount the volume after repairing (with or without an
>> intermediate reboot) and access respective pieces of the fs
>> again. As said, with /var/run affected on that first occasion,
>> I couldn't even cleanly boot again without seeing the
>> corruption re-surface.
> 
> Mount under what kernel, and access in what way?  I'm looking for a
> recipe to reproduce what you've seen using the metadump you've provided.

So that's where the problem is: As said, on this occasion I didn't
try to run xfs_repair at all. What I'm describing is the situation
I've ended in on the earlier occasion, which I didn't send you
any data on (if you think it's worth it despite the several rounds
of repairs I've run there, I could certainly do so, as I didn't
decide yet what to do with that system in order to get it back
into working state).

In any event, the same re-occurrence of the problem was
observed with 3.0, 3.12, 4.4, and 4.11 based kernels. And the
accesses were whatever the system does during boot (from
the names I presume mostly creating /var/run/*.pid files). But
simple directory listings suffice to trigger the kernel warnings
(can't tell whether they also suffice to re-introduce the issues).
I've even tried mounting the volume ro after repairing, but -
not entirely unexpected - the system didn't really like /var
being read-only, so I couldn't check whether the corruption in
that case would not have been flagged again.

> However:
> 
> With further testing I see that xfs_repair v3.1.8 /does not/
> entirely fix the fs; if I run 3.1.8 and then run upstream repair, it
> finds and fixes more bad flags on inode 764 (lib/xenstored/tdb) that 3.1.8
> didn't touch.  The verifiers in an upstream kernel may keep tripping
> over that until newer repair fixes it...

Well, I can see if I can build those newer tools for myself (would
largely depend on how easy/difficult they are to configure/make,
and whether there's a testsuite that I can run them over before
allowing them to touch live data); I don't expect newer tools to
be available for the distro I'm running.

Jan

