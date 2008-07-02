Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 18:58:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m621wYZj030941
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 18:58:37 -0700
Message-ID: <486AE0F8.5080506@sgi.com>
Date: Wed, 02 Jul 2008 11:59:20 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix use after free when closing log/rt devices
References: <48647746.5010007@sgi.com> <20080627063219.GA25015@infradead.org> <48648B2B.3080709@sgi.com> <20080627090822.GA17374@infradead.org>
In-Reply-To: <20080627090822.GA17374@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, Jun 27, 2008 at 04:39:39PM +1000, Mark Goodwin wrote:
>> do we have any QA tests that test external log?
> 
> Most QA tests will use the external log if you set it up that way.  But
> ithout slab poisoning this won't be noticed either.

I think you need:
  USE_EXTERNAL=yes
  SCRATCH_LOGDEV=somelogdevice
  TEST_LOGDEV=somelogdevice
to get the scratch and test mounts using an external log.

There are no explicit external log tests (logdev=) that I can see.

--Tim

  
