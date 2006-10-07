Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 07 Oct 2006 12:42:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k97JgraG030179
	for <xfs@oss.sgi.com>; Sat, 7 Oct 2006 12:42:54 -0700
Received: from smtp114.sbc.mail.mud.yahoo.com (smtp114.sbc.mail.mud.yahoo.com [68.142.198.213])
	by cuda.sgi.com (Spam Firewall) with SMTP id DB511480DA1
	for <xfs@oss.sgi.com>; Sat,  7 Oct 2006 12:42:12 -0700 (PDT)
Date: Sat, 7 Oct 2006 12:42:08 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: is quotacheck fast with xfs?
Message-ID: <20061007194208.GC28578@tuatara.stupidest.org>
References: <20061005204240.GA7922@apartia.fr> <1160086501.32536.57.camel@edge> <20061006075226.GB2414@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061006075226.GB2414@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, Oct 06, 2006 at 09:52:26AM +0200, Louis-David Mitterrand wrote:

> What you are saying is that userspace quotacheck is not needed with
> xfs (or only once)?

there is no userspace quata check, it's done in the kernel

userspace tells the kernel it needs to mount with quotas, if there
were none before it will rebuild the quata database
