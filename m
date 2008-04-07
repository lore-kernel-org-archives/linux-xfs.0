Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 05:50:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37CoYiW002862
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 05:50:35 -0700
Date: Mon, 7 Apr 2008 08:51:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Per iclog callback chain lock
Message-ID: <20080407125111.GB27350@infradead.org>
References: <20080401231348.GT103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401231348.GT103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Looks good.  You might want to kill ic_callback_tail while you're at it
as it's a write-only struct member.
