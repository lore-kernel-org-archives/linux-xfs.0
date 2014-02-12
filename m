Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 798FA7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 23:50:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C1B08F8039
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 21:50:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ffy7lHzJdSK2hkRB for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 21:50:38 -0800 (PST)
Date: Wed, 12 Feb 2014 00:50:27 -0500
From: Dave Jones <davej@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212055027.GA28502@redhat.com>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140212054043.GB13997@dastard>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, Feb 12, 2014 at 04:40:43PM +1100, Dave Chinner wrote:

 > None of the XFS code disables interrupts in that path, not does is
 > call outside XFS except to dispatch IO. The stack is pretty deep at
 > this point and I know that the standard (non stacked) IO stack can
 > consume >3kb of stack space when it gets down to having to do memory
 > reclaim during GFP_NOIO allocation at the lowest level of SCSI
 > drivers. Stack overruns typically show up with symptoms like we are
 > seeing.
 > ..
 > 
 > Dave, before chasing ghosts, can you (like Eric originally asked)
 > turn on stack overrun detection?

CONFIG_DEBUG_STACKOVERFLOW ? Already turned on.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
