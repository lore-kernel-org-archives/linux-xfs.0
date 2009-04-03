Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n33HE3Uj226187 for <xfs@oss.sgi.com>; Fri, 3 Apr 2009 12:14:13 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6D1731EA55D
	for <xfs@oss.sgi.com>; Fri,  3 Apr 2009 10:13:40 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	B3PS6G39mIeMq0hD for <xfs@oss.sgi.com>;
	Fri, 03 Apr 2009 10:13:40 -0700 (PDT)
Date: Fri, 3 Apr 2009 10:02:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.30
In-Reply-To: <alpine.LFD.2.00.0904030952220.4130@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904030954030.4130@localhost.localdomain>
References: <20090331053013.7642414167108@attica.americas.sgi.com>
	<BD6F95C9-2F2D-49A3-979C-25018E62E416@sgi.com>
	<alpine.LFD.2.00.0904030952220.4130@localhost.localdomain>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>, Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>



On Fri, 3 Apr 2009, Linus Torvalds wrote:

> 
> 
> On Thu, 2 Apr 2009, Felix Blyakher wrote:
> > 
> > Were there any problems pulling from the xfs repository?
> 
> Sorry, no - just too much email, too many trees to look at, too many 
> people to argue with.
> 
> Pulled.

Side note - I almost unpulled afterwards. 

You've done several apparently totally useless pulls from my tree at 
random points. 

Daily "keep up-to-date with Linus' tree" pulls are _strongly_ discouraged 
(read: if this continues, I'll just stop pulling from you), because it 
makes the history totally unreadable after-the-fact. It has some direct 
technical downsides (it makes it much harder to run "git bisect" and see 
what is going on), but apart from those direct downsides it just makes it 
much harder for me - or anybody else who wants to get an overview of what 
happened - to visualize things when history is messy.

Instead of having a clear nice line of development that says "this is what 
happened to XFS", those merges have basically mixed up all your changes 
with all the random _other_ changes in the tree. 

In other words, having those extra merges makes the graphical tools almost 
useless for getting some kind of "what happened" overview. 

I realize that an occasional back-merge may be required to resolve big 
conflicts early, but they really have to be pretty big and immediate for 
it to be a win. 

			Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
