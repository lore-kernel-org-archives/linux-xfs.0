Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 17:54:07 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4A0s4fB031191
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 17:54:05 -0700
Message-ID: <46426D31.8070000@goop.org>
Date: Wed, 09 May 2007 17:54:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com>
In-Reply-To: <20070510004918.GS85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

David Chinner wrote:
> Suspend-resume, eh?
>
> There's an immediate suspect. Can you test this specifically for us?
> i.e. download a known good file set, do some stuff, suspend, resume,
> then check the files? If it doesn't show up the first time, can
> you do it a few times just to rule it out?
>   

Well, I've been doing suspend-resume with xfs for a while without
problems; the problems seem to be recent and easily repeatable.  Which
just means that it could be a new suspend-resume problem, of course.

> If suspend/resume does cause the problem, can you try again but this
> time please run 'xfs_freeze -f <mtpt>' on the filesystem before
> suspend, and then 'xfs_freeze -u <mtpt>' after the resume and see if
> the problem still occurs?

OK, but I tend to find that xfs_freeze ends up locking up large parts of
the system...  (For example, I tried to do the xfs_freeze + lvm snapshot
thing, but the lvm snapshot just blocked on the frozen filesystem until
I unfroze it).  But I'll try it out.  Hm, is there some script I can
stick it into?

    J
