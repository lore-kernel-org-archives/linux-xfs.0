Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 02:19:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5H9JGZP003159
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 02:19:17 -0700
Received: from web34501.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0E05823D365
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 02:20:14 -0700 (PDT)
Received: from web34501.mail.mud.yahoo.com (web34501.mail.mud.yahoo.com [66.163.178.167]) by cuda.sgi.com with SMTP id PMHBnWPdZr5xk2r6 for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 02:20:14 -0700 (PDT)
Date: Tue, 17 Jun 2008 02:20:14 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: Re: XFS mkfs/mount options
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <153266.85236.qm@web34501.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--- On Tue, 6/17/08, Dave Chinner <david@fromorbit.com> wrote:

> > For each of these kernel threads, only those on CPU #2
> are actually pulling notable load. Why is this?
> 
> Because your disk interrupts are delivered to that CPU
> only.

Thank you! Tuning my IRQ delivery gave a noticeable speed-up.

-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
