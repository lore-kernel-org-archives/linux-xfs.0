Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B1277F3F
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 00:44:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BC518F8033
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 22:43:57 -0800 (PST)
Received: from mail1.xortex.at (mail1.xortex.at [95.130.251.167]) by
	cuda.sgi.com with ESMTP id Kx8TSzNj3vhHxalq for
	<xfs@oss.sgi.com>; Sun, 13 Dec 2015 22:43:53 -0800 (PST)
From: =?Windows-1252?Q?Georg_Sch=F6nberger?= <g.schoenberger@xortex.com>
Subject: Re: XFS and nobarrier with SSDs
Date: Mon, 14 Dec 2015 06:43:48 +0000
Message-ID: <566E6524.6070401@xortex.com>
References: <E127700EFE58FD45BD6298EAC813FA42020D8173@TIGER2010.xortex.local>
	<3496214.YTSKClH6pV@merkaba>
In-Reply-To: <3496214.YTSKClH6pV@merkaba>
Content-Language: de-DE
Content-ID: <f06239cb-8906-46d4-8045-fadd4060f914>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <martin@lichtvoll.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 2015-12-12 13:26, Martin Steigerwald wrote:
> Am Samstag, 12. Dezember 2015, 10:24:25 CET schrieb Georg Sch=F6nberger:
>> We are using a lot of SSDs in our Ceph clusters with XFS. Our SSDs have
>> Power Loss Protection via capacitors, so is it safe in all cases to run =
XFS
>> with nobarrier on them? Or is there indeed a need for a specific I/O
>> scheduler?
> I do think that using nobarrier would be safe with those SSDs as long as =
there
> is no other caching happening on the hardware side, for example inside the
> controller that talks to the SSDs.
Hi Martin, thanks for your response!

We are using HBAs and no RAID controller, therefore there is no other =

cache in the I/O stack.

>
> I always thought barrier/nobarrier acts independently of the I/O scheduler
> thing, but I can understand the thought from the bug report you linked to
> below. As for I/O schedulers, with recent kernels and block multiqueue I =
see
> it being set to "none".
What do you mean by "none" near? Do you think I will be more on the safe =

side with noop scheduler?

>
>> I have found a recent discussion on the Ceph mailing list, anyone from X=
FS
>> that can help us?
>>
>> *http://www.spinics.net/lists/ceph-users/msg22053.html
> Also see:
>
> http://xfs.org/index.php/
> XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent=
_write_cache.
> 3F
I've already read that XFS wiki entry before and also found some Intel =

presentations where they suggest to use nobarrier with
there enterprise SSDs. But a confirmation from any block layer =

specialist would be a good thing!

>
>> *https://bugzilla.redhat.com/show_bug.cgi?id=3D1104380
> Interesting. Never thought of that one.
>
> So would it be safe to interrupt the flow of data towards the SSD at any =
point
> if time with reordering I/O schedulers in place? And how about blk-mq whi=
ch
> has mutiple software queus?
Maybe we should ask the block layer mailing list about that?

>
> I like to think that they are still independent of the barrier thing and =
the
> last bug comment by Eric, where he quoted from Jeff, supports this:
>
>> Eric Sandeen 2014-06-24 10:32:06 EDT
>>
>> As Jeff Moyer says:
>>> The file system will manually order dependent I/O.
>>> What I mean by that is the file system will send down any I/O for the
>>> transaction log, wait for that to complete, issue a barrier (which will
>>> be a noop in the case of a battery-backed write cache), and then send
>>> down the commit block along with another barrier.  As such, you cannot
>>> have the I/O scheduler reorder the commit block and the log entry with
>>> which it is associated.
If it is truly that way then I do not see any problems using nobarrier =

with the SSDs an power loss protection.
I have already find some people say that enterprise SSDs with PLP simply =

ignore the sync call. If that's the case
then using nobarrier would have no performance improvement...

Cheers, Georg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
