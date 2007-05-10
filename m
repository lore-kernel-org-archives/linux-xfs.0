Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 14:51:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4ALpXfB013510
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 14:51:34 -0700
Message-ID: <464393E1.3050705@redhat.com>
Date: Thu, 10 May 2007 17:51:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org>
In-Reply-To: <464392B4.3070009@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

Jeremy Fitzhardinge wrote:
> Chuck Ebbert wrote:
>> What CPU architecture is this happening on? Not i686 with PAE by
>> any chance?
> 
> Yes.  Why?

I have a bug report where NFS files are corrupted only with PAE clients.
Corruption is at the end of the (newly untarred) files. Doesn't happen
without PAE.
