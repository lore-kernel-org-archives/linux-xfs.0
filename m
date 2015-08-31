Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 772677F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 15:05:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0AF63AC00A
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:05:55 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0022.hostedemail.com
	[216.40.44.22]) by cuda.sgi.com with ESMTP id HFeEGoxBbDLGfKV0
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:05:54 -0700 (PDT)
Date: Mon, 31 Aug 2015 16:05:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 21/22] xfs: %pF is only for function pointers
Message-ID: <20150831160551.4e4fb61c@gandalf.local.home>
In-Reply-To: <1441051104.4966.41.camel@freescale.com>
References: <1426130037-17956-1-git-send-email-scottwood@freescale.com>
	<1426130037-17956-21-git-send-email-scottwood@freescale.com>
	<20150831080657.GF26895@dastard>
	<1441049065.4966.38.camel@freescale.com>
	<20150831154521.1c9353b6@gandalf.local.home>
	<1441051104.4966.41.camel@freescale.com>
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

On Mon, 31 Aug 2015 14:58:24 -0500
Scott Wood <scottwood@freescale.com> wrote:

> > We can fix that with adding %ps to the traceevent library.
> 
> I wasn't sure if this would be considered a stable ABI issue, as it's not 
> about the events themselves, but about the event mechanism.

When it comes to trace events, there's a fine line about the use space
stable ABI. Even Linus has mentioned that tracing and perf counters are
"special", as the two are not about a feature of the kernel, but
instead a way to see how the kernel works internally.

I've fixed up trace-cmd and libtraceevent more than once in the past
due to changes in the kernel. Unless it truly breaks the tool, it
should be fine to fix up tracepoints to handle small changes like this.

-- Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
