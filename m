Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 534F47F62
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 11:02:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 424998F8064
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 09:02:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cxGvLuJ3JGgetxbV for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 09:02:20 -0700 (PDT)
Message-ID: <51E9630A.3070201@sandeen.net>
Date: Fri, 19 Jul 2013 11:02:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4>
	<CAAxjCExBi-4Qgf6-=MBzdkzBmMtu=GTURu46DoD2CzpnF2dinw@mail.gmail.com>
	<20130719125149.GB360@x4>
In-Reply-To: <20130719125149.GB360@x4>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Stefan Ring <stefanrin@gmail.com>, Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux fs XFS <xfs@oss.sgi.com>

On 7/19/13 7:51 AM, Markus Trippelsdorf wrote:
> On 2013.07.19 at 14:41 +0200, Stefan Ring wrote:
>>> I've bisected this issue to the following commit:
>>>
>>>  commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
>>>  Author: Dave Chinner <dchinner@redhat.com>
>>>  Date:   Thu Jun 27 16:04:49 2013 +1000
>>>
>>>      xfs: don't do IO when creating an new inode
>>>
>>> Reverting this commit on top of the Linus tree "solves" all problems for
>>> me. IOW I no longer loose my KDE and LibreOffice config files during a
>>> crash. Log recovery now works fine and xfs_repair shows no issues.
>>>
>>> So users of 3.11.0-rc1 beware. Only run this version if you have
>>> up-to-date backups handy.

Are you certain about that bisection point?  All that does is
say:  When we allocate a new inode, assign it a random generation
number, rather than reading it from disk & incrementing the
older generation number, AFAICS.  So it simply avoids a read IO.

I wonder if simply changing IO patterns on the SSD changes how
it's doing caching & destaging <handwave>.

>> What I miss in this thread is a distinction between filesystem
>> corruption on the one hand and a few zeroed files on the other. The
>> latter may be a nuisance, but it is expected behavior, while the
>> former should never happen, period, if I'm not mistaken.
> 
> Well, it is natural that fs developers at first try to blame userspace.

I disagree with that, we just need to be clear about your scenarios,
and what integrity guarantees should apply.

> Unfortunately it turned out that in this case there is filesystem
> corruption. (Fortunately this normally happens only very rarely on rc1
> kernels).

Corruption is when you get back data that you did not write,
or metadata which is inconsistent or unreadable even after a proper
log replay.

Corruption is _not_ unsynced, buffered data that was lost on a
crash or poweroff.

But I might not have followed the thread properly, and I might
misunderstand your situation.

When you experience this lost file [data] scenario, was it after an
orderly reboot, or after a crash and/or system reset?

-Eric



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
