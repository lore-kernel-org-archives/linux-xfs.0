Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C6C929DFD
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 19:20:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E3C88F8035
	for <xfs@oss.sgi.com>; Sun, 30 Mar 2014 17:20:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WgTEI6YceqsAIKXv for
	<xfs@oss.sgi.com>; Sun, 30 Mar 2014 17:20:41 -0700 (PDT)
Date: Sun, 30 Mar 2014 20:20:30 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
Message-ID: <20140331002030.GA19391@redhat.com>
References: <20140329223109.GA24098@redhat.com>
	<20140330234335.GB16336@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140330234335.GB16336@dastard>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 31, 2014 at 10:43:35AM +1100, Dave Chinner wrote:
 > On Sat, Mar 29, 2014 at 06:31:09PM -0400, Dave Jones wrote:
 > > Not sure if I've reported this already (it looks familiar, though I've not managed
 > > to find it in my sent mail folder).  This is rc8 + a diff to fix the stack usage reports
 > > I was seeing (diff at http://paste.fedoraproject.org/89854/13210913/raw)
 > > 
 > >  ======================================================
 > >  [ INFO: possible circular locking dependency detected ]
 > >  3.14.0-rc8+ #153 Not tainted
 > >  -------------------------------------------------------
 > >  git/32710 is trying to acquire lock:
 > >   (&(&ip->i_lock)->mr_lock){++++.+}, at: [<ffffffffc03bd782>] xfs_ilock+0x122/0x250 [xfs]
 > >  
 > > but task is already holding lock:
 > >   (&mm->mmap_sem){++++++}, at: [<ffffffffae7b816a>] __do_page_fault+0x14a/0x610
 > > 
 > > which lock already depends on the new lock.
 > 
 > filldir on a directory inode vs page fault on regular file. Known
 > issue, definitely a false positive.

ah yeah, thought it looked familiar. I think I reported this last summer.

 > We have to change locking
 > algorithms to avoid such deficiencies of lockdep (a case of "lockdep
 > considered harmful", perhaps?) so it's not something I'm about to
 > rush...

Bummer, as it makes lockdep useless on my test box using xfs because it
disables itself after hitting this very quickly.
(I re-enabled it a couple days ago wondering why I'd left it turned off,
 chances are it was because of this)

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
