Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Jul 2006 09:05:26 -0700 (PDT)
Received: from nwkea-mail-5.sun.com (nwkea-mail-5.sun.com [192.18.42.27])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6EG5BDW009339
	for <xfs@oss.sgi.com>; Fri, 14 Jul 2006 09:05:11 -0700
Received: from centralmail3brm.Central.Sun.COM ([129.147.62.199])
	by nwkea-mail-5.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k6EG4oAV009000
	for <xfs@oss.sgi.com>; Fri, 14 Jul 2006 09:04:50 -0700 (PDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail3brm.Central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k6EG23n6022722
	for <xfs@oss.sgi.com>; Fri, 14 Jul 2006 10:02:03 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (localhost [127.0.0.1])
	by kickball-mn.Central.Sun.COM (8.13.4+Sun/8.13.3) with ESMTP id k6EG4otA007234
	for <xfs@oss.sgi.com>; Fri, 14 Jul 2006 11:04:50 -0500 (CDT)
Received: (from roehrich@localhost)
	by kickball-mn.Central.Sun.COM (8.13.4+Sun/8.13.3/Submit) id k6EG4oKZ007233
	for xfs@oss.sgi.com; Fri, 14 Jul 2006 11:04:50 -0500 (CDT)
Date: Fri, 14 Jul 2006 11:04:49 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: Re: Re: Delivered state of DMAPI Event
Message-ID: <20060714160449.GA7207@kickball-mn.Central.Sun.COM>
References: <bc5727090607132007w7e884c3cr3339eaf745ea5207@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc5727090607132007w7e884c3cr3339eaf745ea5207@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, Jul 14, 2006 at 11:07:40AM +0800, Michael Li (Gmail) wrote:

> Or: No matther the event is outstanding or not, if it is read event and
> DMAPI enabled, it will cause a read process hang although the event will not
> be in delivered state(outstanding state)?

The state (new or delivered) doesn't matter.  The file had a dmapi event set
for that action so the filesystem deferred the thread to dmapi.  That thread
is now in the DMAPI module and, ultimately, the only mechanism to release it
from DMAPI and allow it to return to the filesystem is a call to
dm_respond_event.

You don't have a usable filesystem if there's no DM app responding to events.
You need to think in terms of making that app robust and keeping it running.
The people writing that DM app also need to be aware that through DMAPI their
app becomes a part of the filesystem's I/O path and they need to think
appropriately, given that context.

Dean
