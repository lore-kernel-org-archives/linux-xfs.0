Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 16:49:43 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4ANnefB028196
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 16:49:41 -0700
Message-ID: <4643AF8F.5040705@goop.org>
Date: Thu, 10 May 2007 16:49:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com> <46439491.9010604@goop.org> <20070510225834.GF86004887@sgi.com> <4643A5B2.3060906@goop.org> <20070510232729.GH86004887@sgi.com>
In-Reply-To: <20070510232729.GH86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

David Chinner wrote:
> Ok, this is important to kow becase we merged a mod around that time
> that changes the way we handle the updates to the file size i.e. the
> fix for the NULL-files-on-crash problem:
>
> http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ba87ea699ebd9dd577bf055ebc4a98200e337542
>
> and that means the size of the file is not updated to the incore
> cached inode until after the data write is complete. The symptoms
> being seen would match with a inode-not-being-written-after-last-
> data-write-bug in this mod....
>   

Yes, that does look like a good candidate.  Should I try to
before-and-after this change?

    J
