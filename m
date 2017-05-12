Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:43567 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbdELG0f (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:2:1>);
        Fri, 12 May 2017 02:26:35 -0400
Message-Id: <591571BC0200007800159165@prv-mh.provo.novell.com>
Date: Fri, 12 May 2017 00:26:36 -0600
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <a185194a-af56-cd53-cfb9-653e3b5f81b7@sandeen.net>
In-Reply-To: <a185194a-af56-cd53-cfb9-653e3b5f81b7@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

>>> On 11.05.17 at 18:39, <sandeen@sandeen.net> wrote:
> On 5/11/17 9:39 AM, Jan Beulich wrote:
>> In any event I think there are two problems: The corruption itself
>> (possibly an issue with recent enough upstream kernels only) and
>> the fact that running xfs_repair doesn't help in these cases.
> 
> FWIW, recent xfs_repair (v4.11.0) finds several bad inodes on the
> sdb8 metadump you sent, and apparently fixes* them without problems.
> 
> inode 764 has RT flag set but there is no RT device
> directory flags set on non-directory inode 764
> inode 2068 has RT flag set but there is no RT device
> directory flags set on non-directory inode 2068
> inode 268448674 has RT flag set but there is no RT device
> directory flags set on non-directory inode 268448674
> 
> these are:
> 
> 764: lib/xenstored/tdb
> 2068: log/messages
> 268448674: lib/sudo/jbeulich/0

This matches then was xfs_repair -n has found here.

I'm surprised log/messages is among them, as I didn't have to do
anything to it to at least avoid the kernel warnings (for the other
two I've simply renamed the containing directories, creating fresh
ones instead). What I did get kernel warnings for were one or
two files under log/xen/, which I've then similarly renamed and
re-created.

> and after repair, I can read all the inodes on the device w/o
> further errors (upstream linus kernel)

So on the earlier instance, where I did run actual repairs (and
indeed multiple of them), the problem re-surfaces every time
I mount the volume again. Iirc the inode numbers didn't change,
but in some cases the associated files did (namely when these
weren't ones created very soon after mount, i.e. when the
order of things is less predictable - it was in particular /var/run/
which was affected there). That's the reason I've refrained
from trying to xfs_repair the issues in this second instance.

Now one question obviously is whether the repair strategy
changed between the xfs_repair versions I use (3.1.8 on the
system that I sent you the meta data dump from, likely the
same on the other one): Mine clears the inodes with the bad
RT flag, while - namely considering the subsequent "block ...
type unknown" reported by xfs_check - it might instead be
possible to reconstruct the files and clear the RT flag. But of
course I know nothing about XFS internals...

> *Each of the 3 problematic inodes has an odd assortment of flags
> set (think chattr type flags) - some have immutable, some have
> noatime, some have nodump, etc.  These are what cause xfs_repair
> t ocomplain.  It seems unlikely that any of these were actually set
> on your filesystem, as these are the only ones with any flags set.
> After repair, they're showing:
> 
> --S---dA----------- mnt/log/messages
> --S-i--A----------- mnt/lib/sudo/jbeulich/0
> --S----A----------- mnt/lib/xenstored/tdb
> 
> Did you happen to set chattr flags on these files intentionally?

I certainly didn't. As I don't know how to produce this form of
flags display, I can't (for now) compare with what a healthy
system has there.

Jan

