Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF4A07F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 14:45:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83624304032
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 12:45:27 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0129.hostedemail.com
	[216.40.44.129]) by cuda.sgi.com with ESMTP id tm1EPtMQTWPJyeB4
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 12:45:25 -0700 (PDT)
Date: Mon, 31 Aug 2015 15:45:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 21/22] xfs: %pF is only for function pointers
Message-ID: <20150831154521.1c9353b6@gandalf.local.home>
In-Reply-To: <1441049065.4966.38.camel@freescale.com>
References: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
	<1426130037-17956-21-git-send-email-scottwood@freescale.com>
	<20150831080657.GF26895@dastard>
	<1441049065.4966.38.camel@freescale.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Scott Wood <scottwood@freescale.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, 31 Aug 2015 14:24:25 -0500
Scott Wood <scottwood@freescale.com> wrote:
 
> > Can you please look into why this change broke the tracing output
> > on x86-64 - if there is no obvious/easy fix for it, then I'm simply
> > going to revert it because having the tracing work correctly on
> > x86-64 is far more important to us than ppc64 or ia64....
> 
> It looks like the cause is that TP_printk() is not really printk() -- it 
> actually passes the format to userspace which has its own, not 100% 
> compatible implementation pretty_print() in tools/lib/traceevent/event-
> parse.c.  %pf in that function behaves like %ps in the kernel, and %ps is 
> absent.
> 

We can fix that with adding %ps to the traceevent library.

-- Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
