Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Nov 2007 04:06:11 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAMC64Hh029699
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2007 04:06:07 -0800
Date: Thu, 22 Nov 2007 13:06:11 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122120611.GA3573@one.firstfloor.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <1195702123.8369.78.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195702123.8369.78.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stewart Smith <stewart@mysql.com>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>, xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

> FWIW from a "real time" database POV this seems to make sense to me...
> in fact, we probably rely on filesystem metadata way too much
> (historically it's just "worked".... although we do seem to get issues
> on ext3).

For that case you really would need priority inheritance: any metadata
IO on behalf or blocking a process needs to use the process' block IO 
priority.

David's change just fixes a limited set of cases, but breaks others.

-Andi
