Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 09:52:16 -0700 (PDT)
Received: from nwkea-mail-5.sun.com (nwkea-mail-5.sun.com [192.18.42.27])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6PGpqDW014458
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 09:51:56 -0700
Received: from centralmail4brm.central.Sun.COM ([129.147.62.198])
	by nwkea-mail-5.sun.com (8.13.6+Sun/8.12.9) with ESMTP id k6PGpRKA008791
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 09:51:27 -0700 (PDT)
Received: from kickball-mn.Central.Sun.COM (kickball-mn.Central.Sun.COM [10.1.170.217])
	by centralmail4brm.central.Sun.COM (8.13.6+Sun/8.13.6/ENSMAIL,v2.2) with ESMTP id k6PGpQ3T015542
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 10:51:26 -0600 (MDT)
Received: from kickball-mn.Central.Sun.COM (localhost [127.0.0.1])
	by kickball-mn.Central.Sun.COM (8.13.4+Sun/8.13.3) with ESMTP id k6PGpQ30009401
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 11:51:26 -0500 (CDT)
Received: (from roehrich@localhost)
	by kickball-mn.Central.Sun.COM (8.13.4+Sun/8.13.3/Submit) id k6PGpQ1N009400
	for xfs@oss.sgi.com; Tue, 25 Jul 2006 11:51:26 -0500 (CDT)
Date: Tue, 25 Jul 2006 11:51:26 -0500
From: Dean Roehrich <dean.roehrich@sun.com>
Subject: Re: DMF & DMAPI
Message-ID: <20060725165126.GA9392@kickball-mn.Central.Sun.COM>
References: <44C64704.8000301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44C64704.8000301@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Jul 26, 2006 at 12:29:56AM +0800, Michael Li (gmail) wrote:
> Hi, Dean and all,
> 
> How does DMF using DMAPI? If I lauch a DM application to 
> receive/response some data event message(read/write/truncate) on the 
> same MDS on which a DMF server is running, is it possible to bother 
> DMF's job? If it will happen, is there any tips to help designing such a 
> DM application?

The DMAPI specification does not cover the case of having two independent
DMAPI apps that want to see the same events from the same files on the same
filesystem.  Does that scenario even make sense when you consider the problem
that DMAPI was intended to solve?

Dean
