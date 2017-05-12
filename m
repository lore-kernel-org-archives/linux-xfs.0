Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from prv-mh.provo.novell.com ([137.65.248.74]:46666 "EHLO
        prv-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755567AbdELOJn (ORCPT
        <rfc822;groupwise-linux-xfs@vger.kernel.org:2:1>);
        Fri, 12 May 2017 10:09:43 -0400
Message-Id: <5915DE47020000780015946C@prv-mh.provo.novell.com>
Date: Fri, 12 May 2017 08:09:43 -0600
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <a185194a-af56-cd53-cfb9-653e3b5f81b7@sandeen.net>
 <591571BC0200007800159165@prv-mh.provo.novell.com>
 <30296667-47d7-8b94-472a-1d4b96120c09@sandeen.net>
In-Reply-To: <30296667-47d7-8b94-472a-1d4b96120c09@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

>>> On 12.05.17 at 15:56, <sandeen@sandeen.net> wrote:
> On 5/12/17 1:26 AM, Jan Beulich wrote:
>> So on the earlier instance, where I did run actual repairs (and
>> indeed multiple of them), the problem re-surfaces every time
>> I mount the volume again.
> 
> Ok, what is the exact sequence there, from repair to re-corruption?

Simply mount the volume after repairing (with or without an
intermediate reboot) and access respective pieces of the fs
again. As said, with /var/run affected on that first occasion,
I couldn't even cleanly boot again without seeing the
corruption re-surface.

>> Iirc the inode numbers didn't change,
>> but in some cases the associated files did (namely when these
>> weren't ones created very soon after mount, i.e. when the
>> order of things is less predictable - it was in particular /var/run/
>> which was affected there). That's the reason I've refrained
>> from trying to xfs_repair the issues in this second instance.
>> 
>> Now one question obviously is whether the repair strategy
>> changed between the xfs_repair versions I use (3.1.8 on the
> 
> That's extremely old - Mar 2012, FWIW.
> 
>> system that I sent you the meta data dump from, likely the
>> same on the other one): Mine clears the inodes with the bad
>> RT flag, while - namely considering the subsequent "block ...
>> type unknown" reported by xfs_check - it might instead be
>> possible to reconstruct the files and clear the RT flag. But of
>> course I know nothing about XFS internals...
> 
> That is what xfs_repair did here - it cleared the bad flags and left
> the rest intact.

For all of the cases? According to my run, "Bad flags set in inode..."
would lead to the flags being corrected, but "found inode ... claiming
to be a real-time file" would lead to the inode being cleared. But of
course I can imagine this being dealt with differently in newer
versions of the tool...

>>> *Each of the 3 problematic inodes has an odd assortment of flags
>>> set (think chattr type flags) - some have immutable, some have
>>> noatime, some have nodump, etc.  These are what cause xfs_repair
>>> t ocomplain.  It seems unlikely that any of these were actually set
>>> on your filesystem, as these are the only ones with any flags set.
>>> After repair, they're showing:
>>>
>>> --S---dA----------- mnt/log/messages
>>> --S-i--A----------- mnt/lib/sudo/jbeulich/0
>>> --S----A----------- mnt/lib/xenstored/tdb
>>>
>>> Did you happen to set chattr flags on these files intentionally?
>> 
>> I certainly didn't. As I don't know how to produce this form of
>> flags display, I can't (for now) compare with what a healthy
>> system has there.
> 
> The above is from the lsattr display.  (I suppose it's plausible that
> i.e. messages would have "append-only" set by something ...)

On a healthy system all three of them have no flags set at all.

Jan

