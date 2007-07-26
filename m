Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 10:53:16 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6QHr5bm022847
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 10:53:09 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l6QHqa1J031799
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 10:52:41 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l6QHr1YT025892
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 10:53:01 -0700
Message-ID: <46A8DF7E.4090006@agami.com>
Date: Thu, 26 Jul 2007 10:53:02 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com>
In-Reply-To: <46A7226D.8080906@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Mark Goodwin wrote:

>
> David Chinner wrote:
> >
> > The next question is the hard one. What do we do when we detect
> > a log record CRC error? Right now it just warns and sets a flag
> > in the log. I think it should probably prevent log replay from
> > replaying past this point (i.e. trim the head back to the last
> > good log record) but I'm not sure what the best thing to do here.
> >
> > Comments?
>
> 1. perhaps use a new flag XLOG_CRC_MISMATCH instead of 
> XLOG_CHKSUM_MISMATCH
> 2. is there (or could there be if we added it), correction for n-bit 
> errors?
>
> -- Mark
>
I don't see the original message in the archives.  Is CRC checking being
added to xfs log data?  If so, what data has been collected to show that
this needs to be added?

thanks,

    Michael
