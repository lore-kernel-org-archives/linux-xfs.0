Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Jul 2006 08:39:55 -0700 (PDT)
Received: from brmea-mail-3.sun.com (brmea-mail-3.Sun.COM [192.18.98.34])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6QFdXDW032712
	for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 08:39:36 -0700
Received: from centralmail3brm.Central.Sun.COM ([129.147.62.199])
	by brmea-mail-3.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k6QFd7e6023372
	for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 09:39:07 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail3brm.Central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k6QFZrHD007807
	for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 09:35:53 -0600 (MDT)
Date: Wed, 26 Jul 2006 10:39:06 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: DMF & DMAPI
Message-ID: <20060726153906.GA14535@kickball-mn.Central.Sun.COM>
References: <bc5727090607252124p4f1126cbh1ba0f0b47642592d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc5727090607252124p4f1126cbh1ba0f0b47642592d@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Michael Li (Gmail)" <mikore.li@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 26, 2006 at 12:24:49PM +0800, Michael Li (Gmail) wrote:
> Hi, Dean,
> 
> Is there a way to dispatch the read event to different channel? So that we
> can get both the DM application I mentioned and DMF work together. Is it
> difficult to do? Seems not so easy...

Given the existing DMAPI specification and implementation, I don't see how to
to this.

You're using the wrong tool for the job.  DMAPI is not designed to be a
generalized event mechanism.


Dean
