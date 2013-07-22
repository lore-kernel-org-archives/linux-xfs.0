Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EE107F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 05:47:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEE068F8052
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 03:47:47 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id c3KcESClOTLlAtHm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 03:47:46 -0700 (PDT)
Date: Mon, 22 Jul 2013 12:47:43 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
Message-ID: <20130722104743.GA361@x4>
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4> <20130720014836.GZ11674@dastard>
	<20130722102223.GG11674@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130722102223.GG11674@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 2013.07.22 at 20:22 +1000, Dave Chinner wrote:
> On Sat, Jul 20, 2013 at 11:48:36AM +1000, Dave Chinner wrote:
> > On Fri, Jul 19, 2013 at 02:22:35PM +0200, Markus Trippelsdorf wrote:
> > > On 2013.07.15 at 08:47 +0200, Markus Trippelsdorf wrote:
> > > I've bisected this issue to the following commit:
> > > 
> > >  commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
> > >  Author: Dave Chinner <dchinner@redhat.com>
> > >  Date:   Thu Jun 27 16:04:49 2013 +1000
> > > 
> > >      xfs: don't do IO when creating an new inode
> > >          
> > > Reverting this commit on top of the Linus tree "solves" all problems for
> > > me. IOW I no longer loose my KDE and LibreOffice config files during a
> > > crash. Log recovery now works fine and xfs_repair shows no issues.
> > 
> > Thanks for bisecting this, Marcus.
> > 
> > I'll admit, right now it doesn't make a lot of sense to me - I don't
> > immediately see a connection between not reading an inode during the
> > create phase and unlinked list and directory corruption after a
> > crash. But now you've identified a change that might be the cause,
> > I have an avenue of investigation I can follow.
> > 
> > Indeed, in the time I've taken to write this mail I've thought of
> > 2-3 possible causes that I need to investigate....
> 
> Hi Markus, can you test the patch I just posted to the list titled
> "xfs: di_flushiter considered harmful" and see if it fixes your
> problem? Archive link here:
> 
> http://oss.sgi.com/pipermail/xfs/2013-July/028331.html

Unfortunately no. I still get the same corruption with this patch
applied.

(It's embarrassing to mention, but please add:
Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
to the next iteration of this patch.
Thanks.)

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
